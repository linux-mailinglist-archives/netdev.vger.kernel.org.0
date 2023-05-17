Return-Path: <netdev+bounces-3207-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BE837705F61
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 07:30:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7983328116D
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 05:30:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3281253BD;
	Wed, 17 May 2023 05:25:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282E63212
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 05:25:56 +0000 (UTC)
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B75540C0;
	Tue, 16 May 2023 22:25:49 -0700 (PDT)
Received: from localhost.localdomain (unknown [10.101.196.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id B348F42ADB;
	Wed, 17 May 2023 05:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1684301142;
	bh=LN2I4rs9nd2jBQ5+AzfrrYXlbpfi5mpuUEXL2JSMY2Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
	b=cQpd5yYzDuEjHhenUWYtNRvwVuiKf/eJtxodJ82UFKgmViJbA9Pdhd7R/BR68IE1b
	 u1Adke1ERZiJiVU2P6FI0z+4meiQfNNnJm6auaw4S98bk7luthyNTCDozw7KLe3MoD
	 hiiyByOSQzAlx7x1bOBj/BWtxHrN5A+0RLjLOBnCaSeeEcT1djLwVQ6iMzoNLaJ4Aa
	 rdizG/XeYejpPYATyWFVvOdmQN4I3ZvqHzkLYrUvsyzYAFlB33RWLwJTe96RVO2Eo7
	 XZTXpPT6VSpvHvdD6TESWsA4qiiNAPEmkINWkltG23ePo1qdYAKhbJMdYB6UJrNvtp
	 fyLVQ2ZJ9xNEA==
From: Kai-Heng Feng <kai.heng.feng@canonical.com>
To: chandrashekar.devegowda@intel.com,
	linuxwwan@intel.com,
	chiranjeevi.rapolu@linux.intel.com,
	haijun.liu@mediatek.com,
	m.chetan.kumar@linux.intel.com,
	ricardo.martinez@linux.intel.com
Cc: Kai-Heng Feng <kai.heng.feng@canonical.com>,
	Loic Poulain <loic.poulain@linaro.org>,
	Sergey Ryazanov <ryazanov.s.a@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: wwan: t7xx: Ensure init is completed before system sleep
Date: Wed, 17 May 2023 13:24:51 +0800
Message-Id: <20230517052451.398452-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When the system attempts to sleep while mtk_t7xx is not ready, the driver
cannot put the device to sleep:
[   12.472918] mtk_t7xx 0000:57:00.0: [PM] Exiting suspend, modem in invalid state
[   12.472936] mtk_t7xx 0000:57:00.0: PM: pci_pm_suspend(): t7xx_pci_pm_suspend+0x0/0x20 [mtk_t7xx] returns -14
[   12.473678] mtk_t7xx 0000:57:00.0: PM: dpm_run_callback(): pci_pm_suspend+0x0/0x1b0 returns -14
[   12.473711] mtk_t7xx 0000:57:00.0: PM: failed to suspend async: error -14
[   12.764776] PM: Some devices failed to suspend, or early wake event detected

Mediatek confirmed the device can take a rather long time to complete
its initialization, so wait for up to 20 seconds until init is done.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
v2:
 - Define timeout value
 - Return error if prepare callback fails.

 drivers/net/wwan/t7xx/t7xx_pci.c | 18 ++++++++++++++++++
 drivers/net/wwan/t7xx/t7xx_pci.h |  1 +
 2 files changed, 19 insertions(+)

diff --git a/drivers/net/wwan/t7xx/t7xx_pci.c b/drivers/net/wwan/t7xx/t7xx_pci.c
index 226fc1703e90..91256e005b84 100644
--- a/drivers/net/wwan/t7xx/t7xx_pci.c
+++ b/drivers/net/wwan/t7xx/t7xx_pci.c
@@ -45,6 +45,7 @@
 #define T7XX_PCI_IREG_BASE		0
 #define T7XX_PCI_EREG_BASE		2
 
+#define T7XX_INIT_TIMEOUT		20
 #define PM_SLEEP_DIS_TIMEOUT_MS		20
 #define PM_ACK_TIMEOUT_MS		1500
 #define PM_AUTOSUSPEND_MS		20000
@@ -96,6 +97,7 @@ static int t7xx_pci_pm_init(struct t7xx_pci_dev *t7xx_dev)
 	spin_lock_init(&t7xx_dev->md_pm_lock);
 	init_completion(&t7xx_dev->sleep_lock_acquire);
 	init_completion(&t7xx_dev->pm_sr_ack);
+	init_completion(&t7xx_dev->init_done);
 	atomic_set(&t7xx_dev->md_pm_state, MTK_PM_INIT);
 
 	device_init_wakeup(&pdev->dev, true);
@@ -124,6 +126,7 @@ void t7xx_pci_pm_init_late(struct t7xx_pci_dev *t7xx_dev)
 	pm_runtime_mark_last_busy(&t7xx_dev->pdev->dev);
 	pm_runtime_allow(&t7xx_dev->pdev->dev);
 	pm_runtime_put_noidle(&t7xx_dev->pdev->dev);
+	complete_all(&t7xx_dev->init_done);
 }
 
 static int t7xx_pci_pm_reinit(struct t7xx_pci_dev *t7xx_dev)
@@ -529,6 +532,20 @@ static void t7xx_pci_shutdown(struct pci_dev *pdev)
 	__t7xx_pci_pm_suspend(pdev);
 }
 
+static int t7xx_pci_pm_prepare(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct t7xx_pci_dev *t7xx_dev;
+
+	t7xx_dev = pci_get_drvdata(pdev);
+	if (!wait_for_completion_timeout(&t7xx_dev->init_done, T7XX_INIT_TIMEOUT * HZ)) {
+		dev_warn(dev, "Not ready for system sleep.\n");
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+
 static int t7xx_pci_pm_suspend(struct device *dev)
 {
 	return __t7xx_pci_pm_suspend(to_pci_dev(dev));
@@ -555,6 +572,7 @@ static int t7xx_pci_pm_runtime_resume(struct device *dev)
 }
 
 static const struct dev_pm_ops t7xx_pci_pm_ops = {
+	.prepare = t7xx_pci_pm_prepare,
 	.suspend = t7xx_pci_pm_suspend,
 	.resume = t7xx_pci_pm_resume,
 	.resume_noirq = t7xx_pci_pm_resume_noirq,
diff --git a/drivers/net/wwan/t7xx/t7xx_pci.h b/drivers/net/wwan/t7xx/t7xx_pci.h
index 112efa534eac..f08f1ab74469 100644
--- a/drivers/net/wwan/t7xx/t7xx_pci.h
+++ b/drivers/net/wwan/t7xx/t7xx_pci.h
@@ -69,6 +69,7 @@ struct t7xx_pci_dev {
 	struct t7xx_modem	*md;
 	struct t7xx_ccmni_ctrl	*ccmni_ctlb;
 	bool			rgu_pci_irq_en;
+	struct completion	init_done;
 
 	/* Low Power Items */
 	struct list_head	md_pm_entities;
-- 
2.34.1


