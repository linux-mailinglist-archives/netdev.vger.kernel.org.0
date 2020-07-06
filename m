Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0442161C6
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 01:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgGFXBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 19:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbgGFXBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 19:01:33 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BC9C061794
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 16:01:33 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id v16so17156597qka.18
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 16:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+vrVjn18hLwzji4h54Yc/RlbA6Fx90Vj5CfTJ215CUk=;
        b=F9WEhSlwE4qVop4xztWFVYGCZeSNl2iTKXQgEJKisJ1/tC3RiZNLdt9jDcQXSwNJW8
         Nq5ywtfFjBKpB1n9dXX+4HzJLlgYNXflc+rqyBdfMj4AefGnIqllsDQmzAiQz/z3G8ep
         xixs37LzDTk36D5ogLmAFFpMXsStFRYix2hxBf1GvG0e+GVjRrNhAYn/Cvt+Wq5kOLAp
         clnpm8sNRJsbTqQ/+P1OXY8O9kKFMJmwPJ/9/n3Ie99jAy7gb3fzZ5P9QcWEhZ7OObVk
         srJ+uaPrYYTigi9fyt3cCpiElvuXRVlQGuJsbLngjkuUfG2tfhwwrQ+0dM19eABp2LSB
         AnMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+vrVjn18hLwzji4h54Yc/RlbA6Fx90Vj5CfTJ215CUk=;
        b=RAZeY4atuasJwaizGdr45NZE37s+2QNPRTg5kUnxp0Ej4vPGXA08O7YNsaArV/hc4N
         tB1LyZEv1cDwkJ1vLIlS6QO51He246etS1xfpoMkhYZzo8tq/rRIKCn6lvmYIB3h6ht/
         iu2I3VAnD/TcugSpE7IjPWtx2nAsPUnleY7Y1wfIDF79Q/8KXDv+0puCSMz0ESH3m6sE
         JCQ97brF0QUWvYTFVu+mkMmWA6pF2pPwzVva3TSKmITfSx30OBzHUzatxbuATi8ZAwal
         PafDYuVRShv4KqgWjlf1TKW1Wf3OBDW/meb5kqzM+Gnb7y51xHH19bHvzrpmNHNjgM2n
         IW2Q==
X-Gm-Message-State: AOAM532rFsH1zbxwY9WzDG4vxTEdmga1vSg2sT639Lb3ROS3yIH5l512
        ySi4QoCrxnSHtDynq0xxe/OmnA7ux9+D6HgDg9t95PmdYFLkk+7x+ikg4H85GRoJoQUzAWqzPK7
        x+pIsAAFyT7wqv4+vMH3HtuZGl5jw0LDJAO0BtuiRqvjk18efTi7sFg==
X-Google-Smtp-Source: ABdhPJy4fj0RKrX1qfygM9t/RRkYhzN9xzR196KlXCXcagWGy7DLhXM9A/tNN+JfA+Nl+XYwW03cYyc=
X-Received: by 2002:a0c:e14d:: with SMTP id c13mr16788506qvl.158.1594076492231;
 Mon, 06 Jul 2020 16:01:32 -0700 (PDT)
Date:   Mon,  6 Jul 2020 16:01:25 -0700
In-Reply-To: <20200706230128.4073544-1-sdf@google.com>
Message-Id: <20200706230128.4073544-2-sdf@google.com>
Mime-Version: 1.0
References: <20200706230128.4073544-1-sdf@google.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH bpf-next v4 1/4] bpf: add BPF_CGROUP_INET_SOCK_RELEASE hook
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
index ea6ed6d487ed..ff141d630bdf 100644
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

