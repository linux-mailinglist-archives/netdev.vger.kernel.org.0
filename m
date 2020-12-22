Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C39802E08C8
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 11:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgLVK2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 05:28:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgLVK2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 05:28:03 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F43C0611CD
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 02:26:53 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id a11so10302187qto.16
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 02:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=t0QDGZ4RnAJnUWRRyU9abg4X7726TpGoTxSFt9qp7yo=;
        b=YT/9mQ5YjEMDnb9Q+WAthF6nlaOM6O7CobFCJKlj8kn2HI0eogsYslcIwvQXj/neqX
         RT3i3ygz6SCICco7fb4PYeeQCeOrtWFL1Jvs3jCKzMV3hWYvfoMahhsi9aUduII03oKC
         Vq7ZbrdTZ6SWwyQ/jDbIpqto5ngTwV9McvNeJ0YS4SQP+DS8kh/47JvJtQkdeNqInd0R
         FalCgD5Pot76Whgfxw821OKBrGi0ln2dTPG1NcV1m286jPP1Tg0YapNX9ieBvyoyQfcB
         saheMcqYLfUY9Qve76XWnTtcG9Bv5RZcY8+hx6CHfggzMlpKd8yxXLk6zZRXk3+IiEYR
         9iLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=t0QDGZ4RnAJnUWRRyU9abg4X7726TpGoTxSFt9qp7yo=;
        b=ci/Nnge8quVWr08ZmwGF3RB/96rlbZKDlfvvDXeTO1k+g5Ano3jsUHm63WRyEUeFy3
         6/2vKRB1SxRwYK8MWFC9rB+dyxCQqnSYkuiIVMPvQQx9H2Pj8ForS+MQJdaRgX5zoV2o
         sMKxexnTd8k92uo2OOqQSgAv2EmMK8uQqHMDvaYbF9iH6ffcTRIqPr7ZfYwUNlGNhbeB
         JO1FR/UiNM9/bM6IiZgkvriNkWxf0TONq/mXyeKMXMv/b8yaolhyD5S2nTXYwhCCUbDp
         pBhDq6PSbR8YpicqFRia5XvHBl24bFBKeb/Sy6gWxAHwNI9tw1onQRJTouXiJe3mlmJb
         8nRQ==
X-Gm-Message-State: AOAM531sKOGvRBpsd7OO2CZmT+iJZWaKrrYkfKIpPsmcUxyP/5q94kkx
        Li+srcA896aL+/LmMMoC3njzMC5Q82Us
X-Google-Smtp-Source: ABdhPJzzYkMdd7AUThnj4tDQ1lbcQ+Y+lkJuhAPBlmf5AEuA4txxKpb/3eAxTsTaB5Rq6URMSo2Ct48iX/ly
Sender: "apusaka via sendgmr" <apusaka@apusaka-p920.tpe.corp.google.com>
X-Received: from apusaka-p920.tpe.corp.google.com ([172.30.210.44])
 (user=apusaka job=sendgmr) by 2002:a0c:dc13:: with SMTP id
 s19mr21479184qvk.26.1608632813082; Tue, 22 Dec 2020 02:26:53 -0800 (PST)
Date:   Tue, 22 Dec 2020 18:26:28 +0800
In-Reply-To: <20201222102629.1335742-1-apusaka@google.com>
Message-Id: <20201222182553.v5.4.I215b0904cb68d68ac780a0c75c06f7d12e6147b7@changeid>
Mime-Version: 1.0
References: <20201222102629.1335742-1-apusaka@google.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH v5 4/5] Bluetooth: advmon offload MSFT handle controller reset
From:   Archie Pusaka <apusaka@google.com>
To:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Yun-Hao Chung <howardchung@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Archie Pusaka <apusaka@chromium.org>

When the controller is powered off, the registered advertising monitor
is removed from the controller. This patch handles the re-registration
of those monitors when the power is on.

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
Reviewed-by: Yun-Hao Chung <howardchung@google.com>

---

Changes in v5:
* Discard struct flags on msft_data and use it's members directly

 net/bluetooth/msft.c | 76 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 71 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index f5aa0e3b1b9b..d25c6936daa4 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -82,8 +82,12 @@ struct msft_data {
 	struct list_head handle_map;
 	__u16 pending_add_handle;
 	__u16 pending_remove_handle;
+	__u8 reregistering;
 };
 
+static int __msft_add_monitor_pattern(struct hci_dev *hdev,
+				      struct adv_monitor *monitor);
+
 bool msft_monitor_supported(struct hci_dev *hdev)
 {
 	return !!(msft_get_features(hdev) & MSFT_FEATURE_MASK_LE_ADV_MONITOR);
@@ -134,6 +138,35 @@ static bool read_supported_features(struct hci_dev *hdev,
 	return false;
 }
 
+/* This function requires the caller holds hdev->lock */
+static void reregister_monitor_on_restart(struct hci_dev *hdev, int handle)
+{
+	struct adv_monitor *monitor;
+	struct msft_data *msft = hdev->msft_data;
+	int err;
+
+	while (1) {
+		monitor = idr_get_next(&hdev->adv_monitors_idr, &handle);
+		if (!monitor) {
+			/* All monitors have been reregistered */
+			msft->reregistering = false;
+			hci_update_background_scan(hdev);
+			return;
+		}
+
+		msft->pending_add_handle = (u16)handle;
+		err = __msft_add_monitor_pattern(hdev, monitor);
+
+		/* If success, we return and wait for monitor added callback */
+		if (!err)
+			return;
+
+		/* Otherwise remove the monitor and keep registering */
+		hci_free_adv_monitor(hdev, monitor);
+		handle++;
+	}
+}
+
 void msft_do_open(struct hci_dev *hdev)
 {
 	struct msft_data *msft;
@@ -154,12 +187,18 @@ void msft_do_open(struct hci_dev *hdev)
 
 	INIT_LIST_HEAD(&msft->handle_map);
 	hdev->msft_data = msft;
+
+	if (msft_monitor_supported(hdev)) {
+		msft->reregistering = true;
+		reregister_monitor_on_restart(hdev, 0);
+	}
 }
 
 void msft_do_close(struct hci_dev *hdev)
 {
 	struct msft_data *msft = hdev->msft_data;
 	struct msft_monitor_advertisement_handle_data *handle_data, *tmp;
+	struct adv_monitor *monitor;
 
 	if (!msft)
 		return;
@@ -169,6 +208,12 @@ void msft_do_close(struct hci_dev *hdev)
 	hdev->msft_data = NULL;
 
 	list_for_each_entry_safe(handle_data, tmp, &msft->handle_map, list) {
+		monitor = idr_find(&hdev->adv_monitors_idr,
+				   handle_data->mgmt_handle);
+
+		if (monitor && monitor->state == ADV_MONITOR_STATE_OFFLOADED)
+			monitor->state = ADV_MONITOR_STATE_REGISTERED;
+
 		list_del(&handle_data->list);
 		kfree(handle_data);
 	}
@@ -282,9 +327,15 @@ static void msft_le_monitor_advertisement_cb(struct hci_dev *hdev,
 	if (status && monitor)
 		hci_free_adv_monitor(hdev, monitor);
 
+	/* If in restart/reregister sequence, keep registering. */
+	if (msft->reregistering)
+		reregister_monitor_on_restart(hdev,
+					      msft->pending_add_handle + 1);
+
 	hci_dev_unlock(hdev);
 
-	hci_add_adv_patterns_monitor_complete(hdev, status);
+	if (!msft->reregistering)
+		hci_add_adv_patterns_monitor_complete(hdev, status);
 }
 
 static void msft_le_cancel_monitor_advertisement_cb(struct hci_dev *hdev,
@@ -374,7 +425,8 @@ static bool msft_monitor_pattern_valid(struct adv_monitor *monitor)
 }
 
 /* This function requires the caller holds hdev->lock */
-int msft_add_monitor_pattern(struct hci_dev *hdev, struct adv_monitor *monitor)
+static int __msft_add_monitor_pattern(struct hci_dev *hdev,
+				      struct adv_monitor *monitor)
 {
 	struct msft_cp_le_monitor_advertisement *cp;
 	struct msft_le_monitor_advertisement_pattern_data *pattern_data;
@@ -387,9 +439,6 @@ int msft_add_monitor_pattern(struct hci_dev *hdev, struct adv_monitor *monitor)
 	u8 pattern_count = 0;
 	int err = 0;
 
-	if (!msft)
-		return -EOPNOTSUPP;
-
 	if (!msft_monitor_pattern_valid(monitor))
 		return -EINVAL;
 
@@ -434,6 +483,20 @@ int msft_add_monitor_pattern(struct hci_dev *hdev, struct adv_monitor *monitor)
 	return err;
 }
 
+/* This function requires the caller holds hdev->lock */
+int msft_add_monitor_pattern(struct hci_dev *hdev, struct adv_monitor *monitor)
+{
+	struct msft_data *msft = hdev->msft_data;
+
+	if (!msft)
+		return -EOPNOTSUPP;
+
+	if (msft->reregistering)
+		return -EBUSY;
+
+	return __msft_add_monitor_pattern(hdev, monitor);
+}
+
 /* This function requires the caller holds hdev->lock */
 int msft_remove_monitor(struct hci_dev *hdev, struct adv_monitor *monitor,
 			u16 handle)
@@ -447,6 +510,9 @@ int msft_remove_monitor(struct hci_dev *hdev, struct adv_monitor *monitor,
 	if (!msft)
 		return -EOPNOTSUPP;
 
+	if (msft->reregistering)
+		return -EBUSY;
+
 	handle_data = msft_find_handle_data(hdev, monitor->handle, true);
 
 	/* If no matched handle, just remove without telling controller */
-- 
2.29.2.729.g45daf8777d-goog

