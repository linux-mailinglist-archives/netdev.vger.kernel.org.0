Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAF5634414
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 19:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234574AbiKVSzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 13:55:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234282AbiKVSzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 13:55:49 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78EDC7EBD5
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 10:55:47 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id i64-20020a1c3b43000000b003d016c21100so6374638wma.3
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 10:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2434tB7FP4/Y6139o+YqR6fe/hlFtN7viFppwMOREps=;
        b=ciXsqnnjYzhhQnI4CkwG6HhxjZ0kZzpeEGFNh0307pCixpQHe7bYpAidh6qi+CGzAD
         lgb17YYhVCJSSvAuQO0lUFf4sPNhCS6m9Kc5XZzytoIeToYW2TxvVNLsKRmgcdtRCRPd
         1nGdlQl+GXTwlgLEgA+KhmO859foPPXtn6nKpScoiRvocKTmyXKhoJ6xykU4oOnE16Oz
         NEUVlpMz6UIz9WVvleG/C5GOexBfdX1cuKmC0M5SOv6Qt0K7f3LKvevr5ru2orD7V7ht
         V41uVmav4fxfK78d3Ri5Qhz01pvj6n+XX5mgwmqzKxfTIepSq/i9SUSZurOC033JRiOV
         8UjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2434tB7FP4/Y6139o+YqR6fe/hlFtN7viFppwMOREps=;
        b=hLwZF0muPhP7sD9p4lKcQiTZYeF0MxETH+oVjbapzToxdFQkiw/Z6gdjK9FRa+KZCS
         co7if1yN9HCzcz3D9UMjEtEaYkLoT9pZJUbUzxAsG8p3psbJmod/6Tl/oSfWZiDXteW2
         vvUq6Nqs2nVDZv2P3EnrurPnVromiw32JHuIjWZT3s4abxVxZFlE6ZkK+1BKF9yAZ6G1
         kTeTV83D/WSko6hCqjbf/XYfQ0gYq8TUh7JDj21TbWI9/xqAEIRU3WGAtpVqJ0Pj/rlh
         LToxR9832h201NJSnn3XCZIGzSvkob0JN+PBhDpkZwDonFS0tTx27uyMj/JLZmT+9sTB
         PU7w==
X-Gm-Message-State: ANoB5plsT4dR4wTs0QQcOvEqhjwR2DJKcyQZXVGCp4+Q1M2xq4dAPft3
        tYbxGmzGZ5LM01eXHH9by6t3yQ==
X-Google-Smtp-Source: AA0mqf4wp7Ds2kypLodAmSFyX+WSFKE3RBBgZcYbJ7s15ABHMDQ3lROLnRhV2kIAhPYNxOnEQK7Ftg==
X-Received: by 2002:a05:600c:4f55:b0:3cf:729b:d4b4 with SMTP id m21-20020a05600c4f5500b003cf729bd4b4mr11333600wmq.48.1669143345975;
        Tue, 22 Nov 2022 10:55:45 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id c18-20020adffb12000000b002365730eae8sm14478044wrr.55.2022.11.22.10.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 10:55:45 -0800 (PST)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Dmitry Safonov <dima@arista.com>, Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Baron <jbaron@akamai.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org
Subject: [PATCH v5 3/5] net/tcp: Disable TCP-MD5 static key on tcp_md5sig_info destruction
Date:   Tue, 22 Nov 2022 18:55:32 +0000
Message-Id: <20221122185534.308643-4-dima@arista.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221122185534.308643-1-dima@arista.com>
References: <20221122185534.308643-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To do that, separate two scenarios:
- where it's the first MD5 key on the system, which means that enabling
  of the static key may need to sleep;
- copying of an existing key from a listening socket to the request
  socket upon receiving a signed TCP segment, where static key was
  already enabled (when the key was added to the listening socket).

Now the life-time of the static branch for TCP-MD5 is until:
- last tcp_md5sig_info is destroyed
- last socket in time-wait state with MD5 key is closed.

Which means that after all sockets with TCP-MD5 keys are gone, the
system gets back the performance of disabled md5-key static branch.

While at here, provide static_key_fast_inc() helper that does ref
counter increment in atomic fashion (without grabbing cpus_read_lock()
on CONFIG_JUMP_LABEL=y). This is needed to add a new user for
a static_key when the caller controls the lifetime of another user.

Signed-off-by: Dmitry Safonov <dima@arista.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/jump_label.h |  4 ++-
 include/net/tcp.h          | 10 ++++--
 kernel/jump_label.c        |  3 +-
 net/ipv4/tcp.c             |  5 +--
 net/ipv4/tcp_ipv4.c        | 71 +++++++++++++++++++++++++++++++-------
 net/ipv4/tcp_minisocks.c   | 16 ++++++---
 net/ipv4/tcp_output.c      |  4 +--
 net/ipv6/tcp_ipv6.c        | 10 +++---
 8 files changed, 89 insertions(+), 34 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index c0a02d4c2ea2..f3fc5081cae6 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -225,6 +225,7 @@ extern bool arch_jump_label_transform_queue(struct jump_entry *entry,
 extern void arch_jump_label_transform_apply(void);
 extern int jump_label_text_reserved(void *start, void *end);
 extern bool static_key_slow_inc(struct static_key *key);
+extern bool static_key_fast_inc_not_negative(struct static_key *key);
 extern void static_key_slow_dec(struct static_key *key);
 extern bool static_key_slow_inc_cpuslocked(struct static_key *key);
 extern void static_key_slow_dec_cpuslocked(struct static_key *key);
@@ -278,7 +279,7 @@ static __always_inline bool static_key_true(struct static_key *key)
 	return false;
 }
 
-static inline bool static_key_slow_inc(struct static_key *key)
+static inline bool static_key_fast_inc_not_negative(struct static_key *key)
 {
 	int v;
 
@@ -294,6 +295,7 @@ static inline bool static_key_slow_inc(struct static_key *key)
 	} while (!likely(atomic_try_cmpxchg(&key->enabled, &v, v + 1)));
 	return true;
 }
+#define static_key_slow_inc(key)	static_key_fast_inc_not_negative(key)
 
 static inline void static_key_slow_dec(struct static_key *key)
 {
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 6b814e788f00..f925377066fe 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1675,7 +1675,11 @@ int tcp_v4_md5_hash_skb(char *md5_hash, const struct tcp_md5sig_key *key,
 			const struct sock *sk, const struct sk_buff *skb);
 int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 		   int family, u8 prefixlen, int l3index, u8 flags,
-		   const u8 *newkey, u8 newkeylen, gfp_t gfp);
+		   const u8 *newkey, u8 newkeylen);
+int tcp_md5_key_copy(struct sock *sk, const union tcp_md5_addr *addr,
+		     int family, u8 prefixlen, int l3index,
+		     struct tcp_md5sig_key *key);
+
 int tcp_md5_do_del(struct sock *sk, const union tcp_md5_addr *addr,
 		   int family, u8 prefixlen, int l3index, u8 flags);
 struct tcp_md5sig_key *tcp_v4_md5_lookup(const struct sock *sk,
@@ -1683,7 +1687,7 @@ struct tcp_md5sig_key *tcp_v4_md5_lookup(const struct sock *sk,
 
 #ifdef CONFIG_TCP_MD5SIG
 #include <linux/jump_label.h>
-extern struct static_key_false tcp_md5_needed;
+extern struct static_key_false_deferred tcp_md5_needed;
 struct tcp_md5sig_key *__tcp_md5_do_lookup(const struct sock *sk, int l3index,
 					   const union tcp_md5_addr *addr,
 					   int family);
@@ -1691,7 +1695,7 @@ static inline struct tcp_md5sig_key *
 tcp_md5_do_lookup(const struct sock *sk, int l3index,
 		  const union tcp_md5_addr *addr, int family)
 {
-	if (!static_branch_unlikely(&tcp_md5_needed))
+	if (!static_branch_unlikely(&tcp_md5_needed.key))
 		return NULL;
 	return __tcp_md5_do_lookup(sk, l3index, addr, family);
 }
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 677a6674c130..32c785f5d2b1 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -123,7 +123,7 @@ EXPORT_SYMBOL_GPL(static_key_count);
  *
  * Returns true if the increment was done.
  */
-static bool static_key_fast_inc_not_negative(struct static_key *key)
+bool static_key_fast_inc_not_negative(struct static_key *key)
 {
 	int v;
 
@@ -142,6 +142,7 @@ static bool static_key_fast_inc_not_negative(struct static_key *key)
 
 	return true;
 }
+EXPORT_SYMBOL_GPL(static_key_fast_inc_not_negative);
 
 bool static_key_slow_inc_cpuslocked(struct static_key *key)
 {
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4a69c5fcfedc..267406f199bc 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4465,11 +4465,8 @@ bool tcp_alloc_md5sig_pool(void)
 	if (unlikely(!READ_ONCE(tcp_md5sig_pool_populated))) {
 		mutex_lock(&tcp_md5sig_mutex);
 
-		if (!tcp_md5sig_pool_populated) {
+		if (!tcp_md5sig_pool_populated)
 			__tcp_alloc_md5sig_pool();
-			if (tcp_md5sig_pool_populated)
-				static_branch_inc(&tcp_md5_needed);
-		}
 
 		mutex_unlock(&tcp_md5sig_mutex);
 	}
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 2d76d50b8ae8..776fbc2451bc 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1064,7 +1064,7 @@ static void tcp_v4_reqsk_destructor(struct request_sock *req)
  * We need to maintain these in the sk structure.
  */
 
-DEFINE_STATIC_KEY_FALSE(tcp_md5_needed);
+DEFINE_STATIC_KEY_DEFERRED_FALSE(tcp_md5_needed, HZ);
 EXPORT_SYMBOL(tcp_md5_needed);
 
 static bool better_md5_match(struct tcp_md5sig_key *old, struct tcp_md5sig_key *new)
@@ -1177,9 +1177,6 @@ static int tcp_md5sig_info_add(struct sock *sk, gfp_t gfp)
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_md5sig_info *md5sig;
 
-	if (rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk)))
-		return 0;
-
 	md5sig = kmalloc(sizeof(*md5sig), gfp);
 	if (!md5sig)
 		return -ENOMEM;
@@ -1191,9 +1188,9 @@ static int tcp_md5sig_info_add(struct sock *sk, gfp_t gfp)
 }
 
 /* This can be called on a newly created socket, from other files */
-int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
-		   int family, u8 prefixlen, int l3index, u8 flags,
-		   const u8 *newkey, u8 newkeylen, gfp_t gfp)
+static int __tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
+			    int family, u8 prefixlen, int l3index, u8 flags,
+			    const u8 *newkey, u8 newkeylen, gfp_t gfp)
 {
 	/* Add Key to the list */
 	struct tcp_md5sig_key *key;
@@ -1220,9 +1217,6 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 		return 0;
 	}
 
-	if (tcp_md5sig_info_add(sk, gfp))
-		return -ENOMEM;
-
 	md5sig = rcu_dereference_protected(tp->md5sig_info,
 					   lockdep_sock_is_held(sk));
 
@@ -1246,8 +1240,59 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 	hlist_add_head_rcu(&key->node, &md5sig->head);
 	return 0;
 }
+
+int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
+		   int family, u8 prefixlen, int l3index, u8 flags,
+		   const u8 *newkey, u8 newkeylen)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+
+	if (!rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk))) {
+		if (tcp_md5sig_info_add(sk, GFP_KERNEL))
+			return -ENOMEM;
+
+		if (!static_branch_inc(&tcp_md5_needed.key)) {
+			struct tcp_md5sig_info *md5sig;
+
+			md5sig = rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk));
+			rcu_assign_pointer(tp->md5sig_info, NULL);
+			kfree_rcu(md5sig);
+			return -EUSERS;
+		}
+	}
+
+	return __tcp_md5_do_add(sk, addr, family, prefixlen, l3index, flags,
+				newkey, newkeylen, GFP_KERNEL);
+}
 EXPORT_SYMBOL(tcp_md5_do_add);
 
+int tcp_md5_key_copy(struct sock *sk, const union tcp_md5_addr *addr,
+		     int family, u8 prefixlen, int l3index,
+		     struct tcp_md5sig_key *key)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+
+	if (!rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk))) {
+		if (tcp_md5sig_info_add(sk, sk_gfp_mask(sk, GFP_ATOMIC)))
+			return -ENOMEM;
+
+		if (!static_key_fast_inc_not_negative(&tcp_md5_needed.key.key)) {
+			struct tcp_md5sig_info *md5sig;
+
+			md5sig = rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk));
+			net_warn_ratelimited("Too many TCP-MD5 keys in the system\n");
+			rcu_assign_pointer(tp->md5sig_info, NULL);
+			kfree_rcu(md5sig);
+			return -EUSERS;
+		}
+	}
+
+	return __tcp_md5_do_add(sk, addr, family, prefixlen, l3index,
+				key->flags, key->key, key->keylen,
+				sk_gfp_mask(sk, GFP_ATOMIC));
+}
+EXPORT_SYMBOL(tcp_md5_key_copy);
+
 int tcp_md5_do_del(struct sock *sk, const union tcp_md5_addr *addr, int family,
 		   u8 prefixlen, int l3index, u8 flags)
 {
@@ -1334,7 +1379,7 @@ static int tcp_v4_parse_md5_keys(struct sock *sk, int optname,
 		return -EINVAL;
 
 	return tcp_md5_do_add(sk, addr, AF_INET, prefixlen, l3index, flags,
-			      cmd.tcpm_key, cmd.tcpm_keylen, GFP_KERNEL);
+			      cmd.tcpm_key, cmd.tcpm_keylen);
 }
 
 static int tcp_v4_md5_hash_headers(struct tcp_md5sig_pool *hp,
@@ -1591,8 +1636,7 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 		 * memory, then we end up not copying the key
 		 * across. Shucks.
 		 */
-		tcp_md5_do_add(newsk, addr, AF_INET, 32, l3index, key->flags,
-			       key->key, key->keylen, GFP_ATOMIC);
+		tcp_md5_key_copy(newsk, addr, AF_INET, 32, l3index, key);
 		sk_gso_disable(newsk);
 	}
 #endif
@@ -2284,6 +2328,7 @@ void tcp_v4_destroy_sock(struct sock *sk)
 		tcp_clear_md5_list(sk);
 		kfree_rcu(rcu_dereference_protected(tp->md5sig_info, 1), rcu);
 		tp->md5sig_info = NULL;
+		static_branch_slow_dec_deferred(&tcp_md5_needed);
 	}
 #endif
 
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index c375f603a16c..50f91c10eb7b 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -291,13 +291,19 @@ void tcp_time_wait(struct sock *sk, int state, int timeo)
 		 */
 		do {
 			tcptw->tw_md5_key = NULL;
-			if (static_branch_unlikely(&tcp_md5_needed)) {
+			if (static_branch_unlikely(&tcp_md5_needed.key)) {
 				struct tcp_md5sig_key *key;
 
 				key = tp->af_specific->md5_lookup(sk, sk);
 				if (key) {
 					tcptw->tw_md5_key = kmemdup(key, sizeof(*key), GFP_ATOMIC);
-					BUG_ON(tcptw->tw_md5_key && !tcp_alloc_md5sig_pool());
+					if (!tcptw->tw_md5_key)
+						break;
+					BUG_ON(!tcp_alloc_md5sig_pool());
+					if (!static_key_fast_inc_not_negative(&tcp_md5_needed.key.key)) {
+						kfree(tcptw->tw_md5_key);
+						tcptw->tw_md5_key = NULL;
+					}
 				}
 			}
 		} while (0);
@@ -337,11 +343,13 @@ EXPORT_SYMBOL(tcp_time_wait);
 void tcp_twsk_destructor(struct sock *sk)
 {
 #ifdef CONFIG_TCP_MD5SIG
-	if (static_branch_unlikely(&tcp_md5_needed)) {
+	if (static_branch_unlikely(&tcp_md5_needed.key)) {
 		struct tcp_timewait_sock *twsk = tcp_twsk(sk);
 
-		if (twsk->tw_md5_key)
+		if (twsk->tw_md5_key) {
 			kfree_rcu(twsk->tw_md5_key, rcu);
+			static_branch_slow_dec_deferred(&tcp_md5_needed);
+		}
 	}
 #endif
 }
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 894410dc9293..71d01cf3c13e 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -766,7 +766,7 @@ static unsigned int tcp_syn_options(struct sock *sk, struct sk_buff *skb,
 
 	*md5 = NULL;
 #ifdef CONFIG_TCP_MD5SIG
-	if (static_branch_unlikely(&tcp_md5_needed) &&
+	if (static_branch_unlikely(&tcp_md5_needed.key) &&
 	    rcu_access_pointer(tp->md5sig_info)) {
 		*md5 = tp->af_specific->md5_lookup(sk, sk);
 		if (*md5) {
@@ -922,7 +922,7 @@ static unsigned int tcp_established_options(struct sock *sk, struct sk_buff *skb
 
 	*md5 = NULL;
 #ifdef CONFIG_TCP_MD5SIG
-	if (static_branch_unlikely(&tcp_md5_needed) &&
+	if (static_branch_unlikely(&tcp_md5_needed.key) &&
 	    rcu_access_pointer(tp->md5sig_info)) {
 		*md5 = tp->af_specific->md5_lookup(sk, sk);
 		if (*md5) {
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index f676be14e6b6..83304d6a6bd0 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -677,12 +677,11 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 	if (ipv6_addr_v4mapped(&sin6->sin6_addr))
 		return tcp_md5_do_add(sk, (union tcp_md5_addr *)&sin6->sin6_addr.s6_addr32[3],
 				      AF_INET, prefixlen, l3index, flags,
-				      cmd.tcpm_key, cmd.tcpm_keylen,
-				      GFP_KERNEL);
+				      cmd.tcpm_key, cmd.tcpm_keylen);
 
 	return tcp_md5_do_add(sk, (union tcp_md5_addr *)&sin6->sin6_addr,
 			      AF_INET6, prefixlen, l3index, flags,
-			      cmd.tcpm_key, cmd.tcpm_keylen, GFP_KERNEL);
+			      cmd.tcpm_key, cmd.tcpm_keylen);
 }
 
 static int tcp_v6_md5_hash_headers(struct tcp_md5sig_pool *hp,
@@ -1382,9 +1381,8 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 		 * memory, then we end up not copying the key
 		 * across. Shucks.
 		 */
-		tcp_md5_do_add(newsk, (union tcp_md5_addr *)&newsk->sk_v6_daddr,
-			       AF_INET6, 128, l3index, key->flags, key->key, key->keylen,
-			       sk_gfp_mask(sk, GFP_ATOMIC));
+		tcp_md5_key_copy(newsk, (union tcp_md5_addr *)&newsk->sk_v6_daddr,
+				 AF_INET6, 128, l3index, key);
 	}
 #endif
 
-- 
2.38.1

