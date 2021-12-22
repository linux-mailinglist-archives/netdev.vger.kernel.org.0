Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C325347CA8D
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 01:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240135AbhLVAvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 19:51:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbhLVAvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 19:51:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D827C061574;
        Tue, 21 Dec 2021 16:51:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFEFB617FB;
        Wed, 22 Dec 2021 00:51:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D908BC36AE9;
        Wed, 22 Dec 2021 00:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640134276;
        bh=OENk/ZjgaUgMd+liaAby8bsFphHrP7zKgnJsZpoPGYU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aClbUZ3TjkPS1RqlfVC8YNew0gZwXbULPf1uEc8lzWl4qDTE28ouaH30hxU8AGQgP
         bOlzhdcvDKVJPuCWyaIzVspnKaoKF0/1mDT+aZ0iCpb0LeBKki0Xi09L8TEopo5rlP
         7jdgDu43/Oj9S+2iSOURr4Q4BMC8ubcRxSHE0+mfb+/rW4W6DzyZt0toNbjwRkSkAC
         yplFsx9J1Q3JcdhKh5Iz75rNYVeHxxnzaZQ3/5xucSX8ad1r3QC+9rq5jveh6pXfuD
         lAshXunX81d3ki6SElo+oYwgy9OMHNUjoCB1iON1o5TylOWOCDQ9rtgpPuOjh8VnOb
         jUxyhtanru5tA==
Date:   Tue, 21 Dec 2021 16:51:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joseph CHAMG <josright123@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, joseph_chang@davicom.com.tw,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7, 2/2] net: Add dm9051 driver
Message-ID: <20211221165114.2f4cd148@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211220113342.11437-3-josright123@gmail.com>
References: <20211220113342.11437-1-josright123@gmail.com>
        <20211220113342.11437-3-josright123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Dec 2021 19:33:42 +0800 Joseph CHAMG wrote:
> +/* set mac permanently
> + */
> +static void dm9051_write_mac_lock(struct board_info *db)
> +{
> +	struct net_device *ndev = db->ndev;
> +	int i, oft;
> +
> +	netdev_dbg(ndev, "set_mac_address %pM\n", ndev->dev_addr);
> +
> +	/* write to net device and chip */
> +	mutex_lock(&db->addr_lock);
> +	for (i = 0, oft = DM9051_PAR; i < ETH_ALEN; i++, oft++)
> +		dm9051_iow(db, oft, ndev->dev_addr[i]);
> +	mutex_unlock(&db->addr_lock);
> +
> +	/* write to EEPROM */
> +	for (i = 0; i < ETH_ALEN; i += 2)
> +		dm9051_write_eeprom(db, i / 2, (u8 *)&ndev->dev_addr[i]);
> +}

Why set the MAC permanently? I don't thin users will expect that.

> +/* reset while rx error found
> + */
> +static void dm9051_restart_dm9051(struct board_info *db)
> +{
> +	struct net_device *ndev = db->ndev;
> +	char *sbuff = (char *)db->prxhdr;
> +	int rxlen = le16_to_cpu(db->prxhdr->rxlen);
> +
> +	netdev_dbg(ndev, "dm9-rxhdr, Large-eror (rxhdr %02x %02x %02x %02x)\n",
> +		   sbuff[0], sbuff[1], sbuff[2], sbuff[3]);
> +	netdev_dbg(ndev, "dm9-pkt-Wrong, RxLen over-range (%x= %d > %x= %d)\n",
> +		   rxlen, rxlen, DM9051_PKT_MAX, DM9051_PKT_MAX);
> +
> +	dm9051_reset(db);
> +	dm9051_restart_fifo_rst(db);
> +
> +	/* phy mdiobus phy read/write is already enclose with mutex_lock/mutex_unlock */
> +	mutex_unlock(&db->addr_lock);
> +	dm9051_restart_phy(db);
> +	mutex_lock(&db->addr_lock);
> +
> +	netdev_dbg(ndev, " RxLenErr&MacOvrSft_Er %d, RST_c %d\n",
> +		   db->bc.large_err_counter + db->bc.mac_ovrsft_counter,
> +		   db->bc.DO_FIFO_RST_counter);
> +}
> +
> +static int dm9051_loop_rx(struct board_info *db)
> +{
> +	struct net_device *ndev = db->ndev;
> +	u8 rxbyte;
> +	int ret, rxlen;
> +	char sbuff[DM_RXHDR_SIZE];
> +	struct sk_buff *skb;
> +	u8 *rdptr;
> +	int scanrr = 0;
> +
> +	while (1) {
> +		rxbyte = dm9051_ior(db, DM_SPI_MRCMDX); /* Dummy read */
> +		rxbyte = dm9051_ior(db, DM_SPI_MRCMDX); /* Dummy read */
> +		if (rxbyte != DM9051_PKT_RDY) {
> +			dm9051_iow(db, DM9051_ISR, 0xff); /* Clear ISR, clear to stop mrcmd */

Should you not clear the ISR _before_ checking if there is a packet
pending? What if a packet arrives between the two, does the HW re-raise
the IRQ if the fifo is not empty?

> +			break; /* exhaust-empty */
> +		}
> +		ret = dm9051_inblk(db, sbuff, DM_RXHDR_SIZE);

This is not a DMA, right? You can't DMA to a stack buffer, stack may 
be vmapped.

> +		if (ret < 0)
> +			break;
> +		dm9051_iow(db, DM9051_ISR, 0xff); /* Clear ISR, clear to stop mrcmd */
> +
> +		db->prxhdr = (struct dm9051_rxhdr *)sbuff;
> +		rxlen = le16_to_cpu(db->prxhdr->rxlen);
> +
> +		if (db->prxhdr->rxstatus & 0xbf) {
> +			netdev_dbg(ndev, "warn : rxhdr.status 0x%02x\n",
> +				   db->prxhdr->rxstatus);
> +		}
> +		if (rxlen > DM9051_PKT_MAX) {
> +			db->bc.large_err_counter++;
> +			dm9051_restart_dm9051(db);
> +			return scanrr;
> +		}
> +
> +		skb = dev_alloc_skb(rxlen + 4);
> +		if (!skb) {
> +			dm9051_dumpblk(db, rxlen);
> +			return scanrr;
> +		}
> +		skb_reserve(skb, 2);

is the two NET_IP_ALIGN? If so please use __netdev_alloc_skb_ip_align().

> +		rdptr = (u8 *)skb_put(skb, rxlen - 4);
> +
> +		ret = dm9051_inblk(db, rdptr, rxlen);
> +		if (ret < 0)
> +			break;
> +
> +		dm9051_iow(db, DM9051_ISR, 0xff); /* Clear ISR, clear to stop mrcmd */
> +
> +		skb->protocol = eth_type_trans(skb, db->ndev);
> +		if (db->ndev->features & NETIF_F_RXCSUM)
> +			skb_checksum_none_assert(skb);
> +		if (in_interrupt())

I don't think it can ever be in_interrupt(), just call netif_rx_ni()

> +			netif_rx(skb);
> +		else
> +			netif_rx_ni(skb);
> +		db->ndev->stats.rx_bytes += rxlen;
> +		db->ndev->stats.rx_packets++;
> +		scanrr++;
> +	}
> +	return scanrr;
> +}

> +static void dm9051_stopcode_lock(struct board_info *db)
> +{
> +	mutex_lock(&db->addr_lock);
> +
> +	dm9051_iow(db, DM9051_GPR, 0x01); /* Power-Down PHY */
> +	dm9051_iow(db, DM9051_RCR, RCR_RX_DISABLE);	/* Disable RX */
> +
> +	mutex_unlock(&db->addr_lock);
> +}
> +
> +/* Open network device
> + * Called when the network device is marked active, such as a user executing
> + * 'ifconfig up' on the device
> + */
> +static int dm9051_open(struct net_device *ndev)
> +{
> +	struct board_info *db = to_dm9051_board(ndev);
> +	int ret;
> +
> +	skb_queue_head_init(&db->txq);
> +	netif_start_queue(ndev);
> +	netif_wake_queue(ndev);

Shouldn't you wake the queues _after_ all the init?

Also you don't need both of those, wake_queue() is enough.

> +	ret = dm9051_opencode_receiving(ndev, db);
> +	if (ret < 0)
> +		return ret;
> +
> +	dm9051_initcode_lock(ndev, db);
> +	dm9051_imr_enable_lock_essential(db);
> +	return 0;
> +}
> +
> +/* Close network device
> + * Called to close down a network device which has been active. Cancell any

s/cancell/cancel/

> + * work, shutdown the RX and TX process and then place the chip into a low
> + * power state while it is not being used
> + */
> +static int dm9051_stop(struct net_device *ndev)
> +{
> +	struct board_info *db = to_dm9051_board(ndev);
> +
> +	phy_stop(db->phydev);
> +	dm9051_stopcode_release(db);
> +	netif_stop_queue(ndev);
> +	dm9051_stopcode_lock(db);
> +	return 0;
> +}
> +
> +/* event: play a schedule starter in condition
> + */
> +static netdev_tx_t dm9051_start_xmit(struct sk_buff *skb, struct net_device *ndev)
> +{
> +	struct board_info *db = to_dm9051_board(ndev);
> +
> +	skb_queue_tail(&db->txq, skb); /* add to skb */

You should probably enforce a limit on this queue size,
and pause the qdisc once it fills up. This will prevent
obvious buffer bloat problems.

> +	schedule_delayed_work(&db->tx_work, 0);

Same as below, why is it delayed if you always pass 0?

> +	return NETDEV_TX_OK;
> +}
> +
> +/* event: play with a schedule starter
> + */
> +static void dm9051_set_multicast_list_schedule(struct net_device *ndev)
> +{
> +	struct board_info *db = to_dm9051_board(ndev);
> +	u8 rcr = RCR_DIS_LONG | RCR_DIS_CRC | RCR_RXEN;
> +	struct netdev_hw_addr *ha;
> +	u32 hash_val;
> +
> +	/* rx control */
> +	if (ndev->flags & IFF_PROMISC) {
> +		rcr |= RCR_PRMSC;
> +		netdev_dbg(ndev, "set_multicast rcr |= RCR_PRMSC, rcr= %02x\n", rcr);
> +	}
> +
> +	if (ndev->flags & IFF_ALLMULTI) {
> +		rcr |= RCR_ALL;
> +		netdev_dbg(ndev, "set_multicast rcr |= RCR_ALLMULTI, rcr= %02x\n", rcr);
> +	}
> +
> +	db->rcr_all = rcr;
> +
> +	/* broadcast address */
> +	db->hash_table[0] = 0;
> +	db->hash_table[1] = 0;
> +	db->hash_table[2] = 0;
> +	db->hash_table[3] = 0x8000;
> +
> +	/* the multicast address in Hash Table : 64 bits */
> +	netdev_for_each_mc_addr(ha, ndev) {
> +		hash_val = ether_crc_le(6, ha->addr) & 0x3f;
> +		db->hash_table[hash_val / 16] |= (u16)1 << (hash_val % 16);
> +	}

This can theoretically race with the work reading these values, but in
practice that's probably fine..

> +	schedule_delayed_work(&db->rxctrl_work, 0);

Do you ever schedule this work with a delay? Use a normal work if it
doesn't need a delay.

> +	u8				cmd[2] ____cacheline_aligned;
> +	struct spi_transfer		spi_xfer2[2] ____cacheline_aligned;
> +	struct spi_message		spi_msg2 ____cacheline_aligned;
> +	struct rx_ctl_mach		bc ____cacheline_aligned;
> +	struct flow_ctl_tag		fl ____cacheline_aligned;
> +	struct dm9051_rxhdr		*prxhdr ____cacheline_aligned;

Do you really need all this cache line alignment?
Isn't it better to group the structures into rx side and tx side
instead of having each member be its own cache line?
