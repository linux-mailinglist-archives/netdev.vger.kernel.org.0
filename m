Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B24AA1FA513
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 02:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgFPAZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 20:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbgFPAZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 20:25:19 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A838C08C5C5
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 17:25:19 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id b201so8645903pfb.0
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 17:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t7gJ95niPWSsprqAZWceLiTUFn9lWfcF6iU6w7eWkzk=;
        b=QWxNBw/xvbH9OteDbSE+M7EPyVqut54tTqtNHNGohcEhgktCzaN1p9mbbTFLHTENVr
         gSwKFVOrjEbzENvId+TZ/GrvWy+ZeO7viEPIrm9+eCXscmYOro64tTuEDcEIHioeu+Ux
         Uh7MtoO5TeuvY08K4m8fnBnP6/rspdXXwB/6E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t7gJ95niPWSsprqAZWceLiTUFn9lWfcF6iU6w7eWkzk=;
        b=Q8g9Y6wiWi4Ig/lhKgfFj2Vg0MDk5r9TvqwomEtFPNzisbbfMG3LviDp0rEy8VJ8wZ
         Msbyvk6FWByDad3YgDcUly02GN+zuoZ5IpxIpbKpCN5oqiJcOJ4NkFLXsTTwdf0J7hfb
         Cn/KQDiXL3L2I60N1ZUlJBB0GXR8eAfE5KyJ+8RdlJA8Ow0F8Z23/xtd+CzX148HWA8B
         dxk+Q7M0ocT7MavyyMibWhVGQnXyvRPsmpuU3fekUmlgOZQTUH2BOXktQp/7n1a/TL6Z
         55qGscTfcEGgLwKrbr7+yHZVl/TYU1CEnYaJ7dqZ6fUeRqIwTuOQhYvLc5tefZ+NHn3H
         GpDQ==
X-Gm-Message-State: AOAM530sJYhEgsN7aC1Ov0JHUFwspzjmrOtO1s4ShrcZbDpcg623mM0Y
        61hA7Pq5clbnfVkOFlNoX0Z4yw==
X-Google-Smtp-Source: ABdhPJyo9y2QdKAx86ZN1CLcejYPjfzo8XEuzXqcXtp7p9QXDsGT17W5RHX6eeh1YsDRje2rzCn9eg==
X-Received: by 2002:a62:5c03:: with SMTP id q3mr215235pfb.58.1592267118959;
        Mon, 15 Jun 2020 17:25:18 -0700 (PDT)
Received: from mcchou0.mtv.corp.google.com ([2620:15c:202:201:b46:ac84:1014:9555])
        by smtp.gmail.com with ESMTPSA id x2sm14783781pfr.186.2020.06.15.17.25.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jun 2020 17:25:18 -0700 (PDT)
From:   Miao-chen Chou <mcchou@chromium.org>
To:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Alain Michaud <alainm@chromium.org>,
        Yoni Shavit <yshavit@chromium.org>,
        Michael Sun <michaelfsun@google.com>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v5 7/7] Bluetooth: Update background scan and report device based on advertisement monitors
Date:   Mon, 15 Jun 2020 17:25:05 -0700
Message-Id: <20200615172440.v5.7.Id9ca021d5a3e8c748ea5c0a1c81582b9a8183f45@changeid>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200615172440.v5.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
References: <20200615172440.v5.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This calls hci_update_background_scan() when there is any update on the
advertisement monitors. If there is at least one advertisement monitor,
the filtering policy of scan parameters should be 0x00. This also reports
device found mgmt events if there is at least one monitor.

The following cases were tested with btmgmt advmon-* commands.
(1) add a ADV monitor and observe that the passive scanning is
triggered.
(2) remove the last ADV monitor and observe that the passive scanning is
terminated.
(3) with a LE peripheral paired, repeat (1) and observe the passive
scanning continues.
(4) with a LE peripheral paired, repeat (2) and observe the passive
scanning continues.
(5) with a ADV monitor, suspend/resume the host and observe the passive
scanning continues.

Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
---

Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 include/net/bluetooth/hci_core.h |  1 +
 net/bluetooth/hci_core.c         | 13 +++++++++++++
 net/bluetooth/hci_event.c        |  5 +++--
 net/bluetooth/hci_request.c      | 17 ++++++++++++++---
 net/bluetooth/mgmt.c             |  5 ++++-
 5 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 78ac7fd282d77..1ce89e546a64e 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1243,6 +1243,7 @@ void hci_adv_monitors_clear(struct hci_dev *hdev);
 void hci_free_adv_monitor(struct adv_monitor *monitor);
 int hci_add_adv_monitor(struct hci_dev *hdev, struct adv_monitor *monitor);
 int hci_remove_adv_monitor(struct hci_dev *hdev, u16 handle);
+bool hci_is_adv_monitoring(struct hci_dev *hdev);
 
 void hci_event_packet(struct hci_dev *hdev, struct sk_buff *skb);
 
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index d0f30e2e29471..2d318916e9ebc 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3005,6 +3005,8 @@ void hci_adv_monitors_clear(struct hci_dev *hdev)
 		hci_free_adv_monitor(monitor);
 
 	idr_destroy(&hdev->adv_monitors_idr);
+
+	hci_update_background_scan(hdev);
 }
 
 void hci_free_adv_monitor(struct adv_monitor *monitor)
@@ -3038,6 +3040,9 @@ int hci_add_adv_monitor(struct hci_dev *hdev, struct adv_monitor *monitor)
 
 	hdev->adv_monitors_cnt++;
 	monitor->handle = handle;
+
+	hci_update_background_scan(hdev);
+
 	return 0;
 }
 
@@ -3069,9 +3074,17 @@ int hci_remove_adv_monitor(struct hci_dev *hdev, u16 handle)
 		idr_for_each(&hdev->adv_monitors_idr, &free_adv_monitor, hdev);
 	}
 
+	hci_update_background_scan(hdev);
+
 	return 0;
 }
 
+/* This function requires the caller holds hdev->lock */
+bool hci_is_adv_monitoring(struct hci_dev *hdev)
+{
+	return !idr_is_empty(&hdev->adv_monitors_idr);
+}
+
 struct bdaddr_list *hci_bdaddr_list_lookup(struct list_head *bdaddr_list,
 					 bdaddr_t *bdaddr, u8 type)
 {
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index cfeaee347db32..cbcc0b590fd41 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5447,14 +5447,15 @@ static void process_adv_report(struct hci_dev *hdev, u8 type, bdaddr_t *bdaddr,
 
 	/* Passive scanning shouldn't trigger any device found events,
 	 * except for devices marked as CONN_REPORT for which we do send
-	 * device found events.
+	 * device found events, or advertisement monitoring requested.
 	 */
 	if (hdev->le_scan_type == LE_SCAN_PASSIVE) {
 		if (type == LE_ADV_DIRECT_IND)
 			return;
 
 		if (!hci_pend_le_action_lookup(&hdev->pend_le_reports,
-					       bdaddr, bdaddr_type))
+					       bdaddr, bdaddr_type) &&
+		    idr_is_empty(&hdev->adv_monitors_idr))
 			return;
 
 		if (type == LE_ADV_NONCONN_IND || type == LE_ADV_SCAN_IND)
diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 1acf5b8e0910c..d465dbbb1963c 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -418,11 +418,15 @@ static void __hci_update_background_scan(struct hci_request *req)
 	 */
 	hci_discovery_filter_clear(hdev);
 
+	BT_DBG("%s ADV monitoring is %s", hdev->name,
+	       hci_is_adv_monitoring(hdev) ? "on" : "off");
+
 	if (list_empty(&hdev->pend_le_conns) &&
-	    list_empty(&hdev->pend_le_reports)) {
+	    list_empty(&hdev->pend_le_reports) &&
+	    !hci_is_adv_monitoring(hdev)) {
 		/* If there is no pending LE connections or devices
-		 * to be scanned for, we should stop the background
-		 * scanning.
+		 * to be scanned for or no ADV monitors, we should stop the
+		 * background scanning.
 		 */
 
 		/* If controller is not scanning we are done. */
@@ -798,6 +802,13 @@ static u8 update_white_list(struct hci_request *req)
 			return 0x00;
 	}
 
+	/* Once the controller offloading of advertisement monitor is in place,
+	 * the if condition should include the support of MSFT extension
+	 * support.
+	 */
+	if (!idr_is_empty(&hdev->adv_monitors_idr))
+		return 0x00;
+
 	/* Select filter policy to use white list */
 	return 0x01;
 }
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index fed9c17b90dc9..514b1605cc973 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -8437,8 +8437,11 @@ void mgmt_device_found(struct hci_dev *hdev, bdaddr_t *bdaddr, u8 link_type,
 	if (!hci_discovery_active(hdev)) {
 		if (link_type == ACL_LINK)
 			return;
-		if (link_type == LE_LINK && list_empty(&hdev->pend_le_reports))
+		if (link_type == LE_LINK &&
+		    list_empty(&hdev->pend_le_reports) &&
+		    !hci_is_adv_monitoring(hdev)) {
 			return;
+		}
 	}
 
 	if (hdev->discovery.result_filtering) {
-- 
2.26.2

