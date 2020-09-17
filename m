Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0D626D71C
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 10:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgIQItR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 04:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726471AbgIQIre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 04:47:34 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE729C06178C
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 01:47:33 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id ic18so685334pjb.3
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 01:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=FNIQ4TwzUmm1KHmokSEwCEB+0kpJ2JKM9cy2f0sja/s=;
        b=msz2NcBEHBn4//yvvlA9BvhRf9AbMQ4vFBBmV31mMDu/xsybwVA8JKpGL8YwGWRTkK
         C9dMyGQvzuutz7TlFpLoA/NBVj2arKtETcrRIRgihU50mn/CbHx1GuXnNSXeQZToOvKr
         YfRth3WHQ5gRXi3M9OmExnLIummqxyxMu0WVTQtHleO6IvGYoT/6KrbRB23ajEqNSYlt
         uwvdVtyB7wgxutDSPNaNMOR1uZ9qjBusTRqcHREfQEbW9EdmF75ccCe/O0rTbmVKNA+L
         yyMcvXj3zUc1QNX3ERlxjWJfytcDFCAJAYvEwPhE7O8YXBuY/PGfqTB10LGtUyzhK/r0
         aTsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FNIQ4TwzUmm1KHmokSEwCEB+0kpJ2JKM9cy2f0sja/s=;
        b=J2hwDmqvVmIr40Kv1OeaongqmJoIeFQemJEf18j5pDMhH/PJk3co/+2/taQz4TSu97
         1Ze6clkrpyI04I/vQGbq54aTnn9827nXmiDNMRyZn5HdwaaWlWgnNIu8RHp5qpY7IX90
         9U1CwhU+5ZDtoh5F7unIV0wx8cFFnrHEW1zlcNy2LSi8Zh5EcDTAKEzTGIlpY9I4q4YY
         lYHkQpUuwpJxpGATAP6mHYW5UeOyYjN/xTVxeotRKW/ieCcvs8d588DIAvHUn2vU6UHv
         OcfK7RUkEJqc0o2El9sdjHmR7VfH/IkbRUfjJRagHuG9gNWhwwcHIAKIfHLz1ulh27gu
         m+SA==
X-Gm-Message-State: AOAM5330L93itMtXs4gJYu6p0OYQV9bbdpIJBKXd4YBt+4Ooc0UABvw9
        H12Dv3099mJl+9c+oNQmO2jyi7dHb9bw/Z3TdA==
X-Google-Smtp-Source: ABdhPJyZ5zr8aCmSNqrsGqhZ7eOqE5l90QCLj+GHKNbZg3/YWweber23RTxxs6jdmYjWgzSEI1Z9EfXTAg39J3fMNw==
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:a17:90b:941:: with SMTP id
 dw1mr715085pjb.1.1600332452758; Thu, 17 Sep 2020 01:47:32 -0700 (PDT)
Date:   Thu, 17 Sep 2020 16:47:13 +0800
In-Reply-To: <20200917164632.BlueZ.v2.1.I27ef2a783d8920c147458639f3fa91b69f6fd9ea@changeid>
Message-Id: <20200917164632.BlueZ.v2.4.I3774a8f0d748c7c6ec3402c4adcead32810c9164@changeid>
Mime-Version: 1.0
References: <20200917164632.BlueZ.v2.1.I27ef2a783d8920c147458639f3fa91b69f6fd9ea@changeid>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [BlueZ PATCH v2 4/6] Bluetooth: Handle system suspend resume case
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org
Cc:     marcel@holtmann.org, luiz.dentz@gmail.com, mmandlik@chromium.org,
        mcchou@chromium.org, howardchung@google.com, alainm@chromium.org,
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

(no changes since v1)

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

