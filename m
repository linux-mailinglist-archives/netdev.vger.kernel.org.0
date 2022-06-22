Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4AB55422B
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 07:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356131AbiFVFPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 01:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356975AbiFVFNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 01:13:22 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7657D35DEA
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:18 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-317f6128c86so47401857b3.22
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VrbWSc5Rvr0QaUW4lFQUf++mBAUZtrxHkQQzmsdcRk0=;
        b=lFr8g+J2yygc7gP9acMYbX5p+2YxnlA29iCFvRqAdN6Lv7RE7M7lj2DDJYii1iPbDR
         YIZuhKubKqHl7rh9CNgJ1WenmdP7NPSsSJsg++Uka1rZPNTvn9HKxxPnTgNoIRS+Almw
         3DhvPt26Qnq/ztIbGFaU9qp3NFeO7iFPWYiYZRRtBqtNs8QQWeENs3GQ0VwD+VHs/K1h
         OraB2Xi6ILSUpbV5XZ9hFc6ob5UnRDK3fQJ+CFte6DOfEcyDetuDvZb7hI/uzMwOt3BQ
         K1gNDYhOMJEhCtpBmLVdEes2BUD2voyo+bD35YeivE8Qc26OyTWRo0FL0qzxGzUM4DlU
         xinw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VrbWSc5Rvr0QaUW4lFQUf++mBAUZtrxHkQQzmsdcRk0=;
        b=OgX2D+q9e24aCYqO9onN7eJogHAuKB90HO+8jO92Nd9OfyIUqC4uHlXyddT4CaAqj5
         4Wjgw6KKcDZ+u4eLR8ceVf7kjklT4DyzYbmIxgWbpf/ZC/rvV3F0Lwzn9br7y8szqz0f
         7cZaLoGZ9HjFlyQspsuDGkN8dl3Z73DDt4nBZvaaKPXL6hcEC1C90tfeIzkClJRS/rRH
         QX+pLRrNhLAk15cTGLctBxkuOFPXkmrcM3h2oWuZgKzv933SSXM8ZZdUFgGi8zRJf8SO
         1g+8pI57IdQGu+g+tlwG5Y7BQhOGd51ajAkgBg5iA0nGuisox8g/yJH5ni7CiDEMI+1E
         05rA==
X-Gm-Message-State: AJIora83hab3qXrom+Esxum0+JufQ+vgWFrcKWJTRoo1vWDFEPQ/sels
        DrmNcMOyVZqRRu3Ku3EHetdTtZGLljPAlw==
X-Google-Smtp-Source: AGRyM1thzYG74QoIY75/LFGIjygNwZzH23N6wgF7a/Enu1Znz5QyHrD77/VPxVD/87xv0359eFBssQz81Dld9w==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:5ad4:0:b0:317:7320:4c23 with SMTP id
 o203-20020a815ad4000000b0031773204c23mr2018505ywb.520.1655874797836; Tue, 21
 Jun 2022 22:13:17 -0700 (PDT)
Date:   Wed, 22 Jun 2022 05:12:46 +0000
In-Reply-To: <20220622051255.700309-1-edumazet@google.com>
Message-Id: <20220622051255.700309-11-edumazet@google.com>
Mime-Version: 1.0
References: <20220622051255.700309-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH net-next 10/19] ip6mr: ip6mr_cache_report() changes
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

ip6mr_cache_report() first argument can be marked const, and we change
the caller convention about which lock needs to be held.

Instead of read_lock(&mrt_lock), we can use rcu_read_lock().

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/ip6mr.c | 35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 44cb3d88bbd6f85ce0c8e9054dd3d578b7b3733b..a6d97952bf5306c245996c612107d0c851bbc822 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -91,11 +91,11 @@ static void ip6mr_free_table(struct mr_table *mrt);
 static void ip6_mr_forward(struct net *net, struct mr_table *mrt,
 			   struct net_device *dev, struct sk_buff *skb,
 			   struct mfc6_cache *cache);
-static int ip6mr_cache_report(struct mr_table *mrt, struct sk_buff *pkt,
+static int ip6mr_cache_report(const struct mr_table *mrt, struct sk_buff *pkt,
 			      mifi_t mifi, int assert);
 static void mr6_netlink_event(struct mr_table *mrt, struct mfc6_cache *mfc,
 			      int cmd);
-static void mrt6msg_netlink_event(struct mr_table *mrt, struct sk_buff *pkt);
+static void mrt6msg_netlink_event(const struct mr_table *mrt, struct sk_buff *pkt);
 static int ip6mr_rtm_dumproute(struct sk_buff *skb,
 			       struct netlink_callback *cb);
 static void mroute_clean_tables(struct mr_table *mrt, int flags);
@@ -608,11 +608,12 @@ static netdev_tx_t reg_vif_xmit(struct sk_buff *skb,
 	if (ip6mr_fib_lookup(net, &fl6, &mrt) < 0)
 		goto tx_err;
 
-	read_lock(&mrt_lock);
 	dev->stats.tx_bytes += skb->len;
 	dev->stats.tx_packets++;
-	ip6mr_cache_report(mrt, skb, mrt->mroute_reg_vif_num, MRT6MSG_WHOLEPKT);
-	read_unlock(&mrt_lock);
+	rcu_read_lock();
+	ip6mr_cache_report(mrt, skb, READ_ONCE(mrt->mroute_reg_vif_num),
+			   MRT6MSG_WHOLEPKT);
+	rcu_read_unlock();
 	kfree_skb(skb);
 	return NETDEV_TX_OK;
 
@@ -718,8 +719,10 @@ static int mif6_delete(struct mr_table *mrt, int vifi, int notify,
 	RCU_INIT_POINTER(v->dev, NULL);
 
 #ifdef CONFIG_IPV6_PIMSM_V2
-	if (vifi == mrt->mroute_reg_vif_num)
-		mrt->mroute_reg_vif_num = -1;
+	if (vifi == mrt->mroute_reg_vif_num) {
+		/* Pairs with READ_ONCE() in ip6mr_cache_report() and reg_vif_xmit() */
+		WRITE_ONCE(mrt->mroute_reg_vif_num, -1);
+	}
 #endif
 
 	if (vifi + 1 == mrt->maxvif) {
@@ -922,7 +925,7 @@ static int mif6_add(struct net *net, struct mr_table *mrt,
 	netdev_tracker_alloc(dev, &v->dev_tracker, GFP_ATOMIC);
 #ifdef CONFIG_IPV6_PIMSM_V2
 	if (v->flags & MIFF_REGISTER)
-		mrt->mroute_reg_vif_num = vifi;
+		WRITE_ONCE(mrt->mroute_reg_vif_num, vifi);
 #endif
 	if (vifi + 1 > mrt->maxvif)
 		mrt->maxvif = vifi + 1;
@@ -1033,10 +1036,10 @@ static void ip6mr_cache_resolve(struct net *net, struct mr_table *mrt,
 /*
  *	Bounce a cache query up to pim6sd and netlink.
  *
- *	Called under mrt_lock.
+ *	Called under rcu_read_lock()
  */
 
-static int ip6mr_cache_report(struct mr_table *mrt, struct sk_buff *pkt,
+static int ip6mr_cache_report(const struct mr_table *mrt, struct sk_buff *pkt,
 			      mifi_t mifi, int assert)
 {
 	struct sock *mroute6_sk;
@@ -1077,7 +1080,7 @@ static int ip6mr_cache_report(struct mr_table *mrt, struct sk_buff *pkt,
 		if (assert == MRT6MSG_WRMIFWHOLE)
 			msg->im6_mif = mifi;
 		else
-			msg->im6_mif = mrt->mroute_reg_vif_num;
+			msg->im6_mif = READ_ONCE(mrt->mroute_reg_vif_num);
 		msg->im6_pad = 0;
 		msg->im6_src = ipv6_hdr(pkt)->saddr;
 		msg->im6_dst = ipv6_hdr(pkt)->daddr;
@@ -1112,10 +1115,8 @@ static int ip6mr_cache_report(struct mr_table *mrt, struct sk_buff *pkt,
 	skb->ip_summed = CHECKSUM_UNNECESSARY;
 	}
 
-	rcu_read_lock();
 	mroute6_sk = rcu_dereference(mrt->mroute_sk);
 	if (!mroute6_sk) {
-		rcu_read_unlock();
 		kfree_skb(skb);
 		return -EINVAL;
 	}
@@ -1124,7 +1125,7 @@ static int ip6mr_cache_report(struct mr_table *mrt, struct sk_buff *pkt,
 
 	/* Deliver to user space multicast routing algorithms */
 	ret = sock_queue_rcv_skb(mroute6_sk, skb);
-	rcu_read_unlock();
+
 	if (ret < 0) {
 		net_warn_ratelimited("mroute6: pending queue full, dropping entries\n");
 		kfree_skb(skb);
@@ -2042,7 +2043,9 @@ static int ip6mr_forward2(struct net *net, struct mr_table *mrt,
 		vif->bytes_out += skb->len;
 		vif_dev->stats.tx_bytes += skb->len;
 		vif_dev->stats.tx_packets++;
+		rcu_read_lock();
 		ip6mr_cache_report(mrt, skb, vifi, MRT6MSG_WHOLEPKT);
+		rcu_read_unlock();
 		goto out_free;
 	}
 #endif
@@ -2155,10 +2158,12 @@ static void ip6_mr_forward(struct net *net, struct mr_table *mrt,
 			       c->_c.mfc_un.res.last_assert +
 			       MFC_ASSERT_THRESH)) {
 			c->_c.mfc_un.res.last_assert = jiffies;
+			rcu_read_lock();
 			ip6mr_cache_report(mrt, skb, true_vifi, MRT6MSG_WRONGMIF);
 			if (mrt->mroute_do_wrvifwhole)
 				ip6mr_cache_report(mrt, skb, true_vifi,
 						   MRT6MSG_WRMIFWHOLE);
+			rcu_read_unlock();
 		}
 		goto dont_forward;
 	}
@@ -2465,7 +2470,7 @@ static size_t mrt6msg_netlink_msgsize(size_t payloadlen)
 	return len;
 }
 
-static void mrt6msg_netlink_event(struct mr_table *mrt, struct sk_buff *pkt)
+static void mrt6msg_netlink_event(const struct mr_table *mrt, struct sk_buff *pkt)
 {
 	struct net *net = read_pnet(&mrt->net);
 	struct nlmsghdr *nlh;
-- 
2.37.0.rc0.104.g0611611a94-goog

