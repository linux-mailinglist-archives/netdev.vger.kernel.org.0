Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE7E5E6A2D
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 19:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbiIVR7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 13:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232342AbiIVR6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 13:58:48 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015CD10653E
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 10:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=pvY/kxtPAYphSW76zOLyHOFh3S18Jk2KB1MOihpbnzw=; b=QvtUN88HCZeBL7eI6goapNhJnp
        dVWEDxwHddqjtvVZN1RVLTdBQPx8P5GUQN2HY/Jd4YaKZvHVvFGpVavu6h0LNs00zEszb8gCd1Mly
        sxSEZykeF519pKX7JFs8N9G98I/xMSxxakQbXdlmkRQriKP9ou0stU3uvYe7UIH98/v0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1obQTA-00HYcz-Hh; Thu, 22 Sep 2022 19:58:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     mattias.forsblad@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH rfc v2 07/10] net: dsa: qca8k: Refactor sequence number mismatch to use error code
Date:   Thu, 22 Sep 2022 19:58:18 +0200
Message-Id: <20220922175821.4184622-8-andrew@lunn.ch>
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

Replace the boolean that the sequence numbers matches with an error
code. Now that responses with the wrong sequence number are dropped,
this is actually unused in this driver. However, other devices can
perform additional validation of a response with the correct sequence
number and potentially return -EPROTO to indicate some other sort of
error.

The value is only safe to use if the completion happens. Ensure the
return from the completion is always considered, and if it fails, a
timeout error is returned.

This is a preparation step to moving the error tracking into the DSA
core. This intermediate step is a bit ugly, but that all gets cleaned
up in the next patch.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
v2
-ret -> err
Extended commit message warning the code is ugly
Point out it is not actually used by this driver
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 46 +++++++++++++-------------------
 drivers/net/dsa/qca/qca8k.h      |  2 +-
 2 files changed, 20 insertions(+), 28 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 35dbb16f9d62..1127fa138960 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -229,7 +229,7 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 {
 	struct qca8k_mgmt_eth_data *mgmt_eth_data = &priv->mgmt_eth_data;
 	struct sk_buff *skb;
-	bool ack;
+	int err;
 	int ret;
 
 	skb = qca8k_alloc_mdio_header(MDIO_READ, reg, NULL,
@@ -247,7 +247,6 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 	}
 
 	skb->dev = priv->mgmt_master;
-	mgmt_eth_data->ack = false;
 
 	ret = dsa_inband_request(&mgmt_eth_data->inband, skb,
 				 qca8k_mdio_header_fill_seq_num,
@@ -257,15 +256,15 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 	if (len > QCA_HDR_MGMT_DATA1_LEN)
 		memcpy(val + 1, mgmt_eth_data->data + 1, len - QCA_HDR_MGMT_DATA1_LEN);
 
-	ack = mgmt_eth_data->ack;
+	err = mgmt_eth_data->err;
 
 	mutex_unlock(&mgmt_eth_data->mutex);
 
 	if (ret)
 		return ret;
 
-	if (!ack)
-		return -EINVAL;
+	if (err)
+		return err;
 
 	return 0;
 }
@@ -274,7 +273,7 @@ static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 {
 	struct qca8k_mgmt_eth_data *mgmt_eth_data = &priv->mgmt_eth_data;
 	struct sk_buff *skb;
-	bool ack;
+	int err;
 	int ret;
 
 	skb = qca8k_alloc_mdio_header(MDIO_WRITE, reg, val,
@@ -292,21 +291,20 @@ static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 	}
 
 	skb->dev = priv->mgmt_master;
-	mgmt_eth_data->ack = false;
 
 	ret = dsa_inband_request(&mgmt_eth_data->inband, skb,
 				 qca8k_mdio_header_fill_seq_num,
 				 QCA8K_ETHERNET_TIMEOUT);
 
-	ack = mgmt_eth_data->ack;
+	err = mgmt_eth_data->err;
 
 	mutex_unlock(&mgmt_eth_data->mutex);
 
 	if (ret)
 		return ret;
 
-	if (!ack)
-		return -EINVAL;
+	if (err)
+		return err;
 
 	return 0;
 }
@@ -431,22 +429,20 @@ qca8k_phy_eth_busy_wait(struct qca8k_mgmt_eth_data *mgmt_eth_data,
 			struct sk_buff *read_skb, u32 *val)
 {
 	struct sk_buff *skb = skb_copy(read_skb, GFP_KERNEL);
-	bool ack;
+	int err;
 	int ret;
 
-	mgmt_eth_data->ack = false;
-
 	ret = dsa_inband_request(&mgmt_eth_data->inband, skb,
 				 qca8k_mdio_header_fill_seq_num,
 				 QCA8K_ETHERNET_TIMEOUT);
 
-	ack = mgmt_eth_data->ack;
+	err = mgmt_eth_data->err;
 
 	if (ret)
 		return ret;
 
-	if (!ack)
-		return -EINVAL;
+	if (err)
+		return err;
 
 	*val = mgmt_eth_data->data[0];
 
@@ -462,7 +458,7 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 	u32 write_val, clear_val = 0, val;
 	struct net_device *mgmt_master;
 	int ret, ret1;
-	bool ack;
+	int err;
 
 	if (regnum >= QCA8K_MDIO_MASTER_MAX_REG)
 		return -EINVAL;
@@ -519,21 +515,20 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 	read_skb->dev = mgmt_master;
 	clear_skb->dev = mgmt_master;
 	write_skb->dev = mgmt_master;
-	mgmt_eth_data->ack = false;
 
 	ret = dsa_inband_request(&mgmt_eth_data->inband, write_skb,
 				 qca8k_mdio_header_fill_seq_num,
 				 QCA8K_ETHERNET_TIMEOUT);
 
-	ack = mgmt_eth_data->ack;
+	err = mgmt_eth_data->err;
 
 	if (ret) {
 		kfree_skb(read_skb);
 		goto exit;
 	}
 
-	if (!ack) {
-		ret = -EINVAL;
+	if (err) {
+		ret = err;
 		kfree_skb(read_skb);
 		goto exit;
 	}
@@ -549,19 +544,17 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 	}
 
 	if (read) {
-		mgmt_eth_data->ack = false;
-
 		ret = dsa_inband_request(&mgmt_eth_data->inband, read_skb,
 					 qca8k_mdio_header_fill_seq_num,
 					 QCA8K_ETHERNET_TIMEOUT);
 
-		ack = mgmt_eth_data->ack;
+		err = mgmt_eth_data->err;
 
 		if (ret)
 			goto exit;
 
-		if (!ack) {
-			ret = -EINVAL;
+		if (err) {
+			ret = err;
 			goto exit;
 		}
 
@@ -570,7 +563,6 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 		kfree_skb(read_skb);
 	}
 exit:
-	mgmt_eth_data->ack = false;
 
 	/* This is expected to fail sometimes, so don't check return value. */
 	dsa_inband_request(&mgmt_eth_data->inband, clear_skb,
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index ae5815365a86..7b928c160c0e 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -348,7 +348,7 @@ enum {
 struct qca8k_mgmt_eth_data {
 	struct dsa_inband inband;
 	struct mutex mutex; /* Enforce one mdio read/write at time */
-	bool ack;
+	int err;
 	u32 data[4];
 };
 
-- 
2.37.2

