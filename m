Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEE291E8CDE
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 03:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbgE3Bai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 21:30:38 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:2511 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727876AbgE3Bai (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 21:30:38 -0400
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id B2EB6D981CBA66B8CAD9;
        Sat, 30 May 2020 09:30:36 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Sat, 30 May 2020 09:30:36 +0800
Received: from [10.173.219.71] (10.173.219.71) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Sat, 30 May 2020 09:30:35 +0800
Subject: Re: [PATCH net-next v2] hinic: add set_channels ethtool_ops support
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
References: <20200528183633.6689-1-luobin9@huawei.com>
 <20200529104424.58dd665a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <e316f3e4-fdc7-ebba-e6d8-ae74ba257b08@huawei.com>
Date:   Sat, 30 May 2020 09:30:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200529104424.58dd665a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.173.219.71]
X-ClientProxiedBy: dggeme714-chm.china.huawei.com (10.1.199.110) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/5/30 1:44, Jakub Kicinski wrote:

> On Thu, 28 May 2020 18:36:33 +0000 Luo bin wrote:
>> add support to change TX/RX queue number with ethtool -L
>>
>> Signed-off-by: Luo bin <luobin9@huawei.com>
> Luo bin, your patches continue to come with Date: header being in the
> past. Also suspiciously no time zone offset. Can you address this?
>
>> +static int hinic_set_channels(struct net_device *netdev,
>> +			      struct ethtool_channels *channels)
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
> This check has been added to the core since the last version of you
> patch:
>
> 	/* ensure there is at least one RX and one TX channel */
> 	if (!channels.combined_count &&
> 	    (!channels.rx_count || !channels.tx_count))
> 		return -EINVAL;
>
>> +	netif_info(nic_dev, drv, netdev, "Set max combined queue number from %d to %d\n",
>> +		   hinic_hwdev_num_qps(nic_dev->hwdev), count);
>> +
>> +	if (netif_running(netdev)) {
>> +		netif_info(nic_dev, drv, netdev, "Restarting netdev\n");
>> +		hinic_close(netdev);
>> +
>> +		nic_dev->hwdev->nic_cap.num_qps = count;
>> +
>> +		err = hinic_open(netdev);
>> +		if (err) {
>> +			netif_err(nic_dev, drv, netdev,
>> +				  "Failed to open netdev\n");
>> +			return -EFAULT;
>> +		}
>> +	} else {
>> +		nic_dev->hwdev->nic_cap.num_qps = count;
>> +	}
>> +
>> +	return 0;
>>   }
> Will fix. Thanks.
> .
