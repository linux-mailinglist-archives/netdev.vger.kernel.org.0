Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9322CE22B
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 23:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387437AbgLCWxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 17:53:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731865AbgLCWxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 17:53:41 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7821C061A51;
        Thu,  3 Dec 2020 14:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=O7SE73yvQEcPcDDjzMoCt43L3cMIZXlKFOb3iR2LqBw=; b=RuaaWUqte3o2aWFrf+UKhj7zq
        0H/ui1VV7iksLg4dAmU2HOdL7iDoPKPd1CTRqwC5hKuIjWHJxXNbfOvQTiS3c4utdeg2HkjIRBb6D
        LddP1k+xiUmBFaEF4RbIGudqVOvuq/Y6DfIkA9CNkFNJGELVMJq02O9pPKUhLG70QjJrGHCz3JKhj
        IZMEx12vNxcZC8WOU+qNR8IIYeUnaVVI7STbCjhjbBTzAC6y1ujF1NQrwuadXNKwIUeVJBOTueXuI
        /NfCfDTLSfCIAYCkuqp+W7Rp20jWczNw+zwGoyZOHz4Nvx41wQabuXdcz1fQzb6ZFCOrLdFRaPYlV
        GrbCZ5aDA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:39418)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kkxSk-0003bk-4t; Thu, 03 Dec 2020 22:52:34 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kkxSj-0008Sm-3b; Thu, 03 Dec 2020 22:52:33 +0000
Date:   Thu, 3 Dec 2020 22:52:33 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 3/4] phy: Add Sparx5 ethernet serdes PHY driver
Message-ID: <20201203225232.GI1551@shell.armlinux.org.uk>
References: <20201203103015.3735373-1-steen.hegelund@microchip.com>
 <20201203103015.3735373-4-steen.hegelund@microchip.com>
 <20201203215253.GL2333853@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203215253.GL2333853@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 10:52:53PM +0100, Andrew Lunn wrote:
> > +/* map from SD25G28 interface width to configuration value */
> > +static u8 sd25g28_get_iw_setting(const u8 interface_width)
> > +{
> > +	switch (interface_width) {
> > +	case 10: return 0;
> > +	case 16: return 1;
> > +	case 32: return 3;
> > +	case 40: return 4;
> > +	case 64: return 5;
> > +	default:
> > +		pr_err("%s: Illegal value %d for interface width\n",
> > +		       __func__, interface_width);
> 
> Please make use of dev_err(phy->dev, so we know which PHY has
> configuration problems.
> 
> > +static int sparx5_serdes_validate(struct phy *phy, enum phy_mode mode,
> > +					int submode,
> > +					union phy_configure_opts *opts)
> > +{
> > +	struct sparx5_serdes_macro *macro = phy_get_drvdata(phy);
> > +	struct sparx5_serdes_private *priv = macro->priv;
> > +	u32 value, analog_sd;
> > +
> > +	if (mode != PHY_MODE_ETHERNET)
> > +		return -EINVAL;
> > +
> > +	switch (submode) {
> > +	case PHY_INTERFACE_MODE_1000BASEX:
> > +	case PHY_INTERFACE_MODE_SGMII:
> > +	case PHY_INTERFACE_MODE_QSGMII:
> > +	case PHY_INTERFACE_MODE_10GBASER:
> > +		break;
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +	if (macro->serdestype == SPX5_SDT_6G) {
> > +		value = sdx5_rd(priv, SD6G_LANE_LANE_DF(macro->stpidx));
> > +		analog_sd = SD6G_LANE_LANE_DF_PMA2PCS_RXEI_FILTERED_GET(value);
> > +	} else if (macro->serdestype == SPX5_SDT_10G) {
> > +		value = sdx5_rd(priv, SD10G_LANE_LANE_DF(macro->stpidx));
> > +		analog_sd = SD10G_LANE_LANE_DF_PMA2PCS_RXEI_FILTERED_GET(value);
> > +	} else {
> > +		value = sdx5_rd(priv, SD25G_LANE_LANE_DE(macro->stpidx));
> > +		analog_sd = SD25G_LANE_LANE_DE_LN_PMA_RXEI_GET(value);
> > +	}
> > +	/* Link up is when analog_sd == 0 */
> > +	return analog_sd;
> > +}

You still have not Cc'd me on your patches. Please can you either:

1) use get_maintainer.pl to find out whom you should be sending
   your patches to
or
2) include me in your cc for this patch set as phylink maintainer in
   your patch set so I can review your use of phylink.

Consider your patches NAK'd until you send them to me so that I can
review them.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
