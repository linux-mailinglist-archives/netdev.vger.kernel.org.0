Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5BBE2719D8
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 06:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbgIUEX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 00:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbgIUEXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 00:23:25 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC90AC061755
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 21:23:24 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id z12so8140291qvp.11
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 21:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=Yq3AQHq0oby0gIEHvauwatHEbFOs+SQiwBq1B7FgTKo=;
        b=LKoEVcaLu9J1s6MC0b/XU0LBbNUgQCSb9C/Gu8Ngkvh1qchoHOqiUZeTCvxbqADEEr
         8HN4+XPGK92MEZgQ6pSijf3ZPuTuV8ue9rmc3lNM27s8n2j9068gHzZP7rN7yIf33RAk
         84MSu6m5JkR8bblDYVXxwMtsHBGVFxcBBHdk/JErR8jcdJxefVt1JtNeK7Q/0JittbhG
         Mgcral7UzED8/qt0+UpJuVFSx2gtT5q62w4wCpMjCGVcNrPmM3ZWRReeuGOh2AEbjl8F
         hCa1RY+SwLDjb0Q+8hUzatNLFYnhWnIMo635KhiILGh0M54/aWO8g4FrsXe+7KEkSrjP
         9Dxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Yq3AQHq0oby0gIEHvauwatHEbFOs+SQiwBq1B7FgTKo=;
        b=FSqe/krZ8elf/h1gaMKg79bYBK/RzVvgIHZZitU0Va87Zl+9thGxD1+r6US7ADYkp7
         ZY3tN3g3KRvzM5m3DJYn+Kaooxry2xOy4VJMLqZ6NUYLBWFz2VMRJe1NVLroDD3ONc3D
         5ks3WAX9uvirF2PeecF+ieF8+tTkVLzGbt24EJvCt1fnPx5NB5UBegGB0y6fKoKdz8Qp
         +BU1cIOJ44fB2DH93noHSvb48FODcRf+X9eOWsM1XZyNAZyt2WwgJ67U72Y8qZsZAXf6
         hIgJBC31yB+SLbJpdzTHhyITxUzU5qJwtkNFw1pTWSa9IrUjX38fIFadpSp5W+7INCP/
         jBeQ==
X-Gm-Message-State: AOAM532XrDZWu+MHfACBOhmAJac75UIXLWv/bN3SMVvVEvJcinBioEXz
        zYE3p0N1D7k5TruWTs/CHO3208VkGa3X50Lmmw==
X-Google-Smtp-Source: ABdhPJwXym3Sd1aSSPHJkyGYexID/m6rqleizJLZo+K6wjMy6lVl1Yw6hCwfp6/l28NUN8/ovKMkGGJCwzOk6pE85g==
Sender: "howardchung via sendgmr" 
        <howardchung@howardchung-p920.tpe.corp.google.com>
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:ad4:58e3:: with SMTP id
 di3mr28838122qvb.54.1600662203923; Sun, 20 Sep 2020 21:23:23 -0700 (PDT)
Date:   Mon, 21 Sep 2020 12:23:06 +0800
In-Reply-To: <20200921122216.v4.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
Message-Id: <20200921122216.v4.2.I3774a8f0d748c7c6ec3402c4adcead32810c9164@changeid>
Mime-Version: 1.0
References: <20200921122216.v4.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v4 2/4] Bluetooth: Handle system suspend resume case
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     alainm@chromium.org, mcchou@chromium.org, mmandlik@chromium.orgi,
        Howard Chung <howardchung@google.com>,
        Manish Mandlik <mmandlik@chromium.org>,
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

