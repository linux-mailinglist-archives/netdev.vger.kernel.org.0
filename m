Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E88A497F02
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 13:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242666AbiAXMO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 07:14:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239296AbiAXMOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 07:14:05 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58338C061765;
        Mon, 24 Jan 2022 04:13:40 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id p12so56231206edq.9;
        Mon, 24 Jan 2022 04:13:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U2mXf2WXVZ5apcoUUDJSkauSWrTBrA2j8Gq8gmjJmeg=;
        b=bWdNLPF4TA1eQYTMuRtBo+AEqLNxNqPbgt5q4jnHgoVoxhhpSVMolZ0RJhhmpewNe7
         Xx2gcZirTm6TCdTCAdAV3gnRjTJXaLlumKiNhpbsOSVXgLC0kQy+rcK1ycwE5gflC1mF
         vvxYKLvBcSb/JfA7kr7/U7EYDadCfHQSbKmAyBwzWf5o7VL/d3feamS/sFR0wATZYNzF
         izxE+Pt8iCmgi+nfmY/DxgUl2649XZ+5qxbNbV7vwjeLMKuzn7dkh1ZIW/WD9gULw5Il
         C+4ZO0DzsCj2jBl92O4ohYgWYrKHEb0gpokI/VwfRRBmfApvvEVksTAziFylMN8q7BHn
         x1Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U2mXf2WXVZ5apcoUUDJSkauSWrTBrA2j8Gq8gmjJmeg=;
        b=TCD9g6Ta1EBWpC3JzaFeGwzIoQi4pNgU+4RNTfFC80E8NDrvlyk+NDtBe4ZLzDWCOD
         MBGTzfdhPvThIjMgR9Ag8l1ugC1SuhJU3AlmDdFdgHTsDXPoamH9F7EL/f67PjUf/w9u
         WYPvuBLgdlS4duWPF8zYWOgOuXAwB4lCFsFoxMLAmDE9o4jhjhDEVRogUORDHBjqR//E
         mnt8gSQ1Q03ocCV5AXUfS5slwRlOiVsWvw6q4s+A846piLU7cBPvMoqRoKQNYyszqKMS
         4zKjBY2LLTHuw4DrKzO7zjhAh4PN7m1sI++Kabqx2tFzo7YLMRwSXZUzGybQrWeQ+tA8
         99+Q==
X-Gm-Message-State: AOAM532hXhGvk9kUHd9Shv0MspzAp4kBJNUY1a3IouJ2G7L2ksdh/TyR
        v0XKxsLvb0HP38R0KpEM91U=
X-Google-Smtp-Source: ABdhPJwgV8l2/TF4uh8xjJ5HtzISrof0XakjK9m8PdjcCeDt+bTUyyjV9QCxz9EyCdm4hvj+GbpSaw==
X-Received: by 2002:a05:6402:42d3:: with SMTP id i19mr13603965edc.52.1643026418779;
        Mon, 24 Jan 2022 04:13:38 -0800 (PST)
Received: from ponky.lan ([2a04:241e:502:a09c:a21f:7a9f:9158:4a40])
        by smtp.gmail.com with ESMTPSA id b16sm4847517eja.211.2022.01.24.04.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 04:13:38 -0800 (PST)
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
Subject: [PATCH v5 10/20] tcp: authopt: Add support for signing skb-less replies
Date:   Mon, 24 Jan 2022 14:12:56 +0200
Message-Id: <f2f3917cdecd858457831d3817a96eeca5fd53a2.1643026076.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1643026076.git.cdleonard@gmail.com>
References: <cover.1643026076.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is required because tcp ipv4 sometimes sends replies without
allocating a full skb that can be signed by tcp authopt.

Handle this with additional code in tcp authopt.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 include/net/tcp_authopt.h |   7 ++
 net/ipv4/tcp_authopt.c    | 144 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 151 insertions(+)

diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
index 6e9b5ca22f62..9ee5165388b1 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -115,10 +115,17 @@ static inline struct tcp_authopt_key_info *tcp_authopt_select_key(
 int tcp_authopt_hash(
 		char *hash_location,
 		struct tcp_authopt_key_info *key,
 		struct tcp_authopt_info *info,
 		struct sock *sk, struct sk_buff *skb);
+int tcp_v4_authopt_hash_reply(
+		char *hash_location,
+		struct tcp_authopt_info *info,
+		struct tcp_authopt_key_info *key,
+		__be32 saddr,
+		__be32 daddr,
+		struct tcphdr *th);
 int __tcp_authopt_openreq(struct sock *newsk, const struct sock *oldsk, struct request_sock *req);
 static inline int tcp_authopt_openreq(
 		struct sock *newsk,
 		const struct sock *oldsk,
 		struct request_sock *req)
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index 3c05b6c55191..7a2e15dd80ba 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -933,10 +933,72 @@ static int tcp_authopt_get_traffic_key(struct sock *sk,
 out:
 	tcp_authopt_put_kdf_pool(key, pool);
 	return err;
 }
 
+struct tcp_v4_authopt_context_data {
+	__be32 saddr;
+	__be32 daddr;
+	__be16 sport;
+	__be16 dport;
+	__be32 sisn;
+	__be32 disn;
+	__be16 digestbits;
+} __packed;
+
+static int tcp_v4_authopt_get_traffic_key_noskb(struct tcp_authopt_key_info *key,
+						__be32 saddr,
+						__be32 daddr,
+						__be16 sport,
+						__be16 dport,
+						__be32 sisn,
+						__be32 disn,
+						u8 *traffic_key)
+{
+	int err;
+	struct tcp_authopt_alg_pool *pool;
+	struct tcp_v4_authopt_context_data data;
+
+	BUILD_BUG_ON(sizeof(data) != 22);
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
+	// RFC5926 section 3.1.1.1
+	// Separate to keep alignment semi-sane
+	err = crypto_ahash_buf(pool->req, "\x01TCP-AO", 7);
+	if (err)
+		return err;
+	data.saddr = saddr;
+	data.daddr = daddr;
+	data.sport = sport;
+	data.dport = dport;
+	data.sisn = sisn;
+	data.disn = disn;
+	data.digestbits = htons(crypto_ahash_digestsize(pool->tfm) * 8);
+
+	err = crypto_ahash_buf(pool->req, (u8 *)&data, sizeof(data));
+	if (err)
+		goto out;
+	ahash_request_set_crypt(pool->req, NULL, traffic_key, 0);
+	err = crypto_ahash_final(pool->req);
+	if (err)
+		goto out;
+
+out:
+	tcp_authopt_put_kdf_pool(key, pool);
+	return err;
+}
+
 static int crypto_ahash_buf_zero(struct ahash_request *req, int len)
 {
 	u8 zeros[TCP_AUTHOPT_MACLEN] = {0};
 	int buflen, err;
 
@@ -1203,10 +1265,92 @@ int tcp_authopt_hash(char *hash_location,
 	return err;
 }
 EXPORT_SYMBOL(tcp_authopt_hash);
 
 /**
+ * tcp_v4_authopt_hash_reply - Hash tcp+ipv4 header without SKB
+ *
+ * @hash_location: output buffer
+ * @info: sending socket's tcp_authopt_info
+ * @key: signing key, from tcp_authopt_select_key.
+ * @saddr: source address
+ * @daddr: destination address
+ * @th: Pointer to TCP header and options
+ */
+int tcp_v4_authopt_hash_reply(char *hash_location,
+			      struct tcp_authopt_info *info,
+			      struct tcp_authopt_key_info *key,
+			      __be32 saddr,
+			      __be32 daddr,
+			      struct tcphdr *th)
+{
+	struct tcp_authopt_alg_pool *pool;
+	u8 macbuf[TCP_AUTHOPT_MAXMACBUF];
+	u8 traffic_key[TCP_AUTHOPT_MAX_TRAFFIC_KEY_LEN];
+	__be32 sne = 0;
+	int err;
+
+	/* Call special code path for computing traffic key without skb
+	 * This can be called from tcp_v4_reqsk_send_ack so caching would be
+	 * difficult here.
+	 */
+	err = tcp_v4_authopt_get_traffic_key_noskb(key, saddr, daddr,
+						   th->source, th->dest,
+						   htonl(info->src_isn), htonl(info->dst_isn),
+						   traffic_key);
+	if (err)
+		goto out_err_traffic_key;
+
+	/* Init mac shash */
+	pool = tcp_authopt_get_mac_pool(key);
+	if (IS_ERR(pool))
+		return PTR_ERR(pool);
+	err = crypto_ahash_setkey(pool->tfm, traffic_key, key->alg->traffic_key_len);
+	if (err)
+		goto out_err;
+	err = crypto_ahash_init(pool->req);
+	if (err)
+		return err;
+
+	err = crypto_ahash_buf(pool->req, (u8 *)&sne, 4);
+	if (err)
+		return err;
+
+	err = tcp_authopt_hash_tcp4_pseudoheader(pool, saddr, daddr, th->doff * 4);
+	if (err)
+		return err;
+
+	// TCP header with checksum set to zero. Caller ensures this.
+	if (WARN_ON_ONCE(th->check != 0))
+		goto out_err;
+	err = crypto_ahash_buf(pool->req, (u8 *)th, sizeof(*th));
+	if (err)
+		goto out_err;
+
+	// TCP options
+	err = tcp_authopt_hash_opts(pool, th, (struct tcphdr_authopt *)(hash_location - 4),
+				    !(key->flags & TCP_AUTHOPT_KEY_EXCLUDE_OPTS));
+	if (err)
+		goto out_err;
+
+	ahash_request_set_crypt(pool->req, NULL, macbuf, 0);
+	err = crypto_ahash_final(pool->req);
+	if (err)
+		goto out_err;
+	memcpy(hash_location, macbuf, TCP_AUTHOPT_MACLEN);
+
+	tcp_authopt_put_mac_pool(key, pool);
+	return 0;
+
+out_err:
+	tcp_authopt_put_mac_pool(key, pool);
+out_err_traffic_key:
+	memset(hash_location, 0, TCP_AUTHOPT_MACLEN);
+	return err;
+}
+
+/*
  * tcp_authopt_lookup_recv - lookup key for receive
  *
  * @sk: Receive socket
  * @skb: Packet, used to compare addr and iface
  * @net: Per-namespace information containing keys
-- 
2.25.1

