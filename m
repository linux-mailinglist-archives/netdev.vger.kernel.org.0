Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50279528870
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 17:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245180AbiEPPUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 11:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236991AbiEPPUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 11:20:50 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E653982E;
        Mon, 16 May 2022 08:20:47 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4L22y20L92z6H7Nm;
        Mon, 16 May 2022 23:20:42 +0800 (CST)
Received: from mscphispre00059.huawei.com (10.123.71.64) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Mon, 16 May 2022 17:20:44 +0200
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <anton.sirazetdinov@huawei.com>
Subject: [PATCH v5 00/15] Network support for Landlock
Date:   Mon, 16 May 2022 23:20:23 +0800
Message-ID: <20220516152038.39594-1-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.123.71.64]
X-ClientProxiedBy: mscpeml500001.china.huawei.com (7.188.26.142) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
This is a new V5 patch related to Landlock LSM network confinement.
It is based on the latest landlock-wip branch on top of v5.18-rc5:
https://git.kernel.org/pub/scm/linux/kernel/git/mic/linux.git/log/?h=landlock-wip

It brings refactoring of previous patch version V4.
Added additional selftests for IP6 network families and network namespace.
Added TCP sockets confinement support in sandboxer demo.

All test were run in QEMU evironment and compiled with
 -static flag.
 1. network_test: 13/13 tests passed.
 2. base_test: 7/7 tests passed.
 3. fs_test: 59/59 tests passed.
 4. ptrace_test: 8/8 tests passed.

Still have issue with base_test were compiled without -static flag
(landlock-wip branch without network support)
1. base_test: 6/7 tests passed.
 Error:
 #  RUN           global.inconsistent_attr ...
 # base_test.c:54:inconsistent_attr:Expected ENOMSG (42) == errno (22)
 # inconsistent_attr: Test terminated by assertion
 #          FAIL  global.inconsistent_attr
not ok 1 global.inconsistent_attr

LCOV - code coverage report:
            Hit  Total  Coverage
Lines:      952  1010    94.3 %
Functions:  79   82      96.3 %

Previous versions:
v4: https://lore.kernel.org/linux-security-module/20220309134459.6448-1-konstantin.meskhidze@huawei.com/
v3: https://lore.kernel.org/linux-security-module/20220124080215.265538-1-konstantin.meskhidze@huawei.com/
v2: https://lore.kernel.org/linux-security-module/20211228115212.703084-1-konstantin.meskhidze@huawei.com/
v1: https://lore.kernel.org/linux-security-module/20211210072123.386713-1-konstantin.meskhidze@huawei.com/

Konstantin Meskhidze (15):
  landlock: access mask renaming
  landlock: landlock_find/insert_rule refactoring
  landlock: merge and inherit function refactoring
  landlock: helper functions refactoring
  landlock: landlock_add_rule syscall refactoring
  landlock: user space API network support
  landlock: add support network rules
  landlock: TCP network hooks implementation
  seltests/landlock: add tests for bind() hooks
  seltests/landlock: add tests for connect() hooks
  seltests/landlock: connect() with AF_UNSPEC tests
  seltests/landlock: rules overlapping test
  seltests/landlock: ruleset expanding test
  seltests/landlock: invalid user input data test
  samples/landlock: adds network demo

 include/uapi/linux/landlock.h                |  48 +
 samples/landlock/sandboxer.c                 | 105 ++-
 security/landlock/Kconfig                    |   1 +
 security/landlock/Makefile                   |   2 +
 security/landlock/fs.c                       | 169 +---
 security/landlock/limits.h                   |   8 +-
 security/landlock/net.c                      | 159 ++++
 security/landlock/net.h                      |  25 +
 security/landlock/ruleset.c                  | 481 ++++++++--
 security/landlock/ruleset.h                  | 102 +-
 security/landlock/setup.c                    |   2 +
 security/landlock/syscalls.c                 | 173 ++--
 tools/testing/selftests/landlock/base_test.c |   4 +-
 tools/testing/selftests/landlock/common.h    |   9 +
 tools/testing/selftests/landlock/config      |   5 +-
 tools/testing/selftests/landlock/fs_test.c   |  10 -
 tools/testing/selftests/landlock/net_test.c  | 935 +++++++++++++++++++
 17 files changed, 1925 insertions(+), 313 deletions(-)
 create mode 100644 security/landlock/net.c
 create mode 100644 security/landlock/net.h
 create mode 100644 tools/testing/selftests/landlock/net_test.c

--
2.25.1

