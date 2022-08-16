Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73B875953D8
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 09:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbiHPHd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 03:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbiHPHda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 03:33:30 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2AC18C2FB
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 21:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660623144; x=1692159144;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kr3iVDL+uXNt+lSenE3T38nJlWk2Nxsc9bb3GJ6DQS0=;
  b=UcXwjkyx3mcG/lB5peZACkb7+8epOTyZ5aBhCFysAYIpn0j2XUF1C7RO
   4tAwP3VfS7/4L05efK0oyJDWgP11rf1bDi93joPnf2fUpesbyUh+C2WnI
   xwkd0ruftfNh1/4/nSxZhwFo8OqB4wVPcpYBrD2J+2zav7ZZmpU1O9LsD
   ln815M79CacqhKGfeXevOBsk1zoag7QomWC2EJR1qGFMGsIIfo+33VsLP
   OTpLha2rXZTrkpJ4IRN57cfxpz0isLdV9+7Hr4wcx4ofi5n3XBuMN0AfE
   Wa5awUt/8nxCVD71H0E3eaawxzGjvDtDH/NpOjoy/N7pdIGLZG5RfoBbU
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="290872594"
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="290872594"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 21:12:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="852505577"
Received: from bswcg005.iind.intel.com ([10.224.174.23])
  by fmsmga006.fm.intel.com with ESMTP; 15 Aug 2022 21:12:20 -0700
From:   m.chetan.kumar@intel.com
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@linux.intel.com,
        linuxwwan@intel.com,
        Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>,
        Mishra Soumya Prakash <soumya.prakash.mishra@intel.com>
Subject: [PATCH net-next 4/5] net: wwan: t7xx: Enable devlink based fw flashing and coredump collection
Date:   Tue, 16 Aug 2022 09:54:05 +0530
Message-Id: <20220816042405.2416972-1-m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

This patch brings-in support for t7xx wwan device firmware flashing &
coredump collection using devlink.

Driver Registers with Devlink framework.
Implements devlink ops flash_update callback that programs modem firmware.
Creates region & snapshot required for device coredump log collection.
On early detection of wwan device in fastboot mode driver sets up CLDMA0 HW
tx/rx queues for raw data transfer then registers with devlink framework.
Upon receiving firmware image & partition details driver sends fastboot
commands for flashing the firmware.

In this flow the fastboot command & response gets exchanged between driver
and device. Once firmware flashing is success completion status is reported
to user space application.

Below is the devlink command usage for firmware flashing

$devlink dev flash pci/$BDF file ABC.img component ABC

Note: ABC.img is the firmware to be programmed to "ABC" partition.

In case of coredump collection when wwan device encounters an exception
it reboots & stays in fastboot mode for coredump collection by host driver.
On detecting exception state driver collects the core dump, creates the
devlink region & reports an event to user space application for dump
collection. The user space application invokes devlink region read command
for dump collection.

Below are the devlink commands used for coredump collection.

devlink region new pci/$BDF/mr_dump
devlink region read pci/$BDF/mr_dump snapshot $ID address $ADD length $LEN
devlink region del pci/$BDF/mr_dump snapshot $ID

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Signed-off-by: Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
Signed-off-by: Mishra Soumya Prakash <soumya.prakash.mishra@intel.com>
---
 drivers/net/wwan/Kconfig                   |   1 +
 drivers/net/wwan/t7xx/Makefile             |   4 +-
 drivers/net/wwan/t7xx/t7xx_pci.c           |  14 +-
 drivers/net/wwan/t7xx/t7xx_pci.h           |   2 +
 drivers/net/wwan/t7xx/t7xx_port.h          |   1 +
 drivers/net/wwan/t7xx/t7xx_port_devlink.c  | 705 +++++++++++++++++++++
 drivers/net/wwan/t7xx/t7xx_port_devlink.h  |  85 +++
 drivers/net/wwan/t7xx/t7xx_port_proxy.c    |   2 +
 drivers/net/wwan/t7xx/t7xx_port_proxy.h    |   1 +
 drivers/net/wwan/t7xx/t7xx_reg.h           |   6 +
 drivers/net/wwan/t7xx/t7xx_state_monitor.c |  36 +-
 drivers/net/wwan/t7xx/t7xx_uevent.c        |  41 ++
 drivers/net/wwan/t7xx/t7xx_uevent.h        |  39 ++
 13 files changed, 932 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_devlink.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_devlink.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_uevent.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_uevent.h

diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig
index 3486ffe94ac4..73b8cc1db0bd 100644
--- a/drivers/net/wwan/Kconfig
+++ b/drivers/net/wwan/Kconfig
@@ -108,6 +108,7 @@ config IOSM
 config MTK_T7XX
 	tristate "MediaTek PCIe 5G WWAN modem T7xx device"
 	depends on PCI
+	select NET_DEVLINK
 	help
 	  Enables MediaTek PCIe based 5G WWAN modem (T7xx series) device.
 	  Adapts WWAN framework and provides network interface like wwan0
diff --git a/drivers/net/wwan/t7xx/Makefile b/drivers/net/wwan/t7xx/Makefile
index df42764b3df8..91ecabf29dd1 100644
--- a/drivers/net/wwan/t7xx/Makefile
+++ b/drivers/net/wwan/t7xx/Makefile
@@ -18,4 +18,6 @@ mtk_t7xx-y:=	t7xx_pci.o \
 		t7xx_hif_dpmaif_rx.o  \
 		t7xx_dpmaif.o \
 		t7xx_netdev.o \
-		t7xx_pci_rescan.o
+		t7xx_pci_rescan.o \
+		t7xx_uevent.o \
+		t7xx_port_devlink.o
diff --git a/drivers/net/wwan/t7xx/t7xx_pci.c b/drivers/net/wwan/t7xx/t7xx_pci.c
index 2f5c6fbe601e..14cdf00cac8e 100644
--- a/drivers/net/wwan/t7xx/t7xx_pci.c
+++ b/drivers/net/wwan/t7xx/t7xx_pci.c
@@ -40,6 +40,7 @@
 #include "t7xx_pci.h"
 #include "t7xx_pci_rescan.h"
 #include "t7xx_pcie_mac.h"
+#include "t7xx_port_devlink.h"
 #include "t7xx_reg.h"
 #include "t7xx_state_monitor.h"
 
@@ -704,16 +705,20 @@ static int t7xx_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	t7xx_pci_infracfg_ao_calc(t7xx_dev);
 	t7xx_mhccif_init(t7xx_dev);
 
-	ret = t7xx_md_init(t7xx_dev);
+	ret = t7xx_devlink_register(t7xx_dev);
 	if (ret)
 		return ret;
 
+	ret = t7xx_md_init(t7xx_dev);
+	if (ret)
+		goto err_devlink_unregister;
+
 	t7xx_pcie_mac_interrupts_dis(t7xx_dev);
 
 	ret = t7xx_interrupt_init(t7xx_dev);
 	if (ret) {
 		t7xx_md_exit(t7xx_dev);
-		return ret;
+		goto err_devlink_unregister;
 	}
 
 	t7xx_rescan_done();
@@ -723,6 +728,10 @@ static int t7xx_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		pci_ignore_hotplug(pdev);
 
 	return 0;
+
+err_devlink_unregister:
+	t7xx_devlink_unregister(t7xx_dev);
+	return ret;
 }
 
 static void t7xx_pci_remove(struct pci_dev *pdev)
@@ -732,6 +741,7 @@ static void t7xx_pci_remove(struct pci_dev *pdev)
 
 	t7xx_dev = pci_get_drvdata(pdev);
 	t7xx_md_exit(t7xx_dev);
+	t7xx_devlink_unregister(t7xx_dev);
 
 	for (i = 0; i < EXT_INT_NUM; i++) {
 		if (!t7xx_dev->intr_handler[i])
diff --git a/drivers/net/wwan/t7xx/t7xx_pci.h b/drivers/net/wwan/t7xx/t7xx_pci.h
index a87c4cae94ef..1017d21aad59 100644
--- a/drivers/net/wwan/t7xx/t7xx_pci.h
+++ b/drivers/net/wwan/t7xx/t7xx_pci.h
@@ -59,6 +59,7 @@ typedef irqreturn_t (*t7xx_intr_callback)(int irq, void *param);
  * @md_pm_lock: protects PCIe sleep lock
  * @sleep_disable_count: PCIe L1.2 lock counter
  * @sleep_lock_acquire: indicates that sleep has been disabled
+ * @dl: devlink struct
  */
 struct t7xx_pci_dev {
 	t7xx_intr_callback	intr_handler[EXT_INT_NUM];
@@ -79,6 +80,7 @@ struct t7xx_pci_dev {
 	spinlock_t		md_pm_lock;		/* Protects PCI resource lock */
 	unsigned int		sleep_disable_count;
 	struct completion	sleep_lock_acquire;
+	struct t7xx_devlink	*dl;
 };
 
 enum t7xx_pm_id {
diff --git a/drivers/net/wwan/t7xx/t7xx_port.h b/drivers/net/wwan/t7xx/t7xx_port.h
index 6a96ee6d9449..070097a658d1 100644
--- a/drivers/net/wwan/t7xx/t7xx_port.h
+++ b/drivers/net/wwan/t7xx/t7xx_port.h
@@ -129,6 +129,7 @@ struct t7xx_port {
 	int				rx_length_th;
 	bool				chan_enable;
 	struct task_struct		*thread;
+	struct t7xx_devlink	*dl;
 };
 
 int t7xx_get_port_mtu(struct t7xx_port *port);
diff --git a/drivers/net/wwan/t7xx/t7xx_port_devlink.c b/drivers/net/wwan/t7xx/t7xx_port_devlink.c
new file mode 100644
index 000000000000..026a1db42f69
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_port_devlink.c
@@ -0,0 +1,705 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2022, Intel Corporation.
+ */
+
+#include <linux/bitfield.h>
+#include <linux/debugfs.h>
+#include <linux/vmalloc.h>
+
+#include "t7xx_hif_cldma.h"
+#include "t7xx_pci_rescan.h"
+#include "t7xx_port_devlink.h"
+#include "t7xx_port_proxy.h"
+#include "t7xx_state_monitor.h"
+#include "t7xx_uevent.h"
+
+static struct t7xx_devlink_region_info t7xx_devlink_region_list[T7XX_TOTAL_REGIONS] = {
+	{"mr_dump", T7XX_MRDUMP_SIZE},
+	{"lk_dump", T7XX_LKDUMP_SIZE},
+};
+
+static int t7xx_devlink_port_read(struct t7xx_port *port, char *buf, size_t count)
+{
+	int ret = 0, read_len;
+	struct sk_buff *skb;
+
+	spin_lock_irq(&port->rx_wq.lock);
+	if (skb_queue_empty(&port->rx_skb_list)) {
+		ret = wait_event_interruptible_locked_irq(port->rx_wq,
+							  !skb_queue_empty(&port->rx_skb_list));
+		if (ret == -ERESTARTSYS) {
+			spin_unlock_irq(&port->rx_wq.lock);
+			return -EINTR;
+		}
+	}
+	skb = skb_dequeue(&port->rx_skb_list);
+	spin_unlock_irq(&port->rx_wq.lock);
+
+	read_len = count > skb->len ? skb->len : count;
+	memcpy(buf, skb->data, read_len);
+	dev_kfree_skb(skb);
+
+	return ret ? ret : read_len;
+}
+
+static int t7xx_devlink_port_write(struct t7xx_port *port, const char *buf, size_t count)
+{
+	const struct t7xx_port_conf *port_conf = port->port_conf;
+	size_t actual_count;
+	struct sk_buff *skb;
+	int ret, txq_mtu;
+
+	txq_mtu = t7xx_get_port_mtu(port);
+	if (txq_mtu < 0)
+		return -EINVAL;
+
+	actual_count = count > txq_mtu ? txq_mtu : count;
+	skb = __dev_alloc_skb(actual_count, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
+	skb_put_data(skb, buf, actual_count);
+	ret = t7xx_port_send_raw_skb(port, skb);
+	if (ret) {
+		dev_err(port->dev, "write error on %s, size: %zu, ret: %d\n",
+			port_conf->name, actual_count, ret);
+		dev_kfree_skb(skb);
+		return ret;
+	}
+
+	return actual_count;
+}
+
+static int t7xx_devlink_fb_handle_response(struct t7xx_port *port, int *data)
+{
+	int ret = 0, index = 0, return_data = 0, read_bytes;
+	char status[T7XX_FB_RESPONSE_SIZE + 1];
+
+	while (index < T7XX_FB_RESP_COUNT) {
+		index++;
+		read_bytes = t7xx_devlink_port_read(port, status, T7XX_FB_RESPONSE_SIZE);
+		if (read_bytes < 0) {
+			dev_err(port->dev, "status read failed");
+			ret = -EIO;
+			break;
+		}
+
+		status[read_bytes] = '\0';
+		if (!strncmp(status, T7XX_FB_RESP_INFO, strlen(T7XX_FB_RESP_INFO))) {
+			break;
+		} else if (!strncmp(status, T7XX_FB_RESP_OKAY, strlen(T7XX_FB_RESP_OKAY))) {
+			break;
+		} else if (!strncmp(status, T7XX_FB_RESP_FAIL, strlen(T7XX_FB_RESP_FAIL))) {
+			ret = -EPROTO;
+			break;
+		} else if (!strncmp(status, T7XX_FB_RESP_DATA, strlen(T7XX_FB_RESP_DATA))) {
+			if (data) {
+				if (!kstrtoint(status + strlen(T7XX_FB_RESP_DATA), 16,
+					       &return_data)) {
+					*data = return_data;
+				} else {
+					dev_err(port->dev, "kstrtoint error!\n");
+					ret = -EPROTO;
+				}
+			}
+			break;
+		}
+	}
+
+	return ret;
+}
+
+static int t7xx_devlink_fb_raw_command(char *cmd, struct t7xx_port *port, int *data)
+{
+	int ret, cmd_size = strlen(cmd);
+
+	if (cmd_size > T7XX_FB_COMMAND_SIZE) {
+		dev_err(port->dev, "command length %d is long\n", cmd_size);
+		return -EINVAL;
+	}
+
+	if (cmd_size != t7xx_devlink_port_write(port, cmd, cmd_size)) {
+		dev_err(port->dev, "raw command = %s write failed\n", cmd);
+		return -EIO;
+	}
+
+	dev_dbg(port->dev, "raw command = %s written to the device\n", cmd);
+	ret = t7xx_devlink_fb_handle_response(port, data);
+	if (ret)
+		dev_err(port->dev, "raw command = %s response FAILURE:%d\n", cmd, ret);
+
+	return ret;
+}
+
+static int t7xx_devlink_fb_send_buffer(struct t7xx_port *port, const u8 *buf, size_t size)
+{
+	size_t remaining = size, offset = 0, len;
+	int write_done;
+
+	if (!size)
+		return -EINVAL;
+
+	while (remaining) {
+		len = min_t(size_t, remaining, CLDMA_DEDICATED_Q_BUFF_SZ);
+		write_done = t7xx_devlink_port_write(port, buf + offset, len);
+
+		if (write_done < 0) {
+			dev_err(port->dev, "write to device failed in %s", __func__);
+			return -EIO;
+		} else if (write_done != len) {
+			dev_err(port->dev, "write Error. Only %d/%zu bytes written",
+				write_done, len);
+			return -EIO;
+		}
+
+		remaining -= len;
+		offset += len;
+	}
+
+	return 0;
+}
+
+static int t7xx_devlink_fb_download_command(struct t7xx_port *port, size_t size)
+{
+	char download_command[T7XX_FB_COMMAND_SIZE];
+
+	snprintf(download_command, sizeof(download_command), "%s:%08zx",
+		 T7XX_FB_CMD_DOWNLOAD, size);
+	return t7xx_devlink_fb_raw_command(download_command, port, NULL);
+}
+
+static int t7xx_devlink_fb_download(struct t7xx_port *port, const u8 *buf, size_t size)
+{
+	int ret;
+
+	if (size <= 0 || size > SIZE_MAX) {
+		dev_err(port->dev, "file is too large to download");
+		return -EINVAL;
+	}
+
+	ret = t7xx_devlink_fb_download_command(port, size);
+	if (ret)
+		return ret;
+
+	ret = t7xx_devlink_fb_send_buffer(port, buf, size);
+	if (ret)
+		return ret;
+
+	return t7xx_devlink_fb_handle_response(port, NULL);
+}
+
+static int t7xx_devlink_fb_flash(const char *cmd, struct t7xx_port *port)
+{
+	char flash_command[T7XX_FB_COMMAND_SIZE];
+
+	snprintf(flash_command, sizeof(flash_command), "%s:%s", T7XX_FB_CMD_FLASH, cmd);
+	return t7xx_devlink_fb_raw_command(flash_command, port, NULL);
+}
+
+static int t7xx_devlink_fb_flash_partition(const char *partition, const u8 *buf,
+					   struct t7xx_port *port, size_t size)
+{
+	int ret;
+
+	ret = t7xx_devlink_fb_download(port, buf, size);
+	if (ret)
+		return ret;
+
+	return t7xx_devlink_fb_flash(partition, port);
+}
+
+static int t7xx_devlink_fb_get_core(struct t7xx_port *port)
+{
+	struct t7xx_devlink_region_info *mrdump_region;
+	char mrdump_complete_event[T7XX_FB_EVENT_SIZE];
+	u32 mrd_mb = T7XX_MRDUMP_SIZE / (1024 * 1024);
+	struct t7xx_devlink *dl = port->dl;
+	int clen, dlen = 0, result = 0;
+	unsigned long long zipsize = 0;
+	char mcmd[T7XX_FB_MCMD_SIZE];
+	size_t offset_dlen = 0;
+	char *mdata;
+
+	set_bit(T7XX_MRDUMP_STATUS, &dl->status);
+	mdata = kmalloc(T7XX_FB_MDATA_SIZE, GFP_KERNEL);
+	if (!mdata) {
+		result = -ENOMEM;
+		goto get_core_exit;
+	}
+
+	mrdump_region = dl->dl_region_info[T7XX_MRDUMP_INDEX];
+	mrdump_region->dump = vmalloc(mrdump_region->default_size);
+	if (!mrdump_region->dump) {
+		kfree(mdata);
+		result = -ENOMEM;
+		goto get_core_exit;
+	}
+
+	result = t7xx_devlink_fb_raw_command(T7XX_FB_CMD_OEM_MRDUMP, port, NULL);
+	if (result) {
+		dev_err(port->dev, "%s command failed\n", T7XX_FB_CMD_OEM_MRDUMP);
+		vfree(mrdump_region->dump);
+		kfree(mdata);
+		goto get_core_exit;
+	}
+
+	while (mrdump_region->default_size > offset_dlen) {
+		clen = t7xx_devlink_port_read(port, mcmd, sizeof(mcmd));
+		if (clen == strlen(T7XX_FB_CMD_RTS) &&
+		    (!strncmp(mcmd, T7XX_FB_CMD_RTS, strlen(T7XX_FB_CMD_RTS)))) {
+			memset(mdata, 0, T7XX_FB_MDATA_SIZE);
+			dlen = 0;
+			memset(mcmd, 0, sizeof(mcmd));
+			clen = snprintf(mcmd, sizeof(mcmd), "%s", T7XX_FB_CMD_CTS);
+
+			if (t7xx_devlink_port_write(port, mcmd, clen) != clen) {
+				dev_err(port->dev, "write for _CTS failed:%d\n", clen);
+				goto get_core_free_mem;
+			}
+
+			dlen = t7xx_devlink_port_read(port, mdata, T7XX_FB_MDATA_SIZE);
+			if (dlen <= 0) {
+				dev_err(port->dev, "read data error(%d)\n", dlen);
+				goto get_core_free_mem;
+			}
+
+			zipsize += (unsigned long long)(dlen);
+			memcpy(mrdump_region->dump + offset_dlen, mdata, dlen);
+			offset_dlen += dlen;
+			memset(mcmd, 0, sizeof(mcmd));
+			clen = snprintf(mcmd, sizeof(mcmd), "%s", T7XX_FB_CMD_FIN);
+			if (t7xx_devlink_port_write(port, mcmd, clen) != clen) {
+				dev_err(port->dev, "%s: _FIN failed, (Read %05d:%05llu)\n",
+					__func__, clen, zipsize);
+				goto get_core_free_mem;
+			}
+		} else if ((clen == strlen(T7XX_FB_RESP_MRDUMP_DONE)) &&
+			  (!strncmp(mcmd, T7XX_FB_RESP_MRDUMP_DONE,
+				    strlen(T7XX_FB_RESP_MRDUMP_DONE)))) {
+			dev_dbg(port->dev, "%s! size:%zd\n", T7XX_FB_RESP_MRDUMP_DONE, offset_dlen);
+			mrdump_region->actual_size = offset_dlen;
+			snprintf(mrdump_complete_event, sizeof(mrdump_complete_event),
+				 "%s size=%zu", T7XX_UEVENT_MRDUMP_READY, offset_dlen);
+			t7xx_uevent_send(dl->dev, mrdump_complete_event);
+			kfree(mdata);
+			result = 0;
+			goto get_core_exit;
+		} else {
+			dev_err(port->dev, "getcore protocol error (read len %05d)\n", clen);
+			goto get_core_free_mem;
+		}
+	}
+
+	dev_err(port->dev, "mrdump exceeds %uMB size. Discarded!", mrd_mb);
+	t7xx_uevent_send(port->dev, T7XX_UEVENT_MRD_DISCD);
+
+get_core_free_mem:
+	kfree(mdata);
+	vfree(mrdump_region->dump);
+	clear_bit(T7XX_MRDUMP_STATUS, &dl->status);
+	return -EPROTO;
+
+get_core_exit:
+	clear_bit(T7XX_MRDUMP_STATUS, &dl->status);
+	return result;
+}
+
+static int t7xx_devlink_fb_dump_log(struct t7xx_port *port)
+{
+	struct t7xx_devlink_region_info *lkdump_region;
+	char lkdump_complete_event[T7XX_FB_EVENT_SIZE];
+	struct t7xx_devlink *dl = port->dl;
+	int dlen, datasize = 0, result;
+	size_t offset_dlen = 0;
+	u8 *data;
+
+	set_bit(T7XX_LKDUMP_STATUS, &dl->status);
+	result = t7xx_devlink_fb_raw_command(T7XX_FB_CMD_OEM_LKDUMP, port, &datasize);
+	if (result) {
+		dev_err(port->dev, "%s command returns failure\n", T7XX_FB_CMD_OEM_LKDUMP);
+		goto lkdump_exit;
+	}
+
+	lkdump_region = dl->dl_region_info[T7XX_LKDUMP_INDEX];
+	if (datasize > lkdump_region->default_size) {
+		dev_err(port->dev, "lkdump size is more than %dKB. Discarded!",
+			T7XX_LKDUMP_SIZE / 1024);
+		t7xx_uevent_send(dl->dev, T7XX_UEVENT_LKD_DISCD);
+		result = -EPROTO;
+		goto lkdump_exit;
+	}
+
+	data = kzalloc(datasize, GFP_KERNEL);
+	if (!data) {
+		result = -ENOMEM;
+		goto lkdump_exit;
+	}
+
+	lkdump_region->dump = vmalloc(lkdump_region->default_size);
+	if (!lkdump_region->dump) {
+		kfree(data);
+		result = -ENOMEM;
+		goto lkdump_exit;
+	}
+
+	while (datasize > 0) {
+		dlen = t7xx_devlink_port_read(port, data, datasize);
+		if (dlen <= 0) {
+			dev_err(port->dev, "lkdump read error ret = %d", dlen);
+			kfree(data);
+			result = -EPROTO;
+			goto lkdump_exit;
+		}
+
+		memcpy(lkdump_region->dump + offset_dlen, data, dlen);
+		datasize -= dlen;
+		offset_dlen += dlen;
+	}
+
+	dev_dbg(port->dev, "LKDUMP DONE! size:%zd\n", offset_dlen);
+	lkdump_region->actual_size = offset_dlen;
+	snprintf(lkdump_complete_event, sizeof(lkdump_complete_event), "%s size=%zu",
+		 T7XX_UEVENT_LKDUMP_READY, offset_dlen);
+	t7xx_uevent_send(dl->dev, lkdump_complete_event);
+	kfree(data);
+	clear_bit(T7XX_LKDUMP_STATUS, &dl->status);
+	return t7xx_devlink_fb_handle_response(port, NULL);
+
+lkdump_exit:
+	clear_bit(T7XX_LKDUMP_STATUS, &dl->status);
+	return result;
+}
+
+static int t7xx_devlink_flash_update(struct devlink *devlink,
+				     struct devlink_flash_update_params *params,
+				     struct netlink_ext_ack *extack)
+{
+	struct t7xx_devlink *dl = devlink_priv(devlink);
+	const char *component = params->component;
+	const struct firmware *fw = params->fw;
+	char flash_event[T7XX_FB_EVENT_SIZE];
+	struct t7xx_port *port;
+	int ret;
+
+	port = dl->port;
+	if (port->dl->mode != T7XX_FB_DL_MODE) {
+		dev_err(port->dev, "Modem is not in fastboot download mode!");
+		ret = -EPERM;
+		goto err_out;
+	}
+
+	if (dl->status != T7XX_DEVLINK_IDLE) {
+		dev_err(port->dev, "Modem is busy!");
+		ret = -EBUSY;
+		goto err_out;
+	}
+
+	if (!component || !fw->data) {
+		ret = -EINVAL;
+		goto err_out;
+	}
+
+	set_bit(T7XX_FLASH_STATUS, &dl->status);
+	dev_dbg(port->dev, "flash partition name:%s binary size:%zu\n", component, fw->size);
+	ret = t7xx_devlink_fb_flash_partition(component, fw->data, port, fw->size);
+	if (ret) {
+		devlink_flash_update_status_notify(devlink, "flashing failure!",
+						   params->component, 0, 0);
+		snprintf(flash_event, sizeof(flash_event), "%s for [%s]",
+			 T7XX_UEVENT_FLASHING_FAILURE, params->component);
+	} else {
+		devlink_flash_update_status_notify(devlink, "flashing success!",
+						   params->component, 0, 0);
+		snprintf(flash_event, sizeof(flash_event), "%s for [%s]",
+			 T7XX_UEVENT_FLASHING_SUCCESS, params->component);
+	}
+
+	t7xx_uevent_send(dl->dev, flash_event);
+
+err_out:
+	clear_bit(T7XX_FLASH_STATUS, &dl->status);
+	return ret;
+}
+
+static int t7xx_devlink_reload_down(struct devlink *devlink, bool netns_change,
+				    enum devlink_reload_action action,
+				    enum devlink_reload_limit limit,
+				    struct netlink_ext_ack *extack)
+{
+	struct t7xx_devlink *dl = devlink_priv(devlink);
+
+	switch (action) {
+	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
+		dl->set_fastboot_dl = 1;
+		return 0;
+	case DEVLINK_RELOAD_ACTION_FW_ACTIVATE:
+		return t7xx_devlink_fb_raw_command(T7XX_FB_CMD_REBOOT, dl->port, NULL);
+	default:
+		/* Unsupported action should not get to this function */
+		return -EOPNOTSUPP;
+	}
+}
+
+static int t7xx_devlink_reload_up(struct devlink *devlink,
+				  enum devlink_reload_action action,
+				  enum devlink_reload_limit limit,
+				  u32 *actions_performed,
+				  struct netlink_ext_ack *extack)
+{
+	struct t7xx_devlink *dl = devlink_priv(devlink);
+	*actions_performed = BIT(action);
+	switch (action) {
+	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
+	case DEVLINK_RELOAD_ACTION_FW_ACTIVATE:
+		t7xx_rescan_queue_work(dl->mtk_dev->pdev);
+		return 0;
+	default:
+		/* Unsupported action should not get to this function */
+		return -EOPNOTSUPP;
+	}
+}
+
+/* Call back function for devlink ops */
+static const struct devlink_ops devlink_flash_ops = {
+	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT,
+	.flash_update = t7xx_devlink_flash_update,
+	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
+			  BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
+	.reload_down = t7xx_devlink_reload_down,
+	.reload_up = t7xx_devlink_reload_up,
+};
+
+static int t7xx_devlink_region_snapshot(struct devlink *dl, const struct devlink_region_ops *ops,
+					struct netlink_ext_ack *extack, u8 **data)
+{
+	struct t7xx_devlink_region_info *region_info = ops->priv;
+	struct t7xx_devlink *t7xx_dl = devlink_priv(dl);
+	u8 *snapshot_mem;
+
+	if (t7xx_dl->status != T7XX_DEVLINK_IDLE) {
+		dev_err(t7xx_dl->dev, "Modem is busy!");
+		return -EBUSY;
+	}
+
+	dev_dbg(t7xx_dl->dev, "accessed devlink region:%s index:%d", ops->name, region_info->entry);
+	if (!strncmp(ops->name, "mr_dump", strlen("mr_dump"))) {
+		if (!region_info->dump) {
+			dev_err(t7xx_dl->dev, "devlink region:%s dump memory is not valid!",
+				region_info->region_name);
+			return -ENOMEM;
+		}
+
+		snapshot_mem = vmalloc(region_info->default_size);
+		if (!snapshot_mem)
+			return -ENOMEM;
+
+		memcpy(snapshot_mem, region_info->dump, region_info->default_size);
+		*data = snapshot_mem;
+	} else if (!strncmp(ops->name, "lk_dump", strlen("lk_dump"))) {
+		int ret;
+
+		ret = t7xx_devlink_fb_dump_log(t7xx_dl->port);
+		if (ret)
+			return ret;
+
+		*data = region_info->dump;
+	}
+
+	return 0;
+}
+
+/* To create regions for dump files */
+static int t7xx_devlink_create_region(struct t7xx_devlink *dl)
+{
+	struct devlink_region_ops *region_ops;
+	int rc, i;
+
+	region_ops = dl->dl_region_ops;
+	for (i = 0; i < T7XX_TOTAL_REGIONS; i++) {
+		region_ops[i].name = t7xx_devlink_region_list[i].region_name;
+		region_ops[i].snapshot = t7xx_devlink_region_snapshot;
+		region_ops[i].destructor = vfree;
+		dl->dl_region[i] =
+		devlink_region_create(dl->dl_ctx, &region_ops[i], T7XX_MAX_SNAPSHOTS,
+				      t7xx_devlink_region_list[i].default_size);
+
+		if (IS_ERR(dl->dl_region[i])) {
+			rc = PTR_ERR(dl->dl_region[i]);
+			dev_err(dl->dev, "devlink region fail,err %d", rc);
+			for ( ; i >= 0; i--)
+				devlink_region_destroy(dl->dl_region[i]);
+
+			return rc;
+		}
+
+		t7xx_devlink_region_list[i].entry = i;
+		region_ops[i].priv = t7xx_devlink_region_list + i;
+	}
+
+	return 0;
+}
+
+/* To Destroy devlink regions */
+static void t7xx_devlink_destroy_region(struct t7xx_devlink *dl)
+{
+	u8 i;
+
+	for (i = 0; i < T7XX_TOTAL_REGIONS; i++)
+		devlink_region_destroy(dl->dl_region[i]);
+}
+
+int t7xx_devlink_register(struct t7xx_pci_dev *t7xx_dev)
+{
+	struct devlink *dl_ctx;
+
+	dl_ctx = devlink_alloc(&devlink_flash_ops, sizeof(struct t7xx_devlink),
+			       &t7xx_dev->pdev->dev);
+	if (!dl_ctx)
+		return -ENOMEM;
+
+	devlink_set_features(dl_ctx, DEVLINK_F_RELOAD);
+	devlink_register(dl_ctx);
+	t7xx_dev->dl = devlink_priv(dl_ctx);
+	t7xx_dev->dl->dl_ctx = dl_ctx;
+
+	return 0;
+}
+
+void t7xx_devlink_unregister(struct t7xx_pci_dev *t7xx_dev)
+{
+	struct devlink *dl_ctx = priv_to_devlink(t7xx_dev->dl);
+
+	devlink_unregister(dl_ctx);
+	devlink_free(dl_ctx);
+}
+
+/**
+ * t7xx_devlink_region_init - Initialize/register devlink to t7xx driver
+ * @port: Pointer to port structure
+ * @dw: Pointer to devlink work structure
+ * @wq: Pointer to devlink workqueue structure
+ *
+ * Returns: Pointer to t7xx_devlink on success and NULL on failure
+ */
+static struct t7xx_devlink *t7xx_devlink_region_init(struct t7xx_port *port,
+						     struct t7xx_devlink_work *dw,
+						     struct workqueue_struct *wq)
+{
+	struct t7xx_pci_dev *mtk_dev = port->t7xx_dev;
+	struct t7xx_devlink *dl = mtk_dev->dl;
+	int rc, i;
+
+	dl->dl_ctx = mtk_dev->dl->dl_ctx;
+	dl->mtk_dev = mtk_dev;
+	dl->dev = &mtk_dev->pdev->dev;
+	dl->mode = T7XX_FB_NO_MODE;
+	dl->status = T7XX_DEVLINK_IDLE;
+	dl->dl_work = dw;
+	dl->dl_wq = wq;
+	for (i = 0; i < T7XX_TOTAL_REGIONS; i++) {
+		dl->dl_region_info[i] = &t7xx_devlink_region_list[i];
+		dl->dl_region_info[i]->dump = NULL;
+	}
+	dl->port = port;
+	port->dl = dl;
+
+	rc = t7xx_devlink_create_region(dl);
+	if (rc) {
+		dev_err(dl->dev, "devlink region creation failed, rc %d", rc);
+		return NULL;
+	}
+
+	return dl;
+}
+
+/**
+ * t7xx_devlink_region_deinit - To unintialize the devlink from T7XX driver.
+ * @dl:        Devlink instance
+ */
+static void t7xx_devlink_region_deinit(struct t7xx_devlink *dl)
+{
+	dl->mode = T7XX_FB_NO_MODE;
+	t7xx_devlink_destroy_region(dl);
+}
+
+static void t7xx_devlink_work_handler(struct work_struct *data)
+{
+	struct t7xx_devlink_work *dl_work;
+
+	dl_work = container_of(data, struct t7xx_devlink_work, work);
+	t7xx_devlink_fb_get_core(dl_work->port);
+}
+
+static int t7xx_devlink_init(struct t7xx_port *port)
+{
+	struct t7xx_devlink_work *dl_work;
+	struct workqueue_struct *wq;
+
+	dl_work = kmalloc(sizeof(*dl_work), GFP_KERNEL);
+	if (!dl_work)
+		return -ENOMEM;
+
+	wq = create_workqueue("t7xx_devlink");
+	if (!wq) {
+		kfree(dl_work);
+		dev_err(port->dev, "create_workqueue failed\n");
+		return -ENODATA;
+	}
+
+	INIT_WORK(&dl_work->work, t7xx_devlink_work_handler);
+	dl_work->port = port;
+	port->rx_length_th = T7XX_MAX_QUEUE_LENGTH;
+
+	if (!t7xx_devlink_region_init(port, dl_work, wq))
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void t7xx_devlink_uninit(struct t7xx_port *port)
+{
+	struct t7xx_devlink *dl = port->dl;
+	struct sk_buff *skb;
+	unsigned long flags;
+
+	vfree(dl->dl_region_info[T7XX_MRDUMP_INDEX]->dump);
+	if (dl->dl_wq)
+		destroy_workqueue(dl->dl_wq);
+	kfree(dl->dl_work);
+
+	t7xx_devlink_region_deinit(port->dl);
+	spin_lock_irqsave(&port->rx_skb_list.lock, flags);
+	while ((skb = __skb_dequeue(&port->rx_skb_list)) != NULL)
+		dev_kfree_skb(skb);
+	spin_unlock_irqrestore(&port->rx_skb_list.lock, flags);
+}
+
+static int t7xx_devlink_enable_chl(struct t7xx_port *port)
+{
+	spin_lock(&port->port_update_lock);
+	port->chan_enable = true;
+	spin_unlock(&port->port_update_lock);
+
+	if (port->dl->dl_wq && port->dl->mode == T7XX_FB_DUMP_MODE)
+		queue_work(port->dl->dl_wq, &port->dl->dl_work->work);
+
+	return 0;
+}
+
+static int t7xx_devlink_disable_chl(struct t7xx_port *port)
+{
+	spin_lock(&port->port_update_lock);
+	port->chan_enable = false;
+	spin_unlock(&port->port_update_lock);
+
+	return 0;
+}
+
+struct port_ops devlink_port_ops = {
+	.init = &t7xx_devlink_init,
+	.recv_skb = &t7xx_port_enqueue_skb,
+	.uninit = &t7xx_devlink_uninit,
+	.enable_chl = &t7xx_devlink_enable_chl,
+	.disable_chl = &t7xx_devlink_disable_chl,
+};
diff --git a/drivers/net/wwan/t7xx/t7xx_port_devlink.h b/drivers/net/wwan/t7xx/t7xx_port_devlink.h
new file mode 100644
index 000000000000..85384e40519e
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_port_devlink.h
@@ -0,0 +1,85 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (c) 2022, Intel Corporation.
+ */
+
+#ifndef __T7XX_PORT_DEVLINK_H__
+#define __T7XX_PORT_DEVLINK_H__
+
+#include <net/devlink.h>
+
+#include "t7xx_pci.h"
+
+#define T7XX_MAX_QUEUE_LENGTH 32
+#define T7XX_FB_COMMAND_SIZE  64
+#define T7XX_FB_RESPONSE_SIZE 64
+#define T7XX_FB_MCMD_SIZE     64
+#define T7XX_FB_MDATA_SIZE    1024
+#define T7XX_FB_RESP_COUNT    30
+
+#define T7XX_FB_CMD_RTS          "_RTS"
+#define T7XX_FB_CMD_CTS          "_CTS"
+#define T7XX_FB_CMD_FIN          "_FIN"
+#define T7XX_FB_CMD_OEM_MRDUMP   "oem mrdump"
+#define T7XX_FB_CMD_OEM_LKDUMP   "oem dump_pllk_log"
+#define T7XX_FB_CMD_DOWNLOAD     "download"
+#define T7XX_FB_CMD_FLASH        "flash"
+#define T7XX_FB_CMD_REBOOT       "reboot"
+#define T7XX_FB_RESP_MRDUMP_DONE "MRDUMP08_DONE"
+#define T7XX_FB_RESP_OKAY        "OKAY"
+#define T7XX_FB_RESP_FAIL        "FAIL"
+#define T7XX_FB_RESP_DATA        "DATA"
+#define T7XX_FB_RESP_INFO        "INFO"
+
+#define T7XX_FB_EVENT_SIZE      50
+
+#define T7XX_MAX_SNAPSHOTS  1
+#define T7XX_MAX_REGION_NAME_LENGTH 20
+#define T7XX_MRDUMP_SIZE    (160 * 1024 * 1024)
+#define T7XX_LKDUMP_SIZE    (256 * 1024)
+#define T7XX_TOTAL_REGIONS  2
+
+#define T7XX_FLASH_STATUS   0
+#define T7XX_MRDUMP_STATUS  1
+#define T7XX_LKDUMP_STATUS  2
+#define T7XX_DEVLINK_IDLE   0
+
+#define T7XX_FB_NO_MODE     0
+#define T7XX_FB_DL_MODE     1
+#define T7XX_FB_DUMP_MODE   2
+
+#define T7XX_MRDUMP_INDEX   0
+#define T7XX_LKDUMP_INDEX   1
+
+struct t7xx_devlink_work {
+	struct work_struct work;
+	struct t7xx_port *port;
+};
+
+struct t7xx_devlink_region_info {
+	char region_name[T7XX_MAX_REGION_NAME_LENGTH];
+	u32 default_size;
+	u32 actual_size;
+	u32 entry;
+	u8 *dump;
+};
+
+struct t7xx_devlink {
+	struct t7xx_pci_dev *mtk_dev;
+	struct t7xx_port *port;
+	struct device *dev;
+	struct devlink *dl_ctx;
+	struct t7xx_devlink_work *dl_work;
+	struct workqueue_struct *dl_wq;
+	struct t7xx_devlink_region_info *dl_region_info[T7XX_TOTAL_REGIONS];
+	struct devlink_region_ops dl_region_ops[T7XX_TOTAL_REGIONS];
+	struct devlink_region *dl_region[T7XX_TOTAL_REGIONS];
+	u8 mode;
+	unsigned long status;
+	int set_fastboot_dl;
+};
+
+int t7xx_devlink_register(struct t7xx_pci_dev *t7xx_dev);
+void t7xx_devlink_unregister(struct t7xx_pci_dev *t7xx_dev);
+
+#endif /*__T7XX_PORT_DEVLINK_H__*/
diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.c b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
index 7582777cf94d..fdf0c6e5ed6d 100644
--- a/drivers/net/wwan/t7xx/t7xx_port_proxy.c
+++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
@@ -98,6 +98,7 @@ static struct t7xx_port_conf t7xx_early_port_conf[] = {
 		.rxq_exp_index = 1,
 		.path_id = CLDMA_ID_AP,
 		.is_early_port = true,
+		.ops = &devlink_port_ops,
 		.name = "ttyDUMP",
 	},
 };
@@ -493,6 +494,7 @@ static void t7xx_proxy_init_all_ports(struct t7xx_modem *md)
 
 		port->t7xx_dev = md->t7xx_dev;
 		port->dev = &md->t7xx_dev->pdev->dev;
+		port->dl = md->t7xx_dev->dl;
 		spin_lock_init(&port->port_update_lock);
 		port->chan_enable = false;
 
diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.h b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
index 33caf85f718a..7298a2d09fa0 100644
--- a/drivers/net/wwan/t7xx/t7xx_port_proxy.h
+++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
@@ -93,6 +93,7 @@ struct ctrl_msg_header {
 /* Port operations mapping */
 extern struct port_ops wwan_sub_port_ops;
 extern struct port_ops ctl_port_ops;
+extern struct port_ops devlink_port_ops;
 
 void t7xx_port_proxy_reset(struct port_proxy *port_prox);
 void t7xx_port_proxy_uninit(struct port_proxy *port_prox);
diff --git a/drivers/net/wwan/t7xx/t7xx_reg.h b/drivers/net/wwan/t7xx/t7xx_reg.h
index 60e025e57baa..3a758bf79a4e 100644
--- a/drivers/net/wwan/t7xx/t7xx_reg.h
+++ b/drivers/net/wwan/t7xx/t7xx_reg.h
@@ -101,11 +101,17 @@ enum t7xx_pm_resume_state {
 	PM_RESUME_REG_STATE_L2_EXP,
 };
 
+enum host_event_e {
+	HOST_EVENT_INIT = 0,
+	FASTBOOT_DL_NOTY = 0x3,
+};
+
 #define T7XX_PCIE_MISC_DEV_STATUS		0x0d1c
 #define MISC_RESET_TYPE_FLDR			BIT(27)
 #define MISC_RESET_TYPE_PLDR			BIT(26)
 #define MISC_DEV_STATUS_MASK			GENMASK(15, 0)
 #define LK_EVENT_MASK				GENMASK(11, 8)
+#define HOST_EVENT_MASK			GENMASK(31, 28)
 
 enum lk_event_id {
 	LK_EVENT_NORMAL = 0,
diff --git a/drivers/net/wwan/t7xx/t7xx_state_monitor.c b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
index 9c222809371b..00e143c8d568 100644
--- a/drivers/net/wwan/t7xx/t7xx_state_monitor.c
+++ b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
@@ -38,10 +38,12 @@
 #include "t7xx_netdev.h"
 #include "t7xx_pci.h"
 #include "t7xx_pcie_mac.h"
+#include "t7xx_port_devlink.h"
 #include "t7xx_port_proxy.h"
 #include "t7xx_pci_rescan.h"
 #include "t7xx_reg.h"
 #include "t7xx_state_monitor.h"
+#include "t7xx_uevent.h"
 
 #define FSM_DRM_DISABLE_DELAY_MS		200
 #define FSM_EVENT_POLL_INTERVAL_MS		20
@@ -212,6 +214,16 @@ static void fsm_routine_exception(struct t7xx_fsm_ctl *ctl, struct t7xx_fsm_comm
 		fsm_finish_command(ctl, cmd, 0);
 }
 
+static void t7xx_host_event_notify(struct t7xx_modem *md, unsigned int event_id)
+{
+	u32 value;
+
+	value = ioread32(IREG_BASE(md->t7xx_dev) + T7XX_PCIE_MISC_DEV_STATUS);
+	value &= ~HOST_EVENT_MASK;
+	value |= FIELD_PREP(HOST_EVENT_MASK, event_id);
+	iowrite32(value, IREG_BASE(md->t7xx_dev) + T7XX_PCIE_MISC_DEV_STATUS);
+}
+
 static void t7xx_lk_stage_event_handling(struct t7xx_fsm_ctl *ctl, unsigned int dev_status)
 {
 	struct t7xx_modem *md = ctl->md;
@@ -228,6 +240,7 @@ static void t7xx_lk_stage_event_handling(struct t7xx_fsm_ctl *ctl, unsigned int
 		break;
 
 	case LK_EVENT_CREATE_PD_PORT:
+	case LK_EVENT_CREATE_POST_DL_PORT:
 		md_ctrl = md->md_ctrl[CLDMA_ID_AP];
 		t7xx_cldma_hif_hw_init(md_ctrl);
 		t7xx_cldma_stop(md_ctrl);
@@ -239,8 +252,16 @@ static void t7xx_lk_stage_event_handling(struct t7xx_fsm_ctl *ctl, unsigned int
 			return;
 		}
 
+		if (lk_event == LK_EVENT_CREATE_PD_PORT)
+			port->dl->mode = T7XX_FB_DUMP_MODE;
+		else
+			port->dl->mode = T7XX_FB_DL_MODE;
 		port->port_conf->ops->enable_chl(port);
 		t7xx_cldma_start(md_ctrl);
+		if (lk_event == LK_EVENT_CREATE_PD_PORT)
+			t7xx_uevent_send(dev, T7XX_UEVENT_MODEM_FASTBOOT_DUMP_MODE);
+		else
+			t7xx_uevent_send(dev, T7XX_UEVENT_MODEM_FASTBOOT_DL_MODE);
 		break;
 
 	case LK_EVENT_RESET:
@@ -289,13 +310,23 @@ static void fsm_routine_stopping(struct t7xx_fsm_ctl *ctl, struct t7xx_fsm_comma
 	t7xx_cldma_stop(md_ctrl);
 
 	if (!ctl->md->rgu_irq_asserted) {
+		if (t7xx_dev->dl->set_fastboot_dl)
+			t7xx_host_event_notify(ctl->md, FASTBOOT_DL_NOTY);
+
 		t7xx_mhccif_h2d_swint_trigger(t7xx_dev, H2D_CH_DRM_DISABLE_AP);
 		/* Wait for the DRM disable to take effect */
 		msleep(FSM_DRM_DISABLE_DELAY_MS);
 
-		err = t7xx_acpi_fldr_func(t7xx_dev);
-		if (err)
+		if (t7xx_dev->dl->set_fastboot_dl) {
+			/* Do not try fldr because device will always wait for
+			 * MHCCIF bit 13 in fastboot download flow.
+			 */
 			t7xx_mhccif_h2d_swint_trigger(t7xx_dev, H2D_CH_DEVICE_RESET);
+		} else {
+			err = t7xx_acpi_fldr_func(t7xx_dev);
+			if (err)
+				t7xx_mhccif_h2d_swint_trigger(t7xx_dev, H2D_CH_DEVICE_RESET);
+		}
 	}
 
 	fsm_finish_command(ctl, cmd, fsm_stopped_handler(ctl));
@@ -318,6 +349,7 @@ static void fsm_routine_ready(struct t7xx_fsm_ctl *ctl)
 
 	ctl->curr_state = FSM_STATE_READY;
 	t7xx_fsm_broadcast_ready_state(ctl);
+	t7xx_uevent_send(&md->t7xx_dev->pdev->dev, T7XX_UEVENT_MODEM_READY);
 	t7xx_md_event_notify(md, FSM_READY);
 }
 
diff --git a/drivers/net/wwan/t7xx/t7xx_uevent.c b/drivers/net/wwan/t7xx/t7xx_uevent.c
new file mode 100644
index 000000000000..5a320cf3f94b
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_uevent.c
@@ -0,0 +1,41 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2022, Intel Corporation.
+ */
+
+#include <linux/slab.h>
+
+#include "t7xx_uevent.h"
+
+/* Update the uevent in work queue context */
+static void t7xx_uevent_work(struct work_struct *data)
+{
+	struct t7xx_uevent_info *info;
+	char *envp[2] = { NULL, NULL };
+
+	info = container_of(data, struct t7xx_uevent_info, work);
+	envp[0] = info->uevent;
+
+	if (kobject_uevent_env(&info->dev->kobj, KOBJ_CHANGE, envp))
+		pr_err("uevent %s failed to sent", info->uevent);
+
+	kfree(info);
+}
+
+/**
+ * t7xx_uevent_send - Send modem event to user space.
+ * @dev:	Generic device pointer
+ * @uevent:	Uevent information
+ */
+void t7xx_uevent_send(struct device *dev, char *uevent)
+{
+	struct t7xx_uevent_info *info = kzalloc(sizeof(*info), GFP_ATOMIC);
+
+	if (!info)
+		return;
+
+	INIT_WORK(&info->work, t7xx_uevent_work);
+	info->dev = dev;
+	snprintf(info->uevent, T7XX_MAX_UEVENT_LEN, "T7XX_EVENT=%s", uevent);
+	schedule_work(&info->work);
+}
diff --git a/drivers/net/wwan/t7xx/t7xx_uevent.h b/drivers/net/wwan/t7xx/t7xx_uevent.h
new file mode 100644
index 000000000000..e871dc0e9444
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_uevent.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (c) 2022, Intel Corporation.
+ */
+
+#ifndef __T7XX_UEVENT_H__
+#define __T7XX_UEVENT_H__
+
+#include <linux/device.h>
+#include <linux/kobject.h>
+
+/* Maximum length of user events */
+#define T7XX_MAX_UEVENT_LEN 64
+
+/* T7XX Host driver uevents */
+#define T7XX_UEVENT_MODEM_READY			"T7XX_MODEM_READY"
+#define T7XX_UEVENT_MODEM_FASTBOOT_DL_MODE	"T7XX_MODEM_FASTBOOT_DL_MODE"
+#define T7XX_UEVENT_MODEM_FASTBOOT_DUMP_MODE	"T7XX_MODEM_FASTBOOT_DUMP_MODE"
+#define T7XX_UEVENT_MRDUMP_READY		"T7XX_MRDUMP_READY"
+#define T7XX_UEVENT_LKDUMP_READY		"T7XX_LKDUMP_READY"
+#define T7XX_UEVENT_MRD_DISCD			"T7XX_MRDUMP_DISCARDED"
+#define T7XX_UEVENT_LKD_DISCD			"T7XX_LKDUMP_DISCARDED"
+#define T7XX_UEVENT_FLASHING_SUCCESS		"T7XX_FLASHING_SUCCESS"
+#define T7XX_UEVENT_FLASHING_FAILURE		"T7XX_FLASHING_FAILURE"
+
+/**
+ * struct t7xx_uevent_info - Uevent information structure.
+ * @dev:	Pointer to device structure
+ * @uevent:	Uevent information
+ * @work:	Uevent work struct
+ */
+struct t7xx_uevent_info {
+	struct device *dev;
+	char uevent[T7XX_MAX_UEVENT_LEN];
+	struct work_struct work;
+};
+
+void t7xx_uevent_send(struct device *dev, char *uevent);
+#endif
-- 
2.34.1

