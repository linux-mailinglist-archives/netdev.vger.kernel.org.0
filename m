Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5FBF4A6305
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 18:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233984AbiBARxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 12:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233440AbiBARxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 12:53:19 -0500
Received: from smtp-190f.mail.infomaniak.ch (smtp-190f.mail.infomaniak.ch [IPv6:2001:1600:3:17::190f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CF9C06173B
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 09:53:19 -0800 (PST)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4JpCG46NvFzMqCNQ;
        Tue,  1 Feb 2022 18:53:16 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4JpCG439FbzlhMBQ;
        Tue,  1 Feb 2022 18:53:16 +0100 (CET)
Message-ID: <85450679-51fd-e5ae-b994-74bda3041739@digikod.net>
Date:   Tue, 1 Feb 2022 18:53:18 +0100
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20220124080215.265538-1-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [RFC PATCH 0/2] landlock network implementation cover letter
In-Reply-To: <20220124080215.265538-1-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 24/01/2022 09:02, Konstantin Meskhidze wrote:
> Hi, all!
> 
> This is a new bunch of RFC patches related to Landlock LSM network confinement.
> Here are previous discussions:
> 1. https://lore.kernel.org/linux-security-module/20211210072123.386713-1-konstantin.meskhidze@huawei.com/
> 2. https://lore.kernel.org/linux-security-module/20211228115212.703084-1-konstantin.meskhidze@huawei.com/
> 
> As in previous RFCs, 2 hooks are supported:
>    - hook_socket_bind()
>    - hook_socket_connect()
> 
> Selftest are provided in tools/testing/selftests/landlock/network_test.c;
> Implementation was tested in QEMU invironment with 5.13 kernel version:

Again, you need to base your work on the latest kernel version.


>   1. base_test - passed all tests
>   2. fs_test - passed 44/46 tests. 2 tests related to overlayfs failed.
>      Probably, I have wrong config options for overlayfs.

The minimal required configuration is listed in the "config" file. You 
need to update it for the network tests as well. You missed the 
ptrace_test. To test everything you can run:
fakeroot make -C tools/testing/selftests TARGETS=landlock gen_tar
and then extract 
tools/testing/selftests/kselftest_install/kselftest-packages/kselftest.tar.gz 
and execute run_kselftest.sh on your VM.


>   3. network_test - passed all tests.
>      Please give your suggestions about test cover in network_test.c
> 
> Implementation related issues
> =============================

It is more a changelog than issues. ;)


> 
> 1. Access masks array refactored into 1D one and changed
> to 32 bits. Filesystem masks occupy 16 lower bits and network
> masks reside in 16 upper bits.
> 
>        struct landlock_ruleset {
>              ...
>              ...
>              u32 access_masks[];
>        }
> 
> 2. Refactor API functions in ruleset.c:
>      1. Add (void *)object argument.
>      2. Add u16 rule_type argument.
> 
>    - In filesystem case the "object" is defined by underlying inode.
>    In network case the "object" is defined by a port. There is
>    a union containing either a struct landlock_object pointer or a
>    raw data (here a u16 port):
>      union {
>          struct landlock_object *ptr;
>          uintptr_t data;
>      } object;
> 
>    - Everytime when a rule is inserted it's needed to provide a rule type:
> 
>      landlock_insert_rule(ruleset, (void *)object, access, rule_type)
>        1. A rule_type could be or LANDLOCK_RULE_NET_SERVICE or
>        LANDLOCK_RULE_PATH_BENEATH;
>        2. (void *) object - is either landlock_object *ptr or port value;
> 
> 3. Use two rb_trees in ruleset structure:
>      1. root_inode - for filesystem objects (inodes).
>      2. root_net_port - for network port objects.

Thanks for these explanations!


> 
> Konstantin Meskhidze (2):
>    landlock: TCP network hooks implementation
>    landlock: selftests for bind and connect hooks
> 
>   include/uapi/linux/landlock.h                 |  52 +++
>   security/landlock/Makefile                    |   2 +-
>   security/landlock/fs.c                        |  12 +-
>   security/landlock/limits.h                    |   6 +
>   security/landlock/net.c                       | 175 +++++++++
>   security/landlock/net.h                       |  21 ++
>   security/landlock/ruleset.c                   | 167 ++++++---
>   security/landlock/ruleset.h                   |  40 +-
>   security/landlock/setup.c                     |   3 +
>   security/landlock/syscalls.c                  | 142 ++++---
>   .../testing/selftests/landlock/network_test.c | 346 ++++++++++++++++++
>   11 files changed, 860 insertions(+), 106 deletions(-)
>   create mode 100644 security/landlock/net.c
>   create mode 100644 security/landlock/net.h
>   create mode 100644 tools/testing/selftests/landlock/network_test.c
> 
> --
> 2.25.1
> 
