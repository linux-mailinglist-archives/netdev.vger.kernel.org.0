Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABF5A641E
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 10:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbfICIoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 04:44:23 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33943 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfICIoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 04:44:23 -0400
Received: by mail-pl1-f195.google.com with SMTP id d3so7602726plr.1
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 01:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Kg3/G14JkCUHimnDtYhw8Lsvdhcqtg2VN2yVBVV81Es=;
        b=h1GHgYosj/bKfA8gwE8m+c1W/Fr6axP7vk1Eql2p0+/BmimpG4u3M1pwVlqtqn4VtY
         tKkjuUwxqUiqyD8zJ7BqJ4z5kBMF2cUT9Rqrx39IVyTCHGDikbL6K/OpH7PbsL0F4V8F
         y0uVGSyhkDYx1FrilF8eMefEXaucBINeJr+jy2dq++rT5tQkUxNXrYA1b/CklmWOUsKF
         F9RcguLUQlPzyYWsOjn3G0WGzPhun7YRMy8oNcHGC0XiMCcVywmxBjJeH3e1A5S3AhM9
         hIRJDrd1dI30WG9VtnYpMRuDAvLIqWnDvV8Q2N+FnJYgL3VNiLd24WV8ou0q2wfAcVjr
         Mmig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Kg3/G14JkCUHimnDtYhw8Lsvdhcqtg2VN2yVBVV81Es=;
        b=eViJMRj08QHdRJDF1SAXleJQgsrEASEVUBzS1ppb8LO2WYGFNttmrlz+hxA+OAFBPv
         ph3yxi8n2Z//pALyv1blHGTK7qzjQC5jwKGGWv5iARjF8AMNbxC3z8YthnbJYlyYeWRF
         +A1g27EDWU0V38wjCLHN6UviwEJolRTFNOEgf4fYJWY06Civ4TXRwlM7R8hxnv36Kn85
         S4nHitYYm3vzDGhUskb++dIOH8nCqCP8WYUtLcEuezVkScJaZowC2Onp5Xe1dyT9AQbh
         P79ewqlPkN/0n+sruf/PuYanKQICEbO8kl717yyv1kxoqWDaIWFa/rmOLNKoBvyfR5cP
         bFow==
X-Gm-Message-State: APjAAAXHEUh2O02Ry69V45mk0lA75lc7Oln5MFKeQDJxAnHusCN0/3VH
        BW8Ke0EkSv/1FIxEjiTjKUtddKvhKoA=
X-Google-Smtp-Source: APXvYqwyBpQczwcNXDGC+oEy6nGR5oDtBX9Geu4YShe37V4EAiAGitRtTCmJDwUgXETOmFHog4euUw==
X-Received: by 2002:a17:902:bb95:: with SMTP id m21mr33750156pls.26.1567500262652;
        Tue, 03 Sep 2019 01:44:22 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s7sm6196624pjn.8.2019.09.03.01.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 01:44:22 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Phil Karn <karn@ka9q.net>,
        Sukumar Gopalakrishnan <sukumarg1973@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] ipmr: remove cache_resolve_queue_len
Date:   Tue,  3 Sep 2019 16:43:59 +0800
Message-Id: <20190903084359.13310-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a re-post of previous patch wrote by David Miller[1].

Phil Karn reported[2] that on busy networks with lots of unresolved
multicast routing entries, the creation of new multicast group routes
can be extremely slow and unreliable.

The reason is we hard-coded multicast route entries with unresolved source
addresses(cache_resolve_queue_len) to 10. If some multicast route never
resolves and the unresolved source addresses increased, there will
be no ability to create new multicast route cache.

To resolve this issue, we need either add a sysctl entry to make the
cache_resolve_queue_len configurable, or just remove cache_resolve_queue_len
directly, as we already have the socket receive queue limits of mrouted
socket, pointed by David.

From my side, I'd perfer to remove the cache_resolve_queue_len instead
of creating two more(IPv4 and IPv6 version) sysctl entry.

[1] https://lkml.org/lkml/2018/7/22/11
[2] https://lkml.org/lkml/2018/7/21/343

Reported-by: Phil Karn <karn@ka9q.net>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/linux/mroute_base.h |  2 --
 net/ipv4/ipmr.c             | 27 ++++++++++++++++++---------
 net/ipv6/ip6mr.c            | 10 +++-------
 3 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/include/linux/mroute_base.h b/include/linux/mroute_base.h
index 34de06b426ef..50fb89533029 100644
--- a/include/linux/mroute_base.h
+++ b/include/linux/mroute_base.h
@@ -235,7 +235,6 @@ struct mr_table_ops {
  * @mfc_hash: Hash table of all resolved routes for easy lookup
  * @mfc_cache_list: list of resovled routes for possible traversal
  * @maxvif: Identifier of highest value vif currently in use
- * @cache_resolve_queue_len: current size of unresolved queue
  * @mroute_do_assert: Whether to inform userspace on wrong ingress
  * @mroute_do_pim: Whether to receive IGMP PIMv1
  * @mroute_reg_vif_num: PIM-device vif index
@@ -252,7 +251,6 @@ struct mr_table {
 	struct rhltable		mfc_hash;
 	struct list_head	mfc_cache_list;
 	int			maxvif;
-	atomic_t		cache_resolve_queue_len;
 	bool			mroute_do_assert;
 	bool			mroute_do_pim;
 	bool			mroute_do_wrvifwhole;
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index c07bc82cbbe9..6c5278b45afb 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -744,8 +744,6 @@ static void ipmr_destroy_unres(struct mr_table *mrt, struct mfc_cache *c)
 	struct sk_buff *skb;
 	struct nlmsgerr *e;
 
-	atomic_dec(&mrt->cache_resolve_queue_len);
-
 	while ((skb = skb_dequeue(&c->_c.mfc_un.unres.unresolved))) {
 		if (ip_hdr(skb)->version == 0) {
 			struct nlmsghdr *nlh = skb_pull(skb,
@@ -1133,9 +1131,11 @@ static int ipmr_cache_unresolved(struct mr_table *mrt, vifi_t vifi,
 	}
 
 	if (!found) {
+		bool was_empty;
+
 		/* Create a new entry if allowable */
-		if (atomic_read(&mrt->cache_resolve_queue_len) >= 10 ||
-		    (c = ipmr_cache_alloc_unres()) == NULL) {
+		c = ipmr_cache_alloc_unres();
+		if (!c) {
 			spin_unlock_bh(&mfc_unres_lock);
 
 			kfree_skb(skb);
@@ -1161,11 +1161,11 @@ static int ipmr_cache_unresolved(struct mr_table *mrt, vifi_t vifi,
 			return err;
 		}
 
-		atomic_inc(&mrt->cache_resolve_queue_len);
+		was_empty = list_empty(&mrt->mfc_unres_queue);
 		list_add(&c->_c.list, &mrt->mfc_unres_queue);
 		mroute_netlink_event(mrt, c, RTM_NEWROUTE);
 
-		if (atomic_read(&mrt->cache_resolve_queue_len) == 1)
+		if (was_empty)
 			mod_timer(&mrt->ipmr_expire_timer,
 				  c->_c.mfc_un.unres.expires);
 	}
@@ -1272,7 +1272,6 @@ static int ipmr_mfc_add(struct net *net, struct mr_table *mrt,
 		if (uc->mfc_origin == c->mfc_origin &&
 		    uc->mfc_mcastgrp == c->mfc_mcastgrp) {
 			list_del(&_uc->list);
-			atomic_dec(&mrt->cache_resolve_queue_len);
 			found = true;
 			break;
 		}
@@ -1328,7 +1327,7 @@ static void mroute_clean_tables(struct mr_table *mrt, int flags)
 	}
 
 	if (flags & MRT_FLUSH_MFC) {
-		if (atomic_read(&mrt->cache_resolve_queue_len) != 0) {
+		if (!list_empty(&mrt->mfc_unres_queue)) {
 			spin_lock_bh(&mfc_unres_lock);
 			list_for_each_entry_safe(c, tmp, &mrt->mfc_unres_queue, list) {
 				list_del(&c->list);
@@ -2750,9 +2749,19 @@ static int ipmr_rtm_route(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return ipmr_mfc_delete(tbl, &mfcc, parent);
 }
 
+static int queue_count(struct mr_table *mrt)
+{
+	struct list_head *pos;
+	int count = 0;
+
+	list_for_each(pos, &mrt->mfc_unres_queue)
+		count++;
+	return count;
+}
+
 static bool ipmr_fill_table(struct mr_table *mrt, struct sk_buff *skb)
 {
-	u32 queue_len = atomic_read(&mrt->cache_resolve_queue_len);
+	u32 queue_len = queue_count(mrt);
 
 	if (nla_put_u32(skb, IPMRA_TABLE_ID, mrt->id) ||
 	    nla_put_u32(skb, IPMRA_TABLE_CACHE_RES_QUEUE_LEN, queue_len) ||
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index e80d36c5073d..d02f0f903559 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -768,8 +768,6 @@ static void ip6mr_destroy_unres(struct mr_table *mrt, struct mfc6_cache *c)
 	struct net *net = read_pnet(&mrt->net);
 	struct sk_buff *skb;
 
-	atomic_dec(&mrt->cache_resolve_queue_len);
-
 	while ((skb = skb_dequeue(&c->_c.mfc_un.unres.unresolved)) != NULL) {
 		if (ipv6_hdr(skb)->version == 0) {
 			struct nlmsghdr *nlh = skb_pull(skb,
@@ -1148,8 +1146,8 @@ static int ip6mr_cache_unresolved(struct mr_table *mrt, mifi_t mifi,
 		 *	Create a new entry if allowable
 		 */
 
-		if (atomic_read(&mrt->cache_resolve_queue_len) >= 10 ||
-		    (c = ip6mr_cache_alloc_unres()) == NULL) {
+		c = ip6mr_cache_alloc_unres();
+		if (!c) {
 			spin_unlock_bh(&mfc_unres_lock);
 
 			kfree_skb(skb);
@@ -1176,7 +1174,6 @@ static int ip6mr_cache_unresolved(struct mr_table *mrt, mifi_t mifi,
 			return err;
 		}
 
-		atomic_inc(&mrt->cache_resolve_queue_len);
 		list_add(&c->_c.list, &mrt->mfc_unres_queue);
 		mr6_netlink_event(mrt, c, RTM_NEWROUTE);
 
@@ -1468,7 +1465,6 @@ static int ip6mr_mfc_add(struct net *net, struct mr_table *mrt,
 		if (ipv6_addr_equal(&uc->mf6c_origin, &c->mf6c_origin) &&
 		    ipv6_addr_equal(&uc->mf6c_mcastgrp, &c->mf6c_mcastgrp)) {
 			list_del(&_uc->list);
-			atomic_dec(&mrt->cache_resolve_queue_len);
 			found = true;
 			break;
 		}
@@ -1526,7 +1522,7 @@ static void mroute_clean_tables(struct mr_table *mrt, int flags)
 	}
 
 	if (flags & MRT6_FLUSH_MFC) {
-		if (atomic_read(&mrt->cache_resolve_queue_len) != 0) {
+		if (!list_empty(&mrt->mfc_unres_queue)) {
 			spin_lock_bh(&mfc_unres_lock);
 			list_for_each_entry_safe(c, tmp, &mrt->mfc_unres_queue, list) {
 				list_del(&c->list);
-- 
2.19.2

