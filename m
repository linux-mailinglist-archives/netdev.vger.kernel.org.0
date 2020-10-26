Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130AF2996D0
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 20:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793011AbgJZT2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 15:28:54 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:46586 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1771819AbgJZT2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 15:28:54 -0400
X-Greylist: delayed 534 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Oct 2020 15:28:54 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=SpZX4c/aincIHSmWIPWOPZGtAj5ESwUK3hKcdozmlyo=; b=Dcbr8OmKhVE9z/DSmROAEftAa
        5UGZ/g8l7ojYmeGRau3rMZKRQ25OFmfxS4p7IjiIYZr16DaWJeuQKvZCXUiPscJanvnj3kYX/dgxO
        +qxaC1g7lMEOQX2ewPypdzpHnJd6XoYWOtE84+x8+xtgf3TAh/WpXRDAxuAYro3d0JJ1iEfPbuXve
        1fJ3I/pmN4elyKWty3u7NfdGE9KlzFtgg72odkWwP/LtaLXOlSMWifPQtxGXeftrVpH+3HhXsBxZI
        FQ05lMwk4fr6kLPVau3F5ZdcjjOeGtf9M+bKV4F7kk4EklAXEJZjAqs9+fKoY25pRBVsjK/CFrkL2
        JiMv6CDgQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51316)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kX824-00085g-2z; Mon, 26 Oct 2020 19:19:52 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kX820-0003GE-Gr; Mon, 26 Oct 2020 19:19:48 +0000
Date:   Mon, 26 Oct 2020 19:19:48 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Radhey Shyam Pandey <radheys@xilinx.com>
Cc:     Robert Hancock <robert.hancock@calian.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Michal Simek <michals@xilinx.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net: axienet: Properly handle PCS/PMA PHY
 for 1000BaseX mode
Message-ID: <20201026191948.GJ1551@shell.armlinux.org.uk>
References: <20201026175535.1332222-1-robert.hancock@calian.com>
 <BYAPR02MB56382BA3CB100008FC02B02BC7190@BYAPR02MB5638.namprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR02MB56382BA3CB100008FC02B02BC7190@BYAPR02MB5638.namprd02.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 06:57:00PM +0000, Radhey Shyam Pandey wrote:
> > +	switch (state->interface) {
> > +	case PHY_INTERFACE_MODE_NA:
> > +	case PHY_INTERFACE_MODE_1000BASEX:
> > +	case PHY_INTERFACE_MODE_SGMII:
> > +	case PHY_INTERFACE_MODE_GMII:
> > +	case PHY_INTERFACE_MODE_RGMII:
> > +	case PHY_INTERFACE_MODE_RGMII_ID:
> > +	case PHY_INTERFACE_MODE_RGMII_RXID:
> > +	case PHY_INTERFACE_MODE_RGMII_TXID:
> > +		phylink_set(mask, 1000baseX_Full);
> > +		phylink_set(mask, 1000baseT_Full);
> > +		if (state->interface == PHY_INTERFACE_MODE_1000BASEX)
> > +			break;
> 
> 100BaseT and 10BaseT can be set in PHY_INTERFACE_MODE_MII if we 
> allow fallthrough here.

The above is actually correct (at the moment) since we don't yet support
rate adapting 1G PHYs.

> > +	if (lp->phy_mode == PHY_INTERFACE_MODE_SGMII ||
> > +	    lp->phy_mode == PHY_INTERFACE_MODE_1000BASEX) {
> > +		if (!lp->phy_node) {
> > +			dev_err(&pdev->dev, "phy-handle required for
> > 1000BaseX/SGMII\n");
> > +			ret = -EINVAL;
> > +			goto free_netdev;
> > +		}
> > +		lp->pcs_phy = of_mdio_find_device(lp->phy_node);
> > +		if (!lp->pcs_phy) {
> > +			ret = -EPROBE_DEFER;
> 
> Are we assuming the error is always EPROBE_DEFER?

of_mdio_find_device() returning NULL when the argument is non-NULL
just means it wasn't found - which isn't an "error".

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
