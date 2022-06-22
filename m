Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B31F55421B
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 07:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356633AbiFVFNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 01:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356602AbiFVFNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 01:13:06 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5AEC34678
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:04 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3177d1fe9f1so120218057b3.0
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LnGapFElVHJ5Xu6TsypR+UtkUB7GlltsZy8jxki75xQ=;
        b=HiNiwCY9ctKgCw4WprOnnsMInUIAJCK3X8Xzbz/YTpt1yr8v+Ok+73aVhC+QdbGy2u
         RVt2Rk/wsQUuW5QO6cVrrbqsOPS6xMv0ky23G2IlnKVqPcbt0whR4qXOg0Wnz2/TPCnm
         mWPRY/kXuqWbKCOyBRoK/zsyBg2j6paNMejKQ9CT2/uhPtAIwfkz0ABm7cKeMOU9Y82O
         k2PVoPnYqZ6OkeLysYmTvrCzyZCN6HeR4cL9IUpYaIeayvalQ5LLsKbxkVRh1fgzK1zj
         fYtjpII30aG/Oc9yaTeMBz/szii7HSGDAbbp0156tsbMl+Vpuy/6xcvC67JU0yJJY60I
         iZqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LnGapFElVHJ5Xu6TsypR+UtkUB7GlltsZy8jxki75xQ=;
        b=dYGyxq24aeGoj8ljUm0yf+4EHbVNkhTKoPlitxuPy3jEf2CXd7t6Yal4ypxTVAEJVv
         VbD/q6cPfcVuhsfjKRJDAvRoLWqCoXglJZYELNYw2RYO7YBtrZoT4H42PzDnP8BaFAd/
         Tg+Z9Oa1XNPxfBPY1us1Vviazvb5r90XEcg7o5+erkDwUUsiwYPpZSZA3NvI8sqhM+b+
         Dex6gDUsO1PAiXsFj64zZLIzNnTcgD7KL/lZef0kq6S6F8TJBcNt/hT6O36Ffr9ILtLZ
         U0xskY69VU3frPgmL7rA7YTN3Swx+RjcmcgLpGVDt0ojawEP7gPrW5nmG325B+0K2a2j
         7MYA==
X-Gm-Message-State: AJIora8Qq8nWGYpKpgtdd+jvbNF93FVx8cSa9qhcTfD78iG0ZtiT0bUi
        jCqOYcwp40tc+oiCsUDmzDY2Y84tcmmaoQ==
X-Google-Smtp-Source: AGRyM1tNfqAdC+LQw6M2XGvQtcNGERedPp8NmNJq4sesqh+ZmYGhDoCsR4Va4aiReCxBsU0G27kZwu2zi5xRVA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:d48:0:b0:669:4ac2:9d4b with SMTP id
 69-20020a250d48000000b006694ac29d4bmr1725266ybn.491.1655874784059; Tue, 21
 Jun 2022 22:13:04 -0700 (PDT)
Date:   Wed, 22 Jun 2022 05:12:38 +0000
In-Reply-To: <20220622051255.700309-1-edumazet@google.com>
Message-Id: <20220622051255.700309-3-edumazet@google.com>
Mime-Version: 1.0
References: <20220622051255.700309-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH net-next 02/19] ipmr: add rcu protection over (struct vif_device)->dev
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

We will soon use RCU instead of rwlock in impr.

This preliminary patch adds proper rcu verbs to read/write
(struct vif_device)->dev

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/mroute_base.h | 11 ++++---
 net/ipv4/ipmr.c             | 65 ++++++++++++++++++++++---------------
 net/ipv4/ipmr_base.c        | 49 ++++++++++++++++++----------
 net/ipv6/ip6mr.c            | 63 +++++++++++++++++++----------------
 4 files changed, 111 insertions(+), 77 deletions(-)

diff --git a/include/linux/mroute_base.h b/include/linux/mroute_base.h
index e05ee9f001ffbf30f7b26ab5555e2db5cc058560..10d1e4fb4e9fe387d914c83d135ed6a8f284c374 100644
--- a/include/linux/mroute_base.h
+++ b/include/linux/mroute_base.h
@@ -26,7 +26,7 @@
  * @remote: Remote address for tunnels
  */
 struct vif_device {
-	struct net_device *dev;
+	struct net_device __rcu *dev;
 	netdevice_tracker dev_tracker;
 	unsigned long bytes_in, bytes_out;
 	unsigned long pkt_in, pkt_out;
@@ -52,6 +52,7 @@ static inline int mr_call_vif_notifier(struct notifier_block *nb,
 				       unsigned short family,
 				       enum fib_event_type event_type,
 				       struct vif_device *vif,
+				       struct net_device *vif_dev,
 				       unsigned short vif_index, u32 tb_id,
 				       struct netlink_ext_ack *extack)
 {
@@ -60,7 +61,7 @@ static inline int mr_call_vif_notifier(struct notifier_block *nb,
 			.family = family,
 			.extack = extack,
 		},
-		.dev = vif->dev,
+		.dev = vif_dev,
 		.vif_index = vif_index,
 		.vif_flags = vif->flags,
 		.tb_id = tb_id,
@@ -73,6 +74,7 @@ static inline int mr_call_vif_notifiers(struct net *net,
 					unsigned short family,
 					enum fib_event_type event_type,
 					struct vif_device *vif,
+					struct net_device *vif_dev,
 					unsigned short vif_index, u32 tb_id,
 					unsigned int *ipmr_seq)
 {
@@ -80,7 +82,7 @@ static inline int mr_call_vif_notifiers(struct net *net,
 		.info = {
 			.family = family,
 		},
-		.dev = vif->dev,
+		.dev = vif_dev,
 		.vif_index = vif_index,
 		.vif_flags = vif->flags,
 		.tb_id = tb_id,
@@ -98,7 +100,8 @@ static inline int mr_call_vif_notifiers(struct net *net,
 #define MAXVIFS	32
 #endif
 
-#define VIF_EXISTS(_mrt, _idx) (!!((_mrt)->vif_table[_idx].dev))
+/* Note: This helper is deprecated. */
+#define VIF_EXISTS(_mrt, _idx) (!!rcu_access_pointer((_mrt)->vif_table[_idx].dev))
 
 /* mfc_flags:
  * MFC_STATIC - the entry was added statically (not by a routing daemon)
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 8324e541d193b0024a82d83149a0ee3b5967f2a9..10371a9e78fc41e8562fa8d81222a8ae24e2fbb6 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -79,6 +79,12 @@ struct ipmr_result {
 
 static DEFINE_RWLOCK(mrt_lock);
 
+static struct net_device *vif_dev_read(const struct vif_device *vif)
+{
+	return rcu_dereference_check(vif->dev,
+				     lockdep_is_held(&mrt_lock));
+}
+
 /* Multicast router control variables */
 
 /* Special spinlock for queue of unresolved entries */
@@ -586,7 +592,7 @@ static int __pim_rcv(struct mr_table *mrt, struct sk_buff *skb,
 
 	read_lock(&mrt_lock);
 	if (mrt->mroute_reg_vif_num >= 0)
-		reg_dev = mrt->vif_table[mrt->mroute_reg_vif_num].dev;
+		reg_dev = vif_dev_read(&mrt->vif_table[mrt->mroute_reg_vif_num]);
 	read_unlock(&mrt_lock);
 
 	if (!reg_dev)
@@ -614,10 +620,11 @@ static struct net_device *ipmr_reg_vif(struct net *net, struct mr_table *mrt)
 static int call_ipmr_vif_entry_notifiers(struct net *net,
 					 enum fib_event_type event_type,
 					 struct vif_device *vif,
+					 struct net_device *vif_dev,
 					 vifi_t vif_index, u32 tb_id)
 {
 	return mr_call_vif_notifiers(net, RTNL_FAMILY_IPMR, event_type,
-				     vif, vif_index, tb_id,
+				     vif, vif_dev, vif_index, tb_id,
 				     &net->ipv4.ipmr_seq);
 }
 
@@ -649,18 +656,14 @@ static int vif_delete(struct mr_table *mrt, int vifi, int notify,
 
 	v = &mrt->vif_table[vifi];
 
-	if (VIF_EXISTS(mrt, vifi))
-		call_ipmr_vif_entry_notifiers(net, FIB_EVENT_VIF_DEL, v, vifi,
-					      mrt->id);
+	dev = rtnl_dereference(v->dev);
+	if (!dev)
+		return -EADDRNOTAVAIL;
 
 	write_lock_bh(&mrt_lock);
-	dev = v->dev;
-	v->dev = NULL;
-
-	if (!dev) {
-		write_unlock_bh(&mrt_lock);
-		return -EADDRNOTAVAIL;
-	}
+	call_ipmr_vif_entry_notifiers(net, FIB_EVENT_VIF_DEL, v, dev,
+				      vifi, mrt->id);
+	RCU_INIT_POINTER(v->dev, NULL);
 
 	if (vifi == mrt->mroute_reg_vif_num)
 		mrt->mroute_reg_vif_num = -1;
@@ -890,14 +893,15 @@ static int vif_add(struct net *net, struct mr_table *mrt,
 
 	/* And finish update writing critical data */
 	write_lock_bh(&mrt_lock);
-	v->dev = dev;
+	rcu_assign_pointer(v->dev, dev);
 	netdev_tracker_alloc(dev, &v->dev_tracker, GFP_ATOMIC);
 	if (v->flags & VIFF_REGISTER)
 		mrt->mroute_reg_vif_num = vifi;
 	if (vifi+1 > mrt->maxvif)
 		mrt->maxvif = vifi+1;
 	write_unlock_bh(&mrt_lock);
-	call_ipmr_vif_entry_notifiers(net, FIB_EVENT_VIF_ADD, v, vifi, mrt->id);
+	call_ipmr_vif_entry_notifiers(net, FIB_EVENT_VIF_ADD, v, dev,
+				      vifi, mrt->id);
 	return 0;
 }
 
@@ -1726,7 +1730,7 @@ static int ipmr_device_event(struct notifier_block *this, unsigned long event, v
 	ipmr_for_each_table(mrt, net) {
 		v = &mrt->vif_table[0];
 		for (ct = 0; ct < mrt->maxvif; ct++, v++) {
-			if (v->dev == dev)
+			if (rcu_access_pointer(v->dev) == dev)
 				vif_delete(mrt, ct, 1, NULL);
 		}
 	}
@@ -1811,19 +1815,21 @@ static void ipmr_queue_xmit(struct net *net, struct mr_table *mrt,
 {
 	const struct iphdr *iph = ip_hdr(skb);
 	struct vif_device *vif = &mrt->vif_table[vifi];
+	struct net_device *vif_dev;
 	struct net_device *dev;
 	struct rtable *rt;
 	struct flowi4 fl4;
 	int    encap = 0;
 
-	if (!vif->dev)
+	vif_dev = vif_dev_read(vif);
+	if (!vif_dev)
 		goto out_free;
 
 	if (vif->flags & VIFF_REGISTER) {
 		vif->pkt_out++;
 		vif->bytes_out += skb->len;
-		vif->dev->stats.tx_bytes += skb->len;
-		vif->dev->stats.tx_packets++;
+		vif_dev->stats.tx_bytes += skb->len;
+		vif_dev->stats.tx_packets++;
 		ipmr_cache_report(mrt, skb, vifi, IGMPMSG_WHOLEPKT);
 		goto out_free;
 	}
@@ -1881,8 +1887,8 @@ static void ipmr_queue_xmit(struct net *net, struct mr_table *mrt,
 	if (vif->flags & VIFF_TUNNEL) {
 		ip_encap(net, skb, vif->local, vif->remote);
 		/* FIXME: extra output firewall step used to be here. --RR */
-		vif->dev->stats.tx_packets++;
-		vif->dev->stats.tx_bytes += skb->len;
+		vif_dev->stats.tx_packets++;
+		vif_dev->stats.tx_bytes += skb->len;
 	}
 
 	IPCB(skb)->flags |= IPSKB_FORWARDED;
@@ -1911,7 +1917,7 @@ static int ipmr_find_vif(struct mr_table *mrt, struct net_device *dev)
 	int ct;
 
 	for (ct = mrt->maxvif-1; ct >= 0; ct--) {
-		if (mrt->vif_table[ct].dev == dev)
+		if (rcu_access_pointer(mrt->vif_table[ct].dev) == dev)
 			break;
 	}
 	return ct;
@@ -1944,7 +1950,7 @@ static void ip_mr_forward(struct net *net, struct mr_table *mrt,
 	}
 
 	/* Wrong interface: drop packet and (maybe) send PIM assert. */
-	if (mrt->vif_table[vif].dev != dev) {
+	if (rcu_access_pointer(mrt->vif_table[vif].dev) != dev) {
 		if (rt_is_output_route(skb_rtable(skb))) {
 			/* It is our own packet, looped back.
 			 * Very complicated situation...
@@ -2744,18 +2750,21 @@ static bool ipmr_fill_table(struct mr_table *mrt, struct sk_buff *skb)
 
 static bool ipmr_fill_vif(struct mr_table *mrt, u32 vifid, struct sk_buff *skb)
 {
+	struct net_device *vif_dev;
 	struct nlattr *vif_nest;
 	struct vif_device *vif;
 
+	vif = &mrt->vif_table[vifid];
+	vif_dev = vif_dev_read(vif);
 	/* if the VIF doesn't exist just continue */
-	if (!VIF_EXISTS(mrt, vifid))
+	if (!vif_dev)
 		return true;
 
-	vif = &mrt->vif_table[vifid];
 	vif_nest = nla_nest_start_noflag(skb, IPMRA_VIF);
 	if (!vif_nest)
 		return false;
-	if (nla_put_u32(skb, IPMRA_VIFA_IFINDEX, vif->dev->ifindex) ||
+
+	if (nla_put_u32(skb, IPMRA_VIFA_IFINDEX, vif_dev->ifindex) ||
 	    nla_put_u32(skb, IPMRA_VIFA_VIF_ID, vifid) ||
 	    nla_put_u16(skb, IPMRA_VIFA_FLAGS, vif->flags) ||
 	    nla_put_u64_64bit(skb, IPMRA_VIFA_BYTES_IN, vif->bytes_in,
@@ -2919,9 +2928,11 @@ static int ipmr_vif_seq_show(struct seq_file *seq, void *v)
 			 "Interface      BytesIn  PktsIn  BytesOut PktsOut Flags Local    Remote\n");
 	} else {
 		const struct vif_device *vif = v;
-		const char *name =  vif->dev ?
-				    vif->dev->name : "none";
+		const struct net_device *vif_dev;
+		const char *name;
 
+		vif_dev = vif_dev_read(vif);
+		name = vif_dev ? vif_dev->name : "none";
 		seq_printf(seq,
 			   "%2td %-10s %8ld %7ld  %8ld %7ld %05X %08X %08X\n",
 			   vif - mrt->vif_table,
diff --git a/net/ipv4/ipmr_base.c b/net/ipv4/ipmr_base.c
index aa8738a91210a563a2bd7ee1fe17f3bcde1936de..59f62b938472aef79b4eb3ade706bf4d111e1e3a 100644
--- a/net/ipv4/ipmr_base.c
+++ b/net/ipv4/ipmr_base.c
@@ -13,7 +13,7 @@ void vif_device_init(struct vif_device *v,
 		     unsigned short flags,
 		     unsigned short get_iflink_mask)
 {
-	v->dev = NULL;
+	RCU_INIT_POINTER(v->dev, NULL);
 	v->bytes_in = 0;
 	v->bytes_out = 0;
 	v->pkt_in = 0;
@@ -208,6 +208,7 @@ EXPORT_SYMBOL(mr_mfc_seq_next);
 int mr_fill_mroute(struct mr_table *mrt, struct sk_buff *skb,
 		   struct mr_mfc *c, struct rtmsg *rtm)
 {
+	struct net_device *vif_dev;
 	struct rta_mfc_stats mfcs;
 	struct nlattr *mp_attr;
 	struct rtnexthop *nhp;
@@ -220,10 +221,13 @@ int mr_fill_mroute(struct mr_table *mrt, struct sk_buff *skb,
 		return -ENOENT;
 	}
 
-	if (VIF_EXISTS(mrt, c->mfc_parent) &&
-	    nla_put_u32(skb, RTA_IIF,
-			mrt->vif_table[c->mfc_parent].dev->ifindex) < 0)
+	rcu_read_lock();
+	vif_dev = rcu_dereference(mrt->vif_table[c->mfc_parent].dev);
+	if (vif_dev && nla_put_u32(skb, RTA_IIF, vif_dev->ifindex) < 0) {
+		rcu_read_unlock();
 		return -EMSGSIZE;
+	}
+	rcu_read_unlock();
 
 	if (c->mfc_flags & MFC_OFFLOAD)
 		rtm->rtm_flags |= RTNH_F_OFFLOAD;
@@ -232,23 +236,27 @@ int mr_fill_mroute(struct mr_table *mrt, struct sk_buff *skb,
 	if (!mp_attr)
 		return -EMSGSIZE;
 
+	rcu_read_lock();
 	for (ct = c->mfc_un.res.minvif; ct < c->mfc_un.res.maxvif; ct++) {
-		if (VIF_EXISTS(mrt, ct) && c->mfc_un.res.ttls[ct] < 255) {
-			struct vif_device *vif;
+		struct vif_device *vif = &mrt->vif_table[ct];
+
+		vif_dev = rcu_dereference(vif->dev);
+		if (vif_dev && c->mfc_un.res.ttls[ct] < 255) {
 
 			nhp = nla_reserve_nohdr(skb, sizeof(*nhp));
 			if (!nhp) {
+				rcu_read_unlock();
 				nla_nest_cancel(skb, mp_attr);
 				return -EMSGSIZE;
 			}
 
 			nhp->rtnh_flags = 0;
 			nhp->rtnh_hops = c->mfc_un.res.ttls[ct];
-			vif = &mrt->vif_table[ct];
-			nhp->rtnh_ifindex = vif->dev->ifindex;
+			nhp->rtnh_ifindex = vif_dev->ifindex;
 			nhp->rtnh_len = sizeof(*nhp);
 		}
 	}
+	rcu_read_unlock();
 
 	nla_nest_end(skb, mp_attr);
 
@@ -275,13 +283,14 @@ static bool mr_mfc_uses_dev(const struct mr_table *mrt,
 	int ct;
 
 	for (ct = c->mfc_un.res.minvif; ct < c->mfc_un.res.maxvif; ct++) {
-		if (VIF_EXISTS(mrt, ct) && c->mfc_un.res.ttls[ct] < 255) {
-			const struct vif_device *vif;
-
-			vif = &mrt->vif_table[ct];
-			if (vif->dev == dev)
-				return true;
-		}
+		const struct net_device *vif_dev;
+		const struct vif_device *vif;
+
+		vif = &mrt->vif_table[ct];
+		vif_dev = rcu_access_pointer(vif->dev);
+		if (vif_dev && c->mfc_un.res.ttls[ct] < 255 &&
+		    vif_dev == dev)
+			return true;
 	}
 	return false;
 }
@@ -402,18 +411,22 @@ int mr_dump(struct net *net, struct notifier_block *nb, unsigned short family,
 
 	for (mrt = mr_iter(net, NULL); mrt; mrt = mr_iter(net, mrt)) {
 		struct vif_device *v = &mrt->vif_table[0];
+		struct net_device *vif_dev;
 		struct mr_mfc *mfc;
 		int vifi;
 
 		/* Notifiy on table VIF entries */
 		read_lock(mrt_lock);
 		for (vifi = 0; vifi < mrt->maxvif; vifi++, v++) {
-			if (!v->dev)
+			vif_dev = rcu_dereference_check(v->dev,
+							lockdep_is_held(mrt_lock));
+			if (!vif_dev)
 				continue;
 
 			err = mr_call_vif_notifier(nb, family,
-						   FIB_EVENT_VIF_ADD,
-						   v, vifi, mrt->id, extack);
+						   FIB_EVENT_VIF_ADD, v,
+						   vif_dev, vifi,
+						   mrt->id, extack);
 			if (err)
 				break;
 		}
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index aa66c032ba979e7a14e5e296b68c55bc73d98398..44cb3d88bbd6f85ce0c8e9054dd3d578b7b3733b 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -64,6 +64,12 @@ struct ip6mr_result {
 
 static DEFINE_RWLOCK(mrt_lock);
 
+static struct net_device *vif_dev_read(const struct vif_device *vif)
+{
+	return rcu_dereference_check(vif->dev,
+				     lockdep_is_held(&mrt_lock));
+}
+
 /* Multicast router control variables */
 
 /* Special spinlock for queue of unresolved entries */
@@ -430,7 +436,11 @@ static int ip6mr_vif_seq_show(struct seq_file *seq, void *v)
 			 "Interface      BytesIn  PktsIn  BytesOut PktsOut Flags\n");
 	} else {
 		const struct vif_device *vif = v;
-		const char *name = vif->dev ? vif->dev->name : "none";
+		const struct net_device *vif_dev;
+		const char *name;
+
+		vif_dev = vif_dev_read(vif);
+		name = vif_dev ? vif_dev->name : "none";
 
 		seq_printf(seq,
 			   "%2td %-10s %8ld %7ld  %8ld %7ld %05X\n",
@@ -553,7 +563,7 @@ static int pim6_rcv(struct sk_buff *skb)
 
 	read_lock(&mrt_lock);
 	if (reg_vif_num >= 0)
-		reg_dev = mrt->vif_table[reg_vif_num].dev;
+		reg_dev = vif_dev_read(&mrt->vif_table[reg_vif_num]);
 	read_unlock(&mrt_lock);
 
 	if (!reg_dev)
@@ -668,10 +678,11 @@ static struct net_device *ip6mr_reg_vif(struct net *net, struct mr_table *mrt)
 static int call_ip6mr_vif_entry_notifiers(struct net *net,
 					  enum fib_event_type event_type,
 					  struct vif_device *vif,
+					  struct net_device *vif_dev,
 					  mifi_t vif_index, u32 tb_id)
 {
 	return mr_call_vif_notifiers(net, RTNL_FAMILY_IP6MR, event_type,
-				     vif, vif_index, tb_id,
+				     vif, vif_dev, vif_index, tb_id,
 				     &net->ipv6.ipmr_seq);
 }
 
@@ -696,19 +707,15 @@ static int mif6_delete(struct mr_table *mrt, int vifi, int notify,
 
 	v = &mrt->vif_table[vifi];
 
-	if (VIF_EXISTS(mrt, vifi))
-		call_ip6mr_vif_entry_notifiers(read_pnet(&mrt->net),
-					       FIB_EVENT_VIF_DEL, v, vifi,
-					       mrt->id);
+	dev = rtnl_dereference(v->dev);
+	if (!dev)
+		return -EADDRNOTAVAIL;
 
+	call_ip6mr_vif_entry_notifiers(read_pnet(&mrt->net),
+				       FIB_EVENT_VIF_DEL, v, dev,
+				       vifi, mrt->id);
 	write_lock_bh(&mrt_lock);
-	dev = v->dev;
-	v->dev = NULL;
-
-	if (!dev) {
-		write_unlock_bh(&mrt_lock);
-		return -EADDRNOTAVAIL;
-	}
+	RCU_INIT_POINTER(v->dev, NULL);
 
 #ifdef CONFIG_IPV6_PIMSM_V2
 	if (vifi == mrt->mroute_reg_vif_num)
@@ -911,7 +918,7 @@ static int mif6_add(struct net *net, struct mr_table *mrt,
 
 	/* And finish update writing critical data */
 	write_lock_bh(&mrt_lock);
-	v->dev = dev;
+	rcu_assign_pointer(v->dev, dev);
 	netdev_tracker_alloc(dev, &v->dev_tracker, GFP_ATOMIC);
 #ifdef CONFIG_IPV6_PIMSM_V2
 	if (v->flags & MIFF_REGISTER)
@@ -921,7 +928,7 @@ static int mif6_add(struct net *net, struct mr_table *mrt,
 		mrt->maxvif = vifi + 1;
 	write_unlock_bh(&mrt_lock);
 	call_ip6mr_vif_entry_notifiers(net, FIB_EVENT_VIF_ADD,
-				       v, vifi, mrt->id);
+				       v, dev, vifi, mrt->id);
 	return 0;
 }
 
@@ -1241,7 +1248,7 @@ static int ip6mr_device_event(struct notifier_block *this,
 	ip6mr_for_each_table(mrt, net) {
 		v = &mrt->vif_table[0];
 		for (ct = 0; ct < mrt->maxvif; ct++, v++) {
-			if (v->dev == dev)
+			if (rcu_access_pointer(v->dev) == dev)
 				mif6_delete(mrt, ct, 1, NULL);
 		}
 	}
@@ -2019,21 +2026,22 @@ static inline int ip6mr_forward2_finish(struct net *net, struct sock *sk, struct
 static int ip6mr_forward2(struct net *net, struct mr_table *mrt,
 			  struct sk_buff *skb, int vifi)
 {
-	struct ipv6hdr *ipv6h;
 	struct vif_device *vif = &mrt->vif_table[vifi];
-	struct net_device *dev;
+	struct net_device *vif_dev;
+	struct ipv6hdr *ipv6h;
 	struct dst_entry *dst;
 	struct flowi6 fl6;
 
-	if (!vif->dev)
+	vif_dev = vif_dev_read(vif);
+	if (!vif_dev)
 		goto out_free;
 
 #ifdef CONFIG_IPV6_PIMSM_V2
 	if (vif->flags & MIFF_REGISTER) {
 		vif->pkt_out++;
 		vif->bytes_out += skb->len;
-		vif->dev->stats.tx_bytes += skb->len;
-		vif->dev->stats.tx_packets++;
+		vif_dev->stats.tx_bytes += skb->len;
+		vif_dev->stats.tx_packets++;
 		ip6mr_cache_report(mrt, skb, vifi, MRT6MSG_WHOLEPKT);
 		goto out_free;
 	}
@@ -2066,14 +2074,13 @@ static int ip6mr_forward2(struct net *net, struct mr_table *mrt,
 	 * not mrouter) cannot join to more than one interface - it will
 	 * result in receiving multiple packets.
 	 */
-	dev = vif->dev;
-	skb->dev = dev;
+	skb->dev = vif_dev;
 	vif->pkt_out++;
 	vif->bytes_out += skb->len;
 
 	/* We are about to write */
 	/* XXX: extension headers? */
-	if (skb_cow(skb, sizeof(*ipv6h) + LL_RESERVED_SPACE(dev)))
+	if (skb_cow(skb, sizeof(*ipv6h) + LL_RESERVED_SPACE(vif_dev)))
 		goto out_free;
 
 	ipv6h = ipv6_hdr(skb);
@@ -2082,7 +2089,7 @@ static int ip6mr_forward2(struct net *net, struct mr_table *mrt,
 	IP6CB(skb)->flags |= IP6SKB_FORWARDED;
 
 	return NF_HOOK(NFPROTO_IPV6, NF_INET_FORWARD,
-		       net, NULL, skb, skb->dev, dev,
+		       net, NULL, skb, skb->dev, vif_dev,
 		       ip6mr_forward2_finish);
 
 out_free:
@@ -2095,7 +2102,7 @@ static int ip6mr_find_vif(struct mr_table *mrt, struct net_device *dev)
 	int ct;
 
 	for (ct = mrt->maxvif - 1; ct >= 0; ct--) {
-		if (mrt->vif_table[ct].dev == dev)
+		if (rcu_access_pointer(mrt->vif_table[ct].dev) == dev)
 			break;
 	}
 	return ct;
@@ -2133,7 +2140,7 @@ static void ip6_mr_forward(struct net *net, struct mr_table *mrt,
 	/*
 	 * Wrong interface: drop packet and (maybe) send PIM assert.
 	 */
-	if (mrt->vif_table[vif].dev != dev) {
+	if (rcu_access_pointer(mrt->vif_table[vif].dev) != dev) {
 		c->_c.mfc_un.res.wrong_if++;
 
 		if (true_vifi >= 0 && mrt->mroute_do_assert &&
-- 
2.37.0.rc0.104.g0611611a94-goog

