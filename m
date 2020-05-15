Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 846261D5784
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 19:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgEORVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 13:21:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbgEORVv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 13:21:51 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DDDF20727;
        Fri, 15 May 2020 17:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589563310;
        bh=0u+vfeI5NHpoUr2jotfaehDbXvOFd19VU+rRMEeueXM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0eZ7NYSnZAxvD43cMPyCyVTv+gt3Egqar5ra8C+UgP8BMyjGq2+RGY5+HQJ1F2UWA
         t/C7opgLun2z1q5Ehq13i+SN/Xv3oue8QGqTO8oUD11qn7eti9MVuUMc1oyCxUciX0
         u++lR1HvsapQjUlEAOJkw2c092HQ3HkxgHMRB0P4=
Date:   Fri, 15 May 2020 10:21:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luo bin <luobin9@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
Subject: Re: [PATCH net-next] hinic: add set_channels ethtool_ops support
Message-ID: <20200515102148.376cb0a8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200515003547.27359-1-luobin9@huawei.com>
References: <20200515003547.27359-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 May 2020 00:35:47 +0000 Luo bin wrote:
> add support to change TX/RX queue number with ethtool -L
> 
> Signed-off-by: Luo bin <luobin9@huawei.com>
> ---
>  .../net/ethernet/huawei/hinic/hinic_ethtool.c | 67 +++++++++++++++++--
>  .../net/ethernet/huawei/hinic/hinic_hw_dev.c  |  7 ++
>  .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |  2 +
>  .../net/ethernet/huawei/hinic/hinic_main.c    |  5 +-
>  drivers/net/ethernet/huawei/hinic/hinic_tx.c  |  5 ++
>  5 files changed, 79 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
> index ace18d258049..92a0e3bd19c3 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
> @@ -619,14 +619,68 @@ static void hinic_get_channels(struct net_device *netdev,
>  	struct hinic_dev *nic_dev = netdev_priv(netdev);
>  	struct hinic_hwdev *hwdev = nic_dev->hwdev;
>  
> -	channels->max_rx = hwdev->nic_cap.max_qps;
> -	channels->max_tx = hwdev->nic_cap.max_qps;
> +	channels->max_rx = 0;
> +	channels->max_tx = 0;

No need to set members to zero, core passes in a zero-initialized
structure.

>  	channels->max_other = 0;
> -	channels->max_combined = 0;
> -	channels->rx_count = hinic_hwdev_num_qps(hwdev);
> -	channels->tx_count = hinic_hwdev_num_qps(hwdev);
> +	channels->max_combined = nic_dev->max_qps;
> +	channels->rx_count = 0;
> +	channels->tx_count = 0;
>  	channels->other_count = 0;
> -	channels->combined_count = 0;
> +	channels->combined_count = hinic_hwdev_num_qps(hwdev);
> +}
> +
> +int hinic_set_channels(struct net_device *netdev,
> +		       struct ethtool_channels *channels)

I haven't actually built this, but - static?

> +{
> +	struct hinic_dev *nic_dev = netdev_priv(netdev);
> +	unsigned int count = channels->combined_count;
> +	int err;
> +
> +	if (!count) {
> +		netif_err(nic_dev, drv, netdev,
> +			  "Unsupported combined_count: 0\n");
> +		return -EINVAL;
> +	}
> +
> +	if (channels->tx_count || channels->rx_count || channels->other_count) {
> +		netif_err(nic_dev, drv, netdev,
> +			  "Setting rx/tx/other count not supported\n");
> +		return -EINVAL;
> +	}

Core already checks this:

	if (channels.rx_count > curr.max_rx ||
	    channels.tx_count > curr.max_tx ||
	    channels.combined_count > curr.max_combined ||
	    channels.other_count > curr.max_other)
		return -EINVAL;

> +	if (!(nic_dev->flags & HINIC_RSS_ENABLE)) {
> +		netif_err(nic_dev, drv, netdev,
> +			  "This function doesn't support RSS, only support 1 queue pair\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (count > nic_dev->max_qps) {

same here

> +		netif_err(nic_dev, drv, netdev,
> +			  "Combined count %d exceeds limit %d\n",
> +			  count, nic_dev->max_qps);
> +		return -EINVAL;
> +	}
> +
> +	netif_info(nic_dev, drv, netdev, "Set max combined queue number from %d to %d\n",
> +		   hinic_hwdev_num_qps(nic_dev->hwdev), count);
> +
> +	if (netif_running(netdev)) {
> +		netif_info(nic_dev, drv, netdev, "Restarting netdev\n");
> +		hinic_close(netdev);
> +
> +		hinic_update_num_qps(nic_dev->hwdev, count);
> +
> +		err = hinic_open(netdev);
> +		if (err) {
> +			netif_err(nic_dev, drv, netdev,
> +				  "Failed to open netdev\n");
> +			return -EFAULT;
> +		}
> +	} else {
> +		hinic_update_num_qps(nic_dev->hwdev, count);
> +	}
> +
> +	return 0;
>  }
>  
>  static int hinic_get_rss_hash_opts(struct hinic_dev *nic_dev,
> @@ -1219,6 +1273,7 @@ static const struct ethtool_ops hinic_ethtool_ops = {
>  	.get_ringparam = hinic_get_ringparam,
>  	.set_ringparam = hinic_set_ringparam,
>  	.get_channels = hinic_get_channels,
> +	.set_channels = hinic_set_channels,
>  	.get_rxnfc = hinic_get_rxnfc,
>  	.set_rxnfc = hinic_set_rxnfc,
>  	.get_rxfh_key_size = hinic_get_rxfh_key_size,
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
> index 0245da02efbb..d40a0a5d2c8d 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
> @@ -858,6 +858,13 @@ int hinic_hwdev_num_qps(struct hinic_hwdev *hwdev)
>  	return nic_cap->num_qps;
>  }
>  
> +void hinic_update_num_qps(struct hinic_hwdev *hwdev, u16 num_qp)
> +{
> +	struct hinic_cap *nic_cap = &hwdev->nic_cap;
> +
> +	nic_cap->num_qps = num_qp;
> +}
> +
>  /**
>   * hinic_hwdev_get_sq - get SQ
>   * @hwdev: the NIC HW device
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
> index 71ea7e46dbbc..e7dfe5ae2f8b 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
> @@ -359,6 +359,8 @@ int hinic_hwdev_max_num_qps(struct hinic_hwdev *hwdev);
>  
>  int hinic_hwdev_num_qps(struct hinic_hwdev *hwdev);
>  
> +void hinic_update_num_qps(struct hinic_hwdev *hwdev, u16 num_qp);
> +
>  struct hinic_sq *hinic_hwdev_get_sq(struct hinic_hwdev *hwdev, int i);
>  
>  struct hinic_rq *hinic_hwdev_get_rq(struct hinic_hwdev *hwdev, int i);
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
> index e3ff119fe341..5a130c982a02 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
> @@ -326,7 +326,6 @@ static void hinic_enable_rss(struct hinic_dev *nic_dev)
>  	int i, node, err = 0;
>  	u16 num_cpus = 0;
>  
> -	nic_dev->max_qps = hinic_hwdev_max_num_qps(hwdev);
>  	if (nic_dev->max_qps <= 1) {
>  		nic_dev->flags &= ~HINIC_RSS_ENABLE;
>  		nic_dev->rss_limit = nic_dev->max_qps;
> @@ -1043,6 +1042,10 @@ static int nic_dev_init(struct pci_dev *pdev)
>  	nic_dev->rq_depth = HINIC_RQ_DEPTH;
>  	nic_dev->sriov_info.hwdev = hwdev;
>  	nic_dev->sriov_info.pdev = pdev;
> +	nic_dev->max_qps = num_qps;
> +
> +	if (nic_dev->max_qps > 1)
> +		nic_dev->flags |= HINIC_RSS_ENABLE;
>  
>  	sema_init(&nic_dev->mgmt_lock, 1);
>  
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.c b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
> index 4c66a0bc1b28..6da761d7a6ef 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
> @@ -470,6 +470,11 @@ netdev_tx_t hinic_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
>  	struct hinic_txq *txq;
>  	struct hinic_qp *qp;
>  
> +	if (unlikely(!netif_carrier_ok(netdev))) {
> +		dev_kfree_skb_any(skb);
> +		return NETDEV_TX_OK;
> +	}

Why do you need this? How is it supposed to be synchronized in the first
place, the link can go down two instructions after you do the check.

>  	txq = &nic_dev->txqs[q_id];
>  	qp = container_of(txq->sq, struct hinic_qp, sq);
>  

