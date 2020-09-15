Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9DB26AF47
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 23:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbgIOVPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 17:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727925AbgIOVOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 17:14:49 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC37C06178A
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 14:14:48 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id x10so4728177ybj.19
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 14:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=K+OfCoM6oTmkFdqxGs+YSyPIFR+NJtTdbrbahx+pi8o=;
        b=Bfbb6PAjFKNPNmBiLhOhqp8uf+5dfGDcVtfLcv83W6I4mmz8leffU/S6ATJ0NoEcAS
         v1VM7hSpryC5Zauqdu6RcvSUTpFZwn0SROVOg8yfdiPto085QZO2xD+JPI0lb5kBTuK5
         sRXkaD5z5MkbrYn2N/Eu/MAMtEUePcvEBd33t7RdW3i4TuR6llHN4ezRrgipgYs2+33i
         IhBVEV/aHL1iMHk7sX1HiMGJVcDCemlIYsORCB84pLS6RjpT6RNH+MlgKDSi2A6p6Bbz
         IKK1p5CaBXGfFWRijvbhUT/GCHri9hZhxul8R6Cm7YmExyGEfivaE0P6MZucOBtoFRX5
         n95g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=K+OfCoM6oTmkFdqxGs+YSyPIFR+NJtTdbrbahx+pi8o=;
        b=k/cHL/W6MIeRCPpRffREmfdpQzi96Ph9JZfufuuJT5wX5GHRuwqaxDR8VkmGZp1wg3
         vl9XRakyKk+0UgKXPke7oIhyeoTomfcpFczpktACSHuWxotI5HGAyr+Ghvx27dIXtIVR
         1WO1Ypd7TU4lnaWuVXNcaP6/wDwBqDaeKtF40y5vPLWZ0GFX/vnI4F27RjFOP8yh09/C
         wk4ST0H752MilySc9OL82rzVH6/cTrCSUZSMHvGmPzxbxJyo1P+gsRMj/WHOVOWewhpU
         bu+WlDT31sVfR2UMQGsKYvlHpa9vTDITjgy7z8OGDTQ6Nsz/2I+QvM9naxn+3oHGZaQu
         Xq/A==
X-Gm-Message-State: AOAM531u7s99PjRhGuno+VyIrt3dT7bVaWt3Rh1ThzBKNJYxUkB/7au9
        CIM0G9Qc1PqtK8rQkxeR3UMehL2tJnlR8K0MPcD0
X-Google-Smtp-Source: ABdhPJyww2+5qPFKot6oq/w5hjYv4FO0/obmugq2VwsJRMK9d8CCeO5bHaloVjkf47P7tieu34FzW1yIWD4tngmvw+TY
X-Received: from danielwinkler-linux.mtv.corp.google.com ([2620:15c:202:201:f693:9fff:fef4:4e59])
 (user=danielwinkler job=sendgmr) by 2002:a25:3783:: with SMTP id
 e125mr8595152yba.423.1600204487979; Tue, 15 Sep 2020 14:14:47 -0700 (PDT)
Date:   Tue, 15 Sep 2020 14:14:27 -0700
Message-Id: <20200915141229.1.Icfac86f8dfa0813bba6c7604c420d11c3820b4ab@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH] Bluetooth: pause/resume advertising around suspend
From:   Daniel Winkler <danielwinkler@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Daniel Winkler <danielwinkler@google.com>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the controller will continue advertising when the system
enters suspend. This patch makes sure that all advertising instances are
paused when entering suspend, and resumed when suspend exits.

The Advertising and Suspend/Resume test suites were both run on this
change on 4.19 kernel with both hardware offloaded multi-advertising and
software rotated multi-advertising. In addition, a new test was added
that performs the following steps:
* Register 3 advertisements via bluez RegisterAdvertisement
* Verify reception of all advertisements by remote peer
* Enter suspend on DUT
* Verify failure to receive all advertisements by remote peer
* Exit suspend on DUT
* Verify reception of all advertisements by remote peer

Signed-off-by: Daniel Winkler <danielwinkler@google.com>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
---

 net/bluetooth/hci_request.c | 67 +++++++++++++++++++++++++++++++------
 1 file changed, 57 insertions(+), 10 deletions(-)

diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index e17bc8a1c66ddd..413e3a5aabf544 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -1111,6 +1111,53 @@ static void hci_req_config_le_suspend_scan(struct hci_request *req)
 	set_bit(SUSPEND_SCAN_ENABLE, req->hdev->suspend_tasks);
 }
 
+static void cancel_adv_timeout(struct hci_dev *hdev)
+{
+	if (hdev->adv_instance_timeout) {
+		hdev->adv_instance_timeout = 0;
+		cancel_delayed_work(&hdev->adv_instance_expire);
+	}
+}
+
+/* This function requires the caller holds hdev->lock */
+static void hci_suspend_adv_instances(struct hci_request *req)
+{
+	bt_dev_dbg(req->hdev, "Suspending advertising instances");
+
+	/* Call to disable any advertisements active on the controller.
+	 * This will succeed even if no advertisements are configured.
+	 */
+	__hci_req_disable_advertising(req);
+
+	/* If we are using software rotation, pause the loop */
+	if (!ext_adv_capable(req->hdev))
+		cancel_adv_timeout(req->hdev);
+}
+
+/* This function requires the caller holds hdev->lock */
+static void hci_resume_adv_instances(struct hci_request *req)
+{
+	struct adv_info *adv;
+
+	bt_dev_dbg(req->hdev, "Resuming advertising instances");
+
+	if (ext_adv_capable(req->hdev)) {
+		/* Call for each tracked instance to be re-enabled */
+		list_for_each_entry(adv, &req->hdev->adv_instances, list) {
+			__hci_req_enable_ext_advertising(req,
+							 adv->instance);
+		}
+
+	} else {
+		/* Schedule for most recent instance to be restarted and begin
+		 * the software rotation loop
+		 */
+		__hci_req_schedule_adv_instance(req,
+						req->hdev->cur_adv_instance,
+						true);
+	}
+}
+
 static void suspend_req_complete(struct hci_dev *hdev, u8 status, u16 opcode)
 {
 	bt_dev_dbg(hdev, "Request complete opcode=0x%x, status=0x%x", opcode,
@@ -1153,7 +1200,7 @@ void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
 		hdev->discovery_paused = true;
 		hdev->discovery_old_state = old_state;
 
-		/* Stop advertising */
+		/* Stop directed advertising */
 		old_state = hci_dev_test_flag(hdev, HCI_ADVERTISING);
 		if (old_state) {
 			set_bit(SUSPEND_PAUSE_ADVERTISING, hdev->suspend_tasks);
@@ -1162,6 +1209,10 @@ void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
 					   &hdev->discov_off, 0);
 		}
 
+		/* Pause other advertisements */
+		if (hdev->adv_instance_cnt)
+			hci_suspend_adv_instances(&req);
+
 		hdev->advertising_paused = true;
 		hdev->advertising_old_state = old_state;
 		/* Disable page scan */
@@ -1212,7 +1263,7 @@ void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
 		/* Reset passive/background scanning to normal */
 		hci_req_config_le_suspend_scan(&req);
 
-		/* Unpause advertising */
+		/* Unpause directed advertising */
 		hdev->advertising_paused = false;
 		if (hdev->advertising_old_state) {
 			set_bit(SUSPEND_UNPAUSE_ADVERTISING,
@@ -1223,6 +1274,10 @@ void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
 			hdev->advertising_old_state = 0;
 		}
 
+		/* Resume other advertisements */
+		if (hdev->adv_instance_cnt)
+			hci_resume_adv_instances(&req);
+
 		/* Unpause discovery */
 		hdev->discovery_paused = false;
 		if (hdev->discovery_old_state != DISCOVERY_STOPPED &&
@@ -2186,14 +2241,6 @@ int __hci_req_schedule_adv_instance(struct hci_request *req, u8 instance,
 	return 0;
 }
 
-static void cancel_adv_timeout(struct hci_dev *hdev)
-{
-	if (hdev->adv_instance_timeout) {
-		hdev->adv_instance_timeout = 0;
-		cancel_delayed_work(&hdev->adv_instance_expire);
-	}
-}
-
 /* For a single instance:
  * - force == true: The instance will be removed even when its remaining
  *   lifetime is not zero.
-- 
2.28.0.618.gf4bc123cb7-goog

