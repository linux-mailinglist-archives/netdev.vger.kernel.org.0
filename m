Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8190A323D2C
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 14:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbhBXNFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 08:05:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:55392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235525AbhBXM63 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 07:58:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3074764EFA;
        Wed, 24 Feb 2021 12:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171150;
        bh=tKBofiDtxn2HpZhFBDa1gf7NKEt9xht1Qo7VvokpgYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AK02RyIJ6aOX77ikosK7w+d6WzF5FrDKp+O1/WlZEif0XGEAJr0FpYunW7WFkjO0g
         uyFDCiTZX0ym8mMoBWe2x4+lRsL5qdkca3nK86FB8DndA+UOCw+pFmwD59Oeg0fFwl
         AMQSivQBy9JnTpZ1SG5J61EwOqPOmm2qGtu4k9ZluVSNOAbW3dzt3d4PrLYXa2CmYW
         BStb8arKea73b3CygbI6zlD7ZWuoDFqb8hTPsL2I1GD5TNTZBguRBK1PY6mCXYv+5O
         k3l3RAgwXSmTkQoGAAfnTt75kdCXRF/Y1Uc4U/CfKS7akNk1am/wl6RUJh+XxUnU79
         viYa6yksnMGzA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 13/56] Bluetooth: Add new HCI_QUIRK_NO_SUSPEND_NOTIFIER quirk
Date:   Wed, 24 Feb 2021 07:51:29 -0500
Message-Id: <20210224125212.482485-13-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125212.482485-1-sashal@kernel.org>
References: <20210224125212.482485-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 219991e6be7f4a31d471611e265b72f75b2d0538 ]

Some devices, e.g. the RTL8723BS bluetooth part, some USB attached devices,
completely drop from the bus on a system-suspend. These devices will
have their driver unbound and rebound on resume (when the dropping of
the bus gets detected) and will show up as a new HCI after resume.

These devices do not benefit from the suspend / resume handling work done
by the hci_suspend_notifier. At best this unnecessarily adds some time to
the suspend/resume time. But this may also actually cause problems, if the
code doing the driver unbinding runs after the pm-notifier then the
hci_suspend_notifier code will try to talk to a device which is now in
an uninitialized state.

This commit adds a new HCI_QUIRK_NO_SUSPEND_NOTIFIER quirk which allows
drivers to opt-out of the hci_suspend_notifier when they know beforehand
that their device will be fully re-initialized / reprobed on resume.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h |  8 ++++++++
 net/bluetooth/hci_core.c    | 18 +++++++++++-------
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index c8e67042a3b14..6da4b3c5dd55d 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -238,6 +238,14 @@ enum {
 	 * during the hdev->setup vendor callback.
 	 */
 	HCI_QUIRK_BROKEN_ERR_DATA_REPORTING,
+
+	/*
+	 * When this quirk is set, then the hci_suspend_notifier is not
+	 * registered. This is intended for devices which drop completely
+	 * from the bus on system-suspend and which will show up as a new
+	 * HCI after resume.
+	 */
+	HCI_QUIRK_NO_SUSPEND_NOTIFIER,
 };
 
 /* HCI device flags */
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index a8679cc468abc..211062a86a3a8 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3783,10 +3783,12 @@ int hci_register_dev(struct hci_dev *hdev)
 	hci_sock_dev_event(hdev, HCI_DEV_REG);
 	hci_dev_hold(hdev);
 
-	hdev->suspend_notifier.notifier_call = hci_suspend_notifier;
-	error = register_pm_notifier(&hdev->suspend_notifier);
-	if (error)
-		goto err_wqueue;
+	if (!test_bit(HCI_QUIRK_NO_SUSPEND_NOTIFIER, &hdev->quirks)) {
+		hdev->suspend_notifier.notifier_call = hci_suspend_notifier;
+		error = register_pm_notifier(&hdev->suspend_notifier);
+		if (error)
+			goto err_wqueue;
+	}
 
 	queue_work(hdev->req_workqueue, &hdev->power_on);
 
@@ -3821,9 +3823,11 @@ void hci_unregister_dev(struct hci_dev *hdev)
 
 	cancel_work_sync(&hdev->power_on);
 
-	hci_suspend_clear_tasks(hdev);
-	unregister_pm_notifier(&hdev->suspend_notifier);
-	cancel_work_sync(&hdev->suspend_prepare);
+	if (!test_bit(HCI_QUIRK_NO_SUSPEND_NOTIFIER, &hdev->quirks)) {
+		hci_suspend_clear_tasks(hdev);
+		unregister_pm_notifier(&hdev->suspend_notifier);
+		cancel_work_sync(&hdev->suspend_prepare);
+	}
 
 	hci_dev_do_close(hdev);
 
-- 
2.27.0

