Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 298DF3EAB55
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 21:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236641AbhHLTvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 15:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236053AbhHLTvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 15:51:08 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D5D1C0617A8
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 12:50:42 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id s184so10076768ios.2
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 12:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=64xPgsftRVJbwugHrzB1UvjPqduhCUZZEB/J6cFDx2k=;
        b=eXzgkABuTmzTk1yRQI2m382W8/rUC3gAINQz39akmYF6UzQyXUOLKk2Ss59hTyEcz0
         eO1FGq5+C0LWlgOkXsiyXNfXu2f8Bb9pyUjPEWW/zoQ4MrGR6eDo/hNz254HNh46M6DW
         1wM61mU+CDkotkqhXFPYyipwaZ9WrkjQ36pz3JdTHjrwo4LD6QfdMgs3I+TEGi6oHd9h
         CIEUFguydH1jEMEvVnzd6qbTE23m1X5sg17hYY9Gs4flbBAbNC8jjWxjsTZuewicL7z3
         pjj5FPfrPMthcNdpHBcsAjyZq5Q5+WkgaWW8xJ/IMIYhzymPjdCc63XXs3UnWb2crd0E
         /f2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=64xPgsftRVJbwugHrzB1UvjPqduhCUZZEB/J6cFDx2k=;
        b=mFhcK8vNw6MpvF14ajruHDY5n7d49sy0U4O6kZ23OvWhpeSLmtxnUJ8C0pb9Y2eCHj
         9gWqVmkjxPvcwi2LB/ktRy87EgfRd8HdnO9CG4wDrrWbKsMoaEoR7lUozeeXtHw9WbRD
         jX+onrDlL8rhUE0os6zozlwcqS1y8aWcRp0chnzuSD4grpF+8jvI255s5/arlQdep3E6
         +s6r2YtuCyaxXOjIBeRXw6eQskXtQJErfhTADnc+4d6726rzPxcslkpKFkvLAIPvWUMt
         bruA3QAyptyGVbiyW/DdX8neR1tUG2ahaCk7FmopP6ZScRM+OQXxEbg5ilO8Xb8yyZz9
         VPLw==
X-Gm-Message-State: AOAM532xFV3g9N6grC942SLzilItwNCAc4P6h7l2AxuNpgYpI9cqnJMV
        eoeLWm0StXsyo5Woavaad94+Yg==
X-Google-Smtp-Source: ABdhPJxTF/07x0z/K2dmFbII8lo1G5DJVSsKCuBKMCR3Czt6OqUYOH6T7W2j2mYZOg2Fdr029kVTrA==
X-Received: by 2002:a5e:d91a:: with SMTP id n26mr4169992iop.96.1628797841987;
        Thu, 12 Aug 2021 12:50:41 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id s16sm2058821iln.5.2021.08.12.12.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 12:50:41 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/6] net: ipa: ensure hardware has power in ipa_start_xmit()
Date:   Thu, 12 Aug 2021 14:50:33 -0500
Message-Id: <20210812195035.2816276-5-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210812195035.2816276-1-elder@linaro.org>
References: <20210812195035.2816276-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to ensure the hardware is powered when we transmit a packet.
But if it's not, we can't block to wait for it.  So asynchronously
request power in ipa_start_xmit(), and only proceed if the return
value indicates the power state is active.

If the hardware is not active, a runtime resume request will have
been initiated.  In that case, stop the network stack from further
transmit attempts until the resume completes.  Return NETDEV_TX_BUSY,
to retry sending the packet once the queue is restarted.

If the power request returns an error (other than -EINPROGRESS,
which just means a resume requested elsewhere isn't complete), just
drop the packet.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_modem.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
index 0a3b034614b61..aa1b483d9f7db 100644
--- a/drivers/net/ipa/ipa_modem.c
+++ b/drivers/net/ipa/ipa_modem.c
@@ -106,6 +106,7 @@ static int ipa_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 	struct ipa_endpoint *endpoint;
 	struct ipa *ipa = priv->ipa;
 	u32 skb_len = skb->len;
+	struct device *dev;
 	int ret;
 
 	if (!skb_len)
@@ -115,7 +116,31 @@ static int ipa_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 	if (endpoint->data->qmap && skb->protocol != htons(ETH_P_MAP))
 		goto err_drop_skb;
 
+	/* The hardware must be powered for us to transmit */
+	dev = &ipa->pdev->dev;
+	ret = pm_runtime_get(dev);
+	if (ret < 1) {
+		/* If a resume won't happen, just drop the packet */
+		if (ret < 0 && ret != -EINPROGRESS) {
+			pm_runtime_put_noidle(dev);
+			goto err_drop_skb;
+		}
+
+		/* No power (yet).  Stop the network stack from transmitting
+		 * until we're resumed; ipa_modem_resume() arranges for the
+		 * TX queue to be started again.
+		 */
+		netif_stop_queue(netdev);
+
+		(void)pm_runtime_put(dev);
+
+		return NETDEV_TX_BUSY;
+	}
+
 	ret = ipa_endpoint_skb_tx(endpoint, skb);
+
+	(void)pm_runtime_put(dev);
+
 	if (ret) {
 		if (ret != -E2BIG)
 			return NETDEV_TX_BUSY;
@@ -201,7 +226,10 @@ void ipa_modem_suspend(struct net_device *netdev)
  *
  * Re-enable transmit on the modem network device.  This is called
  * in (power management) work queue context, scheduled when resuming
- * the modem.
+ * the modem.  We can't enable the queue directly in ipa_modem_resume()
+ * because transmits restart the instant the queue is awakened; but the
+ * device power state won't be ACTIVE until *after* ipa_modem_resume()
+ * returns.
  */
 static void ipa_modem_wake_queue_work(struct work_struct *work)
 {
-- 
2.27.0

