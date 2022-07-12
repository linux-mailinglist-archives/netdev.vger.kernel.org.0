Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C03FD572318
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 20:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233967AbiGLSnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 14:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234053AbiGLSmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 14:42:43 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F6BC08E9;
        Tue, 12 Jul 2022 11:41:48 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Lj8fD5vdTz67MLY;
        Wed, 13 Jul 2022 02:38:44 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 12 Jul 2022 20:41:45 +0200
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
Subject: [PATCH v7 3/7] bpf: Add bpf_lookup_user_key() and bpf_key_put() helpers
Date:   Tue, 12 Jul 2022 20:41:24 +0200
Message-ID: <20220712184128.999301-4-roberto.sassu@huawei.com>
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

Add the bpf_lookup_user_key() and bpf_key_put() helpers, to respectively
search a key with a given serial and flags, and release the reference count
of the found key.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 include/uapi/linux/bpf.h       | 25 ++++++++++++++++
 kernel/bpf/bpf_lsm.c           | 53 ++++++++++++++++++++++++++++++++++
 kernel/bpf/verifier.c          |  6 ++--
 scripts/bpf_doc.py             |  2 ++
 tools/include/uapi/linux/bpf.h | 25 ++++++++++++++++
 5 files changed, 109 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 379e68fb866f..a3f6506ddeba 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5327,6 +5327,29 @@ union bpf_attr {
  *		**-EACCES** if the SYN cookie is not valid.
  *
  *		**-EPROTONOSUPPORT** if CONFIG_IPV6 is not builtin.
+ *
+ * struct key *bpf_lookup_user_key(u32 serial, u64 flags)
+ *	Description
+ *		Search a key with a given *serial* and the provided *flags*. The
+ *		returned key, if found, has the reference count incremented by
+ *		one, and must be passed to bpf_key_put() when done with it.
+ *		Permission checks are deferred to the time the key is used by
+ *		one of the available key-specific helpers.
+ *
+ *		Set *flags* with 1 to attempt creating a requested special
+ *		keyring (e.g. session keyring), if it doesn't yet exist. Set
+ *		*flags* to 2 to lookup a key without waiting for the key
+ *		construction, and to retrieve uninstantiated keys (keys without
+ *		data attached to them).
+ *	Return
+ *		A key pointer if the key is found, a NULL pointer otherwise.
+ *
+ * void bpf_key_put(struct key *key)
+ *	Description
+ *		Decrement the reference count of *key* obtained with the
+ *		bpf_lookup_user_key() helper.
+ *	Return
+ *		0
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5537,6 +5560,8 @@ union bpf_attr {
 	FN(tcp_raw_gen_syncookie_ipv6),	\
 	FN(tcp_raw_check_syncookie_ipv4),	\
 	FN(tcp_raw_check_syncookie_ipv6),	\
+	FN(lookup_user_key),		\
+	FN(key_put),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index d469b7f3deef..0a95e2137d65 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -184,6 +184,51 @@ static const struct bpf_func_proto bpf_get_attach_cookie_proto = {
 	.arg1_type	= ARG_PTR_TO_CTX,
 };
 
+#ifdef CONFIG_KEYS
+BTF_ID_LIST_SINGLE(btf_key_ids, struct, key)
+
+BPF_CALL_2(bpf_lookup_user_key, u32, serial, u64, flags)
+{
+	key_ref_t key_ref;
+
+	/* Keep in sync with include/linux/key.h. */
+	if (flags > (KEY_LOOKUP_PARTIAL << 1) - 1)
+		return (unsigned long)NULL;
+
+	/* Permission check is deferred until actual helper using the key. */
+	key_ref = lookup_user_key(serial, flags, KEY_DEFER_PERM_CHECK);
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
@@ -239,6 +284,14 @@ bpf_lsm_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 					prog->aux->attach_btf_id))
 			return &bpf_unlocked_sk_getsockopt_proto;
 		return NULL;
+#ifdef CONFIG_KEYS
+	case BPF_FUNC_lookup_user_key:
+		return prog->aux->sleepable ?
+		       &bpf_lookup_user_key_proto : NULL;
+	case BPF_FUNC_key_put:
+		return prog->aux->sleepable ?
+		       &bpf_key_put_proto : NULL;
+#endif /* CONFIG_KEYS */
 	default:
 		return tracing_prog_func_proto(func_id, prog);
 	}
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 328cfab3af60..d9f52fbfb660 100644
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
index 379e68fb866f..a3f6506ddeba 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5327,6 +5327,29 @@ union bpf_attr {
  *		**-EACCES** if the SYN cookie is not valid.
  *
  *		**-EPROTONOSUPPORT** if CONFIG_IPV6 is not builtin.
+ *
+ * struct key *bpf_lookup_user_key(u32 serial, u64 flags)
+ *	Description
+ *		Search a key with a given *serial* and the provided *flags*. The
+ *		returned key, if found, has the reference count incremented by
+ *		one, and must be passed to bpf_key_put() when done with it.
+ *		Permission checks are deferred to the time the key is used by
+ *		one of the available key-specific helpers.
+ *
+ *		Set *flags* with 1 to attempt creating a requested special
+ *		keyring (e.g. session keyring), if it doesn't yet exist. Set
+ *		*flags* to 2 to lookup a key without waiting for the key
+ *		construction, and to retrieve uninstantiated keys (keys without
+ *		data attached to them).
+ *	Return
+ *		A key pointer if the key is found, a NULL pointer otherwise.
+ *
+ * void bpf_key_put(struct key *key)
+ *	Description
+ *		Decrement the reference count of *key* obtained with the
+ *		bpf_lookup_user_key() helper.
+ *	Return
+ *		0
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5537,6 +5560,8 @@ union bpf_attr {
 	FN(tcp_raw_gen_syncookie_ipv6),	\
 	FN(tcp_raw_check_syncookie_ipv4),	\
 	FN(tcp_raw_check_syncookie_ipv6),	\
+	FN(lookup_user_key),		\
+	FN(key_put),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.25.1

