Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 556C235F79B
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 17:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352213AbhDNP1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 11:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352138AbhDNP1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 11:27:31 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FFC1C061756;
        Wed, 14 Apr 2021 08:27:09 -0700 (PDT)
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id A848322260;
        Wed, 14 Apr 2021 17:27:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1618414027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yzD3ZqdGmr1DdLAfgBlMTWQ/ij/c36NrdB4QWYRCpIY=;
        b=ST5iJYYID4fuxydmgC4pxXXQKAk0J27jbpXkXw7zfCWbuWpeczLoDHs8lODtIP4RfyP4Zr
        bHYMp1Fp6/wrceuHNokQeTahaZJcIIOp0jizWye7QUvSqjwKwHC29jiJsXa0JDhtVTjMUU
        EQwKFBHnyHq36ihoRAqApPDyDPDCMho=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Frank Rowand <frowand.list@gmail.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 3/3] net: implement nvmem-mac-address-offset DT property
Date:   Wed, 14 Apr 2021 17:26:57 +0200
Message-Id: <20210414152657.12097-4-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210414152657.12097-1-michael@walle.cc>
References: <20210414152657.12097-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MAC address fetched by an NVMEM provider might have an offset to it.
Add the support for it in nvmem_get_mac_address().

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/of/of_net.c | 4 ++++
 net/ethernet/eth.c  | 5 +++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/of/of_net.c b/drivers/of/of_net.c
index dbac3a172a11..60c6048a823a 100644
--- a/drivers/of/of_net.c
+++ b/drivers/of/of_net.c
@@ -63,6 +63,7 @@ static int of_get_mac_addr_nvmem(struct device_node *np, u8 *addr)
 	struct nvmem_cell *cell;
 	const void *mac;
 	size_t len;
+	u32 offset;
 	int ret;
 
 	/* Try lookup by device first, there might be a nvmem_cell_lookup
@@ -92,6 +93,9 @@ static int of_get_mac_addr_nvmem(struct device_node *np, u8 *addr)
 	memcpy(addr, mac, ETH_ALEN);
 	kfree(mac);
 
+	if (!of_property_read_u32(np, "nvmem-mac-address-offset", &offset))
+		eth_addr_add(addr, offset);
+
 	return 0;
 }
 
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index 9cce612e8976..fe5311f614fe 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -541,6 +541,7 @@ int nvmem_get_mac_address(struct device *dev, void *addrbuf)
 {
 	struct nvmem_cell *cell;
 	const void *mac;
+	u32 offset;
 	size_t len;
 
 	cell = nvmem_cell_get(dev, "mac-address");
@@ -561,6 +562,10 @@ int nvmem_get_mac_address(struct device *dev, void *addrbuf)
 	ether_addr_copy(addrbuf, mac);
 	kfree(mac);
 
+	if (!device_property_read_u32(dev, "nvmem-mac-address-offset",
+				      &offset))
+		eth_addr_add(addrbuf, offset);
+
 	return 0;
 }
 EXPORT_SYMBOL(nvmem_get_mac_address);
-- 
2.20.1

