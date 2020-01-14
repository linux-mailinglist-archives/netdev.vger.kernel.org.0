Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1F213A71D
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 11:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730325AbgANKSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 05:18:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:54828 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730910AbgANKIP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jan 2020 05:08:15 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 790E4AE2E;
        Tue, 14 Jan 2020 10:08:13 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 961BCE0488; Tue, 14 Jan 2020 11:08:12 +0100 (CET)
Date:   Tue, 14 Jan 2020 11:08:12 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     sunil.kovvuri@gmail.com, davem@davemloft.net, kubakici@wp.pl,
        Christina Jacob <cjacob@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH v2 14/17] octeontx2-pf: Add basic ethtool support
Message-ID: <20200114100812.GA22304@unicorn.suse.cz>
References: <1578985340-28775-1-git-send-email-sunil.kovvuri@gmail.com>
 <1578985340-28775-15-git-send-email-sunil.kovvuri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1578985340-28775-15-git-send-email-sunil.kovvuri@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 14, 2020 at 12:32:17PM +0530, sunil.kovvuri@gmail.com wrote:
> From: Christina Jacob <cjacob@marvell.com>
> 
> This patch adds ethtool support for
>  - Driver stats, Tx/Rx perqueue and CGX LMAC stats
>  - Set/show Rx/Tx queue count
>  - Set/show Rx/Tx ring sizes
>  - Set/show IRQ coalescing parameters
> 
> Signed-off-by: Christina Jacob <cjacob@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> ---
[...]
> +static void otx2_dev_open(struct net_device *netdev)
> +{
> +	otx2_open(netdev);
> +}
> +
> +static void otx2_dev_stop(struct net_device *netdev)
> +{
> +	otx2_stop(netdev);
> +}

Why don't you call these directly?

[...]
> +/* Get no of queues device supports and current queue count */
> +static void otx2_get_channels(struct net_device *dev,
> +			      struct ethtool_channels *channel)
> +{
> +	struct otx2_nic *pfvf = netdev_priv(dev);
> +
> +	memset(channel, 0, sizeof(*channel));

The structure is already zero initialized in ethtool_get_channels()
(except for cmd).

> +	channel->max_rx = pfvf->hw.max_queues;
> +	channel->max_tx = pfvf->hw.max_queues;
> +
> +	channel->rx_count = pfvf->hw.rx_queues;
> +	channel->tx_count = pfvf->hw.tx_queues;
> +}
> +
> +/* Set no of Tx, Rx queues to be used */
> +static int otx2_set_channels(struct net_device *dev,
> +			     struct ethtool_channels *channel)
> +{
> +	struct otx2_nic *pfvf = netdev_priv(dev);
> +	bool if_up = netif_running(dev);
> +	int err = 0;
> +
> +	if (!channel->rx_count || !channel->tx_count)
> +		return -EINVAL;
> +	if (channel->rx_count > pfvf->hw.max_queues)
> +		return -EINVAL;
> +	if (channel->tx_count > pfvf->hw.max_queues)
> +		return -EINVAL;

The upper bounds are checked in ethtool_set_channels() so that you don't
get here if requested counts are too high.

> +
> +	if (if_up)
> +		otx2_dev_stop(dev);
> +
> +	pfvf->hw.rx_queues = channel->rx_count;
> +	pfvf->hw.tx_queues = channel->tx_count;
> +	err = otx2_set_real_num_queues(dev, pfvf->hw.tx_queues,
> +				       pfvf->hw.rx_queues);
> +	pfvf->qset.cq_cnt = pfvf->hw.tx_queues +  pfvf->hw.rx_queues;
> +	if (err)
> +		return err;
> +
> +	if (if_up)
> +		otx2_dev_open(dev);

Is it intentional that you leave the device down when the change fails?

> +	netdev_info(dev, "Setting num Tx rings to %d, Rx rings to %d success\n",
> +		    pfvf->hw.tx_queues, pfvf->hw.rx_queues);
> +
> +	return err;
> +}
> +
> +static void otx2_get_ringparam(struct net_device *netdev,
> +			       struct ethtool_ringparam *ring)
> +{
> +	struct otx2_nic *pfvf = netdev_priv(netdev);
> +	struct otx2_qset *qs = &pfvf->qset;
> +
> +	ring->rx_max_pending = Q_COUNT(Q_SIZE_MAX);
> +	ring->rx_pending = qs->rqe_cnt ? qs->rqe_cnt : Q_COUNT(Q_SIZE_256);
> +	ring->tx_max_pending = Q_COUNT(Q_SIZE_MAX);
> +	ring->tx_pending = qs->sqe_cnt ? qs->sqe_cnt : Q_COUNT(Q_SIZE_4K);
> +}
> +
> +static int otx2_set_ringparam(struct net_device *netdev,
> +			      struct ethtool_ringparam *ring)
> +{
> +	struct otx2_nic *pfvf = netdev_priv(netdev);
> +	bool if_up = netif_running(netdev);
> +	struct otx2_qset *qs = &pfvf->qset;
> +	u32 rx_count, tx_count;
> +
> +	if (ring->rx_mini_pending || ring->rx_jumbo_pending)
> +		return -EINVAL;
> +
> +	/* Permitted lengths are 16 64 256 1K 4K 16K 64K 256K 1M  */
> +	rx_count = clamp_t(u32, ring->rx_pending,
> +			   Q_COUNT(Q_SIZE_MIN), Q_COUNT(Q_SIZE_MAX));

The upper bound is checked in ethtool_set_ringparam().

Michal Kubecek

> +	/* On some silicon variants a skid or reserved CQEs are
> +	 * needed to avoid CQ overflow.
> +	 */
> +	if (rx_count < pfvf->hw.rq_skid)
> +		rx_count =  pfvf->hw.rq_skid;
> +	rx_count = Q_COUNT(Q_SIZE(rx_count, 3));
> +
> +	/* Due pipelining impact minimum 2000 unused SQ CQE's
> +	 * need to maintain to avoid CQ overflow, hence the
> +	 * minimum 4K size.
> +	 */
> +	tx_count = clamp_t(u32, ring->tx_pending,
> +			   Q_COUNT(Q_SIZE_4K), Q_COUNT(Q_SIZE_MAX));
> +	tx_count = Q_COUNT(Q_SIZE(tx_count, 3));
> +
> +	if (tx_count == qs->sqe_cnt && rx_count == qs->rqe_cnt)
> +		return 0;
> +
> +	if (if_up)
> +		otx2_dev_stop(netdev);
> +
> +	/* Assigned to the nearest possible exponent. */
> +	qs->sqe_cnt = tx_count;
> +	qs->rqe_cnt = rx_count;
> +
> +	if (if_up)
> +		otx2_dev_open(netdev);
> +	return 0;
> +}
