Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 837D254AFB0
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 13:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353166AbiFNLyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 07:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347890AbiFNLyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 07:54:44 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8603B393E0;
        Tue, 14 Jun 2022 04:54:43 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LMmwh4RZ8z67Nc8;
        Tue, 14 Jun 2022 19:51:00 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 14 Jun 2022 13:54:41 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kpsingh@kernel.org>, <john.fastabend@gmail.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v4 3/4] bpf: Add bpf_verify_pkcs7_signature() helper
Date:   Tue, 14 Jun 2022 13:54:19 +0200
Message-ID: <20220614115420.1964686-4-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220614115420.1964686-1-roberto.sassu@huawei.com>
References: <20220614115420.1964686-1-roberto.sassu@huawei.com>
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
using system-provided keys as trust anchor.

The new helper makes it possible to enforce mandatory policies, as eBPF
programs might be allowed to make security decisions only based on data
sources the system administrator approves.

The caller should provide both the data to be verified and the signature as
eBPF dynamic pointers (to minimize the number of parameters). The caller
should also provide a keyring pointer, that can be currently obtained with
the bpf_request_key_by_id() helper. In the future, it will be possible to
search a keyring by its description.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Reported-by: kernel test robot <lkp@intel.com> (cast warning)
---
 include/uapi/linux/bpf.h       |  8 ++++++++
 kernel/bpf/bpf_lsm.c           | 30 ++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  8 ++++++++
 3 files changed, 46 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index dfd93e0e0759..e6d9158e4981 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5265,6 +5265,13 @@ union bpf_attr {
  *	Return
  *		A non-NULL pointer if *id* is valid and not 0, a NULL pointer
  *		otherwise.
+ *
+ * long bpf_verify_pkcs7_signature(struct bpf_dynptr *data_ptr, struct bpf_dynptr *sig_ptr, struct key *trusted_keys)
+ *	Description
+ *		Verify the PKCS#7 signature *sig* against the supplied *data*
+ *		with keys in *trusted_keys*.
+ *	Return
+ *		0 on success, a negative value on error.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5472,6 +5479,7 @@ union bpf_attr {
 	FN(dynptr_write),		\
 	FN(dynptr_data),		\
 	FN(request_key_by_id),		\
+	FN(verify_pkcs7_signature),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index e1911812398b..6c0d71b8c3b6 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -156,6 +156,31 @@ static const struct bpf_func_proto bpf_request_key_by_id_proto = {
 	.ret_btf_id	= &bpf_request_key_by_id_btf_ids[0],
 	.arg1_type	= ARG_ANYTHING,
 };
+
+#ifdef CONFIG_SYSTEM_DATA_VERIFICATION
+BPF_CALL_3(bpf_verify_pkcs7_signature, struct bpf_dynptr_kern *, data_ptr,
+	   struct bpf_dynptr_kern *, sig_ptr, struct key *, trusted_keys)
+{
+	return verify_pkcs7_signature(data_ptr->data,
+				      bpf_dynptr_get_size(data_ptr),
+				      sig_ptr->data,
+				      bpf_dynptr_get_size(sig_ptr),
+				      trusted_keys,
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
+	.arg3_btf_id	= &bpf_request_key_by_id_btf_ids[0],
+	.allowed	= bpf_ima_inode_hash_allowed,
+};
+#endif /* CONFIG_SYSTEM_DATA_VERIFICATION */
 #endif /* CONFIG_KEYS */
 
 static const struct bpf_func_proto *
@@ -187,6 +212,11 @@ bpf_lsm_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 #ifdef CONFIG_KEYS
 	case BPF_FUNC_request_key_by_id:
 		return &bpf_request_key_by_id_proto;
+#ifdef CONFIG_SYSTEM_DATA_VERIFICATION
+	case BPF_FUNC_verify_pkcs7_signature:
+		return prog->aux->sleepable ?
+		       &bpf_verify_pkcs7_signature_proto : NULL;
+#endif /* CONFIG_SYSTEM_DATA_VERIFICATION */
 #endif /* CONFIG_KEYS */
 	default:
 		return tracing_prog_func_proto(func_id, prog);
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index dfd93e0e0759..e6d9158e4981 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5265,6 +5265,13 @@ union bpf_attr {
  *	Return
  *		A non-NULL pointer if *id* is valid and not 0, a NULL pointer
  *		otherwise.
+ *
+ * long bpf_verify_pkcs7_signature(struct bpf_dynptr *data_ptr, struct bpf_dynptr *sig_ptr, struct key *trusted_keys)
+ *	Description
+ *		Verify the PKCS#7 signature *sig* against the supplied *data*
+ *		with keys in *trusted_keys*.
+ *	Return
+ *		0 on success, a negative value on error.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5472,6 +5479,7 @@ union bpf_attr {
 	FN(dynptr_write),		\
 	FN(dynptr_data),		\
 	FN(request_key_by_id),		\
+	FN(verify_pkcs7_signature),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.25.1

