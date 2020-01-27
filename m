Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCB6B14A43F
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 13:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbgA0Mzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 07:55:55 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:36760 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727250AbgA0Mzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 07:55:54 -0500
Received: by mail-lj1-f193.google.com with SMTP id r19so10560114ljg.3
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 04:55:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1G30UMK0augyexazwmTXwQHhRo58H589gz1vgGmoRQk=;
        b=Hvq8HA2LALlkN60AazmaafzwB4lQ8D7hYuRHlDJoBrzd4RaYWYBhGYa6RplqjyBaHo
         4xX8TDiQW4IY3qvxPvsjLt5OiV4J+X00JKibzcGCuPKGZhbX2Qo1qnCtIC9iuIhCmNac
         Sf1GGWTiSJSqqQLYRC9kOaSQZ4vD6VDWt8L/c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1G30UMK0augyexazwmTXwQHhRo58H589gz1vgGmoRQk=;
        b=WYovYbJyeMgT2bVw7I7ceVebrmRCW/jZTSUUSfGGEJujdUi7C2N4KOIZg8nmU9ynY3
         8GTTyvvNeRCopSrjdzB9MlDSTtCF8+mKL9MYqpTlKgST4aCUQNM+BewtKU6c90KPxzqi
         CnrAnoxGwWfTy/EzMsswV59Iru+a1lHAhkuqMQAY+GOX1jPR9YsdxKfSUAvZj6cIsHwK
         H1/x2MnCkA/DXeZk5H3i4+fUsRMngd5IXIn1fMrKpzgBTHwubQFvXZjxmKxeVeOTB+z3
         O1XA6kCkfgmkbwerIoWsjV8b4C06QfvF89O07Jot+JPF3I0mOirbxPX40nDPOZJopzEy
         Piug==
X-Gm-Message-State: APjAAAU7G4FdVuiQj6RKkCI36WfMwLuAhO4ZuPhWI2Gses9igCY1twEg
        eGZLESp8aabok3uxHgf10ZWxaw==
X-Google-Smtp-Source: APXvYqzm879Hh7DYViqJjBVNN9vgZlIlAcVL4bGRCNqxfFTqCokGdicaLQFMXSaVOEbLBUo+i2/75g==
X-Received: by 2002:a2e:b007:: with SMTP id y7mr9554952ljk.215.1580129752058;
        Mon, 27 Jan 2020 04:55:52 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id p136sm8166549lfa.8.2020.01.27.04.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 04:55:51 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Martin Lau <kafai@fb.com>
Subject: [PATCH bpf-next v5 10/12] net: Generate reuseport group ID on group creation
Date:   Mon, 27 Jan 2020 13:55:32 +0100
Message-Id: <20200127125534.137492-11-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200127125534.137492-1-jakub@cloudflare.com>
References: <20200127125534.137492-1-jakub@cloudflare.com>
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
most S32_MAX reuseport groups, which hopefully is sufficient. If we ever
get close to the limit, we can switch an u64 counter like sk_cookie.

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
 net/core/filter.c            | 12 +--------
 net/core/sock_reuseport.c    | 50 +++++++++++++++---------------------
 4 files changed, 22 insertions(+), 47 deletions(-)

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
index 6922f1a55383..0e2d82306c95 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8641,18 +8641,8 @@ BPF_CALL_4(sk_select_reuseport, struct sk_reuseport_kern *, reuse_kern,
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
index f19f179538b9..8d928d632ac5 100644
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
 
@@ -200,12 +189,15 @@ void reuseport_detach_sock(struct sock *sk)
 	reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
 					  lockdep_is_held(&reuseport_lock));
 
-	/* At least one of the sk in this reuseport group is added to
-	 * a bpf map.  Notify the bpf side.  The bpf map logic will
-	 * remove the sk if it is indeed added to a bpf map.
+	/* Notify the bpf side. The sk may be added to a sockarray
+	 * map. If so, sockarray logic will remove it from the map.
+	 *
+	 * Other bpf map types that work with reuseport, like sockmap,
+	 * don't need an explicit callback from here. They override sk
+	 * unhash/close ops to remove the sk from the map before we
+	 * get to this point.
 	 */
-	if (reuse->reuseport_id)
-		bpf_sk_reuseport_detach(sk);
+	bpf_sk_reuseport_detach(sk);
 
 	rcu_assign_pointer(sk->sk_reuseport_cb, NULL);
 
-- 
2.24.1

