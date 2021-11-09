Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D4C44AAF2
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 10:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245113AbhKIJyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 04:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245106AbhKIJxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 04:53:54 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D05FC0613B9;
        Tue,  9 Nov 2021 01:51:08 -0800 (PST)
From:   Martin Kaistra <martin.kaistra@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636451467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nJgE1Oggh7wQq8N7HhcPzV1VqckTR+2ntDU2O4TJk/M=;
        b=qpEkXcDqcisjbA0djXVk7UFyyyEuftY8gGBx6d+Xb2znpjdk0LLIy7MUx/K40BuZUfA//h
        U5/IEEV1Jww+QsPbNqo11mKV6jWfYyDobR0bkeaKRxFk7uDA2igg68ZRLz/EGyMiehQ07d
        6KwapMaXWc/7lW6O4jau9xXCgZoIHUHTI/JqtPGid9w7E9Ip9jqk8PhmaHdhTKN78nX5YE
        vNGCzWCNyFPGo7At7Cs50+EsN6z8cYOkPvK79tyQiWH+vjEMKWCIcjgLiaGc8QvIscIBri
        PR52quUfCaNeiEdnWE4CHrmC4GO59USTtthZ0yiu7sScu5BUjcKpOIpf6qu/Zw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636451467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nJgE1Oggh7wQq8N7HhcPzV1VqckTR+2ntDU2O4TJk/M=;
        b=PKn/t/688GQmkta1UU9vAAHPxf2YZ+2RygAKrOlWZfKvIAH+wmQ/MTocRtTXYTfje+mZlo
        nrviuW02Uw2pTxCQ==
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     martin.kaistra@linutronix.de,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 6/7] net: dsa: b53: Add logic for TX timestamping
Date:   Tue,  9 Nov 2021 10:50:08 +0100
Message-Id: <20211109095013.27829-7-martin.kaistra@linutronix.de>
In-Reply-To: <20211109095013.27829-1-martin.kaistra@linutronix.de>
References: <20211109095013.27829-1-martin.kaistra@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to get the switch to generate a timestamp for a transmitted
packet, we need to set the TS bit in the BRCM tag. The switch will then
create a status frame, which gets send back to the cpu.
In b53_port_txtstamp() we put the skb into a waiting position.

When a status frame is received, we extract the timestamp and put the time
according to our timecounter into the waiting skb. When
TX_TSTAMP_TIMEOUT is reached and we have no means to correctly get back
a full timestamp, we cancel the process.

As the status frame doesn't contain a reference to the original packet,
only one packet with timestamp request can be sent at a time.

Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
---
 drivers/net/dsa/b53/b53_common.c |  1 +
 drivers/net/dsa/b53/b53_ptp.c    | 56 ++++++++++++++++++++++++++++++++
 drivers/net/dsa/b53/b53_ptp.h    |  8 +++++
 net/dsa/tag_brcm.c               | 46 ++++++++++++++++++++++++++
 4 files changed, 111 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index a9408f9cd414..56a9de89b38b 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2301,6 +2301,7 @@ static const struct dsa_switch_ops b53_switch_ops = {
 	.port_change_mtu	= b53_change_mtu,
 	.get_ts_info		= b53_get_ts_info,
 	.port_rxtstamp		= b53_port_rxtstamp,
+	.port_txtstamp		= b53_port_txtstamp,
 };
 
 struct b53_chip_data {
diff --git a/drivers/net/dsa/b53/b53_ptp.c b/drivers/net/dsa/b53/b53_ptp.c
index f8dd8d484d93..5567135ba8b9 100644
--- a/drivers/net/dsa/b53/b53_ptp.c
+++ b/drivers/net/dsa/b53/b53_ptp.c
@@ -100,14 +100,65 @@ static long b53_hwtstamp_work(struct ptp_clock_info *ptp)
 {
 	struct b53_device *dev =
 		container_of(ptp, struct b53_device, ptp_clock_info);
+	struct dsa_switch *ds = dev->ds;
+	int i;
 
 	mutex_lock(&dev->ptp_mutex);
 	timecounter_read(&dev->tc);
 	mutex_unlock(&dev->ptp_mutex);
 
+	for (i = 0; i < ds->num_ports; i++) {
+		struct b53_port_hwtstamp *ps;
+
+		if (!dsa_is_user_port(ds, i))
+			continue;
+
+		ps = &dev->ports[i].port_hwtstamp;
+
+		if (test_bit(B53_HWTSTAMP_TX_IN_PROGRESS, &ps->state) &&
+		    time_is_before_jiffies(ps->tx_tstamp_start +
+					   TX_TSTAMP_TIMEOUT)) {
+			dev_err(dev->dev,
+				"Timeout while waiting for Tx timestamp!\n");
+			dev_kfree_skb_any(ps->tx_skb);
+			ps->tx_skb = NULL;
+			clear_bit_unlock(B53_HWTSTAMP_TX_IN_PROGRESS,
+					 &ps->state);
+		}
+	}
+
 	return B53_PTP_OVERFLOW_PERIOD;
 }
 
+void b53_port_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
+{
+	struct b53_device *dev = ds->priv;
+	struct b53_port_hwtstamp *ps = &dev->ports[port].port_hwtstamp;
+	struct sk_buff *clone;
+	unsigned int type;
+
+	type = ptp_classify_raw(skb);
+
+	if (type != PTP_CLASS_V2_L2)
+		return;
+
+	if (!test_bit(B53_HWTSTAMP_ENABLED, &ps->state))
+		return;
+
+	clone = skb_clone_sk(skb);
+	if (!clone)
+		return;
+
+	if (test_and_set_bit_lock(B53_HWTSTAMP_TX_IN_PROGRESS, &ps->state)) {
+		kfree_skb(clone);
+		return;
+	}
+
+	ps->tx_skb = clone;
+	ps->tx_tstamp_start = jiffies;
+}
+EXPORT_SYMBOL(b53_port_txtstamp);
+
 bool b53_port_rxtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb,
 		       unsigned int type)
 {
@@ -136,6 +187,8 @@ EXPORT_SYMBOL(b53_port_rxtstamp);
 
 int b53_ptp_init(struct b53_device *dev)
 {
+	struct dsa_port *dp;
+
 	mutex_init(&dev->ptp_mutex);
 
 	/* Enable BroadSync HD for all ports */
@@ -191,6 +244,9 @@ int b53_ptp_init(struct b53_device *dev)
 
 	ptp_schedule_worker(dev->ptp_clock, 0);
 
+	dsa_switch_for_each_port(dp, dev->ds)
+		dp->priv = &dev->ports[dp->index].port_hwtstamp;
+
 	return 0;
 }
 EXPORT_SYMBOL(b53_ptp_init);
diff --git a/drivers/net/dsa/b53/b53_ptp.h b/drivers/net/dsa/b53/b53_ptp.h
index 3b3437870c55..f888f0a2022a 100644
--- a/drivers/net/dsa/b53/b53_ptp.h
+++ b/drivers/net/dsa/b53/b53_ptp.h
@@ -10,6 +10,7 @@
 #include "b53_priv.h"
 
 #define SKB_PTP_TYPE(__skb) (*(unsigned int *)((__skb)->cb))
+#define TX_TSTAMP_TIMEOUT msecs_to_jiffies(40)
 
 #ifdef CONFIG_B53_PTP
 int b53_ptp_init(struct b53_device *dev);
@@ -18,6 +19,8 @@ int b53_get_ts_info(struct dsa_switch *ds, int port,
 		    struct ethtool_ts_info *info);
 bool b53_port_rxtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb,
 		       unsigned int type);
+void b53_port_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb);
+
 #else /* !CONFIG_B53_PTP */
 
 static inline int b53_ptp_init(struct b53_device *dev)
@@ -41,5 +44,10 @@ static inline bool b53_port_rxtstamp(struct dsa_switch *ds, int port,
 	return false;
 }
 
+static inline void b53_port_txtstamp(struct dsa_switch *ds, int port,
+				     struct sk_buff *skb)
+{
+}
+
 #endif
 #endif
diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index d611c1073deb..a44ac81fa097 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -8,6 +8,7 @@
 #include <linux/dsa/brcm.h>
 #include <linux/etherdevice.h>
 #include <linux/list.h>
+#include <linux/ptp_classify.h>
 #include <linux/slab.h>
 #include <linux/dsa/b53.h>
 
@@ -76,6 +77,7 @@
 #define BRCM_EG_TC_SHIFT	5
 #define BRCM_EG_TC_MASK		0x7
 #define BRCM_EG_PID_MASK	0x1f
+#define BRCM_EG_T_R		0x20
 
 #if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM) || \
 	IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM_PREPEND)
@@ -85,6 +87,8 @@ static struct sk_buff *brcm_tag_xmit_ll(struct sk_buff *skb,
 					unsigned int offset)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	unsigned int type = ptp_classify_raw(skb);
+	struct b53_port_hwtstamp *ps = dp->priv;
 	u16 queue = skb_get_queue_mapping(skb);
 	u8 *brcm_tag;
 
@@ -112,7 +116,13 @@ static struct sk_buff *brcm_tag_xmit_ll(struct sk_buff *skb,
 	 */
 	brcm_tag[0] = (1 << BRCM_OPCODE_SHIFT) |
 		       ((queue & BRCM_IG_TC_MASK) << BRCM_IG_TC_SHIFT);
+
 	brcm_tag[1] = 0;
+
+	if (type == PTP_CLASS_V2_L2 &&
+	    test_bit(B53_HWTSTAMP_TX_IN_PROGRESS, &ps->state))
+		brcm_tag[1] = 1 << BRCM_IG_TS_SHIFT;
+
 	brcm_tag[2] = 0;
 	if (dp->index == 8)
 		brcm_tag[2] = BRCM_IG_DSTMAP2_MASK;
@@ -126,6 +136,33 @@ static struct sk_buff *brcm_tag_xmit_ll(struct sk_buff *skb,
 	return skb;
 }
 
+static int set_txtstamp(struct dsa_port *dp,
+			int port,
+			u64 ns)
+{
+	struct b53_device *b53_dev = dp->ds->priv;
+	struct b53_port_hwtstamp *ps = dp->priv;
+	struct skb_shared_hwtstamps shhwtstamps;
+	struct sk_buff *tmp_skb;
+
+	if (!ps->tx_skb)
+		return 0;
+
+	mutex_lock(&b53_dev->ptp_mutex);
+	ns = timecounter_cyc2time(&b53_dev->tc, ns);
+	mutex_unlock(&b53_dev->ptp_mutex);
+
+	memset(&shhwtstamps, 0, sizeof(shhwtstamps));
+	shhwtstamps.hwtstamp = ns_to_ktime(ns);
+	tmp_skb = ps->tx_skb;
+	ps->tx_skb = NULL;
+
+	clear_bit_unlock(B53_HWTSTAMP_TX_IN_PROGRESS, &ps->state);
+	skb_complete_tx_timestamp(tmp_skb, &shhwtstamps);
+
+	return 0;
+}
+
 /* Frames with this tag have one of these two layouts:
  * -----------------------------------
  * | MAC DA | MAC SA | 4b tag | Type | DSA_TAG_PROTO_BRCM
@@ -143,6 +180,7 @@ static struct sk_buff *brcm_tag_rcv_ll(struct sk_buff *skb,
 				       unsigned int offset,
 				       int *tag_len)
 {
+	struct dsa_port *dp;
 	int source_port;
 	u8 *brcm_tag;
 	u32 tstamp;
@@ -177,6 +215,14 @@ static struct sk_buff *brcm_tag_rcv_ll(struct sk_buff *skb,
 	if (!skb->dev)
 		return NULL;
 
+	/* Check whether this is a status frame */
+	if (unlikely(*tag_len == 8 && brcm_tag[3] & BRCM_EG_T_R)) {
+		dp = dsa_slave_to_port(skb->dev);
+
+		set_txtstamp(dp, source_port, tstamp);
+		return NULL;
+	}
+
 	/* Remove Broadcom tag and update checksum */
 	skb_pull_rcsum(skb, *tag_len);
 
-- 
2.20.1

