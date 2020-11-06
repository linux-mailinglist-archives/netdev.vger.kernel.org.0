Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F632AA0F1
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 00:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728536AbgKFXUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 18:20:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728031AbgKFXUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 18:20:34 -0500
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84214C0613D2
        for <netdev@vger.kernel.org>; Fri,  6 Nov 2020 15:20:34 -0800 (PST)
Received: by mail-qv1-xf4a.google.com with SMTP id l16so1637412qvt.17
        for <netdev@vger.kernel.org>; Fri, 06 Nov 2020 15:20:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=qCKTIk6ok2nzyOjT+W8oFEMA5y5me/um1ag42Yf+6JI=;
        b=dpcsma2wgTVriYQHC6IHei1h9amIcKsTw4Q/mORO0om4L6LrnXNZMGYqI4hsDl52gX
         RKaCieFlwr49xdQApbYQNOy5YAUii/mDjya1B/vV0nh/Ii7srPCpRK1hQ6YxF8gujFZx
         0JIRJ5MevFVKr9TVW3RMPLIAgaNHL2DuonyqIrv6RM3foOPcr/RTfj1bUl3pHYskMaJw
         lxUCCBzWO3ezRtZE6tvLYv+o+RoPSbbBK7h+0zQYcmH4alNZFHEmIFTk8SCv6k/svgef
         nks7zi6xTsb6DQ/cUp+/goY+worUKmvbETSzcWdXBvkTtjgk1ZTQq5Um/YPkZpKf1dKo
         72xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=qCKTIk6ok2nzyOjT+W8oFEMA5y5me/um1ag42Yf+6JI=;
        b=MxWhrbL1VlDYyLcRu9b/aR1s163d5PraFtdpjK6VeW0+LanU22Dm4s72Q6LrtrYFtt
         GLeGgNtuR05LwoizGfG3TlUuNeiGTHF/igLeiiy/IMPaxiZq09UTM7S5f5/6qr3BKBNC
         mwxm/xSBS3+4s7y1koFSrG11lxv5hjAc/GNA10N9cFaAREG920ST7isWuiKMFA3/SMyH
         v6sXFBAL26Zue1mj2s008je+VTHV8779xDKgatJzU/siUUJyStuxyiXNnc8ArR/USRAX
         IybOiBdGTpfYoFSnYhmv4nNJM9Pr7bb2jn+moltCZL5KNnUymwiQzNK3EPSJchc9Tpwm
         vv7Q==
X-Gm-Message-State: AOAM533bwgfy7g7E7xdHSku2i5EgVqrc9DsSHEvyVMx8wPLihYtQSoNT
        3OR9c9h6UrTIIcLkaxKWWRcX0DzNYeAFcIlgJgHb
X-Google-Smtp-Source: ABdhPJzKUpTPGKEo90bduIJh7AIB7W76777TiJsPZsctXcwbqJ9wLcjlt7quOpcVkxW/faOTr2RuKGm4ksAcmO1ogFmO
Sender: "danielwinkler via sendgmr" 
        <danielwinkler@danielwinkler-linux.mtv.corp.google.com>
X-Received: from danielwinkler-linux.mtv.corp.google.com ([2620:15c:202:201:f693:9fff:fef4:4e59])
 (user=danielwinkler job=sendgmr) by 2002:a05:6214:1787:: with SMTP id
 ct7mr3997641qvb.58.1604704833583; Fri, 06 Nov 2020 15:20:33 -0800 (PST)
Date:   Fri,  6 Nov 2020 15:20:19 -0800
Message-Id: <20201106151937.1.I8362b4cedb0f34b7a88b8dbd3a62155085e02ea7@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.222.g5d2a92d10f8-goog
Subject: [PATCH] Bluetooth: Resume advertising after LE connection
From:   Daniel Winkler <danielwinkler@google.com>
To:     marcel@holtmann.org
Cc:     linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        Daniel Winkler <danielwinkler@google.com>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When an LE connection request is made, advertising is disabled and never
resumed. When a client has an active advertisement, this is disruptive.
This change adds resume logic for client-configured (non-directed)
advertisements after the connection attempt.

The patch was tested by registering an advertisement, initiating an LE
connection from a remote peer, and verifying that the advertisement is
re-activated after the connection is established. This is performed on
Hatch and Kukui Chromebooks.

Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Signed-off-by: Daniel Winkler <danielwinkler@google.com>

---

 net/bluetooth/hci_conn.c    | 12 ++++++++++--
 net/bluetooth/hci_request.c | 21 ++++++++++++++++-----
 net/bluetooth/hci_request.h |  2 ++
 3 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index d0c1024bf60083..4f1cd8063e720a 100644
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
index 6f12bab4d2fa6b..fdc6eccef9d107 100644
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
index 6a12e84c66c404..39ee8a18087a28 100644
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
2.29.2.222.g5d2a92d10f8-goog

