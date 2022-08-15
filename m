Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27DB65949EF
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 02:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233102AbiHOXHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 19:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352469AbiHOXF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 19:05:26 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3316140C99
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 12:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=ys0p+m8vEeM7+pZbwq4AhKTXJmES6U7pjAAivzVVg1k=;
        t=1660593520; x=1661803120; b=XgGGyv1dy0Zh5oQT2LRr0eCpTa71rEgOHXtSd/mtk9+mb6l
        czsU3SkdBN84L04hQpB08qNWhQvTuIGHI2vBL4vM1ZkCHQDlUB3tmnfX/HKWbrMiJtmNiUlFJfFMs
        S4pphl5/+xA/m3mGPzm9bImzTj4gqZ7IaRE2pCrE+sGmJVeGeLKmP425OnrZRrnX8yruVjRcALhdg
        J833n5yCJVBd3G7QEuOEd0Dk/KxI3f+3PYmnov1kTFsXyIHK5SX04Hx/kLuBkQI6wgkTDHlZ7ug/A
        7pALynH4xShHHUga120RK9M/kT9BHzqb4Q1rOGuxexwKZsFUPxSdkk1MezWVFpJg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oNgEE-008oaX-0G;
        Mon, 15 Aug 2022 21:58:26 +0200
Message-ID: <18fd9b89d45aedc1504d0cbd299ffb289ae96438.camel@sipsolutions.net>
Subject: Re: [PATCH v2] wifi: cfg80211: Fix UAF in ieee80211_scan_rx()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, Siddh Raman Pant <code@siddh.me>
Cc:     greg kh <gregkh@linuxfoundation.org>,
        "david s. miller" <davem@davemloft.net>,
        eric dumazet <edumazet@google.com>,
        paolo abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel-mentees 
        <linux-kernel-mentees@lists.linuxfoundation.org>
Date:   Mon, 15 Aug 2022 21:58:24 +0200
In-Reply-To: <20220815094722.3c275087@kernel.org>
References: <20220726123921.29664-1-code@siddh.me>
         <18291779771.584fa6ab156295.3990923778713440655@siddh.me>
         <YvZEfnjGIpH6XjsD@kroah.com>
         <18292791718.88f48d22175003.6675210189148271554@siddh.me>
         <YvZxfpY4JUqvsOG5@kroah.com>
         <18292e1dcd8.2359a549180213.8185874405406307019@siddh.me>
         <20220812122509.281f0536@kernel.org>
         <182980137c6.5665bf61226802.3084448395277966678@siddh.me>
         <20220815094722.3c275087@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-08-15 at 09:47 -0700, Jakub Kicinski wrote:
> On Sat, 13 Aug 2022 21:49:52 +0530 Siddh Raman Pant wrote:
> > On Sat, 13 Aug 2022 00:55:09 +0530  Jakub Kicinski  wrote:
> > > Similarly to Greg, I'm not very familiar with the code base but one
> > > sure way to move things forward would be to point out a commit which
> > > broke things and put it in a Fixes tag. Much easier to validate a fix
> > > by looking at where things went wrong. =20
> >=20
> > Thanks, I now looked at some history.
> >=20
> > The following commit on 28 Sep 2020 put the kfree call before NULLing:
> > c8cb5b854b40 ("nl80211/cfg80211: support 6 GHz scanning")
> >=20
> > The following commit on 19 Nov 2014 introduces RCU:
> > 6ea0a69ca21b ("mac80211: rcu-ify scan and scheduled scan request pointe=
rs")
> >=20
> > The kfree call wasn't "rcu-ified" in this commit, and neither were
> > RCU heads added.
> >=20
> > The following commit on 18 Dec 2014 added RCU head for sched_scan_req:
> > 31a60ed1e95a ("nl80211: Convert sched_scan_req pointer to RCU pointer")
> >=20
> > It seems a similar thing might not have been done for scan_req, but I
> > could have also missed commits.
> >=20
> > So what should go into the fixes tag, if any? Probably 6ea0a69ca21b?
>=20
> That'd be my instinct, too. But do add the full history analysis=20
> to the commit message.
>=20
> > Also, I probably should use RCU_INIT_POINTER in this patch. Or should
> > I make a patch somewhat like 31a60ed1e95a?
>=20
> Yeah, IDK, I'm confused on what the difference between rdev and local
> is. The crash site reads the pointer from local, so other of clearing
> the pointer on rdev should not matter there. Hopefully wireless folks
> can chime in on v3.

Sorry everyone, I always thought "this looks odd" and then never got
around to taking a closer look.

So yeah, I still think this looks odd - cfg80211 doesn't really know
anything about how mac80211 might be doing something with RCU to protect
the pointer.

The patch also leaves the NULL-ing in mac80211 (that is how we reach it)
broken wrt. the kfree_rcu() since it doesn't happen _before_, and the
pointer in rdev isn't how this is reached through RCU (it's not even
__rcu annotated).

I think it might be conceptually better, though not faster, to do
something like https://p.sipsolutions.net/1d23837f455dc4c2.txt which
ensures that from mac80211's POV it can no longer be reached before we
call cfg80211_scan_done().

Yeah, that's slower, but scanning is still a relatively infrequent (and
slow anyway) operation, and this way we can stick to "this is not used
once you call cfg80211_scan_done()" which just makes much more sense?

johannes
