Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF0F7572313
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 20:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234242AbiGLSn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 14:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234120AbiGLSms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 14:42:48 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD142D9159;
        Tue, 12 Jul 2022 11:41:49 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Lj8h84PJZz67jhH;
        Wed, 13 Jul 2022 02:40:24 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 12 Jul 2022 20:41:46 +0200
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
Subject: [PATCH v7 4/7] bpf: Add bpf_verify_pkcs7_signature() helper
Date:   Tue, 12 Jul 2022 20:41:25 +0200
Message-ID: <20220712184128.999301-5-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220712184128.999301-1-roberto.sassu@huawei.com>
References: <20220712184128.999301-1-roberto.sassu@huawei.com>
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

Add the bpf_verify_pkcs7_signature() helper, to give eBPF security modules
the ability to check the validity of a signature against supplied data, by
using user-provided or system-provided keys as trust anchor.

The new helper makes it possible to enforce mandatory policies, as eBPF
programs might be allowed to make security decisions only based on data
sources the system administrator approves.

The caller should provide both the data to be verified and the signature as
eBPF dynamic pointers (to minimize the number of parameters) and,
alternatively, a keyring obtained from bpf_lookup_user_key(), or a
pre-determined keyring ID with values defined in
include/linux/verification.h.

The two keyring parameters have to be provided separately: the
pre-determined IDs exist only in the context of verify_pkcs7_signature().
They should not be passed to the bpf_lookup_user_key() helper, or to a new
helper doing type casting to a struct key (like: ((struct key *)2UL) in
include/linux/verification.h), as otherwise, each helper accepting a struct
key would have to check if it is a valid pointer or not.

Finally, bpf_verify_pkcs7_signature() completes the permission check
deferred by bpf_lookup_user_key(), by calling key_validate().
key_task_permission() is already called by the PKCS#7 code.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 include/uapi/linux/bpf.h       | 22 ++++++++++++
 kernel/bpf/bpf_lsm.c           | 63 ++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h | 22 ++++++++++++
 3 files changed, 107 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index a3f6506ddeba..9037ff1414c2 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5350,6 +5350,27 @@ union bpf_attr {
  *		bpf_lookup_user_key() helper.
  *	Return
  *		0
+ *
+ * long bpf_verify_pkcs7_signature(struct bpf_dynptr *data_ptr, struct bpf_dynptr *sig_ptr, struct key *user_keyring, u64 system_keyring)
+ *	Description
+ *		Verify the PKCS#7 signature *sig_ptr* against the supplied
+ *		*data_ptr* alternatively with keys in *user_keyring* or
+ *		*system_keyring*. Either one of the two must be provided.
+ *		Respectively, NULL or UINT64_MAX must be passed to signal to the
+ *		helper that the parameter is not used.
+ *
+ *		*user_keyring* is a key pointer obtained from
+ *		bpf_lookup_user_key(), while *system_keyring* is a
+ *		pre-determined ID with values defined in
+ *		include/linux/verification.h: 0 for the primary keyring
+ *		(immutable keyring of system keys); 1 for both the primary and
+ *		secondary keyring (where keys can be added only if they are
+ *		vouched for by existing keys in those keyrings); 2 for the
+ *		platform keyring (primarily used by the integrity subsystem to
+ *		verify a kexec'ed kerned image and, possibly, the initramfs
+ *		signature).
+ *	Return
+ *		0 on success, a negative value on error.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5562,6 +5583,7 @@ union bpf_attr {
 	FN(tcp_raw_check_syncookie_ipv6),	\
 	FN(lookup_user_key),		\
 	FN(key_put),			\
+	FN(verify_pkcs7_signature),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 0a95e2137d65..6d8a40b8b1e0 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -17,6 +17,7 @@
 #include <linux/btf_ids.h>
 #include <linux/ima.h>
 #include <linux/bpf-cgroup.h>
+#include <linux/verification.h>
 
 /* For every LSM hook that allows attachment of BPF programs, declare a nop
  * function where a BPF program can be attached.
@@ -227,6 +228,63 @@ static const struct bpf_func_proto bpf_key_put_proto = {
 	.arg1_btf_id	= &btf_key_ids[0],
 	.allowed	= bpf_ima_inode_hash_allowed,
 };
+
+#ifdef CONFIG_SYSTEM_DATA_VERIFICATION
+BPF_CALL_4(bpf_verify_pkcs7_signature, struct bpf_dynptr_kern *, data_ptr,
+	   struct bpf_dynptr_kern *, sig_ptr, struct key *, user_keyring,
+	   u64, system_keyring)
+{
+	struct key *trusted_keyring;
+	int ret;
+
+	/* Either user_keyring or system_keyring must be specified. */
+	if ((user_keyring && system_keyring != U64_MAX) ||
+	    (!user_keyring && system_keyring == U64_MAX))
+		return -EINVAL;
+
+	if (user_keyring) {
+		/*
+		 * Do the permission check deferred in bpf_lookup_user_key().
+		 *
+		 * A call to key_task_permission() here would be redundant, as
+		 * it is already done by keyring_search() called by
+		 * find_asymmetric_key().
+		 */
+		ret = key_validate(user_keyring);
+		if (ret < 0)
+			return ret;
+
+		trusted_keyring = user_keyring;
+		goto verify;
+	}
+
+	/* Keep in sync with defs in include/linux/verification.h. */
+	if (system_keyring > (unsigned long)VERIFY_USE_PLATFORM_KEYRING)
+		return -EINVAL;
+
+	trusted_keyring = (struct key *)(unsigned long)system_keyring;
+verify:
+	return verify_pkcs7_signature(data_ptr->data,
+				      bpf_dynptr_get_size(data_ptr),
+				      sig_ptr->data,
+				      bpf_dynptr_get_size(sig_ptr),
+				      trusted_keyring,
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
@@ -291,6 +349,11 @@ bpf_lsm_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	case BPF_FUNC_key_put:
 		return prog->aux->sleepable ?
 		       &bpf_key_put_proto : NULL;
+#ifdef CONFIG_SYSTEM_DATA_VERIFICATION
+	case BPF_FUNC_verify_pkcs7_signature:
+		return prog->aux->sleepable ?
+		       &bpf_verify_pkcs7_signature_proto : NULL;
+#endif /* CONFIG_SYSTEM_DATA_VERIFICATION */
 #endif /* CONFIG_KEYS */
 	default:
 		return tracing_prog_func_proto(func_id, prog);
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index a3f6506ddeba..9037ff1414c2 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5350,6 +5350,27 @@ union bpf_attr {
  *		bpf_lookup_user_key() helper.
  *	Return
  *		0
+ *
+ * long bpf_verify_pkcs7_signature(struct bpf_dynptr *data_ptr, struct bpf_dynptr *sig_ptr, struct key *user_keyring, u64 system_keyring)
+ *	Description
+ *		Verify the PKCS#7 signature *sig_ptr* against the supplied
+ *		*data_ptr* alternatively with keys in *user_keyring* or
+ *		*system_keyring*. Either one of the two must be provided.
+ *		Respectively, NULL or UINT64_MAX must be passed to signal to the
+ *		helper that the parameter is not used.
+ *
+ *		*user_keyring* is a key pointer obtained from
+ *		bpf_lookup_user_key(), while *system_keyring* is a
+ *		pre-determined ID with values defined in
+ *		include/linux/verification.h: 0 for the primary keyring
+ *		(immutable keyring of system keys); 1 for both the primary and
+ *		secondary keyring (where keys can be added only if they are
+ *		vouched for by existing keys in those keyrings); 2 for the
+ *		platform keyring (primarily used by the integrity subsystem to
+ *		verify a kexec'ed kerned image and, possibly, the initramfs
+ *		signature).
+ *	Return
+ *		0 on success, a negative value on error.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5562,6 +5583,7 @@ union bpf_attr {
 	FN(tcp_raw_check_syncookie_ipv6),	\
 	FN(lookup_user_key),		\
 	FN(key_put),			\
+	FN(verify_pkcs7_signature),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.25.1

