Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A926389A6
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 13:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiKYMYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 07:24:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiKYMYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 07:24:12 -0500
Received: from smtp.smtpout.orange.fr (smtp-14.smtpout.orange.fr [80.12.242.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D524A06C
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 04:24:11 -0800 (PST)
Received: from pop-os.home ([86.243.100.34])
        by smtp.orange.fr with ESMTPA
        id yXkRoPBKkY4XVyXkXoE20c; Fri, 25 Nov 2022 13:24:09 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 25 Nov 2022 13:24:09 +0100
X-ME-IP: 86.243.100.34
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH 3/5] octeontx2-af: Use the bitmap API to allocate bitmaps
Date:   Fri, 25 Nov 2022 13:23:59 +0100
Message-Id: <24177a9ee7043259448b735263d9cfd6a70e89a4.1669378798.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1669378798.git.christophe.jaillet@wanadoo.fr>
References: <cover.1669378798.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use devm_bitmap_zalloc() instead of hand-writing it.

This also makes the comment "Allocate bitmap for 32 entry mcam" more
explicit because now 32 is really used in the allocation function, instead
of an obscure 'sizeof(long)'.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
index c584680f2d2b..3f94b620ef5a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
@@ -1898,15 +1898,15 @@ int rvu_npc_exact_init(struct rvu *rvu)
 	table_size = table->mem_table.depth * table->mem_table.ways;
 
 	/* Allocate bitmap for 4way 2K table */
-	table->mem_table.bmap = devm_kcalloc(rvu->dev, BITS_TO_LONGS(table_size),
-					     sizeof(long), GFP_KERNEL);
+	table->mem_table.bmap = devm_bitmap_zalloc(rvu->dev, table_size,
+						   GFP_KERNEL);
 	if (!table->mem_table.bmap)
 		return -ENOMEM;
 
 	dev_dbg(rvu->dev, "%s: Allocated bitmap for 4way 2K entry table\n", __func__);
 
 	/* Allocate bitmap for 32 entry mcam */
-	table->cam_table.bmap = devm_kcalloc(rvu->dev, 1, sizeof(long), GFP_KERNEL);
+	table->cam_table.bmap = devm_bitmap_zalloc(rvu->dev, 32, GFP_KERNEL);
 
 	if (!table->cam_table.bmap)
 		return -ENOMEM;
-- 
2.34.1

