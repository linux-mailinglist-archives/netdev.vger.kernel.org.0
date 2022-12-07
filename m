Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54CAA6450A6
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 01:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiLGAxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 19:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiLGAxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 19:53:21 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B47B49E
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 16:53:20 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NRdzf4fftzJqHY;
        Wed,  7 Dec 2022 08:52:30 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 7 Dec 2022 08:53:18 +0800
Message-ID: <ea4b318c-4c35-9074-589e-2336b9997384@huawei.com>
Date:   Wed, 7 Dec 2022 08:53:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net v2] net: thunderbolt: fix memory leak in tbnet_open()
To:     Jiri Pirko <jiri@resnulli.us>
CC:     <netdev@vger.kernel.org>, <michael.jamet@intel.com>,
        <mika.westerberg@linux.intel.com>, <YehezkelShB@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>
References: <20221206010646.3552313-1-shaozhengchao@huawei.com>
 <Y48Nf4OkBbaVgw4C@nanopsycho>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <Y48Nf4OkBbaVgw4C@nanopsycho>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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



On 2022/12/6 17:38, Jiri Pirko wrote:
> Tue, Dec 06, 2022 at 02:06:46AM CET, shaozhengchao@huawei.com wrote:
>> When tb_ring_alloc_rx() failed in tbnet_open(), it doesn't free ida.
> 
> You should be imperative to the codebase in your patch descriptions.
> 
Thank you for your advice. I will describe more detail later.

> The code fix looks okay.
> 
>>
>> Fixes: 180b0689425c ("thunderbolt: Allow multiple DMA tunnels over a single XDomain connection")
>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
>> ---
>> v2: move release ida before free tx_ring
>> ---
>> drivers/net/thunderbolt.c | 1 +
>> 1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
>> index a52ee2bf5575..6312f67f260e 100644
>> --- a/drivers/net/thunderbolt.c
>> +++ b/drivers/net/thunderbolt.c
>> @@ -914,6 +914,7 @@ static int tbnet_open(struct net_device *dev)
>> 				eof_mask, tbnet_start_poll, net);
>> 	if (!ring) {
>> 		netdev_err(dev, "failed to allocate Rx ring\n");
>> +		tb_xdomain_release_out_hopid(xd, hopid);
>> 		tb_ring_free(net->tx_ring.ring);
>> 		net->tx_ring.ring = NULL;
>> 		return -ENOMEM;
>> -- 
>> 2.34.1
>>
