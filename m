Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5721142BA2B
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 10:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238507AbhJMI2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 04:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234440AbhJMI2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 04:28:14 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F47C061570;
        Wed, 13 Oct 2021 01:26:11 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next 1/2] of: net: move nvmem_get_mac_address() into of_get_mac_addr_nvmem()
Date:   Wed, 13 Oct 2021 16:25:50 +0800
Message-Id: <20211013082550.624-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nvmem_get_mac_address() is only called by of_get_mac_addr_nvmem(), and
they use almost the same code. so move nvmem_get_mac_address() into
of_get_mac_addr_nvmem().
In addition, prefer ether_addr_copy() over memcpy() if the ethernet
addresses are __aligned(2).

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/core/of_net.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/core/of_net.c b/net/core/of_net.c
index f1a9bf7578e7..cd170ffda5f9 100644
--- a/net/core/of_net.c
+++ b/net/core/of_net.c
@@ -51,7 +51,7 @@ static int of_get_mac_addr(struct device_node *np, const char *name, u8 *addr)
 	struct property *pp = of_find_property(np, name, NULL);
 
 	if (pp && pp->length == ETH_ALEN && is_valid_ether_addr(pp->value)) {
-		memcpy(addr, pp->value, ETH_ALEN);
+		ether_addr_copy(addr, pp->value);
 		return 0;
 	}
 	return -ENODEV;
@@ -68,13 +68,11 @@ static int of_get_mac_addr_nvmem(struct device_node *np, u8 *addr)
 	/* Try lookup by device first, there might be a nvmem_cell_lookup
 	 * associated with a given device.
 	 */
-	if (pdev) {
-		ret = nvmem_get_mac_address(&pdev->dev, addr);
-		put_device(&pdev->dev);
-		return ret;
-	}
+	if (pdev)
+		cell = nvmem_cell_get(&pdev->dev, "mac-address");
+	else
+		cell = of_nvmem_cell_get(np, "mac-address");
 
-	cell = of_nvmem_cell_get(np, "mac-address");
 	if (IS_ERR(cell))
 		return PTR_ERR(cell);
 
@@ -89,9 +87,12 @@ static int of_get_mac_addr_nvmem(struct device_node *np, u8 *addr)
 		return -EINVAL;
 	}
 
-	memcpy(addr, mac, ETH_ALEN);
+	ether_addr_copy(addr, mac);
 	kfree(mac);
 
+	if (pdev)
+		put_device(&pdev->dev);
+
 	return 0;
 }
 
-- 
2.32.0

