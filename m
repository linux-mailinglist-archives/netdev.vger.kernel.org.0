Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2C325AA51
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 13:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgIBLbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 07:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgIBL3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 07:29:20 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE86C061245
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 04:29:20 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id w2so4041197wmi.1
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 04:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cCKiL+huUrH+G1EiQAvHJFnQDyxaz+24nbHZqfy+tlk=;
        b=O2Wn5E7xy4EtZF31dxZX87O9prirrlpqXwkl8F3lkwddVWjcD3oaoo7IRly/Soa5lE
         dk+JSfuuXSizTq4YqJEjwCWzEVIB0FPt4+kYPJZG5ckbdp/AUK9zRJuEBcRj6Z2UHnm1
         phf1rvUsPNzq05j6VF43ag2fWXm6weyRKdPjc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cCKiL+huUrH+G1EiQAvHJFnQDyxaz+24nbHZqfy+tlk=;
        b=Qr96b0PuK7QN1STItx1eMxapFYFVTd0N81wP6ONr3DqtBAxMg/o19OOa2hJvs7PY08
         B1sfKhl7CupDaWnJKaKM03j530H2oapzQgVPNXSstwlP9U9O+27j5jVigxIsjHhjmNhD
         nlg62SKKlZsFF+T8TPNcXWzggdPlWCMkFg2U49vwOkxsIAjOfzto+tOf5FAkTmtdtSMh
         7pGyJn4xrVmRlJHr28IhrJdDEfZZVjqakmCvMHDof4nq5AEzXd/9GzxDQRyP14pxYqlU
         g2eIYCJ71zbPYcKydupWByCpiX6oSq/0GtGYtbV5n4nYpz4rJWkzlY7sw7e6VJdoDEb3
         cODA==
X-Gm-Message-State: AOAM533ndj8J/G8HguAFI4DslmHc/ukXqKJZJEt2PQZXjLU3CXbflwaW
        Dk+eD8ZMsP80OywPuPtzCcSfp9Q2Leg2nuMx
X-Google-Smtp-Source: ABdhPJxThDesuGtk+f3NFSRZOHXQJOkxC6i7fwHHE1dc1fOabR8DLP1N52Qg05KgKVG1tYCSeQNLMA==
X-Received: by 2002:a05:600c:20c:: with SMTP id 12mr245194wmi.40.1599046158499;
        Wed, 02 Sep 2020 04:29:18 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 5sm5985172wmz.22.2020.09.02.04.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 04:29:17 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v2 07/15] net: bridge: mdb: push notifications in __br_mdb_add/del
Date:   Wed,  2 Sep 2020 14:25:21 +0300
Message-Id: <20200902112529.1570040-8-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200902112529.1570040-1-nikolay@cumulusnetworks.com>
References: <20200902112529.1570040-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change is in preparation for using the mdb port group entries when
sending a notification, so their full state and additional attributes can
be filled in.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_mdb.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 7625db4b7fb9..f5290021310a 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -663,7 +663,7 @@ static int br_mdb_parse(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
-			    struct br_ip *group, unsigned char state)
+			    struct br_ip *group, struct br_mdb_entry *entry)
 {
 	struct net_bridge_mdb_entry *mp;
 	struct net_bridge_port_group *p;
@@ -682,12 +682,13 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 	/* host join */
 	if (!port) {
 		/* don't allow any flags for host-joined groups */
-		if (state)
+		if (entry->state)
 			return -EINVAL;
 		if (mp->host_joined)
 			return -EEXIST;
 
 		br_multicast_host_join(mp, false);
+		__br_mdb_notify(br->dev, NULL, entry, RTM_NEWMDB);
 
 		return 0;
 	}
@@ -701,13 +702,14 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 			break;
 	}
 
-	p = br_multicast_new_port_group(port, group, *pp, state, NULL);
+	p = br_multicast_new_port_group(port, group, *pp, entry->state, NULL);
 	if (unlikely(!p))
 		return -ENOMEM;
 	p->filter_mode = MCAST_EXCLUDE;
 	rcu_assign_pointer(*pp, p);
-	if (state == MDB_TEMPORARY)
+	if (entry->state == MDB_TEMPORARY)
 		mod_timer(&p->timer, now + br->multicast_membership_interval);
+	__br_mdb_notify(br->dev, port, entry, RTM_NEWMDB);
 
 	return 0;
 }
@@ -736,7 +738,7 @@ static int __br_mdb_add(struct net *net, struct net_bridge *br,
 	__mdb_entry_to_br_ip(entry, &ip);
 
 	spin_lock_bh(&br->multicast_lock);
-	ret = br_mdb_add_group(br, p, &ip, entry->state);
+	ret = br_mdb_add_group(br, p, &ip, entry);
 	spin_unlock_bh(&br->multicast_lock);
 	return ret;
 }
@@ -781,12 +783,9 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 			err = __br_mdb_add(net, br, entry);
 			if (err)
 				break;
-			__br_mdb_notify(dev, p, entry, RTM_NEWMDB);
 		}
 	} else {
 		err = __br_mdb_add(net, br, entry);
-		if (!err)
-			__br_mdb_notify(dev, p, entry, RTM_NEWMDB);
 	}
 
 	return err;
@@ -814,6 +813,7 @@ static int __br_mdb_del(struct net_bridge *br, struct br_mdb_entry *entry)
 	if (entry->ifindex == mp->br->dev->ifindex && mp->host_joined) {
 		br_multicast_host_leave(mp, false);
 		err = 0;
+		__br_mdb_notify(br->dev, NULL, entry, RTM_DELMDB);
 		if (!mp->ports && netif_running(br->dev))
 			mod_timer(&mp->timer, jiffies);
 		goto unlock;
@@ -876,13 +876,9 @@ static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 		list_for_each_entry(v, &vg->vlan_list, vlist) {
 			entry->vid = v->vid;
 			err = __br_mdb_del(br, entry);
-			if (!err)
-				__br_mdb_notify(dev, p, entry, RTM_DELMDB);
 		}
 	} else {
 		err = __br_mdb_del(br, entry);
-		if (!err)
-			__br_mdb_notify(dev, p, entry, RTM_DELMDB);
 	}
 
 	return err;
-- 
2.25.4

