Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE643E5273
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 06:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235466AbhHJEyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 00:54:47 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:52434
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231329AbhHJEyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 00:54:46 -0400
Received: from localhost.localdomain (1.general.khfeng.us.vpn [10.172.68.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id F38503F10F;
        Tue, 10 Aug 2021 04:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628571263;
        bh=5r4dLAsVk9DJOAlbYOUdKsSk8hgd3Xvb6spEiyz/nvw=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=o/WpuF7GGzjkbQD+05kTc8H78Yfmov9dSV9XYvZN99t/OCwUZGBxv7TMBgm+deEVj
         +gwSWzGYXWgxzqNQdsQqmj4guAiIqzgc/EDmUfhuV2GCsVO5AT5Oto1r1seSvCaeUd
         95oq0X5gSViUFVEj9T7DD5L4kB33ZS4rz3AjmAjKsmUtQx47WbgfDwOrexH630LPo8
         8692wW5Rx/p1E20AYLL9fPGfLqDiUBcFOMErlRHR7bIilrToqzcBdKmz3M6YRlw++y
         pUKifGHn76IcbVc+dsfmLycB1QpEQIG3MTXjaJBAuHfiXexkt87oyNMy2yzY2Z3hqG
         ZzyPBLB7+YR1Q==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Mattijs Korpershoek <mkorpershoek@baylibre.com>,
        Hsin-Yi Wang <hsinyi@chromium.org>,
        Guenter Roeck <linux@roeck-us.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth@vger.kernel.org (open list:BLUETOOTH SUBSYSTEM),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] Bluetooth: Move shutdown callback before flushing tx and rx queue
Date:   Tue, 10 Aug 2021 12:53:15 +0800
Message-Id: <20210810045315.184383-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 0ea9fd001a14 ("Bluetooth: Shutdown controller after workqueues
are flushed or cancelled") introduced a regression that makes mtkbtsdio
driver stops working:
[   36.593956] Bluetooth: hci0: Firmware already downloaded
[   46.814613] Bluetooth: hci0: Execution of wmt command timed out
[   46.814619] Bluetooth: hci0: Failed to send wmt func ctrl (-110)

The shutdown callback depends on the result of hdev->rx_work, so we
should call it before flushing rx_work:
-> btmtksdio_shutdown()
 -> mtk_hci_wmt_sync()
  -> __hci_cmd_send()
   -> wait for BTMTKSDIO_TX_WAIT_VND_EVT gets cleared

-> btmtksdio_recv_event()
 -> hci_recv_frame()
  -> queue_work(hdev->workqueue, &hdev->rx_work)
   -> clears BTMTKSDIO_TX_WAIT_VND_EVT

So move the shutdown callback before flushing TX/RX queue to resolve the
issue.

Reported-and-tested-by: Mattijs Korpershoek <mkorpershoek@baylibre.com>
Tested-by: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Fixes: 0ea9fd001a14 ("Bluetooth: Shutdown controller after workqueues are flushed or cancelled")
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
v2: 
 Move the shutdown callback before clearing HCI_UP, otherwise 1)
 shutdown callback won't be called and 2) other routines that depend on
 HCI_UP won't work.

 net/bluetooth/hci_core.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index cb2e9e513907..8622da2d9395 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1727,6 +1727,14 @@ int hci_dev_do_close(struct hci_dev *hdev)
 	hci_request_cancel_all(hdev);
 	hci_req_sync_lock(hdev);
 
+	if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
+	    !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
+	    test_bit(HCI_UP, &hdev->flags)) {
+		/* Execute vendor specific shutdown routine */
+		if (hdev->shutdown)
+			hdev->shutdown(hdev);
+	}
+
 	if (!test_and_clear_bit(HCI_UP, &hdev->flags)) {
 		cancel_delayed_work_sync(&hdev->cmd_timer);
 		hci_req_sync_unlock(hdev);
@@ -1798,14 +1806,6 @@ int hci_dev_do_close(struct hci_dev *hdev)
 		clear_bit(HCI_INIT, &hdev->flags);
 	}
 
-	if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
-	    !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
-	    test_bit(HCI_UP, &hdev->flags)) {
-		/* Execute vendor specific shutdown routine */
-		if (hdev->shutdown)
-			hdev->shutdown(hdev);
-	}
-
 	/* flush cmd  work */
 	flush_work(&hdev->cmd_work);
 
-- 
2.31.1

