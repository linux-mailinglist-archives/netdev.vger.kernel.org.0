Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A21A55437D9
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 17:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244835AbiFHPrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 11:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244769AbiFHPq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 11:46:57 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BB6F2C671
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 08:46:57 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id e66so19236376pgc.8
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 08:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c7ZxjBhd9r0DJDMboQQNSRkeIfCRgvQImpqF0uM/P4U=;
        b=Y8a0W8ZH2SVO65TihV2hj0qZmdGdTOwZ29icML2FrZKCoUdSGtpkcteMd4rre5iPj5
         R2CtRJFrLOmXn0knthgHuLJpcZPOygHGZqkyFP7acZ7vJUReyn0mRhpgTpRLP8iz/hYD
         0E1ibBWWeOFwH2kOeyDshfbFRo1xhDMDNyzPlHHQ0b7h5hEUqa/f1sWJpjACp3Fh871O
         rIOxy2Ai3i+HisMNDxHx4S1a7+fGuC8oyM75t/VgjvzqjODE/K1AnQAkmA3OMmBnu9mE
         VnIa9W5cW4AT0Uz9MBzdX5svfQABljfL5Ge8vDpxd5WEprC3bD0GzbJSuhDADz9DW2Xs
         hInQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c7ZxjBhd9r0DJDMboQQNSRkeIfCRgvQImpqF0uM/P4U=;
        b=SKS8DVi1CKLbIbRkWxLHRVVjOXEgzksb3AjNAPB5eJhQ8VOaiHYt3mJiBUK9FEhU46
         q9MRAiXoykO1YJR8ANh0PDNnKNlt21MA5h87l9bEU8sI+wuQXGV35uLMNVyqwR1x64Ne
         UAhqZ4td5Mt6y2rEtbvwTdMTxkqs543oA3hcXAdeh0iXRlfQgrQ5M5vHVUGidiMY6RSO
         BeGIkX7A3uiNVuuFxZ9mwC2UA9HNdc9eVev8LEeajR1GhJ3avyeF4Z8VBRf3Eqr7DzGB
         TBJkBdJdvjOC4/HjBTS3WzRf1+7vfPmM4adHRSC35LEOvXfEeBbfTT6wdMDyAhpNW4Bc
         +IcA==
X-Gm-Message-State: AOAM5309n+ESnY9b2qDEWXEHwB2hqmhEs5+4nOpWCU92qFYSlie3Ior/
        weEgE/578Ad5ZEw+25zuziI=
X-Google-Smtp-Source: ABdhPJxQPdbIUG78OvFm9xHD+7TJfiW7vFGsqFVHegt3orR/t6oPKRv+237tDHwjJAoP2SKZmC9IqA==
X-Received: by 2002:a63:87c1:0:b0:3fe:d69:be78 with SMTP id i184-20020a6387c1000000b003fe0d69be78mr6774524pge.287.1654703216652;
        Wed, 08 Jun 2022 08:46:56 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f579:a14f:f943:9d9a])
        by smtp.gmail.com with ESMTPSA id a10-20020a056a001d0a00b0051be2ae1fb5sm10885973pfx.61.2022.06.08.08.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 08:46:56 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 9/9] team: adopt u64_stats_t
Date:   Wed,  8 Jun 2022 08:46:40 -0700
Message-Id: <20220608154640.1235958-10-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220608154640.1235958-1-eric.dumazet@gmail.com>
References: <20220608154640.1235958-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

As explained in commit 316580b69d0a ("u64_stats: provide u64_stats_t type")
we should use u64_stats_t and related accessors to avoid load/store tearing.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/team/team.c | 26 +++++++++++++-------------
 include/linux/if_team.h | 10 +++++-----
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index b07dde6f0abf273195ff0f60217bd7158535b153..aac133a1e27a5f64fe8f83a456aa0598fad6824c 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -749,10 +749,10 @@ static rx_handler_result_t team_handle_frame(struct sk_buff **pskb)
 
 		pcpu_stats = this_cpu_ptr(team->pcpu_stats);
 		u64_stats_update_begin(&pcpu_stats->syncp);
-		pcpu_stats->rx_packets++;
-		pcpu_stats->rx_bytes += skb->len;
+		u64_stats_inc(&pcpu_stats->rx_packets);
+		u64_stats_add(&pcpu_stats->rx_bytes, skb->len);
 		if (skb->pkt_type == PACKET_MULTICAST)
-			pcpu_stats->rx_multicast++;
+			u64_stats_inc(&pcpu_stats->rx_multicast);
 		u64_stats_update_end(&pcpu_stats->syncp);
 
 		skb->dev = team->dev;
@@ -1720,8 +1720,8 @@ static netdev_tx_t team_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		pcpu_stats = this_cpu_ptr(team->pcpu_stats);
 		u64_stats_update_begin(&pcpu_stats->syncp);
-		pcpu_stats->tx_packets++;
-		pcpu_stats->tx_bytes += len;
+		u64_stats_inc(&pcpu_stats->tx_packets);
+		u64_stats_add(&pcpu_stats->tx_bytes, len);
 		u64_stats_update_end(&pcpu_stats->syncp);
 	} else {
 		this_cpu_inc(team->pcpu_stats->tx_dropped);
@@ -1854,11 +1854,11 @@ team_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 		p = per_cpu_ptr(team->pcpu_stats, i);
 		do {
 			start = u64_stats_fetch_begin_irq(&p->syncp);
-			rx_packets	= p->rx_packets;
-			rx_bytes	= p->rx_bytes;
-			rx_multicast	= p->rx_multicast;
-			tx_packets	= p->tx_packets;
-			tx_bytes	= p->tx_bytes;
+			rx_packets	= u64_stats_read(&p->rx_packets);
+			rx_bytes	= u64_stats_read(&p->rx_bytes);
+			rx_multicast	= u64_stats_read(&p->rx_multicast);
+			tx_packets	= u64_stats_read(&p->tx_packets);
+			tx_bytes	= u64_stats_read(&p->tx_bytes);
 		} while (u64_stats_fetch_retry_irq(&p->syncp, start));
 
 		stats->rx_packets	+= rx_packets;
@@ -1870,9 +1870,9 @@ team_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 		 * rx_dropped, tx_dropped & rx_nohandler are u32,
 		 * updated without syncp protection.
 		 */
-		rx_dropped	+= p->rx_dropped;
-		tx_dropped	+= p->tx_dropped;
-		rx_nohandler	+= p->rx_nohandler;
+		rx_dropped	+= READ_ONCE(p->rx_dropped);
+		tx_dropped	+= READ_ONCE(p->tx_dropped);
+		rx_nohandler	+= READ_ONCE(p->rx_nohandler);
 	}
 	stats->rx_dropped	= rx_dropped;
 	stats->tx_dropped	= tx_dropped;
diff --git a/include/linux/if_team.h b/include/linux/if_team.h
index add607943c9564365e8d72d7522291d7a3d899d2..fc985e5c739d434148e8ff19d30ebc3ee8abf1d8 100644
--- a/include/linux/if_team.h
+++ b/include/linux/if_team.h
@@ -12,11 +12,11 @@
 #include <uapi/linux/if_team.h>
 
 struct team_pcpu_stats {
-	u64			rx_packets;
-	u64			rx_bytes;
-	u64			rx_multicast;
-	u64			tx_packets;
-	u64			tx_bytes;
+	u64_stats_t		rx_packets;
+	u64_stats_t		rx_bytes;
+	u64_stats_t		rx_multicast;
+	u64_stats_t		tx_packets;
+	u64_stats_t		tx_bytes;
 	struct u64_stats_sync	syncp;
 	u32			rx_dropped;
 	u32			tx_dropped;
-- 
2.36.1.255.ge46751e96f-goog

