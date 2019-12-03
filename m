Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8F7610FA23
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 09:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbfLCIsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 03:48:54 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46274 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfLCIsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 03:48:54 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4700E1500CC09;
        Tue,  3 Dec 2019 00:48:53 -0800 (PST)
Date:   Tue, 03 Dec 2019 00:48:50 -0800 (PST)
Message-Id: <20191203.004850.2142378371017096251.davem@davemloft.net>
To:     linyunsheng@huawei.com
Cc:     tanhuazhong@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, salil.mehta@huawei.com,
        yisen.zhuang@huawei.com, linuxarm@huawei.com,
        jakub.kicinski@netronome.com
Subject: Re: [PATCH net 1/3] net: hns3: fix for TX queue not restarted
 problem
From:   David Miller <davem@davemloft.net>
In-Reply-To: <2f017ae3-ddec-928c-16b7-5ed59e6fc8d6@huawei.com>
References: <1575342535-2981-2-git-send-email-tanhuazhong@huawei.com>
        <20191202.192539.1290120247243731738.davem@davemloft.net>
        <2f017ae3-ddec-928c-16b7-5ed59e6fc8d6@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Dec 2019 00:48:53 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>
Date: Tue, 3 Dec 2019 12:28:22 +0800

> On 2019/12/3 11:25, David Miller wrote:
>> From: Huazhong Tan <tanhuazhong@huawei.com>
>> Date: Tue, 3 Dec 2019 11:08:53 +0800
>> 
>>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
>>> index ba05368..b2bb8e2 100644
>>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
>>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
>>> @@ -1286,13 +1286,16 @@ static bool hns3_skb_need_linearized(struct sk_buff *skb, unsigned int *bd_size,
>>>  	return false;
>>>  }
>>>  
>>> -static int hns3_nic_maybe_stop_tx(struct hns3_enet_ring *ring,
>>> +static int hns3_nic_maybe_stop_tx(struct net_device *netdev,
>>>  				  struct sk_buff **out_skb)
>>>  {
>>> +	struct hns3_nic_priv *priv = netdev_priv(netdev);
>>>  	unsigned int bd_size[HNS3_MAX_TSO_BD_NUM + 1U];
>>>  	struct sk_buff *skb = *out_skb;
>>> +	struct hns3_enet_ring *ring;
>>>  	unsigned int bd_num;
>>>  
>>> +	ring = &priv->ring[skb->queue_mapping];
>> 
>> Please just pass the ring pointer into hns3_nic_maybe_stop_tx() instead of
>> needlessly recalculating it.
> 
> The reason that I am passing the netdev instead of ring pointer is
> that the netif_start_subqueue() need a netdev parameter, and the
> netdev can not be derived from the ring pointer.
> 
> Do you think it is better to keep it as this patch, or add a new
> netdevice parameter? like below:

Just add the netdev parameter, in addition to the ring parameter.

All arguments fit in the register argument passing conventions of
various cpus so the cost of adding the parameter is zero.
