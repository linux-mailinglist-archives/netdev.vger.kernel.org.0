Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18C04677BE
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 13:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239885AbhLCNBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 08:01:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbhLCNBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 08:01:32 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05547C06173E
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 04:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=lIICrWo19lDF1JsKSawkwGy00ZkRRr92+zT80OWW9Y0=; b=Oj9waY2Mw5uQAQaaERdQoIO/wr
        KMtBHeyxmQYBPbbNgm16tmI4iwJCy8ViQC2IilOU8pmz4S2SwSEntO1GW/PGzENFxZ5lH0RaqD8uQ
        /S3azRvNkEwphO7yVWow2j4IWRq7WNIDWwI0gpUDIiLRcyFG6T+BDzPnn31Dn+qIyFK3IFQxyY52y
        1PBMYToT6JbuThR2+CoEJpm4cIhvZGVv1qDj0YAyz5+XKo0/PpMOirw7XWmrNViCb1af4xDyv4DjT
        rHyS6TNtKE+EjUd+Z2hgMx8YqN+GaUkT+SD/ZyHqMI007tnTxcQj2bZDdweP9XnBqG4WV1zUgCwcr
        g7Wbszlw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56026)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mt88b-0001rD-2f; Fri, 03 Dec 2021 12:58:05 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mt88Z-0001SH-VU; Fri, 03 Dec 2021 12:58:03 +0000
Date:   Fri, 3 Dec 2021 12:58:03 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        netdev@vger.kernel.org,
        =?utf-8?B?54Wn5bGx5ZGo5LiA6YOO?= <teruyama@springboard-inc.jp>
Subject: Re: [PATCH net,stable] phy: sfp: fix high power modules without diag
 mode
Message-ID: <YaoUW9KHyEQOt46b@shell.armlinux.org.uk>
References: <20211130073929.376942-1-bjorn@mork.no>
 <20211202175843.0210476e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YaoFkZ53m7cILdYu@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YaoFkZ53m7cILdYu@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 03, 2021 at 11:54:57AM +0000, Russell King (Oracle) wrote:
> On Thu, Dec 02, 2021 at 05:58:43PM -0800, Jakub Kicinski wrote:
> > On Tue, 30 Nov 2021 08:39:29 +0100 Bjørn Mork wrote:
> > > Commit 7cfa9c92d0a3 ("net: sfp: avoid power switch on address-change
> > > modules") changed semantics for high power modules without diag mode.
> > > We repeatedly try to read the current power status from the non-existing
> > > 0xa2 address, in the futile hope this failure is temporary:
> > > 
> > > [    8.856051] sfp sfp-eth3: module NTT              0000000000000000 rev 0000 sn 0000000000000000 dc 160408
> > > [    8.865843] mvpp2 f4000000.ethernet eth3: switched to inband/1000base-x link mode
> > > [    8.873469] sfp sfp-eth3: Failed to read EEPROM: -5
> > > [    8.983251] sfp sfp-eth3: Failed to read EEPROM: -5
> > > [    9.103250] sfp sfp-eth3: Failed to read EEPROM: -5
> > > 
> > > Eeprom dump:
> > > 
> > > 0x0000: 03 04 01 00 00 00 80 00 00 00 00 01 0d 00 0a 64
> > > 0x0010: 00 00 00 00 4e 54 54 20 20 20 20 20 20 20 20 20
> > > 0x0020: 20 20 20 20 00 00 00 00 30 30 30 30 30 30 30 30
> > > 0x0030: 30 30 30 30 30 30 30 30 30 30 30 30 05 1e 00 7d
> > > 0x0040: 02 00 00 00 30 30 30 30 30 30 30 30 30 30 30 30
> > > 0x0050: 30 30 30 30 31 36 30 34 30 38 20 20 00 00 00 75
> > > 0x0060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > 0x0070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > 0x0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > 0x0090: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > 0x00a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > 0x00b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > 0x00c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > 0x00d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > 0x00e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > 0x00f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > 
> > > Previously we assumed such modules were powered up in the correct
> > > mode, continuing without further configuration as long as the
> > > required power class was supported by the host.
> > > 
> > > Revert to that behaviour, refactoring to keep the improved
> > > diagnostic messages.
> > > 
> > > Fixes: 7cfa9c92d0a3 ("net: sfp: avoid power switch on address-change modules")
> > > Reported-and-tested-by: 照山周一郎 <teruyama@springboard-inc.jp>
> > > Cc: Russell King <rmk+kernel@armlinux.org.uk>
> > > Signed-off-by: Bjørn Mork <bjorn@mork.no>
> > 
> > Russell, any comments?
> 
> Sorry for the delay, I've been out over the last couple of days. I 
> hink it's fine, but the code here is not easy to understand, hence
> why this subtlety was missed. So, I'm not entirely happy about going
> back to the original code.
> 
> Maybe instead doing a check in sfp_sm_mod_hpower() for this would
> be better? Possibly something like:
> 
> static int sfp_module_parse_power(struct sfp *sfp)
> {
> 	u32 power_mW = 1000;
> +	bool supports_a2;
> 
> 	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_POWER_DECL))
> 		power_mW = 1500;
> 	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_HIGH_POWER_LEVEL))
> 		power_mW = 2000;
> 
> +	supports_a2 = sfp->id.ext.sff8472_compliance !=
> +				SFP_SFF8472_COMPLIANCE_NONE ||
> +			sfp->id.ext.diagmon & SFP_DIAGMON_DDM;
> 
> 	if (power_mW > sfp->max_power_mW) {
> 		/* Module power specification exceeds the allowed maximum. */
> -		if (sfp->id.ext.sff8472_compliance ==
> -			SFP_SFF8472_COMPLIANCE_NONE &&
> -		    !(sfp->id.ext.diagmon & SFP_DIAGMON_DDM)) {
> +		if (!supports_a2) {
> ...
> 	}
> +
> +	if (!supports_a2 && power_mW > 1000) {
> +		/* The module power level is below the host maximum and the
> +		 * module appears not to implement bus address 0xa2, so assume
> +		 * that the module powers up in the indicated mode.
> +		 */
> +		return 0;
> +	}
> 
> 	/* If the module requires a higher power mode, but also requires
> ...
> 
> This way, if the module reports it doesn't support 0xa2, we don't get
> the "Address Change Sequence not supported" message - since if 0xa2 is
> not supported, then the address change sequence is irrelevant. However,
> modules shouldn't have that bit set... but "shouldn't" doesn't mean
> they do not.
> 
> This also has the advantage of making the check explicit and obvious,
> and I much prefer the organisation of:
> 
> 	if (module_exceeds_host_power) {
> 		handle this case
> 	} else {
> 		do other checks
> 	}
> 
> I think maybe dealing with power_mW <= 1000 early on may be a good idea,
> and eliminates the tests further down for power_mW > 1000.
> 
> 	if (power_mW <= 1000) {
> 		sfp->module_power_mW = power_mW;
> 		return 0;
> 	}
> 
> since those modules do not require any special handling.

Thinking a little more, how about this:

 drivers/net/phy/sfp.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 51a1da50c608..4c900d063b19 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1752,17 +1752,20 @@ static int sfp_sm_probe_for_phy(struct sfp *sfp)
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
+		      sfp->id.ext.diagmon & SFP_DIAGMON_DDM;
+
 	if (power_mW > sfp->max_power_mW) {
 		/* Module power specification exceeds the allowed maximum. */
-		if (sfp->id.ext.sff8472_compliance ==
-			SFP_SFF8472_COMPLIANCE_NONE &&
-		    !(sfp->id.ext.diagmon & SFP_DIAGMON_DDM)) {
+		if (!supports_a2) {
 			/* The module appears not to implement bus address
 			 * 0xa2, so assume that the module powers up in the
 			 * indicated mode.
@@ -1779,11 +1782,24 @@ static int sfp_module_parse_power(struct sfp *sfp)
 		}
 	}
 
+	if (power_mW <= 1000) {
+		/* Modules below 1W do not require a power change sequence */
+		return 0;
+	}
+
+	if (!supports_a2) {
+		/* The module power level is below the host maximum and the
+		 * module appears not to implement bus address 0xa2, so assume
+		 * that the module powers up in the indicated mode.
+		 */
+		return 0;
+	}
+
 	/* If the module requires a higher power mode, but also requires
 	 * an address change sequence, warn the user that the module may
 	 * not be functional.
 	 */
-	if (sfp->id.ext.diagmon & SFP_DIAGMON_ADDRMODE && power_mW > 1000) {
+	if (sfp->id.ext.diagmon & SFP_DIAGMON_ADDRMODE) {
 		dev_warn(sfp->dev,
 			 "Address Change Sequence not supported but module requires %u.%uW, module may not be functional\n",
 			 power_mW / 1000, (power_mW / 100) % 10);

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
