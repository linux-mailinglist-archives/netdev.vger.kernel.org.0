Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 124F864413D
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 11:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbiLFK2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 05:28:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiLFK2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 05:28:35 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA19615FF4
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 02:28:34 -0800 (PST)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NRGnm0qnPzFqv0;
        Tue,  6 Dec 2022 18:27:39 +0800 (CST)
Received: from [10.174.178.41] (10.174.178.41) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 6 Dec 2022 18:28:27 +0800
Message-ID: <e9f5eeae-6785-5fb8-06a4-3d846e8658c9@huawei.com>
Date:   Tue, 6 Dec 2022 18:28:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH] intel/i40e: Fix potential memory leak in
 i40e_init_recovery_mode()
To:     Leon Romanovsky <leon@kernel.org>
CC:     <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <jeffrey.t.kirsher@intel.com>,
        <alice.michael@intel.com>, <piotr.marczak@intel.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>
References: <20221206092613.122952-1-yuancan@huawei.com>
 <Y48TO7s0K9J0kVh0@unreal>
From:   Yuan Can <yuancan@huawei.com>
In-Reply-To: <Y48TO7s0K9J0kVh0@unreal>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.41]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/12/6 18:02, Leon Romanovsky 写道:
> On Tue, Dec 06, 2022 at 09:26:13AM +0000, Yuan Can wrote:
>> If i40e_vsi_mem_alloc() failed in i40e_init_recovery_mode(), the pf will be
>> freed with the pf->vsi leaked.
>> Fix by free pf->vsi in the error handling path.
>>
>> Fixes: 4ff0ee1af016 ("i40e: Introduce recovery mode support")
>> Signed-off-by: Yuan Can <yuancan@huawei.com>
>> ---
>>   drivers/net/ethernet/intel/i40e/i40e_main.c | 1 +
>>   1 file changed, 1 insertion(+)
> The patch title needs to be "[PATCH net]..."
>
>> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
>> index b5dcd15ced36..d23081c224d6 100644
>> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
>> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
>> @@ -15536,6 +15536,7 @@ static int i40e_init_recovery_mode(struct i40e_pf *pf, struct i40e_hw *hw)
>>   	pci_disable_pcie_error_reporting(pf->pdev);
>>   	pci_release_mem_regions(pf->pdev);
>>   	pci_disable_device(pf->pdev);
>> +	kfree(pf->vsi);
>>   	kfree(pf);
>>   
>>   	return err;
> The change is ok, but it is worth to cleanup error flow of i40e_probe and i40e_remove
> as they are not really in the same order.
>
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Thanks for the review, the title problem will be fixed in the next version.

-- 
Best regards,
Yuan Can

