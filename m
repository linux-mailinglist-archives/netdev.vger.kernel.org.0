Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D313650198
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 17:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbiLRQeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 11:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbiLRQdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 11:33:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F89B4A6;
        Sun, 18 Dec 2022 08:12:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 855B0B80BD1;
        Sun, 18 Dec 2022 16:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1573EC433EF;
        Sun, 18 Dec 2022 16:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379926;
        bh=LmK9N7gcHgEMnuX6DPcPrj7//jkR+jXfDOYYregk3zE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gvGW2hchHlUX13Yg5kF0WbZRtdYr+GyJkwBbOi4z5HS6CwI760zwSrrQcpHL4HCpf
         +cqoxidF8oG1Z6d0t+sypRMjidv+8fRlKCOi9nT2Y1zU+cui+nSfw2tzzSg6xj2GhN
         KOXhvt0lNSsblQJSeMDC+wLAykWOWr409xCGtPvGbLol5+yn72QI9LYyBMgmKrjl0d
         u6wVhYmDGcl3Tg5KEP6rmt7LCtFlliRBsdT0GU1tGy4lbcv5WN30BUQ2fORzhvag4o
         enOYzaHAbaDqxMCvaabJZu0Ou/X5YLL7cNXUp6UgjbTmMlKqY9jtUJVWnd6XvNyAMi
         +hIYm+znw4kAg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 60/73] net: dpaa2: publish MAC stringset to ethtool -S even if MAC is missing
Date:   Sun, 18 Dec 2022 11:07:28 -0500
Message-Id: <20221218160741.927862-60-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160741.927862-1-sashal@kernel.org>
References: <20221218160741.927862-1-sashal@kernel.org>
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
index eea7d7a07c00..8381cbdb9461 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -186,7 +186,6 @@ static int dpaa2_eth_set_pauseparam(struct net_device *net_dev,
 static void dpaa2_eth_get_strings(struct net_device *netdev, u32 stringset,
 				  u8 *data)
 {
-	struct dpaa2_eth_priv *priv = netdev_priv(netdev);
 	u8 *p = data;
 	int i;
 
@@ -200,22 +199,17 @@ static void dpaa2_eth_get_strings(struct net_device *netdev, u32 stringset,
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

