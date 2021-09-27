Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3544196F4
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 17:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235063AbhI0PBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 11:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234951AbhI0PBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 11:01:40 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA11C061714;
        Mon, 27 Sep 2021 08:00:01 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id y5so9525842pll.3;
        Mon, 27 Sep 2021 08:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yKGmIS7C5DRrVfELf8OojS9SVi5z+gHo+jOm3l5DvEc=;
        b=ACFgI6sllMP/LwNdaCCb8EiqyYij3/A82Je9jYYLG9Cdu1fgaffpsMQyH0JsWJheCs
         H+1tbcIepiPhM7xtB9mmDFH1WtE4nJ/kuuQpjfqv0I4iwZFutiS97xqGHtO7DWsVw5So
         JDMNOyUknSvdkld0RhA16k0DlCRPLnTI5RPqB1sPvekixKcl4WmY2Os0hb8XUfMeNo/m
         OB1Ujai1ZfQNlwKctdnAa9Gy4udabbrRcz0o1DooRnvYli8Z4a+ufMxi0gwAmPfRM8o+
         1WhErtmrh5r+7wMi2PVR2hDJ9vYnHusww59l3acyyXo3GD4taA54zETDld+ycXA8e6i1
         tO9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yKGmIS7C5DRrVfELf8OojS9SVi5z+gHo+jOm3l5DvEc=;
        b=1WHoI5fzI3sOir1oVgQFl2bfnN/ijqzmmymLgarIkrIlwbdL6zGxGA1DDHCE7UkBBh
         fgILH45fGX/4ON7cIbw2dnEdyvQEObaxCe6wbeYSAkO6bmxP+TdhtiFkneglpogoJFiw
         uyLg4UKf/hFeXN7WrwDnnbesAJBhe+2ieJBHUGuzOU5G4MpOlsvyMDsO6J/C+Jjbe8yQ
         h+s3HhyKFABRuNDsKytQ1aFUURBOjE8JVVir7D7aDDFSWUC1ZbiXgxAJ6cmfdmyphv2g
         iIsuRjCKjcRKOXrtqZQ7IG6OlhPy8kuseit4E6MUntfxRqtmY3pwtkY9TVJ8f+IoIwnZ
         DnCg==
X-Gm-Message-State: AOAM530E6oaS8IyYWyPq5xoa4ZrG0xQycxGKtbB3GzV1gmMFUnXYduqe
        XObRofg/E4gtk/fgTFGwUVZcXBPUnZk=
X-Google-Smtp-Source: ABdhPJyr43nWj2VLU5e2ZNy8ABDxLdour5C8cIWIhcRsTO1CAbZ874QwHvXFQCnseA2Usw672QZflg==
X-Received: by 2002:a17:903:1103:b0:13a:1dd7:485f with SMTP id n3-20020a170903110300b0013a1dd7485fmr35154plh.6.1632754801081;
        Mon, 27 Sep 2021 08:00:01 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id j3sm18103385pgn.12.2021.09.27.08.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 08:00:00 -0700 (PDT)
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
Subject: [PATCH bpf-next v5 05/12] bpf: Enable TCP congestion control kfunc from modules
Date:   Mon, 27 Sep 2021 20:29:34 +0530
Message-Id: <20210927145941.1383001-6-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927145941.1383001-1-memxor@gmail.com>
References: <20210927145941.1383001-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9091; h=from:subject; bh=rxa0xEHmglr7YFOfcijdyTW/nCW7eae0WTlG7/lN0qc=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhUdxO10m1Pya+mmEs93dy9pGb1k5n2oTmvWarBWWf aUdSFlWJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVHcTgAKCRBM4MiGSL8RyotfD/ 9SlQLapkXC+3/bqYEg6IW8q+F2qN9UNA4COctoVI+q9JvpNpsO5M8DKUHXKjbFWDWEkMJrqmcNN04p fKrWQn7UQghfCbz633S1hoQbNrHcvUp0r9AeohJ6yAfapF/3pYY2ApRKD7KxRgHwQVHJYu8VIv6NgI Vy7eRR/WJAgR+syBu3fY6Z/35GxdL7m7G0n/v5ieuRyEBVQTzAx2ZSBKXXXHrlBBK/EYE1iXZBjS5Z SNzEiJr5N6h6ODYl3HZ9Ubj0FnWW+QWACiu5fu/EeCrb77MFTR+YGmo+6D9oWRbYptHOyLXOv/rWo/ W+cu7cc2hDa3t6JEZPCR8zGY799Siu0NPOFP3mlF7UYcJQqzY8sihwNXUqJKX7B/iBl3jByO2zDO2W Zw1JZq9sCQdZlH8pXW+0o7Vi1m1O4YXGMOCcMOoPWvRkugZCtmlrexU8cQnOzxpVHgMyxzLMqJb9cV WCFo0MBeJ9c7/n03pr0TrBe9ktRy8TLnYnqgU8k2aQdboE5u0IWl3ngsmmLqp4D95VNGoaiyq7aP3b haZdObDIACWL+8OXrToI+SDMuB8KdqJ8mvq6O/eZ6gn5shmB/5R6p7J5dD9Em6ZTgIxK5rD1kIKHsS 9Oxw8v9GbTZdbSGxBc/TcK5uwHSWMUkM+kbP3AY5Lme46XH/7ghXHFjivmtQ==
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

