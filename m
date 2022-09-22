Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21D175E6A1F
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 19:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbiIVR6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 13:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232336AbiIVR6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 13:58:48 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC6FF3903
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 10:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=l4dGjDd4NyohDXbARXe9ROoednGUrvCBeItaYgOM3bY=; b=SyaeNVEl5TbKMXyK0QlrqBJnRH
        YGt+3oCi23VOxxC9MubZ0HDCBXZ1N83nBd07tNlmqCrXIG+AS1AxMrzrDLVsRZVeQg1DCOQCrLjN2
        q6nbmMQSo5v4srREduee++4LvyvysHkd+50c29AHNplkLeF2HBRQe24/GPd39m2TV+hQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1obQTA-00HYck-Am; Thu, 22 Sep 2022 19:58:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     mattias.forsblad@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH rfc v2 02/10] net: dsa: qca8k: Move completion into DSA core
Date:   Thu, 22 Sep 2022 19:58:13 +0200
Message-Id: <20220922175821.4184622-3-andrew@lunn.ch>
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

When performing operations on a remote switch using Ethernet frames, a
completion is used between the sender of the request and the code
which receives the reply.

Move this completion into the DSA core, simplifying the driver.  The
initialisation and reinitialisation of the completion is now performed
in the core. Also, the conversion of milliseconds to jiffies is also
in the core.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 49 ++++++++++++--------------------
 drivers/net/dsa/qca/qca8k.h      |  6 ++--
 include/net/dsa.h                | 12 ++++++++
 net/dsa/dsa.c                    | 22 ++++++++++++++
 4 files changed, 55 insertions(+), 34 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 1c9a8764d1d9..f4e92156bd32 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -160,7 +160,7 @@ static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
 			       QCA_HDR_MGMT_DATA2_LEN);
 	}
 
-	complete(&mgmt_eth_data->rw_done);
+	dsa_inband_complete(&mgmt_eth_data->inband);
 }
 
 static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *val,
@@ -248,8 +248,6 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 
 	skb->dev = priv->mgmt_master;
 
-	reinit_completion(&mgmt_eth_data->rw_done);
-
 	/* Increment seq_num and set it in the mdio pkt */
 	mgmt_eth_data->seq++;
 	qca8k_mdio_header_fill_seq_num(skb, mgmt_eth_data->seq);
@@ -257,8 +255,8 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 
 	dev_queue_xmit(skb);
 
-	ret = wait_for_completion_timeout(&mgmt_eth_data->rw_done,
-					  QCA8K_ETHERNET_TIMEOUT);
+	ret = dsa_inband_wait_for_completion(&mgmt_eth_data->inband,
+					     QCA8K_ETHERNET_TIMEOUT);
 
 	*val = mgmt_eth_data->data[0];
 	if (len > QCA_HDR_MGMT_DATA1_LEN)
@@ -300,8 +298,6 @@ static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 
 	skb->dev = priv->mgmt_master;
 
-	reinit_completion(&mgmt_eth_data->rw_done);
-
 	/* Increment seq_num and set it in the mdio pkt */
 	mgmt_eth_data->seq++;
 	qca8k_mdio_header_fill_seq_num(skb, mgmt_eth_data->seq);
@@ -309,8 +305,8 @@ static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 
 	dev_queue_xmit(skb);
 
-	ret = wait_for_completion_timeout(&mgmt_eth_data->rw_done,
-					  QCA8K_ETHERNET_TIMEOUT);
+	ret = dsa_inband_wait_for_completion(&mgmt_eth_data->inband,
+					     QCA8K_ETHERNET_TIMEOUT);
 
 	ack = mgmt_eth_data->ack;
 
@@ -448,8 +444,6 @@ qca8k_phy_eth_busy_wait(struct qca8k_mgmt_eth_data *mgmt_eth_data,
 	bool ack;
 	int ret;
 
-	reinit_completion(&mgmt_eth_data->rw_done);
-
 	/* Increment seq_num and set it in the copy pkt */
 	mgmt_eth_data->seq++;
 	qca8k_mdio_header_fill_seq_num(skb, mgmt_eth_data->seq);
@@ -457,8 +451,8 @@ qca8k_phy_eth_busy_wait(struct qca8k_mgmt_eth_data *mgmt_eth_data,
 
 	dev_queue_xmit(skb);
 
-	ret = wait_for_completion_timeout(&mgmt_eth_data->rw_done,
-					  QCA8K_ETHERNET_TIMEOUT);
+	ret = dsa_inband_wait_for_completion(&mgmt_eth_data->inband,
+					     QCA8K_ETHERNET_TIMEOUT);
 
 	ack = mgmt_eth_data->ack;
 
@@ -540,8 +534,6 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 	clear_skb->dev = mgmt_master;
 	write_skb->dev = mgmt_master;
 
-	reinit_completion(&mgmt_eth_data->rw_done);
-
 	/* Increment seq_num and set it in the write pkt */
 	mgmt_eth_data->seq++;
 	qca8k_mdio_header_fill_seq_num(write_skb, mgmt_eth_data->seq);
@@ -549,8 +541,8 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 
 	dev_queue_xmit(write_skb);
 
-	ret = wait_for_completion_timeout(&mgmt_eth_data->rw_done,
-					  QCA8K_ETHERNET_TIMEOUT);
+	ret = dsa_inband_wait_for_completion(&mgmt_eth_data->inband,
+					     QCA8K_ETHERNET_TIMEOUT);
 
 	ack = mgmt_eth_data->ack;
 
@@ -577,8 +569,6 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 	}
 
 	if (read) {
-		reinit_completion(&mgmt_eth_data->rw_done);
-
 		/* Increment seq_num and set it in the read pkt */
 		mgmt_eth_data->seq++;
 		qca8k_mdio_header_fill_seq_num(read_skb, mgmt_eth_data->seq);
@@ -586,8 +576,8 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 
 		dev_queue_xmit(read_skb);
 
-		ret = wait_for_completion_timeout(&mgmt_eth_data->rw_done,
-						  QCA8K_ETHERNET_TIMEOUT);
+		ret = dsa_inband_wait_for_completion(&mgmt_eth_data->inband,
+						     QCA8K_ETHERNET_TIMEOUT);
 
 		ack = mgmt_eth_data->ack;
 
@@ -606,8 +596,6 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 		kfree_skb(read_skb);
 	}
 exit:
-	reinit_completion(&mgmt_eth_data->rw_done);
-
 	/* Increment seq_num and set it in the clear pkt */
 	mgmt_eth_data->seq++;
 	qca8k_mdio_header_fill_seq_num(clear_skb, mgmt_eth_data->seq);
@@ -615,8 +603,8 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 
 	dev_queue_xmit(clear_skb);
 
-	wait_for_completion_timeout(&mgmt_eth_data->rw_done,
-				    QCA8K_ETHERNET_TIMEOUT);
+	dsa_inband_wait_for_completion(&mgmt_eth_data->inband,
+				       QCA8K_ETHERNET_TIMEOUT);
 
 	mutex_unlock(&mgmt_eth_data->mutex);
 
@@ -1528,7 +1516,7 @@ static void qca8k_mib_autocast_handler(struct dsa_switch *ds, struct sk_buff *sk
 exit:
 	/* Complete on receiving all the mib packet */
 	if (refcount_dec_and_test(&mib_eth_data->port_parsed))
-		complete(&mib_eth_data->rw_done);
+		dsa_inband_complete(&mib_eth_data->inband);
 }
 
 static int
@@ -1543,8 +1531,6 @@ qca8k_get_ethtool_stats_eth(struct dsa_switch *ds, int port, u64 *data)
 
 	mutex_lock(&mib_eth_data->mutex);
 
-	reinit_completion(&mib_eth_data->rw_done);
-
 	mib_eth_data->req_port = dp->index;
 	mib_eth_data->data = data;
 	refcount_set(&mib_eth_data->port_parsed, QCA8K_NUM_PORTS);
@@ -1562,7 +1548,8 @@ qca8k_get_ethtool_stats_eth(struct dsa_switch *ds, int port, u64 *data)
 	if (ret)
 		goto exit;
 
-	ret = wait_for_completion_timeout(&mib_eth_data->rw_done, QCA8K_ETHERNET_TIMEOUT);
+	ret = dsa_inband_wait_for_completion(&mib_eth_data->inband,
+					     QCA8K_ETHERNET_TIMEOUT);
 
 exit:
 	mutex_unlock(&mib_eth_data->mutex);
@@ -1929,10 +1916,10 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 		return -ENOMEM;
 
 	mutex_init(&priv->mgmt_eth_data.mutex);
-	init_completion(&priv->mgmt_eth_data.rw_done);
+	dsa_inband_init(&priv->mgmt_eth_data.inband);
 
 	mutex_init(&priv->mib_eth_data.mutex);
-	init_completion(&priv->mib_eth_data.rw_done);
+	dsa_inband_init(&priv->mib_eth_data.inband);
 
 	priv->ds->dev = &mdiodev->dev;
 	priv->ds->num_ports = QCA8K_NUM_PORTS;
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index 900382aa8c96..84d6b02d75fb 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -15,7 +15,7 @@
 
 #define QCA8K_ETHERNET_MDIO_PRIORITY			7
 #define QCA8K_ETHERNET_PHY_PRIORITY			6
-#define QCA8K_ETHERNET_TIMEOUT				msecs_to_jiffies(5)
+#define QCA8K_ETHERNET_TIMEOUT				5
 
 #define QCA8K_NUM_PORTS					7
 #define QCA8K_NUM_CPU_PORTS				2
@@ -346,7 +346,7 @@ enum {
 };
 
 struct qca8k_mgmt_eth_data {
-	struct completion rw_done;
+	struct dsa_inband inband;
 	struct mutex mutex; /* Enforce one mdio read/write at time */
 	bool ack;
 	u32 seq;
@@ -354,7 +354,7 @@ struct qca8k_mgmt_eth_data {
 };
 
 struct qca8k_mib_eth_data {
-	struct completion rw_done;
+	struct dsa_inband inband;
 	struct mutex mutex; /* Process one command at time */
 	refcount_t port_parsed; /* Counter to track parsed port */
 	u8 req_port;
diff --git a/include/net/dsa.h b/include/net/dsa.h
index d777eac5694f..59dd5855dcbd 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -7,6 +7,7 @@
 #ifndef __LINUX_NET_DSA_H
 #define __LINUX_NET_DSA_H
 
+#include <linux/completion.h>
 #include <linux/if.h>
 #include <linux/if_ether.h>
 #include <linux/list.h>
@@ -1303,6 +1304,17 @@ bool dsa_mdb_present_in_other_db(struct dsa_switch *ds, int port,
 				 const struct switchdev_obj_port_mdb *mdb,
 				 struct dsa_db db);
 
+/* Perform operations on a switch by sending it request in Ethernet
+ * frames and expecting a response in a frame.
+ */
+struct dsa_inband {
+	struct completion completion;
+};
+
+void dsa_inband_init(struct dsa_inband *inband);
+void dsa_inband_complete(struct dsa_inband *inband);
+int dsa_inband_wait_for_completion(struct dsa_inband *inband, int timeout_ms);
+
 /* Keep inline for faster access in hot path */
 static inline bool netdev_uses_dsa(const struct net_device *dev)
 {
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 64b14f655b23..fc031e9693ee 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -518,6 +518,28 @@ bool dsa_mdb_present_in_other_db(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL_GPL(dsa_mdb_present_in_other_db);
 
+void dsa_inband_init(struct dsa_inband *inband)
+{
+	init_completion(&inband->completion);
+}
+EXPORT_SYMBOL_GPL(dsa_inband_init);
+
+void dsa_inband_complete(struct dsa_inband *inband)
+{
+	complete(&inband->completion);
+}
+EXPORT_SYMBOL_GPL(dsa_inband_complete);
+
+int dsa_inband_wait_for_completion(struct dsa_inband *inband, int timeout_ms)
+{
+	unsigned long jiffies = msecs_to_jiffies(timeout_ms);
+
+	reinit_completion(&inband->completion);
+
+	return wait_for_completion_timeout(&inband->completion, jiffies);
+}
+EXPORT_SYMBOL_GPL(dsa_inband_wait_for_completion);
+
 static int __init dsa_init_module(void)
 {
 	int rc;
-- 
2.37.2

