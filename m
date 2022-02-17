Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0EA74B9DC3
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 11:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbiBQK5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 05:57:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234656AbiBQK5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 05:57:30 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2125.outbound.protection.outlook.com [40.107.100.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 437001704C
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 02:57:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=if16SY0eHvHgfpMlXRCVLSLQe2/eHdMDyYhzAvykjmDVoI/gxg6abo6IzlilIwj1HuDrapIYIJeT/1F18ekPy78rC4tcm2Lni1Mb4fpowSNW/DgcNwJxAkT5D6l7Fo834yiLtufukTbY/hLkIURRbHuwLZZKEonwVeMJ6q+qffFidyuZuF4Aqqm77+uugsgXaVALB7K/3epDtVXrPwA/g4Pk0HeDdHccRVZysoxux8cWCNeXRDx717MpF0XFct2MJmjV8D7qlWx3cC5xaw+fyS2gkQ5o/cl5KtQQjIWOmhpHUbqJcVBblTBUnEzl0bYo5TlgP19IFAMIxmEZA04vlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ilOGCwqm5mjplkvAtjPdznOr147UBs4avU1R4yuhak=;
 b=TrebDrvZSJFiXViyU895KNRf6r/ESLEBD6lD50wSIbKTdfHRKt/vsN4ph82eR5H16ZPn2JT+Q8DRcfyRpg620pMSBiUvTNAAylmKipvWyvX5VkLboodtGrmkYuSoATVQCofK9IgEfpz78Wl7b+3LwYstbIOBSdqhl0T1qY4WPL+LKVINgUiKKl4WBIfSf+UXf0So+NS83u52kGLxDNoWTJ2YaoQmj/GpIIJYtoYc4gJF6a2P2/AQTTNHj0roT6PvLK7tIcukMu3fE3V0mMO/UTuKXWlHJYxtdf/rmhV9Sqz2t37QVLJKpP5rrqDeUSGqR2Wq7AVvdbiecKCEtJIwDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ilOGCwqm5mjplkvAtjPdznOr147UBs4avU1R4yuhak=;
 b=ReAUiKRKdHBrs9A7Vz/sbkU8ZTBsmy5k/+8W7pBE5gmOxTBPi1VmjMs+bg9AkzrFPqyPBJJef5i+0ytgzhQfRgR6LHpv6pu9u3pClTMT7Q0wdXHUzElflz5TKNPnYKva5nvTb3dMze4Gy7yAsrghZTSLscbLpK/qN1C1Oy3ndhA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CY4PR13MB1397.namprd13.prod.outlook.com (2603:10b6:903:136::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Thu, 17 Feb
 2022 10:57:13 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d%7]) with mapi id 15.20.4995.015; Thu, 17 Feb 2022
 10:57:13 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 1/6] nfp: refactor policer config to support ingress/egress meter
Date:   Thu, 17 Feb 2022 11:56:47 +0100
Message-Id: <20220217105652.14451-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220217105652.14451-1-simon.horman@corigine.com>
References: <20220217105652.14451-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0081.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6adc0a7-61b3-4ab0-2c3c-08d9f2044101
X-MS-TrafficTypeDiagnostic: CY4PR13MB1397:EE_
X-Microsoft-Antispam-PRVS: <CY4PR13MB139715B2BA9395FE1B9E4776E8369@CY4PR13MB1397.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lHX+VL/OVwWKWMRz2t38YCVJ+47kv8mdQqZkpM3NqtOC+K2rSDX4DNj4qWjIWXvdBjwANPNi3+3E0aUTyzLbHcfRLmye5ItYpQa8a/f23sh/YdRX13v2WCxDWyFccgsUx95JcvhXm/KdbZvoNgEfDl7BpVSmPHV5NEOyzWPpVINBd38y/pt7h5KINLsz5WgWsfi94oXs67PKxn0g37fwVheSRfcpm5Dl4/Ydm1tycbTuxPJcs2AiHAcPGcIm5zIZp8SdqbR7vMxtJjDy5nh9ghJWC4dNQALvtMTk+3sJznGyRf2rRNDv9eSnMq6NPMNwSHVi4slG65I7bPAYjlxx3ecm4VIULK6Hn+BxJ3x4B3eBdPtv12h/laxdfWgI+yYtRA3jMYR+xFP1Gc3JXiqaXOOOyHfma8KbNU2pn00c256PNCczgQ6kAtzsDxfwnULbxs5fxCT3P5MSxU4aS9DqzfV647I8zVNSig3HOvWzqeODAbYhyJLshX5MFl4ZGUXWMkNRqXBjQgr60B3xRFMHcc9LtctWsL8FrzzVTBLOxEvWvxXYpTTcOcVCGgGtxEmP9hzhvFSrYd+/DspZbCQ1fTDmwv7TkfHl63qMjHiMPSD9kvkmjYLBtzOPf8qpIKTLBqeM/4K5RuKzzOMwnVbbDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(39840400004)(136003)(396003)(376002)(366004)(8676002)(66476007)(316002)(1076003)(6666004)(6506007)(2616005)(54906003)(186003)(52116002)(38100700002)(6512007)(66946007)(66556008)(4326008)(86362001)(110136005)(6486002)(83380400001)(508600001)(107886003)(44832011)(36756003)(2906002)(5660300002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D4cKWic0NbRtBC8EedZlgMkd4Qy1JE3XnfASNHEQDnzfcV42iCaN87ZzrZG7?=
 =?us-ascii?Q?933rDLJapqn3Bfza5WqIAZlgxrcPBBKbq5VMyZ6aCokuJjqB1pcx2ooeFzPB?=
 =?us-ascii?Q?VdBbiQ4qkVLXrzhUsK6ff/Zsxs+crO0jkJFaSBXSBDXYLZmvsv3Hz/cK35pc?=
 =?us-ascii?Q?S9KqN7vktuLCfA2p/W5OhXZN0ufOG7ZsPhqVrXDNNaeaXWelNVcgGRDYg1ac?=
 =?us-ascii?Q?OYMP3GPMR2u6y3wWBBjCkhKG2iTi3VKAmOZEXq03lsYlUGo8l0Q0xiTgxIP1?=
 =?us-ascii?Q?w/dScd6Smnr97ixGjgZJxBH2nySj7a6Wlf9JxMUPN1Ro07l5wi0aHhcGUiSf?=
 =?us-ascii?Q?JYcfDWaMb9Jgez80cv9wWxXj7AdchtrIpUg7kmcotyh45Dn3RgaVuFtitrrG?=
 =?us-ascii?Q?r3CAC5pPOIG/QIHmXVy/BC0SqjfTR/bMQMy7l9gDnxKgbWj7DWiolYxwvdWw?=
 =?us-ascii?Q?i2Tq97MwZYXyLe8FmnWR81C8e44912J3DoLP97deBpCnQ2tr7S4jZ4FG5YHw?=
 =?us-ascii?Q?d4FMpQ+VhpOzQwS3Vfhkhk4jGDW5O0ONd+XFTlvqQ1FbGahqbw+v/t8Gf8Mr?=
 =?us-ascii?Q?/hub51LGqyKl/am/ERX54n/z29zx7lKlfjn57V1oriF5NtOHoohB6H16Qgz0?=
 =?us-ascii?Q?c2qMvcSU1I8iQBn4YzsIbSUMYLZeutX+CowdruW/WtHpw7vm0ymNvsuaR+c1?=
 =?us-ascii?Q?6YsUCaSejZXWdYvIwic3yYgCcZ3yW6N8HyM0Y6+FFlxrTPE4k3JUz/cBVoKZ?=
 =?us-ascii?Q?gRwhtY4RWUULUbsRPuLurgadRln7EPeOxRnCnYrtSKwg3PnxfNfnz4aj3hlm?=
 =?us-ascii?Q?CcBFfSXTupV/KHy3d7p9SwBEhNPwV9MBUyaSFJZbI4lNldio24gU4648O/r/?=
 =?us-ascii?Q?Tz0kqFSGcSHcf2PXTEgAHWL5DGeLMTL6cs3l3TCW0sDlcnbsYp0TGKg4iYJB?=
 =?us-ascii?Q?329PDkrV/hXu76kiugPniA03gln2NDQeNv1wh4zM2ZSMvOUdedfmzoMpSXdN?=
 =?us-ascii?Q?rICD81MDmhNQ3E6DR6uvlqDKqW6G3FmGPx78DZBJ5e5sKH/OAxeXxFkXI2nb?=
 =?us-ascii?Q?M8EDQUXbWRHM2BE9tOZn6foPaKOuMxWm6VByZ0tohp0jSw+veoOxhNdUxjik?=
 =?us-ascii?Q?5WWZBIwJ3HZFlbsgoKIRnYzDhkvcrWy4h78wYpP4LGwjfDpDIGpxeB4qEBpy?=
 =?us-ascii?Q?GkN2EbPybUntgXAc7Bbhpnzla0/+E5dbOiDomXPNrGilSnJCLl4rhiUjYQCU?=
 =?us-ascii?Q?DEHsyh4O4a2F0CYO06PPxtyN0KIhNtQBdIFqvSofVMO/u4WQTGlWVs004rsj?=
 =?us-ascii?Q?xz5DVx/Cf+HV6FhF/6H0cw/mdNcbZ354R7yHkBr3JfcT18lAOQ6lCa2Zyrkn?=
 =?us-ascii?Q?2fHcKl2rcxJ2C0IeqbEhTs2yFZSCjjNbP3GUsI+rljGMkfUnPRZwfQBtaDT+?=
 =?us-ascii?Q?8qadvPqSSoqbWMvtcA53tV+s198lORPk50lVQnK0Uk2/I2lgTK2lxDVT+Ah8?=
 =?us-ascii?Q?FicBY6VsJsVfItQc+WBA3wchHfb7taclBagkom5rQPkOHFHavI6oenEDLmK7?=
 =?us-ascii?Q?3ZfQX0gnEey2GRBAP7uwXuxMQeb/zCLwpf/OSuIiuqxBZqYm8ftNogzY5V+L?=
 =?us-ascii?Q?lxUXNpku+pbk2ZPXoWt+yiSt6pN7XXpxQOT0e1sBKbU4hpfqNk5s/y1SWy6M?=
 =?us-ascii?Q?FRBJXP5U/iJWeiM7+BGzSpNdX+CzU44j01sH89GOdVi6h0YDRFGIzyh/1til?=
 =?us-ascii?Q?Hyk8RaOfRhTn5DVLFYP+mOBIM5LVvhM=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6adc0a7-61b3-4ab0-2c3c-08d9f2044101
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 10:57:13.4960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c2aX4n44ZnEGfr0qsocB9tnZohEbC2qWxh+SjHIFb+WMastfR2HQUMxPJBuhB84mDr3M0ptvgjrhVQfdVFo7eBye3Bql5yEWNQIIUApEglk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR13MB1397
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
2.20.1

