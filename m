Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3558F511205
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 09:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358566AbiD0HLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 03:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240796AbiD0HLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 03:11:45 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F5631934;
        Wed, 27 Apr 2022 00:08:35 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id u7so782896plg.13;
        Wed, 27 Apr 2022 00:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LA+lIWlKJHJNsFg/tTuklJgSyoSg6bZZY0onRO3E9GI=;
        b=b3DoGQtxEeDET/u7R4lDa6hJ/Rht+ReM/kJc9afpeiuLLNMtPSwJyb+zqvfANVrT4N
         mZATO86fRlos5bQ7fMbQFLsMUnOdAkOp5YDze81Jui9SoCulqogVRbsqbTBLl1RlXP6h
         eJyCDKAP7MH6SjVMjkYLbvY23oCzOHwkH9e7ee5M2DTQCEEIrqdU6BHsNOaYJdvGIDWA
         37oc9uPCcLsISG1MPYkr6XqKmPjq7+qHUAxKXqGGXlV1aNC+/RljYbGjjOAZZuB94P07
         d+HnC8Ia7FrCtGtnmtMXBGN0krUyMPGVYx+7Mq2g52F6Y8jAyOUPGDDFbOZagDog+95A
         o+GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LA+lIWlKJHJNsFg/tTuklJgSyoSg6bZZY0onRO3E9GI=;
        b=mMeQOaAjSZTPYE+7AsN/yNGLEQARshAlJjFpqrrGn4Iit4SP6fRZbt9AHK7OIylopp
         lWTXm5WnJXzRCnUT7WzR0tqp44Ge+knYelbhRt4xi3JpwkRWhNINhalZ/78C8GPDfli2
         Rb7+sBQO3kj3FDHW7w/dXANMHtWT2g4iUAs37skdcOb7oNypnJ82f8NlFnmpPzKoaAo3
         JjL9qfdbfCsv8M2sW2PAZ/AmkEXDmzrtj242eiJ8UqvbBpsKHKvgjt0IJEMuvH4G8FQw
         DjD/pqwDQLRJYhMy9lzHxEVvulc0dGSqTT/rm20Qba8ro8LBSHhzB3gKs8MBAoVrn09J
         iUYg==
X-Gm-Message-State: AOAM532i5ZPsJ3jaAeBw2v3hcBvBXQ0oKnX+5YfdkSjkP7m/tECxQWOW
        jbZdfBL22OQ9Qk8Dkv6Usos=
X-Google-Smtp-Source: ABdhPJxTJUjkqPe2DXzILwV+z7KDjrLWr2XioYKZRHJaXuWKVXfjidYA4Um4bqV5tGq1TL48CZQlog==
X-Received: by 2002:a17:902:d5c3:b0:154:c472:de80 with SMTP id g3-20020a170902d5c300b00154c472de80mr27010650plh.87.1651043315130;
        Wed, 27 Apr 2022 00:08:35 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.111])
        by smtp.gmail.com with ESMTPSA id t15-20020a63b70f000000b00381510608e9sm14404314pgf.14.2022.04.27.00.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 00:08:34 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Menglong Dong <imagedong@tencent.com>,
        Jiang Biao <benbjiang@tencent.com>,
        Hao Peng <flyingpeng@tencent.com>
Subject: [PATCH bpf-next] net: bpf: support direct packet access in tracing program
Date:   Wed, 27 Apr 2022 15:06:44 +0800
Message-Id: <20220427070644.319661-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

For now, eBPF program of type TRACING is able to access the arguments
of the function or raw_tracepoint directly, which makes data access
easier and efficient. And we can also output the raw data in skb to
user space in tracing program by bpf_skb_output() helper.

However, we still can't access the packet data in 'struct sk_buff'
directly and have to use the helper bpf_probe_read_kernel() to analyse
packet data.

Network tools, which based on eBPF TRACING, often do packet analyse
works in tracing program for filtering, statistics, etc. For example,
we want to trace abnormal skb free through 'kfree_skb' tracepoint with
special ip address or tcp port.

In this patch, 2 helpers are introduced: bpf_skb_get_header() and
bpf_skb_get_end(). The pointer returned by bpf_skb_get_header() has
the same effect with the 'data' in 'struct __sk_buff', and
bpf_skb_get_end() has the same effect with the 'data_end'.

Therefore, we can now access packet data in tracing program in this
way:

  SEC("fentry/icmp_rcv")
  int BPF_PROG(tracing_open, struct sk_buff* skb)
  {
  	void *data, *data_end;
  	struct ethhdr *eth;

  	data = bpf_skb_get_header(skb, BPF_SKB_HEADER_MAC);
  	data_end = bpf_skb_get_end(skb);

  	if (!data || !data_end)
  		return 0;

  	if (data + sizeof(*eth) > data_end)
  		return 0;

  	eth = data;
  	bpf_printk("proto:%d\n", bpf_ntohs(eth->h_proto));

  	return 0;
  }

With any positive reply, I'll complete the selftests programs.

Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/bpf.h      |  4 +++
 include/uapi/linux/bpf.h | 29 ++++++++++++++++++++
 kernel/bpf/verifier.c    |  6 +++++
 kernel/trace/bpf_trace.c | 58 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 97 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index bdb5298735ce..69dff736331a 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -419,6 +419,8 @@ enum bpf_return_type {
 	RET_PTR_TO_ALLOC_MEM,		/* returns a pointer to dynamically allocated memory */
 	RET_PTR_TO_MEM_OR_BTF_ID,	/* returns a pointer to a valid memory or a btf_id */
 	RET_PTR_TO_BTF_ID,		/* returns a pointer to a btf_id */
+	RET_PTR_TO_PACKET,		/* returns a pointer to packet */
+	RET_PTR_TO_PACKET_END,		/* returns a pointer to skb->data + headlen */
 	__BPF_RET_TYPE_MAX,
 
 	/* Extended ret_types. */
@@ -428,6 +430,8 @@ enum bpf_return_type {
 	RET_PTR_TO_SOCK_COMMON_OR_NULL	= PTR_MAYBE_NULL | RET_PTR_TO_SOCK_COMMON,
 	RET_PTR_TO_ALLOC_MEM_OR_NULL	= PTR_MAYBE_NULL | MEM_ALLOC | RET_PTR_TO_ALLOC_MEM,
 	RET_PTR_TO_BTF_ID_OR_NULL	= PTR_MAYBE_NULL | RET_PTR_TO_BTF_ID,
+	RET_PTR_TO_PACKET_OR_NULL	= PTR_MAYBE_NULL | RET_PTR_TO_PACKET,
+	RET_PTR_TO_PACKET_END_OR_NULL	= PTR_MAYBE_NULL | RET_PTR_TO_PACKET_END,
 
 	/* This must be the last entry. Its purpose is to ensure the enum is
 	 * wide enough to hold the higher bits reserved for bpf_type_flag.
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index d14b10b85e51..841f6e7216f4 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5143,6 +5143,27 @@ union bpf_attr {
  *		The **hash_algo** is returned on success,
  *		**-EOPNOTSUP** if the hash calculation failed or **-EINVAL** if
  *		invalid arguments are passed.
+ *
+ * void *bpf_skb_get_header(struct sk_buff *skb, u32 flags)
+ *	Description
+ *		Get packet header from skb in tracing program, which can
+ *		be access (read) directly. According to the *flags*,
+ *		different packet header is returned:
+ *
+ *			**BPF_SKB_HEADER_MAC**: get mac (L2) header
+ *			**BPF_SKB_HEADER_NETWORK**: get network (L3) header
+ *			**BPF_SKB_HEADER_TRANSPORT**:
+ *				get transport (L4) header
+ *	Return
+ *		The pointer to packet header on success, NULL on fail.
+ *
+ * void *bpf_skb_get_end(struct sk_buff *skb)
+ *	Description
+ *		Get packet head end pointer from skb in tracing program,
+ *		which is equal to *data_end* in *struct __sk_buff*.
+ *	Return
+ *		The pointer to packet head end on success, and NULL on
+ *		failing.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5339,6 +5360,8 @@ union bpf_attr {
 	FN(copy_from_user_task),	\
 	FN(skb_set_tstamp),		\
 	FN(ima_file_hash),		\
+	FN(skb_get_header),		\
+	FN(skb_get_end),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
@@ -5537,6 +5560,12 @@ enum {
 	 */
 };
 
+enum {
+	BPF_SKB_HEADER_MAC,
+	BPF_SKB_HEADER_NETWORK,
+	BPF_SKB_HEADER_TRANSPORT,
+};
+
 /* user accessible mirror of in-kernel sk_buff.
  * new fields can only be added to the end of this structure
  */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 9c1a02b82ecd..caf4e09cc114 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6877,6 +6877,12 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 		 */
 		regs[BPF_REG_0].btf = btf_vmlinux;
 		regs[BPF_REG_0].btf_id = ret_btf_id;
+	} else if (base_type(ret_type) == RET_PTR_TO_PACKET) {
+		mark_reg_known_zero(env, regs, BPF_REG_0);
+		regs[BPF_REG_0].type = PTR_TO_PACKET | ret_flag;
+	} else if (base_type(ret_type) == RET_PTR_TO_PACKET_END) {
+		mark_reg_known_zero(env, regs, BPF_REG_0);
+		regs[BPF_REG_0].type = PTR_TO_PACKET_END | ret_flag;
 	} else {
 		verbose(env, "unknown return type %u of func %s#%d\n",
 			base_type(ret_type), func_id_name(func_id), func_id);
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index b26f3da943de..6f2cd30aac07 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -810,6 +810,60 @@ static const struct bpf_func_proto bpf_current_task_under_cgroup_proto = {
 	.arg2_type      = ARG_ANYTHING,
 };
 
+BPF_CALL_2(bpf_skb_get_header, struct sk_buff *, skb, u32, flags)
+{
+	void *header = NULL;
+
+	if (!skb)
+		return (unsigned long)NULL;
+
+	switch (flags) {
+	case BPF_SKB_HEADER_MAC:
+		if (skb_mac_header_was_set(skb) && skb->mac_header)
+			header = skb_mac_header(skb);
+		break;
+	case BPF_SKB_HEADER_TRANSPORT:
+		if (skb_transport_header_was_set(skb) &&
+		    skb->transport_header)
+			header = skb_transport_header(skb);
+		break;
+	case BPF_SKB_HEADER_NETWORK:
+		if (skb->network_header)
+			header = skb_network_header(skb);
+		break;
+	default:
+		break;
+	}
+
+	return (unsigned long)header;
+}
+
+BTF_ID_LIST_SINGLE(bpf_get_skb_ids, struct, sk_buff);
+static const struct bpf_func_proto bpf_skb_get_header_proto = {
+	.func           = bpf_skb_get_header,
+	.gpl_only       = false,
+	.ret_type       = RET_PTR_TO_PACKET_OR_NULL,
+	.arg1_type      = ARG_PTR_TO_BTF_ID,
+	.arg1_btf_id	= &bpf_get_skb_ids[0],
+	.arg2_type      = ARG_ANYTHING,
+};
+
+BPF_CALL_1(bpf_skb_get_end, struct sk_buff *, skb)
+{
+	if (!skb)
+		return (unsigned long)NULL;
+
+	return (unsigned long)skb->data + skb_headlen(skb);
+}
+
+static const struct bpf_func_proto bpf_skb_get_end_proto = {
+	.func           = bpf_skb_get_end,
+	.gpl_only       = false,
+	.ret_type       = RET_PTR_TO_PACKET_END_OR_NULL,
+	.arg1_type      = ARG_PTR_TO_BTF_ID,
+	.arg1_btf_id	= &bpf_get_skb_ids[0],
+};
+
 struct send_signal_irq_work {
 	struct irq_work irq_work;
 	struct task_struct *task;
@@ -1282,6 +1336,10 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_get_branch_snapshot_proto;
 	case BPF_FUNC_find_vma:
 		return &bpf_find_vma_proto;
+	case BPF_FUNC_skb_get_header:
+		return &bpf_skb_get_header_proto;
+	case BPF_FUNC_skb_get_end:
+		return &bpf_skb_get_end_proto;
 	case BPF_FUNC_trace_vprintk:
 		return bpf_get_trace_vprintk_proto();
 	default:
-- 
2.36.0

