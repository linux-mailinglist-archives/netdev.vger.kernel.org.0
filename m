Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC6E2E1745
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 04:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731925AbgLWDH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 22:07:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:46354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728302AbgLWCSt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7B1C233EF;
        Wed, 23 Dec 2020 02:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689863;
        bh=9N31VUoxtCbA3sWRfA47S8GWxTfFBTKI3hHsOg4No/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SBNbyx7bw67BlhpxNnf9rfkFwrLW70BduGdHzo8yqSMqLSMO42uX9y5ITuoJ+bgWX
         o5ui1KDsJ34r+/mJS8ze5pkx4X5HjxB9JGB/+2ULEXy9UkXpUaLQcswK88mBtEuXCu
         55s2hu54aJMHeoy6OA3jDetSWbFBjFIWwOiOkAFtYGJh3PZFolkWumivBOUZ8gDrl3
         VZpInIok423MyGuENb7HP0/H3o3z328O2vbvp3U/dTrjbxM+TCoLWpaY9uU2iCToHu
         gLRjQr3TYa/KeaYtEC+9SxiQ9EytAnJ/6IFrDLD4RjwNHObirk8PhaFVnId3HcqKrl
         87YsTva8Owcyg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Winkler <danielwinkler@google.com>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 059/217] Bluetooth: Resume advertising after LE connection
Date:   Tue, 22 Dec 2020 21:13:48 -0500
Message-Id: <20201223021626.2790791-59-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Winkler <danielwinkler@google.com>

[ Upstream commit 2943d8ede38310db932eb38f91aa1094b471058c ]

When an LE connection request is made, advertising is disabled and never
resumed. When a client has an active advertisement, this is disruptive.
This change adds resume logic for client-configured (non-directed)
advertisements after the connection attempt.

The patch was tested by registering an advertisement, initiating an LE
connection from a remote peer, and verifying that the advertisement is
re-activated after the connection is established. This is performed on
Hatch and Kukui Chromebooks.

Signed-off-by: Daniel Winkler <danielwinkler@google.com>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c    | 12 ++++++++++--
 net/bluetooth/hci_request.c | 21 ++++++++++++++++-----
 net/bluetooth/hci_request.h |  2 ++
 3 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index d0c1024bf6008..4f1cd8063e720 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -758,6 +758,9 @@ static void create_le_conn_complete(struct hci_dev *hdev, u8 status, u16 opcode)
 
 	conn = hci_lookup_le_connect(hdev);
 
+	if (hdev->adv_instance_cnt)
+		hci_req_resume_adv_instances(hdev);
+
 	if (!status) {
 		hci_connect_le_scan_cleanup(conn);
 		goto done;
@@ -1067,10 +1070,11 @@ struct hci_conn *hci_connect_le(struct hci_dev *hdev, bdaddr_t *dst,
 	 * connections most controllers will refuse to connect if
 	 * advertising is enabled, and for slave role connections we
 	 * anyway have to disable it in order to start directed
-	 * advertising.
+	 * advertising. Any registered advertisements will be
+	 * re-enabled after the connection attempt is finished.
 	 */
 	if (hci_dev_test_flag(hdev, HCI_LE_ADV))
-		 __hci_req_disable_advertising(&req);
+		__hci_req_pause_adv_instances(&req);
 
 	/* If requested to connect as slave use directed advertising */
 	if (conn->role == HCI_ROLE_SLAVE) {
@@ -1118,6 +1122,10 @@ struct hci_conn *hci_connect_le(struct hci_dev *hdev, bdaddr_t *dst,
 	err = hci_req_run(&req, create_le_conn_complete);
 	if (err) {
 		hci_conn_del(conn);
+
+		if (hdev->adv_instance_cnt)
+			hci_req_resume_adv_instances(hdev);
+
 		return ERR_PTR(err);
 	}
 
diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 6f12bab4d2fa6..fdc6eccef9d10 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -1123,9 +1123,9 @@ static void cancel_adv_timeout(struct hci_dev *hdev)
 }
 
 /* This function requires the caller holds hdev->lock */
-static void hci_suspend_adv_instances(struct hci_request *req)
+void __hci_req_pause_adv_instances(struct hci_request *req)
 {
-	bt_dev_dbg(req->hdev, "Suspending advertising instances");
+	bt_dev_dbg(req->hdev, "Pausing advertising instances");
 
 	/* Call to disable any advertisements active on the controller.
 	 * This will succeed even if no advertisements are configured.
@@ -1138,7 +1138,7 @@ static void hci_suspend_adv_instances(struct hci_request *req)
 }
 
 /* This function requires the caller holds hdev->lock */
-static void hci_resume_adv_instances(struct hci_request *req)
+static void __hci_req_resume_adv_instances(struct hci_request *req)
 {
 	struct adv_info *adv;
 
@@ -1161,6 +1161,17 @@ static void hci_resume_adv_instances(struct hci_request *req)
 	}
 }
 
+/* This function requires the caller holds hdev->lock */
+int hci_req_resume_adv_instances(struct hci_dev *hdev)
+{
+	struct hci_request req;
+
+	hci_req_init(&req, hdev);
+	__hci_req_resume_adv_instances(&req);
+
+	return hci_req_run(&req, NULL);
+}
+
 static void suspend_req_complete(struct hci_dev *hdev, u8 status, u16 opcode)
 {
 	bt_dev_dbg(hdev, "Request complete opcode=0x%x, status=0x%x", opcode,
@@ -1214,7 +1225,7 @@ void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
 
 		/* Pause other advertisements */
 		if (hdev->adv_instance_cnt)
-			hci_suspend_adv_instances(&req);
+			__hci_req_pause_adv_instances(&req);
 
 		hdev->advertising_paused = true;
 		hdev->advertising_old_state = old_state;
@@ -1279,7 +1290,7 @@ void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
 
 		/* Resume other advertisements */
 		if (hdev->adv_instance_cnt)
-			hci_resume_adv_instances(&req);
+			__hci_req_resume_adv_instances(&req);
 
 		/* Unpause discovery */
 		hdev->discovery_paused = false;
diff --git a/net/bluetooth/hci_request.h b/net/bluetooth/hci_request.h
index 6a12e84c66c40..39ee8a18087a2 100644
--- a/net/bluetooth/hci_request.h
+++ b/net/bluetooth/hci_request.h
@@ -71,6 +71,8 @@ void hci_req_add_le_passive_scan(struct hci_request *req);
 void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next);
 
 void hci_req_disable_address_resolution(struct hci_dev *hdev);
+void __hci_req_pause_adv_instances(struct hci_request *req);
+int hci_req_resume_adv_instances(struct hci_dev *hdev);
 void hci_req_reenable_advertising(struct hci_dev *hdev);
 void __hci_req_enable_advertising(struct hci_request *req);
 void __hci_req_disable_advertising(struct hci_request *req);
-- 
2.27.0

