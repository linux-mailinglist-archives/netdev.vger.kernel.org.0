Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8842F26F438
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 05:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730750AbgIRDM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 23:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbgIRDMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 23:12:32 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A235C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 20:12:32 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id k3so4030792ybk.16
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 20:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=Yq3AQHq0oby0gIEHvauwatHEbFOs+SQiwBq1B7FgTKo=;
        b=FWdnEbfoGFaKXpZHbnLC++79ZWY3a7aRIGxG2mH67sZoVYWZUYC4LcK2SJ2r8mq1IJ
         VN2fUkJ7EQnVl0TGDlhk3EWmIVC8FNtBt131mk65HSsyaCqmFj2XZ3dx837bKYLSTtTp
         KtiAl342ruTWqRQ7YjBWAyaixJN58jS/f+4kUhS9myHZl3p8TUEXUSbz/sbUF+agMq4K
         AAnNYh38Oh55uQbs3TtQ8IPZ8BVtJXVDqpmGk4u/rYTKeSVCH75gVy+RagaTyIrGQjPV
         ZQEzNtygW+Md++DGU88mU1D+gYeda6um7diigCHcmmmMcm3ee2Ge+VsOqtQCdC+PnjvA
         d8xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Yq3AQHq0oby0gIEHvauwatHEbFOs+SQiwBq1B7FgTKo=;
        b=HwVlVoUjkbZVIAWLb5toazT8LNZfWkqiu8lqYH7ifcD1hglixKMr/Q/QLmcoakLa3u
         l8+zHtafLxWeNOIzDJHmHal2wm4GpqdiY6OOP8Xf/tBOlY6hk/gS5oumX0F6wqDIetpO
         I3HORKMx69AR84uiB3SM3zRs7JYHsncSjV0sE4O+jAWWiKP6Qt2nuCtaXIdzwJSVjcc4
         kZLUdINpZ3R31NGKG0B9A872FZlhPeZy+9Jz/noCnHTcSM0nBn8oPFzu6LbuCprjoPUp
         roIoIycVflixPKlOj6KkGvzKkUBum6jlHjQ1g3BE0axqCaHE/wDRSpZFpScroUhU6+X7
         DNyA==
X-Gm-Message-State: AOAM533eLjghIEJ/9D/pPyEViXu3wAv34JGNqivzLHguddwgJ+Ymc/A5
        /x4MjlY8eA4OW8hohtNr6zwSjkuw4MgrvOe1VQ==
X-Google-Smtp-Source: ABdhPJxpXqOdPBoIYXkioBEuMajlBbzI5RIYR8yLeXTdm8sYgj7Z8KPEw60I7kFQuiavazH6jfQ/uumb1tiOo/5KnA==
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:a5b:3d2:: with SMTP id
 t18mr42152587ybp.333.1600398751314; Thu, 17 Sep 2020 20:12:31 -0700 (PDT)
Date:   Fri, 18 Sep 2020 11:11:51 +0800
In-Reply-To: <20200918111110.v3.1.I27ef2a783d8920c147458639f3fa91b69f6fd9ea@changeid>
Message-Id: <20200918111110.v3.4.I3774a8f0d748c7c6ec3402c4adcead32810c9164@changeid>
Mime-Version: 1.0
References: <20200918111110.v3.1.I27ef2a783d8920c147458639f3fa91b69f6fd9ea@changeid>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v3 4/6] Bluetooth: Handle system suspend resume case
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org
Cc:     howardchung@google.com, luiz.dentz@gmail.com, marcel@holtmann.org,
        mcchou@chromium.org, mmandlik@chromium.org, alainm@chromium.org,
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
2.28.0.681.g6f77f65b4e-goog

