Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4594141D368
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 08:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348099AbhI3Gb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 02:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348114AbhI3Gbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 02:31:51 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862ADC061773;
        Wed, 29 Sep 2021 23:30:05 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id s75so5208318pgs.5;
        Wed, 29 Sep 2021 23:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yKGmIS7C5DRrVfELf8OojS9SVi5z+gHo+jOm3l5DvEc=;
        b=Fr905HqjMLLDFRuHsT/X40MOBCP1RQv0hkOJA5Bx1adZT6LP2QoiyCYwGg3kwiAtS2
         fFtsNfcDhdkCCV93LiQmGTCn+tdp8XIz71CAADNcUKGv6RTG0insnITeyAdL0r72YTha
         +HAX8gGu/U6nSyoST3VXISX+nmoKOpyLK8ATWey6FMM06Y12GWFEmEA4c5JIGShOpsJm
         eU1JJEGElVrAQNEJV0RHtvTiSpviJK8N5On+0PiHC25l/wFHE26son/eirveZ1DzWPDM
         a4ooZ0XZWCF8ATTuyRUNZqOToddRONm7YqVSe81Q2THB+wq/bi2C3NaZjCjgRXxk78N2
         hTDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yKGmIS7C5DRrVfELf8OojS9SVi5z+gHo+jOm3l5DvEc=;
        b=QxZUem/9hsbxw1qyYEe1KTb6bbSYYCFpXG8+o8l070nuh5oQoBqnH8yNcKTMUxMn7Z
         SeQkse2jSxyfj45E2Ju9mBMARlLSwh+1YW9/egry9KCnFqxusVnssYRQ0q/au+uDX/bm
         LKlnTBCF5bWYH5bHP1EZTBvUmb4QDblyLRZ3cWkpnedgXVEK9pUbH64EkEOnyju8h7DI
         mmdHqCx3FZq908FdOrUsXVIZLKn7BzUJMcTrlyBCQoKEJoy2Krtcce1BZBRqjoXSlnRi
         UHbwJbC5Q2qMLNSVhzMub7cwlTlIhQCcHjqlSGgQQaC/fkgImt0SMgp3+d8F7hWkID3H
         Tkvg==
X-Gm-Message-State: AOAM531v2pxA+PIMt+NBvzNu6uJEHWyXXkrqNefIY5auGz8uanmfccmq
        JQlHToqXC7V7+KHg0V1rUXmLyzrCr/4=
X-Google-Smtp-Source: ABdhPJw6JD4X3q1f096cV/6603rBlaTBGSrd3f46G9yxcZirdGKwSjBsKClJsF6sVYf7pWllknmCDQ==
X-Received: by 2002:a62:2f81:0:b0:44b:b390:956b with SMTP id v123-20020a622f81000000b0044bb390956bmr2669617pfv.30.1632983404877;
        Wed, 29 Sep 2021 23:30:04 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id k190sm1636884pgc.11.2021.09.29.23.30.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 23:30:04 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v6 5/9] bpf: Enable TCP congestion control kfunc from modules
Date:   Thu, 30 Sep 2021 11:59:44 +0530
Message-Id: <20210930062948.1843919-6-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210930062948.1843919-1-memxor@gmail.com>
References: <20210930062948.1843919-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9091; h=from:subject; bh=rxa0xEHmglr7YFOfcijdyTW/nCW7eae0WTlG7/lN0qc=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhVVlB10m1Pya+mmEs93dy9pGb1k5n2oTmvWarBWWf aUdSFlWJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVVZQQAKCRBM4MiGSL8Rys42D/ 0WnDpe8e5RDQawdGzuTb0Hi9VURo5TpzldTz3IEBnqpYiM40lKU5SNxBv/Al5fECVIUg7ysRcwYxKo EiGGFcTr7mSMOUzh/PHReCnkQJhJkMn9RXfKtDYbPU2yvHkFw4f9uFBOZVuq/bT++LYm7lnGu4WlaA 7PzjZl0cq3CrbSJ7Qn5pHMpnBAEA3dcbKL+mtBJPTu73YGALRfX29FrQ9TKixghW+mZJW5LbAdH1mT JBcvDKQ9Mkv+Rxpv6QBTfAHAFetxtlBGz4ZUjljtU2Stni/yd7yuF1paNjRcc1qC2sEmTCS+79Enzy TStbkZv6EM3FvKm4AGds+Hana5OEqZMttBTtfsuF835sESTfUH8UMy++nbJWC0ahBIDnXeNWrhz7In xFV4lpKou2LQp6XZ8Wvgl9ll63qe9c7nI9rYjJBLZZz/hP2NsvmMzM7EqJ9OOXONAiaQPfVCwEUlG7 tTfLR42iAPzm+rjOroBthCZjQx0IJi244ZkQuFWgmqiXLHKzFmyiz7CxxRb/rTmI+6Sxx0VIbbMb5a HVQz1ASdUR8e2LzacTy/YXKzNm07Jkqm8tSPJ2x6iSTB6UIm/kGL141FRgpjMuoIXRF6WjWii4sFyn cakLHys2iGjosfJUfgS16b8o2mN7UXIA1v9EjBjM4NwZYS8kB91yZUXzN/SA==
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
and can be loaded as modules if required. Also modify Makefile.modfinal
to call resolve_btfids for each module.

Note that since kernel kfunc_ids never overlap with module kfunc_ids, we
only match the owner for module btf id sets.

See following commits for background on use of:

 CONFIG_X86 ifdef:
 569c484f9995 (bpf: Limit static tcp-cc functions in the .BTF_ids list to x86)

 CONFIG_DYNAMIC_FTRACE ifdef:
 7aae231ac93b (bpf: tcp: Limit calling some tcp cc functions to CONFIG_DYNAMIC_FTRACE)

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/btf.h       |  4 ++++
 kernel/bpf/btf.c          |  3 +++
 net/ipv4/bpf_tcp_ca.c     | 34 +++-------------------------------
 net/ipv4/tcp_bbr.c        | 28 +++++++++++++++++++++++++++-
 net/ipv4/tcp_cubic.c      | 26 +++++++++++++++++++++++++-
 net/ipv4/tcp_dctcp.c      | 26 +++++++++++++++++++++++++-
 scripts/Makefile.modfinal |  1 +
 7 files changed, 88 insertions(+), 34 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 382c00d5cede..8dc65ff02bd6 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -269,4 +269,8 @@ static inline void unregister_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
 	struct kfunc_btf_id_set name = { LIST_HEAD_INIT(name.list), (set),     \
 					 THIS_MODULE }
 
+extern struct kfunc_btf_id_list bpf_tcp_ca_kfunc_list;
+
+DECLARE_CHECK_KFUNC_CALLBACK(tcp_ca);
+
 #endif
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 5a8806cfecd0..423744378fc8 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6394,3 +6394,6 @@ EXPORT_SYMBOL_GPL(unregister_kfunc_btf_id_set);
 		mutex_unlock(&list_name.mutex);                                \
 		return false;                                                  \
 	}
+
+DEFINE_KFUNC_BTF_ID_LIST(bpf_tcp_ca_kfunc_list);
+DEFINE_CHECK_KFUNC_CALLBACK(tcp_ca, bpf_tcp_ca_kfunc_list);
diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index b3afd3361f34..dae1515d81dd 100644
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
 
 static bool bpf_tcp_ca_check_kfunc_call(u32 kfunc_btf_id, struct module *owner)
 {
-	return btf_id_set_contains(&bpf_tcp_ca_kfunc_ids, kfunc_btf_id);
+	if (btf_id_set_contains(&bpf_tcp_ca_kfunc_ids, kfunc_btf_id))
+		return true;
+	return __bpf_tcp_ca_check_kfunc_call(kfunc_btf_id, owner);
 }
 
 static const struct bpf_verifier_ops bpf_tcp_ca_verifier_ops = {
diff --git a/net/ipv4/tcp_bbr.c b/net/ipv4/tcp_bbr.c
index 6274462b86b4..ec5550089b4d 100644
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
+static DEFINE_KFUNC_BTF_ID_SET(&tcp_bbr_kfunc_ids, tcp_bbr_kfunc_btf_set);
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
+	register_kfunc_btf_id_set(&bpf_tcp_ca_kfunc_list, &tcp_bbr_kfunc_btf_set);
+	return 0;
 }
 
 static void __exit bbr_unregister(void)
 {
+	unregister_kfunc_btf_id_set(&bpf_tcp_ca_kfunc_list, &tcp_bbr_kfunc_btf_set);
 	tcp_unregister_congestion_control(&tcp_bbr_cong_ops);
 }
 
diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index 4a30deaa9a37..5e9d9c51164c 100644
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
+static DEFINE_KFUNC_BTF_ID_SET(&tcp_cubic_kfunc_ids, tcp_cubic_kfunc_btf_set);
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
+	register_kfunc_btf_id_set(&bpf_tcp_ca_kfunc_list, &tcp_cubic_kfunc_btf_set);
+	return 0;
 }
 
 static void __exit cubictcp_unregister(void)
 {
+	unregister_kfunc_btf_id_set(&bpf_tcp_ca_kfunc_list, &tcp_cubic_kfunc_btf_set);
 	tcp_unregister_congestion_control(&cubictcp);
 }
 
diff --git a/net/ipv4/tcp_dctcp.c b/net/ipv4/tcp_dctcp.c
index 79f705450c16..0d7ab3cc7b61 100644
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
+static DEFINE_KFUNC_BTF_ID_SET(&tcp_dctcp_kfunc_ids, tcp_dctcp_kfunc_btf_set);
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
+	register_kfunc_btf_id_set(&bpf_tcp_ca_kfunc_list, &tcp_dctcp_kfunc_btf_set);
+	return 0;
 }
 
 static void __exit dctcp_unregister(void)
 {
+	unregister_kfunc_btf_id_set(&bpf_tcp_ca_kfunc_list, &tcp_dctcp_kfunc_btf_set);
 	tcp_unregister_congestion_control(&dctcp);
 }
 
diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
index ff805777431c..1fb45b011e4b 100644
--- a/scripts/Makefile.modfinal
+++ b/scripts/Makefile.modfinal
@@ -41,6 +41,7 @@ quiet_cmd_btf_ko = BTF [M] $@
       cmd_btf_ko = 							\
 	if [ -f vmlinux ]; then						\
 		LLVM_OBJCOPY="$(OBJCOPY)" $(PAHOLE) -J --btf_base vmlinux $@; \
+		$(RESOLVE_BTFIDS) -b vmlinux $@; 			\
 	else								\
 		printf "Skipping BTF generation for %s due to unavailability of vmlinux\n" $@ 1>&2; \
 	fi;
-- 
2.33.0

