Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B124922A389
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 02:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733201AbgGWAOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 20:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726685AbgGWAOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 20:14:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E16C0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 17:14:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8E22611E8EC18;
        Wed, 22 Jul 2020 16:57:32 -0700 (PDT)
Date:   Wed, 22 Jul 2020 17:14:16 -0700 (PDT)
Message-Id: <20200722.171416.680374889497844164.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk,
        f.fainelli@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        ioana.ciornei@nxp.com, michael@walle.cc, colin.king@canonical.com
Subject: Re: [PATCH net-next] net: phy: fix check in get_phy_c45_ids
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200720172654.1193241-1-olteanv@gmail.com>
References: <20200720172654.1193241-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Jul 2020 16:57:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Mon, 20 Jul 2020 20:26:54 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> After the patch below, the iteration through the available MMDs is
> completely short-circuited, and devs_in_pkg remains set to the initial
> value of zero.
> 
> Due to devs_in_pkg being zero, the rest of get_phy_c45_ids() is
> short-circuited too: the following loop never reaches below this point
> either (it executes "continue" for every device in package, failing to
> retrieve PHY ID for any of them):
> 
> 	/* Now probe Device Identifiers for each device present. */
> 	for (i = 1; i < num_ids; i++) {
> 		if (!(devs_in_pkg & (1 << i)))
> 			continue;
> 
> So c45_ids->device_ids remains populated with zeroes. This causes an
> Aquantia AQR412 PHY (same as any C45 PHY would, in fact) to be probed by
> the Generic PHY driver.
> 
> The issue seems to be a case of submitting partially committed work (and
> therefore testing something other than was submitted).
> 
> The intention of the patch was to delay exiting the loop until one more
> condition is reached (the devs_in_pkg read from hardware is either 0, OR
> mostly f's). So fix the patch to reflect that.
> 
> Tested with traffic on a LS1028A-QDS, the PHY is now probed correctly
> using the Aquantia driver. The devs_in_pkg bit field is set to
> 0xe000009a, and the MMDs that are present have the following IDs:
 ...
> Fixes: bba238ed037c ("net: phy: continue searching for C45 MMDs even if first returned ffff:ffff")
> Reported-by: Colin King <colin.king@canonical.com>
> Reported-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied, thanks.

I waited on this because I wanted to get a review from someone, and I
try to always give Andrew/Florian/Heiner/etc. a day or two on core PHY
stuff so that they can have a chance to do a review.
