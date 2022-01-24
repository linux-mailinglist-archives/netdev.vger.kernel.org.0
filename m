Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC353497F19
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 13:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239357AbiAXMQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 07:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241071AbiAXMOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 07:14:20 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF56C06177D;
        Mon, 24 Jan 2022 04:13:59 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id o12so20805143eju.13;
        Mon, 24 Jan 2022 04:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mn408lO+pZH3mrHKxY73LKhzz0Csceev4QSmOp495H8=;
        b=aTuPbaSPKZvv8buEAdEPUME0jG8i3UrWZJoUxY6IPj93uSUn6UtEUOBlvoZBW+OUdc
         p6SCCOligO3SDhy7BfB8OYrfByZSLinZ60r97reiTtylpCGU6gCgHFaUAFjKL/b++EIc
         xMKeOpM0SXTiZsLGy/5o+jDD1kEuc3k1gSsj4ZA1jW0j7VjaAr8l5kYSE+bXWPEbCBWc
         Mm3AlEURQLP+0M5hZQBpZoT05fL7laggDV0cS5UiQt1SOawxzyQzbcPLmoIQ0WXitZ4D
         f5Cq2oWVqGoeXgl/WcqnkFVkO66FV9JiqPfH1TtJVSl9b8dN1xFZ41cpYFvvyRFX79w3
         Jl3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mn408lO+pZH3mrHKxY73LKhzz0Csceev4QSmOp495H8=;
        b=PcR7Qspm4ajm5bTw93CRZySVUw/Inb9uGj5X3B1jIbuRrS7DkeBeJ/MWj5i4D0Mn3B
         xkxD+vqri7FfRIG6D/oQ+QicIAYsz2bcVLLqQlPy7KnFz1/jKbrLpJDfaAPqza4wGNx1
         zXNNOYqVmddR+TD6dwxaQUqr6maSOETNOAzE4c9+rfmEy12ydvoPPS1nHOuKTI86Xwan
         oHFxLqvWQJxlhJBtjh0sdoxMWK80eQ57Y1/d9oq04exj8i1vCLqSBUJHtvIt89is/kqa
         XMdq7Sw/QSQ/NCpvnP8Q9Ui5EUJt7bETsswjYVS7r7T0QYGAx5B29dC1sh54RZbEaxNS
         yz5Q==
X-Gm-Message-State: AOAM533WLy2O8o5V1g53IljYpqYcJ73HcGquv9Uwih1Y+styoV+vJmmP
        ftnUoJYCUFgusYslhC8jWvQ=
X-Google-Smtp-Source: ABdhPJxZi/muDBSqalbc/t15r0dAPfU8smxQUbiMsQO1VRfwYeSMOp3AieK07BdoumjDMGt90sg9pw==
X-Received: by 2002:a17:907:3e96:: with SMTP id hs22mr3640399ejc.640.1643026438039;
        Mon, 24 Jan 2022 04:13:58 -0800 (PST)
Received: from ponky.lan ([2a04:241e:502:a09c:a21f:7a9f:9158:4a40])
        by smtp.gmail.com with ESMTPSA id b16sm4847517eja.211.2022.01.24.04.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 04:13:57 -0800 (PST)
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
Subject: [PATCH v5 20/20] tcp: authopt: Try to respect rnextkeyid from SYN on SYNACK
Date:   Mon, 24 Jan 2022 14:13:06 +0200
Message-Id: <2008e2c33acc60883ff41adc33158b63ec2d3acb.1643026076.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1643026076.git.cdleonard@gmail.com>
References: <cover.1643026076.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 497604176119..0c346c2c2145 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -95,10 +95,13 @@ struct tcp_options_received {
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
@@ -133,10 +136,13 @@ struct tcp_request_sock {
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
index 5ea93eb495f1..4b316488c805 100644
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
@@ -424,21 +426,33 @@ struct tcp_authopt_key_info *__tcp_authopt_select_key(const struct sock *sk,
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
index 91f1b04c1933..667da79df4ae 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4094,10 +4094,18 @@ void tcp_parse_options(const struct net *net,
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
@@ -6891,10 +6899,14 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
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

