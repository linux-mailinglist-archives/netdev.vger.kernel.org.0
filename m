Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C99CA6B794
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 09:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729377AbfGQHti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 03:49:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49711 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727019AbfGQHth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 03:49:37 -0400
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1hnegv-00033E-Hg; Wed, 17 Jul 2019 07:49:34 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     johannes.berg@intel.com, emmanuel.grumbach@intel.com,
        luciano.coelho@intel.com, marcel@holtmann.org,
        johan.hedberg@gmail.com
Cc:     linuxwifi@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH v2 1/3] Bluetooth: btintel: Add firmware lock function
Date:   Wed, 17 Jul 2019 15:49:18 +0800
Message-Id: <20190717074920.21624-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When Intel 8260 starts to load Bluetooth firmware and WiFi firmware, by
calling btintel_download_firmware() and iwl_pcie_load_given_ucode_8000()
respectively, the Bluetooth btintel_download_firmware() aborts half way:
[   11.950216] Bluetooth: hci0: Failed to send firmware data (-38)

Let btusb and iwlwifi load firmwares exclusively can avoid the issue, so
introduce a lock to use in btusb and iwlwifi.

This issue still occurs with latest WiFi and Bluetooth firmwares.

BugLink: https://bugs.launchpad.net/bugs/1832988

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
v2:
 - Add bug report link.
 - Rebase on latest wireless-next.

 drivers/bluetooth/btintel.c   | 14 ++++++++++++++
 drivers/bluetooth/btintel.h   | 10 ++++++++++
 include/linux/intel-wifi-bt.h |  8 ++++++++
 3 files changed, 32 insertions(+)
 create mode 100644 include/linux/intel-wifi-bt.h

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index bb99c8653aab..93ab18d6ddad 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -20,6 +20,8 @@
 
 #define BDADDR_INTEL (&(bdaddr_t) {{0x00, 0x8b, 0x9e, 0x19, 0x03, 0x00}})
 
+static DEFINE_MUTEX(firmware_lock);
+
 int btintel_check_bdaddr(struct hci_dev *hdev)
 {
 	struct hci_rp_read_bd_addr *bda;
@@ -709,6 +711,18 @@ int btintel_download_firmware(struct hci_dev *hdev, const struct firmware *fw,
 }
 EXPORT_SYMBOL_GPL(btintel_download_firmware);
 
+void btintel_firmware_lock(void)
+{
+	mutex_lock(&firmware_lock);
+}
+EXPORT_SYMBOL_GPL(btintel_firmware_lock);
+
+void btintel_firmware_unlock(void)
+{
+	mutex_unlock(&firmware_lock);
+}
+EXPORT_SYMBOL_GPL(btintel_firmware_unlock);
+
 MODULE_AUTHOR("Marcel Holtmann <marcel@holtmann.org>");
 MODULE_DESCRIPTION("Bluetooth support for Intel devices ver " VERSION);
 MODULE_VERSION(VERSION);
diff --git a/drivers/bluetooth/btintel.h b/drivers/bluetooth/btintel.h
index 3d846190f2bf..b3682d27d2ee 100644
--- a/drivers/bluetooth/btintel.h
+++ b/drivers/bluetooth/btintel.h
@@ -87,6 +87,8 @@ int btintel_read_boot_params(struct hci_dev *hdev,
 			     struct intel_boot_params *params);
 int btintel_download_firmware(struct hci_dev *dev, const struct firmware *fw,
 			      u32 *boot_param);
+void btintel_firmware_lock(void);
+void btintel_firmware_unlock(void);
 #else
 
 static inline int btintel_check_bdaddr(struct hci_dev *hdev)
@@ -181,4 +183,12 @@ static inline int btintel_download_firmware(struct hci_dev *dev,
 {
 	return -EOPNOTSUPP;
 }
+
+static inline void btintel_firmware_lock(void)
+{
+}
+
+static inline void btintel_firmware_unlock(void)
+{
+}
 #endif
diff --git a/include/linux/intel-wifi-bt.h b/include/linux/intel-wifi-bt.h
new file mode 100644
index 000000000000..260ed628d19b
--- /dev/null
+++ b/include/linux/intel-wifi-bt.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __INTEL_WIFI_BT_H__
+#define __INTEL_WIFI_BT_H__
+
+void btintel_firmware_lock(void);
+void btintel_firmware_unlock(void);
+
+#endif
-- 
2.17.1

