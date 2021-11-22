Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B344590D2
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239108AbhKVPGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 10:06:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:44690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238762AbhKVPGd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 10:06:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CACE160E78;
        Mon, 22 Nov 2021 15:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637593406;
        bh=i6Qp2qR/uQyO6caLKgwJaWmOLmpDkZkj/yPileR7hUE=;
        h=From:To:Cc:Subject:Date:From;
        b=GboMgEHx/ttSvRcTngn9oJgSzqGxxAgfIIXtqW03pnxac3Zj+0K3BG8xmZUm0CYfu
         Vaal1EG1uCkXUQGdUZCbneDo5lhzNWa1GlZdd3brrKcMhwQe51Ol1KIKBEQ9a7RT/B
         p1KB1QhgFvCDF8PWlFLuZrLSlVpcmE8+DkobquFEhdtmxtcfPg5mpJfJUIfVIMSs2G
         jtmHVRL2r9z04UBJBqZC5QzevpbAtAfr1wvInxkh9Mg56sUBivKWYmNKYZ/CEn1+kl
         R8iIZrm3I6WHZNC0YUWv4q70km92RyFJAe7QGipBL33rLEHkgJ89clKtDIvNVhlZ02
         2Svr/AgtRn0ig==
From:   Arnd Bergmann <arnd@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Moritz Fischer <mdf@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        Cai Huoqing <caihuoqing@baidu.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] nixge: fix mac address error handling again
Date:   Mon, 22 Nov 2021 16:02:49 +0100
Message-Id: <20211122150322.4043037-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The change to eth_hw_addr_set() caused gcc to correctly spot a
bug that was introduced in an earlier incorrect fix:

In file included from include/linux/etherdevice.h:21,
                 from drivers/net/ethernet/ni/nixge.c:7:
In function '__dev_addr_set',
    inlined from 'eth_hw_addr_set' at include/linux/etherdevice.h:319:2,
    inlined from 'nixge_probe' at drivers/net/ethernet/ni/nixge.c:1286:3:
include/linux/netdevice.h:4648:9: error: 'memcpy' reading 6 bytes from a region of size 0 [-Werror=stringop-overread]
 4648 |         memcpy(dev->dev_addr, addr, len);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

As nixge_get_nvmem_address() can return either NULL or an error
pointer, the NULL check is wrong, and we can end up reading from
ERR_PTR(-EOPNOTSUPP), which gcc knows to contain zero readable
bytes.

Make the function always return an error pointer again but fix
the check to match that.

Fixes: f3956ebb3bf0 ("ethernet: use eth_hw_addr_set() instead of ether_addr_copy()")
Fixes: abcd3d6fc640 ("net: nixge: Fix error path for obtaining mac address")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/ni/nixge.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index cfeb7620ae20..07a00dd9cfe0 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -1209,7 +1209,7 @@ static void *nixge_get_nvmem_address(struct device *dev)
 
 	cell = nvmem_cell_get(dev, "address");
 	if (IS_ERR(cell))
-		return NULL;
+		return cell;
 
 	mac = nvmem_cell_read(cell, &cell_size);
 	nvmem_cell_put(cell);
@@ -1282,7 +1282,7 @@ static int nixge_probe(struct platform_device *pdev)
 	ndev->max_mtu = NIXGE_JUMBO_MTU;
 
 	mac_addr = nixge_get_nvmem_address(&pdev->dev);
-	if (mac_addr && is_valid_ether_addr(mac_addr)) {
+	if (!IS_ERR(mac_addr) && is_valid_ether_addr(mac_addr)) {
 		eth_hw_addr_set(ndev, mac_addr);
 		kfree(mac_addr);
 	} else {
-- 
2.29.2

