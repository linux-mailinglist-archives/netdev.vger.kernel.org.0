Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41CBB3D67ED
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 22:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbhGZTbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 15:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232888AbhGZTbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 15:31:16 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8363BC061757
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 13:11:44 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id r1so10152618iln.6
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 13:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GDDMRio70MsWS94GuAHc1YhRqb1pVovQbxMWDHgB+9E=;
        b=jQ80CojneeeAhv1iHm/DGQgnPPBEYcpjRGJYTRw86tTeGSm0XUbSyEQioJ1Hz3BP4r
         iJbF+Mevyio3G2rqkAkahbYOs9UCV2CHRYutVc5sJTD5SNsxp2RylmrPdi/2t19wAX6e
         snpqxYpc8RXTaZyqfvWQzbAtC1me90h7GaZOQ2KWsJ3vGHOWTnbl00w+PZLKQ2X8ElCb
         Nf5YLXQkl76f+zkLTgN9WhzFVkc+4+3mfp5XKrRIEam8/YHiYbnZWrQH5EUrYU7IDu6u
         MkDufVf8u5qNelZCDk8KGarKmozzj+ZCO3GcW9anZS643gG9yqtFwA3sNltnVd+65i+X
         HsVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GDDMRio70MsWS94GuAHc1YhRqb1pVovQbxMWDHgB+9E=;
        b=JlR/34t2gsCyrPpJaznOMPOom6R/9daNOyHFWiQpX/2mMmLXevS0GhLiIKdV4ZoXhF
         f4aOxJ3O5d8QD4vRQt0J/eZxAPawRABHp1lRW1z/aLRfK6CUJ5rzqJSOmjUl8VCD9Cfl
         1vHGDjHNiBftvsrCZ7+jAXj4unAQesTAraF4aIB15c1jiytvXR6JduHwE7lcEQE86SEz
         6hfmV7jN7oeUhpdXEWZuUGQ7HA4pi3hfV6+/3W2h+jinA8LqeWqtlSvI0139oIpbFwGJ
         Ksuyh1jaRDTUFVBtvsMR0Uze3jDf2bSirmWlpT/766csr33eOhX6W7mrpiGuiIEVpYkw
         wFLw==
X-Gm-Message-State: AOAM5311Es73VBQd1wFl1KJQ/Z3br6k5l/0x7xWtqApKxhG2jIQOWAcU
        RtTpRCrYA+AnlB5oWZ02GDc/RA==
X-Google-Smtp-Source: ABdhPJzfICrcVZHnfQ4E1mW2w3SWjkCphdNqVsV2Q/x1oNFMtGitDXuOYofjkeGjAcGhSTgeeDfTHw==
X-Received: by 2002:a05:6e02:12e3:: with SMTP id l3mr9924095iln.6.1627330303948;
        Mon, 26 Jul 2021 13:11:43 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id z10sm425964iln.8.2021.07.26.13.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 13:11:43 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/5] net: ipa: introduce ipa_uc_clock()
Date:   Mon, 26 Jul 2021 15:11:36 -0500
Message-Id: <20210726201136.502800-6-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210726201136.502800-1-elder@linaro.org>
References: <20210726201136.502800-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first time it's booted, the modem loads and starts the
IPA-resident microcontroller.  Once the microcontroller has
completed its initialization, it notifies the AP it's "ready"
by sending an INIT_COMPLETED response message.

Until it receives that microcontroller message, the AP must ensure
the IPA core clock remains operational.  Currently, a "proxy" clock
reference is taken in ipa_uc_config(), dropping it again once the
message is received.

However there could be a long delay between when ipa_config()
completes and when modem actually starts.  And because the
microcontroller gets loaded by the modem, there's no need to
get the modem "proxy clock" until the first time it starts.

Create a new function ipa_uc_clock() which takes the "proxy" clock
reference for the microcontroller.  Call it when we get remoteproc
SSR notification that the modem is about to start.  Keep an
additional flag to record whether this proxy clock reference needs
to be dropped at shutdown time, and issue a warning if we get the
microcontroller message either before the clock reference is taken,
or after it has already been dropped.

Drop the nearby use of "hh" length modifiers, which are no longer
encouraged in the kernel.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa.h       |  2 ++
 drivers/net/ipa/ipa_modem.c |  2 ++
 drivers/net/ipa/ipa_uc.c    | 44 +++++++++++++++++++++++--------------
 drivers/net/ipa/ipa_uc.h    | 14 ++++++++++++
 4 files changed, 45 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ipa/ipa.h b/drivers/net/ipa/ipa.h
index 744406832a774..71ba996096bb9 100644
--- a/drivers/net/ipa/ipa.h
+++ b/drivers/net/ipa/ipa.h
@@ -51,6 +51,7 @@ enum ipa_flag {
  * @table_addr:		DMA address of filter/route table content
  * @table_virt:		Virtual address of filter/route table content
  * @interrupt:		IPA Interrupt information
+ * @uc_clocked:		true if clock is active by proxy for microcontroller
  * @uc_loaded:		true after microcontroller has reported it's ready
  * @reg_addr:		DMA address used for IPA register access
  * @reg_virt:		Virtual address used for IPA register access
@@ -95,6 +96,7 @@ struct ipa {
 	__le64 *table_virt;
 
 	struct ipa_interrupt *interrupt;
+	bool uc_clocked;
 	bool uc_loaded;
 
 	dma_addr_t reg_addr;
diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
index 5cb60e2ea6042..c851e2cf12552 100644
--- a/drivers/net/ipa/ipa_modem.c
+++ b/drivers/net/ipa/ipa_modem.c
@@ -19,6 +19,7 @@
 #include "ipa_modem.h"
 #include "ipa_smp2p.h"
 #include "ipa_qmi.h"
+#include "ipa_uc.h"
 
 #define IPA_NETDEV_NAME		"rmnet_ipa%d"
 #define IPA_NETDEV_TAILROOM	0	/* for padding by mux layer */
@@ -314,6 +315,7 @@ static int ipa_modem_notify(struct notifier_block *nb, unsigned long action,
 	switch (action) {
 	case QCOM_SSR_BEFORE_POWERUP:
 		dev_info(dev, "received modem starting event\n");
+		ipa_uc_clock(ipa);
 		ipa_smp2p_notify_reset(ipa);
 		break;
 
diff --git a/drivers/net/ipa/ipa_uc.c b/drivers/net/ipa/ipa_uc.c
index 8b5e75711b644..f88ee02457d49 100644
--- a/drivers/net/ipa/ipa_uc.c
+++ b/drivers/net/ipa/ipa_uc.c
@@ -131,7 +131,7 @@ static void ipa_uc_event_handler(struct ipa *ipa, enum ipa_irq_id irq_id)
 	if (shared->event == IPA_UC_EVENT_ERROR)
 		dev_err(dev, "microcontroller error event\n");
 	else if (shared->event != IPA_UC_EVENT_LOG_INFO)
-		dev_err(dev, "unsupported microcontroller event %hhu\n",
+		dev_err(dev, "unsupported microcontroller event %u\n",
 			shared->event);
 	/* The LOG_INFO event can be safely ignored */
 }
@@ -140,23 +140,28 @@ static void ipa_uc_event_handler(struct ipa *ipa, enum ipa_irq_id irq_id)
 static void ipa_uc_response_hdlr(struct ipa *ipa, enum ipa_irq_id irq_id)
 {
 	struct ipa_uc_mem_area *shared = ipa_uc_shared(ipa);
+	struct device *dev = &ipa->pdev->dev;
 
 	/* An INIT_COMPLETED response message is sent to the AP by the
 	 * microcontroller when it is operational.  Other than this, the AP
 	 * should only receive responses from the microcontroller when it has
 	 * sent it a request message.
 	 *
-	 * We can drop the clock reference taken in ipa_uc_setup() once we
+	 * We can drop the clock reference taken in ipa_uc_clock() once we
 	 * know the microcontroller has finished its initialization.
 	 */
 	switch (shared->response) {
 	case IPA_UC_RESPONSE_INIT_COMPLETED:
-		ipa->uc_loaded = true;
-		ipa_clock_put(ipa);
+		if (ipa->uc_clocked) {
+			ipa->uc_loaded = true;
+			ipa_clock_put(ipa);
+			ipa->uc_clocked = false;
+		} else {
+			dev_warn(dev, "unexpected init_completed response\n");
+		}
 		break;
 	default:
-		dev_warn(&ipa->pdev->dev,
-			 "unsupported microcontroller response %hhu\n",
+		dev_warn(dev, "unsupported microcontroller response %u\n",
 			 shared->response);
 		break;
 	}
@@ -165,16 +170,7 @@ static void ipa_uc_response_hdlr(struct ipa *ipa, enum ipa_irq_id irq_id)
 /* Configure the IPA microcontroller subsystem */
 void ipa_uc_config(struct ipa *ipa)
 {
-	/* The microcontroller needs the IPA clock running until it has
-	 * completed its initialization.  It signals this by sending an
-	 * INIT_COMPLETED response message to the AP.  This could occur after
-	 * we have finished doing the rest of the IPA initialization, so we
-	 * need to take an extra "proxy" reference, and hold it until we've
-	 * received that signal.  (This reference is dropped in
-	 * ipa_uc_response_hdlr(), above.)
-	 */
-	ipa_clock_get(ipa);
-
+	ipa->uc_clocked = false;
 	ipa->uc_loaded = false;
 	ipa_interrupt_add(ipa->interrupt, IPA_IRQ_UC_0, ipa_uc_event_handler);
 	ipa_interrupt_add(ipa->interrupt, IPA_IRQ_UC_1, ipa_uc_response_hdlr);
@@ -185,10 +181,24 @@ void ipa_uc_deconfig(struct ipa *ipa)
 {
 	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_UC_1);
 	ipa_interrupt_remove(ipa->interrupt, IPA_IRQ_UC_0);
-	if (!ipa->uc_loaded)
+	if (ipa->uc_clocked)
 		ipa_clock_put(ipa);
 }
 
+/* Take a proxy clock reference for the microcontroller */
+void ipa_uc_clock(struct ipa *ipa)
+{
+	static bool already;
+
+	if (already)
+		return;
+	already = true;		/* Only do this on first boot */
+
+	/* This clock reference dropped in ipa_uc_response_hdlr() above */
+	ipa_clock_get(ipa);
+	ipa->uc_clocked = true;
+}
+
 /* Send a command to the microcontroller */
 static void send_uc_command(struct ipa *ipa, u32 command, u32 command_param)
 {
diff --git a/drivers/net/ipa/ipa_uc.h b/drivers/net/ipa/ipa_uc.h
index cb0a224022f58..14e4e1115aa79 100644
--- a/drivers/net/ipa/ipa_uc.h
+++ b/drivers/net/ipa/ipa_uc.h
@@ -20,6 +20,20 @@ void ipa_uc_config(struct ipa *ipa);
  */
 void ipa_uc_deconfig(struct ipa *ipa);
 
+/**
+ * ipa_uc_clock() - Take a proxy clock reference for the microcontroller
+ * @ipa:	IPA pointer
+ *
+ * The first time the modem boots, it loads firmware for and starts the
+ * IPA-resident microcontroller.  The microcontroller signals that it
+ * has completed its initialization by sending an INIT_COMPLETED response
+ * message to the AP.  The AP must ensure the IPA core clock is operating
+ * until it receives this message, and to do so we take a "proxy" clock
+ * reference on its behalf here.  Once we receive the INIT_COMPLETED
+ * message (in ipa_uc_response_hdlr()) we drop this clock reference.
+ */
+void ipa_uc_clock(struct ipa *ipa);
+
 /**
  * ipa_uc_panic_notifier()
  * @ipa:	IPA pointer
-- 
2.27.0

