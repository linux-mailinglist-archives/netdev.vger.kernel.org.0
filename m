Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8999154AF99
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 13:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347418AbiFNLyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 07:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240950AbiFNLym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 07:54:42 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEDE337A18;
        Tue, 14 Jun 2022 04:54:41 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LMn0r29Wqz6801v;
        Tue, 14 Jun 2022 19:54:36 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 14 Jun 2022 13:54:38 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kpsingh@kernel.org>, <john.fastabend@gmail.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v4 0/4] bpf: Add bpf_verify_pkcs7_signature() helper
Date:   Tue, 14 Jun 2022 13:54:16 +0200
Message-ID: <20220614115420.1964686-1-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
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
bpf_verify_pkcs7_signature(), dedicated to verify PKCS#7 signatures. More
helpers will be introduced later, as necessary.

The job of bpf_verify_pkcs7_signature() is simply to call the corresponding
signature verification function verify_pkcs7_signature(). Data and
signature can be provided to the new helper with two dynamic pointers, to
reduce the number of parameters. The keyring containing the signature
verification key can be obtained with a new helper
called bpf_request_key_by_id().

For now, keyrings can be obtained with an identifier defined in
verification.h (except for the special value ULONG_MAX, used for testing).
In the future, keyring can be searched also by their description. This
functionality has not been included here in this patch set, as would
require additional care for decrementing the reference count of the
keyring. It could be added later.

While bpf_request_key_by_id() can be called from any program,
bpf_verify_pkcs7_signature(), instead, must be called by a sleepable
program, as it is doing crypto operations. For the latter, for example,
lsm.s/bpf is suitable, fexit/array_map_update_elem is not.

The added test, which invokes both helpers, checks the ability of an eBPF
program to verify module-style appended signatures, as produced by the
kernel tool sign-file, currently used to sign kernel modules.

The patch set is organized as follows.

Patch 1 exports bpf_dynptr_get_size(), to obtain the real size of data
carried by a dynamic pointer. Patch 2 introduces the
bpf_request_key_by_id() helper. Patch 3 introduces the
bpf_verify_pkcs7_signature() helper. Finally, patch 4 adds a test for both
helpers.

Changelog

v3:
 - Rename bpf_verify_signature() back to bpf_verify_pkcs7_signature() to
   avoid managing different parameters for each signature verification
   function in one helper (suggested by Daniel)
 - Use dynamic pointers and export bpf_dynptr_get_size() (suggested by
   Alexei)
 - Introduce bpf_request_key_by_id() to give more flexibility to the caller
   of bpf_verify_pkcs7_signature() to retrieve the appropriate keyring
   (suggested by Alexei)
 - Fix test by reordering the gcc command line, always compile sign-file
 - Improve helper support check mechanism in the test

v2:
 - Rename bpf_verify_pkcs7_signature() to a more generic
   bpf_verify_signature() and pass the signature type (suggested by KP)
 - Move the helper and prototype declaration under #ifdef so that user
   space can probe for support for the helper (suggested by Daniel)
 - Describe better the keyring types (suggested by Daniel)
 - Include linux/bpf.h instead of vmlinux.h to avoid implicit or
   redeclaration
 - Make the test selfcontained (suggested by Alexei)

v1:
 - Don't define new map flag but introduce simple wrapper of
   verify_pkcs7_signature() (suggested by Alexei and KP)

Roberto Sassu (4):
  bpf: Export bpf_dynptr_get_size()
  bpf: Add bpf_request_key_by_id() helper
  bpf: Add bpf_verify_pkcs7_signature() helper
  selftests/bpf: Add test for bpf_verify_pkcs7_signature() helper

 include/linux/bpf.h                           |   1 +
 include/uapi/linux/bpf.h                      |  25 ++
 kernel/bpf/bpf_lsm.c                          |  60 +++++
 kernel/bpf/helpers.c                          |   2 +-
 scripts/bpf_doc.py                            |   2 +
 tools/include/uapi/linux/bpf.h                |  25 ++
 tools/testing/selftests/bpf/Makefile          |  14 +-
 tools/testing/selftests/bpf/config            |   2 +
 .../bpf/prog_tests/verify_pkcs7_sig.c         | 217 ++++++++++++++++++
 .../bpf/progs/test_verify_pkcs7_sig.c         | 168 ++++++++++++++
 .../testing/selftests/bpf/verify_sig_setup.sh | 100 ++++++++
 11 files changed, 612 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/verify_pkcs7_sig.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_verify_pkcs7_sig.c
 create mode 100755 tools/testing/selftests/bpf/verify_sig_setup.sh

-- 
2.25.1

