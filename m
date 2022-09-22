Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDCA5E6A28
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 19:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbiIVR7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 13:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbiIVR6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 13:58:48 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45164106517
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 10:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mFEYsaZvxhwZIrz4ilQiyzkyJaHpsNKtI9EF545CUpg=; b=0P/5I8l8ptYkYkmejrt5ljBg4x
        nC8a4+GQTyILNo9AzAIonpRxxvl5AIvlBlsLsrsuOb4Bgr8kK4aTQzRE4xAtuvEqmfngNHBcDPkfR
        AHDfOj8yAeiNLlNHrD+fve4mHJm5ww83alikAxIoOU1UuBF02mXY6C5RFkKffTEySB2A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1obQTA-00HYd2-JO; Thu, 22 Sep 2022 19:58:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     mattias.forsblad@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH rfc v2 08/10] net: dsa: qca8k: Pass error code from reply decoder to requester
Date:   Thu, 22 Sep 2022 19:58:19 +0200
Message-Id: <20220922175821.4184622-9-andrew@lunn.ch>
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

The code which decodes the frame and signals the complete can detect
error within the reply, such as fields have unexpected values. Pass an
error code between the completer and the function waiting on the
complete. This simplifies the error handling, since all errors are
combined into one place.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
v2:

Remove EPROTO if the sequence numbers don't match, drop the reply
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 54 ++++++--------------------------
 drivers/net/dsa/qca/qca8k.h      |  1 -
 include/net/dsa.h                |  3 +-
 net/dsa/dsa.c                    |  8 +++--
 4 files changed, 17 insertions(+), 49 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 1127fa138960..096b43f89869 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -138,6 +138,7 @@ static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
 	struct qca8k_priv *priv = ds->priv;
 	struct qca_mgmt_ethhdr *mgmt_ethhdr;
 	u8 len, cmd;
+	int err = 0;
 
 	mgmt_ethhdr = (struct qca_mgmt_ethhdr *)skb_mac_header(skb);
 	mgmt_eth_data = &priv->mgmt_eth_data;
@@ -160,7 +161,7 @@ static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
 			       QCA_HDR_MGMT_DATA2_LEN);
 	}
 
-	dsa_inband_complete(&mgmt_eth_data->inband);
+	dsa_inband_complete(&mgmt_eth_data->inband, err);
 }
 
 static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *val,
@@ -229,7 +230,6 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 {
 	struct qca8k_mgmt_eth_data *mgmt_eth_data = &priv->mgmt_eth_data;
 	struct sk_buff *skb;
-	int err;
 	int ret;
 
 	skb = qca8k_alloc_mdio_header(MDIO_READ, reg, NULL,
@@ -256,24 +256,15 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 	if (len > QCA_HDR_MGMT_DATA1_LEN)
 		memcpy(val + 1, mgmt_eth_data->data + 1, len - QCA_HDR_MGMT_DATA1_LEN);
 
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
 
 static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 {
 	struct qca8k_mgmt_eth_data *mgmt_eth_data = &priv->mgmt_eth_data;
 	struct sk_buff *skb;
-	int err;
 	int ret;
 
 	skb = qca8k_alloc_mdio_header(MDIO_WRITE, reg, val,
@@ -296,17 +287,9 @@ static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
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
@@ -429,21 +412,15 @@ qca8k_phy_eth_busy_wait(struct qca8k_mgmt_eth_data *mgmt_eth_data,
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
@@ -458,7 +435,6 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 	u32 write_val, clear_val = 0, val;
 	struct net_device *mgmt_master;
 	int ret, ret1;
-	int err;
 
 	if (regnum >= QCA8K_MDIO_MASTER_MAX_REG)
 		return -EINVAL;
@@ -520,19 +496,11 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
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
@@ -548,16 +516,9 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
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
@@ -1439,6 +1400,7 @@ static void qca8k_mib_autocast_handler(struct dsa_switch *ds, struct sk_buff *sk
 	const struct qca8k_mib_desc *mib;
 	struct mib_ethhdr *mib_ethhdr;
 	int i, mib_len, offset = 0;
+	int err = 0;
 	u64 *data;
 	u8 port;
 
@@ -1449,8 +1411,10 @@ static void qca8k_mib_autocast_handler(struct dsa_switch *ds, struct sk_buff *sk
 	 * parse only the requested one.
 	 */
 	port = FIELD_GET(QCA_HDR_RECV_SOURCE_PORT, ntohs(mib_ethhdr->hdr));
-	if (port != mib_eth_data->req_port)
+	if (port != mib_eth_data->req_port) {
+		err = -EPROTO;
 		goto exit;
+	}
 
 	data = mib_eth_data->data;
 
@@ -1479,7 +1443,7 @@ static void qca8k_mib_autocast_handler(struct dsa_switch *ds, struct sk_buff *sk
 exit:
 	/* Complete on receiving all the mib packet */
 	if (refcount_dec_and_test(&mib_eth_data->port_parsed))
-		dsa_inband_complete(&mib_eth_data->inband);
+		dsa_inband_complete(&mib_eth_data->inband, err);
 }
 
 static int
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index 7b928c160c0e..ce27a732dba0 100644
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
index e8cbd67279ea..497d0eb85cf1 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -1311,10 +1311,11 @@ struct dsa_inband {
 	struct completion completion;
 	u32 seqno;
 	u32 seqno_mask;
+	int err;
 };
 
 void dsa_inband_init(struct dsa_inband *inband, u32 seqno_mask);
-void dsa_inband_complete(struct dsa_inband *inband);
+void dsa_inband_complete(struct dsa_inband *inband, int err);
 int dsa_inband_request(struct dsa_inband *inband, struct sk_buff *skb,
 		       void (*insert_seqno)(struct sk_buff *skb, u32 seqno),
 		       int timeout_ms);
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index cddf62916932..a426459c74c5 100644
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
@@ -552,6 +553,8 @@ int dsa_inband_request(struct dsa_inband *inband, struct sk_buff *skb,
 	unsigned long jiffies = msecs_to_jiffies(timeout_ms);
 	int ret;
 
+	inband->err = 0;
+
 	if (insert_seqno) {
 		inband->seqno++;
 		insert_seqno(skb, inband->seqno & inband->seqno_mask);
@@ -564,7 +567,8 @@ int dsa_inband_request(struct dsa_inband *inband, struct sk_buff *skb,
 	ret = wait_for_completion_timeout(&inband->completion, jiffies);
 	if (ret == 0)
 		return -ETIMEDOUT;
-	return 0;
+
+	return inband->err;
 }
 EXPORT_SYMBOL_GPL(dsa_inband_request);
 
-- 
2.37.2

