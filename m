Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3573342BA30
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 10:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238592AbhJMI3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 04:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238555AbhJMI2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 04:28:54 -0400
X-Greylist: delayed 76 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 13 Oct 2021 01:26:51 PDT
Received: from out10.migadu.com (out10.migadu.com [IPv6:2001:41d0:2:e8e3::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1670DC061570;
        Wed, 13 Oct 2021 01:26:50 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1634113603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3J/v/zdtjtl+/PpmqBkLrn6nFk7IE1zZUoknWsoDZSE=;
        b=b19WTM3BhWK42yjq7O3eNhI/ZZi+Irf0pejMmnhw/dc6lQq4DnorsyEmXtkco4oRIe4ekU
        s6mbvIzEdVj0xj0Ec4rRooVDbLOg/S9lCzrsH5Zu4N7Zg1NV8JvPu8BoiW3UGhD1tBVElr
        BWSw/Iv2FFLEMZNIVC7kmD2PvtsiGaM=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next 2/2] ethernet: remove nvmem_get_mac_address()
Date:   Wed, 13 Oct 2021 16:26:22 +0800
Message-Id: <20211013082622.707-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nvmem_get_mac_address() is no longer used, remove it.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 include/linux/etherdevice.h |  1 -
 net/ethernet/eth.c          | 36 ------------------------------------
 2 files changed, 37 deletions(-)

diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index 3cf546d2ffd1..9a8f46afe114 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -31,7 +31,6 @@ struct fwnode_handle;
 int eth_platform_get_mac_address(struct device *dev, u8 *mac_addr);
 int platform_get_ethdev_address(struct device *dev, struct net_device *netdev);
 unsigned char *arch_get_platform_mac_address(void);
-int nvmem_get_mac_address(struct device *dev, void *addrbuf);
 int device_get_mac_address(struct device *dev, char *addr);
 int device_get_ethdev_address(struct device *dev, struct net_device *netdev);
 int fwnode_get_mac_address(struct fwnode_handle *fwnode, char *addr);
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index c7d9e08107cb..210ff7235e5f 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -543,42 +543,6 @@ int platform_get_ethdev_address(struct device *dev, struct net_device *netdev)
 }
 EXPORT_SYMBOL(platform_get_ethdev_address);
 
-/**
- * nvmem_get_mac_address - Obtain the MAC address from an nvmem cell named
- * 'mac-address' associated with given device.
- *
- * @dev:	Device with which the mac-address cell is associated.
- * @addrbuf:	Buffer to which the MAC address will be copied on success.
- *
- * Returns 0 on success or a negative error number on failure.
- */
-int nvmem_get_mac_address(struct device *dev, void *addrbuf)
-{
-	struct nvmem_cell *cell;
-	const void *mac;
-	size_t len;
-
-	cell = nvmem_cell_get(dev, "mac-address");
-	if (IS_ERR(cell))
-		return PTR_ERR(cell);
-
-	mac = nvmem_cell_read(cell, &len);
-	nvmem_cell_put(cell);
-
-	if (IS_ERR(mac))
-		return PTR_ERR(mac);
-
-	if (len != ETH_ALEN || !is_valid_ether_addr(mac)) {
-		kfree(mac);
-		return -EINVAL;
-	}
-
-	ether_addr_copy(addrbuf, mac);
-	kfree(mac);
-
-	return 0;
-}
-
 static int fwnode_get_mac_addr(struct fwnode_handle *fwnode,
 			       const char *name, char *addr)
 {
-- 
2.32.0

