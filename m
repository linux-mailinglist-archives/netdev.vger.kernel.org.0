Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29CB53FBB15
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 19:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238269AbhH3Rf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 13:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238246AbhH3Rfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 13:35:45 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABE6C06175F;
        Mon, 30 Aug 2021 10:34:51 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id j1so9990655pjv.3;
        Mon, 30 Aug 2021 10:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bJX0AyGbd9hRRY146ZMmI0dinbkaM5zuyV0rfjoDisU=;
        b=Qq+CnHyv5m4HjssH1RgPO4TujobZBA1MM1tvwHto6xYnnJMncTeF7B5N6q5oxyqHNg
         19n0gQAbAlaZauXZsRS6Jib6MbIv/EV5qjoNJ/GRC9kgA2bACVtnG2EVAN1T6YcFF8Wc
         Z3IQK7nVdWg5uUhOcC6S388gqpPFGIVv/3vcWR+PyAgPsaQJVcL6yAvSuSyoS7rdlNxA
         H4j12VeBUjrLeuJ1+u0FAEslnbhesE5jODhNXxUaKfMtnbjGhonUmiY9b6iFkQsFb6XD
         tXRMzG817PUezbRQByoGrmpXcsqHlYkgr8+hiswlOTAj475KcCqZ4okRhtEgPTRjIppV
         TwXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bJX0AyGbd9hRRY146ZMmI0dinbkaM5zuyV0rfjoDisU=;
        b=MpuMUoHhynj9RVJXqPYNxPMFtZpuRR+513q1sUfVFp/AIwsguGJ474Q6Lw2gUqF+SI
         kAN1REa1i2BxHvFcJOiozFb/K/3CzQ5Qn4ay7naZMtI9sgy7t6J84yUl7u5r33cRIyf7
         IfTk3XtNCy+SFXiTSu/+K7115uUBn31n3aciL6nJjnh67UnXOc9mfh3hCJI1K7IFDcWU
         6pb7fYngGrTj9zPaSAnOM2/r/nqnvTAXpCVL7FjTOQ/KHEayD44gyJgCZNXi1WDzZlkj
         ++1Zdo4y8PUiZuX+F/a2E+CHDlRnWCeL1/tCEr2uf2VJGoIqMKXgFz8gjEkAX6Qe3FaO
         N4IQ==
X-Gm-Message-State: AOAM533nAedHtJSy8SbvtsL0+As28cPQyafp6io2/hKnuPbzdNJsAsR+
        I/N12EazQ53bshsyDkMMFp2ejdn5k9vk7Q==
X-Google-Smtp-Source: ABdhPJz/HTeG8P9fK1cv0kRx0EaFE8jdd16Xk43wqj3v72r26cg1mLqqGjFCG6dfzzwk8ypJTc4IeQ==
X-Received: by 2002:a17:90a:bd81:: with SMTP id z1mr176824pjr.207.1630344891137;
        Mon, 30 Aug 2021 10:34:51 -0700 (PDT)
Received: from localhost ([2405:201:6014:d820:9cc6:d37f:c2fd:dc6])
        by smtp.gmail.com with ESMTPSA id fh2sm106158pjb.12.2021.08.30.10.34.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 10:34:50 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next RFC v1 7/8] bpf: enable TCP congestion control kfunc from modules
Date:   Mon, 30 Aug 2021 23:04:23 +0530
Message-Id: <20210830173424.1385796-8-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210830173424.1385796-1-memxor@gmail.com>
References: <20210830173424.1385796-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8888; h=from:subject; bh=+wtSmbpHsLJhBkA9+XpBdzDEaE4kFWY7r1NXIZIdqpA=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhLRX9ZywhGY9TnA5oV1T2mVNV2NjEuhC+tXxzaki0 NE2MmwmJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYS0V/QAKCRBM4MiGSL8Rym8IEA CbKSm7lCT4wFhp1hkv/DIm8aHSzaj7l9r/KH5pcSbulg5NakptpCwOM9Z3j6H8EWfwjKV/NwYRqhaJ UXL4U/VD7f8b0MRokY82d0FWGu9iDy21kc3+c7ssIs4vd7yNQYDXWpnoq1A1ltxVvshsy1FRRSsM4G 84q8YpvXJHEqOUJkH2swbsRQs6mU65iS2U8OaA1HjnXAZojTEjIB3+IYZ2wRYKSD/eCBBtGUxSSDtu jsWY1tJaGSpFcV7PVmSiFNNdXYOkzWhlApg+8QvT1GJ6Jp/9isZhR+8badRvmjgTY3DS55lMqE+/c2 8iSeLMxRQxfnfqjBEzi+1z3yvf4AteH827uRXBNy1jGF4kjQspOnmlBSl5jN7gvWlTsFEernI692C2 F0x2GIY6VFfY7YxfiJmbIamvqRUhrISe63a2oE3eNY3lJIt7uqQ/rdprLlRyqSCVrh4w30t3CzEyQi ln8DejTFHDD9aeccglaBN4iX8wCKWVzscTG3937kVbpGFRlG2z3lhDzVH988a1WTuIQ+atYgEuV5vc 3TM3Qk0uf/nEeT9k7afitbwWqGIOppElZgDX0A/Gx3/sfeWGMiJvGsyeMyX0NAPZUTYfEHczPuAIf2 M0rFGckyl94WT9mConWlndDjA9ntwOO8Xx9p7S69K8UL4L9j4Am7TDSbZNuQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit moves BTF ID lookup into the newly added registration
helper, in a way that the bbr, cubic, and dctcp implementation set up
their sets in the bpf_tcp_ca kfunc_btf_set list, while the ones not
dependent on modules are looked up from the wrapper function.

This lifts the restriction for them to be compiled as built in objects,
and can be loaded as modules if required. Also modify link-vmlinux.sh to
resolve_btfids in TCP congestion control modules if the config option is
set, using the base BTF support added in the previous commit.

See following commits for background on use of:

 CONFIG_X86 ifdef:
 569c484f9995 (bpf: Limit static tcp-cc functions in the .BTF_ids list to x86)

 CONFIG_DYNAMIC_FTRACE ifdef:
 7aae231ac93b (bpf: tcp: Limit calling some tcp cc functions to CONFIG_DYNAMIC_FTRACE)

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/btf.h       |  2 ++
 kernel/bpf/btf.c          |  2 ++
 net/ipv4/bpf_tcp_ca.c     | 34 +++-------------------------------
 net/ipv4/tcp_bbr.c        | 28 +++++++++++++++++++++++++++-
 net/ipv4/tcp_cubic.c      | 26 +++++++++++++++++++++++++-
 net/ipv4/tcp_dctcp.c      | 26 +++++++++++++++++++++++++-
 scripts/Makefile.modfinal |  1 +
 7 files changed, 85 insertions(+), 34 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index d024b0eb43f9..8c0f29ed2af9 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -253,4 +253,6 @@ struct kfunc_btf_set {
 #define DEFINE_KFUNC_BTF_SET(set, name)                                        \
 	struct kfunc_btf_set name = { LIST_HEAD_INIT(name.list), (set) }
 
+DECLARE_KFUNC_BTF_SET_REG(bpf_tcp_ca);
+
 #endif
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 35873495761d..cc12470a55f9 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6249,3 +6249,5 @@ BTF_ID_LIST_GLOBAL_SINGLE(btf_task_struct_ids, struct, task_struct)
 		mutex_unlock(&type##_kfunc_btf_set_mutex);                     \
 	}                                                                      \
 	EXPORT_SYMBOL_GPL(unregister_##type##_kfunc_btf_set)
+
+DEFINE_KFUNC_BTF_SET_REG(bpf_tcp_ca);
diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index 0dcee9df1326..804f2f912fe9 100644
--- a/net/ipv4/bpf_tcp_ca.c
+++ b/net/ipv4/bpf_tcp_ca.c
@@ -223,41 +223,13 @@ BTF_ID(func, tcp_reno_cong_avoid)
 BTF_ID(func, tcp_reno_undo_cwnd)
 BTF_ID(func, tcp_slow_start)
 BTF_ID(func, tcp_cong_avoid_ai)
-#ifdef CONFIG_X86
-#ifdef CONFIG_DYNAMIC_FTRACE
-#if IS_BUILTIN(CONFIG_TCP_CONG_CUBIC)
-BTF_ID(func, cubictcp_init)
-BTF_ID(func, cubictcp_recalc_ssthresh)
-BTF_ID(func, cubictcp_cong_avoid)
-BTF_ID(func, cubictcp_state)
-BTF_ID(func, cubictcp_cwnd_event)
-BTF_ID(func, cubictcp_acked)
-#endif
-#if IS_BUILTIN(CONFIG_TCP_CONG_DCTCP)
-BTF_ID(func, dctcp_init)
-BTF_ID(func, dctcp_update_alpha)
-BTF_ID(func, dctcp_cwnd_event)
-BTF_ID(func, dctcp_ssthresh)
-BTF_ID(func, dctcp_cwnd_undo)
-BTF_ID(func, dctcp_state)
-#endif
-#if IS_BUILTIN(CONFIG_TCP_CONG_BBR)
-BTF_ID(func, bbr_init)
-BTF_ID(func, bbr_main)
-BTF_ID(func, bbr_sndbuf_expand)
-BTF_ID(func, bbr_undo_cwnd)
-BTF_ID(func, bbr_cwnd_event)
-BTF_ID(func, bbr_ssthresh)
-BTF_ID(func, bbr_min_tso_segs)
-BTF_ID(func, bbr_set_state)
-#endif
-#endif  /* CONFIG_DYNAMIC_FTRACE */
-#endif	/* CONFIG_X86 */
 BTF_SET_END(bpf_tcp_ca_kfunc_ids)
 
 static bool bpf_tcp_ca_check_kfunc_call(u32 kfunc_btf_id)
 {
-	return btf_id_set_contains(&bpf_tcp_ca_kfunc_ids, kfunc_btf_id);
+	if (btf_id_set_contains(&bpf_tcp_ca_kfunc_ids, kfunc_btf_id))
+		return true;
+	return __bpf_check_bpf_tcp_ca_kfunc_call(kfunc_btf_id);
 }
 
 static const struct bpf_verifier_ops bpf_tcp_ca_verifier_ops = {
diff --git a/net/ipv4/tcp_bbr.c b/net/ipv4/tcp_bbr.c
index 6274462b86b4..1fea15dd0e05 100644
--- a/net/ipv4/tcp_bbr.c
+++ b/net/ipv4/tcp_bbr.c
@@ -56,6 +56,8 @@
  * otherwise TCP stack falls back to an internal pacing using one high
  * resolution timer per TCP socket and may use more resources.
  */
+#include <linux/btf.h>
+#include <linux/btf_ids.h>
 #include <linux/module.h>
 #include <net/tcp.h>
 #include <linux/inet_diag.h>
@@ -1152,14 +1154,38 @@ static struct tcp_congestion_ops tcp_bbr_cong_ops __read_mostly = {
 	.set_state	= bbr_set_state,
 };
 
+BTF_SET_START(tcp_bbr_kfunc_ids)
+#ifdef CONFIG_X86
+#ifdef CONFIG_DYNAMIC_FTRACE
+BTF_ID(func, bbr_init)
+BTF_ID(func, bbr_main)
+BTF_ID(func, bbr_sndbuf_expand)
+BTF_ID(func, bbr_undo_cwnd)
+BTF_ID(func, bbr_cwnd_event)
+BTF_ID(func, bbr_ssthresh)
+BTF_ID(func, bbr_min_tso_segs)
+BTF_ID(func, bbr_set_state)
+#endif
+#endif
+BTF_SET_END(tcp_bbr_kfunc_ids)
+
+static DEFINE_KFUNC_BTF_SET(&tcp_bbr_kfunc_ids, tcp_bbr_kfunc_btf_set);
+
 static int __init bbr_register(void)
 {
+	int ret;
+
 	BUILD_BUG_ON(sizeof(struct bbr) > ICSK_CA_PRIV_SIZE);
-	return tcp_register_congestion_control(&tcp_bbr_cong_ops);
+	ret = tcp_register_congestion_control(&tcp_bbr_cong_ops);
+	if (ret)
+		return ret;
+	register_bpf_tcp_ca_kfunc_btf_set(&tcp_bbr_kfunc_btf_set);
+	return 0;
 }
 
 static void __exit bbr_unregister(void)
 {
+	unregister_bpf_tcp_ca_kfunc_btf_set(&tcp_bbr_kfunc_btf_set);
 	tcp_unregister_congestion_control(&tcp_bbr_cong_ops);
 }
 
diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index 4a30deaa9a37..5b36b9442797 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -25,6 +25,8 @@
  */
 
 #include <linux/mm.h>
+#include <linux/btf.h>
+#include <linux/btf_ids.h>
 #include <linux/module.h>
 #include <linux/math64.h>
 #include <net/tcp.h>
@@ -482,8 +484,25 @@ static struct tcp_congestion_ops cubictcp __read_mostly = {
 	.name		= "cubic",
 };
 
+BTF_SET_START(tcp_cubic_kfunc_ids)
+#ifdef CONFIG_X86
+#ifdef CONFIG_DYNAMIC_FTRACE
+BTF_ID(func, cubictcp_init)
+BTF_ID(func, cubictcp_recalc_ssthresh)
+BTF_ID(func, cubictcp_cong_avoid)
+BTF_ID(func, cubictcp_state)
+BTF_ID(func, cubictcp_cwnd_event)
+BTF_ID(func, cubictcp_acked)
+#endif
+#endif
+BTF_SET_END(tcp_cubic_kfunc_ids)
+
+static DEFINE_KFUNC_BTF_SET(&tcp_cubic_kfunc_ids, tcp_cubic_kfunc_btf_set);
+
 static int __init cubictcp_register(void)
 {
+	int ret;
+
 	BUILD_BUG_ON(sizeof(struct bictcp) > ICSK_CA_PRIV_SIZE);
 
 	/* Precompute a bunch of the scaling factors that are used per-packet
@@ -514,11 +533,16 @@ static int __init cubictcp_register(void)
 	/* divide by bic_scale and by constant Srtt (100ms) */
 	do_div(cube_factor, bic_scale * 10);
 
-	return tcp_register_congestion_control(&cubictcp);
+	ret = tcp_register_congestion_control(&cubictcp);
+	if (ret)
+		return ret;
+	register_bpf_tcp_ca_kfunc_btf_set(&tcp_cubic_kfunc_btf_set);
+	return 0;
 }
 
 static void __exit cubictcp_unregister(void)
 {
+	unregister_bpf_tcp_ca_kfunc_btf_set(&tcp_cubic_kfunc_btf_set);
 	tcp_unregister_congestion_control(&cubictcp);
 }
 
diff --git a/net/ipv4/tcp_dctcp.c b/net/ipv4/tcp_dctcp.c
index 79f705450c16..efc47b4c7a11 100644
--- a/net/ipv4/tcp_dctcp.c
+++ b/net/ipv4/tcp_dctcp.c
@@ -36,6 +36,8 @@
  *	Glenn Judd <glenn.judd@morganstanley.com>
  */
 
+#include <linux/btf.h>
+#include <linux/btf_ids.h>
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <net/tcp.h>
@@ -236,14 +238,36 @@ static struct tcp_congestion_ops dctcp_reno __read_mostly = {
 	.name		= "dctcp-reno",
 };
 
+BTF_SET_START(tcp_dctcp_kfunc_ids)
+#ifdef CONFIG_X86
+#ifdef CONFIG_DYNAMIC_FTRACE
+BTF_ID(func, dctcp_init)
+BTF_ID(func, dctcp_update_alpha)
+BTF_ID(func, dctcp_cwnd_event)
+BTF_ID(func, dctcp_ssthresh)
+BTF_ID(func, dctcp_cwnd_undo)
+BTF_ID(func, dctcp_state)
+#endif
+#endif
+BTF_SET_END(tcp_dctcp_kfunc_ids)
+
+static DEFINE_KFUNC_BTF_SET(&tcp_dctcp_kfunc_ids, tcp_dctcp_kfunc_btf_set);
+
 static int __init dctcp_register(void)
 {
+	int ret;
+
 	BUILD_BUG_ON(sizeof(struct dctcp) > ICSK_CA_PRIV_SIZE);
-	return tcp_register_congestion_control(&dctcp);
+	ret = tcp_register_congestion_control(&dctcp);
+	if (ret)
+		return ret;
+	register_bpf_tcp_ca_kfunc_btf_set(&tcp_dctcp_kfunc_btf_set);
+	return 0;
 }
 
 static void __exit dctcp_unregister(void)
 {
+	unregister_bpf_tcp_ca_kfunc_btf_set(&tcp_dctcp_kfunc_btf_set);
 	tcp_unregister_congestion_control(&dctcp);
 }
 
diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
index 5e9b8057fb24..0755d4b8b74a 100644
--- a/scripts/Makefile.modfinal
+++ b/scripts/Makefile.modfinal
@@ -58,6 +58,7 @@ quiet_cmd_btf_ko = BTF [M] $@
       cmd_btf_ko = 							\
 	if [ -f vmlinux ]; then						\
 		LLVM_OBJCOPY="$(OBJCOPY)" $(PAHOLE) -J --btf_base vmlinux $@; \
+		$(RESOLVE_BTFIDS) --no-fail -s vmlinux $@; 		\
 	else								\
 		printf "Skipping BTF generation for %s due to unavailability of vmlinux\n" $@ 1>&2; \
 	fi;
-- 
2.33.0

