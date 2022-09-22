Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2050C5E6A2C
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 19:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbiIVR64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 13:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232308AbiIVR6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 13:58:44 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660DE10650A
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 10:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=TiNXYxDA5SUKKvnmlQFJqfr4sq76ccdO73FY3dRiLB4=; b=MsrkbMRI6pJGI5/9ClwJS0Kb18
        ggB1VWczC7ZlsCNxX2abwJZ/kFrJj2tcswpbQR6NCjfmmD6au/v4M88//hdoGA52YDjje/rDxU5XH
        4cqhGjUC56JVw+E1BsX+eFEn1hNzqVi5c6NBHpPAqxM5ZS794Dpfo2eKiafL6vTfaMB0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1obQTA-00HYcq-Dl; Thu, 22 Sep 2022 19:58:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     mattias.forsblad@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH rfc v2 04/10] net: dsa: qca8k: dsa_inband_request: More normal return values
Date:   Thu, 22 Sep 2022 19:58:15 +0200
Message-Id: <20220922175821.4184622-5-andrew@lunn.ch>
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

wait_for_completion_timeout() has unusual return values. If it times
out, it returns 0, and on success it returns the number of remaining
jiffies for the timeout.

For the use case here, the remaining time is not needed. All that is
really interesting is, it succeeded and returns 0, or a timeout.
Massage the return value to fit this, and modify the callers to the
more usual pattern of ret < 0 is an error.

Sending the clear message is expected to fail, so don't check the
return value, and add a comment about this.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
v2
Remove check on the clear message.
wait_for_completion_timeout() does not return negative values
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 24 +++++++++++-------------
 net/dsa/dsa.c                    |  6 +++++-
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 9c44a09590a6..2f92cabe21af 100644
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
@@ -591,8 +588,9 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 	qca8k_mdio_header_fill_seq_num(clear_skb, mgmt_eth_data->seq);
 	mgmt_eth_data->ack = false;
 
-	dsa_inband_wait_for_completion(&mgmt_eth_data->inband,
-				       QCA8K_ETHERNET_TIMEOUT);
+	/* This is expected to fail sometimes, so don't check return value. */
+	dsa_inband_request(&mgmt_eth_data->inband, clear_skb,
+			   QCA8K_ETHERNET_TIMEOUT);
 
 	mutex_unlock(&mgmt_eth_data->mutex);
 
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 4e89b483d3e5..8c40bc4c5944 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -547,12 +547,16 @@ int dsa_inband_request(struct dsa_inband *inband, struct sk_buff *skb,
 		       int timeout_ms)
 {
 	unsigned long jiffies = msecs_to_jiffies(timeout_ms);
+	int ret;
 
 	reinit_completion(&inband->completion);
 
 	dev_queue_xmit(skb);
 
-	return wait_for_completion_timeout(&inband->completion, jiffies);
+	ret = wait_for_completion_timeout(&inband->completion, jiffies);
+	if (ret == 0)
+		return -ETIMEDOUT;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(dsa_inband_request);
 
-- 
2.37.2

