Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F571C5F2F
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 19:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730243AbgEERrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 13:47:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43266 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729315AbgEERrU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 13:47:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+R73Z4jVWXCfBPkWr/ITaVNISegdk9AM0hchGPNJ8Sc=; b=qQ2MvF5uTgTfl+Fohrz1RdJXhA
        jbKJkUtbz4bOmvpVN6BZvX4xrqBf8368xqyVXN9pj3mu5y6CHTKEBzV8hYeZQXFyuM0lhfILWQiWn
        7tQckNZ3aDVY5LOkHKjulgNx5/2306VdzhHpCgzN29KlMn4zb+v52g8MZafJrHKY0UOw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jW1ev-000y9n-Ug; Tue, 05 May 2020 19:47:09 +0200
Date:   Tue, 5 May 2020 19:47:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@openwrt.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 06/11] net: ethernet: mtk-eth-mac: new driver
Message-ID: <20200505174709.GD224913@lunn.ch>
References: <20200505140231.16600-1-brgl@bgdev.pl>
 <20200505140231.16600-7-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505140231.16600-7-brgl@bgdev.pl>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static struct net_device *mtk_mac_get_netdev(struct mtk_mac_priv *priv)
> +{
> +	char *ptr = (char *)priv;
> +
> +	return (struct net_device *)(ptr - ALIGN(sizeof(struct net_device),
> +						 NETDEV_ALIGN));
> +}

Bit of an odd way to do it. It is much more normal to just have

    return priv->netdev;

> +static struct sk_buff *mtk_mac_alloc_skb(struct net_device *ndev)
> +{
> +	uintptr_t tail, offset;
> +	struct sk_buff *skb;
> +
> +	skb = dev_alloc_skb(MTK_MAC_MAX_FRAME_SIZE);
> +	if (!skb)
> +		return NULL;
> +
> +	/* Align to 16 bytes. */
> +	tail = (uintptr_t)skb_tail_pointer(skb);
> +	if (tail & (MTK_MAC_SKB_ALIGNMENT - 1)) {
> +		offset = tail & (MTK_MAC_SKB_ALIGNMENT - 1);
> +		skb_reserve(skb, MTK_MAC_SKB_ALIGNMENT - offset);
> +	}
> +
> +	/* Ensure 16-byte alignment of the skb pointer: eth_type_trans() will
> +	 * extract the Ethernet header (14 bytes) so we need two more bytes.
> +	 */
> +	skb_reserve(skb, 2);

NET_IP_ALIGN

There might also be something in skbuf.h which will do your 16 byte
alignment for you.

> +static int mtk_mac_enable(struct net_device *ndev)
> +{
> +	struct mtk_mac_priv *priv = netdev_priv(ndev);
> +	unsigned int val;
> +	int ret;
> +
> +	mtk_mac_nic_disable_pd(priv);
> +	mtk_mac_intr_mask_all(priv);
> +	mtk_mac_dma_stop(priv);
> +	netif_carrier_off(ndev);

Attaching the PHY will turn the carrier off.  If you are using phylib
correctly, you should not have to touch the carrier status, phylib
will do it for you.

> +	/* Configure flow control */
> +	val = MTK_MAC_VAL_FC_CFG_SEND_PAUSE_TH_2K;
> +	val <<= MTK_MAC_OFF_FC_CFG_SEND_PAUSE_TH;
> +	val |= MTK_MAC_BIT_FC_CFG_BP_EN;
> +	val |= MTK_MAC_BIT_FC_CFG_UC_PAUSE_DIR;
> +	regmap_write(priv->regs, MTK_MAC_REG_FC_CFG, val);
> +
> +	/* Set SEND_PAUSE_RLS to 1K */
> +	val = MTK_MAC_VAL_EXT_CFG_SND_PAUSE_RLS_1K;
> +	val <<= MTK_MAC_OFF_EXT_CFG_SND_PAUSE_RLS;
> +	regmap_write(priv->regs, MTK_MAC_REG_EXT_CFG, val);

Pause is something this is auto-negotiated. You should be setting this
in your link change notifier which phylib will call when the link goes
up.

> +static int mtk_mac_mdio_rwok_wait(struct mtk_mac_priv *priv)
> +{
> +	unsigned long start = jiffies;
> +	unsigned int val;
> +
> +	for (;;) {
> +		regmap_read(priv->regs, MTK_MAC_REG_PHY_CTRL0, &val);
> +		if (val & MTK_MAC_BIT_PHY_CTRL0_RWOK)
> +			break;
> +
> +		udelay(10);
> +		if (time_after(jiffies, start + MTK_MAC_WAIT_TIMEOUT))
> +			return -ETIMEDOUT;
> +	}

regmap_read_poll_timeout() ?

> +static int mtk_mac_mdio_read(struct mii_bus *mii, int phy_id, int regnum)
> +{
> +	struct mtk_mac_priv *priv = mii->priv;
> +	unsigned int val, data;
> +	int ret;

It would be good if here and in _write() you check for C45 addresses
and return -EOPNOTSUP.

> +
> +	mtk_mac_mdio_rwok_clear(priv);
> +
> +	val = (regnum << MTK_MAC_OFF_PHY_CTRL0_PREG);
> +	val &= MTK_MAC_MSK_PHY_CTRL0_PREG;
> +	val |= MTK_MAC_BIT_PHY_CTRL0_RDCMD;
> +
> +	regmap_write(priv->regs, MTK_MAC_REG_PHY_CTRL0, val);
> +
> +	ret = mtk_mac_mdio_rwok_wait(priv);
> +	if (ret)
> +		return ret;
> +
> +	regmap_read(priv->regs, MTK_MAC_REG_PHY_CTRL0, &data);
> +
> +	data &= MTK_MAC_MSK_PHY_CTRL0_RWDATA;
> +	data >>= MTK_MAC_OFF_PHY_CTRL0_RWDATA;
> +
> +	return data;
> +}

> +static int mtk_mac_mdio_init(struct net_device *ndev)
> +{
> +	struct mtk_mac_priv *priv = netdev_priv(ndev);
> +	struct device *dev = mtk_mac_get_dev(priv);
> +	struct device_node *of_node, *mdio_node;
> +	int ret;
> +
> +	of_node = dev->of_node;
> +
> +	mdio_node = of_get_child_by_name(of_node, "mdio");
> +	if (!mdio_node)
> +		return -ENODEV;
> +
> +	if (!of_device_is_available(mdio_node)) {
> +		ret = -ENODEV;
> +		goto out_put_node;
> +	}
> +
> +	priv->mii = devm_mdiobus_alloc(dev);
> +	if (!priv->mii) {
> +		ret = -ENOMEM;
> +		goto out_put_node;
> +	}
> +
> +	snprintf(priv->mii->id, MII_BUS_ID_SIZE, "%s", dev_name(dev));
> +	priv->mii->name = "mdio";

It is normal to include something like 'MTK' in the name.

> +	priv->mii->parent = dev;
> +	priv->mii->read = mtk_mac_mdio_read;
> +	priv->mii->write = mtk_mac_mdio_write;
> +	priv->mii->priv = priv;
> +
> +	ret = of_mdiobus_register(priv->mii, mdio_node);
> +
> +out_put_node:
> +	of_node_put(mdio_node);
> +	return ret;
> +}

  Andrew
