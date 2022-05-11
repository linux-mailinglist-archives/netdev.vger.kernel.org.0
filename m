Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94018522A52
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 05:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241784AbiEKDUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 23:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241738AbiEKDTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 23:19:48 -0400
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706DB13B8E9
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 20:19:44 -0700 (PDT)
X-QQ-mid: bizesmtp75t1652239168t9wrw8a2
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 11 May 2022 11:19:28 +0800 (CST)
X-QQ-SSF: 01400000000000F0O000B00A0000000
X-QQ-FEAT: HoyAXBWgskmA6FlVEHEs81KNMEDjl+iGVJzt8xoAZ+fADyQ9dFX3flf4ugjym
        He6NhloL1N47t4lNP+02UuRJFI9CqvE87fE2KQi7Fv7nPHAi5u6kZAgyptpmI4R61r1n4ik
        ZMWS06yCAmTgtS+AXS+GxGd/xVLolW99bAvqmwmhMGP96ocm0Uh60nYb/AWUgVeojuV2buB
        GN/zMTID35le6zl1rJc61ku5S5nh5OD41e8+4uwDwE8WoeBG4ArBSuJpTjpQ5jbOrkfVZsS
        g0uBIhZXHowJnBR5qHPYX/UZBHbsVezUu4cBBYk527qUqDjehzIrpxAsQoOefTSXOygPkJy
        c3InGuZTlMlvYxMsLAoEXi4pDIEpeEQqw3U4ZKu
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next 11/14] net: txgbe: Support PCIe recovery
Date:   Wed, 11 May 2022 11:26:56 +0800
Message-Id: <20220511032659.641834-12-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220511032659.641834-1-jiawenwu@trustnetic.com>
References: <20220511032659.641834-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybgforeign:qybgforeign8
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_XBL,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When Tx hang detected on queues, or the PCIE request error found,
driver will do PCIE recovery, where the config of "TXGBE_PCI_RECOVER"
is enabled.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/txgbe/Makefile   |   2 +
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |   1 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  79 ++++++
 .../net/ethernet/wangxun/txgbe/txgbe_pcierr.c | 236 ++++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_pcierr.h |   8 +
 5 files changed, 326 insertions(+)
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_pcierr.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_pcierr.h

diff --git a/drivers/net/ethernet/wangxun/txgbe/Makefile b/drivers/net/ethernet/wangxun/txgbe/Makefile
index 43e5d23109d7..7fe32feeded8 100644
--- a/drivers/net/ethernet/wangxun/txgbe/Makefile
+++ b/drivers/net/ethernet/wangxun/txgbe/Makefile
@@ -9,3 +9,5 @@ obj-$(CONFIG_TXGBE) += txgbe.o
 txgbe-objs := txgbe_main.o txgbe_ethtool.o \
               txgbe_hw.o txgbe_phy.o \
               txgbe_lib.o txgbe_ptp.o
+
+txgbe-$(CONFIG_TXGBE_PCI_RECOVER) += txgbe_pcierr.o
\ No newline at end of file
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index 709805f7743c..fe51bdf96f3e 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -385,6 +385,7 @@ struct txgbe_mac_addr {
 #define TXGBE_FLAG2_RSS_FIELD_IPV6_UDP          (1U << 9)
 #define TXGBE_FLAG2_RSS_ENABLED                 (1U << 10)
 #define TXGBE_FLAG2_FDIR_REQUIRES_REINIT        (1U << 11)
+#define TXGBE_FLAG2_PCIE_NEED_RECOVER           (1U << 12)
 
 #define TXGBE_SET_FLAG(_input, _flag, _result) \
 	((_flag <= _result) ? \
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 0e5400dbdd9a..ab222bf9e828 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -23,6 +23,7 @@
 #include "txgbe.h"
 #include "txgbe_hw.h"
 #include "txgbe_phy.h"
+#include "txgbe_pcierr.h"
 
 char txgbe_driver_name[32] = TXGBE_NAME;
 static const char txgbe_driver_string[] =
@@ -416,6 +417,16 @@ static void txgbe_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 		wr32(&adapter->hw, TXGBE_PX_ICS(1), value3);
 		wr32(&adapter->hw, TXGBE_PX_IMC(1), value3);
 	}
+
+#ifdef CONFIG_TXGBE_PCI_RECOVER
+	ERROR_REPORT1(TXGBE_ERROR_POLLING, "tx timeout. do pcie recovery.\n");
+	if (adapter->hw.bus.lan_id == 0) {
+		adapter->flags2 |= TXGBE_FLAG2_PCIE_NEED_RECOVER;
+		txgbe_service_event_schedule(adapter);
+	} else {
+		wr32(&adapter->hw, TXGBE_MIS_PF_SM, 1);
+	}
+#endif
 }
 
 /**
@@ -550,6 +561,16 @@ static bool txgbe_clean_tx_irq(struct txgbe_q_vector *q_vector,
 			   "tx hang %d detected on queue %d, resetting adapter\n",
 			   adapter->tx_timeout_count + 1, tx_ring->queue_index);
 
+#ifdef CONFIG_TXGBE_PCI_RECOVER
+		/* schedule immediate reset if we believe we hung */
+		txgbe_info(hw, "real tx hang. do pcie recovery.\n");
+		if (adapter->hw.bus.lan_id == 0) {
+			adapter->flags2 |= TXGBE_FLAG2_PCIE_NEED_RECOVER;
+			txgbe_service_event_schedule(adapter);
+		} else {
+			wr32(&adapter->hw, TXGBE_MIS_PF_SM, 1);
+		}
+#endif
 		/* the adapter is about to reset, no point in enabling stuff */
 		return true;
 	}
@@ -1593,12 +1614,34 @@ static irqreturn_t txgbe_msix_other(int __always_unused irq, void *data)
 	struct txgbe_hw *hw = &adapter->hw;
 	u32 eicr;
 	u32 ecc;
+#ifdef CONFIG_TXGBE_PCI_RECOVER
+	u16 pci_val = 0;
+#endif
 
 	eicr = txgbe_misc_isb(adapter, TXGBE_ISB_MISC);
 
 	if (eicr & (TXGBE_PX_MISC_IC_ETH_LK | TXGBE_PX_MISC_IC_ETH_LKDN))
 		txgbe_check_lsc(adapter);
 
+#ifdef CONFIG_TXGBE_PCI_RECOVER
+	if (eicr & TXGBE_PX_MISC_IC_PCIE_REQ_ERR) {
+		ERROR_REPORT1(TXGBE_ERROR_POLLING,
+			      "lan id %d, PCIe request error founded.\n", hw->bus.lan_id);
+
+		pci_read_config_word(adapter->pdev, PCI_VENDOR_ID, &pci_val);
+		ERROR_REPORT1(TXGBE_ERROR_POLLING, "pci vendor id is 0x%x\n", pci_val);
+
+		pci_read_config_word(adapter->pdev, PCI_COMMAND, &pci_val);
+		ERROR_REPORT1(TXGBE_ERROR_POLLING, "pci command reg is 0x%x.\n", pci_val);
+
+		if (hw->bus.lan_id == 0) {
+			adapter->flags2 |= TXGBE_FLAG2_PCIE_NEED_RECOVER;
+			txgbe_service_event_schedule(adapter);
+		} else {
+			wr32(&adapter->hw, TXGBE_MIS_PF_SM, 1);
+		}
+	}
+#endif
 	if (eicr & TXGBE_PX_MISC_IC_INT_ERR) {
 		txgbe_info(link, "Received unrecoverable ECC Err, initiating reset.\n");
 		ecc = rd32(hw, TXGBE_MIS_ST);
@@ -4654,6 +4697,9 @@ static void txgbe_service_timer(struct timer_list *t)
 	struct txgbe_adapter *adapter = from_timer(adapter, t, service_timer);
 	unsigned long next_event_offset;
 	struct txgbe_hw *hw = &adapter->hw;
+#ifdef CONFIG_TXGBE_PCI_RECOVER
+	u32 val = 0;
+#endif
 
 	/* poll faster when waiting for link */
 	if (adapter->flags & TXGBE_FLAG_NEED_LINK_UPDATE) {
@@ -4665,6 +4711,23 @@ static void txgbe_service_timer(struct timer_list *t)
 		next_event_offset = HZ * 2;
 	}
 
+#ifdef CONFIG_TXGBE_PCI_RECOVER
+	if (rd32(&adapter->hw, TXGBE_MIS_PF_SM) == 1) {
+		val = rd32m(&adapter->hw, TXGBE_MIS_PRB_CTL,
+			    TXGBE_MIS_PRB_CTL_LAN0_UP | TXGBE_MIS_PRB_CTL_LAN1_UP);
+		if (val & TXGBE_MIS_PRB_CTL_LAN0_UP) {
+			if (hw->bus.lan_id == 0) {
+				adapter->flags2 |= TXGBE_FLAG2_PCIE_NEED_RECOVER;
+				txgbe_info(probe, "%s: set recover on Lan0\n", __func__);
+			}
+		} else if (val & TXGBE_MIS_PRB_CTL_LAN1_UP) {
+			if (hw->bus.lan_id == 1) {
+				adapter->flags2 |= TXGBE_FLAG2_PCIE_NEED_RECOVER;
+				txgbe_info(probe, "%s: set recover on Lan1\n", __func__);
+			}
+		}
+	}
+#endif
 	/* Reset the timer */
 	mod_timer(&adapter->service_timer, next_event_offset + jiffies);
 
@@ -4749,6 +4812,19 @@ static void txgbe_reset_subtask(struct txgbe_adapter *adapter)
 	rtnl_unlock();
 }
 
+#ifdef CONFIG_TXGBE_PCI_RECOVER
+static void txgbe_check_pcie_subtask(struct txgbe_adapter *adapter)
+{
+	if (!(adapter->flags2 & TXGBE_FLAG2_PCIE_NEED_RECOVER))
+		return;
+
+	txgbe_info(probe, "do recovery\n");
+	wr32m(&adapter->hw, TXGBE_MIS_PF_SM, TXGBE_MIS_PF_SM_SM, 0);
+	txgbe_pcie_do_recovery(adapter->pdev);
+	adapter->flags2 &= ~TXGBE_FLAG2_PCIE_NEED_RECOVER;
+}
+#endif
+
 /**
  * txgbe_service_task - manages and runs subtasks
  * @work: pointer to work_struct containing our data
@@ -4768,6 +4844,9 @@ static void txgbe_service_task(struct work_struct *work)
 		return;
 	}
 
+#ifdef CONFIG_TXGBE_PCI_RECOVER
+	txgbe_check_pcie_subtask(adapter);
+#endif
 	txgbe_reset_subtask(adapter);
 	txgbe_sfp_detection_subtask(adapter);
 	txgbe_sfp_link_config_subtask(adapter);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_pcierr.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_pcierr.c
new file mode 100644
index 000000000000..833e5be4540f
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_pcierr.c
@@ -0,0 +1,236 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2015 - 2017 Beijing WangXun Technology Co., Ltd. */
+
+#include <linux/delay.h>
+#include <linux/pci.h>
+#include "txgbe_pcierr.h"
+#include "txgbe.h"
+
+#define TXGBE_ROOT_PORT_INTR_ON_MESG_MASK (PCI_ERR_ROOT_CMD_COR_EN |      \
+					   PCI_ERR_ROOT_CMD_NONFATAL_EN | \
+					   PCI_ERR_ROOT_CMD_FATAL_EN)
+
+#ifndef PCI_ERS_RESULT_NO_AER_DRIVER
+/* No AER capabilities registered for the driver */
+#define PCI_ERS_RESULT_NO_AER_DRIVER ((__force pci_ers_result_t)6)
+#endif
+
+static pci_ers_result_t merge_result(enum pci_ers_result orig,
+				     enum pci_ers_result new)
+{
+	if (new == PCI_ERS_RESULT_NO_AER_DRIVER)
+		return PCI_ERS_RESULT_NO_AER_DRIVER;
+	if (new == PCI_ERS_RESULT_NONE)
+		return orig;
+	switch (orig) {
+	case PCI_ERS_RESULT_CAN_RECOVER:
+	case PCI_ERS_RESULT_RECOVERED:
+		orig = new;
+		break;
+	case PCI_ERS_RESULT_DISCONNECT:
+		if (new == PCI_ERS_RESULT_NEED_RESET)
+			orig = PCI_ERS_RESULT_NEED_RESET;
+		break;
+	default:
+		break;
+	}
+	return orig;
+}
+
+static int txgbe_report_error_detected(struct pci_dev *dev,
+				       pci_channel_state_t state,
+				       enum pci_ers_result *result)
+{
+	pci_ers_result_t vote;
+	const struct pci_error_handlers *err_handler;
+
+	device_lock(&dev->dev);
+	if (!dev->driver ||
+	    !dev->driver->err_handler ||
+	    !dev->driver->err_handler->error_detected) {
+		/* If any device in the subtree does not have an error_detected
+		 * callback, PCI_ERS_RESULT_NO_AER_DRIVER prevents subsequent
+		 * error callbacks of "any" device in the subtree, and will
+		 * exit in the disconnected error state.
+		 */
+		if (dev->hdr_type != PCI_HEADER_TYPE_BRIDGE)
+			vote = PCI_ERS_RESULT_NO_AER_DRIVER;
+		else
+			vote = PCI_ERS_RESULT_NONE;
+	} else {
+		err_handler = dev->driver->err_handler;
+		vote = err_handler->error_detected(dev, state);
+	}
+
+	*result = merge_result(*result, vote);
+	device_unlock(&dev->dev);
+	return 0;
+}
+
+static int txgbe_report_frozen_detected(struct pci_dev *dev, void *data)
+{
+	return txgbe_report_error_detected(dev, pci_channel_io_frozen, data);
+}
+
+static int txgbe_report_mmio_enabled(struct pci_dev *dev, void *data)
+{
+	pci_ers_result_t vote, *result = data;
+	const struct pci_error_handlers *err_handler;
+
+	device_lock(&dev->dev);
+	if (!dev->driver ||
+	    !dev->driver->err_handler ||
+	    !dev->driver->err_handler->mmio_enabled)
+		goto out;
+
+	err_handler = dev->driver->err_handler;
+	vote = err_handler->mmio_enabled(dev);
+	*result = merge_result(*result, vote);
+out:
+	device_unlock(&dev->dev);
+	return 0;
+}
+
+static int txgbe_report_slot_reset(struct pci_dev *dev, void *data)
+{
+	pci_ers_result_t vote, *result = data;
+	const struct pci_error_handlers *err_handler;
+
+	device_lock(&dev->dev);
+	if (!dev->driver ||
+	    !dev->driver->err_handler ||
+	    !dev->driver->err_handler->slot_reset)
+		goto out;
+
+	err_handler = dev->driver->err_handler;
+	vote = err_handler->slot_reset(dev);
+	*result = merge_result(*result, vote);
+out:
+	device_unlock(&dev->dev);
+	return 0;
+}
+
+static int txgbe_report_resume(struct pci_dev *dev, void *data)
+{
+	const struct pci_error_handlers *err_handler;
+
+	device_lock(&dev->dev);
+	dev->error_state = pci_channel_io_normal;
+	if (!dev->driver ||
+	    !dev->driver->err_handler ||
+	    !dev->driver->err_handler->resume)
+		goto out;
+
+	err_handler = dev->driver->err_handler;
+	err_handler->resume(dev);
+out:
+	device_unlock(&dev->dev);
+	return 0;
+}
+
+void txgbe_pcie_do_recovery(struct pci_dev *dev)
+{
+	pci_ers_result_t status = PCI_ERS_RESULT_CAN_RECOVER;
+	struct pci_bus *bus;
+	u32 reg32;
+	int pos;
+	int delay = 1;
+	u32 id;
+	u16 ctrl;
+
+	/* Error recovery runs on all subordinates of the first downstream port.
+	 * If the downstream port detected the error, it is cleared at the end.
+	 */
+	if (!(pci_pcie_type(dev) == PCI_EXP_TYPE_ROOT_PORT ||
+	      pci_pcie_type(dev) == PCI_EXP_TYPE_DOWNSTREAM))
+		dev = dev->bus->self;
+	bus = dev->subordinate;
+
+	pci_walk_bus(bus, txgbe_report_frozen_detected, &status);
+	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ERR);
+	if (pos) {
+		/* Disable Root's interrupt in response to error messages */
+		pci_read_config_dword(dev, pos + PCI_ERR_ROOT_COMMAND, &reg32);
+		reg32 &= ~TXGBE_ROOT_PORT_INTR_ON_MESG_MASK;
+		pci_write_config_dword(dev, pos + PCI_ERR_ROOT_COMMAND, reg32);
+	}
+
+	pci_read_config_word(dev, PCI_BRIDGE_CONTROL, &ctrl);
+	ctrl |= PCI_BRIDGE_CTL_BUS_RESET;
+	pci_write_config_word(dev, PCI_BRIDGE_CONTROL, ctrl);
+
+	/* PCI spec v3.0 7.6.4.2 requires minimum Trst of 1ms. Double
+	 * this to 2ms to ensure that we meet the minimum requirement.
+	 */
+
+	usleep_range(2000, 3000);
+	ctrl &= ~PCI_BRIDGE_CTL_BUS_RESET;
+	pci_write_config_word(dev, PCI_BRIDGE_CONTROL, ctrl);
+
+	/* Trhfa for conventional PCI is 2^25 clock cycles.
+	 * Assuming a minimum 33MHz clock this results in a 1s
+	 * delay before we can consider subordinate devices to
+	 * be re-initialized.  PCIe has some ways to shorten this,
+	 * but we don't make use of them yet.
+	 */
+	ssleep(1);
+
+	pci_read_config_dword(dev, PCI_COMMAND, &id);
+	while (id == ~0) {
+		if (delay > 60000) {
+			pci_warn(dev, "not ready %dms after %s; giving up\n",
+				 delay - 1, "bus_reset");
+			return;
+		}
+
+		if (delay > 1000)
+			pci_info(dev, "not ready %dms after %s; waiting\n",
+				 delay - 1, "bus_reset");
+
+		msleep(delay);
+		delay *= 2;
+		pci_read_config_dword(dev, PCI_COMMAND, &id);
+	}
+
+	if (delay > 1000)
+		pci_info(dev, "ready %dms after %s\n", delay - 1,
+			 "bus_reset");
+
+	pci_info(dev, "Root Port link has been reset\n");
+
+	if (pos) {
+		/* Clear Root Error Status */
+		pci_read_config_dword(dev, pos + PCI_ERR_ROOT_STATUS, &reg32);
+		pci_write_config_dword(dev, pos + PCI_ERR_ROOT_STATUS, reg32);
+
+		/* Enable Root Port's interrupt in response to error messages */
+		pci_read_config_dword(dev, pos + PCI_ERR_ROOT_COMMAND, &reg32);
+		reg32 |= TXGBE_ROOT_PORT_INTR_ON_MESG_MASK;
+		pci_write_config_dword(dev, pos + PCI_ERR_ROOT_COMMAND, reg32);
+	}
+
+	if (status == PCI_ERS_RESULT_CAN_RECOVER) {
+		status = PCI_ERS_RESULT_RECOVERED;
+		pci_dbg(dev, "broadcast mmio_enabled message\n");
+		pci_walk_bus(bus, txgbe_report_mmio_enabled, &status);
+	}
+
+	if (status == PCI_ERS_RESULT_NEED_RESET) {
+		/* TODO: Should call platform-specific
+		 * functions to reset slot before calling
+		 * drivers' slot_reset callbacks?
+		 */
+		status = PCI_ERS_RESULT_RECOVERED;
+		pci_dbg(dev, "broadcast slot_reset message\n");
+		pci_walk_bus(bus, txgbe_report_slot_reset, &status);
+	}
+
+	if (status != PCI_ERS_RESULT_RECOVERED)
+		goto failed;
+
+	pci_dbg(dev, "broadcast resume message\n");
+	pci_walk_bus(bus, txgbe_report_resume, &status);
+
+failed:
+	;
+}
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_pcierr.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_pcierr.h
new file mode 100644
index 000000000000..fda21988550d
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_pcierr.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2015 - 2017 Beijing WangXun Technology Co., Ltd. */
+
+#ifndef _TXGBE_PCIERR_H_
+#define _TXGBE_PCIERR_H_
+
+void txgbe_pcie_do_recovery(struct pci_dev *dev);
+#endif
-- 
2.27.0



