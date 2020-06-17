Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 371D51FCB79
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 12:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbgFQKzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 06:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgFQKzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 06:55:32 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7602FC061573
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 03:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=KtF7AHwx+IWjHeMNIIoYJUSw5kkF6TtU7N5IVTw4PmQ=; b=ERBCM48Nxul+mEUwO3o2Vdpqd
        e/lt3DWi96iiW6MiXKNzQ0B/gtX58paP1c+DC5gSW6AzYx66+7I34o1PwmGuASM/2e3Is79WM0OnE
        g/b870l7bGSomDyKAHhZIxQS7mLtgSoQzMCYoxmgqsLWYAPhZiz303xxgVAPzcuzd+cLYnHpAoblZ
        Y1n+SIo8M/gThlCBhhJoKYYOS0TVOxM4JVB+3WAyRQDNnPc2MxyxHOXV9HFRcq3MUartnn4Hxvazy
        Sb+q0MbvJ4FhzsKSL3MmcyaZ+rwZv6ZMhGrdm3k8o6s9siEbCJgse9QCXjJJqRnCoI1nv3f7PQ7lG
        sBGDdxT5A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58442)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jlVj0-0003dJ-3V; Wed, 17 Jun 2020 11:55:22 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jlViw-0003fF-Df; Wed, 17 Jun 2020 11:55:18 +0100
Date:   Wed, 17 Jun 2020 11:55:18 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Helmut Grohne <helmut.grohne@intenta.de>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: macb: reject unsupported rgmii delays
Message-ID: <20200617105518.GO1551@shell.armlinux.org.uk>
References: <20200616074955.GA9092@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200616074955.GA9092@laureti-dev>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 09:49:56AM +0200, Helmut Grohne wrote:
> The macb driver does not support configuring rgmii delays. At least for
> the Zynq GEM, delays are not supported by the hardware at all. However,
> the driver happily accepts and ignores any such delays.
> 
> When operating in a mac to phy connection, the delay setting applies to
> the phy. Since the MAC does not support delays, the phy must provide
> them and the only supported mode is rgmii-id.  However, in a fixed mac
> to mac connection, the delay applies to the mac itself. Therefore the
> only supported rgmii mode is rgmii.

This seems incorrect - see the phy documentation in
Documentation/networking/phy.rst:

* PHY_INTERFACE_MODE_RGMII: the PHY is not responsible for inserting any
  internal delay by itself, it assumes that either the Ethernet MAC (if capable
  or the PCB traces) insert the correct 1.5-2ns delay

* PHY_INTERFACE_MODE_RGMII_TXID: the PHY should insert an internal delay
  for the transmit data lines (TXD[3:0]) processed by the PHY device

* PHY_INTERFACE_MODE_RGMII_RXID: the PHY should insert an internal delay
  for the receive data lines (RXD[3:0]) processed by the PHY device

* PHY_INTERFACE_MODE_RGMII_ID: the PHY should insert internal delays for
  both transmit AND receive data lines from/to the PHY device

Note that PHY_INTERFACE_MODE_RGMII, the delay can be added by _either_
the MAC or by PCB trace routing.

The individual RGMII delay modes are more about what the PHY itself is
asked to do with respect to inserting delays, so I don't think your
patch makes sense.

In any case...

> Link: https://lore.kernel.org/netdev/20200610081236.GA31659@laureti-dev/
> Signed-off-by: Helmut Grohne <helmut.grohne@intenta.de>
> ---
>  drivers/net/ethernet/cadence/macb_main.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 5b9d7c60eebc..bee5bf65e8b3 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -514,7 +514,7 @@ static void macb_validate(struct phylink_config *config,
>  	    state->interface != PHY_INTERFACE_MODE_RMII &&
>  	    state->interface != PHY_INTERFACE_MODE_GMII &&
>  	    state->interface != PHY_INTERFACE_MODE_SGMII &&
> -	    !phy_interface_mode_is_rgmii(state->interface)) {
> +	    state->interface != PHY_INTERFACE_MODE_RGMII_ID) {

Here you reject everything except PHY_INTERFACE_MODE_RGMII_ID.

>  		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
>  		return;
>  	}
> @@ -694,6 +694,13 @@ static int macb_phylink_connect(struct macb *bp)
>  	struct phy_device *phydev;
>  	int ret;
>  
> +	if (of_phy_is_fixed_link(dn) &&
> +	    phy_interface_mode_is_rgmii(bp->phy_interface) &&
> +	    bp->phy_interface != PHY_INTERFACE_MODE_RGMII) {

but here you reject everything except PHY_INTERFACE_MODE_RGMII.  These
can't both be right.  If you start with PHY_INTERFACE_MODE_RGMII, and
have a fixed link, you'll have PHY_INTERFACE_MODE_RGMII passed into
the validate function, which will then fail.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
