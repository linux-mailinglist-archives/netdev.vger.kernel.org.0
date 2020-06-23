Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5782066AF
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388166AbgFWVyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 17:54:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387455AbgFWVyY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 17:54:24 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B2082078E;
        Tue, 23 Jun 2020 21:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592949263;
        bh=O8oBcAwfn2aG1ULvAIdurZfw8k3bhkeQxnxNjhNs12I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ETvPMl5BukcLTeE69RRPuGOSWDHBqkWg2MgcKpZdNrlXiMillVfk/07c8abn/pFy5
         9FodqvARx7IPxoXANdokwR0LUfGuyqzJ4B2Yf+eG5igR6+ND8B8+idpvqUN1p7/XoP
         Z/JXXNC2RbcWSYCELvC/Fv41Xgjcn6HSbjJxkRE0=
Date:   Tue, 23 Jun 2020 14:54:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luo bin <luobin9@huawei.com>
Cc:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
Subject: Re: [PATCH net-next v2 1/5] hinic: add support to set and get pause
 params
Message-ID: <20200623145421.163d22fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200623142409.19081-2-luobin9@huawei.com>
References: <20200623142409.19081-1-luobin9@huawei.com>
        <20200623142409.19081-2-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jun 2020 22:24:05 +0800 Luo bin wrote:
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
> index e9e6f4c9309a..e69edb01fd9b 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
> @@ -467,6 +467,7 @@ int hinic_open(struct net_device *netdev)
>  	if (ret)
>  		netif_warn(nic_dev, drv, netdev,
>  			   "Failed to revert port state\n");
> +

Unrelated chunk, please drop.

>  err_port_state:
>  	free_rxqs(nic_dev);
>  	if (nic_dev->flags & HINIC_RSS_ENABLE) {
> @@ -887,6 +888,26 @@ static void netdev_features_init(struct net_device *netdev)
>  	netdev->features = netdev->hw_features | NETIF_F_HW_VLAN_CTAG_FILTER;
>  }
>  
> +static void hinic_refresh_nic_cfg(struct hinic_dev *nic_dev)
> +{
> +	struct hinic_nic_cfg *nic_cfg = &nic_dev->hwdev->func_to_io.nic_cfg;
> +	struct hinic_pause_config pause_info = {0};
> +	struct hinic_port_cap port_cap = {0};
> +
> +	if (hinic_port_get_cap(nic_dev, &port_cap))
> +		return;
> +
> +	mutex_lock(&nic_cfg->cfg_mutex);
> +	if (nic_cfg->pause_set || !port_cap.autoneg_state) {
> +		nic_cfg->auto_neg = port_cap.autoneg_state;
> +		pause_info.auto_neg = nic_cfg->auto_neg;
> +		pause_info.rx_pause = nic_cfg->rx_pause;
> +		pause_info.tx_pause = nic_cfg->tx_pause;
> +		hinic_set_hw_pause_info(nic_dev->hwdev, &pause_info);
> +	}
> +	mutex_unlock(&nic_cfg->cfg_mutex);
> +}
> +
>  /**
>   * link_status_event_handler - link event handler
>   * @handle: nic device for the handler
> @@ -918,6 +939,9 @@ static void link_status_event_handler(void *handle, void *buf_in, u16 in_size,
>  
>  		up(&nic_dev->mgmt_lock);
>  
> +		if (!HINIC_IS_VF(nic_dev->hwdev->hwif))
> +			hinic_refresh_nic_cfg(nic_dev);
> +
>  		netif_info(nic_dev, drv, nic_dev->netdev, "HINIC_Link is UP\n");
>  	} else {
>  		down(&nic_dev->mgmt_lock);
> @@ -950,26 +974,38 @@ static int set_features(struct hinic_dev *nic_dev,
>  	u32 csum_en = HINIC_RX_CSUM_OFFLOAD_EN;
>  	int err = 0;
>  
> -	if (changed & NETIF_F_TSO)
> +	if (changed & NETIF_F_TSO) {
>  		err = hinic_port_set_tso(nic_dev, (features & NETIF_F_TSO) ?
>  					 HINIC_TSO_ENABLE : HINIC_TSO_DISABLE);
> +		if (err)
> +			return err;
> +	}
>  
> -	if (changed & NETIF_F_RXCSUM)
> +	if (changed & NETIF_F_RXCSUM) {
>  		err = hinic_set_rx_csum_offload(nic_dev, csum_en);
> +		if (err)
> +			return err;
> +	}
>  
>  	if (changed & NETIF_F_LRO) {
>  		err = hinic_set_rx_lro_state(nic_dev,
>  					     !!(features & NETIF_F_LRO),
>  					     HINIC_LRO_RX_TIMER_DEFAULT,
>  					     HINIC_LRO_MAX_WQE_NUM_DEFAULT);
> +		if (err)
> +			return err;
>  	}
>  
> -	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
> +	if (changed & NETIF_F_HW_VLAN_CTAG_RX) {
>  		err = hinic_set_rx_vlan_offload(nic_dev,
>  						!!(features &
>  						   NETIF_F_HW_VLAN_CTAG_RX));
> +		if (err)
> +			return err;
> +	}

I missed this on v1, but this looks broken, multiple features may be
changed at the same time. If user requests RXCSUM and LRO to be changed
and LRO change fails the RXCSUM will be left in a different state than
dev->features indicates.
  
> -	return err;
> +	/* enable pause and disable pfc by default */
> +	return hinic_dcb_set_pfc(nic_dev->hwdev, 0, 0);

Why do you disable PFC every time features are changed?

> +int hinic_dcb_set_pfc(struct hinic_hwdev *hwdev, u8 pfc_en, u8 pfc_bitmap)

This is only ever called with 0, 0 as parameters.
