Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEA2C11AA39
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 12:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbfLKLv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 06:51:57 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:51236 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727365AbfLKLv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 06:51:56 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1if0X0-003uNE-Jk; Wed, 11 Dec 2019 12:51:50 +0100
Message-ID: <bfab4987668990ea8d86a98f3e87c3fa31403745.camel@sipsolutions.net>
Subject: Re: iwlwifi warnings in 5.5-rc1
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Date:   Wed, 11 Dec 2019 12:51:49 +0100
In-Reply-To: <875zingnzt.fsf@toke.dk>
References: <ceb74ea2-6a1b-4cef-8749-db21a2ee4311@kernel.dk>
         <9727368004ceef03f72d259b0779c2cf401432e1.camel@sipsolutions.net>
         <878snjgs5l.fsf@toke.dk>
         <3420d73e667b01ec64bf0cc9da6232b41e862860.camel@sipsolutions.net>
         <875zingnzt.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Toke,

> > OK, I talked with Emmanuel and I think it's the GSO path - it'll end up
> > with skb_clone() and then report both of them back.
> 
> Right, figured it was something like that; just couldn't find the place
> in the driver where it did that from my cursory browsing.

Yeah, deeply hidden in the guts :)

> > Regardless, I think I'll probably have to disable AQL and make it more
> > opt-in for the driver - I found a bunch of other issues ...
> 
> Issues like what? Making it opt-in was going to be my backup plan; I was
> kinda hoping we could work out any issues so it would be a "no harm"
> kind of thing that could be left as always-on. Maybe that was a bit too
> optimistic; but it's also a pain having to keep track of which drivers
> have which features/fixes...

Sorry to keep you in suspense, had to run when I sent that email and
didn't have time to elaborate.

1) Hardware building A-MPDU will probably make the airtime estimate
   quite a bit wrong. Maybe this doesn't matter? But I wasn't sure how
   this works now with ath10k where (most of?) the testing was.

2) GSO/TSO like what we have - it's not really clear how to handle it.
   The airtime estimate will shoot *way* up (64kB frame) once that frame
   enters, and then ... should it "trickle back down" as the generated 
   parts are transmitted? But then the driver needs to split up the
   airtime estimate? Or should it just go back down entirely? On the
   first frame? That might overshoot. On the last frame? Opposite
   problem ...

3) I'm not quite convinced that all drivers report the TX rate
   completely correctly in the status, some don't even use this path
   but the ieee80211_tx_status_ext() which doesn't update the rate.

4) Probably most importantly, this is completely broken with HE because
   there's currently no way to report HE rates in the TX status at all!
   I just worked around that in our driver for 'iw' reporting purposes
   by implementing the rate reporting in the sta_statistics callback,
   but that data won't be used by the airtime estimates.


Now, (1) probably doesn't matter, the estimates don't need to be that
accurate. (2) I'm not sure how to solve; (3) and (4) could both be
solved by having some mechanism of the rate scaling to tell us what the
current rate is whenever it updates, rather than relying on the
last_rate. Really we should do that much more, and even phase out
last_rate entirely, it's a stupid concept.


There's an additional wrinkle here - what about HE scheduled mode, where
the AP decided when and at what rate you're allowed to send? We don't
report that at all, not even as part of rate scaling, since rate scaling
only affects *our* decision, not when we send as a response to a trigger
frame. This is _still_ relevant for AQL, but there we can only see what
the AP used last (**), but we don't track that now nor do we track the
proportion of packets that we sent triggered vs. normal medium access...


(**) like it does with our rate scaling today (***), but in fact we can
do better since that's local information.

(***) There's an additional problem here - if you _just_ transmitted a
management frame, you'll have a last_rate of say 6Mbps severely over-
estimating the airtime for the next data frame ...



Overall, at least for devices capable of HE we currently _have_ to
disable this, and we need more infrastructure that we cannot build in
the short term to fix that.

I'm also not sure that the last_rate is reliable enough in general, both
because of the management frame issue and because of HW offloaded rate
scaling issues that I'm not convinced reports this correctly for all
drivers.

johannes

