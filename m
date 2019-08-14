Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB1B88D662
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 16:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbfHNOkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 10:40:42 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33828 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727900AbfHNOkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 10:40:41 -0400
Received: by mail-wr1-f68.google.com with SMTP id 31so111378192wrm.1
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 07:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7xQAx7Bv4/dk/huG9TOg9gS2U3uW3jl+g4yWGm3ZB1Q=;
        b=d/O2XDoPrbQD9szP1TeYV2W3hG9nR3aoG8ume2X8YXbfKUAbJlYcNT4ebMuwoklv+6
         k08sXZZbBboEmSt5AXweQ4CvEA2QLikoPmrGSzpE+mgSMFVznwBgDRGgHolIvOgrhq2N
         MNDj42h2Z/zJEMbDyT9QHevM2p8ebhDVQ2yVw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7xQAx7Bv4/dk/huG9TOg9gS2U3uW3jl+g4yWGm3ZB1Q=;
        b=oT33ICBoiZhfw4JxsLdlj6rpcHSQ5X7mfAC87EDOzpUsOpLU3aDgyH25Yo8boRRzMV
         NYnpQsxW+2ac7dnmKllCdB9akgkz4XWw3y/klp3OvC49dAja5TtbnxijsbzKSnsYnnvV
         f+bTiOCpYr9G6AI1JJEz2U49R+2TN4y3yvvRrfyacoP+KnCDObC7BsUBn3v1NsxGPHCj
         dWZdCyoTNHptWdlMyLNVHl7Ljaxzkr3teaoalz4XViGzPiCbStMw6DErjRUAniSKmFIe
         6TU4r2nBb2slBz9/Wxyl7Bo03FntJL/S9padsHeMZIygEOzBRSrnX36mkrUKUcw6c0xH
         fEPw==
X-Gm-Message-State: APjAAAWTaAh6Bv+QzIVrVDHwIaVlappc6LBx6XXHC3+0DJ2oIzlH40cq
        Dy7VWJ0dm8BrGFRxRdOov80qoVfTEwo=
X-Google-Smtp-Source: APXvYqxEN4Q4PuOp/FdNgnwMtYhPCHZXdmDU+pSAzu5Vtp1ErswQPnWkNcBbSgeBHZv1KYsELiVSFw==
X-Received: by 2002:adf:f206:: with SMTP id p6mr30138wro.216.1565793638765;
        Wed, 14 Aug 2019 07:40:38 -0700 (PDT)
Received: from wrk.www.tendawifi.com ([79.134.174.40])
        by smtp.gmail.com with ESMTPSA id o8sm3383874wma.1.2019.08.14.07.40.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 14 Aug 2019 07:40:38 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 4/4] net: bridge: mdb: allow add/delete for host-joined groups
Date:   Wed, 14 Aug 2019 17:40:24 +0300
Message-Id: <20190814144024.9710-5-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190814144024.9710-1-nikolay@cumulusnetworks.com>
References: <20190814144024.9710-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently this is needed only for user-space compatibility, so similar
object adds/deletes as the dumped ones would succeed. Later it can be
used for L2 mcast MAC add/delete.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_mdb.c       | 74 +++++++++++++++++++++++++++------------
 net/bridge/br_multicast.c | 24 +++++++++----
 net/bridge/br_private.h   |  2 ++
 3 files changed, 71 insertions(+), 29 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 985273425117..331a130b83b1 100644
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
+		br_multicast_host_join(mp);
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
@@ -727,6 +746,13 @@ static int __br_mdb_del(struct net_bridge *br, struct br_mdb_entry *entry)
 	if (!mp)
 		goto unlock;
 
+	/* host leave */
+	if (entry->ifindex == mp->br->dev->ifindex && mp->host_joined) {
+		br_multicast_host_leave(mp);
+		err = 0;
+		goto unlock;
+	}
+
 	for (pp = &mp->ports;
 	     (p = mlock_dereference(*pp, br)) != NULL;
 	     pp = &p->next) {
@@ -759,9 +785,9 @@ static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
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
@@ -772,15 +798,19 @@ static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 
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
index 9b379e110129..f92cb6751898 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -148,8 +148,7 @@ static void br_multicast_group_expired(struct timer_list *t)
 	if (!netif_running(br->dev) || timer_pending(&mp->timer))
 		goto out;
 
-	mp->host_joined = false;
-	br_mdb_notify(br->dev, NULL, &mp->addr, RTM_DELMDB, 0);
+	br_multicast_host_leave(mp);
 
 	if (mp->ports)
 		goto out;
@@ -512,6 +511,21 @@ static bool br_port_group_equal(struct net_bridge_port_group *p,
 	return ether_addr_equal(src, p->eth_addr);
 }
 
+void br_multicast_host_join(struct net_bridge_mdb_entry *mp)
+{
+	if (!mp->host_joined) {
+		mp->host_joined = true;
+		br_mdb_notify(mp->br->dev, NULL, &mp->addr, RTM_NEWMDB, 0);
+	}
+	mod_timer(&mp->timer, jiffies + mp->br->multicast_membership_interval);
+}
+
+void br_multicast_host_leave(struct net_bridge_mdb_entry *mp)
+{
+	mp->host_joined = false;
+	br_mdb_notify(mp->br->dev, NULL, &mp->addr, RTM_DELMDB, 0);
+}
+
 static int br_multicast_add_group(struct net_bridge *br,
 				  struct net_bridge_port *port,
 				  struct br_ip *group,
@@ -534,11 +548,7 @@ static int br_multicast_add_group(struct net_bridge *br,
 		goto err;
 
 	if (!port) {
-		if (!mp->host_joined) {
-			mp->host_joined = true;
-			br_mdb_notify(br->dev, NULL, &mp->addr, RTM_NEWMDB, 0);
-		}
-		mod_timer(&mp->timer, now + br->multicast_membership_interval);
+		br_multicast_host_join(mp);
 		goto out;
 	}
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index b7a4942ff1b3..a99dcbb9825c 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -702,6 +702,8 @@ void br_multicast_get_stats(const struct net_bridge *br,
 			    struct br_mcast_stats *dest);
 void br_mdb_init(void);
 void br_mdb_uninit(void);
+void br_multicast_host_join(struct net_bridge_mdb_entry *mp);
+void br_multicast_host_leave(struct net_bridge_mdb_entry *mp);
 
 #define mlock_dereference(X, br) \
 	rcu_dereference_protected(X, lockdep_is_held(&br->multicast_lock))
-- 
2.21.0

