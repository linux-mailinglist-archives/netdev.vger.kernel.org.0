Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C032C580B5C
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 08:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237845AbiGZGSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 02:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbiGZGRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 02:17:08 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A52DF53;
        Mon, 25 Jul 2022 23:16:02 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id c72so13618789edf.8;
        Mon, 25 Jul 2022 23:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KU59swmo/I3OH2xUFCnRP0du6LBX/Oj+pYHId7St1eI=;
        b=TvgNbdMKyy86uZmXhxD01oYDxravCjoFmDy36Eoag5psvw/TWZBCbS+cuGqCsG5mEC
         UztBZU8I1R1uuhEu9JL3f+/vV3aVmXRoQLsVRyVNAfE/ae4HRruecmMe4T9FwFJWNE0B
         hlvrkfSNkdSNxRQx9TB/HsOrgW8N8g6rrNYPHlGFfpA7Cwic2Yogk2X/IZyRT2kLYTr5
         niZD7rejUyuJSR2sdjnwNaQDynX6srEKb/BcGM8nkA3CEnW45Ewbm2kyJ9jVFAbrP2OO
         ROyrQEAFY2KitMlG33DMM8sVCLGZwZziNutY7Q8+rRUYMHmPidkrIHoq+k1RYTEkFmC9
         MIyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KU59swmo/I3OH2xUFCnRP0du6LBX/Oj+pYHId7St1eI=;
        b=LQpCf9v+Fkpm7GLx0yjuMAtEYmi7jmAARXbbNySo62vq8kHFReJomfP1be6OOAGBqc
         26gpJVIXLC0aNnliPtOgHuUX4Kn7533ooltjdNI1HNvrUOpycRwQgw7Ze5RUYpKiUVmi
         TY2Z1GCVeZwD3zyJ7EmZCnXpveiAyweMRrFsFsQ9oy5KpxCXSMMrsvfgMD3UDUpa7UP3
         u61gnDKu3APQsuGNxVtwgiFnQyLDjvnYrrxTlwxbMvD52WnuG2pg8xcfXukfybBRly6o
         +088fi2g+/fHSMDpJ7GcXrSewthlDCdERREV1OhnKQGvJLYDPQbSdLq75w0SZX0demcb
         pQ7Q==
X-Gm-Message-State: AJIora8bXoGDdnAC7yUaA1IZjj61BLm4cnZAtU97nb7OyDa5sPv/jRBn
        V2BOEos8+H+NQvpLEs8W620=
X-Google-Smtp-Source: AGRyM1tHvOiCGpHixXKtO7jIElB1KTcBaUlAUYCAn8mzNIr5txAx/Do/nLGuDDb06OlpfDGVIniSGg==
X-Received: by 2002:a05:6402:909:b0:435:a8b:5232 with SMTP id g9-20020a056402090900b004350a8b5232mr16832230edz.240.1658816160782;
        Mon, 25 Jul 2022 23:16:00 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:2b68:36a:5a94:4ba1])
        by smtp.gmail.com with ESMTPSA id l23-20020a056402345700b0043ba7df7a42sm8133067edc.26.2022.07.25.23.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 23:16:00 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
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
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 12/26] tcp: authopt: Add support for signing skb-less replies
Date:   Tue, 26 Jul 2022 09:15:14 +0300
Message-Id: <56095a3aeb4ce619736cbb25c93e32a99d063488.1658815925.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1658815925.git.cdleonard@gmail.com>
References: <cover.1658815925.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index 1fa1b968c80c..9bc0f58a78cb 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -114,10 +114,17 @@ static inline struct tcp_authopt_key_info *tcp_authopt_select_key(
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
index 2a216356d280..2af6265041b4 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -944,10 +944,72 @@ static int tcp_authopt_get_traffic_key(struct sock *sk,
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
 
@@ -1214,10 +1276,92 @@ int tcp_authopt_hash(char *hash_location,
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

