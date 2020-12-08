Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F17B2D2804
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 10:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729115AbgLHJni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 04:43:38 -0500
Received: from www62.your-server.de ([213.133.104.62]:36184 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728007AbgLHJnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 04:43:37 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kmZW9-0003EK-El; Tue, 08 Dec 2020 10:42:45 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kmZW9-0000AX-3P; Tue, 08 Dec 2020 10:42:45 +0100
Subject: Re: [PATCH v2 bpf 1/5] net: ethtool: add xdp properties flag set
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        alardam@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, andrii.nakryiko@gmail.com, kuba@kernel.org,
        ast@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        hawk@kernel.org, jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, maciejromanfijalkowski@gmail.com,
        intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
 <20201204102901.109709-2-marekx.majtyka@intel.com> <878sad933c.fsf@toke.dk>
 <20201204124618.GA23696@ranger.igk.intel.com>
 <048bd986-2e05-ee5b-2c03-cd8c473f6636@iogearbox.net>
 <20201207135433.41172202@carbon>
 <5fce960682c41_5a96208e4@john-XPS-13-9370.notmuch>
 <20201208100040.0d57742a@carbon>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1c327ddf-f361-8abe-9f8d-605f05ddcc7a@iogearbox.net>
Date:   Tue, 8 Dec 2020 10:42:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201208100040.0d57742a@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26011/Mon Dec  7 15:37:03 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/8/20 10:00 AM, Jesper Dangaard Brouer wrote:
> On Mon, 07 Dec 2020 12:52:22 -0800
> John Fastabend <john.fastabend@gmail.com> wrote:
> 
>>> Use-case(1): Cloud-provider want to give customers (running VMs) ability
>>> to load XDP program for DDoS protection (only), but don't want to allow
>>> customer to use XDP_TX (that can implement LB or cheat their VM
>>> isolation policy).
>>
>> Not following. What interface do they want to allow loading on? If its
>> the VM interface then I don't see how it matters. From outside the
>> VM there should be no way to discover if its done in VM or in tc or
>> some other stack.
>>
>> If its doing some onloading/offloading I would assume they need to
>> ensure the isolation, etc. is still maintained because you can't
>> let one VMs program work on other VMs packets safely.
>>
>> So what did I miss, above doesn't make sense to me.
> 
> The Cloud-provider want to load customer provided BPF-code on the
> physical Host-OS NIC (that support XDP).  The customer can get access
> to a web-interface where they can write or upload their BPF-prog.
> 
> As multiple customers can upload BPF-progs, the Cloud-provider have to
> write a BPF-prog dispatcher that runs these multiple program.  This
> could be done via BPF tail-calls, or via Toke's libxdp[1], or via
> devmap XDP-progs per egress port.
> 
> The Cloud-provider don't fully trust customers BPF-prog.   They already
> pre-filtered traffic to the given VM, so they can allow customers
> freedom to see traffic and do XDP_PASS and XDP_DROP.  They
> administratively (via ethtool) want to disable the XDP_REDIRECT and
> XDP_TX driver feature, as it can be used for violation their VM
> isolation policy between customers.
> 
> Is the use-case more clear now?

I think we're talking about two different things. The use case as I understood
it in (1) mentioned to be able to disable XDP_TX for NICs that are deployed in
the VM. This would be a no-go as-is since that would mean my basic assumption
for attaching XDP progs is gone in that today return codes pass/drop/tx is
pretty much available everywhere on native XDP supported NICs. And if you've
tried it on major cloud providers like AWS or Azure that offer SRIOV-based
networking that works okay and further restricting this would mean breakage of
existing programs.

What you mean here is "offload" from guest to host which is a different use
case than what likely John and I read from your description in (1). Such program
should then be loaded via BPF offload API. Meaning, if offload is used and the
host is then configured to disallow XDP_TX for such requests from guests, then
these get rejected through such facility, but if the /same/ program was loaded as
regular native XDP where it's still running in the guest, then it must succeed.
These are two entirely different things.

It's not clear to me whether some ethtool XDP properties flag is the right place
to describe this (plus this needs to differ between offloaded / non-offloaded progs)
or whether this should be an implementation detail for things like virtio_net e.g.
via virtio_has_feature(). Feels more like the latter to me which already has such
a facility in place.
