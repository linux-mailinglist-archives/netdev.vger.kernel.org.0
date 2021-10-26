Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62EB543B8AA
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 19:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235511AbhJZR6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 13:58:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232088AbhJZR6N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 13:58:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 205666108D;
        Tue, 26 Oct 2021 17:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635270949;
        bh=9hwzGIKGDGSfs3Rc9fKLtGersM3c9MAot8U+o4lvOnM=;
        h=From:To:Cc:Subject:Date:From;
        b=C5ncQ6kcEoYetz3HCDsjk1V6ZS4HVhamMpvz7s8frlOt2XjFjOcHis1924UCi32A+
         jmf/hFni1MVUJu7mxjVKEK2QJiNEjE2EYpV4cO/hX0woFqVeMz7UbVea9v0cKPPqJ+
         F8JjccPzJqCLizIH4QaQtdlS/7GVT4PZZfigXn11tY72U0SA0v71Cj+wcXlZO5FWLR
         /5uaEPFtk/x8nqpiv1eEJecRgZ/qaxIwZWYs/wvtkQrH0J20+AYpQn4hvkrxoKGwnT
         OVv6F5kMes230pjjZ5v+6jF1xTcQXnBqZaukjUhITpGLb+j6aLWFH9HCN5nXMj0PMR
         ixIXLkFCZgdyQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        michael.jamet@intel.com, mika.westerberg@linux.intel.com,
        YehezkelShB@gmail.com
Subject: [PATCH net-next] net: thunderbolt: use eth_hw_addr_set()
Date:   Tue, 26 Oct 2021 10:55:47 -0700
Message-Id: <20211026175547.3198242-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it go through appropriate helpers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: michael.jamet@intel.com
CC: mika.westerberg@linux.intel.com
CC: YehezkelShB@gmail.com
---
 drivers/net/thunderbolt.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index 9a6a8353e192..ff5d0e98a088 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -1202,17 +1202,19 @@ static void tbnet_generate_mac(struct net_device *dev)
 {
 	const struct tbnet *net = netdev_priv(dev);
 	const struct tb_xdomain *xd = net->xd;
+	u8 addr[ETH_ALEN];
 	u8 phy_port;
 	u32 hash;
 
 	phy_port = tb_phy_port_from_link(TBNET_L0_PORT_NUM(xd->route));
 
 	/* Unicast and locally administered MAC */
-	dev->dev_addr[0] = phy_port << 4 | 0x02;
+	addr[0] = phy_port << 4 | 0x02;
 	hash = jhash2((u32 *)xd->local_uuid, 4, 0);
-	memcpy(dev->dev_addr + 1, &hash, sizeof(hash));
+	memcpy(addr + 1, &hash, sizeof(hash));
 	hash = jhash2((u32 *)xd->local_uuid, 4, hash);
-	dev->dev_addr[5] = hash & 0xff;
+	addr[5] = hash & 0xff;
+	eth_hw_addr_set(dev, addr);
 }
 
 static int tbnet_probe(struct tb_service *svc, const struct tb_service_id *id)
-- 
2.31.1

