Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C37985B47B6
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 19:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiIJRZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 13:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiIJRZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 13:25:13 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC5732DA9;
        Sat, 10 Sep 2022 10:25:11 -0700 (PDT)
Received: from fraeml702-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MQ04m1MNhz67yRq;
        Sun, 11 Sep 2022 01:20:56 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 fraeml702-chm.china.huawei.com (10.206.15.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.31; Sat, 10 Sep 2022 19:25:09 +0200
Received: from [10.122.132.241] (10.122.132.241) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 10 Sep 2022 18:25:08 +0100
Message-ID: <f92a11d0-0a1c-bfc1-2d99-efb0863cc0dc@huawei.com>
Date:   Sat, 10 Sep 2022 20:25:07 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v7 07/18] landlock: user space API network support
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <anton.sirazetdinov@huawei.com>
References: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
 <20220829170401.834298-8-konstantin.meskhidze@huawei.com>
 <89241aad-8c17-31bf-85bf-e2d0eea6b7ae@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <89241aad-8c17-31bf-85bf-e2d0eea6b7ae@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



9/6/2022 11:08 AM, Mickaël Salaün пишет:
> You can squash this commit into 8/18.

   I got it. Will be squashed.
> 
> You need to increment the Landlock ABI version here.
> 
   Ok. Thanks for the tip.
> 
> On 29/08/2022 19:03, Konstantin Meskhidze wrote:
>> Refactors user space API to support network actions. Adds new network
>> access flags, network rule and network attributes.
>> 
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>> 
>> Changes since v6:
>> * None.
>> 
>> Changes since v5:
>> * Formats code with clang-format-14.
>> 
>> Changes since v4:
>> * None
>> 
>> Changes since v3:
>> * Splits commit.
>> * Refactors User API for network rule type.
>> 
>> ---
>>   include/uapi/linux/landlock.h | 49 +++++++++++++++++++++++++++++++++++
>>   security/landlock/syscalls.c  |  3 ++-
>>   2 files changed, 51 insertions(+), 1 deletion(-)
>> 
>> diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.h
>> index 735b1fe8326e..1ce2be6a78af 100644
>> --- a/include/uapi/linux/landlock.h
>> +++ b/include/uapi/linux/landlock.h
>> @@ -31,6 +31,13 @@ struct landlock_ruleset_attr {
>>   	 * this access right.
>>   	 */
>>   	__u64 handled_access_fs;
>> +
>> +	/**
>> +	 * @handled_access_net: Bitmask of actions (cf. `Network flags`_)
>> +	 * that is handled by this ruleset and should then be forbidden if no
>> +	 * rule explicitly allow them.
>> +	 */
>> +	__u64 handled_access_net;
>>   };
>> 
>>   /*
>> @@ -54,6 +61,11 @@ enum landlock_rule_type {
>>   	 * landlock_path_beneath_attr .
>>   	 */
>>   	LANDLOCK_RULE_PATH_BENEATH = 1,
>> +	/**
>> +	 * @LANDLOCK_RULE_NET_SERVICE: Type of a &struct
>> +	 * landlock_net_service_attr .
>> +	 */
>> +	LANDLOCK_RULE_NET_SERVICE = 2,
>>   };
>> 
>>   /**
>> @@ -79,6 +91,24 @@ struct landlock_path_beneath_attr {
>>   	 */
>>   } __attribute__((packed));
>> 
>> +/**
>> + * struct landlock_net_service_attr - TCP subnet definition
>> + *
>> + * Argument of sys_landlock_add_rule().
>> + */
>> +struct landlock_net_service_attr {
>> +	/**
>> +	 * @allowed_access: Bitmask of allowed access network for services
>> +	 * (cf. `Network flags`_).
>> +	 */
>> +	__u64 allowed_access;
>> +	/**
>> +	 * @port: Network port.
>> +	 */
>> +	__u16 port;
>> +
>> +} __attribute__((packed));
>> +
>>   /**
>>    * DOC: fs_access
>>    *
>> @@ -169,4 +199,23 @@ struct landlock_path_beneath_attr {
>>   #define LANDLOCK_ACCESS_FS_TRUNCATE			(1ULL << 14)
>>   /* clang-format on */
>> 
>> +/**
>> + * DOC: net_access
>> + *
>> + * Network flags
>> + * ~~~~~~~~~~~~~~~~
>> + *
>> + * These flags enable to restrict a sandboxed process to a set of network
>> + * actions.
>> + *
>> + * TCP sockets with allowed actions:
>> + *
>> + * - %LANDLOCK_ACCESS_NET_BIND_TCP: Bind a TCP socket to a local port.
>> + * - %LANDLOCK_ACCESS_NET_CONNECT_TCP: Connect an active TCP socket to
>> + *   a remote port.
>> + */
>> +/* clang-format off */
>> +#define LANDLOCK_ACCESS_NET_BIND_TCP			(1ULL << 0)
>> +#define LANDLOCK_ACCESS_NET_CONNECT_TCP			(1ULL << 1)
>> +/* clang-format on */
>>   #endif /* _UAPI_LINUX_LANDLOCK_H */
>> diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
>> index 28acc4cef3e8..ffd5805eddd9 100644
>> --- a/security/landlock/syscalls.c
>> +++ b/security/landlock/syscalls.c
>> @@ -82,8 +82,9 @@ static void build_check_abi(void)
>>   	 * struct size.
>>   	 */
>>   	ruleset_size = sizeof(ruleset_attr.handled_access_fs);
>> +	ruleset_size += sizeof(ruleset_attr.handled_access_net);
>>   	BUILD_BUG_ON(sizeof(ruleset_attr) != ruleset_size);
>> -	BUILD_BUG_ON(sizeof(ruleset_attr) != 8);
>> +	BUILD_BUG_ON(sizeof(ruleset_attr) != 16);
>> 
>>   	path_beneath_size = sizeof(path_beneath_attr.allowed_access);
>>   	path_beneath_size += sizeof(path_beneath_attr.parent_fd);
>> --
>> 2.25.1
>> 
> .
