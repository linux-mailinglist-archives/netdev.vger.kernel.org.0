Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF754590EC
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238665AbhKVPLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 10:11:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:46628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232194AbhKVPLG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 10:11:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C46C6054E;
        Mon, 22 Nov 2021 15:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637593680;
        bh=7CiwEOoYK4966oM7tixuCMDNr4WY1V73nIRWiKch93g=;
        h=From:To:Cc:Subject:Date:From;
        b=TkBEdpp9Cq8I2qsQsKiQBnA0KeD1hakdMrPPO+CBcFSeuP1abE/qd9Sj/qpoJybIO
         lUBUSg8858my6558b+GndDPASPF7Kmb22Y/HL9NiWx1HcY01M4lCpaMg3xPT/pwwl6
         TI6mYXmvHmRIFkEKxhkcNCJUlJAS8zMl64bV2attF0cIAigL8chP1qoYrh8Qsb9j2T
         i1czliZljSueHcfmdM471FY+Rq7ONEDNNSIvzP7YeymnTL95lQKTKEDppuCk+CX+26
         nqvHhz+NRPnbHcHp8x57nxOXUdMmJjJZoHQ31mpGkm683t2NGEFe6Z1GWdmHEimlKo
         rgrCydzhNKzmg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Moritz Fischer <mdf@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>,
        Cai Huoqing <caihuoqing@baidu.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] nixge: fix mac address error handling again
Date:   Mon, 22 Nov 2021 16:07:44 +0100
Message-Id: <20211122150754.4044081-1-arnd@kernel.org>
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

Make the function always return NULL on error for consistency,
this addresses the bug and the compiler warning.

Fixes: f3956ebb3bf0 ("ethernet: use eth_hw_addr_set() instead of ether_addr_copy()")
Fixes: abcd3d6fc640 ("net: nixge: Fix error path for obtaining mac address")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: return NULL consistently, rather than returning error pointer
---
 drivers/net/ethernet/ni/nixge.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index cfeb7620ae20..9d8826ad84a6 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -1213,6 +1213,8 @@ static void *nixge_get_nvmem_address(struct device *dev)
 
 	mac = nvmem_cell_read(cell, &cell_size);
 	nvmem_cell_put(cell);
+	if (IS_ERR(mac))
+		return NULL;
 
 	return mac;
 }
-- 
2.29.2

