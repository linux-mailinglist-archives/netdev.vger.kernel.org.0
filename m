Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA866829F4
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 11:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbjAaKH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 05:07:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjAaKH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 05:07:28 -0500
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08FE44860D
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 02:07:21 -0800 (PST)
X-QQ-mid: bizesmtp69t1675159568tj2n5gvn
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 31 Jan 2023 18:06:07 +0800 (CST)
X-QQ-SSF: 01400000000000M0O000000A0000000
X-QQ-FEAT: +ynUkgUhZJkJuyNZaWkvtbpCa8Lpn+clBsQslb+JzjaH8KGL6ENyhK8AYKA46
        0HRic103ykzX+ILBimcIQvTQrwrdPEzqtpP5q88Uf3yjs4ZSfyMNkn/TWh4qDthCfL7lrSd
        3zF/lcDeSxBFxw23pqZVmBW5J3k2iznsfHzbsd8Dj39HQpMC6SFMqk7uO6YDm69HELbUVlF
        4wTVNKvIw4mTTZr079rcpZFjmCbesnQKXuIsfgInD9j3mmKC6JNxBPGAOI/2UbyVZp+TSYR
        RoxeidqaY5SslmYMa09fuA1SGqptI/kuywwwA5trvb1McIMJETe7CWnKlAvtUgDTzYJI7o0
        LZ7xougzGjim2iFC37o6JnunvL1+jSdTyi1jiCXTuCdOac1PUGHjh8zYfuE075r9+nDaSU+
        ivo7YcJbvBjq8+lRa1HrSCKBV37Ecpoq
X-QQ-GoodBg: 2
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com
Subject: [PATCH net-next v2 03/10] net: txgbe: Add interrupt support
Date:   Tue, 31 Jan 2023 18:05:34 +0800
Message-Id: <20230131100541.73757-4-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230131100541.73757-1-mengyuanlou@net-swift.com>
References: <20230131100541.73757-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_PASS,T_SPF_HELO_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiawen Wu <jiawenwu@trustnetic.com>

Determine proper interrupt scheme to enable and handle interrupt.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 201 ++++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  18 ++
 2 files changed, 219 insertions(+)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index aa4d09df3b01..48cca2fb54c7 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -11,6 +11,7 @@
 #include <net/ip.h>
 
 #include "../libwx/wx_type.h"
+#include "../libwx/wx_lib.h"
 #include "../libwx/wx_hw.h"
 #include "txgbe_type.h"
 #include "txgbe_hw.h"
@@ -72,9 +73,158 @@ static int txgbe_enumerate_functions(struct wx *wx)
 	return physfns;
 }
 
+/**
+ * txgbe_irq_enable - Enable default interrupt generation settings
+ * @wx: pointer to private structure
+ * @queues: enable irqs for queues
+ **/
+static void txgbe_irq_enable(struct wx *wx, bool queues)
+{
+	/* unmask interrupt */
+	wx_intr_enable(wx, TXGBE_INTR_MISC(wx));
+	if (queues)
+		wx_intr_enable(wx, TXGBE_INTR_QALL(wx));
+}
+
+/**
+ * txgbe_intr - msi/legacy mode Interrupt Handler
+ * @irq: interrupt number
+ * @data: pointer to a network interface device structure
+ **/
+static irqreturn_t txgbe_intr(int __always_unused irq, void *data)
+{
+	struct wx_q_vector *q_vector;
+	struct wx *wx  = data;
+	struct pci_dev *pdev;
+	u32 eicr;
+
+	q_vector = wx->q_vector[0];
+	pdev = wx->pdev;
+
+	eicr = wx_misc_isb(wx, WX_ISB_VEC0);
+	if (!eicr) {
+		/* shared interrupt alert!
+		 * the interrupt that we masked before the ICR read.
+		 */
+		if (netif_running(wx->netdev))
+			txgbe_irq_enable(wx, true);
+		return IRQ_NONE;        /* Not our interrupt */
+	}
+	wx->isb_mem[WX_ISB_VEC0] = 0;
+	if (!(pdev->msi_enabled))
+		wr32(wx, WX_PX_INTA, 1);
+
+	wx->isb_mem[WX_ISB_MISC] = 0;
+	/* would disable interrupts here but it is auto disabled */
+	napi_schedule_irqoff(&q_vector->napi);
+
+	/* re-enable link(maybe) and non-queue interrupts, no flush.
+	 * txgbe_poll will re-enable the queue interrupts
+	 */
+	if (netif_running(wx->netdev))
+		txgbe_irq_enable(wx, false);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t txgbe_msix_other(int __always_unused irq, void *data)
+{
+	struct wx *wx = data;
+
+	/* re-enable the original interrupt state */
+	if (netif_running(wx->netdev))
+		txgbe_irq_enable(wx, false);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * txgbe_request_msix_irqs - Initialize MSI-X interrupts
+ * @wx: board private structure
+ *
+ * Allocate MSI-X vectors and request interrupts from the kernel.
+ **/
+static int txgbe_request_msix_irqs(struct wx *wx)
+{
+	struct net_device *netdev = wx->netdev;
+	int vector, err;
+
+	for (vector = 0; vector < wx->num_q_vectors; vector++) {
+		struct wx_q_vector *q_vector = wx->q_vector[vector];
+		struct msix_entry *entry = &wx->msix_entries[vector];
+
+		if (q_vector->tx.ring && q_vector->rx.ring)
+			snprintf(q_vector->name, sizeof(q_vector->name) - 1,
+				 "%s-TxRx-%d", netdev->name, entry->entry);
+		else
+			/* skip this unused q_vector */
+			continue;
+
+		err = request_irq(entry->vector, wx_msix_clean_rings, 0,
+				  q_vector->name, q_vector);
+		if (err) {
+			wx_err(wx, "request_irq failed for MSIX interrupt %s Error: %d\n",
+			       q_vector->name, err);
+			goto free_queue_irqs;
+		}
+	}
+
+	err = request_irq(wx->msix_entries[vector].vector,
+			  txgbe_msix_other, 0, netdev->name, wx);
+	if (err) {
+		wx_err(wx, "request_irq for msix_other failed: %d\n", err);
+		goto free_queue_irqs;
+	}
+
+	return 0;
+
+free_queue_irqs:
+	while (vector) {
+		vector--;
+		free_irq(wx->msix_entries[vector].vector,
+			 wx->q_vector[vector]);
+	}
+	wx_reset_interrupt_capability(wx);
+	return err;
+}
+
+/**
+ * txgbe_request_irq - initialize interrupts
+ * @wx: board private structure
+ *
+ * Attempt to configure interrupts using the best available
+ * capabilities of the hardware and kernel.
+ **/
+static int txgbe_request_irq(struct wx *wx)
+{
+	struct net_device *netdev = wx->netdev;
+	struct pci_dev *pdev = wx->pdev;
+	int err;
+
+	if (pdev->msix_enabled)
+		err = txgbe_request_msix_irqs(wx);
+	else if (pdev->msi_enabled)
+		err = request_irq(wx->pdev->irq, &txgbe_intr, 0,
+				  netdev->name, wx);
+	else
+		err = request_irq(wx->pdev->irq, &txgbe_intr, IRQF_SHARED,
+				  netdev->name, wx);
+
+	if (err)
+		wx_err(wx, "request_irq failed, Error %d\n", err);
+
+	return err;
+}
+
 static void txgbe_up_complete(struct wx *wx)
 {
 	wx_control_hw(wx, true);
+	wx_configure_vectors(wx);
+
+	/* clear any pending interrupts, may auto mask */
+	rd32(wx, WX_PX_IC);
+	rd32(wx, WX_PX_MISC_IC);
+	txgbe_irq_enable(wx, true);
 }
 
 static void txgbe_reset(struct wx *wx)
@@ -104,6 +254,8 @@ static void txgbe_disable_device(struct wx *wx)
 	netif_carrier_off(netdev);
 	netif_tx_disable(netdev);
 
+	wx_irq_disable(wx);
+
 	if (wx->bus.func < 2)
 		wr32m(wx, TXGBE_MIS_PRB_CTL, TXGBE_MIS_PRB_CTL_LAN_UP(wx->bus.func), 0);
 	else
@@ -132,6 +284,7 @@ static void txgbe_down(struct wx *wx)
  **/
 static int txgbe_sw_init(struct wx *wx)
 {
+	u16 msix_count = 0;
 	int err;
 
 	wx->mac.num_rar_entries = TXGBE_SP_RAR_ENTRIES;
@@ -156,6 +309,25 @@ static int txgbe_sw_init(struct wx *wx)
 		break;
 	}
 
+	/* Set common capability flags and settings */
+	wx->max_q_vectors = TXGBE_MAX_MSIX_VECTORS;
+	err = wx_get_pcie_msix_counts(wx, &msix_count, TXGBE_MAX_MSIX_VECTORS);
+	if (err)
+		wx_err(wx, "Do not support MSI-X\n");
+	wx->mac.max_msix_vectors = msix_count;
+
+	/* enable itr by default in dynamic mode */
+	wx->rx_itr_setting = 1;
+	wx->tx_itr_setting = 1;
+
+	/* set default ring sizes */
+	wx->tx_ring_count = TXGBE_DEFAULT_TXD;
+	wx->rx_ring_count = TXGBE_DEFAULT_RXD;
+
+	/* set default work limits */
+	wx->tx_work_limit = TXGBE_DEFAULT_TX_WORK;
+	wx->rx_work_limit = TXGBE_DEFAULT_RX_WORK;
+
 	return 0;
 }
 
@@ -171,10 +343,28 @@ static int txgbe_sw_init(struct wx *wx)
 static int txgbe_open(struct net_device *netdev)
 {
 	struct wx *wx = netdev_priv(netdev);
+	int err;
+
+	err = wx_setup_isb_resources(wx);
+	if (err)
+		goto err_reset;
+
+	wx_configure(wx);
+
+	err = txgbe_request_irq(wx);
+	if (err)
+		goto err_free_isb;
 
 	txgbe_up_complete(wx);
 
 	return 0;
+
+err_free_isb:
+	wx_free_isb_resources(wx);
+err_reset:
+	txgbe_reset(wx);
+
+	return err;
 }
 
 /**
@@ -187,6 +377,9 @@ static int txgbe_open(struct net_device *netdev)
 static void txgbe_close_suspend(struct wx *wx)
 {
 	txgbe_disable_device(wx);
+
+	wx_free_irq(wx);
+	wx_free_isb_resources(wx);
 }
 
 /**
@@ -205,6 +398,8 @@ static int txgbe_close(struct net_device *netdev)
 	struct wx *wx = netdev_priv(netdev);
 
 	txgbe_down(wx);
+	wx_free_irq(wx);
+	wx_free_isb_resources(wx);
 	wx_control_hw(wx, false);
 
 	return 0;
@@ -367,6 +562,10 @@ static int txgbe_probe(struct pci_dev *pdev,
 	eth_hw_addr_set(netdev, wx->mac.perm_addr);
 	wx_mac_set_default_filter(wx, wx->mac.perm_addr);
 
+	err = wx_init_interrupt_scheme(wx);
+	if (err)
+		goto err_free_mac_table;
+
 	/* Save off EEPROM version number and Option Rom version which
 	 * together make a unique identify for the eeprom
 	 */
@@ -435,6 +634,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 	return 0;
 
 err_release_hw:
+	wx_clear_interrupt_scheme(wx);
 	wx_control_hw(wx, false);
 err_free_mac_table:
 	kfree(wx->mac_table);
@@ -468,6 +668,7 @@ static void txgbe_remove(struct pci_dev *pdev)
 				     pci_select_bars(pdev, IORESOURCE_MEM));
 
 	kfree(wx->mac_table);
+	wx_clear_interrupt_scheme(wx);
 
 	pci_disable_pcie_error_reporting(pdev);
 
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index cbd705a9f4bd..ec28cf60c91d 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -67,6 +67,7 @@
 #define TXGBE_PBANUM1_PTR                       0x06
 #define TXGBE_PBANUM_PTR_GUARD                  0xFAFA
 
+#define TXGBE_MAX_MSIX_VECTORS          64
 #define TXGBE_MAX_FDIR_INDICES          63
 
 #define TXGBE_MAX_RX_QUEUES   (TXGBE_MAX_FDIR_INDICES + 1)
@@ -77,6 +78,23 @@
 #define TXGBE_SP_RAR_ENTRIES    128
 #define TXGBE_SP_MC_TBL_SIZE    128
 
+/* TX/RX descriptor defines */
+#define TXGBE_DEFAULT_TXD               512
+#define TXGBE_DEFAULT_TX_WORK           256
+
+#if (PAGE_SIZE < 8192)
+#define TXGBE_DEFAULT_RXD               512
+#define TXGBE_DEFAULT_RX_WORK           256
+#else
+#define TXGBE_DEFAULT_RXD               256
+#define TXGBE_DEFAULT_RX_WORK           128
+#endif
+
+#define TXGBE_INTR_MISC(A)    BIT((A)->num_q_vectors)
+#define TXGBE_INTR_QALL(A)    (TXGBE_INTR_MISC(A) - 1)
+
+#define TXGBE_MAX_EITR        GENMASK(11, 3)
+
 extern char txgbe_driver_name[];
 
 #endif /* _TXGBE_TYPE_H_ */
-- 
2.39.1

