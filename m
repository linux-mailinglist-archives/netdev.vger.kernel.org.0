Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77F366D538E
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 23:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbjDCVez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 17:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233212AbjDCVer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 17:34:47 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD4F40FB
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 14:34:34 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id e18so30775247wra.9
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 14:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1680557673;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kSSJCde0iXcKq4voXSbvcUOSRjc/mVd6SC1gLCTHSAs=;
        b=Lre2CZPIa8tqmNgZ79CNGiIdsqyA+rMeftg6Qq4FurVfWZkNMeOxycCWHBzD0nuOzY
         /qVdhlc4YqSism9CEBoVZFYj12LfwVBxTnHNlMGjAyZOysjW3oiK388B7FvQXzNnPHnM
         cqXUDD6ibylp0U1+z0/I9AaK5uXaDvElcJKyRFP5rexP6yapMefQlbqI489eiM57Girn
         8BjrlZI6un9l/XvOHk5/IAK3/g2vgdV2gODTCdF27vwFWU1XEHpdJa5TQyx6MQ56V/9a
         TTxJz0eMrSbqvDJABcfTBNQ5nwoEoNVfWuEWDPwfeusFBULudh4kYBG2CFuPmClmi1s/
         MDqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680557673;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kSSJCde0iXcKq4voXSbvcUOSRjc/mVd6SC1gLCTHSAs=;
        b=LYOq897Rs0zfuZliJTR31+nuNIssRyHnKYRgOdyN4ddZKWTUX2lsUtsf2EMo6Uh+Qp
         Ff6JDLr/UaIStg0/69oX7tnWfHhQLIe394J2yL/2brBuzbf+3hnkwTmTBpvHSFpY+FBv
         OL/1qdKQ3neWflhSlB93W2TlzxEZq9yh+UFXzaaQKNsDR/uvxClk9r3nRbYaIQ+oJdUb
         LYCzLwKr/eR5S2uAlwvx9ZpFFdsZTJXqZaWon27zOcJJKb4gLOC7R0xpKZdvSD7P9FAm
         c8YBZRpcz013k/lsS3jzyaDjXW7XQ647RlhRN8GQehOrz6SBdRuZFRjGD7UQHIQ21FLG
         Ax/Q==
X-Gm-Message-State: AAQBX9elNLFvDecYR3mmNGQhOsP9bBd07sltcXBCXOvYgM22ZAdANjGo
        o06w/tmZXiMc8odxnR5NAZDXiw==
X-Google-Smtp-Source: AKy350aymwiKbipnHZswznBxieIlU3o/NnbzQwTxqKM53gmKuzZrSYjTToUZS7PgSRt9DiAjzsD73g==
X-Received: by 2002:a5d:4a0f:0:b0:2d3:bfcc:1b11 with SMTP id m15-20020a5d4a0f000000b002d3bfcc1b11mr2791114wrq.42.1680557672958;
        Mon, 03 Apr 2023 14:34:32 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id o5-20020a5d4a85000000b002c3f9404c45sm10682740wrq.7.2023.04.03.14.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 14:34:32 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <error27@gmail.com>,
        David Laight <David.Laight@aculab.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri05@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Leonard Crestez <cdleonard@gmail.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, Francesco Ruggeri <fruggeri@arista.com>
Subject: [PATCH v5 04/21] net/tcp: Prevent TCP-MD5 with TCP-AO being set
Date:   Mon,  3 Apr 2023 22:34:03 +0100
Message-Id: <20230403213420.1576559-5-dima@arista.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403213420.1576559-1-dima@arista.com>
References: <20230403213420.1576559-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Be as conservative as possible: if there is TCP-MD5 key for a given peer
regardless of L3 interface - don't allow setting TCP-AO key for the same
peer. According to RFC5925, TCP-AO is supposed to replace TCP-MD5 and
there can't be any switch between both on any connected tuple.
Later it can be relaxed, if there's a use, but in the beginning restrict
any intersection.

Note: it's still should be possible to set both TCP-MD5 and TCP-AO keys
on a listening socket for *different* peers.

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp.h     | 44 ++++++++++++++++++++++++++++++++++++++--
 include/net/tcp_ao.h  | 15 ++++++++++++++
 net/ipv4/tcp_ao.c     | 40 ++++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_ipv4.c   | 14 ++++++++++---
 net/ipv4/tcp_output.c | 47 +++++++++++++++++++++++++++++++++++++++++++
 net/ipv6/tcp_ao.c     | 18 +++++++++++++++++
 net/ipv6/tcp_ipv6.c   | 26 ++++++++++++++++++++----
 7 files changed, 195 insertions(+), 9 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 4846de329045..fe3c0366db56 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1704,6 +1704,7 @@ int tcp_md5_key_copy(struct sock *sk, const union tcp_md5_addr *addr,
 
 int tcp_md5_do_del(struct sock *sk, const union tcp_md5_addr *addr,
 		   int family, u8 prefixlen, int l3index, u8 flags);
+void tcp_clear_md5_list(struct sock *sk);
 struct tcp_md5sig_key *tcp_v4_md5_lookup(const struct sock *sk,
 					 const struct sock *addr_sk);
 
@@ -1712,14 +1713,23 @@ struct tcp_md5sig_key *tcp_v4_md5_lookup(const struct sock *sk,
 extern struct static_key_false_deferred tcp_md5_needed;
 struct tcp_md5sig_key *__tcp_md5_do_lookup(const struct sock *sk, int l3index,
 					   const union tcp_md5_addr *addr,
-					   int family);
+					   int family, bool any_l3index);
 static inline struct tcp_md5sig_key *
 tcp_md5_do_lookup(const struct sock *sk, int l3index,
 		  const union tcp_md5_addr *addr, int family)
 {
 	if (!static_branch_unlikely(&tcp_md5_needed.key))
 		return NULL;
-	return __tcp_md5_do_lookup(sk, l3index, addr, family);
+	return __tcp_md5_do_lookup(sk, l3index, addr, family, false);
+}
+
+static inline struct tcp_md5sig_key *
+tcp_md5_do_lookup_any_l3index(const struct sock *sk,
+			      const union tcp_md5_addr *addr, int family)
+{
+	if (!static_branch_unlikely(&tcp_md5_needed.key))
+		return NULL;
+	return __tcp_md5_do_lookup(sk, 0, addr, family, true);
 }
 
 enum skb_drop_reason
@@ -1737,6 +1747,13 @@ tcp_md5_do_lookup(const struct sock *sk, int l3index,
 	return NULL;
 }
 
+static inline struct tcp_md5sig_key *
+tcp_md5_do_lookup_any_l3index(const struct sock *sk,
+			      const union tcp_md5_addr *addr, int family)
+{
+	return NULL;
+}
+
 static inline enum skb_drop_reason
 tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 		     const void *saddr, const void *daddr,
@@ -2098,6 +2115,9 @@ struct tcp_sock_af_ops {
 					    int optname,
 					    sockptr_t optval,
 					    int optlen);
+	struct tcp_ao_key	*(*ao_lookup)(const struct sock *sk,
+					      struct sock  *addr_sk,
+					      int sndid, int rcvid);
 #endif
 };
 
@@ -2502,4 +2522,24 @@ static inline u64 tcp_transmit_time(const struct sock *sk)
 	return 0;
 }
 
+
+static inline bool tcp_ao_required(struct sock *sk, const void *saddr,
+				   int family)
+{
+#ifdef CONFIG_TCP_AO
+	struct tcp_ao_info *ao_info;
+	struct tcp_ao_key *ao_key;
+
+	ao_info = rcu_dereference_check(tcp_sk(sk)->ao_info,
+					lockdep_sock_is_held(sk));
+	if (!ao_info)
+		return false;
+
+	ao_key = tcp_ao_do_lookup(sk, saddr, family, -1, -1, 0);
+	if (ao_info->ao_required || ao_key)
+		return true;
+#endif
+	return false;
+}
+
 #endif	/* _TCP_H */
diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index 916df79450e0..73f584b499f6 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -98,12 +98,27 @@ struct tcp_ao_info {
 int tcp_parse_ao(struct sock *sk, int cmd, unsigned short int family,
 		 sockptr_t optval, int optlen);
 void tcp_ao_destroy_sock(struct sock *sk);
+struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
+				    const union tcp_ao_addr *addr,
+				    int family, int sndid, int rcvid, u16 port);
 /* ipv4 specific functions */
 int tcp_v4_parse_ao(struct sock *sk, int optname, sockptr_t optval, int optlen);
+struct tcp_ao_key *tcp_v4_ao_lookup(const struct sock *sk, struct sock *addr_sk,
+				    int sndid, int rcvid);
 /* ipv6 specific functions */
+struct tcp_ao_key *tcp_v6_ao_lookup(const struct sock *sk,
+				    struct sock *addr_sk,
+				    int sndid, int rcvid);
 int tcp_v6_parse_ao(struct sock *sk, int cmd,
 		    sockptr_t optval, int optlen);
 #else
+static inline struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
+		const union tcp_ao_addr *addr,
+		int family, int sndid, int rcvid, u16 port)
+{
+	return NULL;
+}
+
 static inline void tcp_ao_destroy_sock(struct sock *sk)
 {
 }
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index 4e311885dbe1..f12937436377 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -172,6 +172,14 @@ void tcp_ao_destroy_sock(struct sock *sk)
 	kfree_rcu(ao, rcu);
 }
 
+struct tcp_ao_key *tcp_v4_ao_lookup(const struct sock *sk, struct sock *addr_sk,
+				    int sndid, int rcvid)
+{
+	union tcp_ao_addr *addr = (union tcp_ao_addr *)&addr_sk->sk_daddr;
+
+	return tcp_ao_do_lookup(sk, addr, AF_INET, sndid, rcvid, 0);
+}
+
 static bool tcp_ao_can_set_current_rnext(struct sock *sk)
 {
 	struct tcp_ao_info *ao_info;
@@ -486,6 +494,10 @@ static int tcp_ao_add_cmd(struct sock *sk, unsigned short int family,
 			return -EINVAL;
 	}
 
+	/* Don't allow keys for peers that have a matching TCP-MD5 key */
+	if (tcp_md5_do_lookup_any_l3index(sk, addr, family))
+		return -EKEYREJECTED;
+
 	ao_info = rcu_dereference_protected(tcp_sk(sk)->ao_info,
 					    lockdep_sock_is_held(sk));
 
@@ -682,6 +694,31 @@ static int tcp_ao_del_cmd(struct sock *sk, unsigned short int family,
 	return -ENOENT;
 }
 
+/* cmd.ao_required makes a socket TCP-AO only.
+ * Don't allow any md5 keys for any l3intf on the socket together with it.
+ * Restricting it early in setsockopt() removes a check for
+ * ao_info->ao_required on inbound tcp segment fast-path.
+ */
+static inline int tcp_ao_required_verify(struct sock *sk)
+{
+#ifdef CONFIG_TCP_MD5SIG
+	const struct tcp_md5sig_info *md5sig;
+
+	if (!static_branch_unlikely(&tcp_md5_needed.key))
+		return 0;
+
+	md5sig = rcu_dereference_check(tcp_sk(sk)->md5sig_info,
+				       lockdep_sock_is_held(sk));
+	if (!md5sig)
+		return 0;
+
+	if (rcu_dereference_check(hlist_first_rcu(&md5sig->head),
+				  lockdep_sock_is_held(sk)))
+		return 1;
+#endif
+	return 0;
+}
+
 static int tcp_ao_info_cmd(struct sock *sk, unsigned short int family,
 			   sockptr_t optval, int optlen)
 {
@@ -715,6 +752,9 @@ static int tcp_ao_info_cmd(struct sock *sk, unsigned short int family,
 		first = true;
 	}
 
+	if (cmd.ao_required && tcp_ao_required_verify(sk))
+		return -EKEYREJECTED;
+
 	/* For sockets in TCP_CLOSED it's possible set keys that aren't
 	 * matching the future peer (address/port/VRF/etc),
 	 * tcp_ao_connect_init() will choose a correct matching MKT
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 17c2504c6b14..e40baf3e8e29 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1073,7 +1073,7 @@ static bool better_md5_match(struct tcp_md5sig_key *old, struct tcp_md5sig_key *
 /* Find the Key structure for an address.  */
 struct tcp_md5sig_key *__tcp_md5_do_lookup(const struct sock *sk, int l3index,
 					   const union tcp_md5_addr *addr,
-					   int family)
+					   int family, bool any_l3index)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_md5sig_key *key;
@@ -1092,7 +1092,8 @@ struct tcp_md5sig_key *__tcp_md5_do_lookup(const struct sock *sk, int l3index,
 				 lockdep_sock_is_held(sk)) {
 		if (key->family != family)
 			continue;
-		if (key->flags & TCP_MD5SIG_FLAG_IFINDEX && key->l3index != l3index)
+		if (!any_l3index && key->flags & TCP_MD5SIG_FLAG_IFINDEX &&
+		    key->l3index != l3index)
 			continue;
 		if (family == AF_INET) {
 			mask = inet_make_mask(key->prefixlen);
@@ -1304,7 +1305,7 @@ int tcp_md5_do_del(struct sock *sk, const union tcp_md5_addr *addr, int family,
 }
 EXPORT_SYMBOL(tcp_md5_do_del);
 
-static void tcp_clear_md5_list(struct sock *sk)
+void tcp_clear_md5_list(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_md5sig_key *key;
@@ -1374,6 +1375,12 @@ static int tcp_v4_parse_md5_keys(struct sock *sk, int optname,
 	if (cmd.tcpm_keylen > TCP_MD5SIG_MAXKEYLEN)
 		return -EINVAL;
 
+	/* Don't allow keys for peers that have a matching TCP-AO key.
+	 * See the comment in tcp_ao_add_cmd()
+	 */
+	if (tcp_ao_required(sk, addr, AF_INET))
+		return -EKEYREJECTED;
+
 	return tcp_md5_do_add(sk, addr, AF_INET, prefixlen, l3index, flags,
 			      cmd.tcpm_key, cmd.tcpm_keylen);
 }
@@ -2269,6 +2276,7 @@ static const struct tcp_sock_af_ops tcp_sock_ipv4_specific = {
 	.md5_parse		= tcp_v4_parse_md5_keys,
 #endif
 #ifdef CONFIG_TCP_AO
+	.ao_lookup		= tcp_v4_ao_lookup,
 	.ao_parse		= tcp_v4_parse_ao,
 #endif
 };
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index ba839e441450..9977e58a5587 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3839,6 +3839,53 @@ int tcp_connect(struct sock *sk)
 
 	tcp_call_bpf(sk, BPF_SOCK_OPS_TCP_CONNECT_CB, 0, NULL);
 
+#if defined(CONFIG_TCP_MD5SIG) && defined(CONFIG_TCP_AO)
+	/* Has to be checked late, after setting daddr/saddr/ops.
+	 * Return error if the peer has both a md5 and a tcp-ao key
+	 * configured as this is ambiguous.
+	 */
+	if (unlikely(rcu_dereference_protected(tp->md5sig_info,
+					       lockdep_sock_is_held(sk)))) {
+		bool needs_md5 = !!tp->af_specific->md5_lookup(sk, sk);
+		bool needs_ao = !!tp->af_specific->ao_lookup(sk, sk, -1, -1);
+		struct tcp_ao_info *ao_info;
+
+		ao_info = rcu_dereference_check(tp->ao_info,
+						lockdep_sock_is_held(sk));
+		if (ao_info) {
+			/* This is an extra check: tcp_ao_required() in
+			 * tcp_v{4,6}_parse_md5_keys() should prevent adding
+			 * md5 keys on ao_required socket.
+			 */
+			needs_ao |= ao_info->ao_required;
+			WARN_ON_ONCE(ao_info->ao_required && needs_md5);
+		}
+		if (needs_md5 && needs_ao)
+			return -EKEYREJECTED;
+
+		/* If we have a matching md5 key and no matching tcp-ao key
+		 * then free up ao_info if allocated.
+		 */
+		if (needs_md5) {
+			tcp_ao_destroy_sock(sk);
+		} else if (needs_ao) {
+			tcp_clear_md5_list(sk);
+			kfree(rcu_replace_pointer(tp->md5sig_info, NULL,
+						  lockdep_sock_is_held(sk)));
+		}
+	}
+#endif
+#ifdef CONFIG_TCP_AO
+	if (unlikely(rcu_dereference_protected(tp->ao_info,
+					       lockdep_sock_is_held(sk)))) {
+		/* Don't allow connecting if ao is configured but no
+		 * matching key is found.
+		 */
+		if (!tp->af_specific->ao_lookup(sk, sk, -1, -1))
+			return -EKEYREJECTED;
+	}
+#endif
+
 	if (inet_csk(sk)->icsk_af_ops->rebuild_header(sk))
 		return -EHOSTUNREACH; /* Routing failure or similar. */
 
diff --git a/net/ipv6/tcp_ao.c b/net/ipv6/tcp_ao.c
index d0aa6414b7d9..3d2be5f73cf0 100644
--- a/net/ipv6/tcp_ao.c
+++ b/net/ipv6/tcp_ao.c
@@ -12,6 +12,24 @@
 #include <net/tcp.h>
 #include <net/ipv6.h>
 
+struct tcp_ao_key *tcp_v6_ao_do_lookup(const struct sock *sk,
+				       const struct in6_addr *addr,
+				       int sndid, int rcvid)
+{
+	return tcp_ao_do_lookup(sk, (union tcp_ao_addr *)addr, AF_INET6,
+				sndid, rcvid, 0);
+}
+
+struct tcp_ao_key *tcp_v6_ao_lookup(const struct sock *sk,
+				    struct sock *addr_sk,
+				    int sndid, int rcvid)
+{
+	struct in6_addr *addr = &addr_sk->sk_v6_daddr;
+
+	return tcp_v6_ao_do_lookup(sk, addr, sndid, rcvid);
+}
+EXPORT_SYMBOL_GPL(tcp_v6_ao_lookup);
+
 int tcp_v6_parse_ao(struct sock *sk, int cmd,
 		    sockptr_t optval, int optlen)
 {
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index e49e76756090..93ee479814bb 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -602,6 +602,7 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 {
 	struct tcp_md5sig cmd;
 	struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *)&cmd.tcpm_addr;
+	union tcp_ao_addr *addr;
 	int l3index = 0;
 	u8 prefixlen;
 	u8 flags;
@@ -656,13 +657,28 @@ static int tcp_v6_parse_md5_keys(struct sock *sk, int optname,
 	if (cmd.tcpm_keylen > TCP_MD5SIG_MAXKEYLEN)
 		return -EINVAL;
 
-	if (ipv6_addr_v4mapped(&sin6->sin6_addr))
-		return tcp_md5_do_add(sk, (union tcp_md5_addr *)&sin6->sin6_addr.s6_addr32[3],
+	if (ipv6_addr_v4mapped(&sin6->sin6_addr)) {
+		addr = (union tcp_md5_addr *)&sin6->sin6_addr.s6_addr32[3];
+
+		/* Don't allow keys for peers that have a matching TCP-AO key.
+		 * See the comment in tcp_ao_add_cmd()
+		 */
+		if (tcp_ao_required(sk, addr, AF_INET))
+			return -EKEYREJECTED;
+		return tcp_md5_do_add(sk, addr,
 				      AF_INET, prefixlen, l3index, flags,
 				      cmd.tcpm_key, cmd.tcpm_keylen);
+	}
+
+	addr = (union tcp_md5_addr *)&sin6->sin6_addr;
+
+	/* Don't allow keys for peers that have a matching TCP-AO key.
+	 * See the comment in tcp_ao_add_cmd()
+	 */
+	if (tcp_ao_required(sk, addr, AF_INET6))
+		return -EKEYREJECTED;
 
-	return tcp_md5_do_add(sk, (union tcp_md5_addr *)&sin6->sin6_addr,
-			      AF_INET6, prefixlen, l3index, flags,
+	return tcp_md5_do_add(sk, addr, AF_INET6, prefixlen, l3index, flags,
 			      cmd.tcpm_key, cmd.tcpm_keylen);
 }
 
@@ -1900,6 +1916,7 @@ static const struct tcp_sock_af_ops tcp_sock_ipv6_specific = {
 	.md5_parse	=	tcp_v6_parse_md5_keys,
 #endif
 #ifdef CONFIG_TCP_AO
+	.ao_lookup	=	tcp_v6_ao_lookup,
 	.ao_parse	=	tcp_v6_parse_ao,
 #endif
 };
@@ -1931,6 +1948,7 @@ static const struct tcp_sock_af_ops tcp_sock_ipv6_mapped_specific = {
 	.md5_parse	=	tcp_v6_parse_md5_keys,
 #endif
 #ifdef CONFIG_TCP_AO
+	.ao_lookup	=	tcp_v6_ao_lookup,
 	.ao_parse	=	tcp_v6_parse_ao,
 #endif
 };
-- 
2.40.0

