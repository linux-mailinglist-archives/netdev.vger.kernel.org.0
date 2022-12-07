Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87CAD6455DB
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 09:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiLGI5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 03:57:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiLGI5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 03:57:42 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5D9FD32
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 00:57:31 -0800 (PST)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NRrgB42CzzJp80;
        Wed,  7 Dec 2022 16:53:58 +0800 (CST)
Received: from [10.174.178.41] (10.174.178.41) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 7 Dec 2022 16:56:26 +0800
Message-ID: <14a8bcdc-6ef6-f29c-8dab-83f48b93ed9d@huawei.com>
Date:   Wed, 7 Dec 2022 16:56:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH net] drivers: net: qlcnic: Fix potential memory leak in
 qlcnic_sriov_init()
To:     Leon Romanovsky <leon@kernel.org>
CC:     <shshaikh@marvell.com>, <manishc@marvell.com>,
        <GR-Linux-NIC-Dev@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <sucheta.chakraborty@qlogic.com>, <rajesh.borundia@qlogic.com>,
        <netdev@vger.kernel.org>
References: <20221206103031.20609-1-yuancan@huawei.com>
 <Y5BHPCE5rfQ0cmne@unreal>
From:   Yuan Can <yuancan@huawei.com>
In-Reply-To: <Y5BHPCE5rfQ0cmne@unreal>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.41]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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


在 2022/12/7 15:56, Leon Romanovsky 写道:
> On Tue, Dec 06, 2022 at 10:30:31AM +0000, Yuan Can wrote:
>> If vp alloc failed in qlcnic_sriov_init(), all previously allocated vp
>> needs to be freed.
>>
>> Fixes: f197a7aa6288 ("qlcnic: VF-PF communication channel implementation")
>> Signed-off-by: Yuan Can <yuancan@huawei.com>
>> ---
>>   drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
>> index 9282321c2e7f..d0470c62e1b2 100644
>> --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
>> +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
>> @@ -222,6 +222,8 @@ int qlcnic_sriov_init(struct qlcnic_adapter *adapter, int num_vfs)
>>   
>>   qlcnic_destroy_async_wq:
>>   	destroy_workqueue(bc->bc_async_wq);
>> +	while (i--)
>> +		kfree(sriov->vf_info[i].vp);
> These lines should be before destroy_workqueue(bc->bc_async_wq);
Ok, thanks for the review!

-- 
Best regards,
Yuan Can

