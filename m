Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC9BE2306C1
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbgG1Jos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:44:48 -0400
Received: from mail-eopbgr10075.outbound.protection.outlook.com ([40.107.1.75]:30084
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728461AbgG1Joq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 05:44:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FSWztOULouI0wOG1Tl+uAsnDzvjBhcOwp50hJZcgOoLfWomwnf7ayZHK6BSuxzi2JOEk7ffy6ads5pIu8M+XSP0V1P43XdINSNpYfCOuNhjTcwmgq+HrNdQ5Jf2cDdDzmPkZ9wdPBYCRoHWRM72+pJdc2mQr/89XdwyqRnUqvBCuyqc/KgzmyeWxwD4rowu97T7u9cfd0LZY65VO7XZIEA1JgSW22MapIrqmpltlle4rv646zpXMPgZKSDWz9+VJtoMa19K50LGHajj6ZKp3SlJSr/Tr5rtmCOtjbFV0IBVkfIfTpCPY++rElLmPrY+KbBpKOgzQTKjz6PUAEME/qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4o8kVmFy79LrYcSsWt3W6gIbpLeXBe/88uNOhxrlifU=;
 b=n+2afMRYe2/GIbZHRDJCM8a0iJO420Y8YUhfE+TM9wPsR0HLv1tVoyaTyMHOgzMxpLDa0XGrh3dhhob3/R3Fce/9atoBYjO87OU2kbTqJq3QyCSto1y8BVBxEkvcQjwL0fZQqmRVz4Dm5f70GujaC9W0U8m2KNMcisSPFhFHN36SELUEFXirdWA6rzQj1Ctch17Na2fQFBCYoYT/QuR1Pnw7ANCwEQfG9zMZ6MRmDociM5j6+sEmGPN/CtT7XfHy5vYudRO1Jlb599Q+6fKSbBjLzQjSDmbf5lLlZ739M/ADUyrLZvDxqLcWEYcgmghS1I/GGWKewQw79o00WkGhUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4o8kVmFy79LrYcSsWt3W6gIbpLeXBe/88uNOhxrlifU=;
 b=JfzIpNHfxnnxYNTGBTNxDhT/yH8Cc1DP+OVl9YZGqbwEfa/D6L0cZ5sU9qJVdc1l+6596T1VQ+3dqDSwObNpFoItb6yz/dC3T3fAd8bAAWUfVy/Tm+U7gaTuDzVXC1CEgOjlTg0L5qmnHQxRQlMB0chKmLvGkuBeEg44WXF34uM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7117.eurprd05.prod.outlook.com (2603:10a6:800:178::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Tue, 28 Jul
 2020 09:44:40 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 09:44:40 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Bodong Wang <bodong@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 04/13] net/mlx5: E-switch, Reuse total_vports and avoid duplicate nvports
Date:   Tue, 28 Jul 2020 02:44:02 -0700
Message-Id: <20200728094411.116386-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728094411.116386-1-saeedm@mellanox.com>
References: <20200728094411.116386-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:a03:217::23) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR04CA0018.namprd04.prod.outlook.com (2603:10b6:a03:217::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21 via Frontend Transport; Tue, 28 Jul 2020 09:44:38 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 596ff1dc-b217-4bf7-8332-08d832dad947
X-MS-TrafficTypeDiagnostic: VI1PR05MB7117:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB71173A3B7A73AB35A4D1D30BBE730@VI1PR05MB7117.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n4BreHoQNyErQk4wz62bD7pOe7p5La3qnHfLdIAPMm40VjDP219EdLo015UOY0PPwois961KkiVPObpSeQZOmM+YP7iiCSjvbrEBjJIs4+CK1oZaahuJGyTG63SOWPw8eUGVcOE21/P5qH52kwFjnOkTOoDIM3eYzARwB3Kx1GTvu3/lF4sDw3RJW1KiQpAToAESfNjqQxlu8SMiE9GAX6HmKIK6G3TipjQLFRwT1F6bd05V/VjNhFyZjg/43pCFy5XfnVjt15K0MPhy+IVwRX7tSnzo7/k0Vl/OeZ4nYCiCdC2aqcoDAcQx75SSWp3UChKXbupHcqVuf90E4mJKg8eLlTsAxhLmosrhoXO8QKhDtFg1o6lVx2K7LBknZFye
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(2906002)(83380400001)(8676002)(26005)(2616005)(5660300002)(186003)(6512007)(16526019)(52116002)(4326008)(8936002)(956004)(66476007)(107886003)(6486002)(66556008)(6506007)(6666004)(110136005)(54906003)(66946007)(36756003)(478600001)(316002)(1076003)(86362001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: yP/eZscqBlGdriqrk5xrz6IJK8646EzYcRfqI1NQt0l+Qk91b8IZEAXKFlMP2x9/xrALfmcCHpqdHQln01D/jVz/ZI02QtrHyz174bsEOXwKIyXa1NmkEh84cki6T8z1TRgTzSTf5DjHVke39u6SFEahwqB6gfGAPyEIo3iHgSG7sNAFTcFydjqtDRb+zmOBVgFBaYdLhB66OdNPh4xFRzLKO/J5UJJxTljprxBOXAccC1W+qQ4vrHirO7PG0jqdXy+TWUFeaUXG4cm9jueiZeMw6TNekO/h5i1yxyOj6qP1cBBIjdwmDAQiKhXU+iCtD6XersRqcQzg7McMKi/ARG6uBbJMysNdx6wJtWNt9Xn5LsXQiCoZVKwOayAL8OcvsrebofYEskwfDA09tLiWglNrWdXZ9hML3wUWcNoOk+GZ95LMG1SPoQ4RI0wz0X81z/pmP9s67OtYLKSrqkWF7Ji/tUVOslf8zOyKcNr1/5s=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 596ff1dc-b217-4bf7-8332-08d832dad947
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 09:44:40.6664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cb3YfBhmTLXFVa8r+9XPnqRjtMnMYwUAv9tbTEemkFLr/2kdWQzFcgsrac6xOJ8OJJ3sglaB96N09BNJYc4vlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7117
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Total e-switch vports are already stored in mlx5_eswitch total_vports.
Avoid copy of it in nvports and reuse existing total_vports calculation.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Bodong Wang <bodong@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h   |  1 -
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c  | 13 ++++++-------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index b68e02ad65e26..1f52b329e9152 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -271,7 +271,6 @@ struct mlx5_eswitch {
 
 	struct mlx5_esw_offload offloads;
 	int                     mode;
-	int                     nvports;
 	u16                     manager_vport;
 	u16                     first_host_vport;
 	struct mlx5_esw_functions esw_funcs;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index a21b00d6a37d0..6097f9aac938f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1132,7 +1132,7 @@ static void esw_set_flow_group_source_port(struct mlx5_eswitch *esw,
 	}
 }
 
-static int esw_create_offloads_fdb_tables(struct mlx5_eswitch *esw, int nvports)
+static int esw_create_offloads_fdb_tables(struct mlx5_eswitch *esw)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
 	struct mlx5_flow_table_attr ft_attr = {};
@@ -1165,7 +1165,7 @@ static int esw_create_offloads_fdb_tables(struct mlx5_eswitch *esw, int nvports)
 		goto ns_err;
 	}
 
-	table_size = nvports * MAX_SQ_NVPORTS + MAX_PF_SQ +
+	table_size = esw->total_vports * MAX_SQ_NVPORTS + MAX_PF_SQ +
 		MLX5_ESW_MISS_FLOWS + esw->total_vports;
 
 	/* create the slow path fdb with encap set, so further table instances
@@ -1202,7 +1202,7 @@ static int esw_create_offloads_fdb_tables(struct mlx5_eswitch *esw, int nvports)
 	MLX5_SET_TO_ONES(fte_match_param, match_criteria, misc_parameters.source_sqn);
 	MLX5_SET_TO_ONES(fte_match_param, match_criteria, misc_parameters.source_port);
 
-	ix = nvports * MAX_SQ_NVPORTS + MAX_PF_SQ;
+	ix = esw->total_vports * MAX_SQ_NVPORTS + MAX_PF_SQ;
 	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 0);
 	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, ix - 1);
 
@@ -1270,7 +1270,6 @@ static int esw_create_offloads_fdb_tables(struct mlx5_eswitch *esw, int nvports)
 	if (err)
 		goto miss_rule_err;
 
-	esw->nvports = nvports;
 	kvfree(flow_group_in);
 	return 0;
 
@@ -2005,7 +2004,7 @@ static int esw_offloads_steering_init(struct mlx5_eswitch *esw)
 	if (err)
 		goto create_restore_err;
 
-	err = esw_create_offloads_fdb_tables(esw, total_vports);
+	err = esw_create_offloads_fdb_tables(esw);
 	if (err)
 		goto create_fdb_err;
 
@@ -2459,13 +2458,13 @@ int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
 
 	esw->offloads.encap = encap;
 
-	err = esw_create_offloads_fdb_tables(esw, esw->nvports);
+	err = esw_create_offloads_fdb_tables(esw);
 
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Failed re-creating fast FDB table");
 		esw->offloads.encap = !encap;
-		(void)esw_create_offloads_fdb_tables(esw, esw->nvports);
+		(void)esw_create_offloads_fdb_tables(esw);
 	}
 
 unlock:
-- 
2.26.2

