Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8654D63FDC0
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 02:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbiLBBkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 20:40:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbiLBBjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 20:39:49 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B77AA4308;
        Thu,  1 Dec 2022 17:39:48 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NNbBY1b9zzJp4h;
        Fri,  2 Dec 2022 09:36:21 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Dec 2022 09:39:45 +0800
Subject: Re: [PATCH net 2/2] octeontx2-pf: Fix a potential double free in
 otx2_sq_free_sqbs()
To:     Paolo Abeni <pabeni@redhat.com>, <sgoutham@marvell.com>,
        <gakula@marvell.com>, <sbhatta@marvell.com>, <hkelam@marvell.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>
References: <cover.1669361183.git.william.xuanziyang@huawei.com>
 <047b210eb3b3a2e26703d8b0570a0a017789c169.1669361183.git.william.xuanziyang@huawei.com>
 <a3c723c5a27a75924f9d2f4ecabe26c04add08f3.camel@redhat.com>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <1a39ec51-0879-a17f-7f4c-4ca0edbeb2a7@huawei.com>
Date:   Fri, 2 Dec 2022 09:39:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <a3c723c5a27a75924f9d2f4ecabe26c04add08f3.camel@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hello,
> 
> On Fri, 2022-11-25 at 15:45 +0800, Ziyang Xuan wrote:
>> otx2_sq_free_sqbs() will be called twice when goto "err_free_nix_queues"
>> label in otx2_init_hw_resources(). The first calling is within
>> otx2_free_sq_res() at "err_free_nix_queues" label, and the second calling
>> is at later "err_free_sq_ptrs" label.
>>
>> In otx2_sq_free_sqbs(), If sq->sqb_ptrs[i] is not 0, the memory page it
>> points to will be freed, and sq->sqb_ptrs[i] do not be assigned 0 after
>> memory page be freed. If otx2_sq_free_sqbs() is called twice, the memory
>> page pointed by sq->sqb_ptrs[i] will be freeed twice. To fix the bug,
>> assign 0 to sq->sqb_ptrs[i] after memory page be freed.
>>
>> Fixes: caa2da34fd25 ("octeontx2-pf: Initialize and config queues")
>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
>> ---
>>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
>> index 9e10e7471b88..5a25fe51d102 100644
>> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
>> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
>> @@ -1146,6 +1146,7 @@ void otx2_sq_free_sqbs(struct otx2_nic *pfvf)
>>  					     DMA_FROM_DEVICE,
>>  					     DMA_ATTR_SKIP_CPU_SYNC);
>>  			put_page(virt_to_page(phys_to_virt(pa)));
>> +			sq->sqb_ptrs[sqb] = 0;
> 
> The above looks not needed...
>>  		}
>>  		sq->sqb_count = 0;
> 
> ... as this will prevent the next invocation of otx2_sq_free_sqbs()
> from traversing and freeing any sq->sqb_ptrs[] element.

Yes, you are right. I did pay much attention to sq->sqb_ptrs[],
and omitted the for loop condition.

Thank you!

> 
> Cheers,
> 
> Paolo
>>  	}
> 
> 
> .
> 
