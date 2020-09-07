Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADBF25FB98
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 15:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729636AbgIGNmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 09:42:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:19032 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729602AbgIGNk6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 09:40:58 -0400
IronPort-SDR: n4o/aJ8XEyaz/Uv0s/LrYbfq2lLtMTG5d4t9A5/tkUZvcRMTCLgbXjQYQYGY8jjHtF/FUIQqtm
 aRU1nwFDJIvg==
X-IronPort-AV: E=McAfee;i="6000,8403,9736"; a="155500088"
X-IronPort-AV: E=Sophos;i="5.76,401,1592895600"; 
   d="scan'208";a="155500088"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2020 06:37:47 -0700
IronPort-SDR: MXbziBHXdLofMRVjhmFogHuU7akOLzGtpfMQCHdquu/U/fDRatsd7XICx8Fn931ptEmH5CxKBM
 MUZVua/bUfcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,401,1592895600"; 
   d="scan'208";a="333166580"
Received: from clroth-mobl2.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.57.7])
  by orsmga008.jf.intel.com with ESMTP; 07 Sep 2020 06:37:41 -0700
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
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <1d2e781e-b26d-4cf0-0178-25b8835dbe26@intel.com>
Date:   Mon, 7 Sep 2020 15:37:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200904165837.16d8ecfd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-09-05 01:58, Jakub Kicinski wrote:
 > On Fri, 4 Sep 2020 16:32:56 +0200 Björn Töpel wrote:
 >> On 2020-09-04 16:27, Jesper Dangaard Brouer wrote:
 >>> On Fri,  4 Sep 2020 15:53:25 +0200
 >>> Björn Töpel <bjorn.topel@gmail.com> wrote:
 >>>
 >>>> On my machine the "one core scenario Rx drop" performance went from
 >>>> ~65Kpps to 21Mpps. In other words, from "not usable" to
 >>>> "usable". YMMV.
 >>>
 >>> We have observed this kind of dropping off an edge before with softirq
 >>> (when userspace process runs on same RX-CPU), but I thought that Eric
 >>> Dumazet solved it in 4cd13c21b207 ("softirq: Let ksoftirqd do its 
job").
 >>>
 >>> I wonder what makes AF_XDP different or if the problem have come back?
 >>>
 >>
 >> I would say this is not the same issue. The problem is that the softirq
 >> is busy dropping packets since the AF_XDP Rx is full. So, the cycles
 >> *are* split 50/50, which is not what we want in this case. :-)
 >>
 >> This issue is more of a "Intel AF_XDP ZC drivers does stupid work", than
 >> fairness. If the Rx ring is full, then there is really no use to let the
 >> NAPI loop continue.
 >>
 >> Would you agree, or am I rambling? :-P
 >
 > I wonder if ksoftirqd never kicks in because we are able to discard
 > the entire ring before we run out of softirq "slice".
 >

This is exactly what's happening, so we're entering a "busy poll like"
behavior; syscall, return from syscall softirq/napi, userland.

 >
 > I've been pondering the exact problem you're solving with Maciej
 > recently. The efficiency of AF_XDP on one core with the NAPI processing.
 >
 > Your solution (even though it admittedly helps, and is quite simple)
 > still has the application potentially not able to process packets
 > until the queue fills up. This will be bad for latency.
 >
 > Why don't we move closer to application polling? Never re-arm the NAPI
 > after RX, let the application ask for packets, re-arm if 0 polled.
 > You'd get max batching, min latency.
 >
 > Who's the rambling one now? :-D
 >

:-D No, these are all very good ideas! We've actually experimented
with it with the busy-poll series a while back -- NAPI busy-polling
does exactly "application polling".

However, I wonder if the busy-polling would have better performance
than the scenario above (i.e. when the ksoftirqd never kicks in)?
Executing the NAPI poll *explicitly* in the syscall, or implicitly
from the softirq.

Hmm, thinking out loud here. A simple(r) patch enabling busy poll;
Exporting the napi_id to the AF_XDP socket (xdp->rxq->napi_id to
sk->sk_napi_id), and do the sk_busy_poll_loop() in sendmsg.

Or did you have something completely different in mind?

As for this patch set, I think it would make sense to pull it in since
it makes the single-core scenario *much* better, and it is pretty
simple. Then do the application polling as another, potentially,
improvement series.


Thoughts? Thanks a lot for the feedback!
Björn
