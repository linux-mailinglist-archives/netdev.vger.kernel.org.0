Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83042474D1B
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 22:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238039AbhLNVLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 16:11:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237820AbhLNVKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 16:10:38 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4A6C061401;
        Tue, 14 Dec 2021 13:10:38 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id z5so68181875edd.3;
        Tue, 14 Dec 2021 13:10:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GwHqgjel+4o9jEPKFMNRrXsb7H4k5y695Z60FXM2aPM=;
        b=Y7NulzX6EeXw9JVWN1sNa1dpCxnl0rHcgtokSeAj6vgW53IwihnuU4hJP63TYebYgG
         cCdiOT2/H/e9pt2VoMf16BD4j6l25eXz8HikYR3QM55mgUgXLzdg8Rn2nGkrfUZtCrsQ
         J4DIu5tG0Wdf8RJhOQZXnZsBngXyvLL6QwIPfMQ1XrLmiFt9nX9KPY4xjgvmxUeb1n77
         U682ahENjA83uShDbIeqteQCePRxMiSo7qywBNIvsyBlX0cx64KnuIvxXwzQpJo2EFZM
         8zTN8giw07/+ecvXwWZ0QxHa3IMHHrhO2xP4k36zluILUjLd5Lu1an0dOQd4Js0z7Ufw
         TCeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GwHqgjel+4o9jEPKFMNRrXsb7H4k5y695Z60FXM2aPM=;
        b=HAOmv4b+Td0fYf+Bv2owPXt8wd5qeFkIfc7rNyQNmJVywG7GrpFHVrD1V08oDIs8T6
         jgmHFDawXz08Jvn3YJUl6O+P+6Jc0Rn7BaQKqeblfT0gxpJpbTer6tS74Kae2YYr6wns
         QmKIOUdCX4fau+mxFz6jRB/Qn0nsR+TNxPE/dDTEQPBC27LOBKnRSal8uwQlWgq3HmgI
         B/4/fwCX/HjidQsB/ls+PhrB1A6yL6Ql6r0AwMBhO+0J4hbrk1h2Has2I6HF1DC7zMtp
         EftBBZsUY4ADG1QEfgREngoKJjKwb6n1621/FjIKxLuaKLfW1ffqOjVwQ94aV3icRONm
         2cGw==
X-Gm-Message-State: AOAM531pPHCgWxN+QbwLfMEZOGR1fWS+8P7staO4Xe0EXcv8HYZvSjaX
        rygFML9mVHEBsnKOeoEzQz5Zamafo2nBzg==
X-Google-Smtp-Source: ABdhPJwkUXZT8HdbLAGt9WUySSsns/GFJR2AFZM6jpvVXH1vxMmqGHizCg4Y5Q2g9XAH0QoWwy3dRw==
X-Received: by 2002:a17:906:4d09:: with SMTP id r9mr1395677eju.447.1639516236566;
        Tue, 14 Dec 2021 13:10:36 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id b4sm261034ejl.206.2021.12.14.13.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 13:10:36 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH RFC v5 10/16] net: dsa: tag_qca: add support for handling mdio Ethernet and MIB packet
Date:   Tue, 14 Dec 2021 22:10:05 +0100
Message-Id: <20211214211011.24850-11-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211214211011.24850-1-ansuelsmth@gmail.com>
References: <20211214211011.24850-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add connect/disconnect helper to assign private struct to the cpu port
dsa priv.
Add support for Ethernet mdio packet and MIB packet if the dsa driver
provide an handler to correctly parse and elaborate the data.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 include/linux/dsa/tag_qca.h |  7 +++++++
 net/dsa/tag_qca.c           | 35 +++++++++++++++++++++++++++++++++--
 2 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/include/linux/dsa/tag_qca.h b/include/linux/dsa/tag_qca.h
index cd6275bac103..203e72dad9bb 100644
--- a/include/linux/dsa/tag_qca.h
+++ b/include/linux/dsa/tag_qca.h
@@ -69,4 +69,11 @@ struct mib_ethhdr {
 	__be16 hdr;		/* qca hdr */
 } __packed;
 
+struct tag_qca_priv {
+	void (*rw_reg_ack_handler)(struct dsa_port *dp,
+				   struct sk_buff *skb);
+	void (*mib_autocast_handler)(struct dsa_port *dp,
+				     struct sk_buff *skb);
+};
+
 #endif /* __TAG_QCA_H */
diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index f5547d357647..59e04157f53b 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -32,11 +32,15 @@ static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
 
 static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 {
+	struct dsa_port *dp = dev->dsa_ptr;
+	struct tag_qca_priv *priv;
 	u16  hdr, pk_type;
 	__be16 *phdr;
 	int port;
 	u8 ver;
 
+	priv = dp->ds->tagger_data;
+
 	if (unlikely(!pskb_may_pull(skb, QCA_HDR_LEN)))
 		return NULL;
 
@@ -52,12 +56,18 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 	pk_type = FIELD_GET(QCA_HDR_RECV_TYPE, hdr);
 
 	/* Ethernet MDIO read/write packet */
-	if (pk_type == QCA_HDR_RECV_TYPE_RW_REG_ACK)
+	if (pk_type == QCA_HDR_RECV_TYPE_RW_REG_ACK) {
+		if (priv->rw_reg_ack_handler)
+			priv->rw_reg_ack_handler(dp, skb);
 		return NULL;
+	}
 
 	/* Ethernet MIB counter packet */
-	if (pk_type == QCA_HDR_RECV_TYPE_MIB)
+	if (pk_type == QCA_HDR_RECV_TYPE_MIB) {
+		if (priv->mib_autocast_handler)
+			priv->mib_autocast_handler(dp, skb);
 		return NULL;
+	}
 
 	/* Remove QCA tag and recalculate checksum */
 	skb_pull_rcsum(skb, QCA_HDR_LEN);
@@ -73,9 +83,30 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 	return skb;
 }
 
+static int qca_tag_connect(struct dsa_switch *ds)
+{
+	struct tag_qca_priv *priv;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	ds->tagger_data = priv;
+
+	return 0;
+}
+
+static void qca_tag_disconnect(struct dsa_switch *ds)
+{
+	kfree(ds->tagger_data);
+	ds->tagger_data = NULL;
+}
+
 static const struct dsa_device_ops qca_netdev_ops = {
 	.name	= "qca",
 	.proto	= DSA_TAG_PROTO_QCA,
+	.connect = qca_tag_connect,
+	.disconnect = qca_tag_disconnect,
 	.xmit	= qca_tag_xmit,
 	.rcv	= qca_tag_rcv,
 	.needed_headroom = QCA_HDR_LEN,
-- 
2.33.1

