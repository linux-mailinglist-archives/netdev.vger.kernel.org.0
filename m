Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1387142FDF9
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 00:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238785AbhJOWTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 18:19:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238763AbhJOWTH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 18:19:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA34B60BD3;
        Fri, 15 Oct 2021 22:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634336220;
        bh=vfz/YNs8y7zYMKx5zvHUpwkzUibBgZroAl9UzzqEXSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BlNxeZwVRFQUhliJrVpcPgx0MAfc9Azq9F3hV/ZDA7msC/Xz3IMeJiwhdEtI/PDab
         KCWIgA2VXnGrRqC3arYNH0EthEVayZui1mR0KwLjOktVg7Px8dq0I7Zm2ZXKqhVBJC
         oDzAkOxxM4RxUHOLut3/C5PyzgmhpslVwpDgNtzIXqTFlcd5XnzV3UPGkMdazqNg+/
         zxJ4t2Ms7YnmmW3c2wOCKLYCASp2QspdSznkKhpGSU7Lsi9mWjDKs3z4F5kB/XvBb5
         iGbZ2rrJpsIhTwSzBkgF1zUDVN52Aaww2kg9GDWPC5aQqx63lLeEngccb8oVgJXqHG
         sGcAnZqmMyZlg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        andreas@gaisler.com
Subject: [PATCH net-next 02/12] ethernet: aeroflex: use eth_hw_addr_set()
Date:   Fri, 15 Oct 2021 15:16:42 -0700
Message-Id: <20211015221652.827253-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211015221652.827253-1-kuba@kernel.org>
References: <20211015221652.827253-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

macaddr[] is a module param, and int, so copy the address into
an array of u8 on the stack, then call eth_hw_addr_set().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: andreas@gaisler.com
---
 drivers/net/ethernet/aeroflex/greth.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/aeroflex/greth.c b/drivers/net/ethernet/aeroflex/greth.c
index cc34eaf0491f..447dc64a17e5 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -1346,6 +1346,7 @@ static int greth_of_probe(struct platform_device *ofdev)
 	int i;
 	int err;
 	int tmp;
+	u8 addr[ETH_ALEN];
 	unsigned long timeout;
 
 	dev = alloc_etherdev(sizeof(struct greth_private));
@@ -1449,8 +1450,6 @@ static int greth_of_probe(struct platform_device *ofdev)
 			break;
 	}
 	if (i == 6) {
-		u8 addr[ETH_ALEN];
-
 		err = of_get_mac_address(ofdev->dev.of_node, addr);
 		if (!err) {
 			for (i = 0; i < 6; i++)
@@ -1464,7 +1463,8 @@ static int greth_of_probe(struct platform_device *ofdev)
 	}
 
 	for (i = 0; i < 6; i++)
-		dev->dev_addr[i] = macaddr[i];
+		addr[i] = macaddr[i];
+	eth_hw_addr_set(dev, addr);
 
 	macaddr[5]++;
 
-- 
2.31.1

