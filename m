Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B52852EA2A
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 12:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348173AbiETKsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 06:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbiETKs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 06:48:29 -0400
Received: from smtp-bc0a.mail.infomaniak.ch (smtp-bc0a.mail.infomaniak.ch [45.157.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21CC24AE19
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 03:48:26 -0700 (PDT)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4L4Nk11GJszMqkPY;
        Fri, 20 May 2022 12:48:25 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4L4Nk02SjgzlhSMV;
        Fri, 20 May 2022 12:48:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1653043705;
        bh=4/DTGTCgp4U0kXNFebaREvz0BDD6lnA4+jHOrbX2u+Q=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=rvbEshG08kgbPp2tW/9PUxfsO9sT6rFw62n/ybnajefDszYLouuiRePzGKp7f2Djd
         WOodqge80GqNylBp2slxcBARfF5SEmK55yo1STowGHXvCQ7cQWL9DvzMCfufpxvyJq
         nbc1vpAF1FaaXZzV8k9x7Y0wFy5ZkAjFMHbCEcAQ=
Message-ID: <a5ef620d-0447-3d58-d9bd-1220b8411957@digikod.net>
Date:   Fri, 20 May 2022 12:48:23 +0200
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        anton.sirazetdinov@huawei.com, Paul Moore <paul@paul-moore.com>
References: <20220516152038.39594-1-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH v5 00/15] Network support for Landlock - UDP discussion
In-Reply-To: <20220516152038.39594-1-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Regarding future plan to support UDP, it may not be possible to 
efficiently restrict sending on a port or receiving on a port because of 
the non-connnected state of UDP sockets. Indeed, when setting up a 
socket to send a packet on a specified port, we (automatically or 
manually) have a receiving port configured and this socket can be used 
to receive any UDP packet. An UDP socket could be restricted to only 
send/write or to receive/read from a specific port, but this would 
probably not be as useful as the TCP restrictions. That could look like 
RECEIVE_UDP and SEND_UDP access-rights but the LSM implementation would 
be more complex because of the socket/FD tracking. Moreover, the 
performance impact could be more important for every read and write 
syscall (whatever the FD type).

Any opinion?

Regards,
  Mickaël


On 16/05/2022 17:20, Konstantin Meskhidze wrote:
> Hi,
> This is a new V5 patch related to Landlock LSM network confinement.
> It is based on the latest landlock-wip branch on top of v5.18-rc5:
> https://git.kernel.org/pub/scm/linux/kernel/git/mic/linux.git/log/?h=landlock-wip
> 
> It brings refactoring of previous patch version V4.
> Added additional selftests for IP6 network families and network namespace.
> Added TCP sockets confinement support in sandboxer demo.
> 
> All test were run in QEMU evironment and compiled with
>   -static flag.
>   1. network_test: 13/13 tests passed.
>   2. base_test: 7/7 tests passed.
>   3. fs_test: 59/59 tests passed.
>   4. ptrace_test: 8/8 tests passed.
> 
> Still have issue with base_test were compiled without -static flag
> (landlock-wip branch without network support)
> 1. base_test: 6/7 tests passed.
>   Error:
>   #  RUN           global.inconsistent_attr ...
>   # base_test.c:54:inconsistent_attr:Expected ENOMSG (42) == errno (22)
>   # inconsistent_attr: Test terminated by assertion
>   #          FAIL  global.inconsistent_attr
> not ok 1 global.inconsistent_attr
> 
> LCOV - code coverage report:
>              Hit  Total  Coverage
> Lines:      952  1010    94.3 %
> Functions:  79   82      96.3 %
> 
> Previous versions:
> v4: https://lore.kernel.org/linux-security-module/20220309134459.6448-1-konstantin.meskhidze@huawei.com/
> v3: https://lore.kernel.org/linux-security-module/20220124080215.265538-1-konstantin.meskhidze@huawei.com/
> v2: https://lore.kernel.org/linux-security-module/20211228115212.703084-1-konstantin.meskhidze@huawei.com/
> v1: https://lore.kernel.org/linux-security-module/20211210072123.386713-1-konstantin.meskhidze@huawei.com/
> 
> Konstantin Meskhidze (15):
>    landlock: access mask renaming
>    landlock: landlock_find/insert_rule refactoring
>    landlock: merge and inherit function refactoring
>    landlock: helper functions refactoring
>    landlock: landlock_add_rule syscall refactoring
>    landlock: user space API network support
>    landlock: add support network rules
>    landlock: TCP network hooks implementation
>    seltests/landlock: add tests for bind() hooks
>    seltests/landlock: add tests for connect() hooks
>    seltests/landlock: connect() with AF_UNSPEC tests
>    seltests/landlock: rules overlapping test
>    seltests/landlock: ruleset expanding test
>    seltests/landlock: invalid user input data test
>    samples/landlock: adds network demo
> 
>   include/uapi/linux/landlock.h                |  48 +
>   samples/landlock/sandboxer.c                 | 105 ++-
>   security/landlock/Kconfig                    |   1 +
>   security/landlock/Makefile                   |   2 +
>   security/landlock/fs.c                       | 169 +---
>   security/landlock/limits.h                   |   8 +-
>   security/landlock/net.c                      | 159 ++++
>   security/landlock/net.h                      |  25 +
>   security/landlock/ruleset.c                  | 481 ++++++++--
>   security/landlock/ruleset.h                  | 102 +-
>   security/landlock/setup.c                    |   2 +
>   security/landlock/syscalls.c                 | 173 ++--
>   tools/testing/selftests/landlock/base_test.c |   4 +-
>   tools/testing/selftests/landlock/common.h    |   9 +
>   tools/testing/selftests/landlock/config      |   5 +-
>   tools/testing/selftests/landlock/fs_test.c   |  10 -
>   tools/testing/selftests/landlock/net_test.c  | 935 +++++++++++++++++++
>   17 files changed, 1925 insertions(+), 313 deletions(-)
>   create mode 100644 security/landlock/net.c
>   create mode 100644 security/landlock/net.h
>   create mode 100644 tools/testing/selftests/landlock/net_test.c
> 
> --
> 2.25.1
> 
