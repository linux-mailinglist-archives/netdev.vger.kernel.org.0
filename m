Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C3544AAF0
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 10:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245084AbhKIJyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 04:54:04 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:35012 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245074AbhKIJxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 04:53:50 -0500
From:   Martin Kaistra <martin.kaistra@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636451462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xQswiKvKoyJnh7CLEzRLDmgSKq/tGhgbu7FVjEL+3G8=;
        b=wN0pMFKG5ZWI5QjMuGncMAgcKn5pZxNuIenHzW3tzyYwCrGaFckY+BWlY8WU7u5bXhFN1B
        xpXTJ3Ml2/VogoBa0Mlg3xYu+9WAIMbyqtIS9BHkRWrTy68Zolg+Zk6953DgdeCmwxt7ql
        HeVB3OTjY1UtgXB/Kgfd9v3y5716mbSE/hwy92wecTDhxtObBZ3J5fJBJEWDr8ucT2PXJc
        L5dwEq6O/MDmr1Kbgg6+wxsAOo64An89olRPVqP9S+iK2YcRu8jDlQh0Jk2CLSg2DbhmHj
        RjLVNurZYDuP4WL2+XKitvHK1CL6AKbmT7xmJIXaTMioeU2XfX6t4qRs59Zxtw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636451462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xQswiKvKoyJnh7CLEzRLDmgSKq/tGhgbu7FVjEL+3G8=;
        b=Xv92KSMwH1rDqdjROAnjFp0GZXDVFNXua3mNhkGhbf0SjXCjPD26dYvuPqB1z2JL5+9Hgb
        79TqYTw3yEDdHLCA==
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
Subject: [PATCH v2 5/7] net: dsa: b53: Add logic for RX timestamping
Date:   Tue,  9 Nov 2021 10:50:07 +0100
Message-Id: <20211109095013.27829-6-martin.kaistra@linutronix.de>
In-Reply-To: <20211109095013.27829-1-martin.kaistra@linutronix.de>
References: <20211109095013.27829-1-martin.kaistra@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Packets received by the tagger with opcode=1 contain the 32-bit timestamp
according to the timebase register. This timestamp is saved in
BRCM_SKB_CB(skb)->meta_tstamp. b53_port_rxtstamp() takes this
and puts the full time information from the timecounter into
shwt->hwtstamp.

Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
---
 drivers/net/dsa/b53/b53_common.c |  1 +
 drivers/net/dsa/b53/b53_ptp.c    | 28 +++++++++++++++++++++++++
 drivers/net/dsa/b53/b53_ptp.h    | 10 +++++++++
 include/linux/dsa/b53.h          | 30 +++++++++++++++++++++++++++
 net/dsa/tag_brcm.c               | 35 ++++++++++++++++++++++++--------
 5 files changed, 95 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index ed590efbd3bf..a9408f9cd414 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2300,6 +2300,7 @@ static const struct dsa_switch_ops b53_switch_ops = {
 	.port_max_mtu		= b53_get_max_mtu,
 	.port_change_mtu	= b53_change_mtu,
 	.get_ts_info		= b53_get_ts_info,
+	.port_rxtstamp		= b53_port_rxtstamp,
 };
 
 struct b53_chip_data {
diff --git a/drivers/net/dsa/b53/b53_ptp.c b/drivers/net/dsa/b53/b53_ptp.c
index 8629c510b1a0..f8dd8d484d93 100644
--- a/drivers/net/dsa/b53/b53_ptp.c
+++ b/drivers/net/dsa/b53/b53_ptp.c
@@ -6,6 +6,8 @@
  * Copyright (C) 2021 Linutronix GmbH
  */
 
+#include <linux/ptp_classify.h>
+
 #include "b53_priv.h"
 #include "b53_ptp.h"
 
@@ -106,6 +108,32 @@ static long b53_hwtstamp_work(struct ptp_clock_info *ptp)
 	return B53_PTP_OVERFLOW_PERIOD;
 }
 
+bool b53_port_rxtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb,
+		       unsigned int type)
+{
+	struct b53_device *dev = ds->priv;
+	struct b53_port_hwtstamp *ps = &dev->ports[port].port_hwtstamp;
+	struct skb_shared_hwtstamps *shwt;
+	u64 ns;
+
+	if (type != PTP_CLASS_V2_L2)
+		return false;
+
+	if (!test_bit(B53_HWTSTAMP_ENABLED, &ps->state))
+		return false;
+
+	mutex_lock(&dev->ptp_mutex);
+	ns = timecounter_cyc2time(&dev->tc, BRCM_SKB_CB(skb)->meta_tstamp);
+	mutex_unlock(&dev->ptp_mutex);
+
+	shwt = skb_hwtstamps(skb);
+	memset(shwt, 0, sizeof(*shwt));
+	shwt->hwtstamp = ns_to_ktime(ns);
+
+	return false;
+}
+EXPORT_SYMBOL(b53_port_rxtstamp);
+
 int b53_ptp_init(struct b53_device *dev)
 {
 	mutex_init(&dev->ptp_mutex);
diff --git a/drivers/net/dsa/b53/b53_ptp.h b/drivers/net/dsa/b53/b53_ptp.h
index 5cd2fd9621a2..3b3437870c55 100644
--- a/drivers/net/dsa/b53/b53_ptp.h
+++ b/drivers/net/dsa/b53/b53_ptp.h
@@ -9,11 +9,15 @@
 
 #include "b53_priv.h"
 
+#define SKB_PTP_TYPE(__skb) (*(unsigned int *)((__skb)->cb))
+
 #ifdef CONFIG_B53_PTP
 int b53_ptp_init(struct b53_device *dev);
 void b53_ptp_exit(struct b53_device *dev);
 int b53_get_ts_info(struct dsa_switch *ds, int port,
 		    struct ethtool_ts_info *info);
+bool b53_port_rxtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb,
+		       unsigned int type);
 #else /* !CONFIG_B53_PTP */
 
 static inline int b53_ptp_init(struct b53_device *dev)
@@ -31,5 +35,11 @@ static inline int b53_get_ts_info(struct dsa_switch *ds, int port,
 	return -EOPNOTSUPP;
 }
 
+static inline bool b53_port_rxtstamp(struct dsa_switch *ds, int port,
+				     struct sk_buff *skb, unsigned int type)
+{
+	return false;
+}
+
 #endif
 #endif
diff --git a/include/linux/dsa/b53.h b/include/linux/dsa/b53.h
index 85aa6d9dc53d..542e5e3040d6 100644
--- a/include/linux/dsa/b53.h
+++ b/include/linux/dsa/b53.h
@@ -46,9 +46,32 @@ struct b53_io_ops {
 					struct phylink_link_state *state);
 };
 
+/* state flags for b53_port_hwtstamp::state */
+enum {
+	B53_HWTSTAMP_ENABLED,
+	B53_HWTSTAMP_TX_IN_PROGRESS,
+};
+
+struct b53_port_hwtstamp {
+	/* Port index */
+	int port_id;
+
+	/* Timestamping state */
+	unsigned long state;
+
+	/* Resources for transmit timestamping */
+	unsigned long tx_tstamp_start;
+	struct sk_buff *tx_skb;
+
+	/* Current timestamp configuration */
+	struct hwtstamp_config tstamp_config;
+};
+
 struct b53_port {
 	u16 vlan_ctl_mask;
 	struct ethtool_eee eee;
+	/* Per-port timestamping resources */
+	struct b53_port_hwtstamp port_hwtstamp;
 };
 
 struct b53_vlan {
@@ -112,3 +135,10 @@ struct b53_device {
 #define B53_PTP_OVERFLOW_PERIOD (HZ / 2)
 	struct delayed_work overflow_work;
 };
+
+struct brcm_skb_cb {
+	struct sk_buff *clone;
+	u32 meta_tstamp;
+};
+
+#define BRCM_SKB_CB(skb) ((struct brcm_skb_cb *)(skb)->cb)
diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index 96dbb8ee2fee..d611c1073deb 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -9,6 +9,7 @@
 #include <linux/etherdevice.h>
 #include <linux/list.h>
 #include <linux/slab.h>
+#include <linux/dsa/b53.h>
 
 #include "dsa_priv.h"
 
@@ -31,7 +32,10 @@
 /* 6th byte in the tag */
 #define BRCM_LEG_PORT_ID	(0xf)
 
-/* Newer Broadcom tag (4 bytes) */
+/* Newer Broadcom tag (4 bytes)
+ * For egress, when opcode = 0001, additional 4 bytes are used for
+ * the time stamp.
+ */
 #define BRCM_TAG_LEN	4
 
 /* Tag is constructed and desconstructed using byte by byte access
@@ -136,19 +140,29 @@ static struct sk_buff *brcm_tag_xmit_ll(struct sk_buff *skb,
  */
 static struct sk_buff *brcm_tag_rcv_ll(struct sk_buff *skb,
 				       struct net_device *dev,
-				       unsigned int offset)
+				       unsigned int offset,
+				       int *tag_len)
 {
 	int source_port;
 	u8 *brcm_tag;
+	u32 tstamp;
+
+	*tag_len = 8;
 
 	if (unlikely(!pskb_may_pull(skb, BRCM_TAG_LEN)))
 		return NULL;
 
 	brcm_tag = skb->data - offset;
 
-	/* The opcode should never be different than 0b000 */
-	if (unlikely((brcm_tag[0] >> BRCM_OPCODE_SHIFT) & BRCM_OPCODE_MASK))
-		return NULL;
+	if ((brcm_tag[0] >> BRCM_OPCODE_SHIFT) & BRCM_OPCODE_MASK) {
+		if (unlikely(!pskb_may_pull(skb, *tag_len)))
+			return NULL;
+
+		tstamp = brcm_tag[4] << 24 | brcm_tag[5] << 16 | brcm_tag[6] << 8 | brcm_tag[7];
+		BRCM_SKB_CB(skb)->meta_tstamp = tstamp;
+	} else {
+		*tag_len = BRCM_TAG_LEN;
+	}
 
 	/* We should never see a reserved reason code without knowing how to
 	 * handle it
@@ -164,7 +178,7 @@ static struct sk_buff *brcm_tag_rcv_ll(struct sk_buff *skb,
 		return NULL;
 
 	/* Remove Broadcom tag and update checksum */
-	skb_pull_rcsum(skb, BRCM_TAG_LEN);
+	skb_pull_rcsum(skb, *tag_len);
 
 	dsa_default_offload_fwd_mark(skb);
 
@@ -184,13 +198,14 @@ static struct sk_buff *brcm_tag_xmit(struct sk_buff *skb,
 static struct sk_buff *brcm_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 {
 	struct sk_buff *nskb;
+	int tag_len;
 
 	/* skb->data points to the EtherType, the tag is right before it */
-	nskb = brcm_tag_rcv_ll(skb, dev, 2);
+	nskb = brcm_tag_rcv_ll(skb, dev, 2, &tag_len);
 	if (!nskb)
 		return nskb;
 
-	dsa_strip_etype_header(skb, BRCM_TAG_LEN);
+	dsa_strip_etype_header(skb, tag_len);
 
 	return nskb;
 }
@@ -295,8 +310,10 @@ static struct sk_buff *brcm_tag_xmit_prepend(struct sk_buff *skb,
 static struct sk_buff *brcm_tag_rcv_prepend(struct sk_buff *skb,
 					    struct net_device *dev)
 {
+	int tag_len;
+
 	/* tag is prepended to the packet */
-	return brcm_tag_rcv_ll(skb, dev, ETH_HLEN);
+	return brcm_tag_rcv_ll(skb, dev, ETH_HLEN, &tag_len);
 }
 
 static const struct dsa_device_ops brcm_prepend_netdev_ops = {
-- 
2.20.1

