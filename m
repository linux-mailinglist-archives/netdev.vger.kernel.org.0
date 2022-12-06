Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0441B644235
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 12:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234866AbiLFLeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 06:34:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiLFLeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 06:34:19 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E89262A
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 03:34:17 -0800 (PST)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NRJBZ2ZcfzJp2g;
        Tue,  6 Dec 2022 19:30:46 +0800 (CST)
Received: from [10.174.178.41] (10.174.178.41) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 6 Dec 2022 19:34:15 +0800
Message-ID: <8a914480-f392-1112-e672-457e8b61d6e5@huawei.com>
Date:   Tue, 6 Dec 2022 19:34:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH] intel/i40e: Fix potential memory leak in
 i40e_init_recovery_mode()
To:     Jiri Pirko <jiri@resnulli.us>
CC:     <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <jeffrey.t.kirsher@intel.com>,
        <alice.michael@intel.com>, <piotr.marczak@intel.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>
References: <20221206092613.122952-1-yuancan@huawei.com>
 <Y48ZXIjtsXu/FZQR@nanopsycho>
From:   Yuan Can <yuancan@huawei.com>
In-Reply-To: <Y48ZXIjtsXu/FZQR@nanopsycho>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.41]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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

在 2022/12/6 18:28, Jiri Pirko 写道:
> Tue, Dec 06, 2022 at 10:26:13AM CET, yuancan@huawei.com wrote:
>> If i40e_vsi_mem_alloc() failed in i40e_init_recovery_mode(), the pf will be
>> freed with the pf->vsi leaked.
>> Fix by free pf->vsi in the error handling path.
>>
>> Fixes: 4ff0ee1af016 ("i40e: Introduce recovery mode support")
>> Signed-off-by: Yuan Can <yuancan@huawei.com>
>> ---
>> drivers/net/ethernet/intel/i40e/i40e_main.c | 1 +
>> 1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
>> index b5dcd15ced36..d23081c224d6 100644
>> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
>> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
>> @@ -15536,6 +15536,7 @@ static int i40e_init_recovery_mode(struct i40e_pf *pf, struct i40e_hw *hw)
>> 	pci_disable_pcie_error_reporting(pf->pdev);
>> 	pci_release_mem_regions(pf->pdev);
>> 	pci_disable_device(pf->pdev);
>> +	kfree(pf->vsi);
> This is not the only thing which is wrong on this error path. Just
> quickly looking at the code:
> - kfree(pf->qp_pile); should be called here as well
> - if i40e_setup_misc_vector_for_recovery_mode() fails,
>    unregister_netdev() needs to be called.
> - if register_netdev() fails, netdev needs to be freed at least.
> Basically the whole error path is completely wrong.
> I suggest to:
>
> 1) rely on error path of i40e_probe() when call of
>     i40e_init_recovery_mode() fails and don't do the cleanup of
>     previously inited things in i40e_probe() locally.
> 2) implement a proper local error path in i40e_init_recovery_mode()
Thanks for this, I will try to make everything correct in the next version.
-- 

Best regards,
Yuan Can

