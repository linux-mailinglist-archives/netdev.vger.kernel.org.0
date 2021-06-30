Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87733B8257
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 14:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234769AbhF3Mpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 08:45:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234713AbhF3Mpv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 08:45:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A67EA61607;
        Wed, 30 Jun 2021 12:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625057002;
        bh=6OF4N7JUtnNgaXGoSID4OhvWKE5ES8/5xECcYMjn9GM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FeTNFP/0ZM6PCu6uCPphHKqYIH1H53Fn0P0lBSgSiPaSnDxaiEDoTfwPnscep264G
         VD1qn9Du9w5RFbMpaoP9kVqAoS1qW6MWuYMYAky4JPkgi0Q3CzwopOlXhVIH6adUP0
         LX1s2/SHr3RkVVE6SCBGo+8/iMPT1lg3xWSop3EqsrAMhyACheA9CZw9gt5d0C/TWG
         v+y1BgP9nZaz+HPITZG95rI25JNIzHguGMlKNmxdf7ZhPIaaFZlCkas7kJTmAEPvz1
         1/TccvltwJ8Iv3+zLrLmFdNM0jThM1U0Vy58BJB+KCztbGEkOiPPqRlps3x4HvXybC
         f8ALCQLH4m1Jg==
Date:   Wed, 30 Jun 2021 14:43:18 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Ling Pei Lee <pei.lee.ling@intel.com>
Cc:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, weifeng.voon@intel.com,
        vee.khee.wong@linux.intel.com, vee.khee.wong@intel.com
Subject: Re: [PATCH net-next V2] net: phy: marvell10g: enable WoL for mv2110
Message-ID: <20210630144318.42786e1b@dellmb>
In-Reply-To: <20210629105554.1443676-1-pei.lee.ling@intel.com>
References: <20210629105554.1443676-1-pei.lee.ling@intel.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ling,

some more things, please look at these.

First, the subject line should be
  net: phy: marvell10g: enable WoL for 88X3310 and 88E2110
since you are also implementing it for 3310.

> From: Voon Weifeng <weifeng.voon@intel.com>
> 
> Basically it is just to enable to WoL interrupt and enable WoL
> detection. Then, configure the MAC address into address detection
> register.

"Implement Wake-on-LAN feature for 88X3310 and 88E2110.

 This is done by enabling WoL interrupt and WoL detection and
 configuring MAC address into WoL magic packet registers."

> Change Log:
>  V2:
>  (1) Reviewer Marek request to rorganize code to readable way.
>  (2) Reviewer Rusell request to put phy_clear_bits_mmd() outside of
> if(){}else{} and modify return ret to return phy_clear_bits_mmd().
>  (3) Reviewer Rusell request to add return on phy_read_mmd() in
> set_wol(). (4) Reorganize register layout to be put before
> MV_V2_TEMP_CTRL. (5) Add the .{get|set}_wol for 88E3110 too as per
> feedback from Russell.

We do not put changelogs into the commit message normally. Mostly we
put it into cover letters or after the "--" line so that it is not
included in the commit message in git history (merge commits are one
of the exceptions).

As Russell wrote, you have only partially reorganized register
constants. The constants should be defined in this order
+	MV_V2_PORT_INTR_STS	= 0xf040,
+	MV_V2_PORT_INTR_MASK	= 0xf043,
+	MV_V2_WOL_INTR_EN	= BIT(8),
+	MV_V2_MAGIC_PKT_WORD0	= 0xf06b,
+	MV_V2_MAGIC_PKT_WORD1	= 0xf06c,
+	MV_V2_MAGIC_PKT_WORD2	= 0xf06d,
+	/* Wake on LAN registers */
+	MV_V2_WOL_CTRL		= 0xf06e,
+	MV_V2_WOL_CLEAR_STS	= BIT(15),
+	MV_V2_WOL_MAGIC_PKT_EN	= BIT(0),
+	MV_V2_WOL_STS		= 0xf06f,

Also:
- MV_V2_WOL_STS is not used, you should read the register before
  cleaning or don't define the constant at all. (IMO you should read
  it).
- register value constants should be prefixed with whole register names,
  so:
    MV_V2_WOL_INTR_EN  rename to  MV_V2_PORT_INTR_STS_WOL_EN
    MV_V2_WOL_CLEAR_STS  rename to  MV_V2_WOL_CTRL_CLEAR_STS
    MV_V2_WOL_MAGIC_PKT_EN  rename to  MV_V2_WOL_CTRL_MAGIC_PKT_EN

+	/* Reset the clear WOL status bit as it does not self-clear */
+	return phy_clear_bits_mmd(phydev, MDIO_MMD_VEND2,
+					MV_V2_WOL_CTRL,
+					MV_V2_WOL_CLEAR_STS);

This has wrong indentation, the arguments in new lines should start at
the position of first argument.

Marek

