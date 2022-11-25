Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6CC96389A8
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 13:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbiKYMYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 07:24:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbiKYMYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 07:24:18 -0500
Received: from smtp.smtpout.orange.fr (smtp-14.smtpout.orange.fr [80.12.242.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D81AB4A5BC
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 04:24:12 -0800 (PST)
Received: from pop-os.home ([86.243.100.34])
        by smtp.orange.fr with ESMTPA
        id yXkRoPBKkY4XVyXkZoE20z; Fri, 25 Nov 2022 13:24:11 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 25 Nov 2022 13:24:11 +0100
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
Subject: [PATCH 4/5] octeontx2-af: Fix the size of memory allocated for the 'id_bmap' bitmap
Date:   Fri, 25 Nov 2022 13:24:00 +0100
Message-Id: <ce2710771939065d68f95d86a27cf7cea7966365.1669378798.git.christophe.jaillet@wanadoo.fr>
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

This allocation is really spurious.
The size of the bitmap is 'tot_ids' and it is used as such in the driver.

So we could expect something like:
   table->id_bmap = devm_kcalloc(rvu->dev, BITS_TO_LONGS(table->tot_ids),
			         sizeof(long), GFP_KERNEL);

However, when the bitmap is allocated, we allocate:
   BITS_TO_LONGS(table->tot_ids) * table->tot_ids ~=
   table->tot_ids / 32 * table->tot_ids ~=
   table->tot_ids^2 / 32

It is proportional to the square of 'table->tot_ids' which seems to
potentially be big.

Allocate the expected amount of memory, and switch to the bitmap API to
have it more straightforward.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
This patch is speculative.

If I'm right, I'm curious to know if 'able->tot_ids' can really get big
(I'm just guessing) , and if yes, how much.
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
index 3f94b620ef5a..ae34746341c4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
@@ -1914,8 +1914,8 @@ int rvu_npc_exact_init(struct rvu *rvu)
 	dev_dbg(rvu->dev, "%s: Allocated bitmap for 32 entry cam\n", __func__);
 
 	table->tot_ids = (table->mem_table.depth * table->mem_table.ways) + table->cam_table.depth;
-	table->id_bmap = devm_kcalloc(rvu->dev, BITS_TO_LONGS(table->tot_ids),
-				      table->tot_ids, GFP_KERNEL);
+	table->id_bmap = devm_bitmap_zalloc(rvu->dev, table->tot_ids,
+					    GFP_KERNEL);
 
 	if (!table->id_bmap)
 		return -ENOMEM;
-- 
2.34.1

