Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0F76546B17
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 19:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239542AbiFJQ66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 12:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349978AbiFJQ6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 12:58:21 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A38132ED2
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 09:58:16 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id q2-20020a170902dac200b00168b3978426so2036942plx.17
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 09:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BZyjEWwnzFdoC1L8q2knk5sFfOhHnP7cMikHRLQz7L4=;
        b=onls1ZESIMnsMmVC9UaxoOtSmWxbFfOEd2cq1tQ6HqCdo5uktEBO/GdxFh/ZSxfWnh
         KgIVnkFoaKC3t9LTKhoMrfmQQ9OnZQU9DOgKANjRWpKwcEVDPw5IPXiHiiSdecomCage
         X2360Wkrk57o0ecITiCPstBo/lF0Vjy8IjYdvCFFxhqrsR1zAeM3Bx1nv90EfgWSkv3G
         nFEwBsSzN6l+rm5JPECPaFhyTMcLsCS1X8zsmDC/XVn6nTJj0N3AiL3wtb8hZ0fKcafA
         zfUxQAAlLyyvYfH//hdf9+mlQfwyqqTvuyfPlFN5JX8bvoJ2nwOMLwPo0XwOH8RvN+Dh
         xJSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BZyjEWwnzFdoC1L8q2knk5sFfOhHnP7cMikHRLQz7L4=;
        b=BCyNQk8E27pXm1xOtmizyaNHOdinaFRMpkxjidx4Xy56fVY0PKH5T1SdoEv2sqH/5x
         S6rmG93uLrK5KPr9a5xMTiav3rNp4evhGTLDSzYhwH4HC2GgGRovprLescIP5KxvhW0j
         rFlOS4Zlvb8bYdryn2owUUa7Q2fb+a8zkQGBWm9Nlt1hOAz8simrQP2eEUgSe0P6+COt
         B1vwLjLRMy8KW0NN3AIkd0k7q9d2o1H6Icjeiyej4PFoazSmxUhZln8fWndMvpSPlKSP
         rz1a/S71172DHwDh4MUqQF3+L9upx4RFvGROODLtYCWDkRw5fvkfFLuyHLHbht/sDwTV
         YxUw==
X-Gm-Message-State: AOAM531RFK+YaWA579p3pgahT6WekiOrGF+0YDACyIu1eLW0sNgzhwRp
        wHctExr02HG/fcjEuMNOriVOgrQvabmqsTvOOduwRHrdWaNiDu/D1ggE6zvLTfBZ3h34vezqeUx
        xUMp06pGk0t7OJji15rgy4fV18aaD0HbDRsBiR0QhQkWKscW8kEcm6w==
X-Google-Smtp-Source: ABdhPJyZqyQ35N0Lj3xry0PvNcn17OVC+o/Zy2TFeSRlYS5hRlWA7OAmbE+gbZ6tm802jAnl4cR7R1o=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:1a56:b0:51b:f1af:c2e8 with SMTP id
 h22-20020a056a001a5600b0051bf1afc2e8mr35771653pfv.48.1654880295808; Fri, 10
 Jun 2022 09:58:15 -0700 (PDT)
Date:   Fri, 10 Jun 2022 09:57:59 -0700
In-Reply-To: <20220610165803.2860154-1-sdf@google.com>
Message-Id: <20220610165803.2860154-7-sdf@google.com>
Mime-Version: 1.0
References: <20220610165803.2860154-1-sdf@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH bpf-next v9 06/10] bpf: expose bpf_{g,s}etsockopt to lsm cgroup
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I don't see how to make it nice without introducing btf id lists
for the hooks where these helpers are allowed. Some LSM hooks
work on the locked sockets, some are triggering early and
don't grab any locks, so have two lists for now:

1. LSM hooks which trigger under socket lock - minority of the hooks,
   but ideal case for us, we can expose existing BTF-based helpers
2. LSM hooks which trigger without socket lock, but they trigger
   early in the socket creation path where it should be safe to
   do setsockopt without any locks
3. The rest are prohibited. I'm thinking that this use-case might
   be a good gateway to sleeping lsm cgroup hooks in the future.
   We can either expose lock/unlock operations (and add tracking
   to the verifier) or have another set of bpf_setsockopt
   wrapper that grab the locks and might sleep.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/linux/bpf.h  |  2 ++
 kernel/bpf/bpf_lsm.c | 40 +++++++++++++++++++++++++++++
 net/core/filter.c    | 60 ++++++++++++++++++++++++++++++++++++++------
 3 files changed, 95 insertions(+), 7 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 503f28fa66d2..c0a269269882 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2282,6 +2282,8 @@ extern const struct bpf_func_proto bpf_for_each_map_elem_proto;
 extern const struct bpf_func_proto bpf_btf_find_by_name_kind_proto;
 extern const struct bpf_func_proto bpf_sk_setsockopt_proto;
 extern const struct bpf_func_proto bpf_sk_getsockopt_proto;
+extern const struct bpf_func_proto bpf_unlocked_sk_setsockopt_proto;
+extern const struct bpf_func_proto bpf_unlocked_sk_getsockopt_proto;
 extern const struct bpf_func_proto bpf_kallsyms_lookup_name_proto;
 extern const struct bpf_func_proto bpf_find_vma_proto;
 extern const struct bpf_func_proto bpf_loop_proto;
diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 83aa431dd52e..52b6e3067986 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -45,6 +45,26 @@ BTF_ID(func, bpf_lsm_sk_alloc_security)
 BTF_ID(func, bpf_lsm_sk_free_security)
 BTF_SET_END(bpf_lsm_current_hooks)
 
+/* List of LSM hooks that trigger while the socket is properly locked.
+ */
+BTF_SET_START(bpf_lsm_locked_sockopt_hooks)
+BTF_ID(func, bpf_lsm_socket_sock_rcv_skb)
+BTF_ID(func, bpf_lsm_sk_clone_security)
+BTF_ID(func, bpf_lsm_sock_graft)
+BTF_ID(func, bpf_lsm_inet_csk_clone)
+BTF_ID(func, bpf_lsm_inet_conn_established)
+BTF_ID(func, bpf_lsm_sctp_bind_connect)
+BTF_SET_END(bpf_lsm_locked_sockopt_hooks)
+
+/* List of LSM hooks that trigger while the socket is _not_ locked,
+ * but it's ok to call bpf_{g,s}etsockopt because the socket is still
+ * in the early init phase.
+ */
+BTF_SET_START(bpf_lsm_unlocked_sockopt_hooks)
+BTF_ID(func, bpf_lsm_socket_post_create)
+BTF_ID(func, bpf_lsm_socket_socketpair)
+BTF_SET_END(bpf_lsm_unlocked_sockopt_hooks)
+
 void bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
 			     bpf_func_t *bpf_func)
 {
@@ -201,6 +221,26 @@ bpf_lsm_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	case BPF_FUNC_get_retval:
 		return prog->expected_attach_type == BPF_LSM_CGROUP ?
 			&bpf_get_retval_proto : NULL;
+	case BPF_FUNC_setsockopt:
+		if (prog->expected_attach_type != BPF_LSM_CGROUP)
+			return NULL;
+		if (btf_id_set_contains(&bpf_lsm_locked_sockopt_hooks,
+					prog->aux->attach_btf_id))
+			return &bpf_sk_setsockopt_proto;
+		if (btf_id_set_contains(&bpf_lsm_unlocked_sockopt_hooks,
+					prog->aux->attach_btf_id))
+			return &bpf_unlocked_sk_setsockopt_proto;
+		return NULL;
+	case BPF_FUNC_getsockopt:
+		if (prog->expected_attach_type != BPF_LSM_CGROUP)
+			return NULL;
+		if (btf_id_set_contains(&bpf_lsm_locked_sockopt_hooks,
+					prog->aux->attach_btf_id))
+			return &bpf_sk_getsockopt_proto;
+		if (btf_id_set_contains(&bpf_lsm_unlocked_sockopt_hooks,
+					prog->aux->attach_btf_id))
+			return &bpf_unlocked_sk_getsockopt_proto;
+		return NULL;
 	default:
 		return tracing_prog_func_proto(func_id, prog);
 	}
diff --git a/net/core/filter.c b/net/core/filter.c
index 5af58eb48587..57cc22e3750e 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5012,8 +5012,8 @@ static const struct bpf_func_proto bpf_get_socket_uid_proto = {
 	.arg1_type      = ARG_PTR_TO_CTX,
 };
 
-static int _bpf_setsockopt(struct sock *sk, int level, int optname,
-			   char *optval, int optlen)
+static int __bpf_setsockopt(struct sock *sk, int level, int optname,
+			    char *optval, int optlen)
 {
 	char devname[IFNAMSIZ];
 	int val, valbool;
@@ -5024,8 +5024,6 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 	if (!sk_fullsock(sk))
 		return -EINVAL;
 
-	sock_owned_by_me(sk);
-
 	if (level == SOL_SOCKET) {
 		if (optlen != sizeof(int) && optname != SO_BINDTODEVICE)
 			return -EINVAL;
@@ -5258,14 +5256,20 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 	return ret;
 }
 
-static int _bpf_getsockopt(struct sock *sk, int level, int optname,
+static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 			   char *optval, int optlen)
+{
+	if (sk_fullsock(sk))
+		sock_owned_by_me(sk);
+	return __bpf_setsockopt(sk, level, optname, optval, optlen);
+}
+
+static int __bpf_getsockopt(struct sock *sk, int level, int optname,
+			    char *optval, int optlen)
 {
 	if (!sk_fullsock(sk))
 		goto err_clear;
 
-	sock_owned_by_me(sk);
-
 	if (level == SOL_SOCKET) {
 		if (optlen != sizeof(int))
 			goto err_clear;
@@ -5360,6 +5364,14 @@ static int _bpf_getsockopt(struct sock *sk, int level, int optname,
 	return -EINVAL;
 }
 
+static int _bpf_getsockopt(struct sock *sk, int level, int optname,
+			   char *optval, int optlen)
+{
+	if (sk_fullsock(sk))
+		sock_owned_by_me(sk);
+	return __bpf_getsockopt(sk, level, optname, optval, optlen);
+}
+
 BPF_CALL_5(bpf_sk_setsockopt, struct sock *, sk, int, level,
 	   int, optname, char *, optval, int, optlen)
 {
@@ -5400,6 +5412,40 @@ const struct bpf_func_proto bpf_sk_getsockopt_proto = {
 	.arg5_type	= ARG_CONST_SIZE,
 };
 
+BPF_CALL_5(bpf_unlocked_sk_setsockopt, struct sock *, sk, int, level,
+	   int, optname, char *, optval, int, optlen)
+{
+	return __bpf_setsockopt(sk, level, optname, optval, optlen);
+}
+
+const struct bpf_func_proto bpf_unlocked_sk_setsockopt_proto = {
+	.func		= bpf_unlocked_sk_setsockopt,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_BTF_ID_SOCK_COMMON,
+	.arg2_type	= ARG_ANYTHING,
+	.arg3_type	= ARG_ANYTHING,
+	.arg4_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
+	.arg5_type	= ARG_CONST_SIZE,
+};
+
+BPF_CALL_5(bpf_unlocked_sk_getsockopt, struct sock *, sk, int, level,
+	   int, optname, char *, optval, int, optlen)
+{
+	return __bpf_getsockopt(sk, level, optname, optval, optlen);
+}
+
+const struct bpf_func_proto bpf_unlocked_sk_getsockopt_proto = {
+	.func		= bpf_unlocked_sk_getsockopt,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_BTF_ID_SOCK_COMMON,
+	.arg2_type	= ARG_ANYTHING,
+	.arg3_type	= ARG_ANYTHING,
+	.arg4_type	= ARG_PTR_TO_UNINIT_MEM,
+	.arg5_type	= ARG_CONST_SIZE,
+};
+
 BPF_CALL_5(bpf_sock_addr_setsockopt, struct bpf_sock_addr_kern *, ctx,
 	   int, level, int, optname, char *, optval, int, optlen)
 {
-- 
2.36.1.476.g0c4daa206d-goog

