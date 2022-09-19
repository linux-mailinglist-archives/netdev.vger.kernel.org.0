Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F16BE5BD727
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 00:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiISWTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 18:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbiISWTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 18:19:09 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8291A4C60D
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 15:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vj5lan9UGgllZdqhsLuVHs2ouaJnMlEzRAz9B1cVqyk=; b=s/s26VuUfYf+qbY9oXnN6oPt4D
        UrpEuajCNfmJvvnKgH+LhUZ/4WqYTrkXaiYatguiU30mnrtTQMqrv8y09lJgkJES03+FaZt9Ur128
        Y1Ww0mBckevnlN57aYz9Vvc96JfwDGAxLk+GXfHIyBisxvQPX6DCyvVCHOj6BLp8caaM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oaP6R-00HBRU-AO; Tue, 20 Sep 2022 00:18:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     mattias.forsblad@gmail.com
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH rfc v0 9/9] net: dsa: qca8k: Move inband mutex into DSA core
Date:   Tue, 20 Sep 2022 00:18:53 +0200
Message-Id: <20220919221853.4095491-10-andrew@lunn.ch>
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

The mutex serves two purposes:

It serialises operations on the switch, so that only one
request/response can be happening at once.

It protects priv->mgmt_master, which itself has two purposes.  If the
hardware is wrongly wires, the wrong switch port is connected to the
cpu, inband cannot be used. In this case it has the value
NULL. Additionally, if the master is down, it is set to
NULL. Otherwise it points to the netdev used to send frames to the
switch.

The protection of priv->mgmt_master is not required. It is a single
pointer, which will be updated atomically. It is not expected that the
interface disappears, it only goes down. Hence mgmt_master will always
be valid, or NULL.

Move the check for the master device being NULL into the core.  Also,
move the mutex for serialisation into the core.

The MIB operations don't follow request/response semantics, so its
mutex is left untouched.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 68 ++++++--------------------------
 drivers/net/dsa/qca/qca8k.h      |  1 -
 include/net/dsa.h                |  1 +
 net/dsa/dsa.c                    |  7 ++++
 4 files changed, 19 insertions(+), 58 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 234d79a09e78..3e60bbe2570d 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -238,15 +238,6 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 	if (!skb)
 		return -ENOMEM;
 
-	mutex_lock(&mgmt_eth_data->mutex);
-
-	/* Check mgmt_master if is operational */
-	if (!priv->mgmt_master) {
-		kfree_skb(skb);
-		mutex_unlock(&mgmt_eth_data->mutex);
-		return -EINVAL;
-	}
-
 	skb->dev = priv->mgmt_master;
 
 	ret = dsa_inband_request(&mgmt_eth_data->inband, skb,
@@ -258,8 +249,6 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 	if (len > QCA_HDR_MGMT_DATA1_LEN)
 		memcpy(val + 1, &data[1], len - QCA_HDR_MGMT_DATA1_LEN);
 
-	mutex_unlock(&mgmt_eth_data->mutex);
-
 	return ret;
 }
 
@@ -267,32 +256,18 @@ static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 {
 	struct qca8k_mgmt_eth_data *mgmt_eth_data = &priv->mgmt_eth_data;
 	struct sk_buff *skb;
-	int ret;
 
 	skb = qca8k_alloc_mdio_header(MDIO_WRITE, reg, val,
 				      QCA8K_ETHERNET_MDIO_PRIORITY, len);
 	if (!skb)
 		return -ENOMEM;
 
-	mutex_lock(&mgmt_eth_data->mutex);
-
-	/* Check mgmt_master if is operational */
-	if (!priv->mgmt_master) {
-		kfree_skb(skb);
-		mutex_unlock(&mgmt_eth_data->mutex);
-		return -EINVAL;
-	}
-
 	skb->dev = priv->mgmt_master;
 
-	ret = dsa_inband_request(&mgmt_eth_data->inband, skb,
-				 qca8k_mdio_header_fill_seq_num,
-				 NULL, 0,
-				 QCA8K_ETHERNET_TIMEOUT);
-
-	mutex_unlock(&mgmt_eth_data->mutex);
-
-	return ret;
+	return dsa_inband_request(&mgmt_eth_data->inband, skb,
+				  qca8k_mdio_header_fill_seq_num,
+				  NULL, 0,
+				  QCA8K_ETHERNET_TIMEOUT);
 }
 
 static int
@@ -438,7 +413,6 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 	struct sk_buff *write_skb, *clear_skb, *read_skb;
 	struct qca8k_mgmt_eth_data *mgmt_eth_data;
 	u32 write_val, clear_val = 0, val;
-	struct net_device *mgmt_master;
 	u32 resp_data[4];
 	int ret, ret1;
 
@@ -484,19 +458,9 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 	 * 3. Get the data if we are reading
 	 * 4. Reset the mdio master (even with error)
 	 */
-	mutex_lock(&mgmt_eth_data->mutex);
-
-	/* Check if mgmt_master is operational */
-	mgmt_master = priv->mgmt_master;
-	if (!mgmt_master) {
-		mutex_unlock(&mgmt_eth_data->mutex);
-		ret = -EINVAL;
-		goto err_mgmt_master;
-	}
-
-	read_skb->dev = mgmt_master;
-	clear_skb->dev = mgmt_master;
-	write_skb->dev = mgmt_master;
+	read_skb->dev = priv->mgmt_master;
+	clear_skb->dev = priv->mgmt_master;
+	write_skb->dev = priv->mgmt_master;
 
 	ret = dsa_inband_request(&mgmt_eth_data->inband, write_skb,
 				 qca8k_mdio_header_fill_seq_num,
@@ -533,18 +497,11 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 	}
 exit:
 
-	ret = dsa_inband_request(&mgmt_eth_data->inband, clear_skb,
-				 qca8k_mdio_header_fill_seq_num,
-				 NULL, 0,
-				 QCA8K_ETHERNET_TIMEOUT);
-
-	mutex_unlock(&mgmt_eth_data->mutex);
-
-	return ret;
+	return dsa_inband_request(&mgmt_eth_data->inband, clear_skb,
+				  qca8k_mdio_header_fill_seq_num,
+				  NULL, 0,
+				  QCA8K_ETHERNET_TIMEOUT);
 
-	/* Error handling before lock */
-err_mgmt_master:
-	kfree_skb(read_skb);
 err_read_skb:
 	kfree_skb(clear_skb);
 err_clear_skb:
@@ -1526,13 +1483,11 @@ qca8k_master_change(struct dsa_switch *ds, const struct net_device *master,
 	if (dp->index != 0)
 		return;
 
-	mutex_lock(&priv->mgmt_eth_data.mutex);
 	mutex_lock(&priv->mib_eth_data.mutex);
 
 	priv->mgmt_master = operational ? (struct net_device *)master : NULL;
 
 	mutex_unlock(&priv->mib_eth_data.mutex);
-	mutex_unlock(&priv->mgmt_eth_data.mutex);
 }
 
 static int qca8k_connect_tag_protocol(struct dsa_switch *ds,
@@ -1850,7 +1805,6 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 	if (!priv->ds)
 		return -ENOMEM;
 
-	mutex_init(&priv->mgmt_eth_data.mutex);
 	dsa_inband_init(&priv->mgmt_eth_data.inband, U32_MAX);
 
 	mutex_init(&priv->mib_eth_data.mutex);
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index 70494096e251..6da36ed6486b 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -347,7 +347,6 @@ enum {
 
 struct qca8k_mgmt_eth_data {
 	struct dsa_inband inband;
-	struct mutex mutex; /* Enforce one mdio read/write at time */
 };
 
 struct qca8k_mib_eth_data {
diff --git a/include/net/dsa.h b/include/net/dsa.h
index dad9e31d36ce..7a545b781e7d 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -1281,6 +1281,7 @@ bool dsa_mdb_present_in_other_db(struct dsa_switch *ds, int port,
  * frames and expecting a response in a frame.
 */
 struct dsa_inband {
+	struct mutex lock; /* Serialise operations */
 	struct completion completion;
 	u32 seqno;
 	u32 seqno_mask;
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 4fa0ab4ae58e..82c729d631eb 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -521,6 +521,7 @@ EXPORT_SYMBOL_GPL(dsa_mdb_present_in_other_db);
 void dsa_inband_init(struct dsa_inband *inband, u32 seqno_mask)
 {
 	init_completion(&inband->completion);
+	mutex_init(&inband->lock);
 	mutex_init(&inband->resp_lock);
 	inband->seqno_mask = seqno_mask;
 	inband->seqno = 0;
@@ -567,6 +568,11 @@ int dsa_inband_request(struct dsa_inband *inband, struct sk_buff *skb,
 	reinit_completion(&inband->completion);
 	inband->err = 0;
 
+	if (!skb->dev)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&inband->lock);
+
 	mutex_lock(&inband->resp_lock);
 	inband->resp = resp;
 	inband->resp_len = resp_len;
@@ -585,6 +591,7 @@ int dsa_inband_request(struct dsa_inband *inband, struct sk_buff *skb,
 	inband->resp = NULL;
 	inband->resp_len = 0;
 	mutex_unlock(&inband->resp_lock);
+	mutex_unlock(&inband->lock);
 
 	if (ret < 0)
 		return ret;
-- 
2.37.2

