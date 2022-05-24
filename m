Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5363B533242
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 22:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241462AbiEXUOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 16:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241452AbiEXUOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 16:14:33 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E2684A0A
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 13:14:30 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id g7-20020a5b0707000000b0064f39e75da4so13565162ybq.17
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 13:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=21cS6HrQlto5xKVBaRyielngkbD0PbPrl0cGSh2e7BE=;
        b=VVa8TWwbnWP3kVBlGBWhzeLb1P+zhQIoAx3I1uI5oV5drao02Vtq2WN65Hq9Trsnfv
         FDqkv0aNyxOqGee0MwC1kQ5KPR1qhJtQYMTLVIaZRjBCEvSg3pwDnEl4j7j9l5c4uo1E
         iNWRCuihAWFvP/vZZ5M4AGcTanLYNduxuIaLINLlN/795cHxqpQrm8Po6C063XYtgWtZ
         u+f3QtWVXCEC5gsZQ9eXiot5jt8A8z2q3oQiHZZ8vViZ61iqXUTXNe6fhvXu7HUxeLcz
         BRRZE+PUJM9ZwqDajBr5wUP/G6+haBU0pylaBBzo9PLnPQ111KHKetiKBRM0dWJ1vNEf
         FUYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=21cS6HrQlto5xKVBaRyielngkbD0PbPrl0cGSh2e7BE=;
        b=KuYu8KZmDcSyZ99R95VjjldC/YcBw9S6OdpCFo8HG3q1+RyOuOzYPtLQwpGawKJO80
         znZLOGHaAnckiC1vIpNa26OM32vROFY+285P9vl1IDPgYcropx2WNFTpJMxliyQRlFh3
         m1Di7n2dM4OUhXIKo/1rtLzvyvw5l+ElKQ9A6rLtCKgc6jFOkc/4w5ohfJZA/K2PHhNr
         TcEyXgV8eA/PPN4TD+PDrruKZWEWRWrS9GlzCto7zNJoIO9Fv8t+3YKhoUjKwXd1pwI1
         c54IFiTPGEe0SbsE4VHnjfCeeTQnK/g4TCqDGuTgYfCVPzHc420MDqOqCHgIrzi0YLBO
         gG4Q==
X-Gm-Message-State: AOAM532rwSlnwAbdShg8htrw3RU97tLzNeyti+aeW25EDFkJA3IgW67q
        eq9+cAQF0Q7vq51ZDgX8kMQ2P/2ud6VZwA==
X-Google-Smtp-Source: ABdhPJz8WHwRNrKCBAec4wIS6xJuhRvYSntcxbf8ukckt6s2KLWTDq+JRpmXuPe8tDBm55b9pipVIHust5tv6Q==
X-Received: from mmandlik.mtv.corp.google.com ([2620:15c:202:201:867d:d253:fd17:d811])
 (user=mmandlik job=sendgmr) by 2002:a5b:302:0:b0:64b:a20a:fcd9 with SMTP id
 j2-20020a5b0302000000b0064ba20afcd9mr27418093ybp.492.1653423269940; Tue, 24
 May 2022 13:14:29 -0700 (PDT)
Date:   Tue, 24 May 2022 13:14:25 -0700
In-Reply-To: <20220524131406.1.If745ed1d05d98c002fc84ba60cef99eb786b7caa@changeid>
Message-Id: <20220524131407.2.Id703da51f33c425056a1148b91468dd6b06429b3@changeid>
Mime-Version: 1.0
References: <20220524131406.1.If745ed1d05d98c002fc84ba60cef99eb786b7caa@changeid>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH 2/2] Bluetooth: hci_sync: Refactor remove Adv Monitor
From:   Manish Mandlik <mmandlik@google.com>
To:     marcel@holtmann.org, luiz.dentz@gmail.com
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org,
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of hci_cmd_sync_queue for removing an advertisement monitor.

Signed-off-by: Manish Mandlik <mmandlik@google.com>
Reviewed-by: Miao-chen Chou <mcchou@google.com>
---

 include/net/bluetooth/hci_core.h |  6 +--
 net/bluetooth/hci_core.c         | 87 ++++++++++----------------------
 net/bluetooth/mgmt.c             | 67 ++++++------------------
 net/bluetooth/msft.c             | 87 +++++++-------------------------
 net/bluetooth/msft.h             |  6 +--
 5 files changed, 63 insertions(+), 190 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 59953a7a6328..7a1e48d794ea 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1410,10 +1410,9 @@ bool hci_adv_instance_is_scannable(struct hci_dev *hdev, u8 instance);
 
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
 
@@ -1873,7 +1872,6 @@ void mgmt_advertising_removed(struct sock *sk, struct hci_dev *hdev,
 			      u8 instance);
 void mgmt_adv_monitor_removed(struct hci_dev *hdev, u16 handle);
 int mgmt_phy_configuration_changed(struct hci_dev *hdev, struct sock *skip);
-int mgmt_remove_adv_monitor_complete(struct hci_dev *hdev, u8 status);
 void mgmt_adv_monitor_device_lost(struct hci_dev *hdev, u16 handle,
 				  bdaddr_t *bdaddr, u8 addr_type);
 
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index bbbbe3203130..c233844a3fc4 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1873,11 +1873,6 @@ void hci_free_adv_monitor(struct hci_dev *hdev, struct adv_monitor *monitor)
 	kfree(monitor);
 }
 
-int hci_remove_adv_monitor_complete(struct hci_dev *hdev, u8 status)
-{
-	return mgmt_remove_adv_monitor_complete(hdev, status);
-}
-
 /* Assigns handle to a monitor, and if offloading is supported and power is on,
  * also attempts to forward the request to the controller.
  */
@@ -1927,92 +1922,64 @@ int hci_add_adv_monitor(struct hci_dev *hdev, struct adv_monitor *monitor)
 
 /* Attempts to tell the controller and free the monitor. If somehow the
  * controller doesn't have a corresponding handle, remove anyway.
- * Returns true if request is forwarded (result is pending), false otherwise.
- * This function requires the caller holds hdev->lock.
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
-		goto free_monitor;
+		hci_free_adv_monitor(hdev, monitor);
+		bt_dev_dbg(hdev, "%s remove monitor %d status %d", hdev->name,
+			   monitor->handle, status);
+		break;
+
 	case HCI_ADV_MONITOR_EXT_MSFT:
-		*err = msft_remove_monitor(hdev, monitor, handle);
+		hci_req_sync_lock(hdev);
+		status = msft_remove_monitor(hdev, monitor);
+		hci_req_sync_unlock(hdev);
+		bt_dev_dbg(hdev, "%s remove monitor %d msft status %d",
+			   hdev->name, monitor->handle, status);
 		break;
 	}
 
-	/* In case no matching handle registered, just free the monitor */
-	if (*err == -ENOENT)
-		goto free_monitor;
-
-	return (*err == 0);
-
-free_monitor:
-	if (*err == -ENOENT)
+	if (status == -ENOENT)
 		bt_dev_warn(hdev, "Removing monitor with no matching handle %d",
 			    monitor->handle);
-	hci_free_adv_monitor(hdev, monitor);
 
-	*err = 0;
-	return false;
+	return status;
 }
 
-/* Returns true if request is forwarded (result is pending), false otherwise.
- * This function requires the caller holds hdev->lock.
- */
-bool hci_remove_single_adv_monitor(struct hci_dev *hdev, u16 handle, int *err)
+int hci_remove_single_adv_monitor(struct hci_dev *hdev, u16 handle)
 {
 	struct adv_monitor *monitor = idr_find(&hdev->adv_monitors_idr, handle);
-	bool pending;
-
-	if (!monitor) {
-		*err = -EINVAL;
-		return false;
-	}
 
-	pending = hci_remove_adv_monitor(hdev, monitor, handle, err);
-	if (!*err && !pending)
-		hci_update_passive_scan(hdev);
-
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
index d04f90698a87..12d91cd87ff0 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4839,37 +4839,6 @@ static int add_adv_patterns_monitor_rssi(struct sock *sk, struct hci_dev *hdev,
 	return status;
 }
 
-int mgmt_remove_adv_monitor_complete(struct hci_dev *hdev, u8 status)
-{
-	struct mgmt_rp_remove_adv_monitor rp;
-	struct mgmt_cp_remove_adv_monitor *cp;
-	struct mgmt_pending_cmd *cmd;
-	int err = 0;
-
-	hci_dev_lock(hdev);
-
-	cmd = pending_find(MGMT_OP_REMOVE_ADV_MONITOR, hdev);
-	if (!cmd)
-		goto done;
-
-	cp = cmd->param;
-	rp.monitor_handle = cp->monitor_handle;
-
-	if (!status)
-		hci_update_passive_scan(hdev);
-
-	err = mgmt_cmd_complete(cmd->sk, cmd->index, cmd->opcode,
-				mgmt_status(status), &rp, sizeof(rp));
-	mgmt_pending_remove(cmd);
-
-done:
-	hci_dev_unlock(hdev);
-	bt_dev_dbg(hdev, "remove monitor %d complete, status %u",
-		   rp.monitor_handle, status);
-
-	return err;
-}
-
 static int remove_adv_monitor(struct sock *sk, struct hci_dev *hdev,
 			      void *data, u16 len)
 {
@@ -4877,11 +4846,7 @@ static int remove_adv_monitor(struct sock *sk, struct hci_dev *hdev,
 	struct mgmt_rp_remove_adv_monitor rp;
 	struct mgmt_pending_cmd *cmd;
 	u16 handle = __le16_to_cpu(cp->monitor_handle);
-	int err, status;
-	bool pending;
-
-	BT_DBG("request for %s", hdev->name);
-	rp.monitor_handle = cp->monitor_handle;
+	int err, status = MGMT_STATUS_SUCCESS;
 
 	hci_dev_lock(hdev);
 
@@ -4897,15 +4862,19 @@ static int remove_adv_monitor(struct sock *sk, struct hci_dev *hdev,
 		goto unlock;
 	}
 
+	hci_dev_unlock(hdev);
+
 	if (handle)
-		pending = hci_remove_single_adv_monitor(hdev, handle, &err);
+		err = hci_remove_single_adv_monitor(hdev, handle);
 	else
-		pending = hci_remove_all_adv_monitor(hdev, &err);
+		err = hci_remove_all_adv_monitor(hdev);
 
-	if (err) {
-		mgmt_pending_remove(cmd);
+	hci_dev_lock(hdev);
+
+	mgmt_pending_remove(cmd);
 
-		if (err == -ENOENT)
+	if (err) {
+		if (err == -ENOENT || err == -EINVAL)
 			status = MGMT_STATUS_INVALID_INDEX;
 		else
 			status = MGMT_STATUS_FAILED;
@@ -4913,19 +4882,13 @@ static int remove_adv_monitor(struct sock *sk, struct hci_dev *hdev,
 		goto unlock;
 	}
 
-	/* monitor can be removed without forwarding request to controller */
-	if (!pending) {
-		mgmt_pending_remove(cmd);
-		hci_dev_unlock(hdev);
-
-		return mgmt_cmd_complete(sk, hdev->id,
-					 MGMT_OP_REMOVE_ADV_MONITOR,
-					 MGMT_STATUS_SUCCESS,
-					 &rp, sizeof(rp));
-	}
+	rp.monitor_handle = cp->monitor_handle;
+	hci_update_passive_scan(hdev);
 
 	hci_dev_unlock(hdev);
-	return 0;
+
+	return mgmt_cmd_complete(sk, hdev->id, MGMT_OP_REMOVE_ADV_MONITOR,
+				 MGMT_STATUS_SUCCESS, &rp, sizeof(rp));
 
 unlock:
 	hci_dev_unlock(hdev);
diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index 9abea16c4305..0d3378e707db 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -106,9 +106,6 @@ struct msft_data {
 	__u8 filter_enabled;
 };
 
-static int __msft_remove_monitor(struct hci_dev *hdev,
-				 struct adv_monitor *monitor, u16 handle);
-
 bool msft_monitor_supported(struct hci_dev *hdev)
 {
 	return !!(msft_get_features(hdev) & MSFT_FEATURE_MASK_LE_ADV_MONITOR);
@@ -264,20 +261,16 @@ static int msft_le_monitor_advertisement_cb(struct hci_dev *hdev, u16 opcode,
 	return status;
 }
 
-static void msft_le_cancel_monitor_advertisement_cb(struct hci_dev *hdev,
-						    u8 status, u16 opcode,
-						    struct sk_buff *skb)
+static int msft_le_cancel_monitor_advertisement_cb(struct hci_dev *hdev,
+						   u16 opcode,
+						   struct sk_buff *skb)
 {
 	struct msft_cp_le_cancel_monitor_advertisement *cp;
 	struct msft_rp_le_cancel_monitor_advertisement *rp;
 	struct adv_monitor *monitor;
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
@@ -285,6 +278,10 @@ static void msft_le_cancel_monitor_advertisement_cb(struct hci_dev *hdev,
 		goto done;
 	}
 
+	status = rp->status;
+	if (status)
+		goto done;
+
 	hci_dev_lock(hdev);
 
 	cp = hci_sent_cmd_data(hdev, hdev->msft_opcode);
@@ -312,26 +309,10 @@ static void msft_le_cancel_monitor_advertisement_cb(struct hci_dev *hdev,
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
 
 static int msft_remove_monitor_sync(struct hci_dev *hdev,
@@ -340,13 +321,14 @@ static int msft_remove_monitor_sync(struct hci_dev *hdev,
 	struct msft_cp_le_cancel_monitor_advertisement cp;
 	struct msft_monitor_advertisement_handle_data *handle_data;
 	struct sk_buff *skb;
-	u8 status;
 
 	handle_data = msft_find_handle_data(hdev, monitor->handle, true);
 
 	/* If no matched handle, just remove without telling controller */
-	if (!handle_data)
+	if (!handle_data) {
+		hci_free_adv_monitor(hdev, monitor);
 		return -ENOENT;
+	}
 
 	cp.sub_opcode = MSFT_OP_LE_CANCEL_MONITOR_ADVERTISEMENT;
 	cp.handle = handle_data->msft_handle;
@@ -356,13 +338,8 @@ static int msft_remove_monitor_sync(struct hci_dev *hdev,
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
+						       skb);
 }
 
 /* This function requires the caller holds hci_req_sync_lock */
@@ -821,38 +798,8 @@ int msft_add_monitor_pattern(struct hci_dev *hdev, struct adv_monitor *monitor)
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
 
@@ -862,7 +809,7 @@ int msft_remove_monitor(struct hci_dev *hdev, struct adv_monitor *monitor,
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
2.36.1.124.g0e6072fb45-goog

