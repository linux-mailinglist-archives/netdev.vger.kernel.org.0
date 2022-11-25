Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F2A63899F
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 13:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbiKYMYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 07:24:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiKYMYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 07:24:08 -0500
Received: from smtp.smtpout.orange.fr (smtp-13.smtpout.orange.fr [80.12.242.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3245F3AC2D
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 04:24:07 -0800 (PST)
Received: from pop-os.home ([86.243.100.34])
        by smtp.orange.fr with ESMTPA
        id yXkRoPBKkY4XVyXkRoE1zY; Fri, 25 Nov 2022 13:24:05 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 25 Nov 2022 13:24:05 +0100
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
Subject: [PATCH 1/5] octeontx2-af: Fix a potentially spurious error message
Date:   Fri, 25 Nov 2022 13:23:57 +0100
Message-Id: <5ce01c402f86412dc57884ff0994b63f0c5b3871.1669378798.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1669378798.git.christophe.jaillet@wanadoo.fr>
References: <cover.1669378798.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When this error message is displayed, we know that the all the bits in the
bitmap are set.

So, bitmap_weight() will return the number of bits of the bitmap, which is
'table->tot_ids'.

It is unlikely that a bit will be cleared between mutex_unlock() and
dev_err(), but, in order to simplify the code and avoid this possibility,
just take 'table->tot_ids'.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
index 594029007f85..5e6c54577a97 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
@@ -490,7 +490,7 @@ static bool rvu_npc_exact_alloc_id(struct rvu *rvu, u32 *seq_id)
 	if (idx == table->tot_ids) {
 		mutex_unlock(&table->lock);
 		dev_err(rvu->dev, "%s: No space in id bitmap (%d)\n",
-			__func__, bitmap_weight(table->id_bmap, table->tot_ids));
+			__func__, table->tot_ids);
 
 		return false;
 	}
-- 
2.34.1

