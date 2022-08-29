Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B36C15A5286
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 19:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbiH2REN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 13:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbiH2REM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 13:04:12 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697809BB4F;
        Mon, 29 Aug 2022 10:04:11 -0700 (PDT)
Received: from fraeml736-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MGcGH4FRvz686pS;
        Tue, 30 Aug 2022 01:03:35 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 fraeml736-chm.china.huawei.com (10.206.15.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 29 Aug 2022 19:04:08 +0200
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 29 Aug 2022 18:04:07 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <hukeping@huawei.com>, <anton.sirazetdinov@huawei.com>
Subject: [PATCH v7 00/18] Network support for Landlock
Date:   Tue, 30 Aug 2022 01:03:43 +0800
Message-ID: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.66.134]
X-ClientProxiedBy: mscpeml100002.china.huawei.com (7.188.26.75) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
This is a new V7 patch related to Landlock LSM network confinement.
It is based on the landlock's -next branch on top of v5.19 kernel version:
https://git.kernel.org/pub/scm/linux/kernel/git/mic/linux.git/log/?h=next

It brings refactoring of previous patch version V6 and based on
Mickaёl's two commits in -tmp-net branch:
https://git.kernel.org/pub/scm/linux/kernel/git/mic/linux.git/commit/?id=8f4104b3dc59e7f110c9b83cdf034d010a2d006f
https://git.kernel.org/pub/scm/linux/kernel/git/mic/linux.git/commit/?id=7d6cf40a6f81adf607ad3cc17aaa11e256beeea4

All test were run in QEMU evironment and compiled with
 -static flag.
 1. network_test: 18/18 tests passed.
 2. base_test: 7/7 tests passed.
 3. fs_test: 61/61 tests passed.
 4. ptrace_test: 8/8 tests passed.

LCOV - code coverage report:
            Hit  Total  Coverage
Lines:      952  1010    94.2 %
Functions:  79   82      96.3 %

Previous versions:
v6: https://lore.kernel.org/linux-security-module/20220621082313.3330667-1-konstantin.meskhidze@huawei.com/
v5: https://lore.kernel.org/linux-security-module/20220516152038.39594-1-konstantin.meskhidze@huawei.com
v4: https://lore.kernel.org/linux-security-module/20220309134459.6448-1-konstantin.meskhidze@huawei.com/
v3: https://lore.kernel.org/linux-security-module/20220124080215.265538-1-konstantin.meskhidze@huawei.com/
v2: https://lore.kernel.org/linux-security-module/20211228115212.703084-1-konstantin.meskhidze@huawei.com/
v1: https://lore.kernel.org/linux-security-module/20211210072123.386713-1-konstantin.meskhidze@huawei.com/

Konstantin Meskhidze (18):
  landlock: rename access mask
  landlock: refactor landlock_find_rule/insert_rule
  landlock: refactor merge/inherit_ruleset functions
  landlock: move helper functions
  landlock: refactor helper functions
  landlock: refactor landlock_add_rule syscall
  landlock: user space API network support
  landlock: add network rules support
  landlock: implement TCP network hooks
  seltests/landlock: move helper function
  seltests/landlock: add tests for bind() hooks
  seltests/landlock: add tests for connect() hooks
  seltests/landlock: add AF_UNSPEC family test
  seltests/landlock: add rules overlapping test
  seltests/landlock: add ruleset expanding test
  seltests/landlock: add invalid input data test
  samples/landlock: add network demo
  landlock: Document Landlock's network support

 Documentation/userspace-api/landlock.rst    |  84 ++-
 include/uapi/linux/landlock.h               |  49 ++
 samples/landlock/sandboxer.c                | 123 ++-
 security/landlock/Kconfig                   |   1 +
 security/landlock/Makefile                  |   2 +
 security/landlock/fs.c                      | 144 +---
 security/landlock/limits.h                  |   7 +-
 security/landlock/net.c                     | 161 ++++
 security/landlock/net.h                     |  26 +
 security/landlock/ruleset.c                 | 369 +++++++--
 security/landlock/ruleset.h                 | 136 +++-
 security/landlock/setup.c                   |   2 +
 security/landlock/syscalls.c                | 168 +++--
 tools/testing/selftests/landlock/common.h   |  10 +
 tools/testing/selftests/landlock/config     |   4 +
 tools/testing/selftests/landlock/fs_test.c  |  10 -
 tools/testing/selftests/landlock/net_test.c | 786 ++++++++++++++++++++
 17 files changed, 1796 insertions(+), 286 deletions(-)
 create mode 100644 security/landlock/net.c
 create mode 100644 security/landlock/net.h
 create mode 100644 tools/testing/selftests/landlock/net_test.c

--
2.25.1

