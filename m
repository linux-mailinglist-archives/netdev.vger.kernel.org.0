Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77811D9D68
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 19:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729219AbgESRCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 13:02:30 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:34182 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729001AbgESRC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 13:02:29 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 349FE600A4;
        Tue, 19 May 2020 17:02:29 +0000 (UTC)
Received: from us4-mdac16-30.ut7.mdlocal (unknown [10.7.66.140])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 32D13800B4;
        Tue, 19 May 2020 17:02:29 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.36])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 99F0980071;
        Tue, 19 May 2020 17:02:25 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E7F4DB40090;
        Tue, 19 May 2020 17:02:24 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 19 May
 2020 18:02:06 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next v2] net: flow_offload: simplify hw stats check
 handling
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jiri@resnulli.us>, <kuba@kernel.org>, <pablo@netfilter.org>
Message-ID: <cf0d731d-cb34-accd-ff40-6be013dd9972@solarflare.com>
Date:   Tue, 19 May 2020 18:02:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25428.003
X-TM-AS-Result: No-3.041700-8.000000-10
X-TMASE-MatchedRID: lZQXsOY9JGOwwAVMmrrBx6iUivh0j2PvBGvINcfHqhdsMPuLZB/IR2pA
        q14Ss3bZZOrVTSi4NwUSGgB6fYnFbKpEIvDEr24EolVO7uyOCDVjRBL1FY388SNGK7UC7ElM2Zr
        OvK69hMu6QeoIbk63dvffbeF2tNWl+nZRZZD696n1P43ozrarBbCsy0J50v8cBph69XjMbdlAHO
        g8qEtqyI+pAn19BHXOoQ9mxrHXOW16EGW3t8W0t/UwiX15l0tvTySC+TZdy0WRDQkhZa5u72kny
        jyxlh7mGfpp5qHIHxOpQXNdjc3qgddtrlx8nH5zKrDHzH6zmUV9LQinZ4QefL6qvLNjDYTwmTDw
        p0zM3zoqtq5d3cxkNZluYBobWQBobYb+UJz/2yztfgn0snuiTWtIxaFp+KDS3cwy3maEJ9gCZpy
        wXHWsmzw5IorkOcLWXvGrNOVyi2UzcYecw200GDhrnJz8VOX4Q4MNjn8G4SyjGuTpDaYh5In7C/
        ugmOEZZd8UPl92ZlE=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.041700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25428.003
X-MDID: 1589907746-f3AwEbptEarT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make FLOW_ACTION_HW_STATS_DONT_CARE be all bits, rather than none, so that
 drivers and __flow_action_hw_stats_check can use simple bitwise checks.

Only the kernel's internal API semantics change; the TC uAPI is unaffected.

v2: rebased on net-next, removed RFC tags.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
The discussion on this rather petered out without any consensus, so I'm
 reposting against net-next now that DONT_CARE has appeared there (as it's
 a bit late in the cycle for something so non-critical to go to 'net').

 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c | 8 ++++----
 include/net/flow_offload.h                            | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index b286fe158820..51e1b3930c56 100644
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
index 4001ffb04f0d..d58741fcc984 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -168,10 +168,11 @@ enum flow_action_hw_stats_bit {
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
@@ -179,6 +180,7 @@ enum flow_action_hw_stats {
 				   FLOW_ACTION_HW_STATS_DELAYED,
 	FLOW_ACTION_HW_STATS_DISABLED =
 		BIT(FLOW_ACTION_HW_STATS_DISABLED_BIT),
+	FLOW_ACTION_HW_STATS_DONT_CARE = BIT(FLOW_ACTION_HW_STATS_NUM_BITS) - 1,
 };
 
 typedef void (*action_destr)(void *priv);
@@ -340,11 +342,9 @@ __flow_action_hw_stats_check(const struct flow_action *action,
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
