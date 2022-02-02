Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33724A68F6
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 01:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243139AbiBBAEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 19:04:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243150AbiBBAEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 19:04:25 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EEA2C061757;
        Tue,  1 Feb 2022 16:04:23 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id s13so59557955ejy.3;
        Tue, 01 Feb 2022 16:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y34PhNDVNLF/FkWy9gLL8vjlqns7WhueetcWJw0qPmk=;
        b=fVXZbpiqImdaRirT99KyibyrE1tur46RvpUZw19yR2XDWsJ5tjrZLwmjSqPiBmejd3
         jWlCNwqaUXI+VhuxYQRYYqah8HBMa1eTej3L1u2jiEfqpzfFcZhqDoRAQDu1fn2xFQ/f
         ssxATPVJgRv3GFwrAVYkb2pzZ0Yu97bwRImpnxqaAn994yV9+/yPPD97TbBcUSZU6wH1
         OVnILivu7ICoiBZyZ2QLjmBbWzqP7gyjoaERF/2w3MRX5Aup9fUPN+jK6IwfjxTEoLyo
         bShK+duqh9/0ygiU2cgJBueeVPghBMRP+rqxHJC77i+kB1DxAAvYElsopaCRQUYEc7CD
         cEoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y34PhNDVNLF/FkWy9gLL8vjlqns7WhueetcWJw0qPmk=;
        b=439OPODXdpjP1ai9YqgnKC7Ur66NlOY+aTzgTW9A1iZB34StXG5NctuaA2TB//ZC9O
         fkj0OWAJNKj4VXTLNO80lKmOJO4zU1uWkrg8xgciLZW+IbjIo2piMhgwpFcEMbEaeVZ8
         Huteh9ADcRCG2tl+xY2xfP7ZgX/sG2wBFW2Lwq8bzVUaEm+R+AxAGT28YRpxWYK+J+et
         WGGfQMtflLJo2anUK4UbCDd5sUEGHrF85h1uha6HO2oIK0j9K0Ho7yN4NeMfluXnfUPA
         k8enFadtrl/jNrWH+CESlFmxra7MjKct4vBu6iq8TPsOMe74+HcUUR52X/h2RAxl+xCl
         mYhQ==
X-Gm-Message-State: AOAM533NX4t6XuQ60pnFS+Q3xeiPLMv8t/mNAn8wWJlewi4BtglF2Jvr
        EJ+NfgjD3V2nofmHWhqbA9hEVSEQQlU=
X-Google-Smtp-Source: ABdhPJwVfed6fk0AW28HEsi2+9jf29iazx7Upxq6MAvhwqyyG0F8D1vOEXNiv1mxbw91a4pXrPaayw==
X-Received: by 2002:a17:907:9491:: with SMTP id dm17mr22547068ejc.47.1643760261805;
        Tue, 01 Feb 2022 16:04:21 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id n3sm3590451ejr.6.2022.02.01.16.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 16:04:21 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v8 08/16] net: dsa: tag_qca: add support for handling mgmt and MIB Ethernet packet
Date:   Wed,  2 Feb 2022 01:03:27 +0100
Message-Id: <20220202000335.19296-9-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220202000335.19296-1-ansuelsmth@gmail.com>
References: <20220202000335.19296-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add connect/disconnect helper to assign private struct to the DSA switch.
Add support for Ethernet mgmt and MIB if the DSA driver provide an handler
to correctly parse and elaborate the data.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/linux/dsa/tag_qca.h |  7 +++++++
 net/dsa/tag_qca.c           | 39 ++++++++++++++++++++++++++++++++++---
 2 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/include/linux/dsa/tag_qca.h b/include/linux/dsa/tag_qca.h
index 1fff57f2937b..4359fb0221cf 100644
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
index be792cf687d9..57d2e00f1e5d 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -5,6 +5,7 @@
 
 #include <linux/etherdevice.h>
 #include <linux/bitfield.h>
+#include <net/dsa.h>
 #include <linux/dsa/tag_qca.h>
 
 #include "dsa_priv.h"
@@ -32,6 +33,9 @@ static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
 
 static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 {
+	struct qca_tagger_data *tagger_data;
+	struct dsa_port *dp = dev->dsa_ptr;
+	struct dsa_switch *ds = dp->ds;
 	u8 ver, pk_type;
 	__be16 *phdr;
 	int port;
@@ -39,6 +43,8 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 
 	BUILD_BUG_ON(sizeof(struct qca_mgmt_ethhdr) != QCA_HDR_MGMT_HEADER_LEN + QCA_HDR_LEN);
 
+	tagger_data = ds->tagger_data;
+
 	if (unlikely(!pskb_may_pull(skb, QCA_HDR_LEN)))
 		return NULL;
 
@@ -53,13 +59,19 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 	/* Get pk type */
 	pk_type = FIELD_GET(QCA_HDR_RECV_TYPE, hdr);
 
-	/* Ethernet MDIO read/write packet */
-	if (pk_type == QCA_HDR_RECV_TYPE_RW_REG_ACK)
+	/* Ethernet mgmt read/write packet */
+	if (pk_type == QCA_HDR_RECV_TYPE_RW_REG_ACK) {
+		if (likely(tagger_data->rw_reg_ack_handler))
+			tagger_data->rw_reg_ack_handler(ds, skb);
 		return NULL;
+	}
 
 	/* Ethernet MIB counter packet */
-	if (pk_type == QCA_HDR_RECV_TYPE_MIB)
+	if (pk_type == QCA_HDR_RECV_TYPE_MIB) {
+		if (likely(tagger_data->mib_autocast_handler))
+			tagger_data->mib_autocast_handler(ds, skb);
 		return NULL;
+	}
 
 	/* Remove QCA tag and recalculate checksum */
 	skb_pull_rcsum(skb, QCA_HDR_LEN);
@@ -75,9 +87,30 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
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

