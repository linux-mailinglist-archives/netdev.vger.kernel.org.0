Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E711D292CE9
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 19:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbgJSRf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 13:35:26 -0400
Received: from mailout02.rmx.de ([62.245.148.41]:53287 "EHLO mailout02.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbgJSRf0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 13:35:26 -0400
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout02.rmx.de (Postfix) with ESMTPS id 4CFP685YRyzNrKW;
        Mon, 19 Oct 2020 19:35:12 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CFP4b6F2Sz2xFM;
        Mon, 19 Oct 2020 19:33:51 +0200 (CEST)
Received: from N95HX1G2.wgnetz.xx (192.168.54.91) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Mon, 19 Oct
 2020 19:28:43 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
CC:     Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>,
        Christian Eggers <ceggers@arri.de>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH net-next 7/9] net: dsa: microchip: ksz9477: add hardware time stamping support
Date:   Mon, 19 Oct 2020 19:24:33 +0200
Message-ID: <20201019172435.4416-8-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201019172435.4416-1-ceggers@arri.de>
References: <20201019172435.4416-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.91]
X-RMX-ID: 20201019-193353-4CFP4b6F2Sz2xFM-0@kdin01
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

The PTP hardware performs internal detection of PTP frames (likely
similar as ptp_classify_raw() and ptp_parse_header()). As these filters
cannot be disabled, the current delay mode (E2E/P2P) and the clock mode
(master/slave) must be configured via sysfs attributes. Time stamping
will only be performed on PTP packets matching the current mode
settings.

Everything has been tested on a Microchip KSZ9563 switch.

Signed-off-by: Christian Eggers <ceggers@arri.de>
---
 drivers/net/dsa/microchip/ksz9477_main.c |   9 +-
 drivers/net/dsa/microchip/ksz9477_ptp.c  | 629 +++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz9477_ptp.h  |  27 +
 include/linux/dsa/ksz_common.h           |  30 ++
 net/dsa/tag_ksz.c                        | 206 +++++++-
 5 files changed, 893 insertions(+), 8 deletions(-)

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
index 44d7bbdea518..d4bcfff0577e 100644
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
 
@@ -251,11 +288,349 @@ static int ksz9477_ptp_stop_clock(struct ksz_device *dev)
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
+static int ksz9477_ptp_tcmode_get(struct ksz_device *dev, enum ksz9477_ptp_tcmode *tcmode)
+{
+	u16 data;
+	int ret;
+
+	ret = ksz_read16(dev, REG_PTP_MSG_CONF1, &data);
+	if (ret)
+		return ret;
+
+	*tcmode = (data & PTP_TC_P2P) ? KSZ9477_PTP_TCMODE_P2P : KSZ9477_PTP_TCMODE_E2E;
+
+	return 0;
+}
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
+static ssize_t tcmode_show(struct device *dev, struct device_attribute *attr __always_unused,
+			   char *buf)
+{
+	struct ksz_device *ksz = dev_get_drvdata(dev);
+	enum ksz9477_ptp_tcmode tcmode;
+	int ret = ksz9477_ptp_tcmode_get(ksz, &tcmode);
+
+	if (ret)
+		return ret;
+
+	return sprintf(buf, "%s\n", tcmode == KSZ9477_PTP_TCMODE_P2P ? "P2P" : "E2E");
+}
+
+static ssize_t tcmode_store(struct device *dev, struct device_attribute *attr __always_unused,
+			    char const *buf, size_t count)
+{
+	struct ksz_device *ksz = dev_get_drvdata(dev);
+	int ret;
+
+	if (strcasecmp(buf, "E2E") == 0)
+		ret = ksz9477_ptp_tcmode_set(ksz, KSZ9477_PTP_TCMODE_E2E);
+	else if (strcasecmp(buf, "P2P") == 0)
+		ret = ksz9477_ptp_tcmode_set(ksz, KSZ9477_PTP_TCMODE_P2P);
+	else
+		return -EINVAL;
+
+	return ret ? ret : (ssize_t)count;
+}
+
+static DEVICE_ATTR_RW(tcmode);
+
+enum ksz9477_ptp_ocmode {
+	KSZ9477_PTP_OCMODE_SLAVE,
+	KSZ9477_PTP_OCMODE_MASTER,
+};
+
+static int ksz9477_ptp_ocmode_get(struct ksz_device *dev, enum ksz9477_ptp_ocmode *ocmode)
+{
+	u16 data;
+	int ret;
+
+	ret = ksz_read16(dev, REG_PTP_MSG_CONF1, &data);
+	if (ret)
+		return ret;
+
+	*ocmode = (data & PTP_MASTER) ? KSZ9477_PTP_OCMODE_MASTER : KSZ9477_PTP_OCMODE_SLAVE;
+
+	return 0;
+}
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
+static ssize_t ocmode_show(struct device *dev, struct device_attribute *attr __always_unused,
+			   char *buf)
+{
+	struct ksz_device *ksz = dev_get_drvdata(dev);
+	enum ksz9477_ptp_ocmode ocmode;
+	int ret = ksz9477_ptp_ocmode_get(ksz, &ocmode);
+
+	if (ret)
+		return ret;
+
+	return sprintf(buf, "%s\n", ocmode == KSZ9477_PTP_OCMODE_MASTER ? "master" : "slave");
+}
+
+static ssize_t ocmode_store(struct device *dev, struct device_attribute *attr __always_unused,
+			    char const *buf, size_t count)
+{
+	struct ksz_device *ksz = dev_get_drvdata(dev);
+	int ret;
+
+	if (strcasecmp(buf, "master") == 0)
+		ret = ksz9477_ptp_ocmode_set(ksz, KSZ9477_PTP_OCMODE_MASTER);
+	else if (strcasecmp(buf, "slave") == 0)
+		ret = ksz9477_ptp_ocmode_set(ksz, KSZ9477_PTP_OCMODE_SLAVE);
+	else
+		return -EINVAL;
+
+	return ret ? ret : (ssize_t)count;
+}
+
+static DEVICE_ATTR_RW(ocmode);
+
+static struct attribute *ksz9477_ptp_attrs[] = {
+	&dev_attr_tcmode.attr,
+	&dev_attr_ocmode.attr,
+	NULL,
+};
+
+static struct attribute_group ksz9477_ptp_attrgrp = {
+	.attrs = ksz9477_ptp_attrs,
+};
+
 int ksz9477_ptp_init(struct ksz_device *dev)
 {
 	int ret;
 
 	mutex_init(&dev->ptp_mutex);
+	spin_lock_init(&dev->ptp_clock_lock);
 
 	/* PTP clock properties */
 
@@ -275,6 +650,7 @@ int ksz9477_ptp_init(struct ksz_device *dev)
 	dev->ptp_caps.gettime64   = ksz9477_ptp_gettime;
 	dev->ptp_caps.settime64   = ksz9477_ptp_settime;
 	dev->ptp_caps.enable      = ksz9477_ptp_enable;
+	dev->ptp_caps.do_aux_work = ksz9477_ptp_do_aux_work;
 
 	/* Start hardware counter (will overflow after 136 years) */
 	ret = ksz9477_ptp_start_clock(dev);
@@ -287,8 +663,36 @@ int ksz9477_ptp_init(struct ksz_device *dev)
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
+	/* Init attributes */
+	ret = sysfs_create_group(&dev->dev->kobj, &ksz9477_ptp_attrgrp);
+	if (ret)
+		goto error_ports_deinit;
+
+	/* Schedule cyclic call of ksz_ptp_do_aux_work() */
+	ret = ptp_schedule_worker(dev->ptp_clock, 0);
+	if (ret)
+		goto error_device_remove_attrgrp;
+
 	return 0;
 
+error_device_remove_attrgrp:
+	sysfs_remove_group(&dev->dev->kobj, &ksz9477_ptp_attrgrp);
+error_ports_deinit:
+	ksz9477_ptp_ports_deinit(dev);
+error_disable_mode:
+	ksz9477_ptp_disable_mode(dev);
+error_unregister_clock:
+	ptp_clock_unregister(dev->ptp_clock);
 error_stop_clock:
 	ksz9477_ptp_stop_clock(dev);
 	return ret;
@@ -296,6 +700,231 @@ int ksz9477_ptp_init(struct ksz_device *dev)
 
 void ksz9477_ptp_deinit(struct ksz_device *dev)
 {
+	sysfs_remove_group(&dev->dev->kobj, &ksz9477_ptp_attrgrp);
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
+		struct skb_shared_hwtstamps shhwtstamps;
+		struct sk_buff *tmp_skb;
+
+		/* In contrast to the KSZ9563R data sheet, the format of the
+		 * port time stamp registers is 2 bit seconds + 30 bit nano
+		 * seconds (same as in the tail tags).
+		 */
+		ret = ksz_read32(dev, PORT_CTRL_ADDR(port, REG_PTP_PORT_XDELAY_TS), &tstamp_raw);
+		if (ret)
+			return result;
+
+		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
+		shhwtstamps.hwtstamp = ksz9477_tstamp_to_clock(dev, tstamp_raw,
+							       prt->tstamp_tx_latency_ns);
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
+	if (!test_bit(KSZ_HWTSTAMP_ENABLED, &port->tstamp_state))
+		return NULL;
+
+	return ptp_parse_header(skb, type);
+}
+
+bool ksz9477_ptp_port_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *clone,
+			       unsigned int type)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz_port *prt = &dev->ports[port];
+	enum ksz9477_ptp_event_messages msg_type;
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
+	msg_type = ptp_get_msgtype(hdr, type);
+
+	switch (msg_type) {
+	/* As the KSZ9563 always performs one step time stamping, only the time
+	 * stamp for Delay_Req and Pdelay_Req are reported to the application
+	 * via socket error queue. Time stamps for Sync and Pdelay_resp will be
+	 * applied directly to the outgoing message (e.g. correction field), but
+	 * will NOT be reported to the socket.
+	 */
+	case PTP_Event_Message_Delay_Req:
+	case PTP_Event_Message_Pdelay_Req:
+		if (test_and_set_bit_lock(KSZ_HWTSTAMP_TX_XDELAY_IN_PROGRESS,
+					  &prt->tstamp_state))
+			return false;  /* free cloned skb */
+
+		prt->tstamp_tx_xdelay_skb = clone;
+		break;
+
+	default:
+		return false;  /* free cloned skb */
+	}
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
index 4d5b6cc9429a..10b42154ba5a 100644
--- a/include/linux/dsa/ksz_common.h
+++ b/include/linux/dsa/ksz_common.h
@@ -8,8 +8,10 @@
 #include <linux/gpio/consumer.h>
 #include <linux/kernel.h>
 #include <linux/mutex.h>
+#include <linux/net_tstamp.h>
 #include <linux/phy.h>
 #include <linux/ptp_clock_kernel.h>
+#include <linux/spinlock.h>
 #include <linux/regmap.h>
 #include <linux/timer.h>
 #include <linux/workqueue.h>
@@ -25,6 +27,12 @@ struct ksz_port_mib {
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
@@ -41,6 +49,13 @@ struct ksz_port {
 
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
@@ -98,7 +113,22 @@ struct ksz_device {
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
+ktime_t ksz9477_tstamp_to_clock(struct ksz_device *ksz, u32 tstamp,
+		int offset_ns);
+
 #endif /* _NET_DSA_KSZ_COMMON_H_ */
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 4820dbcedfa2..9dbe2fde3db0 100644
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
@@ -87,26 +91,210 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ8795);
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
+static inline __wsum ksz9477_check_diff8(__be64 old, __be64 new, __wsum oldsum)
+{
+	__be64 diff[2] = { ~old, new };
+
+	return csum_partial(diff, sizeof(diff), oldsum);
+}
+
+/* Replace content of PTP header's correction field and update UDP checksum */
+static void ksz9477_update_ptp_correction_field(struct sk_buff *skb, unsigned int type,
+						struct ptp_header *ptp_header, u64 value)
+{
+	u8 *ptr = skb_mac_header(skb);
+	struct udphdr *uhdr = NULL;
+	__be64 correction_old;
+
+	/* previous correction value is required for checksum update. */
+	memcpy(&correction_old,  &ptp_header->correction, sizeof(correction_old));
+
+	/* write new correction value */
+	put_unaligned_be64(value, &ptp_header->correction);
+
+	/* locate udp header */
+	if (type & PTP_CLASS_VLAN)
+		ptr += VLAN_HLEN;
+
+	ptr += ETH_HLEN;
+
+	switch (type & PTP_CLASS_PMASK) {
+	case PTP_CLASS_IPV4:
+		ptr += ((struct iphdr *)ptr)->ihl << 2;
+		uhdr = (struct udphdr *)ptr;
+		break;
+	case PTP_CLASS_IPV6:
+		ptr += IP6_HLEN;
+		uhdr = (struct udphdr *)ptr;
+		break;
+	}
+
+	if (uhdr) {
+		/* update checksum */
+		uhdr->check = csum_fold(ksz9477_check_diff8(correction_old, ptp_header->correction,
+							    ~csum_unfold(uhdr->check)));
+		if (!uhdr->check)
+			uhdr->check = CSUM_MANGLED_0;
+	}
+}
+
+/* Time stamp tag is only inserted if PTP is enabled in hardware. */
+static void ksz9477_xmit_timestamp(struct sk_buff *skb)
+{
+	enum ksz9477_ptp_event_messages msg_type;
+	struct ptp_header *ptp_hdr;
+	unsigned int ptp_type;
+	u32 tstamp_raw = 0;
+	u64 correction;
+
+	/* For PDelay_Resp messages we will likely have a negative value in the
+	 * correction field (see ksz9477_rcv()). The switch hardware cannot
+	 * correctly update such values, so it must be moved to the time stamp
+	 * field in the tail tag.
+	 */
+
+	/* Check PTP message type */
+	ptp_type = ptp_classify_raw(skb);
+
+	if (ptp_type == PTP_CLASS_NONE)
+		goto out_put_tag;
+
+	ptp_hdr = ptp_parse_header(skb, ptp_type);
+	if (!ptp_hdr)
+		goto out_put_tag;
+
+	msg_type = ptp_get_msgtype(ptp_hdr, ptp_type);
+	if (msg_type != PTP_Event_Message_Pdelay_Resp)
+		goto out_put_tag;
+
+	correction = get_unaligned_be64(&ptp_hdr->correction);
+	if ((s64)correction < 0) {
+		struct timespec64 ts;
+
+		/* Move ingress time stamp from PTP header's correction field to tail tag. */
+		ts = ns_to_timespec64(-((s64)correction));
+		tstamp_raw = ((ts.tv_sec & 3) << 30) | ts.tv_nsec;
+		correction = 0;
+		ksz9477_update_ptp_correction_field(skb, ptp_type, ptp_hdr, correction);
+	}
+
+out_put_tag:
+	put_unaligned_be32(tstamp_raw, skb_put(skb, KSZ9477_PTP_TAG_LEN));
+}
+
+ktime_t ksz9477_tstamp_to_clock(struct ksz_device *ksz, u32 tstamp, int offset_ns)
+{
+	struct timespec64 ptp_clock_time;
+	/* Split up time stamp, 2 bit seconds, 30 bit nano seconds */
+	struct timespec64 ts = {
+		.tv_sec  = tstamp >> 30,
+		.tv_nsec = tstamp & (BIT_MASK(30) - 1),
+	};
+	struct timespec64 diff;
+	unsigned long flags;
+	s64 ns;
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
+	/* Add/remove excess delay between wire and time stamp unit */
+	ns = timespec64_to_ns(&ts) + offset_ns;
+
+	return ns_to_ktime(ns);
+}
+EXPORT_SYMBOL(ksz9477_tstamp_to_clock);
+
+static void ksz9477_rcv_timestamp(struct sk_buff *skb, u8 *tag,
+				  struct net_device *dev, unsigned int port)
+{
+	struct skb_shared_hwtstamps *hwtstamps = skb_hwtstamps(skb);
+	enum ksz9477_ptp_event_messages msg_type;
+	struct dsa_switch *ds = dev->dsa_ptr->ds;
+	struct ksz_device *ksz = ds->priv;
+	struct ksz_port *prt = &ksz->ports[port];
+	u8 *tstamp = tag - KSZ9477_PTP_TAG_LEN;
+	struct ptp_header *ptp_hdr;
+	unsigned int ptp_type;
+	u64 correction;
+
+	/* convert time stamp and write to skb */
+	memset(hwtstamps, 0, sizeof(*hwtstamps));
+	hwtstamps->hwtstamp = ksz9477_tstamp_to_clock(ksz, get_unaligned_be32(tstamp),
+						      -prt->tstamp_rx_latency_ns);
+
+	/* For PDelay_Req messages, user space (ptp4l) expects that the hardware
+	 * subtracts the egress time stamp from the correction field. The
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
+	correction = get_unaligned_be64(&ptp_hdr->correction);
+	correction -= hwtstamps->hwtstamp;
+	ksz9477_update_ptp_correction_field(skb, ptp_type, ptp_hdr, correction);
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
@@ -116,6 +304,7 @@ static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 	u16 val;
 
 	/* Tag encoding */
+	ksz9477_xmit_timestamp(skb);
 	tag = skb_put(skb, KSZ9477_INGRESS_TAG_LEN);
 	addr = skb_mac_header(skb);
 
@@ -138,8 +327,10 @@ static struct sk_buff *ksz9477_rcv(struct sk_buff *skb, struct net_device *dev,
 	unsigned int len = KSZ_EGRESS_TAG_LEN;
 
 	/* Extra 4-bytes PTP timestamp */
-	if (tag[0] & KSZ9477_PTP_TAG_INDICATION)
+	if (tag[0] & KSZ9477_PTP_TAG_INDICATION) {
+		ksz9477_rcv_timestamp(skb, tag, dev, port);
 		len += KSZ9477_PTP_TAG_LEN;
+	}
 
 	return ksz_common_rcv(skb, dev, port, len);
 }
@@ -149,7 +340,7 @@ static const struct dsa_device_ops ksz9477_netdev_ops = {
 	.proto	= DSA_TAG_PROTO_KSZ9477,
 	.xmit	= ksz9477_xmit,
 	.rcv	= ksz9477_rcv,
-	.overhead = KSZ9477_INGRESS_TAG_LEN,
+	.overhead = KSZ9477_INGRESS_TAG_LEN + KSZ9477_PTP_TAG_LEN,
 	.tail_tag = true,
 };
 
@@ -167,6 +358,7 @@ static struct sk_buff *ksz9893_xmit(struct sk_buff *skb,
 	u8 *tag;
 
 	/* Tag encoding */
+	ksz9477_xmit_timestamp(skb);
 	tag = skb_put(skb, KSZ_INGRESS_TAG_LEN);
 	addr = skb_mac_header(skb);
 
@@ -183,7 +375,7 @@ static const struct dsa_device_ops ksz9893_netdev_ops = {
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

