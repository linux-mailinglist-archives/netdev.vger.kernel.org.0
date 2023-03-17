Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 497AB6BED16
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 16:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbjCQPfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 11:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjCQPfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 11:35:24 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2070.outbound.protection.outlook.com [40.107.100.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF19D4780D
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 08:34:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lfi3Q0HgFg7JIpyr2LvLtrlrplkjyHMxqnOeAu2TaoY3AjzLjrW+nEBk4nXOP7NuaG6VNRznTyo4oKAzla3sx3IMXMSnCWiZ3Ub5nTiQBBGt5RzNB3jzpgSjGt2M/wHp5X+ctmNJaE6/Z2bIP9wZkGi6EkaVtVOp0DblTsl4eBcxM6JzslOAvGoCLQTCULL7I2rOWMD66oVyhLDTIfFf7g3fQq7iymx8ShzG/KDETEXLSyRdWq09PV2WUbVhwFsRnaYAZznopmnRuTT4byJWG8xuMM0RbtBzrLjbC55AYErQLuPCh9mu2R6MaqlS02iTfpkvWk4pGLpqaBBIFnCLEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XCFcIbShxvbWJQ4tOnwaRpqxgJr5BzpzTfaNEf3kDfU=;
 b=RP/F84AZW5ng5DIAG5C855/6y71mD14qkoAPme9K1GXMM5Xi4zd8PvWn9K5JIQxEEmOzSmdP4K8nsdvWBBUBHS/WqQWtgrK1LLG2lpAQa5fN1wufatJ1A5uLBPPovOH+fR7RQgKIA20dkMWXPa77vj1GGFjkg9WIPpoqP7V7lzCtUhwp+mE5/cwbX34WTeuv3GX2Y/0/79OUjHmPIvqngFbCruhmSpJJMPUGGPno7CQqKHwVLv1YG9k2JQBwD9AGr6+obqRX548Oj+gVajkZ+dELOrtC+Ba5zpAErPr8lEbTTG5wn9xDD1YP1AGATSU9t9sfdag43L899wLaCEMrFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XCFcIbShxvbWJQ4tOnwaRpqxgJr5BzpzTfaNEf3kDfU=;
 b=kmPkMgxDUQyMtditBORtgXLLBI8YWkJngo4QM1jld1gOKXb4LyT704Glnsao31oAal7H/g8KDntRuINX12HA8HZ67syhxD0GyIjdCpWBfECXHtIwnM10qT6Gf94W82nbk2ia8AtLaKrhaMexrCfIIQi8PXniMpYuI+crm67givOBp40EJ5yhU71xsRF1pTZ+sQmPX839Y+YFzANs9c59FzDWqBddUYhhLKEB+U0RRSPUcGGPCV8nJDFBWM1ldZmdhdRdNR9jPxazMUXUv2ID9eziJHs9OoiDUGh33kIIEpW/O/IjW2fPLaBL6QNGK5rAOQDnhIQNNOeq9fbNCGtQLA==
Received: from DS7PR06CA0044.namprd06.prod.outlook.com (2603:10b6:8:54::20) by
 PH0PR12MB7012.namprd12.prod.outlook.com (2603:10b6:510:21c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.27; Fri, 17 Mar
 2023 15:34:23 +0000
Received: from DS1PEPF0000E64F.namprd02.prod.outlook.com
 (2603:10b6:8:54:cafe::78) by DS7PR06CA0044.outlook.office365.com
 (2603:10b6:8:54::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35 via Frontend
 Transport; Fri, 17 Mar 2023 15:34:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF0000E64F.mail.protection.outlook.com (10.167.18.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30 via Frontend Transport; Fri, 17 Mar 2023 15:34:22 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 17 Mar 2023
 08:34:10 -0700
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Fri, 17 Mar
 2023 08:34:07 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "Jiri Pirko" <jiri@mellanox.com>,
        Vadim Pasternak <vadimp@mellanox.com>, <mlxsw@nvidia.com>,
        Vadim Pasternak <vadimp@nvidia.com>
Subject: [PATCH net] mlxsw: core_thermal: Fix fan speed in maximum cooling state
Date:   Fri, 17 Mar 2023 16:32:59 +0100
Message-ID: <573c8b3049fadb8b7353986427aeee915cf182f3.1679065970.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E64F:EE_|PH0PR12MB7012:EE_
X-MS-Office365-Filtering-Correlation-Id: f178cdae-62f1-41ab-efbb-08db26fd151a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nvDxOQ+me1Z2XoOUZ68/mUy9S64TBqWQrEnnuA1ADXcYhLXAch2NBpsf0S6xH7E+KiJcrvyh/TCaACLl57ZgwJrHxvDGYXYzGNsBdm2DaU2tGH41OHF46hox2gd6PrmE6bg01cgpv4UDK47Iz1cHTryQGAORlSBBzsdp+wCNyafSHKLXm3eK5975mlLUZ6+yokMXN2N3YDDphULI9hQ9GIe7ul+ig/e4HrU0mdSvf/cmZ3zemFeNAQ+1QJZCGaegfk7H3Q8ips1TDbXPb6L3Q8emCTEq/2KTpR6I1Wh4scTUTUzmej/yoCCSqrhK/WRhFXD1T9bTF90i8q+e775sMF3jclcF8vzq6keJINCyAi8EnXM0/+CrC4D93wOx82sbcPfeW1VZk6gHVQSvAiGtDZWXs6Krxwt9Nb626fnTqWMYst26m2ZCJA9grpc0iS0lycNavdbolm2R4IKiwVUQubR3hxQUQ7dpoEgyrVi1l9c4CpsgBPfiYO0PUAR9kR5OD+jPhTfvBPFAMQIUUJ2F83uaCWvsIzkGTwpG1USUjx9X2wKCAzG1WOCFeliy0OOz8BbCYkX/pIsv+NP8r+o8nM8KQtpd5LmoHF7PH8gwQ8tJsb/F1xC5T+XbiD+PtERt22oEqxo9RHu/QZTD9udaAHNN3TyvSaj9wm0egCjZ25sV+PxVlbNH06KTdD2m5jW3OtKKz2GDhh0Kx5X/4fyn+BiG1xvTmsoX2w92rE0XKM+scv/ov3I0B4zQTGwKJCxG0A414E3UqrQsIPmiik7P+HbvvNokmunNYxsDi/CYHIM=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(376002)(396003)(451199018)(46966006)(36840700001)(40470700004)(426003)(83380400001)(107886003)(316002)(478600001)(36756003)(6666004)(82310400005)(54906003)(70206006)(110136005)(356005)(82740400003)(336012)(36860700001)(26005)(47076005)(41300700001)(8676002)(40460700003)(4326008)(7636003)(86362001)(186003)(966005)(16526019)(2906002)(40480700001)(8936002)(70586007)(2616005)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 15:34:22.4162
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f178cdae-62f1-41ab-efbb-08db26fd151a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E64F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7012
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The cooling levels array is supposed to prevent the system fans from
being configured below a 20% duty cycle as otherwise some of them get
stuck at 0 RPM.

Due to an off-by-one error, the last element in the array was not
initialized, causing it to be set to zero, which in turn lead to fans
being configured with a 0% duty cycle in maximum cooling state.

Since commit 332fdf951df8 ("mlxsw: thermal: Fix out-of-bounds memory
accesses") the contents of the array are static. Therefore, instead of
fixing the initialization of the array, simply remove it and adjust
thermal_cooling_device_ops::set_cur_state() so that the configured duty
cycle is never set below 20%.

Before:

 # cat /sys/class/thermal/thermal_zone0/cdev0/type
 mlxsw_fan
 # echo 10 > /sys/class/thermal/thermal_zone0/cdev0/cur_state
 # cat /sys/class/hwmon/hwmon0/name
 mlxsw
 # cat /sys/class/hwmon/hwmon0/pwm1
 0

After:

 # cat /sys/class/thermal/thermal_zone0/cdev0/type
 mlxsw_fan
 # echo 10 > /sys/class/thermal/thermal_zone0/cdev0/cur_state
 # cat /sys/class/hwmon/hwmon0/name
 mlxsw
 # cat /sys/class/hwmon/hwmon0/pwm1
 255

This bug was uncovered when the thermal subsystem repeatedly tried to
configure the cooling devices to their maximum state due to another
issue [1]. This resulted in the fans being stuck at 0 RPM, which
eventually lead to the system undergoing thermal shutdown.

[1] https://lore.kernel.org/netdev/ZA3CFNhU4AbtsP4G@shredder/

Fixes: a421ce088ac8 ("mlxsw: core: Extend cooling device with cooling levels")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index c5240d38c9db..09ed6e5fa6c3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -105,7 +105,6 @@ struct mlxsw_thermal {
 	struct thermal_zone_device *tzdev;
 	int polling_delay;
 	struct thermal_cooling_device *cdevs[MLXSW_MFCR_PWMS_MAX];
-	u8 cooling_levels[MLXSW_THERMAL_MAX_STATE + 1];
 	struct thermal_trip trips[MLXSW_THERMAL_NUM_TRIPS];
 	struct mlxsw_cooling_states cooling_states[MLXSW_THERMAL_NUM_TRIPS];
 	struct mlxsw_thermal_area line_cards[];
@@ -468,7 +467,7 @@ static int mlxsw_thermal_set_cur_state(struct thermal_cooling_device *cdev,
 		return idx;
 
 	/* Normalize the state to the valid speed range. */
-	state = thermal->cooling_levels[state];
+	state = max_t(unsigned long, MLXSW_THERMAL_MIN_STATE, state);
 	mlxsw_reg_mfsc_pack(mfsc_pl, idx, mlxsw_state_to_duty(state));
 	err = mlxsw_reg_write(thermal->core, MLXSW_REG(mfsc), mfsc_pl);
 	if (err) {
@@ -859,10 +858,6 @@ int mlxsw_thermal_init(struct mlxsw_core *core,
 		}
 	}
 
-	/* Initialize cooling levels per PWM state. */
-	for (i = 0; i < MLXSW_THERMAL_MAX_STATE; i++)
-		thermal->cooling_levels[i] = max(MLXSW_THERMAL_MIN_STATE, i);
-
 	thermal->polling_delay = bus_info->low_frequency ?
 				 MLXSW_THERMAL_SLOW_POLL_INT :
 				 MLXSW_THERMAL_POLL_INT;
-- 
2.39.0

