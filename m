Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31AE0322C4C
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 15:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbhBWOaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 09:30:39 -0500
Received: from alexa-out.qualcomm.com ([129.46.98.28]:52087 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233056AbhBWOaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 09:30:25 -0500
Received: from ironmsg-lv-alpha.qualcomm.com ([10.47.202.13])
  by alexa-out.qualcomm.com with ESMTP; 23 Feb 2021 06:29:44 -0800
X-QCInternal: smtphost
Received: from ironmsg02-blr.qualcomm.com ([10.86.208.131])
  by ironmsg-lv-alpha.qualcomm.com with ESMTP/TLS/AES256-SHA; 23 Feb 2021 06:29:42 -0800
Cc:     ath10k-review.external@qti.qualcomm.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuabhs@chromium.org,
        dianders@chromium.org, briannorris@chromium.org,
        Youghandhar Chintala <youghand@codeaurora.org>
X-QCInternal: smtphost
Received: from youghand-linux.qualcomm.com ([10.206.66.115])
  by ironmsg02-blr.qualcomm.com with ESMTP; 23 Feb 2021 19:59:10 +0530
Received: by youghand-linux.qualcomm.com (Postfix, from userid 2370257)
        id E27EB215EC; Tue, 23 Feb 2021 19:59:10 +0530 (IST)
From:   Youghandhar Chintala <youghand@codeaurora.org>
To:     ath10k@lists.infradead.org
Subject: [PATCH v3] ath10k: skip the wait for completion to recovery in shutdown path
Date:   Tue, 23 Feb 2021 19:59:08 +0530
Message-Id: <20210223142908.23374-1-youghand@codeaurora.org>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently in the shutdown callback we wait for recovery to complete
before freeing up the resources. This results in additional two seconds
delay during the shutdown and thereby increase the shutdown time.

As an attempt to take less time during shutdown, remove the wait for
recovery completion in the shutdown callback and added an API to freeing
the reosurces in which they were common for shutdown and removing
the module.

Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.1-01040-QCAHLSWMTPLZ-1

Signed-off-by: Youghandhar Chintala <youghand@codeaurora.org>
Change-Id: I65bc27b5adae1fedc7f7b367ef13aafbd01f8c0c
---
Changes from v2:
-Corrected commit text and added common API for freeing the
 resources for shutdown and unloading the module
---
 drivers/net/wireless/ath/ath10k/snoc.c | 29 ++++++++++++++++++--------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 84666f72bdfa..70b3f2bd1c81 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -1781,17 +1781,11 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int ath10k_snoc_remove(struct platform_device *pdev)
+static int ath10k_snoc_free_resources(struct ath10k *ar)
 {
-	struct ath10k *ar = platform_get_drvdata(pdev);
 	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
 
-	ath10k_dbg(ar, ATH10K_DBG_SNOC, "snoc remove\n");
-
-	reinit_completion(&ar->driver_recovery);
-
-	if (test_bit(ATH10K_SNOC_FLAG_RECOVERY, &ar_snoc->flags))
-		wait_for_completion_timeout(&ar->driver_recovery, 3 * HZ);
+	ath10k_dbg(ar, ATH10K_DBG_SNOC, "snoc free resources\n");
 
 	set_bit(ATH10K_SNOC_FLAG_UNREGISTERING, &ar_snoc->flags);
 
@@ -1805,12 +1799,29 @@ static int ath10k_snoc_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static int ath10k_snoc_remove(struct platform_device *pdev)
+{
+	struct ath10k *ar = platform_get_drvdata(pdev);
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
+
+	ath10k_dbg(ar, ATH10K_DBG_SNOC, "snoc remove\n");
+
+	reinit_completion(&ar->driver_recovery);
+
+	if (test_bit(ATH10K_SNOC_FLAG_RECOVERY, &ar_snoc->flags))
+		wait_for_completion_timeout(&ar->driver_recovery, 3 * HZ);
+
+	ath10k_snoc_free_resources(ar);
+
+	return 0;
+}
+
 static void ath10k_snoc_shutdown(struct platform_device *pdev)
 {
 	struct ath10k *ar = platform_get_drvdata(pdev);
 
 	ath10k_dbg(ar, ATH10K_DBG_SNOC, "snoc shutdown\n");
-	ath10k_snoc_remove(pdev);
+	ath10k_snoc_free_resources(ar);
 }
 
 static struct platform_driver ath10k_snoc_driver = {
-- 
2.29.0

