Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF03A1F3039
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbgFIA5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:57:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728291AbgFHXI4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:08:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 735CF2085B;
        Mon,  8 Jun 2020 23:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657736;
        bh=84y+gW41dURSJi/gdvoDOb2sY4x5qag2jIQ+OeQgv8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XUynSZ2HWhsPfzIukzg3R68sZn+l+CpO6f/KVYplWfYLX+HvtqvDPJchna2c8D125
         2QzU8i0zpw7EdHEeSmqSl0S5VDjyoGw/3y6dsTRPgEVV9EABFlGKJ2iOAhtNgBsewA
         ewJbc848PauumTH1KwhGMPyC5b7rwxkkBt5qhQrI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alain Michaud <alainm@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 126/274] Bluetooth: Adding driver and quirk defs for multi-role LE
Date:   Mon,  8 Jun 2020 19:03:39 -0400
Message-Id: <20200608230607.3361041-126-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alain Michaud <alainm@chromium.org>

[ Upstream commit 220915857e29795ae5ba4222806268b4a99c19c1 ]

This change adds the relevant driver and quirk to allow drivers to
report the le_states as being trustworthy.

This has historically been disabled as controllers did not reliably
support this. In particular, this will be used to relax this condition
for controllers that have been well tested and reliable.

	/* Most controller will fail if we try to create new connections
	 * while we have an existing one in slave role.
	 */
	if (hdev->conn_hash.le_num_slave > 0)
		return NULL;

Signed-off-by: Alain Michaud <alainm@chromium.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c   | 1 +
 include/net/bluetooth/hci.h | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 3bdec42c9612..3d9313c746f3 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -58,6 +58,7 @@ static struct usb_driver btusb_driver;
 #define BTUSB_CW6622		0x100000
 #define BTUSB_MEDIATEK		0x200000
 #define BTUSB_WIDEBAND_SPEECH	0x400000
+#define BTUSB_VALID_LE_STATES   0x800000
 
 static const struct usb_device_id btusb_table[] = {
 	/* Generic Bluetooth USB device */
diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 5f60e135aeb6..25c2e5ee81dc 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -214,6 +214,15 @@ enum {
 	 * This quirk must be set before hci_register_dev is called.
 	 */
 	HCI_QUIRK_WIDEBAND_SPEECH_SUPPORTED,
+
+	/* When this quirk is set, the controller has validated that
+	 * LE states reported through the HCI_LE_READ_SUPPORTED_STATES are
+	 * valid.  This mechanism is necessary as many controllers have
+	 * been seen has having trouble initiating a connectable
+	 * advertisement despite the state combination being reported as
+	 * supported.
+	 */
+	HCI_QUIRK_VALID_LE_STATES,
 };
 
 /* HCI device flags */
-- 
2.25.1

