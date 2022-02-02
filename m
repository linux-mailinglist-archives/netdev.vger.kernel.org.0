Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 682DE4A68FF
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 01:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243302AbiBBAEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 19:04:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243203AbiBBAEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 19:04:37 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C269DC061401;
        Tue,  1 Feb 2022 16:04:36 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id jx6so59820148ejb.0;
        Tue, 01 Feb 2022 16:04:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fCx5KlkpSS2nAjbxyeLU5dvrwqF18spHvQqdDuhuBTU=;
        b=Tf6ClGsAM5d3WuhS+t4apP0wwTZNTw10VUGSxzI7mRJ9VtJ7vXYxaAgE5LnwRfuPIT
         Uf7QoGKIwEf2a/y7ZUr97ET7Ju2Sv/OMKhqZIlvM9iYiTeLeUrQDjvW1J9SKAfIVMdWu
         gqBwTW+U7xOhmkbXq2OON0Cvr2ZZTP91+UI6V4BNiOEEJ69OWhgP9F2OfKG1ZIew6P4N
         5DH95FEhTwoEFGhT0ZxszmjZts8hLwzdnZFSBa5RmF02914yZxC7Eitc18AuAJSwsaMA
         jTOGqjMQ2rB3CtXsGAVXVbrYPAX0tGwqWf2StzFfIpOYIMUfu+WiM+AuqHOwMiWErM+q
         tUqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fCx5KlkpSS2nAjbxyeLU5dvrwqF18spHvQqdDuhuBTU=;
        b=ApD7c36z3AuySVV8TJJBhfqhv1LeN29vLBH1mi6qBfKsrvVliaJAejfiyPqhyvmeFZ
         59RfzfQguhzmKADqZxE76POJ/+tgSBMWVucl1a6UW5lE4+43Ae+3E9tLezpz2IiFA8B9
         VMmeFLXO1RkOev1b6Y652VJpisXzmxrvFnF3Q/xWFRLRahTkOw02pephh17V5NbZu1k4
         RgdrQ+pXDYyR3NLAPgngzCj1jdpQUwkmOq298PsHpUikuznX49kuSCytB8/GXrAz324P
         LmNVt9mw8YIM5Xo/fodphN0k8VeHDZ/jEexJOpqDrEy2iIFjQzCCjtlVjaZ/7PUnytjH
         loXQ==
X-Gm-Message-State: AOAM533aqbPEjI4u+OFLVKt7nMewuc35XddY2Nl4pUfD1WyzbE5R2DbJ
        hJIPBFRlqiv97zgqNAgBz18=
X-Google-Smtp-Source: ABdhPJxlHon7qDIw8ReezeOpjLaPxRmi7vR1Z1W19Nqmw9RhvrHAExAUCuOd/S8jrKd7LcKFGRn+UQ==
X-Received: by 2002:a17:906:7316:: with SMTP id di22mr23544259ejc.505.1643760275072;
        Tue, 01 Feb 2022 16:04:35 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id n3sm3590451ejr.6.2022.02.01.16.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 16:04:34 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v8 15/16] net: dsa: qca8k: add support for larger read/write size with mgmt Ethernet
Date:   Wed,  2 Feb 2022 01:03:34 +0100
Message-Id: <20220202000335.19296-16-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220202000335.19296-1-ansuelsmth@gmail.com>
References: <20220202000335.19296-1-ansuelsmth@gmail.com>
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

In the alloc skb function we check if the len is 16 and we fix it to a
len of 15. It the read/write function interest to extract the real asked
data. The tagger handler will always copy the fully 16byte with a READ
command. This is useful for some big regs like the fdb reg that are
more than 4byte of data. This permits to introduce a bulk function that
will send and request the entire entry in one go.
Write function is changed and it does now require to pass the pointer to
val to also handle array val.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 61 +++++++++++++++++++++++++++--------------
 1 file changed, 41 insertions(+), 20 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 0cce3a6030af..a1b76dcd2eb6 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -222,7 +222,9 @@ static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
 	if (cmd == MDIO_READ) {
 		mgmt_eth_data->data[0] = mgmt_ethhdr->mdio_data;
 
-		/* Get the rest of the 12 byte of data */
+		/* Get the rest of the 12 byte of data.
+		 * The read/write function will extract the requested data.
+		 */
 		if (len > QCA_HDR_MGMT_DATA1_LEN)
 			memcpy(mgmt_eth_data->data + 1, skb->data,
 			       QCA_HDR_MGMT_DATA2_LEN);
@@ -232,16 +234,30 @@ static void qca8k_rw_reg_ack_handler(struct dsa_switch *ds, struct sk_buff *skb)
 }
 
 static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *val,
-					       int priority)
+					       int priority, unsigned int len)
 {
 	struct qca_mgmt_ethhdr *mgmt_ethhdr;
+	unsigned int real_len;
 	struct sk_buff *skb;
+	u32 *data2;
 	u16 hdr;
 
 	skb = dev_alloc_skb(QCA_HDR_MGMT_PKT_LEN);
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
 
@@ -254,7 +270,7 @@ static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *
 	hdr |= FIELD_PREP(QCA_HDR_XMIT_CONTROL, QCA_HDR_XMIT_TYPE_RW_REG);
 
 	mgmt_ethhdr->command = FIELD_PREP(QCA_HDR_MGMT_ADDR, reg);
-	mgmt_ethhdr->command |= FIELD_PREP(QCA_HDR_MGMT_LENGTH, 4);
+	mgmt_ethhdr->command |= FIELD_PREP(QCA_HDR_MGMT_LENGTH, real_len);
 	mgmt_ethhdr->command |= FIELD_PREP(QCA_HDR_MGMT_CMD, cmd);
 	mgmt_ethhdr->command |= FIELD_PREP(QCA_HDR_MGMT_CHECK_CODE,
 					   QCA_HDR_MGMT_CHECK_CODE_VAL);
@@ -264,7 +280,9 @@ static struct sk_buff *qca8k_alloc_mdio_header(enum mdio_cmd cmd, u32 reg, u32 *
 
 	mgmt_ethhdr->hdr = htons(hdr);
 
-	skb_put_zero(skb, QCA_HDR_MGMT_DATA2_LEN + QCA_HDR_MGMT_PADDING_LEN);
+	data2 = skb_put_zero(skb, QCA_HDR_MGMT_DATA2_LEN + QCA_HDR_MGMT_PADDING_LEN);
+	if (cmd == MDIO_WRITE && len > QCA_HDR_MGMT_DATA1_LEN)
+		memcpy(data2, val + 1, len - QCA_HDR_MGMT_DATA1_LEN);
 
 	return skb;
 }
@@ -277,7 +295,7 @@ static void qca8k_mdio_header_fill_seq_num(struct sk_buff *skb, u32 seq_num)
 	mgmt_ethhdr->seq = FIELD_PREP(QCA_HDR_MGMT_SEQ_NUM, seq_num);
 }
 
-static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val)
+static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 {
 	struct qca8k_mgmt_eth_data *mgmt_eth_data = &priv->mgmt_eth_data;
 	struct sk_buff *skb;
@@ -285,7 +303,7 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val)
 	int ret;
 
 	skb = qca8k_alloc_mdio_header(MDIO_READ, reg, NULL,
-				      QCA8K_ETHERNET_MDIO_PRIORITY);
+				      QCA8K_ETHERNET_MDIO_PRIORITY, len);
 	if (!skb)
 		return -ENOMEM;
 
@@ -313,6 +331,9 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val)
 					  msecs_to_jiffies(QCA8K_ETHERNET_TIMEOUT));
 
 	*val = mgmt_eth_data->data[0];
+	if (len > QCA_HDR_MGMT_DATA1_LEN)
+		memcpy(val + 1, mgmt_eth_data->data + 1, len - QCA_HDR_MGMT_DATA1_LEN);
+
 	ack = mgmt_eth_data->ack;
 
 	mutex_unlock(&mgmt_eth_data->mutex);
@@ -326,15 +347,15 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val)
 	return 0;
 }
 
-static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 val)
+static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 {
 	struct qca8k_mgmt_eth_data *mgmt_eth_data = &priv->mgmt_eth_data;
 	struct sk_buff *skb;
 	bool ack;
 	int ret;
 
-	skb = qca8k_alloc_mdio_header(MDIO_WRITE, reg, &val,
-				      QCA8K_ETHERNET_MDIO_PRIORITY);
+	skb = qca8k_alloc_mdio_header(MDIO_WRITE, reg, val,
+				      QCA8K_ETHERNET_MDIO_PRIORITY, len);
 	if (!skb)
 		return -ENOMEM;
 
@@ -380,14 +401,14 @@ qca8k_regmap_update_bits_eth(struct qca8k_priv *priv, u32 reg, u32 mask, u32 wri
 	u32 val = 0;
 	int ret;
 
-	ret = qca8k_read_eth(priv, reg, &val);
+	ret = qca8k_read_eth(priv, reg, &val, sizeof(val));
 	if (ret)
 		return ret;
 
 	val &= ~mask;
 	val |= write_val;
 
-	return qca8k_write_eth(priv, reg, val);
+	return qca8k_write_eth(priv, reg, &val, sizeof(val));
 }
 
 static int
@@ -398,7 +419,7 @@ qca8k_regmap_read(void *ctx, uint32_t reg, uint32_t *val)
 	u16 r1, r2, page;
 	int ret;
 
-	if (!qca8k_read_eth(priv, reg, val))
+	if (!qca8k_read_eth(priv, reg, val, sizeof(val)))
 		return 0;
 
 	qca8k_split_addr(reg, &r1, &r2, &page);
@@ -424,7 +445,7 @@ qca8k_regmap_write(void *ctx, uint32_t reg, uint32_t val)
 	u16 r1, r2, page;
 	int ret;
 
-	if (!qca8k_write_eth(priv, reg, val))
+	if (!qca8k_write_eth(priv, reg, &val, sizeof(val)))
 		return 0;
 
 	qca8k_split_addr(reg, &r1, &r2, &page);
@@ -959,21 +980,21 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 	}
 
 	/* Prealloc all the needed skb before the lock */
-	write_skb = qca8k_alloc_mdio_header(MDIO_WRITE, QCA8K_MDIO_MASTER_CTRL,
-					    &write_val, QCA8K_ETHERNET_PHY_PRIORITY);
+	write_skb = qca8k_alloc_mdio_header(MDIO_WRITE, QCA8K_MDIO_MASTER_CTRL, &write_val,
+					    QCA8K_ETHERNET_PHY_PRIORITY, sizeof(write_val));
 	if (!write_skb)
 		return -ENOMEM;
 
-	clear_skb = qca8k_alloc_mdio_header(MDIO_WRITE, QCA8K_MDIO_MASTER_CTRL,
-					    &clear_val, QCA8K_ETHERNET_PHY_PRIORITY);
+	clear_skb = qca8k_alloc_mdio_header(MDIO_WRITE, QCA8K_MDIO_MASTER_CTRL, &clear_val,
+					    QCA8K_ETHERNET_PHY_PRIORITY, sizeof(clear_val));
 	if (!write_skb) {
 		ret = -ENOMEM;
 		goto err_clear_skb;
 	}
 
-	read_skb = qca8k_alloc_mdio_header(MDIO_READ, QCA8K_MDIO_MASTER_CTRL,
-					   &clear_val, QCA8K_ETHERNET_PHY_PRIORITY);
-	if (!write_skb) {
+	read_skb = qca8k_alloc_mdio_header(MDIO_READ, QCA8K_MDIO_MASTER_CTRL, &clear_val,
+					   QCA8K_ETHERNET_PHY_PRIORITY, sizeof(clear_val));
+	if (!read_skb) {
 		ret = -ENOMEM;
 		goto err_read_skb;
 	}
-- 
2.33.1

