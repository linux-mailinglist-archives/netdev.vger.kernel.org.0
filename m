Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 426CB4D8834
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 16:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237106AbiCNPfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 11:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234713AbiCNPf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 11:35:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 896781FCC5
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 08:34:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29DE5B80D40
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 15:34:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB6BC340E9;
        Mon, 14 Mar 2022 15:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647272054;
        bh=tp/YcGmz44ekqb1I6fhvjuQlWNXlordIVv8xDUZDqbA=;
        h=From:To:Cc:Subject:Date:From;
        b=QxBf6aseTBokxbuHHhaI2WthaN4GTcWQjU1dFbuPvMnuLpyFAu1LrWLE6FeTlza10
         4vDTY7yBoDUww9shmvjqKeHrIZiKQZ+M34OBQFBHBb4/OnnjVCaHfCtA+QL2pqdhji
         zFa8QJNCHmmu3OtPS47/A/N+KeeszX4hXqpPKhYOFwHffWqtIM2nYwoiHsDrNVSluG
         eieWlj4CMzthGlKYncJyJfdL+ovZOi1HVp/rFsx+73goE8YaQXA1zj+csBoOCkLe1P
         Vq0o8Kl2kHGwmPntbIvWbcc3A1Q2HwbDW5zHQLjwp4Kdpofyq83dGF2PUUjt3eq0P+
         WUyaHSQJ5wQXw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        =?UTF-8?q?Jan=20B=C4=9Bt=C3=ADk?= <hagrid@svine.us>
Subject: [PATCH net] net: dsa: fix panic when port leaves a bridge
Date:   Mon, 14 Mar 2022 16:34:10 +0100
Message-Id: <20220314153410.31744-1-kabel@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a data structure breaking / NULL-pointer dereference in
dsa_switch_bridge_leave().

When a DSA port leaves a bridge, dsa_switch_bridge_leave() is called by
notifier for every DSA switch that contains ports that are in the
bridge.

But the part of the code that unsets vlan_filtering expects that the ds
argument refers to the same switch that contains the leaving port.

This leads to various problems, including a NULL pointer dereference,
which was observed on Turris MOX with 2 switches (one with 8 user ports
and another with 4 user ports).

Thus we need to move the vlan_filtering change code to the non-crosschip
branch.

Fixes: d371b7c92d190 ("net: dsa: Unset vlan_filtering when ports leave the bridge")
Reported-by: Jan Bětík <hagrid@svine.us>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 net/dsa/switch.c | 97 +++++++++++++++++++++++++++---------------------
 1 file changed, 55 insertions(+), 42 deletions(-)

diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index e3c7d2627a61..38afb1e8fcb7 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -123,9 +123,61 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 	struct dsa_port *dp;
 	int err;
 
-	if (dst->index == info->tree_index && ds->index == info->sw_index &&
-	    ds->ops->port_bridge_leave)
-		ds->ops->port_bridge_leave(ds, info->port, info->bridge);
+	if (dst->index == info->tree_index && ds->index == info->sw_index) {
+		if (ds->ops->port_bridge_leave)
+			ds->ops->port_bridge_leave(ds, info->port,
+						   info->bridge);
+
+		/* This function is called by the notifier for every DSA switch
+		 * that has ports in the bridge we are leaving, but vlan
+		 * filtering on the port should be changed only once. Since the
+		 * code expects that ds is the switch containing the leaving
+		 * port, the following code must not be called in the crosschip
+		 * branch, only here.
+		 */
+
+		if (ds->needs_standalone_vlan_filtering &&
+		    !br_vlan_enabled(info->bridge.dev)) {
+			change_vlan_filtering = true;
+			vlan_filtering = true;
+		} else if (!ds->needs_standalone_vlan_filtering &&
+			   br_vlan_enabled(info->bridge.dev)) {
+			change_vlan_filtering = true;
+			vlan_filtering = false;
+		}
+
+		/* If the bridge was vlan_filtering, the bridge core doesn't
+		 * trigger an event for changing vlan_filtering setting upon
+		 * slave ports leaving it. That is a good thing, because that
+		 * lets us handle it and also handle the case where the switch's
+		 * vlan_filtering setting is global (not per port). When that
+		 * happens, the correct moment to trigger the vlan_filtering
+		 * callback is only when the last port leaves the last
+		 * VLAN-aware bridge.
+		 */
+		if (change_vlan_filtering && ds->vlan_filtering_is_global) {
+			dsa_switch_for_each_port(dp, ds) {
+				struct net_device *br =
+					dsa_port_bridge_dev_get(dp);
+
+				if (br && br_vlan_enabled(br)) {
+					change_vlan_filtering = false;
+					break;
+				}
+			}
+		}
+
+		if (change_vlan_filtering) {
+			err = dsa_port_vlan_filtering(dsa_to_port(ds,
+								  info->port),
+						      vlan_filtering, &extack);
+			if (extack._msg)
+				dev_err(ds->dev, "port %d: %s\n", info->port,
+					extack._msg);
+			if (err && err != -EOPNOTSUPP)
+				return err;
+		}
+	}
 
 	if ((dst->index != info->tree_index || ds->index != info->sw_index) &&
 	    ds->ops->crosschip_bridge_leave)
@@ -133,45 +185,6 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 						info->sw_index, info->port,
 						info->bridge);
 
-	if (ds->needs_standalone_vlan_filtering &&
-	    !br_vlan_enabled(info->bridge.dev)) {
-		change_vlan_filtering = true;
-		vlan_filtering = true;
-	} else if (!ds->needs_standalone_vlan_filtering &&
-		   br_vlan_enabled(info->bridge.dev)) {
-		change_vlan_filtering = true;
-		vlan_filtering = false;
-	}
-
-	/* If the bridge was vlan_filtering, the bridge core doesn't trigger an
-	 * event for changing vlan_filtering setting upon slave ports leaving
-	 * it. That is a good thing, because that lets us handle it and also
-	 * handle the case where the switch's vlan_filtering setting is global
-	 * (not per port). When that happens, the correct moment to trigger the
-	 * vlan_filtering callback is only when the last port leaves the last
-	 * VLAN-aware bridge.
-	 */
-	if (change_vlan_filtering && ds->vlan_filtering_is_global) {
-		dsa_switch_for_each_port(dp, ds) {
-			struct net_device *br = dsa_port_bridge_dev_get(dp);
-
-			if (br && br_vlan_enabled(br)) {
-				change_vlan_filtering = false;
-				break;
-			}
-		}
-	}
-
-	if (change_vlan_filtering) {
-		err = dsa_port_vlan_filtering(dsa_to_port(ds, info->port),
-					      vlan_filtering, &extack);
-		if (extack._msg)
-			dev_err(ds->dev, "port %d: %s\n", info->port,
-				extack._msg);
-		if (err && err != -EOPNOTSUPP)
-			return err;
-	}
-
 	return dsa_tag_8021q_bridge_leave(ds, info);
 }
 
-- 
2.34.1

