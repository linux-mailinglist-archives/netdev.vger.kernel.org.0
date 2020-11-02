Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C5F2A36A7
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 23:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgKBWkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 17:40:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:55726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbgKBWkR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 17:40:17 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4482420786;
        Mon,  2 Nov 2020 22:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604356816;
        bh=9S8+FG9QBlG6HdxIfT0YMTCuYSt/DuMyKSvTSRpGecw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X1GmEYtj0zdDCOW9sqmMxKFqVFJvLawSAnawtONFBz2GIDhXdo4V9BUNfRysqSSgl
         7MsAVbv1VwLWplclcpZqz9g3eSLajcf2mj9lTEdh3mc0sruncx+0FiRFOJoA6TnQkq
         3JBiNjyBpyCSqPAkoIQqybAZeDzrrNBy2OYaBXQ8=
Date:   Mon, 2 Nov 2020 14:40:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, bbhatt@codeaurora.org,
        willemdebruijn.kernel@gmail.com, jhugo@codeaurora.org,
        manivannan.sadhasivam@linaro.org, hemantk@codeaurora.org
Subject: Re: [PATCH v9 2/2] net: Add mhi-net driver
Message-ID: <20201102144015.2e060d28@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1604054895-29137-1-git-send-email-loic.poulain@linaro.org>
References: <1604054895-29137-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Oct 2020 11:48:15 +0100 Loic Poulain wrote:
> This patch adds a new network driver implementing MHI transport for
> network packets. Packets can be in any format, though QMAP (rmnet)
> is the usual protocol (flow control + PDN mux).
> 
> It support two MHI devices, IP_HW0 which is, the path to the IPA
> (IP accelerator) on qcom modem, And IP_SW0 which is the software
> driven IP path (to modem CPU).
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

> +static int mhi_ndo_stop(struct net_device *ndev)
> +{
> +	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
> +
> +	netif_stop_queue(ndev);
> +	netif_carrier_off(ndev);
> +	cancel_delayed_work_sync(&mhi_netdev->rx_refill);

Where do you free the allocated skbs? Does
mhi_unprepare_from_transfer() do that?

The skbs should be freed somehow in .ndo_stop().

> +	return 0;
> +}
> +
> +static int mhi_ndo_xmit(struct sk_buff *skb, struct net_device *ndev)
> +{
> +	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
> +	struct mhi_device *mdev = mhi_netdev->mdev;
> +	int err;
> +
> +	err = mhi_queue_skb(mdev, DMA_TO_DEVICE, skb, skb->len, MHI_EOT);
> +	if (unlikely(err)) {
> +		net_err_ratelimited("%s: Failed to queue TX buf (%d)\n",
> +				    ndev->name, err);
> +
> +		u64_stats_update_begin(&mhi_netdev->stats.tx_syncp);
> +		u64_stats_inc(&mhi_netdev->stats.tx_dropped);
> +		u64_stats_update_end(&mhi_netdev->stats.tx_syncp);
> +
> +		/* drop the packet */
> +		kfree_skb(skb);

dev_kfree_skb_any()

> +	}
> +
> +	if (mhi_queue_is_full(mdev, DMA_TO_DEVICE))
> +		netif_stop_queue(ndev);
> +
> +	return NETDEV_TX_OK;
> +}

> +static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
> +				struct mhi_result *mhi_res)
> +{
> +	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
> +	struct sk_buff *skb = mhi_res->buf_addr;
> +	int remaining;
> +
> +	remaining = atomic_dec_return(&mhi_netdev->stats.rx_queued);
> +
> +	if (unlikely(mhi_res->transaction_status)) {
> +		u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
> +		u64_stats_inc(&mhi_netdev->stats.rx_errors);
> +		u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
> +
> +		kfree_skb(skb);

Are you sure this never runs with irqs disabled or from irq context?

Otherwise dev_kfree_skb_any().

> +
> +		/* MHI layer resetting the DL channel */
> +		if (mhi_res->transaction_status == -ENOTCONN)
> +			return;
> +	} else {
> +		u64_stats_update_begin(&mhi_netdev->stats.rx_syncp);
> +		u64_stats_inc(&mhi_netdev->stats.rx_packets);
> +		u64_stats_add(&mhi_netdev->stats.rx_bytes, mhi_res->bytes_xferd);
> +		u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
> +
> +		skb->protocol = htons(ETH_P_MAP);
> +		skb_put(skb, mhi_res->bytes_xferd);
> +		netif_rx(skb);
> +	}
> +
> +	/* Refill if RX buffers queue becomes low */
> +	if (remaining <= mhi_netdev->rx_queue_sz / 2)
> +		schedule_delayed_work(&mhi_netdev->rx_refill, 0);
> +}
> +
> +static void mhi_net_ul_callback(struct mhi_device *mhi_dev,
> +				struct mhi_result *mhi_res)
> +{
> +	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
> +	struct net_device *ndev = mhi_netdev->ndev;
> +	struct sk_buff *skb = mhi_res->buf_addr;
> +
> +	/* Hardware has consumed the buffer, so free the skb (which is not
> +	 * freed by the MHI stack) and perform accounting.
> +	 */
> +	consume_skb(skb);

ditto

> +	u64_stats_update_begin(&mhi_netdev->stats.tx_syncp);
> +	if (unlikely(mhi_res->transaction_status)) {
> +		u64_stats_inc(&mhi_netdev->stats.tx_errors);
> +
> +		/* MHI layer resetting the UL channel */
> +		if (mhi_res->transaction_status == -ENOTCONN)
> +			return;

u64_stats_update_end()

> +	} else {
> +		u64_stats_inc(&mhi_netdev->stats.tx_packets);
> +		u64_stats_add(&mhi_netdev->stats.tx_bytes, mhi_res->bytes_xferd);
> +	}
> +	u64_stats_update_end(&mhi_netdev->stats.tx_syncp);
> +
> +	if (netif_queue_stopped(ndev))
> +		netif_wake_queue(ndev);
> +}
> +
> +static void mhi_net_rx_refill_work(struct work_struct *work)
> +{
> +	struct mhi_net_dev *mhi_netdev = container_of(work, struct mhi_net_dev,
> +						      rx_refill.work);
> +	struct net_device *ndev = mhi_netdev->ndev;
> +	struct mhi_device *mdev = mhi_netdev->mdev;
> +	int size = READ_ONCE(ndev->mtu);
> +	struct sk_buff *skb;
> +	int err;
> +
> +	do {

should this be a while(), not a do {} while() loop now?

> +		skb = netdev_alloc_skb(ndev, size);
> +		if (unlikely(!skb))
> +			break;
> +
> +		err = mhi_queue_skb(mdev, DMA_FROM_DEVICE, skb, size, MHI_EOT);
> +		if (unlikely(err)) {
> +			net_err_ratelimited("%s: Failed to queue RX buf (%d)\n",
> +					    ndev->name, err);
> +			kfree_skb(skb);
> +			break;
> +		}
> +
> +		/* Do not hog the CPU if rx buffers are consumed faster than
> +		 * queued (unlikely).
> +		 */
> +		cond_resched();
> +	} while (atomic_inc_return(&mhi_netdev->stats.rx_queued) < mhi_netdev->rx_queue_sz);
> +
> +	/* If we're still starved of rx buffers, reschedule later */
> +	if (unlikely(!atomic_read(&mhi_netdev->stats.rx_queued)))
> +		schedule_delayed_work(&mhi_netdev->rx_refill, HZ / 2);
> +}
