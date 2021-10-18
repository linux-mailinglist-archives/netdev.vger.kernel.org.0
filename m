Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83634328CF
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 23:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233375AbhJRVMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 17:12:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232272AbhJRVMb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 17:12:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C7D66115A;
        Mon, 18 Oct 2021 21:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634591419;
        bh=PrOWojfJ3sTxBAayQY616YMotZE//jcS8gsw6wOHcmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MAZUfXc7K3BzUTF4jzoQRj1wXYwa8wtIPuJ9XU5PgNjJlNt3ewzKn1TUjVRY6lUad
         26QOSZs2pKBWeiYftj9ApUK/uog6wb2Q5gJrZ1OTdtX+7Y3/ypbGpfJMWMIQe92pM/
         jfTC6p2p2pbdMFpSZXCmIDKdg1ej+LgKTNzr0FDP317ShWOrhxOIZgIP7tMxEQscKy
         wYT4+E7Dd+MIzohdlp9xCDmGw0L/rFpVNQnYRUmybJbjNdz29LwI24GCRN7lyYsKHF
         m5GYGvYv151G+KcsVGgszb/VKdAhHDBGOA7UnbYw66mbkBCRi3+JTLcQxoJaZ/7i44
         qInUcDzcDHlQw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, andrew@lunn.ch,
        idosch@idosch.org, f.fainelli@gmail.com, snelson@pensando.io,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 4/6] ethernet: fec: use eth_hw_addr_gen()
Date:   Mon, 18 Oct 2021 14:10:05 -0700
Message-Id: <20211018211007.1185777-5-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211018211007.1185777-1-kuba@kernel.org>
References: <20211018211007.1185777-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 47a6fc702ac7..bc418b910999 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1768,11 +1768,8 @@ static int fec_get_mac(struct net_device *ndev)
 		return 0;
 	}
 
-	eth_hw_addr_set(ndev, iap);
-
 	/* Adjust MAC if using macaddr */
-	if (iap == macaddr)
-		 ndev->dev_addr[ETH_ALEN-1] = macaddr[ETH_ALEN-1] + fep->dev_id;
+	eth_hw_addr_gen(ndev, iap, iap == macaddr ? fep->dev_id : 0);
 
 	return 0;
 }
-- 
2.31.1

