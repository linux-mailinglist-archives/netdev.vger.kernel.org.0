Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A454676DB
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 12:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380616AbhLCL6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 06:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbhLCL6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 06:58:36 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF54CC06173E
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 03:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ESWi3KfZM6y0fay+STHND+iRgwmhYwg55v1+e889a04=; b=sKBcQQUoXKK5wXN1cWCwMEoWcX
        xK7vWi+O5il5N/x6eItzPh/ZU3GEEUaJtZqAopeh3+vURssPYj7RAclXG1SqVoLc0Z+4X3sRfRuwF
        tLHupW1ufugCEuW407Qrg7i3juGQqFPVexBY4ebZSXz1fIRP3YbOXgL3SuBQgoGho08+SxyGcY34M
        oQRpaGkpEWiNyuTwca9hKn89ljGUg7/h67RCXIJXgLy4z+MRcG7UgFmq6GysUF8lk+Iuw5xKlOmWA
        N0kDfSYz+5IuEPio27EiyD5dHbocufRSuXAc8douyFdvcObgRDgcTKHJXN2UnYTj7Leyfs9Rj5p1b
        EEbjiaGQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56022)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mt79X-0001mT-LV; Fri, 03 Dec 2021 11:54:59 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mt79V-0001PR-GV; Fri, 03 Dec 2021 11:54:57 +0000
Date:   Fri, 3 Dec 2021 11:54:57 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        netdev@vger.kernel.org,
        =?utf-8?B?54Wn5bGx5ZGo5LiA6YOO?= <teruyama@springboard-inc.jp>
Subject: Re: [PATCH net,stable] phy: sfp: fix high power modules without diag
 mode
Message-ID: <YaoFkZ53m7cILdYu@shell.armlinux.org.uk>
References: <20211130073929.376942-1-bjorn@mork.no>
 <20211202175843.0210476e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211202175843.0210476e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 02, 2021 at 05:58:43PM -0800, Jakub Kicinski wrote:
> On Tue, 30 Nov 2021 08:39:29 +0100 Bjørn Mork wrote:
> > Commit 7cfa9c92d0a3 ("net: sfp: avoid power switch on address-change
> > modules") changed semantics for high power modules without diag mode.
> > We repeatedly try to read the current power status from the non-existing
> > 0xa2 address, in the futile hope this failure is temporary:
> > 
> > [    8.856051] sfp sfp-eth3: module NTT              0000000000000000 rev 0000 sn 0000000000000000 dc 160408
> > [    8.865843] mvpp2 f4000000.ethernet eth3: switched to inband/1000base-x link mode
> > [    8.873469] sfp sfp-eth3: Failed to read EEPROM: -5
> > [    8.983251] sfp sfp-eth3: Failed to read EEPROM: -5
> > [    9.103250] sfp sfp-eth3: Failed to read EEPROM: -5
> > 
> > Eeprom dump:
> > 
> > 0x0000: 03 04 01 00 00 00 80 00 00 00 00 01 0d 00 0a 64
> > 0x0010: 00 00 00 00 4e 54 54 20 20 20 20 20 20 20 20 20
> > 0x0020: 20 20 20 20 00 00 00 00 30 30 30 30 30 30 30 30
> > 0x0030: 30 30 30 30 30 30 30 30 30 30 30 30 05 1e 00 7d
> > 0x0040: 02 00 00 00 30 30 30 30 30 30 30 30 30 30 30 30
> > 0x0050: 30 30 30 30 31 36 30 34 30 38 20 20 00 00 00 75
> > 0x0060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > 0x0070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > 0x0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > 0x0090: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > 0x00a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > 0x00b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > 0x00c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > 0x00d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > 0x00e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > 0x00f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > 
> > Previously we assumed such modules were powered up in the correct
> > mode, continuing without further configuration as long as the
> > required power class was supported by the host.
> > 
> > Revert to that behaviour, refactoring to keep the improved
> > diagnostic messages.
> > 
> > Fixes: 7cfa9c92d0a3 ("net: sfp: avoid power switch on address-change modules")
> > Reported-and-tested-by: 照山周一郎 <teruyama@springboard-inc.jp>
> > Cc: Russell King <rmk+kernel@armlinux.org.uk>
> > Signed-off-by: Bjørn Mork <bjorn@mork.no>
> 
> Russell, any comments?

Sorry for the delay, I've been out over the last couple of days. I 
hink it's fine, but the code here is not easy to understand, hence
why this subtlety was missed. So, I'm not entirely happy about going
back to the original code.

Maybe instead doing a check in sfp_sm_mod_hpower() for this would
be better? Possibly something like:

static int sfp_module_parse_power(struct sfp *sfp)
{
	u32 power_mW = 1000;
+	bool supports_a2;

	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_POWER_DECL))
		power_mW = 1500;
	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_HIGH_POWER_LEVEL))
		power_mW = 2000;

+	supports_a2 = sfp->id.ext.sff8472_compliance !=
+				SFP_SFF8472_COMPLIANCE_NONE ||
+			sfp->id.ext.diagmon & SFP_DIAGMON_DDM;

	if (power_mW > sfp->max_power_mW) {
		/* Module power specification exceeds the allowed maximum. */
-		if (sfp->id.ext.sff8472_compliance ==
-			SFP_SFF8472_COMPLIANCE_NONE &&
-		    !(sfp->id.ext.diagmon & SFP_DIAGMON_DDM)) {
+		if (!supports_a2) {
...
	}
+
+	if (!supports_a2 && power_mW > 1000) {
+		/* The module power level is below the host maximum and the
+		 * module appears not to implement bus address 0xa2, so assume
+		 * that the module powers up in the indicated mode.
+		 */
+		return 0;
+	}

	/* If the module requires a higher power mode, but also requires
...

This way, if the module reports it doesn't support 0xa2, we don't get
the "Address Change Sequence not supported" message - since if 0xa2 is
not supported, then the address change sequence is irrelevant. However,
modules shouldn't have that bit set... but "shouldn't" doesn't mean
they do not.

This also has the advantage of making the check explicit and obvious,
and I much prefer the organisation of:

	if (module_exceeds_host_power) {
		handle this case
	} else {
		do other checks
	}

I think maybe dealing with power_mW <= 1000 early on may be a good idea,
and eliminates the tests further down for power_mW > 1000.

	if (power_mW <= 1000) {
		sfp->module_power_mW = power_mW;
		return 0;
	}

since those modules do not require any special handling.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
