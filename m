Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E20CE2A00C2
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 10:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbgJ3JIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 05:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbgJ3JIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 05:08:42 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62340C0613CF
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 02:08:42 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id e16so4212023pgm.1
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 02:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=y9r4BIYxJa4WnGbQ9pgMMQmBboczCy4Fi2w4BB7yPfI=;
        b=sO+NFzSuWYNKtwk3TsEE9K//jXOLQIeOGSB3EphRYpAtYk4KafmJqX5E9bQtt3CUia
         Zd9u/HnxqrG0OMkjBLYnNRnxiaDUVwFGyzsJn1xwL0h14En3ZQhdrfh3EwAEyoBVkRKM
         NGVrzGeCX+k4HplS3NrRPkRbmYa7Sfy5rUsjT5fJg2NDLSsmp3C696OMe2Di22AzOzRF
         796mRXdfWW4/4NVaDU5BrI6WN71CknoJwqt+1olsnaqiSJ/Br367X9YL0pMTcJ+U9fdW
         0e5UnP1E80pmFPK8dST2aeDDJpDASFaUeh5kWRyG2JKn2Xh6ZE20RmVwTGFfwWcdh8nv
         KLMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=y9r4BIYxJa4WnGbQ9pgMMQmBboczCy4Fi2w4BB7yPfI=;
        b=ukM6olk5vTHGAGqe/8kAMx71HdE5GI05Ce3dtxtMLgtOYjNKDI6Gv81LbDKwoh3fvL
         kHiiM/qw5HjiUPhFmjgy35Um0qTq1+tCprMCtJYKubHLqnFKcX9TGmDRG+WmE6DJX0Iy
         4fIKtYIcYaeijdKeLcJrx3NrbxTxhZjnTiEDF8rRzcdyTDUIphtFesUY8/6rcywR4w3R
         EesUiSJaq47yMpMQs1tJwcbBBAt5ZlazLykAd3b/X1zEhuuTXCrROsuLthETlYCa/eUj
         6+ZVj2Y865eq9+ZhV6zN5pH007rTiqvwgYZPjUVNziLtHg6YxHXxNzWvhRfFwEHuUUDZ
         UYtg==
X-Gm-Message-State: AOAM530FIRcv0E0l5klZv67m+TOZm18S281oncUMhLxDcHpqUUYHEudp
        YOjQEJ3R0SUKBRqFMl6LwsYLWJmy0BrnGiI1eQ==
X-Google-Smtp-Source: ABdhPJxw8+JnHM8cyQFea4nh/jbPrP8p85vdA9LnuWxX0qx0KGToUI00j3Jw/lYQ+3stUSj25WTQLCjamZ4jVpK3Ag==
Sender: "howardchung via sendgmr" 
        <howardchung@howardchung-p920.tpe.corp.google.com>
X-Received: from howardchung-p920.tpe.corp.google.com ([2401:fa00:1:10:f693:9fff:fef4:4e45])
 (user=howardchung job=sendgmr) by 2002:a17:90b:f85:: with SMTP id
 ft5mr345340pjb.1.1604048921633; Fri, 30 Oct 2020 02:08:41 -0700 (PDT)
Date:   Fri, 30 Oct 2020 17:08:24 +0800
In-Reply-To: <20201030163529.v6.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
Message-Id: <20201030163529.v6.2.I3774a8f0d748c7c6ec3402c4adcead32810c9164@changeid>
Mime-Version: 1.0
References: <20201030163529.v6.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
X-Mailer: git-send-email 2.29.1.341.ge80a0c044ae-goog
Subject: [PATCH v6 2/5] Bluetooth: Handle system suspend resume case
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     alainm@chromium.org, mmandlik@chromium.orgi, mcchou@chromium.org,
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

Commit-changes 5:
- Remove the change in hci_req_config_le_suspend_scan

Signed-off-by: Howard Chung <howardchung@google.com>
Reviewed-by: Alain Michaud <alainm@chromium.org>
Reviewed-by: Manish Mandlik <mmandlik@chromium.org>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
---

(no changes since v1)

 net/bluetooth/hci_request.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 70ea126f56282..b615b981be9d6 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -1284,8 +1284,10 @@ void hci_req_prepare_suspend(struct hci_dev *hdev, enum suspended_state next)
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
2.29.1.341.ge80a0c044ae-goog

