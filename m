Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5663757C0C4
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 01:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbiGTXVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 19:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiGTXVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 19:21:21 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426513AE7B
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 16:21:19 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id f85-20020a253858000000b00670a44473e2so11389yba.9
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 16:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=kPv/zgdg55aBvysGG2zpclfTB4BrqustdwxHqVcSIm8=;
        b=Ff+/pHmi2PQC+CO76Dh95oyzsjDvPxigwhwjLXvPSZVCA42OS954cWpOm8HaZVY/Lt
         0PvwHoASyzOy4p9+qiwSzLE8kiI+21XYxSOAHK6ESKe6NgU4c4g1Ij1UsDwaEkI8jl+j
         KHE1QpjyalKH1jXsyFkV1m0KOpeBKu2KSl/wdJDz5XZ7oAbk5WdAJ1CI0k6Yu3Xm/+8M
         8CDtvNqzdENSKKwmR4BGioItarmSWvStuGX1IsWzxjB4lm/rUnJ/rHc6aALlxJLjs3MP
         /qAZ470CO4vhYmvUvQ7gPmZieQCqkcPDbB/Kri9Wh4K9VrB1dHdjrnbQdrFyc4ZEFYBz
         5tiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=kPv/zgdg55aBvysGG2zpclfTB4BrqustdwxHqVcSIm8=;
        b=35e5s7Y61pOtQ0uTRW8wuAjI3OqEoD0fs/gIFaRKB38HpgmlVvB7ZrhODaMCQpWCmK
         LKT4TXKggm5VmEKC7ua3wCdL1N6BOCn7osVHN8r1/ymhNuhN9oKJWrghl5tWbkuVi0x9
         H7NK06UM7HKcu48XI4MDOA/6jZTgAaIoDX14KGrZR8cCApGSR7pq0XzNFEovdAT9YemX
         A5xCkDH4NYYy0NdMOyX+N4/BhIWGZLMKDw5mhhsLtU5QvUU8ttLa8lhGYJEEdLcLAICf
         qDw756Hs3QUVxlwTewPWfMVKJlv11aD5DUSzgRlIhfoOht8S983oOukf7Z+yZ4rQb/Ew
         bGGA==
X-Gm-Message-State: AJIora/4I8ufOkQbkh/UU6c2QlVQC0Ic2OgRr7+pUfYROQ7bALObLA/V
        Fh55s8l0vz9yp6ZbR7OiLXIhbP4QMobjmA==
X-Google-Smtp-Source: AGRyM1srMFCC5prOYvcY4WNRk/CgY6a2s9JpD1xCFeyfNpS8VOFrwjvIKyZhxUk9OQdqSZXo9gUPOqtruhaKow==
X-Received: from mmandlik.mtv.corp.google.com ([2620:15c:202:201:2c25:d93c:6b38:6338])
 (user=mmandlik job=sendgmr) by 2002:a05:6902:120f:b0:668:2228:9627 with SMTP
 id s15-20020a056902120f00b0066822289627mr41174561ybu.134.1658359278528; Wed,
 20 Jul 2022 16:21:18 -0700 (PDT)
Date:   Wed, 20 Jul 2022 16:21:13 -0700
Message-Id: <20220720162102.v2.1.If745ed1d05d98c002fc84ba60cef99eb786b7caa@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v2 1/2] Bluetooth: hci_sync: Refactor add Adv Monitor
From:   Manish Mandlik <mmandlik@google.com>
To:     marcel@holtmann.org, luiz.dentz@gmail.com
Cc:     linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        Manish Mandlik <mmandlik@google.com>,
        Miao-chen Chou <mcchou@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of hci_cmd_sync_queue for adding an advertisement monitor.

Signed-off-by: Manish Mandlik <mmandlik@google.com>
Reviewed-by: Miao-chen Chou <mcchou@google.com>
---

Changes in v2:
- Refactored to correctly use hci_cmd_sync_queue

 include/net/bluetooth/hci_core.h |   5 +-
 net/bluetooth/hci_core.c         |  46 ++++-----
 net/bluetooth/mgmt.c             |  52 +++-------
 net/bluetooth/msft.c             | 171 ++++++++-----------------------
 4 files changed, 78 insertions(+), 196 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 15237ee5f761..4dbdf7c468b6 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1423,10 +1423,8 @@ bool hci_adv_instance_is_scannable(struct hci_dev *hdev, u8 instance);
 
 void hci_adv_monitors_clear(struct hci_dev *hdev);
 void hci_free_adv_monitor(struct hci_dev *hdev, struct adv_monitor *monitor);
-int hci_add_adv_patterns_monitor_complete(struct hci_dev *hdev, u8 status);
 int hci_remove_adv_monitor_complete(struct hci_dev *hdev, u8 status);
-bool hci_add_adv_monitor(struct hci_dev *hdev, struct adv_monitor *monitor,
-			int *err);
+int hci_add_adv_monitor(struct hci_dev *hdev, struct adv_monitor *monitor);
 bool hci_remove_single_adv_monitor(struct hci_dev *hdev, u16 handle, int *err);
 bool hci_remove_all_adv_monitor(struct hci_dev *hdev, int *err);
 bool hci_is_adv_monitoring(struct hci_dev *hdev);
@@ -1888,7 +1886,6 @@ void mgmt_advertising_removed(struct sock *sk, struct hci_dev *hdev,
 			      u8 instance);
 void mgmt_adv_monitor_removed(struct hci_dev *hdev, u16 handle);
 int mgmt_phy_configuration_changed(struct hci_dev *hdev, struct sock *skip);
-int mgmt_add_adv_patterns_monitor_complete(struct hci_dev *hdev, u8 status);
 int mgmt_remove_adv_monitor_complete(struct hci_dev *hdev, u8 status);
 void mgmt_adv_monitor_device_lost(struct hci_dev *hdev, u16 handle,
 				  bdaddr_t *bdaddr, u8 addr_type);
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 0a51858d863a..9333e8759fab 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1880,11 +1880,6 @@ void hci_free_adv_monitor(struct hci_dev *hdev, struct adv_monitor *monitor)
 	kfree(monitor);
 }
 
-int hci_add_adv_patterns_monitor_complete(struct hci_dev *hdev, u8 status)
-{
-	return mgmt_add_adv_patterns_monitor_complete(hdev, status);
-}
-
 int hci_remove_adv_monitor_complete(struct hci_dev *hdev, u8 status)
 {
 	return mgmt_remove_adv_monitor_complete(hdev, status);
@@ -1892,49 +1887,48 @@ int hci_remove_adv_monitor_complete(struct hci_dev *hdev, u8 status)
 
 /* Assigns handle to a monitor, and if offloading is supported and power is on,
  * also attempts to forward the request to the controller.
- * Returns true if request is forwarded (result is pending), false otherwise.
- * This function requires the caller holds hdev->lock.
+ * This function requires the caller holds hci_req_sync_lock.
  */
-bool hci_add_adv_monitor(struct hci_dev *hdev, struct adv_monitor *monitor,
-			 int *err)
+int hci_add_adv_monitor(struct hci_dev *hdev, struct adv_monitor *monitor)
 {
 	int min, max, handle;
+	int status = 0;
 
-	*err = 0;
+	if (!monitor)
+		return -EINVAL;
 
-	if (!monitor) {
-		*err = -EINVAL;
-		return false;
-	}
+	hci_dev_lock(hdev);
 
 	min = HCI_MIN_ADV_MONITOR_HANDLE;
 	max = HCI_MIN_ADV_MONITOR_HANDLE + HCI_MAX_ADV_MONITOR_NUM_HANDLES;
 	handle = idr_alloc(&hdev->adv_monitors_idr, monitor, min, max,
 			   GFP_KERNEL);
-	if (handle < 0) {
-		*err = handle;
-		return false;
-	}
+
+	hci_dev_unlock(hdev);
+
+	if (handle < 0)
+		return handle;
 
 	monitor->handle = handle;
 
 	if (!hdev_is_powered(hdev))
-		return false;
+		return status;
 
 	switch (hci_get_adv_monitor_offload_ext(hdev)) {
 	case HCI_ADV_MONITOR_EXT_NONE:
-		hci_update_passive_scan(hdev);
-		bt_dev_dbg(hdev, "%s add monitor status %d", hdev->name, *err);
+		bt_dev_dbg(hdev, "%s add monitor %d status %d", hdev->name,
+			   monitor->handle, status);
 		/* Message was not forwarded to controller - not an error */
-		return false;
+		break;
+
 	case HCI_ADV_MONITOR_EXT_MSFT:
-		*err = msft_add_monitor_pattern(hdev, monitor);
-		bt_dev_dbg(hdev, "%s add monitor msft status %d", hdev->name,
-			   *err);
+		status = msft_add_monitor_pattern(hdev, monitor);
+		bt_dev_dbg(hdev, "%s add monitor %d msft status %d", hdev->name,
+			   monitor->handle, status);
 		break;
 	}
 
-	return (*err == 0);
+	return status;
 }
 
 /* Attempts to tell the controller and free the monitor. If somehow the
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index ef8371975c4e..fb2d0f6de4a3 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4653,23 +4653,15 @@ static int read_adv_mon_features(struct sock *sk, struct hci_dev *hdev,
 	return err;
 }
 
-int mgmt_add_adv_patterns_monitor_complete(struct hci_dev *hdev, u8 status)
+static void mgmt_add_adv_patterns_monitor_complete(struct hci_dev *hdev,
+						   void *data, int status)
 {
 	struct mgmt_rp_add_adv_patterns_monitor rp;
-	struct mgmt_pending_cmd *cmd;
-	struct adv_monitor *monitor;
-	int err = 0;
+	struct mgmt_pending_cmd *cmd = data;
+	struct adv_monitor *monitor = cmd->user_data;
 
 	hci_dev_lock(hdev);
 
-	cmd = pending_find(MGMT_OP_ADD_ADV_PATTERNS_MONITOR_RSSI, hdev);
-	if (!cmd) {
-		cmd = pending_find(MGMT_OP_ADD_ADV_PATTERNS_MONITOR, hdev);
-		if (!cmd)
-			goto done;
-	}
-
-	monitor = cmd->user_data;
 	rp.monitor_handle = cpu_to_le16(monitor->handle);
 
 	if (!status) {
@@ -4680,26 +4672,29 @@ int mgmt_add_adv_patterns_monitor_complete(struct hci_dev *hdev, u8 status)
 		hci_update_passive_scan(hdev);
 	}
 
-	err = mgmt_cmd_complete(cmd->sk, cmd->index, cmd->opcode,
-				mgmt_status(status), &rp, sizeof(rp));
+	mgmt_cmd_complete(cmd->sk, cmd->index, cmd->opcode,
+			  mgmt_status(status), &rp, sizeof(rp));
 	mgmt_pending_remove(cmd);
 
-done:
 	hci_dev_unlock(hdev);
-	bt_dev_dbg(hdev, "add monitor %d complete, status %u",
+	bt_dev_dbg(hdev, "add monitor %d complete, status %d",
 		   rp.monitor_handle, status);
+}
 
-	return err;
+static int mgmt_add_adv_patterns_monitor_sync(struct hci_dev *hdev, void *data)
+{
+	struct mgmt_pending_cmd *cmd = data;
+	struct adv_monitor *monitor = cmd->user_data;
+
+	return hci_add_adv_monitor(hdev, monitor);
 }
 
 static int __add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
 				      struct adv_monitor *m, u8 status,
 				      void *data, u16 len, u16 op)
 {
-	struct mgmt_rp_add_adv_patterns_monitor rp;
 	struct mgmt_pending_cmd *cmd;
 	int err;
-	bool pending;
 
 	hci_dev_lock(hdev);
 
@@ -4721,12 +4716,11 @@ static int __add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
 	}
 
 	cmd->user_data = m;
-	pending = hci_add_adv_monitor(hdev, m, &err);
+	err = hci_cmd_sync_queue(hdev, mgmt_add_adv_patterns_monitor_sync, cmd,
+				 mgmt_add_adv_patterns_monitor_complete);
 	if (err) {
-		if (err == -ENOSPC || err == -ENOMEM)
+		if (err == -ENOMEM)
 			status = MGMT_STATUS_NO_RESOURCES;
-		else if (err == -EINVAL)
-			status = MGMT_STATUS_INVALID_PARAMS;
 		else
 			status = MGMT_STATUS_FAILED;
 
@@ -4734,18 +4728,6 @@ static int __add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
 		goto unlock;
 	}
 
-	if (!pending) {
-		mgmt_pending_remove(cmd);
-		rp.monitor_handle = cpu_to_le16(m->handle);
-		mgmt_adv_monitor_added(sk, hdev, m->handle);
-		m->state = ADV_MONITOR_STATE_REGISTERED;
-		hdev->adv_monitors_cnt++;
-
-		hci_dev_unlock(hdev);
-		return mgmt_cmd_complete(sk, hdev->id, op, MGMT_STATUS_SUCCESS,
-					 &rp, sizeof(rp));
-	}
-
 	hci_dev_unlock(hdev);
 
 	return 0;
diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index f43994523b1f..54fbc718e893 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -99,15 +99,12 @@ struct msft_data {
 	__u8  evt_prefix_len;
 	__u8  *evt_prefix;
 	struct list_head handle_map;
-	__u16 pending_add_handle;
 	__u16 pending_remove_handle;
 	__u8 resuming;
 	__u8 suspending;
 	__u8 filter_enabled;
 };
 
-static int __msft_add_monitor_pattern(struct hci_dev *hdev,
-				      struct adv_monitor *monitor);
 static int __msft_remove_monitor(struct hci_dev *hdev,
 				 struct adv_monitor *monitor, u16 handle);
 
@@ -164,34 +161,6 @@ static bool read_supported_features(struct hci_dev *hdev,
 	return false;
 }
 
-static void reregister_monitor(struct hci_dev *hdev, int handle)
-{
-	struct adv_monitor *monitor;
-	struct msft_data *msft = hdev->msft_data;
-	int err;
-
-	while (1) {
-		monitor = idr_get_next(&hdev->adv_monitors_idr, &handle);
-		if (!monitor) {
-			/* All monitors have been resumed */
-			msft->resuming = false;
-			hci_update_passive_scan(hdev);
-			return;
-		}
-
-		msft->pending_add_handle = (u16)handle;
-		err = __msft_add_monitor_pattern(hdev, monitor);
-
-		/* If success, we return and wait for monitor added callback */
-		if (!err)
-			return;
-
-		/* Otherwise remove the monitor and keep registering */
-		hci_free_adv_monitor(hdev, monitor);
-		handle++;
-	}
-}
-
 /* is_mgmt = true matches the handle exposed to userspace via mgmt.
  * is_mgmt = false matches the handle used by the msft controller.
  * This function requires the caller holds hdev->lock
@@ -243,34 +212,27 @@ static int msft_monitor_device_del(struct hci_dev *hdev, __u16 mgmt_handle,
 	return count;
 }
 
-static void msft_le_monitor_advertisement_cb(struct hci_dev *hdev,
-					     u8 status, u16 opcode,
-					     struct sk_buff *skb)
+static int msft_le_monitor_advertisement_cb(struct hci_dev *hdev, u16 opcode,
+					    struct adv_monitor *monitor,
+					    struct sk_buff *skb)
 {
 	struct msft_rp_le_monitor_advertisement *rp;
-	struct adv_monitor *monitor;
 	struct msft_monitor_advertisement_handle_data *handle_data;
 	struct msft_data *msft = hdev->msft_data;
+	int status = 0;
 
 	hci_dev_lock(hdev);
 
-	monitor = idr_find(&hdev->adv_monitors_idr, msft->pending_add_handle);
-	if (!monitor) {
-		bt_dev_err(hdev, "msft add advmon: monitor %u is not found!",
-			   msft->pending_add_handle);
+	rp = (struct msft_rp_le_monitor_advertisement *)skb->data;
+	if (skb->len < sizeof(*rp)) {
 		status = HCI_ERROR_UNSPECIFIED;
 		goto unlock;
 	}
 
+	status = rp->status;
 	if (status)
 		goto unlock;
 
-	rp = (struct msft_rp_le_monitor_advertisement *)skb->data;
-	if (skb->len < sizeof(*rp)) {
-		status = HCI_ERROR_UNSPECIFIED;
-		goto unlock;
-	}
-
 	handle_data = kmalloc(sizeof(*handle_data), GFP_KERNEL);
 	if (!handle_data) {
 		status = HCI_ERROR_UNSPECIFIED;
@@ -285,13 +247,12 @@ static void msft_le_monitor_advertisement_cb(struct hci_dev *hdev,
 	monitor->state = ADV_MONITOR_STATE_OFFLOADED;
 
 unlock:
-	if (status && monitor)
+	if (status)
 		hci_free_adv_monitor(hdev, monitor);
 
 	hci_dev_unlock(hdev);
 
-	if (!msft->resuming)
-		hci_add_adv_patterns_monitor_complete(hdev, status);
+	return status;
 }
 
 static void msft_le_cancel_monitor_advertisement_cb(struct hci_dev *hdev,
@@ -463,7 +424,6 @@ static int msft_add_monitor_sync(struct hci_dev *hdev,
 	ptrdiff_t offset = 0;
 	u8 pattern_count = 0;
 	struct sk_buff *skb;
-	u8 status;
 
 	if (!msft_monitor_pattern_valid(monitor))
 		return -EINVAL;
@@ -505,20 +465,40 @@ static int msft_add_monitor_sync(struct hci_dev *hdev,
 	if (IS_ERR(skb))
 		return PTR_ERR(skb);
 
-	status = skb->data[0];
-	skb_pull(skb, 1);
+	return msft_le_monitor_advertisement_cb(hdev, hdev->msft_opcode,
+						monitor, skb);
+}
 
-	msft_le_monitor_advertisement_cb(hdev, status, hdev->msft_opcode, skb);
+/* This function requires the caller holds hci_req_sync_lock */
+static void reregister_monitor(struct hci_dev *hdev)
+{
+	struct adv_monitor *monitor;
+	struct msft_data *msft = hdev->msft_data;
+	int handle = 0;
 
-	return status;
+	if (!msft)
+		return;
+
+	msft->resuming = true;
+
+	while (1) {
+		monitor = idr_get_next(&hdev->adv_monitors_idr, &handle);
+		if (!monitor)
+			break;
+
+		msft_add_monitor_sync(hdev, monitor);
+
+		handle++;
+	}
+
+	/* All monitors have been reregistered */
+	msft->resuming = false;
 }
 
 /* This function requires the caller holds hci_req_sync_lock */
 int msft_resume_sync(struct hci_dev *hdev)
 {
 	struct msft_data *msft = hdev->msft_data;
-	struct adv_monitor *monitor;
-	int handle = 0;
 
 	if (!msft || !msft_monitor_supported(hdev))
 		return 0;
@@ -533,24 +513,12 @@ int msft_resume_sync(struct hci_dev *hdev)
 
 	hci_dev_unlock(hdev);
 
-	msft->resuming = true;
-
-	while (1) {
-		monitor = idr_get_next(&hdev->adv_monitors_idr, &handle);
-		if (!monitor)
-			break;
-
-		msft_add_monitor_sync(hdev, monitor);
-
-		handle++;
-	}
-
-	/* All monitors have been resumed */
-	msft->resuming = false;
+	reregister_monitor(hdev);
 
 	return 0;
 }
 
+/* This function requires the caller holds hci_req_sync_lock */
 void msft_do_open(struct hci_dev *hdev)
 {
 	struct msft_data *msft = hdev->msft_data;
@@ -583,7 +551,7 @@ void msft_do_open(struct hci_dev *hdev)
 		/* Monitors get removed on power off, so we need to explicitly
 		 * tell the controller to re-monitor.
 		 */
-		reregister_monitor(hdev, 0);
+		reregister_monitor(hdev);
 	}
 }
 
@@ -829,66 +797,7 @@ static void msft_le_set_advertisement_filter_enable_cb(struct hci_dev *hdev,
 	hci_dev_unlock(hdev);
 }
 
-/* This function requires the caller holds hdev->lock */
-static int __msft_add_monitor_pattern(struct hci_dev *hdev,
-				      struct adv_monitor *monitor)
-{
-	struct msft_cp_le_monitor_advertisement *cp;
-	struct msft_le_monitor_advertisement_pattern_data *pattern_data;
-	struct msft_le_monitor_advertisement_pattern *pattern;
-	struct adv_pattern *entry;
-	struct hci_request req;
-	struct msft_data *msft = hdev->msft_data;
-	size_t total_size = sizeof(*cp) + sizeof(*pattern_data);
-	ptrdiff_t offset = 0;
-	u8 pattern_count = 0;
-	int err = 0;
-
-	if (!msft_monitor_pattern_valid(monitor))
-		return -EINVAL;
-
-	list_for_each_entry(entry, &monitor->patterns, list) {
-		pattern_count++;
-		total_size += sizeof(*pattern) + entry->length;
-	}
-
-	cp = kmalloc(total_size, GFP_KERNEL);
-	if (!cp)
-		return -ENOMEM;
-
-	cp->sub_opcode = MSFT_OP_LE_MONITOR_ADVERTISEMENT;
-	cp->rssi_high = monitor->rssi.high_threshold;
-	cp->rssi_low = monitor->rssi.low_threshold;
-	cp->rssi_low_interval = (u8)monitor->rssi.low_threshold_timeout;
-	cp->rssi_sampling_period = monitor->rssi.sampling_period;
-
-	cp->cond_type = MSFT_MONITOR_ADVERTISEMENT_TYPE_PATTERN;
-
-	pattern_data = (void *)cp->data;
-	pattern_data->count = pattern_count;
-
-	list_for_each_entry(entry, &monitor->patterns, list) {
-		pattern = (void *)(pattern_data->data + offset);
-		/* the length also includes data_type and offset */
-		pattern->length = entry->length + 2;
-		pattern->data_type = entry->ad_type;
-		pattern->start_byte = entry->offset;
-		memcpy(pattern->pattern, entry->value, entry->length);
-		offset += sizeof(*pattern) + entry->length;
-	}
-
-	hci_req_init(&req, hdev);
-	hci_req_add(&req, hdev->msft_opcode, total_size, cp);
-	err = hci_req_run_skb(&req, msft_le_monitor_advertisement_cb);
-	kfree(cp);
-
-	if (!err)
-		msft->pending_add_handle = monitor->handle;
-
-	return err;
-}
-
-/* This function requires the caller holds hdev->lock */
+/* This function requires the caller holds hci_req_sync_lock */
 int msft_add_monitor_pattern(struct hci_dev *hdev, struct adv_monitor *monitor)
 {
 	struct msft_data *msft = hdev->msft_data;
@@ -899,7 +808,7 @@ int msft_add_monitor_pattern(struct hci_dev *hdev, struct adv_monitor *monitor)
 	if (msft->resuming || msft->suspending)
 		return -EBUSY;
 
-	return __msft_add_monitor_pattern(hdev, monitor);
+	return msft_add_monitor_sync(hdev, monitor);
 }
 
 /* This function requires the caller holds hdev->lock */
-- 
2.37.0.170.g444d1eabd0-goog

