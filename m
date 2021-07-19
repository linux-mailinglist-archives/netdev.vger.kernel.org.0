Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836C33CE84A
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 19:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355803AbhGSQj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 12:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345368AbhGSQgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 12:36:36 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386CBC07880E
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 09:49:55 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id k27so24974889edk.9
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 10:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XWAMcGQgcWJL3j09SfjKb/XvvQ805bCMahly93jAMwg=;
        b=fslx44Dp1STX8Hakf2R6egp847gLkkW65fDlNgVYZ6QpnpYvhpUwGZ6Fu13ibGgRJp
         Z2HFHwjOpYfGTFVx+GN84UNVFbVFEOFRuAeUJcJuTBbZCcebyb9GkJw/Vy41OLCueBr1
         ky/+e9L73QNnYTNcvWW60TxhF3UWJk5s+E0lFZ9R2m9NNkyI2N/t/d6qgIgzMRkdKqSO
         HI9/2mTzlQtAMosvDTtBeSsfdGmUFALSJMM3nzrIEtOGDUsZvxBn4nBzEDrTRNGvBPBB
         5jrAx/6Br/r/sQJSV4DGLsbXg7nAyYabfYV+195pRP02k5AasTigKSD8Y2rbvm86WHIo
         dPKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XWAMcGQgcWJL3j09SfjKb/XvvQ805bCMahly93jAMwg=;
        b=d6guwLmZVGN5quiqXtBB4fnpuK8m4Hl62R4v5QIugpdzOGZeBvGUUSCQPBu73o+prW
         6Y1c96ZtU/b1FTh93iP6K+B3fHRsjH5G8yLZUMdlAtpAO+aaulzjFCI15/El9o8fq0Za
         d1J594tO09GI2ryAF2dJbnKaFCU3RUHACA66hhJ1HJ8DXRLFzNEICZ5nhWc9R8eSeKjX
         7aE2z2xEsmqqe9GZo72tOweneXmtVDpriwvovMvAtrnbFAIsDE3i+0fG01RZ5hFvmJ0t
         OvmsdyMkmi3YGQb7vZdAXVojOalI02kmfOk69WgV6f56nheYM+6PBa96lIGkOoMWH0q5
         yFww==
X-Gm-Message-State: AOAM530+rh8Y2KgsYvy67HOstQItK+n4Vll5Vak/3LQd3behl0nl88tW
        0UkQozg2rIPuoSHEGV/uI1hpbql4ViWN3sLWJfU=
X-Google-Smtp-Source: ABdhPJyG8JZKjVP1WNSfUjUl7sk4Ty6qx1bvItnBDMJHthFTCgXGUNTtBh9eMNoyUKigAyGD+YBfcA==
X-Received: by 2002:aa7:ca44:: with SMTP id j4mr35001283edt.203.1626714607133;
        Mon, 19 Jul 2021 10:10:07 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id nc29sm6073896ejc.10.2021.07.19.10.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 10:10:06 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 11/15] net: bridge: multicast: include router port vlan id in notifications
Date:   Mon, 19 Jul 2021 20:06:33 +0300
Message-Id: <20210719170637.435541-12-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210719170637.435541-1-razor@blackwall.org>
References: <20210719170637.435541-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Use the port multicast context to check if the router port is a vlan and
in case it is include its vlan id in the notification.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 include/uapi/linux/if_bridge.h |  1 +
 net/bridge/br_mdb.c            | 29 ++++++++++++++++++++++-------
 net/bridge/br_multicast.c      |  4 ++--
 net/bridge/br_private.h        |  2 +-
 4 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 57a63a1572e0..1f7513300cfe 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -629,6 +629,7 @@ enum {
 	MDBA_ROUTER_PATTR_TYPE,
 	MDBA_ROUTER_PATTR_INET_TIMER,
 	MDBA_ROUTER_PATTR_INET6_TIMER,
+	MDBA_ROUTER_PATTR_VID,
 	__MDBA_ROUTER_PATTR_MAX
 };
 #define MDBA_ROUTER_PATTR_MAX (__MDBA_ROUTER_PATTR_MAX - 1)
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 5319587198eb..d3383a47a2f2 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -781,12 +781,12 @@ void br_mdb_notify(struct net_device *dev,
 
 static int nlmsg_populate_rtr_fill(struct sk_buff *skb,
 				   struct net_device *dev,
-				   int ifindex, u32 pid,
+				   int ifindex, u16 vid, u32 pid,
 				   u32 seq, int type, unsigned int flags)
 {
+	struct nlattr *nest, *port_nest;
 	struct br_port_msg *bpm;
 	struct nlmsghdr *nlh;
-	struct nlattr *nest;
 
 	nlh = nlmsg_put(skb, pid, seq, type, sizeof(*bpm), 0);
 	if (!nlh)
@@ -800,8 +800,18 @@ static int nlmsg_populate_rtr_fill(struct sk_buff *skb,
 	if (!nest)
 		goto cancel;
 
-	if (nla_put_u32(skb, MDBA_ROUTER_PORT, ifindex))
+	port_nest = nla_nest_start_noflag(skb, MDBA_ROUTER_PORT);
+	if (!port_nest)
+		goto end;
+	if (nla_put_nohdr(skb, sizeof(u32), &ifindex)) {
+		nla_nest_cancel(skb, port_nest);
 		goto end;
+	}
+	if (vid && nla_put_u16(skb, MDBA_ROUTER_PATTR_VID, vid)) {
+		nla_nest_cancel(skb, port_nest);
+		goto end;
+	}
+	nla_nest_end(skb, port_nest);
 
 	nla_nest_end(skb, nest);
 	nlmsg_end(skb, nlh);
@@ -817,23 +827,28 @@ static int nlmsg_populate_rtr_fill(struct sk_buff *skb,
 static inline size_t rtnl_rtr_nlmsg_size(void)
 {
 	return NLMSG_ALIGN(sizeof(struct br_port_msg))
-		+ nla_total_size(sizeof(__u32));
+		+ nla_total_size(sizeof(__u32))
+		+ nla_total_size(sizeof(u16));
 }
 
-void br_rtr_notify(struct net_device *dev, struct net_bridge_port *port,
+void br_rtr_notify(struct net_device *dev, struct net_bridge_mcast_port *pmctx,
 		   int type)
 {
 	struct net *net = dev_net(dev);
 	struct sk_buff *skb;
 	int err = -ENOBUFS;
 	int ifindex;
+	u16 vid;
 
-	ifindex = port ? port->dev->ifindex : 0;
+	ifindex = pmctx ? pmctx->port->dev->ifindex : 0;
+	vid = pmctx && br_multicast_port_ctx_is_vlan(pmctx) ? pmctx->vlan->vid :
+							      0;
 	skb = nlmsg_new(rtnl_rtr_nlmsg_size(), GFP_ATOMIC);
 	if (!skb)
 		goto errout;
 
-	err = nlmsg_populate_rtr_fill(skb, dev, ifindex, 0, 0, type, NTF_SELF);
+	err = nlmsg_populate_rtr_fill(skb, dev, ifindex, vid, 0, 0, type,
+				      NTF_SELF);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto errout;
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 9d4a18a711e4..fb5e5df571fd 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -2979,7 +2979,7 @@ static void br_multicast_add_router(struct net_bridge_mcast *brmctx,
 	 * IPv4 or IPv6 multicast router.
 	 */
 	if (br_multicast_no_router_otherpf(pmctx, rlist)) {
-		br_rtr_notify(pmctx->port->br->dev, pmctx->port, RTM_NEWMDB);
+		br_rtr_notify(pmctx->port->br->dev, pmctx, RTM_NEWMDB);
 		br_port_mc_router_state_change(pmctx->port, true);
 	}
 }
@@ -4078,7 +4078,7 @@ br_multicast_rport_del_notify(struct net_bridge_mcast_port *pmctx, bool deleted)
 		return;
 #endif
 
-	br_rtr_notify(pmctx->port->br->dev, pmctx->port, RTM_DELMDB);
+	br_rtr_notify(pmctx->port->br->dev, pmctx, RTM_DELMDB);
 	br_port_mc_router_state_change(pmctx->port, false);
 
 	/* don't allow timer refresh */
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 00b93fcc7870..5515b6c37322 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -885,7 +885,7 @@ int br_mdb_hash_init(struct net_bridge *br);
 void br_mdb_hash_fini(struct net_bridge *br);
 void br_mdb_notify(struct net_device *dev, struct net_bridge_mdb_entry *mp,
 		   struct net_bridge_port_group *pg, int type);
-void br_rtr_notify(struct net_device *dev, struct net_bridge_port *port,
+void br_rtr_notify(struct net_device *dev, struct net_bridge_mcast_port *pmctx,
 		   int type);
 void br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
 			 struct net_bridge_port_group *pg,
-- 
2.31.1

