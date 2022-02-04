Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 043DC4A915B
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 01:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243685AbiBDABX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 19:01:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbiBDABW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 19:01:22 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CEE5C061714;
        Thu,  3 Feb 2022 16:01:22 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id j5-20020a05600c1c0500b0034d2e956aadso2798590wms.4;
        Thu, 03 Feb 2022 16:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IAgjzoa8zqymGZnAHUIzsBT6GMaNixaEOKHQOBV23N8=;
        b=U7C+BhOjdpmQAMXnIW+YmZCLhR1UsCPkWvLtpp5D2RFMx0PZr9dfNn8BtTWQD91bXx
         Lxqpi6uSPOFrid78L1EUQmke6Z8zBmG4/LfMsOzt3qqlhrYux6rWJvcJkbGLy/WrsRQw
         odHJGqce9HqjBHOkV2vp/MiH4oSjap8ERVx2xmowPWA13dwBOZUt1HsXyrnt2vujEOta
         mDm9FuAsiaQs4+T7Qcre89nE7QRNR9V9Y4mEu22B4+/iiAzNry+Mz9Vq3+y56+ZwlmZb
         swXtTex3HXyCu8nJnE1QRrFsBcyNbwzCVcWHVudjWljjv4anYr4UAlBiUuZwqWkcBrfB
         Es8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IAgjzoa8zqymGZnAHUIzsBT6GMaNixaEOKHQOBV23N8=;
        b=hhPNpnDIANCYjbONUl0JOxd/INUyZHbbRRZUoVJ7ci4Z1MhhVIvmw6coLmWVLbQq8c
         GFE0sjt2mWY033mBAPg685tepWJ5rV5d+YX2Bmp0mGu8IeVkUaIjHzbAWbWaVv0OWMYz
         S3sySidqfQCTdSAWYTbAnFZUsfBYHXEZ9ZkX1rrTZWMeLy3aKQ3j2snQfjNWWlslQseo
         9nsyJIk2Kt82223pAshx0WYepZ4Qcq/eX7pTYVck3ddezQBAaE8laa6sWNxASIoG6ECy
         f/SvlOYHqAoBpmmaUg2sNopNrrvo7/lOA4bemYxOHajbWnTzRb5VOM8OyPtwVXuYuOYc
         flEw==
X-Gm-Message-State: AOAM531RzkpxOsPk20dDrI75iCOfmyODTcsgsVWHmD5YbwV/IKlcLRCX
        KohP7hrQMio29PSHH29bSGg=
X-Google-Smtp-Source: ABdhPJw7LxpEvUuX5Iq+TtllxzXubRorkornP8J9cUVQl5XNwuQ3S71gZBnABz/r4GUmX1CT9+8ihw==
X-Received: by 2002:a05:600c:1f15:: with SMTP id bd21mr93275wmb.145.1643932880450;
        Thu, 03 Feb 2022 16:01:20 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id 5sm234298wrb.113.2022.02.03.16.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 16:01:19 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH] drivers: net: dsa: qca8k: use build_skb for mgmt eth packet
Date:   Fri,  4 Feb 2022 01:01:18 +0100
Message-Id: <20220204000118.26051-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use preallocated space and build_skb to recycle the same skb for mgmt
eth packet. This should reduce the CPU load even more by skipping
skb allocation for every mgmt eth packet. We increate the skb users with
skb_get() to prevent the release of the skb so that the space can be
reused.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 158 ++++++++++++++++++++++------------------
 drivers/net/dsa/qca8k.h |   1 +
 2 files changed, 88 insertions(+), 71 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 52ec2800dd89..6fc1f2b4bceb 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -233,7 +233,7 @@ static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
 	complete(&mgmt_eth_data->rw_done);
 }
 
-static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *val,
+static struct sk_buff *qca8k_build_mdio_header(u8 *data, enum mdio_cmd cmd, u32 reg, u32 *val,
 					       int priority, unsigned int len)
 {
 	struct qca_mgmt_ethhdr *mgmt_ethhdr;
@@ -242,10 +242,12 @@ static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *
 	u32 *data2;
 	u16 hdr;
 
-	skb = dev_alloc_skb(QCA_HDR_MGMT_PKT_LEN);
+	skb = build_skb(data, 0);
 	if (!skb)
 		return NULL;
 
+	skb_reserve(skb, NET_SKB_PAD + QCA_HDR_MGMT_PKT_LEN);
+
 	/* Max value for len reg is 15 (0xf) but the switch actually return 16 byte
 	 * Actually for some reason the steps are:
 	 * 0: nothing
@@ -260,6 +262,7 @@ static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *
 
 	skb_reset_mac_header(skb);
 	skb_set_network_header(skb, skb->len);
+	skb_get(skb);
 
 	mgmt_ethhdr = skb_push(skb, QCA_HDR_MGMT_HEADER_LEN + QCA_HDR_LEN);
 
@@ -302,20 +305,21 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 	bool ack;
 	int ret;
 
-	skb = qca8k_alloc_mdio_header(MDIO_READ, reg, NULL,
-				      QCA8K_ETHERNET_MDIO_PRIORITY, len);
-	if (!skb)
-		return -ENOMEM;
-
 	mutex_lock(&mgmt_eth_data->mutex);
 
 	/* Check mgmt_master if is operational */
 	if (!priv->mgmt_master) {
-		kfree_skb(skb);
 		mutex_unlock(&mgmt_eth_data->mutex);
 		return -EINVAL;
 	}
 
+	skb = qca8k_build_mdio_header(mgmt_eth_data->mgmt_pkt, MDIO_READ, reg, NULL,
+				      QCA8K_ETHERNET_MDIO_PRIORITY, len);
+	if (!skb) {
+		mutex_unlock(&mgmt_eth_data->mutex);
+		return -ENOMEM;
+	}
+
 	skb->dev = priv->mgmt_master;
 
 	reinit_completion(&mgmt_eth_data->rw_done);
@@ -354,20 +358,21 @@ static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 	bool ack;
 	int ret;
 
-	skb = qca8k_alloc_mdio_header(MDIO_WRITE, reg, val,
-				      QCA8K_ETHERNET_MDIO_PRIORITY, len);
-	if (!skb)
-		return -ENOMEM;
-
 	mutex_lock(&mgmt_eth_data->mutex);
 
 	/* Check mgmt_master if is operational */
 	if (!priv->mgmt_master) {
-		kfree_skb(skb);
 		mutex_unlock(&mgmt_eth_data->mutex);
 		return -EINVAL;
 	}
 
+	skb = qca8k_build_mdio_header(mgmt_eth_data->mgmt_pkt, MDIO_WRITE, reg, val,
+				      QCA8K_ETHERNET_MDIO_PRIORITY, len);
+	if (!skb) {
+		mutex_unlock(&mgmt_eth_data->mutex);
+		return -ENOMEM;
+	}
+
 	skb->dev = priv->mgmt_master;
 
 	reinit_completion(&mgmt_eth_data->rw_done);
@@ -952,12 +957,21 @@ qca8k_port_set_status(struct qca8k_priv *priv, int port, int enable)
 
 static int
 qca8k_phy_eth_busy_wait(struct qca8k_mgmt_eth_data *mgmt_eth_data,
-			struct sk_buff *read_skb, u32 *val)
+			struct net_device *dev, u32 *val)
 {
-	struct sk_buff *skb = skb_copy(read_skb, GFP_KERNEL);
+	struct sk_buff *skb;
+	u32 clear_val = 0;
 	bool ack;
 	int ret;
 
+	skb = qca8k_build_mdio_header(mgmt_eth_data->mgmt_pkt, MDIO_READ,
+				      QCA8K_MDIO_MASTER_CTRL, &clear_val,
+				      QCA8K_ETHERNET_PHY_PRIORITY, sizeof(clear_val));
+	if (!skb)
+		return -ENOMEM;
+
+	skb->dev = dev;
+
 	reinit_completion(&mgmt_eth_data->rw_done);
 
 	/* Increment seq_num and set it in the copy pkt */
@@ -987,10 +1001,10 @@ static int
 qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 		      int regnum, u16 data)
 {
-	struct sk_buff *write_skb, *clear_skb, *read_skb;
 	struct qca8k_mgmt_eth_data *mgmt_eth_data;
 	u32 write_val, clear_val = 0, val;
 	struct net_device *mgmt_master;
+	struct sk_buff *skb;
 	int ret, ret1;
 	bool ack;
 
@@ -1010,26 +1024,6 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 		write_val |= QCA8K_MDIO_MASTER_DATA(data);
 	}
 
-	/* Prealloc all the needed skb before the lock */
-	write_skb = qca8k_alloc_mdio_header(MDIO_WRITE, QCA8K_MDIO_MASTER_CTRL, &write_val,
-					    QCA8K_ETHERNET_PHY_PRIORITY, sizeof(write_val));
-	if (!write_skb)
-		return -ENOMEM;
-
-	clear_skb = qca8k_alloc_mdio_header(MDIO_WRITE, QCA8K_MDIO_MASTER_CTRL, &clear_val,
-					    QCA8K_ETHERNET_PHY_PRIORITY, sizeof(clear_val));
-	if (!write_skb) {
-		ret = -ENOMEM;
-		goto err_clear_skb;
-	}
-
-	read_skb = qca8k_alloc_mdio_header(MDIO_READ, QCA8K_MDIO_MASTER_CTRL, &clear_val,
-					   QCA8K_ETHERNET_PHY_PRIORITY, sizeof(clear_val));
-	if (!read_skb) {
-		ret = -ENOMEM;
-		goto err_read_skb;
-	}
-
 	/* Actually start the request:
 	 * 1. Send mdio master packet
 	 * 2. Busy Wait for mdio master command
@@ -1042,22 +1036,27 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 	mgmt_master = priv->mgmt_master;
 	if (!mgmt_master) {
 		mutex_unlock(&mgmt_eth_data->mutex);
-		ret = -EINVAL;
-		goto err_mgmt_master;
+		return -EINVAL;
+	}
+
+	skb = qca8k_build_mdio_header(mgmt_eth_data->mgmt_pkt, MDIO_WRITE,
+				      QCA8K_MDIO_MASTER_CTRL, &write_val,
+				      QCA8K_ETHERNET_PHY_PRIORITY, sizeof(write_val));
+	if (!skb) {
+		ret = -ENOMEM;
+		goto err;
 	}
 
-	read_skb->dev = mgmt_master;
-	clear_skb->dev = mgmt_master;
-	write_skb->dev = mgmt_master;
+	skb->dev = mgmt_master;
 
 	reinit_completion(&mgmt_eth_data->rw_done);
 
 	/* Increment seq_num and set it in the write pkt */
 	mgmt_eth_data->seq++;
-	qca8k_mdio_header_fill_seq_num(write_skb, mgmt_eth_data->seq);
+	qca8k_mdio_header_fill_seq_num(skb, mgmt_eth_data->seq);
 	mgmt_eth_data->ack = false;
 
-	dev_queue_xmit(write_skb);
+	dev_queue_xmit(skb);
 
 	ret = wait_for_completion_timeout(&mgmt_eth_data->rw_done,
 					  QCA8K_ETHERNET_TIMEOUT);
@@ -1066,35 +1065,43 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 
 	if (ret <= 0) {
 		ret = -ETIMEDOUT;
-		kfree_skb(read_skb);
-		goto exit;
+		goto err;
 	}
 
 	if (!ack) {
 		ret = -EINVAL;
-		kfree_skb(read_skb);
-		goto exit;
+		goto err;
 	}
 
 	ret = read_poll_timeout(qca8k_phy_eth_busy_wait, ret1,
 				!(val & QCA8K_MDIO_MASTER_BUSY), 0,
 				QCA8K_BUSY_WAIT_TIMEOUT * USEC_PER_MSEC, false,
-				mgmt_eth_data, read_skb, &val);
+				mgmt_eth_data, mgmt_master, &val);
 
 	if (ret < 0 && ret1 < 0) {
 		ret = ret1;
-		goto exit;
+		goto err;
 	}
 
 	if (read) {
+		skb = qca8k_build_mdio_header(mgmt_eth_data->mgmt_pkt, MDIO_READ,
+					      QCA8K_MDIO_MASTER_CTRL, &clear_val,
+					      QCA8K_ETHERNET_PHY_PRIORITY, sizeof(clear_val));
+		if (!skb) {
+			ret = -ENOMEM;
+			goto err;
+		}
+
+		skb->dev = mgmt_master;
+
 		reinit_completion(&mgmt_eth_data->rw_done);
 
 		/* Increment seq_num and set it in the read pkt */
 		mgmt_eth_data->seq++;
-		qca8k_mdio_header_fill_seq_num(read_skb, mgmt_eth_data->seq);
+		qca8k_mdio_header_fill_seq_num(skb, mgmt_eth_data->seq);
 		mgmt_eth_data->ack = false;
 
-		dev_queue_xmit(read_skb);
+		dev_queue_xmit(skb);
 
 		ret = wait_for_completion_timeout(&mgmt_eth_data->rw_done,
 						  QCA8K_ETHERNET_TIMEOUT);
@@ -1103,44 +1110,43 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 
 		if (ret <= 0) {
 			ret = -ETIMEDOUT;
-			goto exit;
+			goto err;
 		}
 
 		if (!ack) {
 			ret = -EINVAL;
-			goto exit;
+			goto err;
 		}
 
 		ret = mgmt_eth_data->data[0] & QCA8K_MDIO_MASTER_DATA_MASK;
-	} else {
-		kfree_skb(read_skb);
 	}
-exit:
+
+err:
+	skb = qca8k_build_mdio_header(mgmt_eth_data->mgmt_pkt, MDIO_WRITE,
+				      QCA8K_MDIO_MASTER_CTRL, &clear_val,
+				      QCA8K_ETHERNET_PHY_PRIORITY, sizeof(clear_val));
+	if (!skb) {
+		ret = -ENOMEM;
+		goto exit;
+	}
+
+	skb->dev = mgmt_master;
+
 	reinit_completion(&mgmt_eth_data->rw_done);
 
 	/* Increment seq_num and set it in the clear pkt */
 	mgmt_eth_data->seq++;
-	qca8k_mdio_header_fill_seq_num(clear_skb, mgmt_eth_data->seq);
+	qca8k_mdio_header_fill_seq_num(skb, mgmt_eth_data->seq);
 	mgmt_eth_data->ack = false;
 
-	dev_queue_xmit(clear_skb);
+	dev_queue_xmit(skb);
 
 	wait_for_completion_timeout(&mgmt_eth_data->rw_done,
 				    QCA8K_ETHERNET_TIMEOUT);
-
+exit:
 	mutex_unlock(&mgmt_eth_data->mutex);
 
 	return ret;
-
-	/* Error handling before lock */
-err_mgmt_master:
-	kfree_skb(read_skb);
-err_read_skb:
-	kfree_skb(clear_skb);
-err_clear_skb:
-	kfree_skb(write_skb);
-
-	return ret;
 }
 
 static u32
@@ -2984,15 +2990,25 @@ qca8k_master_change(struct dsa_switch *ds, const struct net_device *master,
 {
 	struct dsa_port *dp = master->dsa_ptr;
 	struct qca8k_priv *priv = ds->priv;
+	int skb_size;
 
 	/* Ethernet MIB/MDIO is only supported for CPU port 0 */
 	if (dp->index != 0)
 		return;
 
+	skb_size = NET_SKB_PAD + QCA_HDR_MGMT_PKT_LEN +
+		   SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+
 	mutex_lock(&priv->mgmt_eth_data.mutex);
 	mutex_lock(&priv->mib_eth_data.mutex);
 
-	priv->mgmt_master = operational ? (struct net_device *)master : NULL;
+	if (operational) {
+		priv->mgmt_master = (struct net_device *)master;
+		priv->mgmt_eth_data.mgmt_pkt = kzalloc(skb_size, GFP_KERNEL);
+	} else {
+		priv->mgmt_master = NULL;
+		kfree(priv->mgmt_eth_data.mgmt_pkt);
+	}
 
 	mutex_unlock(&priv->mib_eth_data.mutex);
 	mutex_unlock(&priv->mgmt_eth_data.mutex);
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index c3d3c2269b1d..d82f2a02f542 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -345,6 +345,7 @@ struct qca8k_mgmt_eth_data {
 	bool ack;
 	u32 seq;
 	u32 data[4];
+	u8 *mgmt_pkt;
 };
 
 struct qca8k_mib_eth_data {
-- 
2.34.1

