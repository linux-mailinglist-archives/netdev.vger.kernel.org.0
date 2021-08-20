Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4FC3F3129
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 18:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235964AbhHTQJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 12:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbhHTQIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 12:08:00 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF6CC061A27
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 09:01:34 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id n24so12897572ion.10
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 09:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5Zp2UhUWsdpQXcD+Wi7vB0yP7JhgbGoHAYGs2axxCBc=;
        b=dZJIJa+WP/cbXinW1iKx/je5svj4nisn8VTBDRkhlKuWPxvQHQxGsDwIZSP/B8tXQP
         UHZMc+MdI+ckkiYlG8MUJfAdruZodzNCt16AGIVxnj0HaDdlcUIQ1nHrRvIJWuNwxL/Q
         8xTJxkImF+FFuL1HE6h7EKMonjlR9WtCrqXOxaVBO2Z/uLjHjWGjVlq8o9XHb84ixLfn
         ryw0dhPc1tw5P6fcDayakJ1g5BGEH98fhVFrJK15T7ORd+pPqHIrcGTRN7G+fuDZlhvP
         KE1eRwJtNuyT6xA/9KN5z2aMuJ81vNFx85yDpaLoLdD+AYFoAVYseRSVUcumoQYtio3Y
         gLsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5Zp2UhUWsdpQXcD+Wi7vB0yP7JhgbGoHAYGs2axxCBc=;
        b=ojcCTRBsuIFGaGRefTUtXbH2IAtVdOKyAx4325lUkDBXrxFJu+Fz1/bhx/im2t9fNC
         mXTGAAaOOK4/3naJuaFzt/X80HtPAknTtvXmMC/DN5Z1EufQ8j3CfytvPuupMClR5MDv
         CrK4vbZ0eDofgRsp1WSclDL/uXSE/OB/5iNDqAYpR+83ImDjgMTH4u/dNqIN8eVKrNep
         CKCuPb3wCTg7tvY5UlZ3MKt9qsUct0jprXqRILrbsht/mvdAmRfScqK1lbZQC0o2bZ2k
         iwck2q7uqQ5+UgOhwRX4b/2l5t/5iyAZXDydJQDn5eHLMqx4qFynkfbGtslLq91wuyQg
         7ArA==
X-Gm-Message-State: AOAM532kGv449JSDQkPk7d1oxXrtQLSax6ZmNRtTCwrsbOLRNSK675+f
        rM/NkikzkdUZfA3fPtkkB7ZWvA==
X-Google-Smtp-Source: ABdhPJwKIPDQpucWqSQNqHllRSaXw4c2gpSMzzDzttAfnxFBkm/czfL94v9ljvcc8z2e2jTOAI+0gg==
X-Received: by 2002:a6b:2b97:: with SMTP id r145mr2162303ior.193.1629475293766;
        Fri, 20 Aug 2021 09:01:33 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id a8sm3521317ilq.63.2021.08.20.09.01.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 09:01:33 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/3] net: ipa: use autosuspend
Date:   Fri, 20 Aug 2021 11:01:27 -0500
Message-Id: <20210820160129.3473253-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210820160129.3473253-1-elder@linaro.org>
References: <20210820160129.3473253-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use runtime power management autosuspend.

Up until this point, we only suspended the IPA hardware for system
suspend; now we'll suspend it aggressively using runtime power
management, setting the initial autosuspend delay to half a second
of inactivity.

Replace pm_runtime_put() calls with pm_runtime_put_autosuspend(),
call pm_runtime_mark_last_busy() before each of those.  In places
where we're shutting things down, or decrementing power references
for errors, use pm_runtime_put_noidle() instead.

Finally, remove ipa_runtime_idle(), so the ->runtime_suspend
callback will occur if idle.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_clock.c     | 15 +++++++--------
 drivers/net/ipa/ipa_interrupt.c |  3 ++-
 drivers/net/ipa/ipa_main.c      | 11 ++++++-----
 drivers/net/ipa/ipa_modem.c     | 16 ++++++++++------
 drivers/net/ipa/ipa_smp2p.c     |  8 ++++++--
 drivers/net/ipa/ipa_uc.c        | 12 +++++++++---
 6 files changed, 40 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_clock.c
index 149b24da0bcc7..54d684945a7f8 100644
--- a/drivers/net/ipa/ipa_clock.c
+++ b/drivers/net/ipa/ipa_clock.c
@@ -32,6 +32,8 @@
  * An IPA clock reference must be held for any access to IPA hardware.
  */
 
+#define IPA_AUTOSUSPEND_DELAY	500	/* milliseconds */
+
 /**
  * struct ipa_interconnect - IPA interconnect information
  * @path:		Interconnect path
@@ -267,11 +269,6 @@ static int ipa_runtime_resume(struct device *dev)
 	return 0;
 }
 
-static int ipa_runtime_idle(struct device *dev)
-{
-	return -EAGAIN;
-}
-
 static int ipa_suspend(struct device *dev)
 {
 	struct ipa *ipa = dev_get_drvdata(dev);
@@ -443,7 +440,8 @@ ipa_clock_init(struct device *dev, const struct ipa_clock_data *data)
 	if (ret)
 		goto err_kfree;
 
-	pm_runtime_dont_use_autosuspend(dev);
+	pm_runtime_set_autosuspend_delay(dev, IPA_AUTOSUSPEND_DELAY);
+	pm_runtime_use_autosuspend(dev);
 	pm_runtime_enable(dev);
 
 	return clock;
@@ -459,9 +457,11 @@ ipa_clock_init(struct device *dev, const struct ipa_clock_data *data)
 /* Inverse of ipa_clock_init() */
 void ipa_clock_exit(struct ipa_clock *clock)
 {
+	struct device *dev = clock->dev;
 	struct clk *clk = clock->core;
 
-	pm_runtime_disable(clock->dev);
+	pm_runtime_disable(dev);
+	pm_runtime_dont_use_autosuspend(dev);
 	ipa_interconnect_exit(clock);
 	kfree(clock);
 	clk_put(clk);
@@ -472,5 +472,4 @@ const struct dev_pm_ops ipa_pm_ops = {
 	.resume			= ipa_resume,
 	.runtime_suspend	= ipa_runtime_suspend,
 	.runtime_resume		= ipa_runtime_resume,
-	.runtime_idle		= ipa_runtime_idle,
 };
diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
index 3fecaadb4a37e..b35170a93b0fa 100644
--- a/drivers/net/ipa/ipa_interrupt.c
+++ b/drivers/net/ipa/ipa_interrupt.c
@@ -116,7 +116,8 @@ static irqreturn_t ipa_isr_thread(int irq, void *dev_id)
 		iowrite32(pending, ipa->reg_virt + offset);
 	}
 out_power_put:
-	(void)pm_runtime_put(dev);
+	pm_runtime_mark_last_busy(dev);
+	(void)pm_runtime_put_autosuspend(dev);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 3969aef6c4370..b4d7534045a1c 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -766,14 +766,15 @@ static int ipa_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_deconfig;
 done:
-	(void)pm_runtime_put(dev);
+	pm_runtime_mark_last_busy(dev);
+	(void)pm_runtime_put_autosuspend(dev);
 
 	return 0;
 
 err_deconfig:
 	ipa_deconfig(ipa);
 err_power_put:
-	(void)pm_runtime_put(dev);
+	pm_runtime_put_noidle(dev);
 	ipa_modem_exit(ipa);
 err_table_exit:
 	ipa_table_exit(ipa);
@@ -797,9 +798,10 @@ static int ipa_remove(struct platform_device *pdev)
 {
 	struct ipa *ipa = dev_get_drvdata(&pdev->dev);
 	struct ipa_clock *clock = ipa->clock;
+	struct device *dev = &pdev->dev;
 	int ret;
 
-	ret = pm_runtime_get_sync(&pdev->dev);
+	ret = pm_runtime_get_sync(dev);
 	if (WARN_ON(ret < 0))
 		goto out_power_put;
 
@@ -818,8 +820,7 @@ static int ipa_remove(struct platform_device *pdev)
 
 	ipa_deconfig(ipa);
 out_power_put:
-	(void)pm_runtime_put(&pdev->dev);
-
+	pm_runtime_put_noidle(dev);
 	ipa_modem_exit(ipa);
 	ipa_table_exit(ipa);
 	ipa_endpoint_exit(ipa);
diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
index 11f0204a96957..18b1f8d6d729a 100644
--- a/drivers/net/ipa/ipa_modem.c
+++ b/drivers/net/ipa/ipa_modem.c
@@ -67,14 +67,15 @@ static int ipa_open(struct net_device *netdev)
 
 	netif_start_queue(netdev);
 
-	(void)pm_runtime_put(dev);
+	pm_runtime_mark_last_busy(dev);
+	(void)pm_runtime_put_autosuspend(dev);
 
 	return 0;
 
 err_disable_tx:
 	ipa_endpoint_disable_one(ipa->name_map[IPA_ENDPOINT_AP_MODEM_TX]);
 err_power_put:
-	(void)pm_runtime_put(dev);
+	pm_runtime_put_noidle(dev);
 
 	return ret;
 }
@@ -97,7 +98,8 @@ static int ipa_stop(struct net_device *netdev)
 	ipa_endpoint_disable_one(ipa->name_map[IPA_ENDPOINT_AP_MODEM_RX]);
 	ipa_endpoint_disable_one(ipa->name_map[IPA_ENDPOINT_AP_MODEM_TX]);
 out_power_put:
-	(void)pm_runtime_put(dev);
+	pm_runtime_mark_last_busy(dev);
+	(void)pm_runtime_put_autosuspend(dev);
 
 	return 0;
 }
@@ -145,7 +147,7 @@ ipa_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 		 */
 		ipa_power_modem_queue_stop(ipa);
 
-		(void)pm_runtime_put(dev);
+		pm_runtime_put_noidle(dev);
 
 		return NETDEV_TX_BUSY;
 	}
@@ -154,7 +156,8 @@ ipa_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 	ret = ipa_endpoint_skb_tx(endpoint, skb);
 
-	(void)pm_runtime_put(dev);
+	pm_runtime_mark_last_busy(dev);
+	(void)pm_runtime_put_autosuspend(dev);
 
 	if (ret) {
 		if (ret != -E2BIG)
@@ -398,7 +401,8 @@ static void ipa_modem_crashed(struct ipa *ipa)
 		dev_err(dev, "error %d zeroing modem memory regions\n", ret);
 
 out_power_put:
-	(void)pm_runtime_put(dev);
+	pm_runtime_mark_last_busy(dev);
+	(void)pm_runtime_put_autosuspend(dev);
 }
 
 static int ipa_modem_notify(struct notifier_block *nb, unsigned long action,
diff --git a/drivers/net/ipa/ipa_smp2p.c b/drivers/net/ipa/ipa_smp2p.c
index f6e2061cd391c..7e1cef0fc67cb 100644
--- a/drivers/net/ipa/ipa_smp2p.c
+++ b/drivers/net/ipa/ipa_smp2p.c
@@ -174,7 +174,8 @@ static irqreturn_t ipa_smp2p_modem_setup_ready_isr(int irq, void *dev_id)
 	WARN(ret != 0, "error %d from ipa_setup()\n", ret);
 
 out_power_put:
-	(void)pm_runtime_put(dev);
+	pm_runtime_mark_last_busy(dev);
+	(void)pm_runtime_put_autosuspend(dev);
 out_mutex_unlock:
 	mutex_unlock(&smp2p->mutex);
 
@@ -211,10 +212,13 @@ static void ipa_smp2p_irq_exit(struct ipa_smp2p *smp2p, u32 irq)
 /* Drop the clock reference if it was taken in ipa_smp2p_notify() */
 static void ipa_smp2p_clock_release(struct ipa *ipa)
 {
+	struct device *dev = &ipa->pdev->dev;
+
 	if (!ipa->smp2p->clock_on)
 		return;
 
-	(void)pm_runtime_put(&ipa->pdev->dev);
+	pm_runtime_mark_last_busy(dev);
+	(void)pm_runtime_put_autosuspend(dev);
 	ipa->smp2p->clock_on = false;
 }
 
diff --git a/drivers/net/ipa/ipa_uc.c b/drivers/net/ipa/ipa_uc.c
index a0bdd25b65b4f..de04385270195 100644
--- a/drivers/net/ipa/ipa_uc.c
+++ b/drivers/net/ipa/ipa_uc.c
@@ -154,7 +154,8 @@ static void ipa_uc_response_hdlr(struct ipa *ipa, enum ipa_irq_id irq_id)
 	case IPA_UC_RESPONSE_INIT_COMPLETED:
 		if (ipa->uc_clocked) {
 			ipa->uc_loaded = true;
-			(void)pm_runtime_put(dev);
+			pm_runtime_mark_last_busy(dev);
+			(void)pm_runtime_put_autosuspend(dev);
 			ipa->uc_clocked = false;
 		} else {
 			dev_warn(dev, "unexpected init_completed response\n");
@@ -179,10 +180,15 @@ void ipa_uc_config(struct ipa *ipa)
 /* Inverse of ipa_uc_config() */
 void ipa_uc_deconfig(struct ipa *ipa)
 {
+	struct device *dev = &ipa->pdev->dev;
+
 	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_UC_1);
 	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_UC_0);
-	if (ipa->uc_clocked)
-		(void)pm_runtime_put(&ipa->pdev->dev);
+	if (!ipa->uc_clocked)
+		return;
+
+	pm_runtime_mark_last_busy(dev);
+	(void)pm_runtime_put_autosuspend(dev);
 }
 
 /* Take a proxy clock reference for the microcontroller */
-- 
2.27.0

