Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FAA846FC03
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 08:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233774AbhLJHsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 02:48:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbhLJHsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 02:48:12 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A60C061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 23:44:38 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id m15so7331495pgu.11
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 23:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/aGOC8WGff4D+4yjW7lT1y3LpQU4tbVydFHCNUqEMv0=;
        b=YaHoXfWt1b3oIn/uvWqV3ehUGpWnEjW9xCecbR37hcCwxdjiLsvRlhSC1GUI15CqOs
         zSaAEtbkCPXh4tDbHSvlop6YD5V3QwT0EP7jpb/dplsyHlmKynFxqrTUVXX/gzTObwQe
         W3OQymAVBCg3srcUU0/zJU30UJM1mdVVXM56YCzAH2T2LOVMRVq2zEzukEIIgZuh0elk
         OwOCnb65R8koUqO5Wd7b6Cjd9abEMUTWXwyzIU8mEYl+OckCrAyEk6Pz0SVcFWPov93W
         6Ws/EF+r+KGz1D0dt+sff2QYQAlJMpfxJzbMHtXrOr+9Y50D/4xvsgiD4Yh49Qh8U3kH
         xQ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/aGOC8WGff4D+4yjW7lT1y3LpQU4tbVydFHCNUqEMv0=;
        b=qPkamgXRsMOrpT0htdBYgCS+tJXeofLPhggMHJsZUfuIOeS1L6YYjh6LBLuozbvc3w
         rd2uHZclbz9171Q+KpYZx3Cfqo3y8iVvGNDatbsQjifIirFTupPS0Vp/5ufnsYvsfIFH
         CZAqV7JqUXekEFYfDoBrbr8r8+uXCGTWuOoYimNW3oGvypdx5KirVDrkg/hK7NV/ZUZ0
         +1fJTruef5yvMItrb2alyGANKJgkVa6ANMXbob0hSyYIOwKLxJ2Dpa02wIr2tsPk4wyv
         MFol0JchbUUcJlbv9msCQT/YWG9jHf0x52kWv10f6mpv3htIP8wUtVW2nviT0IgWxq+I
         +uMw==
X-Gm-Message-State: AOAM531T0h/dT9SqPJQT78wjCsgpWmAnU8PYGtx7/OkBxXvXIoE9uBbX
        i3vOZO3QPaMDRHjEyLIbMAJEdpSREgBbnA==
X-Google-Smtp-Source: ABdhPJzio56xZUAbalt7Ls1bgKWWPBBxoGjX5jSlQnFP+Nzsh3Ch+Cm3gW/pCZXpEQv76ww/2GlM+w==
X-Received: by 2002:a63:6c81:: with SMTP id h123mr39141687pgc.313.1639122277597;
        Thu, 09 Dec 2021 23:44:37 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4f5:a6b4:3889:ebe5])
        by smtp.gmail.com with ESMTPSA id y12sm2001346pfe.140.2021.12.09.23.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 23:44:37 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH V2 net-next 2/6] net: add netns refcount tracker to struct sock
Date:   Thu,  9 Dec 2021 23:44:22 -0800
Message-Id: <20211210074426.279563-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
In-Reply-To: <20211210074426.279563-1-eric.dumazet@gmail.com>
References: <20211210074426.279563-1-eric.dumazet@gmail.com>
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
2.34.1.173.g76aa8bc2d0-goog

