Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9083660CAE4
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 13:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbiJYL0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 07:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232218AbiJYLZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 07:25:53 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 641B518B485
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 04:25:52 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MxV142ClmzJn9W;
        Tue, 25 Oct 2022 19:23:04 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 25 Oct 2022 19:25:49 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 25 Oct 2022 19:25:49 +0800
Subject: Re: [PATCH net] net: fealnx: fix missing pci_disable_device()
To:     Leon Romanovsky <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
References: <20221024135728.2894863-1-yangyingliang@huawei.com>
 <Y1eUnh/DiEvYvVdO@unreal> <1adbffd3-6503-938e-b0b8-9525b72f00b3@huawei.com>
 <Y1e5+UMaHn3bsY5Y@unreal>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <4b1c521f-4d33-a496-81c5-79abe7521446@huawei.com>
Date:   Tue, 25 Oct 2022 19:25:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <Y1e5+UMaHn3bsY5Y@unreal>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
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


On 2022/10/25 18:27, Leon Romanovsky wrote:
> On Tue, Oct 25, 2022 at 05:01:58PM +0800, Yang Yingliang wrote:
>> On 2022/10/25 15:47, Leon Romanovsky wrote:
>>> On Mon, Oct 24, 2022 at 09:57:28PM +0800, Yang Yingliang wrote:
>>>> pci_disable_device() need be called while module exiting, switch
>>>> to use pcim_enable(), pci_disable_device() and pci_release_regions()
>>>> will be called in pcim_release() while unbinding device.
>>> I didn't understand the description at all, maybe people in CC will.
>>> Most likely, you wanted something like this:
>> After using pcim_enable_device(), pcim_release() will be called while
>> unbinding
>> device, pcim_release() calls both pci_release_regions() and
>> pci_disable_device().
> I'm not sure that you can mix managed with unmanaged PCI APIs.
>
> Thanks
After pcim_enable_device() being called, the region_mask is set in
__pci_request_region(). pcim_release() will call pci_release_region()
because region_mask is set.

Without device managed, the pci_release_region() and pci_disable_device()
is called at end of remove() function which is called in 
device_remove(), and
with managed, they are called in device_unbind_cleanup() which is called
after device_remove(). So I think it's OK to use this management.

Thanks,
Yang
>
>> Thanks,
>> Yang
>>> diff --git a/drivers/net/ethernet/fealnx.c b/drivers/net/ethernet/fealnx.c
>>> index ed18450fd2cc..78107dd4aa57 100644
>>> --- a/drivers/net/ethernet/fealnx.c
>>> +++ b/drivers/net/ethernet/fealnx.c
>>> @@ -690,6 +690,7 @@ static void fealnx_remove_one(struct pci_dev *pdev)
>>>                   pci_iounmap(pdev, np->mem);
>>>                   free_netdev(dev);
>>>                   pci_release_regions(pdev);
>>> +               pci_disable_device(pdev);
>>>           } else
>>>                   printk(KERN_ERR "fealnx: remove for unknown device\n");
>>>
>>>
>>>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>>>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>>>> ---
>>>>    drivers/net/ethernet/fealnx.c | 4 +---
>>>>    1 file changed, 1 insertion(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/fealnx.c b/drivers/net/ethernet/fealnx.c
>>>> index ed18450fd2cc..fb139f295b67 100644
>>>> --- a/drivers/net/ethernet/fealnx.c
>>>> +++ b/drivers/net/ethernet/fealnx.c
>>>> @@ -494,7 +494,7 @@ static int fealnx_init_one(struct pci_dev *pdev,
>>>>    	option = card_idx < MAX_UNITS ? options[card_idx] : 0;
>>>> -	i = pci_enable_device(pdev);
>>>> +	i = pcim_enable_device(pdev);
>>>>    	if (i) return i;
>>>>    	pci_set_master(pdev);
>>>> @@ -670,7 +670,6 @@ static int fealnx_init_one(struct pci_dev *pdev,
>>>>    err_out_unmap:
>>>>    	pci_iounmap(pdev, ioaddr);
>>>>    err_out_res:
>>>> -	pci_release_regions(pdev);
>>>>    	return err;
>>>>    }
>>>> @@ -689,7 +688,6 @@ static void fealnx_remove_one(struct pci_dev *pdev)
>>>>    		unregister_netdev(dev);
>>>>    		pci_iounmap(pdev, np->mem);
>>>>    		free_netdev(dev);
>>>> -		pci_release_regions(pdev);
>>>>    	} else
>>>>    		printk(KERN_ERR "fealnx: remove for unknown device\n");
>>>>    }
>>>> -- 
>>>> 2.25.1
>>>>
>>> .
> .
