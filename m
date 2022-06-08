Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A69DD542EEC
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 13:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237833AbiFHLPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 07:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237553AbiFHLPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 07:15:12 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78A727B9B6;
        Wed,  8 Jun 2022 04:15:09 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LJ4Nd37RXz67Vdy;
        Wed,  8 Jun 2022 19:13:53 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 8 Jun 2022 13:15:07 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kpsingh@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v2 1/3] bpf: Add bpf_verify_pkcs7_signature() helper
Date:   Wed, 8 Jun 2022 13:12:19 +0200
Message-ID: <20220608111221.373833-2-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220608111221.373833-1-roberto.sassu@huawei.com>
References: <20220608111221.373833-1-roberto.sassu@huawei.com>
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

Add the bpf_verify_pkcs7_signature() helper, to give the ability to eBPF
security modules to check the validity of a PKCS#7 signature against
supplied data.

Use the 'keyring' parameter to select the keyring containing the
verification key: 0 for the primary keyring, 1 for the primary and
secondary keyrings, 2 for the platform keyring.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 include/uapi/linux/bpf.h       |  8 ++++++++
 kernel/bpf/bpf_lsm.c           | 32 ++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  8 ++++++++
 3 files changed, 48 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index f4009dbdf62d..40d0fc0d9493 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5249,6 +5249,13 @@ union bpf_attr {
  *		Pointer to the underlying dynptr data, NULL if the dynptr is
  *		read-only, if the dynptr is invalid, or if the offset and length
  *		is out of bounds.
+ *
+ * long bpf_verify_pkcs7_signature(u8 *data, u32 datalen, u8 *sig, u32 siglen, u64 keyring)
+ *	Description
+ *		Verify the PKCS#7 *sig* with length *siglen*, on *data* with
+ *		length *datalen*, with key in *keyring*.
+ *	Return
+ *		0 on success, a negative value on error.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5455,6 +5462,7 @@ union bpf_attr {
 	FN(dynptr_read),		\
 	FN(dynptr_write),		\
 	FN(dynptr_data),		\
+	FN(verify_pkcs7_signature),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index c1351df9f7ee..1cda43cb541a 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -16,6 +16,7 @@
 #include <linux/bpf_local_storage.h>
 #include <linux/btf_ids.h>
 #include <linux/ima.h>
+#include <linux/verification.h>
 
 /* For every LSM hook that allows attachment of BPF programs, declare a nop
  * function where a BPF program can be attached.
@@ -132,6 +133,35 @@ static const struct bpf_func_proto bpf_get_attach_cookie_proto = {
 	.arg1_type	= ARG_PTR_TO_CTX,
 };
 
+BPF_CALL_5(bpf_verify_pkcs7_signature, u8 *, data, u32, datalen, u8 *, sig,
+	   u32, siglen, u64, keyring)
+{
+	int ret = -EOPNOTSUPP;
+
+#ifdef CONFIG_SYSTEM_DATA_VERIFICATION
+	if (keyring > (unsigned long)VERIFY_USE_PLATFORM_KEYRING)
+		return -EINVAL;
+
+	ret = verify_pkcs7_signature(data, datalen, sig, siglen,
+				     (struct key *)keyring,
+				     VERIFYING_UNSPECIFIED_SIGNATURE, NULL,
+				     NULL);
+#endif
+	return ret;
+}
+
+static const struct bpf_func_proto bpf_verify_pkcs7_signature_proto = {
+	.func		= bpf_verify_pkcs7_signature,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
+	.arg3_type	= ARG_PTR_TO_MEM,
+	.arg4_type	= ARG_CONST_SIZE_OR_ZERO,
+	.arg5_type	= ARG_ANYTHING,
+	.allowed	= bpf_ima_inode_hash_allowed,
+};
+
 static const struct bpf_func_proto *
 bpf_lsm_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -158,6 +188,8 @@ bpf_lsm_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return prog->aux->sleepable ? &bpf_ima_file_hash_proto : NULL;
 	case BPF_FUNC_get_attach_cookie:
 		return bpf_prog_has_trampoline(prog) ? &bpf_get_attach_cookie_proto : NULL;
+	case BPF_FUNC_verify_pkcs7_signature:
+		return prog->aux->sleepable ? &bpf_verify_pkcs7_signature_proto : NULL;
 	default:
 		return tracing_prog_func_proto(func_id, prog);
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index f4009dbdf62d..40d0fc0d9493 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5249,6 +5249,13 @@ union bpf_attr {
  *		Pointer to the underlying dynptr data, NULL if the dynptr is
  *		read-only, if the dynptr is invalid, or if the offset and length
  *		is out of bounds.
+ *
+ * long bpf_verify_pkcs7_signature(u8 *data, u32 datalen, u8 *sig, u32 siglen, u64 keyring)
+ *	Description
+ *		Verify the PKCS#7 *sig* with length *siglen*, on *data* with
+ *		length *datalen*, with key in *keyring*.
+ *	Return
+ *		0 on success, a negative value on error.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5455,6 +5462,7 @@ union bpf_attr {
 	FN(dynptr_read),		\
 	FN(dynptr_write),		\
 	FN(dynptr_data),		\
+	FN(verify_pkcs7_signature),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.25.1

