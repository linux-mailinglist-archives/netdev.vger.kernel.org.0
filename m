Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 128D664407B
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235318AbiLFJw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:52:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235344AbiLFJvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:51:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE73D5C;
        Tue,  6 Dec 2022 01:50:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2D83B818E9;
        Tue,  6 Dec 2022 09:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF6DC433D6;
        Tue,  6 Dec 2022 09:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670320217;
        bh=Ks7Pu9BH/4SDd5cXF9QYsdfEFUtiGldA5zs/xJljKN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cnKB8emWP8yOL+OqK8RS7WPchR9nerXjmmS8X9lcKXtVHNV0uGH5KKc4Uz7D4HuRv
         4ckTTCotyrm0PmHGjNxrARvC2jZwMFLb+6qVLTHpO78F0ZIqqYHo7WZds5I6C9aMPG
         D7+77MOnrUgqEuPRyKRCqxwyozfMpsuUIHOUCqv1BdePxS8EUOQglrk5Uyu4LiQtjB
         OQ8k2IWQxFsolYDCW+W30AkgbV9OH0OxBWS4PYBZYcCarxodf4ginTXjVjTi/f+zTo
         bkfyEuzQH0QiEOIksEnq9rX51i6NhcnBJGPSaEozIkKh0z0X9fLfe1XsMvNQsqSZWF
         N8tGrWvw3EMmA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, qiangqing.zhang@nxp.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 08/12] net: fec: don't reset irq coalesce settings to defaults on "ip link up"
Date:   Tue,  6 Dec 2022 04:49:50 -0500
Message-Id: <20221206094955.987437-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221206094955.987437-1-sashal@kernel.org>
References: <20221206094955.987437-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

[ Upstream commit df727d4547de568302b0ed15b0d4e8a469bdb456 ]

Currently, when a FEC device is brought up, the irq coalesce settings
are reset to their default values (1000us, 200 frames). That's
unexpected, and breaks for example use of an appropriate .link file to
make systemd-udev apply the desired
settings (https://www.freedesktop.org/software/systemd/man/systemd.link.html),
or any other method that would do a one-time setup during early boot.

Refactor the code so that fec_restart() instead uses
fec_enet_itr_coal_set(), which simply applies the settings that are
stored in the private data, and initialize that private data with the
default values.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index a829ba128b9d..351f7ef3bc8b 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -72,7 +72,7 @@
 #include "fec.h"
 
 static void set_multicast_list(struct net_device *ndev);
-static void fec_enet_itr_coal_init(struct net_device *ndev);
+static void fec_enet_itr_coal_set(struct net_device *ndev);
 
 #define DRIVER_NAME	"fec"
 
@@ -1163,8 +1163,7 @@ fec_restart(struct net_device *ndev)
 		writel(0, fep->hwp + FEC_IMASK);
 
 	/* Init the interrupt coalescing */
-	fec_enet_itr_coal_init(ndev);
-
+	fec_enet_itr_coal_set(ndev);
 }
 
 static void fec_enet_stop_mode(struct fec_enet_private *fep, bool enabled)
@@ -2760,19 +2759,6 @@ static int fec_enet_set_coalesce(struct net_device *ndev,
 	return 0;
 }
 
-static void fec_enet_itr_coal_init(struct net_device *ndev)
-{
-	struct ethtool_coalesce ec;
-
-	ec.rx_coalesce_usecs = FEC_ITR_ICTT_DEFAULT;
-	ec.rx_max_coalesced_frames = FEC_ITR_ICFT_DEFAULT;
-
-	ec.tx_coalesce_usecs = FEC_ITR_ICTT_DEFAULT;
-	ec.tx_max_coalesced_frames = FEC_ITR_ICFT_DEFAULT;
-
-	fec_enet_set_coalesce(ndev, &ec, NULL, NULL);
-}
-
 static int fec_enet_get_tunable(struct net_device *netdev,
 				const struct ethtool_tunable *tuna,
 				void *data)
@@ -3526,6 +3512,10 @@ static int fec_enet_init(struct net_device *ndev)
 	fep->rx_align = 0x3;
 	fep->tx_align = 0x3;
 #endif
+	fep->rx_pkts_itr = FEC_ITR_ICFT_DEFAULT;
+	fep->tx_pkts_itr = FEC_ITR_ICFT_DEFAULT;
+	fep->rx_time_itr = FEC_ITR_ICTT_DEFAULT;
+	fep->tx_time_itr = FEC_ITR_ICTT_DEFAULT;
 
 	/* Check mask of the streaming and coherent API */
 	ret = dma_set_mask_and_coherent(&fep->pdev->dev, DMA_BIT_MASK(32));
-- 
2.35.1

