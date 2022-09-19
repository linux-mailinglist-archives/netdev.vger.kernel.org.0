Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2FF45BD724
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 00:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiISWTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 18:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiISWTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 18:19:08 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E2840E1C
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 15:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=S5+iRaOc2peMiHkrLZFu6Ozv3l3yq1Pck8xVbV+OOhU=; b=IRKz5R9NwJBlN4lq2KG01/hurq
        A3IvQp/203+vNCoY77qaS4QKVP/HJEayRWQTabw5bxyMC91LkvZ8k96Q2ppl6uzs4V9CDOL2wLpTl
        2iJ1ozd//Np3QW9Jzd8JRgOp5DWNfO4ZPP836UYUsOpPbyCiQoAnpayNWKHaOeSQNDxw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oaP6R-00HBRO-71; Tue, 20 Sep 2022 00:18:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     mattias.forsblad@gmail.com
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH rfc v0 7/9] net: dsa: qca8k: Pass error code from reply decoder to requester
Date:   Tue, 20 Sep 2022 00:18:51 +0200
Message-Id: <20220919221853.4095491-8-andrew@lunn.ch>
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

The code which decodes the frame and signals the complete can
experience error, such as wrong sequence number. Pass an error code
between the completer and the function waiting on the complete. This
simplifies the error handling, since all errors are combined into one
place.

At the same time, return -EPROTO if the sequence numbers don't match.
This is more appropriate than EINVAL.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 60 ++++++--------------------------
 drivers/net/dsa/qca/qca8k.h      |  1 -
 include/net/dsa.h                |  3 +-
 net/dsa/dsa.c                    |  7 ++--
 4 files changed, 18 insertions(+), 53 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 69b807d87367..55a781851e28 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -138,6 +138,7 @@ static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
 	struct qca8k_priv *priv = ds->priv;
 	struct qca_mgmt_ethhdr *mgmt_ethhdr;
 	u8 len, cmd;
+	int err = 0;
 
 	mgmt_ethhdr = (struct qca_mgmt_ethhdr *)skb_mac_header(skb);
 	mgmt_eth_data = &priv->mgmt_eth_data;
@@ -146,10 +147,8 @@ static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
 	len = FIELD_GET(QCA_HDR_MGMT_LENGTH, mgmt_ethhdr->command);
 
 	/* Make sure the seq match the requested packet */
-	if (mgmt_ethhdr->seq == dsa_inband_seqno(&mgmt_eth_data->inband))
-		mgmt_eth_data->err = 0;
-	else
-		mgmt_eth_data->err = -EINVAL;
+	if (mgmt_ethhdr->seq != dsa_inband_seqno(&mgmt_eth_data->inband))
+		err = -EPROTO;
 
 	if (cmd == MDIO_READ) {
 		mgmt_eth_data->data[0] = mgmt_ethhdr->mdio_data;
@@ -162,7 +161,7 @@ static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
 			       QCA_HDR_MGMT_DATA2_LEN);
 	}
 
-	dsa_inband_complete(&mgmt_eth_data->inband);
+	dsa_inband_complete(&mgmt_eth_data->inband, err);
 }
 
 static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *val,
@@ -231,7 +230,6 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 {
 	struct qca8k_mgmt_eth_data *mgmt_eth_data = &priv->mgmt_eth_data;
 	struct sk_buff *skb;
-	int err;
 	int ret;
 
 	skb = qca8k_alloc_mdio_header(MDIO_READ, reg, NULL,
@@ -258,24 +256,15 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 	if (len > QCA_HDR_MGMT_DATA1_LEN)
 		memcpy(val + 1, mgmt_eth_data->data + 1, len - QCA_HDR_MGMT_DATA1_LEN);
 
-	err = mgmt_eth_data->err;
-
 	mutex_unlock(&mgmt_eth_data->mutex);
 
-	if (ret)
-		return ret;
-
-	if (err)
-		return -ret;
-
-	return 0;
+	return ret;
 }
 
 static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 {
 	struct qca8k_mgmt_eth_data *mgmt_eth_data = &priv->mgmt_eth_data;
 	struct sk_buff *skb;
-	int err;
 	int ret;
 
 	skb = qca8k_alloc_mdio_header(MDIO_WRITE, reg, val,
@@ -298,17 +287,9 @@ static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 				 qca8k_mdio_header_fill_seq_num,
 				 QCA8K_ETHERNET_TIMEOUT);
 
-	err = mgmt_eth_data->err;
-
 	mutex_unlock(&mgmt_eth_data->mutex);
 
-	if (ret)
-		return ret;
-
-	if (err)
-		return err;
-
-	return 0;
+	return ret;
 }
 
 static int
@@ -431,21 +412,15 @@ qca8k_phy_eth_busy_wait(struct qca8k_mgmt_eth_data *mgmt_eth_data,
 			struct sk_buff *read_skb, u32 *val)
 {
 	struct sk_buff *skb = skb_copy(read_skb, GFP_KERNEL);
-	int err;
 	int ret;
 
 	ret = dsa_inband_request(&mgmt_eth_data->inband, skb,
 				 qca8k_mdio_header_fill_seq_num,
 				 QCA8K_ETHERNET_TIMEOUT);
 
-	err = mgmt_eth_data->err;
-
 	if (ret)
 		return ret;
 
-	if (err)
-		return err;
-
 	*val = mgmt_eth_data->data[0];
 
 	return 0;
@@ -460,7 +435,6 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 	u32 write_val, clear_val = 0, val;
 	struct net_device *mgmt_master;
 	int ret, ret1;
-	int err;
 
 	if (regnum >= QCA8K_MDIO_MASTER_MAX_REG)
 		return -EINVAL;
@@ -522,19 +496,11 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 				 qca8k_mdio_header_fill_seq_num,
 				 QCA8K_ETHERNET_TIMEOUT);
 
-	err = mgmt_eth_data->err;
-
 	if (ret) {
 		kfree_skb(read_skb);
 		goto exit;
 	}
 
-	if (err) {
-		ret = err;
-		kfree_skb(read_skb);
-		goto exit;
-	}
-
 	ret = read_poll_timeout(qca8k_phy_eth_busy_wait, ret1,
 				!(val & QCA8K_MDIO_MASTER_BUSY), 0,
 				QCA8K_BUSY_WAIT_TIMEOUT * USEC_PER_MSEC, false,
@@ -550,16 +516,9 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 					 qca8k_mdio_header_fill_seq_num,
 					 QCA8K_ETHERNET_TIMEOUT);
 
-		err = mgmt_eth_data->err;
-
 		if (ret)
 			goto exit;
 
-		if (err) {
-			ret = err;
-			goto exit;
-		}
-
 		ret = mgmt_eth_data->data[0] & QCA8K_MDIO_MASTER_DATA_MASK;
 	} else {
 		kfree_skb(read_skb);
@@ -1440,6 +1399,7 @@ static void qca8k_mib_autocast_handler(struct dsa_switch *ds, struct sk_buff *sk
 	const struct qca8k_mib_desc *mib;
 	struct mib_ethhdr *mib_ethhdr;
 	int i, mib_len, offset = 0;
+	int err = 0;
 	u64 *data;
 	u8 port;
 
@@ -1450,8 +1410,10 @@ static void qca8k_mib_autocast_handler(struct dsa_switch *ds, struct sk_buff *sk
 	 * parse only the requested one.
 	 */
 	port = FIELD_GET(QCA_HDR_RECV_SOURCE_PORT, ntohs(mib_ethhdr->hdr));
-	if (port != mib_eth_data->req_port)
+	if (port != mib_eth_data->req_port) {
+		err = -EPROTO;
 		goto exit;
+	}
 
 	data = mib_eth_data->data;
 
@@ -1480,7 +1442,7 @@ static void qca8k_mib_autocast_handler(struct dsa_switch *ds, struct sk_buff *sk
 exit:
 	/* Complete on receiving all the mib packet */
 	if (refcount_dec_and_test(&mib_eth_data->port_parsed))
-		dsa_inband_complete(&mib_eth_data->inband);
+		dsa_inband_complete(&mib_eth_data->inband, err);
 }
 
 static int
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index 79f7197a1790..682106206282 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -348,7 +348,6 @@ enum {
 struct qca8k_mgmt_eth_data {
 	struct dsa_inband inband;
 	struct mutex mutex; /* Enforce one mdio read/write at time */
-	int err;
 	u32 data[4];
 };
 
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 2d6b7c7f158b..1a920f89b667 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -1284,10 +1284,11 @@ struct dsa_inband {
 	struct completion completion;
 	u32 seqno;
 	u32 seqno_mask;
+	int err;
 };
 
 void dsa_inband_init(struct dsa_inband *inband, u32 seqno_mask);
-void dsa_inband_complete(struct dsa_inband *inband);
+void dsa_inband_complete(struct dsa_inband *inband, int err);
 int dsa_inband_request(struct dsa_inband *inband, struct sk_buff *skb,
 		       void (* insert_seqno)(struct sk_buff *skb, u32 seqno),
 		       int timeout_ms);
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 5a8d95f8acec..0de283ac0bfc 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -526,8 +526,9 @@ void dsa_inband_init(struct dsa_inband *inband, u32 seqno_mask)
 }
 EXPORT_SYMBOL_GPL(dsa_inband_init);
 
-void dsa_inband_complete(struct dsa_inband *inband)
+void dsa_inband_complete(struct dsa_inband *inband, int err)
 {
+	inband->err = err;
 	complete(&inband->completion);
 }
 EXPORT_SYMBOL_GPL(dsa_inband_complete);
@@ -553,6 +554,7 @@ int dsa_inband_request(struct dsa_inband *inband, struct sk_buff *skb,
 	int ret;
 
 	reinit_completion(&inband->completion);
+	inband->err = 0;
 
 	if (insert_seqno) {
 		inband->seqno++;
@@ -566,7 +568,8 @@ int dsa_inband_request(struct dsa_inband *inband, struct sk_buff *skb,
 		return ret;
 	if (ret == 0)
 		return -ETIMEDOUT;
-	return 0;
+
+	return inband->err;
 }
 EXPORT_SYMBOL_GPL(dsa_inband_request);
 
-- 
2.37.2

