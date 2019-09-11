Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBF4AFA4F
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 12:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727547AbfIKK0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 06:26:41 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:35302 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727090AbfIKK0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 06:26:40 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1i7zpZ-00044U-VN; Wed, 11 Sep 2019 12:26:34 +0200
Message-ID: <feecebfcceba521703f13c8ee7f5bb9016924cb6.camel@sipsolutions.net>
Subject: Re: WARNING at net/mac80211/sta_info.c:1057
 (__sta_info_destroy_part2())
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>
Date:   Wed, 11 Sep 2019 12:26:32 +0200
In-Reply-To: <CAHk-=wgBuu8PiYpD7uWgxTSY8aUOJj6NJ=ivNQPYjAKO=cRinA@mail.gmail.com> (sfid-20190911_120605_906320_E6C720CE)
References: <CAHk-=wgBuu8PiYpD7uWgxTSY8aUOJj6NJ=ivNQPYjAKO=cRinA@mail.gmail.com>
         (sfid-20190911_120605_906320_E6C720CE)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> So I'm at LCA

When did LCA move to Portugal? ;-))

> , reading email, using my laptop more than I normally do,
> and with different networking than I normally do.
> 
> And I just had a 802.11 WARN_ON() trigger, followed by essentially a
> dead machine due to some lock held (maybe rtnl_lock).

yes, it's definitely stuck on the RTNL, all the lot of the workqueues
are trying to acquire it (linkwatch, ipv6, but oddly enough even the
mac80211 restart work).

> It's possible that the lock held thing happened before, and is the
> _reason_ for the delay, I don't know.

No, we do have the lock in the WARN_ON(), somewhere around
dev_close_many() it is acquired.

> Previous resume looks normal:
> [snip]
>    wlp2s0: Limiting TX power to 23 (23 - 0) dBm as advertised by
> 54:ec:2f:05:70:2c

Is that the message you meant?

> Another _almost_ successful suspend/resume:
> [snip
>    wlp2s0: RX AssocResp from 54:ec:2f:05:70:2c (capab=0x1011 status=0 aid=2)
>    wlp2s0: associated
>    wlp2s0: Limiting TX power to 23 (23 - 0) dBm as advertised by
> 54:ec:2f:05:70:2c
>    ath: EEPROM regdomain: 0x826c
>    ath: EEPROM indicates we should expect a country code
>    ath: doing EEPROM country->regdmn map search
>    ath: country maps to regdmn code: 0x37
>    ath: Country alpha2 being used: PT
>    ath: Regpair used: 0x37
>    ath: regdomain 0x826c dynamically updated by country element
>    IPv6: ADDRCONF(NETDEV_CHANGE): wlp2s0: link becomes ready
> 
> I say _almost_, because I don't see the "No TX power limit" for the
> country lookup (yes, Portugal) this time?

because here you had it too, just a bit earlier. It usually comes when a
beacon is received the first time, which depends on the AP timing.

>    ath10k_pci 0000:02:00.0: wmi command 16387 timeout, restarting hardware
>    ath10k_pci 0000:02:00.0: failed to set 5g txpower 23: -11
>    ath10k_pci 0000:02:00.0: failed to setup tx power 23: -11
>    ath10k_pci 0000:02:00.0: failed to recalc tx power: -11
>    ath10k_pci 0000:02:00.0: failed to set inactivity time for vdev 0: -108
>    ath10k_pci 0000:02:00.0: failed to setup powersave: -108
> 
> That certainly looks like something did try to set a power limit, but
> eventually failed.

Yeah, that does seem a bit fishy. Kalle would have to comment for
ath10k.

> Immediately after that:
> 
>    wlp2s0: deauthenticating from 54:ec:2f:05:70:2c by local choice
> (Reason: 3=DEAUTH_LEAVING)

I don't _think_ any of the above would be a reason to disconnect, but it
clearly looks like the device got stuck at this point, since everything
just fails afterwards.

>    ath10k_pci 0000:02:00.0: failed to delete peer 54:ec:2f:05:70:2c
> for vdev 0: -108
> 
> and this then results in:
> 
>    WARNING: CPU: 4 PID: 1246 at net/mac80211/sta_info.c:1057
> __sta_info_destroy_part2+0x147/0x150 [mac80211]

Not really a surprise. Perhaps we shouldn't even WARN_ON() this, if the
driver is stuck completely and returning errors to everything that
doesn't help so much.

Then again, the stack trace was helpful this time:

>     ieee80211_set_disassoc+0xc2/0x590 [mac80211]
>     ieee80211_mgd_deauth.cold+0x4a/0x1b8 [mac80211]
>     cfg80211_mlme_deauth+0xb3/0x1d0 [cfg80211]
>     cfg80211_mlme_down+0x66/0x90 [cfg80211]
>     cfg80211_disconnect+0x129/0x1e0 [cfg80211]
>     cfg80211_leave+0x27/0x40 [cfg80211]
>     cfg80211_netdev_notifier_call+0x1a7/0x4e0 [cfg80211]
>     notifier_call_chain+0x4c/0x70
>     __dev_close_many+0x57/0x100
>     dev_close_many+0x8d/0x140
>     dev_close.part.0+0x44/0x70
>     cfg80211_shutdown_all_interfaces+0x71/0xd0 [cfg80211]
>     cfg80211_rfkill_set_block+0x22/0x30 [cfg80211]
>     rfkill_set_block+0x92/0x140 [rfkill]
>     rfkill_fop_write+0x11f/0x1c0 [rfkill]
>     vfs_write+0xb6/0x1a0


Since we see that something actually did an rfkill operation. Did you
push a button there?

Like I said above, the fact that we get into notifier_call_chain() from
rfkill_set_block() means that we acquired the RTNL here somewhere
between these.

>    ath10k_pci 0000:02:00.0: failed to recalculate rts/cts prot for vdev 0: -108
>    ath10k_pci 0000:02:00.0: failed to set cts protection for vdev 0: -108
> 
> and it looks like it leaves some lock held.

Yeah, the RTNL.

You don't happen to have timing information on these logs, perhaps
recorded in the logfile/journal?

It seems odd to me, since the RTNL is acquired by
cfg80211_rfkill_set_block() and that doesn't even have an error path, it
just does
        rtnl_lock();
        cfg80211_shutdown_all_interfaces(&rdev->wiphy);
        rtnl_unlock();

The only explanation I therefore have is that something is just taking
*forever* in that code path, hence my question about timing information
on the logs.

Looks like indeed the driver gives the device at least *3 seconds* for
every command, see ath10k_wmi_cmd_send(), so most likely this would
eventually have finished, but who knows how many firmware commands it
would still have attempted to send...

Perhaps the driver should mark the device as dead and fail quickly once
it timed out once, or so, but I'll let Kalle comment on that.

johannes

