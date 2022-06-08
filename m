Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE62542EE8
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 13:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237755AbiFHLPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 07:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237552AbiFHLPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 07:15:12 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F1D93A1B1;
        Wed,  8 Jun 2022 04:15:09 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LJ4JY6gJgz6GD5l;
        Wed,  8 Jun 2022 19:10:21 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 8 Jun 2022 13:15:06 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kpsingh@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v2 0/3] bpf: Add bpf_verify_pkcs7_signature() helper
Date:   Wed, 8 Jun 2022 13:12:18 +0200
Message-ID: <20220608111221.373833-1-roberto.sassu@huawei.com>
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
bpf_verify_pkcs7_signature(). It is simply a wrapper of
verify_pkcs7_signature(), and does the signature verification with a key in
the selected keyring (primary, secondary or platform).

Since verify_pkcs7_signature() is doing crypto operations, it must be
called by a sleepable program. This restricts the set of functions that can
call the associated helper (for example, lsm.s/bpf is suitable,
fexit/array_map_update_elem is not).

The added test check the ability of an eBPF program to verify module-style
appended signatures, as produced by the kernel tool sign-file, currently
used to sign kernel modules.

The patch set is organized as follows.

Patch 1 introduces the new helper. Patch 2 adds two new options to
test_progs (the eBPF selftest binary), to specify the path of sign-file and
the file containing the kernel private key and certificate. Finally,
patch 3 adds the test for the new helper.

Roberto Sassu (3):
  bpf: Add bpf_verify_pkcs7_signature() helper
  selftests/bpf: Add test_progs opts for sign-file and kernel priv key +
    cert
  selftests/bpf: Add test for bpf_verify_pkcs7_signature() helper

 include/uapi/linux/bpf.h                      |   8 +
 kernel/bpf/bpf_lsm.c                          |  32 ++++
 tools/include/uapi/linux/bpf.h                |   8 +
 tools/testing/selftests/bpf/config            |   2 +
 .../bpf/prog_tests/verify_pkcs7_sig.c         | 149 ++++++++++++++++++
 .../bpf/progs/test_verify_pkcs7_sig.c         | 127 +++++++++++++++
 tools/testing/selftests/bpf/test_progs.c      |  12 ++
 tools/testing/selftests/bpf/test_progs.h      |   3 +
 8 files changed, 341 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/verify_pkcs7_sig.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_verify_pkcs7_sig.c

-- 
2.25.1

