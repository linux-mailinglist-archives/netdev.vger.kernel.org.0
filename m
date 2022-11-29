Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A458A63BC9C
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 10:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiK2JK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 04:10:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiK2JKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 04:10:54 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8662497B
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 01:10:52 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NLxPX6XWdzHvQq;
        Tue, 29 Nov 2022 17:10:08 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 29 Nov 2022 17:10:50 +0800
Message-ID: <31833986-aec9-2cb7-ed1f-60465126d26c@huawei.com>
Date:   Tue, 29 Nov 2022 17:10:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net] sfc: fix error process in
 efx_ef100_pci_sriov_enable()
To:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <pieter.jansen-van-vuuren@amd.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>
References: <20221125071958.276454-1-shaozhengchao@huawei.com>
 <3adfad23-b2dd-3bd9-40da-d4dfaa78b435@gmail.com>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <3adfad23-b2dd-3bd9-40da-d4dfaa78b435@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/11/29 16:19, Edward Cree wrote:
> On 25/11/2022 07:19, Zhengchao Shao wrote:
>> There are two issues in efx_ef100_pci_sriov_enable():
>> 1. When it doesn't have MAE Privilege, it doesn't disable pci sriov.
>> 2. When creating VF successfully, it should return vf nums instead of 0.
> 
> A single patch should do one thing.  If these two issues were
>   valid, they ought to be fixed separately by two commits.
> 
>> Compiled test only.
>>
>> Fixes: 08135eecd07f ("sfc: add skeleton ef100 VF representors")
>> Fixes: 78a9b3c47bef ("sfc: add EF100 VF support via a write to sriov_numvfs")
>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
>> ---
>>   drivers/net/ethernet/sfc/ef100_sriov.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/sfc/ef100_sriov.c b/drivers/net/ethernet/sfc/ef100_sriov.c
>> index 94bdbfcb47e8..adf7fb09940e 100644
>> --- a/drivers/net/ethernet/sfc/ef100_sriov.c
>> +++ b/drivers/net/ethernet/sfc/ef100_sriov.c
>> @@ -25,15 +25,17 @@ static int efx_ef100_pci_sriov_enable(struct efx_nic *efx, int num_vfs)
>>   	if (rc)
>>   		goto fail1;
>>   
>> -	if (!nic_data->grp_mae)
>> +	if (!nic_data->grp_mae) {
>> +		pci_disable_sriov(dev);
>>   		return 0;
>> +	}
> 
> NACK to this part; if we don't have MAE privilege, that means
>   someone else (e.g. the embedded SoC) is in charge of the MAE
>   and is responsible for configuring switching behaviour for any
>   VFs we create.
> Thus, the existing behaviour — create the VFs without creating
>   any corresponding representors — is intended.
> 
>>   
>>   	for (i = 0; i < num_vfs; i++) {
>>   		rc = efx_ef100_vfrep_create(efx, i);
>>   		if (rc)
>>   			goto fail2;
>>   	}
>> -	return 0;
>> +	return num_vfs;
> 
> NACK to this too: this is not returned directly to the PCI
>   core but to ef100_pci_sriov_configure(), which already does
>   the translation from 0 (success) to num_vfs.  So changing it
>   here is unnecessary.
> 
> -ed
> 
Thank you for your review. My misunderstood. You are right.
>>   
>>   fail2:
>>   	list_for_each_entry_safe(efv, next, &efx->vf_reps, list)
>>
