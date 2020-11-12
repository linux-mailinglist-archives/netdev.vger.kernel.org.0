Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1147A2B08E2
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728570AbgKLPuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:50:16 -0500
Received: from mailout08.rmx.de ([94.199.90.85]:58490 "EHLO mailout08.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728032AbgKLPuP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 10:50:15 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout08.rmx.de (Postfix) with ESMTPS id 4CX5dq0FkYzMscZ;
        Thu, 12 Nov 2020 16:50:07 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CX5cG0Ng8z2xDT;
        Thu, 12 Nov 2020 16:48:46 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.59) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 12 Nov
 2020 16:40:56 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        "Rob Herring" <robh+dt@kernel.org>
CC:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Christian Eggers <ceggers@arri.de>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v2 09/11] net: dsa: microchip: ksz9477: add hardware time stamping support
Date:   Thu, 12 Nov 2020 16:35:35 +0100
Message-ID: <20201112153537.22383-10-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201112153537.22383-1-ceggers@arri.de>
References: <20201112153537.22383-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.59]
X-RMX-ID: 20201112-164846-4CX5cG0Ng8z2xDT-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add routines required for TX hardware time stamping.

The KSZ9563 only supports one step time stamping
(HWTSTAMP_TX_ONESTEP_P2P), which requires linuxptp-2.0 or later. PTP
mode is permanently enabled (changes tail tag; depends on
CONFIG_NET_DSA_MICROCHIP_KSZ9477_PTP).TX time stamps are reported via an
interrupt / device registers whilst RX time stamps are reported via an
additional tail tag.

Currently, only P2P delay measurement is supported. See patchwork
discussion and comments in ksz9477_ptp_init() for details:
https://patchwork.ozlabs.org/project/netdev/patch/20201019172435.4416-8-ceggers@arri.de/

One step TX time stamping of PDelay_Resp requires the RX time stamp from
the associated PDelay_Req message. linuxptp assumes that the RX time
stamp has already been subtracted from the PDelay_Req correction field
(as done by the TI PHYTER). linuxptp will echo back the value of the
correction field in the PDelay_Resp message.

In order to be compatible to this already established interface, the
KSZ9563 code emulates this behavior. When processing the PDelay_Resp
message, the time stamp is moved back from the correction field to the
tail tag, as the hardware doesn't support negative values on this field.
Of course, the UDP checksums (if any) have to be corrected after this
(for both directions).

Everything has been tested on a Microchip KSZ9563 switch.

Signed-off-by: Christian Eggers <ceggers@arri.de>
---
 drivers/net/dsa/microchip/ksz9477_main.c |   9 +-
 drivers/net/dsa/microchip/ksz9477_ptp.c  | 544 +++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz9477_ptp.h  |  27 ++
 include/linux/dsa/ksz_common.h           |  47 ++
 net/dsa/tag_ksz.c                        | 121 ++++-
 5 files changed, 740 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477_main.c b/drivers/net/dsa/microchip/ksz9477_main.c
index 7d623400139f..42cd17c8c25d 100644
--- a/drivers/net/dsa/microchip/ksz9477_main.c
+++ b/drivers/net/dsa/microchip/ksz9477_main.c
@@ -1388,6 +1388,7 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.phy_read		= ksz9477_phy_read16,
 	.phy_write		= ksz9477_phy_write16,
 	.phylink_mac_link_down	= ksz_mac_link_down,
+	.get_ts_info		= ksz9477_ptp_get_ts_info,
 	.port_enable		= ksz_enable_port,
 	.get_strings		= ksz9477_get_strings,
 	.get_ethtool_stats	= ksz_get_ethtool_stats,
@@ -1408,6 +1409,11 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.port_mdb_del           = ksz9477_port_mdb_del,
 	.port_mirror_add	= ksz9477_port_mirror_add,
 	.port_mirror_del	= ksz9477_port_mirror_del,
+	.port_hwtstamp_get      = ksz9477_ptp_port_hwtstamp_get,
+	.port_hwtstamp_set      = ksz9477_ptp_port_hwtstamp_set,
+	.port_txtstamp          = ksz9477_ptp_port_txtstamp,
+	/* never defer rx delivery, tstamping is done via tail tagging */
+	.port_rxtstamp          = NULL,
 };
 
 static u32 ksz9477_get_port_addr(int port, int offset)
@@ -1554,7 +1560,8 @@ static irqreturn_t ksz9477_switch_irq_thread(int irq, void *dev_id)
 			if (ret)
 				return result;
 
-			/* ToDo: Add specific handling of port interrupts */
+			if (data8 & PORT_PTP_INT)
+				result |= ksz9477_ptp_port_interrupt(dev, port);
 		}
 	}
 
diff --git a/drivers/net/dsa/microchip/ksz9477_ptp.c b/drivers/net/dsa/microchip/ksz9477_ptp.c
index 44d7bbdea518..12698568b68b 100644
--- a/drivers/net/dsa/microchip/ksz9477_ptp.c
+++ b/drivers/net/dsa/microchip/ksz9477_ptp.c
@@ -6,7 +6,10 @@
  * Copyright (c) 2020 ARRI Lighting
  */
 
+#include <linux/net_tstamp.h>
+#include <linux/ptp_classify.h>
 #include <linux/ptp_clock_kernel.h>
+#include <linux/sysfs.h>
 
 #include "ksz_common.h"
 #include "ksz9477_reg.h"
@@ -71,8 +74,10 @@ static int ksz9477_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 static int ksz9477_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 {
 	struct ksz_device *dev = container_of(ptp, struct ksz_device, ptp_caps);
+	struct timespec64 delta64 = ns_to_timespec64(delta);
 	s32 sec, nsec;
 	u16 data16;
+	unsigned long flags;
 	int ret;
 
 	mutex_lock(&dev->ptp_mutex);
@@ -103,6 +108,10 @@ static int ksz9477_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	if (ret)
 		goto error_return;
 
+	spin_lock_irqsave(&dev->ptp_clock_lock, flags);
+	dev->ptp_clock_time = timespec64_add(dev->ptp_clock_time, delta64);
+	spin_unlock_irqrestore(&dev->ptp_clock_lock, flags);
+
 error_return:
 	mutex_unlock(&dev->ptp_mutex);
 	return ret;
@@ -160,6 +169,7 @@ static int ksz9477_ptp_settime(struct ptp_clock_info *ptp, struct timespec64 con
 {
 	struct ksz_device *dev = container_of(ptp, struct ksz_device, ptp_caps);
 	u16 data16;
+	unsigned long flags;
 	int ret;
 
 	mutex_lock(&dev->ptp_mutex);
@@ -198,6 +208,10 @@ static int ksz9477_ptp_settime(struct ptp_clock_info *ptp, struct timespec64 con
 	if (ret)
 		goto error_return;
 
+	spin_lock_irqsave(&dev->ptp_clock_lock, flags);
+	dev->ptp_clock_time = *ts;
+	spin_unlock_irqrestore(&dev->ptp_clock_lock, flags);
+
 error_return:
 	mutex_unlock(&dev->ptp_mutex);
 	return ret;
@@ -208,9 +222,27 @@ static int ksz9477_ptp_enable(struct ptp_clock_info *ptp, struct ptp_clock_reque
 	return -ENOTTY;
 }
 
+static long ksz9477_ptp_do_aux_work(struct ptp_clock_info *ptp)
+{
+	struct ksz_device *dev = container_of(ptp, struct ksz_device, ptp_caps);
+	struct timespec64 ts;
+	unsigned long flags;
+
+	mutex_lock(&dev->ptp_mutex);
+	_ksz9477_ptp_gettime(dev, &ts);
+	mutex_unlock(&dev->ptp_mutex);
+
+	spin_lock_irqsave(&dev->ptp_clock_lock, flags);
+	dev->ptp_clock_time = ts;
+	spin_unlock_irqrestore(&dev->ptp_clock_lock, flags);
+
+	return HZ;  /* reschedule in 1 second */
+}
+
 static int ksz9477_ptp_start_clock(struct ksz_device *dev)
 {
 	u16 data;
+	unsigned long flags;
 	int ret;
 
 	ret = ksz_read16(dev, REG_PTP_CLK_CTRL, &data);
@@ -230,6 +262,11 @@ static int ksz9477_ptp_start_clock(struct ksz_device *dev)
 	if (ret)
 		return ret;
 
+	spin_lock_irqsave(&dev->ptp_clock_lock, flags);
+	dev->ptp_clock_time.tv_sec = 0;
+	dev->ptp_clock_time.tv_nsec = 0;
+	spin_unlock_irqrestore(&dev->ptp_clock_lock, flags);
+
 	return 0;
 }
 
@@ -251,11 +288,249 @@ static int ksz9477_ptp_stop_clock(struct ksz_device *dev)
 	return 0;
 }
 
+/* Time stamping support */
+
+static int ksz9477_ptp_enable_mode(struct ksz_device *dev)
+{
+	u16 data;
+	int ret;
+
+	ret = ksz_read16(dev, REG_PTP_MSG_CONF1, &data);
+	if (ret)
+		return ret;
+
+	/* Enable PTP mode */
+	data |= PTP_ENABLE;
+	ret = ksz_write16(dev, REG_PTP_MSG_CONF1, data);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int ksz9477_ptp_disable_mode(struct ksz_device *dev)
+{
+	u16 data;
+	int ret;
+
+	ret = ksz_read16(dev, REG_PTP_MSG_CONF1, &data);
+	if (ret)
+		return ret;
+
+	/* Disable PTP mode */
+	data &= ~PTP_ENABLE;
+	ret = ksz_write16(dev, REG_PTP_MSG_CONF1, data);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int ksz9477_ptp_enable_port_ptp_interrupts(struct ksz_device *dev, int port)
+{
+	u32 addr = PORT_CTRL_ADDR(port, REG_PORT_INT_MASK);
+	u8 data;
+	int ret;
+
+	ret = ksz_read8(dev, addr, &data);
+	if (ret)
+		return ret;
+
+	/* Enable port PTP interrupt (0 means enabled) */
+	data &= ~PORT_PTP_INT;
+	ret = ksz_write8(dev, addr, data);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int ksz9477_ptp_disable_port_ptp_interrupts(struct ksz_device *dev, int port)
+{
+	u32 addr = PORT_CTRL_ADDR(port, REG_PORT_INT_MASK);
+	u8 data;
+	int ret;
+
+	ret = ksz_read8(dev, addr, &data);
+	if (ret)
+		return ret;
+
+	/* Enable port PTP interrupt (1 means disabled) */
+	data |= PORT_PTP_INT;
+	ret = ksz_write8(dev, addr, data);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int ksz9477_ptp_enable_port_egress_interrupts(struct ksz_device *dev, int port)
+{
+	u32 addr = PORT_CTRL_ADDR(port, REG_PTP_PORT_TX_INT_ENABLE__2);
+	u16 data;
+	int ret;
+
+	ret = ksz_read16(dev, addr, &data);
+	if (ret)
+		return ret;
+
+	/* Enable port xdelay egress timestamp interrupt (1 means enabled) */
+	data |= PTP_PORT_XDELAY_REQ_INT;
+	ret = ksz_write16(dev, addr, data);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int ksz9477_ptp_disable_port_egress_interrupts(struct ksz_device *dev, int port)
+{
+	u32 addr = PORT_CTRL_ADDR(port, REG_PTP_PORT_TX_INT_ENABLE__2);
+	u16 data;
+	int ret;
+
+	ret = ksz_read16(dev, addr, &data);
+	if (ret)
+		return ret;
+
+	/* Disable port xdelay egress timestamp interrupts (0 means disabled) */
+	data &= PTP_PORT_XDELAY_REQ_INT;
+	ret = ksz_write16(dev, addr, data);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int ksz9477_ptp_port_init(struct ksz_device *dev, int port)
+{
+	struct ksz_port *prt = &dev->ports[port];
+	int ret;
+
+	/* Read rx and tx delay from port registers */
+	ret = ksz_read16(dev, PORT_CTRL_ADDR(port, REG_PTP_PORT_RX_DELAY__2),
+			 &prt->tstamp_rx_latency_ns);
+	if (ret)
+		return ret;
+
+	ret = ksz_read16(dev, PORT_CTRL_ADDR(port, REG_PTP_PORT_TX_DELAY__2),
+			 &prt->tstamp_tx_latency_ns);
+	if (ret)
+		return ret;
+
+	if (port != dev->cpu_port) {
+		ret = ksz9477_ptp_enable_port_ptp_interrupts(dev, port);
+		if (ret)
+			return ret;
+
+		ret = ksz9477_ptp_enable_port_egress_interrupts(dev, port);
+		if (ret)
+			goto error_disable_port_ptp_interrupts;
+	}
+
+	return 0;
+
+error_disable_port_ptp_interrupts:
+	if (port != dev->cpu_port)
+		ksz9477_ptp_disable_port_ptp_interrupts(dev, port);
+	return ret;
+}
+
+static void ksz9477_ptp_port_deinit(struct ksz_device *dev, int port)
+{
+	if (port != dev->cpu_port) {
+		ksz9477_ptp_disable_port_egress_interrupts(dev, port);
+		ksz9477_ptp_disable_port_ptp_interrupts(dev, port);
+	}
+}
+
+static int ksz9477_ptp_ports_init(struct ksz_device *dev)
+{
+	int port;
+	int ret;
+
+	for (port = 0; port < dev->port_cnt; port++) {
+		ret = ksz9477_ptp_port_init(dev, port);
+		if (ret)
+			goto error_deinit;
+	}
+
+	return 0;
+
+error_deinit:
+	for (--port; port >= 0; --port)
+		ksz9477_ptp_port_deinit(dev, port);
+	return ret;
+}
+
+static void ksz9477_ptp_ports_deinit(struct ksz_device *dev)
+{
+	int port;
+
+	for (port = dev->port_cnt - 1; port >= 0; --port)
+		ksz9477_ptp_port_deinit(dev, port);
+}
+
+/* device attributes */
+
+enum ksz9477_ptp_tcmode {
+	KSZ9477_PTP_TCMODE_E2E,
+	KSZ9477_PTP_TCMODE_P2P,
+};
+
+static int ksz9477_ptp_tcmode_set(struct ksz_device *dev, enum ksz9477_ptp_tcmode tcmode)
+{
+	u16 data;
+	int ret;
+
+	ret = ksz_read16(dev, REG_PTP_MSG_CONF1, &data);
+	if (ret)
+		return ret;
+
+	if (tcmode == KSZ9477_PTP_TCMODE_P2P)
+		data |= PTP_TC_P2P;
+	else
+		data &= ~PTP_TC_P2P;
+
+	ret = ksz_write16(dev, REG_PTP_MSG_CONF1, data);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+enum ksz9477_ptp_ocmode {
+	KSZ9477_PTP_OCMODE_SLAVE,
+	KSZ9477_PTP_OCMODE_MASTER,
+};
+
+static int ksz9477_ptp_ocmode_set(struct ksz_device *dev, enum ksz9477_ptp_ocmode ocmode)
+{
+	u16 data;
+	int ret;
+
+	ret = ksz_read16(dev, REG_PTP_MSG_CONF1, &data);
+	if (ret)
+		return ret;
+
+	if (ocmode == KSZ9477_PTP_OCMODE_MASTER)
+		data |= PTP_MASTER;
+	else
+		data &= ~PTP_MASTER;
+
+	ret = ksz_write16(dev, REG_PTP_MSG_CONF1, data);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 int ksz9477_ptp_init(struct ksz_device *dev)
 {
 	int ret;
 
 	mutex_init(&dev->ptp_mutex);
+	spin_lock_init(&dev->ptp_clock_lock);
 
 	/* PTP clock properties */
 
@@ -275,6 +550,7 @@ int ksz9477_ptp_init(struct ksz_device *dev)
 	dev->ptp_caps.gettime64   = ksz9477_ptp_gettime;
 	dev->ptp_caps.settime64   = ksz9477_ptp_settime;
 	dev->ptp_caps.enable      = ksz9477_ptp_enable;
+	dev->ptp_caps.do_aux_work = ksz9477_ptp_do_aux_work;
 
 	/* Start hardware counter (will overflow after 136 years) */
 	ret = ksz9477_ptp_start_clock(dev);
@@ -287,8 +563,44 @@ int ksz9477_ptp_init(struct ksz_device *dev)
 		goto error_stop_clock;
 	}
 
+	/* Enable PTP mode (will affect tail tagging format) */
+	ret = ksz9477_ptp_enable_mode(dev);
+	if (ret)
+		goto error_unregister_clock;
+
+	/* Init switch ports */
+	ret = ksz9477_ptp_ports_init(dev);
+	if (ret)
+		goto error_disable_mode;
+
+	/* Currently, only P2P delay measurement is supported.  Setting ocmode to
+	 * slave will work independently of actually being master or slave.
+	 * For E2E delay measurement, switching between master and slave would
+	 * be required, as the KSZ devices filters out PTP messages depending on
+	 * the ocmode setting:
+	 * - in slave mode, DelayReq messages are filtered out
+	 * - in master mode, Sync messages are filtered out
+	 * Currently (and probably also in future) there is no interface in the
+	 * kernel which allows switching between master and slave mode.  For this
+	 * reason, E2E cannot be supported. See patchwork for full discussion:
+	 * https://patchwork.ozlabs.org/project/netdev/patch/20201019172435.4416-8-ceggers@arri.de/
+	 */
+	ksz9477_ptp_tcmode_set(dev, KSZ9477_PTP_TCMODE_P2P);
+	ksz9477_ptp_ocmode_set(dev, KSZ9477_PTP_OCMODE_SLAVE);
+
+	/* Schedule cyclic call of ksz_ptp_do_aux_work() */
+	ret = ptp_schedule_worker(dev->ptp_clock, 0);
+	if (ret)
+		goto error_ports_deinit;
+
 	return 0;
 
+error_ports_deinit:
+	ksz9477_ptp_ports_deinit(dev);
+error_disable_mode:
+	ksz9477_ptp_disable_mode(dev);
+error_unregister_clock:
+	ptp_clock_unregister(dev->ptp_clock);
 error_stop_clock:
 	ksz9477_ptp_stop_clock(dev);
 	return ret;
@@ -296,6 +608,238 @@ int ksz9477_ptp_init(struct ksz_device *dev)
 
 void ksz9477_ptp_deinit(struct ksz_device *dev)
 {
+	ksz9477_ptp_ports_deinit(dev);
+	ksz9477_ptp_disable_mode(dev);
 	ptp_clock_unregister(dev->ptp_clock);
 	ksz9477_ptp_stop_clock(dev);
 }
+
+irqreturn_t ksz9477_ptp_port_interrupt(struct ksz_device *dev, int port)
+{
+	u32 addr = PORT_CTRL_ADDR(port, REG_PTP_PORT_TX_INT_STATUS__2);
+	struct ksz_port *prt = &dev->ports[port];
+	irqreturn_t result = IRQ_NONE;
+	u16 data;
+	int ret;
+
+	ret = ksz_read16(dev, addr, &data);
+	if (ret)
+		return IRQ_NONE;
+
+	if ((data & PTP_PORT_XDELAY_REQ_INT) && prt->tstamp_tx_xdelay_skb) {
+		/* Timestamp for Pdelay_Req / Delay_Req */
+		u32 tstamp_raw;
+		ktime_t tstamp;
+		struct skb_shared_hwtstamps shhwtstamps;
+		struct sk_buff *tmp_skb;
+
+		/* In contrast to the KSZ9563R data sheet, the format of the
+		 * port time stamp registers is also 2 bit seconds + 30 bit
+		 * nanoseconds (same as in the tail tags).
+		 */
+		ret = ksz_read32(dev, PORT_CTRL_ADDR(port, REG_PTP_PORT_XDELAY_TS), &tstamp_raw);
+		if (ret)
+			return result;
+
+		tstamp = ksz9477_decode_tstamp(tstamp_raw, prt->tstamp_tx_latency_ns);
+		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
+		shhwtstamps.hwtstamp = ksz9477_tstamp_to_clock(dev, tstamp);
+
+		/* skb_complete_tx_timestamp() will free up the client to make
+		 * another timestamp-able transmit. We have to be ready for it
+		 * -- by clearing the ps->tx_skb "flag" -- beforehand.
+		 */
+
+		tmp_skb = prt->tstamp_tx_xdelay_skb;
+		prt->tstamp_tx_xdelay_skb = NULL;
+		clear_bit_unlock(KSZ_HWTSTAMP_TX_XDELAY_IN_PROGRESS, &prt->tstamp_state);
+		skb_complete_tx_timestamp(tmp_skb, &shhwtstamps);
+	}
+
+	/* Clear interrupt(s) (W1C) */
+	ret = ksz_write16(dev, addr, data);
+	if (ret)
+		return IRQ_NONE;
+
+	return IRQ_HANDLED;
+}
+
+/* DSA PTP operations */
+
+int ksz9477_ptp_get_ts_info(struct dsa_switch *ds, int port __always_unused,
+			    struct ethtool_ts_info *ts)
+{
+	struct ksz_device *dev = ds->priv;
+
+	ts->so_timestamping =
+			SOF_TIMESTAMPING_TX_HARDWARE |
+			SOF_TIMESTAMPING_RX_HARDWARE |
+			SOF_TIMESTAMPING_RAW_HARDWARE;
+
+	ts->phc_index = ptp_clock_index(dev->ptp_clock);
+
+	ts->tx_types =
+			BIT(HWTSTAMP_TX_OFF) |
+			BIT(HWTSTAMP_TX_ONESTEP_P2P);
+
+	ts->rx_filters =
+			BIT(HWTSTAMP_FILTER_NONE) |
+			BIT(HWTSTAMP_FILTER_PTP_V2_L4_EVENT) |
+			BIT(HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
+			BIT(HWTSTAMP_FILTER_PTP_V2_EVENT);
+
+	return 0;
+}
+
+static int ksz9477_set_hwtstamp_config(struct ksz_device *dev, int port,
+				       struct hwtstamp_config *config)
+{
+	struct ksz_port *prt = &dev->ports[port];
+	bool tstamp_enable = false;
+
+	/* Prevent the TX/RX paths from trying to interact with the
+	 * timestamp hardware while we reconfigure it.
+	 */
+	clear_bit_unlock(KSZ_HWTSTAMP_ENABLED, &prt->tstamp_state);
+
+	/* reserved for future extensions */
+	if (config->flags)
+		return -EINVAL;
+
+	switch (config->tx_type) {
+	case HWTSTAMP_TX_OFF:
+		tstamp_enable = false;
+		break;
+	case HWTSTAMP_TX_ONESTEP_P2P:
+		tstamp_enable = true;
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	switch (config->rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		tstamp_enable = false;
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
+		config->rx_filter = HWTSTAMP_FILTER_PTP_V2_L4_EVENT;  /* UDPv4/UDPv6 */
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
+		config->rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;  /* 802.3 ether */
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
+		config->rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;     /* UDP / 802.3 */
+		break;
+	case HWTSTAMP_FILTER_ALL:
+	default:
+		config->rx_filter = HWTSTAMP_FILTER_NONE;
+		return -ERANGE;
+	}
+
+	/* Once hardware has been configured, enable timestamp checks
+	 * in the RX/TX paths.
+	 */
+	if (tstamp_enable)
+		set_bit(KSZ_HWTSTAMP_ENABLED, &prt->tstamp_state);
+
+	return 0;
+}
+
+int ksz9477_ptp_port_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr)
+{
+	struct ksz_device *dev = ds->priv;
+	struct hwtstamp_config *port_tstamp_config = &dev->ports[port].tstamp_config;
+
+	return copy_to_user(ifr->ifr_data,
+			    port_tstamp_config, sizeof(*port_tstamp_config)) ? -EFAULT : 0;
+}
+
+int ksz9477_ptp_port_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
+{
+	struct ksz_device *dev = ds->priv;
+	struct hwtstamp_config *port_tstamp_config = &dev->ports[port].tstamp_config;
+	struct hwtstamp_config config;
+	int err;
+
+	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
+		return -EFAULT;
+
+	err = ksz9477_set_hwtstamp_config(dev, port, &config);
+	if (err)
+		return err;
+
+	/* Save the chosen configuration to be returned later. */
+	memcpy(port_tstamp_config, &config, sizeof(config));
+
+	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ? -EFAULT : 0;
+}
+
+/* Returns a pointer to the PTP header if the caller should time stamp,
+ * or NULL if the caller should not.
+ */
+static struct ptp_header *ksz9477_ptp_should_tstamp(struct ksz_port *port, struct sk_buff *skb,
+						    unsigned int type)
+{
+	enum ksz9477_ptp_event_messages msg_type;
+	struct ptp_header *hdr;
+
+	if (!test_bit(KSZ_HWTSTAMP_ENABLED, &port->tstamp_state))
+		return NULL;
+
+	hdr = ptp_parse_header(skb, type);
+	if (!hdr)
+		return NULL;
+
+	msg_type = ptp_get_msgtype(hdr, type);
+
+	switch (msg_type) {
+	/* As the KSZ9563 always performs one step time stamping, only the time
+	 * stamp for Pdelay_Req is reported to the application via socket error
+	 * queue.  Time stamps for Sync and Pdelay_resp will be applied directly
+	 * to the outgoing message (e.g. correction field), but will NOT be
+	 * reported to the socket.
+	 * Delay_Req is not time stamped as E2E is currently not supported by
+	 * this driver.  See ksz9477_ptp_init() for details.
+	 */
+	case PTP_Event_Message_Pdelay_Req:
+		break;
+	default:
+		return NULL;
+	}
+
+	return hdr;
+}
+
+bool ksz9477_ptp_port_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *clone,
+			       unsigned int type)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz_port *prt = &dev->ports[port];
+	struct ptp_header *hdr;
+
+	/* KSZ9563 supports PTPv2 only */
+	if (!(type & PTP_CLASS_V2))
+		return false;
+
+	/* Should already been tested in dsa_skb_tx_timestamp()? */
+	if (!(skb_shinfo(clone)->tx_flags & SKBTX_HW_TSTAMP))
+		return false;
+
+	hdr = ksz9477_ptp_should_tstamp(prt, clone, type);
+	if (!hdr)
+		return false;
+
+	if (test_and_set_bit_lock(KSZ_HWTSTAMP_TX_XDELAY_IN_PROGRESS,
+				  &prt->tstamp_state))
+		return false;  /* free cloned skb */
+
+	prt->tstamp_tx_xdelay_skb = clone;
+
+	return true;  /* keep cloned skb */
+}
diff --git a/drivers/net/dsa/microchip/ksz9477_ptp.h b/drivers/net/dsa/microchip/ksz9477_ptp.h
index 0076538419fa..e8d50a086311 100644
--- a/drivers/net/dsa/microchip/ksz9477_ptp.h
+++ b/drivers/net/dsa/microchip/ksz9477_ptp.h
@@ -10,6 +10,9 @@
 #ifndef DRIVERS_NET_DSA_MICROCHIP_KSZ9477_PTP_H_
 #define DRIVERS_NET_DSA_MICROCHIP_KSZ9477_PTP_H_
 
+#include <linux/irqreturn.h>
+#include <linux/types.h>
+
 #include "ksz_common.h"
 
 #if IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ9477_PTP)
@@ -17,11 +20,35 @@
 int ksz9477_ptp_init(struct ksz_device *dev);
 void ksz9477_ptp_deinit(struct ksz_device *dev);
 
+irqreturn_t ksz9477_ptp_port_interrupt(struct ksz_device *dev, int port);
+
+int ksz9477_ptp_get_ts_info(struct dsa_switch *ds, int port, struct ethtool_ts_info *ts);
+int ksz9477_ptp_port_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr);
+int ksz9477_ptp_port_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr);
+bool ksz9477_ptp_port_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *clone,
+			       unsigned int type);
+
 #else
 
 static inline int ksz9477_ptp_init(struct ksz_device *dev) { return 0; }
 static inline void ksz9477_ptp_deinit(struct ksz_device *dev) {}
 
+static inline irqreturn_t ksz9477_ptp_port_interrupt(struct ksz_device *dev, int port)
+	{ return IRQ_NONE; }
+
+static inline int ksz9477_ptp_get_ts_info(struct dsa_switch *ds, int port,
+					  struct ethtool_ts_info *ts) { return -EOPNOTSUPP; }
+
+static inline int ksz9477_ptp_port_hwtstamp_get(struct dsa_switch *ds, int port,
+						struct ifreq *ifr) { return -EOPNOTSUPP; }
+
+static inline int ksz9477_ptp_port_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
+	{ return -EOPNOTSUPP; }
+
+static inline bool ksz9477_ptp_port_txtstamp(struct dsa_switch *ds, int port,
+					     struct sk_buff *clone, unsigned int type)
+	{ return false; }
+
 #endif
 
 #endif /* DRIVERS_NET_DSA_MICROCHIP_KSZ9477_PTP_H_ */
diff --git a/include/linux/dsa/ksz_common.h b/include/linux/dsa/ksz_common.h
index 4d5b6cc9429a..bfe8873b1636 100644
--- a/include/linux/dsa/ksz_common.h
+++ b/include/linux/dsa/ksz_common.h
@@ -5,16 +5,27 @@
 #ifndef _NET_DSA_KSZ_COMMON_H_
 #define _NET_DSA_KSZ_COMMON_H_
 
+#include <linux/bitfield.h>
+#include <linux/bits.h>
 #include <linux/gpio/consumer.h>
 #include <linux/kernel.h>
+#include <linux/ktime.h>
 #include <linux/mutex.h>
+#include <linux/net_tstamp.h>
 #include <linux/phy.h>
 #include <linux/ptp_clock_kernel.h>
+#include <linux/spinlock.h>
 #include <linux/regmap.h>
 #include <linux/timer.h>
 #include <linux/workqueue.h>
 #include <net/dsa.h>
 
+/* All time stamps from the KSZ consist of 2 bits for seconds and 30 bits for
+ * nanoseconds. This is NOT the same as 32 bits for nanoseconds.
+ */
+#define KSZ_TSTAMP_SEC_MASK  GENMASK(31, 30)
+#define KSZ_TSTAMP_NSEC_MASK GENMASK(29, 0)
+
 struct ksz_platform_data;
 struct ksz_dev_ops;
 struct vlan_table;
@@ -25,6 +36,12 @@ struct ksz_port_mib {
 	u64 *counters;
 };
 
+/* state flags for ksz_port::tstamp_state */
+enum {
+	KSZ_HWTSTAMP_ENABLED,
+	KSZ_HWTSTAMP_TX_XDELAY_IN_PROGRESS,
+};
+
 struct ksz_port {
 	u16 member;
 	u16 vid_member;
@@ -41,6 +58,13 @@ struct ksz_port {
 
 	struct ksz_port_mib mib;
 	phy_interface_t interface;
+#if IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ9477_PTP)
+	u16 tstamp_rx_latency_ns;   /* rx delay from wire to tstamp unit */
+	u16 tstamp_tx_latency_ns;   /* tx delay from tstamp unit to wire */
+	struct hwtstamp_config tstamp_config;
+	struct sk_buff *tstamp_tx_xdelay_skb;
+	unsigned long tstamp_state;
+#endif
 };
 
 struct ksz_device {
@@ -98,7 +122,30 @@ struct ksz_device {
 	struct ptp_clock *ptp_clock;
 	struct ptp_clock_info ptp_caps;
 	struct mutex ptp_mutex;
+	spinlock_t ptp_clock_lock; /* for ptp_clock_time */
+	/* approximated current time, read once per second from hardware */
+	struct timespec64 ptp_clock_time;
 #endif
 };
 
+/* KSZ9563 will only timestamp event messages */
+enum ksz9477_ptp_event_messages {
+	PTP_Event_Message_Sync        = 0x0,
+	PTP_Event_Message_Delay_Req   = 0x1,
+	PTP_Event_Message_Pdelay_Req  = 0x2,
+	PTP_Event_Message_Pdelay_Resp = 0x3,
+};
+
+/* net/dsa/tag_ksz.c */
+static inline ktime_t ksz9477_decode_tstamp(u32 tstamp, int offset_ns)
+{
+	u64 ns = FIELD_GET(KSZ_TSTAMP_SEC_MASK, tstamp) * NSEC_PER_SEC +
+		 FIELD_GET(KSZ_TSTAMP_NSEC_MASK, tstamp);
+
+	/* Add/remove excess delay between wire and time stamp unit */
+	return ns_to_ktime(ns + offset_ns);
+}
+
+ktime_t ksz9477_tstamp_to_clock(struct ksz_device *ksz, ktime_t tstamp);
+
 #endif /* _NET_DSA_KSZ_COMMON_H_ */
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 4820dbcedfa2..c16eb9eae19c 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -4,10 +4,14 @@
  * Copyright (c) 2017 Microchip Technology
  */
 
+#include <asm/unaligned.h>
+#include <linux/dsa/ksz_common.h>
 #include <linux/etherdevice.h>
 #include <linux/list.h>
+#include <linux/ptp_classify.h>
 #include <linux/slab.h>
 #include <net/dsa.h>
+#include <net/checksum.h>
 #include "dsa_priv.h"
 
 /* Typically only one byte is used for tail tag. */
@@ -87,26 +91,125 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ8795);
 /*
  * For Ingress (Host -> KSZ9477), 2 bytes are added before FCS.
  * ---------------------------------------------------------------------------
- * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|tag0(1byte)|tag1(1byte)|FCS(4bytes)
+ * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|ts(4bytes)|tag0(1byte)|tag1(1byte)|FCS(4bytes)
  * ---------------------------------------------------------------------------
+ * ts   : time stamp (only present if PTP is enabled on the hardware).
  * tag0 : Prioritization (not used now)
  * tag1 : each bit represents port (eg, 0x01=port1, 0x02=port2, 0x10=port5)
  *
- * For Egress (KSZ9477 -> Host), 1 byte is added before FCS.
+ * For Egress (KSZ9477 -> Host), 1/4 bytes are added before FCS.
  * ---------------------------------------------------------------------------
- * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|tag0(1byte)|FCS(4bytes)
+ * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|ts(4bytes)|tag0(1byte)|FCS(4bytes)
  * ---------------------------------------------------------------------------
+ * ts   : time stamp (only present of bit 7 in tag0 is set
  * tag0 : zero-based value represents port
  *	  (eg, 0x00=port1, 0x02=port3, 0x06=port7)
  */
 
 #define KSZ9477_INGRESS_TAG_LEN		2
 #define KSZ9477_PTP_TAG_LEN		4
-#define KSZ9477_PTP_TAG_INDICATION	0x80
+#define KSZ9477_PTP_TAG_INDICATION	BIT(7)
 
 #define KSZ9477_TAIL_TAG_OVERRIDE	BIT(9)
 #define KSZ9477_TAIL_TAG_LOOKUP		BIT(10)
 
+#if IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ9477_PTP)
+/* Time stamp tag is only inserted if PTP is enabled in hardware. */
+static void ksz9477_xmit_timestamp(struct sk_buff *skb)
+{
+	/* We send always 0 in the tail tag.  For PDelay_Resp, the ingress
+	 * time stamp of the PDelay_Req message has already been subtracted from
+	 * the correction field on rx.
+	 */
+	put_unaligned_be32(0, skb_put(skb, KSZ9477_PTP_TAG_LEN));
+}
+
+ktime_t ksz9477_tstamp_to_clock(struct ksz_device *ksz, ktime_t tstamp)
+{
+	struct timespec64 ts = ktime_to_timespec64(tstamp);
+	struct timespec64 ptp_clock_time;
+	struct timespec64 diff;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ksz->ptp_clock_lock, flags);
+	ptp_clock_time = ksz->ptp_clock_time;
+	spin_unlock_irqrestore(&ksz->ptp_clock_lock, flags);
+
+	/* calculate full time from partial time stamp */
+	ts.tv_sec = (ptp_clock_time.tv_sec & ~3) | ts.tv_sec;
+
+	/* find nearest possible point in time */
+	diff = timespec64_sub(ts, ptp_clock_time);
+	if (diff.tv_sec > 2)
+		ts.tv_sec -= 4;
+	else if (diff.tv_sec < -2)
+		ts.tv_sec += 4;
+
+	return timespec64_to_ktime(ts);
+}
+EXPORT_SYMBOL(ksz9477_tstamp_to_clock);
+
+static void ksz9477_rcv_timestamp(struct sk_buff *skb, u8 *tag,
+				  struct net_device *dev, unsigned int port)
+{
+	struct skb_shared_hwtstamps *hwtstamps = skb_hwtstamps(skb);
+	u8 *tstamp_raw = tag - KSZ9477_PTP_TAG_LEN;
+	enum ksz9477_ptp_event_messages msg_type;
+	struct dsa_switch *ds = dev->dsa_ptr->ds;
+	struct ksz_device *ksz = ds->priv;
+	struct ksz_port *prt = &ksz->ports[port];
+	struct ptp_header *ptp_hdr;
+	unsigned int ptp_type;
+	ktime_t tstamp;
+
+	/* convert time stamp and write to skb */
+	tstamp = ksz9477_decode_tstamp(get_unaligned_be32(tstamp_raw),
+				       -prt->tstamp_rx_latency_ns);
+	memset(hwtstamps, 0, sizeof(*hwtstamps));
+	hwtstamps->hwtstamp = ksz9477_tstamp_to_clock(ksz, tstamp);
+
+	/* For PDelay_Req messages, user space (ptp4l) expects that the hardware
+	 * subtracts the ingress time stamp from the correction field.  The
+	 * separate hw time stamp from the sk_buff struct will not be used in
+	 * this case.
+	 */
+	if (skb_headroom(skb) < ETH_HLEN)
+		return;
+
+	__skb_push(skb, ETH_HLEN);
+	ptp_type = ptp_classify_raw(skb);
+	__skb_pull(skb, ETH_HLEN);
+
+	if (ptp_type == PTP_CLASS_NONE)
+		return;
+
+	ptp_hdr = ptp_parse_header(skb, ptp_type);
+	if (!ptp_hdr)
+		return;
+
+	msg_type = ptp_get_msgtype(ptp_hdr, ptp_type);
+	if (msg_type != PTP_Event_Message_Pdelay_Req)
+		return;
+
+	/* Only subtract partial time stamp from the correction field.  When the
+	 * hardware adds the egress time stamp to the correction field of the
+	 * PDelay_Resp message on tx, also only the partial time stamp will be
+	 * added.
+	 */
+	ptp_onestep_p2p_move_t2_to_correction(skb, ptp_type, ptp_hdr, tstamp);
+}
+#else   /* IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ9477_PTP) */
+static void ksz9477_xmit_timestamp(struct sk_buff *skb __maybe_unused)
+{
+}
+
+static void ksz9477_rcv_timestamp(struct sk_buff *skb __maybe_unused, u8 *tag __maybe_unused,
+				  struct net_device *dev __maybe_unused,
+				  unsigned int port __maybe_unused)
+{
+}
+#endif  /* IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ9477_PTP) */
+
 static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
@@ -116,6 +219,7 @@ static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 	u16 val;
 
 	/* Tag encoding */
+	ksz9477_xmit_timestamp(skb);
 	tag = skb_put(skb, KSZ9477_INGRESS_TAG_LEN);
 	addr = skb_mac_header(skb);
 
@@ -138,8 +242,10 @@ static struct sk_buff *ksz9477_rcv(struct sk_buff *skb, struct net_device *dev,
 	unsigned int len = KSZ_EGRESS_TAG_LEN;
 
 	/* Extra 4-bytes PTP timestamp */
-	if (tag[0] & KSZ9477_PTP_TAG_INDICATION)
+	if (tag[0] & KSZ9477_PTP_TAG_INDICATION) {
+		ksz9477_rcv_timestamp(skb, tag, dev, port);
 		len += KSZ9477_PTP_TAG_LEN;
+	}
 
 	return ksz_common_rcv(skb, dev, port, len);
 }
@@ -149,7 +255,7 @@ static const struct dsa_device_ops ksz9477_netdev_ops = {
 	.proto	= DSA_TAG_PROTO_KSZ9477,
 	.xmit	= ksz9477_xmit,
 	.rcv	= ksz9477_rcv,
-	.overhead = KSZ9477_INGRESS_TAG_LEN,
+	.overhead = KSZ9477_INGRESS_TAG_LEN + KSZ9477_PTP_TAG_LEN,
 	.tail_tag = true,
 };
 
@@ -167,6 +273,7 @@ static struct sk_buff *ksz9893_xmit(struct sk_buff *skb,
 	u8 *tag;
 
 	/* Tag encoding */
+	ksz9477_xmit_timestamp(skb);
 	tag = skb_put(skb, KSZ_INGRESS_TAG_LEN);
 	addr = skb_mac_header(skb);
 
@@ -183,7 +290,7 @@ static const struct dsa_device_ops ksz9893_netdev_ops = {
 	.proto	= DSA_TAG_PROTO_KSZ9893,
 	.xmit	= ksz9893_xmit,
 	.rcv	= ksz9477_rcv,
-	.overhead = KSZ_INGRESS_TAG_LEN,
+	.overhead = KSZ_INGRESS_TAG_LEN + KSZ9477_PTP_TAG_LEN,
 	.tail_tag = true,
 };
 
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

