Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC15260B69
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 08:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbgIHG6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 02:58:37 -0400
Received: from mga18.intel.com ([134.134.136.126]:50924 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728995AbgIHG6f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 02:58:35 -0400
IronPort-SDR: xEZZKvi9hBbldzomTvzax1JKi0SryvMnN1xlLY7eeuLcmZt2UF6QuPDH3OGMoNF8lSCcVb0Q6S
 Fr6TXqLNSy7A==
X-IronPort-AV: E=McAfee;i="6000,8403,9737"; a="145794041"
X-IronPort-AV: E=Sophos;i="5.76,404,1592895600"; 
   d="scan'208";a="145794041"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2020 23:58:34 -0700
IronPort-SDR: ZCsyxjpZdlssSDVMWz1a+wSYlNMW9xTXtHkrzhvvxurk+Xaud2pzNZ4rembEvZls8pBMZ7FPP5
 1WdxQgCygCVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,404,1592895600"; 
   d="scan'208";a="284413920"
Received: from pgierasi-mobl.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.39.2])
  by fmsmga007.fm.intel.com with ESMTP; 07 Sep 2020 23:58:31 -0700
Subject: Re: [PATCH bpf-next 0/6] xsk: exit NAPI loop when AF_XDP Rx ring is
 full
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, davem@davemloft.net,
        john.fastabend@gmail.com, intel-wired-lan@lists.osuosl.org
References: <20200904135332.60259-1-bjorn.topel@gmail.com>
 <20200904162751.632c4443@carbon>
 <27e05518-99c6-15e2-b801-cbc0310630ef@intel.com>
 <20200904165837.16d8ecfd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <1d2e781e-b26d-4cf0-0178-25b8835dbe26@intel.com>
 <20200907114055.27c95483@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <8f698ac5-916f-9bb0-cce2-f00fba6ba407@intel.com>
Date:   Tue, 8 Sep 2020 08:58:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200907114055.27c95483@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-09-07 20:40, Jakub Kicinski wrote:
> On Mon, 7 Sep 2020 15:37:40 +0200 Björn Töpel wrote:
>>   > I've been pondering the exact problem you're solving with Maciej
>>   > recently. The efficiency of AF_XDP on one core with the NAPI processing.
>>   >
>>   > Your solution (even though it admittedly helps, and is quite simple)
>>   > still has the application potentially not able to process packets
>>   > until the queue fills up. This will be bad for latency.
>>   >
>>   > Why don't we move closer to application polling? Never re-arm the NAPI
>>   > after RX, let the application ask for packets, re-arm if 0 polled.
>>   > You'd get max batching, min latency.
>>   >
>>   > Who's the rambling one now? :-D
>>   >
>>
>> :-D No, these are all very good ideas! We've actually experimented
>> with it with the busy-poll series a while back -- NAPI busy-polling
>> does exactly "application polling".
>>
>> However, I wonder if the busy-polling would have better performance
>> than the scenario above (i.e. when the ksoftirqd never kicks in)?
>> Executing the NAPI poll *explicitly* in the syscall, or implicitly
>> from the softirq.
>>
>> Hmm, thinking out loud here. A simple(r) patch enabling busy poll;
>> Exporting the napi_id to the AF_XDP socket (xdp->rxq->napi_id to
>> sk->sk_napi_id), and do the sk_busy_poll_loop() in sendmsg.
>>
>> Or did you have something completely different in mind?
> 
> My understanding is that busy-polling is allowing application to pick
> up packets from the ring before the IRQ fires.
> 
> What we're more concerned about is the IRQ firing in the first place.
> 
>   application:   busy    | needs packets | idle
>   -----------------------+---------------+----------------------
>     standard   |         |   polls NAPI  | keep polling? sleep?
>     busy poll  | IRQ on  |    IRQ off    |  IRQ off      IRQ on
>   -------------+---------+---------------+----------------------
>                |         |   polls once  |
>      AF_XDP    | IRQ off |    IRQ off    |  IRQ on
> 
> 
> So busy polling is pretty orthogonal. It only applies to the
> "application needs packets" time. What we'd need is for the application
> to be able to suppress NAPI polls, promising the kernel that it will
> busy poll when appropriate.
>

Ah, nice write-up! Thanks! A strict busy-poll mechanism, not the
opportunistic (existing) NAPI busy-poll.

This would be a new kind of mechanism, and a very much welcome one in
AF_XDP-land. More below.

>> As for this patch set, I think it would make sense to pull it in since
>> it makes the single-core scenario *much* better, and it is pretty
>> simple. Then do the application polling as another, potentially,
>> improvement series.
> 
> Up to you, it's extra code in the driver so mostly your code to
> maintain.
> 
> I think that if we implement what I described above - everyone will
> use that on a single core setup, so this set would be dead code
> (assuming RQ is sized appropriately). But again, your call :)
> 

Now, I agree that the busy-poll you describe above would be the best
option, but from my perspective it's a much larger set that involves
experimenting. I will explore that, but I still think this series should
go in sooner to make the single core scenario usable *today*.

Ok, back to the busy-poll ideas. I'll call your idea "strict busy-poll",
i.e. the NAPI loop is *only* driven by userland, and interrupts stay
disabled. "Syscall driven poll-mode driver". :-)

On the driver side (again, only talking Intel here, since that's what I
know the details of), the NAPI context would only cover AF_XDP queues,
so that other queues are not starved.

Any ideas how strict busy-poll would look, API/implmentation-wise? An
option only for AF_XDP sockets? Would this make sense to regular
sockets? If so, maybe extend the existing NAPI busy-poll with a "strict"
mode?

I'll start playing around a bit, but again, I think this simple series
should go in just to make AF_XDP single core usable *today*.


Thanks!
Björn
