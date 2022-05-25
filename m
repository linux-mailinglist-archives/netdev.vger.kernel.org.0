Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B61C2533DC9
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 15:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243694AbiEYNVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 09:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232303AbiEYNVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 09:21:42 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B6327FFE;
        Wed, 25 May 2022 06:21:38 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4L7Wnl1gpnz681Yv;
        Wed, 25 May 2022 21:17:31 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 25 May 2022 15:21:36 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kpsingh@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 2/3] bpf: Introduce bpf_map_verified_data_size() helper
Date:   Wed, 25 May 2022 15:21:14 +0200
Message-ID: <20220525132115.896698-3-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220525132115.896698-1-roberto.sassu@huawei.com>
References: <20220525132115.896698-1-roberto.sassu@huawei.com>
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

Introduce the bpf_map_verified_data_size() helper to get the verified data
size from a signed map value, as parsed by the kernel with
bpf_map_verify_value_sig().

The same information might be provided by user space tools as well without
any helper, for example by adding a second unsigned integer after the
verified data+sig size field.

However, this alternative seems to increase the code complexity: the kernel
has to parse two unsigned integers and check their consistency; user space
tools have to parse the module-style appended signature to get the verified
data size.

Alternatively, each eBPF program could parse the module-style signature by
itself, but this would cause duplication of the code.

Adding a new helper seems the best choice, it only needs to call the
existing function bpf_map_verify_value_sig() and pass the result to the
caller.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 include/uapi/linux/bpf.h       |  8 ++++++++
 kernel/bpf/helpers.c           | 15 +++++++++++++++
 tools/include/uapi/linux/bpf.h |  8 ++++++++
 3 files changed, 31 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index a8e7803d2593..4a05caa49419 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5252,6 +5252,13 @@ union bpf_attr {
  *		Pointer to the underlying dynptr data, NULL if the dynptr is
  *		read-only, if the dynptr is invalid, or if the offset and length
  *		is out of bounds.
+ *
+ * long bpf_map_verified_data_size(const void *value, u32 value_size)
+ *	Description
+ *		Parse signed map value in *value* with size *value_size*.
+ *	Return
+ *		The size of verified data on success, or a negative error in
+ *		case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5458,6 +5465,7 @@ union bpf_attr {
 	FN(dynptr_read),		\
 	FN(dynptr_write),		\
 	FN(dynptr_data),		\
+	FN(bpf_map_verified_data_size),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 225806a02efb..78c29c4e5d3f 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1575,6 +1575,19 @@ const struct bpf_func_proto bpf_dynptr_data_proto = {
 	.arg3_type	= ARG_CONST_ALLOC_SIZE_OR_ZERO,
 };
 
+BPF_CALL_2(bpf_map_verified_data_size, const void *, value, u32, value_size)
+{
+	return bpf_map_verify_value_sig(value, value_size, false);
+}
+
+const struct bpf_func_proto bpf_map_verified_data_size_proto = {
+	.func         = bpf_map_verified_data_size,
+	.gpl_only     = false,
+	.ret_type     = RET_INTEGER,
+	.arg1_type    = ARG_PTR_TO_MEM,
+	.arg2_type    = ARG_CONST_SIZE_OR_ZERO,
+};
+
 const struct bpf_func_proto bpf_get_current_task_proto __weak;
 const struct bpf_func_proto bpf_get_current_task_btf_proto __weak;
 const struct bpf_func_proto bpf_probe_read_user_proto __weak;
@@ -1643,6 +1656,8 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return &bpf_dynptr_write_proto;
 	case BPF_FUNC_dynptr_data:
 		return &bpf_dynptr_data_proto;
+	case BPF_FUNC_bpf_map_verified_data_size:
+		return &bpf_map_verified_data_size_proto;
 	default:
 		break;
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index a8e7803d2593..4a05caa49419 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5252,6 +5252,13 @@ union bpf_attr {
  *		Pointer to the underlying dynptr data, NULL if the dynptr is
  *		read-only, if the dynptr is invalid, or if the offset and length
  *		is out of bounds.
+ *
+ * long bpf_map_verified_data_size(const void *value, u32 value_size)
+ *	Description
+ *		Parse signed map value in *value* with size *value_size*.
+ *	Return
+ *		The size of verified data on success, or a negative error in
+ *		case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5458,6 +5465,7 @@ union bpf_attr {
 	FN(dynptr_read),		\
 	FN(dynptr_write),		\
 	FN(dynptr_data),		\
+	FN(bpf_map_verified_data_size),	\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.25.1

