Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36EA735603E
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242039AbhDGAWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 20:22:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232716AbhDGAWi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 20:22:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A0F6610FB;
        Wed,  7 Apr 2021 00:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617754949;
        bh=fgQQmnSRkz2Eh1EzJk8ieEdsJScbxdVLraAzW2aZFVs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PWn/cMIP0e6GuSae/zGGG5e5M5aCF8tyYHwH8Iq2b/v4uDbmwm9I4YVkk9vnCaCuB
         q0SC6PK53wG8XX0DfaZU47Gr4QWSxfhD+iK/BdfsfU6Q8V55Qk+G6h5zsl2E8/J7Wm
         ZbZaXWqSdPha8OKNyCB2gz9U3iSXLtGJpKjhLX39hqo9VHsm+vOWxaw5SeB1A8JM0k
         FSIeu6HW3rfXQ1v5WTqD9Ii83tQUDtrTLpfrNs40Eanje3SrqfnQ4hhVFrQXd/rFq/
         5qUNCcLaTFYWzVh23jI0BA05hKRBB8PKtvvuzDHCicoaLCIApANQIQ+FDK0E6L/zzV
         ACRCb0RwsHx6w==
Date:   Wed, 7 Apr 2021 02:22:24 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kuba@kernel.org
Subject: Re: [PATCH net-next v3 04/18] net: phy: marvell10g: indicate
 88X33x0 only port control registers
Message-ID: <20210407022224.1301b382@thinkpad>
In-Reply-To: <YGz4cIxizCjuEXNM@lunn.ch>
References: <20210406221107.1004-1-kabel@kernel.org>
        <20210406221107.1004-5-kabel@kernel.org>
        <YGz4cIxizCjuEXNM@lunn.ch>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Apr 2021 02:10:24 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> > @@ -479,8 +479,8 @@ static int mv3310_config_init(struct phy_device *phydev)
> >  	val = phy_read_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL);
> >  	if (val < 0)
> >  		return val;
> > -	priv->rate_match = ((val & MV_V2_PORT_CTRL_MACTYPE_MASK) ==
> > -			MV_V2_PORT_CTRL_MACTYPE_RATE_MATCH);
> > +	priv->rate_match = ((val & MV_V2_33X0_PORT_CTRL_MACTYPE_MASK) ==
> > +			MV_V2_33X0_PORT_CTRL_MACTYPE_RATE_MATCH);
> >  
> >  	/* Enable EDPD mode - saving 600mW */
> >  	return mv3310_set_edpd(phydev, ETHTOOL_PHY_EDPD_DFLT_TX_MSECS);
> > --   
> 
> So it appears that mv3310_config_init() should not be used with the
> mv88x2110. Did i miss somewhere where mv3310_drivers was changed so it
> actually does not use it?
> 
> 	 Andrew

This patch series makes it later so that mv3310_config_init() correctly
initializes even 2210 (this is done in patch 07/18). The function then
calls chip->get_mactype() and chip->init_interface() methods, which are
different for 3310 than for 2110.

I am thinking about whether all the functions which are same for all
the chips should be renamed from
  mv3310_*
to
  mv10g_*

This would rename
  mv3310_config_init
to
  mv10g_config_init
which would be more correct.

What do you think?

Marek
