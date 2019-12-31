Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8C212DC2A
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 23:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbfLaW2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 17:28:03 -0500
Received: from mga01.intel.com ([192.55.52.88]:1528 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727201AbfLaW1x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Dec 2019 17:27:53 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Dec 2019 14:27:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,380,1571727600"; 
   d="scan'208";a="209403604"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga007.jf.intel.com with ESMTP; 31 Dec 2019 14:27:52 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        kbuild test robot <lpk@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 09/11] igc: Add legacy power management support
Date:   Tue, 31 Dec 2019 14:27:48 -0800
Message-Id: <20191231222750.3749984-10-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191231222750.3749984-1-jeffrey.t.kirsher@intel.com>
References: <20191231222750.3749984-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Add suspend, resume, runtime_suspend, runtime_resume and
runtime_idle callbacks implementation.

Reported-by: kbuild test robot <lpk@intel.com>
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h         |   2 +
 drivers/net/ethernet/intel/igc/igc_defines.h |  31 +++
 drivers/net/ethernet/intel/igc/igc_main.c    | 204 +++++++++++++++++++
 drivers/net/ethernet/intel/igc/igc_regs.h    |   9 +
 4 files changed, 246 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 0868677d43ed..612fe9ec81a4 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -370,6 +370,8 @@ struct igc_adapter {
 	struct timer_list dma_err_timer;
 	struct timer_list phy_info_timer;
 
+	u32 wol;
+	u32 en_mng_pt;
 	u16 link_speed;
 	u16 link_duplex;
 
diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index f3788f0b95b4..50dffd5db606 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -10,6 +10,37 @@
 
 #define IGC_CTRL_EXT_DRV_LOAD	0x10000000 /* Drv loaded bit for FW */
 
+/* Definitions for power management and wakeup registers */
+/* Wake Up Control */
+#define IGC_WUC_PME_EN	0x00000002 /* PME Enable */
+
+/* Wake Up Filter Control */
+#define IGC_WUFC_LNKC	0x00000001 /* Link Status Change Wakeup Enable */
+#define IGC_WUFC_MC	0x00000008 /* Directed Multicast Wakeup Enable */
+
+#define IGC_CTRL_ADVD3WUC	0x00100000  /* D3 WUC */
+
+/* Wake Up Status */
+#define IGC_WUS_EX	0x00000004 /* Directed Exact */
+#define IGC_WUS_ARPD	0x00000020 /* Directed ARP Request */
+#define IGC_WUS_IPV4	0x00000040 /* Directed IPv4 */
+#define IGC_WUS_IPV6	0x00000080 /* Directed IPv6 */
+#define IGC_WUS_NSD	0x00000400 /* Directed IPv6 Neighbor Solicitation */
+
+/* Packet types that are enabled for wake packet delivery */
+#define WAKE_PKT_WUS ( \
+	IGC_WUS_EX   | \
+	IGC_WUS_ARPD | \
+	IGC_WUS_IPV4 | \
+	IGC_WUS_IPV6 | \
+	IGC_WUS_NSD)
+
+/* Wake Up Packet Length */
+#define IGC_WUPL_MASK	0x00000FFF
+
+/* Wake Up Packet Memory stores the first 128 bytes of the wake up packet */
+#define IGC_WUPM_BYTES	128
+
 /* Physical Func Reset Done Indication */
 #define IGC_CTRL_EXT_LINK_MODE_MASK	0x00C00000
 
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index b85009837cdf..ca7b8d6791f1 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -8,6 +8,7 @@
 #include <linux/tcp.h>
 #include <linux/udp.h>
 #include <linux/ip.h>
+#include <linux/pm_runtime.h>
 
 #include <net/ipv6.h>
 
@@ -4581,11 +4582,214 @@ static void igc_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
+static int __igc_shutdown(struct pci_dev *pdev, bool *enable_wake,
+			  bool runtime)
+{
+	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct igc_adapter *adapter = netdev_priv(netdev);
+	u32 wufc = runtime ? IGC_WUFC_LNKC : adapter->wol;
+	struct igc_hw *hw = &adapter->hw;
+	u32 ctrl, rctl, status;
+	bool wake;
+
+	rtnl_lock();
+	netif_device_detach(netdev);
+
+	if (netif_running(netdev))
+		__igc_close(netdev, true);
+
+	igc_clear_interrupt_scheme(adapter);
+	rtnl_unlock();
+
+	status = rd32(IGC_STATUS);
+	if (status & IGC_STATUS_LU)
+		wufc &= ~IGC_WUFC_LNKC;
+
+	if (wufc) {
+		igc_setup_rctl(adapter);
+		igc_set_rx_mode(netdev);
+
+		/* turn on all-multi mode if wake on multicast is enabled */
+		if (wufc & IGC_WUFC_MC) {
+			rctl = rd32(IGC_RCTL);
+			rctl |= IGC_RCTL_MPE;
+			wr32(IGC_RCTL, rctl);
+		}
+
+		ctrl = rd32(IGC_CTRL);
+		ctrl |= IGC_CTRL_ADVD3WUC;
+		wr32(IGC_CTRL, ctrl);
+
+		/* Allow time for pending master requests to run */
+		igc_disable_pcie_master(hw);
+
+		wr32(IGC_WUC, IGC_WUC_PME_EN);
+		wr32(IGC_WUFC, wufc);
+	} else {
+		wr32(IGC_WUC, 0);
+		wr32(IGC_WUFC, 0);
+	}
+
+	wake = wufc || adapter->en_mng_pt;
+	if (!wake)
+		igc_power_down_link(adapter);
+	else
+		igc_power_up_link(adapter);
+
+	if (enable_wake)
+		*enable_wake = wake;
+
+	/* Release control of h/w to f/w.  If f/w is AMT enabled, this
+	 * would have already happened in close and is redundant.
+	 */
+	igc_release_hw_control(adapter);
+
+	pci_disable_device(pdev);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int __maybe_unused igc_runtime_suspend(struct device *dev)
+{
+	return __igc_shutdown(to_pci_dev(dev), NULL, 1);
+}
+
+static void igc_deliver_wake_packet(struct net_device *netdev)
+{
+	struct igc_adapter *adapter = netdev_priv(netdev);
+	struct igc_hw *hw = &adapter->hw;
+	struct sk_buff *skb;
+	u32 wupl;
+
+	wupl = rd32(IGC_WUPL) & IGC_WUPL_MASK;
+
+	/* WUPM stores only the first 128 bytes of the wake packet.
+	 * Read the packet only if we have the whole thing.
+	 */
+	if (wupl == 0 || wupl > IGC_WUPM_BYTES)
+		return;
+
+	skb = netdev_alloc_skb_ip_align(netdev, IGC_WUPM_BYTES);
+	if (!skb)
+		return;
+
+	skb_put(skb, wupl);
+
+	/* Ensure reads are 32-bit aligned */
+	wupl = roundup(wupl, 4);
+
+	memcpy_fromio(skb->data, hw->hw_addr + IGC_WUPM_REG(0), wupl);
+
+	skb->protocol = eth_type_trans(skb, netdev);
+	netif_rx(skb);
+}
+
+static int __maybe_unused igc_resume(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct igc_adapter *adapter = netdev_priv(netdev);
+	struct igc_hw *hw = &adapter->hw;
+	u32 err, val;
+
+	pci_set_power_state(pdev, PCI_D0);
+	pci_restore_state(pdev);
+	pci_save_state(pdev);
+
+	if (!pci_device_is_present(pdev))
+		return -ENODEV;
+	err = pci_enable_device_mem(pdev);
+	if (err) {
+		dev_err(&pdev->dev,
+			"igc: Cannot enable PCI device from suspend\n");
+		return err;
+	}
+	pci_set_master(pdev);
+
+	pci_enable_wake(pdev, PCI_D3hot, 0);
+	pci_enable_wake(pdev, PCI_D3cold, 0);
+
+	if (igc_init_interrupt_scheme(adapter, true)) {
+		dev_err(&pdev->dev, "Unable to allocate memory for queues\n");
+		return -ENOMEM;
+	}
+
+	igc_reset(adapter);
+
+	/* let the f/w know that the h/w is now under the control of the
+	 * driver.
+	 */
+	igc_get_hw_control(adapter);
+
+	val = rd32(IGC_WUS);
+	if (val & WAKE_PKT_WUS)
+		igc_deliver_wake_packet(netdev);
+
+	wr32(IGC_WUS, ~0);
+
+	rtnl_lock();
+	if (!err && netif_running(netdev))
+		err = __igc_open(netdev, true);
+
+	if (!err)
+		netif_device_attach(netdev);
+	rtnl_unlock();
+
+	return err;
+}
+
+static int __maybe_unused igc_runtime_resume(struct device *dev)
+{
+	return igc_resume(dev);
+}
+
+static int __maybe_unused igc_suspend(struct device *dev)
+{
+	return __igc_shutdown(to_pci_dev(dev), NULL, 0);
+}
+
+static int __maybe_unused igc_runtime_idle(struct device *dev)
+{
+	struct net_device *netdev = dev_get_drvdata(dev);
+	struct igc_adapter *adapter = netdev_priv(netdev);
+
+	if (!igc_has_link(adapter))
+		pm_schedule_suspend(dev, MSEC_PER_SEC * 5);
+
+	return -EBUSY;
+}
+#endif /* CONFIG_PM */
+
+static void igc_shutdown(struct pci_dev *pdev)
+{
+	bool wake;
+
+	__igc_shutdown(pdev, &wake, 0);
+
+	if (system_state == SYSTEM_POWER_OFF) {
+		pci_wake_from_d3(pdev, wake);
+		pci_set_power_state(pdev, PCI_D3hot);
+	}
+}
+
+#ifdef CONFIG_PM
+static const struct dev_pm_ops igc_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(igc_suspend, igc_resume)
+	SET_RUNTIME_PM_OPS(igc_runtime_suspend, igc_runtime_resume,
+			   igc_runtime_idle)
+};
+#endif
+
 static struct pci_driver igc_driver = {
 	.name     = igc_driver_name,
 	.id_table = igc_pci_tbl,
 	.probe    = igc_probe,
 	.remove   = igc_remove,
+#ifdef CONFIG_PM
+	.driver.pm = &igc_pm_ops,
+#endif
+	.shutdown = igc_shutdown,
 };
 
 void igc_set_flag_queue_pairs(struct igc_adapter *adapter,
diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index 50d7c04dccf5..93a9139f08c5 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -215,6 +215,15 @@
 /* Shadow Ram Write Register - RW */
 #define IGC_SRWR	0x12018
 
+/* Wake Up registers */
+#define IGC_WUC		0x05800  /* Wakeup Control - RW */
+#define IGC_WUFC	0x05808  /* Wakeup Filter Control - RW */
+#define IGC_WUS		0x05810  /* Wakeup Status - R/W1C */
+#define IGC_WUPL	0x05900  /* Wakeup Packet Length - RW */
+
+/* Wake Up packet memory */
+#define IGC_WUPM_REG(_i)	(0x05A00 + ((_i) * 4))
+
 /* forward declaration */
 struct igc_hw;
 u32 igc_rd32(struct igc_hw *hw, u32 reg);
-- 
2.24.1

