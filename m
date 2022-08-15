Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 989B6592F48
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 15:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbiHONBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 09:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbiHONBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 09:01:12 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6158026FC
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 06:01:10 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id z20so9453791edb.9
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 06:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=fjK2leRA/Z+0RAypc9miKHurUgiJpR3ekCYEP/m7tNQ=;
        b=ibO0Jxi+TEWmQ69PdQtbNjD08NWUthTFdVLjoMnkb0O38OeL/NSpNQ5uNrmSckkwo1
         4Uf1frbllr+KFgWEVle2vwuqqteLi+cZL1XirWAntVXa0sAWEuTETR7PZFYuQLWoukiu
         VtEb25QssrU3dtfQCFtyG1IPVpecGKqJiExb8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=fjK2leRA/Z+0RAypc9miKHurUgiJpR3ekCYEP/m7tNQ=;
        b=LHj1cQWJvaGrjfk7YAQODYWxttBcYoe+qEs8lG9RSARib1aAkSknSEPa4b9UEPnXNC
         /ZtqOLeJfdquyZFFiaPPcZw2JGa7eBU1e8q5UW7+cYCfU/KnTxwZwKXOdbz88J7TLl7j
         z/j8T3pUdkCVX6uxVaydNjzOVj+orSvbDVhZeFpEEG7VcEDdOgV9tdEfeLLQ041QdKHl
         0kiXNBd7zIcM6cfwr/xXmzE15QVz1ezJtHtGU88c8Gm4LW5aIAqcXu07tFsYw9mksKFB
         /nuAPTuxq5maG63opSF8eC6mvfYN7wBgXP/BirGKEZWaBmDkvekXoJmmkKnguImmUDyO
         DZsQ==
X-Gm-Message-State: ACgBeo2uipqvZd+2zEvlL+subV5o+dv0ju3zOqC0iYeJxgN7AmRBK95u
        DvyYhYCGYY3PUzyAMA8G7w0/LP7OF4JIMw==
X-Google-Smtp-Source: AA6agR6NBEmQIyAVGbaJ2fGXHfvyo0tzbc6hnT2oijzUdt9jDBjrximHmckCPnTMaTDzcBBzUVlwQw==
X-Received: by 2002:a50:baa1:0:b0:43e:5e95:3eda with SMTP id x30-20020a50baa1000000b0043e5e953edamr14722004ede.340.1660568468575;
        Mon, 15 Aug 2022 06:01:08 -0700 (PDT)
Received: from cloudflare.com (79.184.200.53.ipv4.supernova.orange.pl. [79.184.200.53])
        by smtp.gmail.com with ESMTPSA id c18-20020a056402121200b0043cc2c9f5adsm6537305edw.40.2022.08.15.06.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 06:01:08 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     kernel-team@cloudflare.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Haowei Yan <g1042620637@gmail.com>,
        Tom Parkin <tparkin@katalix.com>
Subject: [PATCH net v2] l2tp: Serialize access to sk_user_data with sock lock
Date:   Mon, 15 Aug 2022 15:01:07 +0200
Message-Id: <20220815130107.149345-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.35.3
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
other. To synchronize the users, any check-if-unused-and-set access to the
pointer has to happen with sock lock held.

l2tp currently fails to grab the lock when modifying the underlying tunnel
socket. Fix it by adding appropriate locking.

We don't to grab the lock when l2tp clears sk_user_data, because it happens
only in sk->sk_destruct, when the sock is going away.

v2:
- update Fixes to point to origin of the bug
- use real names in Reported/Tested-by tags

Fixes: 3557baabf280 ("[L2TP]: PPP over L2TP driver core")
Reported-by: Haowei Yan <g1042620637@gmail.com>
Tested-by: Haowei Yan <g1042620637@gmail.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
Cc: Tom Parkin <tparkin@katalix.com>

 net/l2tp/l2tp_core.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 7499c51b1850..9f5f86bfc395 100644
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
+	lock_sock(sk);
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
 
+	release_sock(sk);
 	return 0;
 
 err_sock:
@@ -1525,6 +1528,8 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 		sock_release(sock);
 	else
 		sockfd_put(sock);
+
+	release_sock(sk);
 err:
 	return ret;
 }
-- 
2.35.3

