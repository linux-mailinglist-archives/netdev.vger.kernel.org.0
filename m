Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B31BE4DA0BE
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 18:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350380AbiCORDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 13:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350395AbiCORDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 13:03:34 -0400
Received: from smtp-1909.mail.infomaniak.ch (smtp-1909.mail.infomaniak.ch [IPv6:2001:1600:3:17::1909])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89CAC580ED
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 10:02:20 -0700 (PDT)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4KJ07s4xPFzMppPQ;
        Tue, 15 Mar 2022 18:02:17 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4KJ07r6wTCzljsTq;
        Tue, 15 Mar 2022 18:02:16 +0100 (CET)
Message-ID: <c9333349-5e05-de95-85da-f6a0cd836162@digikod.net>
Date:   Tue, 15 Mar 2022 18:02:49 +0100
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com, anton.sirazetdinov@huawei.com
References: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [RFC PATCH v4 00/15] Landlock LSM
In-Reply-To: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Konstantin,

This series looks good! Thanks for the split in multiple patches.


On 09/03/2022 14:44, Konstantin Meskhidze wrote:
> Hi,
> This is a new V4 bunch of RFC patches related to Landlock LSM network confinement.
> It brings deep refactirong and commit splitting of previous version V3.
> Also added additional selftests.
> 
> This patch series can be applied on top of v5.17-rc3.
> 
> All test were run in QEMU evironment and compiled with
>   -static flag.
>   1. network_test: 9/9 tests passed.

I get a kernel warning running the network tests.

>   2. base_test: 8/8 tests passed.
>   3. fs_test: 46/46 tests passed.
>   4. ptrace_test: 4/8 tests passed.

Does your test machine use Yama? That would explain the 4/8. You can 
disable it with the appropriate sysctl.

> 
> Tests were also launched for Landlock version without
> v4 patch:
>   1. base_test: 8/8 tests passed.
>   2. fs_test: 46/46 tests passed.
>   3. ptrace_test: 4/8 tests passed.
> 
> Could not provide test coverage cause had problems with tests
> on VM (no -static flag the tests compiling, no v4 patch applied):

You can build statically-linked tests with:
make -C tools/testing/selftests/landlock CFLAGS=-static

> 1. base_test: 7/8 tests passed.
>   Error:
>   # Starting 8 tests from 1 test cases.
>   #  RUN           global.inconsistent_attr ...
>   # base_test.c:51:inconsistent_attr:Expected ENOMSG (42) == errno (22)

This looks like a bug in the syscall argument checks.

>   # inconsistent_attr: Test terminated by assertion
> 2. fs_test: 0 / 46 tests passed
>   Error for all tests:
>   # common.h:126:no_restriction:Expected -1 (-1) != cap_set_proc(cap_p) (-1)
>   # common.h:127:no_restriction:Failed to cap_set_proc: Operation not permitted
>   # fs_test.c:106:no_restriction:Expected 0 (0) == mkdir(path, 0700) (-1)
>   # fs_test.c:107:no_restriction:Failed to create directory "tmp": File exists

You need to run these tests as root.

> 3. ptrace_test: 4 / 8 tests passed.
> 
> Previous versions:
> v3: https://lore.kernel.org/linux-security-module/20220124080215.265538-1-konstantin.meskhidze@huawei.com/
> v2: https://lore.kernel.org/linux-security-module/20211228115212.703084-1-konstantin.meskhidze@huawei.com/
> v1: https://lore.kernel.org/linux-security-module/20211210072123.386713-1-konstantin.meskhidze@huawei.com/

Nice to have this history!

> 
> Konstantin Meskhidze (15):
>    landlock: access mask renaming
>    landlock: filesystem access mask helpers
>    landlock: landlock_find/insert_rule refactoring
>    landlock: merge and inherit function refactoring
>    landlock: unmask_layers() function refactoring
>    landlock: landlock_add_rule syscall refactoring
>    landlock: user space API network support
>    landlock: add support network rules
>    landlock: TCP network hooks implementation
>    seltest/landlock: add tests for bind() hooks
>    seltest/landlock: add tests for connect() hooks
>    seltest/landlock: connect() with AF_UNSPEC tests
>    seltest/landlock: rules overlapping test
>    seltest/landlock: ruleset expanding test
>    seltest/landlock: invalid user input data test
> 
>   include/uapi/linux/landlock.h                 |  48 ++
>   security/landlock/Kconfig                     |   1 +
>   security/landlock/Makefile                    |   2 +-
>   security/landlock/fs.c                        |  72 +-
>   security/landlock/limits.h                    |   6 +
>   security/landlock/net.c                       | 180 +++++
>   security/landlock/net.h                       |  22 +
>   security/landlock/ruleset.c                   | 383 ++++++++--
>   security/landlock/ruleset.h                   |  72 +-
>   security/landlock/setup.c                     |   2 +
>   security/landlock/syscalls.c                  | 176 +++--
>   .../testing/selftests/landlock/network_test.c | 665 ++++++++++++++++++
>   12 files changed, 1434 insertions(+), 195 deletions(-)
>   create mode 100644 security/landlock/net.c
>   create mode 100644 security/landlock/net.h
>   create mode 100644 tools/testing/selftests/landlock/network_test.c
> 
> --
> 2.25.1
> 
