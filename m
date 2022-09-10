Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 514CE5B48E1
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 22:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiIJUt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 16:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiIJUt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 16:49:26 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E277940BC3;
        Sat, 10 Sep 2022 13:49:25 -0700 (PDT)
Received: from fraeml705-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MQ4hM3V0bz67ZcT;
        Sun, 11 Sep 2022 04:48:35 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 fraeml705-chm.china.huawei.com (10.206.15.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.31; Sat, 10 Sep 2022 22:49:23 +0200
Received: from [10.122.132.241] (10.122.132.241) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 10 Sep 2022 21:49:23 +0100
Message-ID: <66b0eb2c-7c0e-57e4-77d9-2a94fd0ff3a0@huawei.com>
Date:   Sat, 10 Sep 2022 23:49:22 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v7 14/18] seltests/landlock: add rules overlapping test
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <anton.sirazetdinov@huawei.com>
References: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
 <20220829170401.834298-15-konstantin.meskhidze@huawei.com>
 <25b7e8c8-1eba-1a8d-138b-988dabeeb2ae@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <25b7e8c8-1eba-1a8d-138b-988dabeeb2ae@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhrpeml100006.china.huawei.com (7.191.160.224) To
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
>> This patch adds overlapping rules for one port. First rule adds just
>> bind() access right for a port. The second one adds both bind() and
>> connect() access rights for the same port.
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
>> * Refactors code with self->port, self->addr4 variables.
>> 
>> Changes since v3:
>> * Adds ruleset_overlap test.
>> 
>> ---
>>   tools/testing/selftests/landlock/net_test.c | 89 +++++++++++++++++++++
>>   1 file changed, 89 insertions(+)
>> 
>> diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
>> index 40aef7c683af..b3b38745f4eb 100644
>> --- a/tools/testing/selftests/landlock/net_test.c
>> +++ b/tools/testing/selftests/landlock/net_test.c
>> @@ -464,4 +464,93 @@ TEST_F(socket, connect_afunspec_with_restictions)
>>   	ASSERT_EQ(1, WIFEXITED(status));
>>   	ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
>>   }
>> +
>> +TEST_F(socket, ruleset_overlap)
>> +{
>> +	int sockfd;
>> +	int one = 1;
>> +
>> +	struct landlock_ruleset_attr ruleset_attr = {
>> +		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
>> +				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
>> +	};
>> +	struct landlock_net_service_attr net_service_1 = {
>> +		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
>> +
>> +		.port = self->port[0],
>> +	};
>> +
>> +	struct landlock_net_service_attr net_service_2 = {
>> +		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
>> +				  LANDLOCK_ACCESS_NET_CONNECT_TCP,
>> +
>> +		.port = self->port[0],
>> +	};
>> +
>> +	int ruleset_fd =
>> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
>> +	ASSERT_LE(0, ruleset_fd);
>> +
>> +	/* Allows bind operations to the port[0] socket. */
>> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
>> +				       &net_service_1, 0));
>> +	/* Allows connect and bind operations to the port[0] socket. */
>> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
>> +				       &net_service_2, 0));
>> +
>> +	/* Enforces the ruleset. */
>> +	enforce_ruleset(_metadata, ruleset_fd);
>> +
>> +	/* Creates a server socket. */
>> +	sockfd = create_socket_variant(variant, SOCK_STREAM);
>> +	ASSERT_LE(0, sockfd);
>> +	/* Allows to reuse of local address. */
>> +	ASSERT_EQ(0, setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &one,
>> +				sizeof(one)));
>> +
>> +	/* Binds the socket to address with port[0]. */
>> +	ASSERT_EQ(0, bind_variant(variant, sockfd, self, 0));
>> +
>> +	/* Makes connection to socket with port[0]. */
>> +	ASSERT_EQ(0, connect_variant(variant, sockfd, self, 0));
>> +
>> +	/* Closes socket. */
>> +	ASSERT_EQ(0, close(sockfd));
>> +
>> +	/* Creates another ruleset layer. */
>> +	ruleset_fd =
>> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
>> +	ASSERT_LE(0, ruleset_fd);
>> +
>> +	/*
>> +	 * Allows bind operations to the port[0] socket in
>> +	 * the new ruleset layer.
>> +	 */
>> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
>> +				       &net_service_1, 0));
>> +
>> +	/* Enforces the new ruleset. */
>> +	enforce_ruleset(_metadata, ruleset_fd);
>> +
>> +	/* Creates a server socket. */
>> +	sockfd = create_socket_variant(variant, SOCK_STREAM);
>> +	ASSERT_LE(0, sockfd);
>> +	/* Allows to reuse of local address. */
>> +	ASSERT_EQ(0, setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &one,
>> +				sizeof(one)));
>> +
>> +	/* Binds the socket to address with port[0]. */
>> +	ASSERT_EQ(0, bind_variant(variant, sockfd, self, 0));
>> +
>> +	/*
>> +	 * Forbids to connect the socket to address with port[0],
>> +	 * cause just one ruleset layer has connect() access rule.
> 
> s/cause/because/ (everywhere)

   Ok. I will rewrite it.
> .
