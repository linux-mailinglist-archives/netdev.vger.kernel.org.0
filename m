Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A51824613B
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgHQIwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbgHQIvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:51:55 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E583C061388;
        Mon, 17 Aug 2020 01:51:55 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 189so7155584pgg.13;
        Mon, 17 Aug 2020 01:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ijTmpsgasiQrLvP/jHqs2Q1457rFN2p2/RaYnWwesps=;
        b=Y+DhcifEg1q72HMDHgIEsMC86tLascLHtdlfcBtATq+XLVwpAc1id3Mtkz2CzT3/53
         KhbfMP01NKykwYZWMhM3x8OfyiTSkI4txHco8YdCMzje7oGC472Hz640G/x2DPQ/9sCz
         9RIn6W3+013jpVX7J1qlpPTlKtyr/abO4vTO0AWt0Sye83C4fGxjmiMggQb+CDGHfLES
         akz2DP9CIN70SIomBKNxI3DSZo9prunVFT018KcBoA0gNCTsuepbEWcqnOtFE2huwje7
         0qk8tjm7BV3WJXRG8tqQFlxS3UkMovwou8Wer+klKxaYNwXWW3NUXBeTascKbHyLfRd7
         JzEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ijTmpsgasiQrLvP/jHqs2Q1457rFN2p2/RaYnWwesps=;
        b=b8QfJIRzPRCLpweWsDnNEv9icA0PbT0n19mbDmJi94dKcpUkhWMB3Ohq0xTHAnGhiE
         L2mc+gawbGxmvJhaBWYMIezkrbxhWaR28KOFWqWI325lwQLpqe5Q/8FelJFxG76bRxrX
         ugk8cPkfrEDDuOpmRPTSZGXtp/8hae1cr4o3JElWG5bMBSymz1FQn2AgTtfjpW5uNioU
         ztezzFEzjjmVVcu/SncoqfCHDoFucecYf1LQd/y2TVFkC7f+yoNE9NVsh/lwsjFFWCB4
         fpCRz7AuvXkBV3MMak4B2zs8sV4TIjCZ7jN94iUJDOBhyrcOdk9MzQYdhHmYBZK8U1iu
         yWYg==
X-Gm-Message-State: AOAM533s0lFzqCTUDGUs+JK7v1i94O9SJhQh2B1Tu9J6nRGxpcREw8vt
        8j0/WoC1U7SC6v/sFegqZmM=
X-Google-Smtp-Source: ABdhPJwdNRCoiHOQtKGcoJCuvg7c2qTxDPh3FsDh3LRlUqjN5h2YP89Nv1bV6FSD4miIDTJhwo5dkA==
X-Received: by 2002:a63:4b21:: with SMTP id y33mr9418126pga.142.1597654314904;
        Mon, 17 Aug 2020 01:51:54 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id b185sm18554863pfg.71.2020.08.17.01.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:51:54 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     gerrit@erg.abdn.ac.uk, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, santosh.shilimkar@oracle.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us
Cc:     keescook@chromium.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 3/8] net: mac80211: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:21:15 +0530
Message-Id: <20200817085120.24894-3-allen.cryptic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817085120.24894-1-allen.cryptic@gmail.com>
References: <20200817085120.24894-1-allen.cryptic@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <allen.lkml@gmail.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 net/mac80211/ieee80211_i.h |  4 ++--
 net/mac80211/main.c        | 14 +++++---------
 net/mac80211/tx.c          |  5 +++--
 net/mac80211/util.c        |  5 +++--
 4 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0b1eaec6649f..3fb87a3cee30 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1775,7 +1775,7 @@ static inline bool ieee80211_sdata_running(struct ieee80211_sub_if_data *sdata)
 
 /* tx handling */
 void ieee80211_clear_tx_pending(struct ieee80211_local *local);
-void ieee80211_tx_pending(unsigned long data);
+void ieee80211_tx_pending(struct tasklet_struct *t);
 netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 					 struct net_device *dev);
 netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
@@ -2125,7 +2125,7 @@ void ieee80211_txq_remove_vlan(struct ieee80211_local *local,
 			       struct ieee80211_sub_if_data *sdata);
 void ieee80211_fill_txq_stats(struct cfg80211_txq_stats *txqstats,
 			      struct txq_info *txqi);
-void ieee80211_wake_txqs(unsigned long data);
+void ieee80211_wake_txqs(struct tasklet_struct *t);
 void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 			 u16 transaction, u16 auth_alg, u16 status,
 			 const u8 *extra, size_t extra_len, const u8 *bssid,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index b4a2efe8e83a..dd489b841bb7 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -220,9 +220,9 @@ u32 ieee80211_reset_erp_info(struct ieee80211_sub_if_data *sdata)
 	       BSS_CHANGED_ERP_SLOT;
 }
 
-static void ieee80211_tasklet_handler(unsigned long data)
+static void ieee80211_tasklet_handler(struct tasklet_struct *t)
 {
-	struct ieee80211_local *local = (struct ieee80211_local *) data;
+	struct ieee80211_local *local = from_tasklet(local, t, tasklet);
 	struct sk_buff *skb;
 
 	while ((skb = skb_dequeue(&local->skb_queue)) ||
@@ -733,16 +733,12 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 		skb_queue_head_init(&local->pending[i]);
 		atomic_set(&local->agg_queue_stop[i], 0);
 	}
-	tasklet_init(&local->tx_pending_tasklet, ieee80211_tx_pending,
-		     (unsigned long)local);
+	tasklet_setup(&local->tx_pending_tasklet, ieee80211_tx_pending);
 
 	if (ops->wake_tx_queue)
-		tasklet_init(&local->wake_txqs_tasklet, ieee80211_wake_txqs,
-			     (unsigned long)local);
+		tasklet_setup(&local->wake_txqs_tasklet, ieee80211_wake_txqs);
 
-	tasklet_init(&local->tasklet,
-		     ieee80211_tasklet_handler,
-		     (unsigned long) local);
+	tasklet_setup(&local->tasklet, ieee80211_tasklet_handler);
 
 	skb_queue_head_init(&local->skb_queue);
 	skb_queue_head_init(&local->skb_queue_unreliable);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index dca01d7e6e3e..a7fafd2f196b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4401,9 +4401,10 @@ static bool ieee80211_tx_pending_skb(struct ieee80211_local *local,
 /*
  * Transmit all pending packets. Called from tasklet.
  */
-void ieee80211_tx_pending(unsigned long data)
+void ieee80211_tx_pending(struct tasklet_struct *t)
 {
-	struct ieee80211_local *local = (struct ieee80211_local *)data;
+	struct ieee80211_local *local = from_tasklet(local, t,
+						     tx_pending_tasklet);
 	unsigned long flags;
 	int i;
 	bool txok;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index c8504ffc71a1..b99d3d2721df 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -334,9 +334,10 @@ _ieee80211_wake_txqs(struct ieee80211_local *local, unsigned long *flags)
 	rcu_read_unlock();
 }
 
-void ieee80211_wake_txqs(unsigned long data)
+void ieee80211_wake_txqs(struct tasklet_struct *t)
 {
-	struct ieee80211_local *local = (struct ieee80211_local *)data;
+	struct ieee80211_local *local = from_tasklet(local, t,
+						     wake_txqs_tasklet);
 	unsigned long flags;
 
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
-- 
2.17.1

