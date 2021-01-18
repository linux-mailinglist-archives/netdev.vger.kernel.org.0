Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5841C2FA431
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 16:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405380AbhARPJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 10:09:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405371AbhARPI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 10:08:57 -0500
Received: from michel.telenet-ops.be (michel.telenet-ops.be [IPv6:2a02:1800:110:4::f00:18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44531C0613C1
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 07:08:17 -0800 (PST)
Received: from ramsan.of.borg ([84.195.186.194])
        by michel.telenet-ops.be with bizsmtp
        id JF8E2400b4C55Sk06F8Es0; Mon, 18 Jan 2021 16:08:15 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1l1W8c-004cqS-8S; Mon, 18 Jan 2021 16:08:14 +0100
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1l1W8b-003LIE-FR; Mon, 18 Jan 2021 16:08:13 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Simon Horman <horms+renesas@verge.net.au>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] sh_eth: Fix power down vs. is_opened flag ordering
Date:   Mon, 18 Jan 2021 16:08:12 +0100
Message-Id: <20210118150812.796791-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sh_eth_close() does a synchronous power down of the device before
marking it closed.  Revert the order, to make sure the device is never
marked opened while suspended.

While at it, use pm_runtime_put() instead of pm_runtime_put_sync(), as
there is no reason to do a synchronous power down.

Fixes: 7fa2955ff70ce453 ("sh_eth: Fix sleeping function called from invalid context")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/ethernet/renesas/sh_eth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 9b52d350e21a9f2b..590b088bc4c7f3e2 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2606,10 +2606,10 @@ static int sh_eth_close(struct net_device *ndev)
 	/* Free all the skbuffs in the Rx queue and the DMA buffer. */
 	sh_eth_ring_free(ndev);
 
-	pm_runtime_put_sync(&mdp->pdev->dev);
-
 	mdp->is_opened = 0;
 
+	pm_runtime_put(&mdp->pdev->dev);
+
 	return 0;
 }
 
-- 
2.25.1

