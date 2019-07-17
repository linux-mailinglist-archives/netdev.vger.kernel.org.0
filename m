Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 889246B798
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 09:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729583AbfGQHto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 03:49:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49717 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727019AbfGQHtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 03:49:42 -0400
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1hneh0-00033M-P2; Wed, 17 Jul 2019 07:49:39 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     johannes.berg@intel.com, emmanuel.grumbach@intel.com,
        luciano.coelho@intel.com, marcel@holtmann.org,
        johan.hedberg@gmail.com
Cc:     linuxwifi@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH v2 2/3] Bluetooth: btusb: Load firmware exclusively for Intel BT
Date:   Wed, 17 Jul 2019 15:49:19 +0800
Message-Id: <20190717074920.21624-2-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190717074920.21624-1-kai.heng.feng@canonical.com>
References: <20190717074920.21624-1-kai.heng.feng@canonical.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To avoid the firmware loading race between Bluetooth and WiFi on Intel
8260, load firmware exclusively when IWLWIFI is enabled.

BugLink: https://bugs.launchpad.net/bugs/1832988

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
v2:
 - Add bug report link.
 - Rebase on latest wireless-next.

 drivers/bluetooth/btusb.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 50aed5259c2b..ca7a5757a2ba 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2272,8 +2272,16 @@ static int btusb_setup_intel_new(struct hci_dev *hdev)
 
 	set_bit(BTUSB_DOWNLOADING, &data->flags);
 
+#if IS_ENABLED(CONFIG_IWLWIFI)
+	btintel_firmware_lock();
+#endif
+
 	/* Start firmware downloading and get boot parameter */
 	err = btintel_download_firmware(hdev, fw, &boot_param);
+
+#if IS_ENABLED(CONFIG_IWLWIFI)
+	btintel_firmware_unlock();
+#endif
 	if (err < 0)
 		goto done;
 
-- 
2.17.1

