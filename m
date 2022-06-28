Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B90655D50D
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242448AbiF1ASA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 20:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbiF1AR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 20:17:59 -0400
Received: from shelob.oktetlabs.ru (shelob.oktetlabs.ru [91.220.146.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA8C636F;
        Mon, 27 Jun 2022 17:17:58 -0700 (PDT)
Received: from bree.oktetlabs.ru (bree.oktetlabs.ru [192.168.34.5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by shelob.oktetlabs.ru (Postfix) with ESMTPS id CE03BAA;
        Tue, 28 Jun 2022 03:17:56 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 shelob.oktetlabs.ru CE03BAA
Authentication-Results: shelob.oktetlabs.ru/CE03BAA; dkim=none;
        dkim-atps=neutral
From:   Ivan Malov <ivan.malov@oktetlabs.ru>
To:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        netdev@vger.kernel.org
Cc:     Andrew Rybchenko <andrew.rybchenko@oktetlabs.ru>,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH v2 1/1] xsk: clear page contiguity bit when unmapping pool
Date:   Tue, 28 Jun 2022 03:17:52 +0300
Message-Id: <20220628001752.17586-1-ivan.malov@oktetlabs.ru>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220627190120.176470-1-ivan.malov@oktetlabs.ru>
References: <20220627190120.176470-1-ivan.malov@oktetlabs.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_ADSP_DISCARD,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a XSK pool gets mapped, xp_check_dma_contiguity() adds bit 0x1
to pages' DMA addresses that go in ascending order and at 4K stride.
The problem is that the bit does not get cleared before doing unmap.
As a result, a lot of warnings from iommu_dma_unmap_page() are seen
suggesting mapping lookup failures at drivers/iommu/dma-iommu.c:848.

Fixes: 2b43470add8c ("xsk: Introduce AF_XDP buffer allocation API")
Signed-off-by: Ivan Malov <ivan.malov@oktetlabs.ru>
---
 v1 -> v2: minor adjustments to dispose of the "Fixes:" tag warning

 net/xdp/xsk_buff_pool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 87bdd71c7bb6..f70112176b7c 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -332,6 +332,7 @@ static void __xp_dma_unmap(struct xsk_dma_map *dma_map, unsigned long attrs)
 	for (i = 0; i < dma_map->dma_pages_cnt; i++) {
 		dma = &dma_map->dma_pages[i];
 		if (*dma) {
+			*dma &= ~XSK_NEXT_PG_CONTIG_MASK;
 			dma_unmap_page_attrs(dma_map->dev, *dma, PAGE_SIZE,
 					     DMA_BIDIRECTIONAL, attrs);
 			*dma = 0;
-- 
2.30.2

