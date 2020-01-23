Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF97146D80
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 16:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbgAWPzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 10:55:49 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51982 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728931AbgAWPzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 10:55:45 -0500
Received: by mail-wm1-f68.google.com with SMTP id t23so3101069wmi.1
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 07:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=19I0jwH6NcpRqtS1G/gKKbV/DMmIp3+NrSXyhRDpbX0=;
        b=fH5UY+KXmf1v2N50fJbfuqByilUKEInRsGFmgzpyOiIm0NqhHAo42VT7ATIe1ASPFc
         QEOOmlmvOigHSHpJwDuJ1F4XTjm4Bg4i1LfasvxHNucELBJeoG7sy3qcHB2BHZWWGGZ3
         27bh54nT0Nelj6Y1IBDVx8WF5amXEgUCweh/M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=19I0jwH6NcpRqtS1G/gKKbV/DMmIp3+NrSXyhRDpbX0=;
        b=HQojnSSFPWW+6RGRcheONS78QtPGNQlMRwSJ4g/RhKV69Hl3aXi35ZloqVKawD7hax
         IKcinyyYirv/0OumtYfKhZXnBd73ovJBW/WGMh8rM8UY8bIOql7xsAmC/Km9V0M38wCT
         Jj51145BjW5YDFh32p0mvEKqglUU/b30VvZE1IZVOW72yNZgPL/7f3kEHfXg36Kw9Oqy
         J9F/VVNqWc4kjQrZW0kNLnaj9WAolsl1xavPyYP1fGeMo7Fl32ovB4f6gkQxU2AnC0eJ
         vcfj6c7j4MjeI2cC01WAr3i1w1ApVMPP3wgv1H+UlayO24Pp91cFRY9Yivf07HJpGsDY
         X6Fw==
X-Gm-Message-State: APjAAAWmp9cRH+IBUyDKY/s1HuHt/TbE9Xz1bDHy7ogIP88UJzzfblvN
        ALe3oSWYY3yJFtuVIDI7f+J5sg==
X-Google-Smtp-Source: APXvYqy9OZkDy5xOByXlXA6MfYGc/6rBE45j/g+VQb6DqRImJCCiGSSC1vj9aS8dsewu89Ois19Skg==
X-Received: by 2002:a7b:c8d6:: with SMTP id f22mr5081031wml.189.1579794942363;
        Thu, 23 Jan 2020 07:55:42 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id z123sm3209464wme.18.2020.01.23.07.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 07:55:41 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Subject: [PATCH bpf-next v4 05/12] bpf, sockmap: Allow inserting listening TCP sockets into sockmap
Date:   Thu, 23 Jan 2020 16:55:27 +0100
Message-Id: <20200123155534.114313-6-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200123155534.114313-1-jakub@cloudflare.com>
References: <20200123155534.114313-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order for sockmap type to become a generic collection for storing TCP
sockets we need to loosen the checks during map update, while tightening
the checks in redirect helpers.

Currently sockmap requires the TCP socket to be in established state (or
transitioning out of SYN_RECV into established state when done from BPF),
which prevents inserting listening sockets.

Change the update pre-checks so the socket can also be in listening state.

Since it doesn't make sense to redirect with sockmap to listening sockets,
add appropriate socket state checks to BPF redirect helpers too.

We leave sockhash as is for the moment, with no support for holding
listening sockets. Therefore sockhash needs its own set of checks.

Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/core/sock_map.c                     | 62 +++++++++++++++++++------
 tools/testing/selftests/bpf/test_maps.c |  6 +--
 2 files changed, 50 insertions(+), 18 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index eb114ee419b6..97bdceb29f09 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -385,15 +385,44 @@ static int sock_map_update_common(struct bpf_map *map, u32 idx,
 }
 
 static bool sock_map_op_okay(const struct bpf_sock_ops_kern *ops)
+{
+	return ops->op == BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB ||
+	       ops->op == BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB ||
+	       ops->op == BPF_SOCK_OPS_TCP_LISTEN_CB;
+}
+
+static bool sock_hash_op_okay(const struct bpf_sock_ops_kern *ops)
 {
 	return ops->op == BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB ||
 	       ops->op == BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB;
 }
 
+/* Only TCP sockets can be inserted into the map. They must be either
+ * in established or listening state. SYN_RECV is also allowed because
+ * BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB happens just before socket
+ * enters established state.
+ */
 static bool sock_map_sk_is_suitable(const struct sock *sk)
 {
 	return sk->sk_type == SOCK_STREAM &&
-	       sk->sk_protocol == IPPROTO_TCP;
+	       sk->sk_protocol == IPPROTO_TCP &&
+	       (1 << sk->sk_state) & (TCPF_ESTABLISHED |
+				      TCPF_SYN_RECV |
+				      TCPF_LISTEN);
+}
+
+static bool sock_hash_sk_is_suitable(const struct sock *sk)
+{
+	return sk->sk_type == SOCK_STREAM &&
+	       sk->sk_protocol == IPPROTO_TCP &&
+	       (1 << sk->sk_state) & (TCPF_ESTABLISHED |
+				      TCPF_SYN_RECV);
+}
+
+/* Is sock in a state that allows redirecting into it? */
+static bool sock_map_redirect_okay(const struct sock *sk)
+{
+	return sk->sk_state != TCP_LISTEN;
 }
 
 static int sock_map_update_elem(struct bpf_map *map, void *key,
@@ -413,8 +442,7 @@ static int sock_map_update_elem(struct bpf_map *map, void *key,
 		ret = -EINVAL;
 		goto out;
 	}
-	if (!sock_map_sk_is_suitable(sk) ||
-	    sk->sk_state != TCP_ESTABLISHED) {
+	if (!sock_map_sk_is_suitable(sk)) {
 		ret = -EOPNOTSUPP;
 		goto out;
 	}
@@ -454,13 +482,17 @@ BPF_CALL_4(bpf_sk_redirect_map, struct sk_buff *, skb,
 	   struct bpf_map *, map, u32, key, u64, flags)
 {
 	struct tcp_skb_cb *tcb = TCP_SKB_CB(skb);
+	struct sock *sk;
 
 	if (unlikely(flags & ~(BPF_F_INGRESS)))
 		return SK_DROP;
-	tcb->bpf.flags = flags;
-	tcb->bpf.sk_redir = __sock_map_lookup_elem(map, key);
-	if (!tcb->bpf.sk_redir)
+
+	sk = __sock_map_lookup_elem(map, key);
+	if (unlikely(!sk || !sock_map_redirect_okay(sk)))
 		return SK_DROP;
+
+	tcb->bpf.flags = flags;
+	tcb->bpf.sk_redir = sk;
 	return SK_PASS;
 }
 
@@ -477,12 +509,17 @@ const struct bpf_func_proto bpf_sk_redirect_map_proto = {
 BPF_CALL_4(bpf_msg_redirect_map, struct sk_msg *, msg,
 	   struct bpf_map *, map, u32, key, u64, flags)
 {
+	struct sock *sk;
+
 	if (unlikely(flags & ~(BPF_F_INGRESS)))
 		return SK_DROP;
-	msg->flags = flags;
-	msg->sk_redir = __sock_map_lookup_elem(map, key);
-	if (!msg->sk_redir)
+
+	sk = __sock_map_lookup_elem(map, key);
+	if (unlikely(!sk || !sock_map_redirect_okay(sk)))
 		return SK_DROP;
+
+	msg->flags = flags;
+	msg->sk_redir = sk;
 	return SK_PASS;
 }
 
@@ -736,8 +773,7 @@ static int sock_hash_update_elem(struct bpf_map *map, void *key,
 		ret = -EINVAL;
 		goto out;
 	}
-	if (!sock_map_sk_is_suitable(sk) ||
-	    sk->sk_state != TCP_ESTABLISHED) {
+	if (!sock_hash_sk_is_suitable(sk)) {
 		ret = -EOPNOTSUPP;
 		goto out;
 	}
@@ -882,8 +918,8 @@ BPF_CALL_4(bpf_sock_hash_update, struct bpf_sock_ops_kern *, sops,
 {
 	WARN_ON_ONCE(!rcu_read_lock_held());
 
-	if (likely(sock_map_sk_is_suitable(sops->sk) &&
-		   sock_map_op_okay(sops)))
+	if (likely(sock_hash_sk_is_suitable(sops->sk) &&
+		   sock_hash_op_okay(sops)))
 		return sock_hash_update_common(map, key, sops->sk, flags);
 	return -EOPNOTSUPP;
 }
diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index 02eae1e864c2..c6766b2cff85 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -756,11 +756,7 @@ static void test_sockmap(unsigned int tasks, void *data)
 	/* Test update without programs */
 	for (i = 0; i < 6; i++) {
 		err = bpf_map_update_elem(fd, &i, &sfd[i], BPF_ANY);
-		if (i < 2 && !err) {
-			printf("Allowed update sockmap '%i:%i' not in ESTABLISHED\n",
-			       i, sfd[i]);
-			goto out_sockmap;
-		} else if (i >= 2 && err) {
+		if (err) {
 			printf("Failed noprog update sockmap '%i:%i'\n",
 			       i, sfd[i]);
 			goto out_sockmap;
-- 
2.24.1

