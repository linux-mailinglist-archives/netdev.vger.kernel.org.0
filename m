Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E14D561032D
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 22:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237098AbiJ0Urd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 16:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236565AbiJ0UqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 16:46:04 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CC9951FD
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:44:16 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id z14so4155510wrn.7
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=axN8ZmDNzhMnIzIaFx1++LOhn5A1Ycz/AuCMC//ovzw=;
        b=EI1H4V68rgpTul2737VoMS3IEksZve3+Sk9POOuAWuPesjx9wxZTNgmv58DiZpDGqx
         2a0QCF+/Gfi26Eu7OTXyz5cxPbkIk53zYHyzNvYyz7XiN+I11owcWulTHPtcAOwd0Ukw
         CGHZFdCp91SciD3Tv2gHZ56SCT+Yn7WBDcBROUmjJ1+t7Hk/Xl7fQhhulwqjBo6l3TQv
         LJO6VNeQUg/H6qYn93EQ2AE8PFUlELCeUcmQeVBihUhEH+XlETLC21lWUdz8kussKwhj
         4KvCf4o42e0T384Q3EVFb3uI0zCByGG3mYJabeP9jc19nmjUqDlU5JYtRs8muuG2hW1t
         vH/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=axN8ZmDNzhMnIzIaFx1++LOhn5A1Ycz/AuCMC//ovzw=;
        b=oUHxf7QQ0nnKyn5XUsh3XocrZZUxuGmiKqap1asT5EWwTULFH5fpiuNMiuV6gW7XUV
         epUt3UFzuivmZSNxFY8yrr3sOrhwhD06J7yfOatRh8CI1mMlAbCP975Sf+i2BfDg/+z5
         gL78Q7jMqzQbk0ip5spv46ynVjK6J5JjG4EXwU86r3fKAl7W0pDnp4ZPnoM39Jgkcgwh
         iNx2cUNLZS/eIAeQTFMmb7TgVDH7rFSYYa3ASCGI/ZegTxaRX1Tdmr6ZAs8UnrjrIAMh
         1zzlhuAEp91CC0VF2DyjiQ42jYSzR7WsFe1xDpAYEQqpGfotfKGS323VfEphvH1V6u99
         vofQ==
X-Gm-Message-State: ACrzQf3S5tkPlBMCMOb/MmXa2AcKho5VBWQj2ikHzB1lrj6Vv0peio2k
        +We64+Tl+DbKLriysX31fvfqiw==
X-Google-Smtp-Source: AMsMyM5L7h5AkmuKXXRj0oI92h8HdgiB0wT3aYdjSIm6poCDBwqSpOZ7TX5UU1TJYQ+YGcroBroJSA==
X-Received: by 2002:adf:db10:0:b0:231:bcaa:313b with SMTP id s16-20020adfdb10000000b00231bcaa313bmr31368901wri.142.1666903454890;
        Thu, 27 Oct 2022 13:44:14 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n3-20020a5d6b83000000b00236644228besm1968739wrx.40.2022.10.27.13.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 13:44:14 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
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
Subject: [PATCH v3 13/36] net/tcp: Add AO sign to RST packets
Date:   Thu, 27 Oct 2022 21:43:24 +0100
Message-Id: <20221027204347.529913-14-dima@arista.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027204347.529913-1-dima@arista.com>
References: <20221027204347.529913-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wire up sending resets to TCP-AO hashing.

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp_ao.h |  7 ++++
 net/ipv4/tcp_ao.c    | 53 ++++++++++++++++++++++++
 net/ipv4/tcp_ipv4.c  | 68 +++++++++++++++++++++++++++----
 net/ipv6/tcp_ipv6.c  | 96 ++++++++++++++++++++++++++++++++++++++------
 4 files changed, 203 insertions(+), 21 deletions(-)

diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index 7b38ac70416f..d359fbf89da8 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -114,6 +114,7 @@ int tcp_ao_hash_skb(unsigned short int family,
 		    const u8 *tkey, int hash_offset, u32 sne);
 int tcp_parse_ao(struct sock *sk, int cmd, unsigned short int family,
 		 sockptr_t optval, int optlen);
+struct tcp_ao_key *tcp_ao_do_lookup_sndid(const struct sock *sk, u8 keyid);
 int tcp_ao_calc_traffic_key(struct tcp_ao_key *mkt, u8 *key, void *ctx,
 			    unsigned int len);
 void tcp_ao_destroy_sock(struct sock *sk);
@@ -123,6 +124,12 @@ int tcp_ao_cache_traffic_keys(const struct sock *sk, struct tcp_ao_info *ao,
 struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
 				    const union tcp_ao_addr *addr,
 				    int family, int sndid, int rcvid, u16 port);
+int tcp_ao_hash_hdr(unsigned short family, char *ao_hash,
+		struct tcp_ao_key *key, const u8 *tkey,
+		const union tcp_ao_addr *daddr,
+		const union tcp_ao_addr *saddr,
+		const struct tcphdr *th, u32 sne);
+
 /* ipv4 specific functions */
 int tcp_v4_parse_ao(struct sock *sk, int optname, sockptr_t optval, int optlen);
 struct tcp_ao_key *tcp_v4_ao_lookup(const struct sock *sk, struct sock *addr_sk,
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index bae6cca26fc5..e20e3b435ce1 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -421,6 +421,59 @@ static int tcp_ao_hash_skb_data(struct crypto_pool_ahash *hp,
 	return 0;
 }
 
+int tcp_ao_hash_hdr(unsigned short int family, char *ao_hash,
+		    struct tcp_ao_key *key, const u8 *tkey,
+		    const union tcp_ao_addr *daddr,
+		    const union tcp_ao_addr *saddr,
+		    const struct tcphdr *th, u32 sne)
+{
+	struct crypto_pool_ahash hp;
+	int tkey_len = tcp_ao_digest_size(key);
+	int hash_offset = ao_hash - (char *)th;
+
+	if (crypto_pool_get(key->crypto_pool_id, (struct crypto_pool *)&hp))
+		goto clear_hash_noput;
+
+	if (crypto_ahash_setkey(crypto_ahash_reqtfm(hp.req), tkey, tkey_len))
+		goto clear_hash;
+
+	if (crypto_ahash_init(hp.req))
+		goto clear_hash;
+
+	if (tcp_ao_hash_sne(&hp, sne))
+		goto clear_hash;
+	if (family == AF_INET) {
+		if (tcp_v4_ao_hash_pseudoheader(&hp, daddr->a4.s_addr,
+						saddr->a4.s_addr, th->doff * 4))
+			goto clear_hash;
+#if IS_ENABLED(CONFIG_IPV6)
+	} else if (family == AF_INET6) {
+		if (tcp_v6_ao_hash_pseudoheader(&hp, &daddr->a6,
+						&saddr->a6, th->doff * 4))
+			goto clear_hash;
+#endif
+	} else {
+		WARN_ON_ONCE(1);
+		goto clear_hash;
+	}
+	if (tcp_ao_hash_header(&hp, th, false,
+			       ao_hash, hash_offset, tcp_ao_maclen(key)))
+		goto clear_hash;
+	ahash_request_set_crypt(hp.req, NULL, ao_hash, 0);
+	if (crypto_ahash_final(hp.req))
+		goto clear_hash;
+
+	crypto_pool_put();
+	return 0;
+
+clear_hash:
+	crypto_pool_put();
+clear_hash_noput:
+	memset(ao_hash, 0, tcp_ao_maclen(key));
+	return 1;
+}
+EXPORT_SYMBOL(tcp_ao_hash_hdr);
+
 int tcp_ao_hash_skb(unsigned short int family,
 		    char *ao_hash, struct tcp_ao_key *key,
 		    const struct sock *sk, const struct sk_buff *skb,
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 1c014b326ee6..b76933bb073e 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -696,16 +696,24 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 		__be32 opt[OPTION_BYTES / sizeof(__be32)];
 	} rep;
 	struct ip_reply_arg arg;
+	u64 transmit_time = 0;
+	struct sock *ctl_sk;
+	struct net *net;
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
+	const __u8 *md5_hash_location = NULL;
+	const struct tcp_ao_hdr *aoh;
 #ifdef CONFIG_TCP_MD5SIG
 	struct tcp_md5sig_key *key = NULL;
-	const __u8 *md5_hash_location = NULL;
 	unsigned char newhash[16];
-	int genhash;
 	struct sock *sk1 = NULL;
+	int genhash;
+#endif
+#ifdef CONFIG_TCP_AO
+	char traffic_key[TCP_AO_MAX_HASH_SIZE] __tcp_ao_key_align;
+	struct tcp_ao_key *ao_key = NULL;
+	u32 ao_sne;
+#endif
 #endif
-	u64 transmit_time = 0;
-	struct sock *ctl_sk;
-	struct net *net;
 
 	/* Never send a reset in response to a reset. */
 	if (th->rst)
@@ -737,12 +745,14 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	arg.iov[0].iov_len  = sizeof(rep.th);
 
 	net = sk ? sock_net(sk) : dev_net(skb_dst(skb)->dev);
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
 	/* Invalid TCP option size or twice included auth */
-	if (tcp_parse_auth_options(tcp_hdr(skb), &md5_hash_location, NULL))
+	if (tcp_parse_auth_options(tcp_hdr(skb), &md5_hash_location, &aoh))
 		return;
 
 	rcu_read_lock();
+#endif
+#ifdef CONFIG_TCP_MD5SIG
 	if (sk && sk_fullsock(sk)) {
 		const union tcp_md5_addr *addr;
 		int l3index;
@@ -803,6 +813,48 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 				     key, ip_hdr(skb)->saddr,
 				     ip_hdr(skb)->daddr, &rep.th);
 	}
+#endif
+#ifdef CONFIG_TCP_AO
+	if (sk && aoh && sk->sk_state != TCP_LISTEN) {
+		/* lookup key based on peer address and rcv_next*/
+		ao_key = tcp_ao_do_lookup_sndid(sk, aoh->rnext_keyid);
+
+		if (ao_key) {
+			struct tcp_ao_info *ao_info;
+			u8 keyid;
+
+			ao_info = rcu_dereference(tcp_sk(sk)->ao_info);
+
+			/* XXX: optimize by using cached traffic key depending
+			 * on socket state
+			 */
+			if (tcp_v4_ao_calc_key_sk(ao_key, traffic_key, sk,
+						  ao_info->lisn, ao_info->risn,
+						  true))
+				goto out;
+
+			/* rcv_next holds the rcv_next of the peer, make keyid
+			 * hold our rcv_next
+			 */
+			keyid = ao_info->rnext_key->rcvid;
+			ao_sne = tcp_ao_compute_sne(ao_info->snd_sne,
+						    ao_info->snd_sne_seq,
+						    ntohl(rep.th.seq));
+
+			rep.opt[0] = htonl((TCPOPT_AO << 24) |
+					   (tcp_ao_len(ao_key) << 16) |
+					   (aoh->rnext_keyid << 8) | keyid);
+			arg.iov[0].iov_len += round_up(tcp_ao_len(ao_key), 4);
+			rep.th.doff = arg.iov[0].iov_len / 4;
+
+			if (tcp_ao_hash_hdr(AF_INET, (char *)&rep.opt[1],
+					    ao_key, traffic_key,
+					    (union tcp_ao_addr *)&ip_hdr(skb)->saddr,
+					    (union tcp_ao_addr *)&ip_hdr(skb)->daddr,
+					    &rep.th, ao_sne))
+				goto out;
+		}
+	}
 #endif
 	/* Can't co-exist with TCPMD5, hence check rep.opt[0] */
 	if (rep.opt[0] == 0) {
@@ -860,7 +912,7 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	__TCP_INC_STATS(net, TCP_MIB_OUTRSTS);
 	local_bh_enable();
 
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
 out:
 	rcu_read_unlock();
 #endif
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 58a77515aa27..23e0d4ffc007 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -865,7 +865,9 @@ const struct tcp_request_sock_ops tcp_request_sock_ipv6_ops = {
 static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32 seq,
 				 u32 ack, u32 win, u32 tsval, u32 tsecr,
 				 int oif, struct tcp_md5sig_key *key, int rst,
-				 u8 tclass, __be32 label, u32 priority, u32 txhash)
+				 u8 tclass, __be32 label, u32 priority, u32 txhash,
+				 struct tcp_ao_key *ao_key, char *tkey,
+				 u8 rcv_next, u32 ao_sne)
 {
 	const struct tcphdr *th = tcp_hdr(skb);
 	struct tcphdr *t1;
@@ -884,6 +886,13 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 	if (key)
 		tot_len += TCPOLEN_MD5SIG_ALIGNED;
 #endif
+#ifdef CONFIG_TCP_AO
+	if (ao_key)
+		tot_len += tcp_ao_len(ao_key);
+#endif
+#if defined(CONFIG_TCP_MD5SIG) && defined(CONFIG_TCP_AO)
+	WARN_ON_ONCE(key && ao_key);
+#endif
 
 #ifdef CONFIG_MPTCP
 	if (rst && !key) {
@@ -935,6 +944,21 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 				    &ipv6_hdr(skb)->daddr, t1);
 	}
 #endif
+#ifdef CONFIG_TCP_AO
+	if (ao_key) {
+		*topt++ = htonl((TCPOPT_AO << 24) | (tcp_ao_len(ao_key) << 16) |
+				(ao_key->sndid << 8) | (rcv_next));
+
+		/* TODO: this is right now not going to work for listening
+		 * sockets since the socket won't have the needed ipv6
+		 * addresses
+		 */
+		tcp_ao_hash_hdr(AF_INET6, (char *)topt, ao_key, tkey,
+				(union tcp_ao_addr *)&ipv6_hdr(skb)->saddr,
+				(union tcp_ao_addr *)&ipv6_hdr(skb)->daddr,
+				t1, ao_sne);
+	}
+#endif
 
 	memset(&fl6, 0, sizeof(fl6));
 	fl6.daddr = ipv6_hdr(skb)->saddr;
@@ -999,17 +1023,28 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 	struct ipv6hdr *ipv6h = ipv6_hdr(skb);
 	u32 seq = 0, ack_seq = 0;
 	struct tcp_md5sig_key *key = NULL;
-#ifdef CONFIG_TCP_MD5SIG
-	const __u8 *md5_hash_location = NULL;
-	unsigned char newhash[16];
-	int genhash;
-	struct sock *sk1 = NULL;
-#endif
 	__be32 label = 0;
 	u32 priority = 0;
 	struct net *net;
+	struct tcp_ao_key *ao_key = NULL;
+	u8 rcv_next = 0;
+	u32 ao_sne = 0;
 	u32 txhash = 0;
 	int oif = 0;
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
+	const __u8 *md5_hash_location = NULL;
+	const struct tcp_ao_hdr *aoh;
+#endif
+#ifdef CONFIG_TCP_MD5SIG
+	unsigned char newhash[16];
+	int genhash;
+	struct sock *sk1 = NULL;
+#endif
+#ifdef CONFIG_TCP_AO
+	char traffic_key[TCP_AO_MAX_HASH_SIZE] __tcp_ao_key_align;
+#else
+	u8 *traffic_key = NULL;
+#endif
 
 	if (th->rst)
 		return;
@@ -1021,12 +1056,13 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 		return;
 
 	net = sk ? sock_net(sk) : dev_net(skb_dst(skb)->dev);
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
 	/* Invalid TCP option size or twice included auth */
-	if (tcp_parse_auth_options(th, &md5_hash_location, NULL))
+	if (tcp_parse_auth_options(th, &md5_hash_location, &aoh))
 		return;
-
 	rcu_read_lock();
+#endif
+#ifdef CONFIG_TCP_MD5SIG
 	if (sk && sk_fullsock(sk)) {
 		int l3index;
 
@@ -1075,6 +1111,39 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 		ack_seq = ntohl(th->seq) + th->syn + th->fin + skb->len -
 			  (th->doff << 2);
 
+#ifdef CONFIG_TCP_AO
+	/* XXX: Not implemented for listening sockets yet. How do we
+	 * get the initial sequence numbers? Might need to pass in
+	 * the request socket.
+	 */
+	if (sk && aoh && sk->sk_state != TCP_LISTEN) {
+		struct tcp_ao_info *ao_info;
+
+		if (WARN_ON_ONCE(sk->sk_state == TCP_NEW_SYN_RECV))
+			goto out;
+
+		/* rcv_next is the peer's here */
+		ao_key = tcp_ao_do_lookup_sndid(sk, aoh->rnext_keyid);
+
+		if (ao_key) {
+			ao_info = rcu_dereference(tcp_sk(sk)->ao_info);
+
+			/* XXX: optimize by using cached traffic key depending
+			 * on socket state
+			 */
+			if (tcp_v6_ao_calc_key_sk(ao_key, traffic_key, sk,
+						  ao_info->lisn, ao_info->risn,
+						  true))
+				goto out;
+
+			/* rcv_next switches to our rcv_next */
+			rcv_next = ao_info->rnext_key->rcvid;
+			ao_sne = tcp_ao_compute_sne(ao_info->snd_sne,
+						    ao_info->snd_sne_seq, seq);
+		}
+	}
+#endif
+
 	if (sk) {
 		oif = sk->sk_bound_dev_if;
 		if (sk_fullsock(sk)) {
@@ -1097,9 +1166,10 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 	}
 
 	tcp_v6_send_response(sk, skb, seq, ack_seq, 0, 0, 0, oif, key, 1,
-			     ipv6_get_dsfield(ipv6h), label, priority, txhash);
+			     ipv6_get_dsfield(ipv6h), label, priority, txhash,
+			     ao_key, traffic_key, rcv_next, ao_sne);
 
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
 out:
 	rcu_read_unlock();
 #endif
@@ -1111,7 +1181,7 @@ static void tcp_v6_send_ack(const struct sock *sk, struct sk_buff *skb, u32 seq,
 			    __be32 label, u32 priority, u32 txhash)
 {
 	tcp_v6_send_response(sk, skb, seq, ack, win, tsval, tsecr, oif, key, 0,
-			     tclass, label, priority, txhash);
+			     tclass, label, priority, txhash, NULL, NULL, 0, 0);
 }
 
 static void tcp_v6_timewait_ack(struct sock *sk, struct sk_buff *skb)
-- 
2.38.1

