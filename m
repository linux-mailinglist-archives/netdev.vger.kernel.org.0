Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4A9122BAA
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 13:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbfLQMec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 07:34:32 -0500
Received: from mga14.intel.com ([192.55.52.115]:21400 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727981AbfLQMdw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 07:33:52 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 04:33:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,325,1571727600"; 
   d="scan'208";a="221751193"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 17 Dec 2019 04:33:46 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 927082E6; Tue, 17 Dec 2019 14:33:45 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Rajmohan Mani <rajmohan.mani@intel.com>,
        Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>,
        Lukas Wunner <lukas@wunner.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Mario.Limonciello@dell.com,
        Anthony Wong <anthony.wong@canonical.com>,
        Oliver Neukum <oneukum@suse.com>,
        Christian Kellner <ckellner@redhat.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/9] thunderbolt: Add initial support for USB4
Date:   Tue, 17 Dec 2019 15:33:40 +0300
Message-Id: <20191217123345.31850-5-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191217123345.31850-1-mika.westerberg@linux.intel.com>
References: <20191217123345.31850-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

USB4 is the public specification based on Thunderbolt 3 protocol. There
are some differences in register layouts and flows. In addition to PCIe
and DP tunneling, USB4 supports tunneling of USB 3.x. USB4 is also
backward compatible with Thunderbolt 3 (and older generations but the
spec only talks about 3rd generation). USB4 compliant devices can be
identified by checking USB4 version field in router configuration space.

This patch adds initial support for USB4 compliant hosts and devices
which enables following features provided by the existing functionality
in the driver:

  - PCIe tunneling
  - Display Port tunneling
  - Host and device NVM firmware upgrade
  - P2P networking

This brings the USB4 support to the same level that we already have for
Thunderbolt 1, 2 and 3 devices.

Note the spec talks about host and device "routers" but in the driver we
still use term "switch" in most places. Both can be used interchangeably.

Co-developed-by: Rajmohan Mani <rajmohan.mani@intel.com>
Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/thunderbolt/Makefile  |   2 +-
 drivers/thunderbolt/eeprom.c  |  53 ++-
 drivers/thunderbolt/nhi.c     |   3 +
 drivers/thunderbolt/nhi.h     |   2 +
 drivers/thunderbolt/switch.c  | 382 +++++++++++++-----
 drivers/thunderbolt/tb.c      |  20 +-
 drivers/thunderbolt/tb.h      |  36 ++
 drivers/thunderbolt/tb_regs.h |  36 +-
 drivers/thunderbolt/tunnel.c  |  11 +-
 drivers/thunderbolt/usb4.c    | 724 ++++++++++++++++++++++++++++++++++
 drivers/thunderbolt/xdomain.c |   6 +
 11 files changed, 1158 insertions(+), 117 deletions(-)
 create mode 100644 drivers/thunderbolt/usb4.c

diff --git a/drivers/thunderbolt/Makefile b/drivers/thunderbolt/Makefile
index 001187c577bf..c0b2fd73dfbd 100644
--- a/drivers/thunderbolt/Makefile
+++ b/drivers/thunderbolt/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-${CONFIG_THUNDERBOLT} := thunderbolt.o
 thunderbolt-objs := nhi.o nhi_ops.o ctl.o tb.o switch.o cap.o path.o tunnel.o eeprom.o
-thunderbolt-objs += domain.o dma_port.o icm.o property.o xdomain.o lc.o
+thunderbolt-objs += domain.o dma_port.o icm.o property.o xdomain.o lc.o usb4.o
diff --git a/drivers/thunderbolt/eeprom.c b/drivers/thunderbolt/eeprom.c
index 540e0105bcc0..921d164b3f35 100644
--- a/drivers/thunderbolt/eeprom.c
+++ b/drivers/thunderbolt/eeprom.c
@@ -487,6 +487,37 @@ static int tb_drom_copy_nvm(struct tb_switch *sw, u16 *size)
 	return ret;
 }
 
+static int usb4_copy_host_drom(struct tb_switch *sw, u16 *size)
+{
+	int ret;
+
+	ret = usb4_switch_drom_read(sw, 14, size, sizeof(*size));
+	if (ret)
+		return ret;
+
+	/* Size includes CRC8 + UID + CRC32 */
+	*size += 1 + 8 + 4;
+	sw->drom = kzalloc(*size, GFP_KERNEL);
+	if (!sw->drom)
+		return -ENOMEM;
+
+	ret = usb4_switch_drom_read(sw, 0, sw->drom, *size);
+	if (ret) {
+		kfree(sw->drom);
+		sw->drom = NULL;
+	}
+
+	return ret;
+}
+
+static int tb_drom_read_n(struct tb_switch *sw, u16 offset, u8 *val,
+			  size_t count)
+{
+	if (tb_switch_is_usb4(sw))
+		return usb4_switch_drom_read(sw, offset, val, count);
+	return tb_eeprom_read_n(sw, offset, val, count);
+}
+
 /**
  * tb_drom_read - copy drom to sw->drom and parse it
  */
@@ -512,14 +543,26 @@ int tb_drom_read(struct tb_switch *sw)
 			goto parse;
 
 		/*
-		 * The root switch contains only a dummy drom (header only,
-		 * no entries). Hardcode the configuration here.
+		 * USB4 hosts may support reading DROM through router
+		 * operations.
 		 */
-		tb_drom_read_uid_only(sw, &sw->uid);
+		if (tb_switch_is_usb4(sw)) {
+			usb4_switch_read_uid(sw, &sw->uid);
+			if (!usb4_copy_host_drom(sw, &size))
+				goto parse;
+		} else {
+			/*
+			 * The root switch contains only a dummy drom
+			 * (header only, no entries). Hardcode the
+			 * configuration here.
+			 */
+			tb_drom_read_uid_only(sw, &sw->uid);
+		}
+
 		return 0;
 	}
 
-	res = tb_eeprom_read_n(sw, 14, (u8 *) &size, 2);
+	res = tb_drom_read_n(sw, 14, (u8 *) &size, 2);
 	if (res)
 		return res;
 	size &= 0x3ff;
@@ -533,7 +576,7 @@ int tb_drom_read(struct tb_switch *sw)
 	sw->drom = kzalloc(size, GFP_KERNEL);
 	if (!sw->drom)
 		return -ENOMEM;
-	res = tb_eeprom_read_n(sw, 0, sw->drom, size);
+	res = tb_drom_read_n(sw, 0, sw->drom, size);
 	if (res)
 		goto err;
 
diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
index 641b21b54460..1be491ecbb45 100644
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -1271,6 +1271,9 @@ static struct pci_device_id nhi_ids[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ICL_NHI1),
 	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
 
+	/* Any USB4 compliant host */
+	{ PCI_DEVICE_CLASS(PCI_CLASS_SERIAL_USB_USB4, ~0) },
+
 	{ 0,}
 };
 
diff --git a/drivers/thunderbolt/nhi.h b/drivers/thunderbolt/nhi.h
index b7b973949f8e..5d276ee9b38e 100644
--- a/drivers/thunderbolt/nhi.h
+++ b/drivers/thunderbolt/nhi.h
@@ -74,4 +74,6 @@ extern const struct tb_nhi_ops icl_nhi_ops;
 #define PCI_DEVICE_ID_INTEL_ICL_NHI1			0x8a0d
 #define PCI_DEVICE_ID_INTEL_ICL_NHI0			0x8a17
 
+#define PCI_CLASS_SERIAL_USB_USB4			0x0c0340
+
 #endif
diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index 9c72521cb298..c1d5cd7e0631 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -163,10 +163,12 @@ static int nvm_validate_and_write(struct tb_switch *sw)
 		image_size -= hdr_size;
 	}
 
+	if (tb_switch_is_usb4(sw))
+		return usb4_switch_nvm_write(sw, 0, buf, image_size);
 	return dma_port_flash_write(sw->dma_port, 0, buf, image_size);
 }
 
-static int nvm_authenticate_host(struct tb_switch *sw)
+static int nvm_authenticate_host_dma_port(struct tb_switch *sw)
 {
 	int ret = 0;
 
@@ -206,7 +208,7 @@ static int nvm_authenticate_host(struct tb_switch *sw)
 	return ret;
 }
 
-static int nvm_authenticate_device(struct tb_switch *sw)
+static int nvm_authenticate_device_dma_port(struct tb_switch *sw)
 {
 	int ret, retries = 10;
 
@@ -251,6 +253,78 @@ static int nvm_authenticate_device(struct tb_switch *sw)
 	return -ETIMEDOUT;
 }
 
+static void nvm_authenticate_start_dma_port(struct tb_switch *sw)
+{
+	struct pci_dev *root_port;
+
+	/*
+	 * During host router NVM upgrade we should not allow root port to
+	 * go into D3cold because some root ports cannot trigger PME
+	 * itself. To be on the safe side keep the root port in D0 during
+	 * the whole upgrade process.
+	 */
+	root_port = pci_find_pcie_root_port(sw->tb->nhi->pdev);
+	if (root_port)
+		pm_runtime_get_noresume(&root_port->dev);
+}
+
+static void nvm_authenticate_complete_dma_port(struct tb_switch *sw)
+{
+	struct pci_dev *root_port;
+
+	root_port = pci_find_pcie_root_port(sw->tb->nhi->pdev);
+	if (root_port)
+		pm_runtime_put(&root_port->dev);
+}
+
+static inline bool nvm_readable(struct tb_switch *sw)
+{
+	if (tb_switch_is_usb4(sw)) {
+		/*
+		 * USB4 devices must support NVM operations but it is
+		 * optional for hosts. Therefore we query the NVM sector
+		 * size here and if it is supported assume NVM
+		 * operations are implemented.
+		 */
+		return usb4_switch_nvm_sector_size(sw) > 0;
+	}
+
+	/* Thunderbolt 2 and 3 devices support NVM through DMA port */
+	return !!sw->dma_port;
+}
+
+static inline bool nvm_upgradeable(struct tb_switch *sw)
+{
+	if (sw->no_nvm_upgrade)
+		return false;
+	return nvm_readable(sw);
+}
+
+static inline int nvm_read(struct tb_switch *sw, unsigned int address,
+			   void *buf, size_t size)
+{
+	if (tb_switch_is_usb4(sw))
+		return usb4_switch_nvm_read(sw, address, buf, size);
+	return dma_port_flash_read(sw->dma_port, address, buf, size);
+}
+
+static int nvm_authenticate(struct tb_switch *sw)
+{
+	int ret;
+
+	if (tb_switch_is_usb4(sw))
+		return usb4_switch_nvm_authenticate(sw);
+
+	if (!tb_route(sw)) {
+		nvm_authenticate_start_dma_port(sw);
+		ret = nvm_authenticate_host_dma_port(sw);
+	} else {
+		ret = nvm_authenticate_device_dma_port(sw);
+	}
+
+	return ret;
+}
+
 static int tb_switch_nvm_read(void *priv, unsigned int offset, void *val,
 			      size_t bytes)
 {
@@ -264,7 +338,7 @@ static int tb_switch_nvm_read(void *priv, unsigned int offset, void *val,
 		goto out;
 	}
 
-	ret = dma_port_flash_read(sw->dma_port, offset, val, bytes);
+	ret = nvm_read(sw, offset, val, bytes);
 	mutex_unlock(&sw->tb->lock);
 
 out:
@@ -341,9 +415,21 @@ static int tb_switch_nvm_add(struct tb_switch *sw)
 	u32 val;
 	int ret;
 
-	if (!sw->dma_port)
+	if (!nvm_readable(sw))
 		return 0;
 
+	/*
+	 * The NVM format of non-Intel hardware is not known so
+	 * currently restrict NVM upgrade for Intel hardware. We may
+	 * relax this in the future when we learn other NVM formats.
+	 */
+	if (sw->config.vendor_id != PCI_VENDOR_ID_INTEL) {
+		dev_info(&sw->dev,
+			 "NVM format of vendor %#x is not known, disabling NVM upgrade\n",
+			 sw->config.vendor_id);
+		return 0;
+	}
+
 	nvm = kzalloc(sizeof(*nvm), GFP_KERNEL);
 	if (!nvm)
 		return -ENOMEM;
@@ -358,8 +444,7 @@ static int tb_switch_nvm_add(struct tb_switch *sw)
 	if (!sw->safe_mode) {
 		u32 nvm_size, hdr_size;
 
-		ret = dma_port_flash_read(sw->dma_port, NVM_FLASH_SIZE, &val,
-					  sizeof(val));
+		ret = nvm_read(sw, NVM_FLASH_SIZE, &val, sizeof(val));
 		if (ret)
 			goto err_ida;
 
@@ -367,8 +452,7 @@ static int tb_switch_nvm_add(struct tb_switch *sw)
 		nvm_size = (SZ_1M << (val & 7)) / 8;
 		nvm_size = (nvm_size - hdr_size) / 2;
 
-		ret = dma_port_flash_read(sw->dma_port, NVM_VERSION, &val,
-					  sizeof(val));
+		ret = nvm_read(sw, NVM_VERSION, &val, sizeof(val));
 		if (ret)
 			goto err_ida;
 
@@ -619,6 +703,24 @@ int tb_port_clear_counter(struct tb_port *port, int counter)
 	return tb_port_write(port, zero, TB_CFG_COUNTERS, 3 * counter, 3);
 }
 
+/**
+ * tb_port_unlock() - Unlock downstream port
+ * @port: Port to unlock
+ *
+ * Needed for USB4 but can be called for any CIO/USB4 ports. Makes the
+ * downstream router accessible for CM.
+ */
+int tb_port_unlock(struct tb_port *port)
+{
+	if (tb_switch_is_icm(port->sw))
+		return 0;
+	if (!tb_port_is_null(port))
+		return -EINVAL;
+	if (tb_switch_is_usb4(port->sw))
+		return usb4_port_unlock(port);
+	return 0;
+}
+
 /**
  * tb_init_port() - initialize a port
  *
@@ -650,6 +752,10 @@ static int tb_init_port(struct tb_port *port)
 			port->cap_phy = cap;
 		else
 			tb_port_WARN(port, "non switch port without a PHY\n");
+
+		cap = tb_port_find_cap(port, TB_PORT_CAP_USB4);
+		if (cap > 0)
+			port->cap_usb4 = cap;
 	} else if (port->port != 0) {
 		cap = tb_port_find_cap(port, TB_PORT_CAP_ADAP);
 		if (cap > 0)
@@ -1088,20 +1194,38 @@ int tb_dp_port_enable(struct tb_port *port, bool enable)
 
 /* switch utility functions */
 
-static void tb_dump_switch(struct tb *tb, struct tb_regs_switch_header *sw)
+static const char *tb_switch_generation_name(const struct tb_switch *sw)
+{
+	switch (sw->generation) {
+	case 1:
+		return "Thunderbolt 1";
+	case 2:
+		return "Thunderbolt 2";
+	case 3:
+		return "Thunderbolt 3";
+	case 4:
+		return "USB4";
+	default:
+		return "Unknown";
+	}
+}
+
+static void tb_dump_switch(const struct tb *tb, const struct tb_switch *sw)
 {
-	tb_dbg(tb, " Switch: %x:%x (Revision: %d, TB Version: %d)\n",
-	       sw->vendor_id, sw->device_id, sw->revision,
-	       sw->thunderbolt_version);
-	tb_dbg(tb, "  Max Port Number: %d\n", sw->max_port_number);
+	const struct tb_regs_switch_header *regs = &sw->config;
+
+	tb_dbg(tb, " %s Switch: %x:%x (Revision: %d, TB Version: %d)\n",
+	       tb_switch_generation_name(sw), regs->vendor_id, regs->device_id,
+	       regs->revision, regs->thunderbolt_version);
+	tb_dbg(tb, "  Max Port Number: %d\n", regs->max_port_number);
 	tb_dbg(tb, "  Config:\n");
 	tb_dbg(tb,
 		"   Upstream Port Number: %d Depth: %d Route String: %#llx Enabled: %d, PlugEventsDelay: %dms\n",
-	       sw->upstream_port_number, sw->depth,
-	       (((u64) sw->route_hi) << 32) | sw->route_lo,
-	       sw->enabled, sw->plug_events_delay);
+	       regs->upstream_port_number, regs->depth,
+	       (((u64) regs->route_hi) << 32) | regs->route_lo,
+	       regs->enabled, regs->plug_events_delay);
 	tb_dbg(tb, "   unknown1: %#x unknown4: %#x\n",
-	       sw->__unknown1, sw->__unknown4);
+	       regs->__unknown1, regs->__unknown4);
 }
 
 /**
@@ -1148,6 +1272,10 @@ static int tb_plug_events_active(struct tb_switch *sw, bool active)
 	if (res)
 		return res;
 
+	/* Plug events are always enabled in USB4 */
+	if (tb_switch_is_usb4(sw))
+		return 0;
+
 	res = tb_sw_read(sw, &data, TB_CFG_SWITCH, sw->cap_plug_events + 1, 1);
 	if (res)
 		return res;
@@ -1359,30 +1487,6 @@ static ssize_t lanes_show(struct device *dev, struct device_attribute *attr,
 static DEVICE_ATTR(rx_lanes, 0444, lanes_show, NULL);
 static DEVICE_ATTR(tx_lanes, 0444, lanes_show, NULL);
 
-static void nvm_authenticate_start(struct tb_switch *sw)
-{
-	struct pci_dev *root_port;
-
-	/*
-	 * During host router NVM upgrade we should not allow root port to
-	 * go into D3cold because some root ports cannot trigger PME
-	 * itself. To be on the safe side keep the root port in D0 during
-	 * the whole upgrade process.
-	 */
-	root_port = pci_find_pcie_root_port(sw->tb->nhi->pdev);
-	if (root_port)
-		pm_runtime_get_noresume(&root_port->dev);
-}
-
-static void nvm_authenticate_complete(struct tb_switch *sw)
-{
-	struct pci_dev *root_port;
-
-	root_port = pci_find_pcie_root_port(sw->tb->nhi->pdev);
-	if (root_port)
-		pm_runtime_put(&root_port->dev);
-}
-
 static ssize_t nvm_authenticate_show(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
@@ -1431,17 +1535,7 @@ static ssize_t nvm_authenticate_store(struct device *dev,
 			goto exit_unlock;
 
 		sw->nvm->authenticating = true;
-
-		if (!tb_route(sw)) {
-			/*
-			 * Keep root port from suspending as long as the
-			 * NVM upgrade process is running.
-			 */
-			nvm_authenticate_start(sw);
-			ret = nvm_authenticate_host(sw);
-		} else {
-			ret = nvm_authenticate_device(sw);
-		}
+		ret = nvm_authenticate(sw);
 	}
 
 exit_unlock:
@@ -1556,11 +1650,11 @@ static umode_t switch_attr_is_visible(struct kobject *kobj,
 			return attr->mode;
 		return 0;
 	} else if (attr == &dev_attr_nvm_authenticate.attr) {
-		if (sw->dma_port && !sw->no_nvm_upgrade)
+		if (nvm_upgradeable(sw))
 			return attr->mode;
 		return 0;
 	} else if (attr == &dev_attr_nvm_version.attr) {
-		if (sw->dma_port)
+		if (nvm_readable(sw))
 			return attr->mode;
 		return 0;
 	} else if (attr == &dev_attr_boot.attr) {
@@ -1672,6 +1766,9 @@ static int tb_switch_get_generation(struct tb_switch *sw)
 		return 3;
 
 	default:
+		if (tb_switch_is_usb4(sw))
+			return 4;
+
 		/*
 		 * For unknown switches assume generation to be 1 to be
 		 * on the safe side.
@@ -1682,6 +1779,19 @@ static int tb_switch_get_generation(struct tb_switch *sw)
 	}
 }
 
+static bool tb_switch_exceeds_max_depth(const struct tb_switch *sw, int depth)
+{
+	int max_depth;
+
+	if (tb_switch_is_usb4(sw) ||
+	    (sw->tb->root_switch && tb_switch_is_usb4(sw->tb->root_switch)))
+		max_depth = USB4_SWITCH_MAX_DEPTH;
+	else
+		max_depth = TB_SWITCH_MAX_DEPTH;
+
+	return depth > max_depth;
+}
+
 /**
  * tb_switch_alloc() - allocate a switch
  * @tb: Pointer to the owning domain
@@ -1703,10 +1813,16 @@ struct tb_switch *tb_switch_alloc(struct tb *tb, struct device *parent,
 	int upstream_port;
 	int i, ret, depth;
 
-	/* Make sure we do not exceed maximum topology limit */
+	/* Unlock the downstream port so we can access the switch below */
+	if (route) {
+		struct tb_switch *parent_sw = tb_to_switch(parent);
+		struct tb_port *down;
+
+		down = tb_port_at(route, parent_sw);
+		tb_port_unlock(down);
+	}
+
 	depth = tb_route_length(route);
-	if (depth > TB_SWITCH_MAX_DEPTH)
-		return ERR_PTR(-EADDRNOTAVAIL);
 
 	upstream_port = tb_cfg_get_upstream_port(tb->ctl, route);
 	if (upstream_port < 0)
@@ -1721,8 +1837,10 @@ struct tb_switch *tb_switch_alloc(struct tb *tb, struct device *parent,
 	if (ret)
 		goto err_free_sw_ports;
 
+	sw->generation = tb_switch_get_generation(sw);
+
 	tb_dbg(tb, "current switch config:\n");
-	tb_dump_switch(tb, &sw->config);
+	tb_dump_switch(tb, sw);
 
 	/* configure switch */
 	sw->config.upstream_port_number = upstream_port;
@@ -1731,6 +1849,10 @@ struct tb_switch *tb_switch_alloc(struct tb *tb, struct device *parent,
 	sw->config.route_lo = lower_32_bits(route);
 	sw->config.enabled = 0;
 
+	/* Make sure we do not exceed maximum topology limit */
+	if (tb_switch_exceeds_max_depth(sw, depth))
+		return ERR_PTR(-EADDRNOTAVAIL);
+
 	/* initialize ports */
 	sw->ports = kcalloc(sw->config.max_port_number + 1, sizeof(*sw->ports),
 				GFP_KERNEL);
@@ -1745,14 +1867,9 @@ struct tb_switch *tb_switch_alloc(struct tb *tb, struct device *parent,
 		sw->ports[i].port = i;
 	}
 
-	sw->generation = tb_switch_get_generation(sw);
-
 	ret = tb_switch_find_vse_cap(sw, TB_VSE_CAP_PLUG_EVENTS);
-	if (ret < 0) {
-		tb_sw_warn(sw, "cannot find TB_VSE_CAP_PLUG_EVENTS aborting\n");
-		goto err_free_sw_ports;
-	}
-	sw->cap_plug_events = ret;
+	if (ret > 0)
+		sw->cap_plug_events = ret;
 
 	ret = tb_switch_find_vse_cap(sw, TB_VSE_CAP_LINK_CONTROLLER);
 	if (ret > 0)
@@ -1823,7 +1940,8 @@ tb_switch_alloc_safe_mode(struct tb *tb, struct device *parent, u64 route)
  *
  * Call this function before the switch is added to the system. It will
  * upload configuration to the switch and makes it available for the
- * connection manager to use.
+ * connection manager to use. Can be called to the switch again after
+ * resume from low power states to re-initialize it.
  *
  * Return: %0 in case of success and negative errno in case of failure
  */
@@ -1834,21 +1952,50 @@ int tb_switch_configure(struct tb_switch *sw)
 	int ret;
 
 	route = tb_route(sw);
-	tb_dbg(tb, "initializing Switch at %#llx (depth: %d, up port: %d)\n",
-	       route, tb_route_length(route), sw->config.upstream_port_number);
 
-	if (sw->config.vendor_id != PCI_VENDOR_ID_INTEL)
-		tb_sw_warn(sw, "unknown switch vendor id %#x\n",
-			   sw->config.vendor_id);
+	tb_dbg(tb, "%s Switch at %#llx (depth: %d, up port: %d)\n",
+	       sw->config.enabled ? "restoring " : "initializing", route,
+	       tb_route_length(route), sw->config.upstream_port_number);
 
 	sw->config.enabled = 1;
 
-	/* upload configuration */
-	ret = tb_sw_write(sw, 1 + (u32 *)&sw->config, TB_CFG_SWITCH, 1, 3);
-	if (ret)
-		return ret;
+	if (tb_switch_is_usb4(sw)) {
+		/*
+		 * For USB4 devices, we need to program the CM version
+		 * accordingly so that it knows to expose all the
+		 * additional capabilities.
+		 */
+		sw->config.cmuv = USB4_VERSION_1_0;
+
+		/* Enumerate the switch */
+		ret = tb_sw_write(sw, (u32 *)&sw->config + 1, TB_CFG_SWITCH,
+				  ROUTER_CS_1, 4);
+		if (ret)
+			return ret;
 
-	ret = tb_lc_configure_link(sw);
+		ret = usb4_switch_setup(sw);
+		if (ret)
+			return ret;
+
+		ret = usb4_switch_configure_link(sw);
+	} else {
+		if (sw->config.vendor_id != PCI_VENDOR_ID_INTEL)
+			tb_sw_warn(sw, "unknown switch vendor id %#x\n",
+				   sw->config.vendor_id);
+
+		if (!sw->cap_plug_events) {
+			tb_sw_warn(sw, "cannot find TB_VSE_CAP_PLUG_EVENTS aborting\n");
+			return -ENODEV;
+		}
+
+		/* Enumerate the switch */
+		ret = tb_sw_write(sw, (u32 *)&sw->config + 1, TB_CFG_SWITCH,
+				  ROUTER_CS_1, 3);
+		if (ret)
+			return ret;
+
+		ret = tb_lc_configure_link(sw);
+	}
 	if (ret)
 		return ret;
 
@@ -1857,18 +2004,32 @@ int tb_switch_configure(struct tb_switch *sw)
 
 static int tb_switch_set_uuid(struct tb_switch *sw)
 {
+	bool uid = false;
 	u32 uuid[4];
 	int ret;
 
 	if (sw->uuid)
 		return 0;
 
-	/*
-	 * The newer controllers include fused UUID as part of link
-	 * controller specific registers
-	 */
-	ret = tb_lc_read_uuid(sw, uuid);
-	if (ret) {
+	if (tb_switch_is_usb4(sw)) {
+		ret = usb4_switch_read_uid(sw, &sw->uid);
+		if (ret)
+			return ret;
+		uid = true;
+	} else {
+		/*
+		 * The newer controllers include fused UUID as part of
+		 * link controller specific registers
+		 */
+		ret = tb_lc_read_uuid(sw, uuid);
+		if (ret) {
+			if (ret != -EINVAL)
+				return ret;
+			uid = true;
+		}
+	}
+
+	if (uid) {
 		/*
 		 * ICM generates UUID based on UID and fills the upper
 		 * two words with ones. This is not strictly following
@@ -1935,7 +2096,7 @@ static int tb_switch_add_dma_port(struct tb_switch *sw)
 	nvm_get_auth_status(sw, &status);
 	if (status) {
 		if (!tb_route(sw))
-			nvm_authenticate_complete(sw);
+			nvm_authenticate_complete_dma_port(sw);
 		return 0;
 	}
 
@@ -1950,7 +2111,7 @@ static int tb_switch_add_dma_port(struct tb_switch *sw)
 
 	/* Now we can allow root port to suspend again */
 	if (!tb_route(sw))
-		nvm_authenticate_complete(sw);
+		nvm_authenticate_complete_dma_port(sw);
 
 	if (status) {
 		tb_sw_info(sw, "switch flash authentication failed\n");
@@ -2004,6 +2165,8 @@ static bool tb_switch_lane_bonding_possible(struct tb_switch *sw)
 	if (!up->dual_link_port || !up->dual_link_port->remote)
 		return false;
 
+	if (tb_switch_is_usb4(sw))
+		return usb4_switch_lane_bonding_possible(sw);
 	return tb_lc_lane_bonding_possible(sw);
 }
 
@@ -2240,7 +2403,11 @@ void tb_switch_remove(struct tb_switch *sw)
 
 	if (!sw->is_unplugged)
 		tb_plug_events_active(sw, false);
-	tb_lc_unconfigure_link(sw);
+
+	if (tb_switch_is_usb4(sw))
+		usb4_switch_unconfigure_link(sw);
+	else
+		tb_lc_unconfigure_link(sw);
 
 	tb_switch_nvm_remove(sw);
 
@@ -2298,7 +2465,10 @@ int tb_switch_resume(struct tb_switch *sw)
 			return err;
 		}
 
-		err = tb_drom_read_uid_only(sw, &uid);
+		if (tb_switch_is_usb4(sw))
+			err = usb4_switch_read_uid(sw, &uid);
+		else
+			err = tb_drom_read_uid_only(sw, &uid);
 		if (err) {
 			tb_sw_warn(sw, "uid read failed\n");
 			return err;
@@ -2311,16 +2481,7 @@ int tb_switch_resume(struct tb_switch *sw)
 		}
 	}
 
-	/* upload configuration */
-	err = tb_sw_write(sw, 1 + (u32 *) &sw->config, TB_CFG_SWITCH, 1, 3);
-	if (err)
-		return err;
-
-	err = tb_lc_configure_link(sw);
-	if (err)
-		return err;
-
-	err = tb_plug_events_active(sw, true);
+	err = tb_switch_configure(sw);
 	if (err)
 		return err;
 
@@ -2336,8 +2497,14 @@ int tb_switch_resume(struct tb_switch *sw)
 				tb_sw_set_unplugged(port->remote->sw);
 			else if (port->xdomain)
 				port->xdomain->is_unplugged = true;
-		} else if (tb_port_has_remote(port)) {
-			if (tb_switch_resume(port->remote->sw)) {
+		} else if (tb_port_has_remote(port) || port->xdomain) {
+			/*
+			 * Always unlock the port so the downstream
+			 * switch/domain is accessible.
+			 */
+			if (tb_port_unlock(port))
+				tb_port_warn(port, "failed to unlock port\n");
+			if (port->remote && tb_switch_resume(port->remote->sw)) {
 				tb_port_warn(port,
 					     "lost during suspend, disconnecting\n");
 				tb_sw_set_unplugged(port->remote->sw);
@@ -2361,7 +2528,10 @@ void tb_switch_suspend(struct tb_switch *sw)
 			tb_switch_suspend(port->remote->sw);
 	}
 
-	tb_lc_set_sleep(sw);
+	if (tb_switch_is_usb4(sw))
+		usb4_switch_set_sleep(sw);
+	else
+		tb_lc_set_sleep(sw);
 }
 
 /**
@@ -2374,6 +2544,8 @@ void tb_switch_suspend(struct tb_switch *sw)
  */
 bool tb_switch_query_dp_resource(struct tb_switch *sw, struct tb_port *in)
 {
+	if (tb_switch_is_usb4(sw))
+		return usb4_switch_query_dp_resource(sw, in);
 	return tb_lc_dp_sink_query(sw, in);
 }
 
@@ -2388,6 +2560,8 @@ bool tb_switch_query_dp_resource(struct tb_switch *sw, struct tb_port *in)
  */
 int tb_switch_alloc_dp_resource(struct tb_switch *sw, struct tb_port *in)
 {
+	if (tb_switch_is_usb4(sw))
+		return usb4_switch_alloc_dp_resource(sw, in);
 	return tb_lc_dp_sink_alloc(sw, in);
 }
 
@@ -2401,10 +2575,16 @@ int tb_switch_alloc_dp_resource(struct tb_switch *sw, struct tb_port *in)
  */
 void tb_switch_dealloc_dp_resource(struct tb_switch *sw, struct tb_port *in)
 {
-	if (tb_lc_dp_sink_dealloc(sw, in)) {
+	int ret;
+
+	if (tb_switch_is_usb4(sw))
+		ret = usb4_switch_dealloc_dp_resource(sw, in);
+	else
+		ret = tb_lc_dp_sink_dealloc(sw, in);
+
+	if (ret)
 		tb_sw_warn(sw, "failed to de-allocate DP resource for port %d\n",
 			   in->port);
-	}
 }
 
 struct tb_sw_lookup {
diff --git a/drivers/thunderbolt/tb.c b/drivers/thunderbolt/tb.c
index e54d0d89a32d..6b99dcd1790c 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -365,12 +365,15 @@ static struct tb_port *tb_find_unused_port(struct tb_switch *sw,
 static struct tb_port *tb_find_pcie_down(struct tb_switch *sw,
 					 const struct tb_port *port)
 {
+	struct tb_port *down = NULL;
+
 	/*
 	 * To keep plugging devices consistently in the same PCIe
-	 * hierarchy, do mapping here for root switch downstream PCIe
-	 * ports.
+	 * hierarchy, do mapping here for switch downstream PCIe ports.
 	 */
-	if (!tb_route(sw)) {
+	if (tb_switch_is_usb4(sw)) {
+		down = usb4_switch_map_pcie_down(sw, port);
+	} else if (!tb_route(sw)) {
 		int phy_port = tb_phy_port_from_link(port->port);
 		int index;
 
@@ -391,12 +394,17 @@ static struct tb_port *tb_find_pcie_down(struct tb_switch *sw,
 		/* Validate the hard-coding */
 		if (WARN_ON(index > sw->config.max_port_number))
 			goto out;
-		if (WARN_ON(!tb_port_is_pcie_down(&sw->ports[index])))
+
+		down = &sw->ports[index];
+	}
+
+	if (down) {
+		if (WARN_ON(!tb_port_is_pcie_down(down)))
 			goto out;
-		if (WARN_ON(tb_pci_port_is_enabled(&sw->ports[index])))
+		if (WARN_ON(tb_pci_port_is_enabled(down)))
 			goto out;
 
-		return &sw->ports[index];
+		return down;
 	}
 
 out:
diff --git a/drivers/thunderbolt/tb.h b/drivers/thunderbolt/tb.h
index ade1c7c77db1..0158f0e9858c 100644
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -44,6 +44,7 @@ struct tb_switch_nvm {
 
 #define TB_SWITCH_KEY_SIZE		32
 #define TB_SWITCH_MAX_DEPTH		6
+#define USB4_SWITCH_MAX_DEPTH		5
 
 /**
  * struct tb_switch - a thunderbolt switch
@@ -129,6 +130,7 @@ struct tb_switch {
  * @xdomain: Remote host (%NULL if not connected)
  * @cap_phy: Offset, zero if not found
  * @cap_adap: Offset of the adapter specific capability (%0 if not present)
+ * @cap_usb4: Offset to the USB4 port capability (%0 if not present)
  * @port: Port number on switch
  * @disabled: Disabled by eeprom
  * @bonded: true if the port is bonded (two lanes combined as one)
@@ -146,6 +148,7 @@ struct tb_port {
 	struct tb_xdomain *xdomain;
 	int cap_phy;
 	int cap_adap;
+	int cap_usb4;
 	u8 port;
 	bool disabled;
 	bool bonded;
@@ -637,6 +640,17 @@ static inline bool tb_switch_is_titan_ridge(const struct tb_switch *sw)
 	}
 }
 
+/**
+ * tb_switch_is_usb4() - Is the switch USB4 compliant
+ * @sw: Switch to check
+ *
+ * Returns true if the @sw is USB4 compliant router, false otherwise.
+ */
+static inline bool tb_switch_is_usb4(const struct tb_switch *sw)
+{
+	return sw->config.thunderbolt_version == USB4_VERSION_1_0;
+}
+
 /**
  * tb_switch_is_icm() - Is the switch handled by ICM firmware
  * @sw: Switch to check
@@ -662,6 +676,7 @@ int tb_wait_for_port(struct tb_port *port, bool wait_if_unplugged);
 int tb_port_add_nfc_credits(struct tb_port *port, int credits);
 int tb_port_set_initial_credits(struct tb_port *port, u32 credits);
 int tb_port_clear_counter(struct tb_port *port, int counter);
+int tb_port_unlock(struct tb_port *port);
 int tb_port_alloc_in_hopid(struct tb_port *port, int hopid, int max_hopid);
 void tb_port_release_in_hopid(struct tb_port *port, int hopid);
 int tb_port_alloc_out_hopid(struct tb_port *port, int hopid, int max_hopid);
@@ -736,4 +751,25 @@ void tb_xdomain_remove(struct tb_xdomain *xd);
 struct tb_xdomain *tb_xdomain_find_by_link_depth(struct tb *tb, u8 link,
 						 u8 depth);
 
+int usb4_switch_setup(struct tb_switch *sw);
+int usb4_switch_read_uid(struct tb_switch *sw, u64 *uid);
+int usb4_switch_drom_read(struct tb_switch *sw, unsigned int address, void *buf,
+			  size_t size);
+int usb4_switch_configure_link(struct tb_switch *sw);
+void usb4_switch_unconfigure_link(struct tb_switch *sw);
+bool usb4_switch_lane_bonding_possible(struct tb_switch *sw);
+int usb4_switch_set_sleep(struct tb_switch *sw);
+int usb4_switch_nvm_sector_size(struct tb_switch *sw);
+int usb4_switch_nvm_read(struct tb_switch *sw, unsigned int address, void *buf,
+			 size_t size);
+int usb4_switch_nvm_write(struct tb_switch *sw, unsigned int address,
+			  const void *buf, size_t size);
+int usb4_switch_nvm_authenticate(struct tb_switch *sw);
+bool usb4_switch_query_dp_resource(struct tb_switch *sw, struct tb_port *in);
+int usb4_switch_alloc_dp_resource(struct tb_switch *sw, struct tb_port *in);
+int usb4_switch_dealloc_dp_resource(struct tb_switch *sw, struct tb_port *in);
+struct tb_port *usb4_switch_map_pcie_down(struct tb_switch *sw,
+					  const struct tb_port *port);
+
+int usb4_port_unlock(struct tb_port *port);
 #endif
diff --git a/drivers/thunderbolt/tb_regs.h b/drivers/thunderbolt/tb_regs.h
index 7ee45b73c7f7..47f73f992412 100644
--- a/drivers/thunderbolt/tb_regs.h
+++ b/drivers/thunderbolt/tb_regs.h
@@ -41,6 +41,7 @@ enum tb_port_cap {
 	TB_PORT_CAP_TIME1		= 0x03,
 	TB_PORT_CAP_ADAP		= 0x04,
 	TB_PORT_CAP_VSE			= 0x05,
+	TB_PORT_CAP_USB4		= 0x06,
 };
 
 enum tb_port_state {
@@ -164,10 +165,36 @@ struct tb_regs_switch_header {
 				  * milliseconds. Writing 0x00 is interpreted
 				  * as 255ms.
 				  */
-	u32 __unknown4:16;
+	u32 cmuv:8;
+	u32 __unknown4:8;
 	u32 thunderbolt_version:8;
 } __packed;
 
+/* USB4 version 1.0 */
+#define USB4_VERSION_1_0			0x20
+
+#define ROUTER_CS_1				0x01
+#define ROUTER_CS_4				0x04
+#define ROUTER_CS_5				0x05
+#define ROUTER_CS_5_SLP				BIT(0)
+#define ROUTER_CS_5_C3S				BIT(23)
+#define ROUTER_CS_5_PTO				BIT(24)
+#define ROUTER_CS_5_HCO				BIT(26)
+#define ROUTER_CS_5_CV				BIT(31)
+#define ROUTER_CS_6				0x06
+#define ROUTER_CS_6_SLPR			BIT(0)
+#define ROUTER_CS_6_TNS				BIT(1)
+#define ROUTER_CS_6_HCI				BIT(18)
+#define ROUTER_CS_6_CR				BIT(25)
+#define ROUTER_CS_7				0x07
+#define ROUTER_CS_9				0x09
+#define ROUTER_CS_25				0x19
+#define ROUTER_CS_26				0x1a
+#define ROUTER_CS_26_STATUS_MASK		GENMASK(29, 24)
+#define ROUTER_CS_26_STATUS_SHIFT		24
+#define ROUTER_CS_26_ONS			BIT(30)
+#define ROUTER_CS_26_OV				BIT(31)
+
 enum tb_port_type {
 	TB_TYPE_INACTIVE	= 0x000000,
 	TB_TYPE_PORT		= 0x000001,
@@ -216,6 +243,7 @@ struct tb_regs_port_header {
 #define ADP_CS_4_NFC_BUFFERS_MASK		GENMASK(9, 0)
 #define ADP_CS_4_TOTAL_BUFFERS_MASK		GENMASK(29, 20)
 #define ADP_CS_4_TOTAL_BUFFERS_SHIFT		20
+#define ADP_CS_4_LCK				BIT(31)
 #define ADP_CS_5				0x05
 #define ADP_CS_5_LCA_MASK			GENMASK(28, 22)
 #define ADP_CS_5_LCA_SHIFT			22
@@ -237,6 +265,12 @@ struct tb_regs_port_header {
 #define LANE_ADP_CS_1_CURRENT_WIDTH_MASK	GENMASK(25, 20)
 #define LANE_ADP_CS_1_CURRENT_WIDTH_SHIFT	20
 
+/* USB4 port registers */
+#define PORT_CS_18				0x12
+#define PORT_CS_18_BE				BIT(8)
+#define PORT_CS_19				0x13
+#define PORT_CS_19_PC				BIT(3)
+
 /* Display Port adapter registers */
 #define ADP_DP_CS_0				0x00
 #define ADP_DP_CS_0_VIDEO_HOPID_MASK		GENMASK(26, 16)
diff --git a/drivers/thunderbolt/tunnel.c b/drivers/thunderbolt/tunnel.c
index 0d3463c4e24a..21d266a76b7d 100644
--- a/drivers/thunderbolt/tunnel.c
+++ b/drivers/thunderbolt/tunnel.c
@@ -243,6 +243,12 @@ struct tb_tunnel *tb_tunnel_alloc_pci(struct tb *tb, struct tb_port *up,
 	return tunnel;
 }
 
+static bool tb_dp_is_usb4(const struct tb_switch *sw)
+{
+	/* Titan Ridge DP adapters need the same treatment as USB4 */
+	return tb_switch_is_usb4(sw) || tb_switch_is_titan_ridge(sw);
+}
+
 static int tb_dp_cm_handshake(struct tb_port *in, struct tb_port *out)
 {
 	int timeout = 10;
@@ -250,8 +256,7 @@ static int tb_dp_cm_handshake(struct tb_port *in, struct tb_port *out)
 	int ret;
 
 	/* Both ends need to support this */
-	if (!tb_switch_is_titan_ridge(in->sw) ||
-	    !tb_switch_is_titan_ridge(out->sw))
+	if (!tb_dp_is_usb4(in->sw) || !tb_dp_is_usb4(out->sw))
 		return 0;
 
 	ret = tb_port_read(out, &val, TB_CFG_PORT,
@@ -531,7 +536,7 @@ static int tb_dp_consumed_bandwidth(struct tb_tunnel *tunnel)
 	u32 val, rate = 0, lanes = 0;
 	int ret;
 
-	if (tb_switch_is_titan_ridge(sw)) {
+	if (tb_dp_is_usb4(sw)) {
 		int timeout = 10;
 
 		/*
diff --git a/drivers/thunderbolt/usb4.c b/drivers/thunderbolt/usb4.c
new file mode 100644
index 000000000000..b84c74346d2b
--- /dev/null
+++ b/drivers/thunderbolt/usb4.c
@@ -0,0 +1,724 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * USB4 specific functionality
+ *
+ * Copyright (C) 2019, Intel Corporation
+ * Authors: Mika Westerberg <mika.westerberg@linux.intel.com>
+ *	    Rajmohan Mani <rajmohan.mani@intel.com>
+ */
+
+#include <linux/delay.h>
+#include <linux/ktime.h>
+
+#include "tb.h"
+
+#define USB4_DATA_DWORDS		16
+#define USB4_DATA_RETRIES		3
+
+enum usb4_switch_op {
+	USB4_SWITCH_OP_QUERY_DP_RESOURCE = 0x10,
+	USB4_SWITCH_OP_ALLOC_DP_RESOURCE = 0x11,
+	USB4_SWITCH_OP_DEALLOC_DP_RESOURCE = 0x12,
+	USB4_SWITCH_OP_NVM_WRITE = 0x20,
+	USB4_SWITCH_OP_NVM_AUTH = 0x21,
+	USB4_SWITCH_OP_NVM_READ = 0x22,
+	USB4_SWITCH_OP_NVM_SET_OFFSET = 0x23,
+	USB4_SWITCH_OP_DROM_READ = 0x24,
+	USB4_SWITCH_OP_NVM_SECTOR_SIZE = 0x25,
+};
+
+#define USB4_NVM_READ_OFFSET_MASK	GENMASK(23, 2)
+#define USB4_NVM_READ_OFFSET_SHIFT	2
+#define USB4_NVM_READ_LENGTH_MASK	GENMASK(27, 24)
+#define USB4_NVM_READ_LENGTH_SHIFT	24
+
+#define USB4_NVM_SET_OFFSET_MASK	USB4_NVM_READ_OFFSET_MASK
+#define USB4_NVM_SET_OFFSET_SHIFT	USB4_NVM_READ_OFFSET_SHIFT
+
+#define USB4_DROM_ADDRESS_MASK		GENMASK(14, 2)
+#define USB4_DROM_ADDRESS_SHIFT		2
+#define USB4_DROM_SIZE_MASK		GENMASK(19, 15)
+#define USB4_DROM_SIZE_SHIFT		15
+
+#define USB4_NVM_SECTOR_SIZE_MASK	GENMASK(23, 0)
+
+typedef int (*read_block_fn)(struct tb_switch *, unsigned int, void *, size_t);
+typedef int (*write_block_fn)(struct tb_switch *, const void *, size_t);
+
+static int usb4_switch_wait_for_bit(struct tb_switch *sw, u32 offset, u32 bit,
+				    u32 value, int timeout_msec)
+{
+	ktime_t timeout = ktime_add_ms(ktime_get(), timeout_msec);
+
+	do {
+		u32 val;
+		int ret;
+
+		ret = tb_sw_read(sw, &val, TB_CFG_SWITCH, offset, 1);
+		if (ret)
+			return ret;
+
+		if ((val & bit) == value)
+			return 0;
+
+		usleep_range(50, 100);
+	} while (ktime_before(ktime_get(), timeout));
+
+	return -ETIMEDOUT;
+}
+
+static int usb4_switch_op_read_data(struct tb_switch *sw, void *data,
+				    size_t dwords)
+{
+	if (dwords > USB4_DATA_DWORDS)
+		return -EINVAL;
+
+	return tb_sw_read(sw, data, TB_CFG_SWITCH, ROUTER_CS_9, dwords);
+}
+
+static int usb4_switch_op_write_data(struct tb_switch *sw, const void *data,
+				     size_t dwords)
+{
+	if (dwords > USB4_DATA_DWORDS)
+		return -EINVAL;
+
+	return tb_sw_write(sw, data, TB_CFG_SWITCH, ROUTER_CS_9, dwords);
+}
+
+static int usb4_switch_op_read_metadata(struct tb_switch *sw, u32 *metadata)
+{
+	return tb_sw_read(sw, metadata, TB_CFG_SWITCH, ROUTER_CS_25, 1);
+}
+
+static int usb4_switch_op_write_metadata(struct tb_switch *sw, u32 metadata)
+{
+	return tb_sw_write(sw, &metadata, TB_CFG_SWITCH, ROUTER_CS_25, 1);
+}
+
+static int usb4_switch_do_read_data(struct tb_switch *sw, u16 address,
+	void *buf, size_t size, read_block_fn read_block)
+{
+	unsigned int retries = USB4_DATA_RETRIES;
+	unsigned int offset;
+
+	offset = address & 3;
+	address = address & ~3;
+
+	do {
+		size_t nbytes = min_t(size_t, size, USB4_DATA_DWORDS * 4);
+		unsigned int dwaddress, dwords;
+		u8 data[USB4_DATA_DWORDS * 4];
+		int ret;
+
+		dwaddress = address / 4;
+		dwords = ALIGN(nbytes, 4) / 4;
+
+		ret = read_block(sw, dwaddress, data, dwords);
+		if (ret) {
+			if (ret == -ETIMEDOUT) {
+				if (retries--)
+					continue;
+				ret = -EIO;
+			}
+			return ret;
+		}
+
+		memcpy(buf, data + offset, nbytes);
+
+		size -= nbytes;
+		address += nbytes;
+		buf += nbytes;
+	} while (size > 0);
+
+	return 0;
+}
+
+static int usb4_switch_do_write_data(struct tb_switch *sw, u16 address,
+	const void *buf, size_t size, write_block_fn write_next_block)
+{
+	unsigned int retries = USB4_DATA_RETRIES;
+	unsigned int offset;
+
+	offset = address & 3;
+	address = address & ~3;
+
+	do {
+		u32 nbytes = min_t(u32, size, USB4_DATA_DWORDS * 4);
+		u8 data[USB4_DATA_DWORDS * 4];
+		int ret;
+
+		memcpy(data + offset, buf, nbytes);
+
+		ret = write_next_block(sw, data, nbytes / 4);
+		if (ret) {
+			if (ret == -ETIMEDOUT) {
+				if (retries--)
+					continue;
+				ret = -EIO;
+			}
+			return ret;
+		}
+
+		size -= nbytes;
+		address += nbytes;
+		buf += nbytes;
+	} while (size > 0);
+
+	return 0;
+}
+
+static int usb4_switch_op(struct tb_switch *sw, u16 opcode, u8 *status)
+{
+	u32 val;
+	int ret;
+
+	val = opcode | ROUTER_CS_26_OV;
+	ret = tb_sw_write(sw, &val, TB_CFG_SWITCH, ROUTER_CS_26, 1);
+	if (ret)
+		return ret;
+
+	ret = usb4_switch_wait_for_bit(sw, ROUTER_CS_26, ROUTER_CS_26_OV, 0, 500);
+	if (ret)
+		return ret;
+
+	ret = tb_sw_read(sw, &val, TB_CFG_SWITCH, ROUTER_CS_26, 1);
+	if (val & ROUTER_CS_26_ONS)
+		return -EOPNOTSUPP;
+
+	*status = (val & ROUTER_CS_26_STATUS_MASK) >> ROUTER_CS_26_STATUS_SHIFT;
+	return 0;
+}
+
+/**
+ * usb4_switch_setup() - Additional setup for USB4 device
+ * @sw: USB4 router to setup
+ *
+ * USB4 routers need additional settings in order to enable all the
+ * tunneling. This function enables USB and PCIe tunneling if it can be
+ * enabled (e.g the parent switch also supports them). If USB tunneling
+ * is not available for some reason (like that there is Thunderbolt 3
+ * switch upstream) then the internal xHCI controller is enabled
+ * instead.
+ */
+int usb4_switch_setup(struct tb_switch *sw)
+{
+	struct tb_switch *parent;
+	bool tbt3, xhci;
+	u32 val = 0;
+	int ret;
+
+	if (!tb_route(sw))
+		return 0;
+
+	ret = tb_sw_read(sw, &val, TB_CFG_SWITCH, ROUTER_CS_6, 1);
+	if (ret)
+		return ret;
+
+	xhci = val & ROUTER_CS_6_HCI;
+	tbt3 = !(val & ROUTER_CS_6_TNS);
+
+	tb_sw_dbg(sw, "TBT3 support: %s, xHCI: %s\n",
+		  tbt3 ? "yes" : "no", xhci ? "yes" : "no");
+
+	ret = tb_sw_read(sw, &val, TB_CFG_SWITCH, ROUTER_CS_5, 1);
+	if (ret)
+		return ret;
+
+	parent = tb_switch_parent(sw);
+
+	/* Only enable PCIe tunneling if the parent router supports it */
+	if (tb_switch_find_port(parent, TB_TYPE_PCIE_DOWN)) {
+		val |= ROUTER_CS_5_PTO;
+		/* xHCI can be enabled if PCIe tunneling is supported */
+		if (xhci & ROUTER_CS_6_HCI)
+			val |= ROUTER_CS_5_HCO;
+	}
+
+	/* TBT3 supported by the CM */
+	val |= ROUTER_CS_5_C3S;
+	/* Tunneling configuration is ready now */
+	val |= ROUTER_CS_5_CV;
+
+	ret = tb_sw_write(sw, &val, TB_CFG_SWITCH, ROUTER_CS_5, 1);
+	if (ret)
+		return ret;
+
+	return usb4_switch_wait_for_bit(sw, ROUTER_CS_6, ROUTER_CS_6_CR,
+					ROUTER_CS_6_CR, 50);
+}
+
+/**
+ * usb4_switch_read_uid() - Read UID from USB4 router
+ * @sw: USB4 router
+ *
+ * Reads 64-bit UID from USB4 router config space.
+ */
+int usb4_switch_read_uid(struct tb_switch *sw, u64 *uid)
+{
+	return tb_sw_read(sw, uid, TB_CFG_SWITCH, ROUTER_CS_7, 2);
+}
+
+static int usb4_switch_drom_read_block(struct tb_switch *sw,
+				       unsigned int dwaddress, void *buf,
+				       size_t dwords)
+{
+	u8 status = 0;
+	u32 metadata;
+	int ret;
+
+	metadata = (dwords << USB4_DROM_SIZE_SHIFT) & USB4_DROM_SIZE_MASK;
+	metadata |= (dwaddress << USB4_DROM_ADDRESS_SHIFT) &
+		USB4_DROM_ADDRESS_MASK;
+
+	ret = usb4_switch_op_write_metadata(sw, metadata);
+	if (ret)
+		return ret;
+
+	ret = usb4_switch_op(sw, USB4_SWITCH_OP_DROM_READ, &status);
+	if (ret)
+		return ret;
+
+	if (status)
+		return -EIO;
+
+	return usb4_switch_op_read_data(sw, buf, dwords);
+}
+
+/**
+ * usb4_switch_drom_read() - Read arbitrary bytes from USB4 router DROM
+ * @sw: USB4 router
+ *
+ * Uses USB4 router operations to read router DROM. For devices this
+ * should always work but for hosts it may return %-EOPNOTSUPP in which
+ * case the host router does not have DROM.
+ */
+int usb4_switch_drom_read(struct tb_switch *sw, unsigned int address, void *buf,
+			  size_t size)
+{
+	return usb4_switch_do_read_data(sw, address, buf, size,
+					usb4_switch_drom_read_block);
+}
+
+static int usb4_set_port_configured(struct tb_port *port, bool configured)
+{
+	int ret;
+	u32 val;
+
+	ret = tb_port_read(port, &val, TB_CFG_PORT,
+			   port->cap_usb4 + PORT_CS_19, 1);
+	if (ret)
+		return ret;
+
+	if (configured)
+		val |= PORT_CS_19_PC;
+	else
+		val &= ~PORT_CS_19_PC;
+
+	return tb_port_write(port, &val, TB_CFG_PORT,
+			     port->cap_usb4 + PORT_CS_19, 1);
+}
+
+/**
+ * usb4_switch_configure_link() - Set upstream USB4 link configured
+ * @sw: USB4 router
+ *
+ * Sets the upstream USB4 link to be configured for power management
+ * purposes.
+ */
+int usb4_switch_configure_link(struct tb_switch *sw)
+{
+	struct tb_port *up;
+
+	if (!tb_route(sw))
+		return 0;
+
+	up = tb_upstream_port(sw);
+	return usb4_set_port_configured(up, true);
+}
+
+/**
+ * usb4_switch_unconfigure_link() - Un-set upstream USB4 link configuration
+ * @sw: USB4 router
+ *
+ * Reverse of usb4_switch_configure_link().
+ */
+void usb4_switch_unconfigure_link(struct tb_switch *sw)
+{
+	struct tb_port *up;
+
+	if (sw->is_unplugged || !tb_route(sw))
+		return;
+
+	up = tb_upstream_port(sw);
+	usb4_set_port_configured(up, false);
+}
+
+/**
+ * usb4_switch_lane_bonding_possible() - Are conditions met for lane bonding
+ * @sw: USB4 router
+ *
+ * Checks whether conditions are met so that lane bonding can be
+ * established with the upstream router. Call only for device routers.
+ */
+bool usb4_switch_lane_bonding_possible(struct tb_switch *sw)
+{
+	struct tb_port *up;
+	int ret;
+	u32 val;
+
+	up = tb_upstream_port(sw);
+	ret = tb_port_read(up, &val, TB_CFG_PORT, up->cap_usb4 + PORT_CS_18, 1);
+	if (ret)
+		return false;
+
+	return !!(val & PORT_CS_18_BE);
+}
+
+/**
+ * usb4_switch_set_sleep() - Prepare the router to enter sleep
+ * @sw: USB4 router
+ *
+ * Enables wakes and sets sleep bit for the router. Returns when the
+ * router sleep ready bit has been asserted.
+ */
+int usb4_switch_set_sleep(struct tb_switch *sw)
+{
+	int ret;
+	u32 val;
+
+	/* Set sleep bit and wait for sleep ready to be asserted */
+	ret = tb_sw_read(sw, &val, TB_CFG_SWITCH, ROUTER_CS_5, 1);
+	if (ret)
+		return ret;
+
+	val |= ROUTER_CS_5_SLP;
+
+	ret = tb_sw_write(sw, &val, TB_CFG_SWITCH, ROUTER_CS_5, 1);
+	if (ret)
+		return ret;
+
+	return usb4_switch_wait_for_bit(sw, ROUTER_CS_6, ROUTER_CS_6_SLPR,
+					ROUTER_CS_6_SLPR, 500);
+}
+
+/**
+ * usb4_switch_nvm_sector_size() - Return router NVM sector size
+ * @sw: USB4 router
+ *
+ * If the router supports NVM operations this function returns the NVM
+ * sector size in bytes. If NVM operations are not supported returns
+ * %-EOPNOTSUPP.
+ */
+int usb4_switch_nvm_sector_size(struct tb_switch *sw)
+{
+	u32 metadata;
+	u8 status;
+	int ret;
+
+	ret = usb4_switch_op(sw, USB4_SWITCH_OP_NVM_SECTOR_SIZE, &status);
+	if (ret)
+		return ret;
+
+	if (status)
+		return status == 0x2 ? -EOPNOTSUPP : -EIO;
+
+	ret = usb4_switch_op_read_metadata(sw, &metadata);
+	if (ret)
+		return ret;
+
+	return metadata & USB4_NVM_SECTOR_SIZE_MASK;
+}
+
+static int usb4_switch_nvm_read_block(struct tb_switch *sw,
+	unsigned int dwaddress, void *buf, size_t dwords)
+{
+	u8 status = 0;
+	u32 metadata;
+	int ret;
+
+	metadata = (dwords << USB4_NVM_READ_LENGTH_SHIFT) &
+		   USB4_NVM_READ_LENGTH_MASK;
+	metadata |= (dwaddress << USB4_NVM_READ_OFFSET_SHIFT) &
+		   USB4_NVM_READ_OFFSET_MASK;
+
+	ret = usb4_switch_op_write_metadata(sw, metadata);
+	if (ret)
+		return ret;
+
+	ret = usb4_switch_op(sw, USB4_SWITCH_OP_NVM_READ, &status);
+	if (ret)
+		return ret;
+
+	if (status)
+		return -EIO;
+
+	return usb4_switch_op_read_data(sw, buf, dwords);
+}
+
+/**
+ * usb4_switch_nvm_read() - Read arbitrary bytes from router NVM
+ * @sw: USB4 router
+ * @address: Starting address in bytes
+ * @buf: Read data is placed here
+ * @size: How many bytes to read
+ *
+ * Reads NVM contents of the router. If NVM is not supported returns
+ * %-EOPNOTSUPP.
+ */
+int usb4_switch_nvm_read(struct tb_switch *sw, unsigned int address, void *buf,
+			 size_t size)
+{
+	return usb4_switch_do_read_data(sw, address, buf, size,
+					usb4_switch_nvm_read_block);
+}
+
+static int usb4_switch_nvm_set_offset(struct tb_switch *sw,
+				      unsigned int address)
+{
+	u32 metadata, dwaddress;
+	u8 status = 0;
+	int ret;
+
+	dwaddress = address / 4;
+	metadata = (dwaddress << USB4_NVM_SET_OFFSET_SHIFT) &
+		   USB4_NVM_SET_OFFSET_MASK;
+
+	ret = usb4_switch_op_write_metadata(sw, metadata);
+	if (ret)
+		return ret;
+
+	ret = usb4_switch_op(sw, USB4_SWITCH_OP_NVM_SET_OFFSET, &status);
+	if (ret)
+		return ret;
+
+	return status ? -EIO : 0;
+}
+
+static int usb4_switch_nvm_write_next_block(struct tb_switch *sw,
+					    const void *buf, size_t dwords)
+{
+	u8 status;
+	int ret;
+
+	ret = usb4_switch_op_write_data(sw, buf, dwords);
+	if (ret)
+		return ret;
+
+	ret = usb4_switch_op(sw, USB4_SWITCH_OP_NVM_WRITE, &status);
+	if (ret)
+		return ret;
+
+	return status ? -EIO : 0;
+}
+
+/**
+ * usb4_switch_nvm_write() - Write to the router NVM
+ * @sw: USB4 router
+ * @address: Start address where to write in bytes
+ * @buf: Pointer to the data to write
+ * @size: Size of @buf in bytes
+ *
+ * Writes @buf to the router NVM using USB4 router operations. If NVM
+ * write is not supported returns %-EOPNOTSUPP.
+ */
+int usb4_switch_nvm_write(struct tb_switch *sw, unsigned int address,
+			  const void *buf, size_t size)
+{
+	int ret;
+
+	ret = usb4_switch_nvm_set_offset(sw, address);
+	if (ret)
+		return ret;
+
+	return usb4_switch_do_write_data(sw, address, buf, size,
+					 usb4_switch_nvm_write_next_block);
+}
+
+/**
+ * usb4_switch_nvm_authenticate() - Authenticate new NVM
+ * @sw: USB4 router
+ *
+ * After the new NVM has been written via usb4_switch_nvm_write(), this
+ * function triggers NVM authentication process. If the authentication
+ * is successful the router is power cycled and the new NVM starts
+ * running. In case of failure returns negative errno.
+ */
+int usb4_switch_nvm_authenticate(struct tb_switch *sw)
+{
+	u8 status = 0;
+	int ret;
+
+	ret = usb4_switch_op(sw, USB4_SWITCH_OP_NVM_AUTH, &status);
+	if (ret)
+		return ret;
+
+	switch (status) {
+	case 0x0:
+		tb_sw_dbg(sw, "NVM authentication successful\n");
+		return 0;
+	case 0x1:
+		return -EINVAL;
+	case 0x2:
+		return -EAGAIN;
+	case 0x3:
+		return -EOPNOTSUPP;
+	default:
+		return -EIO;
+	}
+}
+
+/**
+ * usb4_switch_query_dp_resource() - Query availability of DP IN resource
+ * @sw: USB4 router
+ * @in: DP IN adapter
+ *
+ * For DP tunneling this function can be used to query availability of
+ * DP IN resource. Returns true if the resource is available for DP
+ * tunneling, false otherwise.
+ */
+bool usb4_switch_query_dp_resource(struct tb_switch *sw, struct tb_port *in)
+{
+	u8 status;
+	int ret;
+
+	ret = usb4_switch_op_write_metadata(sw, in->port);
+	if (ret)
+		return false;
+
+	ret = usb4_switch_op(sw, USB4_SWITCH_OP_QUERY_DP_RESOURCE, &status);
+	/*
+	 * If DP resource allocation is not supported assume it is
+	 * always available.
+	 */
+	if (ret == -EOPNOTSUPP)
+		return true;
+	else if (ret)
+		return false;
+
+	return !status;
+}
+
+/**
+ * usb4_switch_alloc_dp_resource() - Allocate DP IN resource
+ * @sw: USB4 router
+ * @in: DP IN adapter
+ *
+ * Allocates DP IN resource for DP tunneling using USB4 router
+ * operations. If the resource was allocated returns %0. Otherwise
+ * returns negative errno, in particular %-EBUSY if the resource is
+ * already allocated.
+ */
+int usb4_switch_alloc_dp_resource(struct tb_switch *sw, struct tb_port *in)
+{
+	u8 status;
+	int ret;
+
+	ret = usb4_switch_op_write_metadata(sw, in->port);
+	if (ret)
+		return ret;
+
+	ret = usb4_switch_op(sw, USB4_SWITCH_OP_ALLOC_DP_RESOURCE, &status);
+	if (ret == -EOPNOTSUPP)
+		return 0;
+	else if (ret)
+		return ret;
+
+	return status ? -EBUSY : 0;
+}
+
+/**
+ * usb4_switch_dealloc_dp_resource() - Releases allocated DP IN resource
+ * @sw: USB4 router
+ * @in: DP IN adapter
+ *
+ * Releases the previously allocated DP IN resource.
+ */
+int usb4_switch_dealloc_dp_resource(struct tb_switch *sw, struct tb_port *in)
+{
+	u8 status;
+	int ret;
+
+	ret = usb4_switch_op_write_metadata(sw, in->port);
+	if (ret)
+		return ret;
+
+	ret = usb4_switch_op(sw, USB4_SWITCH_OP_DEALLOC_DP_RESOURCE, &status);
+	if (ret == -EOPNOTSUPP)
+		return 0;
+	else if (ret)
+		return ret;
+
+	return status ? -EIO : 0;
+}
+
+static int usb4_port_idx(const struct tb_switch *sw, const struct tb_port *port)
+{
+	struct tb_port *p;
+	int usb4_idx = 0;
+
+	/* Assume port is primary */
+	tb_switch_for_each_port(sw, p) {
+		if (!tb_port_is_null(p))
+			continue;
+		if (tb_is_upstream_port(p))
+			continue;
+		if (!p->link_nr) {
+			if (p == port)
+				break;
+			usb4_idx++;
+		}
+	}
+
+	return usb4_idx;
+}
+
+/**
+ * usb4_switch_map_pcie_down() - Map USB4 port to a PCIe downstream adapter
+ * @sw: USB4 router
+ * @port: USB4 port
+ *
+ * USB4 routers have direct mapping between USB4 ports and PCIe
+ * downstream adapters where the PCIe topology is extended. This
+ * function returns the corresponding downstream PCIe adapter or %NULL
+ * if no such mapping was possible.
+ */
+struct tb_port *usb4_switch_map_pcie_down(struct tb_switch *sw,
+					  const struct tb_port *port)
+{
+	int usb4_idx = usb4_port_idx(sw, port);
+	struct tb_port *p;
+	int pcie_idx = 0;
+
+	/* Find PCIe down port matching usb4_port */
+	tb_switch_for_each_port(sw, p) {
+		if (!tb_port_is_pcie_down(p))
+			continue;
+
+		if (pcie_idx == usb4_idx && !tb_pci_port_is_enabled(p))
+			return p;
+
+		pcie_idx++;
+	}
+
+	return NULL;
+}
+
+/**
+ * usb4_port_unlock() - Unlock USB4 downstream port
+ * @port: USB4 port to unlock
+ *
+ * Unlocks USB4 downstream port so that the connection manager can
+ * access the router below this port.
+ */
+int usb4_port_unlock(struct tb_port *port)
+{
+	int ret;
+	u32 val;
+
+	ret = tb_port_read(port, &val, TB_CFG_PORT, ADP_CS_4, 1);
+	if (ret)
+		return ret;
+
+	val &= ~ADP_CS_4_LCK;
+	return tb_port_write(port, &val, TB_CFG_PORT, ADP_CS_4, 1);
+}
diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
index 880d784398a3..053f918e00e8 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -1220,7 +1220,13 @@ struct tb_xdomain *tb_xdomain_alloc(struct tb *tb, struct device *parent,
 				    u64 route, const uuid_t *local_uuid,
 				    const uuid_t *remote_uuid)
 {
+	struct tb_switch *parent_sw = tb_to_switch(parent);
 	struct tb_xdomain *xd;
+	struct tb_port *down;
+
+	/* Make sure the downstream domain is accessible */
+	down = tb_port_at(route, parent_sw);
+	tb_port_unlock(down);
 
 	xd = kzalloc(sizeof(*xd), GFP_KERNEL);
 	if (!xd)
-- 
2.24.0

