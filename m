Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E42EF6D223B
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 16:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbjCaOTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 10:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232656AbjCaOTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 10:19:32 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2081.outbound.protection.outlook.com [40.107.102.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777121D2FB
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 07:19:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cbMpJbuIpEFD3gw3e9yZTssF/bay2c34vdLo7Sx/L2VKHCE6+acLSjUgfHGkcnkHELfFbzO0YrSVltaR79dtQOMIA1XH03ZHbm5OLV23fGBpWiFvqe4Xv3xwEQ5u5ozF6IePzpA28vafe669a4Ix97w1LgEsn2gCCN+o/3L6JpHoCFvQj22UlxD0uI/4shyowzob6M6ZRU/g/gEadVs/Q0zA/EziiKiQGeNa6D5qkMNHbmCuarIjqjiK2qWYXxRNN1NiWTLzocqNvvG7E2VgggBcKTQOIbSMUu/uGYsbqJSQFkfUMflLz6CHQN3Dct1V0stwkmzWSuOOfCdlOuOQpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3TckyQwDjuBIqSd3fGC4eE4TvjNEYwdH+yM3XIcMsmk=;
 b=amrcP+RS+TzPJab4uqi9mXH48+cLcNsfYOKld4PXksYGEGG0BHRetANbP2fBeDBUnY7emgUGPae+KHX9GGNS8TsN3WD+jHRvzrbFzmswMNwRBGwS/FUpcewVfcvwOx5F506MkDKQsMcW7zbjaQwatOfhkE2Gj7xzIcT8hfDHhJvudKxBFG+Ncd/4udIqDfz6YXgepc9ZUktZkRDHQepRNXYU1fSTkBQNsgfn089GXUTTT5+1QIjNep4qQw6KUtsdUsgILjeONu3UMRp5Rqa9mkQSRFLkFMbnWww4Bm9mOx6lFOXrVXbBd62H5oP5F7yTycoI5t8NacIffmSUnfw8Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3TckyQwDjuBIqSd3fGC4eE4TvjNEYwdH+yM3XIcMsmk=;
 b=VqVKk5ci62pvbCrfny+aB68DmtLGx6k3SYN+bqHPNcwb5XDwla2W5GneMv3P8u7DtyWYSr4gosDyijydOAGFwk0kvwWPAvy6I9ujTMSsHDrggYpWoEZNQM4O6i5VyKEFlqT6jpr+LNeYlNMXL7ENZ5ICp+0yH/xRs3+Sc73GNMABNo7BgxgiP7FBsU78SAeXOaix5hHKJJIx3S+ora8kazrjB1vCTl1nJTGpMWTLGZ7qywFwfPFbRItvJ4TdI9fX8AChFmxL0MuhtQdMuRELZLg3RKziBB6nxwG2izPCJC+RCNrpPispvxsUjZR1MoVnPGDV50+VIxRjYlkCTFUB2A==
Received: from DS7PR03CA0169.namprd03.prod.outlook.com (2603:10b6:5:3b2::24)
 by SN7PR12MB6690.namprd12.prod.outlook.com (2603:10b6:806:272::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Fri, 31 Mar
 2023 14:19:15 +0000
Received: from DS1PEPF0000E646.namprd02.prod.outlook.com
 (2603:10b6:5:3b2:cafe::bd) by DS7PR03CA0169.outlook.office365.com
 (2603:10b6:5:3b2::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22 via Frontend
 Transport; Fri, 31 Mar 2023 14:19:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E646.mail.protection.outlook.com (10.167.18.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30 via Frontend Transport; Fri, 31 Mar 2023 14:19:14 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 31 Mar 2023
 07:18:41 -0700
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Fri, 31 Mar
 2023 07:18:38 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Vadim Pasternak <vadimp@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 3/3] mlxsw: core_thermal: Simplify transceiver module get_temp() callback
Date:   Fri, 31 Mar 2023 16:17:32 +0200
Message-ID: <e0cc8a345cb5051aa692422340d8810e99152c7e.1680272119.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1680272119.git.petrm@nvidia.com>
References: <cover.1680272119.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E646:EE_|SN7PR12MB6690:EE_
X-MS-Office365-Filtering-Correlation-Id: d92aa8a2-13b9-4e63-ab8f-08db31f2e831
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Oopp54bPsNIdxH4nzj4kLMDgcp7dvmonkLXQmdRzmuzDmZZChnWGYyex6ahmKd42NTlurP+RqUeAXDkv7T+skXkPOWuOnftQMZQdw0xNzozXLj567T3l7ewtR+lOGcgG/OagVZwst5Uemy466YHCUHMZFbiC6wTmEMAy2T1CClYuWCtslkDx5FY3BPoViD6hpk9VlyFAOh30f1J4aK9sWD29w8Go+Ubkusm1uJ+E+d3fhU82WVsoAodqP3l6FtkREIJG52t7aKirQ92wWF4WbQLSGsssDQXbgOOfBDjP5QNN7Aac7tifAjp2GCZX0Uf+/hauOZg26lqxxpz/nWGyHx6nboETiakMtsUVWlwQZV6AHzjkKS6UjxwwSB3NYz8KtXq7RmpWT+52tV7Vg2TBJGbQ2V79Z7XNrRTgBkGoADV6bWCcwcfnMOcgrQq7BFav19JJT0UgwEQQM5RguoHn4LgLfWVqwP2l5hu9HIRWZIfd2PQbtOjz+4tEEwKFYfOjTgUaLaVc3p2Egt0QYHPqSyc6RnqwrcFd6p9pt7l0NBIHfqxcDBV89hLLLd7CsvXP3pLv+hX/4R6x3oraKtnHauKqVQjto9q4NWuZdsAo9SsstpQNPIVsktXzCO+DOQIMW8x7vTThO4TlYz5CoGEmdStfrguGSwMtXd0V04GZEqHmghJtNbdakqzzGvqmICZOAA3mWakNeopIWfXl53z81IjvlpwRJgAHv3Cq3um7GnzmL86XumVGccHU9SFBY4m3
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(396003)(376002)(136003)(451199021)(36840700001)(40470700004)(46966006)(83380400001)(6666004)(36756003)(86362001)(7636003)(70586007)(82310400005)(5660300002)(8936002)(40460700003)(8676002)(356005)(2616005)(82740400003)(70206006)(4326008)(41300700001)(40480700001)(47076005)(107886003)(426003)(336012)(478600001)(186003)(2906002)(36860700001)(110136005)(316002)(16526019)(54906003)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 14:19:14.9066
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d92aa8a2-13b9-4e63-ab8f-08db31f2e831
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E646.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6690
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The get_temp() callback of a thermal zone associated with a transceiver
module no longer needs to read the temperature thresholds of the module.
Therefore, simplify the callback by only reading the temperature.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/core_thermal.c    | 44 ++++---------------
 1 file changed, 8 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index f0c5a2c59075..deac4bced98c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -283,50 +283,22 @@ static int mlxsw_thermal_module_unbind(struct thermal_zone_device *tzdev,
 	return err;
 }
 
-static void
-mlxsw_thermal_module_temp_and_thresholds_get(struct mlxsw_core *core,
-					     u8 slot_index, u16 sensor_index,
-					     int *p_temp, int *p_crit_temp,
-					     int *p_emerg_temp)
-{
-	char mtmp_pl[MLXSW_REG_MTMP_LEN];
-	int err;
-
-	/* Read module temperature and thresholds. */
-	mlxsw_reg_mtmp_pack(mtmp_pl, slot_index, sensor_index,
-			    false, false);
-	err = mlxsw_reg_query(core, MLXSW_REG(mtmp), mtmp_pl);
-	if (err) {
-		/* Set temperature and thresholds to zero to avoid passing
-		 * uninitialized data back to the caller.
-		 */
-		*p_temp = 0;
-		*p_crit_temp = 0;
-		*p_emerg_temp = 0;
-
-		return;
-	}
-	mlxsw_reg_mtmp_unpack(mtmp_pl, p_temp, NULL, p_crit_temp, p_emerg_temp,
-			      NULL);
-}
-
 static int mlxsw_thermal_module_temp_get(struct thermal_zone_device *tzdev,
 					 int *p_temp)
 {
 	struct mlxsw_thermal_module *tz = tzdev->devdata;
 	struct mlxsw_thermal *thermal = tz->parent;
-	int temp, crit_temp, emerg_temp;
+	char mtmp_pl[MLXSW_REG_MTMP_LEN];
 	u16 sensor_index;
+	int err;
 
 	sensor_index = MLXSW_REG_MTMP_MODULE_INDEX_MIN + tz->module;
-
-	/* Read module temperature and thresholds. */
-	mlxsw_thermal_module_temp_and_thresholds_get(thermal->core,
-						     tz->slot_index,
-						     sensor_index, &temp,
-						     &crit_temp, &emerg_temp);
-	*p_temp = temp;
-
+	mlxsw_reg_mtmp_pack(mtmp_pl, tz->slot_index, sensor_index,
+			    false, false);
+	err = mlxsw_reg_query(thermal->core, MLXSW_REG(mtmp), mtmp_pl);
+	if (err)
+		return err;
+	mlxsw_reg_mtmp_unpack(mtmp_pl, p_temp, NULL, NULL, NULL, NULL);
 	return 0;
 }
 
-- 
2.39.0

