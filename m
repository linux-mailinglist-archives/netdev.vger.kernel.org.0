Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19A0068A407
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 22:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233436AbjBCVCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 16:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233096AbjBCVB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 16:01:57 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2054.outbound.protection.outlook.com [40.107.95.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE59AA25A
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 13:00:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=drA+fR7Gnq7Mj1Glty/DBknj1FU8q/+E+RHpa8Gn5rbb0Bp6gmlOy552jhp6BdCBrkjsyq5rEYCWMN3KBrBSAHS1q9434A3ctqxOkO2GzcafAmVCP8FkG0asui36xcSXbNFnFCB+f1scfGyaPF4sHA03oxY62rUbYtOh/rEF9lBu55P9BQHchI3YIISXwEkUCL8BVjFuZ7vIU0LTJqCeyZz82pLwKZ3TcGUfOnF/XyN0bJ7AgiY9bd1y7N7XNK6WPYy5kq7Wj3JHSJOYkWwG5UizVmAw0SIW5EnI6o+/OcbOtsFYl9C+LyDCVyJLKN5Lanv1TOLrFGdNQt36uPGjyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7bUKE7eT86V5Rxv7/g6ATYa0cVStWGS73JiJR0osJyQ=;
 b=FjeHNtJmdiHn4dsqIDee6CeeuGdzVashZD5oKxy+6Q97LMUPF/9RW7SX66b+zcp8+hct7VZJljHHmA1xqW3noCu1hvRnZByGntBY363OJEfHcb3inIxySA2ciEQH0kjNux48vudBnGviApG3IfI/zzXibhQ2wXqJEgAAaQb+ENdm9/SJ9T2x41WGpFpxYCnth4LLJbEFt3pLAgBSUtUvxpSC3bCKCN/1NAGh/SUeuyeiGKZJqKlUdMSsRUNEKTOp+6H2gsyPttnMS/FQDFH/SBSM2EPOok/BrTr+xcA7ICKUHL3oRu/hG1IAXSdU5EUiwKYAwB704QT2Jz8wOE2g1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7bUKE7eT86V5Rxv7/g6ATYa0cVStWGS73JiJR0osJyQ=;
 b=bwE4QTCQX9f+h9kPVIarigcKLWxJAzzzVU632QXdgRSh7H1wpCi0Y14WuONlEjMjf7oA8yJjtTcVu2bEKnHnggmKsYeCDCeR3e8Wc3DgXwIbjGbNoAZSduNFBJJWBA/EZ1tV8ylD9WYaMaNEyghum3hHdun/snCI4QH490SEJGI=
Received: from DS7PR05CA0032.namprd05.prod.outlook.com (2603:10b6:8:2f::31) by
 DS7PR12MB6237.namprd12.prod.outlook.com (2603:10b6:8:97::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.29; Fri, 3 Feb 2023 21:00:41 +0000
Received: from DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2f:cafe::10) by DS7PR05CA0032.outlook.office365.com
 (2603:10b6:8:2f::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.9 via Frontend
 Transport; Fri, 3 Feb 2023 21:00:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT010.mail.protection.outlook.com (10.13.172.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.31 via Frontend Transport; Fri, 3 Feb 2023 21:00:41 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 3 Feb
 2023 15:00:39 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH net-next 2/4] ionic: remove unnecessary void casts
Date:   Fri, 3 Feb 2023 13:00:14 -0800
Message-ID: <20230203210016.36606-3-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT010:EE_|DS7PR12MB6237:EE_
X-MS-Office365-Filtering-Correlation-Id: 39ca2aec-b111-41ab-3cc3-08db0629b5ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RW0tw54FmCb8iRpI3O/Nn/XpVAgZN98QwlDbPG57slMpHSHBDa/6MjAxy/O6GQnn5SQeW8/qJG4f7c9NJIrmEPifB6sgEmy00utTbeQinkJBTe6dzEusPp43TOZzMFhUrBGzilbCFgn2Gde4imgrDi8V7RIBZLUUVFkD1GslXSH+ZelXiXV1izjMoLs6YV0F57AmPudp3sgNhNDdCOHNQxxQGWnx67I0mEUMH/U9RDorWYGgk8WLphHuX3DDzKkkbryCdM8p1QsgqVlaenXyJVfUFZI4H3uFVCVoroCbVR/Gt7cgDlE/1HGmvfeoSzLlghO5rnWcyY+BNMKa/WURAJ7ijRimTZy0fRypxPWvlMl+C+d5L4hK/ZQrxUq5FJBAYI9laexWg5mbKU13UTr59ORZQb2SUVaPUsyYppfubkMHuYR30O167+XfJtrIe59DpG8Td5lokOIiXQVgkhKDKhG5kR7Uqf4RtMMhErBA2stUlQeMuHDutOq9gaSEp3m9Xt5P69o9CNsU4QpzhAgVllZMO4j5ipY3kKB6MKinfl4myUGJqjazlx4OGk2C2yOqq4gQhQj5q452MD32C6FuVeomdn8E93Z9dYUndzn3e2h0UM+2keJaPyG3WH4wzVd9myqfAjS/UCmPaGFYO+ZiEx3YV0/bZyySGyWiIjteIE+j23GZJEsF+FDi0X8smuGHMFJJjTInDQBzhK/1G201x8GzOGh8gbcr/wf2z8kq61E=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(136003)(346002)(396003)(451199018)(36840700001)(46966006)(40470700004)(41300700001)(6666004)(8676002)(70586007)(4326008)(70206006)(426003)(86362001)(47076005)(336012)(2906002)(82740400003)(2616005)(40480700001)(83380400001)(5660300002)(1076003)(8936002)(36860700001)(40460700003)(186003)(16526019)(44832011)(36756003)(26005)(478600001)(316002)(356005)(82310400005)(54906003)(110136005)(66899018)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 21:00:41.3665
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39ca2aec-b111-41ab-3cc3-08db0629b5ac
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6237
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Minor Code cleanup details.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c   | 4 ++--
 drivers/net/ethernet/pensando/ionic/ionic_main.c      | 4 ++--
 drivers/net/ethernet/pensando/ionic/ionic_phc.c       | 2 +-
 drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c | 4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index ce436e97324a..0eff78fa0565 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -121,7 +121,7 @@ static void ionic_vf_dealloc_locked(struct ionic *ionic)
 
 		if (v->stats_pa) {
 			vfc.stats_pa = 0;
-			(void)ionic_set_vf_config(ionic, i, &vfc);
+			ionic_set_vf_config(ionic, i, &vfc);
 			dma_unmap_single(ionic->dev, v->stats_pa,
 					 sizeof(v->stats), DMA_FROM_DEVICE);
 			v->stats_pa = 0;
@@ -169,7 +169,7 @@ static int ionic_vf_alloc(struct ionic *ionic, int num_vfs)
 
 		/* ignore failures from older FW, we just won't get stats */
 		vfc.stats_pa = cpu_to_le64(v->stats_pa);
-		(void)ionic_set_vf_config(ionic, i, &vfc);
+		ionic_set_vf_config(ionic, i, &vfc);
 	}
 
 out:
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index a13530ec4dd8..79d4dfa9e07e 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -359,7 +359,7 @@ int ionic_adminq_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx,
 			break;
 
 		/* force a check of FW status and break out if FW reset */
-		(void)ionic_heartbeat_check(lif->ionic);
+		ionic_heartbeat_check(lif->ionic);
 		if ((test_bit(IONIC_LIF_F_FW_RESET, lif->state) &&
 		     !lif->ionic->idev.fw_status_ready) ||
 		    test_bit(IONIC_LIF_F_FW_STOPPING, lif->state)) {
@@ -647,7 +647,7 @@ int ionic_port_init(struct ionic *ionic)
 	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
 
 	ionic_dev_cmd_port_state(&ionic->idev, IONIC_PORT_ADMIN_STATE_UP);
-	(void)ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+	ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
 
 	mutex_unlock(&ionic->dev_cmd_lock);
 	if (err) {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_phc.c b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
index 887046838b3b..eac2f0e3576e 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_phc.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
@@ -268,7 +268,7 @@ static u64 ionic_hwstamp_read(struct ionic *ionic,
 	u32 tick_high_before, tick_high, tick_low;
 
 	/* read and discard low part to defeat hw staging of high part */
-	(void)ioread32(&ionic->idev.hwstamp_regs->tick_low);
+	ioread32(&ionic->idev.hwstamp_regs->tick_low);
 
 	tick_high_before = ioread32(&ionic->idev.hwstamp_regs->tick_high);
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
index b7363376dfc8..1ee2f285cb42 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_rx_filter.c
@@ -604,14 +604,14 @@ void ionic_rx_filter_sync(struct ionic_lif *lif)
 	 * they can clear room for some new filters
 	 */
 	list_for_each_entry_safe(sync_item, spos, &sync_del_list, list) {
-		(void)ionic_lif_filter_del(lif, &sync_item->f.cmd);
+		ionic_lif_filter_del(lif, &sync_item->f.cmd);
 
 		list_del(&sync_item->list);
 		devm_kfree(dev, sync_item);
 	}
 
 	list_for_each_entry_safe(sync_item, spos, &sync_add_list, list) {
-		(void)ionic_lif_filter_add(lif, &sync_item->f.cmd);
+		ionic_lif_filter_add(lif, &sync_item->f.cmd);
 
 		list_del(&sync_item->list);
 		devm_kfree(dev, sync_item);
-- 
2.17.1

