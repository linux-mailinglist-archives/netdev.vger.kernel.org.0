Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81F005467EC
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 16:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238295AbiFJN7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 09:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236558AbiFJN7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 09:59:38 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7254203A2A;
        Fri, 10 Jun 2022 06:59:32 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LKMtg3YYhz683Pb;
        Fri, 10 Jun 2022 21:55:55 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 10 Jun 2022 15:59:30 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kpsingh@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v3 1/2] bpf: Add bpf_verify_signature() helper
Date:   Fri, 10 Jun 2022 15:59:15 +0200
Message-ID: <20220610135916.1285509-2-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220610135916.1285509-1-roberto.sassu@huawei.com>
References: <20220610135916.1285509-1-roberto.sassu@huawei.com>
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

Add the bpf_verify_signature() helper, to give eBPF security modules the
ability to check the validity of a signature against supplied data, by
using system-provided keys as trust anchor.

The new helper makes it possible to enforce mandatory policies, as eBPF
programs might be allowed to make security decisions only based on data
sources the system administrator approves.

The caller should specify the identifier of the keyring containing the keys
for signature verification: 0 for the primary keyring (immutable keyring of
system keys); 1 for both the primary and secondary keyring (where keys can
be added only if they are vouched for by existing keys in those keyrings);
2 for the platform keyring (primarily used by the integrity subsystem to
verify a kexec'ed kerned image and, possibly, the initramfs signature);
0xffff for the session keyring (for testing purposes).

The caller should also specify the type of signature. Currently only PKCS#7
is supported.

Since the maximum number of parameters of an eBPF helper is 5, the keyring
and signature types share one (keyring ID: low 16 bits, signature type:
high 16 bits).

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Reported-by: kernel test robot <lkp@intel.com> (cast warning)
---
 include/uapi/linux/bpf.h       | 17 +++++++++++++
 kernel/bpf/bpf_lsm.c           | 46 ++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h | 17 +++++++++++++
 3 files changed, 80 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index f4009dbdf62d..97521857e44a 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5249,6 +5249,22 @@ union bpf_attr {
  *		Pointer to the underlying dynptr data, NULL if the dynptr is
  *		read-only, if the dynptr is invalid, or if the offset and length
  *		is out of bounds.
+ *
+ * long bpf_verify_signature(u8 *data, u32 datalen, u8 *sig, u32 siglen, u32 info)
+ *	Description
+ *		Verify a signature of length *siglen* against the supplied data
+ *		with length *datalen*. *info* contains the keyring identifier
+ *		(low 16 bits) and the signature type (high 16 bits). The keyring
+ *		identifier can have the following values (some defined in
+ *		verification.h): 0 for the primary keyring (immutable keyring of
+ *		system keys); 1 for both the primary and secondary keyring
+ *		(where keys can be added only if they are vouched for by
+ *		existing keys in those keyrings); 2 for the platform keyring
+ *		(primarily used by the integrity subsystem to verify a kexec'ed
+ *		kerned image and, possibly, the initramfs signature); 0xffff for
+ *		the session keyring (for testing purposes).
+ *	Return
+ *		0 on success, a negative value on error.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5455,6 +5471,7 @@ union bpf_attr {
 	FN(dynptr_read),		\
 	FN(dynptr_write),		\
 	FN(dynptr_data),		\
+	FN(verify_signature),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index c1351df9f7ee..20bd850ea3ee 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -16,6 +16,8 @@
 #include <linux/bpf_local_storage.h>
 #include <linux/btf_ids.h>
 #include <linux/ima.h>
+#include <linux/verification.h>
+#include <linux/module_signature.h>
 
 /* For every LSM hook that allows attachment of BPF programs, declare a nop
  * function where a BPF program can be attached.
@@ -132,6 +134,46 @@ static const struct bpf_func_proto bpf_get_attach_cookie_proto = {
 	.arg1_type	= ARG_PTR_TO_CTX,
 };
 
+#ifdef CONFIG_SYSTEM_DATA_VERIFICATION
+BPF_CALL_5(bpf_verify_signature, u8 *, data, u32, datalen, u8 *, sig,
+	   u32, siglen, u32, info)
+{
+	unsigned long keyring_id = info & U16_MAX;
+	enum pkey_id_type id_type = info >> 16;
+	const struct cred *cred = current_cred();
+	struct key *keyring;
+
+	if (keyring_id > (unsigned long)VERIFY_USE_PLATFORM_KEYRING &&
+	    keyring_id != U16_MAX)
+		return -EINVAL;
+
+	keyring = (keyring_id == U16_MAX) ?
+		  cred->session_keyring : (struct key *)keyring_id;
+
+	switch (id_type) {
+	case PKEY_ID_PKCS7:
+		return verify_pkcs7_signature(data, datalen, sig, siglen,
+					      keyring,
+					      VERIFYING_UNSPECIFIED_SIGNATURE,
+					      NULL, NULL);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static const struct bpf_func_proto bpf_verify_signature_proto = {
+	.func		= bpf_verify_signature,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
+	.arg3_type	= ARG_PTR_TO_MEM,
+	.arg4_type	= ARG_CONST_SIZE_OR_ZERO,
+	.arg5_type	= ARG_ANYTHING,
+	.allowed	= bpf_ima_inode_hash_allowed,
+};
+#endif
+
 static const struct bpf_func_proto *
 bpf_lsm_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -158,6 +200,10 @@ bpf_lsm_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return prog->aux->sleepable ? &bpf_ima_file_hash_proto : NULL;
 	case BPF_FUNC_get_attach_cookie:
 		return bpf_prog_has_trampoline(prog) ? &bpf_get_attach_cookie_proto : NULL;
+#ifdef CONFIG_SYSTEM_DATA_VERIFICATION
+	case BPF_FUNC_verify_signature:
+		return prog->aux->sleepable ? &bpf_verify_signature_proto : NULL;
+#endif
 	default:
 		return tracing_prog_func_proto(func_id, prog);
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index f4009dbdf62d..97521857e44a 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5249,6 +5249,22 @@ union bpf_attr {
  *		Pointer to the underlying dynptr data, NULL if the dynptr is
  *		read-only, if the dynptr is invalid, or if the offset and length
  *		is out of bounds.
+ *
+ * long bpf_verify_signature(u8 *data, u32 datalen, u8 *sig, u32 siglen, u32 info)
+ *	Description
+ *		Verify a signature of length *siglen* against the supplied data
+ *		with length *datalen*. *info* contains the keyring identifier
+ *		(low 16 bits) and the signature type (high 16 bits). The keyring
+ *		identifier can have the following values (some defined in
+ *		verification.h): 0 for the primary keyring (immutable keyring of
+ *		system keys); 1 for both the primary and secondary keyring
+ *		(where keys can be added only if they are vouched for by
+ *		existing keys in those keyrings); 2 for the platform keyring
+ *		(primarily used by the integrity subsystem to verify a kexec'ed
+ *		kerned image and, possibly, the initramfs signature); 0xffff for
+ *		the session keyring (for testing purposes).
+ *	Return
+ *		0 on success, a negative value on error.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5455,6 +5471,7 @@ union bpf_attr {
 	FN(dynptr_read),		\
 	FN(dynptr_write),		\
 	FN(dynptr_data),		\
+	FN(verify_signature),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.25.1

