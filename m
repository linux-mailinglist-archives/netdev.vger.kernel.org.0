Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCE4281C59
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 21:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725796AbgJBTxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 15:53:32 -0400
Received: from www62.your-server.de ([213.133.104.62]:47456 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgJBTxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 15:53:32 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kOR7Q-0005HG-Io; Fri, 02 Oct 2020 21:53:28 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kOR7Q-0007i3-A8; Fri, 02 Oct 2020 21:53:28 +0200
Subject: Re: [PATCH v4 bpf-next 00/13] mvneta: introduce XDP multi-buffer
 support
To:     John Fastabend <john.fastabend@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        shayagr@amazon.com, sameehj@amazon.com, dsahern@kernel.org,
        brouer@redhat.com, lorenzo.bianconi@redhat.com, echaudro@redhat.com
References: <cover.1601648734.git.lorenzo@kernel.org>
 <5f77467dbc1_38b0208ef@john-XPS-13-9370.notmuch>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5c22ee38-e2c3-0724-5033-603d19c4169f@iogearbox.net>
Date:   Fri, 2 Oct 2020 21:53:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <5f77467dbc1_38b0208ef@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25945/Fri Oct  2 15:54:22 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/2/20 5:25 PM, John Fastabend wrote:
> Lorenzo Bianconi wrote:
>> This series introduce XDP multi-buffer support. The mvneta driver is
>> the first to support these new "non-linear" xdp_{buff,frame}. Reviewers
>> please focus on how these new types of xdp_{buff,frame} packets
>> traverse the different layers and the layout design. It is on purpose
>> that BPF-helpers are kept simple, as we don't want to expose the
>> internal layout to allow later changes.
>>
>> For now, to keep the design simple and to maintain performance, the XDP
>> BPF-prog (still) only have access to the first-buffer. It is left for
>> later (another patchset) to add payload access across multiple buffers.
>> This patchset should still allow for these future extensions. The goal
>> is to lift the XDP MTU restriction that comes with XDP, but maintain
>> same performance as before.
>>
>> The main idea for the new multi-buffer layout is to reuse the same
>> layout used for non-linear SKB. This rely on the "skb_shared_info"
>> struct at the end of the first buffer to link together subsequent
>> buffers. Keeping the layout compatible with SKBs is also done to ease
>> and speedup creating an SKB from an xdp_{buff,frame}. Converting
>> xdp_frame to SKB and deliver it to the network stack is shown in cpumap
>> code (patch 13/13).
> 
> Using the end of the buffer for the skb_shared_info struct is going to
> become driver API so unwinding it if it proves to be a performance issue
> is going to be ugly. So same question as before, for the use case where
> we receive packet and do XDP_TX with it how do we avoid cache miss
> overhead? This is not just a hypothetical use case, the Facebook
> load balancer is doing this as well as Cilium and allowing this with
> multi-buffer packets >1500B would be useful.
[...]

Fully agree. My other question would be if someone else right now is in the process
of implementing this scheme for a 40G+ NIC? My concern is the numbers below are rather
on the lower end of the spectrum, so I would like to see a comparison of XDP as-is
today vs XDP multi-buff on a higher end NIC so that we have a picture how well the
current designed scheme works there and into which performance issue we'll run e.g.
under typical XDP L4 load balancer scenario with XDP_TX. I think this would be crucial
before the driver API becomes 'sort of' set in stone where others start to adapting
it and changing design becomes painful. Do ena folks have an implementation ready as
well? And what about virtio_net, for example, anyone committing there too? Typically
for such features to land is to require at least 2 drivers implementing it.

>> Typical use cases for this series are:
>> - Jumbo-frames
>> - Packet header split (please see Google���s use-case @ NetDevConf 0x14, [0])
>> - TSO
>>
>> More info about the main idea behind this approach can be found here [1][2].
>>
>> We carried out some throughput tests in a standard linear frame scenario in order
>> to verify we did not introduced any performance regression adding xdp multi-buff
>> support to mvneta:
>>
>> offered load is ~ 1000Kpps, packet size is 64B, mvneta descriptor size is one PAGE
>>
>> commit: 879456bedbe5 ("net: mvneta: avoid possible cache misses in mvneta_rx_swbm")
>> - xdp-pass:      ~162Kpps
>> - xdp-drop:      ~701Kpps
>> - xdp-tx:        ~185Kpps
>> - xdp-redirect:  ~202Kpps
>>
>> mvneta xdp multi-buff:
>> - xdp-pass:      ~163Kpps
>> - xdp-drop:      ~739Kpps
>> - xdp-tx:        ~182Kpps
>> - xdp-redirect:  ~202Kpps
[...]
