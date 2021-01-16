Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1DEE2F8A76
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 02:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729406AbhAPB2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 20:28:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:33884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726551AbhAPB2G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 20:28:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67541229F0;
        Sat, 16 Jan 2021 01:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610760444;
        bh=5n7bL1HsU1LCOVcew8p1UGwDgfmh7rVQDysyHv9IBRo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gUK1lo4D+w4Mp2maLa31htKW9C918vwn4R75/M3J9X9l7kkN+uxIcnyaIXpBYl+Z1
         DfYTHo4NHH0ragx6Eb3UiJaXNtTFPj8RGA5PtAn3CtbxdVVFZDrcULjbTua/r69quh
         CQ5XNXorCTRAY5sGzEc8NgcsN+W3e1AU3ITDWk2DaZCdok7RD66LvuNMVCw2JQCkXW
         pK7pef4n3ScNveXvdcqWXkZ0DWhB1HD9sTBarqhN8uF9odktnSbwDlKC2yEICX/smj
         Zrz8SKLC8QBS7iGko3jOaH1UQcMzU2NiZ1FeBHuE85BH7Q1vAINe4WUEYVRLvDj1/5
         K/j1AcXypZ3Vg==
Date:   Fri, 15 Jan 2021 17:27:22 -0800
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
Subject: Re: [PATCH v10 3/3] net: ax88796c: ASIX AX88796C SPI Ethernet
 Adapter Driver
Message-ID: <20210115172722.516468bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210113184028.4433-4-l.stelmach@samsung.com>
References: <20210113184028.4433-1-l.stelmach@samsung.com>
        <CGME20210113184043eucas1p2b08bd9dcfaa8ca15c01f2fbb983f9e7d@eucas1p2.samsung.com>
        <20210113184028.4433-4-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jan 2021 19:40:28 +0100 =C5=81ukasz Stelmach wrote:
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

> +static u32 ax88796c_get_priv_flags(struct net_device *ndev)
> +{
> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
> +
> +        return ax_local->priv_flags;

stray indent

> +}

> +#define MAX(x,y) ((x) > (y) ? (x) : (y))

Please use the standard linux max / max_t macros.

> +static struct sk_buff *
> +ax88796c_tx_fixup(struct net_device *ndev, struct sk_buff_head *q)
> +{
> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
> +	u8 spi_len =3D ax_local->ax_spi.comp ? 1 : 4;
> +	struct sk_buff *skb;
> +	struct tx_pkt_info *info;
> +	struct skb_data *entry;
> +	u16 pkt_len;
> +	u8 padlen, seq_num;
> +	u8 need_pages;
> +	int headroom;
> +	int tailroom;
> +
> +	if (skb_queue_empty(q))
> +		return NULL;
> +
> +	skb =3D skb_peek(q);
> +	pkt_len =3D skb->len;
> +	need_pages =3D (pkt_len + TX_OVERHEAD + 127) >> 7;
> +	if (ax88796c_check_free_pages(ax_local, need_pages) !=3D 0)
> +		return NULL;
> +
> +	headroom =3D skb_headroom(skb);
> +	tailroom =3D skb_tailroom(skb);
> +	padlen =3D round_up(pkt_len, 4) - pkt_len;
> +	seq_num =3D ++ax_local->seq_num & 0x1F;
> +
> +	info =3D (struct tx_pkt_info *)skb->cb;
> +	info->pkt_len =3D pkt_len;
> +
> +	if (skb_cloned(skb) ||
> +	    (headroom < (TX_OVERHEAD + spi_len)) ||
> +	    (tailroom < (padlen + TX_EOP_SIZE))) {
> +		size_t h =3D MAX((TX_OVERHEAD + spi_len) - headroom,0);
> +		size_t t =3D MAX((padlen + TX_EOP_SIZE) - tailroom,0);
> +
> +		if (pskb_expand_head(skb, h, t, GFP_KERNEL))
> +			return NULL;
> +	}
> +
> +	info->seq_num =3D seq_num;
> +	ax88796c_proc_tx_hdr(info, skb->ip_summed);
> +
> +	/* SOP and SEG header */
> +	memcpy(skb_push(skb, TX_OVERHEAD), &info->sop, TX_OVERHEAD);

why use skb->cb to store info? why not declare it on the stack?

> +	/* Write SPI TXQ header */
> +	memcpy(skb_push(skb, spi_len), ax88796c_tx_cmd_buf, spi_len);
> +
> +	/* Make 32-bit alignment */
> +	skb_put(skb, padlen);
> +
> +	/* EOP header */
> +	memcpy(skb_put(skb, TX_EOP_SIZE), &info->eop, TX_EOP_SIZE);
> +
> +	skb_unlink(skb, q);
> +
> +	entry =3D (struct skb_data *)skb->cb;
> +	memset(entry, 0, sizeof(*entry));
> +	entry->len =3D pkt_len;
> +
> +	if (netif_msg_pktdata(ax_local)) {
> +		char pfx[IFNAMSIZ + 7];
> +
> +		snprintf(pfx, sizeof(pfx), "%s:     ", ndev->name);
> +
> +		netdev_info(ndev, "TX packet len %d, total len %d, seq %d\n",
> +			    pkt_len, skb->len, seq_num);
> +
> +		netdev_info(ndev, "  SPI Header:\n");
> +		print_hex_dump(KERN_INFO, pfx, DUMP_PREFIX_OFFSET, 16, 1,
> +			       skb->data, 4, 0);
> +
> +		netdev_info(ndev, "  TX SOP:\n");
> +		print_hex_dump(KERN_INFO, pfx, DUMP_PREFIX_OFFSET, 16, 1,
> +			       skb->data + 4, TX_OVERHEAD, 0);
> +
> +		netdev_info(ndev, "  TX packet:\n");
> +		print_hex_dump(KERN_INFO, pfx, DUMP_PREFIX_OFFSET, 16, 1,
> +			       skb->data + 4 + TX_OVERHEAD,
> +			       skb->len - TX_EOP_SIZE - 4 - TX_OVERHEAD, 0);
> +
> +		netdev_info(ndev, "  TX EOP:\n");
> +		print_hex_dump(KERN_INFO, pfx, DUMP_PREFIX_OFFSET, 16, 1,
> +			       skb->data + skb->len - 4, 4, 0);
> +	}
> +
> +	return skb;
> +}
> +
> +static int ax88796c_hard_xmit(struct ax88796c_device *ax_local)
> +{
> +	struct sk_buff *tx_skb;
> +	struct skb_data *entry;
> +
> +	WARN_ON(!mutex_is_locked(&ax_local->spi_lock));
> +
> +	tx_skb =3D ax88796c_tx_fixup(ax_local->ndev, &ax_local->tx_wait_q);
> +
> +	if (!tx_skb)
> +		return 0;

tx_dropped++ ?

> +	entry =3D (struct skb_data *)tx_skb->cb;
> +
> +	AX_WRITE(&ax_local->ax_spi,
> +		 (TSNR_TXB_START | TSNR_PKT_CNT(1)), P0_TSNR);
> +
> +	axspi_write_txq(&ax_local->ax_spi, tx_skb->data, tx_skb->len);
> +
> +	if (((AX_READ(&ax_local->ax_spi, P0_TSNR) & TXNR_TXB_IDLE) =3D=3D 0) ||
> +	    ((ISR_TXERR & AX_READ(&ax_local->ax_spi, P0_ISR)) !=3D 0)) {
> +		/* Ack tx error int */
> +		AX_WRITE(&ax_local->ax_spi, ISR_TXERR, P0_ISR);
> +
> +		ax_local->stats.tx_dropped++;
> +
> +		netif_err(ax_local, tx_err, ax_local->ndev,
> +			  "TX FIFO error, re-initialize the TX bridge\n");

rate limit

> +		/* Reinitial tx bridge */
> +		AX_WRITE(&ax_local->ax_spi, TXNR_TXB_REINIT |
> +			AX_READ(&ax_local->ax_spi, P0_TSNR), P0_TSNR);
> +		ax_local->seq_num =3D 0;
> +	} else {
> +		ax_local->stats.tx_packets++;
> +		ax_local->stats.tx_bytes +=3D entry->len;
> +	}
> +
> +	entry->state =3D tx_done;
> +	dev_kfree_skb(tx_skb);

dev_consume_skb() is better in cases the xmission was correct.
kfree_skb() shows up in packet drop monitor.

> +
> +	return 1;
> +}

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
> +	skb->protocol =3D eth_type_trans(skb, ax_local->ndev);
> +
> +	netif_info(ax_local, rx_status, ndev, "< rx, len %zu, type 0x%x\n",
> +		   skb->len + sizeof(struct ethhdr), skb->protocol);
> +
> +	status =3D netif_rx_ni(skb);
> +	if (status !=3D NET_RX_SUCCESS)
> +		netif_info(ax_local, rx_err, ndev,
> +			   "netif_rx status %d\n", status);

rate limit

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
> +	if (((rxhdr->flags_len) & RX_HDR1_PKT_LEN) !=3D
> +			 (~(rxhdr->seq_lenbar) & 0x7FF)) {

Lots of unnecessary parenthesis.

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
> +	pskb_trim(rx_skb, len);
> +
> +	ax88796c_skb_return(ax_local, rx_skb, rxhdr);
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

w_count =3D round_up(pkt_len + 6, 4) >> 1;

> +	skb =3D netdev_alloc_skb(ndev, (w_count * 2));

parenthesis unnecessary

> +	if (!skb) {
> +		AX_WRITE(&ax_local->ax_spi, RXBCR1_RXB_DISCARD, P0_RXBCR1);

Increment rx_dropped counter here?

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

rate limit?

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
> +
> +static int ax88796c_process_isr(struct ax88796c_device *ax_local)
> +{
> +	struct net_device *ndev =3D ax_local->ndev;
> +	u8 done =3D 0;

The logic associated with this variable is "is there more to do" rather
than "done", no?

> +	u16 isr;
> +
> +	WARN_ON(!mutex_is_locked(&ax_local->spi_lock));
> +
> +	isr =3D AX_READ(&ax_local->ax_spi, P0_ISR);
> +	AX_WRITE(&ax_local->ax_spi, isr, P0_ISR);
> +
> +	netif_dbg(ax_local, intr, ndev, "  ISR 0x%04x\n", isr);
> +
> +	if (isr & ISR_TXERR) {
> +		netif_dbg(ax_local, intr, ndev, "  TXERR interrupt\n");
> +		AX_WRITE(&ax_local->ax_spi, TXNR_TXB_REINIT, P0_TSNR);
> +		ax_local->seq_num =3D 0x1f;
> +	}
> +
> +	if (isr & ISR_TXPAGES) {
> +		netif_dbg(ax_local, intr, ndev, "  TXPAGES interrupt\n");
> +		set_bit(EVENT_TX, &ax_local->flags);
> +	}
> +
> +	if (isr & ISR_LINK) {
> +		netif_dbg(ax_local, intr, ndev, "  Link change interrupt\n");
> +		phy_mac_interrupt(ax_local->ndev->phydev);
> +	}
> +
> +	if (isr & ISR_RXPKT) {
> +		netif_dbg(ax_local, intr, ndev, "  RX interrupt\n");
> +		done =3D ax88796c_receive(ax_local->ndev);
> +	}
> +
> +	return done;
> +}

> +static void ax88796c_work(struct work_struct *work)
> +{
> +	struct ax88796c_device *ax_local =3D
> +			container_of(work, struct ax88796c_device, ax_work);
> +
> +	mutex_lock(&ax_local->spi_lock);
> +
> +	if (test_bit(EVENT_SET_MULTI, &ax_local->flags)) {
> +		ax88796c_set_hw_multicast(ax_local->ndev);
> +		clear_bit(EVENT_SET_MULTI, &ax_local->flags);
> +	}
> +
> +	if (test_bit(EVENT_INTR, &ax_local->flags)) {
> +		AX_WRITE(&ax_local->ax_spi, IMR_MASKALL, P0_IMR);
> +
> +		while (1) {
> +			if (!ax88796c_process_isr(ax_local))
> +				break;

while (ax88796c_process_isr(ax_local))
	/* nothing */;
?

> +		}
> +
> +		clear_bit(EVENT_INTR, &ax_local->flags);
> +
> +		AX_WRITE(&ax_local->ax_spi, IMR_DEFAULT, P0_IMR);
> +
> +		enable_irq(ax_local->ndev->irq);
> +	}
> +
> +	if (test_bit(EVENT_TX, &ax_local->flags)) {
> +		while (skb_queue_len(&ax_local->tx_wait_q)) {
> +			if (!ax88796c_hard_xmit(ax_local))
> +				break;
> +		}
> +
> +		clear_bit(EVENT_TX, &ax_local->flags);
> +
> +		if (netif_queue_stopped(ax_local->ndev) &&
> +		    (skb_queue_len(&ax_local->tx_wait_q) < TX_QUEUE_LOW_WATER))
> +			netif_wake_queue(ax_local->ndev);
> +	}
> +
> +	mutex_unlock(&ax_local->spi_lock);
> +}

> +static void ax88796c_set_csums(struct ax88796c_device *ax_local)
> +{
> +	struct net_device *ndev =3D ax_local->ndev;
> +
> +	WARN_ON(!mutex_is_locked(&ax_local->spi_lock));

lockdep_assert_held() in all those cases

> +static void ax88796c_free_skb_queue(struct sk_buff_head *q)
> +{
> +	struct sk_buff *skb;
> +
> +	while (q->qlen) {
> +		skb =3D skb_dequeue(q);
> +		kfree_skb(skb);
> +	}

__skb_queue_purge()

> +}
> +
> +static int
> +ax88796c_close(struct net_device *ndev)
> +{
> +	struct ax88796c_device *ax_local =3D to_ax88796c_device(ndev);
> +
> +	netif_stop_queue(ndev);
> +	phy_stop(ndev->phydev);
> +
> +	mutex_lock(&ax_local->spi_lock);
> +
> +	/* Disable MAC interrupts */
> +	AX_WRITE(&ax_local->ax_spi, IMR_MASKALL, P0_IMR);
> +	ax88796c_free_skb_queue(&ax_local->tx_wait_q);
> +	ax88796c_soft_reset(ax_local);
> +
> +	mutex_unlock(&ax_local->spi_lock);
> +
> +	free_irq(ndev->irq, ndev);
> +
> +	return 0;
> +}

> +struct ax88796c_device {
> +	struct spi_device	*spi;
> +	struct net_device	*ndev;
> +	struct net_device_stats	stats;

You need to use 64 bit stats, like struct rtnl_link_stats64.
On a 32bit system at 100Mbps ulong can wrap in minutes.

> +	struct work_struct	ax_work;

I don't see you ever canceling / flushing this work.
You should do that at least on driver remove if not close.

> +	struct mutex		spi_lock; /* device access */
> +
> +	struct sk_buff_head	tx_wait_q;
> +
> +	struct axspi_data	ax_spi;
> +
> +	struct mii_bus		*mdiobus;
> +	struct phy_device	*phydev;
> +
> +	int			msg_enable;
> +
> +	u16			seq_num;
> +
> +	u8			multi_filter[AX_MCAST_FILTER_SIZE];
> +
> +	int			link;
> +	int			speed;
> +	int			duplex;
> +	int			pause;
> +	int			asym_pause;
> +	int			flowctrl;
> +		#define AX_FC_NONE		0
> +		#define AX_FC_RX		BIT(0)
> +		#define AX_FC_TX		BIT(1)
> +		#define AX_FC_ANEG		BIT(2)
> +
> +	u32			priv_flags;
> +		#define AX_CAP_COMP		BIT(0)
> +		#define AX_PRIV_FLAGS_MASK	(AX_CAP_COMP)
> +
> +	unsigned long		flags;
> +		#define EVENT_INTR		BIT(0)
> +		#define EVENT_TX		BIT(1)
> +		#define EVENT_SET_MULTI		BIT(2)
> +
> +};

> +struct skb_data {
> +	enum skb_state state;
> +	struct net_device *ndev;
> +	struct sk_buff *skb;

Don't think you ever use the skb or ndev from this structure.

> +	size_t len;
> +};
