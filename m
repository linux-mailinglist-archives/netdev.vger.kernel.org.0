Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA13D42CC29
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 22:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbhJMU4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 16:56:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229745AbhJMU4z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 16:56:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99B5061152;
        Wed, 13 Oct 2021 20:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634158491;
        bh=338nyty2VvXqjvUlwxz1KfO1Fz2tO11wrhkpT/gQnzM=;
        h=From:To:Cc:Subject:Date:From;
        b=n2yPCNVATyDpFqWknvkew+irSOFoTzYj0FxJHT5NUMKoz5UPuAxCaDuTp3s5pSLi/
         vOfQsWhLez9oO1dEtZ2ZyxmvRxaadx0SKOmucZvS4oFYkoZAQMlCNWpLKs5rcxNIBo
         B+up7D9DXNzBMGkDA0ijY+tPuRF77OFns3hVmSmrPbkN1Wp6tXFkjkcliw6xQPRir4
         JHUPE5+Sos3wOp/X6GdV0lEt0SMwyzks2tfHDmrIA/OYrPzgAQ9AwCt2wfDCJsBcVe
         +KZkTcMyveGeUw6fZLJznSXjv/ritsFATklfHl6Lli1CBWaQpz+nveNhfV/HML1Eqy
         PbJMr7HbuvuVw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        grygorii.strashko@ti.com, vigneshr@ti.com, joe@perches.com
Subject: [PATCH net-next] ethernet: remove random_ether_addr()
Date:   Wed, 13 Oct 2021 13:54:50 -0700
Message-Id: <20211013205450.328092-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

random_ether_addr() was the original name of the helper which
was kept for backward compatibility (?) after the rename in
commit 0a4dd594982a ("etherdevice: Rename random_ether_addr
to eth_random_addr").

We have a single random_ether_addr() caller left in tree
while there are 70 callers of eth_random_addr().
Time to drop this define.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: grygorii.strashko@ti.com
CC: vigneshr@ti.com
CC: joe@perches.com
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 2 +-
 include/linux/etherdevice.h              | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 6904bfaa5777..c092cb61416a 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1918,7 +1918,7 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 							port->port_id,
 							port->slave.mac_addr);
 			if (!is_valid_ether_addr(port->slave.mac_addr)) {
-				random_ether_addr(port->slave.mac_addr);
+				eth_random_addr(port->slave.mac_addr);
 				dev_err(dev, "Use random MAC address\n");
 			}
 		}
diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index 76f7ff684cbf..23681c3d3b8a 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -234,8 +234,6 @@ static inline void eth_random_addr(u8 *addr)
 	addr[0] |= 0x02;	/* set local assignment bit (IEEE802) */
 }
 
-#define random_ether_addr(addr) eth_random_addr(addr)
-
 /**
  * eth_broadcast_addr - Assign broadcast address
  * @addr: Pointer to a six-byte array containing the Ethernet address
-- 
2.31.1

