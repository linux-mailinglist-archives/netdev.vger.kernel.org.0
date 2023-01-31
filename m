Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE32682DF4
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 14:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbjAaNcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 08:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbjAaNcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 08:32:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2A54AA76
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 05:32:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85F84B81C9B
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 13:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546D7C4339C;
        Tue, 31 Jan 2023 13:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675171938;
        bh=JF+ktoQfs4f/a3cCO0S0At1kMyQdPLkrYW9hhNHrSsA=;
        h=From:To:Cc:Subject:Date:From;
        b=qIjOb2BOwK3sYi7G40kUm8i/P3EphKFlxIMfdD9UO0uMibSgJIhIkatQe+oWhlm7h
         r/8RWhnt2KXFtMZr3r0dSyfoemdkvDNJg/EwQePWTwkz1oHfW7jq206h44O3PJWDdq
         p99kNHmkUl9P32JRNT8En0TJk3AEo8QPKIGwmlw3cpmTk7Ock756NIuMMMj4PbZeIG
         lGcSooNzh+OFI1J9xErVaEulo6dWuH5o7lQ3ff7FXqlK5dQA17/3V8dL0kzfGUloFP
         uIxGspp18yShVdLZcl5hvOu6Hrne7YS5/xwKMvTfY9Kf9utoBN11FU1V4zGOfUJCOu
         ts4/U22+q9oQw==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        bridge@lists.linux-foundation.org,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Nikolay Aleksandrov <razor@blackwall.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next v3] netlink: provide an ability to set default extack message
Date:   Tue, 31 Jan 2023 15:31:57 +0200
Message-Id: <6993fac557a40a1973dfa0095107c3d03d40bec1.1675171790.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

In netdev common pattern, extack pointer is forwarded to the drivers
to be filled with error message. However, the caller can easily
overwrite the filled message.

Instead of adding multiple "if (!extack->_msg)" checks before any
NL_SET_ERR_MSG() call, which appears after call to the driver, let's
add new macro to common code.

[1] https://lore.kernel.org/all/Y9Irgrgf3uxOjwUm@unreal
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
Changelog:
v3:
 * Changed From field
v2: https://lore.kernel.org/all/c1a88f471a8aa6d780dde690e76b73ba15618b6d.1675010984.git.leon@kernel.org
 * Removed () brackets around msg to fix compilation error.
v1: https://lore.kernel.org/all/d4843760219f20367c27472f084bd8aa729cf321.1674995155.git.leon@kernel.org
 * Added special *_WEAK() macro instead of embedding same check in
   NL_SET_ERR_MSG_MOD/NL_SET_ERR_MSG_FMT.
 * Reuse same macro for XFRM code which triggered this patch.
v0: https://lore.kernel.org/all/2919eb55e2e9b92265a3ba600afc8137a901ae5f.1674760340.git.leon@kernel.org
---
 include/linux/netlink.h   | 10 ++++++++++
 net/bridge/br_switchdev.c | 10 ++++------
 net/dsa/master.c          |  4 +---
 net/dsa/slave.c           |  4 +---
 net/xfrm/xfrm_device.c    |  5 ++++-
 5 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index fa4d86da0ec7..c43ac7690eca 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -130,6 +130,16 @@ struct netlink_ext_ack {
 #define NL_SET_ERR_MSG_FMT_MOD(extack, fmt, args...)	\
 	NL_SET_ERR_MSG_FMT((extack), KBUILD_MODNAME ": " fmt, ##args)
 
+#define NL_SET_ERR_MSG_WEAK(extack, msg) do {		\
+	if ((extack) && !(extack)->_msg)		\
+		NL_SET_ERR_MSG((extack), msg);		\
+} while (0)
+
+#define NL_SET_ERR_MSG_WEAK_MOD(extack, msg) do {	\
+	if ((extack) && !(extack)->_msg)		\
+		NL_SET_ERR_MSG_MOD((extack), msg);	\
+} while (0)
+
 #define NL_SET_BAD_ATTR_POLICY(extack, attr, pol) do {	\
 	if ((extack)) {					\
 		(extack)->bad_attr = (attr);		\
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 7eb6fd5bb917..de18e9c1d7a7 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -104,9 +104,8 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 		return 0;
 
 	if (err) {
-		if (extack && !extack->_msg)
-			NL_SET_ERR_MSG_MOD(extack,
-					   "bridge flag offload is not supported");
+		NL_SET_ERR_MSG_WEAK_MOD(extack,
+					"bridge flag offload is not supported");
 		return -EOPNOTSUPP;
 	}
 
@@ -115,9 +114,8 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 
 	err = switchdev_port_attr_set(p->dev, &attr, extack);
 	if (err) {
-		if (extack && !extack->_msg)
-			NL_SET_ERR_MSG_MOD(extack,
-					   "error setting offload flag on port");
+		NL_SET_ERR_MSG_WEAK_MOD(extack,
+					"error setting offload flag on port");
 		return err;
 	}
 
diff --git a/net/dsa/master.c b/net/dsa/master.c
index 26d90140d271..1507b8cdb360 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -464,9 +464,7 @@ int dsa_master_lag_setup(struct net_device *lag_dev, struct dsa_port *cpu_dp,
 
 	err = dsa_port_lag_join(cpu_dp, lag_dev, uinfo, extack);
 	if (err) {
-		if (extack && !extack->_msg)
-			NL_SET_ERR_MSG_MOD(extack,
-					   "CPU port failed to join LAG");
+		NL_SET_ERR_MSG_WEAK_MOD(extack, "CPU port failed to join LAG");
 		goto out_master_teardown;
 	}
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 6014ac3aad34..26c458f50ac6 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2692,9 +2692,7 @@ static int dsa_slave_changeupper(struct net_device *dev,
 			if (!err)
 				dsa_bridge_mtu_normalization(dp);
 			if (err == -EOPNOTSUPP) {
-				if (extack && !extack->_msg)
-					NL_SET_ERR_MSG_MOD(extack,
-							   "Offloading not supported");
+				NL_SET_ERR_MSG_WEAK_MOD(extack, "Offloading not supported");
 				err = 0;
 			}
 			err = notifier_from_errno(err);
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 562b9d951598..95f1436bf6a2 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -325,8 +325,10 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 		 * authors to do not return -EOPNOTSUPP in packet offload mode.
 		 */
 		WARN_ON(err == -EOPNOTSUPP && is_packet_offload);
-		if (err != -EOPNOTSUPP || is_packet_offload)
+		if (err != -EOPNOTSUPP || is_packet_offload) {
+			NL_SET_ERR_MSG_WEAK(extack, "Device failed to offload this state");
 			return err;
+		}
 	}
 
 	return 0;
@@ -388,6 +390,7 @@ int xfrm_dev_policy_add(struct net *net, struct xfrm_policy *xp,
 		xdo->type = XFRM_DEV_OFFLOAD_UNSPECIFIED;
 		xdo->dir = 0;
 		netdev_put(dev, &xdo->dev_tracker);
+		NL_SET_ERR_MSG_WEAK(extack, "Device failed to offload this policy");
 		return err;
 	}
 
-- 
2.39.1

