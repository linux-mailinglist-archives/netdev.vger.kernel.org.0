Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1DB75E6A26
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 19:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbiIVR66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 13:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232315AbiIVR6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 13:58:45 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51DE1106510
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 10:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=HxB3OyNlsKQec/EYMatwXhC42Eu9yQtHOarjom2s/hg=; b=L6rmhnCT3tbxUm5XqPhz8DgG5v
        +gD+B3EoYfU0zey7cCuVocmbx0jBiDZMvc5JN9k5/GZWu/aV0Suae8rCbYGJzhVCz6vp4PirrWzdq
        1vYYNPXyoiv355nmgDdIZIklP8bf70WQN4pnuSoP1qdxJWpabTxfHPWtNcFv0UTG4siw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1obQTA-00HYcw-GB; Thu, 22 Sep 2022 19:58:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     mattias.forsblad@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH rfc v2 06/10] net: dsa: qca8k: Move request sequence number handling into core
Date:   Thu, 22 Sep 2022 19:58:17 +0200
Message-Id: <20220922175821.4184622-7-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220922175821.4184622-1-andrew@lunn.ch>
References: <20220922175821.4184622-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Each request/reply frame is likely to have a sequence number so that
request and the reply can be matched together. Move this sequence
number into the inband structure. The driver must provide a helper to
insert the sequence number into the skb, and the core will perform the
increment.

To allow different devices to have different size sequence numbers, a
mask is provided. This can be used for example to reduce the u32
sequence number down to a u8.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
v2
Fix wrong indentation of parameters
Move seqno increment before reinitializing completion to close race
Add a READ_ONCE() to stop compiler mischief.
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 33 +++++++++-----------------------
 drivers/net/dsa/qca/qca8k.h      |  1 -
 include/net/dsa.h                |  6 +++++-
 net/dsa/dsa.c                    | 16 +++++++++++++++-
 4 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index fdf27306d169..35dbb16f9d62 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -146,7 +146,7 @@ static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
 	len = FIELD_GET(QCA_HDR_MGMT_LENGTH, mgmt_ethhdr->command);
 
 	/* Make sure the seq match the requested packet. If not, drop. */
-	if (mgmt_ethhdr->seq == mgmt_eth_data->seq)
+	if (mgmt_ethhdr->seq == dsa_inband_seqno(&mgmt_eth_data->inband))
 		return;
 
 	if (cmd == MDIO_READ) {
@@ -247,13 +247,10 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 	}
 
 	skb->dev = priv->mgmt_master;
-
-	/* Increment seq_num and set it in the mdio pkt */
-	mgmt_eth_data->seq++;
-	qca8k_mdio_header_fill_seq_num(skb, mgmt_eth_data->seq);
 	mgmt_eth_data->ack = false;
 
 	ret = dsa_inband_request(&mgmt_eth_data->inband, skb,
+				 qca8k_mdio_header_fill_seq_num,
 				 QCA8K_ETHERNET_TIMEOUT);
 
 	*val = mgmt_eth_data->data[0];
@@ -295,13 +292,10 @@ static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 	}
 
 	skb->dev = priv->mgmt_master;
-
-	/* Increment seq_num and set it in the mdio pkt */
-	mgmt_eth_data->seq++;
-	qca8k_mdio_header_fill_seq_num(skb, mgmt_eth_data->seq);
 	mgmt_eth_data->ack = false;
 
 	ret = dsa_inband_request(&mgmt_eth_data->inband, skb,
+				 qca8k_mdio_header_fill_seq_num,
 				 QCA8K_ETHERNET_TIMEOUT);
 
 	ack = mgmt_eth_data->ack;
@@ -440,12 +434,10 @@ qca8k_phy_eth_busy_wait(struct qca8k_mgmt_eth_data *mgmt_eth_data,
 	bool ack;
 	int ret;
 
-	/* Increment seq_num and set it in the copy pkt */
-	mgmt_eth_data->seq++;
-	qca8k_mdio_header_fill_seq_num(skb, mgmt_eth_data->seq);
 	mgmt_eth_data->ack = false;
 
 	ret = dsa_inband_request(&mgmt_eth_data->inband, skb,
+				 qca8k_mdio_header_fill_seq_num,
 				 QCA8K_ETHERNET_TIMEOUT);
 
 	ack = mgmt_eth_data->ack;
@@ -527,13 +519,10 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 	read_skb->dev = mgmt_master;
 	clear_skb->dev = mgmt_master;
 	write_skb->dev = mgmt_master;
-
-	/* Increment seq_num and set it in the write pkt */
-	mgmt_eth_data->seq++;
-	qca8k_mdio_header_fill_seq_num(write_skb, mgmt_eth_data->seq);
 	mgmt_eth_data->ack = false;
 
 	ret = dsa_inband_request(&mgmt_eth_data->inband, write_skb,
+				 qca8k_mdio_header_fill_seq_num,
 				 QCA8K_ETHERNET_TIMEOUT);
 
 	ack = mgmt_eth_data->ack;
@@ -560,12 +549,10 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 	}
 
 	if (read) {
-		/* Increment seq_num and set it in the read pkt */
-		mgmt_eth_data->seq++;
-		qca8k_mdio_header_fill_seq_num(read_skb, mgmt_eth_data->seq);
 		mgmt_eth_data->ack = false;
 
 		ret = dsa_inband_request(&mgmt_eth_data->inband, read_skb,
+					 qca8k_mdio_header_fill_seq_num,
 					 QCA8K_ETHERNET_TIMEOUT);
 
 		ack = mgmt_eth_data->ack;
@@ -583,13 +570,11 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 		kfree_skb(read_skb);
 	}
 exit:
-	/* Increment seq_num and set it in the clear pkt */
-	mgmt_eth_data->seq++;
-	qca8k_mdio_header_fill_seq_num(clear_skb, mgmt_eth_data->seq);
 	mgmt_eth_data->ack = false;
 
 	/* This is expected to fail sometimes, so don't check return value. */
 	dsa_inband_request(&mgmt_eth_data->inband, clear_skb,
+			   qca8k_mdio_header_fill_seq_num,
 			   QCA8K_ETHERNET_TIMEOUT);
 
 	mutex_unlock(&mgmt_eth_data->mutex);
@@ -1902,10 +1887,10 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 		return -ENOMEM;
 
 	mutex_init(&priv->mgmt_eth_data.mutex);
-	dsa_inband_init(&priv->mgmt_eth_data.inband);
+	dsa_inband_init(&priv->mgmt_eth_data.inband, U32_MAX);
 
 	mutex_init(&priv->mib_eth_data.mutex);
-	dsa_inband_init(&priv->mib_eth_data.inband);
+	dsa_inband_init(&priv->mib_eth_data.inband, U32_MAX);
 
 	priv->ds->dev = &mdiodev->dev;
 	priv->ds->num_ports = QCA8K_NUM_PORTS;
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index 84d6b02d75fb..ae5815365a86 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -349,7 +349,6 @@ struct qca8k_mgmt_eth_data {
 	struct dsa_inband inband;
 	struct mutex mutex; /* Enforce one mdio read/write at time */
 	bool ack;
-	u32 seq;
 	u32 data[4];
 };
 
diff --git a/include/net/dsa.h b/include/net/dsa.h
index a5bcd9f021d4..e8cbd67279ea 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -1309,13 +1309,17 @@ bool dsa_mdb_present_in_other_db(struct dsa_switch *ds, int port,
  */
 struct dsa_inband {
 	struct completion completion;
+	u32 seqno;
+	u32 seqno_mask;
 };
 
-void dsa_inband_init(struct dsa_inband *inband);
+void dsa_inband_init(struct dsa_inband *inband, u32 seqno_mask);
 void dsa_inband_complete(struct dsa_inband *inband);
 int dsa_inband_request(struct dsa_inband *inband, struct sk_buff *skb,
+		       void (*insert_seqno)(struct sk_buff *skb, u32 seqno),
 		       int timeout_ms);
 int dsa_inband_wait_for_completion(struct dsa_inband *inband, int timeout_ms);
+u32 dsa_inband_seqno(struct dsa_inband *inband);
 
 /* Keep inline for faster access in hot path */
 static inline bool netdev_uses_dsa(const struct net_device *dev)
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 8c40bc4c5944..cddf62916932 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -518,9 +518,11 @@ bool dsa_mdb_present_in_other_db(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL_GPL(dsa_mdb_present_in_other_db);
 
-void dsa_inband_init(struct dsa_inband *inband)
+void dsa_inband_init(struct dsa_inband *inband, u32 seqno_mask)
 {
 	init_completion(&inband->completion);
+	inband->seqno_mask = seqno_mask;
+	inband->seqno = 0;
 }
 EXPORT_SYMBOL_GPL(dsa_inband_init);
 
@@ -544,11 +546,17 @@ EXPORT_SYMBOL_GPL(dsa_inband_wait_for_completion);
  * reinitialized before the skb is queue to avoid races.
  */
 int dsa_inband_request(struct dsa_inband *inband, struct sk_buff *skb,
+		       void (*insert_seqno)(struct sk_buff *skb, u32 seqno),
 		       int timeout_ms)
 {
 	unsigned long jiffies = msecs_to_jiffies(timeout_ms);
 	int ret;
 
+	if (insert_seqno) {
+		inband->seqno++;
+		insert_seqno(skb, inband->seqno & inband->seqno_mask);
+	}
+
 	reinit_completion(&inband->completion);
 
 	dev_queue_xmit(skb);
@@ -560,6 +568,12 @@ int dsa_inband_request(struct dsa_inband *inband, struct sk_buff *skb,
 }
 EXPORT_SYMBOL_GPL(dsa_inband_request);
 
+u32 dsa_inband_seqno(struct dsa_inband *inband)
+{
+	return READ_ONCE(inband->seqno) & inband->seqno_mask;
+}
+EXPORT_SYMBOL_GPL(dsa_inband_seqno);
+
 static int __init dsa_init_module(void)
 {
 	int rc;
-- 
2.37.2

