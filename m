Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2604F455C51
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 14:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhKRNLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 08:11:33 -0500
Received: from mail-dm6nam12on2124.outbound.protection.outlook.com ([40.107.243.124]:6945
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230105AbhKRNL0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 08:11:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RaZiPH5/kA94VdWppSHBvgTXkZy+rm4yERUwCU0x/Lzsel5joSE2f26LUYrPgb6un1auObX9DM1j+QiOyZQjW2ZNNwDEy1O0D2Ed8gWisWgaXld6z0M/PFbVkOpaFACtTDz4KvRwgSvZ4DSaBW7/O85gp+mJ4kSPlBS1xw+Kcgtn1Xa2Hyu/yOWAm1gdDCCPaN5LY/CNOsQJopl3gzufVQR59wwbSaD37hxFOPttjUS8WShzSJGz+SDyz3Jo5lhpBqGrkUkiWHNpogJaYmOFj66yx/f7qV4F4+HjZ0Hg3V5OuX1thl0BEPSEzl+W5uuj1AXGw75UaiEBQSyId70+uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ek1rwnU9+tgZx3wdUBg5ANZwSq3RjpJtHq8v6CpT7DY=;
 b=Fg+TrxUMvLxyqTQh1qegWKF1+/novxvPbRLBoc3OqEpWqkLL2rNIOJh/qCwxqRMqH+3gcnAVDsJgzhh7Oj/ovsrdjhLg5HZsHnRRA4UbQH6Tes19xD2KV+CJzWzpwRLkWawkVMWfFmfcLLR1v6sqgo9e4qu8CyGsQqrU1KVzKhPwy7I741L+sGnSfeYgo7QU3/iT699rWCophyrdJL5Y8DTDpSsc5mup3dQvkWxil9E5mFaQwoHKAwdKR5I5vv8YPir1htBwA9g0K2mC1Hl+eeW7EwyvkJhjfTSFLKSSRhPiPImY0WQXTPyeHBn5hSRZBAyHkGS6t8dNtIYs6r+hHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ek1rwnU9+tgZx3wdUBg5ANZwSq3RjpJtHq8v6CpT7DY=;
 b=i+R6K2iK1tzBziwdNc4P2lNxvNhANjVybmNtNgnzrv1YI3wX6ZiLYsAr6dj1a9DQI2ggv1JBASH1nRNqzlgibGoTOz1yBsi/oDPodCGPbbu7tCCIPxdRndeFaw4Dd+setWYL/7eEWNUmjb7xzIOBOT1cgC/ib8JPJx38QAqeTeU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5422.namprd13.prod.outlook.com (2603:10b6:510:128::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.10; Thu, 18 Nov
 2021 13:08:24 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3152:9426:f3b1:6fd7]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3152:9426:f3b1:6fd7%7]) with mapi id 15.20.4713.016; Thu, 18 Nov 2021
 13:08:24 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com
Subject: [PATCH v4 03/10] flow_offload: add index to flow_action_entry structure
Date:   Thu, 18 Nov 2021 14:07:58 +0100
Message-Id: <20211118130805.23897-4-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211118130805.23897-1-simon.horman@corigine.com>
References: <20211118130805.23897-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0202CA0021.eurprd02.prod.outlook.com
 (2603:10a6:200:89::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from madeliefje.horms.nl (2001:982:7ed1:404:a2a4:c5ff:fe4c:9ce9) by AM4PR0202CA0021.eurprd02.prod.outlook.com (2603:10a6:200:89::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Thu, 18 Nov 2021 13:08:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f994185b-fd38-4875-e8b2-08d9aa9480c8
X-MS-TrafficTypeDiagnostic: PH0PR13MB5422:
X-Microsoft-Antispam-PRVS: <PH0PR13MB54228F806DC92BCE6E8F91FBE89B9@PH0PR13MB5422.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:64;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8dimG6P+egL7sOwXgpDL3SwO5014hV7oOaTp6p9BZHMWIc0hVV640Vyo5n81DobtPWs9wyvZQwmfKl4Ku+SSi4eWnpZR+f3VxEdU6MS0vhFBg169Wus/ct5COnheNzFEbx9XOJj1UgLxU7/hxbdawawXAhqnbFHeW9qno+E/OJ/S5sGU10rRc7SU2MQc9lQzvoZITzu1058qXl0SG8FADbJDXZMcwau0y3UXjx6nJXDDf6icgyaulS5VyCclT0Pjq+MFYHeUoVGjIo5O0zS96WcHuSIZTdXJQksARuyG9iNGKKQcxZ48gbEV+sgD2PZmeN2Id8VGk9z7SrPQYYTcwB9auAL7NxxmpYpqrcGmCqcVnMNWF94WuA+4QPNkI2rBqkSHs9Kik36oFGVcesvC3U5G5OYWKx4lw/mSUG7mFQVarJU+t8YngsN4UkhVRI6wJ5ubIAFTTkR0M1a1EIt6DBP/jR+ukEHhYi4/J5TIhb9hIzteLbgLjpM0PKyPUeBwTAvqM5szxgYfp6fsGND301NXlGUr93B2L6eq/bOjrcWtNGakItBlApqAK93FbCuOrqGSPRj9/sjGsmoFxxj454eC843w8lDRP3zsjxfaBS9PcJFWucpodVl9JFmfRTwXQYsON4porYFjZyTL/YmFwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39830400003)(136003)(376002)(346002)(6486002)(2906002)(54906003)(6666004)(316002)(86362001)(52116002)(6506007)(1076003)(38100700002)(186003)(6916009)(107886003)(2616005)(44832011)(5660300002)(4326008)(8676002)(508600001)(66946007)(8936002)(36756003)(83380400001)(6512007)(66556008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pCDkXst3d+tW5df+bB02lvcWjltdoDlNeoZ5oWWAGRw+93xheUlraIKef6co?=
 =?us-ascii?Q?KVHqLu6V0Vp9zzPa1/kpJHntMpy0wK3fCCCnNKqqbI7c8ppAfzZ66YKbtSAh?=
 =?us-ascii?Q?c/qoyi6jRkGzH5+G9hK7Jo2ypMY5zS6uXcVRLEjKdYlqR+KS/4Fb+wpRcdxI?=
 =?us-ascii?Q?i7gLD8nBeTYduHFagCwyENgb6ZtHpAzXcsZNnlafekmF0BurJxLmhpfWmiWC?=
 =?us-ascii?Q?rIVg/jLSLbWLCRZ7pJkfxi2TUARLQb6GdRmOIBOmpKtFuIEhbwlSycbDmW5q?=
 =?us-ascii?Q?pkNcef/FShGzOOpA4nUn0qSL8aJFfEbo77QzeLsrxGpN9Cw8gZxinrOn9RdZ?=
 =?us-ascii?Q?2ZhvI5zOzQi30bndIhICEseTZctY0PeZggsxFdvVGwVp0ATj2OWg1EMBWf7f?=
 =?us-ascii?Q?G0tjJOrIWFoxLvdObSV6IssBiO2h1GTxn6I4ENFfOVpISSC4A3C2DG/FmcnP?=
 =?us-ascii?Q?4ReGD3kDuaXtQsI8yzdFnW9olfq1THVqGS6x6+e34WS5eRA7j0+aniZgBxVT?=
 =?us-ascii?Q?hYlBJ0g1k3vHsZkovOSLEfP7zqHJ0TcU/CBwzWjOUTPOMdZPuheMTKUTy7jw?=
 =?us-ascii?Q?SZ15B21sgz8jJTVBEMgSpTQWQNj35JkSEFZTacxBgAgzQGzmgdyJTVPsZj3t?=
 =?us-ascii?Q?vMti3wYm9B7rNkgofkWipEaOh/YRqbZ/WsDd3dToM+tOzo5mQzweOJuipu/R?=
 =?us-ascii?Q?MlB+uN45YmmfFbKNi2Futg2Vk57SCrdlT3V0slo7hiZaumOLL1GjpvGWKQDG?=
 =?us-ascii?Q?Xx7gz/PZ61evc/Glm/2qZb0GiDhLJxdP7HDevp/ZTGzzz5xS2JDqQxWAT/6k?=
 =?us-ascii?Q?0EKnhPYbl3CC4tbPDMQtYxAoCKs1SYkM0NtIHN4g3ZgSMeOy1bLznpGGnPw8?=
 =?us-ascii?Q?9NUaD0j6ng2ZBV4zciU7bLTeGNhFsKbGU2TFDXSkQDTno9AuruQeTlq59Xm4?=
 =?us-ascii?Q?XPu2qci0EJpGVHjPMelvC6ih73KMcyN3yNYQQT3UuY7tYP4Q+iStChnBNFLY?=
 =?us-ascii?Q?/t0ziPMZ7EmrcpAbgyXy/LF56gCSrVyXAWZFakXt9qTghZs+9UVYQrWgWahe?=
 =?us-ascii?Q?//E1SBvxil8Lu4rHf4Pil4uTVB93NqXEPb3rXhWmXCaxbGUFV+9fgKuBBnW3?=
 =?us-ascii?Q?eRLLHgQQyqIfKO5HfvDNHxBMYpBimn/mFeQQKQphOWofXZ92msuxOVOfGGm+?=
 =?us-ascii?Q?FjMEoe4l2xIp/paFjbMgjrtODOWuIRLGERilVGO/iMANbPg16uqvg+6Nm7a1?=
 =?us-ascii?Q?JHGLtmeMXgLEGNIk8CT0vB1abVDMFel17SAIomid+OmYo6HbEbzBgAlpeckb?=
 =?us-ascii?Q?l5wpxDLXdU0RKJOIYJs0xOzFFjSjs5k/sjc9X4Vwcv9zqK0gbypUgQ+rUB9Z?=
 =?us-ascii?Q?kzFybLVuPt6oVX6vI6aW+SqRjhvjDWRZqA0yq5VqidUJCXi3PlLbxhgPQkVL?=
 =?us-ascii?Q?5qp9kERMZn+YNtL0ab5NAkDOFFvF7x7A6A6zctma3auBpgj82LMSw+GlY5Te?=
 =?us-ascii?Q?YJpBQo2c2beV+XiBOCV9Rv9AXiLRZuVhw6uLxB9x8noh3gFdT+y0Iw1h86Qp?=
 =?us-ascii?Q?YvWLZmr7FpT+2gO+UA0Lvbv5n0dzjKhiFm8kuUZe3QjqYVNciys4v3PoP5n3?=
 =?us-ascii?Q?nmnuE2xz4Y4t405eWTVsnt+jrvnMUjtzkibA2hMPbb8d/GjtyJw10ycdkHD6?=
 =?us-ascii?Q?ybP2vVwro4x1UBl6ekkRsobitLqILpxDzW1AZqlXUL5Y+Lw022uEj7hulkrD?=
 =?us-ascii?Q?6mrDT/a0AK6LIgzslzgBuNwKiGpG6Zc=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f994185b-fd38-4875-e8b2-08d9aa9480c8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 13:08:24.3721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TsLyF7gcayQBY18E9hnV31aDgnQS5gJ1ncZwFUi7SqW96SXT8H7eiQEkWKdbQPZ5C13fYV9JPsi6O61isaPa89ZhfY2h4oqlSj0JowmcbnE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5422
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Add index to flow_action_entry structure and delete index from police and
gate child structure.

We make this change to offload tc action for driver to identify a tc
action.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/dsa/sja1105/sja1105_flower.c              | 2 +-
 drivers/net/ethernet/freescale/enetc/enetc_qos.c      | 6 +++---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c | 2 +-
 include/net/flow_offload.h                            | 3 +--
 include/net/tc_act/tc_gate.h                          | 5 -----
 net/sched/cls_api.c                                   | 3 +--
 6 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_flower.c b/drivers/net/dsa/sja1105/sja1105_flower.c
index 72b9b39b0989..ff0b48d48576 100644
--- a/drivers/net/dsa/sja1105/sja1105_flower.c
+++ b/drivers/net/dsa/sja1105/sja1105_flower.c
@@ -379,7 +379,7 @@ int sja1105_cls_flower_add(struct dsa_switch *ds, int port,
 			vl_rule = true;
 
 			rc = sja1105_vl_gate(priv, port, extack, cookie,
-					     &key, act->gate.index,
+					     &key, act->index,
 					     act->gate.prio,
 					     act->gate.basetime,
 					     act->gate.cycletime,
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 0536d2c76fbc..04a81bba14b2 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -1182,7 +1182,7 @@ static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
 	}
 
 	/* parsing gate action */
-	if (entryg->gate.index >= priv->psfp_cap.max_psfp_gate) {
+	if (entryg->index >= priv->psfp_cap.max_psfp_gate) {
 		NL_SET_ERR_MSG_MOD(extack, "No Stream Gate resource!");
 		err = -ENOSPC;
 		goto free_filter;
@@ -1202,7 +1202,7 @@ static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
 	}
 
 	refcount_set(&sgi->refcount, 1);
-	sgi->index = entryg->gate.index;
+	sgi->index = entryg->index;
 	sgi->init_ipv = entryg->gate.prio;
 	sgi->basetime = entryg->gate.basetime;
 	sgi->cycletime = entryg->gate.cycletime;
@@ -1244,7 +1244,7 @@ static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
 			refcount_set(&fmi->refcount, 1);
 			fmi->cir = entryp->police.rate_bytes_ps;
 			fmi->cbs = entryp->police.burst;
-			fmi->index = entryp->police.index;
+			fmi->index = entryp->index;
 			filter->flags |= ENETC_PSFP_FLAGS_FMI;
 			filter->fmi_index = fmi->index;
 			sfi->meter_id = fmi->index;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index be3791ca6069..06c006a8b9b4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -203,7 +203,7 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 			 */
 			burst = roundup_pow_of_two(act->police.burst);
 			err = mlxsw_sp_acl_rulei_act_police(mlxsw_sp, rulei,
-							    act->police.index,
+							    act->index,
 							    act->police.rate_bytes_ps,
 							    burst, extack);
 			if (err)
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 3961461d9c8b..f6970213497a 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -197,6 +197,7 @@ void flow_action_cookie_destroy(struct flow_action_cookie *cookie);
 
 struct flow_action_entry {
 	enum flow_action_id		id;
+	u32				index;
 	enum flow_action_hw_stats	hw_stats;
 	action_destr			destructor;
 	void				*destructor_priv;
@@ -232,7 +233,6 @@ struct flow_action_entry {
 			bool			truncate;
 		} sample;
 		struct {				/* FLOW_ACTION_POLICE */
-			u32			index;
 			u32			burst;
 			u64			rate_bytes_ps;
 			u64			burst_pkt;
@@ -267,7 +267,6 @@ struct flow_action_entry {
 			u8		ttl;
 		} mpls_mangle;
 		struct {
-			u32		index;
 			s32		prio;
 			u64		basetime;
 			u64		cycletime;
diff --git a/include/net/tc_act/tc_gate.h b/include/net/tc_act/tc_gate.h
index 8bc6be81a7ad..c8fa11ebb397 100644
--- a/include/net/tc_act/tc_gate.h
+++ b/include/net/tc_act/tc_gate.h
@@ -60,11 +60,6 @@ static inline bool is_tcf_gate(const struct tc_action *a)
 	return false;
 }
 
-static inline u32 tcf_gate_index(const struct tc_action *a)
-{
-	return a->tcfa_index;
-}
-
 static inline s32 tcf_gate_prio(const struct tc_action *a)
 {
 	s32 tcfg_prio;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 2ef8f5a6205a..d9d6ff0bf361 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3568,6 +3568,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 			goto err_out_locked;
 
 		entry->hw_stats = tc_act_hw_stats(act->hw_stats);
+		entry->index = act->tcfa_index;
 
 		if (is_tcf_gact_ok(act)) {
 			entry->id = FLOW_ACTION_ACCEPT;
@@ -3659,7 +3660,6 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 			entry->police.rate_pkt_ps =
 				tcf_police_rate_pkt_ps(act);
 			entry->police.mtu = tcf_police_tcfp_mtu(act);
-			entry->police.index = act->tcfa_index;
 		} else if (is_tcf_ct(act)) {
 			entry->id = FLOW_ACTION_CT;
 			entry->ct.action = tcf_ct_action(act);
@@ -3697,7 +3697,6 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 			entry->priority = tcf_skbedit_priority(act);
 		} else if (is_tcf_gate(act)) {
 			entry->id = FLOW_ACTION_GATE;
-			entry->gate.index = tcf_gate_index(act);
 			entry->gate.prio = tcf_gate_prio(act);
 			entry->gate.basetime = tcf_gate_basetime(act);
 			entry->gate.cycletime = tcf_gate_cycletime(act);
-- 
2.20.1

