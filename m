Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B141D647B17
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 02:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiLIBBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 20:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiLIBBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 20:01:31 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77BB7A504A;
        Thu,  8 Dec 2022 17:01:25 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NSt05678NzqSt2;
        Fri,  9 Dec 2022 08:57:09 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 9 Dec 2022 09:01:21 +0800
Message-ID: <2faab482-33cd-fb07-f0cf-472566784825@huawei.com>
Date:   Fri, 9 Dec 2022 09:01:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH] ipw2200: fix memory leak in ipw_wdev_init()
To:     Jiri Pirko <jiri@resnulli.us>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <stas.yakovlev@gmail.com>, <kvalo@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linville@tuxdriver.com>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
References: <20221208122630.2850534-1-shaozhengchao@huawei.com>
 <Y5HgAAVpYB9WQbz6@nanopsycho>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <Y5HgAAVpYB9WQbz6@nanopsycho>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
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



On 2022/12/8 21:00, Jiri Pirko wrote:
> Thu, Dec 08, 2022 at 01:26:30PM CET, shaozhengchao@huawei.com wrote:
>> In the error path of ipw_wdev_init(), exception value is returned, and
>> the memory applied for in the function is not released. Also the memory
>> is not released in ipw_pci_probe(). As a result, memory leakage occurs.
>> So memory release needs to be added to the error path of ipw_wdev_init().
>>
>> Fixes: a3caa99e6c68 ("libipw: initiate cfg80211 API conversion (v2)")
>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
>> ---
>> drivers/net/wireless/intel/ipw2x00/ipw2200.c | 8 +++++++-
>> 1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
>> index 5b483de18c81..cead5c7fc91e 100644
>> --- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
>> +++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
>> @@ -11397,9 +11397,15 @@ static int ipw_wdev_init(struct net_device *dev)
>> 	set_wiphy_dev(wdev->wiphy, &priv->pci_dev->dev);
>>
>> 	/* With that information in place, we can now register the wiphy... */
>> -	if (wiphy_register(wdev->wiphy))
>> +	if (wiphy_register(wdev->wiphy)) {
> 
> While you are at it, how about to take the actual return value of
> wiphy_register() into account?
> 
> 
Hi Jiri:
	Thank you for your suggestion. I will change it in V2.

Zhengchao Shao
>> 		rc = -EIO;
>> +		goto out;
>> +	}
>> +
>> +	return 0;
>> out:
>> +	kfree(priv->ieee->a_band.channels);
>> +	kfree(priv->ieee->bg_band.channels);
>> 	return rc;
>> }
>>
>> -- 
>> 2.34.1
>>
