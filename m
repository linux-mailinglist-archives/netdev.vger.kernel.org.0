Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 968255B6432
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 01:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiILXdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 19:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiILXdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 19:33:00 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EBE317E19;
        Mon, 12 Sep 2022 16:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GxyJb1VdRuBIekkPcH3xop5jMyGKPepsWbPeOmEF7n8=; b=Brm67TN5+0DUTIHG6tu9HFdZsL
        tRI345WR2SHyI02mvoKcSYb6ef2Bn3RgxPNX59HbwGMv6UO0DLdTpZRceBnbSIBOKZ++PMYkA6pxR
        ynbRSeVarCfTnqrXJFJLAIeRtNa1Ti+3suyONGb1K4+dFZzQMOS+BCc3FiAKq51PzMeM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oXscs-00GXA9-Vb; Tue, 13 Sep 2022 01:14:03 +0200
Date:   Tue, 13 Sep 2022 01:14:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, geert+renesas@glider.be,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 3/5] net: ethernet: renesas: Add Ethernet Switch driver
Message-ID: <Yx+9OrYDxKjVUutF@lunn.ch>
References: <20220909132614.1967276-1-yoshihiro.shimoda.uh@renesas.com>
 <20220909132614.1967276-4-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909132614.1967276-4-yoshihiro.shimoda.uh@renesas.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int default_rate = 1000;
> +module_param(default_rate, int, 0644);
> +MODULE_PARM_DESC(default_rate, "Default rate for both ETHA and GWCA");
> +
> +static int num_etha_ports = 1;
> +module_param(num_etha_ports, int, 0644);
> +MODULE_PARM_DESC(num_etha_ports, "Number of using ETHA ports");
> +
> +static int num_ndev = 1;
> +module_param(num_ndev, int, 0644);
> +MODULE_PARM_DESC(num_ndev, "Number of creating network devices");

No module parameters please. Find a different API for this.

+
> +static int rswitch_reg_wait(void __iomem *addr, u32 offs, u32 mask, u32 expected)
> +{
> +	int i;
> +
> +	for (i = 0; i < RSWITCH_TIMEOUT_US; i++) {
> +		if ((ioread32(addr + offs) & mask) == expected)
> +			return 0;
> +
> +		udelay(1);
> +	}
> +
> +	return -ETIMEDOUT;

iopoll.h

> +/* TOP */

Could you expand that acronym, for those of us how have no idea what
it means?

> +static void rswitch_top_init(struct rswitch_private *priv)
> +{
> +	int i;
> +
> +	for (i = 0; i < RSWITCH_MAX_NUM_CHAINS; i++)
> +		iowrite32((i / 16) << (GWCA_INDEX * 8), priv->addr + TPEMIMC7(i));
> +}
> +
> +/* MFWD */

Multicast Forward? 

> +static void rswitch_fwd_init(struct rswitch_private *priv)
> +{
> +	int i;
> +
> +	for (i = 0; i < RSWITCH_NUM_HW; i++) {
> +		iowrite32(FWPC0_DEFAULT, priv->addr + FWPC0(i));
> +		iowrite32(0, priv->addr + FWPBFC(i));
> +	}
> +
> +	for (i = 0; i < num_etha_ports; i++) {
> +		iowrite32(priv->rdev[i]->rx_chain->index,
> +			  priv->addr + FWPBFCSDC(GWCA_INDEX, i));
> +		iowrite32(BIT(priv->gwca.index), priv->addr + FWPBFC(i));
> +	}
> +	iowrite32(GENMASK(num_etha_ports - 1, 0), priv->addr + FWPBFC(3));
> +}
> +
> +/* gPTP */
> +static void rswitch_get_timestamp(struct rswitch_private *priv,
> +				  struct timespec64 *ts)
> +{
> +	struct rcar_gen4_ptp_private *ptp_priv = priv->ptp_priv;
> +
> +	ptp_priv->info.gettime64(&ptp_priv->info, ts);
> +}
> +
> +/* GWCA */
> +static int rswitch_gwca_change_mode(struct rswitch_private *priv,
> +				    enum rswitch_gwca_mode mode)
> +{
> +	int ret;
> +
> +	if (!rswitch_agent_clock_is_enabled(priv->addr, priv->gwca.index))
> +		rswitch_agent_clock_ctrl(priv->addr, priv->gwca.index, 1);
> +
> +	iowrite32(mode, priv->addr + GWMC);
> +
> +	ret = rswitch_reg_wait(priv->addr, GWMS, GWMS_OPS_MASK, mode);
> +
> +	if (mode == GWMC_OPC_DISABLE)
> +		rswitch_agent_clock_ctrl(priv->addr, priv->gwca.index, 0);
> +
> +	return ret;
> +}
> +
> +static int rswitch_gwca_mcast_table_reset(struct rswitch_private *priv)
> +{
> +	iowrite32(GWMTIRM_MTIOG, priv->addr + GWMTIRM);
> +
> +	return rswitch_reg_wait(priv->addr, GWMTIRM, GWMTIRM_MTR, GWMTIRM_MTR);
> +}
> +
> +static int rswitch_gwca_axi_ram_reset(struct rswitch_private *priv)
> +{
> +	iowrite32(GWARIRM_ARIOG, priv->addr + GWARIRM);
> +
> +	return rswitch_reg_wait(priv->addr, GWARIRM, GWARIRM_ARR, GWARIRM_ARR);
> +}
> +
> +static void rswitch_gwca_set_rate_limit(struct rswitch_private *priv, int rate)
> +{
> +	u32 gwgrlulc, gwgrlc;
> +
> +	switch (rate) {
> +	case 1000:
> +		gwgrlulc = 0x0000005f;
> +		gwgrlc = 0x00010260;
> +		break;
> +	default:
> +		dev_err(&priv->pdev->dev, "%s: This rate is not supported (%d)\n", __func__, rate);
> +		break;
> +	}
> +
> +	iowrite32(gwgrlulc, priv->addr + GWGRLULC);
> +	iowrite32(gwgrlc, priv->addr + GWGRLC);

So on error, you write random values to the hardware? At least change
the break to a return.


> +}
> +
> +static bool rswitch_is_any_data_irq(struct rswitch_private *priv, u32 *dis, bool tx)
> +{
> +	int i;
> +	u32 *mask = tx ? priv->gwca.tx_irq_bits : priv->gwca.rx_irq_bits;
> +
> +	for (i = 0; i < RSWITCH_NUM_IRQ_REGS; i++) {
> +		if (dis[i] & mask[i])
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
> +static void rswitch_get_data_irq_status(struct rswitch_private *priv, u32 *dis)
> +{
> +	int i;
> +
> +	for (i = 0; i < RSWITCH_NUM_IRQ_REGS; i++) {
> +		dis[i] = ioread32(priv->addr + GWDIS(i));
> +		dis[i] &= ioread32(priv->addr + GWDIE(i));
> +	}
> +}
> +
> +static void rswitch_enadis_data_irq(struct rswitch_private *priv, int index, bool enable)
> +{
> +	u32 offs = enable ? GWDIE(index / 32) : GWDID(index / 32);
> +
> +	iowrite32(BIT(index % 32), priv->addr + offs);
> +}
> +
> +static void rswitch_ack_data_irq(struct rswitch_private *priv, int index)
> +{
> +	u32 offs = GWDIS(index / 32);
> +
> +	iowrite32(BIT(index % 32), priv->addr + offs);
> +}
> +
> +static bool rswitch_is_chain_rxed(struct rswitch_gwca_chain *c)
> +{
> +	int entry;
> +	struct rswitch_ext_ts_desc *desc;
> +
> +	entry = c->dirty % c->num_ring;
> +	desc = &c->ts_ring[entry];
> +
> +	if ((desc->die_dt & DT_MASK) != DT_FEMPTY)
> +		return true;
> +
> +	return false;
> +}
> +
> +static bool rswitch_rx(struct net_device *ndev, int *quota)
> +{
> +	struct rswitch_device *rdev = netdev_priv(ndev);
> +	struct rswitch_gwca_chain *c = rdev->rx_chain;
> +	int boguscnt = c->dirty + c->num_ring - c->cur;
> +	int entry = c->cur % c->num_ring;
> +	struct rswitch_ext_ts_desc *desc = &c->ts_ring[entry];
> +	int limit;
> +	u16 pkt_len;
> +	struct sk_buff *skb;
> +	dma_addr_t dma_addr;
> +	u32 get_ts;

Reverse Christmas tree. Please go through all the code.

> +
> +	boguscnt = min(boguscnt, *quota);
> +	limit = boguscnt;
> +
> +	while ((desc->die_dt & DT_MASK) != DT_FEMPTY) {
> +		dma_rmb();
> +		pkt_len = le16_to_cpu(desc->info_ds) & RX_DS;
> +		if (--boguscnt < 0)
> +			break;
> +		skb = c->skb[entry];
> +		c->skb[entry] = NULL;
> +		dma_addr = le32_to_cpu(desc->dptrl) | ((__le64)le32_to_cpu(desc->dptrh) << 32);
> +		dma_unmap_single(ndev->dev.parent, dma_addr, PKT_BUF_SZ, DMA_FROM_DEVICE);
> +		get_ts = rdev->priv->ptp_priv->tstamp_rx_ctrl & RCAR_GEN4_RXTSTAMP_TYPE_V2_L2_EVENT;
> +		if (get_ts) {
> +			struct skb_shared_hwtstamps *shhwtstamps;
> +			struct timespec64 ts;
> +
> +			shhwtstamps = skb_hwtstamps(skb);
> +			memset(shhwtstamps, 0, sizeof(*shhwtstamps));
> +			ts.tv_sec = (u64)le32_to_cpu(desc->ts_sec);
> +			ts.tv_nsec = le32_to_cpu(desc->ts_nsec & 0x3FFFFFFF);
> +			shhwtstamps->hwtstamp = timespec64_to_ktime(ts);
> +		}
> +		skb_put(skb, pkt_len);
> +		skb->protocol = eth_type_trans(skb, ndev);
> +		netif_receive_skb(skb);
> +		rdev->ndev->stats.rx_packets++;
> +		rdev->ndev->stats.rx_bytes += pkt_len;
> +
> +		entry = (++c->cur) % c->num_ring;
> +		desc = &c->ts_ring[entry];
> +	}
> +
> +	/* Refill the RX ring buffers */
> +	for (; c->cur - c->dirty > 0; c->dirty++) {
> +		entry = c->dirty % c->num_ring;
> +		desc = &c->ts_ring[entry];
> +		desc->info_ds = cpu_to_le16(PKT_BUF_SZ);
> +
> +		if (!c->skb[entry]) {
> +			skb = dev_alloc_skb(PKT_BUF_SZ + RSWITCH_ALIGN - 1);
> +			if (!skb)
> +				break;	/* Better luck next round */
> +			skb_reserve(skb, NET_IP_ALIGN);
> +			dma_addr = dma_map_single(ndev->dev.parent, skb->data,
> +						  le16_to_cpu(desc->info_ds),
> +						  DMA_FROM_DEVICE);
> +			if (dma_mapping_error(ndev->dev.parent, dma_addr))
> +				desc->info_ds = cpu_to_le16(0);
> +			desc->dptrl = cpu_to_le32(lower_32_bits(dma_addr));
> +			desc->dptrh = cpu_to_le32(upper_32_bits(dma_addr));

If there has been a dma mapping error, is dma_addr valid?

> +			skb_checksum_none_assert(skb);
> +			c->skb[entry] = skb;
> +		}
> +		dma_wmb();
> +		desc->die_dt = DT_FEMPTY | DIE;
> +	}
> +
> +	*quota -= limit - (++boguscnt);
> +
> +	return boguscnt <= 0;
> +}
> +
> +static int rswitch_tx_free(struct net_device *ndev, bool free_txed_only)
> +{
> +	struct rswitch_device *rdev = netdev_priv(ndev);
> +	struct rswitch_ext_desc *desc;
> +	int free_num = 0;
> +	int entry, size;
> +	dma_addr_t dma_addr;
> +	struct rswitch_gwca_chain *c = rdev->tx_chain;
> +	struct sk_buff *skb;
> +
> +	for (; c->cur - c->dirty > 0; c->dirty++) {
> +		entry = c->dirty % c->num_ring;
> +		desc = &c->ring[entry];
> +		if (free_txed_only && (desc->die_dt & DT_MASK) != DT_FEMPTY)
> +			break;
> +
> +		dma_rmb();
> +		size = le16_to_cpu(desc->info_ds) & TX_DS;
> +		skb = c->skb[entry];
> +		if (skb) {
> +			if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
> +				struct skb_shared_hwtstamps shhwtstamps;
> +				struct timespec64 ts;
> +
> +				rswitch_get_timestamp(rdev->priv, &ts);
> +				memset(&shhwtstamps, 0, sizeof(shhwtstamps));
> +				shhwtstamps.hwtstamp = timespec64_to_ktime(ts);
> +				skb_tstamp_tx(skb, &shhwtstamps);
> +			}
> +			dma_addr = le32_to_cpu(desc->dptrl) |
> +				   ((__le64)le32_to_cpu(desc->dptrh) << 32);
> +			dma_unmap_single(ndev->dev.parent, dma_addr,
> +					 size, DMA_TO_DEVICE);
> +			dev_kfree_skb_any(c->skb[entry]);
> +			c->skb[entry] = NULL;
> +			free_num++;
> +		}
> +		desc->die_dt = DT_EEMPTY;
> +		rdev->ndev->stats.tx_packets++;
> +		rdev->ndev->stats.tx_bytes += size;
> +	}
> +
> +	return free_num;
> +}
> +
> +static int rswitch_poll(struct napi_struct *napi, int budget)
> +{
> +	struct net_device *ndev = napi->dev;
> +	struct rswitch_device *rdev = netdev_priv(ndev);
> +	struct rswitch_private *priv = rdev->priv;
> +	int quota = budget;
> +
> +retry:
> +	rswitch_tx_free(ndev, true);
> +
> +	if (rswitch_rx(ndev, &quota))
> +		goto out;
> +	else if (rswitch_is_chain_rxed(rdev->rx_chain))
> +		goto retry;
> +
> +	netif_wake_subqueue(ndev, 0);
> +
> +	napi_complete(napi);
> +
> +	rswitch_enadis_data_irq(priv, rdev->tx_chain->index, true);
> +	rswitch_enadis_data_irq(priv, rdev->rx_chain->index, true);
> +
> +out:
> +	return budget - quota;
> +}
> +
> +static void rswitch_queue_interrupt(struct net_device *ndev)
> +{
> +	struct rswitch_device *rdev = netdev_priv(ndev);
> +
> +	if (napi_schedule_prep(&rdev->napi)) {
> +		rswitch_enadis_data_irq(rdev->priv, rdev->tx_chain->index, false);
> +		rswitch_enadis_data_irq(rdev->priv, rdev->rx_chain->index, false);
> +		__napi_schedule(&rdev->napi);
> +	}
> +}
> +
> +static irqreturn_t rswitch_data_irq(struct rswitch_private *priv, u32 *dis)
> +{
> +	struct rswitch_gwca_chain *c;
> +	int i;
> +	int index, bit;
> +
> +	for (i = 0; i < priv->gwca.num_chains; i++) {
> +		c = &priv->gwca.chains[i];
> +		index = c->index / 32;
> +		bit = BIT(c->index % 32);
> +		if (!(dis[index] & bit))
> +			continue;
> +
> +		rswitch_ack_data_irq(priv, c->index);
> +		rswitch_queue_interrupt(c->ndev);
> +	}
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static irqreturn_t rswitch_gwca_irq(int irq, void *dev_id)
> +{
> +	struct rswitch_private *priv = dev_id;
> +	irqreturn_t ret = IRQ_NONE;
> +	u32 dis[RSWITCH_NUM_IRQ_REGS];
> +
> +	rswitch_get_data_irq_status(priv, dis);
> +
> +	if (rswitch_is_any_data_irq(priv, dis, true) ||
> +	    rswitch_is_any_data_irq(priv, dis, false))
> +		ret = rswitch_data_irq(priv, dis);
> +
> +	return ret;
> +}
> +
> +static int rswitch_gwca_request_irqs(struct rswitch_private *priv)
> +{
> +	int i, ret;
> +	char *resource_name, *irq_name;
> +	struct rswitch_gwca *gwca = &priv->gwca;
> +
> +	for (i = 0; i < GWCA_NUM_IRQS; i++) {
> +		resource_name = kasprintf(GFP_KERNEL, GWCA_IRQ_RESOURCE_NAME, i);
> +		if (!resource_name) {
> +			ret = -ENOMEM;
> +			goto err;
> +		}
> +
> +		gwca->irq[i] = platform_get_irq_byname(priv->pdev, resource_name);
> +		kfree(resource_name);
> +		if (gwca->irq[i] < 0) {
> +			ret = gwca->irq[i];
> +			goto err;
> +		}
> +
> +		irq_name = devm_kasprintf(&priv->pdev->dev, GFP_KERNEL,
> +					  GWCA_IRQ_NAME, i);
> +		if (!irq_name) {
> +			ret = -ENOMEM;
> +			goto err;
> +		}
> +
> +		ret = request_irq(gwca->irq[i], rswitch_gwca_irq, 0, irq_name, priv);

devm_request_irq() ?

> +static int rswitch_etha_set_access(struct rswitch_etha *etha, bool read,
> +				   int phyad, int devad, int regad, int data)
> +{
> +	int pop = read ? MDIO_READ_C45 : MDIO_WRITE_C45;
> +	u32 val;
> +	int ret;
> +
> +	/* No match device */
> +	if (devad == 0xffffffff)
> +		return 0;
> +
> +	writel(MMIS1_CLEAR_FLAGS, etha->addr + MMIS1);
> +
> +	val = MPSM_PSME | MPSM_MFF_C45;
> +	iowrite32((regad << 16) | (devad << 8) | (phyad << 3) | val, etha->addr + MPSM);
> +
> +	ret = rswitch_reg_wait(etha->addr, MMIS1, MMIS1_PAACS, MMIS1_PAACS);
> +	if (ret)
> +		return ret;
> +
> +	rswitch_modify(etha->addr, MMIS1, MMIS1_PAACS, MMIS1_PAACS);
> +
> +	if (read) {
> +		writel((pop << 13) | (devad << 8) | (phyad << 3) | val, etha->addr + MPSM);
> +
> +		ret = rswitch_reg_wait(etha->addr, MMIS1, MMIS1_PRACS, MMIS1_PRACS);
> +		if (ret)
> +			return ret;
> +
> +		ret = (ioread32(etha->addr + MPSM) & MPSM_PRD_MASK) >> 16;
> +
> +		rswitch_modify(etha->addr, MMIS1, MMIS1_PRACS, MMIS1_PRACS);
> +	} else {
> +		iowrite32((data << 16) | (pop << 13) | (devad << 8) | (phyad << 3) | val,
> +			  etha->addr + MPSM);
> +
> +		ret = rswitch_reg_wait(etha->addr, MMIS1, MMIS1_PWACS, MMIS1_PWACS);
> +	}
> +
> +	return ret;
> +}
> +
> +static int rswitch_etha_mii_read(struct mii_bus *bus, int addr, int regnum)
> +{
> +	struct rswitch_etha *etha = bus->priv;
> +	int mode, devad, regad;
> +
> +	mode = regnum & MII_ADDR_C45;
> +	devad = (regnum >> MII_DEVADDR_C45_SHIFT) & 0x1f;
> +	regad = regnum & MII_REGADDR_C45_MASK;
> +
> +	/* Not support Clause 22 access method */
> +	if (!mode)
> +		return 0;

-EOPNOTSUPP.

> +
> +	return rswitch_etha_set_access(etha, true, addr, devad, regad, 0);
> +}
> +
> +static int rswitch_etha_mii_write(struct mii_bus *bus, int addr, int regnum, u16 val)
> +{
> +	struct rswitch_etha *etha = bus->priv;
> +	int mode, devad, regad;
> +
> +	mode = regnum & MII_ADDR_C45;
> +	devad = (regnum >> MII_DEVADDR_C45_SHIFT) & 0x1f;
> +	regad = regnum & MII_REGADDR_C45_MASK;
> +
> +	/* Not support Clause 22 access method */
> +	if (!mode)
> +		return 0;

Same here.

> +
> +	return rswitch_etha_set_access(etha, false, addr, devad, regad, val);
> +}
> +
> +/* Call of_node_put(port) after done */
> +static struct device_node *rswitch_get_port_node(struct rswitch_device *rdev)
> +{
> +	struct device_node *ports, *port;
> +	int err = 0;
> +	u32 index;
> +
> +	ports = of_get_child_by_name(rdev->ndev->dev.parent->of_node, "ports");
> +	if (!ports)
> +		return NULL;
> +
> +	for_each_child_of_node(ports, port) {
> +		err = of_property_read_u32(port, "reg", &index);
> +		if (err < 0) {
> +			port = NULL;
> +			goto out;
> +		}
> +		if (index == rdev->etha->index)
> +			break;
> +	}
> +
> +out:
> +	of_node_put(ports);
> +
> +	return port;
> +}
> +
> +/* Call of_node_put(phy) after done */
> +static struct device_node *rswitch_get_phy_node(struct rswitch_device *rdev)
> +{
> +	struct device_node *port, *phy = NULL;
> +	int err = 0;
> +
> +	port = rswitch_get_port_node(rdev);
> +	if (!port)
> +		return NULL;
> +
> +	err = of_get_phy_mode(port, &rdev->etha->phy_interface);
> +	if (err < 0)
> +		goto out;
> +
> +	phy = of_parse_phandle(port, "phy-handle", 0);
> +
> +out:
> +	of_node_put(port);
> +
> +	return phy;
> +}
> +
> +static int rswitch_mii_register(struct rswitch_device *rdev)
> +{
> +	struct mii_bus *mii_bus;
> +	struct device_node *port;
> +	int err;
> +
> +	mii_bus = mdiobus_alloc();
> +	if (!mii_bus)
> +		return -ENOMEM;
> +
> +	mii_bus->name = "rswitch_mii";
> +	sprintf(mii_bus->id, "etha%d", rdev->etha->index);
> +	mii_bus->priv = rdev->etha;
> +	mii_bus->read = rswitch_etha_mii_read;
> +	mii_bus->write = rswitch_etha_mii_write;
> +	mii_bus->parent = &rdev->ndev->dev;
> +
> +	port = rswitch_get_port_node(rdev);
> +	err = of_mdiobus_register(mii_bus, port);
> +	if (err < 0) {
> +		mdiobus_free(mii_bus);
> +		goto out;
> +	}
> +
> +	rdev->etha->mii = mii_bus;
> +
> +out:
> +	of_node_put(port);
> +
> +	return err;
> +}
> +
> +static void rswitch_mii_unregister(struct rswitch_device *rdev)
> +{
> +	if (rdev->etha && rdev->etha->mii) {
> +		mdiobus_unregister(rdev->etha->mii);
> +		mdiobus_free(rdev->etha->mii);
> +		rdev->etha->mii = NULL;
> +	}
> +}
> +
> +static void rswitch_adjust_link(struct net_device *ndev)
> +{
> +	struct rswitch_device *rdev = netdev_priv(ndev);
> +	struct phy_device *phydev = ndev->phydev;
> +
> +	if (phydev->link != rdev->etha->link) {
> +		phy_print_status(phydev);
> +		rdev->etha->link = phydev->link;
> +	}

Given that the SERDES supports 100 and 1G, it seems odd you don't need
to do anything here.

> +}
> +
> +static int rswitch_phy_init(struct rswitch_device *rdev, struct device_node *phy)
> +{
> +	struct phy_device *phydev;
> +	int err = 0;
> +
> +	phydev = of_phy_connect(rdev->ndev, phy, rswitch_adjust_link, 0,
> +				rdev->etha->phy_interface);
> +	if (!phydev) {
> +		err = -ENOENT;
> +		goto out;
> +	}
> +
> +	phy_attached_info(phydev);
> +
> +out:
> +	return err;
> +}
> +
> +static void rswitch_phy_deinit(struct rswitch_device *rdev)
> +{
> +	if (rdev->ndev->phydev) {
> +		phy_disconnect(rdev->ndev->phydev);
> +		rdev->ndev->phydev = NULL;
> +	}
> +}
> +
> +static int rswitch_open(struct net_device *ndev)
> +{
> +	struct rswitch_device *rdev = netdev_priv(ndev);
> +	struct device_node *phy;
> +	int err = 0;
> +
> +	if (rdev->etha) {
> +		if (!rdev->etha->operated) {
> +			phy = rswitch_get_phy_node(rdev);
> +			if (!phy)
> +				return -EINVAL;
> +			err = rswitch_etha_hw_init(rdev->etha, ndev->dev_addr);
> +			if (err < 0)
> +				goto err_hw_init;
> +			err = rswitch_mii_register(rdev);
> +			if (err < 0)
> +				goto err_mii_register;

Each port has its own MDIO bus? Not one bus shared by all ports? That
is unusual.

> +			err = rswitch_phy_init(rdev, phy);
> +			if (err < 0)
> +				goto err_phy_init;
> +		}
> +
> +		phy_start(ndev->phydev);
> +
> +		if (!rdev->etha->operated) {
> +			err = rswitch_serdes_init(rdev->etha->serdes_addr,
> +						  rdev->etha->serdes_addr0,
> +						  rdev->etha->phy_interface,
> +						  rdev->etha->speed);
> +			if (err < 0)
> +				goto err_serdes_init;
> +			of_node_put(phy);
> +		}
> +
> +		rdev->etha->operated = true;
> +	}
> +
> +	napi_enable(&rdev->napi);
> +	netif_start_queue(ndev);
> +
> +	rswitch_enadis_data_irq(rdev->priv, rdev->tx_chain->index, true);
> +	rswitch_enadis_data_irq(rdev->priv, rdev->rx_chain->index, true);
> +
> +	return err;
> +
> +err_serdes_init:
> +	phy_stop(ndev->phydev);
> +	rswitch_phy_deinit(rdev);
> +
> +err_phy_init:
> +	rswitch_mii_unregister(rdev);
> +
> +err_mii_register:
> +err_hw_init:
> +	of_node_put(phy);
> +
> +	return err;
> +};
> +
> +static int rswitch_stop(struct net_device *ndev)
> +{
> +	struct rswitch_device *rdev = netdev_priv(ndev);
> +
> +	netif_tx_stop_all_queues(ndev);
> +
> +	rswitch_enadis_data_irq(rdev->priv, rdev->tx_chain->index, false);
> +	rswitch_enadis_data_irq(rdev->priv, rdev->rx_chain->index, false);
> +
> +	if (rdev->etha && ndev->phydev)
> +		phy_stop(ndev->phydev);
> +
> +	napi_disable(&rdev->napi);
> +
> +	return 0;
> +};
> +
> +static int rswitch_start_xmit(struct sk_buff *skb, struct net_device *ndev)
> +{
> +	struct rswitch_device *rdev = netdev_priv(ndev);
> +	int ret = NETDEV_TX_OK;
> +	int entry;
> +	dma_addr_t dma_addr;
> +	struct rswitch_ext_desc *desc;
> +	struct rswitch_gwca_chain *c = rdev->tx_chain;
> +
> +	if (c->cur - c->dirty > c->num_ring - 1) {
> +		netif_stop_subqueue(ndev, 0);
> +		return ret;
> +	}
> +
> +	if (skb_put_padto(skb, ETH_ZLEN))
> +		return ret;
> +
> +	dma_addr = dma_map_single(ndev->dev.parent, skb->data, skb->len, DMA_TO_DEVICE);
> +	if (dma_mapping_error(ndev->dev.parent, dma_addr)) {
> +		dev_kfree_skb_any(skb);
> +		return ret;
> +	}
> +
> +	entry = c->cur % c->num_ring;
> +	c->skb[entry] = skb;
> +	desc = &c->ring[entry];
> +	desc->dptrl = cpu_to_le32(lower_32_bits(dma_addr));
> +	desc->dptrh = cpu_to_le32(upper_32_bits(dma_addr));
> +	desc->info_ds = cpu_to_le16(skb->len);
> +
> +	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
> +		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
> +		rdev->ts_tag++;
> +		desc->info1 = (rdev->ts_tag << 8) | BIT(3);
> +	}
> +
> +	skb_tx_timestamp(skb);
> +	dma_wmb();
> +
> +	desc->die_dt = DT_FSINGLE | DIE;
> +	wmb();	/* c->cur must be incremented after die_dt was set */
> +
> +	c->cur++;
> +	rswitch_modify(rdev->addr, GWTRC(c->index), 0, BIT(c->index % 32));
> +
> +	return ret;
> +}
> +
> +static struct net_device_stats *rswitch_get_stats(struct net_device *ndev)
> +{
> +	return &ndev->stats;
> +}
> +
> +static int rswitch_hwstamp_get(struct net_device *ndev, struct ifreq *req)
> +{
> +	struct rswitch_device *rdev = netdev_priv(ndev);
> +	struct rswitch_private *priv = rdev->priv;
> +	struct rcar_gen4_ptp_private *ptp_priv = priv->ptp_priv;
> +	struct hwtstamp_config config;
> +
> +	config.flags = 0;
> +	config.tx_type = ptp_priv->tstamp_tx_ctrl ? HWTSTAMP_TX_ON :
> +						    HWTSTAMP_TX_OFF;
> +	switch (ptp_priv->tstamp_rx_ctrl & RCAR_GEN4_RXTSTAMP_TYPE) {
> +	case RCAR_GEN4_RXTSTAMP_TYPE_V2_L2_EVENT:
> +		config.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
> +		break;
> +	case RCAR_GEN4_RXTSTAMP_TYPE_ALL:
> +		config.rx_filter = HWTSTAMP_FILTER_ALL;
> +		break;
> +	default:
> +		config.rx_filter = HWTSTAMP_FILTER_NONE;
> +		break;
> +	}
> +
> +	return copy_to_user(req->ifr_data, &config, sizeof(config)) ? -EFAULT : 0;
> +}
> +
> +static int rswitch_hwstamp_set(struct net_device *ndev, struct ifreq *req)
> +{
> +	struct rswitch_device *rdev = netdev_priv(ndev);
> +	struct rswitch_private *priv = rdev->priv;
> +	struct rcar_gen4_ptp_private *ptp_priv = priv->ptp_priv;
> +	struct hwtstamp_config config;
> +	u32 tstamp_rx_ctrl = RCAR_GEN4_RXTSTAMP_ENABLED;
> +	u32 tstamp_tx_ctrl;
> +
> +	if (copy_from_user(&config, req->ifr_data, sizeof(config)))
> +		return -EFAULT;
> +
> +	if (config.flags)
> +		return -EINVAL;
> +
> +	switch (config.tx_type) {
> +	case HWTSTAMP_TX_OFF:
> +		tstamp_tx_ctrl = 0;
> +		break;
> +	case HWTSTAMP_TX_ON:
> +		tstamp_tx_ctrl = RCAR_GEN4_TXTSTAMP_ENABLED;
> +		break;
> +	default:
> +		return -ERANGE;
> +	}
> +
> +	switch (config.rx_filter) {
> +	case HWTSTAMP_FILTER_NONE:
> +		tstamp_rx_ctrl = 0;
> +		break;
> +	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
> +		tstamp_rx_ctrl |= RCAR_GEN4_RXTSTAMP_TYPE_V2_L2_EVENT;
> +		break;
> +	default:
> +		config.rx_filter = HWTSTAMP_FILTER_ALL;
> +		tstamp_rx_ctrl |= RCAR_GEN4_RXTSTAMP_TYPE_ALL;
> +		break;
> +	}
> +
> +	ptp_priv->tstamp_tx_ctrl = tstamp_tx_ctrl;
> +	ptp_priv->tstamp_rx_ctrl = tstamp_rx_ctrl;
> +
> +	return copy_to_user(req->ifr_data, &config, sizeof(config)) ? -EFAULT : 0;
> +}
> +
> +static int rswitch_eth_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
> +{
> +	if (!netif_running(ndev))
> +		return -EINVAL;
> +
> +	switch (cmd) {
> +	case SIOCGHWTSTAMP:
> +		return rswitch_hwstamp_get(ndev, req);
> +	case SIOCSHWTSTAMP:
> +		return rswitch_hwstamp_set(ndev, req);
> +	default:
> +		break;
> +	}

You should call phy_mii_ioctl() here.

> +static int rswitch_serdes_reg_wait(void __iomem *addr, u32 offs, u32 bank, u32 mask, u32 expected)
> +{
> +	int i;
> +
> +	iowrite32(bank, addr + RSWITCH_SERDES_BANK_SELECT);
> +	mdelay(1);
> +
> +	for (i = 0; i < RSWITCH_TIMEOUT_US; i++) {
> +		if ((ioread32(addr + offs) & mask) == expected)
> +			return 0;
> +		udelay(1);
> +	}

iopoll.h

> +
> +	return -ETIMEDOUT;
> +}
> +

> +static int rswitch_serdes_common_setting(void __iomem *addr0,
> +					 enum rswitch_serdes_mode mode)
> +{
> +	switch (mode) {
> +	case SGMII:
> +		rswitch_serdes_write32(addr0, 0x0244, 0x180, 0x97);
> +		rswitch_serdes_write32(addr0, 0x01d0, 0x180, 0x60);
> +		rswitch_serdes_write32(addr0, 0x01d8, 0x180, 0x2200);
> +		rswitch_serdes_write32(addr0, 0x01d4, 0x180, 0);
> +		rswitch_serdes_write32(addr0, 0x01e0, 0x180, 0x3d);

Please add #defines for all these magic numbers.

       Andrew
