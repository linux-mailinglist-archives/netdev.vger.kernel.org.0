Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDB1B6C9D81
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 10:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbjC0IT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 04:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232830AbjC0ITi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 04:19:38 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6EA71FD4
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 01:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=k1; bh=wLuRzzh4tSUyKBDmW5/07cdQNiF
        lz2cl8qUiBA1pOWM=; b=A+EtsIsfRb5BOM6Hs/mknVU6HQ0kuzi5BD6SYcC80JW
        yXMm+EvRzd8n/JCAp+jhVOEoNISxZFkgpu7HYQhKA2gSb7RAokbrMtguU6cZw/+U
        0Lkyjilio94sTQQR2+o1m1x2D8HNGyqUUwfo8mfhAuS5H94dN635wUlJZQNq4fEo
        =
Received: (qmail 3060899 invoked from network); 27 Mar 2023 10:19:35 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 27 Mar 2023 10:19:35 +0200
X-UD-Smtp-Session: l3s3148p1@dWpBZ933JoMujnv6
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     netdev@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] Revert "sh_eth: remove open coded netif_running()"
Date:   Mon, 27 Mar 2023 10:19:33 +0200
Message-Id: <20230327081933.5460-1-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit ce1fdb065695f49ef6f126d35c1abbfe645d62d5. It turned
out this actually introduces a race condition. netif_running() is not a
suitable check for get_stats.

Reported-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
 drivers/net/ethernet/renesas/sh_eth.c | 6 +++++-
 drivers/net/ethernet/renesas/sh_eth.h | 1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 2d9787231099..d8ec729825be 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2441,6 +2441,8 @@ static int sh_eth_open(struct net_device *ndev)
 
 	netif_start_queue(ndev);
 
+	mdp->is_opened = 1;
+
 	return ret;
 
 out_free_irq:
@@ -2563,7 +2565,7 @@ static struct net_device_stats *sh_eth_get_stats(struct net_device *ndev)
 	if (mdp->cd->no_tx_cntrs)
 		return &ndev->stats;
 
-	if (!netif_running(ndev))
+	if (!mdp->is_opened)
 		return &ndev->stats;
 
 	sh_eth_update_stat(ndev, &ndev->stats.tx_dropped, TROCR);
@@ -2612,6 +2614,8 @@ static int sh_eth_close(struct net_device *ndev)
 	/* Free all the skbuffs in the Rx queue and the DMA buffer. */
 	sh_eth_ring_free(ndev);
 
+	mdp->is_opened = 0;
+
 	pm_runtime_put(&mdp->pdev->dev);
 
 	return 0;
diff --git a/drivers/net/ethernet/renesas/sh_eth.h b/drivers/net/ethernet/renesas/sh_eth.h
index f56dbc8a064a..a5c07c6ff44a 100644
--- a/drivers/net/ethernet/renesas/sh_eth.h
+++ b/drivers/net/ethernet/renesas/sh_eth.h
@@ -560,6 +560,7 @@ struct sh_eth_private {
 
 	unsigned no_ether_link:1;
 	unsigned ether_link_active_low:1;
+	unsigned is_opened:1;
 	unsigned wol_enabled:1;
 };
 
-- 
2.30.2

