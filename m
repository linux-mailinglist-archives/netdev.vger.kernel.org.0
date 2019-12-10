Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D784A1198A3
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729817AbfLJVdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:33:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:38168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729785AbfLJVdk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:33:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22827207FF;
        Tue, 10 Dec 2019 21:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013619;
        bh=VU0r/1dwObPA/iBY5BuKPXL3uDNx9KftXifGIMKgdKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KTRv4MSNilkqYDSDd74c68GkIxIo+D69xLd+rmRr4jMOiERHk95zBtebPS5QaIlSl
         M8RN8dWMthyAXjuZUEX2geiZ0bBWZBg5obytpjSpr1XCz5Rwg7RXeryTj7hk7i3HDM
         QPtchkXqZe15l0ZKwgSXF8RD7Habywwq9NwkbK3Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mattijs Korpershoek <mkorpershoek@baylibre.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 064/177] Bluetooth: hci_core: fix init for HCI_USER_CHANNEL
Date:   Tue, 10 Dec 2019 16:30:28 -0500
Message-Id: <20191210213221.11921-64-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mattijs Korpershoek <mkorpershoek@baylibre.com>

[ Upstream commit eb8c101e28496888a0dcfe16ab86a1bee369e820 ]

During the setup() stage, HCI device drivers expect the chip to
acknowledge its setup() completion via vendor specific frames.

If userspace opens() such HCI device in HCI_USER_CHANNEL [1] mode,
the vendor specific frames are never tranmitted to the driver, as
they are filtered in hci_rx_work().

Allow HCI devices which operate in HCI_USER_CHANNEL mode to receive
frames if the HCI device is is HCI_INIT state.

[1] https://www.spinics.net/lists/linux-bluetooth/msg37345.html

Fixes: 23500189d7e0 ("Bluetooth: Introduce new HCI socket channel for user operation")
Signed-off-by: Mattijs Korpershoek <mkorpershoek@baylibre.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index e0de9a609265a..e03faca84919e 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -4330,7 +4330,14 @@ static void hci_rx_work(struct work_struct *work)
 			hci_send_to_sock(hdev, skb);
 		}
 
-		if (hci_dev_test_flag(hdev, HCI_USER_CHANNEL)) {
+		/* If the device has been opened in HCI_USER_CHANNEL,
+		 * the userspace has exclusive access to device.
+		 * When device is HCI_INIT, we still need to process
+		 * the data packets to the driver in order
+		 * to complete its setup().
+		 */
+		if (hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
+		    !test_bit(HCI_INIT, &hdev->flags)) {
 			kfree_skb(skb);
 			continue;
 		}
-- 
2.20.1

