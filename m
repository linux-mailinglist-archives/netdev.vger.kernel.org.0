Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D23F111D8C2
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 22:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731169AbfLLVqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 16:46:34 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:53108 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730876AbfLLVqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 16:46:34 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ifWI1-008AXt-IM; Thu, 12 Dec 2019 22:46:29 +0100
Message-ID: <49cd2d6c7bf597c224edb8806cd56c126b5901b4.camel@sipsolutions.net>
Subject: Re: debugging TCP stalls on high-speed wifi
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ben Greear <greearb@candelatech.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>
Cc:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>
Date:   Thu, 12 Dec 2019 22:46:27 +0100
In-Reply-To: <04dc171a-7385-6544-6cc6-141aae9f2782@candelatech.com>
References: <14cedbb9300f887fecc399ebcdb70c153955f876.camel@sipsolutions.net>
         <CADVnQym_CNktZ917q0-9dVY9dhtiJVRRotGTrPNdZUpkjd3vyw@mail.gmail.com>
         <f4670ce0f4399fe82e7168fb9c491d8eb718e8d8.camel@sipsolutions.net>
         <99748db5-7898-534b-d407-ed819f07f939@gmail.com>
         <ff6b35ad589d7cf0710cb9fca4c799538da2e653.camel@sipsolutions.net>
         <04dc171a-7385-6544-6cc6-141aae9f2782@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-12-12 at 13:29 -0800, Ben Greear wrote:
> 
> > (*) Hmm. Now I have another idea. Maybe we have some kind of problem
> > with the medium access configuration, and we transmit all this data
> > without the AP having a chance to send back all the ACKs? Too bad I
> > can't put an air sniffer into the setup - it's a conductive setup.
> 
> splitter/combiner?

I guess. I haven't looked at it, it's halfway around the world or
something :)

> If it is just delayed acks coming back, which would slow down a stream, then
> multiple streams would tend to work around that problem?

Only a bit, because it allows somewhat more outstanding data. But each
stream estimates the throughput lower in its congestion control
algorithm, so it would have a smaller window size?

What I was thinking is that if we have some kind of skew in the system
and always/frequently/sometimes make our transmissions have priority
over the AP transmissions, then we'd not get ACKs back, and that might
cause what I see - the queue drains entirely and *then* we get an ACK
back...

That's not a _bad_ theory and I'll have to find a good way to test it,
but I'm not entirely convinced that's the problem.

Oh, actually, I guess I know it's *not* the problem because otherwise
the ss output would show we're blocked on congestion window far more
than it looks like now? I think?


> I would actually expect similar speedup with multiple streams if some TCP socket
> was blocked on waiting for ACKs too.
> 
> Even if you can't sniff the air, you could sniff the wire or just look at packet
> in/out counts.  If you have a huge number of ACKs, that would show up in raw pkt
> counters.

I know I have a huge number of ACKs, but I also know that's not the
(only) problem. My question/observation was related to the timing of
them.

> I'm not sure it matters these days, but this patch greatly helped TCP throughput on
> ath10k for a while, and we are still using it.  Maybe your sk_pacing change already
> tweaked the same logic:
> 
> https://github.com/greearb/linux-ct-5.4/commit/65651d4269eb2b0d4b4952483c56316a7fbe2f48

Yes, you should be able to drop that patch - look at it, it just
multiples the thing there that you have with "sk->sk_pacing_shift",
instead we currently by default set sk->sk_pacing_shift to 7 instead of
10 or something, so that'd be equivalent to setting your sysctl to 8.

> 		TCP_TSQ=200

Setting it to 200 is way excessive. In particular since you already get
the *8 from the default mac80211 behaviour, so now you effectively have
*1600, which means instead of 1ms you can have 1.6s worth of TCP data on
the queues ... way too much :)

johannes

