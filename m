Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECAA0554222
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 07:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356733AbiFVFNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 01:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356625AbiFVFNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 01:13:09 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE4534B82
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:08 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id l6-20020a25bf86000000b00668c915a3f2so10477245ybk.4
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=mZRbJA5T4re50Qrp6655mQ8KrSQgpuu0qDvl8PjRB/M=;
        b=kY3pDd7DhbHn07dJS5j0VF6hsXgQcYcXTT23pOoOj+rgYDKMa4F9LzTbhIodEiwQ7O
         dYMrbjg09GWJI56iyAnm9kQAElVdA4+NjJjZZJ5V6G0djj992j+/9y0qyEFpK/rVKyaF
         O+CG22Try8fgzgt2lBFpCTjojLCArR0ImX07PjecIDvl3ikynDipz0RLAEX88aN15kpw
         Z76shgF92QGzNMnRn1K9/FmRyQruSt0t+w3pdohrwmmCS8uPdyVlxxKBxYBRFZ30C/mz
         4Kv4Z2D/BLgfJxRdwVeG+Kvbp/c4FxabJGllFDAjKSaXwSyNW0koI46swikZTrFydWrH
         kfqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=mZRbJA5T4re50Qrp6655mQ8KrSQgpuu0qDvl8PjRB/M=;
        b=EqMIVs4yoH31t/l2l6CYfuj8Lhm0ezvcRdCmW6HcqlIfYuH/EwRRvTSPS/NgslUnG8
         uHx0LTMnfAa3eM/2xai+LL8uBym+W5yG202pJY7pDfOjT0gKGP2N7UHDvkR/kLfd7XWb
         uyBeEP4h+ih8mFChpdNXKniG0kctxFMefUnfQvv7RFIlZgz35BbzOjX658ZtyManWb1Q
         8vL5FMR831+9lXrTdpYtSUJHlpilqiacpcOwuRLbMSiDCCFSPyC98A3P8+1u4HwiPiCN
         gaJRSvFd76URGQHInpRGTojbEtUEhCzPCiqO73hZAKO4oygr8siSITGVN63T8xKqaRqQ
         WS6g==
X-Gm-Message-State: AJIora+69iuTihANvH21euQuOVVrs9f9orjf1ZZ/zyvUuR/9llCfYjOT
        VhuyEPrgImTWT2Ap3yAR+a+xM4vxWUBnQg==
X-Google-Smtp-Source: AGRyM1vhQDnbazpnoLktp8Y4aoUUIylELGj8s5yWlRgXItCKe19PwntY5XPYquy6VT7vkg0u2wNRLUxKfPs/Dw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a0d:d7c7:0:b0:317:bfe8:4f2 with SMTP id
 z190-20020a0dd7c7000000b00317bfe804f2mr2146007ywd.276.1655874787878; Tue, 21
 Jun 2022 22:13:07 -0700 (PDT)
Date:   Wed, 22 Jun 2022 05:12:40 +0000
In-Reply-To: <20220622051255.700309-1-edumazet@google.com>
Message-Id: <20220622051255.700309-5-edumazet@google.com>
Mime-Version: 1.0
References: <20220622051255.700309-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH net-next 04/19] ipmr: ipmr_cache_report() changes
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

