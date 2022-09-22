Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 221575E6A27
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 19:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbiIVR7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 13:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbiIVR6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 13:58:45 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 171C710652B
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 10:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Yn5ODjXsWIxCHBGRebYEzjF9dfkT8rmI7H73fe9Skyk=; b=Q0t8X3F400fdkDalmUmyhgJvYA
        UWxyPNM7jGXtRq8QObHwZ4yQbRa2xjdJEuc+D2UBKyHW8G8RAA9iUcXHolouUwumfDdLuWJ7KIFMF
        teY8ygfPn4v1GkJPCcFkq/+zkw/FxwVHIw5AVi4R9sk7AMwh27qwX8AFbrnf3tjHw3XY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1obQTA-00HYcn-CP; Thu, 22 Sep 2022 19:58:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     mattias.forsblad@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH rfc v2 03/10] net: dsa: qca8K: Move queuing for request frame into the core
Date:   Thu, 22 Sep 2022 19:58:14 +0200
Message-Id: <20220922175821.4184622-4-andrew@lunn.ch>
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

Combine the queuing of the request and waiting for the completion into
one core helper. Add the function dsa_rmu_request() to perform this.

Access to statistics is not a strict request/reply, so the
dsa_rmu_wait_for_completion needs to be kept.

It is also no possible to combine dsa_rmu_request() and
dsa_rmu_wait_for_completion() since we need to avoid the race of
sending the request, receiving a reply, and the completion has not
been reinitialised because the schedule at decided to do other things.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 32 ++++++++++----------------------
 include/net/dsa.h                |  2 ++
 net/dsa/dsa.c                    | 16 ++++++++++++++++
 3 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index f4e92156bd32..9c44a09590a6 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -253,10 +253,8 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 	qca8k_mdio_header_fill_seq_num(skb, mgmt_eth_data->seq);
 	mgmt_eth_data->ack = false;
 
-	dev_queue_xmit(skb);
-
-	ret = dsa_inband_wait_for_completion(&mgmt_eth_data->inband,
-					     QCA8K_ETHERNET_TIMEOUT);
+	ret = dsa_inband_request(&mgmt_eth_data->inband, skb,
+				 QCA8K_ETHERNET_TIMEOUT);
 
 	*val = mgmt_eth_data->data[0];
 	if (len > QCA_HDR_MGMT_DATA1_LEN)
@@ -303,10 +301,8 @@ static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 	qca8k_mdio_header_fill_seq_num(skb, mgmt_eth_data->seq);
 	mgmt_eth_data->ack = false;
 
-	dev_queue_xmit(skb);
-
-	ret = dsa_inband_wait_for_completion(&mgmt_eth_data->inband,
-					     QCA8K_ETHERNET_TIMEOUT);
+	ret = dsa_inband_request(&mgmt_eth_data->inband, skb,
+				 QCA8K_ETHERNET_TIMEOUT);
 
 	ack = mgmt_eth_data->ack;
 
@@ -449,10 +445,8 @@ qca8k_phy_eth_busy_wait(struct qca8k_mgmt_eth_data *mgmt_eth_data,
 	qca8k_mdio_header_fill_seq_num(skb, mgmt_eth_data->seq);
 	mgmt_eth_data->ack = false;
 
-	dev_queue_xmit(skb);
-
-	ret = dsa_inband_wait_for_completion(&mgmt_eth_data->inband,
-					     QCA8K_ETHERNET_TIMEOUT);
+	ret = dsa_inband_request(&mgmt_eth_data->inband, skb,
+				 QCA8K_ETHERNET_TIMEOUT);
 
 	ack = mgmt_eth_data->ack;
 
@@ -539,10 +533,8 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 	qca8k_mdio_header_fill_seq_num(write_skb, mgmt_eth_data->seq);
 	mgmt_eth_data->ack = false;
 
-	dev_queue_xmit(write_skb);
-
-	ret = dsa_inband_wait_for_completion(&mgmt_eth_data->inband,
-					     QCA8K_ETHERNET_TIMEOUT);
+	ret = dsa_inband_request(&mgmt_eth_data->inband, write_skb,
+				 QCA8K_ETHERNET_TIMEOUT);
 
 	ack = mgmt_eth_data->ack;
 
@@ -574,10 +566,8 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 		qca8k_mdio_header_fill_seq_num(read_skb, mgmt_eth_data->seq);
 		mgmt_eth_data->ack = false;
 
-		dev_queue_xmit(read_skb);
-
-		ret = dsa_inband_wait_for_completion(&mgmt_eth_data->inband,
-						     QCA8K_ETHERNET_TIMEOUT);
+		ret = dsa_inband_request(&mgmt_eth_data->inband, read_skb,
+					 QCA8K_ETHERNET_TIMEOUT);
 
 		ack = mgmt_eth_data->ack;
 
@@ -601,8 +591,6 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 	qca8k_mdio_header_fill_seq_num(clear_skb, mgmt_eth_data->seq);
 	mgmt_eth_data->ack = false;
 
-	dev_queue_xmit(clear_skb);
-
 	dsa_inband_wait_for_completion(&mgmt_eth_data->inband,
 				       QCA8K_ETHERNET_TIMEOUT);
 
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 59dd5855dcbd..a5bcd9f021d4 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -1313,6 +1313,8 @@ struct dsa_inband {
 
 void dsa_inband_init(struct dsa_inband *inband);
 void dsa_inband_complete(struct dsa_inband *inband);
+int dsa_inband_request(struct dsa_inband *inband, struct sk_buff *skb,
+		       int timeout_ms);
 int dsa_inband_wait_for_completion(struct dsa_inband *inband, int timeout_ms);
 
 /* Keep inline for faster access in hot path */
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index fc031e9693ee..4e89b483d3e5 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -540,6 +540,22 @@ int dsa_inband_wait_for_completion(struct dsa_inband *inband, int timeout_ms)
 }
 EXPORT_SYMBOL_GPL(dsa_inband_wait_for_completion);
 
+/* Cannot use dsa_inband_wait_completion since the completion needs to be
+ * reinitialized before the skb is queue to avoid races.
+ */
+int dsa_inband_request(struct dsa_inband *inband, struct sk_buff *skb,
+		       int timeout_ms)
+{
+	unsigned long jiffies = msecs_to_jiffies(timeout_ms);
+
+	reinit_completion(&inband->completion);
+
+	dev_queue_xmit(skb);
+
+	return wait_for_completion_timeout(&inband->completion, jiffies);
+}
+EXPORT_SYMBOL_GPL(dsa_inband_request);
+
 static int __init dsa_init_module(void)
 {
 	int rc;
-- 
2.37.2

