Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1784919C5
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344243AbiARC4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:56:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50968 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245410AbiARCoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:44:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11DC9B81262;
        Tue, 18 Jan 2022 02:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967FBC36AF2;
        Tue, 18 Jan 2022 02:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473855;
        bh=qAB+bI0QXUYlCwzmwYWy4GNslrW5yP5RYPjDg882p6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vI9c+tQYj8ctOSSxXNbVjpAkwZuWq9shbE7yGBPtrKoJHKxNV33C7UJ4Sjh4bSThK
         n2IHIrDe80Ak+ZoRRRgpraK08xlnCFq7z5qQfe3Bxs09NB5TOkq3XpVm1U6Y8owSZC
         l4diTPz4dMp8CfKyY8nqOoL4XR0iAYKkpQ0m2cTuDZ/ILv0f5uNF7IdqGgJoA6tnbV
         pLMC8gvZT/Ot94tplIl1XASZ3EfXWwbwtzmRRMOXGzRvtbWbNsBc4uQw0jn/XnFYkO
         fQ79fQM8NBcrI1uqNqDeGfpqumb+X60YZUgadV2L8AYq+Rr2raeqJMc+7OeMgh+OM+
         4ydqSLbxc7jwg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 108/116] net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown}
Date:   Mon, 17 Jan 2022 21:39:59 -0500
Message-Id: <20220118024007.1950576-108-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit c146f9bc195a9dc3ad7fd000a14540e7c9df952d ]

DSA needs to simulate master tracking events when a binding is first
with a DSA master established and torn down, in order to give drivers
the simplifying guarantee that ->master_state_change calls are made
only when the master's readiness state to pass traffic changes.
master_state_change() provide a operational bool that DSA driver can use
to understand if DSA master is operational or not.
To avoid races, we need to block the reception of
NETDEV_UP/NETDEV_CHANGE/NETDEV_GOING_DOWN events in the netdev notifier
chain while we are changing the master's dev->dsa_ptr (this changes what
netdev_uses_dsa(dev) reports).

The dsa_master_setup() and dsa_master_teardown() functions optionally
require the rtnl_mutex to be held, if the tagger needs the master to be
promiscuous, these functions call dev_set_promiscuity(). Move the
rtnl_lock() from that function and make it top-level.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/dsa2.c   | 8 ++++++++
 net/dsa/master.c | 4 ++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 71c8ef7d40870..d7cd7004a8e5d 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -577,6 +577,8 @@ static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 	struct dsa_port *dp;
 	int err;
 
+	rtnl_lock();
+
 	list_for_each_entry(dp, &dst->ports, list) {
 		if (dsa_port_is_cpu(dp)) {
 			err = dsa_master_setup(dp->master, dp);
@@ -585,6 +587,8 @@ static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 		}
 	}
 
+	rtnl_unlock();
+
 	return 0;
 }
 
@@ -592,9 +596,13 @@ static void dsa_tree_teardown_master(struct dsa_switch_tree *dst)
 {
 	struct dsa_port *dp;
 
+	rtnl_lock();
+
 	list_for_each_entry(dp, &dst->ports, list)
 		if (dsa_port_is_cpu(dp))
 			dsa_master_teardown(dp->master);
+
+	rtnl_unlock();
 }
 
 static int dsa_tree_setup(struct dsa_switch_tree *dst)
diff --git a/net/dsa/master.c b/net/dsa/master.c
index 45bd627b4e7bc..f9bc4233ca946 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -267,9 +267,9 @@ static void dsa_master_set_promiscuity(struct net_device *dev, int inc)
 	if (!ops->promisc_on_master)
 		return;
 
-	rtnl_lock();
+	ASSERT_RTNL();
+
 	dev_set_promiscuity(dev, inc);
-	rtnl_unlock();
 }
 
 static ssize_t tagging_show(struct device *d, struct device_attribute *attr,
-- 
2.34.1

