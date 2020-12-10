Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 004F02D5A88
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 13:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732645AbgLJM2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 07:28:31 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9149 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729283AbgLJM20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 07:28:26 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CsCpV37Pvz15bBh;
        Thu, 10 Dec 2020 20:26:58 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Thu, 10 Dec 2020
 20:27:25 +0800
Subject: Re: [PATCH net-next 2/7] net: hns3: add support for tc mqprio offload
To:     Saeed Mahameed <saeed@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kuba@kernel.org>, <huangdaode@huawei.com>,
        Jian Shen <shenjian15@huawei.com>
References: <1607571732-24219-1-git-send-email-tanhuazhong@huawei.com>
 <1607571732-24219-3-git-send-email-tanhuazhong@huawei.com>
 <80b7502b700df43df7f66fa79fb9893399d0abd1.camel@kernel.org>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <42c9fd63-3e51-543e-bbbd-01e7face7c9c@huawei.com>
Date:   Thu, 10 Dec 2020 20:27:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <80b7502b700df43df7f66fa79fb9893399d0abd1.camel@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/12/10 12:50, Saeed Mahameed wrote:
> On Thu, 2020-12-10 at 11:42 +0800, Huazhong Tan wrote:
>> From: Jian Shen <shenjian15@huawei.com>
>>
>> Currently, the HNS3 driver only supports offload for tc number
>> and prio_tc. This patch adds support for other qopts, including
>> queues count and offset for each tc.
>>
>> When enable tc mqprio offload, it's not allowed to change
>> queue numbers by ethtool. For hardware limitation, the queue
>> number of each tc should be power of 2.
>>
>> For the queues is not assigned to each tc by average, so it's
>> should return vport->alloc_tqps for hclge_get_max_channels().
>>
> 
> The commit message needs some improvements, it is not really clear what
> the last two sentences are about.
> 

The hclge_get_max_channels() returns the max queue number of each TC for
user can set by command ethool -L. In previous implement, the queues are
assigned to each TC by average, so we return it by vport-:
alloc_tqps / num_tc. And now we can assign differrent queue number for
each TC, so it shouldn't be divided by num_tc.

>> Signed-off-by: Jian Shen <shenjian15@huawei.com>
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
>> ---
>>
> ...
> 
>>   
>> +	if (kinfo->tc_info.mqprio_active) {
>> +		dev_err(&netdev->dev,
> 
> why not use netdev_err() and friends ?
> anyway I see your driver is using dev_err(&netdev->dev, ...)
> intensively,
> maybe submit a follow up patch to fix all your prints ?
> 

yes, will fix it with another patch.

> ...]
>>   
>> +static int hclge_mqprio_qopt_check(struct hclge_dev *hdev,
>> +				   struct tc_mqprio_qopt_offload
>> *mqprio_qopt)
>> +{
>> +	u16 queue_sum = 0;
>> +	int ret;
>> +	int i;
>> +
>> +	if (!mqprio_qopt->qopt.num_tc) {
>> +		mqprio_qopt->qopt.num_tc = 1;
>> +		return 0;
>> +	}
>> +
>> +	ret = hclge_dcb_common_validate(hdev, mqprio_qopt->qopt.num_tc,
>> +					mqprio_qopt->qopt.prio_tc_map);
>> +	if (ret)
>> +		return ret;
>> +
>> +	for (i = 0; i < mqprio_qopt->qopt.num_tc; i++) {
>> +		if (!is_power_of_2(mqprio_qopt->qopt.count[i])) {
>> +			dev_err(&hdev->pdev->dev,
>> +				"qopt queue count must be power of
>> 2\n");
>> +			return -EINVAL;
>> +		}
>> +
>> +		if (mqprio_qopt->qopt.count[i] > hdev->rss_size_max) {
>> +			dev_err(&hdev->pdev->dev,
>> +				"qopt queue count should be no more
>> than %u\n",
>> +				hdev->rss_size_max);
>> +			return -EINVAL;
>> +		}
>> +
>> +		if (mqprio_qopt->qopt.offset[i] != queue_sum) {
>> +			dev_err(&hdev->pdev->dev,
>> +				"qopt queue offset must start from 0,
>> and being continuous\n");
>> +			return -EINVAL;
>> +		}
>> +
>> +		if (mqprio_qopt->min_rate[i] || mqprio_qopt-
>>> max_rate[i]) {
>> +			dev_err(&hdev->pdev->dev,
>> +				"qopt tx_rate is not supported\n");
>> +			return -EOPNOTSUPP;
>> +		}
>> +
>> +		queue_sum = mqprio_qopt->qopt.offset[i];
>> +		queue_sum += mqprio_qopt->qopt.count[i];
> 
> it will make more sense if you moved this queue summing outside of the
> loop
> 

this queue_sum is used in this loop:
if (mqprio_qopt->qopt.offset[i] != queue_sum) {
...

>> +	}
>> +	if (hdev->vport[0].alloc_tqps < queue_sum) {
> 
> can't you just allocate new tqps according to the new mqprio input like
> other drivers do ? how the user allocates those tqps ?
> 

maybe the name of 'alloc_tqps' is a little bit misleading, the meaning
of this field is the total number of the available tqps in this vport.

>> +		dev_err(&hdev->pdev->dev,
>> +			"qopt queue count sum should be less than
>> %u\n",
>> +			hdev->vport[0].alloc_tqps);
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static void hclge_sync_mqprio_qopt(struct hnae3_tc_info *tc_info,
>> +				   struct tc_mqprio_qopt_offload
>> *mqprio_qopt)
>> +{
>> +	int i;
>> +
>> +	memset(tc_info, 0, sizeof(*tc_info));
>> +	tc_info->num_tc = mqprio_qopt->qopt.num_tc;
>> +	memcpy(tc_info->prio_tc, mqprio_qopt->qopt.prio_tc_map,
>> +	       sizeof_field(struct hnae3_tc_info, prio_tc));
>> +	memcpy(tc_info->tqp_count, mqprio_qopt->qopt.count,
>> +	       sizeof_field(struct hnae3_tc_info, tqp_count));
>> +	memcpy(tc_info->tqp_offset, mqprio_qopt->qopt.offset,
>> +	       sizeof_field(struct hnae3_tc_info, tqp_offset));
>> +
> 
> isn't it much easier to just store a copy of tc_mqprio_qopt in you
> tc_info and then just:
> tc_info->qopt = mqprio->qopt;
> 
> [...]

The tc_mqprio_qopt_offload still contains a lot of opt hns3 driver does
not use yet, even if the hns3 use all the opt, I still think it is
better to create our own struct, if struct tc_mqprio_qopt_offload
changes in the future, we can limit the change to the
tc_mqprio_qopt_offload convertion.

>> -	hclge_tm_schd_info_update(hdev, tc);
>> -	hclge_tm_prio_tc_info_update(hdev, prio_tc);
>> -
>> -	ret = hclge_tm_init_hw(hdev, false);
>> -	if (ret)
>> -		goto err_out;
>> +	kinfo = &vport->nic.kinfo;
>> +	memcpy(&old_tc_info, &kinfo->tc_info, sizeof(old_tc_info));
> 
> if those are of the same kind, just normal assignment would be much
> cleaner.

yes, normal assignment seems cleaner.

>> +	hclge_sync_mqprio_qopt(&kinfo->tc_info, mqprio_qopt);
>> +	kinfo->tc_info.mqprio_active = tc > 0;
>>   
>> -	ret = hclge_client_setup_tc(hdev);
>> +	ret = hclge_config_tc(hdev, &kinfo->tc_info);
>>   	if (ret)
>>   		goto err_out;
>>   
>> @@ -436,6 +534,12 @@ static int hclge_setup_tc(struct hnae3_handle
>> *h, u8 tc, u8 *prio_tc)
>>   	return hclge_notify_init_up(hdev);
>>   
>>   err_out:
>> +	/* roll-back */
>> +	memcpy(&kinfo->tc_info, &old_tc_info, sizeof(old_tc_info));
> same.
> 
> 
> 
> .
> 

