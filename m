Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E73BD4C188A
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 17:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242797AbiBWQYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 11:24:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242780AbiBWQYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 11:24:03 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2093.outbound.protection.outlook.com [40.107.223.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46767C5DA5
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 08:23:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fhRNdWcLdr8kjM5ATR7xBvVLUV4/YfxQYij9XDvzLzxX5OtB3qa7nojchRYYKfugvuCXKGpMiaBRDKMAX7NrMleFSORXs3Aol90bL5XPuL2IhdoHShd6usde/QWRq0coCvwOe8O1wvovGpvSVM03/lyxdESpLQCnAwq++44aSSg7sYkFX3mAAvdtIEnQ56M+LxbVdTgIUi7E2OSArfCrLtEYkEXzDr3zdyR93foV7fe+M86AD+1A0YRRE/H6Z4uph6wbQOs5fIkjpqi2l2aDX2jJkNvELgRjxid7h0shhHGKwQ6yaqPJUw/HJNSOfTkIXx5+e82H8ht8pdxhj3mypw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2l60ffYqiDRIiZrp5BLKCR1w/8QA8mZl496DjOua9qc=;
 b=aN8udZvzQUsoqomFQB2VWkw6HCVnNCEJ32LkiyAFFLNAGduF4eWRZLRckf/0rJM4Rv8wOMoPYhQ8tQ12KLh/gZc14f419mqBUjvOBzdCFcW2ZBxpNn/hsvN1XCptryIFe1sjW+Mj6oiCpLMTqoOgojnxDfAnb8mAvdjTuKR3W5prWcRhBH4kkksxTLadYArYkHKv2UzkvMV1+vBibdj5IbQd2G7URQCkZ5fcxQ61eBmDrSj2SjYYXoj04aWKZDRTQ7hjHMD8NiEnz51ITvw2nmuoHcBDlEkCgfTh251X5r1DP4/3JtH1rbYUL+O5Alo/aEgiIHXyiBeOhLGqSWsJoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2l60ffYqiDRIiZrp5BLKCR1w/8QA8mZl496DjOua9qc=;
 b=DqmY6rU52h3MbA9g4xhLdmJhDsJXc/PYF70J0G2yBCLAyy73ENY1fFCLDQVjVhob4sKKsoQrUnovBt983HNIJdsttSovC2+xHZSMk2n/nr67RfcIPMhw4DU6rH8bZa/k89hfmzgXVvpkoO7ZI5j6V+a6yONmUEaBNehqoBVhHPU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MWHPR13MB1757.namprd13.prod.outlook.com (2603:10b6:300:132::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 23 Feb
 2022 16:23:32 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d%6]) with mapi id 15.20.5017.022; Wed, 23 Feb 2022
 16:23:32 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v2 5/6] nfp: add support to offload police action from flower table
Date:   Wed, 23 Feb 2022 17:23:01 +0100
Message-Id: <20220223162302.97609-6-simon.horman@corigine.com>
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
X-MS-Office365-Filtering-Correlation-Id: 75cd2fec-ca2f-4022-ee7a-08d9f6e8d4a2
X-MS-TrafficTypeDiagnostic: MWHPR13MB1757:EE_
X-Microsoft-Antispam-PRVS: <MWHPR13MB1757E0F1211F15D8E67FF506E83C9@MWHPR13MB1757.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: awcmA1v1WbnJ7M7NyihGeLZdd+jv6El4QUt8YL1LPTBLlf4bec372R5gXVECAjgbKZSl7ZlSF0AORmt5YY42E2OnqJ8PW/1s0psp58WmQFN1qMjPAQJilFsLcURtWgRg/4rDVFkNqfaeWzdajmwGTA0+rFptzUw6ZcB13oRnd0hezvV3BBQiKtSL9TQ7VJih1YHemUjHB0sf3xmQBdwrrYdZUQuugIBESxvICeuhM0A7qpPrmkw9SFTpyCaQ6ire0XAEXX5Lsrj+pq2HNCIaImStaF3Ud2p7h3+aR2nFyDlAp4RgvfZ/fPg2g8bsTcjUqIKMTvsgQa4I2cgcG0AKFSKNRTxlEirhFpmn3kZVM+HWcJ2rzot6K7acQwcIBMcYD1utpgVppXp3MGbFrobdTb8dA1xZKa/ZB35QEkELIngeAHf9A0vSW+vQa7C392k7HRlN2LDA+43GrGJ2/XQWJYMblKeDxm5fsLxlKKzB2oa30UryggHpDfKakJPr1guEdudELl8rM4xUUXviCHTje24Yg0wd9yfTx6GP1gZJbn8QZgz7X0xhE9NxjP4hXo4wmsxLQDlAbOzXo2L/WrA7nWzgw4iKeSvtswkLNkbyUEXeDOjWRjx+oCuXo1pvccEn/xUGqF4E3uZ0ySFDxQhRdHnHbCy88XWYZfn0Y9xjRJAoqBBGDwT/N2y63YD2cJTs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(346002)(136003)(366004)(396003)(39830400003)(8936002)(6506007)(86362001)(508600001)(52116002)(6486002)(36756003)(44832011)(2906002)(5660300002)(54906003)(110136005)(83380400001)(66476007)(1076003)(66556008)(8676002)(2616005)(316002)(66946007)(186003)(38100700002)(107886003)(6512007)(6666004)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OI7XrJ5cx/sl5e3t6fZeV2knPAXldtHA3u9ojtc8/IQJTl4FG10raELo3GoX?=
 =?us-ascii?Q?vmaQtfEHlDrp3yY6ybLHFbMlwgTlr9hPjN3gv/o/tGu5XHRnyn9TIx4Rc5Al?=
 =?us-ascii?Q?kE/RaHZc/JDbLxfSJwFuKqZeQJxiyF5O0x3kyUhSEvqlMo6XRFUjhuTffZCb?=
 =?us-ascii?Q?+idfPrfpBatm+yRZLfY9YifwDuDTb5yoNboRZd30t4EOyEzdYoGFAc1PC6VA?=
 =?us-ascii?Q?QyC9HQzrxaZwfCtVv18IEskJgMiLHXnOHm8wXEH9uO3bu9DI+cNroQITPTva?=
 =?us-ascii?Q?dhV0iA3/Cb+IN/b286GeDYPaE/X0Sg96ffbWfeblIYhjoiGmMo+w4OkJHSNu?=
 =?us-ascii?Q?pP3GkRupaXEu6nRgUwagYanmyzd8dppivwm53x9AzecLYXKKJHvDZv5ODWqN?=
 =?us-ascii?Q?+W/7IeWJXjP4MyA98uLvJaKKN2eRgDnkKMvch92cR6Yis467bdM8pnfSOKYO?=
 =?us-ascii?Q?HelEkZHw5hEMIMBUiC2AoKe+PM4zqYfvk8/t0NuYJsxoyXOmtQBUPezwgy70?=
 =?us-ascii?Q?BS1uxpBNGeGyzDEg9/cALkLrO6rG2h2S0VtBiHD1VyF+6rHYBedYg2mPSlY3?=
 =?us-ascii?Q?Q0oDsOCGfW/0l2JCeGSx0e7pLO6qvylLww4CgKsu4cNyFcDJYMcCTvofBmci?=
 =?us-ascii?Q?l3R8R/5KzZJv40Sh2pLPkY/s5ozhwHQoAJd2DkA2Eprh5ID26yk5YY/LAzIE?=
 =?us-ascii?Q?/e+TNX/CCRFLJ8Mtrek8IGp31cWASziKokQcnBGpD+20AbjuIwPa/a43Jw1K?=
 =?us-ascii?Q?jTJQiDkthuDiRzHl14jhvjmoOPAPzeJ/GSFBQcO27Y21w04n9xPdNUAy0pBU?=
 =?us-ascii?Q?2/xykolBzsY0KfQ5nqTu4YJsyOYtmKVHqoiJkpdI9+Tix4pWul7LYfA+VQ0C?=
 =?us-ascii?Q?2OXUSQJANzmzQaPltG4xYuDAaWQ+sEAUzbjjHi3XIeDdFPjL5+2D7EGjwxqE?=
 =?us-ascii?Q?MwZoZismsM26RWnCf5TQ7V1PInFEKSxCwV1hVyxRm7qk0n05yQ6E2unyZJnE?=
 =?us-ascii?Q?D+hmmpQhZEDAgl7yg4lpKqMQH4oyCp60S1VJ+eXsazfpvcE1BP33ItK5MAuq?=
 =?us-ascii?Q?+R1+YOWKS9Cii++7cbZhSz+8AfOYAIELpzdib8+Oa+GrPF0ylrM58T6+wn15?=
 =?us-ascii?Q?8XW640mTzZjB7BCzqF7XpscDBRSVo1HPB05aiZV44dRkavAfZU1D+Edjkxm3?=
 =?us-ascii?Q?YrylHboUsKviF4BXPerTRq5dXNQmBE3xIJPbaeQt+vtPdyLfC60N+Zl33ZIj?=
 =?us-ascii?Q?9ySrukaZvcd4nx/32g+TQE2lc42BgSdpKN7wM0GCkKmJTR4sWbHwGxCe8xgN?=
 =?us-ascii?Q?5NZCJulSyrU1yOfQULyDp0/G6hP6AsycCTVDcBVxNLyFlyfmwaoIeJoeIy3a?=
 =?us-ascii?Q?Tk2a7SUfMbm2FCbMVziyIcbqmX+PrLF66qi0j62FlIbovgEKbeDLBbCV7zeR?=
 =?us-ascii?Q?0unskTWEB6OmKoQaD1zDvYIqoOsxihK7H7vOlpPfB2J6/37hYu9W1ah35kHM?=
 =?us-ascii?Q?NdM9Z0heU4VmWJU+pC7Bx754/FgtR+H8EXVmd1i/tyq5sMhq3BDRmp17wBRV?=
 =?us-ascii?Q?TSaBn1YiHDvUPMQ6FaDDpX5HLU2Uv9ykOaoqkflpLd4uQmII9FfFWK0ZKf/+?=
 =?us-ascii?Q?1AkX0uLf5Ajek8rP5dpyi6bNq5AcV2zXmQ3xY7lrA9CDmlrnaH0Cd4sL/36V?=
 =?us-ascii?Q?zfMaG1yQ8koOaygAwbkZgWclfC/KBYLwEfKUdyeYpQ6ADigHVG7SbWrzGct/?=
 =?us-ascii?Q?TXWfXibOoQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75cd2fec-ca2f-4022-ee7a-08d9f6e8d4a2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 16:23:31.1335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z8KH5s2EiCAuOieAay6z1JLsFKBFmqCFvCEs8oMAyGrTUKc6FzwLMqAY+jjaYzsR2t2q8FswFfppwlVUN2BsASezobU2g2XAdHeSzVzJffw=
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

Offload flow table if the action is already offloaded to hardware when
flow table uses this action.

Change meter id to type of u32 to support all the action index.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/action.c    | 58 +++++++++++++++++++
 .../net/ethernet/netronome/nfp/flower/cmsg.h  |  7 +++
 .../net/ethernet/netronome/nfp/flower/main.h  |  2 +
 .../ethernet/netronome/nfp/flower/qos_conf.c  |  2 +-
 4 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/action.c b/drivers/net/ethernet/netronome/nfp/flower/action.c
index a3242b36e216..2c40a3959f94 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/action.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
@@ -922,6 +922,51 @@ nfp_fl_pedit(const struct flow_action_entry *act,
 	}
 }
 
+static struct nfp_fl_meter *nfp_fl_meter(char *act_data)
+{
+	size_t act_size = sizeof(struct nfp_fl_meter);
+	struct nfp_fl_meter *meter_act;
+
+	meter_act = (struct nfp_fl_meter *)act_data;
+
+	memset(meter_act, 0, act_size);
+
+	meter_act->head.jump_id = NFP_FL_ACTION_OPCODE_METER;
+	meter_act->head.len_lw = act_size >> NFP_FL_LW_SIZ;
+
+	return meter_act;
+}
+
+static int
+nfp_flower_meter_action(struct nfp_app *app,
+			const struct flow_action_entry *action,
+			struct nfp_fl_payload *nfp_fl, int *a_len,
+			struct net_device *netdev,
+			struct netlink_ext_ack *extack)
+{
+	struct nfp_fl_meter *fl_meter;
+	u32 meter_id;
+
+	if (*a_len + sizeof(struct nfp_fl_meter) > NFP_FL_MAX_A_SIZ) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "unsupported offload:meter action size beyond the allowed maximum");
+		return -EOPNOTSUPP;
+	}
+
+	meter_id = action->hw_index;
+	if (!nfp_flower_search_meter_entry(app, meter_id)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "can not offload flow table with unsupported police action.\n");
+		return -EOPNOTSUPP;
+	}
+
+	fl_meter = nfp_fl_meter(&nfp_fl->action_data[*a_len]);
+	*a_len += sizeof(struct nfp_fl_meter);
+	fl_meter->meter_id = cpu_to_be32(meter_id);
+
+	return 0;
+}
+
 static int
 nfp_flower_output_action(struct nfp_app *app,
 			 const struct flow_action_entry *act,
@@ -985,6 +1030,7 @@ nfp_flower_loop_action(struct nfp_app *app, const struct flow_action_entry *act,
 		       struct nfp_flower_pedit_acts *set_act, bool *pkt_host,
 		       struct netlink_ext_ack *extack, int act_idx)
 {
+	struct nfp_flower_priv *fl_priv = app->priv;
 	struct nfp_fl_pre_tunnel *pre_tun;
 	struct nfp_fl_set_tun *set_tun;
 	struct nfp_fl_push_vlan *psh_v;
@@ -1149,6 +1195,18 @@ nfp_flower_loop_action(struct nfp_app *app, const struct flow_action_entry *act,
 
 		*pkt_host = true;
 		break;
+	case FLOW_ACTION_POLICE:
+		if (!(fl_priv->flower_ext_feats & NFP_FL_FEATS_QOS_METER)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "unsupported offload: unsupported police action in action list");
+			return -EOPNOTSUPP;
+		}
+
+		err = nfp_flower_meter_action(app, act, nfp_fl, a_len, netdev,
+					      extack);
+		if (err)
+			return err;
+		break;
 	default:
 		/* Currently we do not handle any other actions. */
 		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: unsupported action in action list");
diff --git a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
index 1543e47456d5..68e8a2fb1a29 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
@@ -85,6 +85,7 @@
 #define NFP_FL_ACTION_OPCODE_SET_TCP		15
 #define NFP_FL_ACTION_OPCODE_PRE_LAG		16
 #define NFP_FL_ACTION_OPCODE_PRE_TUNNEL		17
+#define NFP_FL_ACTION_OPCODE_METER		24
 #define NFP_FL_ACTION_OPCODE_PUSH_GENEVE	26
 #define NFP_FL_ACTION_OPCODE_NUM		32
 
@@ -260,6 +261,12 @@ struct nfp_fl_set_mpls {
 	__be32 lse;
 };
 
+struct nfp_fl_meter {
+	struct nfp_fl_act_head head;
+	__be16 reserved;
+	__be32 meter_id;
+};
+
 /* Metadata with L2 (1W/4B)
  * ----------------------------------------------------------------
  *    3                   2                   1
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index c2888a3bac9a..729f3244be04 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -613,4 +613,6 @@ int nfp_flower_setup_meter_entry(struct nfp_app *app,
 				 const struct flow_action_entry *action,
 				 enum nfp_meter_op op,
 				 u32 meter_id);
+struct nfp_meter_entry *
+nfp_flower_search_meter_entry(struct nfp_app *app, u32 meter_id);
 #endif
diff --git a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
index 286743de8ea4..6f2f3c797f1a 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
@@ -502,7 +502,7 @@ static const struct rhashtable_params stats_meter_table_params = {
 	.key_len	= sizeof(u32),
 };
 
-static struct nfp_meter_entry *
+struct nfp_meter_entry *
 nfp_flower_search_meter_entry(struct nfp_app *app, u32 meter_id)
 {
 	struct nfp_flower_priv *priv = app->priv;
-- 
2.30.2

