Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4449D633B55
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 12:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232858AbiKVL27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 06:28:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233191AbiKVL2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 06:28:33 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2114.outbound.protection.outlook.com [40.107.92.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E794764A2E
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 03:21:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SDo0KoPGBjf8RqHHMOBMeQpO6o2CMbzyrOreUM5a4Vl2cuelUK/X4X56S8p0becKhiqnMig0MLZZyZ+GlLhOBR15T4dsLtuw8me1LDdAoouFogkcm5NApXFh6fIcCu3TPZ8SlsLUfuzhVRTcFBjCQhIszLIbvNmASYaS0uTmjDXY9P1XMyZEGtnOpHRJZGJ2XKwcW/aU3+sqHoYXxG2/YwcWBsS2HzEVkGtnk6NfLUSs/X4tNJ5nxBQWl9rT/fRQvOYhkaq+6bIOoI9jM2jKFnvhrFCzb4riROxKvFGdoCcoeoZGEfTdMImHLjS8NF9B65nqurPKzGGXnyNmHn982Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oZb04XjFgvHM7lqaz3Gu72UwkOcVkyUt8QzCV62wPHI=;
 b=dRyxmpbKmdZoLjSG3zN/xreGa8qty6GUfTBtJFq/ro1skEYQDcSxCN2m1BQqpzLAAuqepr3026lRpH7CNuf3WARieNbFrP1moY8gSY16jUDULgmHFcHUtqNgHxfWAzNmanu6suIFUmhCA2i7ZX8An49HJHxNg1Z5UUWD/eovKHs46H6l5boIwGtrqAaMnwMbtOw92XqESBamWzKplWOqDlmiyHAZ1TM9qPr3PelkgfruBMtKcoGip3w7S3Z+T5iffWwCMownuiK4oAEEK7uQ9ud84wUacdcS9kz1GHsyYuVDNKlZI4MRpry81n5mbild/zuNu69vwpwi/yE3pbZ9Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oZb04XjFgvHM7lqaz3Gu72UwkOcVkyUt8QzCV62wPHI=;
 b=QpFSu2MmlNC6SbAMOpxUy5PGPfV7FHl8ao+zAkqPwp/9ZPfum0lCGrjLXoI4WUdlLIjLZLg6a0fTLi1hE+3jP76pfRlzRTIR9fUT2wpmDuUOZXX9XS6RGyjkC7lUTimiYoGWocaWj1QnW5vF0Nj6ZkiDvvA20YpdgzFCNmJL1Lo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5619.namprd13.prod.outlook.com (2603:10b6:510:139::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 11:21:48 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%8]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 11:21:48 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Edward Cree <edward.cree@amd.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Marcelo Leitner <mleitner@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Tianyu Yuan <tianyu.yuan@corigine.com>,
        Vlad Buslov <vladbu@nvidia.com>, dev@openvswitch.org,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH/RFC net-next] tc: allow drivers to accept gact with PIPE when offloading
Date:   Tue, 22 Nov 2022 12:20:20 +0100
Message-Id: <20221122112020.922691-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P192CA0012.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5619:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bbaf762-8e71-483a-d860-08dacc7bbeb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WUbkPzTy+l+ZrwscAjf5ESYa+0XDrRZLFEo0vs3CS2H8U64q91JeNIdQq8fdJpPFmZvvl2MidJKihwEFi1p3zYW3bwY49Bu4u4EJwGWzRDgq6bf+9xAvYL+nyVVf+rpYT6whOa7K/AwLzL/zLT/NKTm5zFtQi16Jezv8qlSmGYaSgXL37T4acC86VOtF4poYZPliAmN4oeziqCLy1Njb8OD/c8e1YvsgzIx7bENEExJ1AJjHWmjLC2ZlkA5TEC0eCBP4DLpzL7uaeUSKUqtHXc50KJqrXYCVCaGvZqrNDOSjVeXyCCfu5qx4RDvi64c06s8aRhRPbBIoqybLUPy0aP3dDj5y7JPqMAAjnxysEcwGN1htOaBz9JMbD8WwY8C4FRHxWlr5fHU2kYYwczxboNI+Htjfv+wBoH5Vfw9kSaeIeLEa4JwDwt6Lm/xb7oeHbBFMTVPj4iQb3Zpg784tt5R2JxKloKv4/bo5QBKFVZdNKDc4TAGc/XLGxydbm744o1/QhgXeH8tKX7uWiOcgUC45GooPQRCJeWYqj5cBo9d3N1HdgATD5Kiu4cd0Vk5NHFYzNSHD7d7gnvJZyW9OemoPMeVDy5eRS5hk/iivthj4fzFpiYJ3B3n2+Cjax5SwWh74n5bMMK3GUqqmCSHe/0QToKp/ijsjyoS1mc1ggIrtbORyddAG4KLXSsQkc2UH/afh14NaTRPg+ANOgZH2JyscPYdr0d6w6m9J2k6Ms/8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(366004)(39840400004)(136003)(451199015)(30864003)(86362001)(66556008)(36756003)(4326008)(2616005)(1076003)(41300700001)(66946007)(66476007)(186003)(5660300002)(52116002)(107886003)(8936002)(6486002)(8676002)(6666004)(7416002)(966005)(478600001)(6512007)(316002)(44832011)(6506007)(54906003)(6916009)(38100700002)(83380400001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E4KXDi5mFdlYPjw0XQJboe50cvb6dnMRreouxaa0SGji8+6N+igKWcSR5Csd?=
 =?us-ascii?Q?Qjge5dqhqRiWumlX0knDxWGgBEx1C+M5wWzkm2IxBUYjzkpWBVStXt2Kv612?=
 =?us-ascii?Q?odn+i2Ywpcld2kVVCvrNdoZsR1elJvCmxyE8kw7CfWkWmc6tfr6wB3elb31T?=
 =?us-ascii?Q?5QtXfcMzaw7+aR8bRsGW7CnT5KSSUC6gCsS7U8euYSNIV0CtARi2ELPn2TL0?=
 =?us-ascii?Q?45FFah9PxzM+ZY6t7tOXsfm5MSJ49Nepg2v6Rgi2Iu+43iVeED8HnKiTuVlv?=
 =?us-ascii?Q?BIUpH03Yi/htahICidd/EoAFsGAn95vUNX1KM1J+KpRNzm81q24SG93lwXfE?=
 =?us-ascii?Q?H05+AeDyTt69yop11mY0SLnrjjBwi+n46X8HuGe262LELxFYLGcYKuZFNn3O?=
 =?us-ascii?Q?qKj0vK4Xd/A6E3bnm98wcUAaywSNhMEwQMCA1R14ofh77zCnkUYtqUAwF632?=
 =?us-ascii?Q?0L/NxNmMeCcUUqcI51odHtcC/Lklzyh12YL8eaV/zn2nHpf9ulF+tNVxj7bv?=
 =?us-ascii?Q?YZVmSmQoq4tiQdsleAe6vUTIME7w0i09jSNJz2voecdL1Ip57zSpgYZE7mqu?=
 =?us-ascii?Q?np7xTLKhAxSKU8RC1lNiv6jlLDZGaFbr2fOYpo8Rs06i1vPL11jG1SOb6axn?=
 =?us-ascii?Q?SCTtVsUVDuqX+Re2g33ufa6vwHsSiZOd5XDtZy8ayLQCgTQPwIGWB/SOlh+o?=
 =?us-ascii?Q?T5hxYUy/hS6+Q7/Up8HuXL5tu+BV4JLr53ZFT0RSaCOvzfnan25l9IJPWsoT?=
 =?us-ascii?Q?gNkR2bxaUXnATi6aXK/dBWu3wrvM5MdkO+4UA2/nsbYnj6qx5sRxjSyUGsOy?=
 =?us-ascii?Q?sgQvaEqgp/2YAfXpfg5htLmWnsk59Afs04iWAMwhprzr7KPE+Lf1CIy83ObQ?=
 =?us-ascii?Q?jiECIXJ2PSzNtzkezQYAq0X/nrajew1dB+zSBrJZoP+dO1OEXGI2aISMQeAv?=
 =?us-ascii?Q?L42BeFafUmvJ163K7metflgZV2AmEY0be+WwFGLh05Y0I6xXAnVTMkEpQ6rU?=
 =?us-ascii?Q?04QfzSd4mna7Tr6MqmB/rgOJH+pBbFMUD+3nH32bRwdkj4ifI40osbsNhKj3?=
 =?us-ascii?Q?WwlaARGklZyW23WmEtplOt36JF61FMOiiHFLG6SrDi3/wll0bjCDxOTg6VWR?=
 =?us-ascii?Q?nx1JpvPKulV7g14ii8IIMOkZNqIescx4sWF8ztWUBPFyXYgXW3mJw8nrTKLY?=
 =?us-ascii?Q?jTtYOdYeF9YN7qCW0cNyH91q/CrGh79GzmYr71fKaOwr8kc145gnenEL6Zqe?=
 =?us-ascii?Q?i0BUzw+4LVd5T0OZd8erJ3fQUbcKQrnPgwD/eS3siHYERWFwIsArSvMmg55h?=
 =?us-ascii?Q?jwYTUgctIi9cM38MCyetaXdtWuQSk5hdyDSsWs4gcSv76vP+C6NZSBiAlcLV?=
 =?us-ascii?Q?PO7tt9NbbssTXeYWeVi6DI7Yz60WUe7L5uw/BWpMUtiVAJbL7cFd1Tf4L/Am?=
 =?us-ascii?Q?sGUV9b4YnUh1Z9fKK8KC7QdF8BUbXhVT/SYhHYBdSQQMsRZ5PUFiR+u7wa1E?=
 =?us-ascii?Q?2T8QapUUFb33I2+xLRaG+aj5tvfPVHtIVRAjJW2bV21KlqaFk4xVJWjpusyO?=
 =?us-ascii?Q?jGvt9L8teIq38HfKxKx4V9/aCd9l9jZIN38Oi1EG3r2zInpjntkE2pPhe6mp?=
 =?us-ascii?Q?XTcvqauAiLgnupCb+prj7iaQ4x5XFSjMgj1ixOFYDa2Zxb1QWYrqcZqqSyB9?=
 =?us-ascii?Q?B0fnpw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bbaf762-8e71-483a-d860-08dacc7bbeb6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 11:21:48.0294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xlmP1ufP41Gc/SG03LlPQ3rFzpLaqh+XCgL8Z5iBPhMbTumxGbN1NDK5Zbli3/DL0Xt2uIUVYJXWaTzqmijE/hjQMzxOvbbcI88Z5Y+lMVs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5619
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Yuan <tianyu.yuan@corigine.com>

Support gact with PIPE action when setting up gact in TC.
This PIPE gact could come first in each tc filter to update
the filter(flow) stats.

The stats for each actons in a filter are updated by the
flower stats from HW(via netdev drivers) in kernel TC rather
than drivers.

In each netdev driver, we don't have to process this gact, but
only to ignore it to make sure the whole rule can be offloaded.

Background:

This is a proposed solution to a problem with a miss-match between TC
police action instances - which may be shared between flows - and OpenFlow
meter actions - the action is per flow, while the underlying meter may be
shared. The key problem being that the police action statistics are shared
between flows, and this does not match the requirement of OpenFlow for
per-flow statistics.

Ref: [ovs-dev] [PATCH] tests: fix reference output for meter offload stats
     https://mail.openvswitch.org/pipermail/ovs-dev/2022-October/398363.html

Signed-off-by: Tianyu Yuan <tianyu.yuan@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c                     | 5 +++++
 drivers/net/dsa/sja1105/sja1105_flower.c                   | 5 +++++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c       | 5 +++++
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c | 6 ++++++
 drivers/net/ethernet/intel/ice/ice_tc_lib.c                | 5 +++++
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c       | 5 +++++
 drivers/net/ethernet/marvell/prestera/prestera_flower.c    | 5 +++++
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c            | 5 +++++
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c        | 6 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c            | 5 +++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c      | 5 +++++
 drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c   | 4 ++++
 drivers/net/ethernet/mscc/ocelot_flower.c                  | 5 +++++
 drivers/net/ethernet/netronome/nfp/flower/action.c         | 5 +++++
 drivers/net/ethernet/qlogic/qede/qede_filter.c             | 5 +++++
 drivers/net/ethernet/sfc/tc.c                              | 5 +++++
 drivers/net/ethernet/ti/cpsw_priv.c                        | 5 +++++
 net/sched/act_gact.c                                       | 7 ++++---
 18 files changed, 90 insertions(+), 3 deletions(-)


diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index b0ae8d6156f6..e54eb8e28386 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -2217,6 +2217,11 @@ static int vsc9959_psfp_filter_add(struct ocelot *ocelot, int port,
 			sfi.fmid = index;
 			sfi.maxsdu = a->police.mtu;
 			break;
+		/* Just ignore GACT with pipe action to let this action count the packets.
+		 * The NIC doesn't have to process this action
+		 */
+		case FLOW_ACTION_PIPE:
+			break;
 		default:
 			mutex_unlock(&psfp->lock);
 			return -EOPNOTSUPP;
diff --git a/drivers/net/dsa/sja1105/sja1105_flower.c b/drivers/net/dsa/sja1105/sja1105_flower.c
index fad5afe3819c..d3eeeeea152a 100644
--- a/drivers/net/dsa/sja1105/sja1105_flower.c
+++ b/drivers/net/dsa/sja1105/sja1105_flower.c
@@ -426,6 +426,11 @@ int sja1105_cls_flower_add(struct dsa_switch *ds, int port,
 			if (rc)
 				goto out;
 			break;
+		/* Just ignore GACT with pipe action to let this action count the packets.
+		 * The NIC doesn't have to process this action
+		 */
+		case FLOW_ACTION_PIPE:
+			break;
 		default:
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Action not supported");
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index dd9be229819a..443f405c0ed4 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -770,6 +770,11 @@ int cxgb4_validate_flow_actions(struct net_device *dev,
 		case FLOW_ACTION_QUEUE:
 			/* Do nothing. cxgb4_set_filter will validate */
 			break;
+		/* Just ignore GACT with pipe action to let this action count the packets.
+		 * The NIC doesn't have to process this action
+		 */
+		case FLOW_ACTION_PIPE:
+			break;
 		default:
 			netdev_err(dev, "%s: Unsupported action\n", __func__);
 			return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
index cacd454ac696..cfbf2f76e83a 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
@@ -378,6 +378,11 @@ static int dpaa2_switch_tc_parse_action_acl(struct ethsw_core *ethsw,
 	case FLOW_ACTION_DROP:
 		dpsw_act->action = DPSW_ACL_ACTION_DROP;
 		break;
+	/* Just ignore GACT with pipe action to let this action count the packets.
+	 * The NIC doesn't have to process this action
+	 */
+	case FLOW_ACTION_PIPE:
+		break;
 	default:
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Action not supported");
@@ -651,6 +656,7 @@ int dpaa2_switch_cls_flower_replace(struct dpaa2_switch_filter_block *block,
 	case FLOW_ACTION_REDIRECT:
 	case FLOW_ACTION_TRAP:
 	case FLOW_ACTION_DROP:
+	case FLOW_ACTION_PIPE:
 		return dpaa2_switch_cls_flower_replace_acl(block, cls);
 	case FLOW_ACTION_MIRRED:
 		return dpaa2_switch_cls_flower_replace_mirror(block, cls);
diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index faba0f857cd9..5908ad4d0170 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -642,6 +642,11 @@ ice_eswitch_tc_parse_action(struct ice_tc_flower_fltr *fltr,
 
 		break;
 
+	/* Just ignore GACT with pipe action to let this action count the packets.
+	 * The NIC doesn't have to process this action
+	 */
+	case FLOW_ACTION_PIPE:
+		break;
 	default:
 		NL_SET_ERR_MSG_MOD(fltr->extack, "Unsupported action in switchdev mode");
 		return -EINVAL;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index e64318c110fd..fc05897adb70 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -450,6 +450,11 @@ static int otx2_tc_parse_actions(struct otx2_nic *nic,
 		case FLOW_ACTION_MARK:
 			mark = act->mark;
 			break;
+		/* Just ignore GACT with pipe action to let this action count the packets.
+		 * The NIC doesn't have to process this action
+		 */
+		case FLOW_ACTION_PIPE:
+			break;
 		default:
 			return -EOPNOTSUPP;
 		}
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flower.c b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
index 91a478b75cbf..9686ed086e35 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flower.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
@@ -126,6 +126,11 @@ static int prestera_flower_parse_actions(struct prestera_flow_block *block,
 			if (err)
 				return err;
 			break;
+		/* Just ignore GACT with pipe action to let this action count the packets.
+		 * The NIC doesn't have to process this action
+		 */
+		case FLOW_ACTION_PIPE:
+			break;
 		default:
 			NL_SET_ERR_MSG_MOD(extack, "Unsupported action");
 			pr_err("Unsupported action\n");
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index 81afd5ee3fbf..91e4d3fcc756 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -344,6 +344,11 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
 			data.pppoe.sid = act->pppoe.sid;
 			data.pppoe.num++;
 			break;
+		/* Just ignore GACT with pipe action to let this action count the packets.
+		 * The NIC doesn't have to process this action
+		 */
+		case FLOW_ACTION_PIPE:
+			break;
 		default:
 			return -EOPNOTSUPP;
 		}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index b08339d986d5..231660cb1daf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -544,6 +544,12 @@ mlx5e_rep_indr_replace_act(struct mlx5e_rep_priv *rpriv,
 		if (!act->offload_action)
 			continue;
 
+		/* Just ignore GACT with pipe action to let this action count the packets.
+		 * The NIC doesn't have to process this action
+		 */
+		if (action->id == FLOW_ACTION_PIPE)
+			continue;
+
 		if (!act->offload_action(priv, fl_act, action))
 			add = true;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 3782f0097292..adac2ce9b24f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3853,6 +3853,11 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 
 	flow_action_for_each(i, _act, &flow_action_reorder) {
 		act = *_act;
+		/* Just ignore GACT with pipe action to let this action count the packets.
+		 * The NIC doesn't have to process this action
+		 */
+		if (act->id == FLOW_ACTION_PIPE)
+			continue;
 		tc_act = mlx5e_tc_act_get(act->id, ns_type);
 		if (!tc_act) {
 			NL_SET_ERR_MSG_MOD(extack, "Not implemented offload action");
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index e91fb205e0b4..9270bf9581c7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -266,6 +266,11 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 				return err;
 			break;
 			}
+		/* Just ignore GACT with pipe action to let this action count the packets.
+		 * The NIC doesn't have to process this action
+		 */
+		case FLOW_ACTION_PIPE:
+			break;
 		default:
 			NL_SET_ERR_MSG_MOD(extack, "Unsupported action");
 			dev_err(mlxsw_sp->bus_info->dev, "Unsupported action\n");
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
index bd6bd380ba34..e32f5b5d1e95 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
@@ -692,6 +692,10 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
 			break;
 		case FLOW_ACTION_GOTO:
 			/* Links between VCAPs will be added later */
+		/* Just ignore GACT with pipe action to let this action count the packets.
+		 * The NIC doesn't have to process this action
+		 */
+		case FLOW_ACTION_PIPE:
 			break;
 		default:
 			NL_SET_ERR_MSG_MOD(fco->common.extack,
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 7c0897e779dc..b8e01af0fb48 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -492,6 +492,11 @@ static int ocelot_flower_parse_action(struct ocelot *ocelot, int port,
 			}
 			filter->type = OCELOT_PSFP_FILTER_OFFLOAD;
 			break;
+		/* Just ignore GACT with pipe action to let this action count the packets.
+		 * The NIC doesn't have to process this action
+		 */
+		case FLOW_ACTION_PIPE:
+			break;
 		default:
 			NL_SET_ERR_MSG_MOD(extack, "Cannot offload action");
 			return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/action.c b/drivers/net/ethernet/netronome/nfp/flower/action.c
index 2b383d92d7f5..57fd83b8e54a 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/action.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
@@ -1209,6 +1209,11 @@ nfp_flower_loop_action(struct nfp_app *app, const struct flow_action_entry *act,
 		if (err)
 			return err;
 		break;
+	/* Just ignore GACT with pipe action to let this action count the packets.
+	 * The NIC doesn't have to process this action
+	 */
+	case FLOW_ACTION_PIPE:
+		break;
 	default:
 		/* Currently we do not handle any other actions. */
 		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: unsupported action in action list");
diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index 3010833ddde3..69110d5978d8 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -1691,6 +1691,11 @@ static int qede_parse_actions(struct qede_dev *edev,
 				return -EINVAL;
 			}
 			break;
+		/* Just ignore GACT with pipe action to let this action count the packets.
+		 * The NIC doesn't have to process this action
+		 */
+		case FLOW_ACTION_PIPE:
+			break;
 		default:
 			return -EINVAL;
 		}
diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index deeaab9ee761..7256bbcdcc59 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -494,6 +494,11 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
 			}
 			*act = save;
 			break;
+		/* Just ignore GACT with pipe action to let this action count the packets.
+		 * The NIC doesn't have to process this action
+		 */
+		case FLOW_ACTION_PIPE:
+			break;
 		default:
 			NL_SET_ERR_MSG_FMT_MOD(extack, "Unhandled action %u",
 					       fa->id);
diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index 758295c898ac..c0ac58db64d4 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -1492,6 +1492,11 @@ static int cpsw_qos_configure_clsflower(struct cpsw_priv *priv, struct flow_cls_
 
 			return cpsw_qos_clsflower_add_policer(priv, extack, cls,
 							      act->police.rate_pkt_ps);
+		/* Just ignore GACT with pipe action to let this action count the packets.
+		 * The NIC doesn't have to process this action
+		 */
+		case FLOW_ACTION_PIPE:
+			break;
 		default:
 			NL_SET_ERR_MSG_MOD(extack, "Action not supported");
 			return -EOPNOTSUPP;
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index 62d682b96b88..82d1371e251e 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -250,15 +250,14 @@ static int tcf_gact_offload_act_setup(struct tc_action *act, void *entry_data,
 		} else if (is_tcf_gact_goto_chain(act)) {
 			entry->id = FLOW_ACTION_GOTO;
 			entry->chain_index = tcf_gact_goto_chain_index(act);
+		} else if (is_tcf_gact_pipe(act)) {
+			entry->id = FLOW_ACTION_PIPE;
 		} else if (is_tcf_gact_continue(act)) {
 			NL_SET_ERR_MSG_MOD(extack, "Offload of \"continue\" action is not supported");
 			return -EOPNOTSUPP;
 		} else if (is_tcf_gact_reclassify(act)) {
 			NL_SET_ERR_MSG_MOD(extack, "Offload of \"reclassify\" action is not supported");
 			return -EOPNOTSUPP;
-		} else if (is_tcf_gact_pipe(act)) {
-			NL_SET_ERR_MSG_MOD(extack, "Offload of \"pipe\" action is not supported");
-			return -EOPNOTSUPP;
 		} else {
 			NL_SET_ERR_MSG_MOD(extack, "Unsupported generic action offload");
 			return -EOPNOTSUPP;
@@ -275,6 +274,8 @@ static int tcf_gact_offload_act_setup(struct tc_action *act, void *entry_data,
 			fl_action->id = FLOW_ACTION_TRAP;
 		else if (is_tcf_gact_goto_chain(act))
 			fl_action->id = FLOW_ACTION_GOTO;
+		else if (is_tcf_gact_pipe(act))
+			fl_action->id = FLOW_ACTION_PIPE;
 		else
 			return -EOPNOTSUPP;
 	}
-- 
2.30.2

