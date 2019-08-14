Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D27FB8DB6B
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729547AbfHNRZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:25:12 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34629 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729071AbfHNRF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 13:05:57 -0400
Received: by mail-wr1-f68.google.com with SMTP id 31so111840911wrm.1
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 10:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cgRBCLoXr0LoZeUkv/TKq9Igl1xnDt65wkrs36vbZL8=;
        b=JFBfVFSGQm/mKg8Fs/cX2wiT19aw6Zx/rtvcP6RgvhQuDHYW5D7Wy0Qtl02FWPNQ/6
         xNcEgsElVzXqr3JtS7iMfzNVMM5kv23Zgngu3M7cJlF1mRM5SlT5ND99qReABcTgJ3Aq
         UDUNAgTSYc1Es5Q3I9eWP3qLOSRWSWsG39/hQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cgRBCLoXr0LoZeUkv/TKq9Igl1xnDt65wkrs36vbZL8=;
        b=PHq7jN2Tq9+iFLfkBSfAzxW83zWO0DMqUzA7HB6QzqmyHC9EPT3ZbujR3+EVLGAy7O
         JTbWYr6e7+Gy4gz4pJZQwazTWg5unNeJqhd67ljUfuiB4rihNiUW69VBfCTTUrEtjElp
         8VeU8iBgHTzco+4uW8KxGdcgAKNNSH5icPlM6Bc2b4/F81WXGb50zskop//6kwpvkP/D
         GM3LkX8WKYMybnc4wZHJyiuAua+z/hk2ttAol+RzS+fihzBj0Vk24fl6ijufQ1Ia+2DA
         ezOWJWzhC9P2/b/ENkWQBs/nuSN3UFxN6H2+VGGbTtW/sAoezlzuUtT3cxcgpn6u0mqB
         SkMA==
X-Gm-Message-State: APjAAAWBLuQpRD+DhbttcKsIsJGLr02VBARFDR37MYfl1qQfh2FYHjaQ
        XJtCnTZDJVfwQCnSHTEmYnzIF5RFPGM=
X-Google-Smtp-Source: APXvYqzX0L+TatfFcNkhJG3h6LMfj/yu1RMNtAxaHkW7XjJMDXTegD/xTw5+JfbNGGMfnkXidqZqHw==
X-Received: by 2002:a05:6000:128d:: with SMTP id f13mr775216wrx.241.1565802354907;
        Wed, 14 Aug 2019 10:05:54 -0700 (PDT)
Received: from wrk.www.tendawifi.com ([79.134.174.40])
        by smtp.gmail.com with ESMTPSA id c6sm332311wma.25.2019.08.14.10.05.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 14 Aug 2019 10:05:54 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v2 4/4] net: bridge: mdb: allow add/delete for host-joined groups
Date:   Wed, 14 Aug 2019 20:05:01 +0300
Message-Id: <20190814170501.1808-5-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190814170501.1808-1-nikolay@cumulusnetworks.com>
References: <81258876-5f03-002c-5aa8-2d6d00e6d99e@cumulusnetworks.com>
 <20190814170501.1808-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently this is needed only for user-space compatibility, so similar
object adds/deletes as the dumped ones would succeed. Later it can be
used for L2 mcast MAC add/delete.

v2: don't send a notification when used from user-space, arm the group
    timer if no ports are left after host entry del

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_mdb.c       | 76 +++++++++++++++++++++++++++------------
 net/bridge/br_multicast.c | 30 ++++++++++++----
 net/bridge/br_private.h   |  2 ++
 3 files changed, 79 insertions(+), 29 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 985273425117..e0f789296920 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -616,6 +616,19 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 			return err;
 	}
 
+	/* host join */
+	if (!port) {
+		/* don't allow any flags for host-joined groups */
+		if (state)
+			return -EINVAL;
+		if (mp->host_joined)
+			return -EEXIST;
+
+		br_multicast_host_join(mp, false);
+
+		return 0;
+	}
+
 	for (pp = &mp->ports;
 	     (p = mlock_dereference(*pp, br)) != NULL;
 	     pp = &p->next) {
@@ -640,19 +653,21 @@ static int __br_mdb_add(struct net *net, struct net_bridge *br,
 {
 	struct br_ip ip;
 	struct net_device *dev;
-	struct net_bridge_port *p;
+	struct net_bridge_port *p = NULL;
 	int ret;
 
 	if (!netif_running(br->dev) || !br_opt_get(br, BROPT_MULTICAST_ENABLED))
 		return -EINVAL;
 
-	dev = __dev_get_by_index(net, entry->ifindex);
-	if (!dev)
-		return -ENODEV;
+	if (entry->ifindex != br->dev->ifindex) {
+		dev = __dev_get_by_index(net, entry->ifindex);
+		if (!dev)
+			return -ENODEV;
 
-	p = br_port_get_rtnl(dev);
-	if (!p || p->br != br || p->state == BR_STATE_DISABLED)
-		return -EINVAL;
+		p = br_port_get_rtnl(dev);
+		if (!p || p->br != br || p->state == BR_STATE_DISABLED)
+			return -EINVAL;
+	}
 
 	__mdb_entry_to_br_ip(entry, &ip);
 
@@ -680,15 +695,19 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	br = netdev_priv(dev);
 
-	pdev = __dev_get_by_index(net, entry->ifindex);
-	if (!pdev)
-		return -ENODEV;
+	if (entry->ifindex != br->dev->ifindex) {
+		pdev = __dev_get_by_index(net, entry->ifindex);
+		if (!pdev)
+			return -ENODEV;
 
-	p = br_port_get_rtnl(pdev);
-	if (!p || p->br != br || p->state == BR_STATE_DISABLED)
-		return -EINVAL;
+		p = br_port_get_rtnl(pdev);
+		if (!p || p->br != br || p->state == BR_STATE_DISABLED)
+			return -EINVAL;
+		vg = nbp_vlan_group(p);
+	} else {
+		vg = br_vlan_group(br);
+	}
 
-	vg = nbp_vlan_group(p);
 	/* If vlan filtering is enabled and VLAN is not specified
 	 * install mdb entry on all vlans configured on the port.
 	 */
@@ -727,6 +746,15 @@ static int __br_mdb_del(struct net_bridge *br, struct br_mdb_entry *entry)
 	if (!mp)
 		goto unlock;
 
+	/* host leave */
+	if (entry->ifindex == mp->br->dev->ifindex && mp->host_joined) {
+		br_multicast_host_leave(mp, false);
+		err = 0;
+		if (!mp->ports && netif_running(br->dev))
+			mod_timer(&mp->timer, jiffies);
+		goto unlock;
+	}
+
 	for (pp = &mp->ports;
 	     (p = mlock_dereference(*pp, br)) != NULL;
 	     pp = &p->next) {
@@ -759,9 +787,9 @@ static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 {
 	struct net *net = sock_net(skb->sk);
 	struct net_bridge_vlan_group *vg;
+	struct net_bridge_port *p = NULL;
 	struct net_device *dev, *pdev;
 	struct br_mdb_entry *entry;
-	struct net_bridge_port *p;
 	struct net_bridge_vlan *v;
 	struct net_bridge *br;
 	int err;
@@ -772,15 +800,19 @@ static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	br = netdev_priv(dev);
 
-	pdev = __dev_get_by_index(net, entry->ifindex);
-	if (!pdev)
-		return -ENODEV;
+	if (entry->ifindex != br->dev->ifindex) {
+		pdev = __dev_get_by_index(net, entry->ifindex);
+		if (!pdev)
+			return -ENODEV;
 
-	p = br_port_get_rtnl(pdev);
-	if (!p || p->br != br || p->state == BR_STATE_DISABLED)
-		return -EINVAL;
+		p = br_port_get_rtnl(pdev);
+		if (!p || p->br != br || p->state == BR_STATE_DISABLED)
+			return -EINVAL;
+		vg = nbp_vlan_group(p);
+	} else {
+		vg = br_vlan_group(br);
+	}
 
-	vg = nbp_vlan_group(p);
 	/* If vlan filtering is enabled and VLAN is not specified
 	 * delete mdb entry on all vlans configured on the port.
 	 */
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 9b379e110129..ad12fe3fca8c 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -148,8 +148,7 @@ static void br_multicast_group_expired(struct timer_list *t)
 	if (!netif_running(br->dev) || timer_pending(&mp->timer))
 		goto out;
 
-	mp->host_joined = false;
-	br_mdb_notify(br->dev, NULL, &mp->addr, RTM_DELMDB, 0);
+	br_multicast_host_leave(mp, true);
 
 	if (mp->ports)
 		goto out;
@@ -512,6 +511,27 @@ static bool br_port_group_equal(struct net_bridge_port_group *p,
 	return ether_addr_equal(src, p->eth_addr);
 }
 
+void br_multicast_host_join(struct net_bridge_mdb_entry *mp, bool notify)
+{
+	if (!mp->host_joined) {
+		mp->host_joined = true;
+		if (notify)
+			br_mdb_notify(mp->br->dev, NULL, &mp->addr,
+				      RTM_NEWMDB, 0);
+	}
+	mod_timer(&mp->timer, jiffies + mp->br->multicast_membership_interval);
+}
+
+void br_multicast_host_leave(struct net_bridge_mdb_entry *mp, bool notify)
+{
+	if (!mp->host_joined)
+		return;
+
+	mp->host_joined = false;
+	if (notify)
+		br_mdb_notify(mp->br->dev, NULL, &mp->addr, RTM_DELMDB, 0);
+}
+
 static int br_multicast_add_group(struct net_bridge *br,
 				  struct net_bridge_port *port,
 				  struct br_ip *group,
@@ -534,11 +554,7 @@ static int br_multicast_add_group(struct net_bridge *br,
 		goto err;
 
 	if (!port) {
-		if (!mp->host_joined) {
-			mp->host_joined = true;
-			br_mdb_notify(br->dev, NULL, &mp->addr, RTM_NEWMDB, 0);
-		}
-		mod_timer(&mp->timer, now + br->multicast_membership_interval);
+		br_multicast_host_join(mp, true);
 		goto out;
 	}
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index b7a4942ff1b3..ce2ab14ee605 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -702,6 +702,8 @@ void br_multicast_get_stats(const struct net_bridge *br,
 			    struct br_mcast_stats *dest);
 void br_mdb_init(void);
 void br_mdb_uninit(void);
+void br_multicast_host_join(struct net_bridge_mdb_entry *mp, bool notify);
+void br_multicast_host_leave(struct net_bridge_mdb_entry *mp, bool notify);
 
 #define mlock_dereference(X, br) \
 	rcu_dereference_protected(X, lockdep_is_held(&br->multicast_lock))
-- 
2.21.0

