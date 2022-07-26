Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04F29580B7B
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 08:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238024AbiGZGVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 02:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237897AbiGZGTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 02:19:05 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455712A975;
        Mon, 25 Jul 2022 23:16:35 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id x91so16533318ede.1;
        Mon, 25 Jul 2022 23:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kVRZdxuJ9ycX3epDnPg5nrSBdofilV3G70rXJN3b0KQ=;
        b=kmxy22CHBpjXpAPy4VXO03WMeRIxdnXe0dn2nZZ99jQmMns3CU804GJTf/KXaKfoB5
         wHn1kb2eBX8hEP/0CpeA0uOzGRu/ZDTgpMVTyFmmkf+ebHVPhL/sv7wtVhtVXTK3UFyX
         ve3KoyPIH2LskNXYN3o1g0ortjJhZ4feMSYKjt8fhIkamRneOdWRaZCDVklNEBOjfWDu
         6+8vxOwHhnQ8qrOJb8+ZF7RNoUVpATL7Zwje3paWOzZbpYCkjtBb3c12DJsOzpuBdBww
         ALEwbJdOkZ0ab8fszyjzvoSZSq76ftQjbkQGJo6UVxtiDwIDRNvqW3qclOhMlFHA7k8Y
         kpwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kVRZdxuJ9ycX3epDnPg5nrSBdofilV3G70rXJN3b0KQ=;
        b=0tTR8xmjKEj7ivXaWvRA4fy8M/7NRSop44jssApDX6vAFX2fJubCAEBWwSMSVdfTQJ
         KK2H/1G6JOKKjbgJi6OIgjEu0b+VHh76JnPe5YBalheeMTX016RcZ/BQtv5PamYGzvpG
         mteAkQQdKwp9qPe0S3nwQdDFu/CSjHB7+ZeDuw1VPrHIc5+6RQUVq8/i7j5jCXRxXlHA
         OZTZMqXJMeSoQYRfJo5gKQTM7JTJTK+y++ULRWXcdW55ZjEWtyBkwOLs3kUduXADbuTF
         MiTW/v/D3No4kfDPzKWPfLLfMScype6x4Vryp1FuzEmxHovA55Ckrp9AUdAVCe6f3xdo
         YhBg==
X-Gm-Message-State: AJIora9JH425qhhz5nhUPgbrCRTpaS81w18AZYRZUn0KXb4yysfLu4VH
        olLQqCzEO/3o4NoPzhBWptUAaybl0DZT9g==
X-Google-Smtp-Source: AGRyM1t8TsoBy85dJWLHWS7wjzqAv4uT8oQ/dMWQ80ZGJ3O1yXkm8Ta0emAegg+7H36zItDRbXSKNA==
X-Received: by 2002:aa7:c0d0:0:b0:43b:b6d5:2977 with SMTP id j16-20020aa7c0d0000000b0043bb6d52977mr16764435edp.199.1658816185449;
        Mon, 25 Jul 2022 23:16:25 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:2b68:36a:5a94:4ba1])
        by smtp.gmail.com with ESMTPSA id l23-20020a056402345700b0043ba7df7a42sm8133067edc.26.2022.07.25.23.16.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 23:16:25 -0700 (PDT)
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
Subject: [PATCH v6 25/26] tcp: authopt: If no keys are valid for send report an error
Date:   Tue, 26 Jul 2022 09:15:27 +0300
Message-Id: <09b6b75d04cf4a439cf84a6d50dcf641c9d727bc.1658815925.git.cdleonard@gmail.com>
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

If this is not treated specially then when all keys are removed or
expired then TCP will start sending unsigned packets which is
undesirable. Instead try to report an error on key selection and
propagate it to userspace.

The error is assigned to sk_err and propagate it as soon as possible.
In theory we could try to make the error "soft" and even let the
connection continue if userspace adds a new key but the advantages are
unclear.

Since userspace is responsible for managing keys it can also avoid
sending unsigned packets by always closing the socket before removing
the active last key.

The specific error reported is ENOKEY.

This requires changes inside TCP option write code to support aborting
the actual packet send, until this point this did not happen in any
scenario.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 net/ipv4/tcp_authopt.c |  9 +++++++--
 net/ipv4/tcp_output.c  | 20 ++++++++++++++++++++
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index e162e5944ec5..c71f5ed5ca1d 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -439,10 +439,11 @@ struct tcp_authopt_key_info *__tcp_authopt_select_key(const struct sock *sk,
 						      u8 *rnextkeyid,
 						      bool locked)
 {
 	struct tcp_authopt_key_info *key, *new_key = NULL;
 	struct netns_tcp_authopt *net = sock_net_tcp_authopt(sk);
+	bool anykey = false;
 
 	/* Listen sockets don't refer to any specific connection so we don't try
 	 * to keep using the same key.
 	 * The rnextkeyid is stored in tcp_request_sock
 	 */
@@ -461,11 +462,13 @@ struct tcp_authopt_key_info *__tcp_authopt_select_key(const struct sock *sk,
 		else
 			send_id = rsk->recv_rnextkeyid;
 		key = tcp_authopt_lookup_send(net, addr_sk, send_id, NULL);
 		/* If no key found with specific send_id try anything else. */
 		if (!key)
-			key = tcp_authopt_lookup_send(net, addr_sk, -1, NULL);
+			key = tcp_authopt_lookup_send(net, addr_sk, -1, &anykey);
+		if (!key && anykey)
+			return ERR_PTR(-ENOKEY);
 		if (key)
 			*rnextkeyid = key->recv_id;
 		return key;
 	}
 
@@ -497,11 +500,13 @@ struct tcp_authopt_key_info *__tcp_authopt_select_key(const struct sock *sk,
 							  info->recv_rnextkeyid,
 							  NULL);
 	}
 	/* If no key found with specific send_id try anything else. */
 	if (!key && !new_key)
-		new_key = tcp_authopt_lookup_send(net, addr_sk, -1, NULL);
+		new_key = tcp_authopt_lookup_send(net, addr_sk, -1, &anykey);
+	if (!new_key && anykey)
+		return ERR_PTR(-ENOKEY);
 
 	/* Update current key only if we hold the socket lock. */
 	if (new_key && key != new_key) {
 		if (locked) {
 			if (kref_get_unless_zero(&new_key->ref)) {
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 0ab3c7801f33..b8dab313af0f 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -414,10 +414,11 @@ static inline bool tcp_urg_mode(const struct tcp_sock *tp)
 #define OPTION_SACK_ADVERTISE	BIT(0)
 #define OPTION_TS		BIT(1)
 #define OPTION_MD5		BIT(2)
 #define OPTION_WSCALE		BIT(3)
 #define OPTION_AUTHOPT		BIT(4)
+#define OPTION_AUTHOPT_FAIL	BIT(5)
 #define OPTION_FAST_OPEN_COOKIE	BIT(8)
 #define OPTION_SMC		BIT(9)
 #define OPTION_MPTCP		BIT(10)
 
 static void smc_options_write(__be32 *ptr, u16 *options)
@@ -786,10 +787,14 @@ static int tcp_authopt_init_options(const struct sock *sk,
 {
 #ifdef CONFIG_TCP_AUTHOPT
 	struct tcp_authopt_key_info *key;
 
 	key = tcp_authopt_select_key(sk, addr_sk, &opts->authopt_info, &opts->authopt_rnextkeyid);
+	if (IS_ERR(key)) {
+		opts->options |= OPTION_AUTHOPT_FAIL;
+		return TCPOLEN_AUTHOPT_OUTPUT;
+	}
 	if (key) {
 		opts->options |= OPTION_AUTHOPT;
 		opts->authopt_key = key;
 		return TCPOLEN_AUTHOPT_OUTPUT;
 	}
@@ -1345,10 +1350,18 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 		 * release the following packet.
 		 */
 		if (tcp_skb_pcount(skb) > 1)
 			tcb->tcp_flags |= TCPHDR_PSH;
 	}
+#ifdef CONFIG_TCP_AUTHOPT
+	if (opts.options & OPTION_AUTHOPT_FAIL) {
+		rcu_read_unlock();
+		sk->sk_err = ENOKEY;
+		sk_error_report(sk);
+		return -ENOKEY;
+	}
+#endif
 	tcp_header_size = tcp_options_size + sizeof(struct tcphdr);
 
 	/* if no packet is in qdisc/device queue, then allow XPS to select
 	 * another queue. We can be called from tcp_tsq_handler()
 	 * which holds one reference to sk.
@@ -3655,10 +3668,17 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 	/* bpf program will be interested in the tcp_flags */
 	TCP_SKB_CB(skb)->tcp_flags = TCPHDR_SYN | TCPHDR_ACK;
 	tcp_header_size = tcp_synack_options(sk, req, mss, skb, &opts, md5,
 					     foc, synack_type,
 					     syn_skb) + sizeof(*th);
+#ifdef CONFIG_TCP_AUTHOPT
+	if (opts.options & OPTION_AUTHOPT_FAIL) {
+		rcu_read_unlock();
+		kfree_skb(skb);
+		return NULL;
+	}
+#endif
 
 	skb_push(skb, tcp_header_size);
 	skb_reset_transport_header(skb);
 
 	th = (struct tcphdr *)skb->data;
-- 
2.25.1

