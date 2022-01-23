Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27540496F79
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 02:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235510AbiAWBeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 20:34:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235383AbiAWBd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 20:33:58 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 993F5C06173D;
        Sat, 22 Jan 2022 17:33:57 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id s13so11129138ejy.3;
        Sat, 22 Jan 2022 17:33:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tHfjrYf/tnir+i9aE0CsDN6O+ugVsg69qKxNCdw3bGw=;
        b=LhqI54Uar1uqRrfElldHNxddKdAv1V5KLKix9i0GY6LcvfrbnDMP3aqrFdl0Rrem+H
         t56gfAYaiZIFJy+fuIBILKocC1lCxsct0zNNQWIn8KnhBNVBSBfZy4rr1UQJ31prEKoN
         qeeHaiLwPHPzFb/SrJ/3CNs7F06hu3ICgQVp6PtEhlf6yYpVvBI4M9pP0/yk6atLlNhh
         6PS0TQzJLM6oD/AHJVSOALwsMOmK68rXDk8cO/nvs5khbnL5VfLYbQGBdX7520qzLwyJ
         De3kXI3LaTxnLPI02r3Lx0HJslTdZ584w9xnbRGMcEO9uwZZYH6H4KaLpL2GYmM5sjox
         nGkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tHfjrYf/tnir+i9aE0CsDN6O+ugVsg69qKxNCdw3bGw=;
        b=mTn/3qQ7kMhwnPHMQWu5OiPA7Epb8iuckiM3BfpELlgE5S3WnC4g3+2YxuT93Eiq8P
         sGvUTYHwed84XPDi3kN9ajN9cBuT9mc+LwWfEQtmtAzsgtkD7waUS9wKDTRb4ygC4//g
         c85e6Y6Fawpdu4WNaAtjYlvPT3oKnlkFTaPQvFQoFOT+P+tSI36FMGg8e81mNjqznRzQ
         JGGP7SoLbwnWux3SAywXzZJ9Y+f88NYgrTNl4NZ1v5UDA66PU7HWlF3jdAfV1QeFbPE+
         PKNSgys0gCOwcXyrQewLIamHAICCZfESWgl1nDt+N1zp40BEmmTPA0MiPsNFD50Wx2BY
         X/dA==
X-Gm-Message-State: AOAM530CIMuYA3ot3JPTJsQPM1cD0vYOXFMfY7rvNx0G4DMqte87fneK
        /RN10OiKyjnjayfZrFXPxRs=
X-Google-Smtp-Source: ABdhPJwb+qdC7mkXnybdDxHsIODvHf9xc5gofm1PtlDgLVJWe1gEPQv8c4TaaXlY+xagF5QqXGAoqQ==
X-Received: by 2002:a17:906:1c4e:: with SMTP id l14mr8330775ejg.480.1642901636092;
        Sat, 22 Jan 2022 17:33:56 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id fy40sm3259866ejc.36.2022.01.22.17.33.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Jan 2022 17:33:55 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH v7 15/16] net: da: qca8k: add support for larger read/write size with mgmt Ethernet
Date:   Sun, 23 Jan 2022 02:33:36 +0100
Message-Id: <20220123013337.20945-16-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220123013337.20945-1-ansuelsmth@gmail.com>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mgmt Ethernet packet can read/write up to 16byte at times. The len reg
is limited to 15 (0xf). The switch actually sends and accepts data in 4
different steps of len values.
Len steps:
- 0: nothing
- 1-4: first 4 byte
- 5-6: first 12 byte
- 7-15: all 16 byte

In the allock skb function we check if the len is 16 and we fix it to a
len of 15. It the read/write function interest to extract the real asked
data. The tagger handler will always copy the fully 16byte with a READ
command. This is useful for some big regs like the fdb reg that are
more than 4byte of data. This permits to introduce a bulk function that
will send and request the entire entry in one go.
Write function is changed and it does now require to pass the pointer to
val to also handle array val.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 56 ++++++++++++++++++++++++++++++-----------
 1 file changed, 41 insertions(+), 15 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 2a43fb9aeef2..0183ce2d5b74 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -219,7 +219,9 @@ static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
 	if (cmd == MDIO_READ) {
 		mgmt_hdr_data->data[0] = mgmt_ethhdr->mdio_data;
 
-		/* Get the rest of the 12 byte of data */
+		/* Get the rest of the 12 byte of data.
+		 * The read/write function will extract the requested data.
+		 */
 		if (len > QCA_HDR_MGMT_DATA1_LEN)
 			memcpy(mgmt_hdr_data->data + 1, skb->data,
 			       QCA_HDR_MGMT_DATA2_LEN);
@@ -229,16 +231,30 @@ static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
 }
 
 static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *val,
-					       int seq_num, int priority)
+					       int seq_num, int priority, int len)
 {
 	struct mgmt_ethhdr *mgmt_ethhdr;
 	struct sk_buff *skb;
+	int real_len;
+	u32 *data2;
 	u16 hdr;
 
 	skb = dev_alloc_skb(QCA_HDR_MGMT_PKG_LEN);
 	if (!skb)
 		return NULL;
 
+	/* Max value for len reg is 15 (0xf) but the switch actually return 16 byte
+	 * Actually for some reason the steps are:
+	 * 0: nothing
+	 * 1-4: first 4 byte
+	 * 5-6: first 12 byte
+	 * 7-15: all 16 byte
+	 */
+	if (len == 16)
+		real_len = 15;
+	else
+		real_len = len;
+
 	skb_reset_mac_header(skb);
 	skb_set_network_header(skb, skb->len);
 
@@ -253,7 +269,7 @@ static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *
 	mgmt_ethhdr->seq = FIELD_PREP(QCA_HDR_MGMT_SEQ_NUM, seq_num);
 
 	mgmt_ethhdr->command = FIELD_PREP(QCA_HDR_MGMT_ADDR, reg);
-	mgmt_ethhdr->command |= FIELD_PREP(QCA_HDR_MGMT_LENGTH, 4);
+	mgmt_ethhdr->command |= FIELD_PREP(QCA_HDR_MGMT_LENGTH, real_len);
 	mgmt_ethhdr->command |= FIELD_PREP(QCA_HDR_MGMT_CMD, cmd);
 	mgmt_ethhdr->command |= FIELD_PREP(QCA_HDR_MGMT_CHECK_CODE,
 					   QCA_HDR_MGMT_CHECK_CODE_VAL);
@@ -263,19 +279,22 @@ static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *
 
 	mgmt_ethhdr->hdr = htons(hdr);
 
-	skb_put_zero(skb, QCA_HDR_MGMT_DATA2_LEN + QCA_HDR_MGMT_PADDING_LEN);
+	data2 = skb_put_zero(skb, QCA_HDR_MGMT_DATA2_LEN + QCA_HDR_MGMT_PADDING_LEN);
+	if (cmd == MDIO_WRITE && len > QCA_HDR_MGMT_DATA1_LEN)
+		memcpy(data2, val + 1, len - QCA_HDR_MGMT_DATA1_LEN);
 
 	return skb;
 }
 
-static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val)
+static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 {
 	struct qca8k_mgmt_hdr_data *mgmt_hdr_data = &priv->mgmt_hdr_data;
 	struct sk_buff *skb;
 	bool ack;
 	int ret;
 
-	skb = qca8k_alloc_mdio_header(MDIO_READ, reg, NULL, 200, QCA8K_ETHERNET_MDIO_PRIORITY);
+	skb = qca8k_alloc_mdio_header(MDIO_READ, reg, NULL, 200,
+				      QCA8K_ETHERNET_MDIO_PRIORITY, len);
 	if (!skb)
 		return -ENOMEM;
 
@@ -297,6 +316,9 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val)
 					  msecs_to_jiffies(QCA8K_ETHERNET_TIMEOUT));
 
 	*val = mgmt_hdr_data->data[0];
+	if (len > QCA_HDR_MGMT_DATA1_LEN)
+		memcpy(val + 1, mgmt_hdr_data->data + 1, len - QCA_HDR_MGMT_DATA1_LEN);
+
 	ack = mgmt_hdr_data->ack;
 
 	mutex_unlock(&mgmt_hdr_data->mutex);
@@ -310,14 +332,15 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val)
 	return 0;
 }
 
-static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 val)
+static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 {
 	struct qca8k_mgmt_hdr_data *mgmt_hdr_data = &priv->mgmt_hdr_data;
 	struct sk_buff *skb;
 	bool ack;
 	int ret;
 
-	skb = qca8k_alloc_mdio_header(MDIO_WRITE, reg, &val, 200, QCA8K_ETHERNET_MDIO_PRIORITY);
+	skb = qca8k_alloc_mdio_header(MDIO_WRITE, reg, val, 200,
+				      QCA8K_ETHERNET_MDIO_PRIORITY, len);
 	if (!skb)
 		return -ENOMEM;
 
@@ -357,14 +380,14 @@ qca8k_regmap_update_bits_eth(struct qca8k_priv *priv, u32 reg, u32 mask, u32 wri
 	u32 val = 0;
 	int ret;
 
-	ret = qca8k_read_eth(priv, reg, &val);
+	ret = qca8k_read_eth(priv, reg, &val, 4);
 	if (ret)
 		return ret;
 
 	val &= ~mask;
 	val |= write_val;
 
-	return qca8k_write_eth(priv, reg, val);
+	return qca8k_write_eth(priv, reg, &val, 4);
 }
 
 static int
@@ -376,7 +399,7 @@ qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
 	u16 r1, r2, page;
 	int ret;
 
-	if (priv->mgmt_master && !qca8k_read_eth(priv, reg, val))
+	if (priv->mgmt_master && !qca8k_read_eth(priv, reg, val, 4))
 		return 0;
 
 	mdio_cache = &priv->mdio_cache;
@@ -405,7 +428,7 @@ qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
 	u16 r1, r2, page;
 	int ret;
 
-	if (priv->mgmt_master && !qca8k_write_eth(priv, reg, val))
+	if (priv->mgmt_master && !qca8k_write_eth(priv, reg, &val, 4))
 		return 0;
 
 	mdio_cache = &priv->mdio_cache;
@@ -945,17 +968,20 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 
 	/* Prealloc all the needed skb before the lock */
 	write_skb = qca8k_alloc_mdio_header(MDIO_WRITE, QCA8K_MDIO_MASTER_CTRL,
-					    &write_val, seq_num, QCA8K_ETHERNET_PHY_PRIORITY);
+					    &write_val, seq_num,
+					    QCA8K_ETHERNET_PHY_PRIORITY, 4);
 	if (!write_skb)
 		return -ENOMEM;
 
 	clear_skb = qca8k_alloc_mdio_header(MDIO_WRITE, QCA8K_MDIO_MASTER_CTRL,
-					    &clear_val, seq_num, QCA8K_ETHERNET_PHY_PRIORITY);
+					    &clear_val, seq_num,
+					    QCA8K_ETHERNET_PHY_PRIORITY, 4);
 	if (!write_skb)
 		return -ENOMEM;
 
 	read_skb = qca8k_alloc_mdio_header(MDIO_READ, QCA8K_MDIO_MASTER_CTRL,
-					   &clear_val, seq_num, QCA8K_ETHERNET_PHY_PRIORITY);
+					   &clear_val, seq_num,
+					   QCA8K_ETHERNET_PHY_PRIORITY, 4);
 	if (!write_skb)
 		return -ENOMEM;
 
-- 
2.33.1

