Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38253602EAE
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 16:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbiJROit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 10:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbiJROir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 10:38:47 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2072.outbound.protection.outlook.com [40.107.244.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFCBBD77E4
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 07:38:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hQen2enV9dwiyXM3JNz/P8YR4anmIGzQWia4X0yLXfIAfjAYSHzczxeWgCbNkuWKH0N/szmJeC1auEWE6xHj+oEW8F+lkJxSPlQTAPja3vRXk2vTlDj6FjNvx7hk6xFxWkaXUNcMQwO1+026wyszWNmKX1v6x4VknUCiucvMhmm9rQF5e+Hgz7e7FhegyRZNmsy3PlvP/SrlD95+nxD45o0A0dh5ac/fnQIofqhABEc+wwHMUlJGkcJuFYY/p6UjrZvXRb+y53tEzM7vpzhNFIgkJBV8vYSvZ10Xxo+84EN7LEE+yT83zEHYI6gjlEUVLOkymSazOAyObJNzfImg4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IN1+DzckYapOyI+NPaAyLDe9yRI66HV6A853PYDkZU4=;
 b=GHuI7XPqn+dsiT5pB/rQ86l7zLTDVku5Cjtax/vL/tiOhIbIOHcP6Hb6jiG356cuAu1xgQtpFZtcYIBw4IHVSnq8FX46skmbAyTq6MAljBCoa999ed4bHN+a0wTc++QJxsqQgvTn3FH509rF11A48nk8BLFI3Iayr+iUrrOw7f75YG6Gmqvticx8xlSQTuartuqsFFb+puXwrXTDo90MW140mkj4gxpwSY6qn29JhQF6yxsAy/AAFfZDP5wvDWY4jos8mYTpPiBHl76FxqlXHpWykMQZIreXJoc5xsNWiPmrhHmKt0uMtF9HkCJ2I6jpdQkoJBESIg/9U5fkqWlTUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IN1+DzckYapOyI+NPaAyLDe9yRI66HV6A853PYDkZU4=;
 b=EIwFsC8afAySLkDCfNPJRX7HNOmds8YUWhpeWlVdgyTArDR3FwuFAy6CIISf5bdvSKncOEruSjcV0SnqOII5tzQ7IbxPhpD2Zca23/+g6uYiu1JdoohiFs+C7lPpTsQsUbWxEL5+CEKNtfIQr8LfqSegtn+2tJ7OMUfArrLHFFw=
Received: from DM6PR01CA0007.prod.exchangelabs.com (2603:10b6:5:296::12) by
 MN2PR12MB4287.namprd12.prod.outlook.com (2603:10b6:208:1dd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Tue, 18 Oct
 2022 14:38:43 +0000
Received: from DM6NAM11FT077.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::17) by DM6PR01CA0007.outlook.office365.com
 (2603:10b6:5:296::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.22 via Frontend
 Transport; Tue, 18 Oct 2022 14:38:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT077.mail.protection.outlook.com (10.13.173.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Tue, 18 Oct 2022 14:38:43 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 18 Oct
 2022 09:38:17 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31 via Frontend
 Transport; Tue, 18 Oct 2022 09:38:15 -0500
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <johannes@sipsolutions.net>, <marcelo.leitner@gmail.com>,
        <jiri@resnulli.us>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v3 net-next 2/3] sfc: use formatted extacks instead of efx_tc_err()
Date:   Tue, 18 Oct 2022 15:37:28 +0100
Message-ID: <a29b7b847cca0fda4dab0ee9109f63218d4c925c.1666102698.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1666102698.git.ecree.xilinx@gmail.com>
References: <cover.1666102698.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT077:EE_|MN2PR12MB4287:EE_
X-MS-Office365-Filtering-Correlation-Id: 520034c8-373d-4da4-4c12-08dab116750d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oELTIHozZm9Xb+Bye+7V1YrJYSy0i2T+ISnbWHWu/O4Sv3CIaHBNcOkjFgaYc+owMVrUmCiGh8E7JXIB+F6nM0g5HnJhYztBZOUDm/0zPqB2fZTh2mnHTTkVU1zrx0pxbtNmKKhE3kXOdaDTjWeYQDkq0ArQVT6eY56A/6cSGmKDD7/osBlj9J+cf7KRA2O+XMnQCYJgC8Ay93vjyI3L2h9LTuNOLGy4jGjpktv/EcWLdIL7Qy39JsbYAHuUp/QwPO+k4uv4sJy2vL62+4txS2rj51L/5umh+M0wluDpafZUEcJfVxaubxNI57m8HxE3YcXxeJLeYrnK5dPx7DQv8creEviXCC7xVHdiDX3wQfFYCPpGh3nPadhhFQkRV6OkXBq1yCS18pMkSOXZoDVRY8hm50gO4UuzJaj86H8YM7SsQXgoRNQbJLXX5FB+D44TmMV7lPdo9e0zshmfYQkaMKJ5r49Q1xcMpY/G14LnIsgcnJte2kF31YHfU9YuR8QdsFAQYAS0wXoRFpmrD+8LG9jIgkkDGWae/RLRKJzd3FHjbkgk9sy19R+H8DkhohmjGpBfafFSN++fgUiSfPZl6/MRikjXJHrRrA2NBT/VKiPlL5IY6NZF6BqEqNanR7YsaoaHU58I8jJ3L7DwIP7ji2MHx3ba5P0GI7ZaAMNU5a0hhHUlLzGZcU3VRwQoVuIMEzgNFFpzPwUGgUPV3Z2Z2hVdukr9pdQI9eT7PUxKfJg77fvfQt1XT4zCzjR+5fnP9dhbh5wXcxiBCchYtF+yYtAMavR75tVrYdzxrh6jrCI=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(136003)(346002)(451199015)(46966006)(40470700004)(36840700001)(36860700001)(82310400005)(81166007)(478600001)(356005)(82740400003)(9686003)(40460700003)(6636002)(36756003)(4326008)(110136005)(54906003)(316002)(186003)(6666004)(70586007)(70206006)(2876002)(47076005)(336012)(8676002)(40480700001)(426003)(5660300002)(2906002)(26005)(8936002)(86362001)(55446002)(7416002)(83380400001)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 14:38:43.6299
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 520034c8-373d-4da4-4c12-08dab116750d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT077.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4287
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Since we can now get a formatted message back to the user with
 NL_SET_ERR_MSG_FMT_MOD(), there's no need for our special logging.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/mae.c |  5 ++--
 drivers/net/ethernet/sfc/tc.c  | 47 +++++++++++++++-------------------
 drivers/net/ethernet/sfc/tc.h  | 18 -------------
 3 files changed, 23 insertions(+), 47 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index 874c765b2465..6f472ea0638a 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -265,9 +265,8 @@ int efx_mae_match_check_caps(struct efx_nic *efx,
 	rc = efx_mae_match_check_cap_typ(supported_fields[MAE_FIELD_INGRESS_PORT],
 					 ingress_port_mask_type);
 	if (rc) {
-		efx_tc_err(efx, "No support for %s mask in field ingress_port\n",
-			   mask_type_name(ingress_port_mask_type));
-		NL_SET_ERR_MSG_MOD(extack, "Unsupported mask type for ingress_port");
+		NL_SET_ERR_MSG_FMT_MOD(extack, "No support for %s mask in field ingress_port",
+				       mask_type_name(ingress_port_mask_type));
 		return rc;
 	}
 	return 0;
diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index 3478860d4023..b21a961eabb1 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -137,17 +137,16 @@ static int efx_tc_flower_parse_match(struct efx_nic *efx,
 		flow_rule_match_control(rule, &fm);
 
 		if (fm.mask->flags) {
-			efx_tc_err(efx, "Unsupported match on control.flags %#x\n",
-				   fm.mask->flags);
-			NL_SET_ERR_MSG_MOD(extack, "Unsupported match on control.flags");
+			NL_SET_ERR_MSG_FMT_MOD(extack, "Unsupported match on control.flags %#x",
+					       fm.mask->flags);
 			return -EOPNOTSUPP;
 		}
 	}
 	if (dissector->used_keys &
 	    ~(BIT(FLOW_DISSECTOR_KEY_CONTROL) |
 	      BIT(FLOW_DISSECTOR_KEY_BASIC))) {
-		efx_tc_err(efx, "Unsupported flower keys %#x\n", dissector->used_keys);
-		NL_SET_ERR_MSG_MOD(extack, "Unsupported flower keys encountered");
+		NL_SET_ERR_MSG_FMT_MOD(extack, "Unsupported flower keys %#x",
+				       dissector->used_keys);
 		return -EOPNOTSUPP;
 	}
 
@@ -156,11 +155,11 @@ static int efx_tc_flower_parse_match(struct efx_nic *efx,
 
 		flow_rule_match_basic(rule, &fm);
 		if (fm.mask->n_proto) {
-			EFX_TC_ERR_MSG(efx, extack, "Unsupported eth_proto match\n");
+			NL_SET_ERR_MSG_MOD(extack, "Unsupported eth_proto match");
 			return -EOPNOTSUPP;
 		}
 		if (fm.mask->ip_proto) {
-			EFX_TC_ERR_MSG(efx, extack, "Unsupported ip_proto match\n");
+			NL_SET_ERR_MSG_MOD(extack, "Unsupported ip_proto match");
 			return -EOPNOTSUPP;
 		}
 	}
@@ -200,13 +199,9 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 
 	if (efv != from_efv) {
 		/* can't happen */
-		efx_tc_err(efx, "for %s efv is %snull but from_efv is %snull\n",
-			   netdev_name(net_dev), efv ? "non-" : "",
-			   from_efv ? "non-" : "");
-		if (efv)
-			NL_SET_ERR_MSG_MOD(extack, "vfrep filter has PF net_dev (can't happen)");
-		else
-			NL_SET_ERR_MSG_MOD(extack, "PF filter has vfrep net_dev (can't happen)");
+		NL_SET_ERR_MSG_FMT_MOD(extack, "for %s efv is %snull but from_efv is %snull (can't happen)",
+				       netdev_name(net_dev), efv ? "non-" : "",
+				       from_efv ? "non-" : "");
 		return -EINVAL;
 	}
 
@@ -214,7 +209,7 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 	memset(&match, 0, sizeof(match));
 	rc = efx_tc_flower_external_mport(efx, from_efv);
 	if (rc < 0) {
-		EFX_TC_ERR_MSG(efx, extack, "Failed to identify ingress m-port");
+		NL_SET_ERR_MSG_MOD(extack, "Failed to identify ingress m-port");
 		return rc;
 	}
 	match.value.ingress_port = rc;
@@ -224,7 +219,7 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 		return rc;
 
 	if (tc->common.chain_index) {
-		EFX_TC_ERR_MSG(efx, extack, "No support for nonzero chain_index");
+		NL_SET_ERR_MSG_MOD(extack, "No support for nonzero chain_index");
 		return -EOPNOTSUPP;
 	}
 	match.mask.recirc_id = 0xff;
@@ -261,7 +256,7 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 
 		if (!act) {
 			/* more actions after a non-pipe action */
-			EFX_TC_ERR_MSG(efx, extack, "Action follows non-pipe action");
+			NL_SET_ERR_MSG_MOD(extack, "Action follows non-pipe action");
 			rc = -EINVAL;
 			goto release;
 		}
@@ -270,7 +265,7 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 		case FLOW_ACTION_DROP:
 			rc = efx_mae_alloc_action_set(efx, act);
 			if (rc) {
-				EFX_TC_ERR_MSG(efx, extack, "Failed to write action set to hw (drop)");
+				NL_SET_ERR_MSG_MOD(extack, "Failed to write action set to hw (drop)");
 				goto release;
 			}
 			list_add_tail(&act->list, &rule->acts.list);
@@ -281,20 +276,20 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 			save = *act;
 			to_efv = efx_tc_flower_lookup_efv(efx, fa->dev);
 			if (IS_ERR(to_efv)) {
-				EFX_TC_ERR_MSG(efx, extack, "Mirred egress device not on switch");
+				NL_SET_ERR_MSG_MOD(extack, "Mirred egress device not on switch");
 				rc = PTR_ERR(to_efv);
 				goto release;
 			}
 			rc = efx_tc_flower_external_mport(efx, to_efv);
 			if (rc < 0) {
-				EFX_TC_ERR_MSG(efx, extack, "Failed to identify egress m-port");
+				NL_SET_ERR_MSG_MOD(extack, "Failed to identify egress m-port");
 				goto release;
 			}
 			act->dest_mport = rc;
 			act->deliver = 1;
 			rc = efx_mae_alloc_action_set(efx, act);
 			if (rc) {
-				EFX_TC_ERR_MSG(efx, extack, "Failed to write action set to hw (mirred)");
+				NL_SET_ERR_MSG_MOD(extack, "Failed to write action set to hw (mirred)");
 				goto release;
 			}
 			list_add_tail(&act->list, &rule->acts.list);
@@ -310,9 +305,9 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 			*act = save;
 			break;
 		default:
-			efx_tc_err(efx, "Unhandled action %u\n", fa->id);
+			NL_SET_ERR_MSG_FMT_MOD(extack, "Unhandled action %u",
+					       fa->id);
 			rc = -EOPNOTSUPP;
-			NL_SET_ERR_MSG_MOD(extack, "Unsupported action");
 			goto release;
 		}
 	}
@@ -334,7 +329,7 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 		act->deliver = 1;
 		rc = efx_mae_alloc_action_set(efx, act);
 		if (rc) {
-			EFX_TC_ERR_MSG(efx, extack, "Failed to write action set to hw (deliver)");
+			NL_SET_ERR_MSG_MOD(extack, "Failed to write action set to hw (deliver)");
 			goto release;
 		}
 		list_add_tail(&act->list, &rule->acts.list);
@@ -349,13 +344,13 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 
 	rc = efx_mae_alloc_action_set_list(efx, &rule->acts);
 	if (rc) {
-		EFX_TC_ERR_MSG(efx, extack, "Failed to write action set list to hw");
+		NL_SET_ERR_MSG_MOD(extack, "Failed to write action set list to hw");
 		goto release;
 	}
 	rc = efx_mae_insert_rule(efx, &rule->match, EFX_TC_PRIO_TC,
 				 rule->acts.fw_id, &rule->fw_id);
 	if (rc) {
-		EFX_TC_ERR_MSG(efx, extack, "Failed to insert rule in hw");
+		NL_SET_ERR_MSG_MOD(extack, "Failed to insert rule in hw");
 		goto release_acts;
 	}
 	return 0;
diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
index 196fd74ed973..4373c3243e3c 100644
--- a/drivers/net/ethernet/sfc/tc.h
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -15,24 +15,6 @@
 #include <linux/rhashtable.h>
 #include "net_driver.h"
 
-/* Error reporting: convenience macros.  For indicating why a given filter
- * insertion is not supported; errors in internal operation or in the
- * hardware should be netif_err()s instead.
- */
-/* Used when error message is constant. */
-#define EFX_TC_ERR_MSG(efx, extack, message)	do {			\
-	NL_SET_ERR_MSG_MOD(extack, message);				\
-	if (efx->log_tc_errs)						\
-		netif_info(efx, drv, efx->net_dev, "%s\n", message);	\
-} while (0)
-/* Used when error message is not constant; caller should also supply a
- * constant extack message with NL_SET_ERR_MSG_MOD().
- */
-#define efx_tc_err(efx, fmt, args...)	do {		\
-if (efx->log_tc_errs)					\
-	netif_info(efx, drv, efx->net_dev, fmt, ##args);\
-} while (0)
-
 struct efx_tc_action_set {
 	u16 deliver:1;
 	u32 dest_mport;
