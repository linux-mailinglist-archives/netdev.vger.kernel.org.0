Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8307F64571B
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 11:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiLGKHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 05:07:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiLGKHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 05:07:19 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91ACD63D8;
        Wed,  7 Dec 2022 02:07:18 -0800 (PST)
Received: from dggpeml500006.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NRtGq1JcFzmWFQ;
        Wed,  7 Dec 2022 18:06:27 +0800 (CST)
Received: from [10.174.178.240] (10.174.178.240) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 7 Dec 2022 18:07:16 +0800
Subject: Re: [PATCH net] net: stmmac: selftests: fix potential memleak in
 stmmac_test_arpoffload()
To:     Leon Romanovsky <leon@kernel.org>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1670401920-7574-1-git-send-email-zhangchangzhong@huawei.com>
 <Y5BY+ZpW20XpkVZw@unreal>
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
Message-ID: <100d8307-4ae6-d370-e836-6c76aff4d920@huawei.com>
Date:   Wed, 7 Dec 2022 18:07:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <Y5BY+ZpW20XpkVZw@unreal>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.240]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/12/7 17:12, Leon Romanovsky wrote:
> On Wed, Dec 07, 2022 at 04:31:59PM +0800, Zhang Changzhong wrote:
>> The skb allocated by stmmac_test_get_arp_skb() hasn't been released in
>> some error handling case, which will lead to a memory leak. Fix this up
>> by adding kfree_skb() to release skb.
>>
>> Compile tested only.
>>
>> Fixes: 5e3fb0a6e2b3 ("net: stmmac: selftests: Implement the ARP Offload test")
>> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
>> ---
>>  drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c | 8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
>> index 49af7e7..687f43c 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
>> @@ -1654,12 +1654,16 @@ static int stmmac_test_arpoffload(struct stmmac_priv *priv)
>>  	}
>>  
>>  	ret = stmmac_set_arp_offload(priv, priv->hw, true, ip_addr);
>> -	if (ret)
>> +	if (ret) {
>> +		kfree_skb(skb);
>>  		goto cleanup;
>> +	}
>>  
>>  	ret = dev_set_promiscuity(priv->dev, 1);
>> -	if (ret)
>> +	if (ret) {
>> +		kfree_skb(skb);
>>  		goto cleanup;
>> +	}
>>  
>>  	ret = dev_direct_xmit(skb, 0);
>>  	if (ret)
> 
> You should release skb here too. So the better patch will be to write
> something like that:
> 

Hi Leon,

Thanks for your review, but I don't think we need release skb here,
because dev_direct_xmit() is responsible for freeing it.

Regards,
Changzhong

> cleanup:
>   stmmac_set_arp_offload(priv, priv->hw, false, 0x0);
>   if (ret)
>   	kfree_skb(skb);
>> Thanks
> 
>> -- 
>> 2.9.5
>>
> .
> 
