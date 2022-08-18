Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F055989EE
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345335AbiHRRCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345430AbiHRRAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:00:47 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 677D6C991C
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:00:37 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id j7so2436941wrh.3
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=jymZs1bEQZV6mI0afAkvYGo5xW1dQ568muR+SHQcqCE=;
        b=R0yLXLKya+piZY1ZjoFgbmL0iUuotMQUYnfUJKbl1vkM8aToMfcw8vgcM1im51mgof
         eXHPaVSvUccoEsLFUljz4TUm+q8yuaL6SjqjINUcS4e356xcsFPN4/miAEhH3eccb8BH
         Q8n8Jc12qCXDL2i9rqtp4XYZD9EAlNcNdr5sFdzZLCD6B6PvrqTZxm5cYjHIm3UH+5bw
         EKMgZY7mvc2yYNpcatXLI74hwlozrDCTp0Lr3zoTpwtmBJFjsRMrGjG127+E1bkldDY3
         8ToIKipVQni9+9ptFwcU7i88TGC/jKv2boz0cBEpmSehrF/bdqZcwjha59bf3WGKmHmg
         1F3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=jymZs1bEQZV6mI0afAkvYGo5xW1dQ568muR+SHQcqCE=;
        b=1TXA6i9Nc/59BEPCdxHH7HqZgq0MxOWTD8XQ8A07kYG7WGHDquXckNNiVtckkJUiBw
         h1Pe9QxHuCrkUrmurxWru1hRdWmBYmEaSjUfuKPX4XMyaFyZMoqJa8EGs7A12XaWo29j
         vX/9X5T5qY8pqTdnBFLKu2B1N15SZ8VQlhfTLe5TNqk5w5rHY99AWDfMrXhKQWUwVdCk
         Ol7ShqRF6qh3dsHDFOgi1Fh1aGN4auE7lt9zxKlrOATApgR4cyhhy1Yppiq2T1HoScX2
         UDpO3Lzk9TenwVoA4/qhCGrXFYdETJ4G/Jlu4AIcbWJ/ugn2VupOeZouL7CmTp0fBZnd
         qOfQ==
X-Gm-Message-State: ACgBeo3Ql5jT/sZij/iQk4UqkLM8LsweJ6r4/pqY/JZRwHLlesOWDOnk
        ao+/aFGHqU07N5LNQTjtmSwvLg==
X-Google-Smtp-Source: AA6agR43pnvd6ejItYGU464pB53N4Y4ZOW7k7b5RosF61XWgm2T9f4IWEXtrBsgxLG/DGEA11EFHpQ==
X-Received: by 2002:a05:6000:178b:b0:222:c6c4:b42e with SMTP id e11-20020a056000178b00b00222c6c4b42emr2287328wrg.275.1660842035690;
        Thu, 18 Aug 2022 10:00:35 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id be13-20020a05600c1e8d00b003a511e92abcsm2662169wmb.34.2022.08.18.10.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 10:00:35 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH 15/31] net/tcp: Wire TCP-AO to request sockets
Date:   Thu, 18 Aug 2022 17:59:49 +0100
Message-Id: <20220818170005.747015-16-dima@arista.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220818170005.747015-1-dima@arista.com>
References: <20220818170005.747015-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now when the new request socket is created from the listening socket,
it's recorded what MKT was used by the peer. tcp_rsk_used_ao() is
a new helper for checking if TCP-AO option was used to create the
request socket.
tcp_ao_copy_all_matching() will copy all keys that match the peer on the
request socket, as well as preparing them for the usage (creating
traffic keys).

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/linux/tcp.h      |  18 +++++
 include/net/tcp.h        |   7 ++
 include/net/tcp_ao.h     |  16 +++++
 net/ipv4/tcp_ao.c        | 137 +++++++++++++++++++++++++++++++++++++++
 net/ipv4/tcp_input.c     |  19 +++++-
 net/ipv4/tcp_ipv4.c      |  63 ++++++++++++++++--
 net/ipv4/tcp_minisocks.c |  10 +++
 net/ipv4/tcp_output.c    |  13 +++-
 net/ipv6/tcp_ao.c        |  21 ++++++
 net/ipv6/tcp_ipv6.c      |  78 ++++++++++++++++++----
 10 files changed, 361 insertions(+), 21 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 8031995b58a2..0e0f07d12f7b 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -165,6 +165,11 @@ struct tcp_request_sock {
 						  * after data-in-SYN.
 						  */
 	u8				syn_tos;
+#ifdef CONFIG_TCP_AO
+	u8				ao_keyid;
+	u8				ao_rcv_next;
+	u8				maclen;
+#endif
 };
 
 static inline struct tcp_request_sock *tcp_rsk(const struct request_sock *req)
@@ -172,6 +177,19 @@ static inline struct tcp_request_sock *tcp_rsk(const struct request_sock *req)
 	return (struct tcp_request_sock *)req;
 }
 
+static inline bool tcp_rsk_used_ao(const struct request_sock *req)
+{
+	/* The real length of MAC is saved in the request socket,
+	 * signing anything with zero-length makes no sense, so here is
+	 * a little hack..
+	 */
+#ifndef CONFIG_TCP_AO
+	return false;
+#else
+	return tcp_rsk(req)->maclen != 0;
+#endif
+}
+
 struct tcp_sock {
 	/* inet_connection_sock has to be the first member of tcp_sock */
 	struct inet_connection_sock	inet_conn;
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 061fe8471bfc..f21898bb31bd 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -2103,6 +2103,13 @@ struct tcp_request_sock_ops {
 					  const struct sock *sk,
 					  const struct sk_buff *skb);
 #endif
+#ifdef CONFIG_TCP_AO
+	struct tcp_ao_key	*(*ao_lookup)(const struct sock *sk,
+					       struct request_sock *req,
+					       int sndid, int rcvid);
+	int			(*ao_calc_key)(struct tcp_ao_key *mkt, u8 *key,
+						struct request_sock *sk);
+#endif
 #ifdef CONFIG_SYN_COOKIES
 	__u32 (*cookie_init_seq)(const struct sk_buff *skb,
 				 __u16 *mss);
diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index af82b4aeef11..a1d26e1a0b82 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -119,6 +119,9 @@ int tcp_ao_hash_skb(unsigned short int family,
 int tcp_parse_ao(struct sock *sk, int cmd, unsigned short int family,
 		 sockptr_t optval, int optlen);
 struct tcp_ao_key *tcp_ao_do_lookup_sndid(const struct sock *sk, u8 keyid);
+int tcp_ao_copy_all_matching(const struct sock *sk, struct sock *newsk,
+			     struct request_sock *req, struct sk_buff *skb,
+			     int family);
 int tcp_ao_calc_traffic_key(struct tcp_ao_key *mkt, u8 *key, void *ctx,
 			    unsigned int len);
 void tcp_ao_destroy_sock(struct sock *sk, bool twsk);
@@ -142,6 +145,11 @@ struct tcp_ao_key *tcp_v4_ao_lookup(const struct sock *sk, struct sock *addr_sk,
 int tcp_v4_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
 			  const struct sock *sk,
 			  __be32 sisn, __be32 disn, bool send);
+int tcp_v4_ao_calc_key_rsk(struct tcp_ao_key *mkt, u8 *key,
+			   struct request_sock *req);
+struct tcp_ao_key *tcp_v4_ao_lookup_rsk(const struct sock *sk,
+					struct request_sock *req,
+					int sndid, int rcvid);
 int tcp_v4_ao_hash_skb(char *ao_hash, struct tcp_ao_key *key,
 		       const struct sock *sk, const struct sk_buff *skb,
 		       const u8 *tkey, int hash_offset, u32 sne);
@@ -152,9 +160,17 @@ int tcp_v6_ao_hash_pseudoheader(struct crypto_pool_ahash *hp,
 int tcp_v6_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
 				 const struct sock *sk, __be32 sisn,
 				 __be32 disn, bool send);
+int tcp_v6_ao_calc_key_rsk(struct tcp_ao_key *mkt, u8 *key,
+			   struct request_sock *req);
+struct tcp_ao_key *tcp_v6_ao_do_lookup(const struct sock *sk,
+				       const struct in6_addr *addr,
+				       int sndid, int rcvid);
 struct tcp_ao_key *tcp_v6_ao_lookup(const struct sock *sk,
 				    struct sock *addr_sk,
 				    int sndid, int rcvid);
+struct tcp_ao_key *tcp_v6_ao_lookup_rsk(const struct sock *sk,
+					struct request_sock *req,
+					int sndid, int rcvid);
 int tcp_v6_ao_hash_skb(char *ao_hash, struct tcp_ao_key *key,
 		       const struct sock *sk, const struct sk_buff *skb,
 		       const u8 *tkey, int hash_offset, u32 sne);
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index 528b6650c72c..a797eedfbcdf 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -52,6 +52,21 @@ int tcp_ao_calc_traffic_key(struct tcp_ao_key *mkt, u8 *key, void *ctx,
 	return 1;
 }
 
+struct tcp_ao_key *tcp_ao_do_lookup_keyid(struct tcp_ao_info *ao,
+					  int sndid, int rcvid)
+{
+	struct tcp_ao_key *key;
+
+	hlist_for_each_entry_rcu(key, &ao->head, node) {
+		if ((sndid >= 0 && key->sndid != sndid) ||
+		    (rcvid >= 0 && key->rcvid != rcvid))
+			continue;
+		return key;
+	}
+
+	return NULL;
+}
+
 struct tcp_ao_key *tcp_ao_do_lookup_rcvid(struct sock *sk, u8 keyid)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
@@ -189,6 +204,22 @@ void tcp_ao_link_mkt(struct tcp_ao_info *ao, struct tcp_ao_key *mkt)
 	hlist_add_head_rcu(&mkt->node, &ao->head);
 }
 
+struct tcp_ao_key *tcp_ao_copy_key(struct sock *sk, struct tcp_ao_key *key)
+{
+	struct tcp_ao_key *new_key;
+
+	new_key = sock_kmalloc(sk, tcp_ao_sizeof_key(key),
+			       GFP_ATOMIC);
+	if (!new_key)
+		return NULL;
+
+	*new_key = *key;
+	INIT_HLIST_NODE(&new_key->node);
+	crypto_pool_add(new_key->crypto_pool_id);
+
+	return new_key;
+}
+
 static void tcp_ao_key_free_rcu(struct rcu_head *head)
 {
 	struct tcp_ao_key *key = container_of(head, struct tcp_ao_key, rcu);
@@ -286,6 +317,18 @@ int tcp_v4_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
 					  htons(sk->sk_num), disn, sisn);
 }
 
+int tcp_v4_ao_calc_key_rsk(struct tcp_ao_key *mkt, u8 *key,
+			   struct request_sock *req)
+{
+	struct inet_request_sock *ireq = inet_rsk(req);
+
+	return tcp_v4_ao_calc_key(mkt, key,
+				  ireq->ir_loc_addr, ireq->ir_rmt_addr,
+				  htons(ireq->ir_num), ireq->ir_rmt_port,
+				  htonl(tcp_rsk(req)->snt_isn),
+				  htonl(tcp_rsk(req)->rcv_isn));
+}
+
 static int tcp_v4_ao_hash_pseudoheader(struct crypto_pool_ahash *hp,
 				       __be32 daddr, __be32 saddr,
 				       int nbytes)
@@ -543,6 +586,16 @@ int tcp_v4_ao_hash_skb(char *ao_hash, struct tcp_ao_key *key,
 			       tkey, hash_offset, sne);
 }
 
+struct tcp_ao_key *tcp_v4_ao_lookup_rsk(const struct sock *sk,
+					struct request_sock *req,
+					int sndid, int rcvid)
+{
+	union tcp_ao_addr *addr =
+			(union tcp_ao_addr *)&inet_rsk(req)->ir_rmt_addr;
+
+	return tcp_ao_do_lookup(sk, addr, AF_INET, sndid, rcvid, 0);
+}
+
 struct tcp_ao_key *tcp_v4_ao_lookup(const struct sock *sk, struct sock *addr_sk,
 				    int sndid, int rcvid)
 {
@@ -644,6 +697,90 @@ void tcp_ao_finish_connect(struct sock *sk, struct sk_buff *skb)
 	}
 }
 
+int tcp_ao_copy_all_matching(const struct sock *sk, struct sock *newsk,
+			     struct request_sock *req, struct sk_buff *skb,
+			     int family)
+{
+	struct tcp_ao_info *ao;
+	struct tcp_ao_info *new_ao;
+	struct tcp_ao_key *key, *new_key, *first_key;
+	struct hlist_node *n;
+	union tcp_ao_addr *addr;
+	bool match = false;
+
+	ao = rcu_dereference(tcp_sk(sk)->ao_info);
+	if (!ao)
+		return 0;
+
+	/* New socket without TCP-AO on it */
+	if (!tcp_rsk_used_ao(req))
+		return 0;
+
+	new_ao = tcp_ao_alloc_info(GFP_ATOMIC, ao);
+	if (!new_ao)
+		return -ENOMEM;
+	new_ao->lisn = htonl(tcp_rsk(req)->snt_isn);
+	new_ao->risn = htonl(tcp_rsk(req)->rcv_isn);
+
+	if (family == AF_INET)
+		addr = (union tcp_ao_addr *)&newsk->sk_daddr;
+	else
+		addr = (union tcp_ao_addr *)&newsk->sk_v6_daddr;
+
+	hlist_for_each_entry_rcu(key, &ao->head, node) {
+		if (tcp_ao_key_cmp(key, addr, key->prefixlen, family,
+				   -1, -1, 0))
+			continue;
+
+		new_key = tcp_ao_copy_key(newsk, key);
+		if (!new_key)
+			goto free_and_exit;
+
+		tcp_ao_cache_traffic_keys(newsk, new_ao, new_key);
+		tcp_ao_link_mkt(new_ao, new_key);
+		match = true;
+	}
+
+	if (match) {
+		struct hlist_node *key_head;
+
+		key_head = rcu_dereference(hlist_first_rcu(&new_ao->head));
+		first_key = hlist_entry_safe(key_head, struct tcp_ao_key, node);
+
+		/* set current_key */
+		key = tcp_ao_do_lookup_keyid(new_ao, tcp_rsk(req)->ao_keyid, -1);
+		if (key)
+			new_ao->current_key = key;
+		else
+			new_ao->current_key = first_key;
+
+		/* set rnext_key */
+		key = tcp_ao_do_lookup_keyid(new_ao, -1, tcp_rsk(req)->ao_rcv_next);
+		if (key)
+			new_ao->rnext_key = key;
+		else
+			new_ao->rnext_key = first_key;
+
+		new_ao->snd_sne_seq = tcp_rsk(req)->snt_isn;
+		new_ao->rcv_sne_seq = tcp_rsk(req)->rcv_isn;
+
+		sk_gso_disable(newsk);
+		rcu_assign_pointer(tcp_sk(newsk)->ao_info, new_ao);
+	}
+
+	return 0;
+
+free_and_exit:
+	hlist_for_each_entry_safe(key, n, &new_ao->head, node) {
+		hlist_del(&key->node);
+		crypto_pool_release(key->crypto_pool_id);
+		atomic_sub(tcp_ao_sizeof_key(key), &newsk->sk_omem_alloc);
+		kfree(key);
+	}
+	kfree(new_ao);
+	return -ENOMEM;
+}
+
 static int tcp_ao_current_rnext(struct sock *sk, u16 tcpa_flags,
 				u8 tcpa_sndid, u8 tcpa_rcvid)
 {
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 27e95876cba1..b8175ded8a70 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6921,6 +6921,14 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 	struct dst_entry *dst;
 	struct flowi fl;
 	u8 syncookies;
+	const struct tcp_ao_hdr *aoh = NULL;
+
+#ifdef CONFIG_TCP_AO
+	/* TODO: Add an option to require TCP-AO signature */
+	/* Packet was already validated in tcp_v[46]_rcv */
+	if (tcp_parse_auth_options(tcp_hdr(skb), NULL, &aoh))
+		goto drop; /* Invalid TCP options */
+#endif
 
 	syncookies = READ_ONCE(net->ipv4.sysctl_tcp_syncookies);
 
@@ -6928,7 +6936,7 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 	 * limitations, they conserve resources and peer is
 	 * evidently real one.
 	 */
-	if ((syncookies == 2 || inet_csk_reqsk_queue_is_full(sk)) && !isn) {
+	if (!aoh && (syncookies == 2 || inet_csk_reqsk_queue_is_full(sk)) && !isn) {
 		want_cookie = tcp_syn_flood_action(sk, rsk_ops->slab_name);
 		if (!want_cookie)
 			goto drop;
@@ -7007,6 +7015,15 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 			inet_rsk(req)->ecn_ok = 0;
 	}
 
+#ifdef CONFIG_TCP_AO
+	if (aoh) {
+		tcp_rsk(req)->maclen = aoh->length - sizeof(struct tcp_ao_hdr);
+		tcp_rsk(req)->ao_rcv_next = aoh->keyid;
+		tcp_rsk(req)->ao_keyid = aoh->rnext_keyid;
+	} else {
+		tcp_rsk(req)->maclen = 0;
+	}
+#endif
 	tcp_rsk(req)->snt_isn = isn;
 	tcp_rsk(req)->txhash = net_tx_rndhash();
 	tcp_rsk(req)->syn_tos = TCP_SKB_CB(skb)->ip_dsfield;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 003c5f320bfc..55c763b8bf24 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1064,30 +1064,73 @@ static void tcp_v4_timewait_ack(struct sock *sk, struct sk_buff *skb)
 static void tcp_v4_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 				  struct request_sock *req)
 {
+	struct tcp_md5sig_key *md5_key = NULL;
+	struct tcp_ao_key *ao_key = NULL;
 	const union tcp_md5_addr *addr;
-	int l3index;
+	u8 keyid = 0;
+#ifdef CONFIG_TCP_AO
+	u8 traffic_key[TCP_AO_MAX_HASH_SIZE] __tcp_ao_key_align;
+	const struct tcp_ao_hdr *aoh;
+#else
+	u8 *traffic_key = NULL;
+#endif
 
 	/* sk->sk_state == TCP_LISTEN -> for regular TCP_SYN_RECV
 	 * sk->sk_state == TCP_SYN_RECV -> for Fast Open.
 	 */
 	u32 seq = (sk->sk_state == TCP_LISTEN) ? tcp_rsk(req)->snt_isn + 1 :
 					     tcp_sk(sk)->snd_nxt;
+	addr = (union tcp_md5_addr *)&ip_hdr(skb)->saddr;
+
+	if (tcp_rsk_used_ao(req)) {
+#ifdef CONFIG_TCP_AO
+		/* Invalid TCP option size or twice included auth */
+		if (tcp_parse_auth_options(tcp_hdr(skb), NULL, &aoh))
+			return;
+
+		if (!aoh)
+			return;
+
+		ao_key = tcp_ao_do_lookup(sk, addr, AF_INET,
+					  aoh->rnext_keyid, -1, 0);
+		if (unlikely(!ao_key)) {
+			/* Send ACK with any matching MKT for the peer */
+			ao_key = tcp_ao_do_lookup(sk, addr,
+						  AF_INET, -1, -1, 0);
+			/* Matching key disappeared (user removed the key?)
+			 * let the handshake timeout.
+			 */
+			if (!ao_key) {
+				net_info_ratelimited("TCP-AO key for (%pI4, %d)->(%pI4, %d) suddenly disappeared, won't ACK new connection\n",
+						addr,
+						ntohs(tcp_hdr(skb)->source),
+						&ip_hdr(skb)->daddr,
+						ntohs(tcp_hdr(skb)->dest));
+				return;
+			}
+		}
 
+		keyid = aoh->keyid;
+		tcp_v4_ao_calc_key_rsk(ao_key, traffic_key, req);
+#endif
+	} else {
+		int l3index;
+
+		l3index = tcp_v4_sdif(skb) ? inet_iif(skb) : 0;
+		md5_key = tcp_md5_do_lookup(sk, l3index, addr, AF_INET);
+	}
 	/* RFC 7323 2.3
 	 * The window field (SEG.WND) of every outgoing segment, with the
 	 * exception of <SYN> segments, MUST be right-shifted by
 	 * Rcv.Wind.Shift bits:
 	 */
-	addr = (union tcp_md5_addr *)&ip_hdr(skb)->saddr;
-	l3index = tcp_v4_sdif(skb) ? inet_iif(skb) : 0;
 	tcp_v4_send_ack(sk, skb, seq,
 			tcp_rsk(req)->rcv_nxt,
 			req->rsk_rcv_wnd >> inet_rsk(req)->rcv_wscale,
 			tcp_time_stamp_raw() + tcp_rsk(req)->ts_off,
 			req->ts_recent,
 			0,
-			tcp_md5_do_lookup(sk, l3index, addr, AF_INET),
-			NULL, NULL, 0, 0,
+			md5_key, ao_key, traffic_key, keyid, 0,
 			inet_rsk(req)->no_srccheck ? IP_REPLY_ARG_NOSRCCHECK : 0,
 			ip_hdr(skb)->tos);
 }
@@ -1603,6 +1646,10 @@ const struct tcp_request_sock_ops tcp_request_sock_ipv4_ops = {
 	.req_md5_lookup	=	tcp_v4_md5_lookup,
 	.calc_md5_hash	=	tcp_v4_md5_hash_skb,
 #endif
+#ifdef CONFIG_TCP_AO
+	.ao_lookup	=	tcp_v4_ao_lookup_rsk,
+	.ao_calc_key	=	tcp_v4_ao_calc_key_rsk,
+#endif
 #ifdef CONFIG_SYN_COOKIES
 	.cookie_init_seq =	cookie_v4_init_sequence,
 #endif
@@ -1704,7 +1751,7 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 	/* Copy over the MD5 key from the original socket */
 	addr = (union tcp_md5_addr *)&newinet->inet_daddr;
 	key = tcp_md5_do_lookup(sk, l3index, addr, AF_INET);
-	if (key) {
+	if (key && !tcp_rsk_used_ao(req)) {
 		/*
 		 * We're using one, so create a matching key
 		 * on the newsk structure. If we fail to get
@@ -1715,6 +1762,10 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 		sk_gso_disable(newsk);
 	}
 #endif
+#ifdef CONFIG_TCP_AO
+	if (tcp_ao_copy_all_matching(sk, newsk, req, skb, AF_INET))
+		goto put_and_exit; /* OOM, release back memory */
+#endif
 
 	if (__inet_inherit_port(sk, newsk) < 0)
 		goto put_and_exit;
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 94012a015bd0..03f1b809866b 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -473,6 +473,9 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
 	struct inet_connection_sock *newicsk;
 	struct tcp_sock *oldtp, *newtp;
 	u32 seq;
+#ifdef CONFIG_TCP_AO
+	struct tcp_ao_key *ao_key;
+#endif
 
 	if (!newsk)
 		return NULL;
@@ -551,6 +554,13 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
 	if (treq->af_specific->req_md5_lookup(sk, req_to_sk(req)))
 		newtp->tcp_header_len += TCPOLEN_MD5SIG_ALIGNED;
 #endif
+#ifdef CONFIG_TCP_AO
+	newtp->ao_info = NULL;
+	ao_key = treq->af_specific->ao_lookup(sk, req,
+				tcp_rsk(req)->ao_keyid, -1);
+	if (ao_key)
+		newtp->tcp_header_len += tcp_ao_len(ao_key);
+ #endif
 	if (skb->len >= TCP_MSS_DEFAULT + newtp->tcp_header_len)
 		newicsk->icsk_ack.last_seg_size = skb->len - newtp->tcp_header_len;
 	newtp->rx_opt.mss_clamp = req->mss;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 26315cac09dd..81f897f95147 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -606,6 +606,7 @@ static void bpf_skops_write_hdr_opt(struct sock *sk, struct sk_buff *skb,
  * (but it may well be that other scenarios fail similarly).
  */
 static void tcp_options_write(struct tcphdr *th, struct tcp_sock *tp,
+			      const struct tcp_request_sock *tcprsk,
 			      struct tcp_out_options *opts,
 			      struct tcp_ao_key *ao_key)
 {
@@ -636,6 +637,14 @@ static void tcp_options_write(struct tcphdr *th, struct tcp_sock *tp,
 				       (ao_key->sndid << 8) |
 				       (ao_info->rnext_key->rcvid));
 		}
+		if (tcprsk) {
+			u8 aolen = tcprsk->maclen + sizeof(struct tcp_ao_hdr);
+
+			maclen = tcprsk->maclen;
+			*ptr++ = htonl((TCPOPT_AO << 24) | (aolen << 16) |
+				       (tcprsk->ao_keyid << 8) |
+				       (tcprsk->ao_rcv_next));
+		}
 		opts->hash_location = (__u8 *)ptr;
 		ptr += maclen / sizeof(*ptr);
 		if (unlikely(maclen % sizeof(*ptr))) {
@@ -1414,7 +1423,7 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 		th->window	= htons(min(tp->rcv_wnd, 65535U));
 	}
 
-	tcp_options_write(th, tp, &opts, ao_key);
+	tcp_options_write(th, tp, NULL, &opts, ao_key);
 
 #ifdef CONFIG_TCP_MD5SIG
 	/* Calculate the MD5 hash, as we have all we need now */
@@ -3700,7 +3709,7 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 
 	/* RFC1323: The window in SYN & SYN/ACK segments is never scaled. */
 	th->window = htons(min(req->rsk_rcv_wnd, 65535U));
-	tcp_options_write(th, NULL, &opts, NULL);
+	tcp_options_write(th, NULL, NULL, &opts, NULL);
 	th->doff = (tcp_header_size >> 2);
 	__TCP_INC_STATS(sock_net(sk), TCP_MIB_OUTSEGS);
 
diff --git a/net/ipv6/tcp_ao.c b/net/ipv6/tcp_ao.c
index 7fd31c60488a..31ae504af8e6 100644
--- a/net/ipv6/tcp_ao.c
+++ b/net/ipv6/tcp_ao.c
@@ -53,6 +53,18 @@ int tcp_v6_ao_calc_key_sk(struct tcp_ao_key *mkt, u8 *key,
 					  htons(sk->sk_num), disn, sisn);
 }
 
+int tcp_v6_ao_calc_key_rsk(struct tcp_ao_key *mkt, u8 *key,
+			   struct request_sock *req)
+{
+	struct inet_request_sock *ireq = inet_rsk(req);
+
+	return tcp_v6_ao_calc_key(mkt, key,
+			&ireq->ir_v6_loc_addr, &ireq->ir_v6_rmt_addr,
+			htons(ireq->ir_num), ireq->ir_rmt_port,
+			htonl(tcp_rsk(req)->snt_isn),
+			htonl(tcp_rsk(req)->rcv_isn));
+}
+
 struct tcp_ao_key *tcp_v6_ao_do_lookup(const struct sock *sk,
 				       const struct in6_addr *addr,
 				       int sndid, int rcvid)
@@ -70,6 +82,15 @@ struct tcp_ao_key *tcp_v6_ao_lookup(const struct sock *sk,
 	return tcp_v6_ao_do_lookup(sk, addr, sndid, rcvid);
 }
 
+struct tcp_ao_key *tcp_v6_ao_lookup_rsk(const struct sock *sk,
+					struct request_sock *req,
+					int sndid, int rcvid)
+{
+	struct in6_addr *addr = &inet_rsk(req)->ir_v6_rmt_addr;
+
+	return tcp_v6_ao_do_lookup(sk, addr, sndid, rcvid);
+}
+
 int tcp_v6_ao_hash_pseudoheader(struct crypto_pool_ahash *hp,
 				const struct in6_addr *daddr,
 				const struct in6_addr *saddr, int nbytes)
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index bab4a1883b3c..7610fdf5d519 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -835,6 +835,10 @@ const struct tcp_request_sock_ops tcp_request_sock_ipv6_ops = {
 	.req_md5_lookup	=	tcp_v6_md5_lookup,
 	.calc_md5_hash	=	tcp_v6_md5_hash_skb,
 #endif
+#ifdef CONFIG_TCP_AO
+	.ao_lookup	=	tcp_v6_ao_lookup_rsk,
+	.ao_calc_key	=	tcp_v6_ao_calc_key_rsk,
+#endif
 #ifdef CONFIG_SYN_COOKIES
 	.cookie_init_seq =	cookie_v6_init_sequence,
 #endif
@@ -1220,9 +1224,51 @@ static void tcp_v6_timewait_ack(struct sock *sk, struct sk_buff *skb)
 static void tcp_v6_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 				  struct request_sock *req)
 {
+	struct tcp_md5sig_key *md5_key = NULL;
+	struct tcp_ao_key *ao_key = NULL;
+	const struct in6_addr *addr;
+	u8 keyid = 0;
+#ifdef CONFIG_TCP_AO
+	char traffic_key[TCP_AO_MAX_HASH_SIZE] __tcp_ao_key_align;
+	const struct tcp_ao_hdr *aoh;
+#else
+	u8 *traffic_key = NULL;
+#endif
 	int l3index;
 
 	l3index = tcp_v6_sdif(skb) ? tcp_v6_iif_l3_slave(skb) : 0;
+	addr = &ipv6_hdr(skb)->saddr;
+
+	if (tcp_rsk_used_ao(req)) {
+#ifdef CONFIG_TCP_AO
+		/* Invalid TCP option size or twice included auth */
+		if (tcp_parse_auth_options(tcp_hdr(skb), NULL, &aoh))
+			return;
+		if (!aoh)
+			return;
+		ao_key = tcp_v6_ao_do_lookup(sk, addr, aoh->rnext_keyid, -1);
+		if (unlikely(!ao_key)) {
+			/* Send ACK with any matching MKT for the peer */
+			ao_key = tcp_v6_ao_do_lookup(sk, addr, -1, -1);
+			/* Matching key disappeared (user removed the key?)
+			 * let the handshake timeout.
+			 */
+			if (!ao_key) {
+				net_info_ratelimited("TCP-AO key for (%pI6, %d)->(%pI6, %d) suddenly disappeared, won't ACK new connection\n",
+						addr,
+						ntohs(tcp_hdr(skb)->source),
+						&ipv6_hdr(skb)->daddr,
+						ntohs(tcp_hdr(skb)->dest));
+				return;
+			}
+		}
+
+		keyid = aoh->keyid;
+		tcp_v6_ao_calc_key_rsk(ao_key, traffic_key, req);
+#endif
+	} else {
+		md5_key = tcp_v6_md5_do_lookup(sk, addr, l3index);
+	}
 
 	/* sk->sk_state == TCP_LISTEN -> for regular TCP_SYN_RECV
 	 * sk->sk_state == TCP_SYN_RECV -> for Fast Open.
@@ -1238,9 +1284,9 @@ static void tcp_v6_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 			req->rsk_rcv_wnd >> inet_rsk(req)->rcv_wscale,
 			tcp_time_stamp_raw() + tcp_rsk(req)->ts_off,
 			req->ts_recent, sk->sk_bound_dev_if,
-			tcp_v6_md5_do_lookup(sk, &ipv6_hdr(skb)->saddr, l3index),
+			md5_key,
 			ipv6_get_dsfield(ipv6_hdr(skb)), 0, sk->sk_priority,
-			NULL, NULL, 0, 0);
+			ao_key, traffic_key, keyid, 0);
 }
 
 
@@ -1470,18 +1516,26 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 #ifdef CONFIG_TCP_MD5SIG
 	l3index = l3mdev_master_ifindex_by_index(sock_net(sk), ireq->ir_iif);
 
-	/* Copy over the MD5 key from the original socket */
-	key = tcp_v6_md5_do_lookup(sk, &newsk->sk_v6_daddr, l3index);
-	if (key) {
-		/* We're using one, so create a matching key
-		 * on the newsk structure. If we fail to get
-		 * memory, then we end up not copying the key
-		 * across. Shucks.
-		 */
-		tcp_md5_key_copy(newsk, (union tcp_md5_addr *)&newsk->sk_v6_daddr,
-			       AF_INET6, 128, l3index, key);
+	if (!tcp_rsk_used_ao(req)) {
+		const struct in6_addr *daddr = &newsk->sk_v6_daddr;
+		/* Copy over the MD5 key from the original socket */
+		key = tcp_v6_md5_do_lookup(sk, daddr, l3index);
+		if (key) {
+			/* We're using one, so create a matching key
+			 * on the newsk structure. If we fail to get
+			 * memory, then we end up not copying the key
+			 * across. Shucks.
+			 */
+			tcp_md5_key_copy(newsk, (union tcp_md5_addr *)daddr,
+					 AF_INET6, 128, l3index, key);
+		}
 	}
 #endif
+#ifdef CONFIG_TCP_AO
+	/* Copy over tcp_ao_info if any */
+	if (tcp_ao_copy_all_matching(sk, newsk, req, skb, AF_INET6))
+		goto out; /* OOM */
+#endif
 
 	if (__inet_inherit_port(sk, newsk) < 0) {
 		inet_csk_prepare_forced_close(newsk);
-- 
2.37.2

