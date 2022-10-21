Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1742C607A74
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 17:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbiJUP0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 11:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJUP0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 11:26:53 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FDD16EA39;
        Fri, 21 Oct 2022 08:26:52 -0700 (PDT)
Received: from frapeml500002.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Mv7Z75xFXz6H74v;
        Fri, 21 Oct 2022 23:25:03 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 frapeml500002.china.huawei.com (7.182.85.205) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 21 Oct 2022 17:26:51 +0200
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 21 Oct 2022 16:26:50 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <artem.kuzin@huawei.com>
Subject: [PATCH v8 00/12] Network support for Landlock
Date:   Fri, 21 Oct 2022 23:26:32 +0800
Message-ID: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.66.134]
X-ClientProxiedBy: mscpeml100002.china.huawei.com (7.188.26.75) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
This is a new V8 patch related to Landlock LSM network confinement.
It is based on the landlock's -next branch on top of v6.1-rc1 kernel version:
https://git.kernel.org/pub/scm/linux/kernel/git/mic/linux.git/log/?h=next

It brings refactoring of previous patch version V7.
Mostly there are minor fixes of logic and typos.

All test were run in QEMU evironment and compiled with
 -static flag.
 1. network_test: 18/18 tests passed.
 2. base_test: 7/7 tests passed.
 3. fs_test: 78/78 tests passed.
 4. ptrace_test: 8/8 tests passed.

Previous versions:
v7: https://lore.kernel.org/linux-security-module/20220829170401.834298-1-konstantin.meskhidze@huawei.com/
v6: https://lore.kernel.org/linux-security-module/20220621082313.3330667-1-konstantin.meskhidze@huawei.com/
v5: https://lore.kernel.org/linux-security-module/20220516152038.39594-1-konstantin.meskhidze@huawei.com
v4: https://lore.kernel.org/linux-security-module/20220309134459.6448-1-konstantin.meskhidze@huawei.com/
v3: https://lore.kernel.org/linux-security-module/20220124080215.265538-1-konstantin.meskhidze@huawei.com/
v2: https://lore.kernel.org/linux-security-module/20211228115212.703084-1-konstantin.meskhidze@huawei.com/
v1: https://lore.kernel.org/linux-security-module/20211210072123.386713-1-konstantin.meskhidze@huawei.com/

Konstantin Meskhidze (12):
  landlock: Make ruleset's access masks more generic
  landlock: Refactor landlock_find_rule/insert_rule
  landlock: Refactor merge/inherit_ruleset functions
  landlock: Move unmask_layers() and init_layer_masks()
  landlock: Refactor unmask_layers() and init_layer_masks()
  landlock: Refactor landlock_add_rule() syscall
  landlock: Add network rules support
  landlock: Implement TCP network hooks
  selftests/landlock: Share enforce_ruleset()
  selftests/landlock: Add 10 new test suites dedicated to network
  samples/landlock: Add network demo
  landlock: Document Landlock's network support

 Documentation/userspace-api/landlock.rst     |  72 +-
 include/uapi/linux/landlock.h                |  49 ++
 samples/landlock/sandboxer.c                 | 129 ++-
 security/landlock/Kconfig                    |   1 +
 security/landlock/Makefile                   |   2 +
 security/landlock/fs.c                       | 168 +---
 security/landlock/limits.h                   |   7 +-
 security/landlock/net.c                      | 164 ++++
 security/landlock/net.h                      |  26 +
 security/landlock/ruleset.c                  | 412 ++++++++--
 security/landlock/ruleset.h                  | 176 +++-
 security/landlock/setup.c                    |   2 +
 security/landlock/syscalls.c                 | 163 ++--
 tools/testing/selftests/landlock/base_test.c |   2 +-
 tools/testing/selftests/landlock/common.h    |  10 +
 tools/testing/selftests/landlock/config      |   4 +
 tools/testing/selftests/landlock/fs_test.c   |  75 +-
 tools/testing/selftests/landlock/net_test.c  | 823 +++++++++++++++++++
 18 files changed, 1972 insertions(+), 313 deletions(-)
 create mode 100644 security/landlock/net.c
 create mode 100644 security/landlock/net.h
 create mode 100644 tools/testing/selftests/landlock/net_test.c

--
2.25.1

