Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEB354B1ED
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 15:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243088AbiFNNGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 09:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241277AbiFNNGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 09:06:39 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491ABDF9F;
        Tue, 14 Jun 2022 06:06:38 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LMpWg2Blxz6877K;
        Tue, 14 Jun 2022 21:02:55 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 14 Jun 2022 15:06:35 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kpsingh@kernel.org>, <john.fastabend@gmail.com>,
        <songliubraving@fb.com>, <kafai@fb.com>, <yhs@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [RESEND][PATCH v4 2/4] bpf: Add bpf_request_key_by_id() helper
Date:   Tue, 14 Jun 2022 15:06:19 +0200
Message-ID: <20220614130621.1976089-3-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220614130621.1976089-1-roberto.sassu@huawei.com>
References: <20220614130621.1976089-1-roberto.sassu@huawei.com>
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

Add the bpf_request_key_by_id() helper, so that an eBPF program can obtain
a suitable key pointer to pass to the bpf_verify_pkcs7_signature() helper,
to be introduced in a later patch.

The passed identifier can have the following values: 0 for the primary
keyring (immutable keyring of system keys); 1 for both the primary and
secondary keyring (where keys can be added only if they are vouched for by
existing keys in those keyrings); 2 for the platform keyring (primarily
used by the integrity subsystem to verify a kexec'ed kerned image and,
possibly, the initramfs signature); ULONG_MAX for the session keyring (for
testing purposes).

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 include/uapi/linux/bpf.h       | 17 +++++++++++++++++
 kernel/bpf/bpf_lsm.c           | 30 ++++++++++++++++++++++++++++++
 scripts/bpf_doc.py             |  2 ++
 tools/include/uapi/linux/bpf.h | 17 +++++++++++++++++
 4 files changed, 66 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index f4009dbdf62d..dfd93e0e0759 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5249,6 +5249,22 @@ union bpf_attr {
  *		Pointer to the underlying dynptr data, NULL if the dynptr is
  *		read-only, if the dynptr is invalid, or if the offset and length
  *		is out of bounds.
+ *
+ * struct key *bpf_request_key_by_id(unsigned long id)
+ *	Description
+ *		Request a keyring by *id*.
+ *
+ *		*id* can have the following values (some defined in
+ *		verification.h): 0 for the primary keyring (immutable keyring of
+ *		system keys); 1 for both the primary and secondary keyring
+ *		(where keys can be added only if they are vouched for by
+ *		existing keys in those keyrings); 2 for the platform keyring
+ *		(primarily used by the integrity subsystem to verify a kexec'ed
+ *		kerned image and, possibly, the initramfs signature); ULONG_MAX
+ *		for the session keyring (for testing purposes).
+ *	Return
+ *		A non-NULL pointer if *id* is valid and not 0, a NULL pointer
+ *		otherwise.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5455,6 +5471,7 @@ union bpf_attr {
 	FN(dynptr_read),		\
 	FN(dynptr_write),		\
 	FN(dynptr_data),		\
+	FN(request_key_by_id),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index c1351df9f7ee..e1911812398b 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -16,6 +16,7 @@
 #include <linux/bpf_local_storage.h>
 #include <linux/btf_ids.h>
 #include <linux/ima.h>
+#include <linux/verification.h>
 
 /* For every LSM hook that allows attachment of BPF programs, declare a nop
  * function where a BPF program can be attached.
@@ -132,6 +133,31 @@ static const struct bpf_func_proto bpf_get_attach_cookie_proto = {
 	.arg1_type	= ARG_PTR_TO_CTX,
 };
 
+#ifdef CONFIG_KEYS
+BTF_ID_LIST_SINGLE(bpf_request_key_by_id_btf_ids, struct, key)
+
+BPF_CALL_1(bpf_request_key_by_id, unsigned long, id)
+{
+	const struct cred *cred = current_cred();
+
+	if (id > (unsigned long)VERIFY_USE_PLATFORM_KEYRING && id != ULONG_MAX)
+		return (unsigned long)NULL;
+
+	if (id == ULONG_MAX)
+		return (unsigned long)cred->session_keyring;
+
+	return id;
+}
+
+static const struct bpf_func_proto bpf_request_key_by_id_proto = {
+	.func		= bpf_request_key_by_id,
+	.gpl_only	= false,
+	.ret_type	= RET_PTR_TO_BTF_ID_OR_NULL,
+	.ret_btf_id	= &bpf_request_key_by_id_btf_ids[0],
+	.arg1_type	= ARG_ANYTHING,
+};
+#endif /* CONFIG_KEYS */
+
 static const struct bpf_func_proto *
 bpf_lsm_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -158,6 +184,10 @@ bpf_lsm_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return prog->aux->sleepable ? &bpf_ima_file_hash_proto : NULL;
 	case BPF_FUNC_get_attach_cookie:
 		return bpf_prog_has_trampoline(prog) ? &bpf_get_attach_cookie_proto : NULL;
+#ifdef CONFIG_KEYS
+	case BPF_FUNC_request_key_by_id:
+		return &bpf_request_key_by_id_proto;
+#endif /* CONFIG_KEYS */
 	default:
 		return tracing_prog_func_proto(func_id, prog);
 	}
diff --git a/scripts/bpf_doc.py b/scripts/bpf_doc.py
index 855b937e7585..176917df0ac0 100755
--- a/scripts/bpf_doc.py
+++ b/scripts/bpf_doc.py
@@ -635,6 +635,7 @@ class PrinterHelpers(Printer):
             'struct bpf_timer',
             'struct mptcp_sock',
             'struct bpf_dynptr',
+            'struct key',
     ]
     known_types = {
             '...',
@@ -686,6 +687,7 @@ class PrinterHelpers(Printer):
             'struct bpf_timer',
             'struct mptcp_sock',
             'struct bpf_dynptr',
+            'struct key',
     }
     mapped_types = {
             'u8': '__u8',
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index f4009dbdf62d..dfd93e0e0759 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5249,6 +5249,22 @@ union bpf_attr {
  *		Pointer to the underlying dynptr data, NULL if the dynptr is
  *		read-only, if the dynptr is invalid, or if the offset and length
  *		is out of bounds.
+ *
+ * struct key *bpf_request_key_by_id(unsigned long id)
+ *	Description
+ *		Request a keyring by *id*.
+ *
+ *		*id* can have the following values (some defined in
+ *		verification.h): 0 for the primary keyring (immutable keyring of
+ *		system keys); 1 for both the primary and secondary keyring
+ *		(where keys can be added only if they are vouched for by
+ *		existing keys in those keyrings); 2 for the platform keyring
+ *		(primarily used by the integrity subsystem to verify a kexec'ed
+ *		kerned image and, possibly, the initramfs signature); ULONG_MAX
+ *		for the session keyring (for testing purposes).
+ *	Return
+ *		A non-NULL pointer if *id* is valid and not 0, a NULL pointer
+ *		otherwise.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5455,6 +5471,7 @@ union bpf_attr {
 	FN(dynptr_read),		\
 	FN(dynptr_write),		\
 	FN(dynptr_data),		\
+	FN(request_key_by_id),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.25.1

