Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8732F554227
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 07:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356939AbiFVFN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 01:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356912AbiFVFNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 01:13:19 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A081535DE5
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:14 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id m68-20020a253f47000000b006683bd91962so13762599yba.0
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=MbAa01ayooLRjvmZvMsHwzRjI7CpSiorxRvp5VWlJKg=;
        b=lFxaMyJoMNDYKOZnodD1Q75etFtJnz/kbZF+a+wBiWlzEpGzQZNjTPeivJK+BhAjOg
         /L4M8jbibxdtTLJGTq5Evi6qUxV1y9rc1VBzfspVeekCn45WzPmzXZq6g7nS1pE9eahf
         anRtvBNdiu04AkP75v2OCSUYU+sZdtmnP6nX+vMPPAc0nVcHGBAAsX0gVAGjfBRpjBL0
         xo0rkj7Hlnik9dTjw26mhAmBJtta5Jpk9jqS41x8s71AM8fl4UrmDYgOJS5khGqV74r9
         tpILDkaoOsKH7XVUpqRVIswFJjlAhgARw485WqJh82n0A5QRXDTn4FZBZ8z5D9msLnXt
         9/Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MbAa01ayooLRjvmZvMsHwzRjI7CpSiorxRvp5VWlJKg=;
        b=zlMyV/Cv1fI625xgNN9sK9ES98Y9wGPtkI3QMG6pnbAaC0OdfbYOGBW3qkkd2vbN9W
         NMASeZzqafGCp/+BvNQsOtny5wHpPau8pd362qARpiXrw2YPJtnp419YlbqS/GvtQNH1
         NUO/swXeO1X39sBVWffhnNEf04fFWvhAyDG8eUs8Nl0Qkk6IwhIBjLvIXvQT7QhMCKU6
         2E+7ZuTJkHmIOgYnlMZugLcAQ3owAibcQCt7cSMx1mjcazzbazMTJW75mRhsWfO8mgcE
         aG4pYCrpTenrlGmrPT5RAk519/xSuspEbANQqXR/A2p1XW7MhmLInxjIcDqw6ATdv2CI
         r1CQ==
X-Gm-Message-State: AJIora9A9b8LzrqF1Dt8q9WVF+Bx1GG+N2Rv6Y/bzddTci4m4OKoYRj6
        u1Ekm5zeT+fn5GhnqKNglDUQEX3FXhRVog==
X-Google-Smtp-Source: AGRyM1sPBtsgreVfUCk2KH/JF6UCLMGB0N2QZSw76EbKMDXlrnzfHH4W9hK5NAZpV+vLK7ecGdNNMMRd2eVD+g==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:6d55:0:b0:317:90a6:83b1 with SMTP id
 i82-20020a816d55000000b0031790a683b1mr2138253ywc.170.1655874794444; Tue, 21
 Jun 2022 22:13:14 -0700 (PDT)
Date:   Wed, 22 Jun 2022 05:12:44 +0000
In-Reply-To: <20220622051255.700309-1-edumazet@google.com>
Message-Id: <20220622051255.700309-9-edumazet@google.com>
Mime-Version: 1.0
References: <20220622051255.700309-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH net-next 08/19] ipmr: do not acquire mrt_lock while calling ip_mr_forward()
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

