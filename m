Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B848E2E086A
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 10:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgLVJ6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 04:58:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbgLVJ6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 04:58:40 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F69C0611CC
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 01:57:30 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id a17so11388544qko.11
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 01:57:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=IfrSEfLFQE31I1dbD09KG7xsA8Rrf54du5V/9TJa44M=;
        b=Yenl2bkqs81QPGmXawAKiP4fcN2CPW/EZjxXaPbd0w9eCdzP4AzU+Zz+5JyeozEFDA
         G/ue1m8QdLg6uenO+AMGUxCfwFwPl+V0UlTEV0Y9G4+V4uCwczWGH6+ixOfO7bvhQVED
         vULWDfDe6hmtrnlHwGJu1Y319SRrZ/S9YNnec7oteEHF0jqd9dkrdAPfyXM40+a7Xnax
         UZaG0MzkPa8/5uYiWGE/OdFwGTFfgcxRw0YuennYzRoPruqjRZ8jl+cO3Bk+XNYE9oVx
         9YutlK7lg4/8eGYBbOSvl3dnUSmqtqJgl4AbPKwyNIltWh0vllaAqSy4Y1Ga0FMbd6y2
         dTTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IfrSEfLFQE31I1dbD09KG7xsA8Rrf54du5V/9TJa44M=;
        b=KGe7fSDVr/HaJvckrgdMmoXxkwNDdIseydopEHwyn8xb0ZJDbMFFhiTj1egmnFpjgD
         If19NmNz7j1yK/tKAShCiJjrfa4zKf+7b1KL83lmK6pFsl8XNTUyPU4PgD8ejM76x9yj
         9QL3OlZ5JwAFx596zUK1DzdbpWLqcaIr1XRIXzSSwUgBOD0xA+NSuuAdKMaF1h7TExvh
         Hg4S5Xi6aED2lCUtqlixY47uQ85eyT2qGczyCTOI2zPgnL+TpQyc150SdTf56vlI5/jf
         9JwCdsiRjard8fN2ulTymS0rEgpF3P2MzzSNMsCsXacdvvWZsyqZOOl7/mTemUzkUE87
         DspQ==
X-Gm-Message-State: AOAM530rUKNjz2QhnqKGbhv/+uYtyDnjeIDXDxzJ9UddVjD70RFFptvh
        O+jGCByx4IntgZWQaHC91nh37Ts+JhoB
X-Google-Smtp-Source: ABdhPJyO8XoLkBW9q066odiYTryaeIeNxqbwdPeUFxzgCoYctGfCgiiAuccLcgQuiQIPnGO5qIHEkgLz7Tkb
Sender: "apusaka via sendgmr" <apusaka@apusaka-p920.tpe.corp.google.com>
X-Received: from apusaka-p920.tpe.corp.google.com ([172.30.210.44])
 (user=apusaka job=sendgmr) by 2002:ad4:52c3:: with SMTP id
 p3mr21298959qvs.52.1608631049959; Tue, 22 Dec 2020 01:57:29 -0800 (PST)
Date:   Tue, 22 Dec 2020 17:57:05 +0800
In-Reply-To: <20201222095706.948827-1-apusaka@google.com>
Message-Id: <20201222175659.v4.4.I215b0904cb68d68ac780a0c75c06f7d12e6147b7@changeid>
Mime-Version: 1.0
References: <20201222095706.948827-1-apusaka@google.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH v4 4/5] Bluetooth: advmon offload MSFT handle controller reset
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

(no changes since v1)

 net/bluetooth/msft.c | 79 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 74 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index f5aa0e3b1b9b..7e33a85c3f1c 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -82,8 +82,15 @@ struct msft_data {
 	struct list_head handle_map;
 	__u16 pending_add_handle;
 	__u16 pending_remove_handle;
+
+	struct {
+		u8 reregistering:1;
+	} flags;
 };
 
+static int __msft_add_monitor_pattern(struct hci_dev *hdev,
+				      struct adv_monitor *monitor);
+
 bool msft_monitor_supported(struct hci_dev *hdev)
 {
 	return !!(msft_get_features(hdev) & MSFT_FEATURE_MASK_LE_ADV_MONITOR);
@@ -134,6 +141,35 @@ static bool read_supported_features(struct hci_dev *hdev,
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
+			msft->flags.reregistering = false;
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
@@ -154,12 +190,18 @@ void msft_do_open(struct hci_dev *hdev)
 
 	INIT_LIST_HEAD(&msft->handle_map);
 	hdev->msft_data = msft;
+
+	if (msft_monitor_supported(hdev)) {
+		msft->flags.reregistering = true;
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
@@ -169,6 +211,12 @@ void msft_do_close(struct hci_dev *hdev)
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
@@ -282,9 +330,15 @@ static void msft_le_monitor_advertisement_cb(struct hci_dev *hdev,
 	if (status && monitor)
 		hci_free_adv_monitor(hdev, monitor);
 
+	/* If in restart/reregister sequence, keep registering. */
+	if (msft->flags.reregistering)
+		reregister_monitor_on_restart(hdev,
+					      msft->pending_add_handle + 1);
+
 	hci_dev_unlock(hdev);
 
-	hci_add_adv_patterns_monitor_complete(hdev, status);
+	if (!msft->flags.reregistering)
+		hci_add_adv_patterns_monitor_complete(hdev, status);
 }
 
 static void msft_le_cancel_monitor_advertisement_cb(struct hci_dev *hdev,
@@ -374,7 +428,8 @@ static bool msft_monitor_pattern_valid(struct adv_monitor *monitor)
 }
 
 /* This function requires the caller holds hdev->lock */
-int msft_add_monitor_pattern(struct hci_dev *hdev, struct adv_monitor *monitor)
+static int __msft_add_monitor_pattern(struct hci_dev *hdev,
+				      struct adv_monitor *monitor)
 {
 	struct msft_cp_le_monitor_advertisement *cp;
 	struct msft_le_monitor_advertisement_pattern_data *pattern_data;
@@ -387,9 +442,6 @@ int msft_add_monitor_pattern(struct hci_dev *hdev, struct adv_monitor *monitor)
 	u8 pattern_count = 0;
 	int err = 0;
 
-	if (!msft)
-		return -EOPNOTSUPP;
-
 	if (!msft_monitor_pattern_valid(monitor))
 		return -EINVAL;
 
@@ -434,6 +486,20 @@ int msft_add_monitor_pattern(struct hci_dev *hdev, struct adv_monitor *monitor)
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
+	if (msft->flags.reregistering)
+		return -EBUSY;
+
+	return __msft_add_monitor_pattern(hdev, monitor);
+}
+
 /* This function requires the caller holds hdev->lock */
 int msft_remove_monitor(struct hci_dev *hdev, struct adv_monitor *monitor,
 			u16 handle)
@@ -447,6 +513,9 @@ int msft_remove_monitor(struct hci_dev *hdev, struct adv_monitor *monitor,
 	if (!msft)
 		return -EOPNOTSUPP;
 
+	if (msft->flags.reregistering)
+		return -EBUSY;
+
 	handle_data = msft_find_handle_data(hdev, monitor->handle, true);
 
 	/* If no matched handle, just remove without telling controller */
-- 
2.29.2.729.g45daf8777d-goog

