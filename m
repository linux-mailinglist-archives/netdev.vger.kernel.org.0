Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA7A268A40A
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 22:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbjBCVCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 16:02:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233142AbjBCVB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 16:01:58 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDDB0A9D7F
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 13:00:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H5FKvjZut9ZXp1JjGx/yZtpdrGqVdQJVxcMrQOox4n+/oIeXPrN58NRhM/f0t9IzolMrbrhDINouu7YGWGyJgePljnOms+rFrvXmUu8l7Ych4f94JpOPGEwLzpGCcbVQNelnv7VOqM45iCIC44bOP+WH+ms2D0sveQnSfU9QYWTDKN4vYtAX0EJFmh2HGsI3bsXZrTxDAsLLLj7947ck6XzApKEALPU6y3B7qwYhVJ3MU9REtYQsSHeywZ+W5hvGD85rnyE0bTKsKtaxP41YUt5QmIVWlXhrsD+sHWindR165nyfPzZupBHsBSsevLQhHmNG1ffJekMSwfwQGnvwJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FiaHRZxbvmzTYkJtRrfUi4iDQ6ehUjZgEQN1ziyHkUA=;
 b=GgvmpsPX2viThj1TOL/UGagCJNp8tsqaR9z5QFA9gj7A97YFLam5MG9g98hcxELiT0dn4mNPupcSAgJRNo5UznpXF7A0y95VQPEWeYpBXpiJU2sgrbmVHZ48xUsDOjvHMS4MDDzkaUW5tAhyHJMzqJw1x0cjSuGaU3m2Aq+41GxtNzkKim8UFMclsq5ZNT1U4ve5LCTsinQmk1MBGEgsp5hDS96EVBWMval/DfHkda5Gu8EfDR1EoA8fm4Ok0MWzmtVAxfpW0xPzyltk27T7s9d5zrWhDdoO5y1Xe/gdpypBO+E/DgRHf9fJS/TEqTDVnE2Md9OqRiDzO7IiD0wf1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FiaHRZxbvmzTYkJtRrfUi4iDQ6ehUjZgEQN1ziyHkUA=;
 b=G18AhxTCznfJcxV7RGK0qkIX+Z6bPRmnWILbVsnaG+YNnPTQTNn5pKfnLeLLqiKOv/yvyIS3H1A2BXlFi3QMLddW135DYIj5Qr0uo0hkZSa4hFiadEA2YWVt6dTpa/LPK6lG1NSzppxbgYufgXobxCLHX+XQlv3Ez1HW5OOyllY=
Received: from DS7PR05CA0048.namprd05.prod.outlook.com (2603:10b6:8:2f::19) by
 IA0PR12MB7674.namprd12.prod.outlook.com (2603:10b6:208:434::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Fri, 3 Feb
 2023 21:00:41 +0000
Received: from DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2f:cafe::1e) by DS7PR05CA0048.outlook.office365.com
 (2603:10b6:8:2f::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.9 via Frontend
 Transport; Fri, 3 Feb 2023 21:00:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT010.mail.protection.outlook.com (10.13.172.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.31 via Frontend Transport; Fri, 3 Feb 2023 21:00:40 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 3 Feb
 2023 15:00:38 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH net-next 1/4] ionic: remove unnecessary indirection
Date:   Fri, 3 Feb 2023 13:00:13 -0800
Message-ID: <20230203210016.36606-2-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230203210016.36606-1-shannon.nelson@amd.com>
References: <20230203210016.36606-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT010:EE_|IA0PR12MB7674:EE_
X-MS-Office365-Filtering-Correlation-Id: a14f2edc-7b0a-4c26-573f-08db0629b543
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fmDCHBqi+YjZoLqGE24sRWQ5cGuAeTMWrpac6Ctpa5JTLwQIKih6/Gbja915qnVDpVdpbUD+AWcyYZxq/f4m8AfohDu+s4iLXotyL/sb6B4vxTuIUvjw8Weqxx8GKpiRuCOVX9djO1e33WbckfTzpa7US/G4vWBSu4S+NmgKAmqOxXS/5emQG35x7/GUVsNphFXSzpulZnRe9CtIIa+Hrk36b1vN/GzLLZmXRO6UvkQ6sqGaM+AI0Nqhl5pfH2kielPMFEYG97W1mnr+vHGVdpQmgJAB+Vjzo9o7vMogK/8b6krXC30aUqgF6b4LvCuT7LdpFGCMoVTFupo1Ji64TC6vK3HhJbs0VPfIoFnQX7pfXbPifAjn+AssJq/1AvrkJxSSp1Ti2oSG2fsAUDLe2VgpvJ16i//rdkqX26S1jtjwpX87QWZBbOqTcM8PIpJ4PysjuVWxTKUaPZaXlRxP3buQMwQwfWNJIp09x2vGaXLLXHgcxmICz994KAhoW1vT/vgRiL5ppN2YfEI4Yxot18n/PekdAhdpbF6Tn11d0Tmy0tE2kPRS7vdOsCUggsi+ZgUnC4OrGyBsvhb5hz4hGH4QB68X3/jry2wooqQfbRTi0bmTgxQKLEtd8aSOQCULUeBK3NgnlRYMktQSNmwqgw27ECd6a7MMOwRVaT3GX64ibbhYJx89zQqXQ6vwDmJBfi5/R5pZXFw8q+CFg4MoViByc0jnIbj0DffvPSDaV3Y=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(396003)(376002)(451199018)(40470700004)(36840700001)(46966006)(426003)(82310400005)(8936002)(36756003)(40460700003)(5660300002)(47076005)(44832011)(110136005)(1076003)(356005)(54906003)(6666004)(316002)(82740400003)(478600001)(81166007)(336012)(4326008)(8676002)(70586007)(2616005)(83380400001)(70206006)(41300700001)(86362001)(40480700001)(36860700001)(186003)(2906002)(16526019)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 21:00:40.6634
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a14f2edc-7b0a-4c26-573f-08db0629b543
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7674
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have the pointer already, don't need to go through the
lif struct for it.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 4dd16c487f2b..8499165b1563 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -148,7 +148,7 @@ static void ionic_link_status_check(struct ionic_lif *lif)
 			mutex_lock(&lif->queue_lock);
 			err = ionic_start_queues(lif);
 			if (err && err != -EBUSY) {
-				netdev_err(lif->netdev,
+				netdev_err(netdev,
 					   "Failed to start queues: %d\n", err);
 				set_bit(IONIC_LIF_F_BROKEN, lif->state);
 				netif_carrier_off(lif->netdev);
@@ -2463,7 +2463,7 @@ static int ionic_set_vf_rate(struct net_device *netdev, int vf,
 
 		ret = ionic_set_vf_config(ionic, vf, &vfc);
 		if (!ret)
-			lif->ionic->vfs[vf].maxrate = cpu_to_le32(tx_max);
+			ionic->vfs[vf].maxrate = cpu_to_le32(tx_max);
 	}
 
 	up_write(&ionic->vf_op_lock);
-- 
2.17.1

