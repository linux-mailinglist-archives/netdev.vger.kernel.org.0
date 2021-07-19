Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFF53CE844
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 19:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355732AbhGSQjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 12:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355660AbhGSQgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 12:36:33 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13377C04F97C
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 09:49:51 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id c17so29853334ejk.13
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 10:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l2f8wSd2cFUSrpRoYeQ6oFo0IF2ypfibcU91DvCPZco=;
        b=wgmz7k/s54dbcXvrb+4rMBZQwTgHvK9EAWb8El5VRb4pA+H1C/njj2yPqKsVbkoDyq
         hb1QLfyM7pmQ4/LafPsodQpBu6ZS7Du86JZVHtcYDWCYpwXVHhlmE7augpY7WVW3XoNS
         uTZOVTmpp6BxA1p7n7amNMxqNBTlWYzSjr2y58XH4fpdUpZm9pjqmw5gumYK3EBmluLF
         nnbrqlvCU0ifK5hDRL9uT2tOQgx5vHbDIDUYqmzfOhGhQLPSGkl08MRIpQWQjlReK4P8
         8x2/CXBwbe0rN/FV4c0WmDwtS38M2Ub6GE1JI6yQDoH1TX7SgTPwMnEP5617q8it6mBb
         C78g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l2f8wSd2cFUSrpRoYeQ6oFo0IF2ypfibcU91DvCPZco=;
        b=D4pWSl9OPf+WkanYxhv1PYIrX58GX8LgtCQiiLQhcJARwkw4a+NVw0HZGNa3x0Urty
         3pIN0fGpcupsgdDYVG0tuUmZlZNRFiKtudoIeF/cdwyj8QX8brSimlPpjILN+b2M/H+B
         6t5P1hu2SihY3GjrbMtffJkSgEG/i5EEygKWsoCeZJpePOFvU4NKJrXtPXsbtP0ywQiK
         /R91op/9d7/Q9UIOkAlFUwMBAPwy5Oqu6G0mCzX+PPhQOOd3MoNS+B87YZDfdk9Gjhrn
         3UCf4dVrVGXFGJnsAApAI2pcqx6j5S9bkltW8YKniq3cQ29aE91hWt919b9M/EVzZp4Q
         6Vyg==
X-Gm-Message-State: AOAM532pjttE5/JFmK4Dg63fmB/fv4xrgEPQ8xcZOvRwolphdaL3lKb9
        5gGS/YN5sCCJ6C01cUmobKao8a95zWCWs2aCRDA=
X-Google-Smtp-Source: ABdhPJzwhFCcOiRVEyJmDZY6cZkJypwCnf5hzFzo6BMWKhnD0MY2PWKu9ajB0VhtCuIfg9+R9lgD3g==
X-Received: by 2002:a17:907:1c21:: with SMTP id nc33mr27486888ejc.436.1626714603306;
        Mon, 19 Jul 2021 10:10:03 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id nc29sm6073896ejc.10.2021.07.19.10.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 10:10:02 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 07/15] net: bridge: multicast: add helper to get port mcast context from port group
Date:   Mon, 19 Jul 2021 20:06:29 +0300
Message-Id: <20210719170637.435541-8-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210719170637.435541-1-razor@blackwall.org>
References: <20210719170637.435541-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add br_multicast_pg_to_port_ctx() which returns the proper port multicast
context from either port or vlan based on bridge option and vlan flags.
As the comment inside explains the locking is a bit tricky, we rely on
the fact that BR_VLFLAG_MCAST_ENABLED requires multicast_lock to change
and we also require it to be held to call that helper. If we find the
vlan under rcu and it still has the flag then we can be sure it will be
alive until we unlock multicast_lock which should be enough.
Note that the context might change from vlan to bridge between different
calls to this helper as the mcast vlan knob requires only rtnl so it should
be used carefully and for read-only/check purposes.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index b71772828b23..353406f2971a 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -192,6 +192,44 @@ struct net_bridge_mdb_entry *br_mdb_get(struct net_bridge_mcast *brmctx,
 	return br_mdb_ip_get_rcu(br, &ip);
 }
 
+/* IMPORTANT: this function must be used only when the contexts cannot be
+ * passed down (e.g. timer) and must be used for read-only purposes because
+ * the vlan snooping option can change, so it can return any context
+ * (non-vlan or vlan). Its initial intended purpose is to read timer values
+ * from the *current* context based on the option. At worst that could lead
+ * to inconsistent timers when the contexts are changed, i.e. src timer
+ * which needs to re-arm with a specific delay taken from the old context
+ */
+static struct net_bridge_mcast_port *
+br_multicast_pg_to_port_ctx(const struct net_bridge_port_group *pg)
+{
+	struct net_bridge_mcast_port *pmctx = &pg->key.port->multicast_ctx;
+	struct net_bridge_vlan *vlan;
+
+	lockdep_assert_held_once(&pg->key.port->br->multicast_lock);
+
+	/* if vlan snooping is disabled use the port's multicast context */
+	if (!pg->key.addr.vid ||
+	    !br_opt_get(pg->key.port->br, BROPT_MCAST_VLAN_SNOOPING_ENABLED))
+		goto out;
+
+	/* locking is tricky here, due to different rules for multicast and
+	 * vlans we need to take rcu to find the vlan and make sure it has
+	 * the BR_VLFLAG_MCAST_ENABLED flag set, it can only change under
+	 * multicast_lock which must be already held here, so the vlan's pmctx
+	 * can safely be used on return
+	 */
+	rcu_read_lock();
+	vlan = br_vlan_find(nbp_vlan_group(pg->key.port), pg->key.addr.vid);
+	if (vlan && !br_multicast_port_ctx_vlan_disabled(&vlan->port_mcast_ctx))
+		pmctx = &vlan->port_mcast_ctx;
+	else
+		pmctx = NULL;
+	rcu_read_unlock();
+out:
+	return pmctx;
+}
+
 static bool br_port_group_equal(struct net_bridge_port_group *p,
 				struct net_bridge_port *port,
 				const unsigned char *src)
-- 
2.31.1

