Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275BB2286F8
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730700AbgGURO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:14:58 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:39508 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730015AbgGURO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:14:56 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1595351695; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=PigUcyn1h95S9+H6bcv2J1xVFlRM+Wlov9hyYKxTijY=; b=ZTBpGbhTmxoJKejc11hMCVUF0gusVgVSZrOmWuU4K3wQnPLSSxQo9D5XxxFIsUoq3EwPf7Mx
 JGElMWNE3f08TtVgDanPM5X4EtoCYsoFzis7LUgdaPUuEtrHy0IJoRV9OybIaL2k443aY6KJ
 vhvdvgPn3emPMgCKhi89meL7GgY=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n14.prod.us-west-2.postgun.com with SMTP id
 5f17228e8e9b2c49c64aa5cd (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 21 Jul 2020 17:14:54
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 015B3C4339C; Tue, 21 Jul 2020 17:14:53 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from pillair-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pillair)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4650CC43391;
        Tue, 21 Jul 2020 17:14:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4650CC43391
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvalo@codeaurora.org, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dianders@chromium.org, evgreen@chromium.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [RFC 3/7] ath10k: Add module param to enable rx thread
Date:   Tue, 21 Jul 2020 22:44:22 +0530
Message-Id: <1595351666-28193-4-git-send-email-pillair@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>
References: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a module parameter to enable or disable
the processing of received packets in rx thread.

To enable rx packet processing in a thread
context, use the belo command to load driver:
insmod ath10k_snoc.ko rx_thread_enable=1

Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.1-01040-QCAHLSWMTPLZ-1

Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.h |  1 +
 drivers/net/wireless/ath/ath10k/snoc.c | 24 +++++++++++++++++-------
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 96919e8..59bdf11 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -998,6 +998,7 @@ struct ath10k {
 	} msa;
 	u8 mac_addr[ETH_ALEN];
 
+	bool rx_thread_enable;
 	struct ath10k_thread rx_thread;
 	enum ath10k_hw_rev hw_rev;
 	u16 dev_id;
diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 463c34e..f01725b 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -26,6 +26,12 @@
 #define CE_POLL_PIPE 4
 #define ATH10K_SNOC_WAKE_IRQ 2
 
+static bool ath10k_rx_thread_enable;
+
+module_param_named(rx_thread_enable, ath10k_rx_thread_enable, bool, 0644);
+
+MODULE_PARM_DESC(rx_thread_enable, "Receive packet processing in thread");
+
 static char *const ce_name[] = {
 	"WLAN_CE_0",
 	"WLAN_CE_1",
@@ -941,7 +947,8 @@ static void ath10k_snoc_hif_stop(struct ath10k *ar)
 
 	napi_synchronize(&ar->napi);
 	napi_disable(&ar->napi);
-	ath10k_core_thread_shutdown(ar, &ar->rx_thread);
+	if (ar->rx_thread_enable)
+		ath10k_core_thread_shutdown(ar, &ar->rx_thread);
 	ath10k_snoc_buffer_cleanup(ar);
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot hif stop\n");
 }
@@ -954,12 +961,14 @@ static int ath10k_snoc_hif_start(struct ath10k *ar)
 	bitmap_clear(ar_snoc->pending_ce_irqs, 0, CE_COUNT_MAX);
 	napi_enable(&ar->napi);
 
-	ret = ath10k_core_thread_init(ar, &ar->rx_thread,
-				      ath10k_snoc_rx_thread_loop,
-				      "ath10k_rx_thread");
-	if (ret) {
-		ath10k_err(ar, "failed to start rx thread\n");
-		goto rx_thread_fail;
+	if (ar->rx_thread_enable) {
+		ret = ath10k_core_thread_init(ar, &ar->rx_thread,
+					      ath10k_snoc_rx_thread_loop,
+					      "ath10k_rx_thread");
+		if (ret) {
+			ath10k_err(ar, "failed to start rx thread\n");
+			goto rx_thread_fail;
+		}
 	}
 
 	ath10k_snoc_irq_enable(ar);
@@ -1693,6 +1702,7 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
 	}
 
 	ar->rx_thread.ar = ar;
+	ar->rx_thread_enable = ath10k_rx_thread_enable;
 	ar_snoc = ath10k_snoc_priv(ar);
 	ar_snoc->dev = pdev;
 	platform_set_drvdata(pdev, ar);
-- 
2.7.4

