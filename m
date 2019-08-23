Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6489AD42
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 12:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405287AbfHWKcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 06:32:18 -0400
Received: from vps.xff.cz ([195.181.215.36]:52650 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390768AbfHWKbs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 06:31:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1566556306; bh=67uddpb2R7BIS7IqV2fjba5xXtiX29M8NMIbKWrD2kc=;
        h=From:To:Cc:Subject:Date:References:From;
        b=L/60kFSD7WwXS9H7E3DLRI81r0aV18fY7q8fmCWGjkj3oIRQd/hoiqF95/m22WbX+
         AZq3WKhSwX1Qk9EDEh/UojmpdEkVAuMPiRsANDRdCw+lqBUoiQT+2BgPxDI3gZy2bp
         h4w2bCxkYUOfuL6klEKvWsE7u8o6gfzXrQpaCy5A=
From:   megous@megous.com
To:     Maxime Ripard <mripard@kernel.org>, Chen-Yu Tsai <wens@csie.org>,
        Rob Herring <robh+dt@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, Ondrej Jirman <megous@megous.com>
Subject: [RESEND PATCH 2/5] bluetooth: bcm: Add support for loading firmware for BCM4345C5
Date:   Fri, 23 Aug 2019 12:31:36 +0200
Message-Id: <20190823103139.17687-3-megous@megous.com>
In-Reply-To: <20190823103139.17687-1-megous@megous.com>
References: <20190823103139.17687-1-megous@megous.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

Detect BCM4345C5 and load a corresponding firmware file.

Signed-off-by: Ondrej Jirman <megous@megous.com>
---
Checkpatch reports a spurious error.

 drivers/bluetooth/btbcm.c   | 3 +++
 drivers/bluetooth/hci_bcm.c | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
index 124ef0a3e1dd..2d2e6d862068 100644
--- a/drivers/bluetooth/btbcm.c
+++ b/drivers/bluetooth/btbcm.c
@@ -23,6 +23,7 @@
 #define BDADDR_BCM43430A0 (&(bdaddr_t) {{0xac, 0x1f, 0x12, 0xa0, 0x43, 0x43}})
 #define BDADDR_BCM4324B3 (&(bdaddr_t) {{0x00, 0x00, 0x00, 0xb3, 0x24, 0x43}})
 #define BDADDR_BCM4330B1 (&(bdaddr_t) {{0x00, 0x00, 0x00, 0xb1, 0x30, 0x43}})
+#define BDADDR_BCM4345C5 (&(bdaddr_t) {{0xac, 0x1f, 0x00, 0xc5, 0x45, 0x43}})
 #define BDADDR_BCM43341B (&(bdaddr_t) {{0xac, 0x1f, 0x00, 0x1b, 0x34, 0x43}})
 
 int btbcm_check_bdaddr(struct hci_dev *hdev)
@@ -73,6 +74,7 @@ int btbcm_check_bdaddr(struct hci_dev *hdev)
 	    !bacmp(&bda->bdaddr, BDADDR_BCM2076B1) ||
 	    !bacmp(&bda->bdaddr, BDADDR_BCM4324B3) ||
 	    !bacmp(&bda->bdaddr, BDADDR_BCM4330B1) ||
+	    !bacmp(&bda->bdaddr, BDADDR_BCM4345C5) ||
 	    !bacmp(&bda->bdaddr, BDADDR_BCM43430A0) ||
 	    !bacmp(&bda->bdaddr, BDADDR_BCM43341B)) {
 		bt_dev_info(hdev, "BCM: Using default device address (%pMR)",
@@ -332,6 +334,7 @@ static const struct bcm_subver_table bcm_uart_subver_table[] = {
 	{ 0x2122, "BCM4343A0"	},	/* 001.001.034 */
 	{ 0x2209, "BCM43430A1"  },	/* 001.002.009 */
 	{ 0x6119, "BCM4345C0"	},	/* 003.001.025 */
+	{ 0x6606, "BCM4345C5"	},	/* 003.006.006 */
 	{ 0x230f, "BCM4356A2"	},	/* 001.003.015 */
 	{ 0x220e, "BCM20702A1"  },	/* 001.002.014 */
 	{ 0x4217, "BCM4329B1"   },	/* 002.002.023 */
diff --git a/drivers/bluetooth/hci_bcm.c b/drivers/bluetooth/hci_bcm.c
index 4d9de20bab7b..95c312ae94cf 100644
--- a/drivers/bluetooth/hci_bcm.c
+++ b/drivers/bluetooth/hci_bcm.c
@@ -1419,6 +1419,7 @@ static void bcm_serdev_remove(struct serdev_device *serdev)
 #ifdef CONFIG_OF
 static const struct of_device_id bcm_bluetooth_of_match[] = {
 	{ .compatible = "brcm,bcm20702a1" },
+	{ .compatible = "brcm,bcm4345c5" },
 	{ .compatible = "brcm,bcm4330-bt" },
 	{ .compatible = "brcm,bcm43438-bt" },
 	{ },
-- 
2.23.0

