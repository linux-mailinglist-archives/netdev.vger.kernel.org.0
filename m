Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55EF1D5E0B
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 04:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgEPC6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 22:58:32 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2077 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726247AbgEPC6c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 22:58:32 -0400
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id D8266FC0081E0A754E42;
        Sat, 16 May 2020 10:58:28 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Sat, 16 May 2020 10:58:28 +0800
Received: from [10.173.219.71] (10.173.219.71) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Sat, 16 May 2020 10:58:28 +0800
Subject: Re: [PATCH net-next] hinic: add set_channels ethtool_ops support
To:     Michal Kubecek <mkubecek@suse.cz>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>
References: <20200515003547.27359-1-luobin9@huawei.com>
 <20200515181330.GC21714@lion.mk-sys.cz>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <595eb127-53ce-dea7-7289-78f53fd8d6bc@huawei.com>
Date:   Sat, 16 May 2020 10:58:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200515181330.GC21714@lion.mk-sys.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.173.219.71]
X-ClientProxiedBy: dggeme711-chm.china.huawei.com (10.1.199.107) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/5/16 2:13, Michal Kubecek wrote:
> On Fri, May 15, 2020 at 12:35:47AM +0000, Luo bin wrote:
>> add support to change TX/RX queue number with ethtool -L
>>
>> Signed-off-by: Luo bin <luobin9@huawei.com>
>> ---
>>   .../net/ethernet/huawei/hinic/hinic_ethtool.c | 67 +++++++++++++++++--
>>   .../net/ethernet/huawei/hinic/hinic_hw_dev.c  |  7 ++
>>   .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |  2 +
>>   .../net/ethernet/huawei/hinic/hinic_main.c    |  5 +-
>>   drivers/net/ethernet/huawei/hinic/hinic_tx.c  |  5 ++
>>   5 files changed, 79 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
>> index ace18d258049..92a0e3bd19c3 100644
>> --- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
>> +++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
>> @@ -619,14 +619,68 @@ static void hinic_get_channels(struct net_device *netdev,
>>   	struct hinic_dev *nic_dev = netdev_priv(netdev);
>>   	struct hinic_hwdev *hwdev = nic_dev->hwdev;
>>   
>> -	channels->max_rx = hwdev->nic_cap.max_qps;
>> -	channels->max_tx = hwdev->nic_cap.max_qps;
>> +	channels->max_rx = 0;
>> +	channels->max_tx = 0;
>>   	channels->max_other = 0;
>> -	channels->max_combined = 0;
>> -	channels->rx_count = hinic_hwdev_num_qps(hwdev);
>> -	channels->tx_count = hinic_hwdev_num_qps(hwdev);
>> +	channels->max_combined = nic_dev->max_qps;
>> +	channels->rx_count = 0;
>> +	channels->tx_count = 0;
>>   	channels->other_count = 0;
>> -	channels->combined_count = 0;
>> +	channels->combined_count = hinic_hwdev_num_qps(hwdev);
>> +}
>> +
>> +int hinic_set_channels(struct net_device *netdev,
>> +		       struct ethtool_channels *channels)
>> +{
>> +	struct hinic_dev *nic_dev = netdev_priv(netdev);
>> +	unsigned int count = channels->combined_count;
>> +	int err;
>> +
>> +	if (!count) {
>> +		netif_err(nic_dev, drv, netdev,
>> +			  "Unsupported combined_count: 0\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (channels->tx_count || channels->rx_count || channels->other_count) {
>> +		netif_err(nic_dev, drv, netdev,
>> +			  "Setting rx/tx/other count not supported\n");
>> +		return -EINVAL;
>> +	}
> With max_* reported as 0, these will be caught in ethnl_set_channels()
> or ethtool_set_channels().
> ---Will fix. Thanks
>> +	if (!(nic_dev->flags & HINIC_RSS_ENABLE)) {
>> +		netif_err(nic_dev, drv, netdev,
>> +			  "This function doesn't support RSS, only support 1 queue pair\n");
>> +		return -EOPNOTSUPP;
>> +	}
> I'm not sure if the request should fail even if requested count is
> actually 1.
>
>> +	if (count > nic_dev->max_qps) {
>> +		netif_err(nic_dev, drv, netdev,
>> +			  "Combined count %d exceeds limit %d\n",
>> +			  count, nic_dev->max_qps);
>> +		return -EINVAL;
>> +	}
> As above, this check has been already performed in ethnl_set_channels()
> or ethtool_set_channels().
> ---Will fix. Thanks
>> +	netif_info(nic_dev, drv, netdev, "Set max combined queue number from %d to %d\n",
>> +		   hinic_hwdev_num_qps(nic_dev->hwdev), count);
> We have netlink notifications now, is it necessary to log successful
> changes?
> ---I think it contributes to locating defects for developers.
>
> Michal
> .
