Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D501C59E459
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 15:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241115AbiHWNQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 09:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241096AbiHWNQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 09:16:36 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E14C13AE2B
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 03:16:11 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id u15so17760752ejt.6
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 03:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=eMk+twlir2eVUASRRwXBQjosMuWVOAOPQBd//R3L8/U=;
        b=t13fc5IUHYIPirhSL0CBsNgt75N57kl6yEWJxWjpr6wt3ZFlnBHFR6SReN3ep1vlog
         L2gQl13FjM+KIzghAhW//DN7g1X5f/ZIpG+kMih8zpgKhEyzBm/ZPGzuuNpULkgb4dnO
         fUb7tRttmsR70eVfvU3NdOSJIjZPIKzTp5wh8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=eMk+twlir2eVUASRRwXBQjosMuWVOAOPQBd//R3L8/U=;
        b=fkEGBFuxt3PiHpk+GUcCaF7Mc7CPqveNVHulikvFvaZ60JX5bXffgr+zNnpAIHUSp2
         ErszrfgTf6U8/5XEnLOH8IzJ08ULbkUHfWEreIstbui9E+GmiKvJAWJmTlXARznA7DBq
         6l5YNYcAvem6Kj7zV7DMttIUejCLAdp78L/71Wt0/e+LyFs+YOoOMTVRmrt1rA5BLDQb
         zX+TALDRAQEKeLIMCgR1q3gZCmsagcDjFiFvx+eRyQWz64OEBdpYa/uGFxwF0X1b7vVC
         zcgJMMQhDlARcA6ht6oQas7V6Vgoy93TBcC0WGL/z/0PkJyBcZDdZNPyAvt0qu8CvIkW
         a/zA==
X-Gm-Message-State: ACgBeo2tu0iGUTSjjnID8X/j2gIdyJd9PRDSfd/SyMoCquQKkcVQYsv7
        qzFDQR7jXUVeEILgZbdOg+oRXoOqMOJu0w==
X-Google-Smtp-Source: AA6agR5AZlRcMUg3t0qhv8ilu3q673iNJCCBsTM1ZXKSaiymyYVMJ7kF2HhO86wSsMRuda2i0KLbEw==
X-Received: by 2002:a17:907:72d0:b0:734:b451:c8d9 with SMTP id du16-20020a17090772d000b00734b451c8d9mr15675451ejc.272.1661249701463;
        Tue, 23 Aug 2022 03:15:01 -0700 (PDT)
Received: from cloudflare.com (79.191.57.8.ipv4.supernova.orange.pl. [79.191.57.8])
        by smtp.gmail.com with ESMTPSA id q1-20020a17090676c100b0073d6dd74152sm3799735ejn.200.2022.08.23.03.15.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 03:15:01 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     kernel-team@cloudflare.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tom Parkin <tparkin@katalix.com>,
        Haowei Yan <g1042620637@gmail.com>
Subject: [PATCH net v3] l2tp: Serialize access to sk_user_data with sk_callback_lock
Date:   Tue, 23 Aug 2022 12:14:59 +0200
Message-Id: <20220823101459.211986-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sk->sk_user_data has multiple users, which are not compatible with each
other. Writers must synchronize by grabbing the sk->sk_callback_lock.

l2tp currently fails to grab the lock when modifying the underlying tunnel
socket. Fix it by adding appropriate locking.

We don't to grab the lock when l2tp clears sk_user_data, because it happens
only in sk->sk_destruct, when the sock is going away.

v3:
- switch from sock lock to sk_callback_lock
- document write-protection for sk_user_data

v2:
- update Fixes to point to origin of the bug
- use real names in Reported/Tested-by tags

Fixes: 3557baabf280 ("[L2TP]: PPP over L2TP driver core")
Reported-by: Haowei Yan <g1042620637@gmail.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/net/sock.h   |  2 +-
 net/l2tp/l2tp_core.c | 17 +++++++++++------
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index d08cfe190a78..601c48601496 100644
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
index 7499c51b1850..429ad9633f13 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1469,16 +1469,18 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
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
 
@@ -1504,7 +1506,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 
 		setup_udp_tunnel_sock(net, sock, &udp_cfg);
 	} else {
-		sk->sk_user_data = tunnel;
+		rcu_assign_sk_user_data(sk, tunnel);
 	}
 
 	tunnel->old_sk_destruct = sk->sk_destruct;
@@ -1518,6 +1520,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 	if (tunnel->fd >= 0)
 		sockfd_put(sock);
 
+	write_unlock(&sk->sk_callback_lock);
 	return 0;
 
 err_sock:
@@ -1525,6 +1528,8 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 		sock_release(sock);
 	else
 		sockfd_put(sock);
+
+	write_unlock(&sk->sk_callback_lock);
 err:
 	return ret;
 }
-- 
2.37.1

