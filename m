Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADB91454C8
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 14:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729299AbgAVNGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 08:06:12 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:34167 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729225AbgAVNGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 08:06:08 -0500
Received: by mail-lj1-f195.google.com with SMTP id z22so6741307ljg.1
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 05:06:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2fuNb/bYY4glLM0GgkM0VFFV8BUT+BNwpGR+uAIzlYc=;
        b=hsAiE8N259sOtCUYtlYDCgcMCCHmjQDQ3zTzYUuXgEOR0e/L0J0BLwoDu5xClTudtx
         mcUX/Qkj4jxTHEQi6FnFTPQoK4U1nBlM9EGI1OO1ow9LdpZts87mzUlgJktWh0CI1U33
         UyxyfqcHf3Gv6N3Xn1EgLl2oDifo0/BJsfbHo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2fuNb/bYY4glLM0GgkM0VFFV8BUT+BNwpGR+uAIzlYc=;
        b=HkFSX7GYeKv72mgWcTaJfTzJK28k8S69nTJRxJ16zLnhaQvv5/LntBpeA5pIzAC7MR
         XKlemp2moMbE1Hakd0r6LJkFgdRnxl3zndFyks97jX6G9yjRvbEW/Hvo5Lm1qTZbXVy8
         GeFZ5+vGy57Il8t2TK3IN1DYJMWmXcdMNI9OeIgMu22dXAsqWUyIjqEHKJRkI0ZjhS50
         N42micKtn0IPAlU0igdhC6rUjo8e6ieMI0ukw8uS2Ne0mcU18/y2jAXv90lFGB8yqhHn
         o/5HY2uNjLHIpe7Jb0uQ1ZczbykP5/B4yEPqKWF4xea3H6Wa0Qq+5uSbK+UnlLlcqxpO
         hmRg==
X-Gm-Message-State: APjAAAU0kx5J1qtsVcqnwwwvqR9HCu4xDBO7D/lnSC0gK2NkFJ5oJ6jD
        hYSC2V1pLVY85e647Ed0BhTyGg==
X-Google-Smtp-Source: APXvYqxHn5Zwj/8KxtOeDDPXrtZnVp6ZUwSiZticBdIFSw52EAy68a+1ZAROk+kIRKp6ZNTEtwKLEg==
X-Received: by 2002:a2e:8946:: with SMTP id b6mr5478185ljk.1.1579698366347;
        Wed, 22 Jan 2020 05:06:06 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id c27sm20488301lfh.62.2020.01.22.05.06.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 05:06:05 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Subject: [PATCH bpf-next v3 10/12] net: Generate reuseport group ID on group creation
Date:   Wed, 22 Jan 2020 14:05:47 +0100
Message-Id: <20200122130549.832236-11-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200122130549.832236-1-jakub@cloudflare.com>
References: <20200122130549.832236-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 736b46027eb4 ("net: Add ID (if needed) to sock_reuseport and expose
reuseport_lock") has introduced lazy generation of reuseport group IDs that
survive group resize.

By comparing the identifier we check if BPF reuseport program is not trying
to select a socket from a BPF map that belongs to a different reuseport
group than the one the packet is for.

Because SOCKARRAY used to be the only BPF map type that can be used with
reuseport BPF, it was possible to delay the generation of reuseport group
ID until a socket from the group was inserted into BPF map for the first
time.

Now that SOCKMAP can be used with reuseport BPF we have two options, either
generate the reuseport ID on map update, like SOCKARRAY does, or allocate
an ID from the start when reuseport group gets created.

This patch goes the latter approach to keep SOCKMAP free of calls into
reuseport code. This streamlines the reuseport_id access as its lifetime
now matches the longevity of reuseport object.

The cost of this simplification, however, is that we allocate reuseport IDs
for all SO_REUSEPORT users. Even those that don't use SOCKARRAY in their
setups. With the way identifiers are currently generated, we can have at
most S32_MAX reuseport groups, which hopefully is sufficient.

Another change is that we now always call into SOCKARRAY logic to unlink
the socket from the map when unhashing or closing the socket. Previously we
did it only when at least one socket from the group was in a BPF map.

It is worth noting that this doesn't conflict with SOCKMAP tear-down in
case a socket is in a SOCKMAP and belongs to a reuseport group. SOCKMAP
tear-down happens first:

  prot->unhash
  `- tcp_bpf_unhash
     |- tcp_bpf_remove
     |  `- while (sk_psock_link_pop(psock))
     |     `- sk_psock_unlink
     |        `- sock_map_delete_from_link
     |           `- __sock_map_delete
     |              `- sock_map_unref
     |                 `- sk_psock_put
     |                    `- sk_psock_drop
     |                       `- rcu_assign_sk_user_data(sk, NULL)
     `- inet_unhash
        `- reuseport_detach_sock
           `- bpf_sk_reuseport_detach
              `- WRITE_ONCE(sk->sk_user_data, NULL)

Suggested-by: Martin Lau <kafai@fb.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/net/sock_reuseport.h |  2 --
 kernel/bpf/reuseport_array.c |  5 ----
 net/core/filter.c            | 12 +---------
 net/core/sock_reuseport.c    | 45 +++++++++++++-----------------------
 4 files changed, 17 insertions(+), 47 deletions(-)

diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
index 43f4a818d88f..3ecaa15d1850 100644
--- a/include/net/sock_reuseport.h
+++ b/include/net/sock_reuseport.h
@@ -55,6 +55,4 @@ static inline bool reuseport_has_conns(struct sock *sk, bool set)
 	return ret;
 }
 
-int reuseport_get_id(struct sock_reuseport *reuse);
-
 #endif  /* _SOCK_REUSEPORT_H */
diff --git a/kernel/bpf/reuseport_array.c b/kernel/bpf/reuseport_array.c
index 50c083ba978c..01badd3eda7a 100644
--- a/kernel/bpf/reuseport_array.c
+++ b/kernel/bpf/reuseport_array.c
@@ -305,11 +305,6 @@ int bpf_fd_reuseport_array_update_elem(struct bpf_map *map, void *key,
 	if (err)
 		goto put_file_unlock;
 
-	/* Ensure reuse->reuseport_id is set */
-	err = reuseport_get_id(reuse);
-	if (err < 0)
-		goto put_file_unlock;
-
 	WRITE_ONCE(nsk->sk_user_data, &array->ptrs[index]);
 	rcu_assign_pointer(array->ptrs[index], nsk);
 	free_osk = osk;
diff --git a/net/core/filter.c b/net/core/filter.c
index e20f076ab9b0..41d15770ad80 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8646,18 +8646,8 @@ BPF_CALL_4(sk_select_reuseport, struct sk_reuseport_kern *, reuse_kern,
 	}
 
 	if (unlikely(reuse->reuseport_id != reuse_kern->reuseport_id)) {
-		struct sock *sk;
-
-		if (unlikely(!reuse_kern->reuseport_id))
-			/* There is a small race between adding the
-			 * sk to the map and setting the
-			 * reuse_kern->reuseport_id.
-			 * Treat it as the sk has not been added to
-			 * the bpf map yet.
-			 */
-			return -ENOENT;
+		struct sock *sk = reuse_kern->sk;
 
-		sk = reuse_kern->sk;
 		if (sk->sk_protocol != selected_sk->sk_protocol)
 			return -EPROTOTYPE;
 		else if (sk->sk_family != selected_sk->sk_family)
diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index f19f179538b9..236b66e01ad8 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -16,27 +16,8 @@
 
 DEFINE_SPINLOCK(reuseport_lock);
 
-#define REUSEPORT_MIN_ID 1
 static DEFINE_IDA(reuseport_ida);
 
-int reuseport_get_id(struct sock_reuseport *reuse)
-{
-	int id;
-
-	if (reuse->reuseport_id)
-		return reuse->reuseport_id;
-
-	id = ida_simple_get(&reuseport_ida, REUSEPORT_MIN_ID, 0,
-			    /* Called under reuseport_lock */
-			    GFP_ATOMIC);
-	if (id < 0)
-		return id;
-
-	reuse->reuseport_id = id;
-
-	return reuse->reuseport_id;
-}
-
 static struct sock_reuseport *__reuseport_alloc(unsigned int max_socks)
 {
 	unsigned int size = sizeof(struct sock_reuseport) +
@@ -55,6 +36,7 @@ static struct sock_reuseport *__reuseport_alloc(unsigned int max_socks)
 int reuseport_alloc(struct sock *sk, bool bind_inany)
 {
 	struct sock_reuseport *reuse;
+	int id, ret = 0;
 
 	/* bh lock used since this function call may precede hlist lock in
 	 * soft irq of receive path or setsockopt from process context
@@ -78,10 +60,18 @@ int reuseport_alloc(struct sock *sk, bool bind_inany)
 
 	reuse = __reuseport_alloc(INIT_SOCKS);
 	if (!reuse) {
-		spin_unlock_bh(&reuseport_lock);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out;
 	}
 
+	id = ida_alloc(&reuseport_ida, GFP_ATOMIC);
+	if (id < 0) {
+		kfree(reuse);
+		ret = id;
+		goto out;
+	}
+
+	reuse->reuseport_id = id;
 	reuse->socks[0] = sk;
 	reuse->num_socks = 1;
 	reuse->bind_inany = bind_inany;
@@ -90,7 +80,7 @@ int reuseport_alloc(struct sock *sk, bool bind_inany)
 out:
 	spin_unlock_bh(&reuseport_lock);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(reuseport_alloc);
 
@@ -135,8 +125,7 @@ static void reuseport_free_rcu(struct rcu_head *head)
 
 	reuse = container_of(head, struct sock_reuseport, rcu);
 	sk_reuseport_prog_free(rcu_dereference_protected(reuse->prog, 1));
-	if (reuse->reuseport_id)
-		ida_simple_remove(&reuseport_ida, reuse->reuseport_id);
+	ida_free(&reuseport_ida, reuse->reuseport_id);
 	kfree(reuse);
 }
 
@@ -200,12 +189,10 @@ void reuseport_detach_sock(struct sock *sk)
 	reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
 					  lockdep_is_held(&reuseport_lock));
 
-	/* At least one of the sk in this reuseport group is added to
-	 * a bpf map.  Notify the bpf side.  The bpf map logic will
-	 * remove the sk if it is indeed added to a bpf map.
+	/* Notify the bpf side. The sk may be added to bpf map. The
+	 * bpf map logic will remove the sk from the map if indeed.
 	 */
-	if (reuse->reuseport_id)
-		bpf_sk_reuseport_detach(sk);
+	bpf_sk_reuseport_detach(sk);
 
 	rcu_assign_pointer(sk->sk_reuseport_cb, NULL);
 
-- 
2.24.1

