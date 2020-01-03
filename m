Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB2812F492
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 07:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgACGbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 01:31:22 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:55664 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgACGbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 01:31:22 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1inGUM-007Xa9-Ba; Fri, 03 Jan 2020 07:31:14 +0100
Message-ID: <4abacaad51ce3c7d0b867472605a366dc9ae7994.camel@sipsolutions.net>
Subject: Re: PROBLEM: Wireless networking goes down on Acer C720P Chromebook
 (bisected)
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Stephen Oberholtzer <stevie@qrpff.net>
Cc:     toke@redhat.com, "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 03 Jan 2020 07:31:13 +0100
In-Reply-To: <CAD_xR9eh=CAYeQZ3Vp9Yj9h3ifMu2exy0ihaXyE+736tJrPVLA@mail.gmail.com>
References: <CAD_xR9eDL+9jzjYxPXJjS7U58ypCPWHYzrk0C3_vt-w26FZeAQ@mail.gmail.com>
         <1762437703fd150bb535ee488c78c830f107a531.camel@sipsolutions.net>
         <CAD_xR9eh=CAYeQZ3Vp9Yj9h3ifMu2exy0ihaXyE+736tJrPVLA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,


> To answer your immediate question, no, I don't get any dmesg output at
> all. Nothing about underruns.

OK.

> However, while pursuing other avenues -- specifically, enabling
> mac80211 debugfs and log messages -- I realized that my 'master' was
> out-of-date from linux-stable and did a git pull.  Imagine my surprise
> when the resulting kernel did not exhibit the problem!
> 
> Apparently, I had been a bit too pessimistic; since the problem
> existed in 5.5-rc1 release, I'd assumed that the problem wouldn't get
> rectified before 5.5.
> 
> However, I decided to bisect the fix, and ended up with: 911bde0f
> ("mac80211: Turn AQL into an NL80211_EXT_FEATURE"), which appears to
> have "solved" the problem by just disabling the feature (this is
> ath9k, by the way.)

Oh. I didn't pay attention and thought you actually had ath10k, not
ath9k!

> This AQL stuff sounds pretty nifty, and I'd love to try my hand at
> making it work for ath9k (also, since I put so much effort into an
> automated build-and-test framework, it'd be a shame to just abandon
> it.)

:-)

> However, the ath9k code is rather lacking for comments, so I
> don't even know where I should start, except for (I suspect) a call to
> `wiphy_ext_feature_set(whatever, NL80211_EXT_FEATURE_AQL);` from
> inside ath9k_set_hw_capab()?

Honestly, I don't know, you'd probably have to wait for Toke to be back
from vacations to get a pointer on what could be done here.

> In the meantime, I went back to e548f749b096 -- the commit prior to
> the one making AQL support opt-in -- and cranked up the debugging.
> 
> I'm not sure how to interpret any of this, but  here's what I got:
> 
> dmesg output:
> 
> Last relevant mention is "moving STA <my AP's MAC> to state 4" which
> happened during startup, before everything shut down.

That just means the STA was set to authorized (state 4) due to the 4-
way-handshake completing, nothing more.

> /sys/kernel/debug/ieee80211/phy0
> 
> airtime_flags = 7
> 
> stations/<my AP's MAC>/airtime =
> 
> RX: 6583578 us
> TX: 32719 us
> Weight: 256
> Deficit: VO: -1128 us VI: 11 us BE: -5098636 us BK: 256 us
> Q depth: VO: 3868 us VI: 3636 us BE: 12284 us BK: 0 us
> Q limit[low/high]: VO: 5000/12000 VI: 5000/12000 BE: 5000/12000 BK: 5000/12000
> 
> (I have no idea how to interpret this, but that '32719 us' seems odd,
> I thought the airtime usage was in 4us units?)

Me neither, off the top of my head, let's wait for Toke.

> Doing an 'echo 3 | tee airtime_flags' to clear the (old) AQL-enabled
> bit seemed to *immediately* restore network connectivity.

Hmm. That probably means it was blocked on AQL and not some kind of soft
"didn't know I had to transmit" type scenario that the comment in the
commit log you quoted would have implied (if it was actually wrong).

> I ran a ping, and saw this:
> 
> - pings coming back in <5ms
> - re-enable AQL (echo 7 | tee airtime_flags)
> - pings stop coming back immediately
> - some seconds later, disable AQL again (echo 3 | tee airtime_flags)
> - immediate *flood* of ping replies registered, with times 16000ms,
> 15000ms, 14000ms, .. down to 1000ms, 15ms, then stabilizing sub-5ms
> - According to the icmp_seq values, all 28 requests were replied to,
> and their replies were delivered in-order
> 
> This certainly looks like a missing TX queue restart to me?

I don't think it does. If it was just a missing TX queue restart then
changing the AQL bit shouldn't have had any effect, since changing the
flags via debugfs doesn't trigger a TX queue restart.

Rather, it seems to me that this implies some accounting went wrong, and
doing this clears/recovers that?

But I guess Toke will have a much better idea from the debug data above.

johannes

