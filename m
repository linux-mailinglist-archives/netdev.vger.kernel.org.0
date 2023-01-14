Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2465866A8C4
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 03:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbjANCxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 21:53:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbjANCxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 21:53:39 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6E765ACE;
        Fri, 13 Jan 2023 18:53:38 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Nv2qv4QkMznVKG;
        Sat, 14 Jan 2023 10:51:55 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Sat, 14 Jan 2023 10:53:34 +0800
Message-ID: <f420615f-2b3c-90c2-4e14-f06ed4cac3eb@huawei.com>
Date:   Sat, 14 Jan 2023 10:53:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH] wifi: mac80211: fix memory leak in ieee80211_if_add()
To:     Eric Dumazet <eric.dumazet@gmail.com>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
References: <20221117064500.319983-1-shaozhengchao@huawei.com>
 <b5ad26c3-fa10-b056-d79d-8bebb8795a90@gmail.com>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <b5ad26c3-fa10-b056-d79d-8bebb8795a90@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2023/1/13 16:15, Eric Dumazet wrote:
> 
> On 11/17/22 07:45, Zhengchao Shao wrote:
>> When register_netdevice() failed in ieee80211_if_add(), ndev->tstats
>> isn't released. Fix it.
>>
>> Fixes: 5a490510ba5f ("mac80211: use per-CPU TX/RX statistics")
>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
>> ---
>>   net/mac80211/iface.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
>> index dd9ac1f7d2ea..46f08ec5ed76 100644
>> --- a/net/mac80211/iface.c
>> +++ b/net/mac80211/iface.c
>> @@ -2258,6 +2258,7 @@ int ieee80211_if_add(struct ieee80211_local 
>> *local, const char *name,
>>           ret = cfg80211_register_netdevice(ndev);
>>           if (ret) {
>> +            ieee80211_if_free(ndev);
>>               free_netdev(ndev);
>>               return ret;
>>           }
> 
> 
> Note: I will send a revert of this buggy patch, this was adding a double 
> free.
> 
> 
Hi Eric：
	Thank you very much for pointing out my problem. I'll be more
rigorous in the future.

Zhengchao Shao
> 
