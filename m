Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8C8490A35
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 15:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234429AbiAQOYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 09:24:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234290AbiAQOYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 09:24:23 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D30C061574
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 06:24:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fxb3q5tFJzFo+F0/Qg377tZuRX6yxExjg4qScdhJ6yo=; b=YNldg6OoMJ/Pb/B3NjgweJE59t
        e96DprGArDvRX7MMpOo02qlZzQ4ovHf/S9PDVKBxf8dP8GAsAwaLnMiVqckOnmpaTG3i0z/GFPE65
        6+73cu7BLTQJV9jE2raQ3jrt02U8RaJKHSy4p21eeZWgzc18yNyFECIiMCq6juTqMfdvcUfJX0Sdk
        2YZ/3UevRdHm4JUSTXLRm0xwvY5GbjJUpfdgKPwkmKRtDI+d1GKb6ikybOUwS6Tblnn8BJYoDAoO5
        Y/QpVRCoqRmQXqUe+WFu59s8waTChSlaQcMIJ/Mp+bSTZPrvMfL3tjqX2V7F4rpavnQ7D/qTZoTFr
        UjFVYU0g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56722)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n9Sva-0002gu-Mw; Mon, 17 Jan 2022 14:24:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n9SvX-0003NP-9R; Mon, 17 Jan 2022 14:24:07 +0000
Date:   Mon, 17 Jan 2022 14:24:07 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        netdev@vger.kernel.org,
        =?utf-8?B?54Wn5bGx5ZGo5LiA6YOO?= <teruyama@springboard-inc.jp>
Subject: Re: [PATCH net,stable] phy: sfp: fix high power modules without diag
 mode
Message-ID: <YeV8BwzyXuuvxvBN@shell.armlinux.org.uk>
References: <20211130073929.376942-1-bjorn@mork.no>
 <20211202175843.0210476e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YaoFkZ53m7cILdYu@shell.armlinux.org.uk>
 <YaoUW9KHyEQOt46b@shell.armlinux.org.uk>
 <d4533eb7-97c1-5eb1-011d-60b59ff7ccbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d4533eb7-97c1-5eb1-011d-60b59ff7ccbb@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 15, 2022 at 05:58:43PM +0100, Christian Lamparter wrote:
> On 03/12/2021 13:58, Russell King (Oracle) wrote:
> > On Fri, Dec 03, 2021 at 11:54:57AM +0000, Russell King (Oracle) wrote:
> > [...]
> > Thinking a little more, how about this:
> > 
> >   drivers/net/phy/sfp.c | 25 +++++++++++++++++++++----
> >   1 file changed, 21 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> > index 51a1da50c608..4c900d063b19 100644
> > --- a/drivers/net/phy/sfp.c
> > +++ b/drivers/net/phy/sfp.c
> > @@ -1752,17 +1752,20 @@ static int sfp_sm_probe_for_phy(struct sfp *sfp)
> >   static int sfp_module_parse_power(struct sfp *sfp)
> >   {
> >   	u32 power_mW = 1000;
> > +	bool supports_a2;
> >   	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_POWER_DECL))
> >   		power_mW = 1500;
> >   	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_HIGH_POWER_LEVEL))
> >   		power_mW = 2000;
> > +	supports_a2 = sfp->id.ext.sff8472_compliance !=
> > +				SFP_SFF8472_COMPLIANCE_NONE ||
> > +		      sfp->id.ext.diagmon & SFP_DIAGMON_DDM;
> > +
> >   	if (power_mW > sfp->max_power_mW) {
> >   		/* Module power specification exceeds the allowed maximum. */
> > -		if (sfp->id.ext.sff8472_compliance ==
> > -			SFP_SFF8472_COMPLIANCE_NONE &&
> > -		    !(sfp->id.ext.diagmon & SFP_DIAGMON_DDM)) {
> > +		if (!supports_a2) {
> >   			/* The module appears not to implement bus address
> >   			 * 0xa2, so assume that the module powers up in the
> >   			 * indicated mode.
> > @@ -1779,11 +1782,24 @@ static int sfp_module_parse_power(struct sfp *sfp)
> >   		}
> >   	}
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
> >   	/* If the module requires a higher power mode, but also requires
> >   	 * an address change sequence, warn the user that the module may
> >   	 * not be functional.
> >   	 */
> > -	if (sfp->id.ext.diagmon & SFP_DIAGMON_ADDRMODE && power_mW > 1000) {
> > +	if (sfp->id.ext.diagmon & SFP_DIAGMON_ADDRMODE) {
> >   		dev_warn(sfp->dev,
> >   			 "Address Change Sequence not supported but module requires %u.%uW, module may not be functional\n",
> >   			 power_mW / 1000, (power_mW / 100) % 10);
> > 
> 
> The reporter has problems reaching you. But from what I can tell in his reply to his
> OpenWrt Github PR:
> <https://github.com/openwrt/openwrt/pull/4802#issuecomment-1013439827>
> 
> your approach is working perfectly. Could you spin this up as a fully-fledged patch (backports?)

There seems to be no problem - I received an email on the 30 December
complete with the test logs. However, that was during the holiday period
and has been buried, so thanks for the reminder.

However, I'm confused about who the reporter and testers actually are,
so I'm not sure who to put in the Reported-by and Tested-by fields.
From what I can see, Bjørn Mork <bjorn@mork.no> reported it (at least
to mainline devs), and the fix was tested by 照山周一郎
<teruyama@springboard-inc.jp>.

Is that correct? Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
