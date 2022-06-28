Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCF9D55D370
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345767AbiF1M2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 08:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345715AbiF1M2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 08:28:18 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46392DFB2;
        Tue, 28 Jun 2022 05:28:07 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LXP0M4Xn1z67LMV;
        Tue, 28 Jun 2022 20:24:03 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 28 Jun 2022 14:28:04 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kpsingh@kernel.org>, <john.fastabend@gmail.com>,
        <songliubraving@fb.com>, <kafai@fb.com>, <yhs@fb.com>,
        <dhowells@redhat.com>
CC:     <keyrings@vger.kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v6 0/5] bpf: Add bpf_verify_pkcs7_signature() helper
Date:   Tue, 28 Jun 2022 14:27:45 +0200
Message-ID: <20220628122750.1895107-1-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml751-chm.china.huawei.com (10.201.108.201) To
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

The job of bpf_verify_pkcs7_signature() is to retrieve the trusted keyring 
from function parameters, and to perform signature verification by calling
verify_pkcs7_signature().

Data and signature can be provided to the new helper with two dynamic
pointers, to reduce the number of parameters. The keyring can be provided
by its serial, or by its special ID defined in verification.h, if the
serial is zero (not a valid value). bpf_verify_pkcs7_signature() also
accepts key lookup-specific flags, passed to lookup_user_key() when the
helper searches the keyring by its serial.

While passing the keyring serial to bpf_verify_pkcs7_signature() provides
great flexibility, it seems suboptimal in terms of security guarantees, as
even if the eBPF program is assumed to be trusted, that serial might come
from untrusted user space not choosing one that the system administrator
approves to enforce a mandatory policy. The same goal could be instead more
easily achieved by setting a hardcoded keyring ID in the signed eBPF
program, to be passed to bpf_verify_pkcs7_signature().

bpf_verify_pkcs7_signature() can be called only from sleepable programs,
because of memory allocation (with lookup flag KEY_LOOKUP_CREATE) and
crypto operations. For example, the lsm.s/bpf attach point is suitable,
fexit/array_map_update_elem is not.

A test was added to check the ability of bpf_verify_pkcs7_signature() to
verify PKCS#7 signatures from the session keyring, a newly-created keyring,
and from the primary and secondary keyring (taking the tcp_bic.ko kernel
module for the verification). The test does not fail if that kernel module
is not found (needs support from the CI).

A consideration was made on whether bpf_verify_pkcs7_signature() should be
a simple wrapper, doing as little as possible, or whether it could have
more complex logic. Having a simple and flexible wrapper requires two
additional helpers, bpf_lookup_user_key() and bpf_key_put(), to search and
acquire a key reference, pass that key to the wrapper, and release the
reference. More care is also required on the eBPF verifier side, to ensure
that an eBPF program always releases an acquired reference.

While that gives eBPF developers the greatest flexibility to use the
helpers as necessary, it does not match the security of the solution of
retrieving the key and using it within the same function, as for example in
security/keys/keyctl.c. The risk is that an eBPF program requests a key for
a purpose, and then uses the key in a different way with one of the
available key-related helpers (to be added in the future).

struct key is not like a file descriptor, carrying permissions requested
during an open, that can be revalidated at the time a read or write is
performed. It is more close to a struct inode, the function using the key
cannot know reliably which permission was requested at lookup time.

For that reason, the key lookup and usage cannot be separated, as the
kernel will guarantee (also to other MAC mechanisms) that once a key has
been requested with a specific purpose, it will be used accordingly, beyond
the control of eBFP programs.

The patch set is organized as follows.

Patch 1 exports bpf_dynptr_get_size(), to obtain the real size of data
carried by a dynamic pointer. Patch 2 makes available for new eBPF helpers
some key-related definitions. Patch 3 fixes the helper prototype regular
expression to accept unsigned as type prefix. Patch 4 introduces the
bpf_verify_pkcs7_signature() helper and patch 5 adds the corresponding
test.

Changelog

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

Roberto Sassu (5):
  bpf: Export bpf_dynptr_get_size()
  KEYS: Move KEY_LOOKUP_ to include/linux/key.h
  scripts: Handle unsigned type prefix in bpf_doc.py
  bpf: Add bpf_verify_pkcs7_signature() helper
  selftests/bpf: Add test for bpf_verify_pkcs7_signature() helper

 include/linux/bpf.h                           |   1 +
 include/linux/key.h                           |   3 +
 include/uapi/linux/bpf.h                      |  24 ++
 kernel/bpf/bpf_lsm.c                          |  63 +++
 kernel/bpf/helpers.c                          |   2 +-
 scripts/bpf_doc.py                            |   2 +-
 security/keys/internal.h                      |   2 -
 tools/include/uapi/linux/bpf.h                |  24 ++
 tools/testing/selftests/bpf/Makefile          |  14 +-
 tools/testing/selftests/bpf/config            |   2 +
 .../bpf/prog_tests/verify_pkcs7_sig.c         | 359 ++++++++++++++++++
 .../bpf/progs/test_verify_pkcs7_sig.c         |  79 ++++
 .../testing/selftests/bpf/verify_sig_setup.sh | 104 +++++
 13 files changed, 672 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/verify_pkcs7_sig.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_verify_pkcs7_sig.c
 create mode 100755 tools/testing/selftests/bpf/verify_sig_setup.sh

-- 
2.25.1

