Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75C5765CE9A
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 09:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234296AbjADIqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 03:46:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234288AbjADIpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 03:45:46 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB941A815;
        Wed,  4 Jan 2023 00:45:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1672821923; x=1704357923;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vki3vUZzZwKvk+WRo/C7+lOu6zVXJGNDZfZrnMWIGRM=;
  b=LTwX126SRtE70O0NFoc4jesofDktyUUut0lL6lLroz+xUkswqEAtTI0A
   5wsBTiRk85+cITAbWTqFPlymDwbwJwjiJn7Gu6N5cb5arxJ6BTsw8o6pC
   gE92umwzqkoFlWsGee++GxcyfZ4GCZd/ylFrGbeNJw4Y2Ni7GcrcApAB0
   btEKRBKZkz+QBX+g/wR44f4tFY5zNUT5Sc996ivCueb/4yDKE+7Djo2XT
   BDGOWcU84g+LKt1MsyAAZLCEFtIj4+P5jTycuCcFirwyzJ9OgdEUV25at
   HZ7Imb/Jhk1CEuTo7b5DfvxtS8ZTR1IZ7DFACM1lJ/NVsJUoUVUAp5KIa
   g==;
X-IronPort-AV: E=Sophos;i="5.96,299,1665471600"; 
   d="scan'208";a="130719906"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Jan 2023 01:45:17 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 4 Jan 2023 01:45:16 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Wed, 4 Jan 2023 01:45:10 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>, <ceggers@arri.de>
Subject: [Patch net-next v7 05/13] net: dsa: microchip: ptp: enable interrupt for timestamping
Date:   Wed, 4 Jan 2023 14:13:08 +0530
Message-ID: <20230104084316.4281-6-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20230104084316.4281-1-arun.ramadoss@microchip.com>
References: <20230104084316.4281-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PTP Interrupt mask and status register differ from the global and port
interrupt mechanism by two methods. One is that for global/port
interrupt enabling we have to clear the bit but for ptp interrupt we
have to set the bit. And other is bit12:0 is reserved in ptp interrupt
registers. This forced to not use the generic implementation of
global/port interrupt method routine. This patch implement the ptp
interrupt mechanism to read the timestamp register for sync, pdelay_req
and pdelay_resp.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
v4 -> v5
- Replaced the irq_domain_add_simple with  irq_domain_add_linear
- Updated the error path to free_irq

v3 -> v4
- Removed IRQF_TRIGGER_FALLING flag in the request_threaded_irq

RFC v2 -> Patch v1
- Moved the acking of interrupts before calling the handle_nested_irq to
  avoid race condition between deferred xmit and Irq threads
---
 drivers/net/dsa/microchip/ksz_common.c  |  15 +-
 drivers/net/dsa/microchip/ksz_common.h  |  11 ++
 drivers/net/dsa/microchip/ksz_ptp.c     | 207 ++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_ptp.h     |   9 ++
 drivers/net/dsa/microchip/ksz_ptp_reg.h |  19 +++
 5 files changed, 259 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 1dddb80a2baf..bdd068322ca0 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -2100,13 +2100,17 @@ static int ksz_setup(struct dsa_switch *ds)
 			ret = ksz_pirq_setup(dev, dp->index);
 			if (ret)
 				goto out_girq;
+
+			ret = ksz_ptp_irq_setup(ds, dp->index);
+			if (ret)
+				goto out_pirq;
 		}
 	}
 
 	ret = ksz_ptp_clock_register(ds);
 	if (ret) {
 		dev_err(dev->dev, "Failed to register PTP clock: %d\n", ret);
-		goto out_pirq;
+		goto out_ptpirq;
 	}
 
 	ret = ksz_mdio_register(dev);
@@ -2123,6 +2127,10 @@ static int ksz_setup(struct dsa_switch *ds)
 
 out_ptp_clock_unregister:
 	ksz_ptp_clock_unregister(ds);
+out_ptpirq:
+	if (dev->irq > 0)
+		dsa_switch_for_each_user_port(dp, dev->ds)
+			ksz_ptp_irq_free(ds, dp->index);
 out_pirq:
 	if (dev->irq > 0)
 		dsa_switch_for_each_user_port(dp, dev->ds)
@@ -2142,8 +2150,11 @@ static void ksz_teardown(struct dsa_switch *ds)
 	ksz_ptp_clock_unregister(ds);
 
 	if (dev->irq > 0) {
-		dsa_switch_for_each_user_port(dp, dev->ds)
+		dsa_switch_for_each_user_port(dp, dev->ds) {
+			ksz_ptp_irq_free(ds, dp->index);
+
 			ksz_irq_free(&dev->ports[dp->index].pirq);
+		}
 
 		ksz_irq_free(&dev->girq);
 	}
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 641aca78ef05..ec1bceb4efcc 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -20,6 +20,7 @@
 #define KSZ_MAX_NUM_PORTS 8
 
 struct ksz_device;
+struct ksz_port;
 
 struct vlan_table {
 	u32 table[3];
@@ -83,6 +84,13 @@ struct ksz_irq {
 	struct ksz_device *dev;
 };
 
+struct ksz_ptp_irq {
+	struct ksz_port *port;
+	u16 ts_reg;
+	char name[16];
+	int num;
+};
+
 struct ksz_port {
 	bool remove_tag;		/* Remove Tag flag set, for ksz8795 only */
 	bool learning;
@@ -106,6 +114,8 @@ struct ksz_port {
 	struct hwtstamp_config tstamp_config;
 	bool hwts_tx_en;
 	bool hwts_rx_en;
+	struct ksz_irq ptpirq;
+	struct ksz_ptp_irq ptpmsg_irq[3];
 #endif
 };
 
@@ -612,6 +622,7 @@ static inline int is_lan937x(struct ksz_device *dev)
 #define REG_PORT_INT_MASK		0x001F
 
 #define PORT_SRC_PHY_INT		1
+#define PORT_SRC_PTP_INT		2
 
 #define KSZ8795_HUGE_PACKET_SIZE	2000
 #define KSZ8863_HUGE_PACKET_SIZE	1916
diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
index 3e124816697d..6cf30bf50c7e 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.c
+++ b/drivers/net/dsa/microchip/ksz_ptp.c
@@ -6,6 +6,8 @@
  */
 
 #include <linux/dsa/ksz_common.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
 #include <linux/kernel.h>
 #include <linux/ptp_classify.h>
 #include <linux/ptp_clock_kernel.h>
@@ -25,6 +27,8 @@
 #define KSZ_PTP_INC_NS 40ULL  /* HW clock is incremented every 40 ns (by 40) */
 #define KSZ_PTP_SUBNS_BITS 32
 
+#define KSZ_PTP_INT_START 13
+
 static int ksz_ptp_enable_mode(struct ksz_device *dev)
 {
 	struct ksz_tagger_data *tagger_data = ksz_tagger_data(dev->ds);
@@ -419,6 +423,209 @@ void ksz_ptp_clock_unregister(struct dsa_switch *ds)
 		ptp_clock_unregister(ptp_data->clock);
 }
 
+static irqreturn_t ksz_ptp_msg_thread_fn(int irq, void *dev_id)
+{
+	return IRQ_NONE;
+}
+
+static irqreturn_t ksz_ptp_irq_thread_fn(int irq, void *dev_id)
+{
+	struct ksz_irq *ptpirq = dev_id;
+	unsigned int nhandled = 0;
+	struct ksz_device *dev;
+	unsigned int sub_irq;
+	u16 data;
+	int ret;
+	u8 n;
+
+	dev = ptpirq->dev;
+
+	ret = ksz_read16(dev, ptpirq->reg_status, &data);
+	if (ret)
+		goto out;
+
+	/* Clear the interrupts W1C */
+	ret = ksz_write16(dev, ptpirq->reg_status, data);
+	if (ret)
+		return IRQ_NONE;
+
+	for (n = 0; n < ptpirq->nirqs; ++n) {
+		if (data & BIT(n + KSZ_PTP_INT_START)) {
+			sub_irq = irq_find_mapping(ptpirq->domain, n);
+			handle_nested_irq(sub_irq);
+			++nhandled;
+		}
+	}
+
+out:
+	return (nhandled > 0 ? IRQ_HANDLED : IRQ_NONE);
+}
+
+static void ksz_ptp_irq_mask(struct irq_data *d)
+{
+	struct ksz_irq *kirq = irq_data_get_irq_chip_data(d);
+
+	kirq->masked &= ~BIT(d->hwirq + KSZ_PTP_INT_START);
+}
+
+static void ksz_ptp_irq_unmask(struct irq_data *d)
+{
+	struct ksz_irq *kirq = irq_data_get_irq_chip_data(d);
+
+	kirq->masked |= BIT(d->hwirq + KSZ_PTP_INT_START);
+}
+
+static void ksz_ptp_irq_bus_lock(struct irq_data *d)
+{
+	struct ksz_irq *kirq  = irq_data_get_irq_chip_data(d);
+
+	mutex_lock(&kirq->dev->lock_irq);
+}
+
+static void ksz_ptp_irq_bus_sync_unlock(struct irq_data *d)
+{
+	struct ksz_irq *kirq  = irq_data_get_irq_chip_data(d);
+	struct ksz_device *dev = kirq->dev;
+	int ret;
+
+	ret = ksz_write16(dev, kirq->reg_mask, kirq->masked);
+	if (ret)
+		dev_err(dev->dev, "failed to change IRQ mask\n");
+
+	mutex_unlock(&dev->lock_irq);
+}
+
+static const struct irq_chip ksz_ptp_irq_chip = {
+	.name			= "ksz-irq",
+	.irq_mask		= ksz_ptp_irq_mask,
+	.irq_unmask		= ksz_ptp_irq_unmask,
+	.irq_bus_lock		= ksz_ptp_irq_bus_lock,
+	.irq_bus_sync_unlock	= ksz_ptp_irq_bus_sync_unlock,
+};
+
+static int ksz_ptp_irq_domain_map(struct irq_domain *d,
+				  unsigned int irq, irq_hw_number_t hwirq)
+{
+	irq_set_chip_data(irq, d->host_data);
+	irq_set_chip_and_handler(irq, &ksz_ptp_irq_chip, handle_level_irq);
+	irq_set_noprobe(irq);
+
+	return 0;
+}
+
+static const struct irq_domain_ops ksz_ptp_irq_domain_ops = {
+	.map	= ksz_ptp_irq_domain_map,
+	.xlate	= irq_domain_xlate_twocell,
+};
+
+static void ksz_ptp_msg_irq_free(struct ksz_port *port, u8 n)
+{
+	struct ksz_ptp_irq *ptpmsg_irq;
+
+	ptpmsg_irq = &port->ptpmsg_irq[n];
+
+	free_irq(ptpmsg_irq->num, ptpmsg_irq);
+	irq_dispose_mapping(ptpmsg_irq->num);
+}
+
+static int ksz_ptp_msg_irq_setup(struct ksz_port *port, u8 n)
+{
+	u16 ts_reg[] = {REG_PTP_PORT_PDRESP_TS, REG_PTP_PORT_XDELAY_TS,
+			REG_PTP_PORT_SYNC_TS};
+	static const char * const name[] = {"pdresp-msg", "xdreq-msg",
+					    "sync-msg"};
+	const struct ksz_dev_ops *ops = port->ksz_dev->dev_ops;
+	struct ksz_ptp_irq *ptpmsg_irq;
+
+	ptpmsg_irq = &port->ptpmsg_irq[n];
+
+	ptpmsg_irq->port = port;
+	ptpmsg_irq->ts_reg = ops->get_port_addr(port->num, ts_reg[n]);
+
+	snprintf(ptpmsg_irq->name, sizeof(ptpmsg_irq->name), name[n]);
+
+	ptpmsg_irq->num = irq_find_mapping(port->ptpirq.domain, n);
+	if (ptpmsg_irq->num < 0)
+		return ptpmsg_irq->num;
+
+	return request_threaded_irq(ptpmsg_irq->num, NULL,
+				    ksz_ptp_msg_thread_fn, IRQF_ONESHOT,
+				    ptpmsg_irq->name, ptpmsg_irq);
+}
+
+int ksz_ptp_irq_setup(struct dsa_switch *ds, u8 p)
+{
+	struct ksz_device *dev = ds->priv;
+	const struct ksz_dev_ops *ops = dev->dev_ops;
+	struct ksz_port *port = &dev->ports[p];
+	struct ksz_irq *ptpirq = &port->ptpirq;
+	int irq;
+	int ret;
+
+	ptpirq->dev = dev;
+	ptpirq->masked = 0;
+	ptpirq->nirqs = 3;
+	ptpirq->reg_mask = ops->get_port_addr(p, REG_PTP_PORT_TX_INT_ENABLE__2);
+	ptpirq->reg_status = ops->get_port_addr(p,
+						REG_PTP_PORT_TX_INT_STATUS__2);
+	snprintf(ptpirq->name, sizeof(ptpirq->name), "ptp-irq-%d", p);
+
+	ptpirq->domain = irq_domain_add_linear(dev->dev->of_node, ptpirq->nirqs,
+					       &ksz_ptp_irq_domain_ops, ptpirq);
+	if (!ptpirq->domain)
+		return -ENOMEM;
+
+	for (irq = 0; irq < ptpirq->nirqs; irq++)
+		irq_create_mapping(ptpirq->domain, irq);
+
+	ptpirq->irq_num = irq_find_mapping(port->pirq.domain, PORT_SRC_PTP_INT);
+	if (ptpirq->irq_num < 0) {
+		ret = ptpirq->irq_num;
+		goto out;
+	}
+
+	ret = request_threaded_irq(ptpirq->irq_num, NULL, ksz_ptp_irq_thread_fn,
+				   IRQF_ONESHOT, ptpirq->name, ptpirq);
+	if (ret)
+		goto out;
+
+	for (irq = 0; irq < ptpirq->nirqs; irq++) {
+		ret = ksz_ptp_msg_irq_setup(port, irq);
+		if (ret)
+			goto out_ptp_msg;
+	}
+
+	return 0;
+
+out_ptp_msg:
+	free_irq(ptpirq->irq_num, ptpirq);
+	while (irq--)
+		free_irq(port->ptpmsg_irq[irq].num, &port->ptpmsg_irq[irq]);
+out:
+	for (irq = 0; irq < ptpirq->nirqs; irq++)
+		irq_dispose_mapping(port->ptpmsg_irq[irq].num);
+
+	irq_domain_remove(ptpirq->domain);
+
+	return ret;
+}
+
+void ksz_ptp_irq_free(struct dsa_switch *ds, u8 p)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz_port *port = &dev->ports[p];
+	struct ksz_irq *ptpirq = &port->ptpirq;
+	u8 n;
+
+	for (n = 0; n < ptpirq->nirqs; n++)
+		ksz_ptp_msg_irq_free(port, n);
+
+	free_irq(ptpirq->irq_num, ptpirq);
+	irq_dispose_mapping(ptpirq->irq_num);
+
+	irq_domain_remove(ptpirq->domain);
+}
+
 MODULE_AUTHOR("Christian Eggers <ceggers@arri.de>");
 MODULE_AUTHOR("Arun Ramadoss <arun.ramadoss@microchip.com>");
 MODULE_DESCRIPTION("PTP support for KSZ switch");
diff --git a/drivers/net/dsa/microchip/ksz_ptp.h b/drivers/net/dsa/microchip/ksz_ptp.h
index 2c29a0b604bb..7c5679372705 100644
--- a/drivers/net/dsa/microchip/ksz_ptp.h
+++ b/drivers/net/dsa/microchip/ksz_ptp.h
@@ -30,6 +30,8 @@ int ksz_get_ts_info(struct dsa_switch *ds, int port,
 		    struct ethtool_ts_info *ts);
 int ksz_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr);
 int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr);
+int ksz_ptp_irq_setup(struct dsa_switch *ds, u8 p);
+void ksz_ptp_irq_free(struct dsa_switch *ds, u8 p);
 
 #else
 
@@ -45,6 +47,13 @@ static inline int ksz_ptp_clock_register(struct dsa_switch *ds)
 
 static inline void ksz_ptp_clock_unregister(struct dsa_switch *ds) { }
 
+static inline int ksz_ptp_irq_setup(struct dsa_switch *ds, u8 p)
+{
+	return 0;
+}
+
+static inline void ksz_ptp_irq_free(struct dsa_switch *ds, u8 p) {}
+
 #define ksz_get_ts_info NULL
 
 #define ksz_hwtstamp_get NULL
diff --git a/drivers/net/dsa/microchip/ksz_ptp_reg.h b/drivers/net/dsa/microchip/ksz_ptp_reg.h
index 4ca4ad4bba7e..abe95bbefc12 100644
--- a/drivers/net/dsa/microchip/ksz_ptp_reg.h
+++ b/drivers/net/dsa/microchip/ksz_ptp_reg.h
@@ -49,4 +49,23 @@
 #define PTP_MASTER			BIT(1)
 #define PTP_1STEP			BIT(0)
 
+/* Port PTP Register */
+#define REG_PTP_PORT_RX_DELAY__2	0x0C00
+#define REG_PTP_PORT_TX_DELAY__2	0x0C02
+#define REG_PTP_PORT_ASYM_DELAY__2	0x0C04
+
+#define REG_PTP_PORT_XDELAY_TS		0x0C08
+#define REG_PTP_PORT_SYNC_TS		0x0C0C
+#define REG_PTP_PORT_PDRESP_TS		0x0C10
+
+#define REG_PTP_PORT_TX_INT_STATUS__2	0x0C14
+#define REG_PTP_PORT_TX_INT_ENABLE__2	0x0C16
+
+#define PTP_PORT_SYNC_INT		BIT(15)
+#define PTP_PORT_XDELAY_REQ_INT		BIT(14)
+#define PTP_PORT_PDELAY_RESP_INT	BIT(13)
+#define KSZ_SYNC_MSG			2
+#define KSZ_XDREQ_MSG			1
+#define KSZ_PDRES_MSG			0
+
 #endif
-- 
2.36.1

