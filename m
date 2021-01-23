Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD413011D7
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 02:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725968AbhAWBFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 20:05:10 -0500
Received: from www62.your-server.de ([213.133.104.62]:50138 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbhAWBEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 20:04:40 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1l37Kh-000Gey-4d; Sat, 23 Jan 2021 02:03:19 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1l37Kg-000LEl-Pg; Sat, 23 Jan 2021 02:03:18 +0100
Subject: Re: [PATCH v6 bpf-next 0/8] mvneta: introduce XDP multi-buffer
 support
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, sameehj@amazon.com
References: <cover.1611086134.git.lorenzo@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <572556bb-845f-1b4a-8f0a-fb6a4fc286e3@iogearbox.net>
Date:   Sat, 23 Jan 2021 02:03:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <cover.1611086134.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26057/Fri Jan 22 13:30:31 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenzo,

On 1/19/21 9:20 PM, Lorenzo Bianconi wrote:
> This series introduce XDP multi-buffer support. The mvneta driver is
> the first to support these new "non-linear" xdp_{buff,frame}. Reviewers
> please focus on how these new types of xdp_{buff,frame} packets
> traverse the different layers and the layout design. It is on purpose
> that BPF-helpers are kept simple, as we don't want to expose the
> internal layout to allow later changes.
> 
> For now, to keep the design simple and to maintain performance, the XDP
> BPF-prog (still) only have access to the first-buffer. It is left for
> later (another patchset) to add payload access across multiple buffers.

I think xmas break has mostly wiped my memory from 2020 ;) so it would be
good to describe the sketched out design for how this will look like inside
the cover letter in terms of planned uapi exposure. (Additionally discussing
api design proposal could also be sth for BPF office hour to move things
quicker + posting a summary to the list for transparency of course .. just
a thought.)

Glancing over the series, while you've addressed the bpf_xdp_adjust_tail()
helper API, this series will be breaking one assumption of programs at least
for the mvneta driver from one kernel to another if you then use the multi
buff mode, and that is basically bpf_xdp_event_output() API: the assumption
is that you can do full packet capture by passing in the xdp buff len that
is data_end - data ptr. We use it this way for sampling & others might as well
(e.g. xdpcap). But bpf_xdp_copy() would only copy the first buffer today which
would break the full pkt visibility assumption. Just walking the frags if
xdp->mb bit is set would still need some sort of struct xdp_md exposure so
the prog can figure out the actual full size..

> This patchset should still allow for these future extensions. The goal
> is to lift the XDP MTU restriction that comes with XDP, but maintain
> same performance as before.
> 
> The main idea for the new multi-buffer layout is to reuse the same
> layout used for non-linear SKB. We introduced a "xdp_shared_info" data
> structure at the end of the first buffer to link together subsequent buffers.
> xdp_shared_info will alias skb_shared_info allowing to keep most of the frags
> in the same cache-line (while with skb_shared_info only the first fragment will
> be placed in the first "shared_info" cache-line). Moreover we introduced some
> xdp_shared_info helpers aligned to skb_frag* ones.
> Converting xdp_frame to SKB and deliver it to the network stack is shown in
> cpumap code (patch 7/8). Building the SKB, the xdp_shared_info structure
> will be converted in a skb_shared_info one.
> 
> A multi-buffer bit (mb) has been introduced in xdp_{buff,frame} structure
> to notify the bpf/network layer if this is a xdp multi-buffer frame (mb = 1)
> or not (mb = 0).
> The mb bit will be set by a xdp multi-buffer capable driver only for
> non-linear frames maintaining the capability to receive linear frames
> without any extra cost since the xdp_shared_info structure at the end
> of the first buffer will be initialized only if mb is set.
> 
> Typical use cases for this series are:
> - Jumbo-frames
> - Packet header split (please see Google’s use-case @ NetDevConf 0x14, [0])
> - TSO
> 
> bpf_xdp_adjust_tail helper has been modified to take info account xdp
> multi-buff frames.

Also in terms of logistics (I think mentioned earlier already), for the series to
be merged - as with other networking features spanning core + driver (example
af_xdp) - we also need a second driver (ideally mlx5, i40e or ice) implementing
this and ideally be submitted together in the same series for review. For that
it probably also makes sense to more cleanly split out the core pieces from the
driver ones. Either way, how is progress on that side coming along?

Thanks,
Daniel
