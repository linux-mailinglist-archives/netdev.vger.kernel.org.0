Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9107274317
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 04:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388831AbfGYCFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 22:05:37 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:54656 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388438AbfGYCFh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 22:05:37 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id ED01276D3082DAAF3BB1;
        Thu, 25 Jul 2019 10:05:33 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Thu, 25 Jul 2019
 10:05:23 +0800
Subject: Re: [PATCH net-next 08/11] net: hns3: add interrupt affinity support
 for misc interrupt
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "tanhuazhong@huawei.com" <tanhuazhong@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "lipeng321@huawei.com" <lipeng321@huawei.com>,
        "yisen.zhuang@huawei.com" <yisen.zhuang@huawei.com>,
        "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1563938327-9865-1-git-send-email-tanhuazhong@huawei.com>
 <1563938327-9865-9-git-send-email-tanhuazhong@huawei.com>
 <67b32cdc72c0be03622e78899ac518d807ca7b85.camel@mellanox.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <db2d081f-b892-b141-7fa5-44e66dd97eb9@huawei.com>
Date:   Thu, 25 Jul 2019 10:05:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <67b32cdc72c0be03622e78899ac518d807ca7b85.camel@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/7/25 3:24, Saeed Mahameed wrote:
> On Wed, 2019-07-24 at 11:18 +0800, Huazhong Tan wrote:
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
>> @@ -1270,6 +1270,12 @@ static int hclge_configure(struct hclge_dev
>> *hdev)
>>  
>>  	hclge_init_kdump_kernel_config(hdev);
>>  
>> +	/* Set the init affinity based on pci func number */
>> +	i = cpumask_weight(cpumask_of_node(dev_to_node(&hdev->pdev-
>>> dev)));
>> +	i = i ? PCI_FUNC(hdev->pdev->devfn) % i : 0;
>> +	cpumask_set_cpu(cpumask_local_spread(i, dev_to_node(&hdev-
>>> pdev->dev)),
>> +			&hdev->affinity_mask);
>> +
>>  	return ret;
>>  }
>>  
>> @@ -2502,14 +2508,16 @@ static void hclge_mbx_task_schedule(struct
>> hclge_dev *hdev)
>>  {
>>  	if (!test_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state) &&
>>  	    !test_and_set_bit(HCLGE_STATE_MBX_SERVICE_SCHED, &hdev-
>>> state))
>> -		schedule_work(&hdev->mbx_service_task);
>> +		queue_work_on(cpumask_first(&hdev->affinity_mask),
>> system_wq,
>> +			      &hdev->mbx_service_task);
>>  }
>>  
>>  static void hclge_reset_task_schedule(struct hclge_dev *hdev)
>>  {
>>  	if (!test_bit(HCLGE_STATE_REMOVING, &hdev->state) &&
>>  	    !test_and_set_bit(HCLGE_STATE_RST_SERVICE_SCHED, &hdev-
>>> state))
>> -		schedule_work(&hdev->rst_service_task);
>> +		queue_work_on(cpumask_first(&hdev->affinity_mask),
>> system_wq,
>> +			      &hdev->rst_service_task);
>>  }
>>  
>>  static void hclge_task_schedule(struct hclge_dev *hdev)
>> @@ -2517,7 +2525,8 @@ static void hclge_task_schedule(struct
>> hclge_dev *hdev)
>>  	if (!test_bit(HCLGE_STATE_DOWN, &hdev->state) &&
>>  	    !test_bit(HCLGE_STATE_REMOVING, &hdev->state) &&
>>  	    !test_and_set_bit(HCLGE_STATE_SERVICE_SCHED, &hdev->state))
>> -		(void)schedule_work(&hdev->service_task);
>> +		queue_work_on(cpumask_first(&hdev->affinity_mask),
>> system_wq,
>> +			      &hdev->service_task);
>>  }
>>  
>>  static int hclge_get_mac_link_status(struct hclge_dev *hdev)
>> @@ -2921,6 +2930,39 @@ static void hclge_get_misc_vector(struct
>> hclge_dev *hdev)
>>  	hdev->num_msi_used += 1;
>>  }
>>  
>> +static void hclge_irq_affinity_notify(struct irq_affinity_notify
>> *notify,
>> +				      const cpumask_t *mask)
>> +{
>> +	struct hclge_dev *hdev = container_of(notify, struct hclge_dev,
>> +					      affinity_notify);
>> +
>> +	cpumask_copy(&hdev->affinity_mask, mask);
>> +	del_timer_sync(&hdev->service_timer);
>> +	hdev->service_timer.expires = jiffies + HZ;
>> +	add_timer_on(&hdev->service_timer, cpumask_first(&hdev-
>>> affinity_mask));
>> +}
> 
> I don't see any relation between your misc irq vector and &hdev-
>> service_timer, to me this looks like an abuse of the irq affinity API
> to allow the user to move the service timer affinity.

Hi, thanks for reviewing.

hdev->service_timer is used to schedule the periodic work
queue hdev->service_task， we want all the management work
queue including hdev->service_task to bind to the same cpu
to improve cache and power efficiency, it is better to move
service timer affinity according to that.

The hdev->service_task is changed to delay work queue in
next patch " net: hns3: make hclge_service use delayed workqueue",
So the affinity in the timer of the delay work queue is automatically
set to the affinity of the delay work queue, we will move the
"make hclge_service use delayed workqueue" patch before the
"add interrupt affinity support for misc interrupt" patch, so
we do not have to set service timer affinity explicitly.

Also, There is there work queues(mbx_service_task, service_task,
rst_service_task) in the hns3 driver, we plan to combine them
to one or two workqueue to improve efficiency and readability.

> 
>> +
>> +static void hclge_irq_affinity_release(struct kref *ref)
>> +{
>> +}
>> +
>> +static void hclge_misc_affinity_setup(struct hclge_dev *hdev)
>> +{
>> +	irq_set_affinity_hint(hdev->misc_vector.vector_irq,
>> +			      &hdev->affinity_mask);
>> +
>> +	hdev->affinity_notify.notify = hclge_irq_affinity_notify;
>> +	hdev->affinity_notify.release = hclge_irq_affinity_release;
>> +	irq_set_affinity_notifier(hdev->misc_vector.vector_irq,
>> +				  &hdev->affinity_notify);
>> +}
>> +
>> +static void hclge_misc_affinity_teardown(struct hclge_dev *hdev)
>> +{
>> +	irq_set_affinity_notifier(hdev->misc_vector.vector_irq, NULL);
>> +	irq_set_affinity_hint(hdev->misc_vector.vector_irq, NULL);
>> +}
>> +
>>  static int hclge_misc_irq_init(struct hclge_dev *hdev)
>>  {
>>  	int ret;
>> @@ -6151,7 +6193,10 @@ static void hclge_set_timer_task(struct
>> hnae3_handle *handle, bool enable)
>>  	struct hclge_dev *hdev = vport->back;
>>  
>>  	if (enable) {
>> -		mod_timer(&hdev->service_timer, jiffies + HZ);
>> +		del_timer_sync(&hdev->service_timer);
>> +		hdev->service_timer.expires = jiffies + HZ;
>> +		add_timer_on(&hdev->service_timer,
>> +			     cpumask_first(&hdev->affinity_mask));
>>  	} else {
>>  		del_timer_sync(&hdev->service_timer);
>>  		cancel_work_sync(&hdev->service_task);
>> @@ -8809,6 +8854,11 @@ static int hclge_init_ae_dev(struct
>> hnae3_ae_dev *ae_dev)
>>  	INIT_WORK(&hdev->rst_service_task, hclge_reset_service_task);
>>  	INIT_WORK(&hdev->mbx_service_task, hclge_mailbox_service_task);
>>  
>> +	/* Setup affinity after service timer setup because
>> add_timer_on
>> +	 * is called in affinity notify.
>> +	 */
>> +	hclge_misc_affinity_setup(hdev);
>> +
>>  	hclge_clear_all_event_cause(hdev);
>>  	hclge_clear_resetting_state(hdev);
>>  
>> @@ -8970,6 +9020,7 @@ static void hclge_uninit_ae_dev(struct
>> hnae3_ae_dev *ae_dev)
>>  	struct hclge_dev *hdev = ae_dev->priv;
>>  	struct hclge_mac *mac = &hdev->hw.mac;
>>  
>> +	hclge_misc_affinity_teardown(hdev);
>>  	hclge_state_uninit(hdev);
>>  
>>  	if (mac->phydev)
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
>> b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
>> index 6a12285..14df23c 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
>> @@ -864,6 +864,10 @@ struct hclge_dev {
>>  
>>  	DECLARE_KFIFO(mac_tnl_log, struct hclge_mac_tnl_stats,
>>  		      HCLGE_MAC_TNL_LOG_SIZE);
>> +
>> +	/* affinity mask and notify for misc interrupt */
>> +	cpumask_t affinity_mask;
>> +	struct irq_affinity_notify affinity_notify;
>>  };
>>  
>>  /* VPort level vlan tag configuration for TX direction */

