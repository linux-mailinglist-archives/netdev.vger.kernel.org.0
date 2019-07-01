Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEBDC5C17A
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 18:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbfGAQzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 12:55:04 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37754 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727563AbfGAQzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 12:55:04 -0400
Received: by mail-pf1-f196.google.com with SMTP id 19so6875568pfa.4
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 09:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=rsYSRMQDvpj2JBh7T2693BdOfBG3YhePj+PlQvXlBd8=;
        b=fvmqgVy5oZgunW7Ma7iI4wG/lLhzPJmly7bbH+BVuMdq9KDJM+gpETB0C/Xwo8hG4P
         a5kJXf/+9pZpcXeHmdxhlCklV7ELAOJaw3TSw+T2fpnvG0JCjQNGDdTuCE38zQYcV7JM
         pOO+ks2aYSiIalNVomh3S+wHdH+njjZKlMHtZOktxisWpE+1rBU5vDWAkN3d05HJiqiS
         3Tkhj9nfDe3wFwNPuXksH+lqMXLQvgKSdTeV86uv9PKEq9GnbbjNn0W7Z5A8dUKaissV
         gnZ/XC6+6uvebJhQAfwohr7/lwTmxb1EXQfUky+fOtsg5RpmuuP+lTL9uS3xaaL61Ye9
         Y0uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rsYSRMQDvpj2JBh7T2693BdOfBG3YhePj+PlQvXlBd8=;
        b=sjoRCqNm6+filKzUeBOIQ/3oY4Do9ER1g8BMx64KWT2FZyGkGg8qwRlQbuKNa3og6+
         GPVQUXZhfGvYgWHRvLJqagbqz36RnxzRtSKKuckHtJAvlJzpp5Njwdix/wDgeJ9z3z4d
         SHp8QDWDeDGDyw9tqE7ydD9R1eHsADhkfRXYmINsQVRdvEqcrkdaQMxBVMaW+wtYdP57
         2WEDQs3BUgs2bJK73Y/Dm2OT2ldIqUv3QMN7UoYVR13hPqb5X9fVZhy6jZXsNek99FId
         UovWQ86J2ENw/jDYcCSnjVIi+fWh5XXtj5WUVXAePYG0xFt3x3Ac+t/ZHF8cclOppztn
         erbg==
X-Gm-Message-State: APjAAAXdzqpUJVwDvNpUpPmV9NsX0o7rJ2PvJ65zQfMHNAr3PJ/n7HtU
        vTNbB9Ot8ZZZGndjwEv2hgmcVRO3
X-Google-Smtp-Source: APXvYqw9uJNB5GOH0xPlKlKWbq8dUZhRQ4jDCyQeGsNYwENWoPo1uTpv0f6HGD+A3TwIh8WgH9AzUg==
X-Received: by 2002:a17:90a:2ec1:: with SMTP id h1mr246012pjs.101.1562000103119;
        Mon, 01 Jul 2019 09:55:03 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j23sm10404074pgb.63.2019.07.01.09.55.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 09:55:02 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net, davem@davemloft.net
Subject: [PATCH net-next] tipc: use rcu dereference functions properly
Date:   Tue,  2 Jul 2019 00:54:55 +0800
Message-Id: <07e0518ac689f5919890a38634df38edf95d34a1.1562000095.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For these places are protected by rcu_read_lock, we change from
rcu_dereference_rtnl to rcu_dereference, as there is no need to
check if rtnl lock is held.

For these places are protected by rtnl_lock, we change from
rcu_dereference_rtnl to rtnl_dereference/rcu_dereference_protected,
as no extra memory barriers are needed under rtnl_lock() which also
protects tn->bearer_list[] and dev->tipc_ptr/b->media_ptr updating.

rcu_dereference_rtnl will be only used in the places where it could
be under rcu_read_lock or rtnl_lock.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/bearer.c    | 14 +++++++-------
 net/tipc/udp_media.c |  8 ++++----
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index 2bed658..a809c0e 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -62,7 +62,7 @@ static struct tipc_bearer *bearer_get(struct net *net, int bearer_id)
 {
 	struct tipc_net *tn = tipc_net(net);
 
-	return rcu_dereference_rtnl(tn->bearer_list[bearer_id]);
+	return rcu_dereference(tn->bearer_list[bearer_id]);
 }
 
 static void bearer_disable(struct net *net, struct tipc_bearer *b);
@@ -210,7 +210,7 @@ void tipc_bearer_add_dest(struct net *net, u32 bearer_id, u32 dest)
 	struct tipc_bearer *b;
 
 	rcu_read_lock();
-	b = rcu_dereference_rtnl(tn->bearer_list[bearer_id]);
+	b = rcu_dereference(tn->bearer_list[bearer_id]);
 	if (b)
 		tipc_disc_add_dest(b->disc);
 	rcu_read_unlock();
@@ -222,7 +222,7 @@ void tipc_bearer_remove_dest(struct net *net, u32 bearer_id, u32 dest)
 	struct tipc_bearer *b;
 
 	rcu_read_lock();
-	b = rcu_dereference_rtnl(tn->bearer_list[bearer_id]);
+	b = rcu_dereference(tn->bearer_list[bearer_id]);
 	if (b)
 		tipc_disc_remove_dest(b->disc);
 	rcu_read_unlock();
@@ -444,7 +444,7 @@ int tipc_l2_send_msg(struct net *net, struct sk_buff *skb,
 	struct net_device *dev;
 	int delta;
 
-	dev = (struct net_device *)rcu_dereference_rtnl(b->media_ptr);
+	dev = (struct net_device *)rcu_dereference(b->media_ptr);
 	if (!dev)
 		return 0;
 
@@ -481,7 +481,7 @@ int tipc_bearer_mtu(struct net *net, u32 bearer_id)
 	struct tipc_bearer *b;
 
 	rcu_read_lock();
-	b = rcu_dereference_rtnl(tipc_net(net)->bearer_list[bearer_id]);
+	b = rcu_dereference(tipc_net(net)->bearer_list[bearer_id]);
 	if (b)
 		mtu = b->mtu;
 	rcu_read_unlock();
@@ -574,8 +574,8 @@ static int tipc_l2_rcv_msg(struct sk_buff *skb, struct net_device *dev,
 	struct tipc_bearer *b;
 
 	rcu_read_lock();
-	b = rcu_dereference_rtnl(dev->tipc_ptr) ?:
-		rcu_dereference_rtnl(orig_dev->tipc_ptr);
+	b = rcu_dereference(dev->tipc_ptr) ?:
+		rcu_dereference(orig_dev->tipc_ptr);
 	if (likely(b && test_bit(0, &b->up) &&
 		   (skb->pkt_type <= PACKET_MULTICAST))) {
 		skb_mark_not_on_list(skb);
diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
index b8962df..62b85db 100644
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -231,7 +231,7 @@ static int tipc_udp_send_msg(struct net *net, struct sk_buff *skb,
 	}
 
 	skb_set_inner_protocol(skb, htons(ETH_P_TIPC));
-	ub = rcu_dereference_rtnl(b->media_ptr);
+	ub = rcu_dereference(b->media_ptr);
 	if (!ub) {
 		err = -ENODEV;
 		goto out;
@@ -490,7 +490,7 @@ int tipc_udp_nl_dump_remoteip(struct sk_buff *skb, struct netlink_callback *cb)
 		}
 	}
 
-	ub = rcu_dereference_rtnl(b->media_ptr);
+	ub = rtnl_dereference(b->media_ptr);
 	if (!ub) {
 		rtnl_unlock();
 		return -EINVAL;
@@ -532,7 +532,7 @@ int tipc_udp_nl_add_bearer_data(struct tipc_nl_msg *msg, struct tipc_bearer *b)
 	struct udp_bearer *ub;
 	struct nlattr *nest;
 
-	ub = rcu_dereference_rtnl(b->media_ptr);
+	ub = rtnl_dereference(b->media_ptr);
 	if (!ub)
 		return -ENODEV;
 
@@ -806,7 +806,7 @@ static void tipc_udp_disable(struct tipc_bearer *b)
 {
 	struct udp_bearer *ub;
 
-	ub = rcu_dereference_rtnl(b->media_ptr);
+	ub = rtnl_dereference(b->media_ptr);
 	if (!ub) {
 		pr_err("UDP bearer instance not found\n");
 		return;
-- 
2.1.0

