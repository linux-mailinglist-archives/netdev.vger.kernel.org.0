Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADA86B79D
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 09:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729983AbfGQHtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 03:49:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49723 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729686AbfGQHtq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 03:49:46 -0400
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1hneh5-00033d-5M; Wed, 17 Jul 2019 07:49:43 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     johannes.berg@intel.com, emmanuel.grumbach@intel.com,
        luciano.coelho@intel.com, marcel@holtmann.org,
        johan.hedberg@gmail.com
Cc:     linuxwifi@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH v2 3/3] iwlwifi: Load firmware exclusively for Intel WiFi
Date:   Wed, 17 Jul 2019 15:49:20 +0800
Message-Id: <20190717074920.21624-3-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190717074920.21624-1-kai.heng.feng@canonical.com>
References: <20190717074920.21624-1-kai.heng.feng@canonical.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To avoid the firmware loading race between Bluetooth and WiFi on Intel
8260, load firmware exclusively when BT_INTEL is enabled.

BugLink: https://bugs.launchpad.net/bugs/1832988

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
v2:
 - Add bug report link.
 - Rebase on latest wireless-next.

 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 37 ++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 602c31b3992a..e10ff847b216 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -72,6 +72,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/module.h>
 #include <linux/wait.h>
+#include <linux/intel-wifi-bt.h>
 
 #include "iwl-drv.h"
 #include "iwl-trans.h"
@@ -1335,6 +1336,10 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 	bool hw_rfkill;
 	int ret;
 
+#if IS_ENABLED(CONFIG_BT_INTEL)
+	void (*firmware_lock_func)(void);
+	void (*firmware_unlock_func)(void);
+#endif
 	/* This may fail if AMT took ownership of the device */
 	if (iwl_pcie_prepare_card_hw(trans)) {
 		IWL_WARN(trans, "Exit HW not ready\n");
@@ -1394,6 +1399,7 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 	 * RF-Kill switch is toggled, we will find out after having loaded
 	 * the firmware and return the proper value to the caller.
 	 */
+
 	iwl_enable_fw_load_int(trans);
 
 	/* really make sure rfkill handshake bits are cleared */
@@ -1401,8 +1407,37 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 	iwl_write32(trans, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
 
 	/* Load the given image to the HW */
-	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_8000)
+	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_8000) {
+#if IS_ENABLED(CONFIG_BT_INTEL)
+		firmware_lock_func = symbol_request(btintel_firmware_lock);
+		firmware_unlock_func = symbol_request(btintel_firmware_unlock);
+		if (!firmware_lock_func || !firmware_unlock_func) {
+			if (firmware_lock_func) {
+				symbol_put(btintel_firmware_lock);
+				firmware_lock_func = NULL;
+			}
+
+			if (firmware_unlock_func) {
+				symbol_put(btintel_firmware_unlock);
+				firmware_unlock_func = NULL;
+			}
+		}
+
+		if (firmware_lock_func)
+			firmware_lock_func();
+#endif
 		ret = iwl_pcie_load_given_ucode_8000(trans, fw);
+
+#if IS_ENABLED(CONFIG_BT_INTEL)
+		if (firmware_unlock_func) {
+			firmware_unlock_func();
+			symbol_put(btintel_firmware_lock);
+			firmware_lock_func = NULL;
+			symbol_put(btintel_firmware_unlock);
+			firmware_unlock_func = NULL;
+		}
+#endif
+	}
 	else
 		ret = iwl_pcie_load_given_ucode(trans, fw);
 
-- 
2.17.1

