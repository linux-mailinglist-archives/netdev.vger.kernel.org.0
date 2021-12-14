Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAB0474E18
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 23:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235139AbhLNWoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 17:44:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234943AbhLNWod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 17:44:33 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E8BC061759;
        Tue, 14 Dec 2021 14:44:32 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id x15so69151386edv.1;
        Tue, 14 Dec 2021 14:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GwHqgjel+4o9jEPKFMNRrXsb7H4k5y695Z60FXM2aPM=;
        b=GkmAiEJMU5gi4MZhyRcBXQUAWr6vTWYOE+rre27Lxj1AfqM4CmqgyCPcRjtItP3w45
         nWaCcSXCAMYBOwowSAa3esyNUZXM3tBpDjtckZaaFDAIxhG9/eI2gNT5BseKSKGbjWLi
         ON51skTyT2XGIdl2YJb+A7wjObPIpZluQnC/qjKtCruMxHHLJXIDkjf1Ge4eWXqoUApQ
         SomPuV2QyqDk04F3LHD7WXcazSmim+NVGDIzt8N+lRjp4IrUGu9UUckJK5G4yoW7zz6O
         fcoPeKpwbYyEmn3W0GR+nVZ7Gxlg90Kj6h6jhezlLtmDJEHPx5PkpFgkpYeBbyg7r6El
         bhZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GwHqgjel+4o9jEPKFMNRrXsb7H4k5y695Z60FXM2aPM=;
        b=Ex0hCByKAxq9FZx+6dAPlsM1JJTDR06alJ5hEp7t6U/3MzThlk/SYzf1MGNsHQQWei
         rISmtofzrSC+GMQ6N87yoHnzOukQehdOe0qtdshPqbZnVEwW70sU+u1AzGU0ACVXZXgg
         heEUnSgQ4YfnL6MTemAoegxYsTq5U9jX7BhGwGXKK7JqgO1dxUcwwrK9Mk1WEEXvZmiJ
         o6mkrV2xrSaF9NZWvcbiVHhkBsfOkF7LzKPJyeTNvHGzHKHvc0hWIMJAglzQMBzPExF9
         kFEojblCQfdbryam5iPf+DR0e2GCln4Tz17PFD8cgm/uA/gfLQRswS8tbBvryxq+8014
         XdJw==
X-Gm-Message-State: AOAM531plg9cwCZAZCfW1NJ0LQkDu5u7iZt8uNcyv4aM4sTDgdbI/FCd
        k77HKUHkHkzrNs51AaZEcoM=
X-Google-Smtp-Source: ABdhPJyIi0T9g4+/VIf1+N+wpV1vAZ46m7sf44D1bF8SdGVt5RYdpufCKkSmkPVI9JFIksgP75E+Iw==
X-Received: by 2002:aa7:c915:: with SMTP id b21mr11341245edt.195.1639521871028;
        Tue, 14 Dec 2021 14:44:31 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id b19sm39008ejl.152.2021.12.14.14.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 14:44:30 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH RFC v6 10/16] net: dsa: tag_qca: add support for handling mdio Ethernet and MIB packet
Date:   Tue, 14 Dec 2021 23:44:03 +0100
Message-Id: <20211214224409.5770-11-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211214224409.5770-1-ansuelsmth@gmail.com>
References: <20211214224409.5770-1-ansuelsmth@gmail.com>
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

