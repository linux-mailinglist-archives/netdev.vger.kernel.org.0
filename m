Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9EB93CF6D8
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 11:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235476AbhGTIuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 04:50:40 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:12280 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235619AbhGTIsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 04:48:52 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GTYFx6xhRz7w9X;
        Tue, 20 Jul 2021 17:24:53 +0800 (CST)
Received: from dggpeml500024.china.huawei.com (7.185.36.10) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Jul 2021 17:29:23 +0800
Received: from [10.67.103.6] (10.67.103.6) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 20 Jul
 2021 17:29:23 +0800
Subject: Re: [PATCH RFC] net: hns3: add a module parameter wq_unbound
To:     Leon Romanovsky <leon@kernel.org>
References: <1626770097-56989-1-git-send-email-moyufeng@huawei.com>
 <YPaQ0qW+uIToEM6c@unreal>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <shenjian15@huawei.com>, <lipeng321@huawei.com>,
        <yisen.zhuang@huawei.com>, <linyunsheng@huawei.com>,
        <zhangjiaran@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>, <salil.mehta@huawei.com>,
        <linuxarm@huawei.com>, <linuxarm@openeuler.org>
From:   moyufeng <moyufeng@huawei.com>
Message-ID: <5442f62e-163c-fcee-55c2-263fe123c507@huawei.com>
Date:   Tue, 20 Jul 2021 17:29:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <YPaQ0qW+uIToEM6c@unreal>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/7/20 17:01, Leon Romanovsky wrote:
> On Tue, Jul 20, 2021 at 04:34:57PM +0800, Yufeng Mo wrote:
>> To meet the requirements of different scenarios, the WQ_UNBOUND
>> flag of the workqueue is transferred as a module parameter. Users
>> can flexibly configure the usage mode as required.
>>
>> Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
>> ---
>>  drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 10 +++++++++-
>>  drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 10 +++++++++-
>>  2 files changed, 18 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
>> index dd3354a..9816592 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
>> @@ -76,6 +76,10 @@ static struct hnae3_ae_algo ae_algo;
>>  
>>  static struct workqueue_struct *hclge_wq;
>>  
>> +static unsigned int wq_unbound;
>> +module_param(wq_unbound, uint, 0400);
>> +MODULE_PARM_DESC(wq_unbound, "Specifies WQ_UNBOUND flag for the workqueue, non-zero value takes effect");
> 
> Nice, but no. We don't like module parameters for such a basic thing.
> Somehow all other NIC drivers in the world works without it and hns3
> will success too.
> 
> Thanks
> 

Thanks for your comments. I'll change it to WQ_UNBOUND mode fixedly for
more reasonable workqueue scheduling in complex scenarios.

Thanks

>> +
>>  static const struct pci_device_id ae_algo_pci_tbl[] = {
>>  	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_GE), 0},
>>  	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_25GE), 0},
>> @@ -12936,7 +12940,11 @@ static int hclge_init(void)
>>  {
>>  	pr_info("%s is initializing\n", HCLGE_NAME);
>>  
>> -	hclge_wq = alloc_workqueue("%s", 0, 0, HCLGE_NAME);
>> +	if (wq_unbound)
>> +		hclge_wq = alloc_workqueue("%s", WQ_UNBOUND, 0, HCLGE_NAME);
>> +	else
>> +		hclge_wq = alloc_workqueue("%s", 0, 0, HCLGE_NAME);
>> +
>>  	if (!hclge_wq) {
>>  		pr_err("%s: failed to create workqueue\n", HCLGE_NAME);
>>  		return -ENOMEM;
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
>> index 52eaf82..85f6772 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
>> @@ -21,6 +21,10 @@ static struct hnae3_ae_algo ae_algovf;
>>  
>>  static struct workqueue_struct *hclgevf_wq;
>>  
>> +static unsigned int wq_unbound;
>> +module_param(wq_unbound, uint, 0400);
>> +MODULE_PARM_DESC(wq_unbound, "Specifies WQ_UNBOUND flag for the workqueue, non-zero value takes effect");
>> +
>>  static const struct pci_device_id ae_algovf_pci_tbl[] = {
>>  	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_VF), 0},
>>  	{PCI_VDEVICE(HUAWEI, HNAE3_DEV_ID_RDMA_DCB_PFC_VF),
>> @@ -3855,7 +3859,11 @@ static int hclgevf_init(void)
>>  {
>>  	pr_info("%s is initializing\n", HCLGEVF_NAME);
>>  
>> -	hclgevf_wq = alloc_workqueue("%s", 0, 0, HCLGEVF_NAME);
>> +	if (wq_unbound)
>> +		hclgevf_wq = alloc_workqueue("%s", WQ_UNBOUND, 0, HCLGEVF_NAME);
>> +	else
>> +		hclgevf_wq = alloc_workqueue("%s", 0, 0, HCLGEVF_NAME);
>> +
>>  	if (!hclgevf_wq) {
>>  		pr_err("%s: failed to create workqueue\n", HCLGEVF_NAME);
>>  		return -ENOMEM;
>> -- 
>> 2.8.1
>>
> .
> 
