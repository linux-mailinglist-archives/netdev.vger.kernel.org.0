Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337BC2DCCE2
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 08:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgLQHSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 02:18:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbgLQHSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 02:18:24 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA60C0617A7
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 23:17:44 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id e2so19700113pgi.5
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 23:17:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TEO3/oQXoRDhA5Aynf5tOUBOZITapi4dUktMPWEGVZE=;
        b=ndhZNq/pSBaAgASPaZht6Nko7YjlzT6/xcqnnYlTyx6Yzm41/zdeDh2EXZOVRR8jOU
         L6jYs1DdTbipR0GET9I8bg6eOds5218HKB8ugQgwO1v0QJMjeVeuIy4L8tiJN5v56VcL
         9jW6pcdLX16EGoR01wxXTe2H4BP6IELYAp5gg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TEO3/oQXoRDhA5Aynf5tOUBOZITapi4dUktMPWEGVZE=;
        b=T3lFVR3Ger5xjGa4VB2zyZY16BXPO2QGSf16zH6OpOxlqR1PEt11eyRc87Rw248LBU
         QtS6JE9ta4xGWxcvka0/kevBxVmaAtWXXyCJ7yb6y3ITgzmse2acsi3y2bIh+Y0jEp5B
         +VMtlykDQbJy/8l8tGnqHMXAzPQqLfONj0fmnfbMeAQUzMPrEk8ZjR7PkmIYVbcQKLRG
         MyLOLfLKZa9scdCndmTXS6S+nZAyuVBu608MFCsGfTdYK3VFzd/Z1CIcdcZLnfuE1AZC
         ruGNWBtFA8M5/EytAGM6xhN5Xh5jkAHao0RB+Vf8guaezuZKYdqm6BkJMOmAObT0pVzl
         pC9Q==
X-Gm-Message-State: AOAM533EC4QKht7PGVz90HrbV9olYtowZ9UI59Lycm8N247gIVM6HP3R
        ie1H2zQTWJrXEohojXCGO+UowA==
X-Google-Smtp-Source: ABdhPJyfnhMZrex/tPAF6iMu7BaBNlY7Znatxxe8jrhqGqXY7JjT4xdxaIdYGm2/h8qhP/AaVc152g==
X-Received: by 2002:a62:1716:0:b029:19d:b78b:ef02 with SMTP id 22-20020a6217160000b029019db78bef02mr8043307pfx.11.1608189463855;
        Wed, 16 Dec 2020 23:17:43 -0800 (PST)
Received: from localhost ([2620:15c:202:201:de4a:3eff:fe75:1314])
        by smtp.gmail.com with ESMTPSA id q26sm4723632pfl.219.2020.12.16.23.17.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Dec 2020 23:17:43 -0800 (PST)
From:   Miao-chen Chou <mcchou@chromium.org>
To:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>
Cc:     Alain Michaud <alainm@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Miao-chen Chou <mcchou@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v1 1/4] Bluetooth: Keep MSFT extension info throughout a hci_dev's life cycle
Date:   Wed, 16 Dec 2020 23:17:27 -0800
Message-Id: <20201216231652.v1.1.Id9bc5434114de07512661f002cdc0ada8b3d6d02@changeid>
X-Mailer: git-send-email 2.29.2.684.gfbc64c5ab5-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This moves msft_do_close() from hci_dev_do_close() to
hci_unregister_dev() to avoid clearing MSFT extension info. This also
avoids retrieving MSFT info upon every msft_do_open() if MSFT extension
has been initialized.

The following test steps were performed.
(1) boot the test device and verify the MSFT support debug log in syslog
(2) restart bluetoothd and verify msft_do_close() doesn't get invoked

Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Reviewed-by: Archie Pusaka <apusaka@chromium.org>
---

 net/bluetooth/hci_core.c | 4 ++--
 net/bluetooth/msft.c     | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 9d2c9a1c552fd..8471be105a2ac 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1780,8 +1780,6 @@ int hci_dev_do_close(struct hci_dev *hdev)
 
 	hci_sock_dev_event(hdev, HCI_DEV_DOWN);
 
-	msft_do_close(hdev);
-
 	if (hdev->flush)
 		hdev->flush(hdev);
 
@@ -3869,6 +3867,8 @@ void hci_unregister_dev(struct hci_dev *hdev)
 	unregister_pm_notifier(&hdev->suspend_notifier);
 	cancel_work_sync(&hdev->suspend_prepare);
 
+	msft_do_close(hdev);
+
 	hci_dev_do_close(hdev);
 
 	if (!test_bit(HCI_INIT, &hdev->flags) &&
diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
index 4b39534a14a18..d9d2269bc93ef 100644
--- a/net/bluetooth/msft.c
+++ b/net/bluetooth/msft.c
@@ -76,7 +76,8 @@ void msft_do_open(struct hci_dev *hdev)
 {
 	struct msft_data *msft;
 
-	if (hdev->msft_opcode == HCI_OP_NOP)
+	/* Skip if opcode is not supported or MSFT has been initiatlized */
+	if (hdev->msft_opcode == HCI_OP_NOP || hdev->msft_data)
 		return;
 
 	bt_dev_dbg(hdev, "Initialize MSFT extension");
-- 
2.29.2.684.gfbc64c5ab5-goog

