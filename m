Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10CD8136B56
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 11:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727659AbgAJKuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 05:50:39 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41645 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727630AbgAJKui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 05:50:38 -0500
Received: by mail-wr1-f67.google.com with SMTP id c9so1332508wrw.8
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 02:50:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oiCVl4px+tKVEh+6rXZ/+jXk8tt2rRze7absviz4v7k=;
        b=O5LOnDj+g+7Y/USSVr6fszlZDvyPmhsMiC1zYKPUEXhnol6X3N8Cy701W/szF3qfEE
         EEjvvkNnMuxbU44TJSlZAf1wjLHBpqEQ7yz3BBK0q8CufllB9k0Jt2d8xwx81HB6LaNb
         +ORFYNl1mlyk04iID0KB4SLIX3heGXR0P8uuU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oiCVl4px+tKVEh+6rXZ/+jXk8tt2rRze7absviz4v7k=;
        b=uHU7eizoAJwxC+/cKcgjSauWSGZfYI9/0KgQ1Q0JUhtuSyB6AOgLhrSbJXrqCI8CfI
         ZCyJ8wDTfR81/SfCoOBU26n7gLfiK1TvUetzJCuKZ9ShyktN/tHuJH6m9tOUd/ybFNK9
         4tAgswdl6o47AP18lDaZubUMWvIzrqQoAV5LWaQqir/suvHJPqX7zvPwzd/AbYoGlDgO
         bpa+eDhk8iO78Nos7kwQ/KemGuh8PSlcczQf0x+Ub52pxW2dwHKCZAuUStvmXxtUawrl
         yhYJjjDueQSfw04U58xqwzNgNE4FvaReRklEtkVejrLtUxqnhwb5NhRwnqhANNA/KRdf
         dwvg==
X-Gm-Message-State: APjAAAW5/2oCltl6MHWDozfxE0HnHZMvmiWMdEMFYECZtvgzngTR2Prv
        nTJEV/MSII/hz0fFdqasXNKTWA==
X-Google-Smtp-Source: APXvYqyYdmyJL0QAvkRZyyiYEHv2c1mJkjDPY33o7SN4gbE5f+WVlgof3s8G+TenFNPchalYjqexsw==
X-Received: by 2002:adf:f491:: with SMTP id l17mr2794568wro.149.1578653436241;
        Fri, 10 Jan 2020 02:50:36 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id y17sm1763597wma.36.2020.01.10.02.50.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 02:50:35 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next v2 05/11] bpf, sockmap: Allow inserting listening TCP sockets into sockmap
Date:   Fri, 10 Jan 2020 11:50:21 +0100
Message-Id: <20200110105027.257877-6-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110105027.257877-1-jakub@cloudflare.com>
References: <20200110105027.257877-1-jakub@cloudflare.com>
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

Change the update pre-checks so that the socket can also be in listening
state. If the state is not white-listed, return -EINVAL to be consistent
with REUSEPORT_SOCKARRY map type.

Since it doesn't make sense to redirect with sockmap to listening sockets,
add appropriate socket state checks to BPF redirect helpers too.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/core/sock_map.c                     | 46 ++++++++++++++++++++-----
 tools/testing/selftests/bpf/test_maps.c |  6 +---
 2 files changed, 39 insertions(+), 13 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index eb114ee419b6..99daea502508 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -396,6 +396,23 @@ static bool sock_map_sk_is_suitable(const struct sock *sk)
 	       sk->sk_protocol == IPPROTO_TCP;
 }
 
+/* Is sock in a state that allows inserting into the map?
+ * SYN_RECV is needed for updates on BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB.
+ */
+static bool sock_map_update_okay(const struct sock *sk)
+{
+	return (1 << sk->sk_state) & (TCPF_ESTABLISHED |
+				      TCPF_SYN_RECV |
+				      TCPF_LISTEN);
+}
+
+/* Is sock in a state that allows redirecting into it? */
+static bool sock_map_redirect_okay(const struct sock *sk)
+{
+	return (1 << sk->sk_state) & (TCPF_ESTABLISHED |
+				      TCPF_SYN_RECV);
+}
+
 static int sock_map_update_elem(struct bpf_map *map, void *key,
 				void *value, u64 flags)
 {
@@ -413,11 +430,14 @@ static int sock_map_update_elem(struct bpf_map *map, void *key,
 		ret = -EINVAL;
 		goto out;
 	}
-	if (!sock_map_sk_is_suitable(sk) ||
-	    sk->sk_state != TCP_ESTABLISHED) {
+	if (!sock_map_sk_is_suitable(sk)) {
 		ret = -EOPNOTSUPP;
 		goto out;
 	}
+	if (!sock_map_update_okay(sk)) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	sock_map_sk_acquire(sk);
 	ret = sock_map_update_common(map, idx, sk, flags);
@@ -433,6 +453,7 @@ BPF_CALL_4(bpf_sock_map_update, struct bpf_sock_ops_kern *, sops,
 	WARN_ON_ONCE(!rcu_read_lock_held());
 
 	if (likely(sock_map_sk_is_suitable(sops->sk) &&
+		   sock_map_update_okay(sops->sk) &&
 		   sock_map_op_okay(sops)))
 		return sock_map_update_common(map, *(u32 *)key, sops->sk,
 					      flags);
@@ -454,13 +475,17 @@ BPF_CALL_4(bpf_sk_redirect_map, struct sk_buff *, skb,
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
+	if (!sk || !sock_map_redirect_okay(sk))
 		return SK_DROP;
+
+	tcb->bpf.flags = flags;
+	tcb->bpf.sk_redir = sk;
 	return SK_PASS;
 }
 
@@ -477,12 +502,17 @@ const struct bpf_func_proto bpf_sk_redirect_map_proto = {
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
+	if (!sk || !sock_map_redirect_okay(sk))
 		return SK_DROP;
+
+	msg->flags = flags;
+	msg->sk_redir = sk;
 	return SK_PASS;
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

