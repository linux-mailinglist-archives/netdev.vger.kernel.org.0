Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB78E48A91D
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 09:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348811AbiAKIMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 03:12:20 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:40555 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235115AbiAKIMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 03:12:18 -0500
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 7FF712223E;
        Tue, 11 Jan 2022 09:12:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1641888736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=DCRA6S3WathlSGOsTrGujaxqrgIghgKZV9qdJ4CRuY8=;
        b=Dt82kGkf9ZqxSe9AqxhJ/H/HMt8r8a3QkYOE2zaQz7SGxR99ym8XWKLiz+2A8iDfsBzrAM
        k1QejW893jg7RRGwGVdBlTyFAl4lCrb47mKA8ut05Z1jD2M7bOVJEFM6WsjA69CaYMYQNh
        BWi5TGuVqBLRrTGaDo9mICs9PePMEYQ=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next] Revert "of: net: support NVMEM cells with MAC in text format"
Date:   Tue, 11 Jan 2022 09:12:06 +0100
Message-Id: <20220111081206.2393560-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 9ed319e411915e882bb4ed99be3ae78667a70022.

We can already post process a nvmem cell value in a particular driver.
Instead of having yet another place to convert the values, the post
processing hook of the nvmem provider should be used in this case.

Signed-off-by: Michael Walle <michael@walle.cc>
---

As mentioned in [1] I think we should discuss this a bit more and revert
the patch for now before there are any users of it.

[1] https://lore.kernel.org/netdev/20211229124047.1286965-1-michael@walle.cc/

btw, now with net-next closed, should this patch have net-next or net as
the queue in the subject?

 net/core/of_net.c | 33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/net/core/of_net.c b/net/core/of_net.c
index 95a64c813ae5..f1a9bf7578e7 100644
--- a/net/core/of_net.c
+++ b/net/core/of_net.c
@@ -61,7 +61,7 @@ static int of_get_mac_addr_nvmem(struct device_node *np, u8 *addr)
 {
 	struct platform_device *pdev = of_find_device_by_node(np);
 	struct nvmem_cell *cell;
-	const void *buf;
+	const void *mac;
 	size_t len;
 	int ret;
 
@@ -78,32 +78,21 @@ static int of_get_mac_addr_nvmem(struct device_node *np, u8 *addr)
 	if (IS_ERR(cell))
 		return PTR_ERR(cell);
 
-	buf = nvmem_cell_read(cell, &len);
+	mac = nvmem_cell_read(cell, &len);
 	nvmem_cell_put(cell);
 
-	if (IS_ERR(buf))
-		return PTR_ERR(buf);
-
-	ret = 0;
-	if (len == ETH_ALEN) {
-		if (is_valid_ether_addr(buf))
-			memcpy(addr, buf, ETH_ALEN);
-		else
-			ret = -EINVAL;
-	} else if (len == 3 * ETH_ALEN - 1) {
-		u8 mac[ETH_ALEN];
-
-		if (mac_pton(buf, mac))
-			memcpy(addr, mac, ETH_ALEN);
-		else
-			ret = -EINVAL;
-	} else {
-		ret = -EINVAL;
+	if (IS_ERR(mac))
+		return PTR_ERR(mac);
+
+	if (len != ETH_ALEN || !is_valid_ether_addr(mac)) {
+		kfree(mac);
+		return -EINVAL;
 	}
 
-	kfree(buf);
+	memcpy(addr, mac, ETH_ALEN);
+	kfree(mac);
 
-	return ret;
+	return 0;
 }
 
 /**
-- 
2.30.2

