Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C21B5B48E9
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 22:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiIJUvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 16:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiIJUvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 16:51:51 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA35402F1;
        Sat, 10 Sep 2022 13:51:50 -0700 (PDT)
Received: from fraeml701-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MQ4gB0Vr3z67ms2;
        Sun, 11 Sep 2022 04:47:34 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 fraeml701-chm.china.huawei.com (10.206.15.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.31; Sat, 10 Sep 2022 22:51:47 +0200
Received: from [10.122.132.241] (10.122.132.241) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 10 Sep 2022 21:51:47 +0100
Message-ID: <47ddb2ea-3bc7-533a-9b0d-2b2d3950644c@huawei.com>
Date:   Sat, 10 Sep 2022 23:51:46 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v7 16/18] seltests/landlock: add invalid input data test
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <anton.sirazetdinov@huawei.com>
References: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
 <20220829170401.834298-17-konstantin.meskhidze@huawei.com>
 <d91e3fcc-2320-e98c-7d54-458b749c87a8@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <d91e3fcc-2320-e98c-7d54-458b749c87a8@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhrpeml100005.china.huawei.com (7.191.160.25) To
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



9/6/2022 11:09 AM, Mickaël Salaün пишет:
> 
> On 29/08/2022 19:03, Konstantin Meskhidze wrote:
>> This patch adds rules with invalid user space supplied data:
>>      - out of range ruleset attribute;
>>      - unhandled allowed access;
>>      - zero port value;
>>      - zero access value;
>> 
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>> 
>> Changes since v6:
>> * Adds invalid ruleset attribute test.
>> 
>> Changes since v5:
>> * Formats code with clang-format-14.
>> 
>> Changes since v4:
>> * Refactors code with self->port variable.
>> 
>> Changes since v3:
>> * Adds inval test.
>> 
>> ---
>>   tools/testing/selftests/landlock/net_test.c | 66 ++++++++++++++++++++-
>>   1 file changed, 65 insertions(+), 1 deletion(-)
>> 
>> diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
>> index a93224d1521b..067ba45f58a5 100644
>> --- a/tools/testing/selftests/landlock/net_test.c
>> +++ b/tools/testing/selftests/landlock/net_test.c
>> @@ -26,9 +26,12 @@
>> 
>>   #define IP_ADDRESS "127.0.0.1"
>> 
>> -/* Number pending connections queue to be hold */
>> +/* Number pending connections queue to be hold. */
> 
> Patch of a previous patch?
> 
> 
>>   #define BACKLOG 10
>> 
>> +/* Invalid attribute, out of landlock network access range. */
>> +#define LANDLOCK_INVAL_ATTR 7
>> +
>>   FIXTURE(socket)
>>   {
>>   	uint port[MAX_SOCKET_NUM];
>> @@ -719,4 +722,65 @@ TEST_F(socket, ruleset_expanding)
>>   	/* Closes socket 1. */
>>   	ASSERT_EQ(0, close(sockfd_1));
>>   }
>> +
>> +TEST_F(socket, inval)
>> +{
>> +	struct landlock_ruleset_attr ruleset_attr = {
>> +		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP
>> +	};
>> +	struct landlock_ruleset_attr ruleset_attr_inval = {
>> +		.handled_access_net = LANDLOCK_INVAL_ATTR
> 
> Please add a test similar to TEST_F_FORK(layout1,
> file_and_dir_access_rights) instead of explicitly defining and only
> testing LANDLOCK_INVAL_ATTR.
> 
   Do you want fs test to be in this commit or maybe its better to add 
it into "[PATCH v7 01/18] landlock: rename access mask" one.
> 
>> +	};
>> +	struct landlock_net_service_attr net_service_1 = {
>> +		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
>> +				  LANDLOCK_ACCESS_NET_CONNECT_TCP,
>> +		.port = self->port[0],
>> +	};
>> +	struct landlock_net_service_attr net_service_2 = {
>> +		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
>> +		.port = 0,
>> +	};
>> +	struct landlock_net_service_attr net_service_3 = {
>> +		.allowed_access = 0,
>> +		.port = self->port[1],
>> +	};
>> +	struct landlock_net_service_attr net_service_4 = {
>> +		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
>> +		.port = self->port[2],
>> +	};
>> +
>> +	/* Checks invalid ruleset attribute. */
>> +	const int ruleset_fd_inv = landlock_create_ruleset(
>> +		&ruleset_attr_inval, sizeof(ruleset_attr_inval), 0);
>> +	ASSERT_EQ(-1, ruleset_fd_inv);
>> +	ASSERT_EQ(EINVAL, errno);
>> +
>> +	/* Gets ruleset. */
>> +	const int ruleset_fd =
>> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
>> +	ASSERT_LE(0, ruleset_fd);
>> +
>> +	/* Checks unhandled allowed_access. */
>> +	ASSERT_EQ(-1, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
>> +					&net_service_1, 0));
>> +	ASSERT_EQ(EINVAL, errno);
>> +
>> +	/* Checks zero port value. */
>> +	ASSERT_EQ(-1, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
>> +					&net_service_2, 0));
>> +	ASSERT_EQ(EINVAL, errno);
>> +
>> +	/* Checks zero access value. */
>> +	ASSERT_EQ(-1, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
>> +					&net_service_3, 0));
>> +	ASSERT_EQ(ENOMSG, errno);
>> +
>> +	/* Adds with legitimate values. */
>> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
>> +				       &net_service_4, 0));
>> +
>> +	/* Enforces the ruleset. */
>> +	enforce_ruleset(_metadata, ruleset_fd);
>> +	ASSERT_EQ(0, close(ruleset_fd));
>> +}
>>   TEST_HARNESS_MAIN
>> --
>> 2.25.1
>> 
> .
