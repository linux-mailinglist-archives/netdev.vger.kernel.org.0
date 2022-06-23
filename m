Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B42665571A1
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 06:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbiFWEkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 00:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347318AbiFWEfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 00:35:10 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF3530F71
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:35:09 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-317765eb7ccso156829137b3.13
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=mZRbJA5T4re50Qrp6655mQ8KrSQgpuu0qDvl8PjRB/M=;
        b=npAUnBoD4NEvzk4J/fUK28YJ337Zcoyrxtt8ljucKHheL73wfsS2GQ1NYcamlIZaLS
         +ZE3QP5/YlJ2UKRwDwqyU2G/QdVWxUN475OtN65S/pXm5JooNmSdqDq/SOfNqaXerNU5
         d91hab/fXjM6zxYr3JwC3fJ5xaHhxpKRbRLTPtgJybGDdjCBePd7D6r4fdcXmbOyhPPR
         w2ydD3HUNkSDF8JWgPpK7uAZ4mbgED1LEfiLOxa79Gh8hQByV8SFDCyVHkwkE1QoZIYg
         okVB1Ola7CUnsOVZ7s3wCe3AS9PEiTAKQeedyV1YGzUM4qmRSg6xXpjg+ok+4yOOn1nB
         GHfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=mZRbJA5T4re50Qrp6655mQ8KrSQgpuu0qDvl8PjRB/M=;
        b=JojDbmehM72qCpo43Zd33iv8Lm9YrcKBOnFhAHQ0pBWLsMkPUQ66RIPFMNbdhkmRb6
         CIibGNMDjregHKfP3fdKdw06OPC06KsN010ygZYHNb1BaKrfu8woEkNSSTFJd33a/2US
         LnRampmZhdcIs3TkjEWuEkfIEKF3FC/vB6RM05UBqXc93ud5EllFRcgW+dXo9RMlLhBg
         AdQc77iQB2THIetu/Phhukk822uK7N/aRTNjg+86HDmhacjBwn5H/1jXwwQ+05mD12sN
         qgGIXBCAkHN8wopL8WPNzRNSQU75k3E2+ZETezzygXdHk1kLkkrAw9CUFpd9IF+8qlGc
         e7SA==
X-Gm-Message-State: AJIora+gdN1yJ+5SDeBf3aENjSN6qFPqpzUwrruRPo+XYiCSjTdqxtaw
        b9Js3neoWtFQbtgRp2DzEIR77ns2SgNyCw==
X-Google-Smtp-Source: AGRyM1siVasfF+Gvj5/K4q8iM0M1NrY9F6RFLGBeJjOvknVsZlJDP1tdY6eUsNAz8qHeu2yeOsPDh/tb3x1HpQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:a090:0:b0:664:83b4:bbd3 with SMTP id
 y16-20020a25a090000000b0066483b4bbd3mr7740038ybh.243.1655958908780; Wed, 22
 Jun 2022 21:35:08 -0700 (PDT)
Date:   Thu, 23 Jun 2022 04:34:34 +0000
In-Reply-To: <20220623043449.1217288-1-edumazet@google.com>
Message-Id: <20220623043449.1217288-5-edumazet@google.com>
Mime-Version: 1.0
References: <20220623043449.1217288-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH v2 net-next 04/19] ipmr: ipmr_cache_report() changes
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

ipmr_cache_report() first argument can be marked const, and we change
the caller convention about which lock needs to be held.

Instead of read_lock(&mrt_lock), we can use rcu_read_lock().

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/ipmr.c | 45 +++++++++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 16 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 6710324497cae3bbc2fcdd12d6e1d44eed5215b3..8fe7a688cf41deeb99c7ca554f1788a956d2fdb9 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -106,7 +106,7 @@ static void ipmr_free_table(struct mr_table *mrt);
 static void ip_mr_forward(struct net *net, struct mr_table *mrt,
 			  struct net_device *dev, struct sk_buff *skb,
 			  struct mfc_cache *cache, int local);
-static int ipmr_cache_report(struct mr_table *mrt,
+static int ipmr_cache_report(const struct mr_table *mrt,
 			     struct sk_buff *pkt, vifi_t vifi, int assert);
 static void mroute_netlink_event(struct mr_table *mrt, struct mfc_cache *mfc,
 				 int cmd);
@@ -507,11 +507,15 @@ static netdev_tx_t reg_vif_xmit(struct sk_buff *skb, struct net_device *dev)
 		return err;
 	}
 
-	read_lock(&mrt_lock);
 	dev->stats.tx_bytes += skb->len;
 	dev->stats.tx_packets++;
-	ipmr_cache_report(mrt, skb, mrt->mroute_reg_vif_num, IGMPMSG_WHOLEPKT);
-	read_unlock(&mrt_lock);
+	rcu_read_lock();
+
+	/* Pairs with WRITE_ONCE() in vif_add() and vif_delete() */
+	ipmr_cache_report(mrt, skb, READ_ONCE(mrt->mroute_reg_vif_num),
+			  IGMPMSG_WHOLEPKT);
+
+	rcu_read_unlock();
 	kfree_skb(skb);
 	return NETDEV_TX_OK;
 }
@@ -665,9 +669,10 @@ static int vif_delete(struct mr_table *mrt, int vifi, int notify,
 				      vifi, mrt->id);
 	RCU_INIT_POINTER(v->dev, NULL);
 
-	if (vifi == mrt->mroute_reg_vif_num)
-		mrt->mroute_reg_vif_num = -1;
-
+	if (vifi == mrt->mroute_reg_vif_num) {
+		/* Pairs with READ_ONCE() in ipmr_cache_report() and reg_vif_xmit() */
+		WRITE_ONCE(mrt->mroute_reg_vif_num, -1);
+	}
 	if (vifi + 1 == mrt->maxvif) {
 		int tmp;
 
@@ -895,8 +900,10 @@ static int vif_add(struct net *net, struct mr_table *mrt,
 	write_lock_bh(&mrt_lock);
 	rcu_assign_pointer(v->dev, dev);
 	netdev_tracker_alloc(dev, &v->dev_tracker, GFP_ATOMIC);
-	if (v->flags & VIFF_REGISTER)
-		mrt->mroute_reg_vif_num = vifi;
+	if (v->flags & VIFF_REGISTER) {
+		/* Pairs with READ_ONCE() in ipmr_cache_report() and reg_vif_xmit() */
+		WRITE_ONCE(mrt->mroute_reg_vif_num, vifi);
+	}
 	if (vifi+1 > mrt->maxvif)
 		mrt->maxvif = vifi+1;
 	write_unlock_bh(&mrt_lock);
@@ -1005,9 +1012,9 @@ static void ipmr_cache_resolve(struct net *net, struct mr_table *mrt,
 
 /* Bounce a cache query up to mrouted and netlink.
  *
- * Called under mrt_lock.
+ * Called under rcu_read_lock().
  */
-static int ipmr_cache_report(struct mr_table *mrt,
+static int ipmr_cache_report(const struct mr_table *mrt,
 			     struct sk_buff *pkt, vifi_t vifi, int assert)
 {
 	const int ihl = ip_hdrlen(pkt);
@@ -1042,8 +1049,11 @@ static int ipmr_cache_report(struct mr_table *mrt,
 			msg->im_vif = vifi;
 			msg->im_vif_hi = vifi >> 8;
 		} else {
-			msg->im_vif = mrt->mroute_reg_vif_num;
-			msg->im_vif_hi = mrt->mroute_reg_vif_num >> 8;
+			/* Pairs with WRITE_ONCE() in vif_add() and vif_delete() */
+			int vif_num = READ_ONCE(mrt->mroute_reg_vif_num);
+
+			msg->im_vif = vif_num;
+			msg->im_vif_hi = vif_num >> 8;
 		}
 		ip_hdr(skb)->ihl = sizeof(struct iphdr) >> 2;
 		ip_hdr(skb)->tot_len = htons(ntohs(ip_hdr(pkt)->tot_len) +
@@ -1068,10 +1078,8 @@ static int ipmr_cache_report(struct mr_table *mrt,
 		skb->transport_header = skb->network_header;
 	}
 
-	rcu_read_lock();
 	mroute_sk = rcu_dereference(mrt->mroute_sk);
 	if (!mroute_sk) {
-		rcu_read_unlock();
 		kfree_skb(skb);
 		return -EINVAL;
 	}
@@ -1080,7 +1088,7 @@ static int ipmr_cache_report(struct mr_table *mrt,
 
 	/* Deliver to mrouted */
 	ret = sock_queue_rcv_skb(mroute_sk, skb);
-	rcu_read_unlock();
+
 	if (ret < 0) {
 		net_warn_ratelimited("mroute: pending queue full, dropping entries\n");
 		kfree_skb(skb);
@@ -1090,6 +1098,7 @@ static int ipmr_cache_report(struct mr_table *mrt,
 }
 
 /* Queue a packet for resolution. It gets locked cache entry! */
+/* Called under rcu_read_lock() */
 static int ipmr_cache_unresolved(struct mr_table *mrt, vifi_t vifi,
 				 struct sk_buff *skb, struct net_device *dev)
 {
@@ -1830,7 +1839,9 @@ static void ipmr_queue_xmit(struct net *net, struct mr_table *mrt,
 		vif->bytes_out += skb->len;
 		vif_dev->stats.tx_bytes += skb->len;
 		vif_dev->stats.tx_packets++;
+		rcu_read_lock();
 		ipmr_cache_report(mrt, skb, vifi, IGMPMSG_WHOLEPKT);
+		rcu_read_unlock();
 		goto out_free;
 	}
 
@@ -1980,10 +1991,12 @@ static void ip_mr_forward(struct net *net, struct mr_table *mrt,
 			       c->_c.mfc_un.res.last_assert +
 			       MFC_ASSERT_THRESH)) {
 			c->_c.mfc_un.res.last_assert = jiffies;
+			rcu_read_lock();
 			ipmr_cache_report(mrt, skb, true_vifi, IGMPMSG_WRONGVIF);
 			if (mrt->mroute_do_wrvifwhole)
 				ipmr_cache_report(mrt, skb, true_vifi,
 						  IGMPMSG_WRVIFWHOLE);
+			rcu_read_unlock();
 		}
 		goto dont_forward;
 	}
-- 
2.37.0.rc0.104.g0611611a94-goog

