Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2596147E338
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 13:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348233AbhLWM2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 07:28:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243438AbhLWM2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 07:28:01 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8015AC061401;
        Thu, 23 Dec 2021 04:28:00 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id o12so12095200lfk.1;
        Thu, 23 Dec 2021 04:28:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tMANTZjGM32zMcdkkj2p89DnLbFvSZJ2+UHontqoues=;
        b=hY6OF5Ps0Z+zomNDbxSEKN7iOI7Zlv5+YrivUSePJfJzOX14NSntueewgw0UuqSVlq
         fF9CydBkkIceW8adueAhFUIy8yZKhwVuvT4RTFpT0drdjWgXI47So+++BQMqe+DYCkoP
         iUCXEqscJfLNrj9BgfDigmZQB13WhDw4GfvW3JkI+uaNuI3G42KNTAkudCkcgI4Dlgv5
         edMpPUrYh1AgO0bL11joUARnqmYVu1tqAnuIrKVXrEdpI35MDdPy+rwevfgxtFgahS4C
         jak4enkryNLAN4m7gI86i9AXxp6jq909Fal0RbRcLGTLSKwffW7E5hVP9czn0mgrQw+p
         UBDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tMANTZjGM32zMcdkkj2p89DnLbFvSZJ2+UHontqoues=;
        b=EvH3TWpnv5tKdVClXWDkKR3l4kw81k5NnrxWxJe47uDsRqhoQIXQsQOU5gi3rUOmIx
         E7KppNrfhNf/7PgTJZum3etUcmEANekmkDq1+vZU2SRpTi5xmoC6ulF8f8snY9Sp9db/
         6QnZYxVhgQjtk+zPMO4ryd+PNCuoVCX11kq+FiBM4ua9ootToum6BYEw2lb3BRkAOBNK
         5mpEMCXpdWfgXME0TiwbMBCSE46CnuzbJO4iSJX+r1YOwRoKC8juV8y6I4oM3JyZgOJ3
         7JCGG/txLqMDznoDxlAkHeE1TW49Ej5terWIAlZwW2NcBIfIH1DTVZBrIlJCKxUx8Vf3
         zFeg==
X-Gm-Message-State: AOAM533db7a2O/SKeVjbMqvtdmJFP4d0LCTHLeg6OpFOspgdjhimFdhD
        z9zvyG1smSBZWFU+1tfIrlu0dK6LKIE=
X-Google-Smtp-Source: ABdhPJzETOF5KZPnRyxldDYRSsCOLI/3AO7w0OWFwazHLU5WbqEiHTj6lOCZ+31uthWAGrnNZyhl8g==
X-Received: by 2002:a19:5e41:: with SMTP id z1mr1634697lfi.657.1640262478798;
        Thu, 23 Dec 2021 04:27:58 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id a17sm495881ljq.72.2021.12.23.04.27.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 04:27:58 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH] of: net: support NVMEM cells with MAC in text format
Date:   Thu, 23 Dec 2021 13:27:47 +0100
Message-Id: <20211223122747.30448-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

Some NVMEM devices have text based cells. In such cases MAC is stored in
a XX:XX:XX:XX:XX:XX format. Use mac_pton() to parse such data and
support those NVMEM cells. This is required to support e.g. a very
popular U-Boot and its environment variables.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
Please let me know if checking NVMEM cell length (6 B vs. 17 B) can be
considered a good enough solution. Alternatively we could use some DT
property to make it explicity, e.g. something like:

ethernet@18024000 {
	compatible = "brcm,amac";
	reg = <0x18024000 0x800>;

	nvmem-cells = <&mac_addr>;
	nvmem-cell-names = "mac-address";
	nvmem-mac-format = "text";
};
---
 net/core/of_net.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/net/core/of_net.c b/net/core/of_net.c
index f1a9bf7578e7..95a64c813ae5 100644
--- a/net/core/of_net.c
+++ b/net/core/of_net.c
@@ -61,7 +61,7 @@ static int of_get_mac_addr_nvmem(struct device_node *np, u8 *addr)
 {
 	struct platform_device *pdev = of_find_device_by_node(np);
 	struct nvmem_cell *cell;
-	const void *mac;
+	const void *buf;
 	size_t len;
 	int ret;
 
@@ -78,21 +78,32 @@ static int of_get_mac_addr_nvmem(struct device_node *np, u8 *addr)
 	if (IS_ERR(cell))
 		return PTR_ERR(cell);
 
-	mac = nvmem_cell_read(cell, &len);
+	buf = nvmem_cell_read(cell, &len);
 	nvmem_cell_put(cell);
 
-	if (IS_ERR(mac))
-		return PTR_ERR(mac);
-
-	if (len != ETH_ALEN || !is_valid_ether_addr(mac)) {
-		kfree(mac);
-		return -EINVAL;
+	if (IS_ERR(buf))
+		return PTR_ERR(buf);
+
+	ret = 0;
+	if (len == ETH_ALEN) {
+		if (is_valid_ether_addr(buf))
+			memcpy(addr, buf, ETH_ALEN);
+		else
+			ret = -EINVAL;
+	} else if (len == 3 * ETH_ALEN - 1) {
+		u8 mac[ETH_ALEN];
+
+		if (mac_pton(buf, mac))
+			memcpy(addr, mac, ETH_ALEN);
+		else
+			ret = -EINVAL;
+	} else {
+		ret = -EINVAL;
 	}
 
-	memcpy(addr, mac, ETH_ALEN);
-	kfree(mac);
+	kfree(buf);
 
-	return 0;
+	return ret;
 }
 
 /**
-- 
2.31.1

