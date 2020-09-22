Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491C7273BE6
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 09:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730042AbgIVHau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 03:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729988AbgIVHas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 03:30:48 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5409FC061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:30:48 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id o5so15824653wrn.13
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sbHsP3+rb6n8HpEyq3TxWopOvaJM25/6iBadHf2ysoI=;
        b=STN62BxjVh2eE5qRaUOyGnkZFsCXw0nfsP0KMaRLgWzQ5pRBIFUZBwD/KSX6qGFTTg
         yVLIg4FNZ6OYsZ6XwVy/z1bRXHk5d12NKIg8R2tqxi55FDMzl+/8Pnq55psfExSzb+Tt
         MbancY5lOBdyd+50rhyfvv5QonMNu7wcBc8e4VmvCVHygN2O6UjKiSVy1rQY/wOxNxgI
         Y+tUS0lLjSsoJf2m6WNVjdpPozROF5U/PLySSHZcuQGcCdpd1bvs+M1FwhIjkPAjwSUY
         nZf0lgrKroj/Kb8L7aWxoQcff6ZTpnDG/PC9icxoajbbEBCv45Zh4i21AEqyrMhOD90h
         qpvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sbHsP3+rb6n8HpEyq3TxWopOvaJM25/6iBadHf2ysoI=;
        b=RK2dm/TA/I63trmsu2u6spN/IjdspL13VvxQqS5jOcZAriw+dyUM0ZCsb5h22gV41H
         SX0tAcPokjbYlrGFWX2p7OLI5tm53kx7158Ye7JepxgqzkluZ17G20/HlRF5ETUzUk/5
         zyCN87xa5RHVz5smKvqoqAkw6wMEC1/U3il7doRZa1hk5lVJKZwsq4YjUZ1XyYEjphdr
         wlOjHM8oChjyv5IGiT1GeMHJR6zLyfcTgQuhNAUehU0SiCIylN9YcFgROhzRGQ1ZEXQW
         Q59fYT4J5iVmfL0acNDCcagZyeejqGw1bDveoGfbIhqg9hWLBCtSQ+ph9MEUXLmfY+2m
         t8TA==
X-Gm-Message-State: AOAM533SBEfjfYjMoVXdGE8SyM3SCKg53i3cUYEiIavUj9ZjkHb0sMSI
        0wXSF5xIkc6rvXuvTL7d6ll0rfW7MK1RcXVldY/EvA==
X-Google-Smtp-Source: ABdhPJxn8PWlaZZnY79co70s7pP3mrzPdKRTaGABS0uAgQqB5/dmjcTBXWRVviM0SivoiBIPa+qYJw==
X-Received: by 2002:adf:db4d:: with SMTP id f13mr2791745wrj.155.1600759846639;
        Tue, 22 Sep 2020 00:30:46 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id s26sm3258287wmh.44.2020.09.22.00.30.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 00:30:46 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next v2 03/16] net: bridge: mdb: use extack in br_mdb_add() and br_mdb_add_group()
Date:   Tue, 22 Sep 2020 10:30:14 +0300
Message-Id: <20200922073027.1196992-4-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200922073027.1196992-1-razor@blackwall.org>
References: <20200922073027.1196992-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Pass and use extack all the way down to br_mdb_add_group().

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_mdb.c | 54 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 42 insertions(+), 12 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 92ab7369fee0..1df62d887953 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -723,7 +723,8 @@ static int br_mdb_parse(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
-			    struct br_ip *group, struct br_mdb_entry *entry)
+			    struct br_ip *group, struct br_mdb_entry *entry,
+			    struct netlink_ext_ack *extack)
 {
 	struct net_bridge_mdb_entry *mp;
 	struct net_bridge_port_group *p;
@@ -742,10 +743,14 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 	/* host join */
 	if (!port) {
 		/* don't allow any flags for host-joined groups */
-		if (entry->state)
+		if (entry->state) {
+			NL_SET_ERR_MSG_MOD(extack, "Flags are not allowed for host groups");
 			return -EINVAL;
-		if (mp->host_joined)
+		}
+		if (mp->host_joined) {
+			NL_SET_ERR_MSG_MOD(extack, "Group is already joined by host");
 			return -EEXIST;
+		}
 
 		br_multicast_host_join(mp, false);
 		br_mdb_notify(br->dev, mp, NULL, RTM_NEWMDB);
@@ -756,16 +761,20 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 	for (pp = &mp->ports;
 	     (p = mlock_dereference(*pp, br)) != NULL;
 	     pp = &p->next) {
-		if (p->port == port)
+		if (p->port == port) {
+			NL_SET_ERR_MSG_MOD(extack, "Group is already joined by port");
 			return -EEXIST;
+		}
 		if ((unsigned long)p->port < (unsigned long)port)
 			break;
 	}
 
 	p = br_multicast_new_port_group(port, group, *pp, entry->state, NULL,
 					MCAST_EXCLUDE);
-	if (unlikely(!p))
+	if (unlikely(!p)) {
+		NL_SET_ERR_MSG_MOD(extack, "Couldn't allocate new port group");
 		return -ENOMEM;
+	}
 	rcu_assign_pointer(*pp, p);
 	if (entry->state == MDB_TEMPORARY)
 		mod_timer(&p->timer, now + br->multicast_membership_interval);
@@ -776,7 +785,8 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 
 static int __br_mdb_add(struct net *net, struct net_bridge *br,
 			struct net_bridge_port *p,
-			struct br_mdb_entry *entry)
+			struct br_mdb_entry *entry,
+			struct netlink_ext_ack *extack)
 {
 	struct br_ip ip;
 	int ret;
@@ -784,7 +794,7 @@ static int __br_mdb_add(struct net *net, struct net_bridge *br,
 	__mdb_entry_to_br_ip(entry, &ip);
 
 	spin_lock_bh(&br->multicast_lock);
-	ret = br_mdb_add_group(br, p, &ip, entry);
+	ret = br_mdb_add_group(br, p, &ip, entry, extack);
 	spin_unlock_bh(&br->multicast_lock);
 
 	return ret;
@@ -808,17 +818,37 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	br = netdev_priv(dev);
 
-	if (!netif_running(br->dev) || !br_opt_get(br, BROPT_MULTICAST_ENABLED))
+	if (!netif_running(br->dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Bridge device is not running");
 		return -EINVAL;
+	}
+
+	if (!br_opt_get(br, BROPT_MULTICAST_ENABLED)) {
+		NL_SET_ERR_MSG_MOD(extack, "Bridge's multicast processing is disabled");
+		return -EINVAL;
+	}
 
 	if (entry->ifindex != br->dev->ifindex) {
 		pdev = __dev_get_by_index(net, entry->ifindex);
-		if (!pdev)
+		if (!pdev) {
+			NL_SET_ERR_MSG_MOD(extack, "Port net device doesn't exist");
 			return -ENODEV;
+		}
 
 		p = br_port_get_rtnl(pdev);
-		if (!p || p->br != br || p->state == BR_STATE_DISABLED)
+		if (!p) {
+			NL_SET_ERR_MSG_MOD(extack, "Net device is not a bridge port");
 			return -EINVAL;
+		}
+
+		if (p->br != br) {
+			NL_SET_ERR_MSG_MOD(extack, "Port belongs to a different bridge device");
+			return -EINVAL;
+		}
+		if (p->state == BR_STATE_DISABLED) {
+			NL_SET_ERR_MSG_MOD(extack, "Port is in disabled state");
+			return -EINVAL;
+		}
 		vg = nbp_vlan_group(p);
 	} else {
 		vg = br_vlan_group(br);
@@ -830,12 +860,12 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (br_vlan_enabled(br->dev) && vg && entry->vid == 0) {
 		list_for_each_entry(v, &vg->vlan_list, vlist) {
 			entry->vid = v->vid;
-			err = __br_mdb_add(net, br, p, entry);
+			err = __br_mdb_add(net, br, p, entry, extack);
 			if (err)
 				break;
 		}
 	} else {
-		err = __br_mdb_add(net, br, p, entry);
+		err = __br_mdb_add(net, br, p, entry, extack);
 	}
 
 	return err;
-- 
2.25.4

