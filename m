Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8BE84793BA
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 19:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240233AbhLQSRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 13:17:25 -0500
Received: from mail-mw2nam10lp2103.outbound.protection.outlook.com ([104.47.55.103]:7308
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240199AbhLQSRW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 13:17:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eOmLnGXv52QsDzMxvLBq+Vz+f+mQKX5Y/YUkyz/yMNt0WOnPkhUMG6QJSQF4O17hOetvsKn/PUCcXXr0iUoPK7Jhr5yZoNXo7UXjOjI6N2bapyuh69oOMtrTCAkF0e1tFVtvqrJjGHXjuBkypaR7ByzhkbnKsAJX0fwi4YRlzo7+OAGmnXYPbM8ewl5mR7WykDhc90AAa2ln5lc22iYDB2RtmmE8ghQSF0sHxly+4rPg7nXEtioWa0uDEELzRHPtiSaMc/MtPVblRr+NSopLAYhj9q5HKTcvIF8AfERdTHe1ZU2tYkD6wDn8XXI85v/qNYai/vPkp58ESAWuXPUYpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rDxbz0agi6tuKvuxZkL+ESnpnv5yDWQ2KIvtKcBMQm8=;
 b=hcv7jAmJ6flbAX8EY7k5RRQQRm2VwE8h8OsBEWCrKF83y8ZuTJD0qUw9cOS4r9n5blQgsYq0tib7oX/okk+D/k6OTgm7vIN/oS3sAg/Yj63wlVwP+0dzde6eNWRyCCD7wYAhrd6wuG/62SZ0w6WtVSbwLdWcsu66pIzbz007IKmc5HfjbiNgk/icP+j8ykc/KEPvh2AdwvHThpHfv1cPjmZbsbKSz1EILj71YZD3b9EzJByhgo2B7RNTlQD1saRO0FcRYZPKPX5EVe1QL39Lx6/GM9srxR/wRNusdgFJPGQsJbd4QHjmpqWvyzSx+7SqgGoN0qFXYwsHcxwZnvIFEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rDxbz0agi6tuKvuxZkL+ESnpnv5yDWQ2KIvtKcBMQm8=;
 b=dlUJ7OICMWTEQj/BbVwB0aDZQesRcsAY6Ibav9I5DvUNoy11mXFUHPxHX1+VIqoiO921fgw1ELtGuM/qEvIpHYRgpO0AzoOT+skeojdX74NRxj64WBfMislUjkrcBoXUEyN+g7ISVgdBvT/Ku87Vrb3bhewIjG6Oi6eDzugQhdU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5004.namprd13.prod.outlook.com (2603:10b6:510:7b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.12; Fri, 17 Dec
 2021 18:17:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4801.014; Fri, 17 Dec 2021
 18:17:21 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leon@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Oz Shlomo <ozsh@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v8 net-next 03/13] flow_offload: add index to flow_action_entry structure
Date:   Fri, 17 Dec 2021 19:16:19 +0100
Message-Id: <20211217181629.28081-4-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211217181629.28081-1-simon.horman@corigine.com>
References: <20211217181629.28081-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0097.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::38) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e19d4ea-ce07-4321-01e8-08d9c1897755
X-MS-TrafficTypeDiagnostic: PH0PR13MB5004:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB5004FF4241A7B6A91D5C53D5E8789@PH0PR13MB5004.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:64;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VnzwXAu6R58pPMYWw7eVK/3L1D/GEbpUTWOXX4Lt2yB2tSUOGkoWH92qeqIIZz2Vv+ERXuDJ4nnYV8FC5LP52DCyOabYFP6Co2brmvJA0FVzZ7NC1lXS+n4hULZDmAbKbHuK7ld/ECCzjsJ69BJBNcwQ5700Rp4nIHXGKZZq4lL+Ee4+ibdRbcoD/NVfGRF/V/1qKLd2xftFvOiKRitGGXAgtnbsSJJSd9Z7AQa84kOmXKO4GT1TdimmQpFK8dNzrKjeDaQqikfTa325eP5Lu6QQ+u4kfSI+POnHotauVIXDKwxls5I1QH4lZz0RKVONiYEHd1vWIa12Gp9WB179tQ8Iy2d9c/2sxk6f+Rq9TmgD9EDsMVb013rpDD4jbjIFuDXFsxvUenzmhybNREJ8A7P9poFPpiJ4jaI8+1w5kMar2HG7t88ipu2vAijyv4RH6MX75+tKyuTML/kkBF7PgpfpC3yOMLICJKVev1X3B3kcAcq0iouLx/e5JfKDMgsPACF7Daf3k7TDrDnBrkVxkHnAgPqHh4V8GyaOzaNklfJ0LPjJtlD2T21WCV4GXqvbYsG9+kdHctQBGvKZLaY7RNK4NI/B3QIprl2iwZGGYe1vbNdqVNjBqyaRLrbR5RxcxghPz8KArZ6pxr8FRW8e2J5G7GuhrAHqdn99MVRvhXs5A4pOq58HxdNy885POVFof3qrUROK9vc609Hun8JdQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(396003)(346002)(39830400003)(376002)(366004)(508600001)(36756003)(6486002)(7416002)(5660300002)(186003)(6506007)(38100700002)(2906002)(44832011)(52116002)(6512007)(66476007)(83380400001)(8676002)(54906003)(110136005)(86362001)(107886003)(66556008)(1076003)(2616005)(4326008)(316002)(66946007)(8936002)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3+MoIfFeA40huXpq9SRteIr1b/yJ3ezrAwzQCm/KFvsexUZcl7XloStw8Hix?=
 =?us-ascii?Q?m6RDEbbqpp7abB7Prsq/anzfawjXRaKUGKgO0AUiQpDuJiE605KeftVAC3N7?=
 =?us-ascii?Q?U/SVOXgmHxp0eRFinoAMpdr0BAhFwpLLVZeOp8eMhCNrrMHSZSjCmmCvsJs4?=
 =?us-ascii?Q?m/KeDuhruvDQkvo1ZH0HEcKgpasBrNu/saMoAHZHqkubCdBPd+iE2uMVNozj?=
 =?us-ascii?Q?bk3FyWCpf6v4RmjxhaThKwNDLZFeqq1lwJiUgthwjHAU4GkrWyTkzGLMGevz?=
 =?us-ascii?Q?dN77GeymDRhZ0yUUS1Fe4cpziN3qC2gyrYm2xEzoTx1vSdkKPvBxBYia8um6?=
 =?us-ascii?Q?7SZG9FryxWrc5qWeNP19If04oqwo66nrWYvbGruo8zLMJbufF+sipPvNuIrM?=
 =?us-ascii?Q?3spRVb1FvUDBK1TQI/d9qecdQU7LINL+a+O98VpQzLSy7+FAuEscFGypKiJ4?=
 =?us-ascii?Q?g351XSPVWfOwBhp1zB2GBDuckGbl8ysrAWUo64uiEXzxN0dvlItcP+OdwNWr?=
 =?us-ascii?Q?xAvXzRxrnSfzuD1e+ZrRJK8sLbh36Py1GTJu/eoXVnFwSrN2O/biMRhy1hRF?=
 =?us-ascii?Q?NWgpI9Ff8KXQ4J14L7bFGfhrHBy/Npq5gx5i522a/9F3EXhV9kxM6VU8xMhe?=
 =?us-ascii?Q?syFA7zP1W07fQ2CnFhj2gFBGAlmfkfZF5xRukYFy+vIKUaU70by9QQncbXEs?=
 =?us-ascii?Q?z3Y4xqViEgtOoORk+m9kJ1HRHIx8etC22cSLcvuoVJ4FpOpVy6HpZpTqyfdk?=
 =?us-ascii?Q?6stoSMVHqxugSF0xqU1sRwBfFaCapfXthy/U2pN54IcXVgN+BFv+eNjDkuKV?=
 =?us-ascii?Q?hxu5AaI3RB8G+tMXV6DIn8ITfBrx4wPsfY32U1S94dW+5c76XN3kNk9K4T7i?=
 =?us-ascii?Q?lJ9gTIo3Ue6fxwNAzcUPaUovYBHHUPjg2F19xCl24WijJ5SJo3TSQjW18kmV?=
 =?us-ascii?Q?nOfsiIiIXbp3fwPeSJHb6z1ZpO4BVecy+r5EUzFm2LwdXay6IZKKkVcyPaaG?=
 =?us-ascii?Q?THcqPwmsSeyJkjxBPfyN8MuBH1ES5Ajl5DrjyuCYCyRluEGlDVsJXUqoAo+x?=
 =?us-ascii?Q?MT3cD580kC+HsJN+mDuX3n6gCSV+2gJPSJjElLGvgAYFVv4vggFZNKSnH7GM?=
 =?us-ascii?Q?1kiB/88EP1boOsFeMYskhLn6Xrw3YzISCZDx+ePHYt/0abkoPVMl0BEowYyi?=
 =?us-ascii?Q?Nu/w9ULrIaz9MMZPaJLv/GbguU59+QIBawffUEm3zwoqqcmX9LBPbGA7Frjk?=
 =?us-ascii?Q?QtIepXytuMgnoOTn7W0o5ZZ2uI5el4LYAbKPMdRBhtk9PpKVV8C29RmoSZiv?=
 =?us-ascii?Q?tVnWoz+uoAqIiDwRAOukN/S/hDK/rLFQWNfFM+2uy9TBCw0qd8iQ/UY4X4sj?=
 =?us-ascii?Q?ZefjWlmemK4NbDV992fneYz/5Nhrw4/TZQ2xV2y9yUbmOXmvW255nBnEWADS?=
 =?us-ascii?Q?B8e0CW8sV/5InCCzLsbM0asKw70Ll72wgmzkME3fb+18rWNRUUxwKYpT/u8j?=
 =?us-ascii?Q?XdVDLNoNvkwEXM7kN+P8us3no5riEbOqeL3QnfvkykhxlG+/pDWQ8jHK9fUe?=
 =?us-ascii?Q?5kTTbGyYblkNJyq0jnW5QuK6W6ZYoVWZ+SXwE5+ioLwpIhQu7ebeNUolAcJi?=
 =?us-ascii?Q?sOgyGpQCWC299Kt0e66l+WPQiUMaqbOrfjcjyYIcDdKQDXHpaGmT7OS4aUSe?=
 =?us-ascii?Q?PW/NL44FSneuK/G6nlU/hH3ZOyPcFZkHjoYHEjzYTcEbr5cDYMsYaoCh5INb?=
 =?us-ascii?Q?fzcer7O4LosOySHfzB4g1lOeQAiSP5A=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e19d4ea-ce07-4321-01e8-08d9c1897755
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 18:17:20.9691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ELgh1b65rOlZ+hts/8b3LafDlyaWlkei0b5NipLlvzwETCqUB8H2JVTtodmm6JZkW5jlQPem+ERiQ7lt9bp5FIcjBXkBu7m7ACG7JMSKIzY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5004
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
 drivers/net/dsa/ocelot/felix_vsc9959.c                | 4 ++--
 drivers/net/dsa/sja1105/sja1105_flower.c              | 2 +-
 drivers/net/ethernet/freescale/enetc/enetc_qos.c      | 6 +++---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c | 2 +-
 drivers/net/ethernet/mscc/ocelot_flower.c             | 2 +-
 include/net/flow_offload.h                            | 3 +--
 include/net/tc_act/tc_gate.h                          | 5 -----
 net/sched/cls_api.c                                   | 3 +--
 8 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 110d6c403bdd..4ffd303c64ea 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1745,7 +1745,7 @@ static void vsc9959_psfp_sfi_table_del(struct ocelot *ocelot, u32 index)
 static void vsc9959_psfp_parse_gate(const struct flow_action_entry *entry,
 				    struct felix_stream_gate *sgi)
 {
-	sgi->index = entry->gate.index;
+	sgi->index = entry->hw_index;
 	sgi->ipv_valid = (entry->gate.prio < 0) ? 0 : 1;
 	sgi->init_ipv = (sgi->ipv_valid) ? entry->gate.prio : 0;
 	sgi->basetime = entry->gate.basetime;
@@ -1947,7 +1947,7 @@ static int vsc9959_psfp_filter_add(struct ocelot *ocelot, int port,
 			kfree(sgi);
 			break;
 		case FLOW_ACTION_POLICE:
-			index = a->police.index + VSC9959_PSFP_POLICER_BASE;
+			index = a->hw_index + VSC9959_PSFP_POLICER_BASE;
 			if (index > VSC9959_PSFP_POLICER_MAX) {
 				ret = -EINVAL;
 				goto err;
diff --git a/drivers/net/dsa/sja1105/sja1105_flower.c b/drivers/net/dsa/sja1105/sja1105_flower.c
index 72b9b39b0989..7dcdd784aea4 100644
--- a/drivers/net/dsa/sja1105/sja1105_flower.c
+++ b/drivers/net/dsa/sja1105/sja1105_flower.c
@@ -379,7 +379,7 @@ int sja1105_cls_flower_add(struct dsa_switch *ds, int port,
 			vl_rule = true;
 
 			rc = sja1105_vl_gate(priv, port, extack, cookie,
-					     &key, act->gate.index,
+					     &key, act->hw_index,
 					     act->gate.prio,
 					     act->gate.basetime,
 					     act->gate.cycletime,
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 0536d2c76fbc..3555c12edb45 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -1182,7 +1182,7 @@ static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
 	}
 
 	/* parsing gate action */
-	if (entryg->gate.index >= priv->psfp_cap.max_psfp_gate) {
+	if (entryg->hw_index >= priv->psfp_cap.max_psfp_gate) {
 		NL_SET_ERR_MSG_MOD(extack, "No Stream Gate resource!");
 		err = -ENOSPC;
 		goto free_filter;
@@ -1202,7 +1202,7 @@ static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
 	}
 
 	refcount_set(&sgi->refcount, 1);
-	sgi->index = entryg->gate.index;
+	sgi->index = entryg->hw_index;
 	sgi->init_ipv = entryg->gate.prio;
 	sgi->basetime = entryg->gate.basetime;
 	sgi->cycletime = entryg->gate.cycletime;
@@ -1244,7 +1244,7 @@ static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
 			refcount_set(&fmi->refcount, 1);
 			fmi->cir = entryp->police.rate_bytes_ps;
 			fmi->cbs = entryp->police.burst;
-			fmi->index = entryp->police.index;
+			fmi->index = entryp->hw_index;
 			filter->flags |= ENETC_PSFP_FLAGS_FMI;
 			filter->fmi_index = fmi->index;
 			sfi->meter_id = fmi->index;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index be3791ca6069..186c556f0de1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -203,7 +203,7 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 			 */
 			burst = roundup_pow_of_two(act->police.burst);
 			err = mlxsw_sp_acl_rulei_act_police(mlxsw_sp, rulei,
-							    act->police.index,
+							    act->hw_index,
 							    act->police.rate_bytes_ps,
 							    burst, extack);
 			if (err)
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 58fce173f95b..beb9379424c0 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -303,7 +303,7 @@ static int ocelot_flower_parse_action(struct ocelot *ocelot, int port,
 			}
 			filter->action.police_ena = true;
 
-			pol_ix = a->police.index + ocelot->vcap_pol.base;
+			pol_ix = a->hw_index + ocelot->vcap_pol.base;
 			pol_max = ocelot->vcap_pol.max;
 
 			if (ocelot->vcap_pol.max2 && pol_ix > pol_max) {
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 3961461d9c8b..2271da5aa8ee 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -197,6 +197,7 @@ void flow_action_cookie_destroy(struct flow_action_cookie *cookie);
 
 struct flow_action_entry {
 	enum flow_action_id		id;
+	u32				hw_index;
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
index e54f0a42270c..dea1dca6a0fd 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3568,6 +3568,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 			goto err_out_locked;
 
 		entry->hw_stats = tc_act_hw_stats(act->hw_stats);
+		entry->hw_index = act->tcfa_index;
 
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
@@ -3698,7 +3698,6 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 			entry->priority = tcf_skbedit_priority(act);
 		} else if (is_tcf_gate(act)) {
 			entry->id = FLOW_ACTION_GATE;
-			entry->gate.index = tcf_gate_index(act);
 			entry->gate.prio = tcf_gate_prio(act);
 			entry->gate.basetime = tcf_gate_basetime(act);
 			entry->gate.cycletime = tcf_gate_cycletime(act);
-- 
2.20.1

