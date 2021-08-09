Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 678B13E4B16
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 19:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234811AbhHIRpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 13:45:04 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:49196
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234821AbhHIRot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 13:44:49 -0400
Received: from localhost.localdomain (1-171-221-113.dynamic-ip.hinet.net [1.171.221.113])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id E04A83F108;
        Mon,  9 Aug 2021 17:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628531052;
        bh=iEu8pX3ziO36ryx3wRkOZPEyw/YMnEi7g0A9wLQ7fqg=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=uFqOjEyOSzWGs9RABUyWVaLle2NxDyK0Y/3sDI7zraOizwLyHI/+VdKvjK1pYw3ib
         zoQgeCJ1QbEaW9Rwfg2iJ+X+d5sCK2ISC4Z3ZLuu6omo+DCsJczQjhUJbZvwU3q7PB
         WVZPYukTzf73a+gQwTpV4VLcw/QnJ3f8dCz++4mKB1zOEZ+t2mbjWga+1B1WKJLIPi
         ju4HB3FVh0xmredvVnO9hV/hdUQExnuAKhv+YmrItROVQNfVwFPwKduMLZ9eGCo05/
         zwFEIZmd6bpbsSyc5FetxiCNPYUqGlggPdJii2T2YtfD9hSB5CjBhfsb1zVc0TJDaD
         lVwzh8iRUPW/w==
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
Subject: [PATCH] Bluetooth: Move shutdown callback before flushing tx and rx queue
Date:   Tue, 10 Aug 2021 01:43:58 +0800
Message-Id: <20210809174358.163525-1-kai.heng.feng@canonical.com>
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
 net/bluetooth/hci_core.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index cb2e9e513907..8da04c899197 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1735,6 +1735,14 @@ int hci_dev_do_close(struct hci_dev *hdev)
 
 	hci_leds_update_powered(hdev, false);
 
+	if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
+	    !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
+	    test_bit(HCI_UP, &hdev->flags)) {
+		/* Execute vendor specific shutdown routine */
+		if (hdev->shutdown)
+			hdev->shutdown(hdev);
+	}
+
 	/* Flush RX and TX works */
 	flush_work(&hdev->tx_work);
 	flush_work(&hdev->rx_work);
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

