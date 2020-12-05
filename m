Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A39FF2CF930
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 04:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbgLEDhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 22:37:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:40144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725300AbgLEDhp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 22:37:45 -0500
Date:   Fri, 4 Dec 2020 19:37:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607139424;
        bh=1JZ+9Lc4Fbd1IKvWnVBzvYQb9NEPqVa+B6/FxWbE6P0=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=emTnzGjcpTnbaOlQp6Qzh4t1s9qOQd3H0HNjVpb8/98WAkmyhn1shBMcMsLz8VTSz
         MqSGmYJvtqqOohpdZFkPxr4JwPw3Co5imekIdEV2MDEK3m3WZkLM54K6p21IcTIp6o
         oJEWzi2Vv6HbGA/Zq3cMJHlatseXHoGXB/juWwbJm09p9mjDtKjMjaCZ6mKX5AvN7g
         oMjYEMd2EXm6LqoU7SmasxoyuCaU+Fj1yJZoEvqGIS1qgnkTdKmx5nS8REKE+Vc6zB
         v9avvktQw4NtWYfNJLEA18th6N2SlOtijoPFyc0UxBjBCvqcYUpEBCco4wA40b4aeF
         TIRVTZgG5Ya2Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?xYF1a2Fzeg==?= Stelmach <l.stelmach@samsung.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        =?UTF-8?B?QmFydMWCb21pZWogxbtvbG5pZXJr?= =?UTF-8?B?aWV3aWN6?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v8 3/3] net: ax88796c: ASIX AX88796C SPI Ethernet
 Adapter Driver
Message-ID: <20201204193702.1e4b0427@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201202214709.16192-4-l.stelmach@samsung.com>
References: <20201202214709.16192-1-l.stelmach@samsung.com>
        <CGME20201202214712eucas1p213bfb590b05086954a6ccd13deabe450@eucas1p2.samsung.com>
        <20201202214709.16192-4-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Dec 2020 22:47:09 +0100 =C5=81ukasz Stelmach wrote:
> ASIX AX88796[1] is a versatile ethernet adapter chip, that can be
> connected to a CPU with a 8/16-bit bus or with an SPI. This driver
> supports SPI connection.
>=20
> The driver has been ported from the vendor kernel for ARTIK5[2]
> boards. Several changes were made to adapt it to the current kernel
> which include:
>=20
> + updated DT configuration,
> + clock configuration moved to DT,
> + new timer, ethtool and gpio APIs,
> + dev_* instead of pr_* and custom printk() wrappers,
> + removed awkward vendor power managemtn.
> + introduced ethtool tunable to control SPI compression
>=20
> [1] https://www.asix.com.tw/products.php?op=3DpItemdetail&PItemID=3D104;6=
5;86&PLine=3D65
> [2] https://git.tizen.org/cgit/profile/common/platform/kernel/linux-3.10-=
artik/
>=20
> The other ax88796 driver is for NE2000 compatible AX88796L chip. These
> chips are not compatible. Hence, two separate drivers are required.
>=20
> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

> +	case ETHTOOL_SPI_COMPRESSION:
> +		if (netif_running(ndev))
> +			return -EBUSY;
> +		if ((*(u32 *)data) !=3D 1)
> +			return -EINVAL;
> +		ax_local->capabilities &=3D ~AX_CAP_COMP;
> +		ax_local->capabilities |=3D (*(u32 *)data) =3D=3D 1 ? AX_CAP_COMP : 0;

Since you're just using a single bit of information please use=20
a private driver flag.

> +	headroom =3D skb_headroom(skb);
> +	tailroom =3D skb_tailroom(skb);
> +	padlen =3D ((pkt_len + 3) & 0x7FC) - pkt_len;

	round_up(pkt_len, 4) - pkt_len;

> +	tol_len =3D ((pkt_len + 3) & 0x7FC) +
> +			TX_OVERHEAD + TX_EOP_SIZE + spi_len;

Ditto

> +	seq_num =3D ++ax_local->seq_num & 0x1F;
> +
> +	info =3D (struct tx_pkt_info *)skb->cb;
> +	info->pkt_len =3D pkt_len;
> +
> +	if ((!skb_cloned(skb)) &&
> +	    (headroom >=3D (TX_OVERHEAD + spi_len)) &&
> +	    (tailroom >=3D (padlen + TX_EOP_SIZE))) {

> +	} else {

I think you can just use pskb_expand_head() instead of all this

> +		tx_skb =3D alloc_skb(tol_len, GFP_KERNEL);
> +		if (!tx_skb)
> +			return NULL;
> +
> +		/* Write SPI TXQ header */
> +		memcpy(skb_put(tx_skb, spi_len), ax88796c_tx_cmd_buf, spi_len);
> +
> +		info->seq_num =3D seq_num;
> +		ax88796c_proc_tx_hdr(info, skb->ip_summed);
> +
> +		/* SOP and SEG header */
> +		memcpy(skb_put(tx_skb, TX_OVERHEAD),
> +		       &info->sop, TX_OVERHEAD);
> +
> +		/* Packet */
> +		memcpy(skb_put(tx_skb, ((pkt_len + 3) & 0xFFFC)),
> +		       skb->data, pkt_len);
> +
> +		/* EOP header */
> +		memcpy(skb_put(tx_skb, TX_EOP_SIZE),
> +		       &info->eop, TX_EOP_SIZE);
> +
> +		skb_unlink(skb, q);
> +		dev_kfree_skb(skb);
> +	}

> +static void
> +ax88796c_skb_return(struct ax88796c_device *ax_local, struct sk_buff *sk=
b,
> +		    struct rx_header *rxhdr)
> +{
> +	struct net_device *ndev =3D ax_local->ndev;
> +	int status;
> +
> +	do {
> +		if (!(ndev->features & NETIF_F_RXCSUM))
> +			break;
> +
> +		/* checksum error bit is set */
> +		if ((rxhdr->flags & RX_HDR3_L3_ERR) ||
> +		    (rxhdr->flags & RX_HDR3_L4_ERR))
> +			break;
> +
> +		/* Other types may be indicated by more than one bit. */
> +		if ((rxhdr->flags & RX_HDR3_L4_TYPE_TCP) ||
> +		    (rxhdr->flags & RX_HDR3_L4_TYPE_UDP))
> +			skb->ip_summed =3D CHECKSUM_UNNECESSARY;
> +	} while (0);
> +
> +	ax_local->stats.rx_packets++;
> +	ax_local->stats.rx_bytes +=3D skb->len;
> +	skb->dev =3D ndev;
> +
> +	skb->truesize =3D skb->len + sizeof(struct sk_buff);

Why do you modify truesize?

> +	skb->protocol =3D eth_type_trans(skb, ax_local->ndev);
> +
> +	netif_info(ax_local, rx_status, ndev, "< rx, len %zu, type 0x%x\n",
> +		   skb->len + sizeof(struct ethhdr), skb->protocol);
> +
> +	status =3D netif_rx_ni(skb);
> +	if (status !=3D NET_RX_SUCCESS)
> +		netif_info(ax_local, rx_err, ndev,
> +			   "netif_rx status %d\n", status);
> +}
> +
> +static void
> +ax88796c_rx_fixup(struct ax88796c_device *ax_local, struct sk_buff *rx_s=
kb)
> +{
> +	struct rx_header *rxhdr =3D (struct rx_header *)rx_skb->data;
> +	struct net_device *ndev =3D ax_local->ndev;
> +	u16 len;
> +
> +	be16_to_cpus(&rxhdr->flags_len);
> +	be16_to_cpus(&rxhdr->seq_lenbar);
> +	be16_to_cpus(&rxhdr->flags);
> +
> +	if ((((short)rxhdr->flags_len) & RX_HDR1_PKT_LEN) !=3D
> +			 (~((short)rxhdr->seq_lenbar) & 0x7FF)) {

Why do you cast these values to signed types?
Is the casting necessary at all?

> +		netif_err(ax_local, rx_err, ndev, "Header error\n");
> +
> +		ax_local->stats.rx_frame_errors++;
> +		kfree_skb(rx_skb);
> +		return;
> +	}
> +
> +	if ((rxhdr->flags_len & RX_HDR1_MII_ERR) ||
> +	    (rxhdr->flags_len & RX_HDR1_CRC_ERR)) {
> +		netif_err(ax_local, rx_err, ndev, "CRC or MII error\n");
> +
> +		ax_local->stats.rx_crc_errors++;
> +		kfree_skb(rx_skb);
> +		return;
> +	}
> +
> +	len =3D rxhdr->flags_len & RX_HDR1_PKT_LEN;
> +	if (netif_msg_pktdata(ax_local)) {
> +		char pfx[IFNAMSIZ + 7];
> +
> +		snprintf(pfx, sizeof(pfx), "%s:     ", ndev->name);
> +		netdev_info(ndev, "RX data, total len %d, packet len %d\n",
> +			    rx_skb->len, len);
> +
> +		netdev_info(ndev, "  Dump RX packet header:");
> +		print_hex_dump(KERN_INFO, pfx, DUMP_PREFIX_OFFSET, 16, 1,
> +			       rx_skb->data, sizeof(*rxhdr), 0);
> +
> +		netdev_info(ndev, "  Dump RX packet:");
> +		print_hex_dump(KERN_INFO, pfx, DUMP_PREFIX_OFFSET, 16, 1,
> +			       rx_skb->data + sizeof(*rxhdr), len, 0);
> +	}
> +
> +	skb_pull(rx_skb, sizeof(*rxhdr));
> +	__pskb_trim(rx_skb, len);

Why __pskb_trim? skb_trim() should do.

> +	return ax88796c_skb_return(ax_local, rx_skb, rxhdr);

please drop the "return", both caller and callee are void.

> +}
> +
> +static int ax88796c_receive(struct net_device *ndev)
> +{
> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
> +	struct skb_data *entry;
> +	u16 w_count, pkt_len;
> +	struct sk_buff *skb;
> +	u8 pkt_cnt;
> +
> +	WARN_ON(!mutex_is_locked(&ax_local->spi_lock));
> +
> +	/* check rx packet and total word count */
> +	AX_WRITE(&ax_local->ax_spi, AX_READ(&ax_local->ax_spi, P0_RTWCR)
> +		  | RTWCR_RX_LATCH, P0_RTWCR);
> +
> +	pkt_cnt =3D AX_READ(&ax_local->ax_spi, P0_RXBCR2) & RXBCR2_PKT_MASK;
> +	if (!pkt_cnt)
> +		return 0;
> +
> +	pkt_len =3D AX_READ(&ax_local->ax_spi, P0_RCPHR) & 0x7FF;
> +
> +	w_count =3D ((pkt_len + 6 + 3) & 0xFFFC) >> 1;
> +
> +	skb =3D alloc_skb((w_count * 2), GFP_ATOMIC);

netdev_alloc_skb()

> +	if (!skb) {
> +		AX_WRITE(&ax_local->ax_spi, RXBCR1_RXB_DISCARD, P0_RXBCR1);
> +		return 0;
> +	}
> +	entry =3D (struct skb_data *)skb->cb;
> +
> +	AX_WRITE(&ax_local->ax_spi, RXBCR1_RXB_START | w_count, P0_RXBCR1);
> +
> +	axspi_read_rxq(&ax_local->ax_spi,
> +		       skb_put(skb, w_count * 2), skb->len);
> +
> +	/* Check if rx bridge is idle */
> +	if ((AX_READ(&ax_local->ax_spi, P0_RXBCR2) & RXBCR2_RXB_IDLE) =3D=3D 0)=
 {
> +		netif_err(ax_local, rx_err, ndev,
> +			  "Rx Bridge is not idle\n");
> +		AX_WRITE(&ax_local->ax_spi, RXBCR2_RXB_REINIT, P0_RXBCR2);
> +
> +		entry->state =3D rx_err;
> +	} else {
> +		entry->state =3D rx_done;
> +	}
> +
> +	AX_WRITE(&ax_local->ax_spi, ISR_RXPKT, P0_ISR);
> +
> +	ax88796c_rx_fixup(ax_local, skb);
> +
> +	return 1;
> +}

> +static irqreturn_t ax88796c_interrupt(int irq, void *dev_instance)
> +{
> +	struct ax88796c_device *ax_local;
> +	struct net_device *ndev;
> +
> +	ndev =3D dev_instance;
> +	if (!ndev) {
> +		pr_err("irq %d for unknown device.\n", irq);
> +		return IRQ_RETVAL(0);
> +	}
> +	ax_local =3D to_ax88796c_device(ndev);
> +
> +	disable_irq_nosync(irq);
> +
> +	netif_dbg(ax_local, intr, ndev, "Interrupt occurred\n");
> +
> +	set_bit(EVENT_INTR, &ax_local->flags);
> +	schedule_work(&ax_local->ax_work);
> +
> +	return IRQ_HANDLED;
> +}

Since you always punt to a workqueue did you consider just using
threaded interrupts instead?=20

Also you're not checking if this is actually your devices IRQ that
triggered. You can't set IRQF_SHARED.

> +static int
> +ax88796c_open(struct net_device *ndev)
> +{
> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
> +	unsigned long irq_flag =3D IRQF_SHARED;
> +	int fc =3D AX_FC_NONE;
> +	int ret;
> +
> +	ret =3D request_irq(ndev->irq, ax88796c_interrupt,
> +			  irq_flag, ndev->name, ndev);
> +	if (ret) {
> +		netdev_err(ndev, "unable to get IRQ %d (errno=3D%d).\n",
> +			   ndev->irq, ret);
> +		return ret;
> +	}
> +
> +	mutex_lock(&ax_local->spi_lock);
> +
> +	ret =3D ax88796c_soft_reset(ax_local);
> +	if (ret < 0) {
> +		mutex_unlock(&ax_local->spi_lock);
> +		return ret;

What frees the IRQ?

> +	}
> +	ax_local->seq_num =3D 0x1f;
> +
> +	ax88796c_set_mac_addr(ndev);
> +	ax88796c_set_csums(ax_local);
> +
> +	/* Disable stuffing packet */
> +	AX_WRITE(&ax_local->ax_spi,
> +		 AX_READ(&ax_local->ax_spi, P1_RXBSPCR)
> +		 & ~RXBSPCR_STUF_ENABLE, P1_RXBSPCR);

Please use a temporary variable or create a RMW helper.

> +	/* Enable RX packet process */
> +	AX_WRITE(&ax_local->ax_spi, RPPER_RXEN, P1_RPPER);
> +
> +	AX_WRITE(&ax_local->ax_spi, AX_READ(&ax_local->ax_spi, P0_FER)
> +		 | FER_RXEN | FER_TXEN | FER_BSWAP | FER_IRQ_PULL, P0_FER);

Ditto. etc.

> +	ndev =3D devm_alloc_etherdev(&spi->dev, sizeof(*ax_local));
> +	if (!ndev)
> +		return -ENOMEM;
> +
> +	SET_NETDEV_DEV(ndev, &spi->dev);
> +
> +	ax_local =3D to_ax88796c_device(ndev);
> +	memset(ax_local, 0, sizeof(*ax_local));

No need to zero out netdev priv, it's zalloced.

> +	mutex_lock(&ax_local->spi_lock);
> +
> +	/* ax88796c gpio reset */
> +	ax88796c_hard_reset(ax_local);
> +
> +	/* Reset AX88796C */
> +	ret =3D ax88796c_soft_reset(ax_local);
> +	if (ret < 0) {
> +		ret =3D -ENODEV;
> +		goto err;
> +	}
> +	/* Check board revision */
> +	temp =3D AX_READ(&ax_local->ax_spi, P2_CRIR);
> +	if ((temp & 0xF) !=3D 0x0) {
> +		dev_err(&spi->dev, "spi read failed: %d\n", temp);
> +		ret =3D -ENODEV;
> +		goto err;
> +	}

These jump out without releasing the lock.

> +	/* Disable power saving */
> +	AX_WRITE(&ax_local->ax_spi, (AX_READ(&ax_local->ax_spi, P0_PSCR)
> +				     & PSCR_PS_MASK) | PSCR_PS_D0, P0_PSCR);

This is asking for a temporary variable or a RMW helper.

> +	u8			plat_endian;
> +		#define PLAT_LITTLE_ENDIAN	0
> +		#define PLAT_BIG_ENDIAN		1

Why do you store this little nugget of information?

> +/* Tx headers structure */
> +struct tx_sop_header {
> +	/* bit 15-11: flags, bit 10-0: packet length */
> +	u16 flags_len;
> +	/* bit 15-11: sequence number, bit 11-0: packet length bar */
> +	u16 seq_lenbar;
> +} __packed;
> +
> +struct tx_segment_header {
> +	/* bit 15-14: flags, bit 13-11: segment number */
> +	/* bit 10-0: segment length */
> +	u16 flags_seqnum_seglen;
> +	/* bit 15-14: end offset, bit 13-11: start offset */
> +	/* bit 10-0: segment length bar */
> +	u16 eo_so_seglenbar;
> +} __packed;
> +
> +struct tx_eop_header {
> +	/* bit 15-11: sequence number, bit 10-0: packet length */
> +	u16 seq_len;
> +	/* bit 15-11: sequence number bar, bit 10-0: packet length bar */
> +	u16 seqbar_lenbar;
> +} __packed;
> +
> +struct tx_pkt_info {
> +	struct tx_sop_header sop;
> +	struct tx_segment_header seg;
> +	struct tx_eop_header eop;
> +	u16 pkt_len;
> +	u16 seq_num;
> +} __packed;
> +
> +/* Rx headers structure */
> +struct rx_header {
> +	u16 flags_len;
> +	u16 seq_lenbar;
> +	u16 flags;
> +} __packed;

These all look like multiple of 2 bytes. Why do they need to be packed?

> +u16 axspi_read_reg(struct axspi_data *ax_spi, u8 reg)
> +{
> +	int ret;
> +	int len =3D ax_spi->comp ? 3 : 4;
> +
> +	ax_spi->cmd_buf[0] =3D 0x03;	/* OP code read register */
> +	ax_spi->cmd_buf[1] =3D reg;	/* register address */
> +	ax_spi->cmd_buf[2] =3D 0xFF;	/* dumy cycle */
> +	ax_spi->cmd_buf[3] =3D 0xFF;	/* dumy cycle */
> +	ret =3D spi_write_then_read(ax_spi->spi,
> +				  ax_spi->cmd_buf, len,
> +				  ax_spi->rx_buf, 2);
> +	if (ret)
> +		dev_err(&ax_spi->spi->dev, "%s() failed: ret =3D %d\n", __func__, ret);
> +	else
> +		le16_to_cpus(ax_spi->rx_buf);
> +
> +	return *(u16 *)ax_spi->rx_buf;

No need to return some specific pattern on failure? Like 0xffff?
