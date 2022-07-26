Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE7D4580B7E
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 08:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238007AbiGZGVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 02:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237876AbiGZGTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 02:19:02 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80BD52AC6C;
        Mon, 25 Jul 2022 23:16:33 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id bp15so24335242ejb.6;
        Mon, 25 Jul 2022 23:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S4DUuYpKzwf7eBOnbcUPrzqVk85dVnPEW6r8J1HvlEo=;
        b=Jw0bdMaoBc1WkLLthUFvU4M0Y0S8hE/OvPlwnsOo3XqqE7bFkxVwTWcCvtC1LrpiAN
         6U7uv+FiAhuef9bIIKnaBou1Zl0V+R0ge1QPzzQqhxY6Cyz0Ck7dgEjdbFr3GL7pKqNw
         KcYnLVOylMxMPbOChwOAZG6nQiFBX4BwKjDzeFBjqhKGDkOuoBcSiIL1/MOrxT0wcLNb
         9X9O4mYvsacdj0+/IGBBdvHa9dneyL2xDlCsthgK2oARvnSEp5EmiPXwzOU1Z+PjDRtg
         f2LnPB/tnh8fzH7rW0rOz2QnuJ+Ub7ydsj1XQrhGUx82mpc3PmUKebD0oowpsT6qTa1q
         vMPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S4DUuYpKzwf7eBOnbcUPrzqVk85dVnPEW6r8J1HvlEo=;
        b=7WvD9UI24XuqCABzMYGAgVuJE5xfzw8jPAZQGTUBgk4u6zFclGZPDDrC6ZEArJQ3El
         WX9bhG07UXveAiSNbY06YxQ5ZnqI8K1sZ3aOLF4ajJSdp4f3Xgtbw8LLd6XsB4s7cOi9
         6T3zh2PrsVvI0gTBali8Wq1ymr9jwCbHjtYGErzUhtZAgDH3QWqVpLz8Fekg/nW7z9VU
         jdzWlDsa8L99vN2muhhIYQccnL34O4Cfw38SUw7ohbjsm46DV2p5QvVxpkIMV4+POxeN
         NhAUI4QhQgkal7Rg5q7qIRH1O3XimsH9fQYKAw5M7XggkB4YIbQW3eTXg5yfRj3JcXNh
         usjg==
X-Gm-Message-State: AJIora9xLjFM+PGPtLovKWZG1kz3leoRkzD16x1wnSVmPT7LGc2USZs6
        39bxjmfVACxr9bkvEivhxSM=
X-Google-Smtp-Source: AGRyM1ttmapPLFQMDOmqfXGj5RL6D9LSHB1WCPEOK0dZAi1Er4/fJMRIU4FO10Y8RY7+TfzLCvpyNA==
X-Received: by 2002:a17:907:a06e:b0:72b:2cba:da35 with SMTP id ia14-20020a170907a06e00b0072b2cbada35mr12843379ejc.358.1658816179949;
        Mon, 25 Jul 2022 23:16:19 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:2b68:36a:5a94:4ba1])
        by smtp.gmail.com with ESMTPSA id l23-20020a056402345700b0043ba7df7a42sm8133067edc.26.2022.07.25.23.16.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 23:16:19 -0700 (PDT)
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
Subject: [PATCH v6 22/26] tcp: authopt: Try to respect rnextkeyid from SYN on SYNACK
Date:   Tue, 26 Jul 2022 09:15:24 +0300
Message-Id: <c91e0c713650f24dc31924034189990b4ef2970f.1658815925.git.cdleonard@gmail.com>
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

According to the RFC we should use the key that the peer suggests via
rnextkeyid.

This is currently done by storing recv_rnextkeyid in tcp_authopt_info
but this does not work for the SYNACK case because the tcp_request_sock
does not hold an info pointer for reasons of memory usage.

Handle this by storing recv_rnextkeyid inside tcp_request_sock. This
doesn't increase the memory usage because there are unused bytes at the
end.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 include/linux/tcp.h    |  6 ++++++
 net/ipv4/tcp_authopt.c | 26 ++++++++++++++++++++------
 net/ipv4/tcp_input.c   | 12 ++++++++++++
 3 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 551942883f06..6a4ff0ed55c6 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -125,10 +125,13 @@ struct tcp_options_received {
 	u8	saw_unknown:1,	/* Received unknown option		*/
 		unused:7;
 	u8	num_sacks;	/* Number of SACK blocks		*/
 	u16	user_mss;	/* mss requested by user in ioctl	*/
 	u16	mss_clamp;	/* Maximal mss, negotiated at connection setup */
+#if IS_ENABLED(CONFIG_TCP_AUTHOPT)
+	u8	rnextkeyid;
+#endif
 };
 
 static inline void tcp_clear_options(struct tcp_options_received *rx_opt)
 {
 	rx_opt->tstamp_ok = rx_opt->sack_ok = 0;
@@ -163,10 +166,13 @@ struct tcp_request_sock {
 	u32				rcv_nxt; /* the ack # by SYNACK. For
 						  * FastOpen it's the seq#
 						  * after data-in-SYN.
 						  */
 	u8				syn_tos;
+#if IS_ENABLED(CONFIG_TCP_AUTHOPT)
+	u8				recv_rnextkeyid;
+#endif
 };
 
 static inline struct tcp_request_sock *tcp_rsk(const struct request_sock *req)
 {
 	return (struct tcp_request_sock *)req;
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index 00d749aa1025..3596fc1fb770 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -1,7 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
+#include "linux/tcp.h"
+#include "net/tcp_states.h"
 #include <net/tcp_authopt.h>
 #include <net/ip.h>
 #include <net/ipv6.h>
 #include <net/tcp.h>
 #include <linux/kref.h>
@@ -435,21 +437,33 @@ struct tcp_authopt_key_info *__tcp_authopt_select_key(const struct sock *sk,
 {
 	struct tcp_authopt_key_info *key, *new_key = NULL;
 	struct netns_tcp_authopt *net = sock_net_tcp_authopt(sk);
 
 	/* Listen sockets don't refer to any specific connection so we don't try
-	 * to keep using the same key and ignore any received keyids.
+	 * to keep using the same key.
+	 * The rnextkeyid is stored in tcp_request_sock
 	 */
 	if (sk->sk_state == TCP_LISTEN) {
-		int send_keyid = -1;
-
+		int send_id = -1;
+		struct tcp_request_sock *rsk;
+
+		if (WARN_ONCE(addr_sk->sk_state != TCP_NEW_SYN_RECV, "bad socket state"))
+			return NULL;
+		rsk = tcp_rsk((struct request_sock *)addr_sk);
+		/* Forcing a specific send_keyid on a listen socket forces it for
+		 * all clients so is unlikely to be useful.
+		 */
 		if (info->flags & TCP_AUTHOPT_FLAG_LOCK_KEYID)
-			send_keyid = info->send_keyid;
-		key = tcp_authopt_lookup_send(net, addr_sk, send_keyid);
+			send_id = info->send_keyid;
+		else
+			send_id = rsk->recv_rnextkeyid;
+		key = tcp_authopt_lookup_send(net, addr_sk, send_id);
+		/* If no key found with specific send_id try anything else. */
+		if (!key)
+			key = tcp_authopt_lookup_send(net, addr_sk, -1);
 		if (key)
 			*rnextkeyid = key->recv_id;
-
 		return key;
 	}
 
 	if (locked) {
 		sock_owned_by_me(sk);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index c09d42614b2b..6f2af45f4271 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4105,10 +4105,18 @@ void tcp_parse_options(const struct net *net,
 				/*
 				 * The MD5 Hash has already been
 				 * checked (see tcp_v{4,6}_do_rcv()).
 				 */
 				break;
+#endif
+#ifdef CONFIG_TCP_AUTHOPT
+			case TCPOPT_AUTHOPT:
+				/* Hash has already been checked.
+				 * We parse rnextkeyid here so we can match it on synack
+				 */
+				opt_rx->rnextkeyid = ptr[1];
+				break;
 #endif
 			case TCPOPT_FASTOPEN:
 				tcp_parse_fastopen_option(
 					opsize - TCPOLEN_FASTOPEN_BASE,
 					ptr, th->syn, foc, false);
@@ -6958,10 +6966,14 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 		tcp_clear_options(&tmp_opt);
 
 	if (IS_ENABLED(CONFIG_SMC) && want_cookie)
 		tmp_opt.smc_ok = 0;
 
+#if IS_ENABLED(CONFIG_TCP_AUTHOPT)
+	tcp_rsk(req)->recv_rnextkeyid = tmp_opt.rnextkeyid;
+#endif
+
 	tmp_opt.tstamp_ok = tmp_opt.saw_tstamp;
 	tcp_openreq_init(req, &tmp_opt, skb, sk);
 	inet_rsk(req)->no_srccheck = inet_sk(sk)->transparent;
 
 	/* Note: tcp_v6_init_req() might override ir_iif for link locals */
-- 
2.25.1

