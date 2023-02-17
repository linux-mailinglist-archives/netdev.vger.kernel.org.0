Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 003F969B5BE
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 23:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjBQW5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 17:57:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjBQW5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 17:57:15 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B881766CFF
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 14:56:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DSAUiTHxGQisDDWxLLg93CpS3kkwmIRWVJ5szJ3D0Tdtg4KKC9G+rshR/auyUeuKAbDUpJEOZ98MTU+XmJiOr244N4jI6HUNyTL8S5Wj1BcLIeWBn4l6sjQrI6mo0EXmxkQfUB8AjHvEb/++E3ET6OCKQUrCwtIYKAvRmXvM15ij+ehvRsVNci1oB+NtVlqFqUfMCGUo/h9jWYydkJNDUOhCCoS/IfHCrw0B/T4A/q8CDbaPYzSRg9T2Orite6ll93+JCsLHghEK6Sbb2cFYAZBjHIrgJ7eUwT7y4ruu1bv0ita0qow9XP7Cx6WE+h3Kfo6qfQz0ABBYZX9q5vEqjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kz3w3J5y2fKhOITDSxsm/LV9Mrva85Svx0clxNPED2Y=;
 b=f2ggCrZt5gn5UanzqNFkK/pOg4FNcktKWHDnJnNskuZdUHNtfKua5MyLu3hFZerQJow1dUpczUs1UBw9uPZff3SNotJV+zLle46c7UctcfeqHO495a3JvUFAc4qAfZjyaislaemGqoHeY+iOrOlZ+4tncpxPhBHy7716QTtBU8ZadaTFq0YniqNxxY4gl0jQ3y+KL///yssm6FKD/YyY624hUhVbMrLudJsLr5h9B1mYwxeDYfsO+feEfMh0sHFvtbWlm/Hp+biupSQqV2QrT0p2w+P34Z66S/fY4ciOefTnUcUqvVaC+cNElWDyrdmmrVliQ0i5bUrLHKVPrr+p2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kz3w3J5y2fKhOITDSxsm/LV9Mrva85Svx0clxNPED2Y=;
 b=4SOCRSksB9o8sl5A+Gk2/Kdxrvo2+155ga7LXOHoYnpXckSLsMrN6tWmRQHQbnTwEs+OkQrjrsHUQ3AetyhOk116Kn1dNEBMqVgjY1AGciAFN2hiq2c7t0slHkRz/AuooUY0WwVMdarWbXLjVKmYLqL/QFq719lkB3hjvawrO24=
Received: from MW4PR04CA0048.namprd04.prod.outlook.com (2603:10b6:303:6a::23)
 by SA0PR12MB7479.namprd12.prod.outlook.com (2603:10b6:806:24b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.17; Fri, 17 Feb
 2023 22:56:40 +0000
Received: from CO1PEPF00001A62.namprd05.prod.outlook.com
 (2603:10b6:303:6a:cafe::a4) by MW4PR04CA0048.outlook.office365.com
 (2603:10b6:303:6a::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.17 via Frontend
 Transport; Fri, 17 Feb 2023 22:56:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF00001A62.mail.protection.outlook.com (10.167.241.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Fri, 17 Feb 2023 22:56:40 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 17 Feb
 2023 16:56:38 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <brett.creeley@amd.com>,
        Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v3 net-next 04/14] pds_core: health timer and workqueue
Date:   Fri, 17 Feb 2023 14:55:48 -0800
Message-ID: <20230217225558.19837-5-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230217225558.19837-1-shannon.nelson@amd.com>
References: <20230217225558.19837-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00001A62:EE_|SA0PR12MB7479:EE_
X-MS-Office365-Filtering-Correlation-Id: d3d3cb31-4345-427d-55bc-08db113a3b3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a68wcA7u2MtIpxatD67wBPXc1P7cBV0mFXH8AFEctoue+KFfWOdfXlIVe+5zgXI+iOHGFLnmSC2dHKaUn4b7evD+XJQA48y2nK42Frk4gRL2rB0SzsdJNZ097MF9VesxiJhLtx+dwwAFGgbZ8eYJk2isn6pMGn2OD3QdI17fvBI9uMJR+z3O5ycbj+mC5IE1gZegb0IFO5yf3tGlswD1m3e3PKbNVcbx1q0PWqkYcTt353PI897zf5NziAREsh4jWNDvCTQ3QgK1j7qP6/pBF3rD1wSMnGKnGyXkV//VCEoyL2JrKnvGdCsOKp9L0eMiQnARP4WzDF+MvXfv9HzADh1/Qn4eaDY84sOgVomKjScj2vQIrL9jl1T70HAyObJFj37Ulyp6UCl8LTDT5Iz/ULplQTWI8YW79iGlEVcYwTu0gV9XZENO3wLF690wkaFp3+TwcQLP83C964m9hvAQBrQ6agZndmawLKqmeBPtTWKFaRaRf9ej8offBnmlnC+v1J0a/WtsVAVZT9uncAZhSuc6Yd1dbqQEW4REceOP4rCFKsXV78f00eYSTrf91opQGlCtdo8VpTRsTXniO+T8txx4EM5sC2f4sr/8dBG+esbIbv28aHKMGTp8hYa/KZaMRGw3JsjIUvawXIObY7PvJCZxI1vixR+Yw+u36xkYWSaAQ4TQ4Xa2dxWD3FWfC2bZdGwJuKwGtBW3l5y/lFIvzfXuXYguP/S2RbiMx6953m0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(346002)(396003)(136003)(451199018)(36840700001)(46966006)(40470700004)(186003)(40460700003)(41300700001)(8676002)(70206006)(83380400001)(316002)(8936002)(4326008)(5660300002)(1076003)(6666004)(2616005)(26005)(426003)(478600001)(54906003)(336012)(110136005)(356005)(16526019)(70586007)(82310400005)(36756003)(40480700001)(47076005)(2906002)(86362001)(82740400003)(36860700001)(44832011)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 22:56:40.1054
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d3d3cb31-4345-427d-55bc-08db113a3b3e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A62.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7479
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add in the periodic health check and the related workqueue,
as well as the handlers for when a FW reset is seen.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/amd/pds_core/core.c | 60 ++++++++++++++++++++++++
 drivers/net/ethernet/amd/pds_core/core.h |  9 ++++
 drivers/net/ethernet/amd/pds_core/dev.c  |  3 ++
 drivers/net/ethernet/amd/pds_core/main.c | 50 ++++++++++++++++++++
 4 files changed, 122 insertions(+)

diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index 0efc03be9abc..5dfa72001e27 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -41,3 +41,63 @@ void pdsc_teardown(struct pdsc *pdsc, bool removing)
 
 	set_bit(PDSC_S_FW_DEAD, &pdsc->state);
 }
+
+static void pdsc_fw_down(struct pdsc *pdsc)
+{
+	mutex_lock(&pdsc->config_lock);
+
+	if (test_and_set_bit(PDSC_S_FW_DEAD, &pdsc->state)) {
+		dev_err(pdsc->dev, "%s: already happening\n", __func__);
+		mutex_unlock(&pdsc->config_lock);
+		return;
+	}
+
+	pdsc_teardown(pdsc, PDSC_TEARDOWN_RECOVERY);
+
+	mutex_unlock(&pdsc->config_lock);
+}
+
+static void pdsc_fw_up(struct pdsc *pdsc)
+{
+	int err;
+
+	mutex_lock(&pdsc->config_lock);
+
+	if (!test_bit(PDSC_S_FW_DEAD, &pdsc->state)) {
+		dev_err(pdsc->dev, "%s: fw not dead\n", __func__);
+		mutex_unlock(&pdsc->config_lock);
+		return;
+	}
+
+	err = pdsc_setup(pdsc, PDSC_SETUP_RECOVERY);
+	if (err)
+		goto err_out;
+
+	mutex_unlock(&pdsc->config_lock);
+
+	return;
+
+err_out:
+	pdsc_teardown(pdsc, PDSC_TEARDOWN_RECOVERY);
+	mutex_unlock(&pdsc->config_lock);
+}
+
+void pdsc_health_thread(struct work_struct *work)
+{
+	struct pdsc *pdsc = container_of(work, struct pdsc, health_work);
+	bool healthy;
+
+	healthy = pdsc_is_fw_good(pdsc);
+	dev_dbg(pdsc->dev, "%s: health %d fw_status %#02x fw_heartbeat %d\n",
+		__func__, healthy, pdsc->fw_status, pdsc->last_hb);
+
+	if (test_bit(PDSC_S_FW_DEAD, &pdsc->state)) {
+		if (healthy)
+			pdsc_fw_up(pdsc);
+	} else {
+		if (!healthy)
+			pdsc_fw_down(pdsc);
+	}
+
+	pdsc->fw_generation = pdsc->fw_status & PDS_CORE_FW_STS_F_GENERATION;
+}
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index 48618bdf0921..153889f98c25 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -12,6 +12,8 @@
 #include <linux/pds/pds_intr.h>
 
 #define PDSC_DRV_DESCRIPTION	"AMD/Pensando Core PF Driver"
+
+#define PDSC_WATCHDOG_SECS	5
 #define PDSC_TEARDOWN_RECOVERY	false
 #define PDSC_TEARDOWN_REMOVING	true
 #define PDSC_SETUP_RECOVERY	false
@@ -64,12 +66,17 @@ struct pdsc {
 	u8 fw_generation;
 	unsigned long last_fw_time;
 	u32 last_hb;
+	struct timer_list wdtimer;
+	unsigned int wdtimer_period;
+	struct work_struct health_work;
 
 	struct pdsc_devinfo dev_info;
 	struct pds_core_dev_identity dev_ident;
 	unsigned int nintrs;
 	struct pdsc_intr_info *intr_info;	/* array of nintrs elements */
 
+	struct workqueue_struct *wq;
+
 	unsigned int devcmd_timeout;
 	struct mutex devcmd_lock;	/* lock for dev_cmd operations */
 	struct mutex config_lock;	/* lock for configuration operations */
@@ -82,6 +89,7 @@ struct pdsc {
 	u64 __iomem *kern_dbpage;
 };
 
+void pdsc_queue_health_check(struct pdsc *pdsc);
 void __iomem *pdsc_map_dbpage(struct pdsc *pdsc, int page_num);
 
 struct pdsc *pdsc_dl_alloc(struct device *dev);
@@ -119,5 +127,6 @@ int pdsc_dev_init(struct pdsc *pdsc);
 
 int pdsc_setup(struct pdsc *pdsc, bool init);
 void pdsc_teardown(struct pdsc *pdsc, bool removing);
+void pdsc_health_thread(struct work_struct *work);
 
 #endif /* _PDSC_H_ */
diff --git a/drivers/net/ethernet/amd/pds_core/dev.c b/drivers/net/ethernet/amd/pds_core/dev.c
index 1aef124a38cb..0f5a65e0269b 100644
--- a/drivers/net/ethernet/amd/pds_core/dev.c
+++ b/drivers/net/ethernet/amd/pds_core/dev.c
@@ -181,6 +181,9 @@ int pdsc_devcmd_locked(struct pdsc *pdsc, union pds_core_dev_cmd *cmd,
 	err = pdsc_devcmd_wait(pdsc, max_seconds);
 	memcpy_fromio(comp, &pdsc->cmd_regs->comp, sizeof(*comp));
 
+	if (err == -ENXIO || err == -ETIMEDOUT)
+		pdsc_queue_health_check(pdsc);
+
 	return err;
 }
 
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index 8573e119087a..3150a2a665ec 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -25,6 +25,31 @@ static const struct pci_device_id pdsc_id_table[] = {
 };
 MODULE_DEVICE_TABLE(pci, pdsc_id_table);
 
+void pdsc_queue_health_check(struct pdsc *pdsc)
+{
+	unsigned long mask;
+
+	/* Don't do a check when in a transition state */
+	mask = BIT_ULL(PDSC_S_INITING_DRIVER) |
+	       BIT_ULL(PDSC_S_STOPPING_DRIVER);
+	if (pdsc->state & mask)
+		return;
+
+	/* Queue a new health check if one isn't already queued */
+	queue_work(pdsc->wq, &pdsc->health_work);
+}
+
+static void pdsc_wdtimer_cb(struct timer_list *t)
+{
+	struct pdsc *pdsc = from_timer(pdsc, t, wdtimer);
+
+	dev_dbg(pdsc->dev, "%s: jiffies %ld\n", __func__, jiffies);
+	mod_timer(&pdsc->wdtimer,
+		  round_jiffies(jiffies + pdsc->wdtimer_period));
+
+	pdsc_queue_health_check(pdsc);
+}
+
 static void pdsc_unmap_bars(struct pdsc *pdsc)
 {
 	struct pdsc_dev_bar *bars = pdsc->bars;
@@ -135,9 +160,12 @@ static int pdsc_map_bars(struct pdsc *pdsc)
 
 static DEFINE_IDA(pdsc_pf_ida);
 
+#define PDSC_WQ_NAME_LEN 24
+
 static int pdsc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct device *dev = &pdev->dev;
+	char wq_name[PDSC_WQ_NAME_LEN];
 	struct pdsc *pdsc;
 	int err;
 
@@ -189,6 +217,13 @@ static int pdsc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto err_out_pci_disable_device;
 
+	/* General workqueue and timer, but don't start timer yet */
+	snprintf(wq_name, sizeof(wq_name), "%s.%d", PDS_CORE_DRV_NAME, pdsc->id);
+	pdsc->wq = create_singlethread_workqueue(wq_name);
+	INIT_WORK(&pdsc->health_work, pdsc_health_thread);
+	timer_setup(&pdsc->wdtimer, pdsc_wdtimer_cb, 0);
+	pdsc->wdtimer_period = PDSC_WATCHDOG_SECS * HZ;
+
 	/* PDS device setup */
 	mutex_init(&pdsc->devcmd_lock);
 	mutex_init(&pdsc->config_lock);
@@ -209,6 +244,8 @@ static int pdsc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pdsc->fw_generation = PDS_CORE_FW_STS_F_GENERATION &
 			      ioread8(&pdsc->info_regs->fw_status);
+	/* Lastly, start the health check timer */
+	mod_timer(&pdsc->wdtimer, round_jiffies(jiffies + pdsc->wdtimer_period));
 
 	clear_bit(PDSC_S_INITING_DRIVER, &pdsc->state);
 	return 0;
@@ -216,6 +253,12 @@ static int pdsc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_out:
 	pdsc_teardown(pdsc, PDSC_TEARDOWN_REMOVING);
 err_out_unmap_bars:
+	del_timer_sync(&pdsc->wdtimer);
+	if (pdsc->wq) {
+		flush_workqueue(pdsc->wq);
+		destroy_workqueue(pdsc->wq);
+		pdsc->wq = NULL;
+	}
 	mutex_unlock(&pdsc->config_lock);
 	mutex_destroy(&pdsc->config_lock);
 	mutex_destroy(&pdsc->devcmd_lock);
@@ -248,6 +291,13 @@ static void pdsc_remove(struct pci_dev *pdev)
 	mutex_lock(&pdsc->config_lock);
 	set_bit(PDSC_S_STOPPING_DRIVER, &pdsc->state);
 
+	del_timer_sync(&pdsc->wdtimer);
+	if (pdsc->wq) {
+		flush_workqueue(pdsc->wq);
+		destroy_workqueue(pdsc->wq);
+		pdsc->wq = NULL;
+	}
+
 	/* Device teardown */
 	pdsc_teardown(pdsc, PDSC_TEARDOWN_REMOVING);
 	pdsc_debugfs_del_dev(pdsc);
-- 
2.17.1

