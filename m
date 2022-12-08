Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E33A46466AB
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 02:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiLHBvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 20:51:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiLHBvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 20:51:48 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0C68C6A6
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 17:51:47 -0800 (PST)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NSH8l18d9zqSPQ;
        Thu,  8 Dec 2022 09:47:35 +0800 (CST)
Received: from [10.174.178.41] (10.174.178.41) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 8 Dec 2022 09:51:45 +0800
Message-ID: <0d769f50-bbd1-4291-c3c0-29527b40fb98@huawei.com>
Date:   Thu, 8 Dec 2022 09:51:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH] dpaa2-switch: Fix memory leak in
 dpaa2_switch_acl_entry_add() and dpaa2_switch_acl_entry_remove()
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <ioana.ciornei@nxp.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>
References: <20221205061515.115012-1-yuancan@huawei.com>
 <20221207115537.zf2ikns77bxyt74m@skbuf>
From:   Yuan Can <yuancan@huawei.com>
In-Reply-To: <20221207115537.zf2ikns77bxyt74m@skbuf>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.41]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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


在 2022/12/7 19:55, Vladimir Oltean 写道:
> Hi Yuan,
>
> On Mon, Dec 05, 2022 at 06:15:15AM +0000, Yuan Can wrote:
>> The cmd_buff needs to be freed when error happened in
>> dpaa2_switch_acl_entry_add() and dpaa2_switch_acl_entry_remove().
>>
>> Fixes: 1110318d83e8 ("dpaa2-switch: add tc flower hardware offload on ingress traffic")
>> Signed-off-by: Yuan Can <yuancan@huawei.com>
>> ---
>>   drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
>> index cacd454ac696..c39b866e2582 100644
>> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
>> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
>> @@ -132,6 +132,7 @@ int dpaa2_switch_acl_entry_add(struct dpaa2_switch_filter_block *filter_block,
>>   						 DMA_TO_DEVICE);
>>   	if (unlikely(dma_mapping_error(dev, acl_entry_cfg->key_iova))) {
>>   		dev_err(dev, "DMA mapping failed\n");
>> +		kfree(cmd_buff);
>>   		return -EFAULT;
>>   	}
>>   
>> @@ -142,6 +143,7 @@ int dpaa2_switch_acl_entry_add(struct dpaa2_switch_filter_block *filter_block,
>>   			 DMA_TO_DEVICE);
>>   	if (err) {
>>   		dev_err(dev, "dpsw_acl_add_entry() failed %d\n", err);
>> +		kfree(cmd_buff);
> To reduce the number of kfree() calls, this last one can be put right
> before checking for error, and we could remove the kfree(cmd_buff) call at
> the very end. I mean that was already the intention, if you look at the
> dma_unmap_single() call compared to the error checking. Like this:
>
> 	err = dpsw_acl_add_entry(...);
>
> 	dma_unmap_single(dev, acl_entry_cfg->key_iova, sizeof(cmd_buff),
> 			 DMA_TO_DEVICE);
> 	kfree(cmd_buff);
>
> 	if (err) {
> 		dev_err(dev, "dpsw_acl_add_entry() failed %d\n", err);
> 		return err;
> 	}
>
> 	return 0;
> }
Nice! Thanks for the suggestion, as the patch has been merged, let me 
send another patch to do this job.

-- 
Best regards,
Yuan Can

