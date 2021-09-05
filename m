Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD054011A8
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 23:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233779AbhIEVFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 17:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbhIEVFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 17:05:06 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47879C061575
        for <netdev@vger.kernel.org>; Sun,  5 Sep 2021 14:04:03 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id j1so3040484pjv.3
        for <netdev@vger.kernel.org>; Sun, 05 Sep 2021 14:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8sNKEVJBC2v8g4oUEvMr7hiCcGK5pocfEGEp7QE+uNk=;
        b=Y6VghV8fTqkS26PwLmH4McynWrZ7OTKq1bFj+o2Gg+h+pCcPNKQStZG/FmplOZT7EM
         KmeiWMC8frtkq70DuXlsWa+UN9obBBowNDE1ndPirTCixslhbBQ9SBOSHS3iupWoxPAh
         lK+T9KrcKHjUXVcLEyB7VUk2qMOOqo3pnNB9I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8sNKEVJBC2v8g4oUEvMr7hiCcGK5pocfEGEp7QE+uNk=;
        b=JKyYsT5Kk9RDZtBPWnkDXbdjvBK4dc50pYc//IP6N4vKZzR2mwFOum06ivp8G6Jgf3
         yroamFB+jrpna21h6FtATvnxV3LZih5Njokg9ObjPw6OVl6n4+eBs7x9dqPqDn3q+LJX
         BZi1o6OMEjIGt/Mfvc3ISPhCPocDSMsrRVzIruICAVchwNlfqFjJUta1zm2YF0sNhbx1
         YEzYmrcaLvP75TJuKauABsPic9Wx2Q2f4hlfOxiH8f4m1qxuOjdExO3Jc74l7eKhQ1O2
         bYYG7OPojhaDQfa58qoFvn4Xzh5CkDZxBWwPfWLrdiyjt+52WzdY31tCuA+5HCuwFC1U
         t4bA==
X-Gm-Message-State: AOAM531aQ3/1XHHFovAlZt4NayCJkDGl2quV7iJlLD3OOdJ1ePeG+dH5
        SdHYZ1fm5PYrrkugmeUcHFqc9g==
X-Google-Smtp-Source: ABdhPJwup5WpYvzf3TPglhjUyzySn9YGNiVmr7+eq7fdfkNhRwCRNXx4lIdbfKBgFJ86itinGYaAaw==
X-Received: by 2002:a17:90a:a092:: with SMTP id r18mr10298978pjp.175.1630875842717;
        Sun, 05 Sep 2021 14:04:02 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:5077:c47b:f2dc:d63b])
        by smtp.gmail.com with ESMTPSA id n9sm5243109pfu.152.2021.09.05.14.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 14:04:02 -0700 (PDT)
From:   Stephen Boyd <swboyd@chromium.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-kernel@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, Govind Singh <govinds@codeaurora.org>,
        Youghandhar Chintala <youghand@codeaurora.org>,
        Abhishek Kumar <kuabhs@chromium.org>
Subject: [PATCH] ath10k: Don't always treat modem stop events as crashes
Date:   Sun,  5 Sep 2021 14:04:00 -0700
Message-Id: <20210905210400.1157870-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When rebooting on sc7180 Trogdor devices I see the following crash from
the wifi driver.

 ath10k_snoc 18800000.wifi: firmware crashed! (guid 83493570-29a2-4e98-a83e-70048c47669c)

This is because a modem stop event looks just like a firmware crash to
the driver, the qmi connection is closed in both cases. Use the qcom ssr
notifier block to stop treating the qmi connection close event as a
firmware crash signal when the modem hasn't actually crashed. See
ath10k_qmi_event_server_exit() for more details.

This silences the crash message seen during every reboot.

Fixes: 3f14b73c3843 ("ath10k: Enable MSA region dump support for WCN3990")
Cc: Govind Singh <govinds@codeaurora.org>
Cc: Youghandhar Chintala <youghand@codeaurora.org>
Cc: Abhishek Kumar <kuabhs@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 75 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/snoc.h |  4 ++
 2 files changed, 79 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index ea00fbb15601..fc4970e063f8 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -12,6 +12,7 @@
 #include <linux/platform_device.h>
 #include <linux/property.h>
 #include <linux/regulator/consumer.h>
+#include <linux/remoteproc/qcom_rproc.h>
 #include <linux/of_address.h>
 #include <linux/iommu.h>
 
@@ -1477,6 +1478,70 @@ void ath10k_snoc_fw_crashed_dump(struct ath10k *ar)
 	mutex_unlock(&ar->dump_mutex);
 }
 
+static int ath10k_snoc_modem_notify(struct notifier_block *nb, unsigned long action,
+				    void *data)
+{
+	struct ath10k_snoc *ar_snoc = container_of(nb, struct ath10k_snoc, nb);
+	struct ath10k *ar = ar_snoc->ar;
+	struct qcom_ssr_notify_data *notify_data = data;
+
+	switch (action) {
+	case QCOM_SSR_BEFORE_POWERUP:
+		ath10k_dbg(ar, ATH10K_DBG_SNOC, "received modem starting event\n");
+		clear_bit(ATH10K_SNOC_FLAG_UNREGISTERING, &ar_snoc->flags);
+		break;
+
+	case QCOM_SSR_AFTER_POWERUP:
+		ath10k_dbg(ar, ATH10K_DBG_SNOC, "received modem running event\n");
+		break;
+
+	case QCOM_SSR_BEFORE_SHUTDOWN:
+		ath10k_dbg(ar, ATH10K_DBG_SNOC, "received modem %s event\n",
+			   notify_data->crashed ? "crashed" : "stopping");
+		if (!notify_data->crashed)
+			set_bit(ATH10K_SNOC_FLAG_UNREGISTERING, &ar_snoc->flags);
+		else
+			clear_bit(ATH10K_SNOC_FLAG_UNREGISTERING, &ar_snoc->flags);
+		break;
+
+	case QCOM_SSR_AFTER_SHUTDOWN:
+		ath10k_dbg(ar, ATH10K_DBG_SNOC, "received modem offline event\n");
+		break;
+
+	default:
+		ath10k_err(ar, "received unrecognized event %lu\n", action);
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static int ath10k_modem_init(struct ath10k *ar)
+{
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
+	void *notifier;
+
+	ar_snoc->nb.notifier_call = ath10k_snoc_modem_notify;
+
+	notifier = qcom_register_ssr_notifier("mpss", &ar_snoc->nb);
+	if (IS_ERR(notifier))
+		return PTR_ERR(notifier);
+
+	ar_snoc->notifier = notifier;
+
+	return 0;
+}
+
+static void ath10k_modem_deinit(struct ath10k *ar)
+{
+	int ret;
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
+
+	ret = qcom_unregister_ssr_notifier(ar_snoc->notifier, &ar_snoc->nb);
+	if (ret)
+		ath10k_err(ar, "error %d unregistering notifier\n", ret);
+}
+
 static int ath10k_setup_msa_resources(struct ath10k *ar, u32 msa_size)
 {
 	struct device *dev = ar->dev;
@@ -1740,10 +1805,19 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
 		goto err_fw_deinit;
 	}
 
+	ret = ath10k_modem_init(ar);
+	if (ret) {
+		ath10k_err(ar, "failed to initialize modem notifier: %d\n", ret);
+		goto err_qmi_deinit;
+	}
+
 	ath10k_dbg(ar, ATH10K_DBG_SNOC, "snoc probe\n");
 
 	return 0;
 
+err_qmi_deinit:
+	ath10k_qmi_deinit(ar);
+
 err_fw_deinit:
 	ath10k_fw_deinit(ar);
 
@@ -1771,6 +1845,7 @@ static int ath10k_snoc_free_resources(struct ath10k *ar)
 	ath10k_fw_deinit(ar);
 	ath10k_snoc_free_irq(ar);
 	ath10k_snoc_release_resource(ar);
+	ath10k_modem_deinit(ar);
 	ath10k_qmi_deinit(ar);
 	ath10k_core_destroy(ar);
 
diff --git a/drivers/net/wireless/ath/ath10k/snoc.h b/drivers/net/wireless/ath/ath10k/snoc.h
index 5095d1893681..d986edc772f8 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.h
+++ b/drivers/net/wireless/ath/ath10k/snoc.h
@@ -6,6 +6,8 @@
 #ifndef _SNOC_H_
 #define _SNOC_H_
 
+#include <linux/notifier.h>
+
 #include "hw.h"
 #include "ce.h"
 #include "qmi.h"
@@ -75,6 +77,8 @@ struct ath10k_snoc {
 	struct clk_bulk_data *clks;
 	size_t num_clks;
 	struct ath10k_qmi *qmi;
+	struct notifier_block nb;
+	void *notifier;
 	unsigned long flags;
 	bool xo_cal_supported;
 	u32 xo_cal_data;

base-commit: 7d2a07b769330c34b4deabeed939325c77a7ec2f
-- 
https://chromeos.dev

