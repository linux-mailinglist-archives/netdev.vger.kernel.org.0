Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9D553C386
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 06:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbiFCEMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 00:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiFCEMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 00:12:15 -0400
Received: from m12-15.163.com (m12-15.163.com [220.181.12.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 09D3B2719;
        Thu,  2 Jun 2022 21:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=ppRjE54dXKAoRtJpzS
        LrcjgNP0rfZu9Scloxgpg5394=; b=KZ+50YqReumkEfGv3P66uLecTSPM3Ycr7E
        U5TZBpFq3nQNfzvf8pGjNqzf9COQI2ZDAPF4m2HrZdzUJaLuu4T7Jy/RO8hFUxpp
        ILORy0a2O2PmIc8uqOzY0C7dvYZxhZOafMS7UXF+6PC6aYSh9hI0TdO1q8SYPfGF
        Y8d51FWcc=
Received: from localhost.localdomain (unknown [218.88.124.148])
        by smtp11 (Coremail) with SMTP id D8CowAAH6O_ZiZliCHYfFw--.40165S2;
        Fri, 03 Jun 2022 12:11:10 +0800 (CST)
From:   Chen Lin <chen45464546@163.com>
To:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        alexander.duyck@gmail.com, Chen Lin <chen45464546@163.com>
Subject: [PATCH] net: ethernet: mtk_eth_soc: fix misuse of mem alloc interface netdev_alloc_frag
Date:   Fri,  3 Jun 2022 12:10:35 +0800
Message-Id: <1654229435-2934-1-git-send-email-chen45464546@163.com>
X-Mailer: git-send-email 1.7.9.5
X-CM-TRANSID: D8CowAAH6O_ZiZliCHYfFw--.40165S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Xry3Wr4kGFy8XrW3Gry3urg_yoWkAFb_Cr
        1vvF43ZrWUGr1rKw42kr1ak342kF4kXwn5AFyaqFWaqw1Uur4kZr4Dur1rXFs7Ww1kAFZr
        Cr9xWa93Za4xKjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRER6zUUUUUU==
X-Originating-IP: [218.88.124.148]
X-CM-SenderInfo: hfkh0kqvuwkkiuw6il2tof0z/xtbCqR4Vnl0DfymTNAAAsT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When rx_flag == MTK_RX_FLAGS_HWLRO, 
rx_data_len = MTK_MAX_LRO_RX_LENGTH(4096 * 3) > PAGE_SIZE.
netdev_alloc_frag is for alloction of page fragment only.
Reference to other drivers and Documentation/vm/page_frags.rst

Branch to use kmalloc when rx_data_len > PAGE_SIZE.

Signed-off-by: Chen Lin <chen45464546@163.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index b3b3c07..d0eebca 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1914,7 +1914,10 @@ static int mtk_rx_alloc(struct mtk_eth *eth, int ring_no, int rx_flag)
 		return -ENOMEM;
 
 	for (i = 0; i < rx_dma_size; i++) {
-		ring->data[i] = netdev_alloc_frag(ring->frag_size);
+		if (ring->frag_size <= PAGE_SIZE)
+			ring->data[i] = netdev_alloc_frag(ring->frag_size);
+		else
+			ring->data[i] = kmalloc(ring->frag_size, GFP_KERNEL);
 		if (!ring->data[i])
 			return -ENOMEM;
 	}
-- 
1.7.9.5

