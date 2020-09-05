Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F371025E681
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 10:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728507AbgIEIZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 04:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728364AbgIEIYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 04:24:52 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90862C06124F
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 01:24:52 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id z4so9667269wrr.4
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 01:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hT9vU1lKXpIUXAGJ5O2ZQpnKTxvjgUKuVdaVH35xDc4=;
        b=EBr3Ufe2kSwQ0O5N9Hd0ouzduAEvBYT7hQoQ3gaOqKxrRNZHUcGDLu89Gv/IB1uvgq
         2fehdJRQK2W6/QQHe2LJPedQaqlMSObVhXYiF3XgYJkOv/RvJ95GR+v8eumSSNstnLvW
         WjGgnmVP+/3V6Bs31QWw5amxBYghd2HlzSDJA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hT9vU1lKXpIUXAGJ5O2ZQpnKTxvjgUKuVdaVH35xDc4=;
        b=NDnZ1RDmrOVv+TFSenH6Co+rFWM8GaTgHJh9FKd34EyJ7+oIGB6rFBrjRWqS9kGFgI
         qRktNGsRX/cto+J8JxdN7N9GDefLOHtJChUUwettlfa8859AUM5/J7C6Vk79rDkax+Ic
         y3qbxTQJqNC9QaYziYamcAixDGlug6n/Ig0b9cFicEbPLc1QchLmA8ekc2d2kusjHtMJ
         vybvElG9jvEKZzr6nBikkILd8MhLV9bacw7HZXetTnAHA//Yzy408lwWdeJlkRavUyTS
         xLq5TOY+A909lWhZQaIAvHOTo3r1OHcWopLkxm2XjKKwBJ/hvkcFbYVTLkYtLT55YHOA
         GlUQ==
X-Gm-Message-State: AOAM532prBd/UfX/lRvQae4JMopNdBTekbY5023caEiThRIfGvEzeUwy
        jFpd22jkEIDi122a3yNLYXvXk0baTQTOduH8
X-Google-Smtp-Source: ABdhPJwa5kD/O/w6Tc/DH06e8PDC+aszyfMMYU/BDaMPvWJTX63D9RAjNVXQgk7amVw8/7Wd9R/EZA==
X-Received: by 2002:adf:edd2:: with SMTP id v18mr10938045wro.242.1599294290846;
        Sat, 05 Sep 2020 01:24:50 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id m185sm17169296wmf.5.2020.09.05.01.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 01:24:50 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v3 07/15] net: bridge: mdb: push notifications in __br_mdb_add/del
Date:   Sat,  5 Sep 2020 11:24:02 +0300
Message-Id: <20200905082410.2230253-8-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200905082410.2230253-1-nikolay@cumulusnetworks.com>
References: <20200905082410.2230253-1-nikolay@cumulusnetworks.com>
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
index 9dc12ce61018..24f6ccf98657 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -681,7 +681,7 @@ static int br_mdb_parse(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
-			    struct br_ip *group, unsigned char state)
+			    struct br_ip *group, struct br_mdb_entry *entry)
 {
 	struct net_bridge_mdb_entry *mp;
 	struct net_bridge_port_group *p;
@@ -700,12 +700,13 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
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
@@ -719,13 +720,14 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 			break;
 	}
 
-	p = br_multicast_new_port_group(port, group, *pp, state, NULL,
+	p = br_multicast_new_port_group(port, group, *pp, entry->state, NULL,
 					MCAST_EXCLUDE);
 	if (unlikely(!p))
 		return -ENOMEM;
 	rcu_assign_pointer(*pp, p);
-	if (state == MDB_TEMPORARY)
+	if (entry->state == MDB_TEMPORARY)
 		mod_timer(&p->timer, now + br->multicast_membership_interval);
+	__br_mdb_notify(br->dev, port, entry, RTM_NEWMDB);
 
 	return 0;
 }
@@ -754,7 +756,7 @@ static int __br_mdb_add(struct net *net, struct net_bridge *br,
 	__mdb_entry_to_br_ip(entry, &ip);
 
 	spin_lock_bh(&br->multicast_lock);
-	ret = br_mdb_add_group(br, p, &ip, entry->state);
+	ret = br_mdb_add_group(br, p, &ip, entry);
 	spin_unlock_bh(&br->multicast_lock);
 	return ret;
 }
@@ -799,12 +801,9 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
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
@@ -832,6 +831,7 @@ static int __br_mdb_del(struct net_bridge *br, struct br_mdb_entry *entry)
 	if (entry->ifindex == mp->br->dev->ifindex && mp->host_joined) {
 		br_multicast_host_leave(mp, false);
 		err = 0;
+		__br_mdb_notify(br->dev, NULL, entry, RTM_DELMDB);
 		if (!mp->ports && netif_running(br->dev))
 			mod_timer(&mp->timer, jiffies);
 		goto unlock;
@@ -894,13 +894,9 @@ static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
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

