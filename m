Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9CF2B72F6
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 01:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgKRARv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 19:17:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727105AbgKRARu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 19:17:50 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E30C0617A7
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 16:17:49 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id v134so198726qka.19
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 16:17:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=UjkKglrC80PIpRHe5uZqazgkFPKiIiF/dGgGFz4T2eI=;
        b=CKZUOVGRFv43XA6rTi5lcICczxqLEsqPyYUTOUji+YTx37NM4JbW1s2AR9oW7PTmlI
         ufSrMgzrFNt/fBnUQXdfgNeI12nAJncn9MWcclzBga0tcX+zkZvKvDBE5Ti7hxc6MX8B
         vpswQtyv0vXZG1k6eyEaaBxCkqhgzJ0gm7Is/t6AAZrBEdIciIrMEBRI7297Wkj9UA8Y
         BAsdmwlMsgb9EVZkkz/vN0jXAd9hMo+rxVvX/PKjoJAfHxX5WPUZ6x7wLi4W2sC+u1e0
         nEvM/T7OVOTgDGyuabAFnNbbOe5GQmMRe7PYkMHydYadRsDYTut2/7VcOwyNlpB6SQ7v
         M4tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=UjkKglrC80PIpRHe5uZqazgkFPKiIiF/dGgGFz4T2eI=;
        b=KvxmOh2KuZwn8qmhHHgRuKwpLOCOnRQ0Knq0opdvS5OR2COhLEEY/wmyWYLfsNZNTl
         snTuX4q9cibDasqdWrFKkToIkYDHUlxZ9b1zdjdlp0befGzeZ/q67yPfA4iivhshtAC3
         v4Dun0q1jFAenjHJkr8Bjic9XzNYiEpmRengcWEZmVfMbIhIA+T+Lg+kibOPaWKZs+UN
         YnfcMhv7PiM5cdjF++TUxrokwh0IEC6jY6FnPDloXM7EYK7ZsQGGsXmALz89UFPjbE/Y
         4HD3GesOGp9MSJ73mjBF1WYQErvaF+z1KzWu+uj2Mro+o257+qh0X/HqUnBMaxA8qhCl
         VW8w==
X-Gm-Message-State: AOAM533BiX3dw5Jp6iKfmcqDdKkaXZ8p0yqQXSRSGNvgbCeetki37DlQ
        ARS+KOHgXGm/QsC/FyEh51w5uxb3A+sN3KsQ9wr8IvG4hyOn2vC5ZUxJilzBYjmzbYl4PWKDcxj
        f9ihMh/uhtHlaCEnYLLSVsCwEn6eisoClvXHwtU0wW4O/4Xm0pJjvfA==
X-Google-Smtp-Source: ABdhPJzlkM2EnZrL/6i3C75E8o+bXcCRf9YZDmrxgJzt3Erm1TFpeyxAbiROfCPDj1xJma9ARYB9JZk=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a0c:90e4:: with SMTP id p91mr2170314qvp.61.1605658668299;
 Tue, 17 Nov 2020 16:17:48 -0800 (PST)
Date:   Tue, 17 Nov 2020 16:17:41 -0800
In-Reply-To: <20201118001742.85005-1-sdf@google.com>
Message-Id: <20201118001742.85005-3-sdf@google.com>
Mime-Version: 1.0
References: <20201118001742.85005-1-sdf@google.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
Subject: [PATCH bpf-next 2/3] bpf: allow bpf_{s,g}etsockopt from cgroup
 bind{4,6} hooks
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have to now lock/unlock socket for the bind hook execution.
That shouldn't cause any overhead because the socket is unbound
and shouldn't receive any traffic.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/linux/bpf-cgroup.h | 12 ++++++------
 net/core/filter.c          |  4 ++++
 net/ipv4/af_inet.c         |  2 +-
 net/ipv6/af_inet6.c        |  2 +-
 4 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index ed71bd1a0825..72e69a0e1e8c 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -246,11 +246,11 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 	__ret;								       \
 })
 
-#define BPF_CGROUP_RUN_PROG_INET4_BIND(sk, uaddr)			       \
-	BPF_CGROUP_RUN_SA_PROG(sk, uaddr, BPF_CGROUP_INET4_BIND)
+#define BPF_CGROUP_RUN_PROG_INET4_BIND_LOCK(sk, uaddr)			       \
+	BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, BPF_CGROUP_INET4_BIND, NULL)
 
-#define BPF_CGROUP_RUN_PROG_INET6_BIND(sk, uaddr)			       \
-	BPF_CGROUP_RUN_SA_PROG(sk, uaddr, BPF_CGROUP_INET6_BIND)
+#define BPF_CGROUP_RUN_PROG_INET6_BIND_LOCK(sk, uaddr)			       \
+	BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, BPF_CGROUP_INET6_BIND, NULL)
 
 #define BPF_CGROUP_PRE_CONNECT_ENABLED(sk) (cgroup_bpf_enabled && \
 					    sk->sk_prot->pre_connect)
@@ -434,8 +434,8 @@ static inline int bpf_percpu_cgroup_storage_update(struct bpf_map *map,
 #define BPF_CGROUP_RUN_PROG_INET_EGRESS(sk,skb) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_INET_SOCK(sk) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_INET_SOCK_RELEASE(sk) ({ 0; })
-#define BPF_CGROUP_RUN_PROG_INET4_BIND(sk, uaddr) ({ 0; })
-#define BPF_CGROUP_RUN_PROG_INET6_BIND(sk, uaddr) ({ 0; })
+#define BPF_CGROUP_RUN_PROG_INET4_BIND_LOCK(sk, uaddr) ({ 0; })
+#define BPF_CGROUP_RUN_PROG_INET6_BIND_LOCK(sk, uaddr) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_INET4_POST_BIND(sk) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_INET6_POST_BIND(sk) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_INET4_CONNECT(sk, uaddr) ({ 0; })
diff --git a/net/core/filter.c b/net/core/filter.c
index 2ca5eecebacf..21d91dcf0260 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6995,6 +6995,8 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_sk_storage_delete_proto;
 	case BPF_FUNC_setsockopt:
 		switch (prog->expected_attach_type) {
+		case BPF_CGROUP_INET4_BIND:
+		case BPF_CGROUP_INET6_BIND:
 		case BPF_CGROUP_INET4_CONNECT:
 		case BPF_CGROUP_INET6_CONNECT:
 			return &bpf_sock_addr_setsockopt_proto;
@@ -7003,6 +7005,8 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		}
 	case BPF_FUNC_getsockopt:
 		switch (prog->expected_attach_type) {
+		case BPF_CGROUP_INET4_BIND:
+		case BPF_CGROUP_INET6_BIND:
 		case BPF_CGROUP_INET4_CONNECT:
 		case BPF_CGROUP_INET6_CONNECT:
 			return &bpf_sock_addr_getsockopt_proto;
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index b7260c8cef2e..b94fa8eb831b 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -450,7 +450,7 @@ int inet_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	/* BPF prog is run before any checks are done so that if the prog
 	 * changes context in a wrong way it will be caught.
 	 */
-	err = BPF_CGROUP_RUN_PROG_INET4_BIND(sk, uaddr);
+	err = BPF_CGROUP_RUN_PROG_INET4_BIND_LOCK(sk, uaddr);
 	if (err)
 		return err;
 
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index e648fbebb167..a7e3d170af51 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -451,7 +451,7 @@ int inet6_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	/* BPF prog is run before any checks are done so that if the prog
 	 * changes context in a wrong way it will be caught.
 	 */
-	err = BPF_CGROUP_RUN_PROG_INET6_BIND(sk, uaddr);
+	err = BPF_CGROUP_RUN_PROG_INET6_BIND_LOCK(sk, uaddr);
 	if (err)
 		return err;
 
-- 
2.29.2.299.gdc1121823c-goog

