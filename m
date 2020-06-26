Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD0D20B648
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 18:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgFZQwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 12:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgFZQwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 12:52:34 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6E9C03E979
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 09:52:34 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id x22so7026977qkj.6
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 09:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=8T9UcUdWSX0ttb1WtDDxPNgqHJdOlrPTkZTwK0rEYOo=;
        b=KDKt6xqpFlaiAPsD8ziYgL2Iwvm2a4gE0np2UKG2Xw8mylFBwkNljntqMDZNXdPU40
         OtzHlUvTlrRUXVrDas38vj2QrTtC48Z6MYWudViRV04bbNhNSqgpaCqqM1wAITffDnRM
         J7D4hD9OxkuRpWBUB1JmStjAMtEkm21DsYCuh7u8uw0pb/LwudNY65osUrZfAJT3c83S
         Xa46ogiQozxqMYpwjijooO5oLGKe8v3xXWJCzuqxFPFoEgqe2Cu0vHxWBQTyTEZN3Of8
         hvwmNu/IP4ZcIQuNeIRZ61p4x5P/oCTz0RlpmfgbZjVvYrKrw13oef9irYZ7ZqESGORe
         Gy6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=8T9UcUdWSX0ttb1WtDDxPNgqHJdOlrPTkZTwK0rEYOo=;
        b=U95i4JkAymD/NykYmK5r74n4mVhKPGIhrJMsUsOmpQD1EbHXS5t49oKpMeGwQSPX2W
         5fw7IdWzGa1iwRzPkPtxXm2ZvxQiYE3rlCCoBg6dqFSFvZ/9OQg03I6Zj4g9BsCRHfWS
         jxUGUArWRXSPi8Rt9Or2esEZZtQSeIX3QWgwI2UCFsCENBAIc8/FLWnJXmrlgorrTgZN
         XD7sZ4qU/CPnNoKj+i8yB/Nu6L2eZ5LHHUDobQWK/CU8l7lqd8Q1UbP6xJo73tSF9+tQ
         0EJH+tPVJssAMkyNNeyw8d3x1TnEdPsFbHsfk83iQLceOLPnVzeYmFVsv9Mjxhm9/aJv
         EqqA==
X-Gm-Message-State: AOAM530D7HVngZInCqVIQYJbHCqsmesWj/+zaL+YxsYW2c59+Y2YEyPH
        bgBvYNKOGF5rys80wHHQsdM8HUx2BQl1lv54/QCbXcb2eQWAUfl717rAw6YG1XMqqvjxCQ6Pq6Z
        4GOysm2tz6HKRkf0z311asK+lpbcyt5xBgpBqhzsJVu14xLW8zqph1A==
X-Google-Smtp-Source: ABdhPJw1i76iXkgQ4//c+MK0T1tQu/HCzNwM6V7w51BDkW/gJLfqnTfSgAqgaqjK5mh4eGLmmIaDSDo=
X-Received: by 2002:ad4:4b34:: with SMTP id s20mr4154042qvw.177.1593190353520;
 Fri, 26 Jun 2020 09:52:33 -0700 (PDT)
Date:   Fri, 26 Jun 2020 09:52:28 -0700
Message-Id: <20200626165231.672001-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH bpf-next v2 1/4] bpf: add BPF_CGROUP_INET_SOCK_RELEASE hook
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sometimes it's handy to know when the socket gets freed.
In particular, we'd like to try to use a smarter allocation
of ports for bpf_bind and explore the possibility of
limiting the number of SOCK_DGRAM sockets the process can have.
Adding a release pair to existing BPF_CGROUP_INET_SOCK_CREATE
can unlock both of the mentioned features.

The only questionable part here is the sock->sk check
in the inet_release. Looking at the places where we
do 'sock->sk = NULL', I don't understand how it can race
with inet_release and why the check is there (it's been
there since the initial git import). Otherwise, the
change itself is pretty simple, we add a BPF hook
to the inet_release and avoid calling it for kernel
sockets.

v2:
* fix compile issue with CONFIG_CGROUP_BPF=n (kernel test robot)

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
index c65b374a5090..d7aea1d0167a 100644
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
index 4d530b1d5683..2a3d4b8f95c7 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1994,6 +1994,7 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
 	case BPF_PROG_TYPE_CGROUP_SOCK:
 		switch (expected_attach_type) {
 		case BPF_CGROUP_INET_SOCK_CREATE:
+		case BPF_CGROUP_INET_SOCK_RELEASE:
 		case BPF_CGROUP_INET4_POST_BIND:
 		case BPF_CGROUP_INET6_POST_BIND:
 			return 0;
@@ -2792,6 +2793,7 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
 		return BPF_PROG_TYPE_CGROUP_SKB;
 		break;
 	case BPF_CGROUP_INET_SOCK_CREATE:
+	case BPF_CGROUP_INET_SOCK_RELEASE:
 	case BPF_CGROUP_INET4_POST_BIND:
 	case BPF_CGROUP_INET6_POST_BIND:
 		return BPF_PROG_TYPE_CGROUP_SOCK;
@@ -2942,6 +2944,7 @@ static int bpf_prog_query(const union bpf_attr *attr,
 	case BPF_CGROUP_INET_INGRESS:
 	case BPF_CGROUP_INET_EGRESS:
 	case BPF_CGROUP_INET_SOCK_CREATE:
+	case BPF_CGROUP_INET_SOCK_RELEASE:
 	case BPF_CGROUP_INET4_BIND:
 	case BPF_CGROUP_INET6_BIND:
 	case BPF_CGROUP_INET4_POST_BIND:
diff --git a/net/core/filter.c b/net/core/filter.c
index 209482a4eaa2..7bcac182383c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6855,6 +6855,7 @@ static bool __sock_filter_check_attach_type(int off,
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

