Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F394E5F8F85
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbiJIWJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbiJIWJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:09:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FB12981A;
        Sun,  9 Oct 2022 15:08:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B1F460CBB;
        Sun,  9 Oct 2022 22:08:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD41C433C1;
        Sun,  9 Oct 2022 22:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353306;
        bh=4I++Kn9fSoZUHIYC6BYNYv/X7IAgLUe/WFzrPJLmnbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vw/x9lID/j16T7UHNsbb+uN/t+aJVql3H9GoownUOY0HZhSgFsWngJFTaYzzgjGpr
         agSMDEumy541OavxYunr1ZdZqelQ701R+8O+8Th5BY8fj2P06bx2vQeQTrSdJwHI3J
         nbxlNuToAgzqGdGUnrB9e9Hr5m/AXg2NNscuPgMYzFBui8oeaDpmQi+21npxBbBqob
         +pxH4hTBve6PDK/53aR1PjGfQufaDIhBAYAD71nFIQfsp0VAv9xM70Y8qET7w9Ah6M
         ygCxrjaWbdtqC5dRdPCAN7AXQnAIc+Fw3MD1uJgKspnxkI3ATpR1BEtHcxqQrvtLKE
         0bOtNDUrUEtdQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 11/77] net: dsa: all DSA masters must be down when changing the tagging protocol
Date:   Sun,  9 Oct 2022 18:06:48 -0400
Message-Id: <20221009220754.1214186-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009220754.1214186-1-sashal@kernel.org>
References: <20221009220754.1214186-1-sashal@kernel.org>
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

[ Upstream commit f41ec1fd1c20e2a4e60a4ab8490b3e63423c0a8a ]

The fact that the tagging protocol is set and queried from the
/sys/class/net/<dsa-master>/dsa/tagging file is a bit of a quirk from
the single CPU port days which isn't aging very well now that DSA can
have more than a single CPU port. This is because the tagging protocol
is a switch property, yet in the presence of multiple CPU ports it can
be queried and set from multiple sysfs files, all of which are handled
by the same implementation.

The current logic ensures that the net device whose sysfs file we're
changing the tagging protocol through must be down. That net device is
the DSA master, and this is fine for single DSA master / CPU port setups.

But exactly because the tagging protocol is per switch [ tree, in fact ]
and not per DSA master, this isn't fine any longer with multiple CPU
ports, and we must iterate through the tree and find all DSA masters,
and make sure that all of them are down.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/dsa2.c     | 10 +++-------
 net/dsa/dsa_priv.h |  1 -
 net/dsa/master.c   |  2 +-
 3 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index cac48a741f27..b2fe62bfe8dd 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1238,7 +1238,6 @@ static int dsa_tree_bind_tag_proto(struct dsa_switch_tree *dst,
  * they would have formed disjoint trees (different "dsa,member" values).
  */
 int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
-			      struct net_device *master,
 			      const struct dsa_device_ops *tag_ops,
 			      const struct dsa_device_ops *old_tag_ops)
 {
@@ -1254,14 +1253,11 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 	 * attempts to change the tagging protocol. If we ever lift the IFF_UP
 	 * restriction, there needs to be another mutex which serializes this.
 	 */
-	if (master->flags & IFF_UP)
-		goto out_unlock;
-
 	list_for_each_entry(dp, &dst->ports, list) {
-		if (!dsa_port_is_user(dp))
-			continue;
+		if (dsa_port_is_cpu(dp) && (dp->master->flags & IFF_UP))
+			goto out_unlock;
 
-		if (dp->slave->flags & IFF_UP)
+		if (dsa_port_is_user(dp) && (dp->slave->flags & IFF_UP))
 			goto out_unlock;
 	}
 
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index d9722e49864b..cc1cc866dc42 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -545,7 +545,6 @@ struct dsa_lag *dsa_tree_lag_find(struct dsa_switch_tree *dst,
 int dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v);
 int dsa_broadcast(unsigned long e, void *v);
 int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
-			      struct net_device *master,
 			      const struct dsa_device_ops *tag_ops,
 			      const struct dsa_device_ops *old_tag_ops);
 void dsa_tree_master_admin_state_change(struct dsa_switch_tree *dst,
diff --git a/net/dsa/master.c b/net/dsa/master.c
index 2851e44c4cf0..32c0a00a8b92 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -307,7 +307,7 @@ static ssize_t tagging_store(struct device *d, struct device_attribute *attr,
 		 */
 		goto out;
 
-	err = dsa_tree_change_tag_proto(cpu_dp->ds->dst, dev, new_tag_ops,
+	err = dsa_tree_change_tag_proto(cpu_dp->ds->dst, new_tag_ops,
 					old_tag_ops);
 	if (err) {
 		/* On failure the old tagger is restored, so we don't need the
-- 
2.35.1

