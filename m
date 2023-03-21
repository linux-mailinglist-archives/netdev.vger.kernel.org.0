Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D534E6C2AEC
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 07:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjCUG6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 02:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjCUG6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 02:58:43 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9DD1A67E
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 23:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=k1; bh=MNl+VG3YYUPhMgZtRA2yLlfxWj/
        Q3UyU6pvAzRvVSwo=; b=yHSBvAJG4V4HpuVki/pUbWwdTbqHZ6Gr5cGLOa+uGP9
        +9CjczFN+tOIocs44qpJZSZ8age4C+eLzB96/l12vExpk36CyYNfHYPwXZ/INKUs
        2KhO8BF8hOgudMhU57Wh/dOKFz/myrOknfVUFaQNXEjevOrp9ynFwrlhtIR+68iw
        =
Received: (qmail 1180438 invoked from network); 21 Mar 2023 07:58:34 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 21 Mar 2023 07:58:34 +0100
X-UD-Smtp-Session: l3s3148p1@I3hrkmP31pUujnv6
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     netdev@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] sh_eth: remove open coded netif_running()
Date:   Tue, 21 Mar 2023 07:58:26 +0100
Message-Id: <20230321065826.2044-1-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It had a purpose back in the days, but today we have a handy helper.

Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---

Based on 6.3-rc3 and tested on a Renesas Lager board (R-Car H2).

 drivers/net/ethernet/renesas/sh_eth.c | 6 +-----
 drivers/net/ethernet/renesas/sh_eth.h | 1 -
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index d8ec729825be..2d9787231099 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2441,8 +2441,6 @@ static int sh_eth_open(struct net_device *ndev)
 
 	netif_start_queue(ndev);
 
-	mdp->is_opened = 1;
-
 	return ret;
 
 out_free_irq:
@@ -2565,7 +2563,7 @@ static struct net_device_stats *sh_eth_get_stats(struct net_device *ndev)
 	if (mdp->cd->no_tx_cntrs)
 		return &ndev->stats;
 
-	if (!mdp->is_opened)
+	if (!netif_running(ndev))
 		return &ndev->stats;
 
 	sh_eth_update_stat(ndev, &ndev->stats.tx_dropped, TROCR);
@@ -2614,8 +2612,6 @@ static int sh_eth_close(struct net_device *ndev)
 	/* Free all the skbuffs in the Rx queue and the DMA buffer. */
 	sh_eth_ring_free(ndev);
 
-	mdp->is_opened = 0;
-
 	pm_runtime_put(&mdp->pdev->dev);
 
 	return 0;
diff --git a/drivers/net/ethernet/renesas/sh_eth.h b/drivers/net/ethernet/renesas/sh_eth.h
index a5c07c6ff44a..f56dbc8a064a 100644
--- a/drivers/net/ethernet/renesas/sh_eth.h
+++ b/drivers/net/ethernet/renesas/sh_eth.h
@@ -560,7 +560,6 @@ struct sh_eth_private {
 
 	unsigned no_ether_link:1;
 	unsigned ether_link_active_low:1;
-	unsigned is_opened:1;
 	unsigned wol_enabled:1;
 };
 
-- 
2.30.2

