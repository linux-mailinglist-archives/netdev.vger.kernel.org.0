Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37C7B47E596
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 16:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349098AbhLWPk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 10:40:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349042AbhLWPkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 10:40:47 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32387C061759;
        Thu, 23 Dec 2021 07:40:47 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id o6so22973634edc.4;
        Thu, 23 Dec 2021 07:40:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ijyG4YVZrdYIGC7hCdsBdBrsDOG/QviB0lGYBejnUaE=;
        b=B3yWWghjNaj2TGvlc6LRGbskPGHdk1+fySeyln5DqyOsbWs2/vRMnelcd0KJ9AMJYx
         Aaq4ISAMWdb/jYsEJCdGFPRjzCQmeZc/VZxdJCcfSEe1V0oKME1wrFLkeeFDz09uf4e1
         gGk0rTdoJVl6Leq6KZ2pQVCt9JKw3BtmEhzHFhIpkPDEL1n42yJpLpia4a9nYSCvG3QM
         8yWP2ktKf5mdD8ENlvUOmJiAb9pS0x847J/IOI7s4KM/EJjjBtmwsh7De4CDl1go3UC6
         NXVwdFddE//4oSUMmXBpl1Ro8mPFchdUY8dN905FK76PWAs4qksep5posOrltd+GuEfR
         9Tew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ijyG4YVZrdYIGC7hCdsBdBrsDOG/QviB0lGYBejnUaE=;
        b=31EQrawA1p8Yne3r1DjY931ffTNouNitZK1sxDbE6YSps8oP+jXD4+0e0MYj+byKyS
         88ts7R9G8epAKTFlZWOeiTWmTPf1UG995EsPW09imHTAfvNJHJq6d8VDrlK/Jr+pL/cJ
         wW3dhc6HachcqhUcv8MDXtewUcfC0DzfvAGpRCoso57fogtm4W8u3YkCwv9VN+rkOgMW
         oPWQokmntGbAn8IzUtbWzNcwyWgxRuD3NIuLQtOBfYBK+dDCTIWv8Q9dTRX2opNU7BSq
         b7J/ycu52xP/Yfu1fc9BsQ8TVOJax0eIIpMjHWiJjGqP5gEtpw6h1UYpEMClkzMTvoNc
         sYGA==
X-Gm-Message-State: AOAM530fHOR3Db8JB64FiQ2SrEW4N6fEcV/KGoOAbaiId5r757g3zmd5
        2+yk9A5S5QUSRLtwJNW8eLM=
X-Google-Smtp-Source: ABdhPJwGLXCiRRwnoKVXrNCC8COeKwZDXUmseG8bvAkTKG1OJdC3qEelKPCoElShmKSWwqiCvlXVAQ==
X-Received: by 2002:a17:907:da0:: with SMTP id go32mr2410273ejc.201.1640274045679;
        Thu, 23 Dec 2021 07:40:45 -0800 (PST)
Received: from ponky.lan ([2a04:241e:501:3870:7c02:dfc6:b554:ab10])
        by smtp.gmail.com with ESMTPSA id bx6sm2088617edb.78.2021.12.23.07.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 07:40:45 -0800 (PST)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>,
        Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 05/19] tcp: authopt: Compute packet signatures
Date:   Thu, 23 Dec 2021 17:40:00 +0200
Message-Id: <a0f8121e7efb452971800ee4a556314c4a8ad446.1640273966.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1640273966.git.cdleonard@gmail.com>
References: <cover.1640273966.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Computing tcp authopt packet signatures is a two step process:

* traffic key is computed based on tcp 4-tuple, initial sequence numbers
and the secret key.
* packet mac is computed based on traffic key and content of individual
packets.

The traffic key could be cached for established sockets but it is not.

A single code path exists for ipv4/ipv6 and input/output. This keeps the
code short but slightly slower due to lots of conditionals.

On output we read remote IP address from socket members on output, we
can't use skb network header because it's computed after TCP options.

On input we read remote IP address from skb network headers, we can't
use socket binding members because those are not available for SYN.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 include/net/tcp_authopt.h |   9 +
 net/ipv4/tcp_authopt.c    | 441 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 450 insertions(+)

diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
index bbd0c0977954..7d0a66fcde71 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -68,10 +68,19 @@ struct tcp_authopt_info {
 	u32 src_isn;
 	/** @dst_isn: Remote Initial Sequence Number */
 	u32 dst_isn;
 };
 
+/* TCP authopt as found in header */
+struct tcphdr_authopt {
+	u8 num;
+	u8 len;
+	u8 keyid;
+	u8 rnextkeyid;
+	u8 mac[0];
+};
+
 #ifdef CONFIG_TCP_AUTHOPT
 void tcp_authopt_clear(struct sock *sk);
 int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen);
 int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *key);
 int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen);
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index 8d04ececf09f..01bc12ad56f1 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -461,10 +461,451 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 	mutex_unlock(&net->mutex);
 
 	return 0;
 }
 
+static int tcp_authopt_get_isn(struct sock *sk,
+			       struct tcp_authopt_info *info,
+			       struct sk_buff *skb,
+			       int input,
+			       __be32 *sisn,
+			       __be32 *disn)
+{
+	struct tcphdr *th = tcp_hdr(skb);
+
+	/* Special cases for SYN and SYN/ACK */
+	if (th->syn && !th->ack) {
+		*sisn = th->seq;
+		*disn = 0;
+		return 0;
+	}
+	if (th->syn && th->ack) {
+		*sisn = th->seq;
+		*disn = htonl(ntohl(th->ack_seq) - 1);
+		return 0;
+	}
+
+	if (sk->sk_state == TCP_NEW_SYN_RECV) {
+		struct tcp_request_sock *rsk = (struct tcp_request_sock *)sk;
+
+		if (WARN_ONCE(!input, "Caller passed wrong socket"))
+			return -EINVAL;
+		*sisn = htonl(rsk->rcv_isn);
+		*disn = htonl(rsk->snt_isn);
+		return 0;
+	} else if (sk->sk_state == TCP_LISTEN) {
+		/* Signature computation for non-syn packet on a listen
+		 * socket is not possible because we lack the initial
+		 * sequence numbers.
+		 *
+		 * Input segments that are not matched by any request,
+		 * established or timewait socket will get here. These
+		 * are not normally sent by peers.
+		 *
+		 * Their signature might be valid but we don't have
+		 * enough state to determine that. TCP-MD5 can attempt
+		 * to validate and reply with a signed RST because it
+		 * doesn't care about ISNs.
+		 *
+		 * Reporting an error from signature code causes the
+		 * packet to be discarded which is good.
+		 */
+		if (WARN_ONCE(!input, "Caller passed wrong socket"))
+			return -EINVAL;
+		*sisn = 0;
+		*disn = 0;
+		return 0;
+	}
+	if (WARN_ONCE(!info, "caller did not pass tcp_authopt_info\n"))
+		return -EINVAL;
+	/* Initial sequence numbers for ESTABLISHED connections from info */
+	if (input) {
+		*sisn = htonl(info->dst_isn);
+		*disn = htonl(info->src_isn);
+	} else {
+		*sisn = htonl(info->src_isn);
+		*disn = htonl(info->dst_isn);
+	}
+	return 0;
+}
+
+/* Feed one buffer into ahash
+ * The buffer is assumed to be DMA-able
+ */
+static int crypto_ahash_buf(struct ahash_request *req, u8 *buf, uint len)
+{
+	struct scatterlist sg;
+
+	sg_init_one(&sg, buf, len);
+	ahash_request_set_crypt(req, &sg, NULL, len);
+
+	return crypto_ahash_update(req);
+}
+
+/* feed traffic key into ahash */
+static int tcp_authopt_ahash_traffic_key(struct tcp_authopt_alg_pool *pool,
+					 struct sock *sk,
+					 struct sk_buff *skb,
+					 struct tcp_authopt_info *info,
+					 bool input,
+					 bool ipv6)
+{
+	struct tcphdr *th = tcp_hdr(skb);
+	int err;
+	__be32 sisn, disn;
+	__be16 digestbits = htons(crypto_ahash_digestsize(pool->tfm) * 8);
+
+	// RFC5926 section 3.1.1.1
+	err = crypto_ahash_buf(pool->req, "\x01TCP-AO", 7);
+	if (err)
+		return err;
+
+	/* Addresses from packet on input and from sk_common on output
+	 * This is because on output MAC is computed before prepending IP header
+	 */
+	if (input) {
+		if (ipv6)
+			err = crypto_ahash_buf(pool->req, (u8 *)&ipv6_hdr(skb)->saddr, 32);
+		else
+			err = crypto_ahash_buf(pool->req, (u8 *)&ip_hdr(skb)->saddr, 8);
+		if (err)
+			return err;
+	} else {
+		if (ipv6) {
+			err = crypto_ahash_buf(pool->req, (u8 *)&sk->sk_v6_rcv_saddr, 16);
+			if (err)
+				return err;
+			err = crypto_ahash_buf(pool->req, (u8 *)&sk->sk_v6_daddr, 16);
+			if (err)
+				return err;
+		} else {
+			err = crypto_ahash_buf(pool->req, (u8 *)&sk->sk_rcv_saddr, 4);
+			if (err)
+				return err;
+			err = crypto_ahash_buf(pool->req, (u8 *)&sk->sk_daddr, 4);
+			if (err)
+				return err;
+		}
+	}
+
+	/* TCP ports from header */
+	err = crypto_ahash_buf(pool->req, (u8 *)&th->source, 4);
+	if (err)
+		return err;
+	err = tcp_authopt_get_isn(sk, info, skb, input, &sisn, &disn);
+	if (err)
+		return err;
+	err = crypto_ahash_buf(pool->req, (u8 *)&sisn, 4);
+	if (err)
+		return err;
+	err = crypto_ahash_buf(pool->req, (u8 *)&disn, 4);
+	if (err)
+		return err;
+	err = crypto_ahash_buf(pool->req, (u8 *)&digestbits, 2);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+/* Convert a variable-length key to a 16-byte fixed-length key for AES-CMAC
+ * This is described in RFC5926 section 3.1.1.2
+ */
+static int aes_setkey_derived(struct crypto_ahash *tfm, struct ahash_request *req,
+			      u8 *key, size_t keylen)
+{
+	static const u8 zeros[16] = {0};
+	struct scatterlist sg;
+	u8 derived_key[16];
+	int err;
+
+	if (WARN_ON_ONCE(crypto_ahash_digestsize(tfm) != sizeof(derived_key)))
+		return -EINVAL;
+	err = crypto_ahash_setkey(tfm, zeros, sizeof(zeros));
+	if (err)
+		return err;
+	err = crypto_ahash_init(req);
+	if (err)
+		return err;
+	sg_init_one(&sg, key, keylen);
+	ahash_request_set_crypt(req, &sg, derived_key, keylen);
+	err = crypto_ahash_digest(req);
+	if (err)
+		return err;
+	return crypto_ahash_setkey(tfm, derived_key, sizeof(derived_key));
+}
+
+static int tcp_authopt_setkey(struct tcp_authopt_alg_pool *pool, struct tcp_authopt_key_info *key)
+{
+	if (key->alg_id == TCP_AUTHOPT_ALG_AES_128_CMAC_96 && key->keylen != 16)
+		return aes_setkey_derived(pool->tfm, pool->req, key->key, key->keylen);
+	else
+		return crypto_ahash_setkey(pool->tfm, key->key, key->keylen);
+}
+
+static int tcp_authopt_get_traffic_key(struct sock *sk,
+				       struct sk_buff *skb,
+				       struct tcp_authopt_key_info *key,
+				       struct tcp_authopt_info *info,
+				       bool input,
+				       bool ipv6,
+				       u8 *traffic_key)
+{
+	struct tcp_authopt_alg_pool *pool;
+	int err;
+
+	pool = tcp_authopt_get_kdf_pool(key);
+	if (IS_ERR(pool))
+		return PTR_ERR(pool);
+
+	err = tcp_authopt_setkey(pool, key);
+	if (err)
+		goto out;
+	err = crypto_ahash_init(pool->req);
+	if (err)
+		goto out;
+
+	err = tcp_authopt_ahash_traffic_key(pool, sk, skb, info, input, ipv6);
+	if (err)
+		goto out;
+
+	ahash_request_set_crypt(pool->req, NULL, traffic_key, 0);
+	err = crypto_ahash_final(pool->req);
+	if (err)
+		return err;
+
+out:
+	tcp_authopt_put_kdf_pool(key, pool);
+	return err;
+}
+
+static int crypto_ahash_buf_zero(struct ahash_request *req, int len)
+{
+	u8 zeros[TCP_AUTHOPT_MACLEN] = {0};
+	int buflen, err;
+
+	/* In practice this is always called with len exactly 12.
+	 * Even on input we drop unusual signature sizes early.
+	 */
+	while (len) {
+		buflen = min_t(int, len, sizeof(zeros));
+		err = crypto_ahash_buf(req, zeros, buflen);
+		if (err)
+			return err;
+		len -= buflen;
+	}
+
+	return 0;
+}
+
+static int tcp_authopt_hash_tcp4_pseudoheader(struct tcp_authopt_alg_pool *pool,
+					      __be32 saddr,
+					      __be32 daddr,
+					      int nbytes)
+{
+	struct tcp4_pseudohdr phdr = {
+		.saddr = saddr,
+		.daddr = daddr,
+		.pad = 0,
+		.protocol = IPPROTO_TCP,
+		.len = htons(nbytes)
+	};
+	return crypto_ahash_buf(pool->req, (u8 *)&phdr, sizeof(phdr));
+}
+
+static int tcp_authopt_hash_tcp6_pseudoheader(struct tcp_authopt_alg_pool *pool,
+					      struct in6_addr *saddr,
+					      struct in6_addr *daddr,
+					      u32 plen)
+{
+	int err;
+	__be32 buf[2];
+
+	buf[0] = htonl(plen);
+	buf[1] = htonl(IPPROTO_TCP);
+
+	err = crypto_ahash_buf(pool->req, (u8 *)saddr, sizeof(*saddr));
+	if (err)
+		return err;
+	err = crypto_ahash_buf(pool->req, (u8 *)daddr, sizeof(*daddr));
+	if (err)
+		return err;
+	return crypto_ahash_buf(pool->req, (u8 *)&buf, sizeof(buf));
+}
+
+/** Hash tcphdr options.
+ *
+ * If include_options is false then only the TCPOPT_AUTHOPT option itself is hashed
+ * Point to AO inside TH is passed by the caller
+ */
+static int tcp_authopt_hash_opts(struct tcp_authopt_alg_pool *pool,
+				 struct tcphdr *th,
+				 struct tcphdr_authopt *aoptr,
+				 bool include_options)
+{
+	int err;
+	/* start of options */
+	u8 *tcp_opts = (u8 *)(th + 1);
+	/* start of options */
+	u8 *aobuf = (u8 *)aoptr;
+	u8 aolen = aoptr->len;
+
+	if (WARN_ONCE(aoptr->num != TCPOPT_AUTHOPT, "Bad aoptr\n"))
+		return -EINVAL;
+
+	if (include_options) {
+		/* end of options */
+		u8 *tcp_data = ((u8 *)th) + th->doff * 4;
+
+		err = crypto_ahash_buf(pool->req, tcp_opts, aobuf - tcp_opts + 4);
+		if (err)
+			return err;
+		err = crypto_ahash_buf_zero(pool->req, aolen - 4);
+		if (err)
+			return err;
+		err = crypto_ahash_buf(pool->req, aobuf + aolen, tcp_data - (aobuf + aolen));
+		if (err)
+			return err;
+	} else {
+		err = crypto_ahash_buf(pool->req, aobuf, 4);
+		if (err)
+			return err;
+		err = crypto_ahash_buf_zero(pool->req, aolen - 4);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int tcp_authopt_hash_packet(struct tcp_authopt_alg_pool *pool,
+				   struct sock *sk,
+				   struct sk_buff *skb,
+				   struct tcphdr_authopt *aoptr,
+				   bool input,
+				   bool ipv6,
+				   bool include_options,
+				   u8 *macbuf)
+{
+	struct tcphdr *th = tcp_hdr(skb);
+	int err;
+
+	/* NOTE: SNE unimplemented */
+	__be32 sne = 0;
+
+	err = crypto_ahash_init(pool->req);
+	if (err)
+		return err;
+
+	err = crypto_ahash_buf(pool->req, (u8 *)&sne, 4);
+	if (err)
+		return err;
+
+	if (ipv6) {
+		struct in6_addr *saddr;
+		struct in6_addr *daddr;
+
+		if (input) {
+			saddr = &ipv6_hdr(skb)->saddr;
+			daddr = &ipv6_hdr(skb)->daddr;
+		} else {
+			saddr = &sk->sk_v6_rcv_saddr;
+			daddr = &sk->sk_v6_daddr;
+		}
+		err = tcp_authopt_hash_tcp6_pseudoheader(pool, saddr, daddr, skb->len);
+		if (err)
+			return err;
+	} else {
+		__be32 saddr;
+		__be32 daddr;
+
+		if (input) {
+			saddr = ip_hdr(skb)->saddr;
+			daddr = ip_hdr(skb)->daddr;
+		} else {
+			saddr = sk->sk_rcv_saddr;
+			daddr = sk->sk_daddr;
+		}
+		err = tcp_authopt_hash_tcp4_pseudoheader(pool, saddr, daddr, skb->len);
+		if (err)
+			return err;
+	}
+
+	// TCP header with checksum set to zero
+	{
+		struct tcphdr hashed_th = *th;
+
+		hashed_th.check = 0;
+		err = crypto_ahash_buf(pool->req, (u8 *)&hashed_th, sizeof(hashed_th));
+		if (err)
+			return err;
+	}
+
+	// TCP options
+	err = tcp_authopt_hash_opts(pool, th, aoptr, include_options);
+	if (err)
+		return err;
+
+	// Rest of SKB->data
+	err = tcp_sig_hash_skb_data(pool->req, skb, th->doff << 2);
+	if (err)
+		return err;
+
+	ahash_request_set_crypt(pool->req, NULL, macbuf, 0);
+	return crypto_ahash_final(pool->req);
+}
+
+/* __tcp_authopt_calc_mac - Compute packet MAC using key
+ *
+ * The macbuf output buffer must be large enough to fit the digestsize of the
+ * underlying transform before truncation.
+ * This means TCP_AUTHOPT_MAXMACBUF, not TCP_AUTHOPT_MACLEN
+ */
+static int __tcp_authopt_calc_mac(struct sock *sk,
+				  struct sk_buff *skb,
+				  struct tcphdr_authopt *aoptr,
+				  struct tcp_authopt_key_info *key,
+				  struct tcp_authopt_info *info,
+				  bool input,
+				  char *macbuf)
+{
+	struct tcp_authopt_alg_pool *mac_pool;
+	u8 traffic_key[TCP_AUTHOPT_MAX_TRAFFIC_KEY_LEN];
+	int err;
+	bool ipv6 = (sk->sk_family != AF_INET);
+
+	if (sk->sk_family != AF_INET && sk->sk_family != AF_INET6)
+		return -EINVAL;
+
+	err = tcp_authopt_get_traffic_key(sk, skb, key, info, input, ipv6, traffic_key);
+	if (err)
+		return err;
+
+	mac_pool = tcp_authopt_get_mac_pool(key);
+	if (IS_ERR(mac_pool))
+		return PTR_ERR(mac_pool);
+	err = crypto_ahash_setkey(mac_pool->tfm, traffic_key, key->alg->traffic_key_len);
+	if (err)
+		goto out;
+	err = crypto_ahash_init(mac_pool->req);
+	if (err)
+		return err;
+
+	err = tcp_authopt_hash_packet(mac_pool,
+				      sk,
+				      skb,
+				      aoptr,
+				      input,
+				      ipv6,
+				      !(key->flags & TCP_AUTHOPT_KEY_EXCLUDE_OPTS),
+				      macbuf);
+
+out:
+	tcp_authopt_put_mac_pool(key, mac_pool);
+	return err;
+}
+
 static int tcp_authopt_init_net(struct net *full_net)
 {
 	struct netns_tcp_authopt *net = &full_net->tcp_authopt;
 
 	mutex_init(&net->mutex);
-- 
2.25.1

