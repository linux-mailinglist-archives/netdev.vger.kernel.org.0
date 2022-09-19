Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC3EF5BD721
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 00:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiISWTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 18:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiISWTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 18:19:08 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D8E4E606
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 15:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=iOh2OYhgLa3XzJ+6lwdU/0DYjkO7bQB+/2KA0vvcDuM=; b=wchTP/PYEl6uTpYMegj7MpRyHv
        kDSu5sQRUJNASahgIY5eu/H2rxW/Xw5oQgqSkNoXl0FasagdwY4LFh0biBYSI4XbFcshC2d+FDRdi
        3DLs5RI0sCwCiMVrkGp9XdvBd5zrlOh4RE/zdYgelCb6tykIngrp92JbIPvVdFosZL28=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oaP6R-00HBRF-1e; Tue, 20 Sep 2022 00:18:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     mattias.forsblad@gmail.com
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH rfc v0 4/9] net: dsa: qca8k: dsa_inband_request: More normal return values
Date:   Tue, 20 Sep 2022 00:18:48 +0200
Message-Id: <20220919221853.4095491-5-andrew@lunn.ch>
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

wait_for_completion_timeout() has unusual return values.  It can
return negative error conditions. If it times out, it returns 0, and
on success it returns the number of remaining jiffies for the timeout.

For the use case here, the remaining time is not needed. All that is
really interesting is, it succeeded and returns 0, or there was an
error or a timeout. Massage the return value to fit this, and modify
the callers to the more usual pattern of ret < 0 is an error.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 23 ++++++++++-------------
 net/dsa/dsa.c                    |  8 +++++++-
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 9c44a09590a6..9481a248273a 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -264,8 +264,8 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 
 	mutex_unlock(&mgmt_eth_data->mutex);
 
-	if (ret <= 0)
-		return -ETIMEDOUT;
+	if (ret)
+		return ret;
 
 	if (!ack)
 		return -EINVAL;
@@ -308,8 +308,8 @@ static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 
 	mutex_unlock(&mgmt_eth_data->mutex);
 
-	if (ret <= 0)
-		return -ETIMEDOUT;
+	if (ret)
+		return ret;
 
 	if (!ack)
 		return -EINVAL;
@@ -450,8 +450,8 @@ qca8k_phy_eth_busy_wait(struct qca8k_mgmt_eth_data *mgmt_eth_data,
 
 	ack = mgmt_eth_data->ack;
 
-	if (ret <= 0)
-		return -ETIMEDOUT;
+	if (ret)
+		return ret;
 
 	if (!ack)
 		return -EINVAL;
@@ -538,8 +538,7 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 
 	ack = mgmt_eth_data->ack;
 
-	if (ret <= 0) {
-		ret = -ETIMEDOUT;
+	if (ret) {
 		kfree_skb(read_skb);
 		goto exit;
 	}
@@ -571,10 +570,8 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 
 		ack = mgmt_eth_data->ack;
 
-		if (ret <= 0) {
-			ret = -ETIMEDOUT;
+		if (ret)
 			goto exit;
-		}
 
 		if (!ack) {
 			ret = -EINVAL;
@@ -591,8 +588,8 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 	qca8k_mdio_header_fill_seq_num(clear_skb, mgmt_eth_data->seq);
 	mgmt_eth_data->ack = false;
 
-	dsa_inband_wait_for_completion(&mgmt_eth_data->inband,
-				       QCA8K_ETHERNET_TIMEOUT);
+	ret = dsa_inband_request(&mgmt_eth_data->inband, clear_skb,
+				 QCA8K_ETHERNET_TIMEOUT);
 
 	mutex_unlock(&mgmt_eth_data->mutex);
 
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 8de0c3124abf..68576f1c5b02 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -547,12 +547,18 @@ int dsa_inband_request(struct dsa_inband *inband, struct sk_buff *skb,
 		       int timeout_ms)
 {
 	unsigned long jiffies = msecs_to_jiffies(timeout_ms);
+	int ret;
 
 	reinit_completion(&inband->completion);
 
 	dev_queue_xmit(skb);
 
-	return wait_for_completion_timeout(&inband->completion, jiffies);
+	ret = wait_for_completion_timeout(&inband->completion, jiffies);
+	if (ret < 0)
+		return ret;
+	if (ret == 0)
+		return -ETIMEDOUT;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(dsa_inband_request);
 
-- 
2.37.2

