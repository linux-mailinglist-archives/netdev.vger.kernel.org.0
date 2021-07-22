Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEDB3D1F86
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 09:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbhGVHSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 03:18:13 -0400
Received: from mail-sn1anam02on2093.outbound.protection.outlook.com ([40.107.96.93]:59110
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231237AbhGVHSL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 03:18:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ApOsc4soMI3jCVFUqFmg+2RJ8tBV9vXYRVjeyCKwvHGeoStTEcu/3IW3b+7OUMxyvAmx9sHhtbSo97OI+I8rl9tMCYcs7ssG7d2bUkUQWjQY83w7btyynW5poP6gUr5uRtz5RM491K5h09t3V2LaopLVEBsf0d94a2jaMvZ+zLtIk5Ue+/9PQ4LWDbWCE4yzpAPKbj61/HNDJwl3uWhUhQhYri1+RoWaeHB4lDwxdS59TT+bIX3LKNbR6EvuU3HGGyIDA7WK1+yaqwVGSs73JoaZEz2IdGc1Z9mM+YKBmDXG/xyUPlgcwf47C4DszqY6AjISMUnHQETHQBcNr5TLnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=trYWb5VjcpTu8pmrejUxW7d92FYCKYAgeZrnLAxI61Y=;
 b=NatUcqwA/4h84f+i79ZWGlCflZqjAOHaxnIUSWeS/s4zj7CASlUR7pgRs8KyPqa6Nk2rpDNR+cxivX34BCOB5iGT4W6nY5f9XT3YgaHgJkyoIxCgiCn3CKEEau+rtg3OouSttT9k4z71dLOu4vD5tegkBefZUg5iIq77LDis7bOqmvlMnTjTMT/akqnF9H4Jdbz/08Y6dZk92+S0zDWFw7ltfPHOtHNvrVdZesFV2u7pppV/ohV4Ibfu1Dgs2OM6I78w1peUq/cwdVCZ3MrqMeLnhzNt6GXggWAWYOz04XKsONCptOvfMbFpeWQn9GmqrOwyarNElnfVOR4xdjIwrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=trYWb5VjcpTu8pmrejUxW7d92FYCKYAgeZrnLAxI61Y=;
 b=EA/J72vQaE2jyikT2BxjUPlkHn99rofJ3m6qKHqLAipXUsb4Uonxxzs61T8A3ow2Df3rZwHp4pOcszzc0Z0B+VembXW+CT0fghLk2PgIOfDdrD8BaMR9+TjQYS5zvG1BRhLQpH24/pZc4+7D7+r7+9KJeKuhbWm1fOphoUQ7APM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4778.namprd13.prod.outlook.com (2603:10b6:510:76::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24; Thu, 22 Jul
 2021 07:58:38 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%7]) with mapi id 15.20.4352.024; Thu, 22 Jul 2021
 07:58:38 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 6/9] nfp: flower-ct: add actions into flow_pay for offload
Date:   Thu, 22 Jul 2021 09:58:05 +0200
Message-Id: <20210722075808.10095-7-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210722075808.10095-1-simon.horman@corigine.com>
References: <20210722075808.10095-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0136.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::41) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM0PR06CA0136.eurprd06.prod.outlook.com (2603:10a6:208:ab::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 07:58:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01ac2ed9-f60b-4c36-44e3-08d94ce68363
X-MS-TrafficTypeDiagnostic: PH0PR13MB4778:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4778D6438D3C06FCBFA4302DE8E49@PH0PR13MB4778.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zDpy9T6M9Jn1a5Dg9zDwuhVNL3LFb9c1ll4QYuqQ+zbuXnmMf1vkXVed2rYfdS450d4quJX/DWW8C+5FhIFvStFcHqaZa8OW7lOUeefqIRzPGt1vRtXi5n+m1SahkaB69vi2G8GObKZdAgYhqhyp5ywG7jYPT29hyQSNbq/1qnFwtRVo+Q61aS8eoPGUfhio9N82u5RcvLxmdkCIwA3Ls5o1f9r6K4ujxc2TEX81B1QKqp3lD10ZhGbRnF7QP4P2JE4sfjdObRRwSaVOjg/NRoFK+/mQbYwr11lFL0Mes6n1DAVRkk6uZTolLN+hb3TP/UvMMZiSFkzK88R5aKb5LRraGftQaPWF1ODuWzOxlF1R+an1VE0KPGokpQsPEHbDLFmu+nZ7VX9xydPxVBkufSyntm78xJTAJf75l63wK/fTaQcJ/dtIJ3vkTmi3B4CBzFWskDp5987cSWcOJ/gxShav/tuHvkZTpnF/cg3nG1/kceJuk6QLsdG2u8r5L58PO1JEApQz8i4OaXlw7srWChLjugcBux6tYpxaxpZVu0jxlfV+aV0Isc7/8+ozZLOmpaWy0GirukZn1Y/vCaMwO9Bl8XvXHTthUa6sKVO719YH6Hhb6s0mXREx6ZMWAFoYjKZf2PgyBVPEbQ6hyevw1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(396003)(366004)(39830400003)(44832011)(2616005)(36756003)(66476007)(8936002)(66556008)(8676002)(5660300002)(54906003)(6486002)(107886003)(186003)(38100700002)(6666004)(478600001)(2906002)(66946007)(6512007)(52116002)(1076003)(6506007)(110136005)(83380400001)(86362001)(4326008)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H3MG51hKVaDV1/2dOQj08fCLzUwtNbd2S1P2jsc0ZXF3d1zkWXQa359m1ffB?=
 =?us-ascii?Q?gGzk3GswGQRF5qjNbF9HRtPwHzI9wd8WoQZD7budgIsS07NesH915HWNAwa4?=
 =?us-ascii?Q?J7u+cz+6uF+CP+5/WefrnPUwKWFiUpQj9cXPplE59nEkwAipIOlPMXOfNhIv?=
 =?us-ascii?Q?wFgEvIs2RWK4JV/Bsoje9lOd9x8uq9hep0o8TqqNEpPxvIsUOk6LBWqIq7tJ?=
 =?us-ascii?Q?zrs0nJaRTayUTe0lwGLQ7rxqvAeQW3kkV/idzdxgHAAoPYep94z/J1KvVEQy?=
 =?us-ascii?Q?WIp+HV1dnAc81q52Uf2EwVmw0Us9idRRk+p2eqQKhjj7eYrj7410eenikIAM?=
 =?us-ascii?Q?thsW/ejDbS59Th58/sug3aoMIk7D6xIBGyrhMFlcnFYXYborrmDM/xc90yc9?=
 =?us-ascii?Q?1cmef8WC/cpvBoOfUPMIJ+yjYeTAldgdEBaPkpU6rAFPwoRrbghApFT15em3?=
 =?us-ascii?Q?6KqfUGrnZluzphUkNcN+mUCrXtDDjf2sMKkjv0qQqADQ5Vt8mXOC1HTdLynB?=
 =?us-ascii?Q?o6k/X5NF/RKfhz4miZw0E2dFDEyBUos+Frms0PYUNmx2XA8h+lRNautXtZ3V?=
 =?us-ascii?Q?uK3u87WDJi9v/3tF1QKvjWQ3TjGWHPAUz9cwGJ3X9F7xAyFBXwPtbOHuv6ej?=
 =?us-ascii?Q?tIj/s0ve1ySttkD9ieokt/d+hv/uhWI3zaP10MHcrHXaNzQ9KomVo0HqIZ8I?=
 =?us-ascii?Q?LT/WaNWYJgS6tqX135m5mcUH3gISFUmDSfeudF2nEnJXPPUo87RvNd/IONaj?=
 =?us-ascii?Q?jQUOxmN1fAFx2naQeYmqtOC0835BR/XLkpcHWk17eGrq8tQLuqdHWTUs+T91?=
 =?us-ascii?Q?9QJF/A3bRqN8gODkwzGAEwnGpjFseklHvpOexZz+SYgFl2ymTO94oZeyjjgR?=
 =?us-ascii?Q?nr+UBdev7CKyY9AOJ2KHvs+906TT9bxOOZpvPPgDEV8uJewe3csP26WuGGoO?=
 =?us-ascii?Q?YgsSqEi3I5lj2+nAF3CTyyi2udkfygfElTdXtQA0rx+LoRDEvYJ7XhugbKxA?=
 =?us-ascii?Q?FKCqz5kA04bNb/w0dyMmMIPIao837+T8lsEOZ8NTldH6P23MQyoJI/DRtXaD?=
 =?us-ascii?Q?Fm3GYuJV1aJAAfNjCuosuXTsOp8hesHBP/Ohyihd0qna9lTCCdMlC8yM6VT2?=
 =?us-ascii?Q?92t7k3KHMKcGUE+oW1bfQJIBYqaCih/Jvk7QUaKz1cPy5+Ir5y1jFW5zYdVe?=
 =?us-ascii?Q?XRTsLPwzD9tNLsShA4y/xTuzbXFP/A7W7p2B582dCHlywGaC3/VW0zkW1h15?=
 =?us-ascii?Q?RpZzwrbJfTqEgIsKEdTevSuGombVpfi10jpIZHibRdsXdb38+lAm6OZrvs0Y?=
 =?us-ascii?Q?joi0XpnEIUxBPS9H3LN6dilUmAEmP8DXJepfCl5xKqbZkgtGVOozytQskEFO?=
 =?us-ascii?Q?ll9aDC3JkHp4zSGfbTDtxtLehsZg?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01ac2ed9-f60b-4c36-44e3-08d94ce68363
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 07:58:38.1051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EQs6eZKd3FeidCX1k8xSldLzaYoI/Hkv2oISBEWuVxJafYpX2CsLgCY4QZnlf2rJvs8d2MbjipIDUbg3EwCIRBd7G+DoVv4GT06v6cEq7Mw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4778
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

Combine the actions from the three different rules into one and
convert into the payload format expected by the nfp.

Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/conntrack.c | 72 +++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index e057403c1a8f..41b1f9773d46 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -471,6 +471,73 @@ nfp_fl_calc_key_layers_sz(struct nfp_fl_key_ls in_key_ls, uint16_t *map)
 	return key_size;
 }
 
+static int nfp_fl_merge_actions_offload(struct flow_rule **rules,
+					struct nfp_flower_priv *priv,
+					struct net_device *netdev,
+					struct nfp_fl_payload *flow_pay)
+{
+	struct flow_action_entry *a_in;
+	int i, j, num_actions, id;
+	struct flow_rule *a_rule;
+	int err = 0, offset = 0;
+
+	num_actions = rules[CT_TYPE_PRE_CT]->action.num_entries +
+		      rules[CT_TYPE_NFT]->action.num_entries +
+		      rules[CT_TYPE_POST_CT]->action.num_entries;
+
+	a_rule = flow_rule_alloc(num_actions);
+	if (!a_rule)
+		return -ENOMEM;
+
+	/* Actions need a BASIC dissector. */
+	a_rule->match = rules[CT_TYPE_PRE_CT]->match;
+
+	/* Copy actions */
+	for (j = 0; j < _CT_TYPE_MAX; j++) {
+		if (flow_rule_match_key(rules[j], FLOW_DISSECTOR_KEY_BASIC)) {
+			struct flow_match_basic match;
+
+			/* ip_proto is the only field that needed in later compile_action,
+			 * needed to set the correct checksum flags. It doesn't really matter
+			 * which input rule's ip_proto field we take as the earlier merge checks
+			 * would have made sure that they don't conflict. We do not know which
+			 * of the subflows would have the ip_proto filled in, so we need to iterate
+			 * through the subflows and assign the proper subflow to a_rule
+			 */
+			flow_rule_match_basic(rules[j], &match);
+			if (match.mask->ip_proto)
+				a_rule->match = rules[j]->match;
+		}
+
+		for (i = 0; i < rules[j]->action.num_entries; i++) {
+			a_in = &rules[j]->action.entries[i];
+			id = a_in->id;
+
+			/* Ignore CT related actions as these would already have
+			 * been taken care of by previous checks, and we do not send
+			 * any CT actions to the firmware.
+			 */
+			switch (id) {
+			case FLOW_ACTION_CT:
+			case FLOW_ACTION_GOTO:
+			case FLOW_ACTION_CT_METADATA:
+				continue;
+			default:
+				memcpy(&a_rule->action.entries[offset++],
+				       a_in, sizeof(struct flow_action_entry));
+				break;
+			}
+		}
+	}
+
+	/* Some actions would have been ignored, so update the num_entries field */
+	a_rule->action.num_entries = offset;
+	err = nfp_flower_compile_action(priv->app, a_rule, netdev, flow_pay, NULL);
+	kfree(a_rule);
+
+	return err;
+}
+
 static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
 {
 	enum nfp_flower_tun_type tun_type = NFP_FL_TUNNEL_NONE;
@@ -720,6 +787,11 @@ static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
 		}
 	}
 
+	/* Merge actions into flow_pay */
+	err = nfp_fl_merge_actions_offload(rules, priv, netdev, flow_pay);
+	if (err)
+		goto ct_offload_err;
+
 ct_offload_err:
 	kfree(flow_pay->action_data);
 	kfree(flow_pay->mask_data);
-- 
2.20.1

