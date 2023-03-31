Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 645046D2239
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 16:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbjCaOTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 10:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232630AbjCaOTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 10:19:05 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061.outbound.protection.outlook.com [40.107.93.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D632031E
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 07:18:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZgElVJ49kDNZDK1jzMW+5OlnwNywGUXRG6NFToSSlF3eQJCpWISbyYxyPTp/RIsKr9qmNAKCBPwzB3PsKQkI5aEY9XVqOauOvrW3v8iSQ0DmxlcOBwwX64Fo3SrtWYTeIUeR2MKakTJ9OCPCW6e2ofmPvbVC4tfj6W3W1Mf8UczKQFaIHMNpaHgoU02vbWch9cJ3FilobdjXYbfS1pWVb5h6FS86R/38F6uyoK5viCDY2E1dDCEOpqYzt8opg2zZzN1rpmFviRSLBAPFPTCIqJn1L7lwyte+i2Io9568iJV5h1RzDvrrHpDNAYqaZh1DwB9vYo9qXgpGQZByIWfKXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AxPTxMy7EcQz+6e/R6D5c1ghoB/xIoPyzBd1g9hENL0=;
 b=Y4TtcJ3Op9NHA2ehxXh9pSPXxh5GCrjq0sk/N4cAWB/4b97Hek24j/2f+UuBpS3nu4KKXvQu+A+RWKw45ROZJZ9BMmb6XBooF5EuYX6xIN97D/NFsBY8gLQEMnlj4LMHmc+442/VYjz0KyllmbWQj09oUTCUpIcDRZ48RsVZlhHYV/yv9q67DyNhLXdlP+VC1JgVyojZDpw0F2ZObtm/+yqTpBYS88r5pGckKYKcZJ9cy7wHOHwQve93GgauTmvK50i7wxRARrWjnVqDSgha3J1JjYa6vTYOMz9qbvgEj/Ijbv9vduIWKAJ2CjT9fYHhL7/U+bPC4FDVsYvmeL+Nvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AxPTxMy7EcQz+6e/R6D5c1ghoB/xIoPyzBd1g9hENL0=;
 b=XsrpfjuvuDu9/wecvv5+i1RKk9LAZjnoVdvBW8cgeFENNUVU9K8+auN8yPCSeRKV7C0IQ6/lHBOKNJ0lqXeNiVFz7gLo5ehOX7uQzOstvraarTK7fSKkBbpmqaqJfcvXWB9thYY4QmkCuBSHrQAr4WapU8kVNOJ7PyIzea/Ngxo7LcFc34MSUsoPugN1LK7KORCzNxrqsbysZUxXGEnL0Vd2EH/Qp8y2HzHAZNS/KEwnIkyYerBahL22zxwksZbiTWi73aNaDeTl4XVdnS0Y4mBZI/nUMhJozelrLubhL7b3z79P/rHejsbFGP1J+Cv629lOg+AMaLsFZLbtyiT1dQ==
Received: from MN2PR10CA0012.namprd10.prod.outlook.com (2603:10b6:208:120::25)
 by PH7PR12MB8054.namprd12.prod.outlook.com (2603:10b6:510:27f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Fri, 31 Mar
 2023 14:18:57 +0000
Received: from BL02EPF000108EB.namprd05.prod.outlook.com
 (2603:10b6:208:120:cafe::fb) by MN2PR10CA0012.outlook.office365.com
 (2603:10b6:208:120::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22 via Frontend
 Transport; Fri, 31 Mar 2023 14:18:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF000108EB.mail.protection.outlook.com (10.167.241.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30 via Frontend Transport; Fri, 31 Mar 2023 14:18:56 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 31 Mar 2023
 07:18:38 -0700
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Fri, 31 Mar
 2023 07:18:35 -0700
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
Subject: [PATCH net-next 2/3] mlxsw: core_thermal: Make mlxsw_thermal_module_init() void
Date:   Fri, 31 Mar 2023 16:17:31 +0200
Message-ID: <7f2b22b660fa20f0a4cbed0126b579e40af44dba.1680272119.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF000108EB:EE_|PH7PR12MB8054:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b342055-5023-4840-e8c1-08db31f2dd8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qZjaxz6y81wPg11d9CIPoCSfb3dzT03KN6uCQJcNTU+8aLm6j7WAuMIPd+eOZ1lzf6HoNwb4L7cEZMzUj+FmB7Xp04nU5BNi1CjlcJ05mGZeZsLWSV1CWToTGYyHWxn6quE1lATXhV1fU3PT9KlAgtSC7raP4c7jrsDDbdD5+YTsVLp4bxov5VdNxIjSQIABBSzb5qPDAY5I8Zgi5WyqcLQFALtE+KGdlChWppo+drIQCBzyAevM5VF1Kly6hfHv6wzhkTdkMadu2UBiYr9xDOdE9ZnJbhWrPAnsUsFFIlXnXiPjcAymj2qtOolWuknsL6+RuvT9kC1LCSz8gwJsUMWuj05+gEN8o55mhRD3tCm3l20DkQa+mVEsZicDJoXPb/VE8I6hyxZ+fcrZo3C2sMVERqWIaWtKtGuS2iHZcgo8016TgEDWmMewtafPqPP9KQAGVqmqXnR+rH9a1JHVM6wViFDvAiiQg6BJf1DLV+rlJeBL7H1W62lxfwFzQjOA5RtM7BeUxwadS+BVCrgaj4sSMRrOYhjIjeluzhaOxkJJCmkum/f/sUQsH8YR/vz53Q00Oi0G2sCpGLIGkNFCRPzuy0D8PgnfQAt7CtO101zl4nU7wYhMiIIu3ohEI0LVMyUuT6tmv0xHqrd82DUgrmw2nj3cRdh6/6D9tVkz5kpE3TFHhpgc3DA6PU+Lq2k5eCg3lxxKDuhFv0VSNkgcFDqPT7IqsWJhPHlURsn3X5lsjlIsePGcNW44y0WEOYyI
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(39860400002)(376002)(451199021)(40470700004)(46966006)(36840700001)(7636003)(8936002)(40460700003)(2906002)(41300700001)(5660300002)(4326008)(40480700001)(82310400005)(86362001)(36756003)(356005)(82740400003)(316002)(26005)(110136005)(54906003)(70586007)(478600001)(107886003)(6666004)(426003)(83380400001)(70206006)(336012)(2616005)(47076005)(8676002)(186003)(16526019)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 14:18:56.9584
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b342055-5023-4840-e8c1-08db31f2dd8a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108EB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8054
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

The function can no longer fail so make it void and remove the
associated error path.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index ece5075b7dbf..f0c5a2c59075 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -470,7 +470,7 @@ static void mlxsw_thermal_module_tz_fini(struct thermal_zone_device *tzdev)
 	thermal_zone_device_unregister(tzdev);
 }
 
-static int
+static void
 mlxsw_thermal_module_init(struct device *dev, struct mlxsw_core *core,
 			  struct mlxsw_thermal *thermal,
 			  struct mlxsw_thermal_area *area, u8 module)
@@ -480,7 +480,7 @@ mlxsw_thermal_module_init(struct device *dev, struct mlxsw_core *core,
 	module_tz = &area->tz_module_arr[module];
 	/* Skip if parent is already set (case of port split). */
 	if (module_tz->parent)
-		return 0;
+		return;
 	module_tz->module = module;
 	module_tz->slot_index = area->slot_index;
 	module_tz->parent = thermal;
@@ -490,7 +490,6 @@ mlxsw_thermal_module_init(struct device *dev, struct mlxsw_core *core,
 	       sizeof(thermal->trips));
 	memcpy(module_tz->cooling_states, default_cooling_states,
 	       sizeof(thermal->cooling_states));
-	return 0;
 }
 
 static void mlxsw_thermal_module_fini(struct mlxsw_thermal_module *module_tz)
@@ -529,11 +528,8 @@ mlxsw_thermal_modules_init(struct device *dev, struct mlxsw_core *core,
 	if (!area->tz_module_arr)
 		return -ENOMEM;
 
-	for (i = 0; i < area->tz_module_num; i++) {
-		err = mlxsw_thermal_module_init(dev, core, thermal, area, i);
-		if (err)
-			goto err_thermal_module_init;
-	}
+	for (i = 0; i < area->tz_module_num; i++)
+		mlxsw_thermal_module_init(dev, core, thermal, area, i);
 
 	for (i = 0; i < area->tz_module_num; i++) {
 		module_tz = &area->tz_module_arr[i];
@@ -547,7 +543,6 @@ mlxsw_thermal_modules_init(struct device *dev, struct mlxsw_core *core,
 	return 0;
 
 err_thermal_module_tz_init:
-err_thermal_module_init:
 	for (i = area->tz_module_num - 1; i >= 0; i--)
 		mlxsw_thermal_module_fini(&area->tz_module_arr[i]);
 	kfree(area->tz_module_arr);
-- 
2.39.0

