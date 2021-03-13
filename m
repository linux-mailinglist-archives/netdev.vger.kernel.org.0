Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF077339AAA
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 02:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbhCMBBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 20:01:52 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54986 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232348AbhCMBBf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 20:01:35 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lKsed-00AcPR-7B; Sat, 13 Mar 2021 02:01:19 +0100
Date:   Sat, 13 Mar 2021 02:01:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] net: ethernet: actions: Add Actions Semi Owl
 Ethernet MAC driver
Message-ID: <YEwO33TR7ENHuMaY@lunn.ch>
References: <cover.1615423279.git.cristian.ciocaltea@gmail.com>
 <158d63db7d17d87b01f723433e0ddc1fa24377a8.1615423279.git.cristian.ciocaltea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158d63db7d17d87b01f723433e0ddc1fa24377a8.1615423279.git.cristian.ciocaltea@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 03:20:13AM +0200, Cristian Ciocaltea wrote:
> +static inline void owl_emac_reg_set(struct owl_emac_priv *priv,
> +				    u32 reg, u32 bits)
> +{
> +	owl_emac_reg_update(priv, reg, bits, bits);
> +}

Hi Cristian

No inline functions in C files please. Let the compiler decide. Please
fix them all.

> +static struct sk_buff *owl_emac_alloc_skb(struct net_device *netdev)
> +{
> +	int offset;
> +	struct sk_buff *skb;

Reverse Christmas tree please.

> +
> +	skb = netdev_alloc_skb(netdev, OWL_EMAC_RX_FRAME_MAX_LEN +
> +			       OWL_EMAC_SKB_RESERVE);
> +	if (unlikely(!skb))
> +		return NULL;
> +
> +	/* Ensure 4 bytes DMA alignment. */
> +	offset = ((uintptr_t)skb->data) & (OWL_EMAC_SKB_ALIGN - 1);
> +	if (unlikely(offset))
> +		skb_reserve(skb, OWL_EMAC_SKB_ALIGN - offset);
> +
> +	return skb;
> +}
> +
> +static void owl_emac_phy_config(struct owl_emac_priv *priv)

You are not really configuring the PHY here, but configuring the MAC
with what the PHY tells you has been negotiated. So maybe change this
name?

> +{
> +	u32 val, status;
> +
> +	if (priv->pause) {
> +		val = OWL_EMAC_BIT_MAC_CSR20_FCE | OWL_EMAC_BIT_MAC_CSR20_TUE;
> +		val |= OWL_EMAC_BIT_MAC_CSR20_TPE | OWL_EMAC_BIT_MAC_CSR20_RPE;
> +		val |= OWL_EMAC_BIT_MAC_CSR20_BPE;
> +	} else {
> +		val = 0;
> +	}
> +
> +	/* Update flow control. */
> +	owl_emac_reg_write(priv, OWL_EMAC_REG_MAC_CSR20, val);
> +
> +	val = (priv->speed == SPEED_100) ? OWL_EMAC_VAL_MAC_CSR6_SPEED_100M :
> +					   OWL_EMAC_VAL_MAC_CSR6_SPEED_10M;
> +	val <<= OWL_EMAC_OFF_MAC_CSR6_SPEED;
> +
> +	if (priv->duplex == DUPLEX_FULL)
> +		val |= OWL_EMAC_BIT_MAC_CSR6_FD;
> +
> +	spin_lock_bh(&priv->lock);
> +
> +	/* Temporarily stop DMA TX & RX. */
> +	status = owl_emac_dma_cmd_stop(priv);
> +
> +	/* Update operation modes. */
> +	owl_emac_reg_update(priv, OWL_EMAC_REG_MAC_CSR6,
> +			    OWL_EMAC_MSK_MAC_CSR6_SPEED |
> +			    OWL_EMAC_BIT_MAC_CSR6_FD, val);
> +
> +	/* Restore DMA TX & RX status. */
> +	owl_emac_dma_cmd_set(priv, status);
> +
> +	spin_unlock_bh(&priv->lock);
> +}

> +static inline void owl_emac_ether_addr_push(u8 **dst, const u8 *src)
> +{
> +	u32 *a = (u32 *)(*dst);

Is *dst guaranteed to by 32bit aligned? Given that it is skb->data, i
don't think it is.

> +	const u16 *b = (const u16 *)src;
> +
> +	a[0] = b[0];
> +	a[1] = b[1];
> +	a[2] = b[2];

So i don't know if this is safe. Some architectures don't like doing
miss aligned read/writes. You probably should be using one of the
put_unaligned_() macros.

> +
> +	*dst += 12;
> +}
> +
> +static void
> +owl_emac_setup_frame_prepare(struct owl_emac_priv *priv, struct sk_buff *skb)
> +{
> +	const u8 bcast_addr[] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
> +	const u8 *mac_addr = priv->netdev->dev_addr;
> +	u8 *frame;
> +	int i;
> +
> +	skb_put(skb, OWL_EMAC_SETUP_FRAME_LEN);
> +
> +	frame = skb->data;
> +	memset(frame, 0, skb->len);
> +
> +	owl_emac_ether_addr_push(&frame, mac_addr);
> +	owl_emac_ether_addr_push(&frame, bcast_addr);
> +
> +	/* Fill multicast addresses. */
> +	WARN_ON(priv->mcaddr_list.count >= OWL_EMAC_MAX_MULTICAST_ADDRS);
> +	for (i = 0; i < priv->mcaddr_list.count; i++) {
> +		mac_addr = priv->mcaddr_list.addrs[i];
> +		owl_emac_ether_addr_push(&frame, mac_addr);
> +	}

Please could you add some comments to this. You are building a rather
odd frame here! What is it used form?

> +}
> +static int owl_emac_poll(struct napi_struct *napi, int budget)
> +{
> +	struct owl_emac_priv *priv;
> +	u32 status, proc_status;
> +	int work_done = 0, recv;
> +	static int tx_err_cnt, rx_err_cnt;
> +	int ru_cnt = 0;

More reverse Christmas tree.

> +static void owl_emac_mdio_clock_enable(struct owl_emac_priv *priv)
> +{
> +	u32 val;
> +
> +	/* Enable MDC clock generation by setting CLKDIV to at least 128. */

You should be aiming for 2.5MHz bus clock. Does this depend on the
speed of one of the two clocks you have? Maybe you can dynamically
calculate the divider?

> +	val = owl_emac_reg_read(priv, OWL_EMAC_REG_MAC_CSR10);
> +	val &= OWL_EMAC_MSK_MAC_CSR10_CLKDIV;
> +	val |= OWL_EMAC_VAL_MAC_CSR10_CLKDIV_128 << OWL_EMAC_OFF_MAC_CSR10_CLKDIV;
> +
> +	val |= OWL_EMAC_BIT_MAC_CSR10_SB;
> +	val |= OWL_EMAC_VAL_MAC_CSR10_OPCODE_CDS << OWL_EMAC_OFF_MAC_CSR10_OPCODE;
> +	owl_emac_reg_write(priv, OWL_EMAC_REG_MAC_CSR10, val);
> +}

> +static int owl_emac_phy_init(struct net_device *netdev)
> +{
> +	struct owl_emac_priv *priv = netdev_priv(netdev);
> +	struct device *dev = owl_emac_get_dev(priv);
> +	struct phy_device *phy;
> +
> +	phy = of_phy_get_and_connect(netdev, dev->of_node,
> +				     owl_emac_adjust_link);
> +	if (!phy)
> +		return -ENODEV;
> +
> +	if (phy->interface != PHY_INTERFACE_MODE_RMII) {
> +		netdev_err(netdev, "unsupported phy mode: %s\n",
> +			   phy_modes(phy->interface));
> +		phy_disconnect(phy);
> +		netdev->phydev = NULL;
> +		return -EINVAL;
> +	}

It looks like the MAC only supports symmetric pause. So you should
call phy_set_sym_pause() to let the PHY know this.

> +
> +	if (netif_msg_link(priv))
> +		phy_attached_info(phy);
> +
> +	return 0;
> +}
> +
> +/* Generate the MAC address based on the system serial number.
> + */
> +static int owl_emac_generate_mac_addr(struct net_device *netdev)
> +{
> +	int ret = -ENXIO;
> +
> +#ifdef CONFIG_OWL_EMAC_GEN_ADDR_SYS_SN
> +	struct device *dev = netdev->dev.parent;
> +	struct crypto_sync_skcipher *tfm;
> +	struct scatterlist sg;
> +	const u8 key[] = { 1, 4, 13, 21, 59, 67, 69, 127 };
> +	u64 sn;
> +	u8 enc_sn[sizeof(key)];
> +
> +	SYNC_SKCIPHER_REQUEST_ON_STACK(req, tfm);
> +
> +	sn = ((u64)system_serial_high << 32) | system_serial_low;
> +	if (!sn)
> +		return ret;
> +
> +	tfm = crypto_alloc_sync_skcipher("ecb(des)", 0, 0);
> +	if (IS_ERR(tfm)) {
> +		dev_err(dev, "failed to allocate cipher: %ld\n", PTR_ERR(tfm));
> +		return PTR_ERR(tfm);
> +	}
> +
> +	ret = crypto_sync_skcipher_setkey(tfm, key, sizeof(key));
> +	if (ret) {
> +		dev_err(dev, "failed to set cipher key: %d\n", ret);
> +		goto err_free_tfm;
> +	}
> +
> +	memcpy(enc_sn, &sn, sizeof(enc_sn));
> +
> +	sg_init_one(&sg, enc_sn, sizeof(enc_sn));
> +	skcipher_request_set_sync_tfm(req, tfm);
> +	skcipher_request_set_callback(req, 0, NULL, NULL);
> +	skcipher_request_set_crypt(req, &sg, &sg, sizeof(enc_sn), NULL);
> +
> +	ret = crypto_skcipher_encrypt(req);
> +	if (ret) {
> +		dev_err(dev, "failed to encrypt S/N: %d\n", ret);
> +		goto err_free_tfm;
> +	}
> +
> +	netdev->dev_addr[0] = 0xF4;
> +	netdev->dev_addr[1] = 0x4E;
> +	netdev->dev_addr[2] = 0xFD;

0xF4 has the locally administered bit 0. So this is a true OUI. Who
does it belong to? Ah!

F4:4E:FD Actions Semiconductor Co.,Ltd.(Cayman Islands)

Which makes sense. But is there any sort of agreement this is allowed?
It is going to cause problems if they are giving out these MAC
addresses in a controlled way.

Maybe it would be better to set bit 1 of byte 0? And then you can use
5 bytes from enc_sn, not just 4.

> +	netdev->dev_addr[3] = enc_sn[0];
> +	netdev->dev_addr[4] = enc_sn[4];
> +	netdev->dev_addr[5] = enc_sn[7];
> +
> +err_free_tfm:
> +	crypto_free_sync_skcipher(tfm);
> +#endif /* CONFIG_OWL_EMAC_GEN_ADDR_SYS_SN */
> +
> +	return ret;
> +}

> +static int owl_emac_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct net_device *netdev;
> +	struct owl_emac_priv *priv;
> +	int ret, i;
> +
> +	netdev = devm_alloc_etherdev(dev, sizeof(*priv));
> +	if (!netdev)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, netdev);
> +	SET_NETDEV_DEV(netdev, dev);
> +
> +	priv = netdev_priv(netdev);
> +	priv->netdev = netdev;
> +	priv->msg_enable = netif_msg_init(debug, DEFAULT_MSG_ENABLE);
> +
> +	spin_lock_init(&priv->lock);
> +
> +	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
> +	if (ret) {
> +		dev_err(dev, "unsupported DMA mask\n");
> +		return ret;
> +	}
> +
> +	ret = owl_emac_ring_alloc(dev, &priv->rx_ring, OWL_EMAC_RX_RING_SIZE);
> +	if (ret)
> +		return ret;
> +
> +	ret = owl_emac_ring_alloc(dev, &priv->tx_ring, OWL_EMAC_TX_RING_SIZE);
> +	if (ret)
> +		return ret;
> +
> +	priv->base = devm_platform_ioremap_resource(pdev, 0);
> +	if (IS_ERR(priv->base))
> +		return PTR_ERR(priv->base);
> +
> +	netdev->irq = platform_get_irq(pdev, 0);
> +	if (netdev->irq < 0)
> +		return netdev->irq;
> +
> +	ret = devm_request_irq(dev, netdev->irq, owl_emac_handle_irq,
> +			       IRQF_SHARED, netdev->name, netdev);
> +	if (ret) {
> +		dev_err(dev, "failed to request irq: %d\n", netdev->irq);
> +		return ret;
> +	}
> +
> +	for (i = 0; i < OWL_EMAC_NCLKS; i++)
> +		priv->clks[i].id = owl_emac_clk_names[i];
> +
> +	ret = devm_clk_bulk_get(dev, OWL_EMAC_NCLKS, priv->clks);
> +	if (ret)
> +		return ret;
> +
> +	ret = clk_bulk_prepare_enable(OWL_EMAC_NCLKS, priv->clks);
> +	if (ret)
> +		return ret;
> +
> +	ret = clk_set_rate(priv->clks[OWL_EMAC_CLK_RMII].clk, 50000000);
> +	if (ret) {
> +		dev_err(dev, "failed to set RMII clock rate: %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret = devm_add_action_or_reset(dev, owl_emac_clk_disable_unprepare, priv);
> +	if (ret)
> +		return ret;

Maybe this should go before the clk_set_rate(), just in case it fail?

Otherwise, this look a new clean driver.

	   Andrew
