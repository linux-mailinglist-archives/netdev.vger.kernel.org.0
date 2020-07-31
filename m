Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8968C233C93
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 02:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730926AbgGaAbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 20:31:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728086AbgGaAbE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 20:31:04 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EB5A20829;
        Fri, 31 Jul 2020 00:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596155463;
        bh=UAGQaBqzvHaRLzKJdFQnz8IqQCgS8DbNuGwrU4nMoiE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EpnhUnNSKtwQiNZWNdpWnTpnWQjCqNvrbUXbjIE7so2mcrZrq3JmtB0Kokrt4OKTB
         BvJEEmPpuyMFlWmMEyleDEO3mdI/jumiwpmF+kPmWTR9st3kdn4uJ4zMONLN8SqfWs
         Y7PzxTJYMiMtp5uGrj9r6GjwSta4FKEf8chBRs2U=
Date:   Thu, 30 Jul 2020 17:30:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Thompson <dthompson@mellanox.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        Asmaa Mnebhi <asmaa@mellanox.com>
Subject: Re: [PATCH net-next v2] Add Mellanox BlueField Gigabit Ethernet
 driver
Message-ID: <20200730173059.7440e21c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1596149638-23563-1-git-send-email-dthompson@mellanox.com>
References: <1596149638-23563-1-git-send-email-dthompson@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jul 2020 18:53:58 -0400 David Thompson wrote:
> The logic in "mlxbf_gige_mdio.c" is the driver controlling
> the Mellanox BlueField hardware that interacts with a PHY
> device via MDIO/MDC pins.  This driver does the following:
>   - At driver probe time, it configures several BlueField MDIO
>     parameters such as sample rate, full drive, voltage and MDC
>     based on values read from ACPI table.
>   - It defines functions to read and write MDIO registers and
>     registers the MDIO bus.
>   - It defines the phy interrupt handler reporting a
>     link up/down status change
>   - This driver's probe is invoked from the main driver logic
>     while the phy interrupt handler is registered in ndo_open.

These parts will definitely need Andrew or other PHY maintainers 
to look at. Good luck with the ACPI stuff :)

> Reported-by: kernel test robot <lkp@intel.com>

Remove this, it only applies if the entire patch is prompted by the
reporter. I doubt the build bot made you write this driver.

> +config MLXBF_GIGE
> +	tristate "Mellanox Technologies BlueField Gigabit Ethernet support"
> +	depends on (ARM64 || COMPILE_TEST) && ACPI && INET

Why do you depend on INET? :S

> +	for (i = 0; i < priv->rx_q_entries; i++) {
> +		/* Allocate a receive buffer for this RX WQE. The DMA
> +		 * form (dma_addr_t) of the receive buffer address is
> +		 * stored in the RX WQE array (via 'rx_wqe_ptr') where
> +		 * it is accessible by the GigE device. The VA form of
> +		 * the receive buffer is stored in 'rx_buf[]' array in
> +		 * the driver private storage for housekeeping.
> +		 */
> +		priv->rx_buf[i] = dma_alloc_coherent(priv->dev,
> +						     MLXBF_GIGE_DEFAULT_BUF_SZ,
> +						     &rx_buf_dma,
> +						     GFP_KERNEL);

Do the buffers have to be in coherent memory? That's kinda strange.

> +		if (!priv->rx_buf[i])
> +			goto free_wqe_and_buf;
> +
> +		*rx_wqe_ptr++ = rx_buf_dma;
> +	}

> +	/* Enable RX DMA to write new packets to memory */
> +	writeq(MLXBF_GIGE_RX_DMA_EN, priv->base + MLXBF_GIGE_RX_DMA);

Looks a little strange that you enable DMA and then do further config
like CRC stripping.

> +	/* Enable removal of CRC during RX */
> +	data = readq(priv->base + MLXBF_GIGE_RX);
> +	data |= MLXBF_GIGE_RX_STRIP_CRC_EN;
> +	writeq(data, priv->base + MLXBF_GIGE_RX);
> +
> +	/* Enable RX MAC filter pass and discard counters */
> +	writeq(MLXBF_GIGE_RX_MAC_FILTER_COUNT_DISC_EN,
> +	       priv->base + MLXBF_GIGE_RX_MAC_FILTER_COUNT_DISC);
> +	writeq(MLXBF_GIGE_RX_MAC_FILTER_COUNT_PASS_EN,
> +	       priv->base + MLXBF_GIGE_RX_MAC_FILTER_COUNT_PASS);
> +
> +	/* Clear MLXBF_GIGE_INT_MASK 'receive pkt' bit to
> +	 * indicate readiness to receive pkts
> +	 */

Readiness to receive interrupts - I presume.

> +	data = readq(priv->base + MLXBF_GIGE_INT_MASK);
> +	data &= ~MLXBF_GIGE_INT_MASK_RX_RECEIVE_PACKET;
> +	writeq(data, priv->base + MLXBF_GIGE_INT_MASK);
> +
> +	writeq(ilog2(priv->rx_q_entries),
> +	       priv->base + MLXBF_GIGE_RX_WQE_SIZE_LOG2);

This is probably what enables the reception of packets?

> +	return 0;
> +
> +free_wqe_and_buf:
> +	rx_wqe_ptr = priv->rx_wqe_base;
> +	for (j = 0; j < i; j++) {
> +		dma_free_coherent(priv->dev, MLXBF_GIGE_DEFAULT_BUF_SZ,
> +				  priv->rx_buf[j], *rx_wqe_ptr);
> +		rx_wqe_ptr++;
> +	}
> +	dma_free_coherent(priv->dev, wq_size,
> +			  priv->rx_wqe_base, priv->rx_wqe_base_dma);
> +	return -ENOMEM;
> +}
> +
> +/* Transmit Initialization
> + * 1) Allocates TX WQE array using coherent DMA mapping
> + * 2) Allocates TX completion counter using coherent DMA mapping
> + */
> +static int mlxbf_gige_tx_init(struct mlxbf_gige *priv)
> +{
> +	size_t size;
> +
> +	size = MLXBF_GIGE_TX_WQE_SZ * priv->tx_q_entries;
> +	priv->tx_wqe_base = dma_alloc_coherent(priv->dev, size,
> +					       &priv->tx_wqe_base_dma,
> +					       GFP_KERNEL);
> +	if (!priv->tx_wqe_base)
> +		return -ENOMEM;
> +
> +	priv->tx_wqe_next = priv->tx_wqe_base;
> +
> +	/* Write TX WQE base address into MMIO reg */
> +	writeq(priv->tx_wqe_base_dma, priv->base + MLXBF_GIGE_TX_WQ_BASE);
> +
> +	/* Allocate address for TX completion count */
> +	priv->tx_cc = dma_alloc_coherent(priv->dev, MLXBF_GIGE_TX_CC_SZ,
> +					 &priv->tx_cc_dma, GFP_KERNEL);
> +

nit: don't put empty lines between a call and error checking

> +	if (!priv->tx_cc) {
> +		dma_free_coherent(priv->dev, size,
> +				  priv->tx_wqe_base, priv->tx_wqe_base_dma);
> +		return -ENOMEM;
> +	}
> +
> +	/* Write TX CC base address into MMIO reg */
> +	writeq(priv->tx_cc_dma, priv->base + MLXBF_GIGE_TX_CI_UPDATE_ADDRESS);
> +
> +	writeq(ilog2(priv->tx_q_entries),
> +	       priv->base + MLXBF_GIGE_TX_WQ_SIZE_LOG2);
> +
> +	priv->prev_tx_ci = 0;
> +	priv->tx_pi = 0;
> +
> +	return 0;
> +}

> +/* Start of struct ethtool_ops functions */
> +static int mlxbf_gige_get_regs_len(struct net_device *netdev)
> +{
> +	/* Return size of MMIO register space (in bytes).
> +	 *
> +	 * NOTE: MLXBF_GIGE_MAC_CFG is the last defined register offset,
> +	 * so use that plus size of single register to derive total size
> +	 */
> +	return MLXBF_GIGE_MAC_CFG + 8;

Please make a define for this, instead of the comment.

> +}
> +
> +static void mlxbf_gige_get_regs(struct net_device *netdev,
> +				struct ethtool_regs *regs, void *p)
> +{
> +	struct mlxbf_gige *priv = netdev_priv(netdev);
> +	__be64 *buff = p;
> +	int reg;
> +
> +	regs->version = MLXBF_GIGE_REGS_VERSION;
> +
> +	/* Read entire MMIO register space and store results
> +	 * into the provided buffer. Each 64-bit word is converted
> +	 * to big-endian to make the output more readable.
> +	 *
> +	 * NOTE: by design, a read to an offset without an existing
> +	 *       register will be acknowledged and return zero.
> +	 */
> +	for (reg = 0; reg <= MLXBF_GIGE_MAC_CFG; reg += 8)

Also with a define this will look less weird.

> +		*buff++ = cpu_to_be64(readq(priv->base + reg));

Can you use memcpy_fromio()?

> +}
> +
> +static void mlxbf_gige_get_ringparam(struct net_device *netdev,
> +				     struct ethtool_ringparam *ering)
> +{
> +	struct mlxbf_gige *priv = netdev_priv(netdev);
> +
> +	memset(ering, 0, sizeof(*ering));

No need, core clears this.

> +	ering->rx_max_pending = MLXBF_GIGE_MAX_RXQ_SZ;
> +	ering->tx_max_pending = MLXBF_GIGE_MAX_TXQ_SZ;
> +	ering->rx_pending = priv->rx_q_entries;
> +	ering->tx_pending = priv->tx_q_entries;
> +}
> +
> +static int mlxbf_gige_set_ringparam(struct net_device *netdev,
> +				    struct ethtool_ringparam *ering)
> +{
> +	const struct net_device_ops *ops = netdev->netdev_ops;
> +	struct mlxbf_gige *priv = netdev_priv(netdev);
> +	int new_rx_q_entries, new_tx_q_entries;
> +
> +	/* Device does not have separate queues for small/large frames */
> +	if (ering->rx_mini_pending || ering->rx_jumbo_pending)
> +		return -EINVAL;
> +
> +	/* Round up to supported values */
> +	new_rx_q_entries = roundup_pow_of_two(ering->rx_pending);
> +	new_tx_q_entries = roundup_pow_of_two(ering->tx_pending);
> +
> +	/* Range check the new values */
> +	if (new_tx_q_entries < MLXBF_GIGE_MIN_TXQ_SZ ||
> +	    new_tx_q_entries > MLXBF_GIGE_MAX_TXQ_SZ ||
> +	    new_rx_q_entries < MLXBF_GIGE_MIN_RXQ_SZ ||
> +	    new_rx_q_entries > MLXBF_GIGE_MAX_RXQ_SZ)

No need to check against max values, core does that.

> +		return -EINVAL;
> +
> +	/* If queue sizes did not change, exit now */
> +	if (new_rx_q_entries == priv->rx_q_entries &&
> +	    new_tx_q_entries == priv->tx_q_entries)
> +		return 0;
> +
> +	if (netif_running(netdev))
> +		ops->ndo_stop(netdev);
> +
> +	priv->rx_q_entries = new_rx_q_entries;
> +	priv->tx_q_entries = new_tx_q_entries;
> +
> +	if (netif_running(netdev))
> +		ops->ndo_open(netdev);

Please write the driver in a way where full stopping and starting the
interface, risking memory allocation failures is not necessary to
reconfigure rings.

> +	return 0;
> +}
> +
> +static void mlxbf_gige_get_drvinfo(struct net_device *netdev,
> +				   struct ethtool_drvinfo *info)
> +{
> +	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
> +	strlcpy(info->bus_info, dev_name(&netdev->dev), sizeof(info->bus_info));
> +}

If this is all you report - you don't need to implement drvinfo.
Core fills those in.

> +static void mlxbf_gige_get_ethtool_stats(struct net_device *netdev,
> +					 struct ethtool_stats *estats,
> +					 u64 *data)
> +{
> +	struct mlxbf_gige *priv = netdev_priv(netdev);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&priv->lock, flags);

Why do you take a lock around stats?

> +	/* Fill data array with interface statistics
> +	 *
> +	 * NOTE: the data writes must be in
> +	 *       sync with the strings shown in
> +	 *       the mlxbf_gige_ethtool_stats_keys[] array
> +	 *
> +	 * NOTE2: certain statistics below are zeroed upon
> +	 *        port disable, so the calculation below
> +	 *        must include the "cached" value of the stat
> +	 *        plus the value read directly from hardware.
> +	 *        Cached statistics are currently:
> +	 *          rx_din_dropped_pkts
> +	 *          rx_filter_passed_pkts
> +	 *          rx_filter_discard_pkts
> +	 */
> +	*data++ = netdev->stats.rx_bytes;
> +	*data++ = netdev->stats.rx_packets;
> +	*data++ = netdev->stats.tx_bytes;
> +	*data++ = netdev->stats.tx_packets;

Please don't duplicate standard stats in ethtool.

> +	*data++ = priv->stats.hw_access_errors;
> +	*data++ = priv->stats.tx_invalid_checksums;
> +	*data++ = priv->stats.tx_small_frames;
> +	*data++ = priv->stats.tx_index_errors;
> +	*data++ = priv->stats.sw_config_errors;
> +	*data++ = priv->stats.sw_access_errors;
> +	*data++ = priv->stats.rx_truncate_errors;
> +	*data++ = priv->stats.rx_mac_errors;
> +	*data++ = (priv->stats.rx_din_dropped_pkts +
> +		   readq(priv->base + MLXBF_GIGE_RX_DIN_DROP_COUNTER));
> +	*data++ = priv->stats.tx_fifo_full;
> +	*data++ = (priv->stats.rx_filter_passed_pkts +
> +		   readq(priv->base + MLXBF_GIGE_RX_PASS_COUNTER_ALL));
> +	*data++ = (priv->stats.rx_filter_discard_pkts +
> +		   readq(priv->base + MLXBF_GIGE_RX_DISC_COUNTER_ALL));
> +
> +	spin_unlock_irqrestore(&priv->lock, flags);
> +}

> +static int mlxbf_gige_get_link_ksettings(struct net_device *netdev,
> +					 struct ethtool_link_ksettings *link_ksettings)
> +{
> +	struct phy_device *phydev = netdev->phydev;
> +	u32 supported, advertising;
> +	u32 lp_advertising = 0;
> +	int status;
> +
> +	supported = SUPPORTED_TP | SUPPORTED_1000baseT_Full |
> +		    SUPPORTED_Autoneg | SUPPORTED_Pause;
> +
> +	advertising = ADVERTISED_1000baseT_Full | ADVERTISED_Autoneg |
> +		      ADVERTISED_Pause;
> +
> +	status = phy_read(phydev, MII_LPA);
> +	if (status >= 0)
> +		lp_advertising = mii_lpa_to_ethtool_lpa_t(status & 0xffff);
> +
> +	status = phy_read(phydev, MII_STAT1000);
> +	if (status >= 0)
> +		lp_advertising |= mii_stat1000_to_ethtool_lpa_t(status & 0xffff);
> +
> +	ethtool_convert_legacy_u32_to_link_mode(link_ksettings->link_modes.supported,
> +						supported);
> +	ethtool_convert_legacy_u32_to_link_mode(link_ksettings->link_modes.advertising,
> +						advertising);
> +	ethtool_convert_legacy_u32_to_link_mode(link_ksettings->link_modes.lp_advertising,
> +						lp_advertising);
> +
> +	link_ksettings->base.autoneg = AUTONEG_ENABLE;
> +	link_ksettings->base.speed = SPEED_1000;
> +	link_ksettings->base.duplex = DUPLEX_FULL;

Hm. You're reporting this even if the link is down?

> +	link_ksettings->base.port = PORT_TP;
> +	link_ksettings->base.phy_address = MLXBF_GIGE_MDIO_DEFAULT_PHY_ADDR;
> +	link_ksettings->base.transceiver = XCVR_INTERNAL;
> +	link_ksettings->base.mdio_support = ETH_MDIO_SUPPORTS_C22;
> +	link_ksettings->base.eth_tp_mdix = ETH_TP_MDI_INVALID;
> +	link_ksettings->base.eth_tp_mdix_ctrl = ETH_TP_MDI_INVALID;

> +static irqreturn_t mlxbf_gige_rx_intr(int irq, void *dev_id)
> +{
> +	struct mlxbf_gige *priv;
> +
> +	priv = dev_id;
> +
> +	priv->rx_intr_count++;
> +
> +	/* Driver has been interrupted because a new packet is available,
> +	 * but do not process packets at this time.  Instead, disable any
> +	 * further "packet rx" interrupts and tell the networking subsystem
> +	 * to poll the driver to pick up all available packets.

I must say these comments really are excessive.

> +	 * NOTE: GigE silicon automatically disables "packet rx" interrupt by
> +	 *       setting MLXBF_GIGE_INT_MASK bit0 upon triggering the interrupt
> +	 *       to the ARM cores.  Software needs to re-enable "packet rx"
> +	 *       interrupts by clearing MLXBF_GIGE_INT_MASK bit0.
> +	 */
> +
> +	/* Tell networking subsystem to poll GigE driver */
> +	napi_schedule(&priv->napi);

_irqoff

> +
> +	return IRQ_HANDLED;
> +}
> +static u16 mlxbf_gige_tx_buffs_avail(struct mlxbf_gige *priv)
> +{
> +	unsigned long flags;
> +	u16 avail;
> +
> +	spin_lock_irqsave(&priv->lock, flags);
> +
> +	if (priv->prev_tx_ci == priv->tx_pi)
> +		avail = priv->tx_q_entries - 1;
> +	else
> +		avail = ((priv->tx_q_entries + priv->prev_tx_ci - priv->tx_pi)
> +			  % priv->tx_q_entries) - 1;

Because this is unsigned logic, and q_entries is a power of 2 you
probably don't need the if, and the modulo.

> +	spin_unlock_irqrestore(&priv->lock, flags);
> +
> +	return avail;
> +}
> +
> +static bool mlxbf_gige_handle_tx_complete(struct mlxbf_gige *priv)
> +{
> +	struct net_device_stats *stats;
> +	u16 tx_wqe_index;
> +	u64 *tx_wqe_addr;
> +	u64 tx_status;
> +	u16 tx_ci;
> +
> +	tx_status = readq(priv->base + MLXBF_GIGE_TX_STATUS);
> +	if (tx_status & MLXBF_GIGE_TX_STATUS_DATA_FIFO_FULL)
> +		priv->stats.tx_fifo_full++;
> +	tx_ci = readq(priv->base + MLXBF_GIGE_TX_CONSUMER_INDEX);
> +	stats = &priv->netdev->stats;
> +
> +	/* Transmit completion logic needs to loop until the completion
> +	 * index (in SW) equals TX consumer index (from HW).  These
> +	 * parameters are unsigned 16-bit values and the wrap case needs
> +	 * to be supported, that is TX consumer index wrapped from 0xFFFF
> +	 * to 0 while TX completion index is still < 0xFFFF.
> +	 */
> +	for (; priv->prev_tx_ci != tx_ci; priv->prev_tx_ci++) {
> +		tx_wqe_index = priv->prev_tx_ci % priv->tx_q_entries;
> +		/* Each TX WQE is 16 bytes. The 8 MSB store the 2KB TX
> +		 * buffer address and the 8 LSB contain information
> +		 * about the TX WQE.
> +		 */
> +		tx_wqe_addr = priv->tx_wqe_base +
> +			       (tx_wqe_index * MLXBF_GIGE_TX_WQE_SZ_QWORDS);
> +
> +		stats->tx_packets++;
> +		stats->tx_bytes += MLXBF_GIGE_TX_WQE_PKT_LEN(tx_wqe_addr);
> +		dma_free_coherent(priv->dev, MLXBF_GIGE_DEFAULT_BUF_SZ,
> +				  priv->tx_buf[tx_wqe_index], *tx_wqe_addr);
> +		priv->tx_buf[tx_wqe_index] = NULL;
> +	}
> +
> +	/* Since the TX ring was likely just drained, check if TX queue
> +	 * had previously been stopped and now that there are TX buffers
> +	 * available the TX queue can be awakened.
> +	 */
> +	if (netif_queue_stopped(priv->netdev) &&
> +	    mlxbf_gige_tx_buffs_avail(priv)) {
> +		netif_wake_queue(priv->netdev);
> +	}

No need for parens.

> +
> +	return true;
> +}
> +
> +static bool mlxbf_gige_rx_packet(struct mlxbf_gige *priv, int *rx_pkts)
> +{
> +	struct net_device *netdev = priv->netdev;
> +	u16 rx_pi_rem, rx_ci_rem;
> +	struct sk_buff *skb;
> +	u64 *rx_cqe_addr;
> +	u64 datalen;
> +	u64 rx_cqe;
> +	u16 rx_ci;
> +	u16 rx_pi;
> +	u8 *pktp;
> +
> +	/* Index into RX buffer array is rx_pi w/wrap based on RX_CQE_SIZE */
> +	rx_pi = readq(priv->base + MLXBF_GIGE_RX_WQE_PI);
> +	rx_pi_rem = rx_pi % priv->rx_q_entries;
> +	pktp = priv->rx_buf[rx_pi_rem];
> +	rx_cqe_addr = priv->rx_cqe_base + rx_pi_rem;
> +	rx_cqe = *rx_cqe_addr;
> +	datalen = rx_cqe & MLXBF_GIGE_RX_CQE_PKT_LEN_MASK;
> +
> +	if ((rx_cqe & MLXBF_GIGE_RX_CQE_PKT_STATUS_MASK) == 0) {
> +		/* Packet is OK, increment stats */
> +		netdev->stats.rx_packets++;
> +		netdev->stats.rx_bytes += datalen;
> +
> +		skb = dev_alloc_skb(datalen);
> +		if (!skb) {
> +			netdev->stats.rx_dropped++;
> +			return false;
> +		}
> +
> +		memcpy(skb_put(skb, datalen), pktp, datalen);
> +
> +		skb->dev = netdev;
> +		skb->protocol = eth_type_trans(skb, netdev);
> +		skb->ip_summed = CHECKSUM_NONE; /* device did not checksum packet */
> +
> +		netif_receive_skb(skb);
> +	} else if (rx_cqe & MLXBF_GIGE_RX_CQE_PKT_STATUS_MAC_ERR) {
> +		priv->stats.rx_mac_errors++;
> +	} else if (rx_cqe & MLXBF_GIGE_RX_CQE_PKT_STATUS_TRUNCATED) {
> +		priv->stats.rx_truncate_errors++;
> +	}
> +
> +	/* Let hardware know we've replenished one buffer */
> +	writeq(rx_pi + 1, priv->base + MLXBF_GIGE_RX_WQE_PI);
> +
> +	(*rx_pkts)++;
> +	rx_pi = readq(priv->base + MLXBF_GIGE_RX_WQE_PI);
> +	rx_pi_rem = rx_pi % priv->rx_q_entries;
> +	rx_ci = readq(priv->base + MLXBF_GIGE_RX_CQE_PACKET_CI);
> +	rx_ci_rem = rx_ci % priv->rx_q_entries;

Looks really wasteful to keep reading IO registers on every packet,
while you may already know there is more from the previous iteration..

> +	return rx_pi_rem != rx_ci_rem;
> +}
> +
> +/* Driver poll() function called by NAPI infrastructure */
> +static int mlxbf_gige_poll(struct napi_struct *napi, int budget)
> +{
> +	struct mlxbf_gige *priv;
> +	bool remaining_pkts;
> +	int work_done = 0;
> +	u64 data;
> +
> +	priv = container_of(napi, struct mlxbf_gige, napi);
> +
> +	mlxbf_gige_handle_tx_complete(priv);
> +
> +	do {
> +		remaining_pkts = mlxbf_gige_rx_packet(priv, &work_done);
> +	} while (remaining_pkts && work_done < budget);
> +
> +	/* If amount of work done < budget, turn off NAPI polling
> +	 * via napi_complete_done(napi, work_done) and then
> +	 * re-enable interrupts.
> +	 */
> +	if (work_done < budget && napi_complete_done(napi, work_done)) {
> +		/* Clear MLXBF_GIGE_INT_MASK 'receive pkt' bit to
> +		 * indicate receive readiness
> +		 */
> +		data = readq(priv->base + MLXBF_GIGE_INT_MASK);
> +		data &= ~MLXBF_GIGE_INT_MASK_RX_RECEIVE_PACKET;
> +		writeq(data, priv->base + MLXBF_GIGE_INT_MASK);
> +	}
> +
> +	return work_done;
> +}
> +
> +static int mlxbf_gige_request_irqs(struct mlxbf_gige *priv)
> +{
> +	int err;
> +
> +	err = devm_request_irq(priv->dev, priv->error_irq,
> +			       mlxbf_gige_error_intr, 0, "mlxbf_gige_error",
> +			       priv);
> +	if (err) {
> +		dev_err(priv->dev, "Request error_irq failure\n");
> +		return err;
> +	}
> +
> +	err = devm_request_irq(priv->dev, priv->rx_irq,
> +			       mlxbf_gige_rx_intr, 0, "mlxbf_gige_rx",
> +			       priv);
> +	if (err) {
> +		dev_err(priv->dev, "Request rx_irq failure\n");
> +		return err;
> +	}
> +
> +	err = devm_request_irq(priv->dev, priv->llu_plu_irq,
> +			       mlxbf_gige_llu_plu_intr, 0, "mlxbf_gige_llu_plu",
> +			       priv);
> +	if (err) {
> +		dev_err(priv->dev, "Request llu_plu_irq failure\n");
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
> +static void mlxbf_gige_free_irqs(struct mlxbf_gige *priv)
> +{
> +	devm_free_irq(priv->dev, priv->error_irq, priv);
> +	devm_free_irq(priv->dev, priv->rx_irq, priv);
> +	devm_free_irq(priv->dev, priv->llu_plu_irq, priv);

What's the point of devm if you free them manually, just use normal
routines, please.

> +}

> +static void mlxbf_gige_clean_port(struct mlxbf_gige *priv)
> +{
> +	u64 control, status;
> +	int cnt;
> +
> +	/* Set the CLEAN_PORT_EN bit to trigger SW reset */
> +	control = readq(priv->base + MLXBF_GIGE_CONTROL);
> +	control |= MLXBF_GIGE_CONTROL_CLEAN_PORT_EN;
> +	writeq(control, priv->base + MLXBF_GIGE_CONTROL);
> +
> +	/* Loop waiting for status ready bit to assert */
> +	cnt = 1000;
> +	do {
> +		status = readq(priv->base + MLXBF_GIGE_STATUS);
> +		if (status & MLXBF_GIGE_STATUS_READY)
> +			break;
> +		usleep_range(50, 100);
> +	} while (--cnt > 0);

check out linux/iopoll.h

> +	/* Clear the CLEAN_PORT_EN bit at end of this loop */
> +	control = readq(priv->base + MLXBF_GIGE_CONTROL);
> +	control &= ~MLXBF_GIGE_CONTROL_CLEAN_PORT_EN;
> +	writeq(control, priv->base + MLXBF_GIGE_CONTROL);
> +}
> +
> +static int mlxbf_gige_open(struct net_device *netdev)
> +{
> +	struct mlxbf_gige *priv = netdev_priv(netdev);
> +	struct phy_device *phydev = netdev->phydev;
> +	u64 int_en;
> +	int err;
> +
> +	mlxbf_gige_cache_stats(priv);
> +	mlxbf_gige_clean_port(priv);
> +	mlxbf_gige_rx_init(priv);
> +	mlxbf_gige_tx_init(priv);

These can fail.

> +	netif_napi_add(netdev, &priv->napi, mlxbf_gige_poll, NAPI_POLL_WEIGHT);
> +	napi_enable(&priv->napi);
> +	netif_start_queue(netdev);
> +
> +	err = mlxbf_gige_request_irqs(priv);

Request IRQs before you start enabling NAPI and doing stuff that can't
fail.

> +	if (err)
> +		return err;
> +
> +	phy_start(phydev);
> +
> +	/* Set bits in INT_EN that we care about */
> +	int_en = MLXBF_GIGE_INT_EN_HW_ACCESS_ERROR |
> +		 MLXBF_GIGE_INT_EN_TX_CHECKSUM_INPUTS |
> +		 MLXBF_GIGE_INT_EN_TX_SMALL_FRAME_SIZE |
> +		 MLXBF_GIGE_INT_EN_TX_PI_CI_EXCEED_WQ_SIZE |
> +		 MLXBF_GIGE_INT_EN_SW_CONFIG_ERROR |
> +		 MLXBF_GIGE_INT_EN_SW_ACCESS_ERROR |
> +		 MLXBF_GIGE_INT_EN_RX_RECEIVE_PACKET;
> +	writeq(int_en, priv->base + MLXBF_GIGE_INT_EN);
> +
> +	return 0;
> +}

> +static netdev_tx_t mlxbf_gige_start_xmit(struct sk_buff *skb,
> +					 struct net_device *netdev)
> +{
> +	struct mlxbf_gige *priv = netdev_priv(netdev);
> +	dma_addr_t tx_buf_dma;
> +	u8 *tx_buf = NULL;
> +	u64 *tx_wqe_addr;
> +	u64 word2;
> +
> +	/* Check that there is room left in TX ring */
> +	if (!mlxbf_gige_tx_buffs_avail(priv)) {
> +		/* TX ring is full, inform stack but do not free SKB */
> +		netif_stop_queue(netdev);
> +		netdev->stats.tx_dropped++;
> +		return NETDEV_TX_BUSY;

Stop the queue when the last index gets used, not when a frame that
overflows the ring arrives. re-queuing skbs is expensive.

> +	}
> +
> +	/* Allocate ptr for buffer */
> +	if (skb->len < MLXBF_GIGE_DEFAULT_BUF_SZ)
> +		tx_buf = dma_alloc_coherent(priv->dev, MLXBF_GIGE_DEFAULT_BUF_SZ,
> +					    &tx_buf_dma, GFP_KERNEL);
> +
> +	if (!tx_buf) {
> +		/* Free incoming skb, could not alloc TX buffer */
> +		dev_kfree_skb(skb);
> +		netdev->stats.tx_dropped++;
> +		return NET_XMIT_DROP;
> +	}
> +
> +	priv->tx_buf[priv->tx_pi % priv->tx_q_entries] = tx_buf;
> +
> +	/* Copy data from skb to allocated TX buffer
> +	 *
> +	 * NOTE: GigE silicon will automatically pad up to
> +	 *       minimum packet length if needed.
> +	 */
> +	skb_copy_bits(skb, 0, tx_buf, skb->len);

Why do you copy data for both TX and RX?! Can't you map the skb data
directly?

> +	/* Get address of TX WQE */
> +	tx_wqe_addr = priv->tx_wqe_next;
> +
> +	mlxbf_gige_update_tx_wqe_next(priv);
> +
> +	/* Put PA of buffer address into first 64-bit word of TX WQE */
> +	*tx_wqe_addr = tx_buf_dma;
> +
> +	/* Set TX WQE pkt_len appropriately */
> +	word2 = skb->len & MLXBF_GIGE_TX_WQE_PKT_LEN_MASK;
> +
> +	/* Write entire 2nd word of TX WQE */
> +	*(tx_wqe_addr + 1) = word2;
> +
> +	priv->tx_pi++;
> +
> +	/* Create memory barrier before write to TX PI */
> +	wmb();

please implement xmit_more

> +	writeq(priv->tx_pi, priv->base + MLXBF_GIGE_TX_PRODUCER_INDEX);
> +
> +	/* Free incoming skb, contents already copied to HW */
> +	dev_kfree_skb(skb);

No, you can't do that. The socket that produced this data will think
it's already on the wire and bombard you with more data.

> +	return NETDEV_TX_OK;
> +}

> +static const struct net_device_ops mlxbf_gige_netdev_ops = {
> +	.ndo_open		= mlxbf_gige_open,
> +	.ndo_stop		= mlxbf_gige_stop,
> +	.ndo_start_xmit		= mlxbf_gige_start_xmit,
> +	.ndo_set_mac_address	= eth_mac_addr,
> +	.ndo_validate_addr	= eth_validate_addr,
> +	.ndo_do_ioctl		= mlxbf_gige_do_ioctl,
> +	.ndo_set_rx_mode        = mlxbf_gige_set_rx_mode,

You must report standard stats.

> +};
> +
> +static u64 mlxbf_gige_mac_to_u64(u8 *addr)
> +{
> +	u64 mac = 0;
> +	int i;
> +
> +	for (i = 0; i < ETH_ALEN; i++) {
> +		mac <<= 8;
> +		mac |= addr[i];
> +	}
> +	return mac;
> +}

ether_addr_to_u64()

> +static void mlxbf_gige_u64_to_mac(u8 *addr, u64 mac)
> +{
> +	int i;
> +
> +	for (i = ETH_ALEN; i > 0; i--) {
> +		addr[i - 1] = mac & 0xFF;
> +		mac >>= 8;
> +	}
> +}

u64_to_ether_addr()
