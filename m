Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE171B1A3B
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 01:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgDTXn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 19:43:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:14655 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726006AbgDTXnS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 19:43:18 -0400
IronPort-SDR: c7u9OWyeCoDkWKTYwlD0IlYcEGV/tajwmfztnM6DWhDrypTq1FEG7m0JukgzMCn+/D1rv24G5z
 w2xMtl5w5yVA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 16:43:16 -0700
IronPort-SDR: SQ/T/xYwgLgin9GzWQhsLn8FzhXKZgLg5o51Y+R/fLbJJ4yz7dx+jxKoqYk2qglsenlbqlHEgp
 C5u+La8eMl9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,408,1580803200"; 
   d="scan'208";a="300428848"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Apr 2020 16:43:15 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Vitaly Lifshits <vitaly.lifshits@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        kbuild test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andre Guedes <andre.guedes@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 03/13] igc: add support to interrupt, eeprom, registers and link self-tests
Date:   Mon, 20 Apr 2020 16:43:03 -0700
Message-Id: <20200420234313.2184282-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200420234313.2184282-1-jeffrey.t.kirsher@intel.com>
References: <20200420234313.2184282-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vitaly Lifshits <vitaly.lifshits@intel.com>

Introduced igc_diag.c and igc_diag.h, these files have the
diagnostics functionality of igc driver. For the time being
these files are being used by ethtool self-test callbacks.
Which mean that interrupt, eeprom, registers and link self-tests for
ethtool were implemented.

Signed-off-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/Makefile      |   2 +-
 drivers/net/ethernet/intel/igc/igc.h         |   4 +
 drivers/net/ethernet/intel/igc/igc_diag.c    | 336 +++++++++++++++++++
 drivers/net/ethernet/intel/igc/igc_diag.h    |  37 ++
 drivers/net/ethernet/intel/igc/igc_ethtool.c |  63 ++++
 drivers/net/ethernet/intel/igc/igc_main.c    |   4 +-
 drivers/net/ethernet/intel/igc/igc_regs.h    |   2 +
 7 files changed, 445 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/igc/igc_diag.c
 create mode 100644 drivers/net/ethernet/intel/igc/igc_diag.h

diff --git a/drivers/net/ethernet/intel/igc/Makefile b/drivers/net/ethernet/intel/igc/Makefile
index 3652f211f351..1c3051db9085 100644
--- a/drivers/net/ethernet/intel/igc/Makefile
+++ b/drivers/net/ethernet/intel/igc/Makefile
@@ -8,4 +8,4 @@
 obj-$(CONFIG_IGC) += igc.o
 
 igc-objs := igc_main.o igc_mac.o igc_i225.o igc_base.o igc_nvm.o igc_phy.o \
-igc_ethtool.o igc_ptp.o igc_dump.o igc_tsn.o
+igc_diag.o igc_ethtool.o igc_ptp.o igc_dump.o igc_tsn.o
diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 8ddc39482a8e..661dc8875f3f 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -198,6 +198,8 @@ struct igc_adapter {
 	unsigned long link_check_timeout;
 	struct igc_info ei;
 
+	u32 test_icr;
+
 	struct ptp_clock *ptp_clock;
 	struct ptp_clock_info ptp_caps;
 	struct work_struct ptp_tx_work;
@@ -215,6 +217,8 @@ struct igc_adapter {
 
 void igc_up(struct igc_adapter *adapter);
 void igc_down(struct igc_adapter *adapter);
+int igc_open(struct net_device *netdev);
+int igc_close(struct net_device *netdev);
 int igc_setup_tx_resources(struct igc_ring *ring);
 int igc_setup_rx_resources(struct igc_ring *ring);
 void igc_free_tx_resources(struct igc_ring *ring);
diff --git a/drivers/net/ethernet/intel/igc/igc_diag.c b/drivers/net/ethernet/intel/igc/igc_diag.c
new file mode 100644
index 000000000000..4197ceac5d28
--- /dev/null
+++ b/drivers/net/ethernet/intel/igc/igc_diag.c
@@ -0,0 +1,336 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c)  2020 Intel Corporation */
+
+#include "igc.h"
+#include "igc_diag.h"
+
+struct igc_reg_test reg_test[] = {
+	{ IGC_FCAL,	1,	PATTERN_TEST,	0xFFFFFFFF,	0xFFFFFFFF },
+	{ IGC_FCAH,	1,	PATTERN_TEST,	0x0000FFFF,	0xFFFFFFFF },
+	{ IGC_FCT,	1,	PATTERN_TEST,	0x0000FFFF,	0xFFFFFFFF },
+	{ IGC_RDBAH(0),	4,	PATTERN_TEST,	0xFFFFFFFF,	0xFFFFFFFF },
+	{ IGC_RDBAL(0),	4,	PATTERN_TEST,	0xFFFFFF80,	0xFFFFFF80 },
+	{ IGC_RDLEN(0),	4,	PATTERN_TEST,	0x000FFF80,	0x000FFFFF },
+	{ IGC_RDT(0),	4,	PATTERN_TEST,	0x0000FFFF,	0x0000FFFF },
+	{ IGC_FCRTH,	1,	PATTERN_TEST,	0x0003FFF0,	0x0003FFF0 },
+	{ IGC_FCTTV,	1,	PATTERN_TEST,	0x0000FFFF,	0x0000FFFF },
+	{ IGC_TIPG,	1,	PATTERN_TEST,	0x3FFFFFFF,	0x3FFFFFFF },
+	{ IGC_TDBAH(0),	4,	PATTERN_TEST,	0xFFFFFFFF,	0xFFFFFFFF },
+	{ IGC_TDBAL(0),	4,	PATTERN_TEST,	0xFFFFFF80,	0xFFFFFF80 },
+	{ IGC_TDLEN(0),	4,	PATTERN_TEST,	0x000FFF80,	0x000FFFFF },
+	{ IGC_TDT(0),	4,	PATTERN_TEST,	0x0000FFFF,	0x0000FFFF },
+	{ IGC_RCTL,	1,	SET_READ_TEST,	0xFFFFFFFF,	0x00000000 },
+	{ IGC_RCTL,	1,	SET_READ_TEST,	0x04CFB2FE,	0x003FFFFB },
+	{ IGC_RCTL,	1,	SET_READ_TEST,	0x04CFB2FE,	0xFFFFFFFF },
+	{ IGC_TCTL,	1,	SET_READ_TEST,	0xFFFFFFFF,	0x00000000 },
+	{ IGC_RA,	16,	TABLE64_TEST_LO,
+						0xFFFFFFFF,	0xFFFFFFFF },
+	{ IGC_RA,	16,	TABLE64_TEST_HI,
+						0x900FFFFF,	0xFFFFFFFF },
+	{ IGC_MTA,	128,	TABLE32_TEST,
+						0xFFFFFFFF,	0xFFFFFFFF },
+	{ 0, 0, 0, 0}
+};
+
+static bool reg_pattern_test(struct igc_adapter *adapter, u64 *data, int reg,
+			     u32 mask, u32 write)
+{
+	struct igc_hw *hw = &adapter->hw;
+	u32 pat, val, before;
+	static const u32 test_pattern[] = {
+		0x5A5A5A5A, 0xA5A5A5A5, 0x00000000, 0xFFFFFFFF
+	};
+
+	for (pat = 0; pat < ARRAY_SIZE(test_pattern); pat++) {
+		before = rd32(reg);
+		wr32(reg, test_pattern[pat] & write);
+		val = rd32(reg);
+		if (val != (test_pattern[pat] & write & mask)) {
+			netdev_err(adapter->netdev,
+				   "pattern test reg %04X failed: got 0x%08X expected 0x%08X",
+				   reg, val, test_pattern[pat] & write & mask);
+			*data = reg;
+			wr32(reg, before);
+			return false;
+		}
+		wr32(reg, before);
+	}
+	return true;
+}
+
+static bool reg_set_and_check(struct igc_adapter *adapter, u64 *data, int reg,
+			      u32 mask, u32 write)
+{
+	struct igc_hw *hw = &adapter->hw;
+	u32 val, before;
+
+	before = rd32(reg);
+	wr32(reg, write & mask);
+	val = rd32(reg);
+	if ((write & mask) != (val & mask)) {
+		netdev_err(adapter->netdev,
+			   "set/check reg %04X test failed: got 0x%08X expected 0x%08X",
+			   reg, (val & mask), (write & mask));
+		*data = reg;
+		wr32(reg, before);
+		return false;
+	}
+	wr32(reg, before);
+	return true;
+}
+
+bool igc_reg_test(struct igc_adapter *adapter, u64 *data)
+{
+	struct igc_reg_test *test = reg_test;
+	struct igc_hw *hw = &adapter->hw;
+	u32 value, before, after;
+	u32 i, toggle, b = false;
+
+	/* Because the status register is such a special case,
+	 * we handle it separately from the rest of the register
+	 * tests.  Some bits are read-only, some toggle, and some
+	 * are writeable.
+	 */
+	toggle = 0x6800D3;
+	before = rd32(IGC_STATUS);
+	value = before & toggle;
+	wr32(IGC_STATUS, toggle);
+	after = rd32(IGC_STATUS) & toggle;
+	if (value != after) {
+		netdev_err(adapter->netdev,
+			   "failed STATUS register test got: 0x%08X expected: 0x%08X",
+			   after, value);
+		*data = 1;
+		return false;
+	}
+	/* restore previous status */
+	wr32(IGC_STATUS, before);
+
+	/* Perform the remainder of the register test, looping through
+	 * the test table until we either fail or reach the null entry.
+	 */
+	while (test->reg) {
+		for (i = 0; i < test->array_len; i++) {
+			switch (test->test_type) {
+			case PATTERN_TEST:
+				b = reg_pattern_test(adapter, data,
+						     test->reg + (i * 0x40),
+						     test->mask,
+						     test->write);
+				break;
+			case SET_READ_TEST:
+				b = reg_set_and_check(adapter, data,
+						      test->reg + (i * 0x40),
+						      test->mask,
+						      test->write);
+				break;
+			case TABLE64_TEST_LO:
+				b = reg_pattern_test(adapter, data,
+						     test->reg + (i * 8),
+						     test->mask,
+						     test->write);
+				break;
+			case TABLE64_TEST_HI:
+				b = reg_pattern_test(adapter, data,
+						     test->reg + 4 + (i * 8),
+						     test->mask,
+						     test->write);
+				break;
+			case TABLE32_TEST:
+				b = reg_pattern_test(adapter, data,
+						     test->reg + (i * 4),
+						     test->mask,
+						     test->write);
+				break;
+			}
+			if (!b)
+				return false;
+		}
+		test++;
+	}
+	*data = 0;
+	return true;
+}
+
+bool igc_eeprom_test(struct igc_adapter *adapter, u64 *data)
+{
+	struct igc_hw *hw = &adapter->hw;
+
+	*data = 0;
+
+	if (hw->nvm.ops.validate(hw) != IGC_SUCCESS) {
+		*data = 1;
+		return false;
+	}
+
+	return true;
+}
+
+static irqreturn_t igc_test_intr(int irq, void *data)
+{
+	struct igc_adapter *adapter = (struct igc_adapter *)data;
+	struct igc_hw *hw = &adapter->hw;
+
+	adapter->test_icr |= rd32(IGC_ICR);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t igc_test_intr_msix(int irq, void *data)
+{
+	struct igc_adapter *adapter = (struct igc_adapter *)data;
+	struct igc_hw *hw = &adapter->hw;
+
+	adapter->test_icr |= rd32(IGC_EICR);
+
+	return IRQ_HANDLED;
+}
+
+bool igc_intr_test(struct igc_adapter *adapter, u64 *data)
+{
+	struct igc_hw *hw = &adapter->hw;
+	struct net_device *netdev = adapter->netdev;
+	u32 mask, ics_mask = IGC_ICS_MASK_OTHER, i = 0, shared_int = true;
+	u32 irq = adapter->pdev->irq;
+
+	*data = 0;
+
+	/* Hook up test interrupt handler just for this test */
+	if (adapter->msix_entries) {
+		if (request_irq(adapter->msix_entries[0].vector,
+				&igc_test_intr_msix, 0,
+				netdev->name, adapter)) {
+			*data = 1;
+			return false;
+		}
+		ics_mask = IGC_ICS_MASK_MSIX;
+	} else if (adapter->flags & IGC_FLAG_HAS_MSI) {
+		shared_int = false;
+		if (request_irq(irq,
+				igc_test_intr, 0, netdev->name, adapter)) {
+			*data = 1;
+			return false;
+		}
+	} else if (!request_irq(irq, igc_test_intr, IRQF_PROBE_SHARED,
+				netdev->name, adapter)) {
+		shared_int = false;
+	} else if (request_irq(irq, &igc_test_intr, IRQF_SHARED,
+		 netdev->name, adapter)) {
+		*data = 1;
+		return false;
+	}
+	netdev_info(adapter->netdev, "testing %s interrupt",
+		    (shared_int ? "shared" : "unshared"));
+
+	/* Disable all the interrupts */
+	wr32(IGC_IMC, ~0);
+	wr32(IGC_EIMC, ~0);
+	wrfl();
+	usleep_range(10000, 20000);
+
+	/* Test each interrupt */
+	for (; i < 31; i++) {
+		/* Interrupt to test */
+		mask = BIT(i);
+
+		if (!(mask & ics_mask))
+			continue;
+
+		if (!shared_int) {
+			/* Disable the interrupt to be reported in
+			 * the cause register and then force the same
+			 * interrupt and see if one gets posted.  If
+			 * an interrupt was posted to the bus, the
+			 * test failed.
+			 */
+			adapter->test_icr = 0;
+
+			/* Flush any pending interrupts */
+			wr32(IGC_ICR, ~0);
+
+			wr32(IGC_IMC, mask);
+			wr32(IGC_ICS, mask);
+			wrfl();
+			usleep_range(10000, 20000);
+
+			if (adapter->test_icr & mask) {
+				*data = 3;
+				break;
+			}
+		}
+
+		/* Enable the interrupt to be reported in
+		 * the cause register and then force the same
+		 * interrupt and see if one gets posted.  If
+		 * an interrupt was not posted to the bus, the
+		 * test failed.
+		 */
+		adapter->test_icr = 0;
+
+		wr32(IGC_EIMS, mask);
+		wr32(IGC_EICS, mask);
+		wrfl();
+		usleep_range(10000, 20000);
+
+		if (!(adapter->test_icr & mask)) {
+			*data = 4;
+			break;
+		}
+
+		if (!shared_int) {
+			/* Disable the other interrupts to be reported in
+			 * the cause register and then force the other
+			 * interrupts and see if any get posted.  If
+			 * an interrupt was posted to the bus, the
+			 * test failed.
+			 */
+			adapter->test_icr = 0;
+
+			/* Flush any pending interrupts */
+			wr32(IGC_ICR, ~0);
+
+			wr32(IGC_IMC, ~mask);
+			wr32(IGC_ICS, ~mask);
+			wrfl();
+			usleep_range(10000, 20000);
+
+			if (adapter->test_icr & mask) {
+				*data = 5;
+				break;
+			}
+		}
+	}
+
+	/* Disable all the interrupts */
+	wr32(IGC_EIMC, ~0);
+	wr32(IGC_IMC, ~0);
+	wrfl();
+	usleep_range(10000, 20000);
+
+	/* Unhook test interrupt handler */
+	if (adapter->msix_entries)
+		free_irq(adapter->msix_entries[0].vector, adapter);
+	else
+		free_irq(irq, adapter);
+
+	return true;
+}
+
+bool igc_link_test(struct igc_adapter *adapter, u64 *data)
+{
+	bool link_up;
+
+	*data = 0;
+
+	/* add delay to give enough time for autonegotioation to finish */
+	if (adapter->hw.mac.autoneg)
+		ssleep(5);
+
+	link_up = igc_has_link(adapter);
+	if (!link_up) {
+		*data = 1;
+		return false;
+	}
+
+	return true;
+}
diff --git a/drivers/net/ethernet/intel/igc/igc_diag.h b/drivers/net/ethernet/intel/igc/igc_diag.h
new file mode 100644
index 000000000000..3cffaad01d50
--- /dev/null
+++ b/drivers/net/ethernet/intel/igc/igc_diag.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c)  2020 Intel Corporation */
+
+bool igc_reg_test(struct igc_adapter *adapter, u64 *data);
+bool igc_eeprom_test(struct igc_adapter *adapter, u64 *data);
+bool igc_intr_test(struct igc_adapter *adapter, u64 *data);
+bool igc_link_test(struct igc_adapter *adapter, u64 *data);
+
+struct igc_reg_test {
+	u16 reg;
+	u8 array_len;
+	u8 test_type;
+	u32 mask;
+	u32 write;
+};
+
+/* In the hardware, registers are laid out either singly, in arrays
+ * spaced 0x40 bytes apart, or in contiguous tables.  We assume
+ * most tests take place on arrays or single registers (handled
+ * as a single-element array) and special-case the tables.
+ * Table tests are always pattern tests.
+ *
+ * We also make provision for some required setup steps by specifying
+ * registers to be written without any read-back testing.
+ */
+
+#define PATTERN_TEST	1
+#define SET_READ_TEST	2
+#define TABLE32_TEST	3
+#define TABLE64_TEST_LO	4
+#define TABLE64_TEST_HI	5
+
+/* For interrupt test we are using different registers
+ * and masks for msi-x interrupts and the other methods
+ */
+#define IGC_ICS_MASK_OTHER	0x774CFED5
+#define IGC_ICS_MASK_MSIX	0xF
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 0a8c4a7412a4..c14196663ebb 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -6,6 +6,7 @@
 #include <linux/pm_runtime.h>
 
 #include "igc.h"
+#include "igc_diag.h"
 
 /* forward declaration */
 struct igc_stats {
@@ -1896,6 +1897,67 @@ static int igc_set_link_ksettings(struct net_device *netdev,
 	return 0;
 }
 
+static void igc_diag_test(struct net_device *netdev,
+			  struct ethtool_test *eth_test, u64 *data)
+{
+	struct igc_adapter *adapter = netdev_priv(netdev);
+	bool if_running = netif_running(netdev);
+
+	if (eth_test->flags == ETH_TEST_FL_OFFLINE) {
+		netdev_info(adapter->netdev, "offline testing starting");
+		set_bit(__IGC_TESTING, &adapter->state);
+
+		/* Link test performed before hardware reset so autoneg doesn't
+		 * interfere with test result
+		 */
+		if (!igc_link_test(adapter, &data[TEST_LINK]))
+			eth_test->flags |= ETH_TEST_FL_FAILED;
+
+		if (if_running)
+			igc_close(netdev);
+		else
+			igc_reset(adapter);
+
+		netdev_info(adapter->netdev, "register testing starting");
+		if (!igc_reg_test(adapter, &data[TEST_REG]))
+			eth_test->flags |= ETH_TEST_FL_FAILED;
+
+		igc_reset(adapter);
+
+		netdev_info(adapter->netdev, "eeprom testing starting");
+		if (!igc_eeprom_test(adapter, &data[TEST_EEP]))
+			eth_test->flags |= ETH_TEST_FL_FAILED;
+
+		igc_reset(adapter);
+
+		netdev_info(adapter->netdev, "interrupt testing starting");
+		if (!igc_intr_test(adapter, &data[TEST_IRQ]))
+			eth_test->flags |= ETH_TEST_FL_FAILED;
+
+		igc_reset(adapter);
+
+		/* loopback test will be implemented in the future */
+		data[TEST_LOOP] = 0;
+
+		clear_bit(__IGC_TESTING, &adapter->state);
+		if (if_running)
+			igc_open(netdev);
+	} else {
+		netdev_info(adapter->netdev, "online testing starting");
+
+		/* register, eeprom, intr and loopback tests not run online */
+		data[TEST_REG] = 0;
+		data[TEST_EEP] = 0;
+		data[TEST_IRQ] = 0;
+		data[TEST_LOOP] = 0;
+
+		if (!igc_link_test(adapter, &data[TEST_LINK]))
+			eth_test->flags |= ETH_TEST_FL_FAILED;
+	}
+
+	msleep_interruptible(4 * 1000);
+}
+
 static const struct ethtool_ops igc_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS,
 	.get_drvinfo		= igc_get_drvinfo,
@@ -1933,6 +1995,7 @@ static const struct ethtool_ops igc_ethtool_ops = {
 	.complete		= igc_ethtool_complete,
 	.get_link_ksettings	= igc_get_link_ksettings,
 	.set_link_ksettings	= igc_set_link_ksettings,
+	.self_test		= igc_diag_test,
 };
 
 void igc_set_ethtool_ops(struct net_device *netdev)
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index c67d141def1d..ecf074093a42 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4380,7 +4380,7 @@ static int __igc_open(struct net_device *netdev, bool resuming)
 	return err;
 }
 
-static int igc_open(struct net_device *netdev)
+int igc_open(struct net_device *netdev)
 {
 	return __igc_open(netdev, false);
 }
@@ -4422,7 +4422,7 @@ static int __igc_close(struct net_device *netdev, bool suspending)
 	return 0;
 }
 
-static int igc_close(struct net_device *netdev)
+int igc_close(struct net_device *netdev)
 {
 	if (netif_device_present(netdev) || netdev->dismantle)
 		return __igc_close(netdev, false);
diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index 6093cde2351c..633545977a65 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -49,6 +49,7 @@
 #define IGC_FACTPS		0x05B30
 
 /* Interrupt Register Description */
+#define IGC_EICR		0x01580  /* Ext. Interrupt Cause read - W0 */
 #define IGC_EICS		0x01520  /* Ext. Interrupt Cause Set - W0 */
 #define IGC_EIMS		0x01524  /* Ext. Interrupt Mask Set/Read - RW */
 #define IGC_EIMC		0x01528  /* Ext. Interrupt Mask Clear - WO */
@@ -119,6 +120,7 @@
 #define IGC_RLPML		0x05004  /* Rx Long Packet Max Length */
 #define IGC_RFCTL		0x05008  /* Receive Filter Control*/
 #define IGC_MTA			0x05200  /* Multicast Table Array - RW Array */
+#define IGC_RA			0x05400  /* Receive Address - RW Array */
 #define IGC_UTA			0x0A000  /* Unicast Table Array - RW */
 #define IGC_RAL(_n)		(0x05400 + ((_n) * 0x08))
 #define IGC_RAH(_n)		(0x05404 + ((_n) * 0x08))
-- 
2.25.3

