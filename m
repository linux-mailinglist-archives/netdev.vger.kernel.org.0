Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728285467FD
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 16:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344471AbiFJOB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 10:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349985AbiFJN7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 09:59:38 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6FDF1F5E24;
        Fri, 10 Jun 2022 06:59:32 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LKMtf5cfmz67NMW;
        Fri, 10 Jun 2022 21:55:54 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 10 Jun 2022 15:59:29 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kpsingh@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v3 0/2] bpf: Add bpf_verify_signature() helper
Date:   Fri, 10 Jun 2022 15:59:14 +0200
Message-ID: <20220610135916.1285509-1-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml753-chm.china.huawei.com (10.201.108.203) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One of the desirable features in security is the ability to restrict import
of data to a given system based on data authenticity. If data import can be
restricted, it would be possible to enforce a system-wide policy based on
the signing keys the system owner trusts.

This feature is widely used in the kernel. For example, if the restriction
is enabled, kernel modules can be plugged in only if they are signed with a
key whose public part is in the primary or secondary keyring.

For eBPF, it can be useful as well. For example, it might be useful to
authenticate data an eBPF program makes security decisions on.

After a discussion in the eBPF mailing list, it was decided that the stated
goal should be accomplished by introducing a new helper:
bpf_verify_signature(). Its job is simply to call the signature verification
function corresponding to the passed signature type, with the keyring selected
through the passed keyring identifier.

Since verify_pkcs7_signature() is doing crypto operations, it must be
called by a sleepable program. This restricts the set of functions that can
call the associated helper (for example, lsm.s/bpf is suitable,
fexit/array_map_update_elem is not).

The added test checks the ability of an eBPF program to verify module-style
appended signatures, as produced by the kernel tool sign-file, currently
used to sign kernel modules.

The patch set is organized as follows.

Patch 1 introduces the new helper. Patch 2 adds the test for the new
helper.

Changelog

v1:
 - Don't define new map flag but introduce simple wrapper of
   verify_pkcs7_signature() (suggested by Alexei and KP)

v2:
 - Rename bpf_verify_pkcs7_signature() to a more generic
   bpf_verify_signature() and pass the signature type (suggested by KP)
 - Move the helper and prototype declaration under #ifdef so that user
   space can probe for support for the helper (suggested by Daniel)
 - Describe better the keyring types (suggested by Daniel)
 - Include linux/bpf.h instead of vmlinux.h to avoid implicit or
   redeclaration
 - Make the test selfcontained (suggested by Alexei)

Roberto Sassu (2):
  bpf: Add bpf_verify_signature() helper
  selftests/bpf: Add test for bpf_verify_signature() helper

 include/uapi/linux/bpf.h                      |  17 ++
 kernel/bpf/bpf_lsm.c                          |  46 ++++
 tools/include/uapi/linux/bpf.h                |  17 ++
 tools/testing/selftests/bpf/Makefile          |  11 +-
 tools/testing/selftests/bpf/config            |   1 +
 .../selftests/bpf/prog_tests/verify_sig.c     | 200 ++++++++++++++++++
 .../selftests/bpf/progs/test_verify_sig.c     | 160 ++++++++++++++
 .../testing/selftests/bpf/verify_sig_setup.sh | 100 +++++++++
 8 files changed, 549 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/verify_sig.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_verify_sig.c
 create mode 100755 tools/testing/selftests/bpf/verify_sig_setup.sh

-- 
2.25.1

