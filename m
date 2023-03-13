Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 012646B7F4B
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 18:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbjCMRS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 13:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbjCMRSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 13:18:08 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920E6C662;
        Mon, 13 Mar 2023 10:17:39 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Pb3Gj4JKvz6J7lN;
        Tue, 14 Mar 2023 01:16:29 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 13 Mar 2023 17:16:43 +0000
Message-ID: <c20fc9eb-518e-84b4-0dd5-7b97c0825259@huawei.com>
Date:   Mon, 13 Mar 2023 20:16:42 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v9 00/12] Network support for Landlock
Content-Language: ru
To:     =?UTF-8?Q?G=c3=bcnther_Noack?= <gnoack3000@gmail.com>
CC:     <mic@digikod.net>, <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
References: <20230116085818.165539-1-konstantin.meskhidze@huawei.com>
 <Y/fl5iEbkL5Pj5cJ@galopp>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <Y/fl5iEbkL5Pj5cJ@galopp>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml500005.china.huawei.com (7.191.163.240) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



2/24/2023 1:17 AM, Günther Noack пишет:
> Hello Konstantin!
> 
> Sorry for asking such fundamental questions again so late in the review.
> 
> After playing with patch V9 with the Go-Landlock library, I'm still
> having trouble understanding these questions -- they probably have
> good answers, but I also did not see them explained in the
> documentation. Maybe it would help to clarify it there?
> 
> * What is the use case for permitting processes to connect to a given
>    TCP port, but leaving unspecified what the IP address is?
> 
>    Example: If a Landlock ruleset permits connecting to TCP port 53,
>    that makes it possible to talk to any IP address on the internet (at
>    least if the process runs on a normal Linux desktop machine), and we
>    can't really control whether that is the system's proper (TCP-)DNS
>    server or whether that is an attacker-controlled service for
>    accepting leaked secrets from the process...?
> 
>    Is the plan that IP address support should be added in a follow-up
>    patch?  Will it become part of the landlock_net_service_attr struct?

      In the beginning I introduced the idea with IP address to
Mickaël but he suggested to use port-based granularity. So with ports 
it's worth using Landlock in containerized applications working within 
one IP address. Anyway it's possible to use netfilter to control 
incoming traffic. It's a good question - we should discuss it carefuly.
> 
> * Given the list of obscure network protocols listed in the socket(2)
>    man page, I find it slightly weird to have rules for the use of TCP,
>    but to leave less prominent protocols unrestricted.
> 
>    For example, a process with an enabled Landlock network ruleset may
>    connect only to certain TCP ports, but at the same time it can
>    happily use Bluetooth/CAN bus/DECnet/IPX or other protocols?

      We also have started a discussion about UDP protocol, but it's 
more complicated since UDP sockets does not establish connections 
between each other. There is a performance problem on the first place here.

I'm not familiar with Bluetooth/CAN bus/DECnet/IPX but let's discuss it.
Any ideas here?

> 
>    I'm mentioning these more obscure protocols, because I doubt that
>    Landlock will grow more sophisticated support for them anytime soon,
>    so maybe the best option would be to just make it possible to
>    disable these?  Is that also part of the plan?
> 
>    (I think there would be a lot of value in restricting network
>    access, even when it's done very broadly.  There are many programs
>    that don't need network at all, and among those that do need
>    network, most only require IP networking.
> 
>    Btw, the argument for more broad disabling of network access was
>    already made at https://cr.yp.to/unix/disablenetwork.html in the
>    past.)
      Thanks for the link. I will read it.
> 
> * This one is more of an implementation question: I don't understand
>    why we are storing the networking rules in the same RB tree as the
>    file system rules. - It looks a bit like "YAGNI" to me...?

      Actually network rules are stored in a different RB tree.
      You can check it in struct landlock_ruleset (ruleset.h):
      - struct rb_root root_inodeis for fs rules

      - struct rb_root root_net_port is for network rules;
> 
>    Would it be more efficient to keep the file system rules in the
>    existing RB tree, and store the networking rules *separately* next
>    to it in a different RB tree, or even in a more optimized data
>    structure? In pseudocode:
> 
>      struct fast_lookup_int_set bind_tcp_ports;
>      struct fast_lookup_int_set connect_tcp_ports;
>      struct landlock_rb_tree fs_rules;
> 
>    It seems that there should be a data structure that supports this
>    well and which uses the fact that we only need to store small
>    integers?

      Thnaks for the question. From my point of view it depends on a 
real scenario - how many ports we want to allow by Landlock for a 
proccess - thousands, hundreds or less. If it's just 10 ports - do we 
really need some optimized data structure? Do we get some performance 
gain here?
What do you think?
> 
> Thanks,
> –Günther
> 
> P.S.: Apologies if some of it was discussed previously. I did my best
> to catch up on previous threads, but it's long, and it's possible that
> I missed parts of the discussion.
> 
> On Mon, Jan 16, 2023 at 04:58:06PM +0800, Konstantin Meskhidze wrote:
>> Hi,
>> This is a new V9 patch related to Landlock LSM network confinement.
>> It is based on the landlock's -next branch on top of v6.2-rc3 kernel version:
>> https://git.kernel.org/pub/scm/linux/kernel/git/mic/linux.git/log/?h=next
>> 
>> It brings refactoring of previous patch version V8.
>> Mostly there are fixes of logic and typos, adding new tests.
>> 
>> All test were run in QEMU evironment and compiled with
>>  -static flag.
>>  1. network_test: 32/32 tests passed.
>>  2. base_test: 7/7 tests passed.
>>  3. fs_test: 78/78 tests passed.
>>  4. ptrace_test: 8/8 tests passed.
>> 
>> Previous versions:
>> v8: https://lore.kernel.org/linux-security-module/20221021152644.155136-1-konstantin.meskhidze@huawei.com/
>> v7: https://lore.kernel.org/linux-security-module/20220829170401.834298-1-konstantin.meskhidze@huawei.com/
>> v6: https://lore.kernel.org/linux-security-module/20220621082313.3330667-1-konstantin.meskhidze@huawei.com/
>> v5: https://lore.kernel.org/linux-security-module/20220516152038.39594-1-konstantin.meskhidze@huawei.com
>> v4: https://lore.kernel.org/linux-security-module/20220309134459.6448-1-konstantin.meskhidze@huawei.com/
>> v3: https://lore.kernel.org/linux-security-module/20220124080215.265538-1-konstantin.meskhidze@huawei.com/
>> v2: https://lore.kernel.org/linux-security-module/20211228115212.703084-1-konstantin.meskhidze@huawei.com/
>> v1: https://lore.kernel.org/linux-security-module/20211210072123.386713-1-konstantin.meskhidze@huawei.com/
>> 
>> Konstantin Meskhidze (11):
>>   landlock: Make ruleset's access masks more generic
>>   landlock: Refactor landlock_find_rule/insert_rule
>>   landlock: Refactor merge/inherit_ruleset functions
>>   landlock: Move and rename umask_layers() and init_layer_masks()
>>   landlock: Refactor _unmask_layers() and _init_layer_masks()
>>   landlock: Refactor landlock_add_rule() syscall
>>   landlock: Add network rules and TCP hooks support
>>   selftests/landlock: Share enforce_ruleset()
>>   selftests/landlock: Add 10 new test suites dedicated to network
>>   samples/landlock: Add network demo
>>   landlock: Document Landlock's network support
>> 
>> Mickaël Salaün (1):
>>   landlock: Allow filesystem layout changes for domains without such
>>     rule type
>> 
>>  Documentation/userspace-api/landlock.rst     |   72 +-
>>  include/uapi/linux/landlock.h                |   49 +
>>  samples/landlock/sandboxer.c                 |  131 +-
>>  security/landlock/Kconfig                    |    1 +
>>  security/landlock/Makefile                   |    2 +
>>  security/landlock/fs.c                       |  255 ++--
>>  security/landlock/limits.h                   |    7 +-
>>  security/landlock/net.c                      |  200 +++
>>  security/landlock/net.h                      |   26 +
>>  security/landlock/ruleset.c                  |  409 +++++--
>>  security/landlock/ruleset.h                  |  185 ++-
>>  security/landlock/setup.c                    |    2 +
>>  security/landlock/syscalls.c                 |  165 ++-
>>  tools/testing/selftests/landlock/base_test.c |    2 +-
>>  tools/testing/selftests/landlock/common.h    |   10 +
>>  tools/testing/selftests/landlock/config      |    4 +
>>  tools/testing/selftests/landlock/fs_test.c   |   75 +-
>>  tools/testing/selftests/landlock/net_test.c  | 1157 ++++++++++++++++++
>>  18 files changed, 2398 insertions(+), 354 deletions(-)
>>  create mode 100644 security/landlock/net.c
>>  create mode 100644 security/landlock/net.h
>>  create mode 100644 tools/testing/selftests/landlock/net_test.c
>> 
>> -- 
>> 2.25.1
>> 
> .
