Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C58C3F2C5C
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 14:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240308AbhHTMoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 08:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239917AbhHTMoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 08:44:38 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFACC061575
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 05:44:01 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id z20so19985023ejf.5
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 05:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n/xXaP86OQ6aA4f7HKy+IYr/tYhPkArpBKf71oj6eyQ=;
        b=zNZ4HP6eAol6yE1f8NAWaafWuSJFfWpnUTneQVp7A0KSybg/dhpotSQNQFEbnaodVG
         M7rro7r5iP8LrsayWdZs4mxBUY/SUA6c/LF1c12kVB88UPLQfHvfaWo3s53yzxpapvFU
         xhV49DM9DHJvfS7GfOQG84ITTnmPck/X0Wdyuav2vRwj91WtgH35TdpbOlfs7HYrUSq9
         /U5fk6lKcx9RuParIbMT+FsKrNrkq0h0qE23GaXb1V71N7BR0Qn7feU2mk/RLOyfM66q
         fGkR+KXnI5EHMjwSc9NQ+dAv3XCTClrh+ZqdVOc80FDUN/jssJiogye0Sp82HvahksJT
         ElQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n/xXaP86OQ6aA4f7HKy+IYr/tYhPkArpBKf71oj6eyQ=;
        b=KG13DYRAMa6oZLm/Qlq1nqs3BeXpbboUDKLJ2pcazp61LZsJ/EFViOf9pw41JksGKC
         1DOZkoorFJlsgJ9GlWtz4SudaY31fLyI51OZSumpWTlxrz8E88luAaSe+gmfVFZQ9Jul
         VKWN5EE/RD3kKDynuHwSceEyFg6kCpgRtLkUPME5nfU7x6AzDuyLgAx3V0+hKL33cL1e
         EPthhM4UwVpNrpN4lA3xE8F7j1K24Wot/eKRoQgmo3fUmItBuheshsLvBB6AzouGuGqT
         7z+G73YCyoz0lsa/kPwMJS2rWyzkG/PVA+ivFXKjIBibJe2N9jycK5lDLtoawa2iQ1RJ
         VZiQ==
X-Gm-Message-State: AOAM5316n5pt2Ehi30mdpvfFjp6efd1uhB4a1R0nQBWMWKX3HIdeMsy8
        q+fc2MZw1zev8PyVb831Rt+6e8VX9i1sbhu/
X-Google-Smtp-Source: ABdhPJzlHED3LAOKishrI0nK19ZMu7umSZkvh2288oAvIfP79r2VOW15/AG0NitVHtL+Kkuepop2/w==
X-Received: by 2002:a17:906:b08e:: with SMTP id x14mr21098410ejy.40.1629463439344;
        Fri, 20 Aug 2021 05:43:59 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id ci19sm676627ejc.109.2021.08.20.05.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 05:43:58 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 1/2] net: bridge: mcast: br_multicast_set_port_router takes multicast context as argument
Date:   Fri, 20 Aug 2021 15:42:54 +0300
Message-Id: <20210820124255.1465672-2-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210820124255.1465672-1-razor@blackwall.org>
References: <20210820124255.1465672-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Change br_multicast_set_port_router to take port multicast context as
its first argument so we can later use it to control port/vlan mcast
router option.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast.c | 11 ++++++-----
 net/bridge/br_netlink.c   |  3 ++-
 net/bridge/br_private.h   |  3 ++-
 net/bridge/br_sysfs_if.c  |  2 +-
 4 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 16e686f5b9e9..be9d1376e249 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -4246,15 +4246,16 @@ br_multicast_rport_del_notify(struct net_bridge_mcast_port *pmctx, bool deleted)
 		pmctx->multicast_router = MDB_RTR_TYPE_TEMP_QUERY;
 }
 
-int br_multicast_set_port_router(struct net_bridge_port *p, unsigned long val)
+int br_multicast_set_port_router(struct net_bridge_mcast_port *pmctx,
+				 unsigned long val)
 {
-	struct net_bridge_mcast *brmctx = &p->br->multicast_ctx;
-	struct net_bridge_mcast_port *pmctx = &p->multicast_ctx;
+	struct net_bridge_mcast *brmctx;
 	unsigned long now = jiffies;
 	int err = -EINVAL;
 	bool del = false;
 
-	spin_lock(&p->br->multicast_lock);
+	brmctx = br_multicast_port_ctx_get_global(pmctx);
+	spin_lock(&brmctx->br->multicast_lock);
 	if (pmctx->multicast_router == val) {
 		/* Refresh the temp router port timer */
 		if (pmctx->multicast_router == MDB_RTR_TYPE_TEMP) {
@@ -4304,7 +4305,7 @@ int br_multicast_set_port_router(struct net_bridge_port *p, unsigned long val)
 	}
 	err = 0;
 unlock:
-	spin_unlock(&p->br->multicast_lock);
+	spin_unlock(&brmctx->br->multicast_lock);
 
 	return err;
 }
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 2f184ad8ae29..6c58fc14d2cb 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -932,7 +932,8 @@ static int br_setport(struct net_bridge_port *p, struct nlattr *tb[],
 	if (tb[IFLA_BRPORT_MULTICAST_ROUTER]) {
 		u8 mcast_router = nla_get_u8(tb[IFLA_BRPORT_MULTICAST_ROUTER]);
 
-		err = br_multicast_set_port_router(p, mcast_router);
+		err = br_multicast_set_port_router(&p->multicast_ctx,
+						   mcast_router);
 		if (err)
 			return err;
 	}
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 21b292eb2b3e..fcc0fcf44a95 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -879,7 +879,8 @@ void br_multicast_flood(struct net_bridge_mdb_entry *mdst, struct sk_buff *skb,
 			struct net_bridge_mcast *brmctx,
 			bool local_rcv, bool local_orig);
 int br_multicast_set_router(struct net_bridge_mcast *brmctx, unsigned long val);
-int br_multicast_set_port_router(struct net_bridge_port *p, unsigned long val);
+int br_multicast_set_port_router(struct net_bridge_mcast_port *pmctx,
+				 unsigned long val);
 int br_multicast_toggle(struct net_bridge *br, unsigned long val,
 			struct netlink_ext_ack *extack);
 int br_multicast_set_querier(struct net_bridge_mcast *brmctx, unsigned long val);
diff --git a/net/bridge/br_sysfs_if.c b/net/bridge/br_sysfs_if.c
index e9e3aedd3178..07fa76080512 100644
--- a/net/bridge/br_sysfs_if.c
+++ b/net/bridge/br_sysfs_if.c
@@ -250,7 +250,7 @@ static ssize_t show_multicast_router(struct net_bridge_port *p, char *buf)
 static int store_multicast_router(struct net_bridge_port *p,
 				      unsigned long v)
 {
-	return br_multicast_set_port_router(p, v);
+	return br_multicast_set_port_router(&p->multicast_ctx, v);
 }
 static BRPORT_ATTR(multicast_router, 0644, show_multicast_router,
 		   store_multicast_router);
-- 
2.31.1

