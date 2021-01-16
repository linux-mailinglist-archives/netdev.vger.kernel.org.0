Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D792F8A6D
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 02:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729143AbhAPB0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 20:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726662AbhAPB0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 20:26:32 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24791C061793
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:25:52 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id m25so15857544lfc.11
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 17:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=OE5CJwn57ipw41wtwse27GpaDkZuxirGNUKQQ0a4wSQ=;
        b=Qwyt/WKje2ETDP4sm0EHQYHJ+79MvPV6f3PfrUF87ccl8s0pt/lWYHKqzLymgcN0gl
         ZEjLWS0meuGjGq5gfbwGcr9cIj72+AlavZghbA9N858dzO80qSDc+bWhaAml3J9yenSc
         WnG2mXdERa8Uz056M7DUXpm7oeHF0zJTJAtPREVeai3REdx17cLYdmFK6hotnAeThIux
         3yR4QkEETyVu+ODS0e9/Yii4jlUWaIpoZfkUaWL/vD2wBEUio2yBts9KKPCqCnIGPSWA
         5MJhwpe4EDJcLSTyH98TTJPOjGjPLkiZVIIetLD1sJYbt5Ctt5EEj55vYnE5DfNoCSlv
         0ldw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=OE5CJwn57ipw41wtwse27GpaDkZuxirGNUKQQ0a4wSQ=;
        b=ffady0+yI7pzqqUHuA44HmWnezBAnTbnIKcZ0WM9V5rTbZoRLxlL6A/1PTkWNWngF/
         0JR/CV9sdr6wb6TSU3EfgqaR6r8vwaaYtxyeYh2XtK7lSNcFRYjWRaXRWImM+XC4dPQn
         ol94y7Up7bFgAxsIq5fvuQp6TSxbIfz+DYuFZzH2SZ157GuEqG3HCtGnDVXJ7y3MeiP6
         cVxFT7MNcryNUSw6aXd3ckMEto7k1BBgNrofzSIA5pb14Hifzp8qHk9UcGHmkE+2cwJs
         FtJiPATNDIpLU98hFhewkRFxWWGZpFMtW0stfUMHuGfpi2JLlIHCtwobOY+aPuMFfoxB
         XyRw==
X-Gm-Message-State: AOAM531z3kNqE6EHtOlf31zyeH/bG8szTg63CRRjAM1s2c0g0s9TXI3t
        CfLnmjTOuiYRUV99HzKZ4sJCNA==
X-Google-Smtp-Source: ABdhPJxNIwEpwd/Agg85tr6juLOZIu3q0dwi8m5mInqQu5pC0onEBRo0ivCvJHvcMPHj4f2z/btqGg==
X-Received: by 2002:a05:6512:30a:: with SMTP id t10mr6429086lfp.124.1610760350689;
        Fri, 15 Jan 2021 17:25:50 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id 198sm1085686lfn.51.2021.01.15.17.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 17:25:50 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, roopa@nvidia.com, nikolay@nvidia.com,
        netdev@vger.kernel.org
Subject: [RFC net-next 3/7] net: bridge: switchdev: Send FDB notifications for host addresses
Date:   Sat, 16 Jan 2021 02:25:11 +0100
Message-Id: <20210116012515.3152-4-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210116012515.3152-1-tobias@waldekranz.com>
References: <20210116012515.3152-1-tobias@waldekranz.com>
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Treat addresses added to the bridge itself in the same way as regular
ports and send out a notification so that drivers may sync it down to
the hardware FDB.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 net/bridge/br_fdb.c       |  4 ++--
 net/bridge/br_private.h   |  7 ++++---
 net/bridge/br_switchdev.c | 11 +++++------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index b7490237f3fc..1d54ae0f58fb 100644
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
@@ -735,7 +735,7 @@ static void fdb_notify(struct net_bridge *br,
 	int err = -ENOBUFS;
 
 	if (swdev_notify)
-		br_switchdev_fdb_notify(fdb, type);
+		br_switchdev_fdb_notify(br, fdb, type);
 
 	skb = nlmsg_new(fdb_nlmsg_size(), GFP_ATOMIC);
 	if (skb == NULL)
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index d62c6e1af64a..a3e20b747eca 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1568,8 +1568,8 @@ bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
 int br_switchdev_set_port_flag(struct net_bridge_port *p,
 			       unsigned long flags,
 			       unsigned long mask);
-void br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb,
-			     int type);
+void br_switchdev_fdb_notify(struct net_bridge *br,
+			     const struct net_bridge_fdb_entry *fdb, int type);
 int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid, u16 flags,
 			       struct netlink_ext_ack *extack);
 int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid);
@@ -1615,7 +1615,8 @@ static inline int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid)
 }
 
 static inline void
-br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
+br_switchdev_fdb_notify(struct net_bridge *br,
+			const struct net_bridge_fdb_entry *fdb, int type)
 {
 }
 
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 1090bb3d4ee0..125637c34f14 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -103,7 +103,8 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 }
 
 void
-br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
+br_switchdev_fdb_notify(struct net_bridge *br,
+			const struct net_bridge_fdb_entry *fdb, int type)
 {
 	struct switchdev_notifier_fdb_info info = {
 		.addr = fdb->key.addr.addr,
@@ -112,18 +113,16 @@ br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
 		.local = test_bit(BR_FDB_LOCAL, &fdb->flags),
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
2.17.1

