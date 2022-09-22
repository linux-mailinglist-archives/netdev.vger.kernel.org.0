Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 774885E6A25
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 19:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbiIVR7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 13:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232327AbiIVR6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 13:58:47 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9469106533
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 10:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xhnEXnME6jxat0DKxtYNU/EQ66A7POLznSGwmRyvOH8=; b=IRf0O4eQnQ7doJsujw87f61TlU
        Vnc94Ms7hWjMK8I6Q6E9ClcjRJMEc70wu9St4ZVxnIzl2wTkGOnqkTSUKyjK7U0yZhgfpr+FXpiET
        TiOXvS9KzJ/z9gUSHkPcrLotcuamqcWEuHw+P2EsG+26CRP09GkIv+qrguLixib0/hXI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1obQTA-00HYd5-L5; Thu, 22 Sep 2022 19:58:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     mattias.forsblad@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH rfc v2 09/10] net: dsa: qca8k: Pass response buffer via dsa_rmu_request
Date:   Thu, 22 Sep 2022 19:58:20 +0200
Message-Id: <20220922175821.4184622-10-andrew@lunn.ch>
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

Make the calling of operations on the switch more like a request
response API by passing the address of the response buffer, rather
than making use of global state.

To avoid race conditions with the completion timeout, and late
arriving responses, protect the resp members via a spinlock.

The qca8k response frame has an odd layout, the reply is not
contiguous. Use a small intermediary buffer to convert the reply into
something which can be memcpy'ed.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
v2:
Replace mutex with spinlock, since processing the response cannot block.
Add more documentation about what the lock protects.
Add a return value check
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 30 +++++++++++++++++++++---------
 drivers/net/dsa/qca/qca8k.h      |  1 -
 include/net/dsa.h                | 12 +++++++++++-
 net/dsa/dsa.c                    | 24 +++++++++++++++++++++++-
 4 files changed, 55 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 096b43f89869..e0dc6dbafefe 100644
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
 		return;
 
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
@@ -250,12 +251,16 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 
 	ret = dsa_inband_request(&mgmt_eth_data->inband, skb,
 				 qca8k_mdio_header_fill_seq_num,
+				 &data, sizeof(data),
 				 QCA8K_ETHERNET_TIMEOUT);
+	if (ret < 0)
+		goto out;
 
-	*val = mgmt_eth_data->data[0];
+	*val = data[0];
 	if (len > QCA_HDR_MGMT_DATA1_LEN)
-		memcpy(val + 1, mgmt_eth_data->data + 1, len - QCA_HDR_MGMT_DATA1_LEN);
+		memcpy(val + 1, &data[1], len - QCA_HDR_MGMT_DATA1_LEN);
 
+out:
 	mutex_unlock(&mgmt_eth_data->mutex);
 
 	return ret;
@@ -285,6 +290,7 @@ static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 
 	ret = dsa_inband_request(&mgmt_eth_data->inband, skb,
 				 qca8k_mdio_header_fill_seq_num,
+				 NULL, 0,
 				 QCA8K_ETHERNET_TIMEOUT);
 
 	mutex_unlock(&mgmt_eth_data->mutex);
@@ -412,16 +418,18 @@ qca8k_phy_eth_busy_wait(struct qca8k_mgmt_eth_data *mgmt_eth_data,
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
@@ -434,6 +442,7 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 	struct qca8k_mgmt_eth_data *mgmt_eth_data;
 	u32 write_val, clear_val = 0, val;
 	struct net_device *mgmt_master;
+	u32 resp_data[4];
 	int ret, ret1;
 
 	if (regnum >= QCA8K_MDIO_MASTER_MAX_REG)
@@ -494,6 +503,7 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 
 	ret = dsa_inband_request(&mgmt_eth_data->inband, write_skb,
 				 qca8k_mdio_header_fill_seq_num,
+				 NULL, 0,
 				 QCA8K_ETHERNET_TIMEOUT);
 
 	if (ret) {
@@ -514,12 +524,13 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
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
@@ -528,6 +539,7 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 	/* This is expected to fail sometimes, so don't check return value. */
 	dsa_inband_request(&mgmt_eth_data->inband, clear_skb,
 			   qca8k_mdio_header_fill_seq_num,
+			   NULL, 0,
 			   QCA8K_ETHERNET_TIMEOUT);
 
 	mutex_unlock(&mgmt_eth_data->mutex);
@@ -1443,7 +1455,7 @@ static void qca8k_mib_autocast_handler(struct dsa_switch *ds, struct sk_buff *sk
 exit:
 	/* Complete on receiving all the mib packet */
 	if (refcount_dec_and_test(&mib_eth_data->port_parsed))
-		dsa_inband_complete(&mib_eth_data->inband, err);
+		dsa_inband_complete(&mib_eth_data->inband, NULL, 0, err);
 }
 
 static int
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index ce27a732dba0..e58cd7a5f91a 100644
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
index 497d0eb85cf1..7450f413b709 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -1306,18 +1306,28 @@ bool dsa_mdb_present_in_other_db(struct dsa_switch *ds, int port,
 
 /* Perform operations on a switch by sending it request in Ethernet
  * frames and expecting a response in a frame.
+ *
+ * resp_lock protects resp and resp_len to ensure they are consistent.
+ * If there is a thread waiting for the response, resp will point to a
+ * buffer to copy the response to. If the thread has given up waiting,
+ * resp will be a NULL pointer.
  */
 struct dsa_inband {
 	struct completion completion;
 	u32 seqno;
 	u32 seqno_mask;
 	int err;
+	spinlock_t resp_lock;
+	void *resp;
+	unsigned int resp_len;
 };
 
 void dsa_inband_init(struct dsa_inband *inband, u32 seqno_mask);
-void dsa_inband_complete(struct dsa_inband *inband, int err);
+void dsa_inband_complete(struct dsa_inband *inband,
+		      void *resp, unsigned int resp_len, int err);
 int dsa_inband_request(struct dsa_inband *inband, struct sk_buff *skb,
 		       void (*insert_seqno)(struct sk_buff *skb, u32 seqno),
+		       void *resp, unsigned int resp_len,
 		       int timeout_ms);
 int dsa_inband_wait_for_completion(struct dsa_inband *inband, int timeout_ms);
 u32 dsa_inband_seqno(struct dsa_inband *inband);
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index a426459c74c5..fc7be84dbafb 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -521,14 +521,24 @@ EXPORT_SYMBOL_GPL(dsa_mdb_present_in_other_db);
 void dsa_inband_init(struct dsa_inband *inband, u32 seqno_mask)
 {
 	init_completion(&inband->completion);
+	spin_lock_init(&inband->resp_lock);
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
+	spin_lock(&inband->resp_lock);
+	resp_len = min(inband->resp_len, resp_len);
+	if (inband->resp && resp)
+		memcpy(inband->resp, resp, resp_len);
+	spin_unlock(&inband->resp_lock);
+
 	complete(&inband->completion);
 }
 EXPORT_SYMBOL_GPL(dsa_inband_complete);
@@ -548,6 +558,7 @@ EXPORT_SYMBOL_GPL(dsa_inband_wait_for_completion);
  */
 int dsa_inband_request(struct dsa_inband *inband, struct sk_buff *skb,
 		       void (*insert_seqno)(struct sk_buff *skb, u32 seqno),
+		       void *resp, unsigned int resp_len,
 		       int timeout_ms)
 {
 	unsigned long jiffies = msecs_to_jiffies(timeout_ms);
@@ -555,6 +566,11 @@ int dsa_inband_request(struct dsa_inband *inband, struct sk_buff *skb,
 
 	inband->err = 0;
 
+	spin_lock(&inband->resp_lock);
+	inband->resp = resp;
+	inband->resp_len = resp_len;
+	spin_unlock(&inband->resp_lock);
+
 	if (insert_seqno) {
 		inband->seqno++;
 		insert_seqno(skb, inband->seqno & inband->seqno_mask);
@@ -565,6 +581,12 @@ int dsa_inband_request(struct dsa_inband *inband, struct sk_buff *skb,
 	dev_queue_xmit(skb);
 
 	ret = wait_for_completion_timeout(&inband->completion, jiffies);
+
+	spin_lock(&inband->resp_lock);
+	inband->resp = NULL;
+	inband->resp_len = 0;
+	spin_unlock(&inband->resp_lock);
+
 	if (ret == 0)
 		return -ETIMEDOUT;
 
-- 
2.37.2

