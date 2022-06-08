Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03AFA5437D7
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 17:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244841AbiFHPrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 11:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244739AbiFHPq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 11:46:57 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE6373DDD9
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 08:46:55 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id r1so732258plo.10
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 08:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oo4VNLQ32ZUWs+xj1GEnWGce/STbLBZ5K8YuYmraaxI=;
        b=jp2i7Y3Dg4+4Z6HwW/HpFpLGD0OLsQH8UF/STvKaBNntlNp20R1xAuZfzCPyrOT3Eu
         04330H4YxOmCJjTie+uV0vQ/PDWv0GTmGMKweYCkbmSTXf5qYWIyZbKgGBHjLOklpAWh
         2y+qQNIbOJMM9XiqkhGwi7ATThBl7y/b0aejtiHJuHJS6beuK3y3E9xDsk+tYC7OrEEP
         rYBl+fJnnZNmTmdCRGqu8vQtb5fJKu9krRQ9Z3Dffm7mFmmI4oQtetHHRlreWMT+tbCX
         f7JuQE2mIebrdLSQ7M6u+0wOBHSxLbm8qIOU811o7bkX9fClkvDjJ0pssQkKsHnP5BEQ
         EmgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oo4VNLQ32ZUWs+xj1GEnWGce/STbLBZ5K8YuYmraaxI=;
        b=CzZjpSN30Vny5CAQ3RhJYrKV9RiuKAgF9KsOtEIshKQX0kRHfNHjBm6F6f6AMwR0k2
         SZytHFlp6oyElm6KBEZiWaUhG+kU8dQsgizJRWlfTYZRR4jiyZ0Gs8D+p3RRFDuSisVP
         xhOBDQjxShVAouFgSzsSH/3oSQGgDsZxilmJ+mVJJsVn14ekm71jhLo3h7tljSW+NvyO
         7uxrk5+5QVDK1bZFQZ7ynUQlK1ug0ZdDVXOEfPH1moSPongZRrzXMo3I0u0JlWgBwvvJ
         m176Q+erFQLYOVD9oSeboGhuaRkcYFKYb7Oxp6Myo4R0hopKMNfaLZwNBkgMH415HD/G
         F/Vg==
X-Gm-Message-State: AOAM530FB9dFFF7GC+8RUetAs6f1nIZFSCdzqITxEj7U+q0vDx6CCMCX
        D72Me5NovGnkfRLXTJNm/wY=
X-Google-Smtp-Source: ABdhPJyE3EZMAZtp+telWlwhxPyiul7/e0UEWv8YCR8z4E/bWdYBXH5n4sE5H4edoCJXcLGFs0hbWA==
X-Received: by 2002:a17:902:ea0f:b0:164:1a71:bef1 with SMTP id s15-20020a170902ea0f00b001641a71bef1mr34503841plg.52.1654703215393;
        Wed, 08 Jun 2022 08:46:55 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f579:a14f:f943:9d9a])
        by smtp.gmail.com with ESMTPSA id a10-20020a056a001d0a00b0051be2ae1fb5sm10885973pfx.61.2022.06.08.08.46.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 08:46:55 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 8/9] drop_monitor: adopt u64_stats_t
Date:   Wed,  8 Jun 2022 08:46:39 -0700
Message-Id: <20220608154640.1235958-9-eric.dumazet@gmail.com>
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
 net/core/drop_monitor.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 4ad1decce72418818aa4c2415b202e4311061a8c..98952ffcee452fe8437b0d020ce834496cd26570 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -55,7 +55,7 @@ static bool monitor_hw;
 static DEFINE_MUTEX(net_dm_mutex);
 
 struct net_dm_stats {
-	u64 dropped;
+	u64_stats_t dropped;
 	struct u64_stats_sync syncp;
 };
 
@@ -530,7 +530,7 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
 unlock_free:
 	spin_unlock_irqrestore(&data->drop_queue.lock, flags);
 	u64_stats_update_begin(&data->stats.syncp);
-	data->stats.dropped++;
+	u64_stats_inc(&data->stats.dropped);
 	u64_stats_update_end(&data->stats.syncp);
 	consume_skb(nskb);
 }
@@ -985,7 +985,7 @@ net_dm_hw_trap_packet_probe(void *ignore, const struct devlink *devlink,
 unlock_free:
 	spin_unlock_irqrestore(&hw_data->drop_queue.lock, flags);
 	u64_stats_update_begin(&hw_data->stats.syncp);
-	hw_data->stats.dropped++;
+	u64_stats_inc(&hw_data->stats.dropped);
 	u64_stats_update_end(&hw_data->stats.syncp);
 	net_dm_hw_metadata_free(n_hw_metadata);
 free:
@@ -1432,10 +1432,10 @@ static void net_dm_stats_read(struct net_dm_stats *stats)
 
 		do {
 			start = u64_stats_fetch_begin_irq(&cpu_stats->syncp);
-			dropped = cpu_stats->dropped;
+			dropped = u64_stats_read(&cpu_stats->dropped);
 		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
 
-		stats->dropped += dropped;
+		u64_stats_add(&stats->dropped, dropped);
 	}
 }
 
@@ -1451,7 +1451,7 @@ static int net_dm_stats_put(struct sk_buff *msg)
 		return -EMSGSIZE;
 
 	if (nla_put_u64_64bit(msg, NET_DM_ATTR_STATS_DROPPED,
-			      stats.dropped, NET_DM_ATTR_PAD))
+			      u64_stats_read(&stats.dropped), NET_DM_ATTR_PAD))
 		goto nla_put_failure;
 
 	nla_nest_end(msg, attr);
@@ -1476,10 +1476,10 @@ static void net_dm_hw_stats_read(struct net_dm_stats *stats)
 
 		do {
 			start = u64_stats_fetch_begin_irq(&cpu_stats->syncp);
-			dropped = cpu_stats->dropped;
+			dropped = u64_stats_read(&cpu_stats->dropped);
 		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
 
-		stats->dropped += dropped;
+		u64_stats_add(&stats->dropped, dropped);
 	}
 }
 
@@ -1495,7 +1495,7 @@ static int net_dm_hw_stats_put(struct sk_buff *msg)
 		return -EMSGSIZE;
 
 	if (nla_put_u64_64bit(msg, NET_DM_ATTR_STATS_DROPPED,
-			      stats.dropped, NET_DM_ATTR_PAD))
+			      u64_stats_read(&stats.dropped), NET_DM_ATTR_PAD))
 		goto nla_put_failure;
 
 	nla_nest_end(msg, attr);
-- 
2.36.1.255.ge46751e96f-goog

