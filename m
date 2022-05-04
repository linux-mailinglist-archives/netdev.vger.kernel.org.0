Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACEB751A5A9
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 18:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353518AbiEDQl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 12:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbiEDQlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 12:41:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF8DC2DA85
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 09:37:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46A5D61742
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 16:37:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3385CC385AA;
        Wed,  4 May 2022 16:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651682268;
        bh=+ddl/oYCxYiE4FQDAYb6NY3Ux3WG4sSLovf+Jy81Uww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eb1QiYs1DHqsS6/N6pxlpiwGdVyKJeG+2hJIAR6JhMgSt6KKQ5XWw4vD6uPC7RI6O
         uG8/6Z/UAhQKnj0RbgVfVl63tFMvimvp3Kg2nvt5Pp8J4TtaOmcmNSFKZCH/mQol+V
         ZaDzSKZE2nEivjjRRE9ydej+Qt4CpSFRuUKMn2dOqhYm0ajRSP5Kc6XkYkKGVrYacW
         Mq3KoqgX4sKBOLoG8lcre+G8OLdRqbUUai13xKijL5tJSchOdDSwXjbCG9xOmjpxl+
         PSEtU0N68UcK15lBhMtB26LzxzLob+oL4FgybCpwzvRlKgtJex/YVLw+SQH/kbE6To
         E47mXwKSs8/zA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>, claudiu.manoil@nxp.com,
        bryan.whitehead@microchip.com, UNGLinuxDriver@microchip.com,
        mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH net-next 2/2] net: move snowflake callers to netif_napi_add_tx_weight()
Date:   Wed,  4 May 2022 09:37:25 -0700
Message-Id: <20220504163725.550782-2-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220504163725.550782-1-kuba@kernel.org>
References: <20220504163725.550782-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the drivers with custom tx napi weight call netif_napi_add_tx_weight().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: claudiu.manoil@nxp.com
CC: bryan.whitehead@microchip.com
CC: UNGLinuxDriver@microchip.com
CC: mst@redhat.com
CC: jasowang@redhat.com
CC: virtualization@lists.linux-foundation.org
---
 drivers/net/ethernet/freescale/gianfar.c      | 4 ++--
 drivers/net/ethernet/microchip/lan743x_main.c | 6 +++---
 drivers/net/virtio_net.c                      | 5 +++--
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index f0b652a65043..3dc9369a33f7 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -3233,8 +3233,8 @@ static int gfar_probe(struct platform_device *ofdev)
 	for (i = 0; i < priv->num_grps; i++) {
 		netif_napi_add(dev, &priv->gfargrp[i].napi_rx,
 			       gfar_poll_rx_sq, NAPI_POLL_WEIGHT);
-		netif_tx_napi_add(dev, &priv->gfargrp[i].napi_tx,
-				  gfar_poll_tx_sq, 2);
+		netif_napi_add_tx_weight(dev, &priv->gfargrp[i].napi_tx,
+					 gfar_poll_tx_sq, 2);
 	}
 
 	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_CSUM) {
diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 9ac0c2b96a15..efbddf24ba31 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -2044,9 +2044,9 @@ static int lan743x_tx_open(struct lan743x_tx *tx)
 	tx->vector_flags = lan743x_intr_get_vector_flags(adapter,
 							 INT_BIT_DMA_TX_
 							 (tx->channel_number));
-	netif_tx_napi_add(adapter->netdev,
-			  &tx->napi, lan743x_tx_napi_poll,
-			  tx->ring_size - 1);
+	netif_napi_add_tx_weight(adapter->netdev,
+				 &tx->napi, lan743x_tx_napi_poll,
+				 tx->ring_size - 1);
 	napi_enable(&tx->napi);
 
 	data = 0;
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index cbba9d2e8f32..ebb98b796352 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3315,8 +3315,9 @@ static int virtnet_alloc_queues(struct virtnet_info *vi)
 		vi->rq[i].pages = NULL;
 		netif_napi_add(vi->dev, &vi->rq[i].napi, virtnet_poll,
 			       napi_weight);
-		netif_tx_napi_add(vi->dev, &vi->sq[i].napi, virtnet_poll_tx,
-				  napi_tx ? napi_weight : 0);
+		netif_napi_add_tx_weight(vi->dev, &vi->sq[i].napi,
+					 virtnet_poll_tx,
+					 napi_tx ? napi_weight : 0);
 
 		sg_init_table(vi->rq[i].sg, ARRAY_SIZE(vi->rq[i].sg));
 		ewma_pkt_len_init(&vi->rq[i].mrg_avg_pkt_len);
-- 
2.34.1

