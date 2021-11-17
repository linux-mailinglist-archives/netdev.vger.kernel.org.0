Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3A6453EF0
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 04:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232888AbhKQDcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 22:32:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232885AbhKQDca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 22:32:30 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10D0C061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 19:29:32 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so1287848pjb.1
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 19:29:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Woqt5ISaGQV8hS1AlZu+KIyS3oVxiY9AlS2a8rTt3eI=;
        b=fYKKZwJ7gZYl1UIe2a7f1GDuQpVG7H2I/VnGKCEexrb9rwG6TWVLmlQAk4FtSK5tpD
         z1e40mJbQxGxZrIg9lf56dddnYHHtJVfQLtKIy9AFNk3nx+eptqd5zdKoAWz9WEIochq
         +jtdMd8V8wE5WYISNXAABfi0GYxCD2nBbi64xTh46EwjH3ygoTO2Fcjl9Pzy190cEPYJ
         o+Fs4Q160oQDu1WoH8XbU2V+Re69T79BKTbTL5iD7KzkYmtWGWlUS3u6aR9UB+MtMVjI
         LKLYCSZ9p7qPocjVQFtTFrtsbr9xSn3wdVnlOGnRde5h4SGTjPYnH0JSBqSDulECZuDG
         CdaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Woqt5ISaGQV8hS1AlZu+KIyS3oVxiY9AlS2a8rTt3eI=;
        b=IFwTWeYf5ZnAc+61bcG9DD9AS0nvtj9Tn43bbU53qU6I2mtZHQ8mhcI1Sqkc0T2bpe
         /4ygP62hBNn/GWsw9zSFj8gLv0NT2muh6DoR2IEyj/OCGLLRTno3jxOOoMAjt7xMxrph
         NJswMo++7FaIkvNRJV18TPrwHGugJ00hjHHM/KzXpg5qdwgvHiLWoAZrowzq8Ik9F8TY
         D80zwP+xuMN8UE7qqCPKBjNNtHQHemT4qI2Gs1lqj9NdJeZ/eOXlcuCDW7aNpghekCBH
         SatozRsCZPJkzdB96WxWEqtyBiMC37OvIxUO2ajn0C5x+aC8xEAJck0V/thRCmvVEGyL
         8Tcg==
X-Gm-Message-State: AOAM530XaQDXu96/Gk7mVKXIuuNSc1pei2MUCDB/8weEoI8tIFXkgR8q
        oVSuvrdvBhACWg9hbTOfzjo=
X-Google-Smtp-Source: ABdhPJz298QDMYrasEBmEp2YDAPwsgidRLsYLspE4rN1qE+e36etjBTFVQPS28FcBIl9TowzLpsfJw==
X-Received: by 2002:a17:90a:fe85:: with SMTP id co5mr5531668pjb.110.1637119772575;
        Tue, 16 Nov 2021 19:29:32 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:bea:143e:3360:c708])
        by smtp.gmail.com with ESMTPSA id mi18sm4042394pjb.13.2021.11.16.19.29.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 19:29:32 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 3/4] net: do not inline netif_tx_lock()/netif_tx_unlock()
Date:   Tue, 16 Nov 2021 19:29:23 -0800
Message-Id: <20211117032924.1740327-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211117032924.1740327-1-eric.dumazet@gmail.com>
References: <20211117032924.1740327-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

These are not fast path, there is no point in inlining them.

Also provide netif_freeze_queues()/netif_unfreeze_queues()
so that we can use them from dev_watchdog() in the following patch.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h | 39 ++----------------------------
 net/sched/sch_generic.c   | 51 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 37 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 83e6204c0ba3491b56eec5c7f94e55eab7159223..28e79ef5ca06f66a788ce3e3f59d158be9150332 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4126,27 +4126,7 @@ static inline void netif_trans_update(struct net_device *dev)
  *
  * Get network device transmit lock
  */
-static inline void netif_tx_lock(struct net_device *dev)
-{
-	unsigned int i;
-	int cpu;
-
-	spin_lock(&dev->tx_global_lock);
-	cpu = smp_processor_id();
-	for (i = 0; i < dev->num_tx_queues; i++) {
-		struct netdev_queue *txq = netdev_get_tx_queue(dev, i);
-
-		/* We are the only thread of execution doing a
-		 * freeze, but we have to grab the _xmit_lock in
-		 * order to synchronize with threads which are in
-		 * the ->hard_start_xmit() handler and already
-		 * checked the frozen bit.
-		 */
-		__netif_tx_lock(txq, cpu);
-		set_bit(__QUEUE_STATE_FROZEN, &txq->state);
-		__netif_tx_unlock(txq);
-	}
-}
+void netif_tx_lock(struct net_device *dev);
 
 static inline void netif_tx_lock_bh(struct net_device *dev)
 {
@@ -4154,22 +4134,7 @@ static inline void netif_tx_lock_bh(struct net_device *dev)
 	netif_tx_lock(dev);
 }
 
-static inline void netif_tx_unlock(struct net_device *dev)
-{
-	unsigned int i;
-
-	for (i = 0; i < dev->num_tx_queues; i++) {
-		struct netdev_queue *txq = netdev_get_tx_queue(dev, i);
-
-		/* No need to grab the _xmit_lock here.  If the
-		 * queue is not stopped for another reason, we
-		 * force a schedule.
-		 */
-		clear_bit(__QUEUE_STATE_FROZEN, &txq->state);
-		netif_schedule_queue(txq);
-	}
-	spin_unlock(&dev->tx_global_lock);
-}
+void netif_tx_unlock(struct net_device *dev);
 
 static inline void netif_tx_unlock_bh(struct net_device *dev)
 {
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 02c46041f76e85571fd2862e02fb409bfd8e6611..389e0d8fc68d12cf092a975511729a8dae1b29fb 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -445,6 +445,57 @@ unsigned long dev_trans_start(struct net_device *dev)
 }
 EXPORT_SYMBOL(dev_trans_start);
 
+static void netif_freeze_queues(struct net_device *dev)
+{
+	unsigned int i;
+	int cpu;
+
+	cpu = smp_processor_id();
+	for (i = 0; i < dev->num_tx_queues; i++) {
+		struct netdev_queue *txq = netdev_get_tx_queue(dev, i);
+
+		/* We are the only thread of execution doing a
+		 * freeze, but we have to grab the _xmit_lock in
+		 * order to synchronize with threads which are in
+		 * the ->hard_start_xmit() handler and already
+		 * checked the frozen bit.
+		 */
+		__netif_tx_lock(txq, cpu);
+		set_bit(__QUEUE_STATE_FROZEN, &txq->state);
+		__netif_tx_unlock(txq);
+	}
+}
+
+void netif_tx_lock(struct net_device *dev)
+{
+	spin_lock(&dev->tx_global_lock);
+	netif_freeze_queues(dev);
+}
+EXPORT_SYMBOL(netif_tx_lock);
+
+static void netif_unfreeze_queues(struct net_device *dev)
+{
+	unsigned int i;
+
+	for (i = 0; i < dev->num_tx_queues; i++) {
+		struct netdev_queue *txq = netdev_get_tx_queue(dev, i);
+
+		/* No need to grab the _xmit_lock here.  If the
+		 * queue is not stopped for another reason, we
+		 * force a schedule.
+		 */
+		clear_bit(__QUEUE_STATE_FROZEN, &txq->state);
+		netif_schedule_queue(txq);
+	}
+}
+
+void netif_tx_unlock(struct net_device *dev)
+{
+	netif_unfreeze_queues(dev);
+	spin_unlock(&dev->tx_global_lock);
+}
+EXPORT_SYMBOL(netif_tx_unlock);
+
 static void dev_watchdog(struct timer_list *t)
 {
 	struct net_device *dev = from_timer(dev, t, watchdog_timer);
-- 
2.34.0.rc1.387.gb447b232ab-goog

