Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46E4F2D29A
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 01:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbfE1X7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 19:59:00 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37999 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727254AbfE1X6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 19:58:34 -0400
Received: by mail-wr1-f68.google.com with SMTP id d18so360268wrs.5;
        Tue, 28 May 2019 16:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KCLmz7y6JXIGD9HL/yvSjQMMl1pjsWsMQoiJDadVVf0=;
        b=pZ+rTLVIK9a0HpAwDNaHKNh46ppkz96fYsW6C7ezfPu0q6kuB3vuHj0hibzeeLGBMl
         6LL5blavGUQF1Q/EvBe5wHe0CMppDjvx45pbUYLCHiT+qdVD0WnDsVqoC69f6AouDGOe
         TaU0knZJYZaqcq34vWFIVA9sYAYNzzLXwqN6V34xjhIeB3twukR79lEnQTj1c/GFUAdZ
         Q/j7ZJaygK5Uf0QqiCm8daBsXnElg8FcKvn5eGnVDmkN8rRbXKZU+x0PO8DSBAYOV2BX
         cJu9UKSwWg5q4wb+v16YSHKS4CAqOVxZSnUq0gBsx0A3nV1ncC98QbDe/ZK7zI8ndHK1
         mNMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KCLmz7y6JXIGD9HL/yvSjQMMl1pjsWsMQoiJDadVVf0=;
        b=HjTVJ8ZhKo/a0pNYPqvPa9MvC+HQ2mIDKNQ+YlYmy9Qo94LpAVMeZ0sotWxmlxxoKF
         tkzKH1fMqpAR3pcGOFceExIY4QPXPjogWU6EJ20arNeGPN8+pdEKOtgvMwoDoYBEp9SA
         0o/nB0tGiDFRjx18KxT+2NFvtvJYCQAkNlEZVmhafhwwmxA25C37/6o7JH/aUwTxCzkR
         BD8XIYWkqwIrjCt1viswaL1hc54i08SeWRoNeVYQtSzUWzzRA5m/btoyzJywdUAJEDoE
         xc0yeKnUzaVXL536WsQr2tsRPD+mz/yAJP9nKF7X0mqnnPACfysOJbKnIdA4Fpwcytg9
         L5AA==
X-Gm-Message-State: APjAAAUN9/nm+g+bopKNLsYuDq/DPpReRwa5u/EwumXO5EoS1grWmQWg
        sDODnrt7zrmekp6uI1S3vzz4V4ZF1RI=
X-Google-Smtp-Source: APXvYqxlPvtMHF687PCS8JlwuGIqVDTHozyf5X8FjbfQii6bJEvelJxC9ZF2q19R/8jP2OJi9OzQtg==
X-Received: by 2002:adf:cf03:: with SMTP id o3mr16472965wrj.5.1559087911071;
        Tue, 28 May 2019 16:58:31 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id f3sm1207505wre.93.2019.05.28.16.58.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 16:58:30 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 3/5] net: dsa: mv88e6xxx: Let taggers specify a can_timestamp function
Date:   Wed, 29 May 2019 02:56:25 +0300
Message-Id: <20190528235627.1315-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190528235627.1315-1-olteanv@gmail.com>
References: <20190528235627.1315-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The newly introduced function is called on both the RX and TX paths.

The boolean returned by port_txtstamp should only return false if the
driver tried to timestamp the skb but failed.

Currently there is some logic in the mv88e6xxx driver that determines
whether it should timestamp frames or not.

This is wasteful, because if the decision is to not timestamp them, then
DSA will have cloned an skb and freed it immediately afterwards.

Additionally other drivers (sja1105) may have other hardware criteria
for timestamping frames on RX, and the default conditions for
timestamping a frame are too restrictive.  When RX timestamping is
enabled, the sja1105 hardware emits a follow-up frame containing the
timestamp for every trapped link-local frame.  Then the link-local frame
is queued up inside the port_rxtstamp callback where it waits for its
follow-up meta frame to come.  But only a subset of the link-local
frames will pass through DSA's default filter for port_rxtstamp, so the
rest of the link-local traffic would still receive a meta frame but
would not get timestamped.

Since the state machine of waiting for meta frames is implemented in the
tagger rcv function for sja1105, it is difficult to know which frames
will pass through DSA's later filter and which won't.  And since
timestamping more frames than just PTP does no harm, just implement a
callback for sja1105 that will say that all link-local traffic will be
timestamped on RX.

PTP classification on the skb is still performed.  But now it is saved
to the DSA_SKB_CB, so drivers can reuse it without calling it again.

The mv88e6xxx driver was also modified to use the new generic
DSA_SKB_CB(skb)->ptp_type instead of its own, custom SKB_PTP_TYPE(skb).

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/hwtstamp.c | 25 +++++++++----------------
 drivers/net/dsa/mv88e6xxx/hwtstamp.h |  4 ++--
 include/net/dsa.h                    |  6 ++++--
 net/dsa/dsa.c                        | 25 +++++++++++++++----------
 net/dsa/slave.c                      | 20 ++++++++++++++------
 5 files changed, 44 insertions(+), 36 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/hwtstamp.c b/drivers/net/dsa/mv88e6xxx/hwtstamp.c
index a17c16a2ab78..3295ad10818f 100644
--- a/drivers/net/dsa/mv88e6xxx/hwtstamp.c
+++ b/drivers/net/dsa/mv88e6xxx/hwtstamp.c
@@ -20,8 +20,6 @@
 #include "ptp.h"
 #include <linux/ptp_classify.h>
 
-#define SKB_PTP_TYPE(__skb) (*(unsigned int *)((__skb)->cb))
-
 static int mv88e6xxx_port_ptp_read(struct mv88e6xxx_chip *chip, int port,
 				   int addr, u16 *data, int len)
 {
@@ -216,8 +214,9 @@ int mv88e6xxx_port_hwtstamp_get(struct dsa_switch *ds, int port,
 }
 
 /* Get the start of the PTP header in this skb */
-static u8 *parse_ptp_header(struct sk_buff *skb, unsigned int type)
+static u8 *parse_ptp_header(struct sk_buff *skb)
 {
+	unsigned int type = DSA_SKB_CB(skb)->ptp_type;
 	u8 *data = skb_mac_header(skb);
 	unsigned int offset = 0;
 
@@ -249,7 +248,7 @@ static u8 *parse_ptp_header(struct sk_buff *skb, unsigned int type)
  * or NULL if the caller should not.
  */
 static u8 *mv88e6xxx_should_tstamp(struct mv88e6xxx_chip *chip, int port,
-				   struct sk_buff *skb, unsigned int type)
+				   struct sk_buff *skb)
 {
 	struct mv88e6xxx_port_hwtstamp *ps = &chip->port_hwtstamp[port];
 	u8 *hdr;
@@ -257,7 +256,7 @@ static u8 *mv88e6xxx_should_tstamp(struct mv88e6xxx_chip *chip, int port,
 	if (!chip->info->ptp_support)
 		return NULL;
 
-	hdr = parse_ptp_header(skb, type);
+	hdr = parse_ptp_header(skb);
 	if (!hdr)
 		return NULL;
 
@@ -278,8 +277,7 @@ static int mv88e6xxx_ts_valid(u16 status)
 
 static int seq_match(struct sk_buff *skb, u16 ts_seqid)
 {
-	unsigned int type = SKB_PTP_TYPE(skb);
-	u8 *hdr = parse_ptp_header(skb, type);
+	u8 *hdr = parse_ptp_header(skb);
 	__be16 *seqid;
 
 	seqid = (__be16 *)(hdr + OFF_PTP_SEQUENCE_ID);
@@ -367,7 +365,7 @@ static int is_pdelay_resp(u8 *msgtype)
 }
 
 bool mv88e6xxx_port_rxtstamp(struct dsa_switch *ds, int port,
-			     struct sk_buff *skb, unsigned int type)
+			     struct sk_buff *skb)
 {
 	struct mv88e6xxx_port_hwtstamp *ps;
 	struct mv88e6xxx_chip *chip;
@@ -379,12 +377,10 @@ bool mv88e6xxx_port_rxtstamp(struct dsa_switch *ds, int port,
 	if (ps->tstamp_config.rx_filter != HWTSTAMP_FILTER_PTP_V2_EVENT)
 		return false;
 
-	hdr = mv88e6xxx_should_tstamp(chip, port, skb, type);
+	hdr = mv88e6xxx_should_tstamp(chip, port, skb);
 	if (!hdr)
 		return false;
 
-	SKB_PTP_TYPE(skb) = type;
-
 	if (is_pdelay_resp(hdr))
 		skb_queue_tail(&ps->rx_queue2, skb);
 	else
@@ -503,17 +499,14 @@ long mv88e6xxx_hwtstamp_work(struct ptp_clock_info *ptp)
 }
 
 bool mv88e6xxx_port_txtstamp(struct dsa_switch *ds, int port,
-			     struct sk_buff *clone, unsigned int type)
+			     struct sk_buff *clone)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	struct mv88e6xxx_port_hwtstamp *ps = &chip->port_hwtstamp[port];
 	__be16 *seq_ptr;
 	u8 *hdr;
 
-	if (!(skb_shinfo(clone)->tx_flags & SKBTX_HW_TSTAMP))
-		return false;
-
-	hdr = mv88e6xxx_should_tstamp(chip, port, clone, type);
+	hdr = mv88e6xxx_should_tstamp(chip, port, clone);
 	if (!hdr)
 		return false;
 
diff --git a/drivers/net/dsa/mv88e6xxx/hwtstamp.h b/drivers/net/dsa/mv88e6xxx/hwtstamp.h
index b9a72661bcc4..17caf374332b 100644
--- a/drivers/net/dsa/mv88e6xxx/hwtstamp.h
+++ b/drivers/net/dsa/mv88e6xxx/hwtstamp.h
@@ -120,9 +120,9 @@ int mv88e6xxx_port_hwtstamp_get(struct dsa_switch *ds, int port,
 				struct ifreq *ifr);
 
 bool mv88e6xxx_port_rxtstamp(struct dsa_switch *ds, int port,
-			     struct sk_buff *clone, unsigned int type);
+			     struct sk_buff *clone);
 bool mv88e6xxx_port_txtstamp(struct dsa_switch *ds, int port,
-			     struct sk_buff *clone, unsigned int type);
+			     struct sk_buff *clone);
 
 int mv88e6xxx_get_ts_info(struct dsa_switch *ds, int port,
 			  struct ethtool_ts_info *info);
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 685294817712..2fd844688f83 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -76,6 +76,7 @@ struct dsa_device_ops {
 	 * as regular on the master net device.
 	 */
 	bool (*filter)(const struct sk_buff *skb, struct net_device *dev);
+	bool (*can_tstamp)(const struct sk_buff *skb, struct net_device *dev);
 	unsigned int overhead;
 	const char *name;
 	enum dsa_tag_protocol proto;
@@ -87,6 +88,7 @@ struct dsa_device_ops {
 
 struct dsa_skb_cb {
 	struct sk_buff *clone;
+	unsigned int ptp_type;
 	bool deferred_xmit;
 };
 
@@ -534,9 +536,9 @@ struct dsa_switch_ops {
 	int	(*port_hwtstamp_set)(struct dsa_switch *ds, int port,
 				     struct ifreq *ifr);
 	bool	(*port_txtstamp)(struct dsa_switch *ds, int port,
-				 struct sk_buff *clone, unsigned int type);
+				 struct sk_buff *clone);
 	bool	(*port_rxtstamp)(struct dsa_switch *ds, int port,
-				 struct sk_buff *skb, unsigned int type);
+				 struct sk_buff *skb);
 
 	/*
 	 * Deferred frame Tx
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 1fc782fab393..ee5606412e2e 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -181,27 +181,32 @@ EXPORT_SYMBOL_GPL(dsa_dev_to_net_device);
  * delivered is never notified unless we do so here.
  */
 static bool dsa_skb_defer_rx_timestamp(struct dsa_slave_priv *p,
-				       struct sk_buff *skb)
+				       struct sk_buff *skb,
+				       struct net_device *dev)
 {
 	struct dsa_switch *ds = p->dp->ds;
-	unsigned int type;
+
+	if (!ds->ops->port_rxtstamp)
+		return false;
 
 	if (skb_headroom(skb) < ETH_HLEN)
 		return false;
 
 	__skb_push(skb, ETH_HLEN);
 
-	type = ptp_classify_raw(skb);
+	DSA_SKB_CB(skb)->ptp_type = ptp_classify_raw(skb);
 
 	__skb_pull(skb, ETH_HLEN);
 
-	if (type == PTP_CLASS_NONE)
-		return false;
-
-	if (likely(ds->ops->port_rxtstamp))
-		return ds->ops->port_rxtstamp(ds, p->dp->index, skb, type);
+	if (p->dp->cpu_dp->tag_ops->can_tstamp) {
+		if (!p->dp->cpu_dp->tag_ops->can_tstamp(skb, dev))
+			return false;
+	} else {
+		if (DSA_SKB_CB(skb)->ptp_type == PTP_CLASS_NONE)
+			return false;
+	}
 
-	return false;
+	return ds->ops->port_rxtstamp(ds, p->dp->index, skb);
 }
 
 static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
@@ -239,7 +244,7 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
 	s->rx_bytes += skb->len;
 	u64_stats_update_end(&s->syncp);
 
-	if (dsa_skb_defer_rx_timestamp(p, skb))
+	if (dsa_skb_defer_rx_timestamp(p, skb, dev))
 		return 0;
 
 	netif_receive_skb(skb);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 9892ca1f6859..ebe7944a2d0f 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -410,24 +410,32 @@ static inline netdev_tx_t dsa_slave_netpoll_send_skb(struct net_device *dev,
 }
 
 static void dsa_skb_tx_timestamp(struct dsa_slave_priv *p,
-				 struct sk_buff *skb)
+				 struct sk_buff *skb, struct net_device *dev)
 {
 	struct dsa_switch *ds = p->dp->ds;
 	struct sk_buff *clone;
-	unsigned int type;
 
-	type = ptp_classify_raw(skb);
-	if (type == PTP_CLASS_NONE)
+	if (!(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
 		return;
 
 	if (!ds->ops->port_txtstamp)
 		return;
 
+	DSA_SKB_CB(skb)->ptp_type = ptp_classify_raw(skb);
+
+	if (p->dp->cpu_dp->tag_ops->can_tstamp) {
+		if (!p->dp->cpu_dp->tag_ops->can_tstamp(skb, dev))
+			return;
+	} else {
+		if (DSA_SKB_CB(skb)->ptp_type == PTP_CLASS_NONE)
+			return;
+	}
+
 	clone = skb_clone_sk(skb);
 	if (!clone)
 		return;
 
-	if (ds->ops->port_txtstamp(ds, p->dp->index, clone, type))
+	if (ds->ops->port_txtstamp(ds, p->dp->index, clone))
 		return;
 
 	kfree_skb(clone);
@@ -468,7 +476,7 @@ static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* Identify PTP protocol packets, clone them, and pass them to the
 	 * switch driver
 	 */
-	dsa_skb_tx_timestamp(p, skb);
+	dsa_skb_tx_timestamp(p, skb, dev);
 
 	/* Transmit function may have to reallocate the original SKB,
 	 * in which case it must have freed it. Only free it here on error.
-- 
2.17.1

