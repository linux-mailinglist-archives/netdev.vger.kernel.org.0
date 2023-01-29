Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4744D67FD20
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 07:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbjA2G2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 01:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjA2G2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 01:28:44 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36DC71F48D;
        Sat, 28 Jan 2023 22:28:43 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4P4LvH2zY6zJrT1;
        Sun, 29 Jan 2023 14:27:07 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Sun, 29 Jan 2023 14:28:39 +0800
Message-ID: <bcb33716-5c14-38d4-8721-1585e9fb8461@huawei.com>
Date:   Sun, 29 Jan 2023 14:28:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH v2] wifi: mac80211: fix memory leak in
 ieee80211_register_hw()
To:     Johannes Berg <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <sara.sharon@intel.com>, <luciano.coelho@intel.com>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
References: <20221202043838.2324539-1-shaozhengchao@huawei.com>
 <e33356c3b654db03030d371e38f02c6019e9c1a7.camel@sipsolutions.net>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <e33356c3b654db03030d371e38f02c6019e9c1a7.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2023/1/18 17:45, Johannes Berg wrote:
> On Fri, 2022-12-02 at 12:38 +0800, Zhengchao Shao wrote:
>>
>> --- a/net/mac80211/main.c
>> +++ b/net/mac80211/main.c
>> @@ -1326,6 +1326,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>>   					      hw->rate_control_algorithm);
>>   	rtnl_unlock();
>>   	if (result < 0) {
>> +		ieee80211_txq_teardown_flows(local);
>>   		wiphy_debug(local->hw.wiphy,
>>   			    "Failed to initialize rate control algorithm\n");
>>   		goto fail_rate;
>> @@ -1364,6 +1365,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>>   
>>   		sband = kmemdup(sband, sizeof(*sband), GFP_KERNEL);
>>   		if (!sband) {
>> +			ieee80211_txq_teardown_flows(local);
>>   			result = -ENOMEM;
>>   			goto fail_rate;
>>   		}
> 
> I don't understand - we have a fail_rate label here where we free
> everything.
> 
> What if we get to fail_wiphy_register, don't we leak it in the same way?
> 
> johannes

Hi johannes:
	Thank you for your review. Sorry it took so long to reply. The
fail_rate label does not release the resources applied for in the
ieee80211_txq_setup_flows().  Or maybe I missed something?
	The fail_wiphy_register label will call
ieee80211_remove_interfaces()->ieee80211_txq_teardown_flows() to release
resources. So it is OK.

Zhengchao Shao
