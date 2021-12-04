Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6924684D8
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 13:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384945AbhLDMlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 07:41:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233028AbhLDMlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 07:41:45 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94930C061751
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 04:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jyA+rqhJqem4NH32hVVAjeD4g4zcEqRg85lTAg+4qmg=; b=12WmZIy9FvII9pil2m30ABiZFM
        lzrNMsH+9W4WTgwA6Dx6Er8p+c3ERc1fOsdKV9piXi36WYmAmCz6mlK5rsGVHDfzIHrm1Sa3mDcZG
        LNnIFh6YzNMu5QtC2H1S3Xo5z6FFMn/xaLwU/TvicDGICgri45U/3+awOrWuvVzRPXvUqOH3kwUiD
        twsQ8bGpJLKQsWK4m6L363BV/u02NkH18v38/KJqZekZwvVLLkoelW0/e5hTQn6bJVfB6Ksh1EMHf
        9IoRtLVoxpA6XtLhG/9aPHw4lSHrXnrSA5iKXAJgxpxsBK+sF3dfsqj//Iuk68RzepSyYceJtkGp3
        e4ds6R2A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56056)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mtUIx-0003IG-5G; Sat, 04 Dec 2021 12:38:15 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mtUIv-0002PC-Qz; Sat, 04 Dec 2021 12:38:13 +0000
Date:   Sat, 4 Dec 2021 12:38:13 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        =?utf-8?B?54Wn5bGx5ZGo5LiA6YOO?= <teruyama@springboard-inc.jp>
Subject: Re: [PATCH net,stable] phy: sfp: fix high power modules without diag
 mode
Message-ID: <YathNbNBob2kHxrH@shell.armlinux.org.uk>
References: <20211130073929.376942-1-bjorn@mork.no>
 <20211202175843.0210476e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YaoFkZ53m7cILdYu@shell.armlinux.org.uk>
 <YaoUW9KHyEQOt46b@shell.armlinux.org.uk>
 <877dclkd2y.fsf@miraculix.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <877dclkd2y.fsf@miraculix.mork.no>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 03, 2021 at 02:55:17PM +0100, Bjørn Mork wrote:
> "Russell King (Oracle)" <linux@armlinux.org.uk> writes:
> 
> > Thinking a little more, how about this:
> >
> >  drivers/net/phy/sfp.c | 25 +++++++++++++++++++++----
> >  1 file changed, 21 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> > index 51a1da50c608..4c900d063b19 100644
> > --- a/drivers/net/phy/sfp.c
> > +++ b/drivers/net/phy/sfp.c
> > @@ -1752,17 +1752,20 @@ static int sfp_sm_probe_for_phy(struct sfp *sfp)
> >  static int sfp_module_parse_power(struct sfp *sfp)
> >  {
> >  	u32 power_mW = 1000;
> > +	bool supports_a2;
> >  
> >  	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_POWER_DECL))
> >  		power_mW = 1500;
> >  	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_HIGH_POWER_LEVEL))
> >  		power_mW = 2000;
> >  
> > +	supports_a2 = sfp->id.ext.sff8472_compliance !=
> > +				SFP_SFF8472_COMPLIANCE_NONE ||
> > +		      sfp->id.ext.diagmon & SFP_DIAGMON_DDM;
> > +
> >  	if (power_mW > sfp->max_power_mW) {
> >  		/* Module power specification exceeds the allowed maximum. */
> > -		if (sfp->id.ext.sff8472_compliance ==
> > -			SFP_SFF8472_COMPLIANCE_NONE &&
> > -		    !(sfp->id.ext.diagmon & SFP_DIAGMON_DDM)) {
> > +		if (!supports_a2) {
> >  			/* The module appears not to implement bus address
> >  			 * 0xa2, so assume that the module powers up in the
> >  			 * indicated mode.
> > @@ -1779,11 +1782,24 @@ static int sfp_module_parse_power(struct sfp *sfp)
> >  		}
> >  	}
> >  
> > +	if (power_mW <= 1000) {
> > +		/* Modules below 1W do not require a power change sequence */
> > +		return 0;
> > +	}
> > +
> > +	if (!supports_a2) {
> > +		/* The module power level is below the host maximum and the
> > +		 * module appears not to implement bus address 0xa2, so assume
> > +		 * that the module powers up in the indicated mode.
> > +		 */
> > +		return 0;
> > +	}
> > +
> >  	/* If the module requires a higher power mode, but also requires
> >  	 * an address change sequence, warn the user that the module may
> >  	 * not be functional.
> >  	 */
> > -	if (sfp->id.ext.diagmon & SFP_DIAGMON_ADDRMODE && power_mW > 1000) {
> > +	if (sfp->id.ext.diagmon & SFP_DIAGMON_ADDRMODE) {
> >  		dev_warn(sfp->dev,
> >  			 "Address Change Sequence not supported but module requires %u.%uW, module may not be functional\n",
> >  			 power_mW / 1000, (power_mW / 100) % 10);
> 
> Looks nice to me at least.  But I don't have the hardware to test it.

I don't have the hardware either, so I can't test it - but it does need
testing. I assume as you've reported it and sent a patch, you know
someone who has run into this issue? It would be great if you could ask
them to test it and let us know if it solves the problem.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
