Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E24F647E7A
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 08:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbiLIH0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 02:26:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbiLIH0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 02:26:02 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B666396C9;
        Thu,  8 Dec 2022 23:25:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670570759; x=1702106759;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EremW9ZgN0AkLFpAwpJ1kbzKzTTZr12pTSYQ6Es5NtA=;
  b=gE0cWI28iwa7SjtbpRpz+viU3RNDdoy3eimJS803VH1FyK9PWMoUrPGt
   NQ+N5/CPdgGbqt1CB+L/aw0SaG+t5YqIIIRgqpIPYwBg/ou1W8Qt3p7Jo
   4eO0vcx/f005QD9qWO2AAGkYg5iVdz/r+Uaub5dMjvJrWLN4SBgNKFGG+
   ZZ1/HTXEWv/Z3N7dDyE4SvwRR7VI0MNxMTzbpQOfc9V0rIAii4bz3HNk8
   Bd1jMXE3AhCsKEObH0StFMLugnYhUbFb4KwSHizQ1e2PcoM+YIxQtdCh/
   +7VsBWS575yjSk51b8RLjiMZduRC+r7KGuA4slrFdywksSfhaOs2gy2Ju
   g==;
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="192359920"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2022 00:25:58 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 9 Dec 2022 00:25:57 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 9 Dec 2022 00:25:51 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>, <ceggers@arri.de>
Subject: [Patch net-next v3 05/13] net: dsa: microchip: ptp: enable interrupt for timestamping
Date:   Fri, 9 Dec 2022 12:54:29 +0530
Message-ID: <20221209072437.18373-6-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221209072437.18373-1-arun.ramadoss@microchip.com>
References: <20221209072437.18373-1-arun.ramadoss@microchip.com>
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
RFC v2 -> Patch v1
- Moved the acking of interrupts before calling the handle_nested_irq to
  avoid race condition between deferred xmit and Irq threads
---
 drivers/net/dsa/microchip/ksz_common.c  |  15 +-
 drivers/net/dsa/microchip/ksz_common.h  |  11 ++
 drivers/net/dsa/microchip/ksz_ptp.c     | 200 ++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_ptp.h     |   9 ++
 drivers/net/dsa/microchip/ksz_ptp_reg.h |  19 +++
 5 files changed, 252 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 81da650b70fb..1611f8f5cd6c 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -2101,13 +2101,17 @@ static int ksz_setup(struct dsa_switch *ds)
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
@@ -2124,6 +2128,10 @@ static int ksz_setup(struct dsa_switch *ds)
 
 out_ptp_clock_unregister:
 	ksz_ptp_clock_unregister(ds);
+out_ptpirq:
+	if (dev->irq > 0)
+		dsa_switch_for_each_user_port(dp, dev->ds)
+			ksz_ptp_irq_free(ds, dp->index);
 out_pirq:
 	if (dev->irq > 0)
 		dsa_switch_for_each_user_port(dp, dev->ds)
@@ -2143,8 +2151,11 @@ static void ksz_teardown(struct dsa_switch *ds)
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
index 641aca78ef05..918028db2e6f 100644
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
+	int irq_num;
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
index b864b88dc6f9..a7b015ac2734 100644
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
 #define KSZ_PTP_INC_NS 40  /* HW clock is incremented every 40 ns (by 40) */
 #define KSZ_PTP_SUBNS_BITS 32
 
+#define KSZ_PTP_INT_START 13
+
 static int ksz_ptp_enable_mode(struct ksz_device *dev)
 {
 	struct ksz_tagger_data *tagger_data = ksz_tagger_data(dev->ds);
@@ -415,6 +419,202 @@ void ksz_ptp_clock_unregister(struct dsa_switch *ds)
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
+static int ksz_ptp_msg_irq_setup(struct ksz_port *port)
+{
+	u16 ts_reg[] = {REG_PTP_PORT_PDRESP_TS, REG_PTP_PORT_XDELAY_TS,
+			REG_PTP_PORT_SYNC_TS};
+	struct ksz_device *dev = port->ksz_dev;
+	struct ksz_irq *ptpirq = &port->ptpirq;
+	struct ksz_ptp_irq *ptpmsg_irq;
+	int ret;
+	u8 n;
+
+	for (n = 0; n < ptpirq->nirqs; n++) {
+		ptpmsg_irq = &port->ptpmsg_irq[n];
+
+		ptpmsg_irq->port = port;
+		ptpmsg_irq->ts_reg = dev->dev_ops->get_port_addr(port->num,
+								 ts_reg[n]);
+		ptpmsg_irq->irq_num = irq_create_mapping(ptpirq->domain, n);
+		if (ptpmsg_irq->irq_num < 0) {
+			ret = ptpmsg_irq->irq_num;
+			goto out;
+		}
+
+		snprintf(ptpmsg_irq->name, sizeof(ptpmsg_irq->name),
+			 "PTP-MSG-%d", n);
+
+		ret = request_threaded_irq(ptpmsg_irq->irq_num, NULL,
+					   ksz_ptp_msg_thread_fn,
+					   IRQF_ONESHOT | IRQF_TRIGGER_FALLING,
+					   ptpmsg_irq->name, ptpmsg_irq);
+		if (ret)
+			goto out;
+	}
+
+	return 0;
+
+out:
+	while (n--)
+		irq_dispose_mapping(port->ptpmsg_irq[n].irq_num);
+
+	return ret;
+}
+
+int ksz_ptp_irq_setup(struct dsa_switch *ds, u8 p)
+{
+	struct ksz_device *dev = ds->priv;
+	const struct ksz_dev_ops *ops = dev->dev_ops;
+	struct ksz_port *port = &dev->ports[p];
+	struct ksz_irq *ptpirq = &port->ptpirq;
+	int ret;
+
+	ptpirq->dev = dev;
+	ptpirq->masked = 0;
+	ptpirq->nirqs = 3;
+	ptpirq->reg_mask = ops->get_port_addr(p, REG_PTP_PORT_TX_INT_ENABLE__2);
+	ptpirq->reg_status = ops->get_port_addr(p,
+						REG_PTP_PORT_TX_INT_STATUS__2);
+	snprintf(ptpirq->name, sizeof(ptpirq->name), "ptp_irq-%d", p);
+
+	ptpirq->irq_num = irq_find_mapping(port->pirq.domain, PORT_SRC_PTP_INT);
+	if (ptpirq->irq_num < 0)
+		return ptpirq->irq_num;
+
+	ptpirq->domain = irq_domain_add_simple(dev->dev->of_node, ptpirq->nirqs,
+					       0, &ksz_ptp_irq_domain_ops,
+					       ptpirq);
+	if (!ptpirq->domain)
+		return -ENOMEM;
+
+	ret = request_threaded_irq(ptpirq->irq_num, NULL, ksz_ptp_irq_thread_fn,
+				   IRQF_ONESHOT | IRQF_TRIGGER_FALLING,
+				   ptpirq->name, ptpirq);
+	if (ret)
+		goto out;
+
+	ret = ksz_ptp_msg_irq_setup(port);
+	if (ret)
+		goto out;
+
+	return 0;
+
+out:
+	irq_dispose_mapping(ptpirq->irq_num);
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
+	free_irq(ptpirq->irq_num, ptpirq);
+
+	for (n = 0; n < ptpirq->nirqs; n++)
+		irq_dispose_mapping(port->ptpmsg_irq[n].irq_num);
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

