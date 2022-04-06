Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 442714F660F
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 18:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238173AbiDFQyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 12:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238247AbiDFQxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 12:53:52 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B083CF48C;
        Wed,  6 Apr 2022 07:17:53 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KYRPw0hZMz67wqg;
        Wed,  6 Apr 2022 22:16:04 +0800 (CST)
Received: from [10.122.132.241] (10.122.132.241) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Wed, 6 Apr 2022 16:17:50 +0200
Message-ID: <e1835aeb-8fe3-a8d7-9d36-69ce8e989291@huawei.com>
Date:   Wed, 6 Apr 2022 17:17:47 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [RFC PATCH v4 10/15] seltest/landlock: add tests for bind() hooks
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>, <anton.sirazetdinov@huawei.com>
References: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
 <20220309134459.6448-11-konstantin.meskhidze@huawei.com>
 <c2bc5ccf-8942-ab5e-c071-6f6c6e6b2d9d@digikod.net>
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
In-Reply-To: <c2bc5ccf-8942-ab5e-c071-6f6c6e6b2d9d@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml751-chm.china.huawei.com (10.201.108.201) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



4/4/2022 9:32 PM, Mickaël Salaün пишет:
> 
> On 09/03/2022 14:44, Konstantin Meskhidze wrote:
>> Adds two selftests for bind socket action.
>> The one is with no landlock restrictions:
>>      - bind_no_restrictions;
>> The second one is with mixed landlock rules:
>>      - bind_with_restrictions;
>>
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>>
>> Changes since v3:
>> * Split commit.
>> * Add helper create_socket.
>> * Add FIXTURE_SETUP.
>>
>> ---
>>   .../testing/selftests/landlock/network_test.c | 153 ++++++++++++++++++
>>   1 file changed, 153 insertions(+)
>>   create mode 100644 tools/testing/selftests/landlock/network_test.c
>>
>> diff --git a/tools/testing/selftests/landlock/network_test.c 
>> b/tools/testing/selftests/landlock/network_test.c
>> new file mode 100644
>> index 000000000000..4c60f6d973a8
>> --- /dev/null
>> +++ b/tools/testing/selftests/landlock/network_test.c
> 
> [...]
> 
>> +
>> +uint port[MAX_SOCKET_NUM];
>> +struct sockaddr_in addr[MAX_SOCKET_NUM];
> 
> You should not change global variables, it is a source of issue. Instead 
> use FIXTURE local variables accessible through self->X.
> 
   Sorry. Did not get your point here.
>> +
>> +const int one = 1;
> 
> This doesn't need to be global.

    Ok. Got it.
> 
> [...]
> 
>> +
>> +static void enforce_ruleset(struct __test_metadata *const _metadata,
>> +        const int ruleset_fd)
>> +{
>> +    ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
>> +    ASSERT_EQ(0, landlock_restrict_self(ruleset_fd, 0)) {
>> +        TH_LOG("Failed to enforce ruleset: %s", strerror(errno));
>> +    }
>> +}
> 
> You should move the same helper from fs_base.c to common.h (see caps 
> helpers) and reuse it here.
> 
   Ok. Thanks.
> 
>> +
>> +FIXTURE(socket) { };
>> +
>> +FIXTURE_SETUP(socket)
>> +{
>> +    int i;
> 
> Please add a new line between declaration and actual code (everywhere).

   Ok. Got it. Will be refactored.
> 
>> +    /* Creates socket addresses */
>> +    for (i = 0; i < MAX_SOCKET_NUM; i++) {
> 
> Use ARRAY_SIZE() instead of MAY_SOCKET_NUM.
> 
   Ok. I got it.
> 
>> +        port[i] = SOCK_PORT_START + SOCK_PORT_ADD*i;
> 
> Use self->port[i] and self->addr[i] instead.
> 

   Do you mean to add it in FIXTURE variables?

>> +        addr[i].sin_family = AF_INET;
>> +        addr[i].sin_port = htons(port[i]);
>> +        addr[i].sin_addr.s_addr = inet_addr(IP_ADDRESS);
>> +        memset(&(addr[i].sin_zero), '\0', 8);
>> +    }
>> +}
> 
> [...]
> 
>> +    /* Allows connect and deny bind operations to the port[1] socket. */
>> +    ASSERT_EQ(0, landlock_add_rule(ruleset_fd, 
>> LANDLOCK_RULE_NET_SERVICE,
>> +                &net_service_2, 0));
>> +    /* Empty allowed_access (i.e. deny rules) are ignored in network 
>> actions
> 
> The kernel coding style says to start a multi-line comments with a "/*" 
> and a new line.

   I missed it here. Thanks.
> .
