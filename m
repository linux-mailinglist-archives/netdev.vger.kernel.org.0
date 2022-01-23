Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C96F496F7D
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 02:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235586AbiAWBeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 20:34:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235257AbiAWBdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 20:33:51 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5B2C06173D;
        Sat, 22 Jan 2022 17:33:50 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id n10so34096307edv.2;
        Sat, 22 Jan 2022 17:33:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sUMQ26SOZFXbGQ1PvNTKW9M6A2FFSbKtZQwAN70Zl7c=;
        b=P9flqfS+AdxVPX3/1uoqzd9wrRvXcN+1sUzMlvmfPevTI1rij7eWSUAA2p1CZ6WvFu
         sLjZPly/siGzg5L2+5VsKfpTCUjWSk27WJe3ZRB3YDHe6ZhwbqVuNRmiii0ex5E/yJTb
         45R0t4S/BfaggWaCsJ/HAFFwPTHkdbs7B8+38yPSCgnEfyUQw0gWNQqbGImU2VpDpEg9
         kkLGCxTRyY3GlQbp1V9qxv6c0pd5Hnv6hGC6L7mYdop7PIdojJTTj7OePbg0wZ/RYqrJ
         p/6vg7V+iGtCB1PcCuievJv2EN8iTLwV5xR8NzbY4xphV5KgANnnWfNk3Fi6Sxe3HlVO
         fslw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sUMQ26SOZFXbGQ1PvNTKW9M6A2FFSbKtZQwAN70Zl7c=;
        b=ak5ut71EapSBITrmQuJmKEctxpD58p9VL9A/2FlIAlTv1FRCyUp/bu3vg/GGzDkYUM
         ZdPvWwHT9k+luUSqA1YvAM41h7Id3+gmhtfdNb7wLva4JkeL4GsHltKLWuiO5lEJvDKS
         e/kp7c4YIGaZRxer3lCwHNk991ehbiEwM18THAzDlbkT22Lw9AtBvr6ybURXIaiJqFwy
         0c5zy5NFnIIus3/yDDMWHjDsoUwJX6CZepdkY0G0zTJ2UJCa6t0XxIUSoBMe7tu8AJgM
         ZnCD7iTB50Ur5Y0f4OqQFnryVbPR6t8PXX7/03vC8DNAN3A12akxyeWWYmjCpFF9q2PB
         zknw==
X-Gm-Message-State: AOAM5322Z/BpNuEiKROp/cbaiKty38g1KhFHx4sXn/Ior21owzci/qDe
        mqSEkq+PLyySDjr6wSgKjyk=
X-Google-Smtp-Source: ABdhPJzIBGa6LiYbM2xydu+Ut20hm9LDWeNFguW+bFEgV5wzyHFsNhjlU+N6NecRcfELbLdz3ZDYMw==
X-Received: by 2002:aa7:dc17:: with SMTP id b23mr10275773edu.402.1642901629258;
        Sat, 22 Jan 2022 17:33:49 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id fy40sm3259866ejc.36.2022.01.22.17.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Jan 2022 17:33:48 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH v7 08/16] net: dsa: tag_qca: add support for handling mgmt and MIB Ethernet packet
Date:   Sun, 23 Jan 2022 02:33:29 +0100
Message-Id: <20220123013337.20945-9-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220123013337.20945-1-ansuelsmth@gmail.com>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add connect/disconnect helper to assign private struct to the dsa switch.
Add support for Ethernet mgm and MIB if the dsa driver provide an handler
to correctly parse and elaborate the data.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 include/linux/dsa/tag_qca.h |  7 +++++++
 net/dsa/tag_qca.c           | 39 ++++++++++++++++++++++++++++++++++---
 2 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/include/linux/dsa/tag_qca.h b/include/linux/dsa/tag_qca.h
index 87dd84e31304..de5a45f5b398 100644
--- a/include/linux/dsa/tag_qca.h
+++ b/include/linux/dsa/tag_qca.h
@@ -72,4 +72,11 @@ struct mib_ethhdr {
 	__be16 hdr;		/* qca hdr */
 } __packed;
 
+struct qca_tagger_data {
+	void (*rw_reg_ack_handler)(struct dsa_switch *ds,
+				   struct sk_buff *skb);
+	void (*mib_autocast_handler)(struct dsa_switch *ds,
+				     struct sk_buff *skb);
+};
+
 #endif /* __TAG_QCA_H */
diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index fdaa1b322d25..dc81c72133eb 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -5,6 +5,7 @@
 
 #include <linux/etherdevice.h>
 #include <linux/bitfield.h>
+#include <net/dsa.h>
 #include <linux/dsa/tag_qca.h>
 
 #include "dsa_priv.h"
@@ -32,11 +33,16 @@ static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
 
 static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 {
+	struct qca_tagger_data *tagger_data;
+	struct dsa_port *dp = dev->dsa_ptr;
+	struct dsa_switch *ds = dp->ds;
 	u16 hdr, pk_type;
 	__be16 *phdr;
 	int port;
 	u8 ver;
 
+	tagger_data = ds->tagger_data;
+
 	if (unlikely(!pskb_may_pull(skb, QCA_HDR_LEN)))
 		return NULL;
 
@@ -51,13 +57,19 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 	/* Get pk type */
 	pk_type = FIELD_GET(QCA_HDR_RECV_TYPE, hdr);
 
-	/* Ethernet MDIO read/write packet */
-	if (pk_type == QCA_HDR_RECV_TYPE_RW_REG_ACK)
+	/* Ethernet mgmt read/write packet */
+	if (pk_type == QCA_HDR_RECV_TYPE_RW_REG_ACK) {
+		if (tagger_data->rw_reg_ack_handler)
+			tagger_data->rw_reg_ack_handler(ds, skb);
 		return NULL;
+	}
 
 	/* Ethernet MIB counter packet */
-	if (pk_type == QCA_HDR_RECV_TYPE_MIB)
+	if (pk_type == QCA_HDR_RECV_TYPE_MIB) {
+		if (tagger_data->mib_autocast_handler)
+			tagger_data->mib_autocast_handler(ds, skb);
 		return NULL;
+	}
 
 	/* Remove QCA tag and recalculate checksum */
 	skb_pull_rcsum(skb, QCA_HDR_LEN);
@@ -73,9 +85,30 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 	return skb;
 }
 
+static int qca_tag_connect(struct dsa_switch *ds)
+{
+	struct qca_tagger_data *tagger_data;
+
+	tagger_data = kzalloc(sizeof(*tagger_data), GFP_KERNEL);
+	if (!tagger_data)
+		return -ENOMEM;
+
+	ds->tagger_data = tagger_data;
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

