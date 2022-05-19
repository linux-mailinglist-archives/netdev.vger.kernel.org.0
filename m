Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAF152D285
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 14:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235651AbiESMbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 08:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237968AbiESMbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 08:31:53 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31AE42C677;
        Thu, 19 May 2022 05:31:38 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4L3q3J1dyPz6F99q;
        Thu, 19 May 2022 20:31:24 +0800 (CST)
Received: from [10.122.132.241] (10.122.132.241) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Thu, 19 May 2022 14:31:35 +0200
Message-ID: <1297f02f-5c2c-bebd-da58-eed9b8ee97cc@huawei.com>
Date:   Thu, 19 May 2022 15:31:33 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v5 11/15] seltests/landlock: connect() with AF_UNSPEC
 tests
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <anton.sirazetdinov@huawei.com>
References: <20220516152038.39594-1-konstantin.meskhidze@huawei.com>
 <20220516152038.39594-12-konstantin.meskhidze@huawei.com>
 <e2c67180-3ec5-f710-710a-0c2644bfa54e@digikod.net>
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
In-Reply-To: <e2c67180-3ec5-f710-710a-0c2644bfa54e@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml753-chm.china.huawei.com (10.201.108.203) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



5/17/2022 11:55 AM, Mickaël Salaün пишет:
> I guess these tests would also work with IPv6. You can then use the 
> "alternative" tests I explained.
> 
   Do you mean adding new helpers such as bind_variant() and 
connect_variant()??
> On 16/05/2022 17:20, Konstantin Meskhidze wrote:
>> Adds two selftests for connect() action with
>> AF_UNSPEC family flag.
>> The one is with no landlock restrictions
>> allows to disconnect already conneted socket
>> with connect(..., AF_UNSPEC, ...):
>>      - connect_afunspec_no_restictions;
>> The second one refuses landlocked process
>> to disconnect already connected socket:
>>      - connect_afunspec_with_restictions;
>>
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>>
>> Changes since v3:
>> * Add connect_afunspec_no_restictions test.
>> * Add connect_afunspec_with_restictions test.
>>
>> Changes since v4:
>> * Refactoring code with self->port, self->addr4 variables.
>> * Adds bind() hook check for with AF_UNSPEC family.
>>
>> ---
>>   tools/testing/selftests/landlock/net_test.c | 121 ++++++++++++++++++++
>>   1 file changed, 121 insertions(+)
>>
>> diff --git a/tools/testing/selftests/landlock/net_test.c 
>> b/tools/testing/selftests/landlock/net_test.c
>> index cf914d311eb3..bf8e49466d1d 100644
>> --- a/tools/testing/selftests/landlock/net_test.c
>> +++ b/tools/testing/selftests/landlock/net_test.c
>> @@ -449,6 +449,7 @@ TEST_F_FORK(socket_test, 
>> connect_with_restrictions_ip6) {
>>       int new_fd;
>>       int sockfd_1, sockfd_2;
>>       pid_t child_1, child_2;
>> +
>>       int status;
>>
>>       struct landlock_ruleset_attr ruleset_attr = {
>> @@ -467,10 +468,12 @@ TEST_F_FORK(socket_test, 
>> connect_with_restrictions_ip6) {
>>
>>       const int ruleset_fd = landlock_create_ruleset(&ruleset_attr,
>>               sizeof(ruleset_attr), 0);
>> +
> 
> Please no…
> 
  Sorry for that. I will apply clang-format-14.
> 
>>       ASSERT_LE(0, ruleset_fd);
>>
>>       /* Allows connect and bind operations to the port[0] socket */
>>       ASSERT_EQ(0, landlock_add_rule(ruleset_fd, 
>> LANDLOCK_RULE_NET_SERVICE,
>> +
> 
> ditto

   Ditto. Will be fixed with clang-format.
> 
>>                   &net_service_1, 0));
>>       /* Allows connect and deny bind operations to the port[1] socket */
>>       ASSERT_EQ(0, landlock_add_rule(ruleset_fd, 
>> LANDLOCK_RULE_NET_SERVICE,
>> @@ -480,6 +483,7 @@ TEST_F_FORK(socket_test, 
>> connect_with_restrictions_ip6) {
>>       enforce_ruleset(_metadata, ruleset_fd);
>>
>>       /* Creates a server socket 1 */
>> +
>>       sockfd_1 = create_socket(_metadata, true, false);
>>       ASSERT_LE(0, sockfd_1);
>>
>> @@ -556,4 +560,121 @@ TEST_F_FORK(socket_test, 
>> connect_with_restrictions_ip6) {
>>       ASSERT_EQ(1, WIFEXITED(status));
>>       ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
>>   }
>> +
>> +TEST_F_FORK(socket_test, connect_afunspec_no_restictions) {
>> +
>> +    int sockfd;
>> +    pid_t child;
>> +    int status;
>> +
>> +    /* Creates a server socket 1 */
>> +    sockfd = create_socket(_metadata, false, false);
>> +    ASSERT_LE(0, sockfd);
>> +
>> +    /* Binds the socket 1 to address with port[0] with AF_UNSPEC 
>> family */
>> +    self->addr4[0].sin_family = AF_UNSPEC;
>> +    ASSERT_EQ(0, bind(sockfd, (struct sockaddr *)&self->addr4[0], 
>> sizeof(self->addr4[0])));
>> +
>> +    /* Makes connection to socket with port[0] */
>> +    ASSERT_EQ(0, connect(sockfd, (struct sockaddr *)&self->addr4[0],
>> +                           sizeof(self->addr4[0])));
>> +
>> +    child = fork();
>> +    ASSERT_LE(0, child);
>> +    if (child == 0) {
>> +        struct sockaddr addr_unspec = {.sa_family = AF_UNSPEC};
>> +
>> +        /* Child tries to disconnect already connected socket */
>> +        ASSERT_EQ(0, connect(sockfd, (struct sockaddr *)&addr_unspec,
>> +                        sizeof(addr_unspec)));
>> +        _exit(_metadata->passed ? EXIT_SUCCESS : EXIT_FAILURE);
>> +        return;
>> +    }
>> +    /* Closes listening socket 1 for the parent*/
>> +    ASSERT_EQ(0, close(sockfd));
>> +
>> +    ASSERT_EQ(child, waitpid(child, &status, 0));
>> +    ASSERT_EQ(1, WIFEXITED(status));
>> +    ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
>> +}
>> +
>> +TEST_F_FORK(socket_test, connect_afunspec_with_restictions) {
>> +
>> +    int sockfd;
>> +    pid_t child;
>> +    int status;
>> +
>> +    struct landlock_ruleset_attr ruleset_attr_1 = {
>> +        .handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP,
>> +    };
>> +    struct landlock_net_service_attr net_service_1 = {
>> +        .allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
>> +
>> +        .port = self->port[0],
>> +    };
>> +
>> +    struct landlock_ruleset_attr ruleset_attr_2 = {
>> +        .handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
>> +                      LANDLOCK_ACCESS_NET_CONNECT_TCP,
>> +    };
>> +    struct landlock_net_service_attr net_service_2 = {
>> +        .allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
>> +                  LANDLOCK_ACCESS_NET_CONNECT_TCP,
>> +
>> +        .port = self->port[0],
>> +    };
>> +
>> +    const int ruleset_fd_1 = landlock_create_ruleset(&ruleset_attr_1,
>> +                    sizeof(ruleset_attr_1), 0);
>> +    ASSERT_LE(0, ruleset_fd_1);
>> +
>> +    /* Allows bind operations to the port[0] socket */
>> +    ASSERT_EQ(0, landlock_add_rule(ruleset_fd_1, 
>> LANDLOCK_RULE_NET_SERVICE,
>> +                       &net_service_1, 0));
>> +
>> +    /* Enforces the ruleset. */
>> +    enforce_ruleset(_metadata, ruleset_fd_1);
>> +
>> +    /* Creates a server socket 1 */
>> +    sockfd = create_socket(_metadata, false, false);
>> +    ASSERT_LE(0, sockfd);
>> +
>> +    /* Binds the socket 1 to address with port[0] with AF_UNSPEC 
>> family */
>> +    self->addr4[0].sin_family = AF_UNSPEC;
>> +    ASSERT_EQ(0, bind(sockfd, (struct sockaddr *)&self->addr4[0], 
>> sizeof(self->addr4[0])));
>> +
>> +    /* Makes connection to socket with port[0] */
>> +    ASSERT_EQ(0, connect(sockfd, (struct sockaddr *)&self->addr4[0],
>> +                           sizeof(self->addr4[0])));
>> +
>> +    const int ruleset_fd_2 = landlock_create_ruleset(&ruleset_attr_2,
>> +                    sizeof(ruleset_attr_2), 0);
>> +    ASSERT_LE(0, ruleset_fd_2);
>> +
>> +    /* Allows connect and bind operations to the port[0] socket */
>> +    ASSERT_EQ(0, landlock_add_rule(ruleset_fd_2, 
>> LANDLOCK_RULE_NET_SERVICE,
>> +                       &net_service_2, 0));
>> +
>> +    /* Enforces the ruleset. */
>> +    enforce_ruleset(_metadata, ruleset_fd_2);
>> +
>> +    child = fork();
>> +    ASSERT_LE(0, child);
>> +    if (child == 0) {
>> +        struct sockaddr addr_unspec = {.sa_family = AF_UNSPEC};
>> +
>> +        /* Child tries to disconnect already connected socket */
>> +        ASSERT_EQ(-1, connect(sockfd, (struct sockaddr *)&addr_unspec,
>> +                        sizeof(addr_unspec)));
>> +        ASSERT_EQ(EACCES, errno);
>> +        _exit(_metadata->passed ? EXIT_SUCCESS : EXIT_FAILURE);
>> +        return;
>> +    }
>> +    /* Closes listening socket 1 for the parent*/
>> +    ASSERT_EQ(0, close(sockfd));
>> +
>> +    ASSERT_EQ(child, waitpid(child, &status, 0));
>> +    ASSERT_EQ(1, WIFEXITED(status));
>> +    ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
>> +}
>>   TEST_HARNESS_MAIN
>> -- 
>> 2.25.1
>>
> .
