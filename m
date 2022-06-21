Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8665537F6
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 18:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352282AbiFUQi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 12:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232900AbiFUQi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 12:38:56 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B32418358;
        Tue, 21 Jun 2022 09:38:53 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LSBxL5x72z6H6t4;
        Wed, 22 Jun 2022 00:36:54 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 21 Jun 2022 18:38:49 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kpsingh@kernel.org>, <john.fastabend@gmail.com>,
        <songliubraving@fb.com>, <kafai@fb.com>, <yhs@fb.com>
CC:     <dhowells@redhat.com>, <keyrings@vger.kernel.org>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v5 0/5] bpf: Add bpf_verify_pkcs7_signature() helper
Date:   Tue, 21 Jun 2022 18:37:52 +0200
Message-ID: <20220621163757.760304-1-roberto.sassu@huawei.com>
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
reduce the number of parameters.

The keyring can be provided from its serial number, with the new helper
bpf_lookup_user_key(). Since it acquires a reference of the found key, the
corresponding release helper bpf_key_put() has been introduced to decrement
the reference count. The eBPF verifier has been enhanced to ensure that the
key reference count is always decreased, when incremented, or otherwise it
refuses to load the program. This ability is being verified with the
lookup_user_key_norelease test.

While the new helpers provide great flexibility, they seem to be suboptimal
in terms of security guarantees. If the goal is to do signature
verification with system-provided keys (e.g. from the built-in keyring),
the eBPF program would have to rely on the user space counterpart to search
the correct keyring and to pass its serial. If only the eBPF program is
signed and verified, there is not certainty that this operation is done
correctly by unverified code.

Instead, since verify_pkcs7_signature() understands a pre-determined set of
struct key pointer values, which translates into the corresponding system
keyrings, the keyring ID parameter has been added as well to the eBPF
helper. It is considered only if the passed struct key pointer is NULL.
That would guaranteed, assuming that the keyring ID is hardcoded, that
signature verification is always done with the desired keys.

The introduced helpers can be called only from sleepable programs, because
of memory allocation (with key flag KEY_LOOKUP_CREATE) and crypto
operations. For example, the lsm.s/bpf attach point is suitable,
fexit/array_map_update_elem is not.

A test was added to check the ability of bpf_verify_pkcs7_signature() to
verify PKCS#7 signatures from the session keyring, a newly-created keyring,
and from the secondary keyring (taking an existing kernel module for the
verification). The test does not fail if a suitable kernel module is not
found (needs support from the CI).

The patch set is organized as follows.

Patch 1 exports bpf_dynptr_get_size(), to obtain the real size of data
carried by a dynamic pointer. Patch 2 introduces the
bpf_lookup_user_key() and bpf_key_put() helpers. Patch 3 introduces the
bpf_verify_pkcs7_signature() helper. Patches 4 and 5 respectively add the
test for the first and the last helper.

Changelog

v4:
 - Remove bpf_request_key_by_id(), don't return an invalid pointer that
   other helpers can use
 - Pass the keyring ID (without ULONG_MAX, suggested by Alexei) to
   bpf_verify_pkcs7_signature()
 - Introduce bpf_lookup_user_key() and bpf_key_put() helpers (suggested by
   Alexei)
 - Add lookup_key_norelease test, to ensure that the verifier blocks eBPF
   programs which don't decrement the key reference count
 - Parse raw PKCS#7 signature instead of module-style signature in the
   verify_pkcs7_signature test (suggested by Alexei)
 - Parse kernel module in user space and pass raw PKCS#7 signature to the
   eBPF program for signature verification

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

Roberto Sassu (5):
  bpf: Export bpf_dynptr_get_size()
  bpf: Add bpf_lookup_user_key() and bpf_key_put() helpers
  bpf: Add bpf_verify_pkcs7_signature() helper
  selftests/bpf: Add test for unreleased key references
  selftests/bpf: Add test for bpf_verify_pkcs7_signature() helper

 include/linux/bpf.h                           |   1 +
 include/uapi/linux/bpf.h                      |  33 ++
 kernel/bpf/bpf_lsm.c                          |  85 +++++
 kernel/bpf/helpers.c                          |   2 +-
 kernel/bpf/verifier.c                         |   6 +-
 scripts/bpf_doc.py                            |   2 +
 tools/include/uapi/linux/bpf.h                |  33 ++
 tools/testing/selftests/bpf/Makefile          |  14 +-
 tools/testing/selftests/bpf/config            |   2 +
 .../prog_tests/lookup_user_key_norelease.c    |  52 +++
 .../bpf/prog_tests/verify_pkcs7_sig.c         | 341 ++++++++++++++++++
 .../progs/test_lookup_user_key_norelease.c    |  24 ++
 .../bpf/progs/test_verify_pkcs7_sig.c         |  90 +++++
 .../testing/selftests/bpf/verify_sig_setup.sh | 104 ++++++
 14 files changed, 783 insertions(+), 6 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/lookup_user_key_norelease.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/verify_pkcs7_sig.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_lookup_user_key_norelease.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_verify_pkcs7_sig.c
 create mode 100755 tools/testing/selftests/bpf/verify_sig_setup.sh

-- 
2.25.1

