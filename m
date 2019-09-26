Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8199FBF236
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 13:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfIZLzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 07:55:14 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:51542 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfIZLzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 07:55:14 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iDSMU-0000Wn-4M; Thu, 26 Sep 2019 13:55:06 +0200
Message-ID: <9ece533700be8237699881312a99cc91c6a71d36.camel@sipsolutions.net>
Subject: Re: [PATCH RFC] cfg80211: add new command for reporting wiphy
 crashes
From:   Johannes Berg <johannes@sipsolutions.net>
To:     =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>,
        Jouni Malinen <j@w1.fi>,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hostap@lists.infradead.org,
        openwrt-devel@lists.openwrt.org
Date:   Thu, 26 Sep 2019 13:55:04 +0200
In-Reply-To: <4f6f37e5-802c-4504-3dcb-c4a640d138bd@milecki.pl>
References: <20190920133708.15313-1-zajec5@gmail.com>
         <20190920140143.GA30514@w1.fi>
         <4f6f37e5-802c-4504-3dcb-c4a640d138bd@milecki.pl>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-09-26 at 13:52 +0200, Rafał Miłecki wrote:
> 
> Indeed my main concert is AP mode. I'm afraid that cfg80211 doesn't
> cache all settings, consider e.g. nl80211_start_ap(). It builds
> struct cfg80211_ap_settings using info from nl80211 message and
> passes it to the driver (rdev_start_ap()). Once it's done it
> caches only a small subset of all setup data.
> 
> In other words driver doesn't have enough info to recover interfaces
> setup.

So the driver can cache it, just like mac80211.

You can't seriously be suggesting that the driver doesn't *have* enough
information - everything passed through it :)

> I meant that hardware has been recovered & is operational again (driver
> can talk to it). I expected user space to reconfigure all interfaces
> using the same settings that were used on previous run.
> 
> If driver were able to recover interfaces setup on its own (with a help
> of cfg80211) then user space wouldn't need to be involved.

The driver can do it, mac80211 does. It's just a matter of what the
driver will do or not.

> First of all I was wondering how to handle interfaces creation. After a
> firmware crash we have:
> 1) Interfaces created in Linux
> 2) No corresponsing interfaces in firmware

> Syncing that (re-creating in-firmware firmwares) may be a bit tricky
> depending on a driver and hardware.

We do that in mac80211, it works fine. Why would it be tricky?

If something fails, I think we force that interface to go down.

> For some cases it could be easier to
> delete all interfaces and ask user space to setup wiphy (create required
> interfaces) again. I'm not sure if that's acceptable though?
> 
> If we agree interfaces should stay and driver simply should configure
> firmware properly, then we need all data as explained earlier. struct
> cfg80211_ap_settings is not available during runtime. How should we
> handle that problem?

You can cache it in the driver in whatever format makes sense.

> I was aiming for a brutal force solution: just make user space
> interfaces need a full setup just at they were just created.

You can still do that btw, just unregister and re-register the wiphy.

johannes

