Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 084322111B
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 01:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbfEPXuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 19:50:12 -0400
Received: from mga03.intel.com ([134.134.136.65]:62001 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbfEPXuM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 19:50:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 May 2019 16:50:11 -0700
X-ExtLoop1: 1
Received: from samudral-mobl1.amr.corp.intel.com (HELO [134.134.177.51]) ([134.134.177.51])
  by orsmga001.jf.intel.com with ESMTP; 16 May 2019 16:50:11 -0700
Subject: Re: [RFC bpf-next 0/7] busy poll support for AF_XDP sockets
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf@vger.kernel.org, Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jonathan Lemon <bsd@fb.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
References: <1556786363-28743-1-git-send-email-magnus.karlsson@intel.com>
 <20190506163135.blyqrxitmk5yrw7c@ast-mbp>
 <CAJ8uoz2MFtoXwuhAp5A0teMmwU2v623pHf2k0WSFi0kovJYjtw@mail.gmail.com>
 <20190507182435.6f2toprk7jus6jid@ast-mbp>
 <CAJ8uoz24HWGfGBNhz4c-kZjYELJQ+G3FcELVEo205xd1CirpqQ@mail.gmail.com>
 <CAJ8uoz1i72MOk711wLX18zmgo9JS+ztzSYAx0YS0VKxkbvod-w@mail.gmail.com>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Message-ID: <6ce758d1-e646-c7c2-bc02-6911c9b7d6ce@intel.com>
Date:   Thu, 16 May 2019 16:50:11 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAJ8uoz1i72MOk711wLX18zmgo9JS+ztzSYAx0YS0VKxkbvod-w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/16/2019 5:37 AM, Magnus Karlsson wrote:
> 
> After a number of surprises and issues in the driver here are now the
> first set of results. 64 byte packets at 40Gbit/s line rate. All
> results in Mpps. Note that I just used my local system and kernel build
> for these numbers so they are not performance tuned. Jesper would
> likely get better results on his setup :-). Explanation follows after
> the table.
> 
>                                        Applications
> method  cores  irqs        txpush        rxdrop      l2fwd
> ---------------------------------------------------------------
> r-t-c     2     y           35.9          11.2        8.6
> poll      2     y           34.2           9.4        8.3
> r-t-c     1     y           18.1           N/A        6.2
> poll      1     y           14.6           8.4        5.9
> busypoll  2     y           31.9          10.5        7.9
> busypoll  1     y           21.5           8.7        6.2
> busypoll  1     n           22.0          10.3        7.3
> 
> r-t-c = Run-to-completion, the mode where we in Rx uses no syscalls
>          and only spin on the pointers in the ring.
> poll = Use the regular syscall poll()
> busypoll = Use the regular syscall poll() in busy-poll mode. The RFC I
>             sent out.
> 
> cores == 2 means that softirq/ksoftirqd is one a different core from
>             the application. 2 cores are consumed in total.
> cores == 1 means that both softirq/ksoftirqd and the application runs
>             on the same core. Only 1 core is used in total.
> 
> irqs == 'y' is the normal case. irqs == 'n' means that I have created a
>          new napi context with the AF_XDP queues inside that does not
>          have any interrupts associated with it. No other traffic goes
>          to this napi context.
> 
> N/A = This combination does not make sense since the application will
>        not yield due to run-to-completion without any syscalls
>        whatsoever. It works, but it crawls in the 30 Kpps
>        range. Creating huge rings would help, but did not do that.
> 
> The applications are the ones from the xdpsock sample application in
> samples/bpf/.
> 
> Some things I had to do to get these results:
> 
> * The current buffer allocation scheme in i40e where we continuously
>    try to access the fill queue until we find some entries, is not
>    effective if we are on a single core. Instead, we try once and call
>    a function that sets a flag. This flag is then checked in the xsk
>    poll code, and if it is set we schedule napi so that it can try to
>    allocate some buffers from the fill ring again. Note that this flag
>    has to propagate all the way to user space so that the application
>    knows that it has to call poll(). I currently set a flag in the Rx
>    ring to indicate that the application should call poll() to resume
>    the driver. This is similar to what the io_uring in the storage
>    subsystem does. It is not enough to return POLLERR from poll() as
>    that will only work for the case when we are using poll(). But I do
>    that as well.
> 
> * Implemented Sridhar's suggestion on adding busy_loop_end callbacks
>    that terminate the busy poll loop if the Rx queue is empty or the Tx
>    queue is full.
> 
> * There is a race in the setup code in i40e when it is used with
>    busy-poll. The fact that busy-poll calls the napi_busy_loop code
>    before interrupts have been registered and enabled seems to trigger
>    some bug where nothing gets transmitted. This only happens for
>    busy-poll. Poll and run-to-completion only enters the napi loop of
>    i40e by interrupts and only then after interrupts have been enabled,
>    which is the last thing that is done after setup. I have just worked
>    around it by introducing a sleep(1) in the application for these
>    experiments. Ugly, but should not impact the numbers, I believe.
> 
> * The 1 core case is sensitive to the amount of work done reported
>    from the driver. This was not correct in the XDP code of i40e and
>    let to bad performance. Now it reports the correct values for
>    Rx. Note that i40e does not honor the napi budget on Tx and sets
>    that to 256, and these are not reported back to the napi
>    library.
> 
> Some observations:
> 
> * Cannot really explain the drop in performance for txpush when going
>    from 2 cores to 1. As stated before, the reporting of Tx work is not
>    really propagated to the napi infrastructure. Tried reporting this
>    in a correct manner (completely ignoring Rx for this experiment) but
>    the results were the same. Will dig deeper into this to screen out
>    any stupid mistakes.
> 
> * With the fixes above, all my driver processing is in softirq for 1
>    core. It never goes over to ksoftirqd. Previously when work was
>    reported incorrectly, this was the case. I would have liked
>    ksoftirqd to take over as that would have been more like a separate
>    thread. How to accomplish this? There might still be some reporting
>    problem in the driver that hinders this, but actually think it is
>    more correct now.
> 
> * Looking at the current results for a single core, busy poll provides
>    a 40% boost for Tx but only 5% for Rx. But if I instead create a
>    napi context without any interrupt associated with it and drive that
>    from busy-poll, I get a 15% - 20% performance improvement for Rx. Tx
>    increases only marginally from the 40% improvement as there are few
>    interrupts on Tx due to the completion interrupt bit being set quite
>    infrequently. One question I have is: what am I breaking by creating
>    a napi context not used by anyone else, only AF_XDP, that does not
>    have an interrupt associated with it?
> 
> Todo:
> 
> * Explain the drop in Tx push when going from 2 cores to 1.
> 
> * Really run a separate thread for kernel processing instead of softirq.
> 
> * What other experiments would you like to see?

Thanks for sharing the results.
For busypoll tests, i guess you may have increased the busypoll budget 
to 64.
What is the busypoll timeout you are using?
Can you try a test that skips calling bpf program for queues that are 
associated with af-xdp socket? I remember seeing a significant bump in
rxdrop performance with this change.
The other overhead i saw was with the dma_sync_single calls in the driver.

Thanks
Sridhar
