Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1F653EC58
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233959AbiFFKim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 06:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233906AbiFFKil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 06:38:41 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 679A11EEEA;
        Mon,  6 Jun 2022 03:38:39 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1654511917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=erdy93WinNJjx6uD82mv+yWGkqgDaA0e53sz3wPEsFQ=;
        b=3UrNR+7IZ25/Ac1Qmcdc46k78hzdqV2gd78pScar/t9rp2sT4hSvEE7klo3xyQFQRoJ7sn
        P/YhaWQto8MUrwEE1xhMUG9cuMMS+j77wbF3huxubSh00qd7XAxVZTLQmswKBJa6FLut+L
        MlTwACnMnFg9VBYD6joZMkvARpkzRDZh3vTRyrYX5bETXM0BP1hIAtk/cTLD7HV8WLXZLB
        erLXm6PEj8ONHeP3yEo59BaBB2iRYMhY+sIj63/wWx8vpjoP0Huigdi2SQOMoT5cIKLXxE
        S/rQBq6I0G/jr8WgBuEqqyQXOa2/o2Z2atBSbGYukVEXS4NTD3HOz5HD9qdU7g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1654511917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=erdy93WinNJjx6uD82mv+yWGkqgDaA0e53sz3wPEsFQ=;
        b=AeTkxR2jswDHlpY2O1kzWTPlLR8FdedY4RBvGXpFrNKULaFioC4TgCZznW0BPz00sLNWWk
        eGBBiT1zU+UE/2Ag==
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Joanne Koong <joannelkoong@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Geliang Tang <geliang.tang@suse.com>,
        Jakub Sitnicki <jakub@cloudflare.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH bpf-next] bpf: Add BPF-helper for accessing CLOCK_TAI
Date:   Mon,  6 Jun 2022 12:37:34 +0200
Message-Id: <20220606103734.92423-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

Commit 3dc6ffae2da2 ("timekeeping: Introduce fast accessor to clock tai")
introduced a fast and NMI-safe accessor for CLOCK_TAI. Especially in time
sensitive networks (TSN), where all nodes are synchronized by Precision Time
Protocol (PTP), it's helpful to have the possibility to generate timestamps
based on CLOCK_TAI instead of CLOCK_MONOTONIC. With a BPF helper for TAI in
place, it becomes very convenient to correlate activity across different
machines in the network.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
[Kurt: Wrote changelog and renamed helper]
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 include/uapi/linux/bpf.h       | 13 +++++++++++++
 kernel/bpf/core.c              |  1 +
 kernel/bpf/helpers.c           | 14 ++++++++++++++
 tools/include/uapi/linux/bpf.h | 13 +++++++++++++
 4 files changed, 41 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index f4009dbdf62d..5f240d5d30f6 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5249,6 +5249,18 @@ union bpf_attr {
  *		Pointer to the underlying dynptr data, NULL if the dynptr is
  *		read-only, if the dynptr is invalid, or if the offset and length
  *		is out of bounds.
+ *
+ * u64 bpf_ktime_get_tai_ns(void)
+ *	Description
+ *		A nonsettable system-wide clock derived from wall-clock time but
+ *		ignoring leap seconds.  This clock does not experience
+ *		discontinuities and backwards jumps caused by NTP inserting leap
+ *		seconds as CLOCK_REALTIME does.
+ *
+ *		See: **clock_gettime**\ (**CLOCK_TAI**)
+ *	Return
+ *		Current *ktime*.
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5455,6 +5467,7 @@ union bpf_attr {
 	FN(dynptr_read),		\
 	FN(dynptr_write),		\
 	FN(dynptr_data),		\
+	FN(ktime_get_tai_ns),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index e78cc5eea4a5..edfa716c3528 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2641,6 +2641,7 @@ const struct bpf_func_proto bpf_get_numa_node_id_proto __weak;
 const struct bpf_func_proto bpf_ktime_get_ns_proto __weak;
 const struct bpf_func_proto bpf_ktime_get_boot_ns_proto __weak;
 const struct bpf_func_proto bpf_ktime_get_coarse_ns_proto __weak;
+const struct bpf_func_proto bpf_ktime_get_tai_ns_proto __weak;
 
 const struct bpf_func_proto bpf_get_current_pid_tgid_proto __weak;
 const struct bpf_func_proto bpf_get_current_uid_gid_proto __weak;
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 225806a02efb..981b34d1e551 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -198,6 +198,18 @@ const struct bpf_func_proto bpf_ktime_get_coarse_ns_proto = {
 	.ret_type	= RET_INTEGER,
 };
 
+BPF_CALL_0(bpf_ktime_get_tai_ns)
+{
+	/* NMI safe access to clock tai */
+	return ktime_get_tai_fast_ns();
+}
+
+const struct bpf_func_proto bpf_ktime_get_tai_ns_proto = {
+	.func		= bpf_ktime_get_tai_ns,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+};
+
 BPF_CALL_0(bpf_get_current_pid_tgid)
 {
 	struct task_struct *task = current;
@@ -1613,6 +1625,8 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return &bpf_ktime_get_ns_proto;
 	case BPF_FUNC_ktime_get_boot_ns:
 		return &bpf_ktime_get_boot_ns_proto;
+	case BPF_FUNC_ktime_get_tai_ns:
+		return &bpf_ktime_get_tai_ns_proto;
 	case BPF_FUNC_ringbuf_output:
 		return &bpf_ringbuf_output_proto;
 	case BPF_FUNC_ringbuf_reserve:
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index f4009dbdf62d..5f240d5d30f6 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5249,6 +5249,18 @@ union bpf_attr {
  *		Pointer to the underlying dynptr data, NULL if the dynptr is
  *		read-only, if the dynptr is invalid, or if the offset and length
  *		is out of bounds.
+ *
+ * u64 bpf_ktime_get_tai_ns(void)
+ *	Description
+ *		A nonsettable system-wide clock derived from wall-clock time but
+ *		ignoring leap seconds.  This clock does not experience
+ *		discontinuities and backwards jumps caused by NTP inserting leap
+ *		seconds as CLOCK_REALTIME does.
+ *
+ *		See: **clock_gettime**\ (**CLOCK_TAI**)
+ *	Return
+ *		Current *ktime*.
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5455,6 +5467,7 @@ union bpf_attr {
 	FN(dynptr_read),		\
 	FN(dynptr_write),		\
 	FN(dynptr_data),		\
+	FN(ktime_get_tai_ns),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.30.2

