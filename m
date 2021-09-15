Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5D340BDEB
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 04:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbhIOC5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 22:57:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:51728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229830AbhIOC5D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 22:57:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2E7660F6F;
        Wed, 15 Sep 2021 02:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631674545;
        bh=XWuBeSFSLCM4PkGHmBNK9OfcE16ZGhZzEik8E/8279E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rJ1226f1zh7Abfmlk0JFFpabZcNdz1gwSYgFFPkQWOZgu+6gZVO59vQTrhCmDoU4q
         05GeJMIyTRjA6W1UU0pg3EolJDI7PvJ9UWk3qLHgyMgZ6M1wNJd9FSFU+CTEawSI+8
         khgarV75zNO3ofdA+TlBAmIj2kbDJHfkE1erSYoDVubFi7haRoNtyqmLOtahqqz8Fp
         QkzP/WLn4tloXGY0ADjGhZlzOQxnyzQW01C+4UXC4UVdAU7TTVy6J6DB5jslwKmo+M
         gJWviyf3e1IkydJd5VE4pcnY124akrleFD9EFBh/IiRHbhUkIol3fi6MS1/vCDKyEZ
         NRj74xOMU3Cjg==
Date:   Tue, 14 Sep 2021 19:55:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefan Wahren <stefan.wahren@i2se.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Heimpold <michael.heimpold@in-tech.com>,
        jimmy.shen@vertexcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH RFC 3/3] net: vertexcom: Add MSE102x SPI support
Message-ID: <20210914195543.28ea7ffb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210914151717.12232-4-stefan.wahren@i2se.com>
References: <20210914151717.12232-1-stefan.wahren@i2se.com>
        <20210914151717.12232-4-stefan.wahren@i2se.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Sep 2021 17:17:17 +0200 Stefan Wahren wrote:
> This implements an SPI protocol driver for Vertexcom MSE102x
> Homeplug GreenPHY chip.
> 
> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>

> +	rxalign = ALIGN(rxlen + DET_SOF_LEN + DET_DFT_LEN, 4);
> +	skb = netdev_alloc_skb_ip_align(mse->ndev, rxalign);
> +	if (!skb)
> +		goto unlock_spi;
> +
> +	/* 2 bytes Start of frame (before ethernet header)
> +	 * 2 bytes Data frame tail (after ethernet frame)
> +	 * They are copied, but ignored.
> +	 */
> +	rxpkt = skb_put(skb, rxlen) - DET_SOF_LEN;

This assumes there is SOF_LEN headroom, but you never reserved that
headroom, and SOF_LEN is added to the frame len.. one of those is not
necessary?

> +	if (mse102x_rx_frame_spi(mse, rxpkt, rxlen)) {
> +		mse->ndev->stats.rx_errors++;
> +		dev_kfree_skb(skb);
> +		goto unlock_spi;
> +	}
> +
> +	if (netif_msg_pktdata(mse))
> +		mse102x_dump_packet(__func__, skb->len, skb->data);
> +
> +	skb->protocol = eth_type_trans(skb, mse->ndev);
> +	netif_rx_ni(skb);
> +
> +	mse->ndev->stats.rx_packets++;
> +	mse->ndev->stats.rx_bytes += rxlen;
> +
> +unlock_spi:
> +	mutex_unlock(&mses->lock);
> +}
> +
> +static int mse102x_tx_pkt_spi(struct mse102x_net *mse, struct sk_buff *txb,
> +			      unsigned long work_timeout)
> +{
> +	unsigned int pad = 0;
> +	__be16 rx = 0;
> +	u16 cmd_resp;
> +	int ret;
> +	bool first = true;
> +
> +	if (txb->len < 60)
> +		pad = 60 - txb->len;
> +
> +	while (1) {
> +		/* It's not predictable how long / many retries it takes to
> +		 * send at least one packet, so TX timeouts are possible.
> +		 * That's the reason why the netdev watchdog is not used here.
> +		 */
> +		if (time_after(jiffies, work_timeout))
> +			return -ETIMEDOUT;
> +
> +		mse102x_tx_cmd_spi(mse, CMD_RTS | (txb->len + pad));
> +		ret = mse102x_rx_cmd_spi(mse, (u8 *)&rx);
> +		cmd_resp = be16_to_cpu(rx);
> +
> +		if (!ret) {
> +			/* ready to send frame ? */
> +			if (cmd_resp == CMD_CTR)
> +				break;
> +
> +			net_dbg_ratelimited("%s: Unexpected response (0x%04x)\n",
> +					    __func__, cmd_resp);
> +			mse->stats.invalid_ctr++;
> +		}
> +
> +		if (first) {
> +			/* throttle at first issue */
> +			netif_stop_queue(mse->ndev);
> +			/* fast retry */
> +			usleep_range(50, 100);
> +			first = false;
> +		} else {
> +			msleep(20);
> +		}
> +	};
> +
> +	ret = mse102x_tx_frame_spi(mse, txb, pad);
> +	if (ret) {
> +		net_dbg_ratelimited("%s: Failed to send (%d), drop frame\n",
> +				    __func__, ret);
> +	}

No need for brackets.

> +	return ret;
> +}
> +
> +#define TX_QUEUE_MAX 10
> +
> +static void mse102x_tx_work(struct work_struct *work)
> +{
> +	/* Make sure timeout is sufficient to transfer TX_QUEUE_MAX frames */
> +	unsigned long work_timeout = jiffies + msecs_to_jiffies(1000);

Sure this is safe? what if the system is under heavy load and the
worker thread just gets scheduled out for the best part of the second?

> +	struct mse102x_net_spi *mses;
> +	struct mse102x_net *mse;
> +	struct sk_buff *txb;
> +	bool done = false;
> +	int ret = 0;
> +
> +	mses = container_of(work, struct mse102x_net_spi, tx_work);
> +	mse = &mses->mse102x;
> +
> +	while (!done) {
> +		mutex_lock(&mses->lock);

I think you can take the lock just around the mse102x_tx_pkt_spi().

> +		txb = skb_dequeue(&mse->txq);
> +		if (!txb) {
> +			done = true;
> +			goto unlock_spi;
> +		}
> +
> +		ret = mse102x_tx_pkt_spi(mse, txb, work_timeout);
> +		if (ret) {
> +			mse->ndev->stats.tx_dropped++;
> +		} else {
> +			mse->ndev->stats.tx_bytes += txb->len;
> +			mse->ndev->stats.tx_packets++;
> +		}
> +
> +		dev_kfree_skb(txb);
> +
> +unlock_spi:
> +		mutex_unlock(&mses->lock);
> +	}
> +
> +	if (ret == -ETIMEDOUT) {
> +		if (netif_msg_timer(mse))
> +			netdev_err(mse->ndev, "tx work timeout\n");
> +
> +		mse->stats.tx_timeout++;
> +	}
> +
> +	netif_wake_queue(mse->ndev);
> +}
> +
> +static netdev_tx_t mse102x_start_xmit_spi(struct sk_buff *skb,
> +					  struct net_device *ndev)
> +{
> +	struct mse102x_net *mse = netdev_priv(ndev);
> +	struct mse102x_net_spi *mses = to_mse102x_spi(mse);
> +	netdev_tx_t ret = NETDEV_TX_OK;
> +
> +	netif_dbg(mse, tx_queued, ndev,
> +		  "%s: skb %p, %d@%p\n", __func__, skb, skb->len, skb->data);
> +
> +	if (skb_queue_len(&mse->txq) >= TX_QUEUE_MAX) {
> +		netif_stop_queue(ndev);
> +		ret = NETDEV_TX_BUSY;

It's best practice to stop the queue in advance if you know you won't
be able to send the next packet, rather than return BUSY and force the
qdisc to requeue the frame.

> +	} else {
> +		skb_queue_tail(&mse->txq, skb);
> +	}
> +
> +	schedule_work(&mses->tx_work);
> +
> +	return ret;
> +}

> +static int mse102x_net_open(struct net_device *ndev)
> +{
> +	struct mse102x_net *mse = netdev_priv(ndev);
> +	struct mse102x_net_spi *mses = to_mse102x_spi(mse);
> +	int ret;
> +
> +	ret = request_threaded_irq(ndev->irq, NULL, mse102x_irq, IRQF_ONESHOT,
> +				   ndev->name, mse);
> +	if (ret < 0) {
> +		netdev_err(ndev, "Failed to get irq: %d\n", ret);
> +		return ret;
> +	}
> +
> +	/* lock the card, even if we may not actually be doing anything
> +	 * else at the moment
> +	 */
> +	mutex_lock(&mses->lock);

What is this lock protecting?

> +	netif_dbg(mse, ifup, ndev, "opening\n");
> +
> +	netif_start_queue(ndev);
> +
> +	netif_carrier_on(ndev);
> +
> +	netif_dbg(mse, ifup, ndev, "network device up\n");
> +
> +	mutex_unlock(&mses->lock);
> +
> +	return 0;
> +}
> +
> +static int mse102x_net_stop(struct net_device *ndev)
> +{
> +	struct mse102x_net *mse = netdev_priv(ndev);
> +	struct mse102x_net_spi *mses = to_mse102x_spi(mse);
> +
> +	netif_info(mse, ifdown, ndev, "shutting down\n");
> +
> +	netif_stop_queue(ndev);
> +
> +	/* stop any outstanding work */
> +	flush_work(&mses->tx_work);

The work can restart the queue.

> +	/* ensure any queued tx buffers are dumped */
> +	while (!skb_queue_empty(&mse->txq)) {
> +		struct sk_buff *txb = skb_dequeue(&mse->txq);
> +
> +		netif_dbg(mse, ifdown, ndev,
> +			  "%s: freeing txb %p\n", __func__, txb);
> +
> +		dev_kfree_skb(txb);
> +	}

skb_queue_purge(), maybe?

> +	free_irq(ndev->irq, mse);
> +
> +	return 0;
> +}

> +static void mse102x_get_drvinfo(struct net_device *ndev,
> +				struct ethtool_drvinfo *di)
> +{
> +	strscpy(di->driver, DRV_NAME, sizeof(di->driver));
> +	strscpy(di->version, "1.00", sizeof(di->version));

Please drop the driver version, we depend on the kernel version these
days (and that's provided by ethtool core by default).

> +	strscpy(di->bus_info, dev_name(ndev->dev.parent), sizeof(di->bus_info));
> +}
