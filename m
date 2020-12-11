Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE802D7092
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 08:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732066AbgLKHHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 02:07:30 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:9426 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731651AbgLKHHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 02:07:25 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Cshdz4MrrzhqSb;
        Fri, 11 Dec 2020 15:06:15 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Fri, 11 Dec 2020
 15:06:32 +0800
Subject: Re: [PATCH net-next 3/7] net: hns3: add support for forwarding packet
 to queues of specified TC when flow director rule hit
To:     Saeed Mahameed <saeed@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kuba@kernel.org>, <huangdaode@huawei.com>,
        Jian Shen <shenjian15@huawei.com>
References: <1607571732-24219-1-git-send-email-tanhuazhong@huawei.com>
 <1607571732-24219-4-git-send-email-tanhuazhong@huawei.com>
 <5057047d659b337317d1ee8355a2659c78d3315f.camel@kernel.org>
 <dc805355-9cb8-87f1-dc4b-f9cfed2a5764@huawei.com>
 <16de519d16ea1925e892f396378b79a98b2aa43e.camel@kernel.org>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <ec34a044-2980-6fbd-3f6b-e2641d190a16@huawei.com>
Date:   Fri, 11 Dec 2020 15:06:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <16de519d16ea1925e892f396378b79a98b2aa43e.camel@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/12/11 4:46, Saeed Mahameed wrote:
> On Thu, 2020-12-10 at 20:24 +0800, tanhuazhong wrote:
>>
>> On 2020/12/10 13:40, Saeed Mahameed wrote:
>>> On Thu, 2020-12-10 at 11:42 +0800, Huazhong Tan wrote:
>>>> From: Jian Shen <shenjian15@huawei.com>
>>>>
>>>> For some new device, it supports forwarding packet to queues
>>>> of specified TC when flow director rule hit. So extend the
>>>> command handle to support it.
>>>>
>>>
>>> ...
>>>
>>>>    static int hclge_config_action(struct hclge_dev *hdev, u8
>>>> stage,
>>>>    			       struct hclge_fd_rule *rule)
>>>>    {
>>>> +	struct hclge_vport *vport = hdev->vport;
>>>> +	struct hnae3_knic_private_info *kinfo = &vport->nic.kinfo;
>>>>    	struct hclge_fd_ad_data ad_data;
>>>>    
>>>> +	memset(&ad_data, 0, sizeof(struct hclge_fd_ad_data));
>>>>    	ad_data.ad_id = rule->location;
>>>>    
>>>>    	if (rule->action == HCLGE_FD_ACTION_DROP_PACKET) {
>>>>    		ad_data.drop_packet = true;
>>>> -		ad_data.forward_to_direct_queue = false;
>>>> -		ad_data.queue_id = 0;
>>>> +	} else if (rule->action == HCLGE_FD_ACTION_SELECT_TC) {
>>>> +		ad_data.override_tc = true;
>>>> +		ad_data.queue_id =
>>>> +			kinfo->tc_info.tqp_offset[rule->tc];
>>>> +		ad_data.tc_size =
>>>> +			ilog2(kinfo->tc_info.tqp_count[rule->tc]);
>>>
>>> In the previous patch you copied this info from mqprio, which is an
>>> egress qdisc feature, this patch is clearly about rx flow director,
>>> I
>>> think the patch is missing some context otherwise it doesn't make
>>> any
>>> sense.
>>>
>>
>> Since tx and rx are in the same tqp, what we do here is to make tx
>> and
>> rx in the same tc when rule is hit.
>>
> 
> this needs more clarification, even if tx and rx are the same hw
> object, AFAIK there is not correlation between mqprio and tc rx
> classifiers.
> 

Could comment below make the code more readable?
"Since tx and rx are in the same tqp, if hit rule, forward the packet to 
the rx queues pair with specified TC"

>>>>    	} else {
>>>> -		ad_data.drop_packet = false;
>>>>    		ad_data.forward_to_direct_queue = true;
>>>>    		ad_data.queue_id = rule->queue_id;
>>>>    	}
>>>> @@ -5937,7 +5950,7 @@ static int hclge_add_fd_entry(struct
>>>> hnae3_handle *handle,
>>>>    			return -EINVAL;
>>>>    		}
>>>>    
>>>> -		action = HCLGE_FD_ACTION_ACCEPT_PACKET;
>>>> +		action = HCLGE_FD_ACTION_SELECT_QUEUE;
>>>>    		q_index = ring;
>>>>    	}
>>>>    
>>>> diff --git
>>>> a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
>>>> b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
>>>> index b3c1301..a481064 100644
>>>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
>>>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
>>>> @@ -572,8 +572,9 @@ enum HCLGE_FD_PACKET_TYPE {
>>>>    };
>>>>    
>>>>    enum HCLGE_FD_ACTION {
>>>> -	HCLGE_FD_ACTION_ACCEPT_PACKET,
>>>> +	HCLGE_FD_ACTION_SELECT_QUEUE,
>>>>    	HCLGE_FD_ACTION_DROP_PACKET,
>>>> +	HCLGE_FD_ACTION_SELECT_TC,
>>>
>>> what is SELECT_TC ? you never actually write this value
>>> anywhere  in
>>> this patch.
>>>
>>
>> HCLGE_FD_ACTION_SELECT_TC means that the packet will be forwarded
>> into
>> the queue of specified TC when rule is hit.
>>
> what is "specified TC" in this context ?

TC specified by 'tc flower'

> 
> Are we talking about ethtool nfc steering here ? because clearly this
> was the purpose of HCLGE_FD_ACTION_ACCEPT_PACKET before it got removed.
> 

In fact, HCLGE_FD_ACTION_ACCEPT_PACKET is splitted in to 
HCLGE_FD_ACTION_SELECT_QUEUE and HCLGE_FD_ACTION_SELECT_TC.
HCLGE_FD_ACTION_SELECT_QUEUE is configured by 'ethtool -U' (nfc 
steering) or aRFS.
HCLGE_FD_ACTION_SELECT_TC is configured by 'tc flower' so far.


> 
>> the assignment is in the next patch, maybe these two patch should be
>> merged for making it more readable.
>>
>>
>> Thanks.
>> Huazhong.
>>
>>>
>>> .
>>>
> 
> 
> .
> 

