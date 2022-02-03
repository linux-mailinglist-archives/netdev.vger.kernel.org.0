Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63E724A90A8
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 23:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355808AbiBCW0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 17:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiBCW0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 17:26:35 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A42FC061714;
        Thu,  3 Feb 2022 14:26:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=UNDKBN8Hpv7lUpDkOhgTISxY3WTMMGezTKV040MGm+E=;
        t=1643927195; x=1645136795; b=LGVrzj7cbNfu68AwH/jdL1nBWOT464hHv3aOERipsGFYCFJ
        TzKjZw8ghYJcC3tSacveW23zGe5PtyMIkETCouwh5UBMT3yHaP1O6BxQF4czjl32bINMy9oLTGTI7
        7KPte1axqvTOzFDM3Y7cqbpxKWbshEFPAC1yN8JATYe9WVsEJYdduZcht9MjAQOzfraqi77M5l/uN
        JFYYCk9N36/H9E70Pzphdl2K0GDvOLFWmIOtE0GBisGK5f+nqUFAWWSPp0kAfb3PmDA8yd9HOSn+b
        ys5p5YYAOFth/F8LBOyzc2wmOKe6Ny1tw5fOKtcrMxdZz62ua31UkzNVBPiNhhWw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nFkYd-00EG1v-Gb;
        Thu, 03 Feb 2022 23:26:27 +0100
Message-ID: <8a955cdeba84bf1febb2fe558ae09456115478db.camel@sipsolutions.net>
Subject: Re: [PATCH v3 0/8] rtw88: prepare locking for SDIO support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Pkshih <pkshih@realtek.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Ed Swierk <eswierk@gh.st>
Date:   Thu, 03 Feb 2022 23:26:26 +0100
In-Reply-To: <CAFBinCDjfKK3+WOXP2xbcAK-KToWof+kSzoxYztqRcc=7T1eyg@mail.gmail.com>
References: <20220108005533.947787-1-martin.blumenstingl@googlemail.com>
         <423f474e15c948eda4db5bc9a50fd391@realtek.com>
         <CAFBinCBVEndU0t-6d5atE31OFYHzPyk7pOe78v0XrrFWcBec9w@mail.gmail.com>
         <5ef8ab4f78e448df9f823385d0daed88@realtek.com>
         <CAFBinCDjfKK3+WOXP2xbcAK-KToWof+kSzoxYztqRcc=7T1eyg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Sorry, I kind of saw this fly by, read over it and wasn't sure I should
take a closer look, and then promptly forgot about it ...

> > So, I think the easiest way is to maintains the vif/sta lists in driver when
> > ::{add,remove }_interface/::sta_{add,remove}, and hold rtwdev->mutex lock to
> > access these lists. But, Johannes pointed out this is not a good idea [1].

> Thank you for this detailed explanation! I appreciate that you took
> the time to clearly explain this.
> 
> For the sta use-case I thought about adding a dedicated rwlock
> (include/linux/rwlock.h) for rtw_dev->mac_id_map.

You can't sleep under an rwlock either though? Wasn't that the point?

> rtw_sta_{add,remove} would take a write-lock.
> rtw_iterate_stas() takes the read-lock (the lock would be acquired
> before calling into ieee80211_iterate_...). Additionally
> rtw_iterate_stas() needs to check if the station is still valid
> according to mac_id_map - if not: skip/ignore it for that iteration.

All of that "still valid" seems fragile though, IMHO. Hard to reason
that it's not racy or prone to use-after-free situations.

IIUC, you're trying to iterate interfaces and stations in a sleepable
context, but you're worried about deadlocks with locking in mac80211, if
ieee80211_iterate_interfaces() or ieee80211_iterate_stations() take
locks that we already hold due to coming into the code from mac80211? Or
about ABBA deadlocks arising from this?

IMHO you should still do it, and just be careful about the locking. I'd
be happy to add APIs for e.g. ieee80211_iterate_stations_locked() when
you know you already hold local->sta_mtx, though whether or not that can
even happen today in any callbacks I don't know, haven't audited it, but
it shouldn't be that hard to audit the path(s) you want to create?
Unless you need this in some very frequently called function ...


Now all of this is potentially also (and just as) error prone as doing
your own iteration machinery, however, my longer-term plan is to unify
the locking more. Now that we're no longer relying on the RTNL so much,
I'm planning to see if we couldn't get rid of most locks in mac80211.
The thing is, that most of the time we're doing all this fine-grained
locking ... under the wdev->mtx, so it's entirely pointless, and in fact
just a bunch of extra work.

So now that from cfg80211 perspective we have everything running under
wdev lock, I think we could in mac80211 just remove all the locks and
take the wdev lock in all the async workers. We already do in many I
guess, or we take local->mtx which is kind of equivalent anyway.

The question is then if we keep wdev->mtx at all, and I'm not really
sure about that yet. There are arguments both ways, and maybe that means
we'd move some things under there rather than under the overall mutex.
One of the strongest arguments for this is probably that mac80211
doesn't really do anything expensive (there aren't really any expensive
calculations in it), so most time spent is in drivers ... and guess
what, drivers mostly just have their own global lock they take for
everything, which makes sense since they need to talk to the device or
firmware.

However we answer that question though, and I'm trending towards
removing the wdev/sdata locks, I (now) think all the mutexes that we
have at the 'local' level in mac80211 are fairly much pointless.

In essence then, with some work in the stack, we could basically have
all calls (apart from TX) into the drivers done with the wiphy->mtx
held, at which point drivers don't even really need their own lock (they
can acquire wiphy_lock() too in workers). Then this whole thing really
all collapses down to being able to do the iteration, just having to
ensure you wiphy_lock() your calls that aren't coming from mac80211 in
the first place.

I really think that's the medium-term strategy, and any help would be
welcome. I'm not sure I can dedicate time to this soon, and the RTNL
rework took I think over a year after I started thinking about it, so I
guess we'll see...

We can do this incrementally btw, like remove local->mtx now and use
wiphy_lock() in its place, then remove local->sta_mtx, local->iface_mtx,
one by one. The RTNL rework was one of the major stepping stones to this
I think, because it ensured a consistent handling of the wiphy_lock() in
cfg80211.

I realize this doesn't help you in the short term, but if you do a lot
of complicated things now, it'll also be hard to get rid of. If you use
the normal iteration functions now it'll be harder to reason about now,
but will sort of automatically become easier once the lock redux work I
outlined above starts. And like I said, any help welcome :)

johannes
