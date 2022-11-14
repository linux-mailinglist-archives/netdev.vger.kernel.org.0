Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC5A062890F
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 20:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237161AbiKNTQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 14:16:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237071AbiKNTQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 14:16:24 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB0426AF6
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 11:16:23 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id s5so2528947edc.12
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 11:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7GZ7mdKRxSmNzZk248APL9GVltHD1aGTMmJ3HYRAqIU=;
        b=GoluzNb+LAr29/2n3WnpatuY1/8sy1ptYyHh29nBg1TcI5ffSS55OWvYH2Z2UZ4sBj
         AsfBPOqKivOl1vOwB1dPlNbUt6JlJQtWYmH6tRKd59BAP59aej7Gei4jseJjYj2DfiyM
         OJN2iOWeMPlANFVx113TqgaW2SH7p8V+PSaeE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7GZ7mdKRxSmNzZk248APL9GVltHD1aGTMmJ3HYRAqIU=;
        b=EIKix8yZrs/2JBr3jHnBawK7X+mMvle2R4ipxKPOtug0yo5ChkeumziCILyieVQ6eC
         QTwfaTef0oyHia6iobN3yJmTtD1KF/kOTkwai4gR8XaXLJgP/TNlJ5UNNhtaVkhZX4qh
         nXa7IAXuyXUd45vtQ0AaSe2JxgG0LfREyB/yZyj1K6fTME4n2Gkj/g4FgjUIFIV7I9PC
         v6ws0rPYPLFq9zJ9yw84JlLjwIcTjnAPlgJWPIiMu8lLmd64Q0a3J8gjaXUkgjk9ohjl
         eMGYg5BbZqnvB663eNuFltDF8ujZAtJ7WHiec8eDyNekZeracgwpdnc2WHodILgH8781
         r3DA==
X-Gm-Message-State: ANoB5pn8lF/epkoC75UxeKJX2I9T3it4OPtDafC2KZ4hfexqiWJZWXha
        X7LSh+zdZqOUAET6gIOtqtLiWJWuDeaMWg==
X-Google-Smtp-Source: AA0mqf72+G1Fm7cD526FPk8x053g7O2PyVF5GGOOAvDIADQT80qufQz4pjACVQO1NQ8dE97VSK62Aw==
X-Received: by 2002:a05:6402:7da:b0:466:4168:6ea7 with SMTP id u26-20020a05640207da00b0046641686ea7mr11807928edy.273.1668453381363;
        Mon, 14 Nov 2022 11:16:21 -0800 (PST)
Received: from cloudflare.com (79.184.204.15.ipv4.supernova.orange.pl. [79.184.204.15])
        by smtp.gmail.com with ESMTPSA id w25-20020aa7da59000000b00463bc1ddc76sm5100523eds.28.2022.11.14.11.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 11:16:21 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tom Parkin <tparkin@katalix.com>,
        Haowei Yan <g1042620637@gmail.com>
Subject: [PATCH net v4] l2tp: Serialize access to sk_user_data with sk_callback_lock
Date:   Mon, 14 Nov 2022 20:16:19 +0100
Message-Id: <20221114191619.124659-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sk->sk_user_data has multiple users, which are not compatible with each
other. Writers must synchronize by grabbing the sk->sk_callback_lock.

l2tp currently fails to grab the lock when modifying the underlying tunnel
socket fields. Fix it by adding appropriate locking.

We err on the side of safety and grab the sk_callback_lock also inside the
sk_destruct callback overridden by l2tp, even though there should be no
refs allowing access to the sock at the time when sk_destruct gets called.

v4:
- serialize write to sk_user_data in l2tp sk_destruct

v3:
- switch from sock lock to sk_callback_lock
- document write-protection for sk_user_data

v2:
- update Fixes to point to origin of the bug
- use real names in Reported/Tested-by tags

Cc: Tom Parkin <tparkin@katalix.com>
Fixes: 3557baabf280 ("[L2TP]: PPP over L2TP driver core")
Reported-by: Haowei Yan <g1042620637@gmail.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---

This took me forever. Sorry about that.

 include/net/sock.h   |  2 +-
 net/l2tp/l2tp_core.c | 19 +++++++++++++------
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 5db02546941c..e0517ecc6531 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -323,7 +323,7 @@ struct sk_filter;
   *	@sk_tskey: counter to disambiguate concurrent tstamp requests
   *	@sk_zckey: counter to order MSG_ZEROCOPY notifications
   *	@sk_socket: Identd and reporting IO signals
-  *	@sk_user_data: RPC layer private data
+  *	@sk_user_data: RPC layer private data. Write-protected by @sk_callback_lock.
   *	@sk_frag: cached page frag
   *	@sk_peek_off: current peek_offset value
   *	@sk_send_head: front of stuff to transmit
diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 7499c51b1850..754fdda8a5f5 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1150,8 +1150,10 @@ static void l2tp_tunnel_destruct(struct sock *sk)
 	}
 
 	/* Remove hooks into tunnel socket */
+	write_lock_bh(&sk->sk_callback_lock);
 	sk->sk_destruct = tunnel->old_sk_destruct;
 	sk->sk_user_data = NULL;
+	write_unlock_bh(&sk->sk_callback_lock);
 
 	/* Call the original destructor */
 	if (sk->sk_destruct)
@@ -1469,16 +1471,18 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 		sock = sockfd_lookup(tunnel->fd, &ret);
 		if (!sock)
 			goto err;
-
-		ret = l2tp_validate_socket(sock->sk, net, tunnel->encap);
-		if (ret < 0)
-			goto err_sock;
 	}
 
+	sk = sock->sk;
+	write_lock(&sk->sk_callback_lock);
+
+	ret = l2tp_validate_socket(sk, net, tunnel->encap);
+	if (ret < 0)
+		goto err_sock;
+
 	tunnel->l2tp_net = net;
 	pn = l2tp_pernet(net);
 
-	sk = sock->sk;
 	sock_hold(sk);
 	tunnel->sock = sk;
 
@@ -1504,7 +1508,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 
 		setup_udp_tunnel_sock(net, sock, &udp_cfg);
 	} else {
-		sk->sk_user_data = tunnel;
+		rcu_assign_sk_user_data(sk, tunnel);
 	}
 
 	tunnel->old_sk_destruct = sk->sk_destruct;
@@ -1518,6 +1522,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 	if (tunnel->fd >= 0)
 		sockfd_put(sock);
 
+	write_unlock(&sk->sk_callback_lock);
 	return 0;
 
 err_sock:
@@ -1525,6 +1530,8 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 		sock_release(sock);
 	else
 		sockfd_put(sock);
+
+	write_unlock(&sk->sk_callback_lock);
 err:
 	return ret;
 }
-- 
2.38.1

