Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4FE6D5398
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 23:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbjDCVfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 17:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233199AbjDCVey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 17:34:54 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66767469D
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 14:34:40 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id v6-20020a05600c470600b003f034269c96so8659144wmo.4
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 14:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1680557678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n7ZG1s53kUvcyXi1bjRNAVYG6VaYIyp0/yht4go0ibM=;
        b=fgmtsj67BVh3LSJPxN5Kf1RqRE9Gw1+ksHDufNaThW2SJOTFTXhPJNlWJm/HSEqnRb
         sgxIqKKmij5m3xJFLeNo8JdkxzKiOZtd1AipalkyicZKl7EmNRPY0k2+kIHRlPQyaLM7
         APDkl7tNCZP3GB4UZJNjVkcp71YRhB8T0U1PW9SbPHXToadbU5xeyyYPmQ+uN75wtKIh
         9FMnS+S5fxZQrkyFi+PRDJ0ST7F/wkAggGj/3dWaa0yVfS7FZqIETzNG7nxtIPdAnG9o
         K2R7Av+q5ygn6P01v2MapV8U53p3IfzjKa5fa07gTuxBpHMma+KQ4odab8AzdWpmvXd9
         vrUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680557678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n7ZG1s53kUvcyXi1bjRNAVYG6VaYIyp0/yht4go0ibM=;
        b=gUvQu0/Qm8UTbNfQJtWPCPk4u26FU/ZlrU8ktuKtfcCOxQJSk/liCPV83ESorerE5i
         jON3bW2Ar3Pq1VZXQN4I+eXxJXR9ZSAueWfnNX70wKx5Y/XJgqtbbkN1oUPHasb+AwNI
         LLqeDwTgCy9gWyaqjzYfW9Po2t5cxMn52BMjWZV8U7ZrRdqtuEupdg/SznfkF/7eE3EB
         pGxbombeoQdgDKS7rgZmKh+PkqQCYLQKnm543/ENM+mjLTbGyGzCNPN6BzqoTe/JH9dW
         B74RpOF9+8QyNI2IHdO6ki5e3dW97AZLMMmEAALgxnwHTZk54LqUyWAhBsHaT8C9X7eb
         7pnA==
X-Gm-Message-State: AAQBX9csur2Liopt2oQswy+1aweR1PJB/bvGR6uZzfYYfGJ5VOadt6DS
        TRCO5PBjGApF9kxj+6CjDBMpXg==
X-Google-Smtp-Source: AKy350ZoYyRgDE5OJnwKccC6q/lWgxrUZ9llefbAO2m77LN2XbAdcvQZlJF0S3FieaOALL6iOLstrg==
X-Received: by 2002:a05:600c:2312:b0:3ed:2b27:5bcc with SMTP id 18-20020a05600c231200b003ed2b275bccmr511011wmo.38.1680557678586;
        Mon, 03 Apr 2023 14:34:38 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id o5-20020a5d4a85000000b002c3f9404c45sm10682740wrq.7.2023.04.03.14.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 14:34:38 -0700 (PDT)
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
Subject: [PATCH v5 08/21] net/tcp: Add AO sign to RST packets
Date:   Mon,  3 Apr 2023 22:34:07 +0100
Message-Id: <20230403213420.1576559-9-dima@arista.com>
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

Wire up sending resets to TCP-AO hashing.

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp_ao.h |   8 ++++
 net/ipv4/tcp_ao.c    |  60 ++++++++++++++++++++++++-
 net/ipv4/tcp_ipv4.c  |  78 +++++++++++++++++++++++++++++----
 net/ipv6/tcp_ipv6.c  | 102 +++++++++++++++++++++++++++++++++++++------
 4 files changed, 225 insertions(+), 23 deletions(-)

diff --git a/include/net/tcp_ao.h b/include/net/tcp_ao.h
index 72fc87cf58bf..5b85ecd7024a 100644
--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -121,6 +121,8 @@ int tcp_ao_hash_skb(unsigned short int family,
 		    const u8 *tkey, int hash_offset, u32 sne);
 int tcp_parse_ao(struct sock *sk, int cmd, unsigned short int family,
 		 sockptr_t optval, int optlen);
+struct tcp_ao_key *tcp_ao_established_key(struct tcp_ao_info *ao,
+					  int sndid, int rcvid);
 int tcp_ao_calc_traffic_key(struct tcp_ao_key *mkt, u8 *key, void *ctx,
 			    unsigned int len);
 void tcp_ao_destroy_sock(struct sock *sk);
@@ -128,6 +130,12 @@ u32 tcp_ao_compute_sne(u32 sne, u32 seq, u32 new_seq);
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
index 56cebdfd07b8..ddd28bf80511 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -56,8 +56,8 @@ int tcp_ao_calc_traffic_key(struct tcp_ao_key *mkt, u8 *key, void *ctx,
  * it's known that the keys in ao_info are matching peer's
  * family/address/port/VRF/etc.
  */
-static struct tcp_ao_key *tcp_ao_established_key(struct tcp_ao_info *ao,
-						 int sndid, int rcvid)
+struct tcp_ao_key *tcp_ao_established_key(struct tcp_ao_info *ao,
+					  int sndid, int rcvid)
 {
 	struct tcp_ao_key *key;
 
@@ -70,6 +70,7 @@ static struct tcp_ao_key *tcp_ao_established_key(struct tcp_ao_info *ao,
 
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(tcp_ao_established_key);
 
 static inline int ipv4_prefix_cmp(const struct in_addr *addr1,
 				  const struct in_addr *addr2,
@@ -387,6 +388,61 @@ static int tcp_ao_hash_header(struct tcp_sigpool *hp,
 	return err;
 }
 
+int tcp_ao_hash_hdr(unsigned short int family, char *ao_hash,
+		    struct tcp_ao_key *key, const u8 *tkey,
+		    const union tcp_ao_addr *daddr,
+		    const union tcp_ao_addr *saddr,
+		    const struct tcphdr *th, u32 sne)
+{
+	__u8 tmp_hash[TCP_AO_MAX_HASH_SIZE] __tcp_ao_key_align;
+	int tkey_len = tcp_ao_digest_size(key);
+	int hash_offset = ao_hash - (char *)th;
+	struct tcp_sigpool hp;
+
+	if (tcp_sigpool_start(key->tcp_sigpool_id, &hp))
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
+	ahash_request_set_crypt(hp.req, NULL, tmp_hash, 0);
+	if (crypto_ahash_final(hp.req))
+		goto clear_hash;
+
+	memcpy(ao_hash, tmp_hash, tcp_ao_maclen(key));
+	tcp_sigpool_end();
+	return 0;
+
+clear_hash:
+	tcp_sigpool_end();
+clear_hash_noput:
+	memset(ao_hash, 0, tcp_ao_maclen(key));
+	return 1;
+}
+EXPORT_SYMBOL_GPL(tcp_ao_hash_hdr);
+
 int tcp_ao_hash_skb(unsigned short int family,
 		    char *ao_hash, struct tcp_ao_key *key,
 		    const struct sock *sk, const struct sk_buff *skb,
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 3ffc966868e0..f86f261dec41 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -684,16 +684,19 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
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
 #endif
-	u64 transmit_time = 0;
-	struct sock *ctl_sk;
-	struct net *net;
 
 	/* Never send a reset in response to a reset. */
 	if (th->rst)
@@ -725,12 +728,14 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
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
@@ -791,6 +796,63 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 				     key, ip_hdr(skb)->saddr,
 				     ip_hdr(skb)->daddr, &rep.th);
 	}
+#endif
+#ifdef CONFIG_TCP_AO
+	/* if (!sk || sk->sk_state == TCP_LISTEN) then the initial sisn/disn
+	 * are unknown. Skip TCP-AO signing.
+	 * Contrary to TCP-MD5 unsigned RST will be sent if there was AO sign
+	 * in segment, but TCP-AO signing isn't possible for reply.
+	 */
+	if (sk && aoh && sk->sk_state != TCP_LISTEN) {
+		char traffic_key[TCP_AO_MAX_HASH_SIZE] __tcp_ao_key_align;
+		struct tcp_ao_key *ao_key, *rnext_key;
+		struct tcp_ao_info *ao_info;
+		u32 ao_sne;
+		u8 keyid;
+
+		/* TODO: reqsk support */
+		if (sk->sk_state == TCP_NEW_SYN_RECV)
+			goto skip_ao_sign;
+
+		ao_info = rcu_dereference(tcp_sk(sk)->ao_info);
+
+		if (!ao_info)
+			goto skip_ao_sign;
+
+		ao_key = tcp_ao_established_key(ao_info, aoh->rnext_keyid, -1);
+		if (!ao_key)
+			goto skip_ao_sign;
+
+		/* XXX: optimize by using cached traffic key depending
+		 * on socket state
+		 */
+		if (tcp_v4_ao_calc_key_sk(ao_key, traffic_key, sk,
+					  ao_info->lisn, ao_info->risn, true))
+			goto out;
+
+		/* rcv_next holds the rcv_next of the peer, make keyid
+		 * hold our rcv_next
+		 */
+		rnext_key = ao_info->rnext_key;
+		keyid = rnext_key->rcvid;
+		ao_sne = tcp_ao_compute_sne(ao_info->snd_sne,
+					    ao_info->snd_sne_seq,
+					    ntohl(rep.th.seq));
+
+		rep.opt[0] = htonl((TCPOPT_AO << 24) |
+				(tcp_ao_len(ao_key) << 16) |
+				(aoh->rnext_keyid << 8) | keyid);
+		arg.iov[0].iov_len += round_up(tcp_ao_len(ao_key), 4);
+		rep.th.doff = arg.iov[0].iov_len / 4;
+
+		if (tcp_ao_hash_hdr(AF_INET, (char *)&rep.opt[1],
+				    ao_key, traffic_key,
+				    (union tcp_ao_addr *)&ip_hdr(skb)->saddr,
+				    (union tcp_ao_addr *)&ip_hdr(skb)->daddr,
+				    &rep.th, ao_sne))
+			goto out;
+	}
+skip_ao_sign:
 #endif
 	/* Can't co-exist with TCPMD5, hence check rep.opt[0] */
 	if (rep.opt[0] == 0) {
@@ -848,7 +910,7 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	__TCP_INC_STATS(net, TCP_MIB_OUTRSTS);
 	local_bh_enable();
 
-#ifdef CONFIG_TCP_MD5SIG
+#if defined(CONFIG_TCP_MD5SIG) || defined(CONFIG_TCP_AO)
 out:
 	rcu_read_unlock();
 #endif
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 519fce8c21f3..6930044fb5a2 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -857,7 +857,9 @@ const struct tcp_request_sock_ops tcp_request_sock_ipv6_ops = {
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
@@ -876,6 +878,13 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
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
@@ -927,6 +936,21 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
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
@@ -991,17 +1015,28 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
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
@@ -1013,12 +1048,13 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
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
 
@@ -1067,6 +1103,45 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 		ack_seq = ntohl(th->seq) + th->syn + th->fin + skb->len -
 			  (th->doff << 2);
 
+#ifdef CONFIG_TCP_AO
+	/* if (!sk || sk->sk_state == TCP_LISTEN) then the initial sisn/disn
+	 * are unknown. Skip TCP-AO signing.
+	 * Contrary to TCP-MD5 unsigned RST will be sent if there was AO sign
+	 * in segment, but TCP-AO signing isn't possible for reply.
+	 */
+	if (sk && aoh && sk->sk_state != TCP_LISTEN) {
+		struct tcp_ao_info *ao_info;
+		struct tcp_ao_key *rnext_key;
+
+		/* TODO: reqsk support */
+		if (sk->sk_state == TCP_NEW_SYN_RECV)
+			goto skip_ao_sign;
+
+		ao_info = rcu_dereference(tcp_sk(sk)->ao_info);
+		if (!ao_info)
+			goto skip_ao_sign;
+
+		/* rcv_next is the peer's here */
+		ao_key = tcp_ao_established_key(ao_info, aoh->rnext_keyid, -1);
+		if (!ao_key)
+			goto skip_ao_sign;
+
+		/* XXX: optimize by using cached traffic key depending
+		 * on socket state
+		 */
+		if (tcp_v6_ao_calc_key_sk(ao_key, traffic_key, sk,
+					  ao_info->lisn, ao_info->risn, true))
+			goto out;
+
+		/* rcv_next switches to our rcv_next */
+		rnext_key = READ_ONCE(ao_info->rnext_key);
+		rcv_next = rnext_key->rcvid;
+		ao_sne = tcp_ao_compute_sne(ao_info->snd_sne,
+					    ao_info->snd_sne_seq, seq);
+	}
+skip_ao_sign:
+#endif
+
 	if (sk) {
 		oif = sk->sk_bound_dev_if;
 		if (sk_fullsock(sk)) {
@@ -1089,9 +1164,10 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
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
@@ -1103,7 +1179,7 @@ static void tcp_v6_send_ack(const struct sock *sk, struct sk_buff *skb, u32 seq,
 			    __be32 label, u32 priority, u32 txhash)
 {
 	tcp_v6_send_response(sk, skb, seq, ack, win, tsval, tsecr, oif, key, 0,
-			     tclass, label, priority, txhash);
+			     tclass, label, priority, txhash, NULL, NULL, 0, 0);
 }
 
 static void tcp_v6_timewait_ack(struct sock *sk, struct sk_buff *skb)
-- 
2.40.0

