Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77421C92D4
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 16:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbgEGO7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 10:59:20 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:58378 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725985AbgEGO7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 10:59:19 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id DB2AE600C5;
        Thu,  7 May 2020 14:59:18 +0000 (UTC)
Received: from us4-mdac16-64.ut7.mdlocal (unknown [10.7.66.63])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D56F78009E;
        Thu,  7 May 2020 14:59:18 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.35])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 545DC28006D;
        Thu,  7 May 2020 14:59:18 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D3B41480081;
        Thu,  7 May 2020 14:59:17 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 7 May 2020
 15:59:11 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [RFC PATCH net] net: flow_offload: simplify hw stats check handling
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <netfilter-devel@vger.kernel.org>,
        <jiri@resnulli.us>, <kuba@kernel.org>, <pablo@netfilter.org>
Message-ID: <49176c41-3696-86d9-f0eb-c20207cd6d23@solarflare.com>
Date:   Thu, 7 May 2020 15:59:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25404.003
X-TM-AS-Result: No-2.976100-8.000000-10
X-TMASE-MatchedRID: dKAjOXhtwHSwwAVMmrrBx6iUivh0j2PvBGvINcfHqhcJeMOJX8c9nKPS
        ksP0QEd515zUG9mZSpKikrdCCR3aDagZeORpCZ4f8Kg68su2wyFI9k0SuFpa9dMgOgDPfBRBcij
        MZrr2iZ2t2gtuWr1Lmtr+D80ZNbcy6TPkXiXihOz1MIl9eZdLb08kgvk2XctFkQ0JIWWubu9pJ8
        o8sZYe5hn6aeahyB8TqUFzXY3N6oHXba5cfJx+cyqwx8x+s5lFfS0Ip2eEHny+qryzYw2E8Jkw8
        KdMzN86KrauXd3MZDU/O6OLhVHRUf4UnspjRm/FKEEv7EQFk0oIHSPjW45l3XBsf5ScnicyWwaH
        oHXhc+JKQKRUDOOXwweiv8Uh0szuTsFoXEtor7BdcFXkHCaP10ODDY5/BuEsoxrk6Q2mIeSJ+wv
        7oJjhGWXfFD5fdmZR
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.976100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25404.003
X-MDID: 1588863558-XPRAzVs8QnR6
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make FLOW_ACTION_HW_STATS_DONT_CARE be all bits, rather than none, so that
 drivers and __flow_action_hw_stats_check can use simple bitwise checks.

In mlxsw we check for DISABLED first, because we'd rather save the counter
 resources in the DONT_CARE case.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
Compile tested only.

 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c | 8 ++++----
 include/net/flow_offload.h                            | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 890b078851c9..1f0caeae24e1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -30,14 +30,14 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 		return -EOPNOTSUPP;
 
 	act = flow_action_first_entry_get(flow_action);
-	if (act->hw_stats == FLOW_ACTION_HW_STATS_ANY ||
-	    act->hw_stats == FLOW_ACTION_HW_STATS_IMMEDIATE) {
+	if (act->hw_stats & FLOW_ACTION_HW_STATS_DISABLED) {
+		/* Nothing to do */
+	} else if (act->hw_stats & FLOW_ACTION_HW_STATS_IMMEDIATE) {
 		/* Count action is inserted first */
 		err = mlxsw_sp_acl_rulei_act_count(mlxsw_sp, rulei, extack);
 		if (err)
 			return err;
-	} else if (act->hw_stats != FLOW_ACTION_HW_STATS_DISABLED &&
-		   act->hw_stats != FLOW_ACTION_HW_STATS_DONT_CARE) {
+	} else {
 		NL_SET_ERR_MSG_MOD(extack, "Unsupported action HW stats type");
 		return -EOPNOTSUPP;
 	}
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index efc8350b42fb..203dd54a095a 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -167,10 +167,11 @@ enum flow_action_hw_stats_bit {
 	FLOW_ACTION_HW_STATS_IMMEDIATE_BIT,
 	FLOW_ACTION_HW_STATS_DELAYED_BIT,
 	FLOW_ACTION_HW_STATS_DISABLED_BIT,
+
+	FLOW_ACTION_HW_STATS_NUM_BITS
 };
 
 enum flow_action_hw_stats {
-	FLOW_ACTION_HW_STATS_DONT_CARE = 0,
 	FLOW_ACTION_HW_STATS_IMMEDIATE =
 		BIT(FLOW_ACTION_HW_STATS_IMMEDIATE_BIT),
 	FLOW_ACTION_HW_STATS_DELAYED = BIT(FLOW_ACTION_HW_STATS_DELAYED_BIT),
@@ -178,6 +179,7 @@ enum flow_action_hw_stats {
 				   FLOW_ACTION_HW_STATS_DELAYED,
 	FLOW_ACTION_HW_STATS_DISABLED =
 		BIT(FLOW_ACTION_HW_STATS_DISABLED_BIT),
+	FLOW_ACTION_HW_STATS_DONT_CARE = BIT(FLOW_ACTION_HW_STATS_NUM_BITS) - 1,
 };
 
 typedef void (*action_destr)(void *priv);
@@ -330,11 +332,9 @@ __flow_action_hw_stats_check(const struct flow_action *action,
 		return false;
 
 	action_entry = flow_action_first_entry_get(action);
-	if (action_entry->hw_stats == FLOW_ACTION_HW_STATS_DONT_CARE)
-		return true;
 
 	if (!check_allow_bit &&
-	    action_entry->hw_stats != FLOW_ACTION_HW_STATS_ANY) {
+	    ~action_entry->hw_stats & FLOW_ACTION_HW_STATS_ANY) {
 		NL_SET_ERR_MSG_MOD(extack, "Driver supports only default HW stats type \"any\"");
 		return false;
 	} else if (check_allow_bit &&
