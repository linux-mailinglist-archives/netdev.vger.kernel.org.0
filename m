Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D3B2CA815
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 17:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404136AbgLAQUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 11:20:18 -0500
Received: from mailout04.rmx.de ([94.199.90.94]:42574 "EHLO mailout04.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390911AbgLAQUR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 11:20:17 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout04.rmx.de (Postfix) with ESMTPS id 4ClnNv2yrVz3qnXH;
        Tue,  1 Dec 2020 17:19:27 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4ClnMH0HNzz2xFb;
        Tue,  1 Dec 2020 17:18:03 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.19) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Tue, 1 Dec
 2020 17:10:56 +0100
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
Subject: [PATCH net-next v4 8/9] net: dsa: microchip: ksz9477: remaining hardware time stamping support
Date:   Tue, 1 Dec 2020 17:06:10 +0100
Message-ID: <20201201160611.22129-9-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201201160611.22129-1-ceggers@arri.de>
References: <20201201160611.22129-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.19]
X-RMX-ID: 20201201-171809-4ClnMH0HNzz2xFb-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add data path routines required for TX hardware time stamping.

PTP mode is enabled depending on the filter setup (changes tail tag). TX
time stamps are reported via an interrupt / device registers whilst RX
time stamps are reported via an additional tail tag.

One step TX time stamping of PDelay_Resp requires the RX time stamp from
the associated PDelay_Req message. The user space PTP stack assumes that
the RX time stamp has already been subtracted from the PDelay_Req
correction field (as done by the ZHAW InES PTP time stamping core). It
will echo back the value of the correction field in the PDelay_Resp
message.

In order to be compatible to this already established interface, the
KSZ9563 code emulates this behavior. When processing the PDelay_Resp
message, the time stamp is moved back from the correction field to the
tail tag, as the hardware generates an invalid UDP checksum if this
field is negative.

Of course, the UDP checksums (if any) have to be corrected after this
(for both directions).

Everything has been tested on a Microchip KSZ9563 switch.

Signed-off-by: Christian Eggers <ceggers@arri.de>
---
Changes in v4:
--------------
- s/low active/active low/
- 80 chars per line
- Use IEEE 802.1AS mode (to suppress forwarding of PDelay messages)
- Enable/disable hardware timestaping at runtime (port_hwtstamp_set)
- Use mutex in port_hwtstamp_set
- Don't use port specific struct hwtstamp_config
- removed #ifdefs from tag_ksz.c
- Set port's tx_latency and rx_latency to 0
- added include/linux/dsa/ksz_common.h to MAINTAINERS

On Saturday, 21 November 2020, 02:26:11 CET, Vladimir Oltean wrote:
> If you don't like the #ifdef's, I am not in love with them either. But
> maybe Christian is just optimizing too aggressively, and doesn't actually
> need to put those #ifdef's there and provide stub implementations, but
> could actually just leave the ksz9477_rcv_timestamp and ksz9477_xmit_timestamp
> always compiled-in, and "dead at runtime" in the case there is no PTP.
I removed the #ifdefs.

> [...]
> The thing is, ptp4l already has ingressLatency and egressLatency
> settings, and I would not be surprised if those config options would get
> extended to cover values at multiple link speeds.
> 
> In the general case, the ksz9477 MAC could be attached to any external
> PHY, having its own propagation delay characteristics, or any number of
> other things that cause clock domain crossings. I'm not sure how feasible
> it is for the kernel to abstract this away completely, and adjust
> timestamps automatically based on any and all combinations of MAC and
> PHY. Maybe this is just wishful thinking.
> 
> Oh, and by the way, Christian, I'm not even sure if you aren't in fact
> just beating around the bush with these tstamp_rx_latency_ns and
> tstamp_tx_latency_ns values? I mean, the switch adds the latency value
> to the timestamps. And you, from the driver, read the value of the
> register, so you can subtract the value from the timestamp, to
> compensate for its correction. So, all in all, there is no net latency
> compensation seen by the outside world?! If that is the case, can't you
> just set the latency registers to zero, do your compensation from the
> application stack and call it a day?
At first I thought that I have to move these values to ptp4l.conf. But after
setting the hardware registers to zero, it turned out, that I also have to
use zero values in ptp4l.conf. So you are right.


On Monday, 23 November 2020, 13:09:38 CET, Vladimir Oltean wrote:
> On Mon, Nov 23, 2020 at 12:32:33PM +0100, Christian Eggers wrote:
> > please let me know, how I shall finally implement this. Enabling the PTP mode
> > on the switch and sending the extra 4 byte tail on tx must be done in sync.
> > Currently, both simply depends on the PTP define.
> 
> I, too, would prefer that the reconfiguration is done at ioctl time.
> Distributions typically enable whatever kernel config options they can.
> However, for users, the behavior should not change. Therefore the tail
> tag should remain small even though the PTP kernel config option is
> enabled, as long as hardware timestamping has not been explicitly
> enabled.
I moved this to port_hwtstamp_set. But I am not sure whether enabling PTP mode
should depend on tx_type or rx_filter.

> [...]
> When forwarding what packet? What profile are you testing with?
> What commands do you run?
> A P2P capable switch should not forward Peer delay messages.
With the 802.1AS settings, no SYNC/Announce messages are forwarded anymore.
Peer delay messages have never been forwarded.

 MAINTAINERS                              |   1 +
 drivers/net/dsa/microchip/ksz9477_main.c |  12 +-
 drivers/net/dsa/microchip/ksz9477_ptp.c  | 391 ++++++++++++++++++++++-
 drivers/net/dsa/microchip/ksz9477_ptp.h  |  14 +
 drivers/net/dsa/microchip/ksz_common.h   |   9 +-
 include/linux/dsa/ksz_common.h           |  70 ++++
 net/dsa/tag_ksz.c                        | 205 +++++++++++-
 7 files changed, 678 insertions(+), 24 deletions(-)
 create mode 100644 include/linux/dsa/ksz_common.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 331fa2594f00..7ed88627c8f4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11491,6 +11491,7 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
 F:	drivers/net/dsa/microchip/*
+F:	include/linux/dsa/ksz_common.h
 F:	include/linux/platform_data/microchip-ksz.h
 F:	net/dsa/tag_ksz.c
 
diff --git a/drivers/net/dsa/microchip/ksz9477_main.c b/drivers/net/dsa/microchip/ksz9477_main.c
index b164605d1563..cc7a069877e3 100644
--- a/drivers/net/dsa/microchip/ksz9477_main.c
+++ b/drivers/net/dsa/microchip/ksz9477_main.c
@@ -1412,7 +1412,7 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.port_mirror_del	= ksz9477_port_mirror_del,
 	.port_hwtstamp_get      = ksz9477_ptp_port_hwtstamp_get,
 	.port_hwtstamp_set      = ksz9477_ptp_port_hwtstamp_set,
-	.port_txtstamp          = NULL,
+	.port_txtstamp          = ksz9477_ptp_port_txtstamp,
 	/* never defer rx delivery, tstamping is done via tail tagging */
 	.port_rxtstamp          = NULL,
 };
@@ -1541,6 +1541,7 @@ static const struct ksz_chip_data ksz9477_switch_chips[] = {
 static irqreturn_t ksz9477_switch_irq_thread(int irq, void *dev_id)
 {
 	struct ksz_device *dev = dev_id;
+	irqreturn_t result = IRQ_NONE;
 	u32 data;
 	int port;
 	int ret;
@@ -1560,12 +1561,15 @@ static irqreturn_t ksz9477_switch_irq_thread(int irq, void *dev_id)
 		ret = ksz_read8(dev, PORT_CTRL_ADDR(port, REG_PORT_INT_STATUS),
 				&data8);
 		if (ret)
-			return IRQ_NONE;
+			return result;
 
-		/* ToDo: Add specific handling of port interrupts */
+		if (data8 & PORT_PTP_INT) {
+			if (ksz9477_ptp_port_interrupt(dev, port) != IRQ_NONE)
+				result = IRQ_HANDLED;
+		}
 	}
 
-	return IRQ_NONE;
+	return result;
 }
 
 static int ksz9477_enable_port_interrupts(struct ksz_device *dev, bool enable)
diff --git a/drivers/net/dsa/microchip/ksz9477_ptp.c b/drivers/net/dsa/microchip/ksz9477_ptp.c
index a1ca1923ec0c..e68c9fc8e679 100644
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
@@ -76,6 +79,8 @@ static int ksz9477_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 static int ksz9477_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 {
 	struct ksz_device *dev = container_of(ptp, struct ksz_device, ptp_caps);
+	struct ksz_device_ptp_shared *ptp_shared = &dev->ptp_shared;
+	struct timespec64 delta64 = ns_to_timespec64(delta);
 	s32 sec, nsec;
 	u16 data16;
 	int ret;
@@ -110,6 +115,11 @@ static int ksz9477_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 	if (ret)
 		goto error_return;
 
+	spin_lock_bh(&ptp_shared->ptp_clock_lock);
+	ptp_shared->ptp_clock_time = timespec64_add(ptp_shared->ptp_clock_time,
+						    delta64);
+	spin_unlock_bh(&ptp_shared->ptp_clock_lock);
+
 error_return:
 	mutex_unlock(&dev->ptp_mutex);
 	return ret;
@@ -168,6 +178,7 @@ static int ksz9477_ptp_settime(struct ptp_clock_info *ptp,
 			       struct timespec64 const *ts)
 {
 	struct ksz_device *dev = container_of(ptp, struct ksz_device, ptp_caps);
+	struct ksz_device_ptp_shared *ptp_shared = &dev->ptp_shared;
 	u16 data16;
 	int ret;
 
@@ -207,6 +218,10 @@ static int ksz9477_ptp_settime(struct ptp_clock_info *ptp,
 	if (ret)
 		goto error_return;
 
+	spin_lock_bh(&ptp_shared->ptp_clock_lock);
+	ptp_shared->ptp_clock_time = *ts;
+	spin_unlock_bh(&ptp_shared->ptp_clock_lock);
+
 error_return:
 	mutex_unlock(&dev->ptp_mutex);
 	return ret;
@@ -221,17 +236,23 @@ static int ksz9477_ptp_enable(struct ptp_clock_info *ptp,
 static long ksz9477_ptp_do_aux_work(struct ptp_clock_info *ptp)
 {
 	struct ksz_device *dev = container_of(ptp, struct ksz_device, ptp_caps);
+	struct ksz_device_ptp_shared *ptp_shared = &dev->ptp_shared;
 	struct timespec64 ts;
 
 	mutex_lock(&dev->ptp_mutex);
 	_ksz9477_ptp_gettime(dev, &ts);
 	mutex_unlock(&dev->ptp_mutex);
 
+	spin_lock_bh(&ptp_shared->ptp_clock_lock);
+	ptp_shared->ptp_clock_time = ts;
+	spin_unlock_bh(&ptp_shared->ptp_clock_lock);
+
 	return HZ;  /* reschedule in 1 second */
 }
 
 static int ksz9477_ptp_start_clock(struct ksz_device *dev)
 {
+	struct ksz_device_ptp_shared *ptp_shared = &dev->ptp_shared;
 	u16 data;
 	int ret;
 
@@ -252,6 +273,11 @@ static int ksz9477_ptp_start_clock(struct ksz_device *dev)
 	if (ret)
 		return ret;
 
+	spin_lock_bh(&ptp_shared->ptp_clock_lock);
+	ptp_shared->ptp_clock_time.tv_sec = 0;
+	ptp_shared->ptp_clock_time.tv_nsec = 0;
+	spin_unlock_bh(&ptp_shared->ptp_clock_lock);
+
 	return 0;
 }
 
@@ -269,6 +295,236 @@ static int ksz9477_ptp_stop_clock(struct ksz_device *dev)
 	return ksz_write16(dev, REG_PTP_CLK_CTRL, data);
 }
 
+/* Time stamping support */
+
+static int ksz9477_ptp_enable_mode(struct ksz_device *dev, bool enable)
+{
+	u16 data;
+	int ret;
+
+	ret = ksz_read16(dev, REG_PTP_MSG_CONF1, &data);
+	if (ret)
+		return ret;
+
+	/* Setting the PTP_802_1AS bit disables forwarding of PDelay_Req and
+	 * PDelay_Resp messages. These messages must not be forwarded in
+	 * Boundary Clock mode.
+	 */
+	if (enable)
+		data |= PTP_ENABLE | PTP_802_1AS;
+	else
+		data &= ~PTP_ENABLE;
+
+	ret = ksz_write16(dev, REG_PTP_MSG_CONF1, data);
+	if (ret)
+		return ret;
+
+	if (enable) {
+		/* Schedule cyclic call of ksz_ptp_do_aux_work() */
+		ret = ptp_schedule_worker(dev->ptp_clock, 0);
+		if (ret)
+			goto error_disable_mode;
+	} else {
+		ptp_cancel_worker_sync(dev->ptp_clock);
+	}
+
+	return 0;
+
+error_disable_mode:
+	ksz_write16(dev, REG_PTP_MSG_CONF1, data & ~PTP_ENABLE);
+	return ret;
+}
+
+static int ksz9477_ptp_enable_port_ptp_interrupts(struct ksz_device *dev,
+						  int port, bool enable)
+{
+	u32 addr = PORT_CTRL_ADDR(port, REG_PORT_INT_MASK);
+	u8 data;
+	int ret;
+
+	ret = ksz_read8(dev, addr, &data);
+	if (ret)
+		return ret;
+
+	/* PORT_PTP_INT bit is active low */
+	if (enable)
+		data &= ~PORT_PTP_INT;
+	else
+		data |= PORT_PTP_INT;
+
+	return ksz_write8(dev, addr, data);
+}
+
+static int ksz9477_ptp_enable_port_egress_interrupts(struct ksz_device *dev,
+						     int port, bool enable)
+{
+	u32 addr = PORT_CTRL_ADDR(port, REG_PTP_PORT_TX_INT_ENABLE__2);
+	u16 data;
+	int ret;
+
+	ret = ksz_read16(dev, addr, &data);
+	if (ret)
+		return ret;
+
+	/* PTP_PORT_XDELAY_REQ_INT is high active */
+	if (enable)
+		data |= PTP_PORT_XDELAY_REQ_INT;
+	else
+		data &= PTP_PORT_XDELAY_REQ_INT;
+
+	return ksz_write16(dev, addr, data);
+}
+
+static void ksz9477_ptp_txtstamp_skb(struct ksz_device *dev,
+				     struct ksz_port *prt, struct sk_buff *skb)
+{
+	struct skb_shared_hwtstamps hwtstamps = {};
+	int ret;
+
+	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+
+	/* timeout must include tstamp latency, IRQ latency and time for
+	 * reading the time stamp via I2C.
+	 */
+	ret = wait_for_completion_timeout(&prt->tstamp_completion,
+					  msecs_to_jiffies(100));
+	if (!ret) {
+		dev_err(dev->dev, "timeout waiting for time stamp\n");
+		return;
+	}
+	hwtstamps.hwtstamp = prt->tstamp_xdelay;
+	skb_complete_tx_timestamp(skb, &hwtstamps);
+}
+
+#define work_to_port(work) \
+		container_of((work), struct ksz_port_ptp_shared, xmit_work)
+#define ptp_shared_to_ksz_port(t) \
+		container_of((t), struct ksz_port, ptp_shared)
+#define ptp_shared_to_ksz_device(t) \
+		container_of((t), struct ksz_device, ptp_shared)
+
+/* Deferred work is necessary for time stamped PDelay_Req messages. This cannot
+ * be done from atomic context as we have to wait for the hardware interrupt.
+ */
+static void ksz9477_port_deferred_xmit(struct kthread_work *work)
+{
+	struct ksz_port_ptp_shared *prt_ptp_shared = work_to_port(work);
+	struct ksz_port *prt = ptp_shared_to_ksz_port(prt_ptp_shared);
+	struct ksz_device_ptp_shared *ptp_shared = prt_ptp_shared->dev;
+	struct ksz_device *dev = ptp_shared_to_ksz_device(ptp_shared);
+	int port = prt - dev->ports;
+	struct sk_buff *skb;
+
+	while ((skb = skb_dequeue(&prt_ptp_shared->xmit_queue)) != NULL) {
+		struct sk_buff *clone = DSA_SKB_CB(skb)->clone;
+
+		reinit_completion(&prt->tstamp_completion);
+
+		/* Transfer skb to the host port. */
+		dsa_enqueue_skb(skb, dsa_to_port(dev->ds, port)->slave);
+
+		ksz9477_ptp_txtstamp_skb(dev, prt, clone);
+	}
+}
+
+static int ksz9477_ptp_port_init(struct ksz_device *dev, int port)
+{
+	struct ksz_port *prt = &dev->ports[port];
+	struct ksz_port_ptp_shared *ptp_shared = &prt->ptp_shared;
+	struct dsa_port *dp = dsa_to_port(dev->ds, port);
+	int ret;
+
+	if (port == dev->cpu_port)
+		return 0;
+
+	/* Set rx and tx latency to 0 (will be handled by user space) */
+	ret = ksz_write16(dev, PORT_CTRL_ADDR(port, REG_PTP_PORT_RX_DELAY__2),
+			  0);
+	if (ret)
+		return ret;
+
+	ret = ksz_write16(dev, PORT_CTRL_ADDR(port, REG_PTP_PORT_TX_DELAY__2),
+			  0);
+	if (ret)
+		return ret;
+
+	ret = ksz9477_ptp_enable_port_ptp_interrupts(dev, port, true);
+	if (ret)
+		return ret;
+
+	ret = ksz9477_ptp_enable_port_egress_interrupts(dev, port, true);
+	if (ret)
+		goto error_disable_port_ptp_interrupts;
+
+	/* ksz_port::ptp_shared is used in tagging driver */
+	ptp_shared->dev = &dev->ptp_shared;
+	dp->priv = ptp_shared;
+
+	/* PDelay_Req messages require deferred transmit as the time
+	 * stamp unit provides no sequenceId or similar.  So we must
+	 * wait for the time stamp interrupt.
+	 */
+	init_completion(&prt->tstamp_completion);
+	kthread_init_work(&ptp_shared->xmit_work,
+			  ksz9477_port_deferred_xmit);
+	ptp_shared->xmit_worker = kthread_create_worker(0, "%s_xmit",
+							dp->slave->name);
+	if (IS_ERR(ptp_shared->xmit_worker)) {
+		ret = PTR_ERR(ptp_shared->xmit_worker);
+		dev_err(dev->dev,
+			"failed to create deferred xmit thread: %d\n", ret);
+		goto error_disable_port_egress_interrupts;
+	}
+	skb_queue_head_init(&ptp_shared->xmit_queue);
+
+	return 0;
+
+error_disable_port_egress_interrupts:
+	ksz9477_ptp_enable_port_egress_interrupts(dev, port, false);
+error_disable_port_ptp_interrupts:
+	ksz9477_ptp_enable_port_ptp_interrupts(dev, port, false);
+	return ret;
+}
+
+static void ksz9477_ptp_port_deinit(struct ksz_device *dev, int port)
+{
+	struct ksz_port_ptp_shared *ptp_shared = &dev->ports[port].ptp_shared;
+
+	if (port == dev->cpu_port)
+		return;
+
+	kthread_destroy_worker(ptp_shared->xmit_worker);
+	ksz9477_ptp_enable_port_egress_interrupts(dev, port, false);
+	ksz9477_ptp_enable_port_ptp_interrupts(dev, port, false);
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
+	while (port-- > 0)
+		ksz9477_ptp_port_deinit(dev, port);
+	return ret;
+}
+
+static void ksz9477_ptp_ports_deinit(struct ksz_device *dev)
+{
+	int port;
+
+	for (port = 0; port < dev->port_cnt; port++)
+		ksz9477_ptp_port_deinit(dev, port);
+}
+
 /* device attributes */
 
 enum ksz9477_ptp_tcmode {
@@ -322,6 +578,7 @@ int ksz9477_ptp_init(struct ksz_device *dev)
 	int ret;
 
 	mutex_init(&dev->ptp_mutex);
+	spin_lock_init(&dev->ptp_shared.ptp_clock_lock);
 
 	/* PTP clock properties */
 
@@ -355,6 +612,11 @@ int ksz9477_ptp_init(struct ksz_device *dev)
 		goto error_stop_clock;
 	}
 
+	/* Init switch ports */
+	ret = ksz9477_ptp_ports_init(dev);
+	if (ret)
+		goto error_unregister_clock;
+
 	/* Currently, only P2P delay measurement is supported.  Setting ocmode
 	 * to slave will work independently of actually being master or slave.
 	 * For E2E delay measurement, switching between master and slave would
@@ -371,11 +633,6 @@ int ksz9477_ptp_init(struct ksz_device *dev)
 	ksz9477_ptp_tcmode_set(dev, KSZ9477_PTP_TCMODE_P2P);
 	ksz9477_ptp_ocmode_set(dev, KSZ9477_PTP_OCMODE_SLAVE);
 
-	/* Schedule cyclic call of ksz_ptp_do_aux_work() */
-	ret = ptp_schedule_worker(dev->ptp_clock, 0);
-	if (ret)
-		goto error_unregister_clock;
-
 	return 0;
 
 error_unregister_clock:
@@ -387,10 +644,53 @@ int ksz9477_ptp_init(struct ksz_device *dev)
 
 void ksz9477_ptp_deinit(struct ksz_device *dev)
 {
+	ksz9477_ptp_ports_deinit(dev);
+	ksz9477_ptp_enable_mode(dev, false);
 	ptp_clock_unregister(dev->ptp_clock);
 	ksz9477_ptp_stop_clock(dev);
 }
 
+irqreturn_t ksz9477_ptp_port_interrupt(struct ksz_device *dev, int port)
+{
+	u32 addr = PORT_CTRL_ADDR(port, REG_PTP_PORT_TX_INT_STATUS__2);
+	struct ksz_port *prt = &dev->ports[port];
+	u16 data;
+	int ret;
+
+	ret = ksz_read16(dev, addr, &data);
+	if (ret)
+		return IRQ_NONE;
+
+	if (data & PTP_PORT_XDELAY_REQ_INT) {
+		/* Timestamp for Pdelay_Req / Delay_Req */
+		struct ksz_device_ptp_shared *ptp_shared = &dev->ptp_shared;
+		u32 tstamp_raw;
+		ktime_t tstamp;
+
+		/* In contrast to the KSZ9563R data sheet, the format of the
+		 * port time stamp registers is also 2 bit seconds + 30 bit
+		 * nanoseconds (same as in the tail tags).
+		 */
+		ret = ksz_read32(dev,
+				 PORT_CTRL_ADDR(port, REG_PTP_PORT_XDELAY_TS),
+				 &tstamp_raw);
+		if (ret)
+			return IRQ_NONE;
+
+		tstamp = ksz9477_decode_tstamp(tstamp_raw);
+		prt->tstamp_xdelay = ksz9477_tstamp_reconstruct(ptp_shared,
+								tstamp);
+		complete(&prt->tstamp_completion);
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
 /* DSA PTP operations */
 
 int ksz9477_ptp_get_ts_info(struct dsa_switch *ds, int port,
@@ -418,7 +718,9 @@ int ksz9477_ptp_get_ts_info(struct dsa_switch *ds, int port,
 static int ksz9477_set_hwtstamp_config(struct ksz_device *dev, int port,
 				       struct hwtstamp_config *config)
 {
+	struct ksz_device_ptp_shared *ptp_shared = &dev->ptp_shared;
 	struct ksz_port *prt = &dev->ports[port];
+	bool on = true;
 
 	/* reserved for future extensions */
 	if (config->flags)
@@ -437,6 +739,7 @@ static int ksz9477_set_hwtstamp_config(struct ksz_device *dev, int port,
 
 	switch (config->rx_filter) {
 	case HWTSTAMP_FILTER_NONE:
+		on = false;
 		break;
 	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
 	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
@@ -452,9 +755,25 @@ static int ksz9477_set_hwtstamp_config(struct ksz_device *dev, int port,
 		break;
 	default:
 		config->rx_filter = HWTSTAMP_FILTER_NONE;
+		on = false;
 		return -ERANGE;
 	}
 
+	if (on != test_bit(KSZ9477_HWTS_EN, &ptp_shared->state)) {
+		int ret = 0;
+
+		clear_bit(KSZ9477_HWTS_EN, &ptp_shared->state);
+
+		ret = ksz9477_ptp_enable_mode(dev, on);
+		if (ret) {
+			dev_err(dev->dev,
+				"Failed to change timestamping: %d\n", ret);
+			return ret;
+		}
+		if (on)
+			set_bit(KSZ9477_HWTS_EN, &ptp_shared->state);
+	}
+
 	return 0;
 }
 
@@ -464,9 +783,8 @@ int ksz9477_ptp_port_hwtstamp_get(struct dsa_switch *ds, int port,
 	struct ksz_device *dev = ds->priv;
 	unsigned long bytes_copied;
 
-	bytes_copied = copy_to_user(ifr->ifr_data,
-				    &dev->ports[port].tstamp_config,
-				    sizeof(dev->ports[port].tstamp_config));
+	bytes_copied = copy_to_user(ifr->ifr_data, &dev->tstamp_config,
+				    sizeof(dev->tstamp_config));
 
 	return bytes_copied ? -EFAULT : 0;
 }
@@ -482,13 +800,66 @@ int ksz9477_ptp_port_hwtstamp_set(struct dsa_switch *ds, int port,
 	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
 		return -EFAULT;
 
+	mutex_lock(&dev->ptp_mutex);
+
 	err = ksz9477_set_hwtstamp_config(dev, port, &config);
-	if (err)
+	if (err) {
+		mutex_unlock(&dev->ptp_mutex);
 		return err;
+	}
 
 	/* Save the chosen configuration to be returned later. */
-	memcpy(&dev->ports[port].tstamp_config, &config, sizeof(config));
+	memcpy(&dev->tstamp_config, &config, sizeof(config));
 	bytes_copied = copy_to_user(ifr->ifr_data, &config, sizeof(config));
 
+	mutex_unlock(&dev->ptp_mutex);
+
 	return bytes_copied ? -EFAULT : 0;
 }
+
+bool ksz9477_ptp_port_txtstamp(struct dsa_switch *ds, int port,
+			       struct sk_buff *clone, unsigned int type)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz_port *prt = &dev->ports[port];
+	struct ptp_header *hdr;
+	u8 ptp_msg_type;
+
+	/* Should already been tested in dsa_skb_tx_timestamp()? */
+	if (!(skb_shinfo(clone)->tx_flags & SKBTX_HW_TSTAMP))
+		return false;
+
+	if (!prt->hwts_tx_en)
+		return false;
+
+	hdr = ptp_parse_header(clone, type);
+	if (!hdr)
+		return false;
+
+	ptp_msg_type = ptp_get_msgtype(hdr, type);
+	switch (ptp_msg_type) {
+	/* As the KSZ9563 always performs one step time stamping, only the time
+	 * stamp for Pdelay_Req is reported to the application via socket error
+	 * queue.  Time stamps for Sync and Pdelay_resp will be applied directly
+	 * to the outgoing message (e.g. correction field), but will NOT be
+	 * reported to the socket.
+	 * Delay_Req is not time stamped as E2E is currently not supported by
+	 * this driver.  See ksz9477_ptp_init() for details.
+	 */
+	case PTP_MSGTYPE_PDELAY_REQ:
+	case PTP_MSGTYPE_PDELAY_RESP:
+		break;
+	default:
+		return false;
+	}
+
+	/* ptp_type will be reused in ksz9477_xmit_timestamp(). ptp_msg_type
+	 * will be reused in ksz9477_defer_xmit(). For PDelay_Resp, the cloned
+	 * skb will not be passed to skb_complete_tx_timestamp() and has to be
+	 * freed manually in ksz9477_defer_xmit().
+	 */
+	KSZ9477_SKB_CB(clone)->ptp_type = type;
+	KSZ9477_SKB_CB(clone)->ptp_msg_type = ptp_msg_type;
+
+	return true;  /* keep cloned skb */
+}
diff --git a/drivers/net/dsa/microchip/ksz9477_ptp.h b/drivers/net/dsa/microchip/ksz9477_ptp.h
index b599401812ae..2f7c4fa0753a 100644
--- a/drivers/net/dsa/microchip/ksz9477_ptp.h
+++ b/drivers/net/dsa/microchip/ksz9477_ptp.h
@@ -10,6 +10,7 @@
 #ifndef DRIVERS_NET_DSA_MICROCHIP_KSZ9477_PTP_H_
 #define DRIVERS_NET_DSA_MICROCHIP_KSZ9477_PTP_H_
 
+#include <linux/irqreturn.h>
 #include <linux/types.h>
 
 #include "ksz_common.h"
@@ -19,18 +20,26 @@
 int ksz9477_ptp_init(struct ksz_device *dev);
 void ksz9477_ptp_deinit(struct ksz_device *dev);
 
+irqreturn_t ksz9477_ptp_port_interrupt(struct ksz_device *dev, int port);
+
 int ksz9477_ptp_get_ts_info(struct dsa_switch *ds, int port,
 			    struct ethtool_ts_info *ts);
 int ksz9477_ptp_port_hwtstamp_get(struct dsa_switch *ds, int port,
 				  struct ifreq *ifr);
 int ksz9477_ptp_port_hwtstamp_set(struct dsa_switch *ds, int port,
 				  struct ifreq *ifr);
+bool ksz9477_ptp_port_txtstamp(struct dsa_switch *ds, int port,
+			       struct sk_buff *clone, unsigned int type);
 
 #else
 
 static inline int ksz9477_ptp_init(struct ksz_device *dev) { return 0; }
 static inline void ksz9477_ptp_deinit(struct ksz_device *dev) {}
 
+static inline irqreturn_t ksz9477_ptp_port_interrupt(struct ksz_device *dev,
+						     int port)
+{ return IRQ_NONE; }
+
 static inline int ksz9477_ptp_get_ts_info(struct dsa_switch *ds, int port,
 					  struct ethtool_ts_info *ts)
 { return -EOPNOTSUPP; }
@@ -43,6 +52,11 @@ static inline int ksz9477_ptp_port_hwtstamp_set(struct dsa_switch *ds, int port,
 						struct ifreq *ifr)
 { return -EOPNOTSUPP; }
 
+static inline bool ksz9477_ptp_port_txtstamp(struct dsa_switch *ds, int port,
+					     struct sk_buff *clone,
+					     unsigned int type)
+{ return false; }
+
 #endif
 
 #endif /* DRIVERS_NET_DSA_MICROCHIP_KSZ9477_PTP_H_ */
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 139e9b84290b..483a2f0e59d2 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -7,8 +7,11 @@
 #ifndef __KSZ_COMMON_H
 #define __KSZ_COMMON_H
 
+#include <linux/completion.h>
+#include <linux/dsa/ksz_common.h>
 #include <linux/etherdevice.h>
 #include <linux/kernel.h>
+#include <linux/ktime.h>
 #include <linux/mutex.h>
 #include <linux/phy.h>
 #include <linux/ptp_clock_kernel.h>
@@ -42,7 +45,9 @@ struct ksz_port {
 	struct ksz_port_mib mib;
 	phy_interface_t interface;
 #if IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ9477_PTP)
-	struct hwtstamp_config tstamp_config;
+	struct ksz_port_ptp_shared ptp_shared;
+	ktime_t tstamp_xdelay;
+	struct completion tstamp_completion;
 	bool hwts_tx_en;
 #endif
 };
@@ -101,7 +106,9 @@ struct ksz_device {
 #if IS_ENABLED(CONFIG_NET_DSA_MICROCHIP_KSZ9477_PTP)
 	struct ptp_clock *ptp_clock;
 	struct ptp_clock_info ptp_caps;
+	struct hwtstamp_config tstamp_config;
 	struct mutex ptp_mutex;		/* protects PTP related hardware */
+	struct ksz_device_ptp_shared ptp_shared;
 #endif
 };
 
diff --git a/include/linux/dsa/ksz_common.h b/include/linux/dsa/ksz_common.h
new file mode 100644
index 000000000000..a9b4720cc842
--- /dev/null
+++ b/include/linux/dsa/ksz_common.h
@@ -0,0 +1,70 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Routines shared between drivers/net/dsa/microchip/ksz9477_ptp.h and
+ * net/dsa/tag_ksz.c
+ *
+ * Copyright (C) 2020 ARRI Lighting
+ */
+
+#ifndef _NET_DSA_KSZ_COMMON_H_
+#define _NET_DSA_KSZ_COMMON_H_
+
+#include <linux/bitfield.h>
+#include <linux/bits.h>
+#include <linux/ktime.h>
+#include <linux/kthread.h>
+#include <linux/net_tstamp.h>
+#include <linux/ptp_classify.h>
+#include <linux/skbuff.h>
+#include <linux/spinlock.h>
+#include <linux/time64.h>
+#include <net/dsa.h>
+
+/* All time stamps from the KSZ consist of 2 bits for seconds and 30 bits for
+ * nanoseconds. This is NOT the same as 32 bits for nanoseconds.
+ */
+#define KSZ_TSTAMP_SEC_MASK  GENMASK(31, 30)
+#define KSZ_TSTAMP_NSEC_MASK GENMASK(29, 0)
+
+#define KSZ9477_HWTS_EN  0
+
+struct ksz_device_ptp_shared {
+	/* protects ptp_clock_time (user space (various syscalls)
+	 * vs. softirq in ksz9477_rcv_timestamp()).
+	 */
+	spinlock_t ptp_clock_lock;
+	/* approximated current time, read once per second from hardware */
+	struct timespec64 ptp_clock_time;
+	unsigned long state;
+};
+
+struct ksz_port_ptp_shared {
+	struct ksz_device_ptp_shared *dev;
+	struct kthread_worker *xmit_worker;
+	struct kthread_work xmit_work;
+	struct sk_buff_head xmit_queue;
+};
+
+/* net/dsa/tag_ksz.c */
+static inline ktime_t ksz9477_decode_tstamp(u32 tstamp)
+{
+	u64 ns = FIELD_GET(KSZ_TSTAMP_SEC_MASK, tstamp) * NSEC_PER_SEC +
+		 FIELD_GET(KSZ_TSTAMP_NSEC_MASK, tstamp);
+
+	return ns_to_ktime(ns);
+}
+
+ktime_t ksz9477_tstamp_reconstruct(struct ksz_device_ptp_shared *ksz,
+				   ktime_t tstamp);
+
+struct ksz9477_skb_cb {
+	unsigned int ptp_type;
+	/* Do not cache pointer to PTP header between ksz9477_ptp_port_txtstamp
+	 * and ksz9xxx_xmit() (will become invalid during dsa_realloc_skb()).
+	 */
+	u8 ptp_msg_type;
+};
+
+#define KSZ9477_SKB_CB(skb) \
+	((struct ksz9477_skb_cb *)DSA_SKB_CB_PRIV(skb))
+
+#endif /* _NET_DSA_KSZ_COMMON_H_ */
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 4820dbcedfa2..0d324367ebec 100644
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
@@ -87,35 +91,212 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ8795);
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
 
+/* Time stamp tag is only inserted if PTP is enabled in hardware. */
+static void ksz9477_xmit_timestamp(struct sk_buff *skb)
+{
+	struct sk_buff *clone = DSA_SKB_CB(skb)->clone;
+	struct ptp_header *ptp_hdr;
+	unsigned int ptp_type;
+	u32 tstamp_raw = 0;
+	u8 ptp_msg_type;
+	s64 correction;
+
+	if (!clone)
+		goto out_put_tag;
+
+	/* Use cached PTP type from ksz9477_ptp_port_txtstamp().  */
+	ptp_type = KSZ9477_SKB_CB(clone)->ptp_type;
+	if (ptp_type == PTP_CLASS_NONE)
+		goto out_put_tag;
+
+	ptp_hdr = ptp_parse_header(skb, ptp_type);
+	if (!ptp_hdr)
+		goto out_put_tag;
+
+	ptp_msg_type = KSZ9477_SKB_CB(clone)->ptp_msg_type;
+	if (ptp_msg_type != PTP_MSGTYPE_PDELAY_RESP)
+		goto out_put_tag;
+
+	correction = (s64)get_unaligned_be64(&ptp_hdr->correction);
+
+	/* For PDelay_Resp messages we will likely have a negative value in the
+	 * correction field (see ksz9477_rcv()). The switch hardware cannot
+	 * correctly update such values (produces an off by one error in the UDP
+	 * checksum), so it must be moved to the time stamp field in the tail
+	 * tag.
+	 */
+	if (correction < 0) {
+		struct timespec64 ts;
+
+		/* Move ingress time stamp from PTP header's correction field to
+		 * tail tag. Format of the correction filed is 48 bit ns + 16
+		 * bit fractional ns.
+		 */
+		ts = ns_to_timespec64(-correction >> 16);
+		tstamp_raw = ((ts.tv_sec & 3) << 30) | ts.tv_nsec;
+
+		/* Set correction field to 0 and update UDP checksum.  */
+		ptp_header_update_correction(skb, ptp_type, ptp_hdr, 0);
+	}
+
+	/* For PDelay_Resp messages, the clone is not required in
+	 * skb_complete_tx_timestamp() and should be freed here.
+	 */
+	kfree_skb(clone);
+	DSA_SKB_CB(skb)->clone = NULL;
+
+out_put_tag:
+	put_unaligned_be32(tstamp_raw, skb_put(skb, KSZ9477_PTP_TAG_LEN));
+}
+
+/* Defer transmit if waiting for egress time stamp is required.  */
+static struct sk_buff *ksz9477_defer_xmit(struct dsa_port *dp,
+					  struct sk_buff *skb)
+{
+	struct ksz_port_ptp_shared *ptp_shared = dp->priv;
+	struct sk_buff *clone = DSA_SKB_CB(skb)->clone;
+	u8 ptp_msg_type;
+
+	if (!clone)
+		return skb;  /* no deferred xmit for this packet */
+
+	/* Use cached PTP msg type from ksz9477_ptp_port_txtstamp().  */
+	ptp_msg_type = KSZ9477_SKB_CB(clone)->ptp_msg_type;
+	if (ptp_msg_type != PTP_MSGTYPE_PDELAY_REQ)
+		goto out_free_clone;  /* only PDelay_Req is deferred */
+
+	/* Increase refcount so the kfree_skb in dsa_slave_xmit
+	 * won't really free the packet.
+	 */
+	skb_queue_tail(&ptp_shared->xmit_queue, skb_get(skb));
+	kthread_queue_work(ptp_shared->xmit_worker, &ptp_shared->xmit_work);
+
+	return NULL;
+
+out_free_clone:
+	kfree_skb(clone);
+	DSA_SKB_CB(skb)->clone = NULL;
+	return skb;
+}
+
+ktime_t ksz9477_tstamp_reconstruct(struct ksz_device_ptp_shared *ksz,
+				   ktime_t tstamp)
+{
+	struct timespec64 ts = ktime_to_timespec64(tstamp);
+	struct timespec64 ptp_clock_time;
+	struct timespec64 diff;
+
+	spin_lock_bh(&ksz->ptp_clock_lock);
+	ptp_clock_time = ksz->ptp_clock_time;
+	spin_unlock_bh(&ksz->ptp_clock_lock);
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
+EXPORT_SYMBOL(ksz9477_tstamp_reconstruct);
+
+static void ksz9477_rcv_timestamp(struct sk_buff *skb, u8 *tag,
+				  struct net_device *dev, unsigned int port)
+{
+	struct skb_shared_hwtstamps *hwtstamps = skb_hwtstamps(skb);
+	struct dsa_switch *ds = dev->dsa_ptr->ds;
+	struct ksz_port_ptp_shared *port_ptp_shared;
+	u8 *tstamp_raw = tag - KSZ9477_PTP_TAG_LEN;
+	struct ptp_header *ptp_hdr;
+	unsigned int ptp_type;
+	u8 ptp_msg_type;
+	ktime_t tstamp;
+	s64 correction;
+
+	port_ptp_shared = dsa_to_port(ds, port)->priv;
+	if (!port_ptp_shared)
+		return;
+
+	/* convert time stamp and write to skb */
+	tstamp = ksz9477_decode_tstamp(get_unaligned_be32(tstamp_raw));
+	memset(hwtstamps, 0, sizeof(*hwtstamps));
+	hwtstamps->hwtstamp = ksz9477_tstamp_reconstruct(port_ptp_shared->dev,
+							 tstamp);
+
+	/* For PDelay_Req messages, user space (ptp4l) expects that the hardware
+	 * subtracts the ingress time stamp from the correction field.  The
+	 * separate hw time stamp from the sk_buff struct will not be used in
+	 * this case.
+	 */
+
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
+	ptp_msg_type = ptp_get_msgtype(ptp_hdr, ptp_type);
+	if (ptp_msg_type != PTP_MSGTYPE_PDELAY_REQ)
+		return;
+
+	/* Only subtract the partial time stamp from the correction field.  When
+	 * the hardware adds the egress time stamp to the correction field of
+	 * the PDelay_Resp message on tx, also only the partial time stamp will
+	 * be added.
+	 */
+	correction = (s64)get_unaligned_be64(&ptp_hdr->correction);
+	correction -= ktime_to_ns(tstamp) << 16;
+
+	ptp_header_update_correction(skb, ptp_type, ptp_hdr, correction);
+}
+
 static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct ksz_port_ptp_shared *port_ptp_shared = dp->priv;
+	struct ksz_device_ptp_shared *ptp_shared = port_ptp_shared->dev;
 	__be16 *tag;
 	u8 *addr;
 	u16 val;
 
 	/* Tag encoding */
+	if (test_bit(KSZ9477_HWTS_EN, &ptp_shared->state))
+		ksz9477_xmit_timestamp(skb);
 	tag = skb_put(skb, KSZ9477_INGRESS_TAG_LEN);
 	addr = skb_mac_header(skb);
 
@@ -126,7 +307,7 @@ static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
 
 	*tag = cpu_to_be16(val);
 
-	return skb;
+	return ksz9477_defer_xmit(dp, skb);
 }
 
 static struct sk_buff *ksz9477_rcv(struct sk_buff *skb, struct net_device *dev,
@@ -138,8 +319,10 @@ static struct sk_buff *ksz9477_rcv(struct sk_buff *skb, struct net_device *dev,
 	unsigned int len = KSZ_EGRESS_TAG_LEN;
 
 	/* Extra 4-bytes PTP timestamp */
-	if (tag[0] & KSZ9477_PTP_TAG_INDICATION)
+	if (tag[0] & KSZ9477_PTP_TAG_INDICATION) {
+		ksz9477_rcv_timestamp(skb, tag, dev, port);
 		len += KSZ9477_PTP_TAG_LEN;
+	}
 
 	return ksz_common_rcv(skb, dev, port, len);
 }
@@ -149,7 +332,7 @@ static const struct dsa_device_ops ksz9477_netdev_ops = {
 	.proto	= DSA_TAG_PROTO_KSZ9477,
 	.xmit	= ksz9477_xmit,
 	.rcv	= ksz9477_rcv,
-	.overhead = KSZ9477_INGRESS_TAG_LEN,
+	.overhead = KSZ9477_INGRESS_TAG_LEN + KSZ9477_PTP_TAG_LEN,
 	.tail_tag = true,
 };
 
@@ -163,10 +346,14 @@ static struct sk_buff *ksz9893_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct ksz_port_ptp_shared *port_ptp_shared = dp->priv;
+	struct ksz_device_ptp_shared *ptp_shared = port_ptp_shared->dev;
 	u8 *addr;
 	u8 *tag;
 
 	/* Tag encoding */
+	if (test_bit(KSZ9477_HWTS_EN, &ptp_shared->state))
+		ksz9477_xmit_timestamp(skb);
 	tag = skb_put(skb, KSZ_INGRESS_TAG_LEN);
 	addr = skb_mac_header(skb);
 
@@ -175,7 +362,7 @@ static struct sk_buff *ksz9893_xmit(struct sk_buff *skb,
 	if (is_link_local_ether_addr(addr))
 		*tag |= KSZ9893_TAIL_TAG_OVERRIDE;
 
-	return skb;
+	return ksz9477_defer_xmit(dp, skb);
 }
 
 static const struct dsa_device_ops ksz9893_netdev_ops = {
@@ -183,7 +370,7 @@ static const struct dsa_device_ops ksz9893_netdev_ops = {
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

