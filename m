Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A70815537FA
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 18:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352467AbiFUQi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 12:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232968AbiFUQi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 12:38:56 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490701C107;
        Tue, 21 Jun 2022 09:38:54 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LSBz907xZz680mF;
        Wed, 22 Jun 2022 00:38:29 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 21 Jun 2022 18:38:51 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kpsingh@kernel.org>, <john.fastabend@gmail.com>,
        <songliubraving@fb.com>, <kafai@fb.com>, <yhs@fb.com>
CC:     <dhowells@redhat.com>, <keyrings@vger.kernel.org>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v5 2/5] bpf: Add bpf_lookup_user_key() and bpf_key_put() helpers
Date:   Tue, 21 Jun 2022 18:37:54 +0200
Message-ID: <20220621163757.760304-3-roberto.sassu@huawei.com>
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

Add the bpf_lookup_user_key() and bpf_key_put() helpers, to respectively
search a key with a given serial, and release the reference count of the
found key.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 include/uapi/linux/bpf.h       | 16 ++++++++++++
 kernel/bpf/bpf_lsm.c           | 46 ++++++++++++++++++++++++++++++++++
 kernel/bpf/verifier.c          |  6 +++--
 scripts/bpf_doc.py             |  2 ++
 tools/include/uapi/linux/bpf.h | 16 ++++++++++++
 5 files changed, 84 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index e81362891596..7bbcf2cd105d 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5325,6 +5325,20 @@ union bpf_attr {
  *		**-EACCES** if the SYN cookie is not valid.
  *
  *		**-EPROTONOSUPPORT** if CONFIG_IPV6 is not builtin.
+ *
+ * struct key *bpf_lookup_user_key(u32 serial, unsigned long flags)
+ *	Description
+ *		Search a key with a given *serial* and the provided *flags*, and
+ *		increment the reference count of the key.
+ *	Return
+ *		A key pointer if the key is found, a NULL pointer otherwise.
+ *
+ * void bpf_key_put(struct key *key)
+ *	Description
+ *		Decrement the reference count of the key obtained with the
+ *		bpf_lookup_user_key() helper.
+ *	Return
+ *		0
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5535,6 +5549,8 @@ union bpf_attr {
 	FN(tcp_raw_gen_syncookie_ipv6),	\
 	FN(tcp_raw_check_syncookie_ipv4),	\
 	FN(tcp_raw_check_syncookie_ipv6),	\
+	FN(lookup_user_key),		\
+	FN(key_put),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index c1351df9f7ee..bbbf9640f391 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -132,6 +132,46 @@ static const struct bpf_func_proto bpf_get_attach_cookie_proto = {
 	.arg1_type	= ARG_PTR_TO_CTX,
 };
 
+#ifdef CONFIG_KEYS
+BTF_ID_LIST_SINGLE(btf_key_ids, struct, key)
+
+BPF_CALL_2(bpf_lookup_user_key, u32, serial, unsigned long, flags)
+{
+	key_ref_t key_ref;
+
+	key_ref = lookup_user_key(serial, flags, KEY_NEED_SEARCH);
+	if (IS_ERR(key_ref))
+		return (unsigned long)NULL;
+
+	return (unsigned long)key_ref_to_ptr(key_ref);
+}
+
+static const struct bpf_func_proto bpf_lookup_user_key_proto = {
+	.func		= bpf_lookup_user_key,
+	.gpl_only	= false,
+	.ret_type	= RET_PTR_TO_BTF_ID_OR_NULL,
+	.ret_btf_id	= &btf_key_ids[0],
+	.arg1_type	= ARG_ANYTHING,
+	.arg2_type	= ARG_ANYTHING,
+	.allowed	= bpf_ima_inode_hash_allowed,
+};
+
+BPF_CALL_1(bpf_key_put, struct key *, key)
+{
+	key_put(key);
+	return 0;
+}
+
+static const struct bpf_func_proto bpf_key_put_proto = {
+	.func		= bpf_key_put,
+	.gpl_only	= false,
+	.ret_type	= RET_VOID,
+	.arg1_type	= ARG_PTR_TO_BTF_ID | OBJ_RELEASE,
+	.arg1_btf_id	= &btf_key_ids[0],
+	.allowed	= bpf_ima_inode_hash_allowed,
+};
+#endif /* CONFIG_KEYS */
+
 static const struct bpf_func_proto *
 bpf_lsm_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -158,6 +198,12 @@ bpf_lsm_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return prog->aux->sleepable ? &bpf_ima_file_hash_proto : NULL;
 	case BPF_FUNC_get_attach_cookie:
 		return bpf_prog_has_trampoline(prog) ? &bpf_get_attach_cookie_proto : NULL;
+#ifdef CONFIG_KEYS
+	case BPF_FUNC_lookup_user_key:
+		return &bpf_lookup_user_key_proto;
+	case BPF_FUNC_key_put:
+		return &bpf_key_put_proto;
+#endif /* CONFIG_KEYS */
 	default:
 		return tracing_prog_func_proto(func_id, prog);
 	}
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index bf72dc511df6..12f06ca649a4 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -483,7 +483,8 @@ static bool may_be_acquire_function(enum bpf_func_id func_id)
 		func_id == BPF_FUNC_sk_lookup_udp ||
 		func_id == BPF_FUNC_skc_lookup_tcp ||
 		func_id == BPF_FUNC_map_lookup_elem ||
-	        func_id == BPF_FUNC_ringbuf_reserve;
+		func_id == BPF_FUNC_ringbuf_reserve ||
+		func_id == BPF_FUNC_lookup_user_key;
 }
 
 static bool is_acquire_function(enum bpf_func_id func_id,
@@ -495,7 +496,8 @@ static bool is_acquire_function(enum bpf_func_id func_id,
 	    func_id == BPF_FUNC_sk_lookup_udp ||
 	    func_id == BPF_FUNC_skc_lookup_tcp ||
 	    func_id == BPF_FUNC_ringbuf_reserve ||
-	    func_id == BPF_FUNC_kptr_xchg)
+	    func_id == BPF_FUNC_kptr_xchg ||
+	    func_id == BPF_FUNC_lookup_user_key)
 		return true;
 
 	if (func_id == BPF_FUNC_map_lookup_elem &&
diff --git a/scripts/bpf_doc.py b/scripts/bpf_doc.py
index a0ec321469bd..3d5a7ad6f493 100755
--- a/scripts/bpf_doc.py
+++ b/scripts/bpf_doc.py
@@ -637,6 +637,7 @@ class PrinterHelpers(Printer):
             'struct bpf_dynptr',
             'struct iphdr',
             'struct ipv6hdr',
+            'struct key',
     ]
     known_types = {
             '...',
@@ -690,6 +691,7 @@ class PrinterHelpers(Printer):
             'struct bpf_dynptr',
             'struct iphdr',
             'struct ipv6hdr',
+            'struct key',
     }
     mapped_types = {
             'u8': '__u8',
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index e81362891596..7bbcf2cd105d 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5325,6 +5325,20 @@ union bpf_attr {
  *		**-EACCES** if the SYN cookie is not valid.
  *
  *		**-EPROTONOSUPPORT** if CONFIG_IPV6 is not builtin.
+ *
+ * struct key *bpf_lookup_user_key(u32 serial, unsigned long flags)
+ *	Description
+ *		Search a key with a given *serial* and the provided *flags*, and
+ *		increment the reference count of the key.
+ *	Return
+ *		A key pointer if the key is found, a NULL pointer otherwise.
+ *
+ * void bpf_key_put(struct key *key)
+ *	Description
+ *		Decrement the reference count of the key obtained with the
+ *		bpf_lookup_user_key() helper.
+ *	Return
+ *		0
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5535,6 +5549,8 @@ union bpf_attr {
 	FN(tcp_raw_gen_syncookie_ipv6),	\
 	FN(tcp_raw_check_syncookie_ipv4),	\
 	FN(tcp_raw_check_syncookie_ipv6),	\
+	FN(lookup_user_key),		\
+	FN(key_put),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.25.1

