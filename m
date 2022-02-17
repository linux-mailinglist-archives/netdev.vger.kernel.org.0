Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55274B9DCE
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 11:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238788AbiBQK5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 05:57:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238015AbiBQK5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 05:57:36 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2125.outbound.protection.outlook.com [40.107.100.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8882FD30
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 02:57:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JDQfi519jJ9+yj1MkP7Nw0nQ6MLf8Sscw2tsV/NA1DX4EPuwqzNUmyNDoR1D7HIkJI6QSLK6lNlVupO9IPloTmCzH6XwWiR3qxFDYMDApY0+WB4/XdX6hAY1xxCUh/9g7O15BaJZs2RoDrjPd7IKJ/MNfdv/2TC5dF0zPnubc5N2IboLScePLryv8Z6OKcAKO8qUU5FdFCXfaymZQ+HWUlNVPJ2c+RfStJXAzxNb5I4sUdgRHR5pTt5UhMwk8cBOnwFPjWlQxiWYymrBg0DxOCMXEun4tpAi1VBqwPU2PeTyM5r5Ay0Hx9oSIC2Mscd3MjBDsejrmb4KCFc2E0tXmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lTdIP6ktfTVFkKhf7Q4a4/l4vYKB6cR7W+WleDBvteo=;
 b=K/nhDiApVHArqK34rv0ll7Kpyv4goDE6KIEgvy6NObREKNdjNmr1RRlBoz/02ljk8W2iQIa/Jw4utBmVAYBP7fRFJJKSBaDcBg1TWXOAODKVXI0VCf7vQGwU8HtYe8CLReu7XNm8DajIe4ovdfinMYW56uvdLY/RhwQph9OkPsU0qBq46DoSYtY+1iRwC4WH0xxVgUyuwPkAnj7JhH+/CIOJ8jhG/cA/osf0iI+eV5TWGWYjwVSWYPJ6bPYIB37cjPzO/8R4fOQLn1ePd3hQHaFlLA2vgV9tRsQqBJJdOf3Ztu0DOgWQBfUjUTmbKeAzclW+JVlNi48agzuEI9PBdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lTdIP6ktfTVFkKhf7Q4a4/l4vYKB6cR7W+WleDBvteo=;
 b=WSQa7EPyx/RzRPshCgT5jjxjqywfaEUoT4h1a24xfk4r/ImaH/t7mduI9UIzPnspaftjIdA6aie3AivuTiM80wjZUUFDq/YuPre5OUjyuaijXMy6ttO+dyB6MEZFksvAjW5oH9zSbVKo5FldHQjtCqQbHLBvNHHnrgt5erhFNFI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CY4PR13MB1397.namprd13.prod.outlook.com (2603:10b6:903:136::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Thu, 17 Feb
 2022 10:57:20 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d%7]) with mapi id 15.20.4995.015; Thu, 17 Feb 2022
 10:57:20 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 5/6] nfp: add support to offload police action from flower table
Date:   Thu, 17 Feb 2022 11:56:51 +0100
Message-Id: <20220217105652.14451-6-simon.horman@corigine.com>
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
X-MS-Office365-Filtering-Correlation-Id: 12a152ee-521f-4420-16cf-08d9f20444ed
X-MS-TrafficTypeDiagnostic: CY4PR13MB1397:EE_
X-Microsoft-Antispam-PRVS: <CY4PR13MB1397BAE9C7BB27BD2E265E20E8369@CY4PR13MB1397.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: prwyhn7k2Mv5cq1INwxle6YMQETjWWDKfL/mw8Eq/uaq2PqDXd7fi6h6SLGnP3/zFmh3t++3tH7BzQOqETKKr55982iOmukdwwRnW0cJdAsmgew3rd7+vN6MSvVIeyIswjb9kpQU4EJmSvXypLMdokeFHeFM1C5GyBdCmPsoMS9gPaRrYcdlYRhlmoFpiC4fi2PjbGDUSBwGiu97cra42Gl2GcTyF+EYdbFRWSAg5qxhhnXWuAYE7GEBes9CBOX+z5RrJP2Cse3+T0Np2O2X590TpBVYQ6CDf5L6IAMtHGYcsBefquIhsKoHVPdG19SSjkPK6gILXO/1Op0UY+I4VgsXlF5O+LXeNhoKID3Mx9yBGHitnxn+k8MOe1v1zqcThOmJHqW+vInKe7j1Vjlm0p8Iq+f3ppTMcq0fvp+gwgjLao9mypPoY7lhOmkAP7CItcTqbJpjCByvNYR7YH00CNyciidUM7kWBWIDhol5Mprn5eBFsCdvy1TE8rEy//JtO1okGMn/9hA3qBOcXHTsrZ7T8gGkIrIFsPaL2OT4y2Ozwga6C1z2MBRA9HGb3Q9Xt9WGlomFkowLIcaizwgtakFeAJDJwNOdp6+ejsjGgGYi5Osx9lcX7S7kIYvWDJABnhDspEnSysXN3RO7VzwBhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(39840400004)(136003)(396003)(376002)(366004)(8676002)(66476007)(316002)(1076003)(6666004)(6506007)(2616005)(54906003)(186003)(52116002)(38100700002)(6512007)(66946007)(66556008)(4326008)(86362001)(110136005)(6486002)(83380400001)(508600001)(107886003)(44832011)(36756003)(2906002)(5660300002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NLITpGWfM7vKooEeb5X4VGZjoFxyvGOvaZhiysVzLxf2XFGRBUutFFJyvBhy?=
 =?us-ascii?Q?xllzsUr9kwqKlDrzujklYOrs0I24KVFiTwA8gtIXj0uX/VUBexQlPzXpqGqV?=
 =?us-ascii?Q?RoucfB8TeIqWXOS3c1ihwYs/kdS+dJ7KYUWoNU75hNqH8iEfUuIg0+pRITzV?=
 =?us-ascii?Q?c0OMKR4dC5SRqAA+cWTyGpL/90naixmNYdR1mT8Gx5AdKOG4vWGI5DpTWnGH?=
 =?us-ascii?Q?Hko/t5C+1IvkKAjb9XYMqFTGTis/LniHmsRQect9111gq3AGUfGsflw+dzmD?=
 =?us-ascii?Q?SqssMbGcrN06KvYdGW9igrnV3I4e48OUuDto6MFOaLw3rcpJR3rLSnhPZ2TV?=
 =?us-ascii?Q?B8MutpM7VjakmnuQAkFLPgy1SIv0udtj5e8W8Fjvd1wnz1KmRhot/+5kC53Z?=
 =?us-ascii?Q?FN5Ay3XN3R0oT09nFVEZE7dAfwjtTx6FVnlQsQKQGwTNFlw+JgJ6sqJh288m?=
 =?us-ascii?Q?2XDbMc5IfxLD/O4Ql+Wnr8mXTjG8bhcwJgHk637Pxp1LEMiTuHo1rZPE0qoz?=
 =?us-ascii?Q?HJxPHeOTWRvXIK2abdEvENEUB5lH1oKlbY9oxRoqtwJmTdY/lk0jOSRPOc1o?=
 =?us-ascii?Q?KVcqP0xTNOCCUHhQPAOQJ2KFlS840+CtloRxH6R32gm2Qcxgkx9+nB2IyMTN?=
 =?us-ascii?Q?2kNC0e2eI274Ah2EgMXfeVLaUhOQNDq6EmSKy5sRPfN9EeeWPsmvsDR8olCY?=
 =?us-ascii?Q?zBQIno4Vnzg281s57I+ZzESqQ0yn3Il74JPR/MgA7VRvpqBEsdDOp+vwYL/c?=
 =?us-ascii?Q?R2bPvAzRMsbViYXiZqEf8eHHJjmaQvFd5D7dMDl7b4D84RGU3s0XfGzFKfa+?=
 =?us-ascii?Q?E1PhKo4MEMtzErwX7acwsXm3slLOQCT8PyVNQ7vb9BFzfI5d6Te2r6Vg3caE?=
 =?us-ascii?Q?sksUnOS9aoNe/ddZoc6KmaDgDHjSySc1nUgYlLBiIVrS/r6GsqI5ZuzcaZyT?=
 =?us-ascii?Q?aRpbKFsjPYwynt10uIO08oIdg5fpNhl3X0dNGzBFHzm/HTnpUEbdaO4sbhm/?=
 =?us-ascii?Q?nRVxC1p2RtLK6LrAmLTlo4QAtVQvk0YE5Td4GRft+RsZeoxGG5Fjl1+YGWJ3?=
 =?us-ascii?Q?zdZ0SB1qv2L0qyLVgVPzConIuPwbEKIUOu+PxuGyZg5G3jrlE4xT9QXoNv/A?=
 =?us-ascii?Q?qi1k2Tby5U7qgPfyE+iEx/KLHebshxRK6tycm70rDRkfrCk6p6sG7NQouYv5?=
 =?us-ascii?Q?2QJkF8IgXMU0fPzMdVg16WiqoplwrRYTWHLSUy/RDH8CX9+FXo5Qkcq9Pp/M?=
 =?us-ascii?Q?q7ouqOz9uLRXYUqom0p4Wx1bX78udYjAfw3KlBLS+IyHpfxACE+nnsKTpPzI?=
 =?us-ascii?Q?MWJz7Vekpqmoy+dBvj+6hxcYT7KypXGg0XZitZ9w1kgocE2sAP2AZILM+Gy6?=
 =?us-ascii?Q?JRSvzUpfjHasIRqNUhS1riN5kNJXYESGlBoA+jyS4PHMCShd7kaySxneVzID?=
 =?us-ascii?Q?Evj8QnzqMvJ8rqysQTOS2gCJTwQD5l6LCZJSmdJCICRlMVcLlno7nxaC0McY?=
 =?us-ascii?Q?ws+r56gbeXV82f2Z+CRhiZ4TsUrlBRjLZG+c9lkFdo13fGUO7Wnp7/i9sJvs?=
 =?us-ascii?Q?HhTJy4niqRqIRp+RvjT1D4uhWiEMEOpYaTzUzPo9sPuo2Sh/fg5ypL/G4l+w?=
 =?us-ascii?Q?EbsQBA99hKznEK/LcsrUBhblaaVW/8HrTVyO4DlYN2YkVgJ0HQ+KyFipHo+k?=
 =?us-ascii?Q?2rViOzwCK0RftEAtBUlWSYgLf2nvcPZ5JLOWks+YzCF/5x73uH+8nZ0kha8r?=
 =?us-ascii?Q?HPFYAbBK+s+sPQgTtQ5aTLarwSvxzZI=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12a152ee-521f-4420-16cf-08d9f20444ed
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 10:57:20.0752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lFVPxQ6m5zEVn67gbCu0a19DqnGhGdQA2HwhUYy+BGIZhPRzc6kqjDfjyU/GTKwD+lmVG7lXM9mi0p7EZbsJgyFB+Cgrw/kpdnlDTnMTjEs=
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
index 784292b16290..4518ee90afef 100644
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
index 73bb76a938a2..898abb68b80b 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -614,4 +614,6 @@ int nfp_flower_setup_meter_entry(struct nfp_app *app,
 				 const struct flow_action_entry *action,
 				 enum nfp_meter_op op,
 				 u32 meter_id);
+struct nfp_meter_entry *
+nfp_flower_search_meter_entry(struct nfp_app *app, u32 meter_id);
 #endif
diff --git a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
index 632513b4f121..6da24c457ab3 100644
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
2.20.1

