Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDB04B2A94
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 17:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351612AbiBKQkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 11:40:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238568AbiBKQkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 11:40:31 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05837BD6
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 08:40:30 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id h22so6013317ejl.12
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 08:40:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ekc7Tn7BClDcaiwZG8Yr7X/WoQx2hyzA+9mP7+Tb9Iw=;
        b=afCuEy6Av7E0JVwRWduZBNc4FeWRqu37aNR+Qf+u2ykSinUNiOgppx79vQDsHGDWBF
         NOzGqNAotlD8xWBfWY+Oj4wE03KNIcbs+yGE8k8ubJSZagWi9lUBFHV79pyFnvhHydtX
         0RhzDkrWxuOEIsOhirb9SFIl/IDRN8mnBZaoA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ekc7Tn7BClDcaiwZG8Yr7X/WoQx2hyzA+9mP7+Tb9Iw=;
        b=3OoUV1oywMyWh5d5JZzHg2m0QorjAeNg6ufVIYUw7PRzz8bzUofFpmMou/2MXQthYD
         MYf4M2QJ0pBJslxeYA0OTBhi+DCfAbAVCAxAYaiA4gYZKbzquHyJ/diQrxb2L5vI9wPy
         XAtY3ZJ3mR2bQXanpkZjLGeNRyGCdpwbzIh7uKL9TjCSGi74dWd2jfIcR+8vJ6Yysxor
         ubu2RCjuykIELNEJE25ktyX4JCindPPNXuyZD6udJiZjQ42IWktZ3j/MgVP0y2uX4QuD
         4Y3qG9UOxZW925Z/R7bQrbp6Zuj9BWxpPLk3WhyhzC/XVLbVw/79rUMBA0p8Bh6xDD1t
         w5GA==
X-Gm-Message-State: AOAM532Rw98zDUwUfblVvi7Lb670Z8tuXokyFpcY+goiBGwl1HcvRqau
        TR4Bvtj3hvEUq70AdQdQ+WC0+Q==
X-Google-Smtp-Source: ABdhPJxNPMirbZYD7tbQa8VZgVK5jhoaL6/AGf6cwux9qoFbkYtUvR2SMxUg759pPkK/F6mXUhGHVQ==
X-Received: by 2002:a17:907:a428:: with SMTP id sg40mr2165519ejc.128.1644597628508;
        Fri, 11 Feb 2022 08:40:28 -0800 (PST)
Received: from alco.lan (80.71.134.83.ipv4.parknet.dk. [80.71.134.83])
        by smtp.gmail.com with ESMTPSA id cn15sm5818965edb.37.2022.02.11.08.40.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 08:40:28 -0800 (PST)
From:   Ricardo Ribalda <ribalda@chromium.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ricardo Ribalda <ribalda@chromium.org>
Subject: [PATCH] net: Fix build when CONFIG_INET is not enabled
Date:   Fri, 11 Feb 2022 17:40:26 +0100
Message-Id: <20220211164026.409225-1-ribalda@chromium.org>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the kernel is configured with CONFIG_NET, but without CONFIG_INET we
get the following error when building:

sock.c:(.text+0x4c17): undefined reference to `__sk_defer_free_flush'

Lets move __sk_defer_free_flush to sock.c

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
---
 net/core/sock.c | 14 ++++++++++++++
 net/ipv4/tcp.c  | 14 --------------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 4ff806d71921..b93b93497e7e 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2045,6 +2045,20 @@ static void __sk_destruct(struct rcu_head *head)
 	sk_prot_free(sk->sk_prot_creator, sk);
 }
 
+void __sk_defer_free_flush(struct sock *sk)
+{
+	struct llist_node *head;
+	struct sk_buff *skb, *n;
+
+	head = llist_del_all(&sk->defer_list);
+	llist_for_each_entry_safe(skb, n, head, ll_node) {
+		prefetch(n);
+		skb_mark_not_on_list(skb);
+		__kfree_skb(skb);
+	}
+}
+EXPORT_SYMBOL(__sk_defer_free_flush);
+
 void sk_destruct(struct sock *sk)
 {
 	bool use_call_rcu = sock_flag(sk, SOCK_RCU_FREE);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 02cb275e5487..bc5b5c29d5c4 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1589,20 +1589,6 @@ void tcp_cleanup_rbuf(struct sock *sk, int copied)
 		tcp_send_ack(sk);
 }
 
-void __sk_defer_free_flush(struct sock *sk)
-{
-	struct llist_node *head;
-	struct sk_buff *skb, *n;
-
-	head = llist_del_all(&sk->defer_list);
-	llist_for_each_entry_safe(skb, n, head, ll_node) {
-		prefetch(n);
-		skb_mark_not_on_list(skb);
-		__kfree_skb(skb);
-	}
-}
-EXPORT_SYMBOL(__sk_defer_free_flush);
-
 static void tcp_eat_recv_skb(struct sock *sk, struct sk_buff *skb)
 {
 	__skb_unlink(skb, &sk->sk_receive_queue);
-- 
2.35.1.265.g69c8d7142f-goog

