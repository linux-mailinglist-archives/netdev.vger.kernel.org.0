Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89FE23B6AAE
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 00:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237704AbhF1WD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 18:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236799AbhF1WDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 18:03:06 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AFC7C061760
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 15:00:36 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id n25so1726218edw.9
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 15:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l0CZNtkfeJQejItwC7vZvOlnWOoK6FFD+nSdpk8okW4=;
        b=BO/Ai9PlHbIxyVNWVaAHGkiBr8HQm6cvZHGsk3OXeRFuJqgvjLlaYa299SRg68ZY1R
         6qn8yhcAeGF/B/DsGPyojUNJ8qALapguVZJHMajxzBIR+BCyWl+c34WhStONUS/nJXQZ
         FGDaI7hRMXmJcAHQqClEheljpX7vUtlZUxmCSf4WjWGxGUoEerH0Go3+eEzZDYS9p32C
         ZTkMwjRURbI1XPNyX9PDTxoc33qA1hdTC5SBPOhtwUQCCKV/TroGvWBV0gb0odS4aCjw
         mkAlhQiSZzJyXMjE8WToUZYu9/yoZ1AdIPZzL4thVZ2yC8a1xZoFK66S7nRINjM0ZUnz
         +hPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l0CZNtkfeJQejItwC7vZvOlnWOoK6FFD+nSdpk8okW4=;
        b=FasO6YtJ5EGjKQY0PbO7dF91qYEjsgbC8xAWyxR2+GS4k4Whh2AsmWFLiugrsXLPHp
         ADrWCDsRd3bpeRV+g3Hu/AMJkL9m1FAo2AzYU0BOinBqZegB3LrH7PU6DTvysJ8S8ZDz
         FPeMXzDjsF9/w+fyz2u/51Er6OQ1/eKA0cwVONU5np5jIqZvfqEQFT4Y+mrOzjxIr6EF
         COjDWHqrl20DxAlRmlf8rd2c+2hUrZfwSgqXr523aT+E5pJ0/MrioNWr/DGJ06m5exM9
         e4v06S1q9K6hb2arlGrj/haFtG/qnTAkeAZpsq3LI5ARbe/5UWk07GYvFIZUiYcwbSJt
         UBEw==
X-Gm-Message-State: AOAM532RU6X8eGxloiQkmlbcXwLElkhMMjcA9OkKwZbCHHqnc511fXv8
        WVLNXditk0ZP1tl5wbcfBLMfwACLS5w=
X-Google-Smtp-Source: ABdhPJxTEiRk5Kgi8p7ywQ+fKxgCD0RUcu1xZ/37jomsujwp+6OZfhdkHeVxiT8Sdv72f56bjuU72Q==
X-Received: by 2002:a05:6402:1111:: with SMTP id u17mr35975530edv.87.1624917635119;
        Mon, 28 Jun 2021 15:00:35 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id dn7sm10146615edb.29.2021.06.28.15.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 15:00:34 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v4 net-next 01/14] net: bridge: switchdev: send FDB notifications for host addresses
Date:   Tue, 29 Jun 2021 00:59:58 +0300
Message-Id: <20210628220011.1910096-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210628220011.1910096-1-olteanv@gmail.com>
References: <20210628220011.1910096-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com>

Treat addresses added to the bridge itself in the same way as regular
ports and send out a notification so that drivers may sync it down to
the hardware FDB.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_fdb.c       |  4 ++--
 net/bridge/br_private.h   |  7 ++++---
 net/bridge/br_switchdev.c | 11 +++++------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 16f9434fdb5d..0296d737a519 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -602,7 +602,7 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 			/* fastpath: update of existing entry */
 			if (unlikely(source != fdb->dst &&
 				     !test_bit(BR_FDB_STICKY, &fdb->flags))) {
-				br_switchdev_fdb_notify(fdb, RTM_DELNEIGH);
+				br_switchdev_fdb_notify(br, fdb, RTM_DELNEIGH);
 				fdb->dst = source;
 				fdb_modified = true;
 				/* Take over HW learned entry */
@@ -794,7 +794,7 @@ static void fdb_notify(struct net_bridge *br,
 	int err = -ENOBUFS;
 
 	if (swdev_notify)
-		br_switchdev_fdb_notify(fdb, type);
+		br_switchdev_fdb_notify(br, fdb, type);
 
 	skb = nlmsg_new(fdb_nlmsg_size(), GFP_ATOMIC);
 	if (skb == NULL)
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index a684d0cfc58c..2b48b204205e 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1654,8 +1654,8 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 			       unsigned long flags,
 			       unsigned long mask,
 			       struct netlink_ext_ack *extack);
-void br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb,
-			     int type);
+void br_switchdev_fdb_notify(struct net_bridge *br,
+			     const struct net_bridge_fdb_entry *fdb, int type);
 int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid, u16 flags,
 			       struct netlink_ext_ack *extack);
 int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid);
@@ -1702,7 +1702,8 @@ static inline int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid)
 }
 
 static inline void
-br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
+br_switchdev_fdb_notify(struct net_bridge *br,
+			const struct net_bridge_fdb_entry *fdb, int type)
 {
 }
 
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index a5e601e41cb9..9a707da79dfe 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -108,7 +108,8 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 }
 
 void
-br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
+br_switchdev_fdb_notify(struct net_bridge *br,
+			const struct net_bridge_fdb_entry *fdb, int type)
 {
 	struct switchdev_notifier_fdb_info info = {
 		.addr = fdb->key.addr.addr,
@@ -117,18 +118,16 @@ br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
 		.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags),
 		.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags),
 	};
-
-	if (!fdb->dst)
-		return;
+	struct net_device *dev = fdb->dst ? fdb->dst->dev : br->dev;
 
 	switch (type) {
 	case RTM_DELNEIGH:
 		call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_DEVICE,
-					 fdb->dst->dev, &info.info, NULL);
+					 dev, &info.info, NULL);
 		break;
 	case RTM_NEWNEIGH:
 		call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_DEVICE,
-					 fdb->dst->dev, &info.info, NULL);
+					 dev, &info.info, NULL);
 		break;
 	}
 }
-- 
2.25.1

