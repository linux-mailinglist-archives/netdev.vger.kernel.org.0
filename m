Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5201AFFAA7
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 17:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfKQQN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 11:13:59 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:49892 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfKQQN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 11:13:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=64w8HUjkoTiWexi14yN9fjSNg8vl1XwgYvtTqWXMRYw=; b=Z4HpJ7z50O4f6WobbNh7UcEBQ
        TCCrQL96mX5e//+lAAaaLPYWaAHZQezqhOe64FDAfakD8q3O90lwhFWewTILsVm1bvXqHNviDEpyM
        9VI5crNVA4PiLq9hyQmPFoDluJPLx9hsG00l3fYm0e1264CP8+iH1zK2evVIAOTdwZIzrs3/gxCEn
        vbIdPLORP1LEz0u7IXwf1YrIURxUQUk3P4UGVI8nW310g3WUf2Sm6BZiEKyejTnh57REqRbPHuvMO
        7XDNLisaRFa5BrtGr0wYNFZco56wRkpQTp6wE4n2FzU55GkgZ9oKQgGUhv0jpTulrLFWya+i+3IEJ
        +1kFk72lw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:40894)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iWNBR-0006Eb-IK; Sun, 17 Nov 2019 16:13:53 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iWNBP-0007Le-4j; Sun, 17 Nov 2019 16:13:51 +0000
Date:   Sun, 17 Nov 2019 16:13:51 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        laurentiu.tudor@nxp.com, andrew@lunn.ch, f.fainelli@gmail.com
Subject: Re: [PATCH net-next v4 4/5] dpaa2-eth: add MAC/PHY support through
 phylink
Message-ID: <20191117161351.GH1344@shell.armlinux.org.uk>
References: <1572477512-4618-1-git-send-email-ioana.ciornei@nxp.com>
 <1572477512-4618-5-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1572477512-4618-5-git-send-email-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 01:18:31AM +0200, Ioana Ciornei wrote:
> The dpaa2-eth driver now has support for connecting to its associated
> PHY device found through standard OF bindings.
> 
> This happens when the DPNI object (that the driver probes on) gets
> connected to a DPMAC. When that happens, the device tree is looked up by
> the DPMAC ID, and the associated PHY bindings are found.
> 
> The old logic of handling the net device's link state by hand still
> needs to be kept, as the DPNI can be connected to other devices on the
> bus than a DPMAC: other DPNI, DPSW ports, etc. This logic is only
> engaged when there is no DPMAC (and therefore no phylink instance)
> attached.
> 
> The MC firmware support multiple type of DPMAC links: TYPE_FIXED,
> TYPE_PHY. The TYPE_FIXED mode does not require any DPMAC management from
> Linux side, and as such, the driver will not handle such a DPMAC.
> 
> Although PHYLINK typically handles SFP cages and in-band AN modes, for
> the moment the driver only supports the RGMII interfaces found on the
> LX2160A. Support for other modes will come later.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

...

> @@ -3363,6 +3425,13 @@ static irqreturn_t dpni_irq0_handler_thread(int irq_num, void *arg)
>  	if (status & DPNI_IRQ_EVENT_ENDPOINT_CHANGED) {
>  		set_mac_addr(netdev_priv(net_dev));
>  		update_tx_fqids(priv);
> +
> +		rtnl_lock();
> +		if (priv->mac)
> +			dpaa2_eth_disconnect_mac(priv);
> +		else
> +			dpaa2_eth_connect_mac(priv);
> +		rtnl_unlock();

Sorry, but this locking is deadlock prone.

You're taking rtnl_lock().
dpaa2_eth_connect_mac() calls dpaa2_mac_connect().
dpaa2_mac_connect() calls phylink_create().
phylink_create() calls phylink_register_sfp().
phylink_register_sfp() calls sfp_bus_add_upstream().
sfp_bus_add_upstream() calls rtnl_lock() *** DEADLOCK ***.

Neither phylink_create() nor phylink_destroy() may be called holding
the rtnl lock.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
