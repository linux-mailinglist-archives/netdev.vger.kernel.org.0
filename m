Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3867B5BD722
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 00:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiISWTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 18:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiISWTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 18:19:05 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD234DF2A
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 15:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Gy6Y78/sd6dWowkaXHqVSk3fONB8c3dj7iEzbU5pNyI=; b=vuq7dtNOLMyPT9zFJykdPRB6RP
        an4lO02iZh085aGrlJMSS1SZ4AsUqW4QckdKjyKsgaut7W+GxNWYWj6xfxsx019/EdBBz35r+eVin
        XkY95uQ6vFcyvvD24SMq7y4T3c5QmRgDtGDzvMux1RNQI8AeLpmD8dLwdKCjMMbNuoNY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oaP6R-00HBRI-3C; Tue, 20 Sep 2022 00:18:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     mattias.forsblad@gmail.com
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH rfc v0 5/9] net: dsa: qca8k: Move request sequence number handling into core
Date:   Tue, 20 Sep 2022 00:18:49 +0200
Message-Id: <20220919221853.4095491-6-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220919221853.4095491-1-andrew@lunn.ch>
References: <20220919110847.744712-3-mattias.forsblad@gmail.com>
 <20220919221853.4095491-1-andrew@lunn.ch>
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
 drivers/net/dsa/qca/qca8k-8xxx.c | 35 +++++++++-----------------------
 drivers/net/dsa/qca/qca8k.h      |  1 -
 include/net/dsa.h                |  6 +++++-
 net/dsa/dsa.c                    | 16 ++++++++++++++-
 4 files changed, 30 insertions(+), 28 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 9481a248273a..a354ba070d33 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -146,7 +146,7 @@ static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
 	len = FIELD_GET(QCA_HDR_MGMT_LENGTH, mgmt_ethhdr->command);
 
 	/* Make sure the seq match the requested packet */
-	if (mgmt_ethhdr->seq == mgmt_eth_data->seq)
+	if (mgmt_ethhdr->seq == dsa_inband_seqno(&mgmt_eth_data->inband))
 		mgmt_eth_data->ack = true;
 
 	if (cmd == MDIO_READ) {
@@ -247,14 +247,11 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 	}
 
 	skb->dev = priv->mgmt_master;
-
-	/* Increment seq_num and set it in the mdio pkt */
-	mgmt_eth_data->seq++;
-	qca8k_mdio_header_fill_seq_num(skb, mgmt_eth_data->seq);
 	mgmt_eth_data->ack = false;
 
 	ret = dsa_inband_request(&mgmt_eth_data->inband, skb,
-				 QCA8K_ETHERNET_TIMEOUT);
+			      qca8k_mdio_header_fill_seq_num,
+			      QCA8K_ETHERNET_TIMEOUT);
 
 	*val = mgmt_eth_data->data[0];
 	if (len > QCA_HDR_MGMT_DATA1_LEN)
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
@@ -583,12 +570,10 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 		kfree_skb(read_skb);
 	}
 exit:
-	/* Increment seq_num and set it in the clear pkt */
-	mgmt_eth_data->seq++;
-	qca8k_mdio_header_fill_seq_num(clear_skb, mgmt_eth_data->seq);
 	mgmt_eth_data->ack = false;
 
 	ret = dsa_inband_request(&mgmt_eth_data->inband, clear_skb,
+				 qca8k_mdio_header_fill_seq_num,
 				 QCA8K_ETHERNET_TIMEOUT);
 
 	mutex_unlock(&mgmt_eth_data->mutex);
@@ -1901,10 +1886,10 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
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
index 685628716ed2..a5abc340471c 100644
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
index 50c319832939..2d6b7c7f158b 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -1282,13 +1282,17 @@ bool dsa_mdb_present_in_other_db(struct dsa_switch *ds, int port,
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
index 68576f1c5b02..5a8d95f8acec 100644
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
 
@@ -544,6 +546,7 @@ EXPORT_SYMBOL_GPL(dsa_inband_wait_for_completion);
  * reinitialized before the skb is queue to avoid races.
  */
 int dsa_inband_request(struct dsa_inband *inband, struct sk_buff *skb,
+		       void (*insert_seqno)(struct sk_buff *skb, u32 seqno),
 		       int timeout_ms)
 {
 	unsigned long jiffies = msecs_to_jiffies(timeout_ms);
@@ -551,6 +554,11 @@ int dsa_inband_request(struct dsa_inband *inband, struct sk_buff *skb,
 
 	reinit_completion(&inband->completion);
 
+	if (insert_seqno) {
+		inband->seqno++;
+		insert_seqno(skb, inband->seqno & inband->seqno_mask);
+	}
+
 	dev_queue_xmit(skb);
 
 	ret = wait_for_completion_timeout(&inband->completion, jiffies);
@@ -562,6 +570,12 @@ int dsa_inband_request(struct dsa_inband *inband, struct sk_buff *skb,
 }
 EXPORT_SYMBOL_GPL(dsa_inband_request);
 
+u32 dsa_inband_seqno(struct dsa_inband *inband)
+{
+	return inband->seqno & inband->seqno_mask;
+}
+EXPORT_SYMBOL_GPL(dsa_inband_seqno);
+
 static int __init dsa_init_module(void)
 {
 	int rc;
-- 
2.37.2

