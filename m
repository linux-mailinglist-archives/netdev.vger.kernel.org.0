Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96D03D67E9
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 22:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbhGZTbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 15:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232486AbhGZTbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 15:31:12 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E0CC061760
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 13:11:41 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id z3so10133012ile.12
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 13:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tgL3Uie/Qodtk8KimI/KjJUNL3yMSDvJaxriDsuLyK0=;
        b=cQF7DY0oNsgCjN5SXuOfOtTqGXx/ZwRX3G7x0ovIpW16FEMLLNWJRfWv/4qO4IVTBn
         U0ERKBCaBBN6ddwSJm+U1CqH+eq/IgjAKFH8ji0L9LSisD26l0CfYxEUNeBW7CKdqNxU
         Ssxd+Jw6wtZcudul6K35cOkw6RAZW6YwNgGDulFHaREEJBqoNshfIUMFPcbfaKhkPT4Q
         gNB1cQ3HhJABXAkvnKHws3o9PObrgGdcrbRYvVSwACjh5yu0iyhB9p8GdXkGo3ieD2AR
         TTpBGbEO2B6r/ojJOeZLpoOBikue/d2h/PVzISjSAYXlVfAOj+6uTa7a6s5bF8Uh80/W
         PRhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tgL3Uie/Qodtk8KimI/KjJUNL3yMSDvJaxriDsuLyK0=;
        b=YojzWEvQCzozqZDg61MALbc+6HSqve6NMD2zl/qJllP8khawoOTRTg+FObpHZECsEW
         MpCOaJU6StB0EI9r2y+CEChyF/isWjZS8xYEdOqZnviLkKnyiIQg024TY6Pp+X2g64J2
         E8qoYAO3ckkrkhlZvKuSwwsxsNJBb8M+TyT70R7qPHLJ9hcM2AT2ivtka10jFHThugrg
         rJnsy7MmkWMbUxWh6Y5L/DKCh6W0h1QI0bTqsb4MzJXaKGGMTElV/EXN4CQCAPX/ohWe
         GJc+b6eDHGdOuc2IFU00gPjuBpsi/atvCS7SegCG4ylJR7JV6vuhyHMsQLw8zlkNdzdv
         5QzA==
X-Gm-Message-State: AOAM533hoBBcseW9s3Fonk8Ok8kJAUxeIgOq+CY51ny8FRtPaBLkbrzK
        FIYgaAzU+J4BFAv+ijYNzvZJcw==
X-Google-Smtp-Source: ABdhPJyUsUg2PRSMaLEEojFEJUGSSLr9dZlv7A5mU7BduZlA6SdIsepLrF8AQH51HQLdEGBUhIFQQw==
X-Received: by 2002:a05:6e02:5ad:: with SMTP id k13mr14042115ils.284.1627330300432;
        Mon, 26 Jul 2021 13:11:40 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id z10sm425964iln.8.2021.07.26.13.11.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 13:11:40 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/5] net: ipa: kill ipa_modem_setup()
Date:   Mon, 26 Jul 2021 15:11:32 -0500
Message-Id: <20210726201136.502800-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210726201136.502800-1-elder@linaro.org>
References: <20210726201136.502800-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The functions ipa_modem_setup() and ipa_modem_teardown() are trivial
wrappers that call ipa_qmi_setup() and ipa_qmi_teardown().  Just
call the QMI functions directly, and get rid of the wrappers.

Improve the documentation of what setting up QMI does.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_main.c  |  4 ++--
 drivers/net/ipa/ipa_modem.c | 10 ----------
 drivers/net/ipa/ipa_modem.h |  4 ----
 drivers/net/ipa/ipa_qmi.c   |  6 ++----
 drivers/net/ipa/ipa_qmi.h   | 19 +++++++++++++++++++
 5 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 9810c61a03202..91e2ec3a0c133 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -167,7 +167,7 @@ int ipa_setup(struct ipa *ipa)
 	ipa_endpoint_default_route_set(ipa, exception_endpoint->endpoint_id);
 
 	/* We're all set.  Now prepare for communication with the modem */
-	ret = ipa_modem_setup(ipa);
+	ret = ipa_qmi_setup(ipa);
 	if (ret)
 		goto err_default_route_clear;
 
@@ -204,7 +204,7 @@ static void ipa_teardown(struct ipa *ipa)
 	struct ipa_endpoint *exception_endpoint;
 	struct ipa_endpoint *command_endpoint;
 
-	ipa_modem_teardown(ipa);
+	ipa_qmi_teardown(ipa);
 	ipa_endpoint_default_route_clear(ipa);
 	exception_endpoint = ipa->name_map[IPA_ENDPOINT_AP_LAN_RX];
 	ipa_endpoint_disable_one(exception_endpoint);
diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
index af9aedbde717a..5cb60e2ea6042 100644
--- a/drivers/net/ipa/ipa_modem.c
+++ b/drivers/net/ipa/ipa_modem.c
@@ -377,13 +377,3 @@ void ipa_modem_deconfig(struct ipa *ipa)
 	ipa->notifier = NULL;
 	memset(&ipa->nb, 0, sizeof(ipa->nb));
 }
-
-int ipa_modem_setup(struct ipa *ipa)
-{
-	return ipa_qmi_setup(ipa);
-}
-
-void ipa_modem_teardown(struct ipa *ipa)
-{
-	ipa_qmi_teardown(ipa);
-}
diff --git a/drivers/net/ipa/ipa_modem.h b/drivers/net/ipa/ipa_modem.h
index 2de3e216d1d43..5e6e3d234454a 100644
--- a/drivers/net/ipa/ipa_modem.h
+++ b/drivers/net/ipa/ipa_modem.h
@@ -7,7 +7,6 @@
 #define _IPA_MODEM_H_
 
 struct ipa;
-struct ipa_endpoint;
 struct net_device;
 struct sk_buff;
 
@@ -25,7 +24,4 @@ void ipa_modem_exit(struct ipa *ipa);
 int ipa_modem_config(struct ipa *ipa);
 void ipa_modem_deconfig(struct ipa *ipa);
 
-int ipa_modem_setup(struct ipa *ipa);
-void ipa_modem_teardown(struct ipa *ipa);
-
 #endif /* _IPA_MODEM_H_ */
diff --git a/drivers/net/ipa/ipa_qmi.c b/drivers/net/ipa/ipa_qmi.c
index 4661105ce7ab2..90f3aec55b365 100644
--- a/drivers/net/ipa/ipa_qmi.c
+++ b/drivers/net/ipa/ipa_qmi.c
@@ -467,10 +467,7 @@ static const struct qmi_ops ipa_client_ops = {
 	.new_server	= ipa_client_new_server,
 };
 
-/* This is called by ipa_setup().  We can be informed via remoteproc that
- * the modem has shut down, in which case this function will be called
- * again to prepare for it coming back up again.
- */
+/* Set up for QMI message exchange */
 int ipa_qmi_setup(struct ipa *ipa)
 {
 	struct ipa_qmi *ipa_qmi = &ipa->qmi;
@@ -526,6 +523,7 @@ int ipa_qmi_setup(struct ipa *ipa)
 	return ret;
 }
 
+/* Tear down IPA QMI handles */
 void ipa_qmi_teardown(struct ipa *ipa)
 {
 	cancel_work_sync(&ipa->qmi.init_driver_work);
diff --git a/drivers/net/ipa/ipa_qmi.h b/drivers/net/ipa/ipa_qmi.h
index b6f2055d35a68..856ef629ccc8d 100644
--- a/drivers/net/ipa/ipa_qmi.h
+++ b/drivers/net/ipa/ipa_qmi.h
@@ -39,7 +39,26 @@ struct ipa_qmi {
 	bool indication_sent;
 };
 
+/**
+ * ipa_qmi_setup() - Set up for QMI message exchange
+ * @ipa:		IPA pointer
+ *
+ * This is called at the end of ipa_setup(), to prepare for the exchange
+ * of QMI messages that perform a "handshake" between the AP and modem.
+ * When the modem QMI server announces its presence, an AP request message
+ * supplies operating parameters to be used to the modem, and the modem
+ * acknowledges receipt of those parameters.  The modem will not touch the
+ * IPA hardware until this handshake is complete.
+ *
+ * If the modem crashes (or shuts down) a new handshake begins when the
+ * modem's QMI server is started again.
+ */
 int ipa_qmi_setup(struct ipa *ipa);
+
+/**
+ * ipa_qmi_teardown() - Tear down IPA QMI handles
+ * @ipa:		IPA pointer
+ */
 void ipa_qmi_teardown(struct ipa *ipa);
 
 #endif /* !_IPA_QMI_H_ */
-- 
2.27.0

