Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 472B86058F0
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 09:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbiJTHqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 03:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbiJTHqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 03:46:08 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2C798CB8
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 00:46:02 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MtKQm1xKJzHv7n;
        Thu, 20 Oct 2022 15:45:52 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 20 Oct 2022 15:45:18 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 20 Oct 2022 15:45:17 +0800
Subject: Re: [PATCH net] net: hns: fix possible memory leak in
 hnae_ae_register()
To:     Leon Romanovsky <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <davem@davemloft.net>
References: <20221018122451.1749171-1-yangyingliang@huawei.com>
 <Y06i/kWwJNT5mbj8@unreal>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <bcde51e2-3abf-6ff7-b5a5-c23c7886d2f4@huawei.com>
Date:   Thu, 20 Oct 2022 15:45:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <Y06i/kWwJNT5mbj8@unreal>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2022/10/18 20:58, Leon Romanovsky wrote:
> On Tue, Oct 18, 2022 at 08:24:51PM +0800, Yang Yingliang wrote:
>> Inject fault while probing module, if device_register() fails,
>> but the refcount of kobject is not decreased to 0, the name
>> allocated in dev_set_name() is leaked. Fix this by calling
>> put_device(), so that name can be freed in callback function
>> kobject_cleanup().
>>
>> unreferenced object 0xffff00c01aba2100 (size 128):
>>    comm "systemd-udevd", pid 1259, jiffies 4294903284 (age 294.152s)
>>    hex dump (first 32 bytes):
>>      68 6e 61 65 30 00 00 00 18 21 ba 1a c0 00 ff ff  hnae0....!......
>>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>    backtrace:
>>      [<0000000034783f26>] slab_post_alloc_hook+0xa0/0x3e0
>>      [<00000000748188f2>] __kmem_cache_alloc_node+0x164/0x2b0
>>      [<00000000ab0743e8>] __kmalloc_node_track_caller+0x6c/0x390
>>      [<000000006c0ffb13>] kvasprintf+0x8c/0x118
>>      [<00000000fa27bfe1>] kvasprintf_const+0x60/0xc8
>>      [<0000000083e10ed7>] kobject_set_name_vargs+0x3c/0xc0
>>      [<000000000b87affc>] dev_set_name+0x7c/0xa0
>>      [<000000003fd8fe26>] hnae_ae_register+0xcc/0x190 [hnae]
>>      [<00000000fe97edc9>] hns_dsaf_ae_init+0x9c/0x108 [hns_dsaf]
>>      [<00000000c36ff1eb>] hns_dsaf_probe+0x548/0x748 [hns_dsaf]
>>
>> Fixes: 6fe6611ff275 ("net: add Hisilicon Network Subsystem hnae framework support")
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> ---
>>   drivers/net/ethernet/hisilicon/hns/hnae.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/hisilicon/hns/hnae.c b/drivers/net/ethernet/hisilicon/hns/hnae.c
>> index 00fafc0f8512..430eccea8e5e 100644
>> --- a/drivers/net/ethernet/hisilicon/hns/hnae.c
>> +++ b/drivers/net/ethernet/hisilicon/hns/hnae.c
>> @@ -419,8 +419,10 @@ int hnae_ae_register(struct hnae_ae_dev *hdev, struct module *owner)
>>   	hdev->cls_dev.release = hnae_release;
>>   	(void)dev_set_name(&hdev->cls_dev, "hnae%d", hdev->id);
>                ^^^^^^^^^^^^ this is unexpected in netdev code.
Did you mean the 'void' can be removed ?
>
>>   	ret = device_register(&hdev->cls_dev);
>> -	if (ret)
>> +	if (ret) {
>> +		put_device(&hdev->cls_dev);
>>   		return ret;
>> +	}
>>   
>>   	__module_get(THIS_MODULE);
>          ^^^^^^^^ I'm curious why? I don't see why you need this.
hnae_ae_register() is called from hns_dsaf.ko(hns_dsaf_probe()), the
refcount of module hnae is already be got while loading hns_dsaf.ko
in resolve_symbol(),  so I think this can be removed.

Thanks,
Yang
>
> The change itself is ok.
>
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> .
