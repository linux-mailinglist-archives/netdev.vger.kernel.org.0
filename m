Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9877A5571A6
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 06:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbiFWEk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 00:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347352AbiFWEfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 00:35:31 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A47D030F71
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:35:29 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id i16-20020a05620a249000b006aedb25493cso4402969qkn.15
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=MbAa01ayooLRjvmZvMsHwzRjI7CpSiorxRvp5VWlJKg=;
        b=R5yKs+TGPSSk0dPi0tql3fdBhWEBjmH5WOGtTGWWqAS3A/tmYMnl8mi5783CtZfkdV
         WfQVI+5Ab+o6FPtUi+fR3Kny0UYLq8wyYXka1WJpREu/3NqfA3tFedefb0fRazEmNjnW
         jguS3qvcw2YBlV3rCo73lPjPy3D87XuNEiN56Ons4108OZavuaKqG+vo9hfDZo0qi33z
         kSwzjEN1ahn/jLzlOz7KtCypbLqzCC1QkrOpCWUSWCfbatAaYheyTZT92ELx3omQ/BPg
         cJr5UH5WN4NMsUF3LZksXNNZDZC0e2Gt0zYUdPm0rGkrBNRCxxLDGtsnkEt66vOCqwH+
         zzbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MbAa01ayooLRjvmZvMsHwzRjI7CpSiorxRvp5VWlJKg=;
        b=t+rj4ffcVXPbbBJY9QbF0ff55n5r1zJ1LGHadISb2NpcUzCv76CfkjvsUS7gWktRRv
         OeXrYqO3FUMGrrUymHmAlqxsj/kB/udu51I3lWyQr4hLujkw3l/NW8gq8XbM+TdpSGJC
         l7r4AOaiHno612hZdPrdoC1naZrEofNRdatRoHqjVe7sBHEzSot8O2ovkudog9dBRoze
         9qbfsboiH+tbRpLGfDs3Y/lEI3tRLrsB//b6Ekhva6EYjIFhXaJrjg5sZP+xudiZLPED
         LVXBiehtPsDHcK1aDXm21MwS0iKAFhD/75o4yXQ3LX7Aoe6tm8hoAWcopbvsaxDD6n9s
         xV2w==
X-Gm-Message-State: AJIora92aFd8iu4B3uv4rTjHJ8uPeGhOqDB+O6T8FAWSWewnR3gXRkP5
        aK4SD4G3dHGMBVXPymDQISw2Jn6RY5RCsQ==
X-Google-Smtp-Source: AGRyM1uJTOBiJFGaJb61+pJRDfw3N7K/r2sicszLPSiK/AqVJHCgKL2qBk4k8AFGKWA48V9S0p7aHDx7tZpvNQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:ad4:5aea:0:b0:470:57a0:f95 with SMTP id
 c10-20020ad45aea000000b0047057a00f95mr8821510qvh.51.1655958928803; Wed, 22
 Jun 2022 21:35:28 -0700 (PDT)
Date:   Thu, 23 Jun 2022 04:34:38 +0000
In-Reply-To: <20220623043449.1217288-1-edumazet@google.com>
Message-Id: <20220623043449.1217288-9-edumazet@google.com>
Mime-Version: 1.0
References: <20220623043449.1217288-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH v2 net-next 08/19] ipmr: do not acquire mrt_lock while calling ip_mr_forward()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ip_mr_forward() uses standard RCU protection already.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/ipmr.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 6ea54bc3d9b6555aaa9974d81ba4acd47481724f..b0f2e6d79d62273c8c2682f28cb45fe5ec3df6f3 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1817,7 +1817,7 @@ static bool ipmr_forward_offloaded(struct sk_buff *skb, struct mr_table *mrt,
 }
 #endif
 
-/* Processing handlers for ipmr_forward */
+/* Processing handlers for ipmr_forward, under rcu_read_lock() */
 
 static void ipmr_queue_xmit(struct net *net, struct mr_table *mrt,
 			    int in_vifi, struct sk_buff *skb, int vifi)
@@ -1839,9 +1839,7 @@ static void ipmr_queue_xmit(struct net *net, struct mr_table *mrt,
 		WRITE_ONCE(vif->bytes_out, vif->bytes_out + skb->len);
 		vif_dev->stats.tx_bytes += skb->len;
 		vif_dev->stats.tx_packets++;
-		rcu_read_lock();
 		ipmr_cache_report(mrt, skb, vifi, IGMPMSG_WHOLEPKT);
-		rcu_read_unlock();
 		goto out_free;
 	}
 
@@ -1936,6 +1934,7 @@ static int ipmr_find_vif(const struct mr_table *mrt, struct net_device *dev)
 }
 
 /* "local" means that we should preserve one skb (for local delivery) */
+/* Called uner rcu_read_lock() */
 static void ip_mr_forward(struct net *net, struct mr_table *mrt,
 			  struct net_device *dev, struct sk_buff *skb,
 			  struct mfc_cache *c, int local)
@@ -1992,12 +1991,10 @@ static void ip_mr_forward(struct net *net, struct mr_table *mrt,
 			       c->_c.mfc_un.res.last_assert +
 			       MFC_ASSERT_THRESH)) {
 			c->_c.mfc_un.res.last_assert = jiffies;
-			rcu_read_lock();
 			ipmr_cache_report(mrt, skb, true_vifi, IGMPMSG_WRONGVIF);
 			if (mrt->mroute_do_wrvifwhole)
 				ipmr_cache_report(mrt, skb, true_vifi,
 						  IGMPMSG_WRVIFWHOLE);
-			rcu_read_unlock();
 		}
 		goto dont_forward;
 	}
@@ -2169,9 +2166,7 @@ int ip_mr_input(struct sk_buff *skb)
 		return -ENODEV;
 	}
 
-	read_lock(&mrt_lock);
 	ip_mr_forward(net, mrt, dev, skb, cache, local);
-	read_unlock(&mrt_lock);
 
 	if (local)
 		return ip_local_deliver(skb);
-- 
2.37.0.rc0.104.g0611611a94-goog

