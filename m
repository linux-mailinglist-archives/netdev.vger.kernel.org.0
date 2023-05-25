Return-Path: <netdev+bounces-5434-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C16657113F8
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 20:35:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7DA181C20F3F
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:35:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0EE51EA8F;
	Thu, 25 May 2023 18:35:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C881156F4
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 18:35:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF25AC433EF;
	Thu, 25 May 2023 18:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685039736;
	bh=34AFP84eVLDkaMxF9Z7xvIZ4RPxJiWPdsI3myJ2MqGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X7q2Tw6MPYfuyb3Af/u6XyCOeyPGoHSVZTxySPNy9riebIXosd4OADIuhbKnnqQFW
	 sPMrdZA+rha0eS3Vr29z9sBDTzMtNL6tULg5QudXGY9Z0Q06bd+AmjQrkP/D+fnR45
	 nhKro+l+YKN5Af27HSUKopoFutDkmDiLH3HbM8icc6KkoXkg8qAd1cfgpCaX9iTH+B
	 uOwG+zF5HZvTA8BzTcKqMTVO2x9/1AQ4yc4115J5KdTzIJYuIVcIAJ2yF2MEpKGNqa
	 Za5Aqwxoa+UYbF4l7E2YW+Tf50XgHBNbV46VsO5foK4imnWyccX1ovlkvPCoQcA/AA
	 /L6D8RSLJh3Yg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Kai-Heng Feng <kai.heng.feng@canonical.com>,
	"David S . Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	chandrashekar.devegowda@intel.com,
	linuxwwan@intel.com,
	loic.poulain@linaro.org,
	ryazanov.s.a@gmail.com,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.3 55/67] net: wwan: t7xx: Ensure init is completed before system sleep
Date: Thu, 25 May 2023 14:31:32 -0400
Message-Id: <20230525183144.1717540-55-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230525183144.1717540-1-sashal@kernel.org>
References: <20230525183144.1717540-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit ab87603b251134441a67385ecc9d3371be17b7a7 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/t7xx/t7xx_pci.c | 18 ++++++++++++++++++
 drivers/net/wwan/t7xx/t7xx_pci.h |  1 +
 2 files changed, 19 insertions(+)

diff --git a/drivers/net/wwan/t7xx/t7xx_pci.c b/drivers/net/wwan/t7xx/t7xx_pci.c
index 226fc1703e90f..91256e005b846 100644
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
index 112efa534eace..f08f1ab744691 100644
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
2.39.2


