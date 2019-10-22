Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9325EDFA09
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 03:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730065AbfJVBGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 21:06:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56720 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727953AbfJVBGx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 21:06:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9KVvA1x4S+g3wS1s0DGWqMKbXR8Sju8g8bBYD34J2VU=; b=5px5GaoYa3xI4ZoQd31yTUVRs/
        hrTMIHi70oDHrCaPGWUK85s+QmCcxSnw3D7yW9kp1g2/ffSe+5APnRa7Vbslg/T9DBGdSkAAuaCd2
        4RjFqE7YVGdvsVlzPNFV47SfBxlD1fDQUgOHf/wIPHaGglL23WVHbsRHqdxy+U2YhEMQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iMidN-0007WH-T8; Tue, 22 Oct 2019 03:06:49 +0200
Date:   Tue, 22 Oct 2019 03:06:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        laurentiu.tudor@nxp.com, f.fainelli@gmail.com, rmk@armlinux.org.uk
Subject: Re: [PATCH net-next 3/4] dpaa2-eth: add MAC/PHY support through
 phylink
Message-ID: <20191022010649.GI16084@lunn.ch>
References: <1571698228-30985-1-git-send-email-ioana.ciornei@nxp.com>
 <1571698228-30985-4-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571698228-30985-4-git-send-email-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ioana

> +static int dpaa2_eth_connect_mac(struct dpaa2_eth_priv *priv)
> +{
> +	struct fsl_mc_device *dpni_dev, *dpmac_dev;
> +	struct dpaa2_mac *mac;
> +	int err;
> +
> +	dpni_dev = to_fsl_mc_device(priv->net_dev->dev.parent);
> +	dpmac_dev = fsl_mc_get_endpoint(dpni_dev);
> +	if (!dpmac_dev || dpmac_dev->dev.type != &fsl_mc_bus_dpmac_type)
> +		return 0;
> +
> +	if (dpaa2_mac_is_type_fixed(dpmac_dev, priv->mc_io))
> +		return 0;
> +
> +	mac = kzalloc(sizeof(struct dpaa2_mac), GFP_KERNEL);
> +	if (!mac)
> +		return -ENOMEM;
> +
> +	mac->mc_dev = dpmac_dev;
> +	mac->mc_io = priv->mc_io;
> +	mac->net_dev = priv->net_dev;
> +
> +	err = dpaa2_mac_connect(mac);
> +	if (err) {
> +		netdev_err(priv->net_dev, "Error connecting to the MAC endpoint\n");
> +		kfree(mac);
> +		return err;
> +	}
> +	priv->mac = mac;
> +
> +	return 0;
> +}
> +
> +static void dpaa2_eth_disconnect_mac(struct dpaa2_eth_priv *priv)
> +{
> +	if (!priv->mac)
> +		return;
> +
> +	rtnl_lock();
> +	dpaa2_mac_disconnect(priv->mac);
> +	kfree(priv->mac);
> +	priv->mac = NULL;
> +	rtnl_unlock();
> +}

dpaa2_eth_connect_mac() does not take the rtnl lock.
dpaa2_eth_disconnect_mac() does. This asymmetry makes me think
something is wrong. But it could be correct....

> +/* Caller must call of_node_put on the returned value */
> +static struct device_node *dpaa2_mac_get_node(u16 dpmac_id)
> +{
> +	struct device_node *dpmacs, *dpmac = NULL;
> +	u32 id;
> +	int err;
> +
> +	dpmacs = of_find_node_by_name(NULL, "dpmacs");
> +	if (!dpmacs)
> +		return NULL;
> +
> +	while ((dpmac = of_get_next_child(dpmacs, dpmac)) != NULL) {
> +		err = of_property_read_u32(dpmac, "reg", &id);
> +		if (err)
> +			continue;
> +		if (id == dpmac_id)
> +			break;
> +	}

of_get_next_child() takes a reference on the child. So you need to
release that reference. It is better to make use of something like
for_each_child_of_node() or for_each_available_child_of_node() which
release the reference at the end of each loop, so long as you don't
break/return out of the loop.

> +
> +static void dpaa2_mac_validate(struct phylink_config *config,
> +			       unsigned long *supported,
> +			       struct phylink_link_state *state)
> +{
> +	struct dpaa2_mac *mac = phylink_to_dpaa2_mac(config);
> +	struct dpmac_link_state *dpmac_state = &mac->state;
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> +
> +	if (state->interface != PHY_INTERFACE_MODE_NA &&
> +	    dpaa2_mac_phy_mode_mismatch(mac, state->interface)) {
> +		goto empty_set;
> +	}
> +
> +	phylink_set_port_modes(mask);
> +	phylink_set(mask, Autoneg);
> +	phylink_set(mask, Pause);
> +	phylink_set(mask, Asym_Pause);
> +
> +	switch (state->interface) {
> +	case PHY_INTERFACE_MODE_RGMII:
> +	case PHY_INTERFACE_MODE_RGMII_ID:
> +	case PHY_INTERFACE_MODE_RGMII_RXID:
> +	case PHY_INTERFACE_MODE_RGMII_TXID:
> +		phylink_set(mask, 10baseT_Full);
> +		phylink_set(mask, 100baseT_Full);
> +		phylink_set(mask, 1000baseT_Full);
> +		break;
> +	default:
> +		goto empty_set;
> +	}
> +
> +	linkmode_and(supported, supported, mask);
> +	linkmode_and(state->advertising, state->advertising, mask);
> +
> +	dpaa2_mac_linkmode2dpmac(supported, &dpmac_state->supported);
> +	dpaa2_mac_linkmode2dpmac(state->advertising, &dpmac_state->advertising);

Humm. Not sure about these last two lines. Validate should be about if
the MAC can support something. I don't think you should be setting any
state here. That should happen in mac_config, when the state really is
configured.

> +
> +	return;
> +
> +empty_set:
> +	linkmode_zero(supported);
> +}
> +

  Andrew
