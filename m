Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E25A74D3923
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 19:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235192AbiCISrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 13:47:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbiCISrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 13:47:35 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32619C73;
        Wed,  9 Mar 2022 10:46:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jYNOrrhFwYjgYrOlgqQat5/1gyh0XbIYmSvMg/1KoYU=; b=aVANFpGjYe41AjoMHPfOM5XipA
        SZPSGhqHq8gcIRbq7g851R+l0Vu+pPjT1SzneSOkHddCaABE9sSe7AIDzCZ9tQTahxKYZBeHVnqAb
        SuGxnepRu+H4zA7AC/zhN3bpD9Bs7i2BCmH8jmtQ+dQjGFqFsl4+Y16ggyzpe329CNu+wOg+Q5cAr
        LQGofl+D1PcojBYc8nKb4/UG7qX3sK/+j+5T3n9EzZ6+2FH7oQGJ4+1ue5laOnqp3eB+N4TFjmxHj
        K6MTRMT2907RQJhtgxV0P70m3u1gxt5sGIQ5sXnNnBQ2Cp2vjLO7wPclHq2U6PAT/xku//dKzkC6u
        vQITHyUg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57750)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nS1KP-0002O7-Jn; Wed, 09 Mar 2022 18:46:29 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nS1KM-0008Bi-Np; Wed, 09 Mar 2022 18:46:26 +0000
Date:   Wed, 9 Mar 2022 18:46:26 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, shawnguo@kernel.org,
        hongxing.zhu@nxp.com
Subject: Re: [PATCH net-next v2 7/8] dpaa2-mac: configure the SerDes phy on a
 protocol change
Message-ID: <Yij2AlJte0bG7eJr@shell.armlinux.org.uk>
References: <20220309172748.3460862-1-ioana.ciornei@nxp.com>
 <20220309172748.3460862-8-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220309172748.3460862-8-ioana.ciornei@nxp.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ioana,

On Wed, Mar 09, 2022 at 07:27:47PM +0200, Ioana Ciornei wrote:
> This patch integrates the dpaa2-eth driver with the generic PHY
> infrastructure in order to search, find and reconfigure the SerDes lanes
> in case of a protocol change.
> 
> On the .mac_config() callback, the phy_set_mode_ext() API is called so
> that the Lynx 28G SerDes PHY driver can change the lane's configuration.
> In the same phylink callback the MC firmware is called so that it
> reconfigures the MAC side to run using the new protocol.
> 
> The consumer drivers - dpaa2-eth and dpaa2-switch - are updated to call
> the dpaa2_mac_start/stop functions newly added which will
> power_on/power_off the associated SerDes lane.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
> Changes in v2:
> 	- none
> 
>  .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  5 +-
>  .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 91 +++++++++++++++++++
>  .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  |  6 ++
>  .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  5 +-
>  4 files changed, 105 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> index 939fa9db6a2e..b87369f0605f 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> @@ -2077,8 +2077,10 @@ static int dpaa2_eth_open(struct net_device *net_dev)
>  		goto enable_err;
>  	}
>  
> -	if (dpaa2_eth_is_type_phy(priv))
> +	if (dpaa2_eth_is_type_phy(priv)) {
>  		phylink_start(priv->mac->phylink);
> +		dpaa2_mac_start(priv->mac);

Is this safe? Shouldn't dpaa2_mac_start() come before phylink_start()
in case phylink determines that the link is somehow already up? I'm
a big fan of teardown being in the reverse order of setup so having
the start and stop below in the same order just doesn't look right.

> +	}
>  
>  	return 0;
>  
> @@ -2153,6 +2155,7 @@ static int dpaa2_eth_stop(struct net_device *net_dev)
>  
>  	if (dpaa2_eth_is_type_phy(priv)) {
>  		phylink_stop(priv->mac->phylink);
> +		dpaa2_mac_stop(priv->mac);
>  	} else {
>  		netif_tx_stop_all_queues(net_dev);
>  		netif_carrier_off(net_dev);
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> index e6e758eaafea..bd90acc49cdb 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> @@ -3,6 +3,7 @@
>  
>  #include <linux/acpi.h>
>  #include <linux/pcs-lynx.h>
> +#include <linux/phy/phy.h>
>  #include <linux/property.h>
>  
>  #include "dpaa2-eth.h"
> @@ -60,6 +61,26 @@ static int phy_mode(enum dpmac_eth_if eth_if, phy_interface_t *if_mode)
>  	return 0;
>  }
>  
> +static enum dpmac_eth_if dpmac_eth_if_mode(phy_interface_t if_mode)
> +{
> +	switch (if_mode) {
> +	case PHY_INTERFACE_MODE_RGMII:

Shouldn't this also include the other RGMII modes (which, from the MAC
point of view, are all synonymous?

> +		return DPMAC_ETH_IF_RGMII;
> +	case PHY_INTERFACE_MODE_USXGMII:
> +		return DPMAC_ETH_IF_USXGMII;
> +	case PHY_INTERFACE_MODE_QSGMII:
> +		return DPMAC_ETH_IF_QSGMII;
> +	case PHY_INTERFACE_MODE_SGMII:
> +		return DPMAC_ETH_IF_SGMII;
> +	case PHY_INTERFACE_MODE_10GBASER:
> +		return DPMAC_ETH_IF_XFI;
> +	case PHY_INTERFACE_MODE_1000BASEX:
> +		return DPMAC_ETH_IF_1000BASEX;
> +	default:
> +		return DPMAC_ETH_IF_MII;
> +	}
> +}
> +
>  static struct fwnode_handle *dpaa2_mac_get_node(struct device *dev,
>  						u16 dpmac_id)
>  {
> @@ -147,6 +168,19 @@ static void dpaa2_mac_config(struct phylink_config *config, unsigned int mode,
>  	if (err)
>  		netdev_err(mac->net_dev, "%s: dpmac_set_link_state() = %d\n",
>  			   __func__, err);
> +
> +	if (!mac->serdes_phy)
> +		return;
> +
> +	/* This happens only if we support changing of protocol at runtime */
> +	err = dpmac_set_protocol(mac->mc_io, 0, mac->mc_dev->mc_handle,
> +				 dpmac_eth_if_mode(state->interface));
> +	if (err)
> +		netdev_err(mac->net_dev,  "dpmac_set_protocol() = %d\n", err);
> +
> +	err = phy_set_mode_ext(mac->serdes_phy, PHY_MODE_ETHERNET, state->interface);
> +	if (err)
> +		netdev_err(mac->net_dev, "phy_set_mode_ext() = %d\n", err);
>  }
>  
>  static void dpaa2_mac_link_up(struct phylink_config *config,
> @@ -200,12 +234,21 @@ static void dpaa2_mac_link_down(struct phylink_config *config,
>  		netdev_err(mac->net_dev, "dpmac_set_link_state() = %d\n", err);
>  }
>  
> +static int dpaa2_mac_prepare(struct phylink_config *config, unsigned int mode,
> +			     phy_interface_t interface)
> +{
> +	dpaa2_mac_link_down(config, mode, interface);

You should never see a reconfiguration while the link is up. However,
if the link is in in-band mode, then obviously the link could come up
at any moment, and in that case, forcing it down in mac_prepare() is
a good idea - but that forcing needs to be removed in mac_finish()
to allow in-band to work again. Not sure that your firmware allows
that though, and I'm not convinced that calling the above function
achieves any of those guarantees.

> +
> +	return 0;
> +}
> +
>  static const struct phylink_mac_ops dpaa2_mac_phylink_ops = {
>  	.validate = phylink_generic_validate,
>  	.mac_select_pcs = dpaa2_mac_select_pcs,
>  	.mac_config = dpaa2_mac_config,
>  	.mac_link_up = dpaa2_mac_link_up,
>  	.mac_link_down = dpaa2_mac_link_down,
> +	.mac_prepare = dpaa2_mac_prepare,
>  };
>  
>  static int dpaa2_pcs_create(struct dpaa2_mac *mac,
> @@ -259,6 +302,8 @@ static void dpaa2_pcs_destroy(struct dpaa2_mac *mac)
>  
>  static void dpaa2_mac_set_supported_interfaces(struct dpaa2_mac *mac)
>  {
> +	int intf, err;
> +
>  	/* We support the current interface mode, and if we have a PCS
>  	 * similar interface modes that do not require the SerDes lane to be
>  	 * reconfigured.
> @@ -278,12 +323,40 @@ static void dpaa2_mac_set_supported_interfaces(struct dpaa2_mac *mac)
>  			break;
>  		}
>  	}
> +
> +	if (!mac->serdes_phy)
> +		return;
> +
> +	/* In case we have access to the SerDes phy/lane, then ask the SerDes
> +	 * driver what interfaces are supported based on the current PLL
> +	 * configuration.
> +	 */
> +	for (intf = 0; intf < PHY_INTERFACE_MODE_MAX; intf++) {

You probably want to avoid PHY_INTERFACE_MODE_NA here, even though your
driver may reject it anyway.

> +		err = phy_validate(mac->serdes_phy, PHY_MODE_ETHERNET, intf, NULL);
> +		if (err)
> +			continue;
> +
> +		__set_bit(intf, mac->phylink_config.supported_interfaces);
> +	}
> +}
> +
> +void dpaa2_mac_start(struct dpaa2_mac *mac)
> +{
> +	if (mac->serdes_phy)
> +		phy_power_on(mac->serdes_phy);
> +}
> +
> +void dpaa2_mac_stop(struct dpaa2_mac *mac)
> +{
> +	if (mac->serdes_phy)
> +		phy_power_off(mac->serdes_phy);
>  }
>  
>  int dpaa2_mac_connect(struct dpaa2_mac *mac)
>  {
>  	struct net_device *net_dev = mac->net_dev;
>  	struct fwnode_handle *dpmac_node;
> +	struct phy *serdes_phy = NULL;
>  	struct phylink *phylink;
>  	int err;
>  
> @@ -300,6 +373,22 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
>  		return -EINVAL;
>  	mac->if_mode = err;
>  
> +	if (mac->features & DPAA2_MAC_FEATURE_PROTOCOL_CHANGE &&
> +	    !phy_interface_mode_is_rgmii(mac->if_mode) &&
> +	    is_of_node(dpmac_node)) {
> +		serdes_phy = of_phy_get(to_of_node(dpmac_node), NULL);
> +
> +		if (IS_ERR(serdes_phy)) {
> +			if (PTR_ERR(serdes_phy) == -ENODEV)
> +				serdes_phy = NULL;
> +			else
> +				return PTR_ERR(serdes_phy);
> +		} else {
> +			phy_init(serdes_phy);
> +		}
> +	}
> +	mac->serdes_phy = serdes_phy;
> +
>  	/* The MAC does not have the capability to add RGMII delays so
>  	 * error out if the interface mode requests them and there is no PHY
>  	 * to act upon them
> @@ -363,6 +452,8 @@ void dpaa2_mac_disconnect(struct dpaa2_mac *mac)
>  	phylink_disconnect_phy(mac->phylink);
>  	phylink_destroy(mac->phylink);
>  	dpaa2_pcs_destroy(mac);
> +	of_phy_put(mac->serdes_phy);
> +	mac->serdes_phy = NULL;
>  }
>  
>  int dpaa2_mac_open(struct dpaa2_mac *mac)
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
> index d2e51d21c80c..a58cab188a99 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
> @@ -26,6 +26,8 @@ struct dpaa2_mac {
>  	enum dpmac_link_type if_link_type;
>  	struct phylink_pcs *pcs;
>  	struct fwnode_handle *fw_node;
> +
> +	struct phy *serdes_phy;
>  };
>  
>  bool dpaa2_mac_is_type_fixed(struct fsl_mc_device *dpmac_dev,
> @@ -45,4 +47,8 @@ void dpaa2_mac_get_strings(u8 *data);
>  
>  void dpaa2_mac_get_ethtool_stats(struct dpaa2_mac *mac, u64 *data);
>  
> +void dpaa2_mac_start(struct dpaa2_mac *mac);
> +
> +void dpaa2_mac_stop(struct dpaa2_mac *mac);
> +
>  #endif /* DPAA2_MAC_H */
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
> index 9a561072aa4a..e4f8f927e223 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
> @@ -703,8 +703,10 @@ static int dpaa2_switch_port_open(struct net_device *netdev)
>  
>  	dpaa2_switch_enable_ctrl_if_napi(ethsw);
>  
> -	if (dpaa2_switch_port_is_type_phy(port_priv))
> +	if (dpaa2_switch_port_is_type_phy(port_priv)) {
>  		phylink_start(port_priv->mac->phylink);
> +		dpaa2_mac_start(port_priv->mac);

Same comments as for dpaa2-mac.

> +	}
>  
>  	return 0;
>  }
> @@ -717,6 +719,7 @@ static int dpaa2_switch_port_stop(struct net_device *netdev)
>  
>  	if (dpaa2_switch_port_is_type_phy(port_priv)) {
>  		phylink_stop(port_priv->mac->phylink);
> +		dpaa2_mac_stop(port_priv->mac);
>  	} else {
>  		netif_tx_stop_all_queues(netdev);
>  		netif_carrier_off(netdev);
> -- 
> 2.33.1
> 
>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
