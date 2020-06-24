Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542142068F9
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 02:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388160AbgFXAXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 20:23:11 -0400
Received: from mga03.intel.com ([134.134.136.65]:52383 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388058AbgFXAW6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 20:22:58 -0400
IronPort-SDR: UUXktdROYPTxdBNbX0vJ+STm9WWZKD4TAAzfrjznrrayOfy0kvX66ny77eC9WKG0PBFlx4GVIH
 FjtU0jLohzVA==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="144308304"
X-IronPort-AV: E=Sophos;i="5.75,273,1589266800"; 
   d="scan'208";a="144308304"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 17:22:55 -0700
IronPort-SDR: KR/+sXDYsvNchGvW22g48AAJNlqgxPAhA6wO6g7NX2bbfNU/NjbiFgoPDyt3KGuP1aIj0my+PF
 bbOOpfgpmHpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,273,1589266800"; 
   d="scan'208";a="293374251"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga002.jf.intel.com with ESMTP; 23 Jun 2020 17:22:54 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Bruce Allan <bruce.w.allan@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Alek Loktionov <aleksandr.loktionov@intel.com>,
        Kevin Liedtke <kevin.d.liedtke@intel.com>,
        Aaron Rowden <aaron.f.rowden@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next v2 6/8] net/intel: remove driver versions from Intel drivers
Date:   Tue, 23 Jun 2020 17:22:50 -0700
Message-Id: <20200624002252.942257-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624002252.942257-1-jeffrey.t.kirsher@intel.com>
References: <20200624002252.942257-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As with other networking drivers, remove the unnecessary driver version
from the Intel drivers. The ethtool driver information and module version
will then report the kernel version instead.

For ixgbe, i40e and ice drivers, the driver passes the driver version to
the firmware to confirm that we are up and running.  So we now pass the
value of UTS_RELEASE to the firmware.  This adminq call is required per
the HAS document.  The Device then sends an indication to the BMC that the
PF driver is present. This is done using Host NC Driver Status Indication
in NC-SI Get Link command or via the Host Network Controller Driver Status
Change AEN.

What the BMC may do with this information is implementation-dependent, but
this is a standard NC-SI 1.1 command we honor per the HAS.

CC: Bruce Allan <bruce.w.allan@intel.com>
CC: Jesse Brandeburg <jesse.brandeburg@intel.com>
CC: Alek Loktionov <aleksandr.loktionov@intel.com>
CC: Kevin Liedtke <kevin.d.liedtke@intel.com>
CC: Aaron Rowden <aaron.f.rowden@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Co-developed-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
---
 drivers/net/ethernet/intel/e100.c             |  6 +----
 drivers/net/ethernet/intel/e1000/e1000.h      |  1 -
 .../net/ethernet/intel/e1000/e1000_ethtool.c  |  2 --
 drivers/net/ethernet/intel/e1000/e1000_main.c |  5 +----
 drivers/net/ethernet/intel/e1000e/e1000.h     |  1 -
 drivers/net/ethernet/intel/e1000e/ethtool.c   |  2 --
 drivers/net/ethernet/intel/e1000e/netdev.c    |  8 +------
 drivers/net/ethernet/intel/fm10k/fm10k.h      |  1 -
 .../net/ethernet/intel/fm10k/fm10k_ethtool.c  |  2 --
 drivers/net/ethernet/intel/fm10k/fm10k_main.c |  5 +----
 drivers/net/ethernet/intel/i40e/i40e.h        |  1 -
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |  2 --
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 22 +++++--------------
 drivers/net/ethernet/intel/iavf/iavf.h        |  1 -
 .../net/ethernet/intel/iavf/iavf_ethtool.c    |  1 -
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 14 +-----------
 drivers/net/ethernet/intel/iavf/iavf_type.h   |  8 -------
 drivers/net/ethernet/intel/ice/ice.h          |  1 -
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  1 -
 drivers/net/ethernet/intel/ice/ice_main.c     | 22 ++++++-------------
 drivers/net/ethernet/intel/igb/igb.h          |  1 -
 drivers/net/ethernet/intel/igb/igb_ethtool.c  |  1 -
 drivers/net/ethernet/intel/igb/igb_main.c     | 11 +---------
 drivers/net/ethernet/intel/igbvf/ethtool.c    |  2 --
 drivers/net/ethernet/intel/igbvf/igbvf.h      |  1 -
 drivers/net/ethernet/intel/igbvf/netdev.c     |  5 +----
 drivers/net/ethernet/intel/igc/igc.h          |  1 -
 drivers/net/ethernet/intel/igc/igc_ethtool.c  |  1 -
 drivers/net/ethernet/intel/igc/igc_main.c     |  7 +-----
 drivers/net/ethernet/intel/ixgb/ixgb.h        |  1 -
 .../net/ethernet/intel/ixgb/ixgb_ethtool.c    |  2 --
 drivers/net/ethernet/intel/ixgb/ixgb_main.c   |  6 +----
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      |  1 -
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  |  2 --
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c |  3 ++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 10 ++++-----
 drivers/net/ethernet/intel/ixgbevf/ethtool.c  |  2 --
 drivers/net/ethernet/intel/ixgbevf/ixgbevf.h  |  1 -
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  7 +-----
 39 files changed, 29 insertions(+), 142 deletions(-)

diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 1b8d015ebfb0..91c64f91a835 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -150,8 +150,6 @@
 
 
 #define DRV_NAME		"e100"
-#define DRV_EXT			"-NAPI"
-#define DRV_VERSION		"3.5.24-k2"DRV_EXT
 #define DRV_DESCRIPTION		"Intel(R) PRO/100 Network Driver"
 #define DRV_COPYRIGHT		"Copyright(c) 1999-2006 Intel Corporation"
 
@@ -165,7 +163,6 @@
 MODULE_DESCRIPTION(DRV_DESCRIPTION);
 MODULE_AUTHOR(DRV_COPYRIGHT);
 MODULE_LICENSE("GPL v2");
-MODULE_VERSION(DRV_VERSION);
 MODULE_FIRMWARE(FIRMWARE_D101M);
 MODULE_FIRMWARE(FIRMWARE_D101S);
 MODULE_FIRMWARE(FIRMWARE_D102E);
@@ -2430,7 +2427,6 @@ static void e100_get_drvinfo(struct net_device *netdev,
 {
 	struct nic *nic = netdev_priv(netdev);
 	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 	strlcpy(info->bus_info, pci_name(nic->pdev),
 		sizeof(info->bus_info));
 }
@@ -3167,7 +3163,7 @@ static struct pci_driver e100_driver = {
 static int __init e100_init_module(void)
 {
 	if (((1 << debug) - 1) & NETIF_MSG_DRV) {
-		pr_info("%s, %s\n", DRV_DESCRIPTION, DRV_VERSION);
+		pr_info("%s\n", DRV_DESCRIPTION);
 		pr_info("%s\n", DRV_COPYRIGHT);
 	}
 	return pci_register_driver(&e100_driver);
diff --git a/drivers/net/ethernet/intel/e1000/e1000.h b/drivers/net/ethernet/intel/e1000/e1000.h
index 7fad2f24dcad..4817eb13ca6f 100644
--- a/drivers/net/ethernet/intel/e1000/e1000.h
+++ b/drivers/net/ethernet/intel/e1000/e1000.h
@@ -330,7 +330,6 @@ struct net_device *e1000_get_hw_dev(struct e1000_hw *hw);
 	dev_err(&adapter->pdev->dev, format, ## arg)
 
 extern char e1000_driver_name[];
-extern const char e1000_driver_version[];
 
 int e1000_open(struct net_device *netdev);
 int e1000_close(struct net_device *netdev);
diff --git a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
index 6f45df5690d4..0b4196d2cdd4 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_ethtool.c
@@ -533,8 +533,6 @@ static void e1000_get_drvinfo(struct net_device *netdev,
 
 	strlcpy(drvinfo->driver,  e1000_driver_name,
 		sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, e1000_driver_version,
-		sizeof(drvinfo->version));
 
 	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 4b2de08137be..266899c0c933 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -10,8 +10,6 @@
 
 char e1000_driver_name[] = "e1000";
 static char e1000_driver_string[] = "Intel(R) PRO/1000 Network Driver";
-#define DRV_VERSION "7.3.21-k8-NAPI"
-const char e1000_driver_version[] = DRV_VERSION;
 static const char e1000_copyright[] = "Copyright (c) 1999-2006 Intel Corporation.";
 
 /* e1000_pci_tbl - PCI Device ID Table
@@ -194,7 +192,6 @@ static struct pci_driver e1000_driver = {
 MODULE_AUTHOR("Intel Corporation, <linux.nics@intel.com>");
 MODULE_DESCRIPTION("Intel(R) PRO/1000 Network Driver");
 MODULE_LICENSE("GPL v2");
-MODULE_VERSION(DRV_VERSION);
 
 #define DEFAULT_MSG_ENABLE (NETIF_MSG_DRV|NETIF_MSG_PROBE|NETIF_MSG_LINK)
 static int debug = -1;
@@ -221,7 +218,7 @@ struct net_device *e1000_get_hw_dev(struct e1000_hw *hw)
 static int __init e1000_init_module(void)
 {
 	int ret;
-	pr_info("%s - version %s\n", e1000_driver_string, e1000_driver_version);
+	pr_info("%s\n", e1000_driver_string);
 
 	pr_info("%s\n", e1000_copyright);
 
diff --git a/drivers/net/ethernet/intel/e1000e/e1000.h b/drivers/net/ethernet/intel/e1000e/e1000.h
index 944abd5eae11..ba7a0f8f6937 100644
--- a/drivers/net/ethernet/intel/e1000e/e1000.h
+++ b/drivers/net/ethernet/intel/e1000e/e1000.h
@@ -460,7 +460,6 @@ enum latency_range {
 };
 
 extern char e1000e_driver_name[];
-extern const char e1000e_driver_version[];
 
 void e1000e_check_options(struct e1000_adapter *adapter);
 void e1000e_set_ethtool_ops(struct net_device *netdev);
diff --git a/drivers/net/ethernet/intel/e1000e/ethtool.c b/drivers/net/ethernet/intel/e1000e/ethtool.c
index 1d47e2503072..11de79e49661 100644
--- a/drivers/net/ethernet/intel/e1000e/ethtool.c
+++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
@@ -633,8 +633,6 @@ static void e1000_get_drvinfo(struct net_device *netdev,
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 
 	strlcpy(drvinfo->driver, e1000e_driver_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, e1000e_driver_version,
-		sizeof(drvinfo->version));
 
 	/* EEPROM image version # is reported as firmware version # for
 	 * PCI-E controllers
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 6f6479ca1267..75937a48d517 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -28,11 +28,7 @@
 
 #include "e1000.h"
 
-#define DRV_EXTRAVERSION "-k"
-
-#define DRV_VERSION "3.2.6" DRV_EXTRAVERSION
 char e1000e_driver_name[] = "e1000e";
-const char e1000e_driver_version[] = DRV_VERSION;
 
 #define DEFAULT_MSG_ENABLE (NETIF_MSG_DRV|NETIF_MSG_PROBE|NETIF_MSG_LINK)
 static int debug = -1;
@@ -7899,8 +7895,7 @@ static struct pci_driver e1000_driver = {
  **/
 static int __init e1000_init_module(void)
 {
-	pr_info("Intel(R) PRO/1000 Network Driver - %s\n",
-		e1000e_driver_version);
+	pr_info("Intel(R) PRO/1000 Network Driver\n");
 	pr_info("Copyright(c) 1999 - 2015 Intel Corporation.\n");
 
 	return pci_register_driver(&e1000_driver);
@@ -7922,6 +7917,5 @@ module_exit(e1000_exit_module);
 MODULE_AUTHOR("Intel Corporation, <linux.nics@intel.com>");
 MODULE_DESCRIPTION("Intel(R) PRO/1000 Network Driver");
 MODULE_LICENSE("GPL v2");
-MODULE_VERSION(DRV_VERSION);
 
 /* netdev.c */
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k.h b/drivers/net/ethernet/intel/fm10k/fm10k.h
index 5b78362b82ac..f9be10a04dd6 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k.h
+++ b/drivers/net/ethernet/intel/fm10k/fm10k.h
@@ -476,7 +476,6 @@ struct fm10k_cb {
 
 /* main */
 extern char fm10k_driver_name[];
-extern const char fm10k_driver_version[];
 int fm10k_init_queueing_scheme(struct fm10k_intfc *interface);
 void fm10k_clear_queueing_scheme(struct fm10k_intfc *interface);
 __be16 fm10k_tx_encap_offload(struct sk_buff *skb);
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c b/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
index 37fbc646deb9..30ea2b422678 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
@@ -449,8 +449,6 @@ static void fm10k_get_drvinfo(struct net_device *dev,
 
 	strncpy(info->driver, fm10k_driver_name,
 		sizeof(info->driver) - 1);
-	strncpy(info->version, fm10k_driver_version,
-		sizeof(info->version) - 1);
 	strncpy(info->bus_info, pci_name(interface->pdev),
 		sizeof(info->bus_info) - 1);
 }
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_main.c b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
index 17738b0a9873..05e9bdb5f4aa 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_main.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
@@ -11,9 +11,7 @@
 
 #include "fm10k.h"
 
-#define DRV_VERSION	"0.27.1-k"
 #define DRV_SUMMARY	"Intel(R) Ethernet Switch Host Interface Driver"
-const char fm10k_driver_version[] = DRV_VERSION;
 char fm10k_driver_name[] = "fm10k";
 static const char fm10k_driver_string[] = DRV_SUMMARY;
 static const char fm10k_copyright[] =
@@ -22,7 +20,6 @@ static const char fm10k_copyright[] =
 MODULE_AUTHOR("Intel Corporation, <linux.nics@intel.com>");
 MODULE_DESCRIPTION(DRV_SUMMARY);
 MODULE_LICENSE("GPL v2");
-MODULE_VERSION(DRV_VERSION);
 
 /* single workqueue for entire fm10k driver */
 struct workqueue_struct *fm10k_workqueue;
@@ -35,7 +32,7 @@ struct workqueue_struct *fm10k_workqueue;
  **/
 static int __init fm10k_init_module(void)
 {
-	pr_info("%s - version %s\n", fm10k_driver_string, fm10k_driver_version);
+	pr_info("%s\n", fm10k_driver_string);
 	pr_info("%s\n", fm10k_copyright);
 
 	/* create driver workqueue */
diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 8151671e5e0e..7618834b149b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -968,7 +968,6 @@ static inline void i40e_write_fd_input_set(struct i40e_pf *pf,
 int i40e_up(struct i40e_vsi *vsi);
 void i40e_down(struct i40e_vsi *vsi);
 extern const char i40e_driver_name[];
-extern const char i40e_driver_version_str[];
 void i40e_do_reset_safe(struct i40e_pf *pf, u32 reset_flags);
 void i40e_do_reset(struct i40e_pf *pf, u32 reset_flags, bool lock_acquired);
 int i40e_config_rss(struct i40e_vsi *vsi, u8 *seed, u8 *lut, u16 lut_size);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index aa8026b1eb81..2dfd87f0bdfd 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -1893,8 +1893,6 @@ static void i40e_get_drvinfo(struct net_device *netdev,
 	struct i40e_pf *pf = vsi->back;
 
 	strlcpy(drvinfo->driver, i40e_driver_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, i40e_driver_version_str,
-		sizeof(drvinfo->version));
 	strlcpy(drvinfo->fw_version, i40e_nvm_version_str(&pf->hw),
 		sizeof(drvinfo->fw_version));
 	strlcpy(drvinfo->bus_info, pci_name(pf->pdev),
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 12d7191c936a..b928fb899b44 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -5,6 +5,7 @@
 #include <linux/of_net.h>
 #include <linux/pci.h>
 #include <linux/bpf.h>
+#include <generated/utsrelease.h>
 
 /* Local includes */
 #include "i40e.h"
@@ -23,15 +24,6 @@ const char i40e_driver_name[] = "i40e";
 static const char i40e_driver_string[] =
 			"Intel(R) Ethernet Connection XL710 Network Driver";
 
-#define DRV_KERN "-k"
-
-#define DRV_VERSION_MAJOR 2
-#define DRV_VERSION_MINOR 8
-#define DRV_VERSION_BUILD 20
-#define DRV_VERSION __stringify(DRV_VERSION_MAJOR) "." \
-	     __stringify(DRV_VERSION_MINOR) "." \
-	     __stringify(DRV_VERSION_BUILD)    DRV_KERN
-const char i40e_driver_version_str[] = DRV_VERSION;
 static const char i40e_copyright[] = "Copyright (c) 2013 - 2019 Intel Corporation.";
 
 /* a bit of forward declarations */
@@ -101,7 +93,6 @@ MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all), Debug mask (0x8XXXXXXX
 MODULE_AUTHOR("Intel Corporation, <e1000-devel@lists.sourceforge.net>");
 MODULE_DESCRIPTION("Intel(R) Ethernet Connection XL710 Network Driver");
 MODULE_LICENSE("GPL v2");
-MODULE_VERSION(DRV_VERSION);
 
 static struct workqueue_struct *i40e_wq;
 
@@ -9843,11 +9834,11 @@ static void i40e_send_version(struct i40e_pf *pf)
 {
 	struct i40e_driver_version dv;
 
-	dv.major_version = DRV_VERSION_MAJOR;
-	dv.minor_version = DRV_VERSION_MINOR;
-	dv.build_version = DRV_VERSION_BUILD;
+	dv.major_version = 0xff;
+	dv.minor_version = 0xff;
+	dv.build_version = 0xff;
 	dv.subbuild_version = 0;
-	strlcpy(dv.driver_string, DRV_VERSION, sizeof(dv.driver_string));
+	strlcpy(dv.driver_string, UTS_RELEASE, sizeof(dv.driver_string));
 	i40e_aq_send_driver_version(&pf->hw, &dv, NULL);
 }
 
@@ -15808,8 +15799,7 @@ static struct pci_driver i40e_driver = {
  **/
 static int __init i40e_init_module(void)
 {
-	pr_info("%s: %s - version %s\n", i40e_driver_name,
-		i40e_driver_string, i40e_driver_version_str);
+	pr_info("%s: %s\n", i40e_driver_name, i40e_driver_string);
 	pr_info("%s: %s\n", i40e_driver_name, i40e_copyright);
 
 	/* There is no need to throttle the number of active tasks because
diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 10b805ba03ee..8a65525a7c0d 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -375,7 +375,6 @@ struct iavf_device {
 
 /* needed by iavf_ethtool.c */
 extern char iavf_driver_name[];
-extern const char iavf_driver_version[];
 extern struct workqueue_struct *iavf_wq;
 
 int iavf_up(struct iavf_adapter *adapter);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index 181573822942..c93567f4d0f7 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -571,7 +571,6 @@ static void iavf_get_drvinfo(struct net_device *netdev,
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 
 	strlcpy(drvinfo->driver, iavf_driver_name, 32);
-	strlcpy(drvinfo->version, iavf_driver_version, 32);
 	strlcpy(drvinfo->fw_version, "N/A", 4);
 	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev), 32);
 	drvinfo->n_priv_flags = IAVF_PRIV_FLAGS_STR_LEN;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index fa82768e5eda..78bd9e3df3ac 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -21,16 +21,6 @@ char iavf_driver_name[] = "iavf";
 static const char iavf_driver_string[] =
 	"Intel(R) Ethernet Adaptive Virtual Function Network Driver";
 
-#define DRV_KERN "-k"
-
-#define DRV_VERSION_MAJOR 3
-#define DRV_VERSION_MINOR 2
-#define DRV_VERSION_BUILD 3
-#define DRV_VERSION __stringify(DRV_VERSION_MAJOR) "." \
-	     __stringify(DRV_VERSION_MINOR) "." \
-	     __stringify(DRV_VERSION_BUILD) \
-	     DRV_KERN
-const char iavf_driver_version[] = DRV_VERSION;
 static const char iavf_copyright[] =
 	"Copyright (c) 2013 - 2018 Intel Corporation.";
 
@@ -57,7 +47,6 @@ MODULE_ALIAS("i40evf");
 MODULE_AUTHOR("Intel Corporation, <linux.nics@intel.com>");
 MODULE_DESCRIPTION("Intel(R) Ethernet Adaptive Virtual Function Network Driver");
 MODULE_LICENSE("GPL v2");
-MODULE_VERSION(DRV_VERSION);
 
 static const struct net_device_ops iavf_netdev_ops;
 struct workqueue_struct *iavf_wq;
@@ -3982,8 +3971,7 @@ static int __init iavf_init_module(void)
 {
 	int ret;
 
-	pr_info("iavf: %s - version %s\n", iavf_driver_string,
-		iavf_driver_version);
+	pr_info("iavf: %s\n", iavf_driver_string);
 
 	pr_info("%s\n", iavf_copyright);
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf_type.h b/drivers/net/ethernet/intel/iavf/iavf_type.h
index 7190a40c540c..de9fda78b43a 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_type.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_type.h
@@ -192,14 +192,6 @@ struct iavf_hw {
 	char err_str[16];
 };
 
-struct iavf_driver_version {
-	u8 major_version;
-	u8 minor_version;
-	u8 build_version;
-	u8 subbuild_version;
-	u8 driver_string[32];
-};
-
 /* RX Descriptors */
 union iavf_16byte_rx_desc {
 	struct {
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 5792ee616b5c..a4cda8212e64 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -55,7 +55,6 @@
 #include "ice_xsk.h"
 #include "ice_arfs.h"
 
-extern const char ice_drv_ver[];
 #define ICE_BAR0		0
 #define ICE_REQ_DESC_MULTIPLE	32
 #define ICE_MIN_NUM_DESC	64
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 68c38004a088..7066775769eb 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -179,7 +179,6 @@ ice_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
 	orom = &nvm->orom;
 
 	strscpy(drvinfo->driver, KBUILD_MODNAME, sizeof(drvinfo->driver));
-	strscpy(drvinfo->version, ice_drv_ver, sizeof(drvinfo->version));
 
 	/* Display NVM version (from which the firmware version can be
 	 * determined) which contains more pertinent information.
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 082825e3cb39..ddfc52661721 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5,6 +5,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <generated/utsrelease.h>
 #include "ice.h"
 #include "ice_base.h"
 #include "ice_lib.h"
@@ -13,15 +14,7 @@
 #include "ice_dcb_nl.h"
 #include "ice_devlink.h"
 
-#define DRV_VERSION_MAJOR 0
-#define DRV_VERSION_MINOR 8
-#define DRV_VERSION_BUILD 2
-
-#define DRV_VERSION	__stringify(DRV_VERSION_MAJOR) "." \
-			__stringify(DRV_VERSION_MINOR) "." \
-			__stringify(DRV_VERSION_BUILD) "-k"
 #define DRV_SUMMARY	"Intel(R) Ethernet Connection E800 Series Linux Driver"
-const char ice_drv_ver[] = DRV_VERSION;
 static const char ice_driver_string[] = DRV_SUMMARY;
 static const char ice_copyright[] = "Copyright (c) 2018, Intel Corporation.";
 
@@ -32,7 +25,6 @@ static const char ice_copyright[] = "Copyright (c) 2018, Intel Corporation.";
 MODULE_AUTHOR("Intel Corporation, <linux.nics@intel.com>");
 MODULE_DESCRIPTION(DRV_SUMMARY);
 MODULE_LICENSE("GPL v2");
-MODULE_VERSION(DRV_VERSION);
 MODULE_FIRMWARE(ICE_DDP_PKG_FILE);
 
 static int debug = -1;
@@ -3168,11 +3160,11 @@ static enum ice_status ice_send_version(struct ice_pf *pf)
 {
 	struct ice_driver_ver dv;
 
-	dv.major_ver = DRV_VERSION_MAJOR;
-	dv.minor_ver = DRV_VERSION_MINOR;
-	dv.build_ver = DRV_VERSION_BUILD;
+	dv.major_ver = 0xff;
+	dv.minor_ver = 0xff;
+	dv.build_ver = 0xff;
 	dv.subbuild_ver = 0;
-	strscpy((char *)dv.driver_string, DRV_VERSION,
+	strscpy((char *)dv.driver_string, UTS_RELEASE,
 		sizeof(dv.driver_string));
 	return ice_aq_send_driver_ver(&pf->hw, &dv, NULL);
 }
@@ -3463,7 +3455,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 	err = ice_send_version(pf);
 	if (err) {
 		dev_err(dev, "probe failed sending driver version %s. error: %d\n",
-			ice_drv_ver, err);
+			UTS_RELEASE, err);
 		goto err_alloc_sw_unroll;
 	}
 
@@ -3769,7 +3761,7 @@ static int __init ice_module_init(void)
 {
 	int status;
 
-	pr_info("%s - version %s\n", ice_driver_string, ice_drv_ver);
+	pr_info("%s\n", ice_driver_string);
 	pr_info("%s\n", ice_copyright);
 
 	ice_wq = alloc_workqueue("%s", WQ_MEM_RECLAIM, 0, KBUILD_MODNAME);
diff --git a/drivers/net/ethernet/intel/igb/igb.h b/drivers/net/ethernet/intel/igb/igb.h
index 0c9282e2aaec..2f015b60a995 100644
--- a/drivers/net/ethernet/intel/igb/igb.h
+++ b/drivers/net/ethernet/intel/igb/igb.h
@@ -642,7 +642,6 @@ enum igb_boards {
 };
 
 extern char igb_driver_name[];
-extern char igb_driver_version[];
 
 int igb_open(struct net_device *netdev);
 int igb_close(struct net_device *netdev);
diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index 2cd003c5ad43..da60e8d2128f 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -851,7 +851,6 @@ static void igb_get_drvinfo(struct net_device *netdev,
 	struct igb_adapter *adapter = netdev_priv(netdev);
 
 	strlcpy(drvinfo->driver,  igb_driver_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, igb_driver_version, sizeof(drvinfo->version));
 
 	/* EEPROM image version # is reported as firmware version # for
 	 * 82575 controllers
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 8bb3db2cbd41..ce611cb02c0a 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -38,12 +38,6 @@
 #include <linux/i2c.h>
 #include "igb.h"
 
-#define MAJ 5
-#define MIN 6
-#define BUILD 0
-#define DRV_VERSION __stringify(MAJ) "." __stringify(MIN) "." \
-__stringify(BUILD) "-k"
-
 enum queue_mode {
 	QUEUE_MODE_STRICT_PRIORITY,
 	QUEUE_MODE_STREAM_RESERVATION,
@@ -55,7 +49,6 @@ enum tx_queue_prio {
 };
 
 char igb_driver_name[] = "igb";
-char igb_driver_version[] = DRV_VERSION;
 static const char igb_driver_string[] =
 				"Intel(R) Gigabit Ethernet Network Driver";
 static const char igb_copyright[] =
@@ -240,7 +233,6 @@ static struct pci_driver igb_driver = {
 MODULE_AUTHOR("Intel Corporation, <e1000-devel@lists.sourceforge.net>");
 MODULE_DESCRIPTION("Intel(R) Gigabit Ethernet Network Driver");
 MODULE_LICENSE("GPL v2");
-MODULE_VERSION(DRV_VERSION);
 
 #define DEFAULT_MSG_ENABLE (NETIF_MSG_DRV|NETIF_MSG_PROBE|NETIF_MSG_LINK)
 static int debug = -1;
@@ -666,8 +658,7 @@ static int __init igb_init_module(void)
 {
 	int ret;
 
-	pr_info("%s - version %s\n",
-	       igb_driver_string, igb_driver_version);
+	pr_info("%s\n", igb_driver_string);
 	pr_info("%s\n", igb_copyright);
 
 #ifdef CONFIG_IGB_DCA
diff --git a/drivers/net/ethernet/intel/igbvf/ethtool.c b/drivers/net/ethernet/intel/igbvf/ethtool.c
index 9217d150e286..f4835eb62fee 100644
--- a/drivers/net/ethernet/intel/igbvf/ethtool.c
+++ b/drivers/net/ethernet/intel/igbvf/ethtool.c
@@ -170,8 +170,6 @@ static void igbvf_get_drvinfo(struct net_device *netdev,
 	struct igbvf_adapter *adapter = netdev_priv(netdev);
 
 	strlcpy(drvinfo->driver,  igbvf_driver_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, igbvf_driver_version,
-		sizeof(drvinfo->version));
 	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 }
diff --git a/drivers/net/ethernet/intel/igbvf/igbvf.h b/drivers/net/ethernet/intel/igbvf/igbvf.h
index eee26a3be90b..975eb47ee04d 100644
--- a/drivers/net/ethernet/intel/igbvf/igbvf.h
+++ b/drivers/net/ethernet/intel/igbvf/igbvf.h
@@ -281,7 +281,6 @@ enum igbvf_state_t {
 };
 
 extern char igbvf_driver_name[];
-extern const char igbvf_driver_version[];
 
 void igbvf_check_options(struct igbvf_adapter *);
 void igbvf_set_ethtool_ops(struct net_device *);
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 5b1800c3ba82..07740654df5c 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -24,9 +24,7 @@
 
 #include "igbvf.h"
 
-#define DRV_VERSION "2.4.0-k"
 char igbvf_driver_name[] = "igbvf";
-const char igbvf_driver_version[] = DRV_VERSION;
 static const char igbvf_driver_string[] =
 		  "Intel(R) Gigabit Virtual Function Network Driver";
 static const char igbvf_copyright[] =
@@ -2987,7 +2985,7 @@ static int __init igbvf_init_module(void)
 {
 	int ret;
 
-	pr_info("%s - version %s\n", igbvf_driver_string, igbvf_driver_version);
+	pr_info("%s\n", igbvf_driver_string);
 	pr_info("%s\n", igbvf_copyright);
 
 	ret = pci_register_driver(&igbvf_driver);
@@ -3011,6 +3009,5 @@ module_exit(igbvf_exit_module);
 MODULE_AUTHOR("Intel Corporation, <e1000-devel@lists.sourceforge.net>");
 MODULE_DESCRIPTION("Intel(R) Gigabit Virtual Function Network Driver");
 MODULE_LICENSE("GPL v2");
-MODULE_VERSION(DRV_VERSION);
 
 /* netdev.c */
diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 5dbc5a156626..a2d260165df3 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -239,7 +239,6 @@ void igc_rings_dump(struct igc_adapter *adapter);
 void igc_regs_dump(struct igc_adapter *adapter);
 
 extern char igc_driver_name[];
-extern char igc_driver_version[];
 
 #define IGC_REGS_LEN			740
 
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index a938ec8db681..735f3fb47dca 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -130,7 +130,6 @@ static void igc_ethtool_get_drvinfo(struct net_device *netdev,
 	struct igc_adapter *adapter = netdev_priv(netdev);
 
 	strlcpy(drvinfo->driver,  igc_driver_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, igc_driver_version, sizeof(drvinfo->version));
 
 	/* add fw_version here */
 	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 6919c50e449a..c2f41a558fd6 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -17,7 +17,6 @@
 #include "igc_hw.h"
 #include "igc_tsn.h"
 
-#define DRV_VERSION	"0.0.1-k"
 #define DRV_SUMMARY	"Intel(R) 2.5G Ethernet Linux Driver"
 
 #define DEFAULT_MSG_ENABLE (NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_LINK)
@@ -27,12 +26,10 @@ static int debug = -1;
 MODULE_AUTHOR("Intel Corporation, <linux.nics@intel.com>");
 MODULE_DESCRIPTION(DRV_SUMMARY);
 MODULE_LICENSE("GPL v2");
-MODULE_VERSION(DRV_VERSION);
 module_param(debug, int, 0);
 MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all)");
 
 char igc_driver_name[] = "igc";
-char igc_driver_version[] = DRV_VERSION;
 static const char igc_driver_string[] = DRV_SUMMARY;
 static const char igc_copyright[] =
 	"Copyright(c) 2018 Intel Corporation.";
@@ -5614,9 +5611,7 @@ static int __init igc_init_module(void)
 {
 	int ret;
 
-	pr_info("%s - version %s\n",
-		igc_driver_string, igc_driver_version);
-
+	pr_info("%s\n", igc_driver_string);
 	pr_info("%s\n", igc_copyright);
 
 	ret = pci_register_driver(&igc_driver);
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb.h b/drivers/net/ethernet/intel/ixgb/ixgb.h
index 681d44cc9784..81ac39576803 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb.h
+++ b/drivers/net/ethernet/intel/ixgb/ixgb.h
@@ -163,7 +163,6 @@ enum ixgb_state_t {
 void ixgb_check_options(struct ixgb_adapter *adapter);
 void ixgb_set_ethtool_ops(struct net_device *netdev);
 extern char ixgb_driver_name[];
-extern const char ixgb_driver_version[];
 
 void ixgb_set_speed_duplex(struct net_device *netdev);
 
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c b/drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c
index c65eb1afc8fb..582099a5ad41 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c
@@ -458,8 +458,6 @@ ixgb_get_drvinfo(struct net_device *netdev,
 
 	strlcpy(drvinfo->driver,  ixgb_driver_name,
 		sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, ixgb_driver_version,
-		sizeof(drvinfo->version));
 	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 }
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_main.c b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
index b64e91ea3465..46829cfd54df 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_main.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
@@ -9,9 +9,6 @@
 char ixgb_driver_name[] = "ixgb";
 static char ixgb_driver_string[] = "Intel(R) PRO/10GbE Network Driver";
 
-#define DRIVERNAPI "-NAPI"
-#define DRV_VERSION "1.0.135-k2" DRIVERNAPI
-const char ixgb_driver_version[] = DRV_VERSION;
 static const char ixgb_copyright[] = "Copyright (c) 1999-2008 Intel Corporation.";
 
 #define IXGB_CB_LENGTH 256
@@ -103,7 +100,6 @@ static struct pci_driver ixgb_driver = {
 MODULE_AUTHOR("Intel Corporation, <linux.nics@intel.com>");
 MODULE_DESCRIPTION("Intel(R) PRO/10GbE Network Driver");
 MODULE_LICENSE("GPL v2");
-MODULE_VERSION(DRV_VERSION);
 
 #define DEFAULT_MSG_ENABLE (NETIF_MSG_DRV|NETIF_MSG_PROBE|NETIF_MSG_LINK)
 static int debug = -1;
@@ -120,7 +116,7 @@ MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all)");
 static int __init
 ixgb_init_module(void)
 {
-	pr_info("%s - version %s\n", ixgb_driver_string, ixgb_driver_version);
+	pr_info("%s\n", ixgb_driver_string);
 	pr_info("%s\n", ixgb_copyright);
 
 	return pci_register_driver(&ixgb_driver);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
index 5ddfc83a1e46..debbcf216134 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
@@ -846,7 +846,6 @@ extern const struct dcbnl_rtnl_ops ixgbe_dcbnl_ops;
 #endif
 
 extern char ixgbe_driver_name[];
-extern const char ixgbe_driver_version[];
 #ifdef IXGBE_FCOE
 extern char ixgbe_default_device_descr[];
 #endif /* IXGBE_FCOE */
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index c6bf0a50ee63..5da367cb5c93 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -1004,8 +1004,6 @@ static void ixgbe_get_drvinfo(struct net_device *netdev,
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 
 	strlcpy(drvinfo->driver, ixgbe_driver_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, ixgbe_driver_version,
-		sizeof(drvinfo->version));
 
 	strlcpy(drvinfo->fw_version, adapter->eeprom_id,
 		sizeof(drvinfo->fw_version));
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
index ec7a11d13fdc..6c5703cdf062 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
@@ -5,6 +5,7 @@
 #include <linux/if_ether.h>
 #include <linux/gfp.h>
 #include <linux/if_vlan.h>
+#include <generated/utsrelease.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/fc/fc_fs.h>
@@ -1001,7 +1002,7 @@ int ixgbe_fcoe_get_hbainfo(struct net_device *netdev,
 		 sizeof(info->driver_version),
 		 "%s v%s",
 		 ixgbe_driver_name,
-		 ixgbe_driver_version);
+		 UTS_RELEASE);
 	/* Firmware Version */
 	strlcpy(info->firmware_version, adapter->eeprom_id,
 		sizeof(info->firmware_version));
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index f162b8b8f345..5becbb487b59 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -28,6 +28,7 @@
 #include <linux/bpf_trace.h>
 #include <linux/atomic.h>
 #include <linux/numa.h>
+#include <generated/utsrelease.h>
 #include <scsi/fc/fc_fcoe.h>
 #include <net/udp_tunnel.h>
 #include <net/pkt_cls.h>
@@ -56,8 +57,6 @@ char ixgbe_default_device_descr[] =
 static char ixgbe_default_device_descr[] =
 			      "Intel(R) 10 Gigabit Network Connection";
 #endif
-#define DRV_VERSION "5.1.0-k"
-const char ixgbe_driver_version[] = DRV_VERSION;
 static const char ixgbe_copyright[] =
 				"Copyright (c) 1999-2016 Intel Corporation.";
 
@@ -165,7 +164,6 @@ MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all)");
 MODULE_AUTHOR("Intel Corporation, <linux.nics@intel.com>");
 MODULE_DESCRIPTION("Intel(R) 10 Gigabit PCI Express Network Driver");
 MODULE_LICENSE("GPL v2");
-MODULE_VERSION(DRV_VERSION);
 
 static struct workqueue_struct *ixgbe_wq;
 
@@ -11146,8 +11144,8 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	if (hw->mac.ops.set_fw_drv_ver)
 		hw->mac.ops.set_fw_drv_ver(hw, 0xFF, 0xFF, 0xFF, 0xFF,
-					   sizeof(ixgbe_driver_version) - 1,
-					   ixgbe_driver_version);
+					   sizeof(UTS_RELEASE) - 1,
+					   UTS_RELEASE);
 
 	/* add san mac addr to netdev */
 	ixgbe_add_sanmac_netdev(netdev);
@@ -11504,7 +11502,7 @@ static struct pci_driver ixgbe_driver = {
 static int __init ixgbe_init_module(void)
 {
 	int ret;
-	pr_info("%s - version %s\n", ixgbe_driver_string, ixgbe_driver_version);
+	pr_info("%s\n", ixgbe_driver_string);
 	pr_info("%s\n", ixgbe_copyright);
 
 	ixgbe_wq = create_singlethread_workqueue(ixgbe_driver_name);
diff --git a/drivers/net/ethernet/intel/ixgbevf/ethtool.c b/drivers/net/ethernet/intel/ixgbevf/ethtool.c
index 988fa49fa99a..e49fb1cd9a99 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ethtool.c
@@ -218,8 +218,6 @@ static void ixgbevf_get_drvinfo(struct net_device *netdev,
 	struct ixgbevf_adapter *adapter = netdev_priv(netdev);
 
 	strlcpy(drvinfo->driver, ixgbevf_driver_name, sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, ixgbevf_driver_version,
-		sizeof(drvinfo->version));
 	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev),
 		sizeof(drvinfo->bus_info));
 
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf.h b/drivers/net/ethernet/intel/ixgbevf/ixgbevf.h
index ecab686574b6..a0e325774819 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf.h
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf.h
@@ -440,7 +440,6 @@ extern const struct ixgbe_mbx_operations ixgbevf_hv_mbx_ops;
 
 /* needed by ethtool.c */
 extern const char ixgbevf_driver_name[];
-extern const char ixgbevf_driver_version[];
 
 int ixgbevf_open(struct net_device *netdev);
 int ixgbevf_close(struct net_device *netdev);
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index a39e2cb384dd..635cbc25e2f2 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -38,8 +38,6 @@ const char ixgbevf_driver_name[] = "ixgbevf";
 static const char ixgbevf_driver_string[] =
 	"Intel(R) 10 Gigabit PCI Express Virtual Function Network Driver";
 
-#define DRV_VERSION "4.1.0-k"
-const char ixgbevf_driver_version[] = DRV_VERSION;
 static char ixgbevf_copyright[] =
 	"Copyright (c) 2009 - 2018 Intel Corporation.";
 
@@ -81,7 +79,6 @@ MODULE_DEVICE_TABLE(pci, ixgbevf_pci_tbl);
 MODULE_AUTHOR("Intel Corporation, <linux.nics@intel.com>");
 MODULE_DESCRIPTION("Intel(R) 10 Gigabit Virtual Function Network Driver");
 MODULE_LICENSE("GPL v2");
-MODULE_VERSION(DRV_VERSION);
 
 #define DEFAULT_MSG_ENABLE (NETIF_MSG_DRV|NETIF_MSG_PROBE|NETIF_MSG_LINK)
 static int debug = -1;
@@ -4913,9 +4910,7 @@ static struct pci_driver ixgbevf_driver = {
  **/
 static int __init ixgbevf_init_module(void)
 {
-	pr_info("%s - version %s\n", ixgbevf_driver_string,
-		ixgbevf_driver_version);
-
+	pr_info("%s\n", ixgbevf_driver_string);
 	pr_info("%s\n", ixgbevf_copyright);
 	ixgbevf_wq = create_singlethread_workqueue(ixgbevf_driver_name);
 	if (!ixgbevf_wq) {
-- 
2.26.2

