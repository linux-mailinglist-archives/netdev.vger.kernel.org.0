Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E552D7075
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 07:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436624AbgLKG4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 01:56:23 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9185 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436622AbgLKG4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 01:56:13 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CshNc2YtzzkmqS;
        Fri, 11 Dec 2020 14:54:40 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Fri, 11 Dec 2020
 14:55:16 +0800
Subject: Re: [PATCH net-next 2/7] net: hns3: add support for tc mqprio offload
To:     Saeed Mahameed <saeed@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kuba@kernel.org>, <huangdaode@huawei.com>,
        Jian Shen <shenjian15@huawei.com>
References: <1607571732-24219-1-git-send-email-tanhuazhong@huawei.com>
 <1607571732-24219-3-git-send-email-tanhuazhong@huawei.com>
 <80b7502b700df43df7f66fa79fb9893399d0abd1.camel@kernel.org>
 <42c9fd63-3e51-543e-bbbd-01e7face7c9c@huawei.com>
 <d2c14bd14daabcd7f589e17b14b2ffeebc0d8a15.camel@kernel.org>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <891cac41-4a56-e173-5521-364a93fe6a69@huawei.com>
Date:   Fri, 11 Dec 2020 14:55:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <d2c14bd14daabcd7f589e17b14b2ffeebc0d8a15.camel@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/12/11 4:24, Saeed Mahameed wrote:
> On Thu, 2020-12-10 at 20:27 +0800, tanhuazhong wrote:
>>
>> On 2020/12/10 12:50, Saeed Mahameed wrote:
>>> On Thu, 2020-12-10 at 11:42 +0800, Huazhong Tan wrote:
>>>> From: Jian Shen <shenjian15@huawei.com>
>>>>
>>>> Currently, the HNS3 driver only supports offload for tc number
>>>> and prio_tc. This patch adds support for other qopts, including
>>>> queues count and offset for each tc.
>>>>
>>>> When enable tc mqprio offload, it's not allowed to change
>>>> queue numbers by ethtool. For hardware limitation, the queue
>>>> number of each tc should be power of 2.
>>>>
>>>> For the queues is not assigned to each tc by average, so it's
>>>> should return vport->alloc_tqps for hclge_get_max_channels().
>>>>
>>>
>>> The commit message needs some improvements, it is not really clear
>>> what
>>> the last two sentences are about.
>>>
>>
>> The hclge_get_max_channels() returns the max queue number of each TC
>> for
>> user can set by command ethool -L. In previous implement, the queues
>> are
>> assigned to each TC by average, so we return it by vport-:
>> alloc_tqps / num_tc. And now we can assign differrent queue number
>> for
>> each TC, so it shouldn't be divided by num_tc.
> 
> What do you mean by "queues assigned to each tc by average" ?
> 

In previous implement the number of queue in each TC is same, now, we
allow that the number of queue in each TC is different.

> [...]
> 
>>    
>>>> +	}
>>>> +	if (hdev->vport[0].alloc_tqps < queue_sum) {
>>>
>>> can't you just allocate new tqps according to the new mqprio input
>>> like
>>> other drivers do ? how the user allocates those tqps ?
>>>
>>
>> maybe the name of 'alloc_tqps' is a little bit misleading, the
>> meaning
>> of this field is the total number of the available tqps in this
>> vport.
>>
> 
> from your driver code it seems alloc_tqps is number of rings allocated
> via ethool -L.
> 
> My point is, it seems like in this patch you demand for the queues to
> be preallocated, but what other drivers do on setup tc, they just
> duplicate what ever number of queues was configured prior to setup tc,
> num_tc times.
> 

The maximum number of queues is defined by 'alloc_tqps', not 
preallocated queues. The behavior on setup tc of HNS3 is same as other 
driver.

'alloc_tqps' in HNS3 has the same means as 'num_queue_pairs' in i40e below
if (vsi->num_queue_pairs <
	    (mqprio_qopt->qopt.offset[i] + mqprio_qopt->qopt.count[i])) {
		return -EINVAL;
}

>>>> +		dev_err(&hdev->pdev->dev,
>>>> +			"qopt queue count sum should be less than
>>>> %u\n",
>>>> +			hdev->vport[0].alloc_tqps);
>>>> +		return -EINVAL;
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static void hclge_sync_mqprio_qopt(struct hnae3_tc_info
>>>> *tc_info,
>>>> +				   struct tc_mqprio_qopt_offload
>>>> *mqprio_qopt)
>>>> +{
>>>> +	int i;
>>>> +
>>>> +	memset(tc_info, 0, sizeof(*tc_info));
>>>> +	tc_info->num_tc = mqprio_qopt->qopt.num_tc;
>>>> +	memcpy(tc_info->prio_tc, mqprio_qopt->qopt.prio_tc_map,
>>>> +	       sizeof_field(struct hnae3_tc_info, prio_tc));
>>>> +	memcpy(tc_info->tqp_count, mqprio_qopt->qopt.count,
>>>> +	       sizeof_field(struct hnae3_tc_info, tqp_count));
>>>> +	memcpy(tc_info->tqp_offset, mqprio_qopt->qopt.offset,
>>>> +	       sizeof_field(struct hnae3_tc_info, tqp_offset));
>>>> +
>>>
>>> isn't it much easier to just store a copy of tc_mqprio_qopt in you
>>> tc_info and then just:
>>> tc_info->qopt = mqprio->qopt;
>>>
>>> [...]
>>
>> The tc_mqprio_qopt_offload still contains a lot of opt hns3 driver
>> does
>> not use yet, even if the hns3 use all the opt, I still think it is
>> better to create our own struct, if struct tc_mqprio_qopt_offload
>> changes in the future, we can limit the change to the
>> tc_mqprio_qopt_offload convertion.
>>
> 
> ok.
> 

Thanks.
Huazhong.

> 
> 
> .
> 

