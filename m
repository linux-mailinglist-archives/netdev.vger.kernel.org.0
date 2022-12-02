Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6922F63FE45
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 03:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbiLBCsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 21:48:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbiLBCsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 21:48:16 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE1089AE7;
        Thu,  1 Dec 2022 18:48:15 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NNcmf6VVtzRpk2;
        Fri,  2 Dec 2022 10:47:30 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Dec 2022 10:48:13 +0800
Message-ID: <84669e9c-81f7-3a56-ea57-39df3e131b3f@huawei.com>
Date:   Fri, 2 Dec 2022 10:48:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH] wifi: mac80211: fix memory leak in
 ieee80211_register_hw()
To:     Johannes Berg <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <sara.sharon@intel.com>, <luciano.coelho@intel.com>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
References: <20221122091142.261354-1-shaozhengchao@huawei.com>
 <4f37f422a0bcd8d1d2dd1bb992be30a16d335a3f.camel@sipsolutions.net>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <4f37f422a0bcd8d1d2dd1bb992be30a16d335a3f.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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



On 2022/12/1 20:52, Johannes Berg wrote:
> On Tue, 2022-11-22 at 17:11 +0800, Zhengchao Shao wrote:
>>
>> +++ b/net/mac80211/iface.c
>> @@ -2326,8 +2326,6 @@ void ieee80211_remove_interfaces(struct ieee80211_local *local)
>>   	WARN(local->open_count, "%s: open count remains %d\n",
>>   	     wiphy_name(local->hw.wiphy), local->open_count);
>>   
>> -	ieee80211_txq_teardown_flows(local);
> 
> 
> This is after shutting down interfaces.
> 
>> @@ -1469,6 +1470,7 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
>>   	 * because the driver cannot be handing us frames any
>>   	 * more and the tasklet is killed.
>>   	 */
>> +	ieee80211_txq_teardown_flows(local);
>>   	ieee80211_remove_interfaces(local);
>>
> 
> But now it's before. Why is that safe?
> 
> johannes
Hi johannes:
	Thank you for your review. This change may be unsafe.
Driver do clear its reource must be after hardware stop. Remove
it before shutdown interface is unsafe. I will change in V2.

Zhengchao Shao
