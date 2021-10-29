Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC78343F8BA
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 10:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232441AbhJ2IYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 04:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232433AbhJ2IYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 04:24:08 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085EEC061570;
        Fri, 29 Oct 2021 01:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=R+jZXij5/Xk2QpRoQVNw9PyvFwMYQKCNbuQ5IodArJs=; b=nn/grtlZsdiZ92/B5exkDezvj+
        VL5sSPnLJWNGAmDVwis600h9Ro4QmOFsZBafp8VhMtPKVnscZeVkSZrYgpPh8sHIvGf8Jngfp//1L
        QTOqH2Tkif94bqxKVJaR9u+IpFGNRIrD84YAk76LQcaIwmFisyhMHBl849Bu5GIkrIJicw245G5Hk
        32O3Z/edQ76y09Gt8vpP/2qfD8yuePIx6YXssIBBSNCrVWaJp+6XVWHFPou3IEUq7EX5CG52hFaa6
        ZbZF7G+ZMv4TOc5cFxMUdol5OGRtlCjN1Xv4ooCDjnNA0cjkQdLZWU9NulqW1I0+sSXB2aiOMrS7l
        SnxZHdrg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55374)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mgN8q-0008Oe-6Y; Fri, 29 Oct 2021 09:21:37 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mgN8p-0001So-6W; Fri, 29 Oct 2021 09:21:35 +0100
Date:   Fri, 29 Oct 2021 09:21:35 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, olteanv@gmail.com,
        robh+dt@kernel.org, UNGLinuxDriver@microchip.com,
        Woojung.Huh@microchip.com, hkallweit1@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v6 net-next 06/10] net: dsa: microchip: add support for
 phylink management
Message-ID: <YXuvD2PJukHqytHe@shell.armlinux.org.uk>
References: <20211029052256.144739-1-prasanna.vengateshan@microchip.com>
 <20211029052256.144739-7-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211029052256.144739-7-prasanna.vengateshan@microchip.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Sorry for missing this.

The use of bitmap_foo() seems to have not been commented on, which
are now unnecessary as linkmode_foo() helpers were added in
b31cdffa2329 ("net: phy: Move linkmode helpers to somewhere public").

On Fri, Oct 29, 2021 at 10:52:52AM +0530, Prasanna Vengateshan wrote:
> +static void lan937x_phylink_validate(struct dsa_switch *ds, int port,
> +				     unsigned long *supported,
> +				     struct phylink_link_state *state)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> +
> +	/* Check for unsupported interfaces */
> +	if (!phy_interface_mode_is_rgmii(state->interface) &&
> +	    state->interface != PHY_INTERFACE_MODE_RMII &&
> +	    state->interface != PHY_INTERFACE_MODE_MII &&
> +	    state->interface != PHY_INTERFACE_MODE_NA &&
> +	    state->interface != PHY_INTERFACE_MODE_INTERNAL) {
> +		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);

		linkmode_zero(supported);

...
> +
> +	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
> +	bitmap_and(state->advertising, state->advertising, mask,
> +		   __ETHTOOL_LINK_MODE_MASK_NBITS);

	linkmode_and(supported, supported, mask);
	linkmode_and(state->advertising, state->advertising, mask);

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
