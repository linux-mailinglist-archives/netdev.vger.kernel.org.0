Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E21A2E08CD
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 11:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgLVK2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 05:28:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbgLVK2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 05:28:13 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786D6C0611D0
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 02:26:57 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id k7so17306979ybm.13
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 02:26:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=rc5GeV91m/6eoUZATdYOYr9FoqLYV4Rzhs9/leORJUE=;
        b=LA6pWjdBbVrTeX93aahQViGe09ABY/+upZrDgScTTBRcnh1fOgZj4QgkmUP3yTmJHF
         q55hBBeMwwfzs8mBLkXWxvrRM7Rb5Km6aWL52D7opfF1/K7XL7LxAHsqXqaaC2jzRJLY
         pHqCUhN9WjbwzwkDmNBXYRvyg4z2eMV0QncybVUZl9+57KsIQuG2BeKJ/uIJMg2pegeI
         n9sz1b16b5DSpouxMQkGoRiEezvGunPZJHUi/6bNHqkO2gqhfNbT7cMg85+JJ0dHaq40
         lPFuc7Oq57Ddp4Tqh522PZ/1ujDWDTO60gOsugRo9n61id5S+5Oke5YC9Yn/wjZ4f5Y4
         efsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rc5GeV91m/6eoUZATdYOYr9FoqLYV4Rzhs9/leORJUE=;
        b=YzEAo443gczNeTrNXy5x/3gekC69IEOFAfWDqrR07kt/VArkudr6tWWZpwUjFMqQGR
         y/BG/M1AC+/9qhBIkXdX7DdAubc3y2Mc3/qBKKPbseDztKunJr89isGQ3vjMFvcR6KPQ
         nQmI1OSqCo3kp8kQv5RgeWZmdhSRE9lA1hG/P3FfpfaOeZ9ZNWX9QB5jUDWMlsl/MOKi
         gk1fcjMgKd54//T2ovaE9mZ2zOp//5Z/7ZxkfGdRAd4iLGWSXCSrGZ6RHBSTdoCblkg8
         ahCFsf/BviKG3ckaqPyZwJiiQq0SUxUr0iwRvjHGU3PND3TSt2U8GtcKRP7iIgkkYI06
         DTTw==
X-Gm-Message-State: AOAM533+RfxhBBSw4FTfcaC8kW9A/EMe9q3a8OI4wj8sslPS5T0MiW9m
        E8chP6UHVYV7O6gPJqzRIgqHEkWg47Ds
X-Google-Smtp-Source: ABdhPJyNvl6CoK33XU907foYZnffLBb6MRCj5jj7ztBx0EP6lQt9t9KpMPVr9wi7EePLbRF17poL8BEFJObB
Sender: "apusaka via sendgmr" <apusaka@apusaka-p920.tpe.corp.google.com>
X-Received: from apusaka-p920.tpe.corp.google.com ([172.30.210.44])
 (user=apusaka job=sendgmr) by 2002:a25:b195:: with SMTP id
 h21mr29501513ybj.406.1608632816709; Tue, 22 Dec 2020 02:26:56 -0800 (PST)
Date:   Tue, 22 Dec 2020 18:26:29 +0800
In-Reply-To: <20201222102629.1335742-1-apusaka@google.com>
Message-Id: <20201222182553.v5.5.I96e97067afe1635dbda036b881ba2a01f37cd343@changeid>
Mime-Version: 1.0
References: <20201222102629.1335742-1-apusaka@google.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH v5 5/5] Bluetooth: advmon offload MSFT handle filter enablement
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

Implements the feature to disable/enable the filter used for
advertising monitor on MSFT controller, effectively have the same
effect as "remove all monitors" and "add all previously removed
monitors".

This feature would be needed when suspending, where we would not want
to get packets from anything outside the allowlist. Note that the
integration with the suspending part is not included in this patch.

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
Reviewed-by: Yun-Hao Chung <howardchung@google.com>

---

(no changes since v1)

 net/bluetooth/msft.c | 67 ++++++++++++++++++++++++++++++++++++++++++++
 net/bluetooth/msft.h |  6 ++++
 2 files changed, 73 insertions(+)

diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index d25c6936daa4..b2ef654b1d3d 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -69,6 +69,17 @@ struct msft_rp_le_cancel_monitor_advertisement {
 	__u8 sub_opcode;
 } __packed;
 
+#define MSFT_OP_LE_SET_ADVERTISEMENT_FILTER_ENABLE	0x05
+struct msft_cp_le_set_advertisement_filter_enable {
+	__u8 sub_opcode;
+	__u8 enable;
+} __packed;
+
+struct msft_rp_le_set_advertisement_filter_enable {
+	__u8 status;
+	__u8 sub_opcode;
+} __packed;
+
 struct msft_monitor_advertisement_handle_data {
 	__u8  msft_handle;
 	__u16 mgmt_handle;
@@ -83,6 +94,7 @@ struct msft_data {
 	__u16 pending_add_handle;
 	__u16 pending_remove_handle;
 	__u8 reregistering;
+	__u8 filter_enabled;
 };
 
 static int __msft_add_monitor_pattern(struct hci_dev *hdev,
@@ -190,6 +202,7 @@ void msft_do_open(struct hci_dev *hdev)
 
 	if (msft_monitor_supported(hdev)) {
 		msft->reregistering = true;
+		msft_set_filter_enable(hdev, true);
 		reregister_monitor_on_restart(hdev, 0);
 	}
 }
@@ -395,6 +408,40 @@ static void msft_le_cancel_monitor_advertisement_cb(struct hci_dev *hdev,
 	hci_remove_adv_monitor_complete(hdev, status);
 }
 
+static void msft_le_set_advertisement_filter_enable_cb(struct hci_dev *hdev,
+						       u8 status, u16 opcode,
+						       struct sk_buff *skb)
+{
+	struct msft_cp_le_set_advertisement_filter_enable *cp;
+	struct msft_rp_le_set_advertisement_filter_enable *rp;
+	struct msft_data *msft = hdev->msft_data;
+
+	rp = (struct msft_rp_le_set_advertisement_filter_enable *)skb->data;
+	if (skb->len < sizeof(*rp))
+		return;
+
+	/* Error 0x0C would be returned if the filter enabled status is
+	 * already set to whatever we were trying to set.
+	 * Although the default state should be disabled, some controller set
+	 * the initial value to enabled. Because there is no way to know the
+	 * actual initial value before sending this command, here we also treat
+	 * error 0x0C as success.
+	 */
+	if (status != 0x00 && status != 0x0C)
+		return;
+
+	hci_dev_lock(hdev);
+
+	cp = hci_sent_cmd_data(hdev, hdev->msft_opcode);
+	msft->filter_enabled = cp->enable;
+
+	if (status == 0x0C)
+		bt_dev_warn(hdev, "MSFT filter_enable is already %s",
+			    cp->enable ? "on" : "off");
+
+	hci_dev_unlock(hdev);
+}
+
 static bool msft_monitor_rssi_valid(struct adv_monitor *monitor)
 {
 	struct adv_rssi_thresholds *r = &monitor->rssi;
@@ -531,3 +578,23 @@ int msft_remove_monitor(struct hci_dev *hdev, struct adv_monitor *monitor,
 
 	return err;
 }
+
+int msft_set_filter_enable(struct hci_dev *hdev, bool enable)
+{
+	struct msft_cp_le_set_advertisement_filter_enable cp;
+	struct hci_request req;
+	struct msft_data *msft = hdev->msft_data;
+	int err;
+
+	if (!msft)
+		return -EOPNOTSUPP;
+
+	cp.sub_opcode = MSFT_OP_LE_SET_ADVERTISEMENT_FILTER_ENABLE;
+	cp.enable = enable;
+
+	hci_req_init(&req, hdev);
+	hci_req_add(&req, hdev->msft_opcode, sizeof(cp), &cp);
+	err = hci_req_run_skb(&req, msft_le_set_advertisement_filter_enable_cb);
+
+	return err;
+}
diff --git a/net/bluetooth/msft.h b/net/bluetooth/msft.h
index 6f126a1f1688..f8e4d3a6d641 100644
--- a/net/bluetooth/msft.h
+++ b/net/bluetooth/msft.h
@@ -20,6 +20,7 @@ __u64 msft_get_features(struct hci_dev *hdev);
 int msft_add_monitor_pattern(struct hci_dev *hdev, struct adv_monitor *monitor);
 int msft_remove_monitor(struct hci_dev *hdev, struct adv_monitor *monitor,
 			u16 handle);
+int msft_set_filter_enable(struct hci_dev *hdev, bool enable);
 
 #else
 
@@ -45,4 +46,9 @@ static inline int msft_remove_monitor(struct hci_dev *hdev,
 	return -EOPNOTSUPP;
 }
 
+static inline int msft_set_filter_enable(struct hci_dev *hdev, bool enable)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif
-- 
2.29.2.729.g45daf8777d-goog

