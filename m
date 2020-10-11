Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82CAF28AAD4
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 00:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387605AbgJKWDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 18:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387413AbgJKWDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 18:03:52 -0400
Received: from valentin-vidic.from.hr (valentin-vidic.from.hr [IPv6:2001:470:1f0b:3b7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01DEAC0613CE;
        Sun, 11 Oct 2020 15:03:51 -0700 (PDT)
X-Virus-Scanned: Debian amavisd-new at valentin-vidic.from.hr
Received: by valentin-vidic.from.hr (Postfix, from userid 1000)
        id 8B0BC3FF6; Mon, 12 Oct 2020 00:03:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=valentin-vidic.from.hr; s=2020; t=1602453828;
        bh=hSs9rp0gRrGMiv6Fn2XmzIuoSpKz2lOe6leFqgPnLsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zaqQw42ZM37C7GEj2x9tV6tiF0613gorGmtqzf+/+25aTTS/hOB22r5ixC/eo2rT3
         N7x5BqBZkQOr+jEtVY7FOm3raYr+cWLQcrtIzJy6o7pfqmzAgvl9FonZjaS2MqheDg
         aLpHmZUs9TDHAJrzL5mDtVq9rRuoDqkeovXziGk/fkFMullfuzs0noqnlhEfFgViSY
         9DXTUhT6kWYLM61YB4mWCPiHC9bKqOznDZPjE3NlrYmJLkbmEp2+xUaaehbfPJyDzN
         C0pkkYp7WREkQ5Xsqajbz0jRcgg5VNGYCqsvFGupBDVTEO9T4WmCWPcF5ljpI+fm4H
         fm0QZ5mw3DzPUeyVpgRvBeSh/I+CF1mSKgjwhz7NEp+eR+9vp9GrIH12crL58klK5R
         uZM6LYWJYgsj5v99w7Ne0ak9Uwn840x4unb+SkZIGCxdt34t/nelyCtgumu5NDzqdm
         rf0kku+ucdC+Gz6iTNEeHUcuZmJ4DZ9QJ3SQ444L/bejBkgsCiXoqF1L86n5/43Crz
         5m4Kk3sUjAmPWZHqBHr0aO6tr9RptJF9UnPkHVTRPHvwheeNAGMteppCzBoTRCBRAd
         08nO5KQ0kqGZzuQ6FswP+DQGrQFC5RjIWP0Wy6530Gxt6rhYHT1U6xpmYhjw0vJXw8
         5D6sGiBxphRCr9g/TnqMOY7A=
From:   Valentin Vidic <vvidic@valentin-vidic.from.hr>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Philip Rischel <rischelp@idt.com>,
        Florian Fainelli <florian@openwrt.org>,
        Roman Yeryomin <roman@advem.lv>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Martin Habets <mhabets@solarflare.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Valentin Vidic <vvidic@valentin-vidic.from.hr>
Subject: [PATCH v2] net: korina: fix kfree of rx/tx descriptor array
Date:   Mon, 12 Oct 2020 00:03:29 +0200
Message-Id: <20201011220329.13038-1-vvidic@valentin-vidic.from.hr>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201011212135.GD8773@valentin-vidic.from.hr>
References: <20201011212135.GD8773@valentin-vidic.from.hr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kmalloc returns KSEG0 addresses so convert back from KSEG1
in kfree. Also make sure array is freed when the driver is
unloaded from the kernel.

Fixes: ef11291bcd5f ("Add support the Korina (IDT RC32434) Ethernet MAC")
Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>
---
 v2: convert kfree address back to KSEG0

 drivers/net/ethernet/korina.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index 03e034918d14..af441d699a57 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -1113,7 +1113,7 @@ static int korina_probe(struct platform_device *pdev)
 	return rc;
 
 probe_err_register:
-	kfree(lp->td_ring);
+	kfree(KSEG0ADDR(lp->td_ring));
 probe_err_td_ring:
 	iounmap(lp->tx_dma_regs);
 probe_err_dma_tx:
@@ -1133,6 +1133,7 @@ static int korina_remove(struct platform_device *pdev)
 	iounmap(lp->eth_regs);
 	iounmap(lp->rx_dma_regs);
 	iounmap(lp->tx_dma_regs);
+	kfree(KSEG0ADDR(lp->td_ring));
 
 	unregister_netdev(bif->dev);
 	free_netdev(bif->dev);
-- 
2.20.1

