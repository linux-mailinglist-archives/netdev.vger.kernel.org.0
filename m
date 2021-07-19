Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5583CD1A5
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 12:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236192AbhGSJad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 05:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235172AbhGSJad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 05:30:33 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B38C061574
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 02:16:03 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id u126so8325828pfb.8
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 03:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w3SwQkskqS5PWvR8GQqNjA1yV/jhwPJ7wI4UPjWWMQ0=;
        b=Yqnr9xrPNYdU9mmHefYrnGg09ESm2uX/3CZYihgK0xBKVlZNlM+t7Nh8FnK7ojVGCZ
         AnYJZnFz21c+Eyh7ahgvdaMY6BKiz8Rhb0LyT9oeYkbaTtAd5FMluQtJVk7K03gJq2Uv
         3TZ/o8ZcQ3kdMb0kWH68hHzGYOBlNLBPWUq2Eq4Onrme7ATeu8MT37i203wLbO75ujj1
         Ev4f4Z+0wfSeWARRPpVY8ifbZT5areTR9hFXW5qZkTT34wdHZpZKrH2V70BpuXE9oZ3Y
         B3V0wskt/ysTXMor7UkvbJYyRnl8/hR5rRPfbmL4rLuUdyxY10lAjN/+P2hvdcLj8dEJ
         mmZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w3SwQkskqS5PWvR8GQqNjA1yV/jhwPJ7wI4UPjWWMQ0=;
        b=EY9AeVln3a6sg7MorwihJLkTWyNGZCiEAs717qCUeINgn+H3uNZ80i3OIBHUPj8jNe
         +5Gl4x30zHOLcapvq5vsauqHo9fjdpnqJF0ceALHsn5bpWVkRsOpixbbQqYhHRInEQUL
         uydI4zVNvqWusefs6pHdwc3wJPOO3Iu60us7j8Vzlf2yQaD5esdpyTroFRvGP+VInlu7
         lC6OI5rPrwUEQG1jTbpCiWFqrM5F4zYaeIndG4rJnZba19TK/KMNQqPi7/+XO9PQYdRM
         yU5weRq2Cp2V70KO1O543FQh7XtbBymWDF++1mP37R4qDNkWZ4nVRP5H7xpcn1sGofho
         ZYyw==
X-Gm-Message-State: AOAM5327ptRs0h1lrSg6nJlaJF3fjHl+EXhjdvuyiPyrr58zu+A43yA7
        oqpY68c4tRsbKdNwomb6HH8=
X-Google-Smtp-Source: ABdhPJy6m7GcILjdbL+as+/T7BXDMhvWYqNydyXS+dpbLZciTJ9Sg+WtlflPRA6ndCRPhLOoBLzygQ==
X-Received: by 2002:aa7:8642:0:b029:348:7bf1:efec with SMTP id a2-20020aa786420000b02903487bf1efecmr4401866pfo.49.1626689471929;
        Mon, 19 Jul 2021 03:11:11 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:d265:ee2c:6429:76fd])
        by smtp.gmail.com with ESMTPSA id w6sm21549441pgh.56.2021.07.19.03.11.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 03:11:11 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Wei Wang <weiwan@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH net-next] net/tcp_fastopen: remove tcp_fastopen_ctx_lock
Date:   Mon, 19 Jul 2021 03:11:07 -0700
Message-Id: <20210719101107.3203943-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Remove the (per netns) spinlock in favor of xchg() atomic operations.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Wei Wang <weiwan@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
---
 include/net/netns/ipv4.h |  1 -
 net/ipv4/tcp_fastopen.c  | 17 +++--------------
 net/ipv4/tcp_ipv4.c      |  1 -
 3 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index b8620519eace8191c76c41f37bd51ac0d3788bc2..2f65701a43c953bd3a9a9e3d491882cb7bb11859 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -174,7 +174,6 @@ struct netns_ipv4 {
 	int sysctl_tcp_fastopen;
 	const struct tcp_congestion_ops __rcu  *tcp_congestion_control;
 	struct tcp_fastopen_context __rcu *tcp_fastopen_ctx;
-	spinlock_t tcp_fastopen_ctx_lock;
 	unsigned int sysctl_tcp_fastopen_blackhole_timeout;
 	atomic_t tfo_active_disable_times;
 	unsigned long tfo_active_disable_stamp;
diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 47c32604d38fca960d2cd56f3588bfd2e390b789..1a9fbd5448a719bb5407a8d1e8fbfbe54f56f258 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -55,12 +55,7 @@ void tcp_fastopen_ctx_destroy(struct net *net)
 {
 	struct tcp_fastopen_context *ctxt;
 
-	spin_lock(&net->ipv4.tcp_fastopen_ctx_lock);
-
-	ctxt = rcu_dereference_protected(net->ipv4.tcp_fastopen_ctx,
-				lockdep_is_held(&net->ipv4.tcp_fastopen_ctx_lock));
-	rcu_assign_pointer(net->ipv4.tcp_fastopen_ctx, NULL);
-	spin_unlock(&net->ipv4.tcp_fastopen_ctx_lock);
+	ctxt = xchg((__force struct tcp_fastopen_context **)&net->ipv4.tcp_fastopen_ctx, NULL);
 
 	if (ctxt)
 		call_rcu(&ctxt->rcu, tcp_fastopen_ctx_free);
@@ -89,18 +84,12 @@ int tcp_fastopen_reset_cipher(struct net *net, struct sock *sk,
 		ctx->num = 1;
 	}
 
-	spin_lock(&net->ipv4.tcp_fastopen_ctx_lock);
 	if (sk) {
 		q = &inet_csk(sk)->icsk_accept_queue.fastopenq;
-		octx = rcu_dereference_protected(q->ctx,
-			lockdep_is_held(&net->ipv4.tcp_fastopen_ctx_lock));
-		rcu_assign_pointer(q->ctx, ctx);
+		octx = xchg((__force struct tcp_fastopen_context **)&q->ctx, ctx);
 	} else {
-		octx = rcu_dereference_protected(net->ipv4.tcp_fastopen_ctx,
-			lockdep_is_held(&net->ipv4.tcp_fastopen_ctx_lock));
-		rcu_assign_pointer(net->ipv4.tcp_fastopen_ctx, ctx);
+		octx = xchg((__force struct tcp_fastopen_context **)&net->ipv4.tcp_fastopen_ctx, ctx);
 	}
-	spin_unlock(&net->ipv4.tcp_fastopen_ctx_lock);
 
 	if (octx)
 		call_rcu(&octx->rcu, tcp_fastopen_ctx_free);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index b9dc2d6197be8b8b03a4d052ad1c87987c7a62aa..e9321dd39cdbcb664843d4ada09a21685b93abb7 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2964,7 +2964,6 @@ static int __net_init tcp_sk_init(struct net *net)
 	net->ipv4.sysctl_tcp_comp_sack_slack_ns = 100 * NSEC_PER_USEC;
 	net->ipv4.sysctl_tcp_comp_sack_nr = 44;
 	net->ipv4.sysctl_tcp_fastopen = TFO_CLIENT_ENABLE;
-	spin_lock_init(&net->ipv4.tcp_fastopen_ctx_lock);
 	net->ipv4.sysctl_tcp_fastopen_blackhole_timeout = 60 * 60;
 	atomic_set(&net->ipv4.tfo_active_disable_times, 0);
 
-- 
2.32.0.402.g57bb445576-goog

