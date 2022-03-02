Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0A114CA321
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 12:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241499AbiCBLQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 06:16:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241382AbiCBLPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 06:15:55 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B201BA27AF;
        Wed,  2 Mar 2022 03:14:36 -0800 (PST)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K7s1F49Mvz67xLj;
        Wed,  2 Mar 2022 19:13:21 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 12:14:34 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <shuah@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <yhs@fb.com>,
        <kpsingh@kernel.org>, <revest@chromium.org>,
        <gregkh@linuxfoundation.org>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v3 3/9] bpf-lsm: Introduce new helper bpf_ima_file_hash()
Date:   Wed, 2 Mar 2022 12:13:58 +0100
Message-ID: <20220302111404.193900-4-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220302111404.193900-1-roberto.sassu@huawei.com>
References: <20220302111404.193900-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml751-chm.china.huawei.com (10.201.108.201) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ima_file_hash() has been modified to calculate the measurement of a file on
demand, if it has not been already performed by IMA or the measurement is
not fresh. For compatibility reasons, ima_inode_hash() remains unchanged.

Keep the same approach in eBPF and introduce the new helper
bpf_ima_file_hash() to take advantage of the modified behavior of
ima_file_hash().

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 include/uapi/linux/bpf.h       | 11 +++++++++++
 kernel/bpf/bpf_lsm.c           | 20 ++++++++++++++++++++
 tools/include/uapi/linux/bpf.h | 11 +++++++++++
 3 files changed, 42 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b0383d371b9a..87d996e954d4 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5018,6 +5018,16 @@ union bpf_attr {
  *
  *	Return
  *		The number of arguments of the traced function.
+ *
+ * long bpf_ima_file_hash(struct file *file, void *dst, u32 size)
+ *	Description
+ *		Returns a calculated IMA hash of the *file*.
+ *		If the hash is larger than *size*, then only *size*
+ *		bytes will be copied to *dst*
+ *	Return
+ *		The **hash_algo** is returned on success,
+ *		**-EOPNOTSUP** if the hash calculation failed or **-EINVAL** if
+ *		invalid arguments are passed.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5206,6 +5216,7 @@ union bpf_attr {
 	FN(get_func_arg),		\
 	FN(get_func_ret),		\
 	FN(get_func_arg_cnt),		\
+	FN(ima_file_hash),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 9e4ecc990647..e8d27af5bbcc 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -99,6 +99,24 @@ static const struct bpf_func_proto bpf_ima_inode_hash_proto = {
 	.allowed	= bpf_ima_inode_hash_allowed,
 };
 
+BPF_CALL_3(bpf_ima_file_hash, struct file *, file, void *, dst, u32, size)
+{
+	return ima_file_hash(file, dst, size);
+}
+
+BTF_ID_LIST_SINGLE(bpf_ima_file_hash_btf_ids, struct, file)
+
+static const struct bpf_func_proto bpf_ima_file_hash_proto = {
+	.func		= bpf_ima_file_hash,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_BTF_ID,
+	.arg1_btf_id	= &bpf_ima_file_hash_btf_ids[0],
+	.arg2_type	= ARG_PTR_TO_UNINIT_MEM,
+	.arg3_type	= ARG_CONST_SIZE,
+	.allowed	= bpf_ima_inode_hash_allowed,
+};
+
 static const struct bpf_func_proto *
 bpf_lsm_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -121,6 +139,8 @@ bpf_lsm_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_bprm_opts_set_proto;
 	case BPF_FUNC_ima_inode_hash:
 		return prog->aux->sleepable ? &bpf_ima_inode_hash_proto : NULL;
+	case BPF_FUNC_ima_file_hash:
+		return prog->aux->sleepable ? &bpf_ima_file_hash_proto : NULL;
 	default:
 		return tracing_prog_func_proto(func_id, prog);
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index b0383d371b9a..87d996e954d4 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5018,6 +5018,16 @@ union bpf_attr {
  *
  *	Return
  *		The number of arguments of the traced function.
+ *
+ * long bpf_ima_file_hash(struct file *file, void *dst, u32 size)
+ *	Description
+ *		Returns a calculated IMA hash of the *file*.
+ *		If the hash is larger than *size*, then only *size*
+ *		bytes will be copied to *dst*
+ *	Return
+ *		The **hash_algo** is returned on success,
+ *		**-EOPNOTSUP** if the hash calculation failed or **-EINVAL** if
+ *		invalid arguments are passed.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5206,6 +5216,7 @@ union bpf_attr {
 	FN(get_func_arg),		\
 	FN(get_func_ret),		\
 	FN(get_func_arg_cnt),		\
+	FN(ima_file_hash),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.32.0

