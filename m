Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7732B67CC02
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 14:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236761AbjAZN01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 08:26:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236599AbjAZN0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 08:26:25 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240EF1114C
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 05:26:23 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id r2so1757661wrv.7
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 05:26:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zFzGTdSeUZShJWXng6t6oHRfoqpnOHHMtiWs6jD2Vic=;
        b=XhOGfFeOSoOxVr49ozuK+4qkVy+qC5ACfg0BOrhkkhy6IPmycsJxMJpjVxJKXdhaZx
         xATowXGJTqYYR2y6+dayzGUR6pQejgROXgkf3qCQKxs8GzG7rvXVO1mX/qhsIDwOTV17
         hc2au1yJtOv/Y/F8lriRkkQgUK1/ol4irRzzKxdvpedtN9QUOtH8H1wj9TblMjIJD6do
         O/R4hZWjJj4MsqSgxCIxM+tWLFfRq6zu6pVaKjGfyDRGsZ7xHR1BdkhA/xLgGToB0c8H
         3J8gJLpOQhz5pWs88cs5CCPN913xG2kZw6AiCvH85Bq5EZpQUeW1dZIvBTEdHV/qENUw
         qdCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zFzGTdSeUZShJWXng6t6oHRfoqpnOHHMtiWs6jD2Vic=;
        b=trK9GS3XAc4FYMraFnc8yiOnGHMSv9QGxM67J0ARLlkNTgv/tK7u+fpnTJ6GW8nhwt
         wBDM9vUWk8g+09QFkhZIfopN20Yj1JU9G4urt+tEDpLhESlx4ElTxP5481BEKJBLDcac
         5reh8d7Cz9CKnfcoDl2SnR53lfpw3NYzOO1s5zqSec9NgmU4t0cESoAzdppGi4kYsh73
         g2GO80wWhzRbAVlJBYzCBp2V//ShXHWXXIhOuxWsi1vPjwpFNVglojJUv9Pzj43O1G1C
         Wy6RGHaVFvYM4HlYUTi6te+Ki3PaGKYcUdTEQtp6iRapU49IV4eVDIN/mnVjzdd+1dw2
         M+4w==
X-Gm-Message-State: AFqh2koi4y1rwcyiKNYPhiyDcyxnuX6HfxKzGROzwzUyrAao1pbJzz8C
        uIXNLM6vbbgtxTCzBGjp0kt4zzKIKsTge+EIFGW6rA==
X-Google-Smtp-Source: AMrXdXvo0Jms8syJaFSQpLL3dxh6mz5xXK7rVBeq324YVtfeYEwpmism+Lx8dgm/Vxpe2T5o2di5iw==
X-Received: by 2002:adf:b509:0:b0:2bf:9465:641 with SMTP id a9-20020adfb509000000b002bf94650641mr17292252wrd.65.1674739581382;
        Thu, 26 Jan 2023 05:26:21 -0800 (PST)
Received: from orzel1.c.googlers.com.com (44.232.78.34.bc.googleusercontent.com. [34.78.232.44])
        by smtp.gmail.com with ESMTPSA id p2-20020a5d4582000000b002b6bcc0b64dsm1326108wrq.4.2023.01.26.05.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 05:26:21 -0800 (PST)
From:   =?UTF-8?q?Kornel=20Dul=C4=99ba?= <mindal@semihalf.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@linux.intel.com>,
        Liu Haijun <haijun.liu@mediatek.com>,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, rad@semihalf.com,
        mw@semihalf.com, upstream@semihalf.com,
        =?UTF-8?q?Kornel=20Dul=C4=99ba?= <mindal@semihalf.com>
Subject: [PATCH 1/2] net: wwan: t7xx: Fix Runtime PM resume sequence
Date:   Thu, 26 Jan 2023 13:25:34 +0000
Message-Id: <20230126132535.80339-2-mindal@semihalf.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
In-Reply-To: <20230126132535.80339-1-mindal@semihalf.com>
References: <20230126132535.80339-1-mindal@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resume device before calling napi_schedule, instead of doing in the napi
poll routine. Polling is done in softrq context. We can't call the PM
resume logic from there as it's blocking and not irq safe.
In order to make it work modify the interrupt handler to be run from irq
handler thread.

Fixes: 5545b7b9f294 ("net: wwan: t7xx: Add NAPI support")
Signed-off-by: Kornel Dulęba <mindal@semihalf.com>
---
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif.c    | 11 +++++++-
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c | 29 +++++++++++++++-------
 drivers/net/wwan/t7xx/t7xx_netdev.c        | 16 +++++++++++-
 3 files changed, 45 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif.c b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif.c
index 7eff3531b9a5..7ff33c1d6ac7 100644
--- a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif.c
+++ b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif.c
@@ -152,6 +152,15 @@ static irqreturn_t t7xx_dpmaif_isr_handler(int irq, void *data)
 	}
 
 	t7xx_pcie_mac_clear_int(dpmaif_ctrl->t7xx_dev, isr_para->pcie_int);
+
+	return IRQ_WAKE_THREAD;
+}
+
+static irqreturn_t t7xx_dpmaif_isr_thread(int irq, void *data)
+{
+	struct dpmaif_isr_para *isr_para = data;
+	struct dpmaif_ctrl *dpmaif_ctrl = isr_para->dpmaif_ctrl;
+
 	t7xx_dpmaif_irq_cb(isr_para);
 	t7xx_pcie_mac_set_int(dpmaif_ctrl->t7xx_dev, isr_para->pcie_int);
 	return IRQ_HANDLED;
@@ -188,7 +197,7 @@ static void t7xx_dpmaif_register_pcie_irq(struct dpmaif_ctrl *dpmaif_ctrl)
 		t7xx_pcie_mac_clear_int(t7xx_dev, int_type);
 
 		t7xx_dev->intr_handler[int_type] = t7xx_dpmaif_isr_handler;
-		t7xx_dev->intr_thread[int_type] = NULL;
+		t7xx_dev->intr_thread[int_type] = t7xx_dpmaif_isr_thread;
 		t7xx_dev->callback_param[int_type] = isr_para;
 
 		t7xx_pcie_mac_clear_int_status(t7xx_dev, int_type);
diff --git a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
index aa2174a10437..f4ff2198b5ef 100644
--- a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
+++ b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
@@ -840,14 +840,13 @@ int t7xx_dpmaif_napi_rx_poll(struct napi_struct *napi, const int budget)
 
 	if (!rxq->que_started) {
 		atomic_set(&rxq->rx_processing, 0);
+		pm_runtime_put_autosuspend(rxq->dpmaif_ctrl->dev);
 		dev_err(rxq->dpmaif_ctrl->dev, "Work RXQ: %d has not been started\n", rxq->index);
 		return work_done;
 	}
 
-	if (!rxq->sleep_lock_pending) {
-		pm_runtime_get_noresume(rxq->dpmaif_ctrl->dev);
+	if (!rxq->sleep_lock_pending)
 		t7xx_pci_disable_sleep(t7xx_dev);
-	}
 
 	ret = try_wait_for_completion(&t7xx_dev->sleep_lock_acquire);
 	if (!ret) {
@@ -876,22 +875,22 @@ int t7xx_dpmaif_napi_rx_poll(struct napi_struct *napi, const int budget)
 		napi_complete_done(napi, work_done);
 		t7xx_dpmaif_clr_ip_busy_sts(&rxq->dpmaif_ctrl->hw_info);
 		t7xx_dpmaif_dlq_unmask_rx_done(&rxq->dpmaif_ctrl->hw_info, rxq->index);
+		t7xx_pci_enable_sleep(rxq->dpmaif_ctrl->t7xx_dev);
+		pm_runtime_mark_last_busy(rxq->dpmaif_ctrl->dev);
+		pm_runtime_put_autosuspend(rxq->dpmaif_ctrl->dev);
+		atomic_set(&rxq->rx_processing, 0);
 	} else {
 		t7xx_dpmaif_clr_ip_busy_sts(&rxq->dpmaif_ctrl->hw_info);
 	}
 
-	t7xx_pci_enable_sleep(rxq->dpmaif_ctrl->t7xx_dev);
-	pm_runtime_mark_last_busy(rxq->dpmaif_ctrl->dev);
-	pm_runtime_put_noidle(rxq->dpmaif_ctrl->dev);
-	atomic_set(&rxq->rx_processing, 0);
-
 	return work_done;
 }
 
 void t7xx_dpmaif_irq_rx_done(struct dpmaif_ctrl *dpmaif_ctrl, const unsigned int que_mask)
 {
 	struct dpmaif_rx_queue *rxq;
-	int qno;
+	struct dpmaif_ctrl *ctrl;
+	int qno, ret;
 
 	qno = ffs(que_mask) - 1;
 	if (qno < 0 || qno > DPMAIF_RXQ_NUM - 1) {
@@ -900,6 +899,18 @@ void t7xx_dpmaif_irq_rx_done(struct dpmaif_ctrl *dpmaif_ctrl, const unsigned int
 	}
 
 	rxq = &dpmaif_ctrl->rxq[qno];
+	ctrl = rxq->dpmaif_ctrl;
+	/* We need to make sure that the modem has been resumed before
+	 * calling napi. This can't be done inside the polling function
+	 * as we could be blocked waiting for device to be resumed,
+	 * which can't be done from softirq context the poll function
+	 * is running in.
+	 */
+	ret = pm_runtime_resume_and_get(ctrl->dev);
+	if (ret < 0 && ret != -EACCES) {
+		dev_err(ctrl->dev, "Failed to resume device: %d\n", ret);
+		return;
+	}
 	napi_schedule(&rxq->napi);
 }
 
diff --git a/drivers/net/wwan/t7xx/t7xx_netdev.c b/drivers/net/wwan/t7xx/t7xx_netdev.c
index 494a28e386a3..3ef4a8a4f8fd 100644
--- a/drivers/net/wwan/t7xx/t7xx_netdev.c
+++ b/drivers/net/wwan/t7xx/t7xx_netdev.c
@@ -27,6 +27,7 @@
 #include <linux/list.h>
 #include <linux/netdev_features.h>
 #include <linux/netdevice.h>
+#include <linux/pm_runtime.h>
 #include <linux/skbuff.h>
 #include <linux/types.h>
 #include <linux/wwan.h>
@@ -45,12 +46,25 @@
 
 static void t7xx_ccmni_enable_napi(struct t7xx_ccmni_ctrl *ctlb)
 {
-	int i;
+	struct dpmaif_ctrl *ctrl;
+	int i, ret;
+
+	ctrl =  ctlb->hif_ctrl;
 
 	if (ctlb->is_napi_en)
 		return;
 
 	for (i = 0; i < RXQ_NUM; i++) {
+		/* The usage count has to be bumped every time before calling
+		 * napi_schedule. It will be decresed in the poll routine,
+		 * right after napi_complete_done is called.
+		 */
+		ret = pm_runtime_resume_and_get(ctrl->dev);
+		if (ret < 0) {
+			dev_err(ctrl->dev, "Failed to resume device: %d\n",
+				ret);
+			return;
+		}
 		napi_enable(ctlb->napi[i]);
 		napi_schedule(ctlb->napi[i]);
 	}
-- 
2.39.1.456.gfc5497dd1b-goog

