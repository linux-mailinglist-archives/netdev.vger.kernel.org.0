Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B19911210A
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 02:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfLDBc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 20:32:28 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7628 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726060AbfLDBc2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Dec 2019 20:32:28 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id EA3AAC1FB35751552426;
        Wed,  4 Dec 2019 09:32:25 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Wed, 4 Dec 2019
 09:32:19 +0800
Subject: Re: [PATCH net 1/3] net: hns3: fix for TX queue not restarted problem
To:     David Miller <davem@davemloft.net>
CC:     <tanhuazhong@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>,
        <jakub.kicinski@netronome.com>
References: <1575342535-2981-2-git-send-email-tanhuazhong@huawei.com>
 <20191202.192539.1290120247243731738.davem@davemloft.net>
 <2f017ae3-ddec-928c-16b7-5ed59e6fc8d6@huawei.com>
 <20191203.004850.2142378371017096251.davem@davemloft.net>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <fbb92429-7242-3716-0f53-35e6b83aeeb2@huawei.com>
Date:   Wed, 4 Dec 2019 09:32:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20191203.004850.2142378371017096251.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/12/3 16:48, David Miller wrote:
> From: Yunsheng Lin <linyunsheng@huawei.com>
> Date: Tue, 3 Dec 2019 12:28:22 +0800
> 
>> On 2019/12/3 11:25, David Miller wrote:
>>> From: Huazhong Tan <tanhuazhong@huawei.com>
>>> Date: Tue, 3 Dec 2019 11:08:53 +0800
>>>
>>>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
>>>> index ba05368..b2bb8e2 100644
>>>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
>>>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
>>>> @@ -1286,13 +1286,16 @@ static bool hns3_skb_need_linearized(struct sk_buff *skb, unsigned int *bd_size,
>>>>  	return false;
>>>>  }
>>>>  
>>>> -static int hns3_nic_maybe_stop_tx(struct hns3_enet_ring *ring,
>>>> +static int hns3_nic_maybe_stop_tx(struct net_device *netdev,
>>>>  				  struct sk_buff **out_skb)
>>>>  {
>>>> +	struct hns3_nic_priv *priv = netdev_priv(netdev);
>>>>  	unsigned int bd_size[HNS3_MAX_TSO_BD_NUM + 1U];
>>>>  	struct sk_buff *skb = *out_skb;
>>>> +	struct hns3_enet_ring *ring;
>>>>  	unsigned int bd_num;
>>>>  
>>>> +	ring = &priv->ring[skb->queue_mapping];
>>>
>>> Please just pass the ring pointer into hns3_nic_maybe_stop_tx() instead of
>>> needlessly recalculating it.
>>
>> The reason that I am passing the netdev instead of ring pointer is
>> that the netif_start_subqueue() need a netdev parameter, and the
>> netdev can not be derived from the ring pointer.
>>
>> Do you think it is better to keep it as this patch, or add a new
>> netdevice parameter? like below:
> 
> Just add the netdev parameter, in addition to the ring parameter.
> 
> All arguments fit in the register argument passing conventions of
> various cpus so the cost of adding the parameter is zero.

Ok, thanks.

> 
> .
> 

