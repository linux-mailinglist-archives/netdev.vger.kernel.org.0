Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D96252DDDA
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 21:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244017AbiESTcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 15:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240233AbiESTci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 15:32:38 -0400
X-Greylist: delayed 409 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 19 May 2022 12:32:20 PDT
Received: from unicorn.mansr.com (unicorn.mansr.com [IPv6:2001:8b0:ca0d:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1243D4A1;
        Thu, 19 May 2022 12:32:19 -0700 (PDT)
Received: from raven.mansr.com (raven.mansr.com [IPv6:2001:8b0:ca0d:1::3])
        by unicorn.mansr.com (Postfix) with ESMTPS id F11FF15360;
        Thu, 19 May 2022 20:25:18 +0100 (BST)
Received: by raven.mansr.com (Postfix, from userid 51770)
        id E297C21A3D6; Thu, 19 May 2022 20:25:18 +0100 (BST)
From:   Mans Rullgard <mans@mansr.com>
To:     Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vitaly Bordug <vbordug@ru.mvista.com>,
        Dan Malek <dan@embeddededge.com>,
        Joakim Tjernlund <joakim.tjernlund@lumentis.se>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: fs_enet: sync rx dma buffer before reading
Date:   Thu, 19 May 2022 20:24:43 +0100
Message-Id: <20220519192443.28681-1-mans@mansr.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dma_sync_single_for_cpu() call must precede reading the received
data. Fix this.

Fixes: 070e1f01827c ("net: fs_enet: don't unmap DMA when packet len is below copybreak")
Signed-off-by: Mans Rullgard <mans@mansr.com>
---
 drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
index b3dae17e067e..432ce10cbfd0 100644
--- a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
+++ b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
@@ -240,14 +240,14 @@ static int fs_enet_napi(struct napi_struct *napi, int budget)
 				/* +2 to make IP header L1 cache aligned */
 				skbn = netdev_alloc_skb(dev, pkt_len + 2);
 				if (skbn != NULL) {
+					dma_sync_single_for_cpu(fep->dev,
+						CBDR_BUFADDR(bdp),
+						L1_CACHE_ALIGN(pkt_len),
+						DMA_FROM_DEVICE);
 					skb_reserve(skbn, 2);	/* align IP header */
 					skb_copy_from_linear_data(skb,
 						      skbn->data, pkt_len);
 					swap(skb, skbn);
-					dma_sync_single_for_cpu(fep->dev,
-						CBDR_BUFADDR(bdp),
-						L1_CACHE_ALIGN(pkt_len),
-						DMA_FROM_DEVICE);
 				}
 			} else {
 				skbn = netdev_alloc_skb(dev, ENET_RX_FRSIZE);
-- 
2.35.1

