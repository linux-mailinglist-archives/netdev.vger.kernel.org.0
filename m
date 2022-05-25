Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC514533A14
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 11:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233075AbiEYJlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 05:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234941AbiEYJlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 05:41:12 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D91B386;
        Wed, 25 May 2022 02:41:09 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4L7QzS3MhZz67Zm0;
        Wed, 25 May 2022 17:40:36 +0800 (CST)
Received: from [10.122.132.241] (10.122.132.241) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Wed, 25 May 2022 11:41:05 +0200
Message-ID: <77be3dcf-cae1-f754-ac2a-f9eeab063d76@huawei.com>
Date:   Wed, 25 May 2022 12:41:03 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v5 00/15] Network support for Landlock - UDP discussion
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <anton.sirazetdinov@huawei.com>, Paul Moore <paul@paul-moore.com>
References: <20220516152038.39594-1-konstantin.meskhidze@huawei.com>
 <a5ef620d-0447-3d58-d9bd-1220b8411957@digikod.net>
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
In-Reply-To: <a5ef620d-0447-3d58-d9bd-1220b8411957@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



5/20/2022 1:48 PM, Mickaël Salaün пишет:
> Hi,
> 
> Regarding future plan to support UDP, it may not be possible to 
> efficiently restrict sending on a port or receiving on a port because of 
> the non-connnected state of UDP sockets. Indeed, when setting up a 
> socket to send a packet on a specified port, we (automatically or 
> manually) have a receiving port configured and this socket can be used 
> to receive any UDP packet. An UDP socket could be restricted to only 
> send/write or to receive/read from a specific port, but this would 
> probably not be as useful as the TCP restrictions. That could look like 
> RECEIVE_UDP and SEND_UDP access-rights but the LSM implementation would 
> be more complex because of the socket/FD tracking. Moreover, the 
> performance impact could be more important for every read and write 
> syscall (whatever the FD type).
> 
> Any opinion?
> 

   You are right about non-connected nature of UDP sockets and 
landlocking them like TCP ones would have performance impact.
I'm thinking about a "connected" UDP socket.
	It's possible call connect() for a UDP socket. But this does not result 
in anything like a TCP connection: There is no three-way handshake. 
Instead, the kernel just checks for any immediate errors (e.g., an 
obviously unreachable destination), records the IP address and port 
number of the peer (from the socket address structure passed to 
connect), and returns immediately to the calling process. In this case 
UDP socket is pseudo-connected and stores peer IP addrsss and port from 
connect(). The application calls connect(), specifies the IP address and 
port number of its peer. It then uses read() and write() yo exchange 
data with the peer. Datagrams arriving from any other IP address or port 
are not passed to the connected socket because either the source IP 
address or source UDP port does not match the protocol address to which 
the socket is connected. These datagrams could be delivered to some 
other UDP socket on the host. If there is no other matching socket for 
the arriving datagram, UDP will discard it and generate an ICMP ‘‘port 
unreachable’’ error. In summary, we can say that a UDP client or server 
can call connect only if that process uses the UDP socket to communicate 
with exactly one peer. Normally, it is a UDP client that calls connect, 
but there are applications in which the UDP server communicates with a 
single client for a long duration (e.g., TFTP); in this case, both the
client and server can call connect. [1]

In case if a "connected", or lets call it "pseudo-connected", UPD socket 
there is no performance impact on write(), read() system calls, cause we 
could use the same hooks bind() and connect() like for TCP one.

What do you think? Please share your opinion?

[1] "Unix Network Programming, The sockets Networling API." by W.Richard 
Stevens.

> Regards,
>   Mickaël
> 
> 
> On 16/05/2022 17:20, Konstantin Meskhidze wrote:
>> Hi,
>> This is a new V5 patch related to Landlock LSM network confinement.
>> It is based on the latest landlock-wip branch on top of v5.18-rc5:
>> https://git.kernel.org/pub/scm/linux/kernel/git/mic/linux.git/log/?h=landlock-wip 
>>
>>
>> It brings refactoring of previous patch version V4.
>> Added additional selftests for IP6 network families and network 
>> namespace.
>> Added TCP sockets confinement support in sandboxer demo.
>>
>> All test were run in QEMU evironment and compiled with
>>   -static flag.
>>   1. network_test: 13/13 tests passed.
>>   2. base_test: 7/7 tests passed.
>>   3. fs_test: 59/59 tests passed.
>>   4. ptrace_test: 8/8 tests passed.
>>
>> Still have issue with base_test were compiled without -static flag
>> (landlock-wip branch without network support)
>> 1. base_test: 6/7 tests passed.
>>   Error:
>>   #  RUN           global.inconsistent_attr ...
>>   # base_test.c:54:inconsistent_attr:Expected ENOMSG (42) == errno (22)
>>   # inconsistent_attr: Test terminated by assertion
>>   #          FAIL  global.inconsistent_attr
>> not ok 1 global.inconsistent_attr
>>
>> LCOV - code coverage report:
>>              Hit  Total  Coverage
>> Lines:      952  1010    94.3 %
>> Functions:  79   82      96.3 %
>>
>> Previous versions:
>> v4: 
>> https://lore.kernel.org/linux-security-module/20220309134459.6448-1-konstantin.meskhidze@huawei.com/ 
>>
>> v3: 
>> https://lore.kernel.org/linux-security-module/20220124080215.265538-1-konstantin.meskhidze@huawei.com/ 
>>
>> v2: 
>> https://lore.kernel.org/linux-security-module/20211228115212.703084-1-konstantin.meskhidze@huawei.com/ 
>>
>> v1: 
>> https://lore.kernel.org/linux-security-module/20211210072123.386713-1-konstantin.meskhidze@huawei.com/ 
>>
>>
>> Konstantin Meskhidze (15):
>>    landlock: access mask renaming
>>    landlock: landlock_find/insert_rule refactoring
>>    landlock: merge and inherit function refactoring
>>    landlock: helper functions refactoring
>>    landlock: landlock_add_rule syscall refactoring
>>    landlock: user space API network support
>>    landlock: add support network rules
>>    landlock: TCP network hooks implementation
>>    seltests/landlock: add tests for bind() hooks
>>    seltests/landlock: add tests for connect() hooks
>>    seltests/landlock: connect() with AF_UNSPEC tests
>>    seltests/landlock: rules overlapping test
>>    seltests/landlock: ruleset expanding test
>>    seltests/landlock: invalid user input data test
>>    samples/landlock: adds network demo
>>
>>   include/uapi/linux/landlock.h                |  48 +
>>   samples/landlock/sandboxer.c                 | 105 ++-
>>   security/landlock/Kconfig                    |   1 +
>>   security/landlock/Makefile                   |   2 +
>>   security/landlock/fs.c                       | 169 +---
>>   security/landlock/limits.h                   |   8 +-
>>   security/landlock/net.c                      | 159 ++++
>>   security/landlock/net.h                      |  25 +
>>   security/landlock/ruleset.c                  | 481 ++++++++--
>>   security/landlock/ruleset.h                  | 102 +-
>>   security/landlock/setup.c                    |   2 +
>>   security/landlock/syscalls.c                 | 173 ++--
>>   tools/testing/selftests/landlock/base_test.c |   4 +-
>>   tools/testing/selftests/landlock/common.h    |   9 +
>>   tools/testing/selftests/landlock/config      |   5 +-
>>   tools/testing/selftests/landlock/fs_test.c   |  10 -
>>   tools/testing/selftests/landlock/net_test.c  | 935 +++++++++++++++++++
>>   17 files changed, 1925 insertions(+), 313 deletions(-)
>>   create mode 100644 security/landlock/net.c
>>   create mode 100644 security/landlock/net.h
>>   create mode 100644 tools/testing/selftests/landlock/net_test.c
>>
>> -- 
>> 2.25.1
>>
> .
