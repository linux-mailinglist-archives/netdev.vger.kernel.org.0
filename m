Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFCB581BD8
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 23:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbiGZV4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 17:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiGZV4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 17:56:00 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D75120A6;
        Tue, 26 Jul 2022 14:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=QXD2A6Ajbfm76chMd9c4TBy9DlwseOktOgWogUlrNA8=; b=i5aEiOAU8BWsotX7540rUmdihL
        Peq0blapeK7KZ+3sR+Vy7ckT8eWD5VpFqTtnWKJTtQ3jFQssyKazoEssbBYpywQIfkgNA96DVQ5eJ
        TArZ5Se5kusKs2F9I+zIc0PsSx43doItVBzXypyu+WmVTCojiQJsYmeXrwME4bgVT2QM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oGSWZ-00BbIl-Ia; Tue, 26 Jul 2022 23:55:31 +0200
Date:   Tue, 26 Jul 2022 23:55:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     alexandru.tachici@analog.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, devicetree@vger.kernel.org,
        krzysztof.kozlowski+dt@linaro.org, gerhard@engleder-embedded.com,
        geert+renesas@glider.be, joel@jms.id.au, stefan.wahren@i2se.com,
        wellslutw@gmail.com, geert@linux-m68k.org, robh+dt@kernel.org,
        d.michailidis@fungible.com, stephen@networkplumber.org,
        l.stelmach@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [net-next v2 2/3] net: ethernet: adi: Add ADIN1110 support
Message-ID: <YuBi0+wJBlqBPhKn@lunn.ch>
References: <20220725165312.59471-1-alexandru.tachici@analog.com>
 <20220725165312.59471-3-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220725165312.59471-3-alexandru.tachici@analog.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int adin1110_set_mac_address(struct net_device *netdev, const unsigned char *dev_addr)
> +{
> +	struct adin1110_port_priv *port_priv = netdev_priv(netdev);
> +	u8 mask[ETH_ALEN];
> +
> +	if (!is_valid_ether_addr(dev_addr))
> +		return -EADDRNOTAVAIL;
> +
> +	eth_hw_addr_set(netdev, dev_addr);
> +	memset(mask, 0xFF, ETH_ALEN);
> +
> +	return adin1110_write_mac_address(port_priv, ADIN_MAC_ADDR_SLOT, netdev->dev_addr, mask);

It looks like you have one slot for this? But two interfaces? So if
you change it on one, you actually change it for both? I would say
this needs handling better, either two slots, or refuse to allow it to
be changed.

> +static int adin1110_ioctl(struct net_device *netdev, struct ifreq *rq, int cmd)
> +{
> +	if (!netif_running(netdev))
> +		return -EINVAL;
> +
> +	if (!netdev->phydev)
> +		return -ENODEV;
> +
> +	return phy_mii_ioctl(netdev->phydev, rq, cmd);

phy_do_ioctl()

> +static int adin1110_probe_netdevs(struct adin1110_priv *priv)
> +{
> +	struct device *dev = &priv->spidev->dev;
> +	struct adin1110_port_priv *port_priv;
> +	struct net_device *netdev;
> +	int ret;
> +	int i;
> +
> +	for (i = 0; i < priv->cfg->ports_nr; i++) {
> +		netdev = devm_alloc_etherdev(dev, sizeof(*port_priv));
> +		if (!netdev)
> +			return -ENOMEM;
> +
> +		port_priv = netdev_priv(netdev);
> +		port_priv->netdev = netdev;
> +		port_priv->priv = priv;
> +		port_priv->cfg = priv->cfg;
> +		port_priv->nr = i;
> +		priv->ports[i] = port_priv;
> +		SET_NETDEV_DEV(netdev, dev);
> +
> +		ret = device_get_ethdev_address(dev, netdev);
> +		if (ret < 0)
> +			return ret;
> +
> +		netdev->irq = priv->spidev->irq;
> +		INIT_WORK(&port_priv->tx_work, adin1110_tx_work);
> +		INIT_WORK(&port_priv->rx_mode_work, adin1110_rx_mode_work);
> +		skb_queue_head_init(&port_priv->txq);
> +
> +		netif_carrier_off(netdev);
> +
> +		netdev->if_port = IF_PORT_10BASET;
> +		netdev->netdev_ops = &adin1110_netdev_ops;
> +		netdev->ethtool_ops = &adin1110_ethtool_ops;
> +		netdev->priv_flags |= IFF_UNICAST_FLT;
> +		netdev->features |= NETIF_F_NETNS_LOCAL;
> +
> +		ret = devm_register_netdev(dev, netdev);
> +		if (ret < 0) {
> +			dev_err(dev, "failed to register network device\n");
> +			return ret;
> +		}

At this point, the device is live. If you are using NFS root for
example, the kernel will try mounting the rootfs before this even
returns. So you need to ensure your netdev is functional at this
point. Anything which happens afterwards needs to be optional, not
cause an OOPS if missing etc.

> +
> +		port_priv->phydev = get_phy_device(priv->mii_bus, i + 1, false);
> +		if (!port_priv->phydev) {
> +			netdev_err(netdev, "Could not find PHY with device address: %d.\n", i);
> +			return -ENODEV;
> +		}
> +
> +		port_priv->phydev = phy_connect(netdev, phydev_name(port_priv->phydev),
> +						adin1110_adjust_link, PHY_INTERFACE_MODE_INTERNAL);
> +		if (IS_ERR(port_priv->phydev)) {
> +			netdev_err(netdev, "Could not connect PHY with device address: %d.\n", i);
> +			return PTR_ERR(port_priv->phydev);
> +		}
> +
> +		ret = devm_add_action_or_reset(dev, adin1110_disconnect_phy, port_priv->phydev);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	/* ADIN1110 INT_N pin will be used to signal the host */
> +	ret = devm_request_threaded_irq(dev, priv->spidev->irq, NULL, adin1110_irq,
> +					IRQF_TRIGGER_LOW | IRQF_ONESHOT, dev_name(dev), priv);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = register_netdevice_notifier(&adin1110_netdevice_nb);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = register_switchdev_blocking_notifier(&adin1110_switchdev_blocking_notifier);
> +	if (ret < 0) {
> +		unregister_netdevice_notifier(&adin1110_netdevice_nb);
> +		return ret;
> +	}
> +
> +	return devm_add_action_or_reset(dev, adin1110_unregister_notifiers, NULL);
> +}
