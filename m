Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB4520BD94
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 03:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgF0BaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 21:30:21 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2550 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726101AbgF0BaU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 21:30:20 -0400
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id 41F4623B295038994A6A;
        Sat, 27 Jun 2020 09:30:15 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Sat, 27 Jun 2020 09:30:14 +0800
Received: from [10.174.61.242] (10.174.61.242) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Sat, 27 Jun 2020 09:30:14 +0800
Subject: Re: [PATCH net-next v2 1/5] hinic: add support to set and get pause
 params
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
References: <20200623142409.19081-1-luobin9@huawei.com>
 <20200623142409.19081-2-luobin9@huawei.com>
 <20200623145421.163d22fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <65424d07-7e87-5f1a-f82b-2badbf47b38c@huawei.com>
Date:   Sat, 27 Jun 2020 09:30:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200623145421.163d22fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.61.242]
X-ClientProxiedBy: dggeme709-chm.china.huawei.com (10.1.199.105) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/6/24 5:54, Jakub Kicinski wrote:
> On Tue, 23 Jun 2020 22:24:05 +0800 Luo bin wrote:
>> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
>> index e9e6f4c9309a..e69edb01fd9b 100644
>> --- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
>> +++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
>> @@ -467,6 +467,7 @@ int hinic_open(struct net_device *netdev)
>>  	if (ret)
>>  		netif_warn(nic_dev, drv, netdev,
>>  			   "Failed to revert port state\n");
>> +
> 
> Unrelated chunk, please drop.
> 
Will undo this.Thanks.
>>  err_port_state:
>>  	free_rxqs(nic_dev);
>>  	if (nic_dev->flags & HINIC_RSS_ENABLE) {
>> @@ -887,6 +888,26 @@ static void netdev_features_init(struct net_device *netdev)
>>  	netdev->features = netdev->hw_features | NETIF_F_HW_VLAN_CTAG_FILTER;
>>  }
>>  
>> +static void hinic_refresh_nic_cfg(struct hinic_dev *nic_dev)
>> +{
>> +	struct hinic_nic_cfg *nic_cfg = &nic_dev->hwdev->func_to_io.nic_cfg;
>> +	struct hinic_pause_config pause_info = {0};
>> +	struct hinic_port_cap port_cap = {0};
>> +
>> +	if (hinic_port_get_cap(nic_dev, &port_cap))
>> +		return;
>> +
>> +	mutex_lock(&nic_cfg->cfg_mutex);
>> +	if (nic_cfg->pause_set || !port_cap.autoneg_state) {
>> +		nic_cfg->auto_neg = port_cap.autoneg_state;
>> +		pause_info.auto_neg = nic_cfg->auto_neg;
>> +		pause_info.rx_pause = nic_cfg->rx_pause;
>> +		pause_info.tx_pause = nic_cfg->tx_pause;
>> +		hinic_set_hw_pause_info(nic_dev->hwdev, &pause_info);
>> +	}
>> +	mutex_unlock(&nic_cfg->cfg_mutex);
>> +}
>> +
>>  /**
>>   * link_status_event_handler - link event handler
>>   * @handle: nic device for the handler
>> @@ -918,6 +939,9 @@ static void link_status_event_handler(void *handle, void *buf_in, u16 in_size,
>>  
>>  		up(&nic_dev->mgmt_lock);
>>  
>> +		if (!HINIC_IS_VF(nic_dev->hwdev->hwif))
>> +			hinic_refresh_nic_cfg(nic_dev);
>> +
>>  		netif_info(nic_dev, drv, nic_dev->netdev, "HINIC_Link is UP\n");
>>  	} else {
>>  		down(&nic_dev->mgmt_lock);
>> @@ -950,26 +974,38 @@ static int set_features(struct hinic_dev *nic_dev,
>>  	u32 csum_en = HINIC_RX_CSUM_OFFLOAD_EN;
>>  	int err = 0;
>>  
>> -	if (changed & NETIF_F_TSO)
>> +	if (changed & NETIF_F_TSO) {
>>  		err = hinic_port_set_tso(nic_dev, (features & NETIF_F_TSO) ?
>>  					 HINIC_TSO_ENABLE : HINIC_TSO_DISABLE);
>> +		if (err)
>> +			return err;
>> +	}
>>  
>> -	if (changed & NETIF_F_RXCSUM)
>> +	if (changed & NETIF_F_RXCSUM) {
>>  		err = hinic_set_rx_csum_offload(nic_dev, csum_en);
>> +		if (err)
>> +			return err;
>> +	}
>>  
>>  	if (changed & NETIF_F_LRO) {
>>  		err = hinic_set_rx_lro_state(nic_dev,
>>  					     !!(features & NETIF_F_LRO),
>>  					     HINIC_LRO_RX_TIMER_DEFAULT,
>>  					     HINIC_LRO_MAX_WQE_NUM_DEFAULT);
>> +		if (err)
>> +			return err;
>>  	}
>>  
>> -	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
>> +	if (changed & NETIF_F_HW_VLAN_CTAG_RX) {
>>  		err = hinic_set_rx_vlan_offload(nic_dev,
>>  						!!(features &
>>  						   NETIF_F_HW_VLAN_CTAG_RX));
>> +		if (err)
>> +			return err;
>> +	}
> 
> I missed this on v1, but this looks broken, multiple features may be
> changed at the same time. If user requests RXCSUM and LRO to be changed
> and LRO change fails the RXCSUM will be left in a different state than
> dev->features indicates.
>  
You're right. Will fix. Thank you.
>> -	return err;
>> +	/* enable pause and disable pfc by default */
>> +	return hinic_dcb_set_pfc(nic_dev->hwdev, 0, 0);
> 
> Why do you disable PFC every time features are changed?
>
It can be optimized. Thanks.

>> +int hinic_dcb_set_pfc(struct hinic_hwdev *hwdev, u8 pfc_en, u8 pfc_bitmap)
> 
> This is only ever called with 0, 0 as parameters.
> .
> 
This function will be called with other parameters before long to support DCB.
So I intend not to modify it.
