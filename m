Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 265214D3036
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 14:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbiCINqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 08:46:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbiCINqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 08:46:09 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A05C17B88E;
        Wed,  9 Mar 2022 05:45:08 -0800 (PST)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KDD1M0Y59z6H711;
        Wed,  9 Mar 2022 21:43:35 +0800 (CST)
Received: from mscphispre00059.huawei.com (10.123.71.64) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Wed, 9 Mar 2022 14:45:04 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>, <anton.sirazetdinov@huawei.com>
Subject: [RFC PATCH v4 00/15] Landlock LSM
Date:   Wed, 9 Mar 2022 21:44:44 +0800
Message-ID: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.123.71.64]
X-ClientProxiedBy: mscpeml500001.china.huawei.com (7.188.26.142) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
This is a new V4 bunch of RFC patches related to Landlock LSM network confinement.
It brings deep refactirong and commit splitting of previous version V3.
Also added additional selftests.

This patch series can be applied on top of v5.17-rc3.

All test were run in QEMU evironment and compiled with
 -static flag.
 1. network_test: 9/9 tests passed.
 2. base_test: 8/8 tests passed.
 3. fs_test: 46/46 tests passed.
 4. ptrace_test: 4/8 tests passed.

Tests were also launched for Landlock version without
v4 patch:
 1. base_test: 8/8 tests passed.
 2. fs_test: 46/46 tests passed.
 3. ptrace_test: 4/8 tests passed.

Could not provide test coverage cause had problems with tests
on VM (no -static flag the tests compiling, no v4 patch applied):
1. base_test: 7/8 tests passed.
 Error:
 # Starting 8 tests from 1 test cases.
 #  RUN           global.inconsistent_attr ...
 # base_test.c:51:inconsistent_attr:Expected ENOMSG (42) == errno (22)
 # inconsistent_attr: Test terminated by assertion
2. fs_test: 0 / 46 tests passed
 Error for all tests:
 # common.h:126:no_restriction:Expected -1 (-1) != cap_set_proc(cap_p) (-1)
 # common.h:127:no_restriction:Failed to cap_set_proc: Operation not permitted
 # fs_test.c:106:no_restriction:Expected 0 (0) == mkdir(path, 0700) (-1)
 # fs_test.c:107:no_restriction:Failed to create directory "tmp": File exists
3. ptrace_test: 4 / 8 tests passed.

Previous versions:
v3: https://lore.kernel.org/linux-security-module/20220124080215.265538-1-konstantin.meskhidze@huawei.com/
v2: https://lore.kernel.org/linux-security-module/20211228115212.703084-1-konstantin.meskhidze@huawei.com/
v1: https://lore.kernel.org/linux-security-module/20211210072123.386713-1-konstantin.meskhidze@huawei.com/

Konstantin Meskhidze (15):
  landlock: access mask renaming
  landlock: filesystem access mask helpers
  landlock: landlock_find/insert_rule refactoring
  landlock: merge and inherit function refactoring
  landlock: unmask_layers() function refactoring
  landlock: landlock_add_rule syscall refactoring
  landlock: user space API network support
  landlock: add support network rules
  landlock: TCP network hooks implementation
  seltest/landlock: add tests for bind() hooks
  seltest/landlock: add tests for connect() hooks
  seltest/landlock: connect() with AF_UNSPEC tests
  seltest/landlock: rules overlapping test
  seltest/landlock: ruleset expanding test
  seltest/landlock: invalid user input data test

 include/uapi/linux/landlock.h                 |  48 ++
 security/landlock/Kconfig                     |   1 +
 security/landlock/Makefile                    |   2 +-
 security/landlock/fs.c                        |  72 +-
 security/landlock/limits.h                    |   6 +
 security/landlock/net.c                       | 180 +++++
 security/landlock/net.h                       |  22 +
 security/landlock/ruleset.c                   | 383 ++++++++--
 security/landlock/ruleset.h                   |  72 +-
 security/landlock/setup.c                     |   2 +
 security/landlock/syscalls.c                  | 176 +++--
 .../testing/selftests/landlock/network_test.c | 665 ++++++++++++++++++
 12 files changed, 1434 insertions(+), 195 deletions(-)
 create mode 100644 security/landlock/net.c
 create mode 100644 security/landlock/net.h
 create mode 100644 tools/testing/selftests/landlock/network_test.c

--
2.25.1

