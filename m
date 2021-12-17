Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED13B478D9C
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 15:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234693AbhLQOWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 09:22:31 -0500
Received: from mail-bn7nam10lp2104.outbound.protection.outlook.com ([104.47.70.104]:6434
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237252AbhLQOWX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 09:22:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q61CgfRcoWqSyzxsi9UzWEZRzWpoHmJ7yGLn3JonMsLWwabwOkmfuuoEKYe1HeWdskrNNvnkwgDeuAso3oRZm1KQ86U1wxp40YlnB5HAKe3LhGgXgFZ7CLqeCaVFU5I3V/rpl1tzUmSoOUburlHToof3jAgZasKvpeGua7aTPzl/FK8jTr23AmFWvU9akkd+NxSLbM6r/syWPrZ+ZB5ZxAsUTr3hRWYgNBGM+fMc6AfSuBFj2nfJFcTGOJw9QeN/sEJnvMNXpKvFx+kluOykNdT+EeWeO2w/u5kwx73MzQ+3VJUl8KuaLBxbPxOPBYdwzfrlL9E+78nxQ96KCDK2mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rDxbz0agi6tuKvuxZkL+ESnpnv5yDWQ2KIvtKcBMQm8=;
 b=mfVLEGKcACAdigfjQZAcwxwMzyo2NRVoTLPezrOeknuQYBPooBsJtobTc/xHjZboT5DCNXx0PqeP4dJ6yGmeAPwVvwzKpBzITsYFu0ZdxvqtLoo/qxHjgad4nAPlN07xtoK4OzGAniqL3rDzPjRAQZvExJPq8Zv7gsM01LBz8omfn74zk6LmzA6SUU5aMniNi8RCn2aC5LfryAi3cuuTJ9NglkB7rEQet6U57eN/9CLrey3o0Ap9fz9eWCPd8aSiORJ9M0J2AZPoYfHkr4Ot2G0IOwVn9H1moBfZ4yGrxRTLHszbx+WN3/UbgmcB5oMQB7K6yMUxCaK06IwJ1czJGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rDxbz0agi6tuKvuxZkL+ESnpnv5yDWQ2KIvtKcBMQm8=;
 b=Ug7+6ryRJMVw1gyF8mOhJFUUECmuZPvNDZLGStTKpqRof/DHGVXfzv87YYlGGeeR1b8BAIymEB42ozmCblSGCuWjdpwrNh+HA110VnwUl1lVrLZqojUq7uzg8gSzzseYmLTEKEufOryRQfi/A0p0EGozZxGC2Bk4o0Uwxi7bsMw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5469.namprd13.prod.outlook.com (2603:10b6:510:142::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.8; Fri, 17 Dec
 2021 14:22:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4801.014; Fri, 17 Dec 2021
 14:22:21 +0000
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
Subject: [PATCH v7 net-next 03/12] flow_offload: add index to flow_action_entry structure
Date:   Fri, 17 Dec 2021 15:21:41 +0100
Message-Id: <20211217142150.17838-4-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211217142150.17838-1-simon.horman@corigine.com>
References: <20211217142150.17838-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0079.eurprd07.prod.outlook.com
 (2603:10a6:207:6::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78c11960-e167-41d1-8f55-08d9c168a324
X-MS-TrafficTypeDiagnostic: PH0PR13MB5469:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB5469034E5764AA7678B63D78E8789@PH0PR13MB5469.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:64;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eYo/6FtkOWNlPL7xci7D9brz1NHPysMfwKDN1Qi91as4P/RF2RYEkXbBUTX4zU6meWGZqba3nSodjX6+0JE0Yn4DhH2hiFOs+La5+F4n0HmSmbB6OJh2tfsP6RWDi1CPXKR+EvMw7MTFLyC38Usln/oiLGk5byzPMsIBno6NAHkn1CgsulUAtRF6yaq/22mdKSvqnwh/q16kARLIttdZ4QyIhZLAaXmwinAO74fqWd53iLaLzJ0EOj85rkCF6f5fRGK9T9bPcp7037TqDOfH2HLo2D5IzIs/zQ6rOj+cDqROQT4LkqjY7+gH0o9X4vwakNQODbpno0yw5WUBjcpISzeLvi//VD5Ml55XbEJrwV1B4x2Ym1xUhxzy496hdKwXZg3IzQghvn9Zn2jU9gYeoCaosuM9dgqxyJRut+mx58l378goaMO1zRQvsGI7OtiMPKZIVUP1NCMVkNQ/t9Bfa0b/yZn3TXDKYOVJ61ZIxvdta1N3uvRgpD1/vzqpQPNkeLCWIyZl4QiYmOYENQnSg3btoivy/9gLEL2IiaIIlGumj8Aicf5I/SToJEhbvAUxq9LG4glNu6R1qDJknnNAw8XlV+J669KNep3tD6jdB4ys2DQ5kA5XKkGobgvpWzoJrKRIYqQQzyf+z4YIGJEHsS0f5BjhxSvv/mPhzbZMKqIQbnyk8/3RfQvYbunfKhERbFYq7GoRbc3PrPFafW+Sng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(39840400004)(376002)(136003)(346002)(396003)(7416002)(5660300002)(83380400001)(36756003)(6666004)(186003)(44832011)(1076003)(107886003)(6506007)(2906002)(6512007)(6486002)(52116002)(66476007)(66556008)(4326008)(38100700002)(66946007)(54906003)(110136005)(508600001)(8936002)(86362001)(316002)(8676002)(2616005)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qwvRHSsNXdgdQCDZfZXacTAkFmItaZOZspR4yXloGIOc2Ma2YjXIm8UOCEXW?=
 =?us-ascii?Q?iZPGTUpPUHaxFv2Y4ocMzu2fe0NcxBcJmwE0ZNdJcG4sgffDd5RheDOFHWnw?=
 =?us-ascii?Q?sCfzjaU3aKH26Emwbvv/eXzOZEFXI7HHINHebnnt4JhmxWhGYvSnmqdyn6zZ?=
 =?us-ascii?Q?adKnv5q6fT+8Rvg2XbcJuNvByKfkvsNheuqgFzWJRrcxJ41h4P4FVCHsnKTz?=
 =?us-ascii?Q?aInO1vkL9V8UkZz2fLbzdRUh+AqZ2fnCc3jJtP+7Sc7zuIS0zW1H0/HFazqf?=
 =?us-ascii?Q?1CgGxJLQPandmxtQKAC4QOLgT3sIlSaOaFiQBLNr7HggJZhDhL5jQxhOxLee?=
 =?us-ascii?Q?9xaFbOyz/HDCIVoXJNVu11NdfPmnuED8geVxF4PHCOUHQ2DCedIYePshZWdb?=
 =?us-ascii?Q?2YDqzYQy4qSz75EqfUyUi4lNZ66OTk3zxDM9Gc+pxgPMikgWuxoynVJFtiMW?=
 =?us-ascii?Q?Mk2RokNylpO3cwC23CJk+1MXOyU3Ofh5dcrI1CNYPqGrEUVTDsFesIBJ6Ywi?=
 =?us-ascii?Q?fU3ltdLczGlJ1EJHjQ3U8Qw/BIlvTfDF3ljoNWZT/6Ggzf3sRNNhT5eItS6P?=
 =?us-ascii?Q?CJjc2a2D6ele0ahLllV/2cfQnTYbbWQdZFwFrwfGUEws+o0mvPXm0jTbmEw0?=
 =?us-ascii?Q?G+A1FX0IoytXXnO7UejiS8KiKIbnyeZC2vIw5s9VTDQdVQHXK/b+QWzrkbAo?=
 =?us-ascii?Q?AO4BCKBk3GjBI3E9jQQHwt///QtOj88zdrRTeINespIoWlcR/X1IhedOxhZ7?=
 =?us-ascii?Q?Q+GkULSO3e6bAfudQTAz1ZDgR3hhGNhpHx2KL1tw7iKkrucPUOa90YVqNKM+?=
 =?us-ascii?Q?XTLLdGjwwXXgeTj5EuBwHHQEmsaRWTRArex++1PLXx6vyOYa0l1YwmteiI9U?=
 =?us-ascii?Q?Kfil3cE1Pqjh0u6mFuCx6avA3cuob9sLDnoiTTHCG23U7tDZkXCS4706Hbub?=
 =?us-ascii?Q?Adysxn9dqYA/KA/AD1UZ/BxZORW1W31fJCj4Xdjx+LcIczA8I2NNwlqysGHH?=
 =?us-ascii?Q?mW3/CG83N5qLAS05vwPGBElsZrT+vdenq59lXNConCJ3Cjh96kfuqcaOSxbQ?=
 =?us-ascii?Q?E3j39hZ1iHUkXsy6kHEAckaTnL5gyijpUrH4NTK0GQ3A9IPEgLenXXNcXGqD?=
 =?us-ascii?Q?3wbw8myBqNk90tsfO5GpgqF0/npML+WhKfJW/VG9OKMJOe8ZuT1B6yQw3b6S?=
 =?us-ascii?Q?z8CQ9Th76Z3s3OFZKiRg929WWsuj79frkB0HmVgNds6fT0EBjBPfBjGeHGuq?=
 =?us-ascii?Q?diMo+X99i1X0fW6PjP2ZYokt1tbu25fQgBboFkKOW88OP7yw9R9mp7nxugsD?=
 =?us-ascii?Q?43A83VoauY7AHnxB4hidcgUp/UDN4+YCP/XBNm/v3uxJ9NnEP1YNjfgXdsf+?=
 =?us-ascii?Q?T+2zf60kDWgGP1B7I8woUPCZZo2UqD15yLtzA348qbsnGLe+9CthoRkKci01?=
 =?us-ascii?Q?2gzl0z2rVn8KabVFPamhE2EQ9qteYCzMPR5DU1ZoqaDPxHzJH09QcLFmMpXR?=
 =?us-ascii?Q?iK5fU4/E6RkBItOOwD61yJ/BmzG87WUPc+3vCAEG5ualNOEcviaVsDnwoZUt?=
 =?us-ascii?Q?1Ws6pu3hRGz29my+DBfZSalDzqG/LYWFuedqW3bfAaGk7W9piqdBf7h7YvDg?=
 =?us-ascii?Q?VYW9UsyCUlnMgEp8An/kKWUh/9OovhW/D000XHrxWk6mnqtGK6IeYDOGLi+C?=
 =?us-ascii?Q?tx6EWEw3F+uhfUxuvzXh4rVRH4Gx1TyD8B2kFj+szA0zFuCijEv9+Zl2aePv?=
 =?us-ascii?Q?s7S/y7cdMQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78c11960-e167-41d1-8f55-08d9c168a324
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 14:22:21.0514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1OSRpHoD6XxzhMwHiSwp7bQ9CSYTYvebx2XMLD18rYTlTIlRl1RCSmMZTvW6IF1JPfEe30fOwGW9XyUAcNNqRElgr/G3+2/bbH+LS6fuUX4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5469
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

