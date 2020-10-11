Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A34D28A984
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 21:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgJKS7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 14:59:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725855AbgJKS7f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 14:59:35 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57CAC2078A;
        Sun, 11 Oct 2020 18:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602442774;
        bh=rwLud/7xJ0byJdJfx2kbTIafsurhZ3360u8ISyB5nlw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jFS1oF85NpOmMiQ1BvAzbh9vs5r4zMjyHZk+LnXvQm8Ok/bnw9qxsgNzbZq6JAQ5w
         Cd7iJrGStVyoUpzVB3bB2D2M4v3FMrpQfP2lo0t1fv3nLBiLmyEKSvOWndfIHBnI8R
         d75I0v8+/2Ho+mZAvhsXCInu8wqCrEFXdvh7iF4I=
Date:   Sun, 11 Oct 2020 11:59:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     davem@davemloft.net, hemantk@codeaurora.org,
        netdev@vger.kernel.org, manivannan.sadhasivam@linaro.org
Subject: Re: [PATCH] net: Add mhi-net driver
Message-ID: <20201011115932.3d67ba52@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1602275611-7440-1-git-send-email-loic.poulain@linaro.org>
References: <1602275611-7440-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  9 Oct 2020 22:33:31 +0200 Loic Poulain wrote:
> This patch adds a new network driver implementing MHI transport for
> network packets. Packets can be in any format, though QMAP (rmnet)
> is the usual protocol (flow control + PDN mux).
> 
> It support two MHI devices, IP_HW0 which is, the path to the IPA
> (IP accelerator) on qcom modem, And IP_SW0 which is the software
> driven IP path (to modem CPU).
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

> +static int mhi_ndo_xmit(struct sk_buff *skb, struct net_device *ndev)
> +{
> +	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
> +	struct mhi_device *mdev = mhi_netdev->mdev;
> +	int err;
> +
> +	/* Only support for single buffer transfer for now */
> +	err = skb_linearize(skb);

Since you don't advertise NETIF_F_SG you shouldn't have to call this,
no?

> +	if (unlikely(err)) {
> +		kfree_skb(skb);
> +		mhi_netdev->stats.tx_dropped++;
> +		return NETDEV_TX_OK;
> +	}
> +
> +	skb_tx_timestamp(skb);
> +
> +	/* mhi_queue_skb is not thread-safe, but xmit is serialized by the
> +	 * network core. Once MHI core will be thread save, migrate to
> +	 * NETIF_F_LLTX support.
> +	 */
> +	err = mhi_queue_skb(mdev, DMA_TO_DEVICE, skb, skb->len, MHI_EOT);
> +	if (err) {
> +		netdev_err(ndev, "mhi_queue_skb err %d\n", err);

This needs to be at least rate limited. 

> +		netif_stop_queue(ndev);

What's going to start the queue if it's a transient errors and not
NETDEV_TX_BUSY?

> +		return (err == -ENOMEM) ? NETDEV_TX_BUSY : err;

You should drop the packet if it's not NETDEV_TX_BUSY, and return
NETDEV_TX_OK. Don't return negative errors from ndo_xmit. 

> +	}
> +
> +	return NETDEV_TX_OK;
> +}
> +
> +static void mhi_ndo_get_stats64(struct net_device *ndev,
> +				struct rtnl_link_stats64 *stats)
> +{
> +	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
> +
> +	stats->rx_packets = mhi_netdev->stats.rx_packets;
> +	stats->rx_bytes = mhi_netdev->stats.rx_bytes;
> +	stats->rx_errors = mhi_netdev->stats.rx_errors;
> +	stats->rx_dropped = mhi_netdev->stats.rx_dropped;
> +	stats->tx_packets = mhi_netdev->stats.tx_packets;
> +	stats->tx_bytes = mhi_netdev->stats.tx_bytes;
> +	stats->tx_errors = mhi_netdev->stats.tx_errors;
> +	stats->tx_dropped = mhi_netdev->stats.tx_dropped;
> +}

Can you use 

> +static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
> +				struct mhi_result *mhi_res)
> +{
> +	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
> +	struct sk_buff *skb = mhi_res->buf_addr;
> +
> +	atomic_dec(&mhi_netdev->stats.rx_queued);
> +
> +	if (mhi_res->transaction_status) {
> +		mhi_netdev->stats.rx_errors++;
> +		kfree_skb(skb);
> +	} else {
> +		mhi_netdev->stats.rx_packets++;
> +		mhi_netdev->stats.rx_bytes += mhi_res->bytes_xferd;
> +
> +		skb->protocol = htons(ETH_P_MAP);
> +		skb_put(skb, mhi_res->bytes_xferd);
> +		netif_rx(skb);
> +	}
> +
> +	schedule_delayed_work(&mhi_netdev->rx_refill, 0);

Scheduling a work to replace every single RX buffer looks quite 
inefficient. Any chance you can do batching? I assume mhi_queue_skb()
has to be able to sleep?

> +static void mhi_net_rx_refill_work(struct work_struct *work)
> +{
> +	struct mhi_net_dev *mhi_netdev = container_of(work, struct mhi_net_dev,
> +						      rx_refill.work);
> +	struct net_device *ndev = mhi_netdev->ndev;
> +	struct mhi_device *mdev = mhi_netdev->mdev;
> +	struct sk_buff *skb;
> +	int err;
> +
> +	if (!netif_running(ndev))
> +		return;

How can this happen? You cancel the work from ndo_stop.

> +	do {
> +		skb = netdev_alloc_skb(ndev, READ_ONCE(ndev->mtu));
> +		if (unlikely(!skb)) {
> +			/* If we are starved of RX buffers, retry later */
> +			if (!atomic_read(&mhi_netdev->stats.rx_queued))
> +				schedule_delayed_work(&mhi_netdev->rx_refill, HZ / 2);
> +			break;
> +		}
> +
> +		err = mhi_queue_skb(mdev, DMA_FROM_DEVICE, skb, ndev->mtu,
> +				    MHI_EOT);
> +		if (err) {
> +			atomic_dec(&mhi_netdev->stats.rx_queued);

This can never fail with an empty ring? No need to potentially
reschedule the work here?

> +			kfree_skb(skb);
> +			break;
> +		}
> +
> +		atomic_inc(&mhi_netdev->stats.rx_queued);
> +
> +	} while (1);
> +}
> +
> +static int mhi_net_probe(struct mhi_device *mhi_dev,
> +			 const struct mhi_device_id *id)
> +{
> +	const char *netname = (char *)id->driver_data;
> +	struct mhi_net_dev *mhi_netdev;
> +	struct net_device *ndev;
> +	struct device *dev = &mhi_dev->dev;
> +	int err;
> +
> +	ndev = alloc_netdev(sizeof(*mhi_netdev), netname, NET_NAME_PREDICTABLE,
> +			    mhi_net_setup);
> +	if (!ndev) {
> +		err = -ENOMEM;
> +		return err;

return -ENOMEM;

> +	}
> +
> +	mhi_netdev = netdev_priv(ndev);
> +	dev_set_drvdata(dev, mhi_netdev);
> +	mhi_netdev->ndev = ndev;
> +	mhi_netdev->mdev = mhi_dev;

SET_NETDEV_DEV() ?

> +	INIT_DELAYED_WORK(&mhi_netdev->rx_refill, mhi_net_rx_refill_work);
> +
> +	/* Start MHI channels */
> +	err = mhi_prepare_for_transfer(mhi_dev, 0);
> +	if (err) {
> +		free_netdev(ndev);
> +		return err;
> +	}
> +
> +	err = register_netdev(ndev);
> +	if (err) {
> +		dev_err(dev, "mhi_net: registering device failed\n");
> +		free_netdev(ndev);
> +		return -EINVAL;

Why not propagate the error?

> +	}
> +
> +	return 0;
> +}
> +
> +static void mhi_net_remove(struct mhi_device *mhi_dev)
> +{
> +	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
> +
> +	mhi_unprepare_from_transfer(mhi_netdev->mdev);
> +	unregister_netdev(mhi_netdev->ndev);

Isn't this the wrong way around?

Should you not unregister the netdev before you stop transfers?

> +	/* netdev released from unregister */

> +}
