Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5F720A9AF
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 02:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbgFZAJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 20:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgFZAJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 20:09:33 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5FB3C08C5DB
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 17:09:32 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id w9so7942208ybt.2
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 17:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=vkDmfyOJtnFtYzWvfEgCd9QelFOIV4Uf9bIpqIS45QQ=;
        b=cvv3oOX5TSfIrmzMS63S0JIxCqqxGEr+RjFTxaMoPlfiWlmI3IDQkzBchu3Zl1VuEn
         C6DRg0J+qkG1UfuIqfnb9fl9AiKmgXiCyXVu3pbKZQ9fxh/pM0GWm1nIE5HKFb8bgF6g
         0gDlZjdZ7hrSWq45PDw4d44rbVl7YC98dT/dPMrPEMOGxKA6Y8Ntx+cTd7afFM8M8f3o
         IBsWhd0M2gJLF7s9mVF6Ak3EVIta5OlePGkbr93/vAmoRGgATMqvYdTtqspb+CzGi/9y
         JApVMpyI0BSF/IpRHpcJht52iC58S6u4HMxOp0fvxeLp52cUHHYSB+V6ooWEI/cRNbPh
         Y05Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=vkDmfyOJtnFtYzWvfEgCd9QelFOIV4Uf9bIpqIS45QQ=;
        b=Q6menkYBdq7/BmIBmxK1HT/giBFtEIwU91EUChHMHuK7L7rN4YXUP2ppMt/4Ozqcx5
         Tx+bXUT9sZOVP00P5cwrNiPF4Rj0SUUdc3kphq/ZZiil9ECb/xR8qBFOoNI6QxAhFrmT
         LYSggAEMX/LoCA4VR63BoA1jemDbm0QSKokA+WNLPaInytcn3H/dxES9+4TGskeKPk0N
         aNLQhhgusAiZ+IrJHMT0sJWo564FkA4DL7V1wxczdAkm0AQeh4moN8zmJl58nbczvgN/
         j262qQulTjC4RRjRmA97QFkNf9xkEzmx+QPyxF7IbS1HpJSx8H8ZsS6mV2GYrqrXW40s
         tNUw==
X-Gm-Message-State: AOAM530xSWHifm2f+t/PNzaOMoMqJzotj5jsJEerOzjSG22QuO+gXjZ8
        HAo3O7kJNgR2E0zqj1Xh8abDMq0tnIr+oFEYyFQ5hNQ//aM64yN1x+bfAGNoldCwoG6vMWdS2OI
        dzeWD6/iAGif5yeips+olObQQEI1XSfZIiLKh/kSjWtbrG04F+0Gb0Q==
X-Google-Smtp-Source: ABdhPJwn7cFeIjhdrEPyiYpK8kPTuvvISD5PrZu5UQ6OipDyT8ufD9F7LzQjg562e0i7O8m5xsQBLeE=
X-Received: by 2002:a25:18d5:: with SMTP id 204mr608318yby.209.1593130171514;
 Thu, 25 Jun 2020 17:09:31 -0700 (PDT)
Date:   Thu, 25 Jun 2020 17:09:26 -0700
Message-Id: <20200626000929.217930-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.111.gc72c7da667-goog
Subject: [PATCH bpf-next 1/4] bpf: add BPF_CGROUP_INET_SOCK_RELEASE hook
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

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/linux/bpf-cgroup.h | 3 +++
 include/uapi/linux/bpf.h   | 1 +
 kernel/bpf/syscall.c       | 3 +++
 net/core/filter.c          | 1 +
 net/ipv4/af_inet.c         | 3 +++
 5 files changed, 11 insertions(+)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index c66c545e161a..b4fd09fe67bd 100644
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
2.27.0.111.gc72c7da667-goog

