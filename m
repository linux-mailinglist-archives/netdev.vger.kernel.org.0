Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5DE94AEEB6
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 10:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbiBIJz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 04:55:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbiBIJz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 04:55:56 -0500
Received: from out199-16.us.a.mail.aliyun.com (out199-16.us.a.mail.aliyun.com [47.90.199.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0DAE046F1A;
        Wed,  9 Feb 2022 01:55:48 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V4-nNmD_1644400399;
Received: from 30.225.28.54(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V4-nNmD_1644400399)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Feb 2022 17:53:19 +0800
Message-ID: <df2fa023-833d-e4a7-23b4-4f6427223ff5@linux.alibaba.com>
Date:   Wed, 9 Feb 2022 17:53:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net-next v5 5/5] net/smc: Add global configure for auto
 fallback by netlink
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <cover.1644323503.git.alibuda@linux.alibaba.com>
 <f54ee9f30898b998edf8f07dabccc84efaa2ab8b.1644323503.git.alibuda@linux.alibaba.com>
 <YgOGg9Ud5N7LOOV6@TonyMac-Alibaba>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <YgOGg9Ud5N7LOOV6@TonyMac-Alibaba>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/2/9 下午5:16, Tony Lu 写道:
> On Tue, Feb 08, 2022 at 08:53:13PM +0800, D. Wythe wrote:
>> From: "D. Wythe" <alibuda@linux.alibaba.com>
>>
>> @@ -248,6 +248,8 @@ int smc_nl_get_sys_info(struct sk_buff *skb, struct netlink_callback *cb)
>>   		goto errattr;
>>   	if (nla_put_u8(skb, SMC_NLA_SYS_IS_SMCR_V2, true))
>>   		goto errattr;
>> +	if (nla_put_u8(skb, SMC_NLA_SYS_AUTO_FALLBACK, smc_auto_fallback))
> 
> READ_ONCE(smc_auto_fallback) ?


No READ_ONCE() will cause ?


>> +		goto errattr;
>>   	smc_clc_get_hostname(&host);
>>   	if (host) {
>>   		memcpy(hostname, host, SMC_MAX_HOSTNAME_LEN);
>> diff --git a/net/smc/smc_netlink.c b/net/smc/smc_netlink.c
>> index f13ab06..a7de517 100644
>> --- a/net/smc/smc_netlink.c
>> +++ b/net/smc/smc_netlink.c
>> @@ -111,6 +111,16 @@
>>   		.flags = GENL_ADMIN_PERM,
>>   		.doit = smc_nl_disable_seid,
>>   	},
>> +	{
>> +		.cmd = SMC_NETLINK_ENABLE_AUTO_FALLBACK,
>> +		.flags = GENL_ADMIN_PERM,
>> +		.doit = smc_enable_auto_fallback,
>> +	},
>> +	{
>> +		.cmd = SMC_NETLINK_DISABLE_AUTO_FALLBACK,
>> +		.flags = GENL_ADMIN_PERM,
>> +		.doit = smc_disable_auto_fallback,
>> +	},
>>   };
> 
> Consider adding the separated cmd to query the status of this config,
> just as SEID does?
> 
> It is common to check this value after user-space setted. Combined with
> sys_info maybe a little heavy in this scene.


Add a independent dumpit is quite okay, but is there have really 
scenarios that access this value frequently? With more and more such 
switches in the future, is is necessary for us to repeat on each switch 
? I do have a plan to put them unified within a NLA attributes, but I 
don't have much time yet.

