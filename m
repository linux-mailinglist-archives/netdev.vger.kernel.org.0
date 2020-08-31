Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA0B257BD6
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 17:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbgHaPLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 11:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728268AbgHaPKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 11:10:10 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A460AC0619C3
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 08:10:02 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id e16so6336690wrm.2
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 08:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TOF7a7FI8Ce6aHPNT2YVGTdqisTrt5r3aRa3Yt5wFn4=;
        b=akT3HeoftK+wnUCJ7eeEPeWNfCZ5VDVE0TvSnrtcrghUhrmCX6EhZ/yir6Csc6WF0j
         nh1jDcxxQxIDcYdWPVCyA6tLNlelvVOjM3gYMMMngh6xoAstSqC24zlbeN1pBO3gvSZk
         UwKs09kKbumBw1sTagi+TxZ0VqgA4Fz70pPC0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TOF7a7FI8Ce6aHPNT2YVGTdqisTrt5r3aRa3Yt5wFn4=;
        b=Y/4HJV8QLJWV7NjHQo2bVKUnJp6+fDimynfCQ15YXZc3H4c1JhMWRdXILaK92J8EYu
         COHZ9+FHia/d9i81lEMRCUdbMbMiyHLabQ+OZPJwZ3hwySWkg4iOmIUElV6qYiEwV5ZE
         6bnrtPfGnIftTm5umPkmUnJ8UB9JgYW2kgZHihVNAOpi6Cq4GCdbNDM8C3cPX1aDvu4n
         w3uC4rWBRG8DJYrHMiLVV2eoWidhJtgdBvPINdpIY5HxLubn9gmfcGm91dH4mXb6HjVe
         AOP59yzIOW8FiIzQ8Rx2h39ivPICl7iqSfNct/Dk+tmXqEJPhAnRpaBWxLBP/PnvYDkV
         YtEw==
X-Gm-Message-State: AOAM532xV/yoJu4BA0sIEuP5kxHyCPPtlmK0vKb3BzbdIx3f6L53p+fr
        1NUeVF9HT8DREudn57oEB4O3Oun1ZuixUlml
X-Google-Smtp-Source: ABdhPJxtPp4LqGKgAEqyuh0ZqvW2ny17uGwCl+Rc3yWbWpMBCDZH9FzS3Dazl3kt9gjKyD8HtxD36g==
X-Received: by 2002:adf:f8d0:: with SMTP id f16mr2259793wrq.66.1598886600944;
        Mon, 31 Aug 2020 08:10:00 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f6sm14181636wme.32.2020.08.31.08.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2020 08:10:00 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 07/15] net: bridge: mdb: push notifications in __br_mdb_add/del
Date:   Mon, 31 Aug 2020 18:08:37 +0300
Message-Id: <20200831150845.1062447-8-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200831150845.1062447-1-nikolay@cumulusnetworks.com>
References: <20200831150845.1062447-1-nikolay@cumulusnetworks.com>
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
index 07cb07cd3691..a3ebc2d3b8f6 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -662,7 +662,7 @@ static int br_mdb_parse(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 
 static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
-			    struct br_ip *group, unsigned char state)
+			    struct br_ip *group, struct br_mdb_entry *entry)
 {
 	struct net_bridge_mdb_entry *mp;
 	struct net_bridge_port_group *p;
@@ -681,12 +681,13 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
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
@@ -700,13 +701,14 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
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
@@ -735,7 +737,7 @@ static int __br_mdb_add(struct net *net, struct net_bridge *br,
 	__mdb_entry_to_br_ip(entry, &ip);
 
 	spin_lock_bh(&br->multicast_lock);
-	ret = br_mdb_add_group(br, p, &ip, entry->state);
+	ret = br_mdb_add_group(br, p, &ip, entry);
 	spin_unlock_bh(&br->multicast_lock);
 	return ret;
 }
@@ -780,12 +782,9 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
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
@@ -813,6 +812,7 @@ static int __br_mdb_del(struct net_bridge *br, struct br_mdb_entry *entry)
 	if (entry->ifindex == mp->br->dev->ifindex && mp->host_joined) {
 		br_multicast_host_leave(mp, false);
 		err = 0;
+		__br_mdb_notify(br->dev, NULL, entry, RTM_DELMDB);
 		if (!mp->ports && netif_running(br->dev))
 			mod_timer(&mp->timer, jiffies);
 		goto unlock;
@@ -875,13 +875,9 @@ static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
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

