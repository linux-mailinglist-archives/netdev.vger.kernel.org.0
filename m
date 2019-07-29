Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17FBE789AF
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 12:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbfG2Kh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 06:37:28 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3197 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728151AbfG2Kh2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 06:37:28 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id AEA81E6113E8A0C205BC;
        Mon, 29 Jul 2019 18:37:25 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Mon, 29 Jul 2019
 18:37:19 +0800
Subject: Re: [PATCH net-next 08/11] net: hns3: add interrupt affinity support
 for misc interrupt
To:     Salil Mehta <salil.mehta@huawei.com>,
        tanhuazhong <tanhuazhong@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhuangyuzeng (Yisen)" <yisen.zhuang@huawei.com>,
        Linuxarm <linuxarm@huawei.com>,
        "lipeng (Y)" <lipeng321@huawei.com>
References: <1563938327-9865-1-git-send-email-tanhuazhong@huawei.com>
 <1563938327-9865-9-git-send-email-tanhuazhong@huawei.com>
 <fa3dbcce9e22453fb1ef111fd107d20f@huawei.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <f6e02338-b545-61a9-17de-222543dfef75@huawei.com>
Date:   Mon, 29 Jul 2019 18:37:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <fa3dbcce9e22453fb1ef111fd107d20f@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/7/29 17:18, Salil Mehta wrote:
>> From: tanhuazhong
>> Sent: Wednesday, July 24, 2019 4:19 AM
>> To: davem@davemloft.net
>> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Salil Mehta
>> <salil.mehta@huawei.com>; Zhuangyuzeng (Yisen) <yisen.zhuang@huawei.com>;
>> Linuxarm <linuxarm@huawei.com>; linyunsheng <linyunsheng@huawei.com>; lipeng
>> (Y) <lipeng321@huawei.com>; tanhuazhong <tanhuazhong@huawei.com>
>> Subject: [PATCH net-next 08/11] net: hns3: add interrupt affinity support for
>> misc interrupt
>>
>> From: Yunsheng Lin <linyunsheng@huawei.com>
>>
>> The misc interrupt is used to schedule the reset and mailbox
>> subtask, and a 1 sec timer is used to schedule the service
>> subtask, which does periodic work.
>>
>> This patch sets the above three subtask's affinity using the
>> misc interrupt' affinity.
>>
>> Also this patch setups a affinity notify for misc interrupt to
>> allow user to change the above three subtask's affinity.
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> Signed-off-by: Peng Li <lipeng321@huawei.com>
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
>> ---
>>  .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 59
>> ++++++++++++++++++++--
>>  .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  4 ++
>>  2 files changed, 59 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
>> b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
>> index f345095..fe45986 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
>> @@ -1270,6 +1270,12 @@ static int hclge_configure(struct hclge_dev *hdev)
>>
>>  	hclge_init_kdump_kernel_config(hdev);
>>
>> +	/* Set the init affinity based on pci func number */
>> +	i = cpumask_weight(cpumask_of_node(dev_to_node(&hdev->pdev->dev)));
>> +	i = i ? PCI_FUNC(hdev->pdev->devfn) % i : 0;
>> +	cpumask_set_cpu(cpumask_local_spread(i, dev_to_node(&hdev->pdev->dev)),
>> +			&hdev->affinity_mask);
>> +
>>  	return ret;
>>  }
>>
>> @@ -2502,14 +2508,16 @@ static void hclge_mbx_task_schedule(struct hclge_dev
>> *hdev)
>>  {
>>  	if (!test_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state) &&
>>  	    !test_and_set_bit(HCLGE_STATE_MBX_SERVICE_SCHED, &hdev->state))
>> -		schedule_work(&hdev->mbx_service_task);
>> +		queue_work_on(cpumask_first(&hdev->affinity_mask), system_wq,
> 
> 
> Why we have to use system Work Queue here? This could adversely affect
> other work scheduled not related to the HNS3 driver. Mailbox is internal
> to the driver and depending upon utilization of the mbx channel(which could
> be heavy if many VMs are running), this might stress other system tasks
> as well. Have we thought of this?

If I understand the CMWQ correctly, it is better to reuse the system Work
Queue when the work queue needed by HNS3 driver shares the same property of
system Work Queue, because Concurrency Managed Workqueue mechnism has ensured
they have the same worker pool if they share the same property.

Some driver(i40e) allocates a work queue with WQ_MEM_RECLAIM, I am not sure
what is the usecase which requires the WQ_MEM_RECLAIM.

Anyway, If the HNS3 need to allocate a new work queue, we need to
figure out the usecase first.

> 
> 
> 
>> +			      &hdev->mbx_service_task);
>>  }
>>
>>  static void hclge_reset_task_schedule(struct hclge_dev *hdev)
>>  {
>>  	if (!test_bit(HCLGE_STATE_REMOVING, &hdev->state) &&
>>  	    !test_and_set_bit(HCLGE_STATE_RST_SERVICE_SCHED, &hdev->state))
>> -		schedule_work(&hdev->rst_service_task);
>> +		queue_work_on(cpumask_first(&hdev->affinity_mask), system_wq,
>> +			      &hdev->rst_service_task);
>>  }
>>
>>  static void hclge_task_schedule(struct hclge_dev *hdev)
>> @@ -2517,7 +2525,8 @@ static void hclge_task_schedule(struct hclge_dev *hdev)
>>  	if (!test_bit(HCLGE_STATE_DOWN, &hdev->state) &&
>>  	    !test_bit(HCLGE_STATE_REMOVING, &hdev->state) &&
>>  	    !test_and_set_bit(HCLGE_STATE_SERVICE_SCHED, &hdev->state))
>> -		(void)schedule_work(&hdev->service_task);
>> +		queue_work_on(cpumask_first(&hdev->affinity_mask), system_wq,
> 
> Same here.
> 
> 
> Salil.
> 
> .
> 

