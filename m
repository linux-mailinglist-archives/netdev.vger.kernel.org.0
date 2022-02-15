Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105D84B6C46
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 13:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237828AbiBOMmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 07:42:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237801AbiBOMmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 07:42:08 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA93414091;
        Tue, 15 Feb 2022 04:41:42 -0800 (PST)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jyggg1chRz6873Q;
        Tue, 15 Feb 2022 20:41:19 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Feb 2022 13:41:40 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <shuah@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <kpsingh@kernel.org>,
        <revest@chromium.org>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v2 3/6] bpf-lsm: Introduce new helper bpf_ima_file_hash()
Date:   Tue, 15 Feb 2022 13:40:39 +0100
Message-ID: <20220215124042.186506-4-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220215124042.186506-1-roberto.sassu@huawei.com>
References: <20220215124042.186506-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml753-chm.china.huawei.com (10.201.108.203) To
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
demand, if it has not been already performed by IMA. For compatibility
reasons, ima_inode_hash() remains unchanged.

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
index b0383d371b9a..ba33d5718d6b 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4648,6 +4648,16 @@ union bpf_attr {
  *		**-EOPNOTSUP** if IMA is disabled or **-EINVAL** if
  *		invalid arguments are passed.
  *
+ * long bpf_ima_file_hash(struct file *file, void *dst, u32 size)
+ *	Description
+ *		Returns a calculated IMA hash of the *file*.
+ *		If the hash is larger than *size*, then only *size*
+ *		bytes will be copied to *dst*
+ *	Return
+ *		The **hash_algo** is returned on success,
+ *		**-EOPNOTSUP** if the hash calculation failed or **-EINVAL** if
+ *		invalid arguments are passed.
+ *
  * struct socket *bpf_sock_from_file(struct file *file)
  *	Description
  *		If the given file represents a socket, returns the associated
@@ -5182,6 +5192,7 @@ union bpf_attr {
 	FN(bprm_opts_set),		\
 	FN(ktime_get_coarse_ns),	\
 	FN(ima_inode_hash),		\
+	FN(ima_file_hash),		\
 	FN(sock_from_file),		\
 	FN(check_mtu),			\
 	FN(for_each_map_elem),		\
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
index b0383d371b9a..ba33d5718d6b 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4648,6 +4648,16 @@ union bpf_attr {
  *		**-EOPNOTSUP** if IMA is disabled or **-EINVAL** if
  *		invalid arguments are passed.
  *
+ * long bpf_ima_file_hash(struct file *file, void *dst, u32 size)
+ *	Description
+ *		Returns a calculated IMA hash of the *file*.
+ *		If the hash is larger than *size*, then only *size*
+ *		bytes will be copied to *dst*
+ *	Return
+ *		The **hash_algo** is returned on success,
+ *		**-EOPNOTSUP** if the hash calculation failed or **-EINVAL** if
+ *		invalid arguments are passed.
+ *
  * struct socket *bpf_sock_from_file(struct file *file)
  *	Description
  *		If the given file represents a socket, returns the associated
@@ -5182,6 +5192,7 @@ union bpf_attr {
 	FN(bprm_opts_set),		\
 	FN(ktime_get_coarse_ns),	\
 	FN(ima_inode_hash),		\
+	FN(ima_file_hash),		\
 	FN(sock_from_file),		\
 	FN(check_mtu),			\
 	FN(for_each_map_elem),		\
-- 
2.32.0

