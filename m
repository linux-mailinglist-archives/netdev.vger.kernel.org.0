Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12B445BD725
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 00:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiISWTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 18:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiISWTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 18:19:08 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657E2419B3
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 15:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ZYwyGzSbjhrFtr/cLHjJzkRxxh7VJAWFZdu32z6tn0s=; b=vLAIapLgilpaGU7LSWHO+mI1U8
        Yl1Hkv09045KkSwKKBA1grP7b3Q+Q0he8UNK1x8J2h9+X1jIss012Zyo/tEmG70JAl2/SmCZjCyo8
        2Jr9vRokE7sll+unA6HDTTbgyW8AX8amb2xnwS1cFs0TQMqvX0NAS0Z0+cPb8roAQOzA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oaP6R-00HBRL-5W; Tue, 20 Sep 2022 00:18:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     mattias.forsblad@gmail.com
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH rfc v0 6/9] net: dsa: qca8k: Refactor sequence number mismatch to use error code
Date:   Tue, 20 Sep 2022 00:18:50 +0200
Message-Id: <20220919221853.4095491-7-andrew@lunn.ch>
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

Replace the boolean that the sequence numbers matches with an error
code. Set the error code to -EINVAL if the sequence numbers are wrong,
otherwise 0.

The value is only safe to us if the completion happens. Ensure the
return from the completion is always considered, and if it fails, a
timeout error is returned.

This is a preparation step to moving the error tracking into the DSA
core.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 50 ++++++++++++++------------------
 drivers/net/dsa/qca/qca8k.h      |  2 +-
 2 files changed, 23 insertions(+), 29 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index a354ba070d33..69b807d87367 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -147,7 +147,9 @@ static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
 
 	/* Make sure the seq match the requested packet */
 	if (mgmt_ethhdr->seq == dsa_inband_seqno(&mgmt_eth_data->inband))
-		mgmt_eth_data->ack = true;
+		mgmt_eth_data->err = 0;
+	else
+		mgmt_eth_data->err = -EINVAL;
 
 	if (cmd == MDIO_READ) {
 		mgmt_eth_data->data[0] = mgmt_ethhdr->mdio_data;
@@ -229,7 +231,7 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 {
 	struct qca8k_mgmt_eth_data *mgmt_eth_data = &priv->mgmt_eth_data;
 	struct sk_buff *skb;
-	bool ack;
+	int err;
 	int ret;
 
 	skb = qca8k_alloc_mdio_header(MDIO_READ, reg, NULL,
@@ -247,7 +249,6 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 	}
 
 	skb->dev = priv->mgmt_master;
-	mgmt_eth_data->ack = false;
 
 	ret = dsa_inband_request(&mgmt_eth_data->inband, skb,
 			      qca8k_mdio_header_fill_seq_num,
@@ -257,15 +258,15 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
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
+		return -ret;
 
 	return 0;
 }
@@ -274,7 +275,7 @@ static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 {
 	struct qca8k_mgmt_eth_data *mgmt_eth_data = &priv->mgmt_eth_data;
 	struct sk_buff *skb;
-	bool ack;
+	int err;
 	int ret;
 
 	skb = qca8k_alloc_mdio_header(MDIO_WRITE, reg, val,
@@ -292,21 +293,20 @@ static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
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
@@ -431,22 +431,20 @@ qca8k_phy_eth_busy_wait(struct qca8k_mgmt_eth_data *mgmt_eth_data,
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
 
@@ -462,7 +460,7 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 	u32 write_val, clear_val = 0, val;
 	struct net_device *mgmt_master;
 	int ret, ret1;
-	bool ack;
+	int err;
 
 	if (regnum >= QCA8K_MDIO_MASTER_MAX_REG)
 		return -EINVAL;
@@ -519,21 +517,20 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
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
@@ -549,19 +546,17 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
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
 
@@ -570,7 +565,6 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 		kfree_skb(read_skb);
 	}
 exit:
-	mgmt_eth_data->ack = false;
 
 	ret = dsa_inband_request(&mgmt_eth_data->inband, clear_skb,
 				 qca8k_mdio_header_fill_seq_num,
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index a5abc340471c..79f7197a1790 100644
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

