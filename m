Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECB746CBAD
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 04:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244079AbhLHDoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 22:44:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243988AbhLHDo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 22:44:27 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 500F1C061746;
        Tue,  7 Dec 2021 19:40:56 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id t18so1602808wrg.11;
        Tue, 07 Dec 2021 19:40:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2CBgZItfHOWD6ekEn1vHZOJMQxa2Ch8UGucuTD9V90o=;
        b=AVEjGSWzLu6jwi9aHN/QrZ3lG7aemHrsIf0mptWTi07FfUWCqgdl1tI/Is4DT7PXiT
         DHHM0UdFeF9uUXD3vVTUV8UGCMj8Zuqv81lemNz2Ta4I3QPik7jGUcBXbOwyFxqTrkUc
         sBDE8T4rHg/STs//bXztan1VSBj54rvlh8XwFxdb1Tqy6nW9PUoZhsfMSkzj6j8IzusD
         hbPFzdbusFreBizRmk1dZK6Y++h4eBUbd+hXSGKVYo6qKooq2pPLlO9NBANblvMsYt8H
         GfD1Z6kppzQ0R4I1nGCAXdfaHwU/myVTK88UsIQy1mqyzSRixwoT/b67pN1q45AAaiaM
         9CRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2CBgZItfHOWD6ekEn1vHZOJMQxa2Ch8UGucuTD9V90o=;
        b=1musNMH3Jaw2X6vihCgbU8lxIcTsCy3S4AWS12yz5Q0jaG7nqoPH9bOd4wOc9b60VL
         yWqKmR6XmYUOJHd6Tf13vS+fIx8/VrV1NDO5H0i9O5Z6d1sqybxMjWwjSxPK6TTFNE/3
         Iow1lx7pQ+Knnx4rl7hawfhe6fi4KZ3FNBYqOXy1GuYc2xyJvFHVtrMSqCV+5TxFtPse
         VYkFtIRQb1B9T9kIFMX9TZ+q1o0+HVKhJ3tLSINfy/oAG1c/3dx1Vv/COeaCOTACc67U
         FmgvcqUEPknasud2DNhTQUq6wZIK5eDitrnI4defxc7ncRrPRswgG0wfx/oHOz7+QXqf
         EVPg==
X-Gm-Message-State: AOAM533dSaQv6PuQqPrXdXtQmcOjS0nf+5DBBcMdNfhARQdek8qXMzCp
        ncMFwKf+sbC1qFQ6gTcX8Zw=
X-Google-Smtp-Source: ABdhPJxtfMgoS9rD2IEORHmpNG/7O0kypgUCvuE8VRXMSMXa8xB6rLdq0ydp15fdKcamAgGQfqiBzQ==
X-Received: by 2002:a5d:4e10:: with SMTP id p16mr54689026wrt.454.1638934854796;
        Tue, 07 Dec 2021 19:40:54 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id v6sm4488944wmh.8.2021.12.07.19.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 19:40:54 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH v2 6/8] net: dsa: tag_qca: Add support for handling Ethernet mdio and MIB packet
Date:   Wed,  8 Dec 2021 04:40:38 +0100
Message-Id: <20211208034040.14457-7-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211208034040.14457-1-ansuelsmth@gmail.com>
References: <20211208034040.14457-1-ansuelsmth@gmail.com>
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
 include/linux/dsa/tag_qca.h |  7 ++++++
 net/dsa/tag_qca.c           | 49 +++++++++++++++++++++++++++++++++++--
 2 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/include/linux/dsa/tag_qca.h b/include/linux/dsa/tag_qca.h
index 578a4aeafd92..f403fdab6f29 100644
--- a/include/linux/dsa/tag_qca.h
+++ b/include/linux/dsa/tag_qca.h
@@ -59,4 +59,11 @@ struct mdio_ethhdr {
 	u16 hdr;		/* qca hdr */
 } __packed;
 
+struct qca8k_port_tag {
+	void (*rw_reg_ack_handler)(struct dsa_port *dp,
+				   struct sk_buff *skb);
+	void (*mib_autocast_handler)(struct dsa_port *dp,
+				     struct sk_buff *skb);
+};
+
 #endif /* __TAG_QCA_H */
diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index b8b05d54a74c..451183f0461a 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -32,6 +32,8 @@ static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
 
 static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 {
+	struct dsa_port *dp = dev->dsa_ptr;
+	struct qca8k_port_tag *header = dp->priv;
 	u16  hdr, pk_type;
 	__be16 *phdr;
 	int port;
@@ -51,9 +53,19 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 	/* Get pk type */
 	pk_type = FIELD_GET(QCA_HDR_RECV_TYPE, hdr);
 
-	/* MDIO read/write packet */
-	if (pk_type == QCA_HDR_RECV_TYPE_RW_REG_ACK)
+	/* Ethernet MDIO read/write packet */
+	if (pk_type == QCA_HDR_RECV_TYPE_RW_REG_ACK) {
+		if (header->rw_reg_ack_handler)
+			header->rw_reg_ack_handler(dp, skb);
 		return NULL;
+	}
+
+	/* Ethernet MIB counter packet */
+	if (pk_type == QCA_HDR_RECV_TYPE_MIB) {
+		if (header->mib_autocast_handler)
+			header->mib_autocast_handler(dp, skb);
+		return NULL;
+	}
 
 	/* Remove QCA tag and recalculate checksum */
 	skb_pull_rcsum(skb, QCA_HDR_LEN);
@@ -69,9 +81,42 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 	return skb;
 }
 
+static int qca_tag_connect(struct dsa_switch_tree *dst)
+{
+	struct qca8k_port_tag *header;
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (!dsa_port_is_cpu(dp))
+			continue;
+
+		header = kzalloc(sizeof(*header), GFP_KERNEL);
+		if (!header)
+			return -ENOMEM;
+
+		dp->priv = header;
+	}
+
+	return 0;
+}
+
+static void qca_tag_disconnect(struct dsa_switch_tree *dst)
+{
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (!dsa_port_is_cpu(dp))
+			continue;
+
+		kfree(dp->priv);
+	}
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
2.32.0

