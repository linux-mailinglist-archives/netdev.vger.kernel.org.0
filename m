Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E3E21141A
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 22:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgGAUNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 16:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727018AbgGAUNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 16:13:12 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121B3C08C5DB
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 13:13:12 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id s7so27260544ybg.10
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 13:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3D4qcP5foOD863wt3lhC/zFsHrwt1YT0IDFr2PFa5Q4=;
        b=ZzlPIM00qQzsqKLDIFL6VzATy1g4zWsRu2KVuvCzOZWfB8OR4sHAl2CRM5sxligwBk
         om1XkD2aiPmpW0+Ns8+03nFvEvsOCF6sYuct5oBoB3f/ai12WRAr19ixoiNqrfzFIw+H
         nbZzGFqpOHNsQ8plQK8ZB+3Usp0e1LtkUK27LMPQED9h/VlFUnUoOKbHcxddd30XiK28
         1nqZWZiAiMIM2rEgiZA7SglCGQe72lHGGsskOBH+KhIbcc8idOjdDsMaCbhZdNfKjX9v
         qGKjEp9IcM1s+VXp2j8bSrhDyMFhkVZZCMuRXu+yVZOijvU+SvzM/gaSZ46H+68H5Vpt
         JMyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3D4qcP5foOD863wt3lhC/zFsHrwt1YT0IDFr2PFa5Q4=;
        b=JJjyllYy4s7TLxnwhbj5tFrFtCxSXl2vBm96lQyStF6X6UtL8n7EqsMTWNk3c4w/Tk
         gsK5TcArlJczlhqmo941J1JRl00TWLJFgV6/syc2VpULTKhpMlJsJTI6aexbQatPp0L2
         Zih3Ohs1C+j+BWIDD8IyvWxmvFxUqZsMXPPeXVwQ86NokgGJXeLGYfhHCBfgazfSqBZ9
         kqZZHyvKU4dFvv9Uh9ANELSmRHHuFgsFLKOuexBlRJYfL2h7abyHd6/nZqAtPp0FkCde
         zM8Gk5sSX5becNNmAfHVghbK6rQBjwBED+8V5F4wrwCN+4uOySdqReHP0lQ7hUmkKO6z
         HqLA==
X-Gm-Message-State: AOAM533t0qnEaujcjoL0JlkmsXOS3zklkXHldP6KeBBvq7q9547N9paL
        Xdg9ailQePic66kmLHOAJcXZzgxjUTHP1ku53MuYNsJIDH2ryDWR4FIuSHeabVCM5KtqrXMZzt5
        L2idD/m/aN31paXpULFsMtjyv/+ZM/IpHNgdGONzOelcMRcbOAo9Bng==
X-Google-Smtp-Source: ABdhPJyRkm4KzkhJA/Xv1/2jeJHtCMr7myQiY3kTpIlZJoZita9JYCo5dKhsUMlPtl5N/mib7yZCzEY=
X-Received: by 2002:a5b:548:: with SMTP id r8mr45060274ybp.322.1593634391203;
 Wed, 01 Jul 2020 13:13:11 -0700 (PDT)
Date:   Wed,  1 Jul 2020 13:13:04 -0700
In-Reply-To: <20200701201307.855717-1-sdf@google.com>
Message-Id: <20200701201307.855717-2-sdf@google.com>
Mime-Version: 1.0
References: <20200701201307.855717-1-sdf@google.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH bpf-next v3 1/4] bpf: add BPF_CGROUP_INET_SOCK_RELEASE hook
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement BPF_CGROUP_INET_SOCK_RELEASE hook that triggers
on inet socket release. It triggers only for userspace
sockets, the same semantics as existing BPF_CGROUP_INET_SOCK_CREATE.

The only questionable part here is the sock->sk check
in the inet_release. Looking at the places where we
do 'sock->sk = NULL', I don't understand how it can race
with inet_release and why the check is there (it's been
there since the initial git import). Otherwise, the
change itself is pretty simple, we add a BPF hook
to the inet_release and avoid calling it for kernel
sockets.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/linux/bpf-cgroup.h | 4 ++++
 include/uapi/linux/bpf.h   | 1 +
 kernel/bpf/syscall.c       | 3 +++
 net/core/filter.c          | 1 +
 net/ipv4/af_inet.c         | 3 +++
 5 files changed, 12 insertions(+)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index c66c545e161a..2c6f26670acc 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -210,6 +210,9 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 #define BPF_CGROUP_RUN_PROG_INET_SOCK(sk)				       \
 	BPF_CGROUP_RUN_SK_PROG(sk, BPF_CGROUP_INET_SOCK_CREATE)
 
+#define BPF_CGROUP_RUN_PROG_INET_SOCK_RELEASE(sk)			       \
+	BPF_CGROUP_RUN_SK_PROG(sk, BPF_CGROUP_INET_SOCK_RELEASE)
+
 #define BPF_CGROUP_RUN_PROG_INET4_POST_BIND(sk)				       \
 	BPF_CGROUP_RUN_SK_PROG(sk, BPF_CGROUP_INET4_POST_BIND)
 
@@ -401,6 +404,7 @@ static inline int bpf_percpu_cgroup_storage_update(struct bpf_map *map,
 #define BPF_CGROUP_RUN_PROG_INET_INGRESS(sk,skb) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_INET_EGRESS(sk,skb) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_INET_SOCK(sk) ({ 0; })
+#define BPF_CGROUP_RUN_PROG_INET_SOCK_RELEASE(sk) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_INET4_BIND(sk, uaddr) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_INET6_BIND(sk, uaddr) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_INET4_POST_BIND(sk) ({ 0; })
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index da9bf35a26f8..548a749aebb3 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -226,6 +226,7 @@ enum bpf_attach_type {
 	BPF_CGROUP_INET4_GETSOCKNAME,
 	BPF_CGROUP_INET6_GETSOCKNAME,
 	BPF_XDP_DEVMAP,
+	BPF_CGROUP_INET_SOCK_RELEASE,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 8da159936bab..156f51ffada2 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1981,6 +1981,7 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
 	case BPF_PROG_TYPE_CGROUP_SOCK:
 		switch (expected_attach_type) {
 		case BPF_CGROUP_INET_SOCK_CREATE:
+		case BPF_CGROUP_INET_SOCK_RELEASE:
 		case BPF_CGROUP_INET4_POST_BIND:
 		case BPF_CGROUP_INET6_POST_BIND:
 			return 0;
@@ -2779,6 +2780,7 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
 		return BPF_PROG_TYPE_CGROUP_SKB;
 		break;
 	case BPF_CGROUP_INET_SOCK_CREATE:
+	case BPF_CGROUP_INET_SOCK_RELEASE:
 	case BPF_CGROUP_INET4_POST_BIND:
 	case BPF_CGROUP_INET6_POST_BIND:
 		return BPF_PROG_TYPE_CGROUP_SOCK;
@@ -2929,6 +2931,7 @@ static int bpf_prog_query(const union bpf_attr *attr,
 	case BPF_CGROUP_INET_INGRESS:
 	case BPF_CGROUP_INET_EGRESS:
 	case BPF_CGROUP_INET_SOCK_CREATE:
+	case BPF_CGROUP_INET_SOCK_RELEASE:
 	case BPF_CGROUP_INET4_BIND:
 	case BPF_CGROUP_INET6_BIND:
 	case BPF_CGROUP_INET4_POST_BIND:
diff --git a/net/core/filter.c b/net/core/filter.c
index c5e696e6c315..ddcc0d6209e1 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6890,6 +6890,7 @@ static bool __sock_filter_check_attach_type(int off,
 	case offsetof(struct bpf_sock, priority):
 		switch (attach_type) {
 		case BPF_CGROUP_INET_SOCK_CREATE:
+		case BPF_CGROUP_INET_SOCK_RELEASE:
 			goto full_access;
 		default:
 			return false;
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 02aa5cb3a4fd..965a96ea1168 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -411,6 +411,9 @@ int inet_release(struct socket *sock)
 	if (sk) {
 		long timeout;
 
+		if (!sk->sk_kern_sock)
+			BPF_CGROUP_RUN_PROG_INET_SOCK_RELEASE(sk);
+
 		/* Applications forget to leave groups before exiting */
 		ip_mc_drop_socket(sk);
 
-- 
2.27.0.212.ge8ba1cc988-goog

