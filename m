Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86EEF58D391
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 08:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236270AbiHIGIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 02:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236254AbiHIGIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 02:08:50 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E0B175B8;
        Mon,  8 Aug 2022 23:08:49 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1660025326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nn8HpLI7UMZhD6fnzbEyryarR8wsr+6bgYT5KEeEP0A=;
        b=roIkkCSFzcDNDfC0+xYOxYiUh2+YjvbLD3Yk102EDbNnXNQIo7JvdPCsgSSMYQ90M36l6W
        dzqgZqu1dqFc9Wy/Ja1FxhIN34xn2XSTj1gn8vlrA5ifVxeBKAnQqfgXAuwCuE1N97iLL8
        Z3W5L2t/KQ9aOO8XjE4GHuO8lZ4zbXKTSvJ6a7Aoi6IuzSCfkCnGeZfEgyKwPHjw/KHiYb
        +V9ZLY0v+r2dhCPZYumgHY6RvUozK2GUFa5YJrSgmEs3+AijboBWZQG4zNggUixY2s3nYQ
        cN7iyVoOLh0vHBQwGaIEq+/1pAzYI8Br6qGcc1FYvcHcRk3CJU7rNaBhLdqf8g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1660025326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nn8HpLI7UMZhD6fnzbEyryarR8wsr+6bgYT5KEeEP0A=;
        b=u6Fo5NjVwFiAgk35Dw3EOYZbZK/D5RvM5nZPL1zT/cJlbICKlCpGILiSfBD+fKC41s/qXz
        Kni4VSI/0r/YWJCA==
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
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH bpf-next v2 1/2] bpf: Add BPF-helper for accessing CLOCK_TAI
Date:   Tue,  9 Aug 2022 08:08:02 +0200
Message-Id: <20220809060803.5773-2-kurt@linutronix.de>
In-Reply-To: <20220809060803.5773-1-kurt@linutronix.de>
References: <20220809060803.5773-1-kurt@linutronix.de>
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

Use cases for such a BPF helper include functionalities such as Tx launch
time (e.g. ETF and TAPRIO Qdiscs) and timestamping.

Note: CLOCK_TAI is nothing new per se, only the NMI-safe variant of it is.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
[Kurt: Wrote changelog and renamed helper]
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 include/linux/bpf.h            |  1 +
 include/uapi/linux/bpf.h       | 13 +++++++++++++
 kernel/bpf/core.c              |  1 +
 kernel/bpf/helpers.c           | 14 ++++++++++++++
 tools/include/uapi/linux/bpf.h | 13 +++++++++++++
 5 files changed, 42 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 20c26aed7896..a627a02cf8ab 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2349,6 +2349,7 @@ extern const struct bpf_func_proto bpf_get_numa_node_id_proto;
 extern const struct bpf_func_proto bpf_tail_call_proto;
 extern const struct bpf_func_proto bpf_ktime_get_ns_proto;
 extern const struct bpf_func_proto bpf_ktime_get_boot_ns_proto;
+extern const struct bpf_func_proto bpf_ktime_get_tai_ns_proto;
 extern const struct bpf_func_proto bpf_get_current_pid_tgid_proto;
 extern const struct bpf_func_proto bpf_get_current_uid_gid_proto;
 extern const struct bpf_func_proto bpf_get_current_comm_proto;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 534e33fb1029..7d1e2794d83e 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5341,6 +5341,18 @@ union bpf_attr {
  *		**-EACCES** if the SYN cookie is not valid.
  *
  *		**-EPROTONOSUPPORT** if CONFIG_IPV6 is not builtin.
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
@@ -5551,6 +5563,7 @@ union bpf_attr {
 	FN(tcp_raw_gen_syncookie_ipv6),	\
 	FN(tcp_raw_check_syncookie_ipv4),	\
 	FN(tcp_raw_check_syncookie_ipv6),	\
+	FN(ktime_get_tai_ns),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index c1e10d088dbb..639437f36928 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2623,6 +2623,7 @@ const struct bpf_func_proto bpf_get_numa_node_id_proto __weak;
 const struct bpf_func_proto bpf_ktime_get_ns_proto __weak;
 const struct bpf_func_proto bpf_ktime_get_boot_ns_proto __weak;
 const struct bpf_func_proto bpf_ktime_get_coarse_ns_proto __weak;
+const struct bpf_func_proto bpf_ktime_get_tai_ns_proto __weak;
 
 const struct bpf_func_proto bpf_get_current_pid_tgid_proto __weak;
 const struct bpf_func_proto bpf_get_current_uid_gid_proto __weak;
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 1f961f9982d2..a95eb9fb01ff 100644
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
@@ -1617,6 +1629,8 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return &bpf_ktime_get_ns_proto;
 	case BPF_FUNC_ktime_get_boot_ns:
 		return &bpf_ktime_get_boot_ns_proto;
+	case BPF_FUNC_ktime_get_tai_ns:
+		return &bpf_ktime_get_tai_ns_proto;
 	case BPF_FUNC_ringbuf_output:
 		return &bpf_ringbuf_output_proto;
 	case BPF_FUNC_ringbuf_reserve:
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index f58d58e1d547..e174ad28aeb7 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5341,6 +5341,18 @@ union bpf_attr {
  *		**-EACCES** if the SYN cookie is not valid.
  *
  *		**-EPROTONOSUPPORT** if CONFIG_IPV6 is not builtin.
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
@@ -5551,6 +5563,7 @@ union bpf_attr {
 	FN(tcp_raw_gen_syncookie_ipv6),	\
 	FN(tcp_raw_check_syncookie_ipv4),	\
 	FN(tcp_raw_check_syncookie_ipv6),	\
+	FN(ktime_get_tai_ns),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.30.2

