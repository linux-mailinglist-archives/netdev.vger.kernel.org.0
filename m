Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074D446AF68
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378740AbhLGAzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:55:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378739AbhLGAzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 19:55:21 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B19BC0613F8
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 16:51:52 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id o4so11709998pfp.13
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 16:51:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Yje/NZCJNIzhe5Ma/sqymz5RSvBvVVnhMwTrhleT8ns=;
        b=hvYa5+vW0uPtLFClOPTJFJaZ/FNakERnVHRwTNV4j0TUPegnbaoIzkCMQm2e3zHV2Q
         Gg9eWWMg5xlAAxKXrYiAZJ38kCxk0860idD9iyrTb4+UQcG19VZQ2SCrNb0q4MP6KXEP
         /CMPPdqDxH2Pszj0K/EpLUbGkKqUFuUE00VC3Llr+BQQZpvt5s4W2jM1J4y5yg3QoVvD
         cYkN/tFs42FVCRU0H4w8U0T7YAF74GSCYusLj0liY/IGvCiZc4qRMXpEO+b4C9LRnAa7
         AExv5A3DXu/NY3GdS9JWeX/HVogXpTg7rVAmmzJehNbuI2c8TjFDHYrWfRlH+9HBwrnl
         Sr3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yje/NZCJNIzhe5Ma/sqymz5RSvBvVVnhMwTrhleT8ns=;
        b=IT4yfD5Rt8xx826OA9IHQX82xRLaUvxGDz1LOfxC6MReGebj9BQEwBkxjnLJClyOra
         t/sLMI54QlJNwdP+reU6luHWScMNVjbm0oNRqzvdY4RQAXglxvVT1mj2H+XiLCBdMhsc
         jtsTV9dOcYZpzUpvJ4ccg6CqNjqsa7ULB71XJ2YBV3Yj3uX4os/Je5m/M6g+3xvToJbq
         zo6kENTGW1NnMSYfLAY/sSUxgWsDM8TzO2JdKfR39iCbq+aA2B6X1vQ2ZKURdyAswOTX
         85dsHnPpCpxTss+o3ifatef8213USkJJs7iC1x0nBGR2gkOwAOKZawiHjLmgUSu/emeV
         Qv+Q==
X-Gm-Message-State: AOAM5319gehvwc3kVLmc8OsfBfOrXssbb+mkwmQjn7hJB0KcUHzk0zau
        PDCW5+AXXEupo6pRHsaI5BU=
X-Google-Smtp-Source: ABdhPJxc0eQD6gW1hgm8YQNFcTJJeUADAVu4jDh/exr2U30DENibMF+ASzO9dgB+ROE0UybH2RsnoA==
X-Received: by 2002:a63:1442:: with SMTP id 2mr21353783pgu.16.1638838311592;
        Mon, 06 Dec 2021 16:51:51 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:518c:39bf:c3e8:ffe2])
        by smtp.gmail.com with ESMTPSA id l13sm14239618pfu.149.2021.12.06.16.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 16:51:51 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 02/17] net: add netns refcount tracker to struct sock
Date:   Mon,  6 Dec 2021 16:51:27 -0800
Message-Id: <20211207005142.1688204-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211207005142.1688204-1-eric.dumazet@gmail.com>
References: <20211207005142.1688204-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h | 2 ++
 net/core/sock.c    | 6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index ae61cd0b650de76d731c8f9b7f9050d9beb3d87e..5d8532f26208fbd05f5b1185afa87207c1c476c9 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -350,6 +350,7 @@ struct bpf_local_storage;
   *	@sk_txtime_deadline_mode: set deadline mode for SO_TXTIME
   *	@sk_txtime_report_errors: set report errors mode for SO_TXTIME
   *	@sk_txtime_unused: unused txtime flags
+  *	@ns_tracker: tracker for netns reference
   */
 struct sock {
 	/*
@@ -538,6 +539,7 @@ struct sock {
 	struct bpf_local_storage __rcu	*sk_bpf_storage;
 #endif
 	struct rcu_head		sk_rcu;
+	netns_tracker		ns_tracker;
 };
 
 enum sk_pacing {
diff --git a/net/core/sock.c b/net/core/sock.c
index 4a499d255f401e61fff2fbab3b0fd9337da77f7e..1a6a925397906508a33e1443b1ec27ac19d036e1 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1983,7 +1983,7 @@ struct sock *sk_alloc(struct net *net, int family, gfp_t priority,
 		sock_lock_init(sk);
 		sk->sk_net_refcnt = kern ? 0 : 1;
 		if (likely(sk->sk_net_refcnt)) {
-			get_net(net);
+			get_net_track(net, &sk->ns_tracker, priority);
 			sock_inuse_add(net, 1);
 		}
 
@@ -2039,7 +2039,7 @@ static void __sk_destruct(struct rcu_head *head)
 	put_pid(sk->sk_peer_pid);
 
 	if (likely(sk->sk_net_refcnt))
-		put_net(sock_net(sk));
+		put_net_track(sock_net(sk), &sk->ns_tracker);
 	sk_prot_free(sk->sk_prot_creator, sk);
 }
 
@@ -2126,7 +2126,7 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 
 	/* SANITY */
 	if (likely(newsk->sk_net_refcnt)) {
-		get_net(sock_net(newsk));
+		get_net_track(sock_net(newsk), &newsk->ns_tracker, priority);
 		sock_inuse_add(sock_net(newsk), 1);
 	}
 	sk_node_init(&newsk->sk_node);
-- 
2.34.1.400.ga245620fadb-goog

