Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0377E68E481
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 00:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjBGXke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 18:40:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjBGXka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 18:40:30 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E1628D0A
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 15:40:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mEQcq20vD9fsiLwnrC6NlkKRA/GIkxvT8SvGkU3+SKdYF0gvtNIT0bTH13QV1B5xrgFZ3YdF8uuWFVt8OQQ92skJ4JAFtqd6wG5llyU8i+fMNT6U8p6S6GKoLxl0REpCGRVkfeRQq7Fc58ky/bYGiRkAPxbZgU0ZVykWnRHAVIG/uAAKP5PgyimGzrNl+BBGdPw//yRdiHPsNukE2YVWQkd3PAJp3EpR2h/XVRuHEzUzMap1LXDZW6WqnLftvWXkh0Wjr5Wln3MXbQfiDtYH6mHQqvDFs4ez1wwfM1Umi/B2r7KMm+HoC0skvfbkzLVej6oiIk6gAxLSxtA3CeE6ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FiaHRZxbvmzTYkJtRrfUi4iDQ6ehUjZgEQN1ziyHkUA=;
 b=adIPdfnXa/AFjp7vBk4CvpWgLqAhDJ2Cy291cO5v5PDeCF+/TGUFw98CzrArsiA+NpR+vjSjYSKF3zmvDTEwzTUyjm9r4jKz0NxKsnc8V7eivpwUSbMSLqSeZFC6QWZod6XTlanb6iF2S6aiEb7vGRkzaPHfeVQC2mriFZDTZQCRNRaszs8qK785bbq+TBIuzK+/Od/yiJLOdY8o5VvVVla+jJEvM7hyy5Q7tyxcUbtD/HqWxCb4a4qHeayOCm4vVqOi0lm/V/rqierkVUixcIeCwMRNCcaE1prhXWdkD7cvFso2/qGy2gC6/MGZe0phuDfVQ0nA9+JNZ3kR/8Q2NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FiaHRZxbvmzTYkJtRrfUi4iDQ6ehUjZgEQN1ziyHkUA=;
 b=lzQEPBaRE5GNYUBCzqbOwItO7CEX8PUDbUKQccYjQmSKLa+bZDdK1vlDCkR6qCtuUTYl2LxsbuZ/bdi8QEof1qTEHAw93o+r+g1FDOLfrFNpDhEo+8VtU5l44Dq3h+zX/om9ID+OaxdwWRcgTSqB55mEiZZ+XXos2kH+bjMGPCY=
Received: from CY5PR13CA0012.namprd13.prod.outlook.com (2603:10b6:930::23) by
 DS7PR12MB8324.namprd12.prod.outlook.com (2603:10b6:8:ec::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.31; Tue, 7 Feb 2023 23:40:24 +0000
Received: from CY4PEPF0000C982.namprd02.prod.outlook.com
 (2603:10b6:930:0:cafe::49) by CY5PR13CA0012.outlook.office365.com
 (2603:10b6:930::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.16 via Frontend
 Transport; Tue, 7 Feb 2023 23:40:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C982.mail.protection.outlook.com (10.167.241.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.16 via Frontend Transport; Tue, 7 Feb 2023 23:40:24 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Feb
 2023 17:40:22 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v3 net-next 1/3] ionic: remove unnecessary indirection
Date:   Tue, 7 Feb 2023 15:40:04 -0800
Message-ID: <20230207234006.29643-2-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230207234006.29643-1-shannon.nelson@amd.com>
References: <20230207234006.29643-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C982:EE_|DS7PR12MB8324:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c580b35-b6f0-4180-7d9e-08db0964af57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7bnEgY7n/iq3TsfaLNdHylHWogMhczav2HlIo1fxtu3mvMnnL3CAjxjMRvqNKgX7q4HxTt8F4hngNSK1eXPNRp8YrpkcttpYZRXfNso4+43VG20ltUrTSKHthJUoBoAAG1TlQP6gof4bXN6oa9ZZr+iy7TSv6m8McIr7RXpMKC5agY+b2dDwE4OJIe8BCgkHldBSlytRX6HW1zHBE71JudsEy1lLkAzwXW005r0jqXL4+Gq4vh0MI5Vb5CplX8tfFd3zlIMcXjMa2eRHt9XGcL7xdTqYp0hEfZa4di7mD3cEwjBkOHXwbuFgpfDiQyHY2S+Pe0iCDfdzdNF10WhvWNkG6BhxqGztPpjKX1hSOsJajU+sDxsQuSijEKjN7iXbKH3Q50wkmeG0T+gKyU9Cby7D6qzqqvd5aoiufqkR00rfs+1bGoERA+L1c1xq+d0w5Tyy8WGMhPsOuzsDEGxptoOjYZf4JfY5JZRgFMSHKbYseITR7QwNHB21PnvYFcRx1ZUpkOibIG9daKUdUa/ohAU3OvGqzjjlh1Xprudr+LthuOb6/H7lw5ZkvgAd0MGfIkvbrbXD2SD10I3gVKGXbV5kj1IWVtMRjD0VHCMdh0eIKrRcgWZxnsU9xNdOJxTqLDiaADFj8+5/hig+77XU2RgUXUfLjpJpGmN+OKghnoEVFImassZTbb9Ze7hGKC3XvxEaLMUKN0PaJGYc4LINMQuGL0Ab1PqQ7MzqidmPON0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(376002)(136003)(451199018)(36840700001)(46966006)(40470700004)(2906002)(82310400005)(36756003)(110136005)(336012)(2616005)(83380400001)(82740400003)(6666004)(47076005)(54906003)(16526019)(86362001)(8936002)(26005)(70206006)(40460700003)(8676002)(81166007)(186003)(70586007)(41300700001)(40480700001)(4326008)(44832011)(1076003)(478600001)(5660300002)(356005)(36860700001)(316002)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 23:40:24.5089
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c580b35-b6f0-4180-7d9e-08db0964af57
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C982.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8324
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

