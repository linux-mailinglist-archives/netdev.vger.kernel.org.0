Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 277F63F2547
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 05:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238139AbhHTD3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 23:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237934AbhHTD3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 23:29:04 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A762C061756
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 20:28:27 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id m66-20020a257145000000b00598282d96ceso2035235ybc.3
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 20:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=PPVWx1bdM2r6k6HCDP6FMLkldqZlCb3M27xZWJhcudQ=;
        b=gJN5GOKfS246dQiqnCnxZvxuC/yXOqjmoGhZvQVQ2BLGma8RRmBU3gem6jqeHf+y4z
         I/L1/iYKjkKHs3cQflrmo/FHJ9ltxCadW1advCtd+c0D0MO6WJiYxV2LjQG6kQoJwOuT
         a5QEMxVkRWM/WDwb4JRs48V0egXca37UP7kdkA3VVU8jxtyw9ApSKkTAGX7G7XdO1Fmw
         nOcFn7JwJbENq4wX3k6NV+rqoZyYqJdwU+kisrl8NmfDj9WaMsgCmC7G55hUQZZW8xEn
         Jr5jt2xH84vG8N5ZXfw5J+6Nd/Z+1lMtP8ZbTqWVwWRVMtRUmbtT4nzDctfNmKFXh45l
         xzAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=PPVWx1bdM2r6k6HCDP6FMLkldqZlCb3M27xZWJhcudQ=;
        b=QZlwM15aUokS6Hcz1x2Eow3QvfNIiOHaKT/65z6FKk9T4bDWorJ5ssa0NB3LW1s08g
         Itmllqh33Kujv7ja+MEtbgibQ/AEVn+hnGBgCn9tc/epGciHj9iKCmIfOi89VYL7CPwQ
         vRrQjrJiMRv44fU4oybxdJ4I2DILhKkRRXCrml3WrM1VRMDTk1fAWe4KDBceqd/QM5oB
         hmZGA+Y0horuDNqCMVKsWpMMRj9b8N3TDXJ34ePEWuGkjYiZXdrA0mZm42lCIbUMq6hW
         ljln7IhY0lWYGpP54gGG01v3+y2AzAaByr1fzrl0f5yVtjv2PWOfMgF6J3t0DwdH3Udi
         PpBw==
X-Gm-Message-State: AOAM530lr13v17LT0tpmDPxqIfr4m5q/q1AdJ9aTw7oboZwm8gYBgNNU
        8ytxjF0P7u77BDWblCyZJ/W5c3vxkM6AWA==
X-Google-Smtp-Source: ABdhPJzCh/1CY9NFlmYEsuZDv3AWwnW88JmxfsBsDibcRNOWieWtPeEac36CDQ+YgoLoeoCGd7Zv1ubtLBAIMA==
X-Received: from mmandlik.mtv.corp.google.com ([2620:15c:202:201:f6f9:890a:ebc2:929c])
 (user=mmandlik job=sendgmr) by 2002:a25:cec6:: with SMTP id
 x189mr21255905ybe.89.1629430106592; Thu, 19 Aug 2021 20:28:26 -0700 (PDT)
Date:   Thu, 19 Aug 2021 20:28:22 -0700
Message-Id: <20210819202819.v5.1.Id9bc5434114de07512661f002cdc0ada8b3d6d02@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH v5] Bluetooth: Keep MSFT ext info throughout a hci_dev's life cycle
From:   Manish Mandlik <mmandlik@google.com>
To:     marcel@holtmann.org, luiz.dentz@gmail.com
Cc:     Archie Pusaka <apusaka@chromium.org>,
        linux-bluetooth@vger.kernel.org,
        Alain Michaud <alainm@chromium.org>,
        chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Manish Mandlik <mmandlik@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miao-chen Chou <mcchou@chromium.org>

This moves msft_do_close() from hci_dev_do_close() to
hci_unregister_dev() to avoid clearing MSFT extension info. This also
re-reads MSFT info upon every msft_do_open() even if MSFT extension has
been initialized.

The following test steps were performed.
(1) boot the test device and verify the MSFT support debug log in syslog
(2) restart bluetoothd and verify msft_do_close() doesn't get invoked
    and msft_do_open re-reads the MSFT support.

Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Reviewed-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Alain Michaud <alainm@chromium.org>
Signed-off-by: Manish Mandlik <mmandlik@google.com>
---

Changes in v5:
- Rebase on ToT and remove extra blank line

Changes in v4:
- Re-read the MSFT data instead of skipping if it's initiated already

Changes in v3:
- Remove the accepted commits from the series

 net/bluetooth/hci_core.c |  3 ++-
 net/bluetooth/msft.c     | 20 +++++++++++++++++---
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index fb296478b86e..681c6dabb550 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1798,7 +1798,6 @@ int hci_dev_do_close(struct hci_dev *hdev)
 	hci_sock_dev_event(hdev, HCI_DEV_DOWN);
 
 	aosp_do_close(hdev);
-	msft_do_close(hdev);
 
 	if (hdev->flush)
 		hdev->flush(hdev);
@@ -4026,6 +4025,8 @@ void hci_unregister_dev(struct hci_dev *hdev)
 		cancel_work_sync(&hdev->suspend_prepare);
 	}
 
+	msft_do_close(hdev);
+
 	hci_dev_do_close(hdev);
 
 	if (!test_bit(HCI_INIT, &hdev->flags) &&
diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index b4bfae41e8a5..c2568e93598a 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -184,16 +184,30 @@ static void reregister_monitor_on_restart(struct hci_dev *hdev, int handle)
 
 void msft_do_open(struct hci_dev *hdev)
 {
-	struct msft_data *msft;
+	struct msft_data *msft = NULL;
 
 	if (hdev->msft_opcode == HCI_OP_NOP)
 		return;
 
 	bt_dev_dbg(hdev, "Initialize MSFT extension");
 
-	msft = kzalloc(sizeof(*msft), GFP_KERNEL);
-	if (!msft)
+	/* If MSFT data exists, reset its members */
+	if (hdev->msft_data) {
+		msft = hdev->msft_data;
+		hdev->msft_data = NULL;
+
+		msft->features = 0;
+		kfree(msft->evt_prefix);
+		msft->evt_prefix = NULL;
+		msft->evt_prefix_len = 0;
+	} else {
+		msft = kzalloc(sizeof(*msft), GFP_KERNEL);
+	}
+
+	if (!msft) {
+		bt_dev_err(hdev, "Failed to init MSFT extension");
 		return;
+	}
 
 	if (!read_supported_features(hdev, msft)) {
 		kfree(msft);
-- 
2.33.0.rc2.250.ged5fa647cd-goog

