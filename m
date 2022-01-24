Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A648F4979E8
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 09:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241969AbiAXICW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 03:02:22 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4441 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235469AbiAXICV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 03:02:21 -0500
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jj2S05Kw7z67vQb;
        Mon, 24 Jan 2022 15:58:56 +0800 (CST)
Received: from mscphispre00059.huawei.com (10.123.71.64) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Mon, 24 Jan 2022 09:02:17 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
Subject: [RFC PATCH 0/2] landlock network implementation cover letter
Date:   Mon, 24 Jan 2022 16:02:13 +0800
Message-ID: <20220124080215.265538-1-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.123.71.64]
X-ClientProxiedBy: mscpeml100002.china.huawei.com (7.188.26.75) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, all!

This is a new bunch of RFC patches related to Landlock LSM network confinement.
Here are previous discussions:
1. https://lore.kernel.org/linux-security-module/20211210072123.386713-1-konstantin.meskhidze@huawei.com/
2. https://lore.kernel.org/linux-security-module/20211228115212.703084-1-konstantin.meskhidze@huawei.com/

As in previous RFCs, 2 hooks are supported:
  - hook_socket_bind()
  - hook_socket_connect()

Selftest are provided in tools/testing/selftests/landlock/network_test.c;
Implementation was tested in QEMU invironment with 5.13 kernel version:
 1. base_test - passed all tests
 2. fs_test - passed 44/46 tests. 2 tests related to overlayfs failed.
    Probably, I have wrong config options for overlayfs.
 3. network_test - passed all tests.
    Please give your suggestions about test cover in network_test.c

Implementation related issues
=============================

1. Access masks array refactored into 1D one and changed
to 32 bits. Filesystem masks occupy 16 lower bits and network
masks reside in 16 upper bits.

      struct landlock_ruleset {
            ...
            ...
            u32 access_masks[];
      }

2. Refactor API functions in ruleset.c:
    1. Add (void *)object argument.
    2. Add u16 rule_type argument.

  - In filesystem case the "object" is defined by underlying inode.
  In network case the "object" is defined by a port. There is
  a union containing either a struct landlock_object pointer or a
  raw data (here a u16 port):
    union {
        struct landlock_object *ptr;
        uintptr_t data;
    } object;

  - Everytime when a rule is inserted it's needed to provide a rule type:

    landlock_insert_rule(ruleset, (void *)object, access, rule_type)
      1. A rule_type could be or LANDLOCK_RULE_NET_SERVICE or
      LANDLOCK_RULE_PATH_BENEATH;
      2. (void *) object - is either landlock_object *ptr or port value;

3. Use two rb_trees in ruleset structure:
    1. root_inode - for filesystem objects (inodes).
    2. root_net_port - for network port objects.

Konstantin Meskhidze (2):
  landlock: TCP network hooks implementation
  landlock: selftests for bind and connect hooks

 include/uapi/linux/landlock.h                 |  52 +++
 security/landlock/Makefile                    |   2 +-
 security/landlock/fs.c                        |  12 +-
 security/landlock/limits.h                    |   6 +
 security/landlock/net.c                       | 175 +++++++++
 security/landlock/net.h                       |  21 ++
 security/landlock/ruleset.c                   | 167 ++++++---
 security/landlock/ruleset.h                   |  40 +-
 security/landlock/setup.c                     |   3 +
 security/landlock/syscalls.c                  | 142 ++++---
 .../testing/selftests/landlock/network_test.c | 346 ++++++++++++++++++
 11 files changed, 860 insertions(+), 106 deletions(-)
 create mode 100644 security/landlock/net.c
 create mode 100644 security/landlock/net.h
 create mode 100644 tools/testing/selftests/landlock/network_test.c

--
2.25.1

