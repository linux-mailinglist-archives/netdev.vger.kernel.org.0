Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8474453F1
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 14:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbhKDNgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 09:36:17 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:34530 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbhKDNfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 09:35:54 -0400
From:   Martin Kaistra <martin.kaistra@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636032795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=blfXNb0qFxMH8GA3oEExJwrE9QKf8UjDNqRg8HeRJrI=;
        b=X+iG11NkYA9UPAVCXteqP+fF2Em6PUOZuItHcf9eAHpmub7kCW5mTku88+srmt3WnEXS3C
        5Z6YTQ2yCLy/VVhtHPpYNybkriZA1XhqOgHFXqTGNUplPR1OCjt6jsluDbezNpcvmpVGU8
        wUPrEBzIRhJU7qGCW+Xy1VkQ5Plva/vx/gUUJur5ZKPHFDwgXu1cO851dh8jU2ARKvDecm
        MmqnvR+UQiFoBrF8gSWSi85ZUwU+xbcUS7y3g1aeAKW07XZZGQDOaH9LvfWwkBYEJaIpw3
        /6auNgbGMhaVgUOMyurKVjPupoUDG46C+ZCpS5UZcY/2rk5+dsw84MX+OZ4mvw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636032795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=blfXNb0qFxMH8GA3oEExJwrE9QKf8UjDNqRg8HeRJrI=;
        b=/ItzVzAmeaML10r9iJdsG6ubw23X5lGcvjq3ymFNRqhm2Y+bL7U3PJljMjt8hQ+6DvWEIV
        Vcyn8Hp86s3r19BQ==
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
Subject: [PATCH 6/7] net: dsa: b53: Add logic for TX timestamping
Date:   Thu,  4 Nov 2021 14:32:00 +0100
Message-Id: <20211104133204.19757-7-martin.kaistra@linutronix.de>
In-Reply-To: <20211104133204.19757-1-martin.kaistra@linutronix.de>
References: <20211104133204.19757-1-martin.kaistra@linutronix.de>
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
 drivers/net/dsa/b53/b53_ptp.c    | 59 ++++++++++++++++++++++++++++++++
 drivers/net/dsa/b53/b53_ptp.h    |  9 +++++
 net/dsa/tag_brcm.c               | 51 +++++++++++++++++++++++++++
 4 files changed, 120 insertions(+)

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
index 86ebaa522084..7cb4d1c9d6f7 100644
--- a/drivers/net/dsa/b53/b53_ptp.c
+++ b/drivers/net/dsa/b53/b53_ptp.c
@@ -109,6 +109,64 @@ static void b53_ptp_overflow_check(struct work_struct *work)
 	schedule_delayed_work(&dev->overflow_work, B53_PTP_OVERFLOW_PERIOD);
 }
 
+static long b53_hwtstamp_work(struct ptp_clock_info *ptp)
+{
+	struct b53_device *dev =
+		container_of(ptp, struct b53_device, ptp_clock_info);
+	struct dsa_switch *ds = dev->ds;
+	int i;
+
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
+	return -1;
+}
+
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
+
 bool b53_port_rxtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb,
 		       unsigned int type)
 {
@@ -172,6 +230,7 @@ int b53_ptp_init(struct b53_device *dev)
 	dev->ptp_clock_info.gettime64 = b53_ptp_gettime;
 	dev->ptp_clock_info.settime64 = b53_ptp_settime;
 	dev->ptp_clock_info.enable = b53_ptp_enable;
+	dev->ptp_clock_info.do_aux_work = b53_hwtstamp_work;
 
 	dev->ptp_clock = ptp_clock_register(&dev->ptp_clock_info, dev->dev);
 	if (IS_ERR(dev->ptp_clock))
diff --git a/drivers/net/dsa/b53/b53_ptp.h b/drivers/net/dsa/b53/b53_ptp.h
index 3b3437870c55..c76e3f4018d0 100644
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
@@ -41,5 +44,11 @@ static inline bool b53_port_rxtstamp(struct dsa_switch *ds, int port,
 	return false;
 }
 
+static inline bool b53_port_txtstamp(struct dsa_switch *ds, int port,
+				     struct sk_buff *skb)
+{
+	return false;
+}
+
 #endif
 #endif
diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index 85dc47c22008..53cd0345df1b 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -8,6 +8,7 @@
 #include <linux/dsa/brcm.h>
 #include <linux/etherdevice.h>
 #include <linux/list.h>
+#include <linux/ptp_classify.h>
 #include <linux/slab.h>
 #include <linux/dsa/b53.h>
 
@@ -85,9 +86,14 @@ static struct sk_buff *brcm_tag_xmit_ll(struct sk_buff *skb,
 					unsigned int offset)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct b53_device *b53_dev = dp->ds->priv;
+	unsigned int type = ptp_classify_raw(skb);
 	u16 queue = skb_get_queue_mapping(skb);
+	struct b53_port_hwtstamp *ps;
 	u8 *brcm_tag;
 
+	ps = &b53_dev->ports[dp->index].port_hwtstamp;
+
 	/* The Ethernet switch we are interfaced with needs packets to be at
 	 * least 64 bytes (including FCS) otherwise they will be discarded when
 	 * they enter the switch port logic. When Broadcom tags are enabled, we
@@ -112,7 +118,13 @@ static struct sk_buff *brcm_tag_xmit_ll(struct sk_buff *skb,
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
@@ -126,6 +138,32 @@ static struct sk_buff *brcm_tag_xmit_ll(struct sk_buff *skb,
 	return skb;
 }
 
+static int set_txtstamp(struct b53_device *dev,
+			struct b53_port_hwtstamp *ps,
+			int port,
+			u64 ns)
+{
+	struct skb_shared_hwtstamps shhwtstamps;
+	struct sk_buff *tmp_skb;
+
+	if (!ps->tx_skb)
+		return 0;
+
+	mutex_lock(&dev->ptp_mutex);
+	ns = timecounter_cyc2time(&dev->tc, ns);
+	mutex_unlock(&dev->ptp_mutex);
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
@@ -143,6 +181,9 @@ static struct sk_buff *brcm_tag_rcv_ll(struct sk_buff *skb,
 				       unsigned int offset,
 				       int *tag_len)
 {
+	struct b53_port_hwtstamp *ps;
+	struct b53_device *b53_dev;
+	struct dsa_port *dp;
 	int source_port;
 	u8 *brcm_tag;
 	u32 tstamp;
@@ -174,6 +215,16 @@ static struct sk_buff *brcm_tag_rcv_ll(struct sk_buff *skb,
 	if (!skb->dev)
 		return NULL;
 
+	/* Check whether this is a status frame */
+	if (*tag_len == 8 && brcm_tag[3] & 0x20) {
+		dp = dsa_slave_to_port(skb->dev);
+		b53_dev = dp->ds->priv;
+		ps = &b53_dev->ports[source_port].port_hwtstamp;
+
+		set_txtstamp(b53_dev, ps, source_port, tstamp);
+		return NULL;
+	}
+
 	/* Remove Broadcom tag and update checksum */
 	skb_pull_rcsum(skb, *tag_len);
 
-- 
2.20.1

