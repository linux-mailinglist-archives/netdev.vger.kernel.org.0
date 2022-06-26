Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05FA255B0FC
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 12:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234029AbiFZKBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 06:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbiFZKBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 06:01:32 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF52EE0F2;
        Sun, 26 Jun 2022 03:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=UfNTsZDFBTUHvbQvIabx1RTUSyCNhgNOnFpow90ezV8=; b=ApuS05K2hw2k7iHbZR3ws9vEJY
        ODKxeRnjTwP7f3sW+urtFGH/4RpWLCG5JgAcBaTPJ0qq0uKgwwfTPMxfykMWI5sAGO0Qu+IF7MX6P
        Ck78bWe5j2wNwBIrbvC2bjkA6lAPUJJEx9/VbVf1bn85FMmfyh9M3H/Mypi0Hl0rxflQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o5P4m-008Hf9-TE; Sun, 26 Jun 2022 12:01:08 +0200
Date:   Sun, 26 Jun 2022 12:01:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     alexandru.tachici@analog.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, devicetree@vger.kernel.org,
        krzysztof.kozlowski+dt@linaro.org, gerhard@engleder-embedded.com,
        geert+renesas@glider.be, joel@jms.id.au, stefan.wahren@i2se.com,
        wellslutw@gmail.com, geert@linux-m68k.org, robh+dt@kernel.org,
        d.michailidis@fungible.com, stephen@networkplumber.org,
        l.stelmach@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [net-next 1/2] net: ethernet: adi: Add ADIN1110 support
Message-ID: <YrguZPrrHA77Tx25@lunn.ch>
References: <20220624200628.77047-1-alexandru.tachici@analog.com>
 <20220624200628.77047-2-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220624200628.77047-2-alexandru.tachici@analog.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void adin1110_read_frames(struct adin1110_port_priv *port_priv)
> +{
> +	struct adin1110_priv *priv = port_priv->priv;
> +	u32 status1;
> +	int ret;
> +
> +	while (1) {
> +		ret = adin1110_read_reg(priv, ADIN1110_STATUS1, &status1);
> +		if (ret < 0)
> +			return;
> +
> +		if (!adin1110_port_rx_ready(port_priv, status1))
> +			break;
> +
> +		ret = adin1110_read_fifo(port_priv);
> +		if (ret < 0)
> +			return;
> +	}

Not sure an endless loop is a good idea here. I assume your SPI bus is
slower than your two Ethernet interfaces. So somebody could DOS the
machine by sending ethernet at line rate, and this function would
never exit? NAPI has the concept of a budget. You only every receive
up to 64 frames at once.

> +static int adin1110_set_mac_address(struct net_device *netdev, void *addr)
> +{
> +	struct adin1110_port_priv *port_priv = netdev_priv(netdev);
> +	struct sockaddr *sa = addr;
> +	u8 mask[ETH_ALEN];
> +
> +	if (netif_running(netdev))
> +		return -EBUSY;
> +
> +	if (!is_valid_ether_addr(sa->sa_data))
> +		return -EADDRNOTAVAIL;
> +
> +	eth_hw_addr_set(netdev, sa->sa_data);
> +	memset(mask, 0xFF, ETH_ALEN);
> +
> +	return adin1110_write_mac_address(port_priv, ADIN_MAC_ADDR_SLOT, netdev->dev_addr, mask);
> +}

So there is a function to set an entry for Multicast, another for its
own MAC address? Does it need entries for broadcast? What about STP
bridge PDUs?

> +static void adin1110_rx_mode_work(struct work_struct *work)
> +{
> +	struct adin1110_port_priv *port_priv = container_of(work, struct adin1110_port_priv, rx_mode_work);
> +	struct adin1110_priv *priv = port_priv->priv;
> +	u32 mask;
> +
> +	if (!port_priv->nr)
> +		mask = ADIN1110_FWD_UNK2HOST;
> +	else
> +		mask = ADIN2111_P2_FWD_UNK2HOST;
> +
> +	mutex_lock(&priv->lock);
> +
> +	/* Bridge core sets IFF_PROMISC on all interfaces and all frames would be
> +	 * forwarded to the CPU over SPI. Allow this only on the single port MAC.
> +	 */

That is a bit of an over-simplification. But it is not clear to me yet
if this hardware can do it all correct, so this is a good start.

> +static int adin1110_init_mac(struct adin1110_port_priv *port_priv)
> +{
> +	struct net_device *netdev = port_priv->netdev;
> +	u8 mask[ETH_ALEN];
> +	u8 mac[ETH_ALEN];
> +	int ret;
> +
> +	memset(mask, 0xFF, ETH_ALEN);
> +	ret = adin1110_write_mac_address(port_priv, ADIN_MAC_ADDR_SLOT, netdev->dev_addr, mask);
> +	if (ret < 0) {
> +		netdev_err(netdev, "Could not set MAC address: %pM, %d\n", mac, ret);
> +		return ret;
> +	}

Better to call adin1110_set_mac_address()

> +
> +	memset(mac, 0xFF, ETH_ALEN);
> +	ret = adin1110_write_mac_address(port_priv, ADIN_MAC_BROADCAST_ADDR_SLOT, mac, mask);
> +	if (ret < 0) {
> +		netdev_err(netdev, "Could not set Broadcast MAC address: %d\n", ret);
> +		return ret;
> +	}

And i would suggest a little helper for this as well.

This partially answers my question above. But so far, i see no STP
support?

> +static int adin1110_net_open(struct net_device *net_dev)
> +{
> +	struct adin1110_port_priv *port_priv = netdev_priv(net_dev);
> +	struct adin1110_priv *priv = port_priv->priv;
> +	u32 val;
> +	int ret;
> +
> +	mutex_lock(&priv->lock);
> +
> +	/* Configure MAC to compute and append the FCS itself. */
> +	ret = adin1110_set_bits(priv, ADIN1110_CONFIG2, ADIN1110_CRC_APPEND, ADIN1110_CRC_APPEND);
> +	if (ret < 0) {
> +		mutex_unlock(&priv->lock);
> +		return ret;
> +	}
> +
> +	val = ADIN1110_TX_RDY_IRQ | ADIN1110_RX_RDY_IRQ | ADIN1110_SPI_ERR_IRQ;
> +	if (priv->cfg->id == ADIN2111_MAC)
> +		val |= ADIN2111_RX_RDY_IRQ;
> +
> +	priv->irq_mask = val;
> +	ret = adin1110_write_reg(priv, ADIN1110_IMASK1, ~val);
> +	if (ret < 0) {
> +		netdev_err(net_dev, "Failed to enable chip IRQs: %d\n", ret);
> +		mutex_unlock(&priv->lock);
> +		return ret;
> +	}

Rather than have all these 
		mutex_unlock(&priv->lock);
+		return ret;

it is better to have
                goto out;

out:
		mutex_unlock(&priv->lock);
		return ret;

You are less likely to miss an unlock. Please do this everywhere.

> +void adin1110_ndo_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *storage)
> +{
> +	struct adin1110_port_priv *port_priv = netdev_priv(dev);
> +	struct adin1110_priv *priv = port_priv->priv;
> +	u32 val;
> +
> +	mutex_lock(&priv->lock);

I really should remember this, since it keeps coming up again and
again. I think this gets called in a context which does not allow
blocking.

> +static void adin1110_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *di)
> +{
> +	strscpy(di->driver, "ADIN1110", sizeof(di->driver));
> +	strscpy(di->version, "1.00", sizeof(di->version));

No version information please, it is meaningless. The core will fill
in the kernel version, which at least is a little bit useful.

> +static int adin1110_hw_forwarding(struct adin1110_priv *priv, bool enable)
> +{
> +	int mac_nr;
> +	int ret;
> +
> +	mutex_lock(&priv->lock);
> +
> +	/* Configure MAC to forward unknown host to other port. */

Does unknown also go to the CPU? You need the software bridge to see
such frames, it might know where they go, e.g. over a VPN, out some
other Ethernet interface etc.

> +	ret = adin1110_set_bits(priv, ADIN1110_CONFIG2, ADIN2111_FWD_UNK2PORT,
> +				enable ? ADIN2111_FWD_UNK2PORT : 0);
> +	if (ret < 0) {
> +		mutex_unlock(&priv->lock);
> +		return ret;
> +	}
> +
> +	/* Broadcast and multicast should also be forwarded to the other port */

So it seems like there is no STP support. If your network has loops,
it will die in a broadcast storm. Is STP something you plan to add
later?

> +static int adin1110_port_bridge_join(struct adin1110_port_priv *port_priv,
> +				     struct net_device *bridge)
> +{
> +	struct adin1110_priv *priv = port_priv->priv;
> +	int ret = 0;
> +
> +	/* Having the same port belong to multiple bridges is not supported */
> +	if (port_priv->bridge && port_priv->bridge != bridge)
> +		return -EOPNOTSUPP;

That is always true, so i don't think you need to check this. If this
happens, something is broken in the core.

> +
> +	port_priv->bridge = bridge;
> +
> +	/* If other port joined same bridge, allow forwarding between ports */
> +	if (priv->ports[0]->bridge == priv->ports[1]->bridge)
> +		ret = adin1110_hw_forwarding(priv, true);
> +
> +	return ret;
> +}
> +

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
> +
> +		port_priv->phydev = get_phy_device(priv->mii_bus, i + 1, false);
> +		if (!port_priv->phydev) {
> +			netdev_err(netdev, "Could not find PHY with device address: %d.\n", i);
> +			return -ENODEV;
> +		}
> +
> +		port_priv->phydev = phy_connect(netdev, phydev_name(port_priv->phydev),
> +						adin1110_adjust_link, PHY_INTERFACE_MODE_MII);

That should probably be PHY_INTERFACE_MODE_INTERNAL.

     Andrew
