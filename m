Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 655B05537FE
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 18:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352486AbiFUQjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 12:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351472AbiFUQi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 12:38:56 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35AAD1D0EC;
        Tue, 21 Jun 2022 09:38:55 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LSBxP4YB2z6H6jC;
        Wed, 22 Jun 2022 00:36:57 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 21 Jun 2022 18:38:52 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kpsingh@kernel.org>, <john.fastabend@gmail.com>,
        <songliubraving@fb.com>, <kafai@fb.com>, <yhs@fb.com>
CC:     <dhowells@redhat.com>, <keyrings@vger.kernel.org>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v5 3/5] bpf: Add bpf_verify_pkcs7_signature() helper
Date:   Tue, 21 Jun 2022 18:37:55 +0200
Message-ID: <20220621163757.760304-4-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220621163757.760304-1-roberto.sassu@huawei.com>
References: <20220621163757.760304-1-roberto.sassu@huawei.com>
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

Add the bpf_verify_pkcs7_signature() helper, to give eBPF security modules
the ability to check the validity of a signature against supplied data, by
using user-provided or system-provided keys as trust anchor.

The new helper makes it possible to enforce mandatory policies, as eBPF
programs might be allowed to make security decisions only based on data
sources the system administrator approves.

The caller should provide both the data to be verified and the signature as
eBPF dynamic pointers (to minimize the number of parameters).

The caller should also provide a keyring pointer obtained with
bpf_lookup_user_key() or, alternatively, a keyring ID with values defined
in verification.h. While the first choice gives users more flexibility, the
second offers better security guarantees, as the keyring selection will not
depend on possibly untrusted user space but on the kernel itself.

Defined keyring IDs are: 0 for the primary keyring (immutable keyring of
system keys); 1 for both the primary and secondary keyring (where keys can
be added only if they are vouched for by existing keys in those keyrings);
2 for the platform keyring (primarily used by the integrity subsystem to
verify a kexec'ed kerned image and, possibly, the initramfs signature).

Note: since the keyring ID assignment is understood only by
verify_pkcs7_signature(), it must be passed directly to the corresponding
helper, rather than to a separate new helper returning a struct key pointer
with the keyring ID as a pointer value. If such pointer is passed to any
other helper which does not check its validity, an illegal memory access
could occur.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Reported-by: kernel test robot <lkp@intel.com> (cast warning)
---
 include/uapi/linux/bpf.h       | 17 +++++++++++++++
 kernel/bpf/bpf_lsm.c           | 39 ++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h | 17 +++++++++++++++
 3 files changed, 73 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 7bbcf2cd105d..524bed4d7170 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5339,6 +5339,22 @@ union bpf_attr {
  *		bpf_lookup_user_key() helper.
  *	Return
  *		0
+ *
+ * long bpf_verify_pkcs7_signature(struct bpf_dynptr *data_ptr, struct bpf_dynptr *sig_ptr, struct key *trusted_keys, unsigned long keyring_id)
+ *	Description
+ *		Verify the PKCS#7 signature *sig* against the supplied *data*
+ *		with keys in *trusted_keys* or in a keyring with ID
+ *		*keyring_id*.
+ *
+ *		*keyring_id* can have the following values defined in
+ *		verification.h: 0 for the primary keyring (immutable keyring of
+ *		system keys); 1 for both the primary and secondary keyring
+ *		(where keys can be added only if they are vouched for by
+ *		existing keys in those keyrings); 2 for the platform keyring
+ *		(primarily used by the integrity subsystem to verify a kexec'ed
+ *		kerned image and, possibly, the initramfs signature).
+ *	Return
+ *		0 on success, a negative value on error.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5551,6 +5567,7 @@ union bpf_attr {
 	FN(tcp_raw_check_syncookie_ipv6),	\
 	FN(lookup_user_key),		\
 	FN(key_put),			\
+	FN(verify_pkcs7_signature),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index bbbf9640f391..1fd94958e88f 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -16,6 +16,7 @@
 #include <linux/bpf_local_storage.h>
 #include <linux/btf_ids.h>
 #include <linux/ima.h>
+#include <linux/verification.h>
 
 /* For every LSM hook that allows attachment of BPF programs, declare a nop
  * function where a BPF program can be attached.
@@ -170,6 +171,39 @@ static const struct bpf_func_proto bpf_key_put_proto = {
 	.arg1_btf_id	= &btf_key_ids[0],
 	.allowed	= bpf_ima_inode_hash_allowed,
 };
+
+#ifdef CONFIG_SYSTEM_DATA_VERIFICATION
+BPF_CALL_4(bpf_verify_pkcs7_signature, struct bpf_dynptr_kern *, data_ptr,
+	   struct bpf_dynptr_kern *, sig_ptr, struct key *, trusted_keys,
+	   unsigned long, keyring_id)
+{
+	struct key *_trusted_keys = trusted_keys;
+
+	if (!_trusted_keys &&
+	    keyring_id <= (unsigned long)VERIFY_USE_PLATFORM_KEYRING)
+		_trusted_keys = (struct key *)keyring_id;
+
+	return verify_pkcs7_signature(data_ptr->data,
+				      bpf_dynptr_get_size(data_ptr),
+				      sig_ptr->data,
+				      bpf_dynptr_get_size(sig_ptr),
+				      _trusted_keys,
+				      VERIFYING_UNSPECIFIED_SIGNATURE, NULL,
+				      NULL);
+}
+
+static const struct bpf_func_proto bpf_verify_pkcs7_signature_proto = {
+	.func		= bpf_verify_pkcs7_signature,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_DYNPTR | DYNPTR_TYPE_LOCAL,
+	.arg2_type	= ARG_PTR_TO_DYNPTR | DYNPTR_TYPE_LOCAL,
+	.arg3_type	= ARG_PTR_TO_BTF_ID_OR_NULL,
+	.arg3_btf_id	= &btf_key_ids[0],
+	.arg4_type	= ARG_ANYTHING,
+	.allowed	= bpf_ima_inode_hash_allowed,
+};
+#endif /* CONFIG_SYSTEM_DATA_VERIFICATION */
 #endif /* CONFIG_KEYS */
 
 static const struct bpf_func_proto *
@@ -203,6 +237,11 @@ bpf_lsm_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_lookup_user_key_proto;
 	case BPF_FUNC_key_put:
 		return &bpf_key_put_proto;
+#ifdef CONFIG_SYSTEM_DATA_VERIFICATION
+	case BPF_FUNC_verify_pkcs7_signature:
+		return prog->aux->sleepable ?
+		       &bpf_verify_pkcs7_signature_proto : NULL;
+#endif /* CONFIG_SYSTEM_DATA_VERIFICATION */
 #endif /* CONFIG_KEYS */
 	default:
 		return tracing_prog_func_proto(func_id, prog);
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 7bbcf2cd105d..524bed4d7170 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5339,6 +5339,22 @@ union bpf_attr {
  *		bpf_lookup_user_key() helper.
  *	Return
  *		0
+ *
+ * long bpf_verify_pkcs7_signature(struct bpf_dynptr *data_ptr, struct bpf_dynptr *sig_ptr, struct key *trusted_keys, unsigned long keyring_id)
+ *	Description
+ *		Verify the PKCS#7 signature *sig* against the supplied *data*
+ *		with keys in *trusted_keys* or in a keyring with ID
+ *		*keyring_id*.
+ *
+ *		*keyring_id* can have the following values defined in
+ *		verification.h: 0 for the primary keyring (immutable keyring of
+ *		system keys); 1 for both the primary and secondary keyring
+ *		(where keys can be added only if they are vouched for by
+ *		existing keys in those keyrings); 2 for the platform keyring
+ *		(primarily used by the integrity subsystem to verify a kexec'ed
+ *		kerned image and, possibly, the initramfs signature).
+ *	Return
+ *		0 on success, a negative value on error.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5551,6 +5567,7 @@ union bpf_attr {
 	FN(tcp_raw_check_syncookie_ipv6),	\
 	FN(lookup_user_key),		\
 	FN(key_put),			\
+	FN(verify_pkcs7_signature),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.25.1

