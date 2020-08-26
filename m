Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B43253A3C
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 00:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgHZW0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 18:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbgHZW0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 18:26:46 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B155C061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 15:26:46 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id n3so1651753pjq.1
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 15:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PkRfetQcp2SyPXpao4+ZMmtYtLe8fTRZhlCz7rJNi6U=;
        b=Z8h3jmnpWF7n+FdysrKDsbSu7wBGc3eoFbM9dho9msL4PB9dDMXlpeV0H31eSQU1b5
         r3Aa61QUvEgghcmBcRl7X0J61lByqkSl+w6XEBC6D9t5MhDazODWG9IPN4xaXe/bqFz8
         qBNNeC18oZI1SgMDRENNkDP44pLgtiWwwXtr4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PkRfetQcp2SyPXpao4+ZMmtYtLe8fTRZhlCz7rJNi6U=;
        b=V9J31pvCYNRBVX6g2Krpjgri718xFzKTB/UodFQYkAY+bVjx9IfUK9+Ut/56+fJwfU
         cv7qrGtmHPh4qdh/8InJcFh6wSxF20ZC9sfEvBbKPgLFoffmOatQvg6/HtZPzLMSXC/9
         lyU6g1wSjaGFr7q8rSD0vjdh2w411tGLQDOf8ebmBG84TEiydNzMFAkdQtySaCLQQppQ
         jxojbdW6XlczuwqVncj12Ij2EN1be9+vB7y6tWCYdhUrOAnKw2zxEPJYH51H7RJrAhcl
         9v6+DeGsoRpUYksDIkhWjkvnMjJ+mcO/EY1lwHmwRkOTzyT9QayIJGN5/0EcRC9P4w5E
         EL0Q==
X-Gm-Message-State: AOAM533CfL1yzm+rGXpm4HLrQhfCLJQdzbKYldwHVGmjyFyyd80Mylxu
        r4yiOv/j5XRdwsV/0cO5P45DiwKfcch7gg==
X-Google-Smtp-Source: ABdhPJwtq/aSnkaRCd+AVsIZIusn3TQlRtKEGYCH0S1le5PKTs+SyjZKUXXLlrqQjBHKw/Nd6anXZg==
X-Received: by 2002:a17:90b:3ce:: with SMTP id go14mr2017340pjb.162.1598480805822;
        Wed, 26 Aug 2020 15:26:45 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:7220:84ff:fe09:2b94])
        by smtp.gmail.com with ESMTPSA id x19sm204076pfq.43.2020.08.26.15.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 15:26:45 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, linux-bluetooth@vger.kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] Bluetooth: Clear suspend tasks on unregister
Date:   Wed, 26 Aug 2020 15:26:39 -0700
Message-Id: <20200826152623.1.I24fb6cc377d03d64d74f83cec748afd12ee33e37@changeid>
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While unregistering, make sure to clear the suspend tasks before
cancelling the work. If the unregister is called during resume from
suspend, this will unnecessarily add 2s to the resume time otherwise.

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
---
This was discovered with RT8822CE using the btusb driver. This chipset
will reset on resume during system suspend and was unnecessarily adding
2s to every resume. Since we're unregistering anyway, there's no harm in
just clearing the pending events.

 net/bluetooth/hci_core.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 68bfe57b66250f..ed4cb3479433c0 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3442,6 +3442,16 @@ void hci_copy_identity_address(struct hci_dev *hdev, bdaddr_t *bdaddr,
 	}
 }
 
+static void hci_suspend_clear_tasks(struct hci_dev *hdev)
+{
+	int i;
+
+	for (i = 0; i < __SUSPEND_NUM_TASKS; ++i)
+		clear_bit(i, hdev->suspend_tasks);
+
+	wake_up(&hdev->suspend_wait_q);
+}
+
 static int hci_suspend_wait_event(struct hci_dev *hdev)
 {
 #define WAKE_COND                                                              \
@@ -3785,6 +3795,7 @@ void hci_unregister_dev(struct hci_dev *hdev)
 	cancel_work_sync(&hdev->power_on);
 
 	unregister_pm_notifier(&hdev->suspend_notifier);
+	hci_suspend_clear_tasks(hdev);
 	cancel_work_sync(&hdev->suspend_prepare);
 
 	hci_dev_do_close(hdev);
-- 
2.28.0.297.g1956fa8f8d-goog

