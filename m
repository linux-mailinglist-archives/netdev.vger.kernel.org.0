Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1CB4233D0E
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 03:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731067AbgGaB6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 21:58:33 -0400
Received: from mail-am6eur05on2083.outbound.protection.outlook.com ([40.107.22.83]:58208
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730794AbgGaB6c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 21:58:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=baDI+V42+I0jKku3jB76d8R22QZQrIzp+hfDmRhzNJVEScELFxBrFsIChRFiT5l/YfGtuDv6+Hndq41ltAdydeDG8nFrXyfExKYo+D0+PLacOB10IK7pnVzEW+49nOA3vaFPkeaCfmuU68+WwDePrWfBslT2bw+10+zMK2FmDN2iPD/Chu7ou9eaQzqmkFh0eHBVfgPlCXlsCRvbjjbqvCkDBrMVB4znKXVjDtAvExDVF4XqDsPTvtGELqUhlnHJJbWhcgA+rE+RVkCwPgEDSo0D4NEGQhnek2SqYPm6n9hJeRSjsKWtwkuiUxa/T82UydqqIRxuEbt5CZofiSAwxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2YhdoLwh/GuHnrxmwhVgvEcWtl/4whsAepUS7meUxRw=;
 b=aeJZOuTOQI2SBCuHZmVL7d766WOlxJiHsmwrsejPlanLizWWYKV/NevSUBQBtWNrwu1T97ceEFPy0FHT6Urf9qMq9e+uIWjPJd35S/qjCYGnYgnGTgZKuS7OlFIZyE0CA6Af2jnGSR+MO1C5gtZYxqfxJjDWsc+p8k52AbsRd1XtOd3Uem3P7CjDPDi6B26mRQZCJ6jwqPleZeNytBY4cjKhZzVKDg/ngqBr+sLD3UPIjynXbrQbApZvo0t19qmnIGbiO+Rm0zmMB0259VIpqVGs1xU69dxj8at4lzncQwAdtZ+SwyfVj0UJ9pxngtgTTELHRF4F97JizX0lvJ16zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2YhdoLwh/GuHnrxmwhVgvEcWtl/4whsAepUS7meUxRw=;
 b=LOlZt+z9aCjwLgyzp8q1s5f35AGJoT/WMIVPGSnA868XVMSNkxQtfM9epKrz8I+uk0xhmLdKCHCnit6cjRK/09hjNARobR3TuPwTzzt+BV/nyNNIF09Z3HSx7GqGWviea3bsvr9zrjTRraePCoUhSDjlJJPja08qcpV73eFNylI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0502MB3997.eurprd05.prod.outlook.com (2603:10a6:803:25::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Fri, 31 Jul
 2020 01:58:21 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Fri, 31 Jul 2020
 01:58:21 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Jianbo Liu <jianbol@mellanox.com>,
        Chris Mi <chrism@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 3/4] net/mlx5e: E-Switch, Specify flow_source for rule with no in_port
Date:   Thu, 30 Jul 2020 18:57:51 -0700
Message-Id: <20200731015752.28665-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200731015752.28665-1-saeedm@mellanox.com>
References: <20200731015752.28665-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0075.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::16) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0075.namprd07.prod.outlook.com (2603:10b6:a03:12b::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16 via Frontend Transport; Fri, 31 Jul 2020 01:58:19 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 443bb0ab-8661-4fd5-b419-08d834f533b7
X-MS-TrafficTypeDiagnostic: VI1PR0502MB3997:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0502MB3997894FBD05663E9BAFD0BABE4E0@VI1PR0502MB3997.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1417;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZYXrp8I07ec1ZNh1IHcbS8A6MgbQRFmVmVwcWscfMgmVTLUOlp/szsGIflhzSqIUOrDoijHccTPFYvLNmjeOE5B6OY1gyoQJHx61qEXjf1D4gdakloDy6bJhy3XzQskT170HO/ejubgPfep14Bq8IbVjyG1w3gxQqSgIBSVU1XuDp+45LOw/dqkD2GtlIgTWj1/ew0rHU/RZ7i8eZxPPrZDSTDcyYXytNjPqU1FmHUA/BnlG7jMgceCDRsgHRM9Cw9g4ftP2JHSgh9iR/3sOaiRmtIcQZIwNdo4+Yy2P+iPirXAY2ddOy7mroNdFMp8eCOtqPrA9rKG9AssyE4URkzEgg3XnV0d/JFRWicNC8jMEfmBT+SpErckEby9P0Eg6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(346002)(366004)(376002)(396003)(4326008)(5660300002)(1076003)(16526019)(6506007)(6666004)(52116002)(186003)(26005)(478600001)(107886003)(6512007)(316002)(54906003)(6916009)(8936002)(36756003)(66946007)(66476007)(66556008)(2906002)(83380400001)(2616005)(956004)(86362001)(6486002)(8676002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 4uWwynlo0YSNeOQZDXVGmM1f/N6P0o6R+E2fdyIflMENaRjYdOBx/teKateZEBEzxBIz/hfLjOEFePwhopbauotdDoxCa66q0d1NO+Ehra6fTq1jSbvElMUu7r81ciema/iS6PzQb6zB/owJA0KnGo+ztF8qlDK7I+Tw+vgO5iz5uiOT4bwDFB2EVgqup0lSFGv7pRG7jzCgoD2CftJSW+h+oKaOzP3Zv5yzGopdfZTMpa7/ZeqK1QPn5QEKTuqDC0PCtlVTPPVvA8WRY623PzLBhc7fgZPF7D6AJS5GsWHgoYa+h8Dmmr07H/8ZvTpkTZBmWcHpQJmCn6+cIMnPMtSedkjUe700d3xeisA4KC1R33UfllWv9jPVrpXWOBOsl+5LmvmjIl0RBn5c2ZCuanbkNbs55EX4FApJ5a5ZG5iVN1htb1uRhZs3WxlirMHa90tBsQSV4NCKTWHF65yPGa+xoeB+HWi1EshHQQPdj6WsdFJacOdZoylYvNfc71809R4E+ml9NUg6BQ0ByD0geUjBF6ckcBtwXvvsuojOjgJlqN1bAJXgQw5D12NQnYNQ+LvgW2jbfwN/xBMvODkhP5dBVT/OYl+Oen5cQkWNDziOPcvgToeAOSA8cCEDTz8fX3Sizb2wgo7W7Sbe+LY0yg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 443bb0ab-8661-4fd5-b419-08d834f533b7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2020 01:58:21.4170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GUqzOb5yhfhn45YLnv4QXB0Erm+MoZKJbcKolsvjZ/s/wABgw/qzCXPteOYwVycxW26TrV48tGZjaN0i6dUe6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB3997
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianbo Liu <jianbol@mellanox.com>

The flow_source must be specified, even for rule without matching
source vport, because some actions are only allowed in uplink.
Otherwise, rule can't be offloaded and firmware syndrome happens.

Fixes: 6fb0701a9cfa ("net/mlx5: E-Switch, Add support for offloading rules with no in_port")
Signed-off-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Chris Mi <chrism@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c     | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index d70d6c099582c..ed75353c56b85 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -236,6 +236,15 @@ static struct mlx5_eswitch_rep *mlx5_eswitch_get_rep(struct mlx5_eswitch *esw,
 	return &esw->offloads.vport_reps[idx];
 }
 
+static void
+mlx5_eswitch_set_rule_flow_source(struct mlx5_eswitch *esw,
+				  struct mlx5_flow_spec *spec,
+				  struct mlx5_esw_flow_attr *attr)
+{
+	if (MLX5_CAP_ESW_FLOWTABLE(esw->dev, flow_source) &&
+	    attr && attr->in_rep && attr->in_rep->vport == MLX5_VPORT_UPLINK)
+		spec->flow_context.flow_source = MLX5_FLOW_CONTEXT_FLOW_SOURCE_UPLINK;
+}
 
 static void
 mlx5_eswitch_set_rule_source_port(struct mlx5_eswitch *esw,
@@ -276,10 +285,6 @@ mlx5_eswitch_set_rule_source_port(struct mlx5_eswitch *esw,
 
 		spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS;
 	}
-
-	if (MLX5_CAP_ESW_FLOWTABLE(esw->dev, flow_source) &&
-	    attr->in_rep->vport == MLX5_VPORT_UPLINK)
-		spec->flow_context.flow_source = MLX5_FLOW_CONTEXT_FLOW_SOURCE_UPLINK;
 }
 
 struct mlx5_flow_handle *
@@ -377,9 +382,6 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 		flow_act.modify_hdr = attr->modify_hdr;
 
 	if (split) {
-		if (MLX5_CAP_ESW_FLOWTABLE(esw->dev, flow_source) &&
-		    attr->in_rep->vport == MLX5_VPORT_UPLINK)
-			spec->flow_context.flow_source = MLX5_FLOW_CONTEXT_FLOW_SOURCE_UPLINK;
 		fdb = esw_vport_tbl_get(esw, attr);
 	} else {
 		if (attr->chain || attr->prio)
@@ -396,6 +398,8 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 		goto err_esw_get;
 	}
 
+	mlx5_eswitch_set_rule_flow_source(esw, spec, attr);
+
 	if (mlx5_eswitch_termtbl_required(esw, attr, &flow_act, spec))
 		rule = mlx5_eswitch_add_termtbl_rule(esw, fdb, spec, attr,
 						     &flow_act, dest, i);
@@ -462,6 +466,7 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 	i++;
 
 	mlx5_eswitch_set_rule_source_port(esw, spec, attr);
+	mlx5_eswitch_set_rule_flow_source(esw, spec, attr);
 
 	if (attr->outer_match_level != MLX5_MATCH_NONE)
 		spec->match_criteria_enable |= MLX5_MATCH_OUTER_HEADERS;
-- 
2.26.2

