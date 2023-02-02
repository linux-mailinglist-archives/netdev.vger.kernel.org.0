Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7BE5687303
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 02:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbjBBBaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 20:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbjBBBa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 20:30:27 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2042.outbound.protection.outlook.com [40.107.93.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D566ACAE
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 17:30:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Owfz8If1XQ6euVj9UvXj7LNoU6fxQuGZY1uW0/3wEtYb/QCtCTHzV2qjoz0eF9NP/5BZsqE/dBhOeE43jVNY6bxSnT8Tn/jaAmy8HBtw3ktcBkC+eVsAwcHO22HkdaqO90H+Xlyn5hFUYmvLzRSMeZ9F6ucvNmIA2HY8tHil7v98XGCec79S7bQCjheioN4USy0brfdfp2JRX/7v1mCMuARNSSHwDqizss2NZwPNzGwCqH0wplPYoj39aOIUDw8v2eetjOcvMasAoWCfoJHsCA29KaH27E4WajER+uwQhENq5JoJNlVofoLZf4BJGYqq+ITHCCaRBukiKyzyz2JVqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oz7KpnDRvh9sz9L7xeaHan/m4pj8kmqduS0ipSxuEQ4=;
 b=Fspsmhzc65GiQXi4JIvKS8EhDwDBqxOJWSSWAzJAK4vqn1xH+BbN+c2XUYwRuEs7+Eg4BDrNrVyj2m+ldUMdOX5+4gMkKl5t5bkME04i70BRlhrgiJHFBKFs5Idm21U33FysTht5lbBMPikemcnQGiuO3cOfvDT92lVfLe9c2uFgVIygNQJ5wkW98AtuNZQutm7+QMEw0wEnw9f58sq4CYiIU4RBgU5N8Wnquk63GId46u5yhw00FE0+AfGkCAWV/cRVdp8LqtkraPjrUo/GmxG58dnDgslPKhcLvBoMpcdSVfMp12b6UsrMG46M0nMJSSn/6DHZhx1XCrnpVHuLzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oz7KpnDRvh9sz9L7xeaHan/m4pj8kmqduS0ipSxuEQ4=;
 b=QT3AM6AJT1F1nyoNqFzq87ZeHt7rzYkm3eti4PsptQOME73U40JHla95DkUPbdDDcBZjNE0rbtucVMbueMl9yu+fDohAyH6qlxKhvHQZEIf00qXZLDN1cOOytJB9VTFzMzF9jph8awelewoL3jYEoj70ekZ76ffOzlo06FwPYHk=
Received: from CY5PR15CA0102.namprd15.prod.outlook.com (2603:10b6:930:7::12)
 by DM4PR12MB5246.namprd12.prod.outlook.com (2603:10b6:5:399::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22; Thu, 2 Feb
 2023 01:30:23 +0000
Received: from CY4PEPF0000C966.namprd02.prod.outlook.com
 (2603:10b6:930:7:cafe::7a) by CY5PR15CA0102.outlook.office365.com
 (2603:10b6:930:7::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.24 via Frontend
 Transport; Thu, 2 Feb 2023 01:30:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C966.mail.protection.outlook.com (10.167.241.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.17 via Frontend Transport; Thu, 2 Feb 2023 01:30:23 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 1 Feb
 2023 19:30:20 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH net 3/6] ionic: add check for NULL t/rxqcqs in reconfig
Date:   Wed, 1 Feb 2023 17:29:59 -0800
Message-ID: <20230202013002.34358-4-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230202013002.34358-1-shannon.nelson@amd.com>
References: <20230202013002.34358-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C966:EE_|DM4PR12MB5246:EE_
X-MS-Office365-Filtering-Correlation-Id: c43015a6-72db-45c2-dae3-08db04bd0df6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x89J84RBcIjkl3pD8HBSB+29DzV/c6IQyiERd0+Xt5WGQ5fc0DnOg5t2iNNxcWi+HaI2CUk33tPlGC21nxYjo0/7zZoddN3vvf9X8qfvol16+oyfUdGLIlosYW00AB2YVayLMotASguszLQVmXzqaPWBVa3gwtb/KS7tr6f5gT2lqvvp+2z5mC18wdjHhlNgVl4nCP5mXZwSfgnyn0HzD76RwiZa7m8sAKRz6VnGL3jfKo/W416OnFclKJvfNYf3hrKEEzMweL1VYi4owMdcLPWelidEhB9pfzjxLzuQITH4LtRWMlLFy/4oCV11OcHnuvqpxMHPbeIYCrVcEjzLVUciSlG/BMxOMURWYZkB5loUozyawjwoYrk2RUe5D+In8zJkXo7N7JooMe+PibmMFDuuUFq5+gHBHMJ2jruDIyogHhyzor8AC3QMyJeyFUEpcR0tHKLEGRst4u85Y0PHHnvEjRgXmdzgNI720Mf+dDdl9VZVlg7P/TUiayazpyWUeHFhWoRLN3hcd6tHJ8u35bZHzE3Nx3WpQtinx/nypGQQ28dA8HOrptm7s5wShN/Z6jU+xk2TJub3ZlC47s7Y/26lxSr+TzmhLTT41S3tFPJdQo2PKji6RHp8iidk+yLBWEu5wIIZme57RNR2SIrxQPZX3e6HG52FflG+v8cLhbO2PNhH4muFjEphInbSw0qsjfCUsdqEG+noiXljwGzV3CgXv3RWczh+7GjXudvMmww=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(376002)(39860400002)(346002)(451199018)(46966006)(36840700001)(40470700004)(356005)(86362001)(186003)(1076003)(2616005)(81166007)(36860700001)(26005)(36756003)(16526019)(336012)(426003)(83380400001)(316002)(47076005)(478600001)(6666004)(5660300002)(54906003)(4326008)(8676002)(70586007)(82740400003)(41300700001)(2906002)(110136005)(70206006)(44832011)(8936002)(82310400005)(40480700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 01:30:23.1575
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c43015a6-72db-45c2-dae3-08db04bd0df6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C966.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5246
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure there are qcqs to clean before trying to swap resources
or clean their interrupt assignments.

Fixes: 101b40a0171f ("ionic: change queue count with no reset")
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 27 ++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 8499165b1563..c08d0762212c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2741,6 +2741,14 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
 			sg_desc_sz = sizeof(struct ionic_txq_sg_desc);
 
 		for (i = 0; i < qparam->nxqs; i++) {
+			/* If missing, short placeholder qcq needed for swap */
+			if (!lif->txqcqs[i]) {
+				flags = IONIC_QCQ_F_TX_STATS | IONIC_QCQ_F_SG;
+				err = ionic_qcq_alloc(lif, IONIC_QTYPE_TXQ, i, "tx", flags,
+						      4, desc_sz, comp_sz, sg_desc_sz,
+						      lif->kern_pid, &lif->txqcqs[i]);
+			}
+
 			flags = lif->txqcqs[i]->flags & ~IONIC_QCQ_F_INTR;
 			err = ionic_qcq_alloc(lif, IONIC_QTYPE_TXQ, i, "tx", flags,
 					      num_desc, desc_sz, comp_sz, sg_desc_sz,
@@ -2760,6 +2768,14 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
 			comp_sz *= 2;
 
 		for (i = 0; i < qparam->nxqs; i++) {
+			/* If missing, short placeholder qcq needed for swap */
+			if (!lif->rxqcqs[i]) {
+				flags = IONIC_QCQ_F_RX_STATS | IONIC_QCQ_F_SG;
+				err = ionic_qcq_alloc(lif, IONIC_QTYPE_RXQ, i, "rx", flags,
+						      4, desc_sz, comp_sz, sg_desc_sz,
+						      lif->kern_pid, &lif->rxqcqs[i]);
+			}
+
 			flags = lif->rxqcqs[i]->flags & ~IONIC_QCQ_F_INTR;
 			err = ionic_qcq_alloc(lif, IONIC_QTYPE_RXQ, i, "rx", flags,
 					      num_desc, desc_sz, comp_sz, sg_desc_sz,
@@ -2809,10 +2825,15 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
 			lif->tx_coalesce_hw = lif->rx_coalesce_hw;
 		}
 
-		/* clear existing interrupt assignments */
+		/* Clear existing interrupt assignments.  We check for NULL here
+		 * because we're checking the whole array for potential qcqs, not
+		 * just those qcqs that have just been set up.
+		 */
 		for (i = 0; i < lif->ionic->ntxqs_per_lif; i++) {
-			ionic_qcq_intr_free(lif, lif->txqcqs[i]);
-			ionic_qcq_intr_free(lif, lif->rxqcqs[i]);
+			if (lif->txqcqs[i])
+				ionic_qcq_intr_free(lif, lif->txqcqs[i]);
+			if (lif->rxqcqs[i])
+				ionic_qcq_intr_free(lif, lif->rxqcqs[i]);
 		}
 
 		/* re-assign the interrupts */
-- 
2.17.1

