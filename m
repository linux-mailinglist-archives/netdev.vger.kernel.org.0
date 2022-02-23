Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04F494C1887
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 17:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242781AbiBWQYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 11:24:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239553AbiBWQX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 11:23:58 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2093.outbound.protection.outlook.com [40.107.223.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C09C5DAA
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 08:23:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KNVg434RASJkkQ4OSHdmBbVj8zbq28XlKHDL9gdchMLQvjVQI70BF+WlnTUxheD07OaedUfAvLEA1QGmQOSkrv3pCQL/1fZ2hyClzKXrD/wLf3EY+bseHbLk74odOAU72RvdvLOMg2rTI6Mc14RRjLHi9W6nxBL5QLRpb1/Qzo8WsqmCy1PZWpnmtfbihnkTqO8ABqzm/JFT9BXS4UwaIFofHo3qStu9+oztKjIhZJxR+Ql2EonELWVGAtKAI6EnDh7BEEjub3prpCf3Wc9DPP/7Fy+SpXK2zwJptSafy/f2uA8dKwDW6yzk9i5IR0ENhXOOSJCtGi9Rbielus2NMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gevC5gpG/A9odi54O5JZOXZNagKO9avNuyOYALmexu0=;
 b=AjZHBae6PPP5/+aLM/OQiDNoquK3Ba+ycuFTj3eixzaMNU90TJHAgz8SQeN+VcYY3QiV4mG5vIOO4lSdLhl+/TwWTJRNi5Emlji6P1UAoqCZD2aE5S6PnbdxocNI74YIRqkyKF6bic9QraaT06v9ydBxJGseWBbL+hMZzD70wz1c2jNoHUL3VpiqskhluONichPDN2iAU1adIH+dTjNkpbZ5AVDcJUGvRhjPzLrPWl85uZd0J+3mPmWTg9EfjvEKdeAaDFLvdLPYtCpMMmM0THBRevFbktfVNC8vk1V/i0X+bGaM3ejEGYZSbhYDLZ2cW9jcPYsEm1gGmXO1epSNfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gevC5gpG/A9odi54O5JZOXZNagKO9avNuyOYALmexu0=;
 b=oSvSN1s50fTpWjL3QdYk2rwkiaFf5KVrpxRxB+5+synT7rOtgZzlfevkGZjhzDJ/5aN7jDy4XSLaldQbkRR5vtCvVw6G4hjT/P7LO5cqrwDeYPGyPhuj8vYO37R0zWixR7frVrLGigfxjDpvZGw1eSu+t58pys5rg4MVyiOZ3UY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MWHPR13MB1757.namprd13.prod.outlook.com (2603:10b6:300:132::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 23 Feb
 2022 16:23:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d%6]) with mapi id 15.20.5017.022; Wed, 23 Feb 2022
 16:23:25 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v2 1/6] nfp: refactor policer config to support ingress/egress meter
Date:   Wed, 23 Feb 2022 17:22:57 +0100
Message-Id: <20220223162302.97609-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220223162302.97609-1-simon.horman@corigine.com>
References: <20220223162302.97609-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0125.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f014fe71-7c56-490d-db48-08d9f6e8d039
X-MS-TrafficTypeDiagnostic: MWHPR13MB1757:EE_
X-Microsoft-Antispam-PRVS: <MWHPR13MB175756C2DFEE2C17ED9FE9E3E83C9@MWHPR13MB1757.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1enJ2Q/84HHgs1HguM5K2E1Cn1rQDW+q+fo59K6DsmddzPTfygDNsZT45UVJP/vcx6xIKSJfuNmG0McHKWOpb3w17xgOMSt3GN9GgrnfH2NAUkMB8NCadAZVQyspIqcfPsR84CmwagEh9skq1Qhxs67NT7jGpyoup52XoZAoqG/EbqoCTXiOjiUkQxMH7xnsWlumScUGlFRnBd3HyDDo5HxGLYOcos7tnVSBDKTPiWhpYZvBHU6vQP/23VntQFVxCgEvQHsaGbdpvtaXKvKFr//x00wigb01CAxhSCfz0yrUGZtZ/V4lePXAM2gKMo0fWNSyFBoLQuEeGsV2rDJwBcd3Jj39xLCfQMHuW4gTnSQFK3zV+LYTpszcSWQZx/I6SsL+yFgl9eNySjoUWeb4bJ/W53LgFLKqlsq1zMTcWNGgxjgl85fWiUt1+uTXYFVALaCb7sqO7+PsXUiRZFKCaZkbkB3bj0V0eg7ocvDXzhpyJpkwiEptUqROpfKdf8eTge1gXge3a1RdUBGhyqZYI0QBd8Fw9NayvsrTsHozxEEUZhlxja9u07d8Dy5xhv6q/8tGvp0cs7o+bD5Ztpx3pyRkIq+gCyP0fgyw7CxUYAKQxZt96e/FKDZrYu8+1Iw0xk9cGdtuPbymk0INsJ4QBrCWQiL2tuUud1N9YMBgiY2vxqULk7rKH48vYwHNi+OwqQaXy6rwRbXoZfZ5LVpNnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(346002)(136003)(366004)(396003)(39830400003)(8936002)(6506007)(86362001)(508600001)(52116002)(6486002)(36756003)(44832011)(2906002)(5660300002)(54906003)(110136005)(83380400001)(66476007)(1076003)(66556008)(8676002)(2616005)(316002)(66946007)(186003)(38100700002)(107886003)(6512007)(6666004)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5ZtEe21yioqbyQhBWHabUavOHxxsNpfkKNmY4EOV76H0EaE5I99CQZa/u3Vl?=
 =?us-ascii?Q?nrgRPVGIWUIX9KWnHie9mOI0TiA4DzWmSKbh45WgNOA+4Gi+7frwf+Ke4D2J?=
 =?us-ascii?Q?v8BnK8EOqj66wjgbbGwW/hDZ/ZsqTvUSw+G6Z4iTzyAU9f8qVXs0o89IiF+h?=
 =?us-ascii?Q?K7EgsWA5vCdmOJ0fqDPTwqEYju4UToA+m5V3j//xF1vSuwzFzVXpbOvYS+G4?=
 =?us-ascii?Q?dztXGoUIdiqFQyT3ClW6R+uk9uM22HTYL4H8vgKHyA3i/JNWhNbO0KstGny2?=
 =?us-ascii?Q?gd9C51PrU/bl60tuJRFjxfcv6PWYytRO1RvA12MD1u6pDI5l+2OhzGYggN+2?=
 =?us-ascii?Q?aUt6VWM0fMcoCulkK0A93I9wx/K5lrLPu5QAdpzh4Q0v3JoXYWb+oDqOhlGs?=
 =?us-ascii?Q?c7Qg6oT28pMFnyCElLbyM9EBgeG4ULcxSR/1vHcZnX3BEi5Be4mGypFmGCms?=
 =?us-ascii?Q?5POewV+r3d/Mfvvv87CfjyS8VEGK+KN2tj/d1g7S4p9K2umv9EARjlYi25EW?=
 =?us-ascii?Q?LsjD80Qi528jq86Otiu+Srrx5KXLmW47OPtgC2YZUIMa+PBONOcCbdFME0tb?=
 =?us-ascii?Q?IyZ189nJngUD6P5AeJcIFEORbEBYsb5SdmJslGmO4dd6vLJRKrEidqF1fKeT?=
 =?us-ascii?Q?CVbXMtqM70bD/8o7UVW5A2ov/4Dod9DufkVkrzn7NfDhkRwPqNkQVG9nZg3c?=
 =?us-ascii?Q?GtNSJAXeUPyWefB/bvpsTYNQtDrsTugbnxCz7otEO8haBXh8zmU8U7JRjszf?=
 =?us-ascii?Q?Nb7yyaifBec7S0twvKBCELJyNANpZ1ivMrzd5iKORoAp6zgUvDwJSmwsEDq5?=
 =?us-ascii?Q?hc2kE46IfsgAM05EjDkGbVPENlNvmJVH4oSHX5UOl2n/OZ1wQHHLlgOrCbGO?=
 =?us-ascii?Q?rRPLbMd2a2avD+8paj+Yd7ex52RmMII6qt28DRMQLcXwgpoPCLRsU0Qq2hFd?=
 =?us-ascii?Q?9nA/eIZARlDDVbN75y4tM3PU8j08Q3JsThgNA9qizWPPb2iQIwX8nm2t9+yt?=
 =?us-ascii?Q?CDprB/jSV6hD3yvdqT5xokIt1ilOBFQr5QjwThu9FWM5tycYUsuJH4Dnl9oX?=
 =?us-ascii?Q?WUg8bUfT9kuH025XoQTAW9Y+3kwVN1X2PH/qP0l9urjreIY3oTxshPTK14Cy?=
 =?us-ascii?Q?3vr1uxRww+u2MCPGKVJRRsqrcZ2QnnWYpOKtcpELfWFuiRzCiFAMjUK2LElm?=
 =?us-ascii?Q?xu7d4d7vfxyYapRr1xr8d2CJlpI4lQJwAfZ3FVKT63mYFIacVjHrROoG0ROz?=
 =?us-ascii?Q?9NUBmVk+K/Kjh+CEKRN+EHuneoEePBn3g3Mj8yqkqK0Z0QYV28atsEkTN4Rs?=
 =?us-ascii?Q?dE58wlz/yIzUJxXe3P5wK7HrBI85aDJ0wXRASKBwQlj1R9NoHYT6NTUsmbXn?=
 =?us-ascii?Q?otxOhgx2DY1R1ey4fcPPT0a9w6cp1srVCSgkb1ij5TvZ3Z3jW2pcQU3nekfb?=
 =?us-ascii?Q?QcATET79/37mWPhHFkFVHs5zucO6Fc2AOWVdzIHQvRAe8cX6Yeb8ZdXb69k7?=
 =?us-ascii?Q?OeyBBvVEspr1z84+OT6aPkKyOzlr0ObY4OPJ8Ca3LufNt5mz6/ReD9dNqiDB?=
 =?us-ascii?Q?Ur1r1+im8SsmIR2fcUuVXFe+N9e3GOZAdyDBlrRtLiWWOYjHin88vt/TqhZ4?=
 =?us-ascii?Q?e7V4Qm+VwOz0b3fRwT+wMXw2nrRcdpVRupjVo4hIX9R+uEsqZ0whXy6S+b2r?=
 =?us-ascii?Q?AW9sV5DmSREZVHqq7da+o6qU2TmhBIvZj52nKDYJyfVoHX6+t/8ZPPI7AXev?=
 =?us-ascii?Q?OBv+HfPr3A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f014fe71-7c56-490d-db48-08d9f6e8d039
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 16:23:23.7652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Glx/GC3s8K/BJzvJAutbDYFPm/0amSqObvUJlcihAZJfTcrW1fWDOfTQSmGz7N89O0UALraE4ueD+yZPk7DdoW2gVMeDSp8tb61xPQwTxNw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR13MB1757
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Add an policer API to support ingress/egress meter.

Change ingress police to compatible with the new API.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../net/ethernet/netronome/nfp/flower/main.h  |  2 +
 .../ethernet/netronome/nfp/flower/qos_conf.c  | 74 ++++++++++++++-----
 2 files changed, 56 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 917c450a7aad..7720403e79fb 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -569,4 +569,6 @@ nfp_flower_xmit_flow(struct nfp_app *app, struct nfp_fl_payload *nfp_flow,
 void
 nfp_flower_update_merge_stats(struct nfp_app *app,
 			      struct nfp_fl_payload *sub_flow);
+int nfp_flower_offload_one_police(struct nfp_app *app, bool ingress,
+				  bool pps, u32 id, u32 rate, u32 burst);
 #endif
diff --git a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
index 784c6dbf8bc4..68a92a28d7fa 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
@@ -11,10 +11,14 @@
 
 #define NFP_FL_QOS_UPDATE		msecs_to_jiffies(1000)
 #define NFP_FL_QOS_PPS  BIT(15)
+#define NFP_FL_QOS_METER  BIT(10)
 
 struct nfp_police_cfg_head {
 	__be32 flags_opts;
-	__be32 port;
+	union {
+		__be32 meter_id;
+		__be32 port;
+	};
 };
 
 enum NFP_FL_QOS_TYPES {
@@ -46,7 +50,15 @@ enum NFP_FL_QOS_TYPES {
  * |                    Committed Information Rate                 |
  * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  * Word[0](FLag options):
- * [15] p(pps) 1 for pps ,0 for bps
+ * [15] p(pps) 1 for pps, 0 for bps
+ *
+ * Meter control message
+ *  1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
+ * +-------------------------------+-+---+-----+-+---------+-+---+-+
+ * |            Reserved           |p| Y |TYPE |E|TSHFV    |P| PC|R|
+ * +-------------------------------+-+---+-----+-+---------+-+---+-+
+ * |                            meter ID                           |
+ * +-------------------------------+-------------------------------+
  *
  */
 struct nfp_police_config {
@@ -67,6 +79,40 @@ struct nfp_police_stats_reply {
 	__be64 drop_pkts;
 };
 
+int nfp_flower_offload_one_police(struct nfp_app *app, bool ingress,
+				  bool pps, u32 id, u32 rate, u32 burst)
+{
+	struct nfp_police_config *config;
+	struct sk_buff *skb;
+
+	skb = nfp_flower_cmsg_alloc(app, sizeof(struct nfp_police_config),
+				    NFP_FLOWER_CMSG_TYPE_QOS_MOD, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
+	config = nfp_flower_cmsg_get_data(skb);
+	memset(config, 0, sizeof(struct nfp_police_config));
+	if (pps)
+		config->head.flags_opts |= cpu_to_be32(NFP_FL_QOS_PPS);
+	if (!ingress)
+		config->head.flags_opts |= cpu_to_be32(NFP_FL_QOS_METER);
+
+	if (ingress)
+		config->head.port = cpu_to_be32(id);
+	else
+		config->head.meter_id = cpu_to_be32(id);
+
+	config->bkt_tkn_p = cpu_to_be32(burst);
+	config->bkt_tkn_c = cpu_to_be32(burst);
+	config->pbs = cpu_to_be32(burst);
+	config->cbs = cpu_to_be32(burst);
+	config->pir = cpu_to_be32(rate);
+	config->cir = cpu_to_be32(rate);
+	nfp_ctrl_tx(app->ctrl, skb);
+
+	return 0;
+}
+
 static int
 nfp_flower_install_rate_limiter(struct nfp_app *app, struct net_device *netdev,
 				struct tc_cls_matchall_offload *flow,
@@ -77,14 +123,13 @@ nfp_flower_install_rate_limiter(struct nfp_app *app, struct net_device *netdev,
 	struct nfp_flower_priv *fl_priv = app->priv;
 	struct flow_action_entry *action = NULL;
 	struct nfp_flower_repr_priv *repr_priv;
-	struct nfp_police_config *config;
 	u32 netdev_port_id, i;
 	struct nfp_repr *repr;
-	struct sk_buff *skb;
 	bool pps_support;
 	u32 bps_num = 0;
 	u32 pps_num = 0;
 	u32 burst;
+	bool pps;
 	u64 rate;
 
 	if (!nfp_netdev_is_nfp_repr(netdev)) {
@@ -169,23 +214,12 @@ nfp_flower_install_rate_limiter(struct nfp_app *app, struct net_device *netdev,
 		}
 
 		if (rate != 0) {
-			skb = nfp_flower_cmsg_alloc(repr->app, sizeof(struct nfp_police_config),
-						    NFP_FLOWER_CMSG_TYPE_QOS_MOD, GFP_KERNEL);
-			if (!skb)
-				return -ENOMEM;
-
-			config = nfp_flower_cmsg_get_data(skb);
-			memset(config, 0, sizeof(struct nfp_police_config));
+			pps = false;
 			if (action->police.rate_pkt_ps > 0)
-				config->head.flags_opts = cpu_to_be32(NFP_FL_QOS_PPS);
-			config->head.port = cpu_to_be32(netdev_port_id);
-			config->bkt_tkn_p = cpu_to_be32(burst);
-			config->bkt_tkn_c = cpu_to_be32(burst);
-			config->pbs = cpu_to_be32(burst);
-			config->cbs = cpu_to_be32(burst);
-			config->pir = cpu_to_be32(rate);
-			config->cir = cpu_to_be32(rate);
-			nfp_ctrl_tx(repr->app->ctrl, skb);
+				pps = true;
+			nfp_flower_offload_one_police(repr->app, true,
+						      pps, netdev_port_id,
+						      rate, burst);
 		}
 	}
 	repr_priv->qos_table.netdev_port_id = netdev_port_id;
-- 
2.30.2

