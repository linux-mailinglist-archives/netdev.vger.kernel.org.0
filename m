Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08B9B7882B
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 11:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727574AbfG2JTD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Jul 2019 05:19:03 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:60246 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726496AbfG2JTC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 05:19:02 -0400
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 0CCEC2E88F05F5A130F2;
        Mon, 29 Jul 2019 17:19:00 +0800 (CST)
Received: from dggeme707-chm.china.huawei.com (10.1.199.103) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 29 Jul 2019 17:18:59 +0800
Received: from lhreml703-chm.china.huawei.com (10.201.108.52) by
 dggeme707-chm.china.huawei.com (10.1.199.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Mon, 29 Jul 2019 17:18:57 +0800
Received: from lhreml703-chm.china.huawei.com ([10.201.68.198]) by
 lhreml703-chm.china.huawei.com ([10.201.68.198]) with mapi id 15.01.1713.004;
 Mon, 29 Jul 2019 10:18:55 +0100
From:   Salil Mehta <salil.mehta@huawei.com>
To:     tanhuazhong <tanhuazhong@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhuangyuzeng (Yisen)" <yisen.zhuang@huawei.com>,
        Linuxarm <linuxarm@huawei.com>,
        linyunsheng <linyunsheng@huawei.com>,
        "lipeng (Y)" <lipeng321@huawei.com>
Subject: RE: [PATCH net-next 08/11] net: hns3: add interrupt affinity support
 for misc interrupt
Thread-Topic: [PATCH net-next 08/11] net: hns3: add interrupt affinity support
 for misc interrupt
Thread-Index: AQHVQc7SvuUmwP6wYkeZvk7xQcNJGqbhV81w
Date:   Mon, 29 Jul 2019 09:18:55 +0000
Message-ID: <fa3dbcce9e22453fb1ef111fd107d20f@huawei.com>
References: <1563938327-9865-1-git-send-email-tanhuazhong@huawei.com>
 <1563938327-9865-9-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1563938327-9865-9-git-send-email-tanhuazhong@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.226.45]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: tanhuazhong
> Sent: Wednesday, July 24, 2019 4:19 AM
> To: davem@davemloft.net
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Salil Mehta
> <salil.mehta@huawei.com>; Zhuangyuzeng (Yisen) <yisen.zhuang@huawei.com>;
> Linuxarm <linuxarm@huawei.com>; linyunsheng <linyunsheng@huawei.com>; lipeng
> (Y) <lipeng321@huawei.com>; tanhuazhong <tanhuazhong@huawei.com>
> Subject: [PATCH net-next 08/11] net: hns3: add interrupt affinity support for
> misc interrupt
> 
> From: Yunsheng Lin <linyunsheng@huawei.com>
> 
> The misc interrupt is used to schedule the reset and mailbox
> subtask, and a 1 sec timer is used to schedule the service
> subtask, which does periodic work.
> 
> This patch sets the above three subtask's affinity using the
> misc interrupt' affinity.
> 
> Also this patch setups a affinity notify for misc interrupt to
> allow user to change the above three subtask's affinity.
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> Signed-off-by: Peng Li <lipeng321@huawei.com>
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> ---
>  .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 59
> ++++++++++++++++++++--
>  .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  4 ++
>  2 files changed, 59 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> index f345095..fe45986 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> @@ -1270,6 +1270,12 @@ static int hclge_configure(struct hclge_dev *hdev)
> 
>  	hclge_init_kdump_kernel_config(hdev);
> 
> +	/* Set the init affinity based on pci func number */
> +	i = cpumask_weight(cpumask_of_node(dev_to_node(&hdev->pdev->dev)));
> +	i = i ? PCI_FUNC(hdev->pdev->devfn) % i : 0;
> +	cpumask_set_cpu(cpumask_local_spread(i, dev_to_node(&hdev->pdev->dev)),
> +			&hdev->affinity_mask);
> +
>  	return ret;
>  }
> 
> @@ -2502,14 +2508,16 @@ static void hclge_mbx_task_schedule(struct hclge_dev
> *hdev)
>  {
>  	if (!test_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state) &&
>  	    !test_and_set_bit(HCLGE_STATE_MBX_SERVICE_SCHED, &hdev->state))
> -		schedule_work(&hdev->mbx_service_task);
> +		queue_work_on(cpumask_first(&hdev->affinity_mask), system_wq,


Why we have to use system Work Queue here? This could adversely affect
other work scheduled not related to the HNS3 driver. Mailbox is internal
to the driver and depending upon utilization of the mbx channel(which could
be heavy if many VMs are running), this might stress other system tasks
as well. Have we thought of this?



> +			      &hdev->mbx_service_task);
>  }
> 
>  static void hclge_reset_task_schedule(struct hclge_dev *hdev)
>  {
>  	if (!test_bit(HCLGE_STATE_REMOVING, &hdev->state) &&
>  	    !test_and_set_bit(HCLGE_STATE_RST_SERVICE_SCHED, &hdev->state))
> -		schedule_work(&hdev->rst_service_task);
> +		queue_work_on(cpumask_first(&hdev->affinity_mask), system_wq,
> +			      &hdev->rst_service_task);
>  }
> 
>  static void hclge_task_schedule(struct hclge_dev *hdev)
> @@ -2517,7 +2525,8 @@ static void hclge_task_schedule(struct hclge_dev *hdev)
>  	if (!test_bit(HCLGE_STATE_DOWN, &hdev->state) &&
>  	    !test_bit(HCLGE_STATE_REMOVING, &hdev->state) &&
>  	    !test_and_set_bit(HCLGE_STATE_SERVICE_SCHED, &hdev->state))
> -		(void)schedule_work(&hdev->service_task);
> +		queue_work_on(cpumask_first(&hdev->affinity_mask), system_wq,

Same here.


Salil.
