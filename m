Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB357572315
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 20:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234173AbiGLSnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 14:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233884AbiGLSmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 14:42:32 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966E0D6CE0;
        Tue, 12 Jul 2022 11:41:45 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Lj8cd2YRDz67M3B;
        Wed, 13 Jul 2022 02:37:21 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 12 Jul 2022 20:41:41 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <kpsingh@kernel.org>, <dhowells@redhat.com>, <jarkko@kernel.org>,
        <shuah@kernel.org>
CC:     <bpf@vger.kernel.org>, <keyrings@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v7 0/7] bpf: Add bpf_verify_pkcs7_signature() helper
Date:   Tue, 12 Jul 2022 20:41:21 +0200
Message-ID: <20220712184128.999301-1-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
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
bpf_verify_pkcs7_signature(), dedicated to verify PKCS#7 signatures.

Other than the data and the signature, the helper also receives two
parameters for the keyring, which can be provided as alternatives: one is a
key pointer returned by the new bpf_lookup_user_key() helper, called with a
key serial possibly decided by the user; another is a pre-determined ID
among values defined in include/linux/verification.h.

While the first keyring-related parameter provides great flexibility, it
seems suboptimal in terms of security guarantees, as even if the eBPF
program is assumed to be trusted, the serial used to obtain the key pointer
might come from untrusted user space not choosing one that the system
administrator approves to enforce a mandatory policy.

The second keyring-related parameter instead provides much stronger
guarantees, especially if the pre-determined ID is not passed by user space
but is hardcoded in the eBPF program, and that program is signed. In this
case, bpf_verify_pkcs7_signature() will always perform signature
verification with a key that the system administrator approves, i.e. the
primary, secondary or platform keyring.

bpf_lookup_user_key() comes with the corresponding release helper
bpf_key_put(), to decrement the reference count of the key found with the
former helper. The eBPF verifier has been enhanced to ensure that the
release helper is always called whenever the acquire helper is called, or
otherwise refuses to load the program.

bpf_lookup_user_key() also accepts lookup-specific flags KEY_LOOKUP_CREATE
and KEY_LOOKUP_PARTIAL. Although these are most likely not useful for the
bpf_verify_pkcs7_signature(), newly defined flags could be.

bpf_lookup_user_key() does not request a particular permission to
lookup_user_key(), as it cannot determine it by itself. Also, it should not
get it from the user, as the user could pass an arbitrary value and use the
key for a different purpose. Instead, bpf_lookup_user_key() requests
KEY_DEFER_PERM_CHECK, and defers the permission check to the helper that
actually uses the key, in this patch set to bpf_verify_pkcs7_signature().

Since key_task_permission() is called by the PKCS#7 code during signature
verification, the only additional function bpf_verify_pkcs7_signature() has
to call is key_validate(). With that, the permission check can be
considered complete and equivalent, as it was done by bpf_lookup_user_key()
with the appropriate permission (in this case KEY_NEED_SEARCH).

All helpers can be called only from sleepable programs, because of memory
allocation (with lookup flag KEY_LOOKUP_CREATE) and crypto operations. For
example, the lsm.s/bpf attach point is suitable,
fexit/array_map_update_elem is not.

The correctness of implementation of the new helpers and of their usage is
checked with the introduced tests.

The patch set is organized as follows.

Patch 1 exports bpf_dynptr_get_size(), to obtain the real size of data
carried by a dynamic pointer. Patch 2 makes available for new eBPF helpers
some key-related definitions. Patch 3 introduces the bpf_lookup_user_key()
and bpf_key_put() helpers. Patch 4 introduces the
bpf_verify_pkcs7_signature(). Finally, patches 5-7 introduce the tests.

Changelog

v6:
 - Switch back to key lookup helpers + signature verification (until v5),
   and defer permission check from bpf_lookup_user_key() to
   bpf_verify_pkcs7_signature()
 - Add additional key lookup test to illustrate the usage of the
   KEY_LOOKUP_CREATE flag and validate the flags (suggested by Daniel)
 - Make description of flags of bpf_lookup_user_key() more user-friendly
   (suggested by Daniel)
 - Fix validation of flags parameter in bpf_lookup_user_key() (reported by
   Daniel)
 - Rename bpf_verify_pkcs7_signature() keyring-related parameters to
   user_keyring and system_keyring to make their purpose more clear
 - Accept keyring-related parameters of bpf_verify_pkcs7_signature() as
   alternatives (suggested by KP)
 - Replace unsigned long type with u64 in helper declaration (suggested by
   Daniel)
 - Extend the bpf_verify_pkcs7_signature() test by calling the helper
   without data, by ensuring that the helper enforces the keyring-related
   parameters as alternatives, by ensuring that the helper rejects
   inaccessible and expired keyrings, and by checking all system keyrings
 - Move bpf_lookup_user_key() and bpf_key_put() usage tests to
   ref_tracking.c (suggested by John)
 - Call bpf_lookup_user_key() and bpf_key_put() only in sleepable programs

v5:
 - Move KEY_LOOKUP_ to include/linux/key.h
   for validation of bpf_verify_pkcs7_signature() parameter
 - Remove bpf_lookup_user_key() and bpf_key_put() helpers, and the
   corresponding tests
 - Replace struct key parameter of bpf_verify_pkcs7_signature() with the
   keyring serial and lookup flags
 - Call lookup_user_key() and key_put() in bpf_verify_pkcs7_signature()
   code, to ensure that the retrieved key is used according to the
   permission requested at lookup time
 - Clarified keyring precedence in the description of
   bpf_verify_pkcs7_signature() (suggested by John)
 - Remove newline in the second argument of ASSERT_
 - Fix helper prototype regular expression in bpf_doc.py

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

Roberto Sassu (7):
  bpf: Export bpf_dynptr_get_size()
  KEYS: Move KEY_LOOKUP_ to include/linux/key.h
  bpf: Add bpf_lookup_user_key() and bpf_key_put() helpers
  bpf: Add bpf_verify_pkcs7_signature() helper
  selftests: Add verifier tests for bpf_lookup_user_key() and
    bpf_key_put()
  selftests/bpf: Add additional test for bpf_lookup_user_key()
  selftests/bpf: Add test for bpf_verify_pkcs7_signature() helper

 include/linux/bpf.h                           |   1 +
 include/linux/key.h                           |   3 +
 include/uapi/linux/bpf.h                      |  47 ++
 kernel/bpf/bpf_lsm.c                          | 116 +++++
 kernel/bpf/helpers.c                          |   2 +-
 kernel/bpf/verifier.c                         |   6 +-
 scripts/bpf_doc.py                            |   2 +
 security/keys/internal.h                      |   2 -
 tools/include/uapi/linux/bpf.h                |  47 ++
 tools/testing/selftests/bpf/Makefile          |  14 +-
 tools/testing/selftests/bpf/config            |   2 +
 .../bpf/prog_tests/lookup_user_key.c          |  94 ++++
 .../bpf/prog_tests/verify_pkcs7_sig.c         | 410 ++++++++++++++++++
 .../bpf/progs/test_lookup_user_key.c          |  35 ++
 .../bpf/progs/test_verify_pkcs7_sig.c         |  90 ++++
 tools/testing/selftests/bpf/test_verifier.c   |   3 +-
 .../selftests/bpf/verifier/ref_tracking.c     |  66 +++
 .../testing/selftests/bpf/verify_sig_setup.sh | 104 +++++
 18 files changed, 1035 insertions(+), 9 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/lookup_user_key.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/verify_pkcs7_sig.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_lookup_user_key.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_verify_pkcs7_sig.c
 create mode 100755 tools/testing/selftests/bpf/verify_sig_setup.sh

-- 
2.25.1

