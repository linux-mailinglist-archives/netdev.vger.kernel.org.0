Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6B826D320
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 07:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgIQFbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 01:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbgIQFaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 01:30:01 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524FEC06174A
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 22:30:00 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id a2so797648qkg.19
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 22:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=7nkg26OctKifdMOC9ynUWWxtGcGNDDYGKPUOkQnY3w4=;
        b=U8+7NojOYti39Ndb55+oUUZODqy28ZqLq7usV9TXykszcGEUcIaGxINuFHmsczZGR7
         y3wcHneEG/GwcGYsVuZMKJ+g9s0sobZain0ZpNeEFZSTsEnGN0pzzxhPMQ91tuiK/Nup
         9WDvmOCD3KN87jlt8fRKIkSIjWrAoNOmpr8qgqhh8bagUQFzGsKXIm/d9isNsvnlgfpg
         7k5JtoN2e3/t7abbv2N93nlK2oM1cH9K2AHDBwBrL/6i0dC/NVGtO1Ud1U3EULXSdAwz
         7Ki8K6qrbYU7amPKnroGPJbyzTbgWoQrn3oFgmtWFzphOboIuE1mAKVwaABQj7YiDt5X
         ZsgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7nkg26OctKifdMOC9ynUWWxtGcGNDDYGKPUOkQnY3w4=;
        b=VWc9U6pZoV0WOvoJQBckRV1HkZjuhQRHbSh+Cxu+70LeY70JdNIu2duosqoIzupo+W
         eHBPcFM0hwzh6txJpo04/rWAt5JYjTNHG7eVyv5hbsHARXazhLaCwlD6y3zDN1h1r0p/
         V2JdupIFrIeb7gQTCTp+bkEDeXMkeo6ZtGa/Ur1gvw/mpQx8H+VvMrZqreOzRpHTxY4D
         TVmvPgIpWb4JD+7jqhO5wi41w6ik8QBYut23IqhF8hUb4IGhskULVfrLrQq4KCNAgPf+
         OLN4rdtX51yEm5iI+ypuviuGv6H6uAJXnvezdhHiXy+XqPRAULu6ywb18pga81YyrSDJ
         XKkA==
X-Gm-Message-State: AOAM531DVmPIm56gQ7TqNa3Gg5GFt9jgWZq54vkPjaXvuH0gMnRi1Hr3
        vd3ZJSKm4kfwpT3SPwGkkfT6eishZwDTFDf/vw==
X-Google-Smtp-Source: ABdhPJx9ZmYekTuJ/BhlyqGQ4czVqNMFjtGq/Gk82PXi4hOOI1yccVgQZUa5Uncin2WGcIFeqGQy/QNzj8A0cEkccA==
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:a0c:e0c3:: with SMTP id
 x3mr10242050qvk.43.1600320599505; Wed, 16 Sep 2020 22:29:59 -0700 (PDT)
Date:   Thu, 17 Sep 2020 13:29:41 +0800
In-Reply-To: <20200917132836.BlueZ.1.I27ef2a783d8920c147458639f3fa91b69f6fd9ea@changeid>
Message-Id: <20200917132836.BlueZ.4.I3774a8f0d748c7c6ec3402c4adcead32810c9164@changeid>
Mime-Version: 1.0
References: <20200917132836.BlueZ.1.I27ef2a783d8920c147458639f3fa91b69f6fd9ea@changeid>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [BlueZ PATCH 4/6] Bluetooth: Handle system suspend resume case
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org
Cc:     mcchou@chromium.org, marcel@holtmann.org, mmandlik@chromium.org,
        howardchung@google.com, luiz.dentz@gmail.com, alainm@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds code to handle the system suspension during interleave
scan. The interleave scan will be canceled when the system is going to
sleep, and will be restarted after waking up.

Signed-off-by: Howard Chung <howardchung@google.com>
Reviewed-by: Alain Michaud <alainm@chromium.org>
Reviewed-by: Manish Mandlik <mmandlik@chromium.org>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
---

 net/bluetooth/hci_request.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 89443b48d90ce..d9082019b6386 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -1081,6 +1081,9 @@ void hci_req_add_le_passive_scan(struct hci_request *req)
 		filter_policy |= 0x02;
 
 	if (hdev->suspended) {
+		/* Block suspend notifier on response */
+		set_bit(SUSPEND_SCAN_ENABLE, hdev->suspend_tasks);
+
 		window = hdev->le_scan_window_suspend;
 		interval = hdev->le_scan_int_suspend;
 	} else if (hci_is_le_conn_scanning(hdev)) {
@@ -1167,10 +1170,8 @@ static void hci_req_config_le_suspend_scan(struct hci_request *req)
 		hci_req_add_le_scan_disable(req, false);
 
 	/* Configure params and enable scanning */
-	hci_req_add_le_passive_scan(req);
+	__hci_update_background_scan(req);
 
-	/* Block suspend notifier on response */
-	set_bit(SUSPEND_SCAN_ENABLE, req->hdev->suspend_tasks);
 }
 
 static void cancel_adv_timeout(struct hci_dev *hdev)
@@ -1282,8 +1283,10 @@ void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
 		hci_req_add(&req, HCI_OP_WRITE_SCAN_ENABLE, 1, &page_scan);
 
 		/* Disable LE passive scan if enabled */
-		if (hci_dev_test_flag(hdev, HCI_LE_SCAN))
+		if (hci_dev_test_flag(hdev, HCI_LE_SCAN)) {
+			cancel_interleave_scan(hdev);
 			hci_req_add_le_scan_disable(&req, false);
+		}
 
 		/* Mark task needing completion */
 		set_bit(SUSPEND_SCAN_DISABLE, hdev->suspend_tasks);
-- 
2.28.0.618.gf4bc123cb7-goog

