Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8571CB2CC
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 17:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbgEHP2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 11:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbgEHP2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 11:28:50 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1A0C061A0C
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 08:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZGiqTkw2DY4uq73TtCb3ENDFOPr8DHMj0a0PIEGWFjA=; b=l7fC3qnEkJUymmrnwUar8yKYl
        Tj7Rff4PZz+QwzypGtSnfOYK0IkDVC7sB4tYZOtgHgauRLqE162/7KjCri0GW0WkG4QQegoJ0JHDS
        NtFgIbXNBu63a8CJMtltNKzS2XRBnAQ5Del5MSnEsIN86aWCyiI1CIul5xMIXS1SInsD4kTR+OdWf
        ckhBAcycEfk3Hg1arghIOaDQMRaKkEDguRtzp2gOKMEmquFgyZKowtz8ybmb4uB8udM9D1WinbrGj
        dcgk0nchOxjhmbbFkDCk9KRXYrzy/iYbeBl5t22I/yE3fz8GtTgTO+vggKkWynq2Sr7gr/13V+Ew/
        v4iz6qnyw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:37634)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jX4vd-0001IB-DT; Fri, 08 May 2020 16:28:45 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jX4vc-0001uw-Px; Fri, 08 May 2020 16:28:44 +0100
Date:   Fri, 8 May 2020 16:28:44 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: sfp: add some quirks for FreeTel direct
 attach modules
Message-ID: <20200508152844.GV1551@shell.armlinux.org.uk>
References: <20200507132135.316-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200507132135.316-1-marek.behun@nic.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 07, 2020 at 03:21:35PM +0200, Marek Behún wrote:
> FreeTel P.C30.2 and P.C30.3 may fail to report anything useful from
> their EEPROM. They report correct nominal bitrate of 10300 MBd, but do
> not report sfp_ct_passive nor sfp_ct_active in their ERPROM.
> 
> These modules can also operate at 1000baseX and 2500baseX.
> 
> Signed-off-by: Marek Behún <marek.behun@nic.cz>
> Cc: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/phy/sfp-bus.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
> index 6900c68260e0..f021709bedcc 100644
> --- a/drivers/net/phy/sfp-bus.c
> +++ b/drivers/net/phy/sfp-bus.c
> @@ -44,6 +44,14 @@ static void sfp_quirk_2500basex(const struct sfp_eeprom_id *id,
>  	phylink_set(modes, 2500baseX_Full);
>  }
>  
> +static void sfp_quirk_direct_attach_10g(const struct sfp_eeprom_id *id,
> +					unsigned long *modes)
> +{
> +	phylink_set(modes, 10000baseCR_Full);
> +	phylink_set(modes, 2500baseX_Full);
> +	phylink_set(modes, 1000baseX_Full);
> +}
> +
>  static const struct sfp_quirk sfp_quirks[] = {
>  	{
>  		// Alcatel Lucent G-010S-P can operate at 2500base-X, but
> @@ -63,6 +71,18 @@ static const struct sfp_quirk sfp_quirks[] = {
>  		.vendor = "HUAWEI",
>  		.part = "MA5671A",
>  		.modes = sfp_quirk_2500basex,
> +	}, {
> +		// FreeTel P.C30.2 is a SFP+ direct attach that can operate at
> +		// at 1000baseX, 2500baseX and 10000baseCR, but may report none
> +		// of these in their EEPROM
> +		.vendor = "FreeTel",
> +		.part = "P.C30.2",
> +		.modes = sfp_quirk_direct_attach_10g,
> +	}, {
> +		// same as previous
> +		.vendor = "FreeTel",
> +		.part = "P.C30.3",
> +		.modes = sfp_quirk_direct_attach_10g,

Looking at the EEPROM capabilities, it seems that these modules give
either:

Transceiver codes     : 0x01 0x00 0x00 0x00 0x00 0x04 0x80 0x00 0x00
Transceiver type      : Infiniband: 1X Copper Passive
Transceiver type      : Passive Cable
Transceiver type      : FC: Twin Axial Pair (TW)
Encoding              : 0x06 (64B/66B)
BR, Nominal           : 10300MBd
Passive Cu cmplnce.   : 0x01 (SFF-8431 appendix E) [SFF-8472 rev10.4 only]
BR margin, max        : 0%
BR margin, min        : 0%

or:

Transceiver codes     : 0x00 0x00 0x00 0x00 0x00 0x04 0x80 0x00 0x00
Transceiver type      : Passive Cable
Transceiver type      : FC: Twin Axial Pair (TW)
Encoding              : 0x06 (64B/66B)
BR, Nominal           : 10300MBd
Passive Cu cmplnce.   : 0x01 (SFF-8431 appendix E) [SFF-8472 rev10.4 only]
BR margin, max        : 0%
BR margin, min        : 0%

These give ethtool capability mask of 000,00000600,0000e040, which
is:

	2500baseX (bit 15)
	1000baseX (bit 41)
	10000baseCR (bit 42)

10000baseCR, 2500baseX and 1000baseX comes from:

        if ((id->base.sfp_ct_passive || id->base.sfp_ct_active) && br_nom) {
                /* This may look odd, but some manufacturers use 12000MBd */
                if (br_min <= 12000 && br_max >= 10300)
                        phylink_set(modes, 10000baseCR_Full);
                if (br_min <= 3200 && br_max >= 3100)
                        phylink_set(modes, 2500baseX_Full);
                if (br_min <= 1300 && br_max >= 1200)
                        phylink_set(modes, 1000baseX_Full);

since id->base.sfp_ct_passive is true, and br_nom = br_max = 10300 and
br_min = 0.

10000baseCR will also come from:

        if (id->base.sfp_ct_passive) {
                if (id->base.passive.sff8431_app_e)
                        phylink_set(modes, 10000baseCR_Full);
        }

You claimed in your patch description that sfp_ct_passive is not set,
but the EEPROM dumps contain:

	Transceiver type      : Passive Cable

which is correctly parsed by the kernel.

So, I'm rather confused, and I don't see why this patch is needed.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
