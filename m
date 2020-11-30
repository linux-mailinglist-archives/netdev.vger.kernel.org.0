Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87AB62C9016
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 22:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388653AbgK3Val (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 16:30:41 -0500
Received: from mga03.intel.com ([134.134.136.65]:5403 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388554AbgK3Vak (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 16:30:40 -0500
IronPort-SDR: uynYVF+kgGBrBYPsaWsTMeBUqYLagOHs6eEKTLxAnyxcvr3E1KjddFnihglE7qVYJy0hyW4QSY
 KHHqnmRWReDA==
X-IronPort-AV: E=McAfee;i="6000,8403,9821"; a="172815007"
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="172815007"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 13:29:19 -0800
IronPort-SDR: RVv6mnXfS5b82/WyUoqownpaYPLs9UEIzWcvaoYiAhNydXQzHuGI4a8kcqsq9jgccHdmsdnwED
 5QwZgDd02qEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="329719688"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 30 Nov 2020 13:29:19 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Mario Limonciello <mario.limonciello@dell.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, sasha.neftin@intel.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next 1/4] e1000e: allow turning s0ix flows on for systems with ME
Date:   Mon, 30 Nov 2020 13:29:04 -0800
Message-Id: <20201130212907.320677-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201130212907.320677-1-anthony.l.nguyen@intel.com>
References: <20201130212907.320677-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mario Limonciello <mario.limonciello@dell.com>

S0ix for GBE flows are needed for allowing the system to get into deepest
power state, but these require coordination of components outside of
control of Linux kernel.  For systems that have confirmed to coordinate
this properly, allow turning on the s0ix flows at load time or runtime.

Fixes: e086ba2fccda ("e1000e: disable s0ix entry and exit flows for ME systems")
Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../device_drivers/ethernet/intel/e1000e.rst  |  23 ++++
 drivers/net/ethernet/intel/e1000e/e1000.h     |   7 ++
 drivers/net/ethernet/intel/e1000e/netdev.c    |  64 +++++-----
 drivers/net/ethernet/intel/e1000e/param.c     | 110 ++++++++++++++++++
 4 files changed, 166 insertions(+), 38 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/intel/e1000e.rst b/Documentation/networking/device_drivers/ethernet/intel/e1000e.rst
index f49cd370e7bf..da029b703573 100644
--- a/Documentation/networking/device_drivers/ethernet/intel/e1000e.rst
+++ b/Documentation/networking/device_drivers/ethernet/intel/e1000e.rst
@@ -249,6 +249,29 @@ Debug
 
 This parameter adjusts the level of debug messages displayed in the system logs.
 
+EnableS0ix
+----------
+:Valid Range: 0, 1, 2
+:Default Value: 1 (Use Heuristics)
+
+   +-------+----------------+
+   | Value |    EnableS0ix  |
+   +=======+================+
+   |   0   |    Disabled    |
+   +-------+----------------+
+   |   1   | Use Heuristics |
+   +-------+----------------+
+   |   2   |    Enabled     |
+   +-------+----------------+
+
+Controls whether the e1000e driver will attempt s0ix flows.  S0ix flows require
+correct platform configuration. By default the e1000e driver will use some heuristics
+to decide whether to enable s0ix.  This parameter can be used to override heuristics.
+
+Additionally a sysfs file "enable_s0ix" will be present that can change the value at
+runtime.
+
+Note: This option is only effective on Cannon Point or later hardware.
 
 Additional Features and Configurations
 ======================================
diff --git a/drivers/net/ethernet/intel/e1000e/e1000.h b/drivers/net/ethernet/intel/e1000e/e1000.h
index ba7a0f8f6937..32262fa7e085 100644
--- a/drivers/net/ethernet/intel/e1000e/e1000.h
+++ b/drivers/net/ethernet/intel/e1000e/e1000.h
@@ -436,6 +436,7 @@ s32 e1000e_get_base_timinca(struct e1000_adapter *adapter, u32 *timinca);
 #define FLAG2_DFLT_CRC_STRIPPING          BIT(12)
 #define FLAG2_CHECK_RX_HWTSTAMP           BIT(13)
 #define FLAG2_CHECK_SYSTIM_OVERFLOW       BIT(14)
+#define FLAG2_ENABLE_S0IX_FLOWS           BIT(15)
 
 #define E1000_RX_DESC_PS(R, i)	    \
 	(&(((union e1000_rx_desc_packet_split *)((R).desc))[i]))
@@ -462,6 +463,12 @@ enum latency_range {
 extern char e1000e_driver_name[];
 
 void e1000e_check_options(struct e1000_adapter *adapter);
+ssize_t enable_s0ix_store(struct device *dev,
+			  struct device_attribute *attr,
+			  const char *buf, size_t count);
+ssize_t enable_s0ix_show(struct device *dev,
+			 struct device_attribute *attr,
+			 char *buf);
 void e1000e_set_ethtool_ops(struct net_device *netdev);
 
 int e1000e_open(struct net_device *netdev);
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index b30f00891c03..f413b33127f6 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -103,44 +103,16 @@ static const struct e1000_reg_info e1000_reg_info_tbl[] = {
 	{0, NULL}
 };
 
-struct e1000e_me_supported {
-	u16 device_id;		/* supported device ID */
-};
+static DEVICE_ATTR_RW(enable_s0ix);
 
-static const struct e1000e_me_supported me_supported[] = {
-	{E1000_DEV_ID_PCH_LPT_I217_LM},
-	{E1000_DEV_ID_PCH_LPTLP_I218_LM},
-	{E1000_DEV_ID_PCH_I218_LM2},
-	{E1000_DEV_ID_PCH_I218_LM3},
-	{E1000_DEV_ID_PCH_SPT_I219_LM},
-	{E1000_DEV_ID_PCH_SPT_I219_LM2},
-	{E1000_DEV_ID_PCH_LBG_I219_LM3},
-	{E1000_DEV_ID_PCH_SPT_I219_LM4},
-	{E1000_DEV_ID_PCH_SPT_I219_LM5},
-	{E1000_DEV_ID_PCH_CNP_I219_LM6},
-	{E1000_DEV_ID_PCH_CNP_I219_LM7},
-	{E1000_DEV_ID_PCH_ICP_I219_LM8},
-	{E1000_DEV_ID_PCH_ICP_I219_LM9},
-	{E1000_DEV_ID_PCH_CMP_I219_LM10},
-	{E1000_DEV_ID_PCH_CMP_I219_LM11},
-	{E1000_DEV_ID_PCH_CMP_I219_LM12},
-	{E1000_DEV_ID_PCH_TGP_I219_LM13},
-	{E1000_DEV_ID_PCH_TGP_I219_LM14},
-	{E1000_DEV_ID_PCH_TGP_I219_LM15},
-	{0}
+static struct attribute *e1000e_attrs[] = {
+	&dev_attr_enable_s0ix.attr,
+	NULL,
 };
 
-static bool e1000e_check_me(u16 device_id)
-{
-	struct e1000e_me_supported *id;
-
-	for (id = (struct e1000e_me_supported *)me_supported;
-	     id->device_id; id++)
-		if (device_id == id->device_id)
-			return true;
-
-	return false;
-}
+static struct attribute_group e1000e_group = {
+	.attrs = e1000e_attrs,
+};
 
 /**
  * __ew32_prepare - prepare to write to MAC CSR register on certain parts
@@ -4243,7 +4215,7 @@ void e1000e_reset(struct e1000_adapter *adapter)
 
 /**
  * e1000e_trigger_lsc - trigger an LSC interrupt
- * @adapter: 
+ * @adapter: board private structure
  *
  * Fire a link status change interrupt to start the watchdog.
  **/
@@ -6975,7 +6947,7 @@ static __maybe_unused int e1000e_pm_suspend(struct device *dev)
 
 	/* Introduce S0ix implementation */
 	if (hw->mac.type >= e1000_pch_cnp &&
-	    !e1000e_check_me(hw->adapter->pdev->device))
+	    adapter->flags2 & FLAG2_ENABLE_S0IX_FLOWS)
 		e1000e_s0ix_entry_flow(adapter);
 
 	return rc;
@@ -6991,7 +6963,7 @@ static __maybe_unused int e1000e_pm_resume(struct device *dev)
 
 	/* Introduce S0ix implementation */
 	if (hw->mac.type >= e1000_pch_cnp &&
-	    !e1000e_check_me(hw->adapter->pdev->device))
+	    adapter->flags2 & FLAG2_ENABLE_S0IX_FLOWS)
 		e1000e_s0ix_exit_flow(adapter);
 
 	rc = __e1000_resume(pdev);
@@ -7655,6 +7627,13 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!(adapter->flags & FLAG_HAS_AMT))
 		e1000e_get_hw_control(adapter);
 
+	/* offer to turn on/off s0ix flows */
+	if (hw->mac.type >= e1000_pch_cnp) {
+		ret_val = sysfs_create_group(&pdev->dev.kobj, &e1000e_group);
+		if (ret_val)
+			goto err_sysfs;
+	}
+
 	strlcpy(netdev->name, "eth%d", sizeof(netdev->name));
 	err = register_netdev(netdev);
 	if (err)
@@ -7673,6 +7652,10 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return 0;
 
 err_register:
+	if (hw->mac.type >= e1000_pch_cnp)
+		sysfs_remove_group(&pdev->dev.kobj, &e1000e_group);
+
+err_sysfs:
 	if (!(adapter->flags & FLAG_HAS_AMT))
 		e1000e_release_hw_control(adapter);
 err_eeprom:
@@ -7710,6 +7693,7 @@ static void e1000_remove(struct pci_dev *pdev)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct e1000_adapter *adapter = netdev_priv(netdev);
+	struct e1000_hw *hw = &adapter->hw;
 
 	e1000e_ptp_remove(adapter);
 
@@ -7734,6 +7718,10 @@ static void e1000_remove(struct pci_dev *pdev)
 		}
 	}
 
+	/* only allow turning on/off s0ix for cannon point and later */
+	if (hw->mac.type >= e1000_pch_cnp)
+		sysfs_remove_group(&pdev->dev.kobj, &e1000e_group);
+
 	unregister_netdev(netdev);
 
 	if (pci_dev_run_wake(pdev))
diff --git a/drivers/net/ethernet/intel/e1000e/param.c b/drivers/net/ethernet/intel/e1000e/param.c
index ebe121db4307..56316b797521 100644
--- a/drivers/net/ethernet/intel/e1000e/param.c
+++ b/drivers/net/ethernet/intel/e1000e/param.c
@@ -138,6 +138,20 @@ E1000_PARAM(WriteProtectNVM,
 E1000_PARAM(CrcStripping,
 	    "Enable CRC Stripping, disable if your BMC needs the CRC");
 
+/* Enable s0ix flows
+ *
+ * Valid Range: varies depending on hardware support
+ *
+ * disabled=0, heuristics=1, enabled=2
+ *
+ * Default Value: 1 (heuristics)
+ */
+E1000_PARAM(EnableS0ix,
+	    "Enable S0ix flows for the system");
+#define S0IX_FORCE_ON	2
+#define S0IX_HEURISTICS	1
+#define S0IX_FORCE_OFF	0
+
 struct e1000_option {
 	enum { enable_option, range_option, list_option } type;
 	const char *name;
@@ -160,6 +174,45 @@ struct e1000_option {
 	} arg;
 };
 
+struct e1000e_me_supported {
+	u16 device_id;		/* supported device ID */
+};
+
+static const struct e1000e_me_supported me_supported[] = {
+	{E1000_DEV_ID_PCH_LPT_I217_LM},
+	{E1000_DEV_ID_PCH_LPTLP_I218_LM},
+	{E1000_DEV_ID_PCH_I218_LM2},
+	{E1000_DEV_ID_PCH_I218_LM3},
+	{E1000_DEV_ID_PCH_SPT_I219_LM},
+	{E1000_DEV_ID_PCH_SPT_I219_LM2},
+	{E1000_DEV_ID_PCH_LBG_I219_LM3},
+	{E1000_DEV_ID_PCH_SPT_I219_LM4},
+	{E1000_DEV_ID_PCH_SPT_I219_LM5},
+	{E1000_DEV_ID_PCH_CNP_I219_LM6},
+	{E1000_DEV_ID_PCH_CNP_I219_LM7},
+	{E1000_DEV_ID_PCH_ICP_I219_LM8},
+	{E1000_DEV_ID_PCH_ICP_I219_LM9},
+	{E1000_DEV_ID_PCH_CMP_I219_LM10},
+	{E1000_DEV_ID_PCH_CMP_I219_LM11},
+	{E1000_DEV_ID_PCH_CMP_I219_LM12},
+	{E1000_DEV_ID_PCH_TGP_I219_LM13},
+	{E1000_DEV_ID_PCH_TGP_I219_LM14},
+	{E1000_DEV_ID_PCH_TGP_I219_LM15},
+	{0}
+};
+
+static bool e1000e_check_me(u16 device_id)
+{
+	struct e1000e_me_supported *id;
+
+	for (id = (struct e1000e_me_supported *)me_supported;
+	     id->device_id; id++)
+		if (device_id == id->device_id)
+			return true;
+
+	return false;
+}
+
 static int e1000_validate_option(unsigned int *value,
 				 const struct e1000_option *opt,
 				 struct e1000_adapter *adapter)
@@ -526,4 +579,61 @@ void e1000e_check_options(struct e1000_adapter *adapter)
 			}
 		}
 	}
+	/* Enable S0ix flows */
+	{
+		static const struct e1000_option opt = {
+			.type = range_option,
+			.name = "S0ix flows (Cannon point or later)",
+			.err  = "defaulting to heuristics",
+			.def  = S0IX_HEURISTICS,
+			.arg  = { .r = { .min = S0IX_FORCE_OFF,
+					 .max = S0IX_FORCE_ON } }
+		};
+		unsigned int enabled = opt.def;
+
+		if (num_EnableS0ix > bd) {
+			unsigned int s0ix = EnableS0ix[bd];
+
+			e1000_validate_option(&s0ix, &opt, adapter);
+			enabled = s0ix;
+		}
+
+		if (enabled == S0IX_HEURISTICS) {
+			/* default to off for ME configurations */
+			if (e1000e_check_me(hw->adapter->pdev->device))
+				enabled = S0IX_FORCE_OFF;
+		}
+
+		if (enabled > S0IX_FORCE_OFF)
+			adapter->flags2 |= FLAG2_ENABLE_S0IX_FLOWS;
+	}
+}
+
+ssize_t enable_s0ix_store(struct device *dev,
+			  struct device_attribute *attr,
+			  const char *buf, size_t count)
+{
+	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
+	struct e1000_adapter *adapter = netdev_priv(netdev);
+	bool enable_s0ix;
+	ssize_t ret;
+
+	ret = kstrtobool(buf, &enable_s0ix);
+	e_info("s0ix flow set to %d\n", enable_s0ix);
+	if (enable_s0ix)
+		adapter->flags2 |= FLAG2_ENABLE_S0IX_FLOWS;
+	else
+		adapter->flags2 &= ~FLAG2_ENABLE_S0IX_FLOWS;
+
+	return ret ? ret : count;
+}
+
+ssize_t enable_s0ix_show(struct device *dev,
+			 struct device_attribute *attr,
+			 char *buf)
+{
+	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
+	struct e1000_adapter *adapter = netdev_priv(netdev);
+
+	return sprintf(buf, "%d\n", (adapter->flags2 & FLAG2_ENABLE_S0IX_FLOWS) > 0);
 }
-- 
2.26.2

