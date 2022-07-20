Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87FA257C0C7
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 01:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbiGTXVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 19:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiGTXVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 19:21:23 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB45142AEF
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 16:21:21 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-31e6ca3d1efso803177b3.9
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 16:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=m9eaTt/V0NxFIvBAByGeBpf4xTPBmfXBwofjjTpsrDI=;
        b=QbYlZKJxtZJinTgUhqcEd3hEbF7lgT7dT8cRNSpdZ4jZkf8pTyNGn0rVA04QyHVh1Y
         hu5ALUKi/j0INOvJTVO0yQP2+QM/qvPUTPKjwTVGJtvZIaHqJu/HxNXAZ+0Ebo8lYk9C
         gRE5Q4F/XtsIAnKqLy/LFEOLCCt+YdWBjHciItXpGF+w+lVULk6MH5hpn+dHfWKEkhLO
         q/YpGpKS7sT3l2a/H4IFImTT1yza0bpKZsu8uEqtBVTs97kJaikXRrJYdf2t0wu2Gmqh
         OD4cvSkLngyXBQ7XhSwmhTL8nuunJH52CGayWFFBM1QnZJ+S4X+nx0eBshwL3WEW6d21
         Iu3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=m9eaTt/V0NxFIvBAByGeBpf4xTPBmfXBwofjjTpsrDI=;
        b=W3CHVGrOSjjms4n/r7oR7SPTZbo6DzcA6uhVxpH7QNao4rGeHMT2Gqh2taFW6GMTDa
         GW3vtDfIiBGDqKETg2MZ7VnyHyPRJ4BtID1HzUDyWzpja7brQl1SxZlSp2VnwTCviQ+4
         LCYfogci+G3zvghgTVP46wnWAj77kHGLmogmmUErwYbzsDpmTnVt0FuWaxlsaUealf0v
         a1ouG9SPq2hFTfM+t6xgzcKKKk1nw8R674awY+mCy7AbmWXar5f6sS7MAME8qkWPRejQ
         mMwGHVI2B1yXu1pg23JClk7VfnCHCdaFTccJ1jqwf8bTpsLR4o8WZVi7JWusSdlBYZyT
         2e7g==
X-Gm-Message-State: AJIora/aJQJnM/QANXL3amje1RmbfQ9IOR6z4ShJ8F2Ksuj7mHXSqNua
        6rm/OcQiDk5ZRVaZ6BFpDx4MRog7s8plyg==
X-Google-Smtp-Source: AGRyM1tzQgEQB921GXAQd3MR1KMapbeqSgGZZgLsI/FLP5U1BvN3NA9lqjlz0FGXS7/BTg7S5dpf0aR4KlJH9w==
X-Received: from mmandlik.mtv.corp.google.com ([2620:15c:202:201:2c25:d93c:6b38:6338])
 (user=mmandlik job=sendgmr) by 2002:a25:3d1:0:b0:670:7c8e:1ab with SMTP id
 200-20020a2503d1000000b006707c8e01abmr10660708ybd.349.1658359281260; Wed, 20
 Jul 2022 16:21:21 -0700 (PDT)
Date:   Wed, 20 Jul 2022 16:21:14 -0700
In-Reply-To: <20220720162102.v2.1.If745ed1d05d98c002fc84ba60cef99eb786b7caa@changeid>
Message-Id: <20220720162102.v2.2.Id703da51f33c425056a1148b91468dd6b06429b3@changeid>
Mime-Version: 1.0
References: <20220720162102.v2.1.If745ed1d05d98c002fc84ba60cef99eb786b7caa@changeid>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v2 2/2] Bluetooth: hci_sync: Refactor remove Adv Monitor
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of hci_cmd_sync_queue for removing an advertisement monitor.

Signed-off-by: Manish Mandlik <mmandlik@google.com>
Reviewed-by: Miao-chen Chou <mcchou@google.com>
---

Changes in v2:
- Refactored to correctly use hci_cmd_sync_queue

 include/net/bluetooth/hci_core.h |  6 +-
 net/bluetooth/hci_core.c         | 81 +++++++++-----------------
 net/bluetooth/mgmt.c             | 62 ++++++++------------
 net/bluetooth/msft.c             | 98 +++++++-------------------------
 net/bluetooth/msft.h             |  6 +-
 5 files changed, 75 insertions(+), 178 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 4dbdf7c468b6..e99f3360c2a9 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1423,10 +1423,9 @@ bool hci_adv_instance_is_scannable(struct hci_dev *hdev, u8 instance);
 
 void hci_adv_monitors_clear(struct hci_dev *hdev);
 void hci_free_adv_monitor(struct hci_dev *hdev, struct adv_monitor *monitor);
-int hci_remove_adv_monitor_complete(struct hci_dev *hdev, u8 status);
 int hci_add_adv_monitor(struct hci_dev *hdev, struct adv_monitor *monitor);
-bool hci_remove_single_adv_monitor(struct hci_dev *hdev, u16 handle, int *err);
-bool hci_remove_all_adv_monitor(struct hci_dev *hdev, int *err);
+int hci_remove_single_adv_monitor(struct hci_dev *hdev, u16 handle);
+int hci_remove_all_adv_monitor(struct hci_dev *hdev);
 bool hci_is_adv_monitoring(struct hci_dev *hdev);
 int hci_get_adv_monitor_offload_ext(struct hci_dev *hdev);
 
@@ -1886,7 +1885,6 @@ void mgmt_advertising_removed(struct sock *sk, struct hci_dev *hdev,
 			      u8 instance);
 void mgmt_adv_monitor_removed(struct hci_dev *hdev, u16 handle);
 int mgmt_phy_configuration_changed(struct hci_dev *hdev, struct sock *skip);
-int mgmt_remove_adv_monitor_complete(struct hci_dev *hdev, u8 status);
 void mgmt_adv_monitor_device_lost(struct hci_dev *hdev, u16 handle,
 				  bdaddr_t *bdaddr, u8 addr_type);
 
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 9333e8759fab..ee4e3f0d32d5 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1880,11 +1880,6 @@ void hci_free_adv_monitor(struct hci_dev *hdev, struct adv_monitor *monitor)
 	kfree(monitor);
 }
 
-int hci_remove_adv_monitor_complete(struct hci_dev *hdev, u8 status)
-{
-	return mgmt_remove_adv_monitor_complete(hdev, status);
-}
-
 /* Assigns handle to a monitor, and if offloading is supported and power is on,
  * also attempts to forward the request to the controller.
  * This function requires the caller holds hci_req_sync_lock.
@@ -1933,92 +1928,72 @@ int hci_add_adv_monitor(struct hci_dev *hdev, struct adv_monitor *monitor)
 
 /* Attempts to tell the controller and free the monitor. If somehow the
  * controller doesn't have a corresponding handle, remove anyway.
- * Returns true if request is forwarded (result is pending), false otherwise.
- * This function requires the caller holds hdev->lock.
+ * This function requires the caller holds hci_req_sync_lock.
  */
-static bool hci_remove_adv_monitor(struct hci_dev *hdev,
-				   struct adv_monitor *monitor,
-				   u16 handle, int *err)
+static int hci_remove_adv_monitor(struct hci_dev *hdev,
+				  struct adv_monitor *monitor)
 {
-	*err = 0;
+	int status = 0;
 
 	switch (hci_get_adv_monitor_offload_ext(hdev)) {
 	case HCI_ADV_MONITOR_EXT_NONE: /* also goes here when powered off */
+		bt_dev_dbg(hdev, "%s remove monitor %d status %d", hdev->name,
+			   monitor->handle, status);
 		goto free_monitor;
+
 	case HCI_ADV_MONITOR_EXT_MSFT:
-		*err = msft_remove_monitor(hdev, monitor, handle);
+		status = msft_remove_monitor(hdev, monitor);
+		bt_dev_dbg(hdev, "%s remove monitor %d msft status %d",
+			   hdev->name, monitor->handle, status);
 		break;
 	}
 
 	/* In case no matching handle registered, just free the monitor */
-	if (*err == -ENOENT)
+	if (status == -ENOENT)
 		goto free_monitor;
 
-	return (*err == 0);
+	return status;
 
 free_monitor:
-	if (*err == -ENOENT)
+	if (status == -ENOENT)
 		bt_dev_warn(hdev, "Removing monitor with no matching handle %d",
 			    monitor->handle);
 	hci_free_adv_monitor(hdev, monitor);
 
-	*err = 0;
-	return false;
+	return status;
 }
 
-/* Returns true if request is forwarded (result is pending), false otherwise.
- * This function requires the caller holds hdev->lock.
- */
-bool hci_remove_single_adv_monitor(struct hci_dev *hdev, u16 handle, int *err)
+/* This function requires the caller holds hci_req_sync_lock */
+int hci_remove_single_adv_monitor(struct hci_dev *hdev, u16 handle)
 {
 	struct adv_monitor *monitor = idr_find(&hdev->adv_monitors_idr, handle);
-	bool pending;
-
-	if (!monitor) {
-		*err = -EINVAL;
-		return false;
-	}
-
-	pending = hci_remove_adv_monitor(hdev, monitor, handle, err);
-	if (!*err && !pending)
-		hci_update_passive_scan(hdev);
 
-	bt_dev_dbg(hdev, "%s remove monitor handle %d, status %d, %spending",
-		   hdev->name, handle, *err, pending ? "" : "not ");
+	if (!monitor)
+		return -EINVAL;
 
-	return pending;
+	return hci_remove_adv_monitor(hdev, monitor);
 }
 
-/* Returns true if request is forwarded (result is pending), false otherwise.
- * This function requires the caller holds hdev->lock.
- */
-bool hci_remove_all_adv_monitor(struct hci_dev *hdev, int *err)
+/* This function requires the caller holds hci_req_sync_lock */
+int hci_remove_all_adv_monitor(struct hci_dev *hdev)
 {
 	struct adv_monitor *monitor;
 	int idr_next_id = 0;
-	bool pending = false;
-	bool update = false;
-
-	*err = 0;
+	int status = 0;
 
-	while (!*err && !pending) {
+	while (1) {
 		monitor = idr_get_next(&hdev->adv_monitors_idr, &idr_next_id);
 		if (!monitor)
 			break;
 
-		pending = hci_remove_adv_monitor(hdev, monitor, 0, err);
+		status = hci_remove_adv_monitor(hdev, monitor);
+		if (status)
+			return status;
 
-		if (!*err && !pending)
-			update = true;
+		idr_next_id++;
 	}
 
-	if (update)
-		hci_update_passive_scan(hdev);
-
-	bt_dev_dbg(hdev, "%s remove all monitors status %d, %spending",
-		   hdev->name, *err, pending ? "" : "not ");
-
-	return pending;
+	return status;
 }
 
 /* This function requires the caller holds hdev->lock */
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index fb2d0f6de4a3..d96dd9a70a05 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4868,49 +4868,46 @@ static int add_adv_patterns_monitor_rssi(struct sock *sk, struct hci_dev *hdev,
 					 MGMT_OP_ADD_ADV_PATTERNS_MONITOR_RSSI);
 }
 
-int mgmt_remove_adv_monitor_complete(struct hci_dev *hdev, u8 status)
+static void mgmt_remove_adv_monitor_complete(struct hci_dev *hdev,
+					     void *data, int status)
 {
 	struct mgmt_rp_remove_adv_monitor rp;
-	struct mgmt_cp_remove_adv_monitor *cp;
-	struct mgmt_pending_cmd *cmd;
-	int err = 0;
+	struct mgmt_pending_cmd *cmd = data;
+	struct mgmt_cp_remove_adv_monitor *cp = cmd->param;
 
 	hci_dev_lock(hdev);
 
-	cmd = pending_find(MGMT_OP_REMOVE_ADV_MONITOR, hdev);
-	if (!cmd)
-		goto done;
-
-	cp = cmd->param;
 	rp.monitor_handle = cp->monitor_handle;
 
 	if (!status)
 		hci_update_passive_scan(hdev);
 
-	err = mgmt_cmd_complete(cmd->sk, cmd->index, cmd->opcode,
-				mgmt_status(status), &rp, sizeof(rp));
+	mgmt_cmd_complete(cmd->sk, cmd->index, cmd->opcode,
+			  mgmt_status(status), &rp, sizeof(rp));
 	mgmt_pending_remove(cmd);
 
-done:
 	hci_dev_unlock(hdev);
-	bt_dev_dbg(hdev, "remove monitor %d complete, status %u",
+	bt_dev_dbg(hdev, "remove monitor %d complete, status %d",
 		   rp.monitor_handle, status);
+}
 
-	return err;
+static int mgmt_remove_adv_monitor_sync(struct hci_dev *hdev, void *data)
+{
+	struct mgmt_pending_cmd *cmd = data;
+	struct mgmt_cp_remove_adv_monitor *cp = cmd->param;
+	u16 handle = __le16_to_cpu(cp->monitor_handle);
+
+	if (!handle)
+		return hci_remove_all_adv_monitor(hdev);
+
+	return hci_remove_single_adv_monitor(hdev, handle);
 }
 
 static int remove_adv_monitor(struct sock *sk, struct hci_dev *hdev,
 			      void *data, u16 len)
 {
-	struct mgmt_cp_remove_adv_monitor *cp = data;
-	struct mgmt_rp_remove_adv_monitor rp;
 	struct mgmt_pending_cmd *cmd;
-	u16 handle = __le16_to_cpu(cp->monitor_handle);
 	int err, status;
-	bool pending;
-
-	BT_DBG("request for %s", hdev->name);
-	rp.monitor_handle = cp->monitor_handle;
 
 	hci_dev_lock(hdev);
 
@@ -4928,34 +4925,23 @@ static int remove_adv_monitor(struct sock *sk, struct hci_dev *hdev,
 		goto unlock;
 	}
 
-	if (handle)
-		pending = hci_remove_single_adv_monitor(hdev, handle, &err);
-	else
-		pending = hci_remove_all_adv_monitor(hdev, &err);
+	err = hci_cmd_sync_queue(hdev, mgmt_remove_adv_monitor_sync, cmd,
+				 mgmt_remove_adv_monitor_complete);
 
 	if (err) {
 		mgmt_pending_remove(cmd);
 
-		if (err == -ENOENT)
-			status = MGMT_STATUS_INVALID_INDEX;
+		if (err == -ENOMEM)
+			status = MGMT_STATUS_NO_RESOURCES;
 		else
 			status = MGMT_STATUS_FAILED;
 
-		goto unlock;
-	}
-
-	/* monitor can be removed without forwarding request to controller */
-	if (!pending) {
 		mgmt_pending_remove(cmd);
-		hci_dev_unlock(hdev);
-
-		return mgmt_cmd_complete(sk, hdev->id,
-					 MGMT_OP_REMOVE_ADV_MONITOR,
-					 MGMT_STATUS_SUCCESS,
-					 &rp, sizeof(rp));
+		goto unlock;
 	}
 
 	hci_dev_unlock(hdev);
+
 	return 0;
 
 unlock:
diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index 54fbc718e893..14975769f678 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -99,15 +99,11 @@ struct msft_data {
 	__u8  evt_prefix_len;
 	__u8  *evt_prefix;
 	struct list_head handle_map;
-	__u16 pending_remove_handle;
 	__u8 resuming;
 	__u8 suspending;
 	__u8 filter_enabled;
 };
 
-static int __msft_remove_monitor(struct hci_dev *hdev,
-				 struct adv_monitor *monitor, u16 handle);
-
 bool msft_monitor_supported(struct hci_dev *hdev)
 {
 	return !!(msft_get_features(hdev) & MSFT_FEATURE_MASK_LE_ADV_MONITOR);
@@ -255,20 +251,15 @@ static int msft_le_monitor_advertisement_cb(struct hci_dev *hdev, u16 opcode,
 	return status;
 }
 
-static void msft_le_cancel_monitor_advertisement_cb(struct hci_dev *hdev,
-						    u8 status, u16 opcode,
-						    struct sk_buff *skb)
+static int msft_le_cancel_monitor_advertisement_cb(struct hci_dev *hdev,
+						   u16 opcode,
+						   struct adv_monitor *monitor,
+						   struct sk_buff *skb)
 {
-	struct msft_cp_le_cancel_monitor_advertisement *cp;
 	struct msft_rp_le_cancel_monitor_advertisement *rp;
-	struct adv_monitor *monitor;
 	struct msft_monitor_advertisement_handle_data *handle_data;
 	struct msft_data *msft = hdev->msft_data;
-	int err;
-	bool pending;
-
-	if (status)
-		goto done;
+	int status = 0;
 
 	rp = (struct msft_rp_le_cancel_monitor_advertisement *)skb->data;
 	if (skb->len < sizeof(*rp)) {
@@ -276,22 +267,22 @@ static void msft_le_cancel_monitor_advertisement_cb(struct hci_dev *hdev,
 		goto done;
 	}
 
+	status = rp->status;
+	if (status)
+		goto done;
+
 	hci_dev_lock(hdev);
 
-	cp = hci_sent_cmd_data(hdev, hdev->msft_opcode);
-	handle_data = msft_find_handle_data(hdev, cp->handle, false);
+	handle_data = msft_find_handle_data(hdev, monitor->handle, true);
 
 	if (handle_data) {
-		monitor = idr_find(&hdev->adv_monitors_idr,
-				   handle_data->mgmt_handle);
-
-		if (monitor && monitor->state == ADV_MONITOR_STATE_OFFLOADED)
+		if (monitor->state == ADV_MONITOR_STATE_OFFLOADED)
 			monitor->state = ADV_MONITOR_STATE_REGISTERED;
 
 		/* Do not free the monitor if it is being removed due to
 		 * suspend. It will be re-monitored on resume.
 		 */
-		if (monitor && !msft->suspending) {
+		if (!msft->suspending) {
 			hci_free_adv_monitor(hdev, monitor);
 
 			/* Clear any monitored devices by this Adv Monitor */
@@ -303,35 +294,19 @@ static void msft_le_cancel_monitor_advertisement_cb(struct hci_dev *hdev,
 		kfree(handle_data);
 	}
 
-	/* If remove all monitors is required, we need to continue the process
-	 * here because the earlier it was paused when waiting for the
-	 * response from controller.
-	 */
-	if (msft->pending_remove_handle == 0) {
-		pending = hci_remove_all_adv_monitor(hdev, &err);
-		if (pending) {
-			hci_dev_unlock(hdev);
-			return;
-		}
-
-		if (err)
-			status = HCI_ERROR_UNSPECIFIED;
-	}
-
 	hci_dev_unlock(hdev);
 
 done:
-	if (!msft->suspending)
-		hci_remove_adv_monitor_complete(hdev, status);
+	return status;
 }
 
+/* This function requires the caller holds hci_req_sync_lock */
 static int msft_remove_monitor_sync(struct hci_dev *hdev,
 				    struct adv_monitor *monitor)
 {
 	struct msft_cp_le_cancel_monitor_advertisement cp;
 	struct msft_monitor_advertisement_handle_data *handle_data;
 	struct sk_buff *skb;
-	u8 status;
 
 	handle_data = msft_find_handle_data(hdev, monitor->handle, true);
 
@@ -347,13 +322,8 @@ static int msft_remove_monitor_sync(struct hci_dev *hdev,
 	if (IS_ERR(skb))
 		return PTR_ERR(skb);
 
-	status = skb->data[0];
-	skb_pull(skb, 1);
-
-	msft_le_cancel_monitor_advertisement_cb(hdev, status, hdev->msft_opcode,
-						skb);
-
-	return status;
+	return msft_le_cancel_monitor_advertisement_cb(hdev, hdev->msft_opcode,
+						       monitor, skb);
 }
 
 /* This function requires the caller holds hci_req_sync_lock */
@@ -811,38 +781,8 @@ int msft_add_monitor_pattern(struct hci_dev *hdev, struct adv_monitor *monitor)
 	return msft_add_monitor_sync(hdev, monitor);
 }
 
-/* This function requires the caller holds hdev->lock */
-static int __msft_remove_monitor(struct hci_dev *hdev,
-				 struct adv_monitor *monitor, u16 handle)
-{
-	struct msft_cp_le_cancel_monitor_advertisement cp;
-	struct msft_monitor_advertisement_handle_data *handle_data;
-	struct hci_request req;
-	struct msft_data *msft = hdev->msft_data;
-	int err = 0;
-
-	handle_data = msft_find_handle_data(hdev, monitor->handle, true);
-
-	/* If no matched handle, just remove without telling controller */
-	if (!handle_data)
-		return -ENOENT;
-
-	cp.sub_opcode = MSFT_OP_LE_CANCEL_MONITOR_ADVERTISEMENT;
-	cp.handle = handle_data->msft_handle;
-
-	hci_req_init(&req, hdev);
-	hci_req_add(&req, hdev->msft_opcode, sizeof(cp), &cp);
-	err = hci_req_run_skb(&req, msft_le_cancel_monitor_advertisement_cb);
-
-	if (!err)
-		msft->pending_remove_handle = handle;
-
-	return err;
-}
-
-/* This function requires the caller holds hdev->lock */
-int msft_remove_monitor(struct hci_dev *hdev, struct adv_monitor *monitor,
-			u16 handle)
+/* This function requires the caller holds hci_req_sync_lock */
+int msft_remove_monitor(struct hci_dev *hdev, struct adv_monitor *monitor)
 {
 	struct msft_data *msft = hdev->msft_data;
 
@@ -852,7 +792,7 @@ int msft_remove_monitor(struct hci_dev *hdev, struct adv_monitor *monitor,
 	if (msft->resuming || msft->suspending)
 		return -EBUSY;
 
-	return __msft_remove_monitor(hdev, monitor, handle);
+	return msft_remove_monitor_sync(hdev, monitor);
 }
 
 void msft_req_add_set_filter_enable(struct hci_request *req, bool enable)
diff --git a/net/bluetooth/msft.h b/net/bluetooth/msft.h
index afcaf7d3b1cb..2a63205b377b 100644
--- a/net/bluetooth/msft.h
+++ b/net/bluetooth/msft.h
@@ -20,8 +20,7 @@ void msft_do_close(struct hci_dev *hdev);
 void msft_vendor_evt(struct hci_dev *hdev, void *data, struct sk_buff *skb);
 __u64 msft_get_features(struct hci_dev *hdev);
 int msft_add_monitor_pattern(struct hci_dev *hdev, struct adv_monitor *monitor);
-int msft_remove_monitor(struct hci_dev *hdev, struct adv_monitor *monitor,
-			u16 handle);
+int msft_remove_monitor(struct hci_dev *hdev, struct adv_monitor *monitor);
 void msft_req_add_set_filter_enable(struct hci_request *req, bool enable);
 int msft_set_filter_enable(struct hci_dev *hdev, bool enable);
 int msft_suspend_sync(struct hci_dev *hdev);
@@ -49,8 +48,7 @@ static inline int msft_add_monitor_pattern(struct hci_dev *hdev,
 }
 
 static inline int msft_remove_monitor(struct hci_dev *hdev,
-				      struct adv_monitor *monitor,
-				      u16 handle)
+				      struct adv_monitor *monitor)
 {
 	return -EOPNOTSUPP;
 }
-- 
2.37.0.170.g444d1eabd0-goog

