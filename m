Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB0896C857F
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 20:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjCXTDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 15:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjCXTDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 15:03:14 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2049.outbound.protection.outlook.com [40.107.94.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4941A9773
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 12:03:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CRH6Ri8fBROEubEBXEkC5i0HQUWNY1X70jAhoqo6/1QmAdrsVE4b+9c4rMrocVRfT/SAyjqHCV7xEEp1QdhHMukaAaKNORdUSCDm1rqmS0UTsk4uHEqZykWXRpjXUYnA8Nbo7x+G7JKw3HTwexWJfDVWv7qQKqpNHG5LoC+imyFwPukTjbMkbipHr35tHUcYZ5cyvEol0FPni3xNiO5X+wtwImbuGKzuXrOVbbtqrZlFLWFKvUqCcW/nmKQuFj5+kJv6aZS14xxgNqiWqZ1R/HiaF/NuDQF3pguvKoGbIX22i8PJm2IbkrqxUhY/H1RMgbn/rJycgPBV+L8tT2HYig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fJ1+KHrbSSZb299qlVjwhNf0pCXKf1ZQ/i/q9sqBamw=;
 b=eUbp+1HdmfMEBou7gGZDkpoz7v8/94sVvzzn433/26v0/Bodu0tDGwicocip8skmsYjHHi1R5EVjdu8RyXsobIDtb8F91yVljKqV/yRzfUvINX8T82lAM+tVt8s5ygoSnrc+HbE56tfEBjwXig7c2BUGC051WqHe5Yy2hu6xdlGOEBwREgZhCaApqPRSDgIhBr03+64Q6qg3dyi4eotYh5TB/1Fy900EGp2SSg2sxKm0iisuz5TkdI//MrzBL8uSLdo3u22GlREhp75uh3GD/WNLtz6goH/Tz7Kdf/+j3TfZm44fBrTdP+UILqEx3xbDf47dqEncK0WldRz+nbSntw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fJ1+KHrbSSZb299qlVjwhNf0pCXKf1ZQ/i/q9sqBamw=;
 b=Enk4ngOEohyQpVIy8n9+TWQGfdwAv9eJUCCscappr1IIxj4J6kyfM872V7Fh4RPQqnoh3cFWKoH1egfubyHUgRw8Q2EOvw8ouMhn7qAU2ehBtRiuvh9gGO7REm50MNENxFLZBlxR75CzNVPKFBS9Tn/3CTeV5drQolt8jgIW5kM=
Received: from DM6PR02CA0164.namprd02.prod.outlook.com (2603:10b6:5:332::31)
 by MN2PR12MB4517.namprd12.prod.outlook.com (2603:10b6:208:267::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.39; Fri, 24 Mar
 2023 19:03:10 +0000
Received: from DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332::4) by DM6PR02CA0164.outlook.office365.com
 (2603:10b6:5:332::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.40 via Frontend
 Transport; Fri, 24 Mar 2023 19:03:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT051.mail.protection.outlook.com (10.13.172.243) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.22 via Frontend Transport; Fri, 24 Mar 2023 19:03:09 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 24 Mar
 2023 14:03:07 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v6 net-next 03/14] pds_core: health timer and workqueue
Date:   Fri, 24 Mar 2023 12:02:32 -0700
Message-ID: <20230324190243.27722-4-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230324190243.27722-1-shannon.nelson@amd.com>
References: <20230324190243.27722-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT051:EE_|MN2PR12MB4517:EE_
X-MS-Office365-Filtering-Correlation-Id: 28577aab-117c-4278-b4bd-08db2c9a68e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8PEaMr2mkoPRcXle1Jj+89rJL4y4dyAqbRjODtU78CRnHFHRYRlHyu2+fc/QCWpWbcGGUrYd28FY6gcRE+skw6a7xO+DrKBi/l9G7cIHhw1ZXDnFdTzkjwWMSwe6JLSWt5kdF539fbyQgEu3I8oQyOfJEUXPwbXFMZF+kgUiRs2NkP6GEF4zl/8z7QmVKfqg2UhnulTpzakWUKnPiLbUcC4oS8QpB5gGx9rwFHzu1PUsw7xQFg6yyl0wMJlwHPf3StUSniNeZHQcS8+uFBzrj96PqokwIPTjS6BcIQT1Z1b2GDzcSoyBvOIAJQIeiRgCxSQ8wXgYW8DdrQq2E6nLqCvOGcZsLFMbWxxXFzv3xjxiIVWPSmfYifBjATRxkMGfp2Prb27B2ZYmbwQt5zE4yeLULgjoPf9rViKDq+z2t/aih6S7UbounhuhKpru5Vj5FsgFkudYFgYq09Ahaj45ZyTZT0dI++ED7nn3GP9aD0qVY0at4CYkvx3yXnStBD3IOFcFOWGmPQtsKTI2w0sG9a7xhsEEX+JYUPyUyvNPnQEYOUkNKu0KeoFYsa4+UFPNQRiGIA8IvnsF5V0NhgQCBhTOx5TaQp6ebVqkeWlMgKzLiWQcQcl/OipESRxo2e14Uu6B7fXYgPSDkapf1jVenmSP3z9HklbZ2IuAk3ONmMOyLH1hRtgrUQl06atv4MNSN7FQido0Z+y8EkggcuID+btToKZyjBcFJnFqjAN2jh0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(346002)(396003)(376002)(451199021)(40470700004)(46966006)(36840700001)(186003)(47076005)(26005)(36860700001)(110136005)(36756003)(8676002)(44832011)(356005)(2906002)(83380400001)(54906003)(40480700001)(41300700001)(82310400005)(316002)(4326008)(1076003)(2616005)(86362001)(82740400003)(478600001)(70206006)(70586007)(16526019)(426003)(8936002)(5660300002)(81166007)(40460700003)(336012)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 19:03:09.8615
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 28577aab-117c-4278-b4bd-08db2c9a68e3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4517
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
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
 drivers/net/ethernet/amd/pds_core/core.h | 10 ++++
 drivers/net/ethernet/amd/pds_core/dev.c  |  3 ++
 drivers/net/ethernet/amd/pds_core/main.c | 51 ++++++++++++++++++++
 4 files changed, 124 insertions(+)

diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index 80d2ecb045df..39e9a215f638 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -34,3 +34,63 @@ void pdsc_teardown(struct pdsc *pdsc, bool removing)
 
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
index a49af9f36e23..29cec08bd795 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -12,6 +12,8 @@
 #include <linux/pds/pds_intr.h>
 
 #define PDSC_DRV_DESCRIPTION	"AMD/Pensando Core Driver"
+
+#define PDSC_WATCHDOG_SECS	5
 #define PDSC_TEARDOWN_RECOVERY	false
 #define PDSC_TEARDOWN_REMOVING	true
 #define PDSC_SETUP_RECOVERY	false
@@ -63,12 +65,17 @@ struct pdsc {
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
@@ -81,6 +88,8 @@ struct pdsc {
 	u64 __iomem *kern_dbpage;
 };
 
+void pdsc_queue_health_check(struct pdsc *pdsc);
+
 struct pdsc *pdsc_dl_alloc(struct device *dev, bool is_pf);
 void pdsc_dl_free(struct pdsc *pdsc);
 int pdsc_dl_register(struct pdsc *pdsc);
@@ -116,5 +125,6 @@ int pdsc_dev_init(struct pdsc *pdsc);
 
 int pdsc_setup(struct pdsc *pdsc, bool init);
 void pdsc_teardown(struct pdsc *pdsc, bool removing);
+void pdsc_health_thread(struct work_struct *work);
 
 #endif /* _PDSC_H_ */
diff --git a/drivers/net/ethernet/amd/pds_core/dev.c b/drivers/net/ethernet/amd/pds_core/dev.c
index 52385a72246d..292deaffe8d6 100644
--- a/drivers/net/ethernet/amd/pds_core/dev.c
+++ b/drivers/net/ethernet/amd/pds_core/dev.c
@@ -177,6 +177,9 @@ int pdsc_devcmd_locked(struct pdsc *pdsc, union pds_core_dev_cmd *cmd,
 	err = pdsc_devcmd_wait(pdsc, max_seconds);
 	memcpy_fromio(comp, &pdsc->cmd_regs->comp, sizeof(*comp));
 
+	if (err == -ENXIO || err == -ETIMEDOUT)
+		pdsc_queue_health_check(pdsc);
+
 	return err;
 }
 
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index a8630cec7b59..6a39faac5c76 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -27,6 +27,31 @@ static const struct pci_device_id pdsc_id_table[] = {
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
@@ -137,8 +162,11 @@ static int pdsc_init_vf(struct pdsc *vf)
 	return -1;
 }
 
+#define PDSC_WQ_NAME_LEN 24
+
 static int pdsc_init_pf(struct pdsc *pdsc)
 {
+	char wq_name[PDSC_WQ_NAME_LEN];
 	int err;
 
 	pcie_print_link_status(pdsc->pdev);
@@ -154,6 +182,13 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 	if (err)
 		goto err_out_release_regions;
 
+	/* General workqueue and timer, but don't start timer yet */
+	snprintf(wq_name, sizeof(wq_name), "%s.%d", PDS_CORE_DRV_NAME, pdsc->id);
+	pdsc->wq = create_singlethread_workqueue(wq_name);
+	INIT_WORK(&pdsc->health_work, pdsc_health_thread);
+	timer_setup(&pdsc->wdtimer, pdsc_wdtimer_cb, 0);
+	pdsc->wdtimer_period = PDSC_WATCHDOG_SECS * HZ;
+
 	mutex_init(&pdsc->devcmd_lock);
 	mutex_init(&pdsc->config_lock);
 
@@ -170,12 +205,21 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 
 	mutex_unlock(&pdsc->config_lock);
 
+	/* Lastly, start the health check timer */
+	mod_timer(&pdsc->wdtimer, round_jiffies(jiffies + pdsc->wdtimer_period));
+
 	return 0;
 
 err_out_teardown:
 	pdsc_teardown(pdsc, PDSC_TEARDOWN_REMOVING);
 err_out_unmap_bars:
 	mutex_unlock(&pdsc->config_lock);
+	del_timer_sync(&pdsc->wdtimer);
+	if (pdsc->wq) {
+		flush_workqueue(pdsc->wq);
+		destroy_workqueue(pdsc->wq);
+		pdsc->wq = NULL;
+	}
 	mutex_destroy(&pdsc->config_lock);
 	mutex_destroy(&pdsc->devcmd_lock);
 	pci_free_irq_vectors(pdsc->pdev);
@@ -263,6 +307,13 @@ static void pdsc_remove(struct pci_dev *pdev)
 	pdsc_dl_unregister(pdsc);
 
 	if (!pdev->is_virtfn) {
+		del_timer_sync(&pdsc->wdtimer);
+		if (pdsc->wq) {
+			flush_workqueue(pdsc->wq);
+			destroy_workqueue(pdsc->wq);
+			pdsc->wq = NULL;
+		}
+
 		mutex_lock(&pdsc->config_lock);
 		set_bit(PDSC_S_STOPPING_DRIVER, &pdsc->state);
 
-- 
2.17.1

