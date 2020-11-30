Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7722C9011
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 22:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388576AbgK3VaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 16:30:00 -0500
Received: from mga03.intel.com ([134.134.136.65]:5349 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388554AbgK3VaA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 16:30:00 -0500
IronPort-SDR: YirZ0gadagO6OrC5+LwnvbvdlJj2J7qksPE5gr84EKiX7mA5JeDCXzBVmCDzE9qJA0a+ehiv0w
 MrdsgAsDL6BA==
X-IronPort-AV: E=McAfee;i="6000,8403,9821"; a="172815008"
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="172815008"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 13:29:19 -0800
IronPort-SDR: lfxbpPulktg4jAyAH32NlLE7xaIKZe2cr2bSbr72YRMfPRnNNPtXbTa/Q+SYyf5RstAlsxp6si
 B+E5adlLGdoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="329719691"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 30 Nov 2020 13:29:19 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Mario Limonciello <mario.limonciello@dell.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, sasha.neftin@intel.com,
        Yijun Shen <Yijun.shen@dell.com>
Subject: [net-next 2/4] e1000e: Add Dell's Comet Lake systems into s0ix heuristics
Date:   Mon, 30 Nov 2020 13:29:05 -0800
Message-Id: <20201130212907.320677-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201130212907.320677-1-anthony.l.nguyen@intel.com>
References: <20201130212907.320677-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mario Limonciello <mario.limonciello@dell.com>

Dell's Comet Lake Latitude and Precision systems containing i219LM are
properly configured and should use the s0ix flows.

Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>
Tested-by: Yijun Shen <Yijun.shen@dell.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/Kconfig        |  1 +
 drivers/net/ethernet/intel/e1000e/param.c | 80 ++++++++++++++++++++++-
 2 files changed, 80 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index 5aa86318ed3e..280af47d74d2 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -58,6 +58,7 @@ config E1000
 config E1000E
 	tristate "Intel(R) PRO/1000 PCI-Express Gigabit Ethernet support"
 	depends on PCI && (!SPARC32 || BROKEN)
+	depends on DMI
 	select CRC32
 	imply PTP_1588_CLOCK
 	help
diff --git a/drivers/net/ethernet/intel/e1000e/param.c b/drivers/net/ethernet/intel/e1000e/param.c
index 56316b797521..d05f55201541 100644
--- a/drivers/net/ethernet/intel/e1000e/param.c
+++ b/drivers/net/ethernet/intel/e1000e/param.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 1999 - 2018 Intel Corporation. */
 
+#include <linux/dmi.h>
 #include <linux/netdevice.h>
 #include <linux/module.h>
 #include <linux/pci.h>
@@ -201,6 +202,80 @@ static const struct e1000e_me_supported me_supported[] = {
 	{0}
 };
 
+static const struct dmi_system_id s0ix_supported_systems[] = {
+	{
+		/* Dell Latitude 5310 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_SKU, "099F"),
+		},
+	},
+	{
+		/* Dell Latitude 5410 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_SKU, "09A0"),
+		},
+	},
+	{
+		/* Dell Latitude 5410 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_SKU, "09C9"),
+		},
+	},
+	{
+		/* Dell Latitude 5510 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_SKU, "09A1"),
+		},
+	},
+	{
+		/* Dell Precision 3550 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_SKU, "09A2"),
+		},
+	},
+	{
+		/* Dell Latitude 5411 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_SKU, "09C0"),
+		},
+	},
+	{
+		/* Dell Latitude 5511 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_SKU, "09C1"),
+		},
+	},
+	{
+		/* Dell Precision 3551 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_SKU, "09C2"),
+		},
+	},
+	{
+		/* Dell Precision 7550 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_SKU, "09C3"),
+		},
+	},
+	{
+		/* Dell Precision 7750 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_SKU, "09C4"),
+		},
+	},
+	{ }
+};
+
 static bool e1000e_check_me(u16 device_id)
 {
 	struct e1000e_me_supported *id;
@@ -599,8 +674,11 @@ void e1000e_check_options(struct e1000_adapter *adapter)
 		}
 
 		if (enabled == S0IX_HEURISTICS) {
+			/* check for allowlist of systems */
+			if (dmi_check_system(s0ix_supported_systems))
+				enabled = S0IX_FORCE_ON;
 			/* default to off for ME configurations */
-			if (e1000e_check_me(hw->adapter->pdev->device))
+			else if (e1000e_check_me(hw->adapter->pdev->device))
 				enabled = S0IX_FORCE_OFF;
 		}
 
-- 
2.26.2

