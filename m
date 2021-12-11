Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7A04715F9
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 20:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbhLKT66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 14:58:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbhLKT6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 14:58:21 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA9CC061714;
        Sat, 11 Dec 2021 11:58:21 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id g14so39234711edb.8;
        Sat, 11 Dec 2021 11:58:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vnLY6KdcrRoSIU2HsNb3g6e/hZnKqFQfK2cCOCiEGu8=;
        b=Yc3lrOh8wcHd9u+H0jNyaYza7JGqOj9gGBAVT9h40QADSFvACedgf5ZIWU47QgnbpA
         WDgcDW2gtmBXdSsG7JOge2+JpBShXnHtn6zy9rd8MkSphqpJjpNuBwK3SCDuzAOyrOoD
         Tt1VwqqRAszSfEd3yXFkX2pX60sK08LMWSLzrfSkfdC/e2LagROphY8fNxWfbdtj9QuT
         wfeoss9O54TrMHJIzdFAqQq1hFEvN3HgUcaV8uhl8qBVbG9ZodvPOZWpWNBSs5AVMGQi
         dBTfSOWuW8rsvvDcgPCVHE6vsQEuM0JybWg2/aG0sa5XLvtbnL3P4u4od6CGIp8NeqSS
         AA2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vnLY6KdcrRoSIU2HsNb3g6e/hZnKqFQfK2cCOCiEGu8=;
        b=JNfiqBEowd8qNIGBDJH6Z5yMlWtXohjnvrTrZCFgLlTRBKO8cKItso4wUECCD0OVPy
         kaEmZ4pt94dJRcWsiB9ugb8gaCJjDA6+mA+Iieq5lqWMEi57M67QR/u6ueYq502ioXeQ
         +z3qhJQrwCJqn3/Fm5kHQB/FWaciVId7NQU6pRVeTO0NZCakWOH5aGSxkZVszGl1ipxG
         B3xCLiv5sjiTYsJGRCYImsvYWvhn83EUedKvq/qSYvbpvUcEPjGaRgkSMrsCqApFYkKa
         DPgfI3GpAnhQjhNWrDZbTXCY60762iDWbgF66VGL/pR0+F01M86rYayi4pYo3cqxO6LI
         sh5A==
X-Gm-Message-State: AOAM531j95jReqMizoRfm4G8yPspRrwfcDXSXcf95n0/n9Qtvv9y8tvV
        fpsBDTYymX+fw0bFZbgoX2k=
X-Google-Smtp-Source: ABdhPJwvHeTDXowVAb6fxxNlvXE0ZZUvGJdrPWXGSoSk8uOOEZJSSHye8bgYafGDH0BM+xBrPCfiFA==
X-Received: by 2002:a50:d74e:: with SMTP id i14mr48273595edj.243.1639252699839;
        Sat, 11 Dec 2021 11:58:19 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id e15sm3581479edq.46.2021.12.11.11.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 11:58:19 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH v4 05/15] net: dsa: tag_qca: convert to FIELD macro
Date:   Sat, 11 Dec 2021 20:57:48 +0100
Message-Id: <20211211195758.28962-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211211195758.28962-1-ansuelsmth@gmail.com>
References: <20211211195758.28962-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert driver to FIELD macro to drop redundant define.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 net/dsa/tag_qca.c | 34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index 1ea9401b8ace..55fa6b96b4eb 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -4,29 +4,24 @@
  */
 
 #include <linux/etherdevice.h>
+#include <linux/bitfield.h>
 
 #include "dsa_priv.h"
 
 #define QCA_HDR_LEN	2
 #define QCA_HDR_VERSION	0x2
 
-#define QCA_HDR_RECV_VERSION_MASK	GENMASK(15, 14)
-#define QCA_HDR_RECV_VERSION_S		14
-#define QCA_HDR_RECV_PRIORITY_MASK	GENMASK(13, 11)
-#define QCA_HDR_RECV_PRIORITY_S		11
-#define QCA_HDR_RECV_TYPE_MASK		GENMASK(10, 6)
-#define QCA_HDR_RECV_TYPE_S		6
+#define QCA_HDR_RECV_VERSION		GENMASK(15, 14)
+#define QCA_HDR_RECV_PRIORITY		GENMASK(13, 11)
+#define QCA_HDR_RECV_TYPE		GENMASK(10, 6)
 #define QCA_HDR_RECV_FRAME_IS_TAGGED	BIT(3)
-#define QCA_HDR_RECV_SOURCE_PORT_MASK	GENMASK(2, 0)
-
-#define QCA_HDR_XMIT_VERSION_MASK	GENMASK(15, 14)
-#define QCA_HDR_XMIT_VERSION_S		14
-#define QCA_HDR_XMIT_PRIORITY_MASK	GENMASK(13, 11)
-#define QCA_HDR_XMIT_PRIORITY_S		11
-#define QCA_HDR_XMIT_CONTROL_MASK	GENMASK(10, 8)
-#define QCA_HDR_XMIT_CONTROL_S		8
+#define QCA_HDR_RECV_SOURCE_PORT	GENMASK(2, 0)
+
+#define QCA_HDR_XMIT_VERSION		GENMASK(15, 14)
+#define QCA_HDR_XMIT_PRIORITY		GENMASK(13, 11)
+#define QCA_HDR_XMIT_CONTROL		GENMASK(10, 8)
 #define QCA_HDR_XMIT_FROM_CPU		BIT(7)
-#define QCA_HDR_XMIT_DP_BIT_MASK	GENMASK(6, 0)
+#define QCA_HDR_XMIT_DP_BIT		GENMASK(6, 0)
 
 static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
 {
@@ -40,8 +35,9 @@ static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
 	phdr = dsa_etype_header_pos_tx(skb);
 
 	/* Set the version field, and set destination port information */
-	hdr = QCA_HDR_VERSION << QCA_HDR_XMIT_VERSION_S |
-		QCA_HDR_XMIT_FROM_CPU | BIT(dp->index);
+	hdr = FIELD_PREP(QCA_HDR_XMIT_VERSION, QCA_HDR_VERSION);
+	hdr |= QCA_HDR_XMIT_FROM_CPU;
+	hdr |= FIELD_PREP(QCA_HDR_XMIT_DP_BIT, BIT(dp->index));
 
 	*phdr = htons(hdr);
 
@@ -62,7 +58,7 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 	hdr = ntohs(*phdr);
 
 	/* Make sure the version is correct */
-	ver = (hdr & QCA_HDR_RECV_VERSION_MASK) >> QCA_HDR_RECV_VERSION_S;
+	ver = FIELD_GET(QCA_HDR_RECV_VERSION, hdr);
 	if (unlikely(ver != QCA_HDR_VERSION))
 		return NULL;
 
@@ -71,7 +67,7 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 	dsa_strip_etype_header(skb, QCA_HDR_LEN);
 
 	/* Get source port information */
-	port = (hdr & QCA_HDR_RECV_SOURCE_PORT_MASK);
+	port = FIELD_GET(QCA_HDR_RECV_SOURCE_PORT, hdr);
 
 	skb->dev = dsa_master_find_slave(dev, 0, port);
 	if (!skb->dev)
-- 
2.32.0

