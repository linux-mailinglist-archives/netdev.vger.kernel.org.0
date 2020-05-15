Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1DD01D58BF
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 20:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbgEOSNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 14:13:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:34484 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgEOSNc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 14:13:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 98C33AA7C;
        Fri, 15 May 2020 18:13:33 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 84D99604B1; Fri, 15 May 2020 20:13:30 +0200 (CEST)
Date:   Fri, 15 May 2020 20:13:30 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Luo bin <luobin9@huawei.com>, davem@davemloft.net,
        linux-kernel@vger.kernel.org, luoxianjun@huawei.com,
        yin.yinshi@huawei.com, cloud.wangxiaoyun@huawei.com
Subject: Re: [PATCH net-next] hinic: add set_channels ethtool_ops support
Message-ID: <20200515181330.GC21714@lion.mk-sys.cz>
References: <20200515003547.27359-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515003547.27359-1-luobin9@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 12:35:47AM +0000, Luo bin wrote:
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

With max_* reported as 0, these will be caught in ethnl_set_channels()
or ethtool_set_channels().

> +	if (!(nic_dev->flags & HINIC_RSS_ENABLE)) {
> +		netif_err(nic_dev, drv, netdev,
> +			  "This function doesn't support RSS, only support 1 queue pair\n");
> +		return -EOPNOTSUPP;
> +	}

I'm not sure if the request should fail even if requested count is
actually 1.

> +	if (count > nic_dev->max_qps) {
> +		netif_err(nic_dev, drv, netdev,
> +			  "Combined count %d exceeds limit %d\n",
> +			  count, nic_dev->max_qps);
> +		return -EINVAL;
> +	}

As above, this check has been already performed in ethnl_set_channels()
or ethtool_set_channels().

> +	netif_info(nic_dev, drv, netdev, "Set max combined queue number from %d to %d\n",
> +		   hinic_hwdev_num_qps(nic_dev->hwdev), count);

We have netlink notifications now, is it necessary to log successful
changes?

Michal
