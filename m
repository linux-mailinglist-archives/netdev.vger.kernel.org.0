Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD4E5BD71E
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 00:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbiISWTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 18:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiISWTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 18:19:03 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8C53AB06
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 15:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=UgQImkQHJE4O46BAEidJTBzO/tkp+xEr43bbZJ25hs0=; b=aSxCdxIqcPSYnhrOW/Ay8GMoPt
        ZjpGX8T62XuW9ggdMkJ5NwWyJ3tYp6tN4BHslcUymeTK/qhy6yQOMlZCuYSJbQ5dOhJL0tlCtzJX8
        96wpDNGw15HiBhn86jozDH2/SveNXkigCBwu//geTWZFjnEbeBZdXIKOtRc2jnsjLnf0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oaP6R-00HBRR-8m; Tue, 20 Sep 2022 00:18:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     mattias.forsblad@gmail.com
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH rfc v0 8/9] net: dsa: qca8k: Pass response buffer via dsa_rmu_request
Date:   Tue, 20 Sep 2022 00:18:52 +0200
Message-Id: <20220919221853.4095491-9-andrew@lunn.ch>
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

Make the calling of operations on the switch more like a request
response API by passing the address of the response buffer, rather
than making use of global state.

To avoid race conditions with the completion timeout, and late
arriving responses, protect the resp members via a mutex.

The qca8k response frame has an odd layout, the reply is not
contiguous. Use a small intermediary buffer to convert the reply into
something which can be memcpy'ed.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 31 ++++++++++++++++++++-----------
 drivers/net/dsa/qca/qca8k.h      |  1 -
 include/net/dsa.h                |  7 ++++++-
 net/dsa/dsa.c                    | 24 +++++++++++++++++++++++-
 4 files changed, 49 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 55a781851e28..234d79a09e78 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -138,6 +138,7 @@ static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
 	struct qca8k_priv *priv = ds->priv;
 	struct qca_mgmt_ethhdr *mgmt_ethhdr;
 	u8 len, cmd;
+	u32 data[4];
 	int err = 0;
 
 	mgmt_ethhdr = (struct qca_mgmt_ethhdr *)skb_mac_header(skb);
@@ -151,17 +152,16 @@ static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
 		err = -EPROTO;
 
 	if (cmd == MDIO_READ) {
-		mgmt_eth_data->data[0] = mgmt_ethhdr->mdio_data;
+		data[0] = mgmt_ethhdr->mdio_data;
 
 		/* Get the rest of the 12 byte of data.
 		 * The read/write function will extract the requested data.
 		 */
 		if (len > QCA_HDR_MGMT_DATA1_LEN)
-			memcpy(mgmt_eth_data->data + 1, skb->data,
-			       QCA_HDR_MGMT_DATA2_LEN);
+			memcpy(&data[1], skb->data, QCA_HDR_MGMT_DATA2_LEN);
 	}
 
-	dsa_inband_complete(&mgmt_eth_data->inband, err);
+	dsa_inband_complete(&mgmt_eth_data->inband, &data, sizeof(data), err);
 }
 
 static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *val,
@@ -230,6 +230,7 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 {
 	struct qca8k_mgmt_eth_data *mgmt_eth_data = &priv->mgmt_eth_data;
 	struct sk_buff *skb;
+	u32 data[4];
 	int ret;
 
 	skb = qca8k_alloc_mdio_header(MDIO_READ, reg, NULL,
@@ -249,12 +250,13 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 	skb->dev = priv->mgmt_master;
 
 	ret = dsa_inband_request(&mgmt_eth_data->inband, skb,
-			      qca8k_mdio_header_fill_seq_num,
-			      QCA8K_ETHERNET_TIMEOUT);
+				 qca8k_mdio_header_fill_seq_num,
+				 &data, sizeof(data),
+				 QCA8K_ETHERNET_TIMEOUT);
 
-	*val = mgmt_eth_data->data[0];
+	*val = data[0];
 	if (len > QCA_HDR_MGMT_DATA1_LEN)
-		memcpy(val + 1, mgmt_eth_data->data + 1, len - QCA_HDR_MGMT_DATA1_LEN);
+		memcpy(val + 1, &data[1], len - QCA_HDR_MGMT_DATA1_LEN);
 
 	mutex_unlock(&mgmt_eth_data->mutex);
 
@@ -285,6 +287,7 @@ static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 
 	ret = dsa_inband_request(&mgmt_eth_data->inband, skb,
 				 qca8k_mdio_header_fill_seq_num,
+				 NULL, 0,
 				 QCA8K_ETHERNET_TIMEOUT);
 
 	mutex_unlock(&mgmt_eth_data->mutex);
@@ -412,16 +415,18 @@ qca8k_phy_eth_busy_wait(struct qca8k_mgmt_eth_data *mgmt_eth_data,
 			struct sk_buff *read_skb, u32 *val)
 {
 	struct sk_buff *skb = skb_copy(read_skb, GFP_KERNEL);
+	u32 data[4];
 	int ret;
 
 	ret = dsa_inband_request(&mgmt_eth_data->inband, skb,
 				 qca8k_mdio_header_fill_seq_num,
+				 &data, sizeof(data),
 				 QCA8K_ETHERNET_TIMEOUT);
 
 	if (ret)
 		return ret;
 
-	*val = mgmt_eth_data->data[0];
+	*val = data[0];
 
 	return 0;
 }
@@ -434,6 +439,7 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 	struct qca8k_mgmt_eth_data *mgmt_eth_data;
 	u32 write_val, clear_val = 0, val;
 	struct net_device *mgmt_master;
+	u32 resp_data[4];
 	int ret, ret1;
 
 	if (regnum >= QCA8K_MDIO_MASTER_MAX_REG)
@@ -494,6 +500,7 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 
 	ret = dsa_inband_request(&mgmt_eth_data->inband, write_skb,
 				 qca8k_mdio_header_fill_seq_num,
+				 NULL, 0,
 				 QCA8K_ETHERNET_TIMEOUT);
 
 	if (ret) {
@@ -514,12 +521,13 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 	if (read) {
 		ret = dsa_inband_request(&mgmt_eth_data->inband, read_skb,
 					 qca8k_mdio_header_fill_seq_num,
+					 &resp_data, sizeof(resp_data),
 					 QCA8K_ETHERNET_TIMEOUT);
 
 		if (ret)
 			goto exit;
 
-		ret = mgmt_eth_data->data[0] & QCA8K_MDIO_MASTER_DATA_MASK;
+		ret = resp_data[0] & QCA8K_MDIO_MASTER_DATA_MASK;
 	} else {
 		kfree_skb(read_skb);
 	}
@@ -527,6 +535,7 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 
 	ret = dsa_inband_request(&mgmt_eth_data->inband, clear_skb,
 				 qca8k_mdio_header_fill_seq_num,
+				 NULL, 0,
 				 QCA8K_ETHERNET_TIMEOUT);
 
 	mutex_unlock(&mgmt_eth_data->mutex);
@@ -1442,7 +1451,7 @@ static void qca8k_mib_autocast_handler(struct dsa_switch *ds, struct sk_buff *sk
 exit:
 	/* Complete on receiving all the mib packet */
 	if (refcount_dec_and_test(&mib_eth_data->port_parsed))
-		dsa_inband_complete(&mib_eth_data->inband, err);
+		dsa_inband_complete(&mib_eth_data->inband, NULL, 0, err);
 }
 
 static int
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index 682106206282..70494096e251 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -348,7 +348,6 @@ enum {
 struct qca8k_mgmt_eth_data {
 	struct dsa_inband inband;
 	struct mutex mutex; /* Enforce one mdio read/write at time */
-	u32 data[4];
 };
 
 struct qca8k_mib_eth_data {
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 1a920f89b667..dad9e31d36ce 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -1285,12 +1285,17 @@ struct dsa_inband {
 	u32 seqno;
 	u32 seqno_mask;
 	int err;
+	struct mutex resp_lock; /* Protects resp* members */
+	void *resp;
+	unsigned int resp_len;
 };
 
 void dsa_inband_init(struct dsa_inband *inband, u32 seqno_mask);
-void dsa_inband_complete(struct dsa_inband *inband, int err);
+void dsa_inband_complete(struct dsa_inband *inband,
+		      void *resp, unsigned int resp_len, int err);
 int dsa_inband_request(struct dsa_inband *inband, struct sk_buff *skb,
 		       void (* insert_seqno)(struct sk_buff *skb, u32 seqno),
+		       void *resp, unsigned int resp_len,
 		       int timeout_ms);
 int dsa_inband_wait_for_completion(struct dsa_inband *inband, int timeout_ms);
 u32 dsa_inband_seqno(struct dsa_inband *inband);
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 0de283ac0bfc..4fa0ab4ae58e 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -521,14 +521,24 @@ EXPORT_SYMBOL_GPL(dsa_mdb_present_in_other_db);
 void dsa_inband_init(struct dsa_inband *inband, u32 seqno_mask)
 {
 	init_completion(&inband->completion);
+	mutex_init(&inband->resp_lock);
 	inband->seqno_mask = seqno_mask;
 	inband->seqno = 0;
 }
 EXPORT_SYMBOL_GPL(dsa_inband_init);
 
-void dsa_inband_complete(struct dsa_inband *inband, int err)
+void dsa_inband_complete(struct dsa_inband *inband,
+			 void *resp, unsigned int resp_len,
+			 int err)
 {
 	inband->err = err;
+
+	mutex_lock(&inband->resp_lock);
+	resp_len = min(inband->resp_len, resp_len);
+	if (inband->resp && resp)
+		memcpy(inband->resp, resp, resp_len);
+	mutex_unlock(&inband->resp_lock);
+
 	complete(&inband->completion);
 }
 EXPORT_SYMBOL_GPL(dsa_inband_complete);
@@ -548,6 +558,7 @@ EXPORT_SYMBOL_GPL(dsa_inband_wait_for_completion);
  */
 int dsa_inband_request(struct dsa_inband *inband, struct sk_buff *skb,
 		       void (* insert_seqno)(struct sk_buff *skb, u32 seqno),
+		       void *resp, unsigned int resp_len,
 		       int timeout_ms)
 {
 	unsigned long jiffies = msecs_to_jiffies(timeout_ms);
@@ -556,6 +567,11 @@ int dsa_inband_request(struct dsa_inband *inband, struct sk_buff *skb,
 	reinit_completion(&inband->completion);
 	inband->err = 0;
 
+	mutex_lock(&inband->resp_lock);
+	inband->resp = resp;
+	inband->resp_len = resp_len;
+	mutex_unlock(&inband->resp_lock);
+
 	if (insert_seqno) {
 		inband->seqno++;
 		insert_seqno(skb, inband->seqno & inband->seqno_mask);
@@ -564,6 +580,12 @@ int dsa_inband_request(struct dsa_inband *inband, struct sk_buff *skb,
 	dev_queue_xmit(skb);
 
 	ret = wait_for_completion_timeout(&inband->completion, jiffies);
+
+	mutex_lock(&inband->resp_lock);
+	inband->resp = NULL;
+	inband->resp_len = 0;
+	mutex_unlock(&inband->resp_lock);
+
 	if (ret < 0)
 		return ret;
 	if (ret == 0)
-- 
2.37.2

