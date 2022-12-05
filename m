Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05C7E64218B
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 03:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbiLECbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 21:31:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbiLECbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 21:31:12 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB9DE0DE;
        Sun,  4 Dec 2022 18:31:05 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NQSFN3nt8zRpkb;
        Mon,  5 Dec 2022 10:30:16 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 5 Dec 2022 10:31:03 +0800
Subject: Re: [PATCH net v2] octeontx2-pf: Fix potential memory leak in
 otx2_init_tc()
To:     Leon Romanovsky <leon@kernel.org>
CC:     <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20221202110430.1472991-1-william.xuanziyang@huawei.com>
 <Y4yYzlzPKix6VloH@unreal>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <206c4fdc-bba2-32e3-8e44-82cad81e0436@huawei.com>
Date:   Mon, 5 Dec 2022 10:31:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <Y4yYzlzPKix6VloH@unreal>
Content-Type: text/plain; charset="gbk"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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

> On Fri, Dec 02, 2022 at 07:04:30PM +0800, Ziyang Xuan wrote:
>> In otx2_init_tc(), if rhashtable_init() failed, it does not free
>> tc->tc_entries_bitmap which is allocated in otx2_tc_alloc_ent_bitmap().
>>
>> Fixes: 2e2a8126ffac ("octeontx2-pf: Unify flow management variables")
>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
>> ---
>> v2:
>>   - Remove patch 2 which is not a problem, see the following link:
>>     https://www.spinics.net/lists/netdev/msg864159.html
>> ---
>>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
>> index e64318c110fd..6a01ab1a6e6f 100644
>> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
>> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
>> @@ -1134,7 +1134,12 @@ int otx2_init_tc(struct otx2_nic *nic)
>>  		return err;
>>  
>>  	tc->flow_ht_params = tc_flow_ht_params;
>> -	return rhashtable_init(&tc->flow_table, &tc->flow_ht_params);
>> +	err = rhashtable_init(&tc->flow_table, &tc->flow_ht_params);
>> +	if (err) {
>> +		kfree(tc->tc_entries_bitmap);
>> +		tc->tc_entries_bitmap = NULL;
> 
> Why do you set NULL here? All callers of otx2_init_tc() unwind error
> properly.

See the implementation of otx2_tc_alloc_ent_bitmap() as following:

int otx2_tc_alloc_ent_bitmap(struct otx2_nic *nic)
{
	struct otx2_tc_info *tc = &nic->tc_info;

	if (!nic->flow_cfg->max_flows)
		return 0;

	/* Max flows changed, free the existing bitmap */
	kfree(tc->tc_entries_bitmap);
	
	...
}

Hello Leon Romanovsky,

It will kfree(tc->tc_entries_bitmap) firstly, and otx2_tc_alloc_ent_bitmap()
is called by otx2_dl_mcam_count_set() and otx2_init_tc(). I am not sure their
sequence and whether it will cause double free for tc->tc_entries_bitmap. So
setting tc->tc_entries_bitmap to NULL is safe, I think.

Thank you!

> 
>> +	}
>> +	return err;
>>  }
>>  EXPORT_SYMBOL(otx2_init_tc);
>>  
>> -- 
>> 2.25.1
>>
> .
> 
