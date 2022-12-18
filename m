Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4445D650243
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 17:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbiLRQo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 11:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbiLRQo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 11:44:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F7EDE5;
        Sun, 18 Dec 2022 08:15:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 452E260DC9;
        Sun, 18 Dec 2022 16:15:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92318C433D2;
        Sun, 18 Dec 2022 16:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671380144;
        bh=/lVAV+9Yg62+MEiBQNhOz3uYi8L2ODHMHpSHJe7i3sI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pC1bsqLUfQh9Y/tjV2oRYMYnxclwNseqU0CN+w6TtgXqWZ6X19txvLInlzY8ZAYDl
         Ro2XTzCSq+Sky29Oh1oNW2UMMyZ5kiJcnqKYkvjrHM3ZdsX9/Dq9tyqzHwIaXOMi/G
         1tr0k1P1Sa5dKIQuGjoG8xvlBzwziqybLeLgp8YIcLeAhUbZu6PYkeMz8j758ErI7R
         STco1FWaoXGvabY+reUmm7IquBqs1r2W95yNdJwlKhXayFhC6sNJ6AYgHLYKIsQIky
         zDlwQwUJvvBL8cTyewFk7ffPVXCuL9Z1P+A0ZNbj6ZoK0jWn5doLlMaBpCwChdacEh
         ud7DZimrsnuJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 41/46] net: dpaa2: publish MAC stringset to ethtool -S even if MAC is missing
Date:   Sun, 18 Dec 2022 11:12:39 -0500
Message-Id: <20221218161244.930785-41-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218161244.930785-1-sashal@kernel.org>
References: <20221218161244.930785-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 29811d6e19d795efcf26644b66c4152abbac35a6 ]

DPNIs and DPSW objects can connect and disconnect at runtime from DPMAC
objects on the same fsl-mc bus. The DPMAC object also holds "ethtool -S"
unstructured counters. Those counters are only shown for the entity
owning the netdev (DPNI, DPSW) if it's connected to a DPMAC.

The ethtool stringset code path is split into multiple callbacks, but
currently, connecting and disconnecting the DPMAC takes the rtnl_lock().
This blocks the entire ethtool code path from running, see
ethnl_default_doit() -> rtnl_lock() -> ops->prepare_data() ->
strset_prepare_data().

This is going to be a problem if we are going to no longer require
rtnl_lock() when connecting/disconnecting the DPMAC, because the DPMAC
could appear between ops->get_sset_count() and ops->get_strings().
If it appears out of the blue, we will provide a stringset into an array
that was dimensioned thinking the DPMAC wouldn't be there => array
accessed out of bounds.

There isn't really a good way to work around that, and I don't want to
put too much pressure on the ethtool framework by playing locking games.
Just make the DPMAC counters be always available. They'll be zeroes if
the DPNI or DPSW isn't connected to a DPMAC.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Tested-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c | 12 +++---------
 .../ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c  | 11 ++---------
 2 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index 2da5f881f630..714a0a058faf 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -184,7 +184,6 @@ static int dpaa2_eth_set_pauseparam(struct net_device *net_dev,
 static void dpaa2_eth_get_strings(struct net_device *netdev, u32 stringset,
 				  u8 *data)
 {
-	struct dpaa2_eth_priv *priv = netdev_priv(netdev);
 	u8 *p = data;
 	int i;
 
@@ -198,22 +197,17 @@ static void dpaa2_eth_get_strings(struct net_device *netdev, u32 stringset,
 			strscpy(p, dpaa2_ethtool_extras[i], ETH_GSTRING_LEN);
 			p += ETH_GSTRING_LEN;
 		}
-		if (dpaa2_eth_has_mac(priv))
-			dpaa2_mac_get_strings(p);
+		dpaa2_mac_get_strings(p);
 		break;
 	}
 }
 
 static int dpaa2_eth_get_sset_count(struct net_device *net_dev, int sset)
 {
-	int num_ss_stats = DPAA2_ETH_NUM_STATS + DPAA2_ETH_NUM_EXTRA_STATS;
-	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
-
 	switch (sset) {
 	case ETH_SS_STATS: /* ethtool_get_stats(), ethtool_get_drvinfo() */
-		if (dpaa2_eth_has_mac(priv))
-			num_ss_stats += dpaa2_mac_get_sset_count();
-		return num_ss_stats;
+		return DPAA2_ETH_NUM_STATS + DPAA2_ETH_NUM_EXTRA_STATS +
+		       dpaa2_mac_get_sset_count();
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c
index 720c9230cab5..40ee57ef55be 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c
@@ -145,14 +145,9 @@ dpaa2_switch_set_link_ksettings(struct net_device *netdev,
 static int
 dpaa2_switch_ethtool_get_sset_count(struct net_device *netdev, int sset)
 {
-	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
-	int num_ss_stats = DPAA2_SWITCH_NUM_COUNTERS;
-
 	switch (sset) {
 	case ETH_SS_STATS:
-		if (port_priv->mac)
-			num_ss_stats += dpaa2_mac_get_sset_count();
-		return num_ss_stats;
+		return DPAA2_SWITCH_NUM_COUNTERS + dpaa2_mac_get_sset_count();
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -161,7 +156,6 @@ dpaa2_switch_ethtool_get_sset_count(struct net_device *netdev, int sset)
 static void dpaa2_switch_ethtool_get_strings(struct net_device *netdev,
 					     u32 stringset, u8 *data)
 {
-	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
 	u8 *p = data;
 	int i;
 
@@ -172,8 +166,7 @@ static void dpaa2_switch_ethtool_get_strings(struct net_device *netdev,
 			       ETH_GSTRING_LEN);
 			p += ETH_GSTRING_LEN;
 		}
-		if (port_priv->mac)
-			dpaa2_mac_get_strings(p);
+		dpaa2_mac_get_strings(p);
 		break;
 	}
 }
-- 
2.35.1

