Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2DB5677EE
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 21:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbiGETi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 15:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbiGETg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 15:36:58 -0400
Received: from smtp.smtpout.orange.fr (smtp02.smtpout.orange.fr [80.12.242.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D798019C0B
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 12:36:56 -0700 (PDT)
Received: from pop-os.home ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id 8oLtojYQmeg3p8oLtoGrDv; Tue, 05 Jul 2022 21:36:55 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Tue, 05 Jul 2022 21:36:55 +0200
X-ME-IP: 90.11.190.129
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH] sfc: falcon: Use the bitmap API to allocate bitmaps
Date:   Tue,  5 Jul 2022 21:36:51 +0200
Message-Id: <c62c1774e6a34bc64323ce526b385aa87c1ca575.1657049799.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use bitmap_zalloc()/bitmap_free() instead of hand-writing them.

It is less verbose and it improves the semantic.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/sfc/falcon/farch.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/falcon/farch.c b/drivers/net/ethernet/sfc/falcon/farch.c
index 2c91792cec01..c64623c2e80c 100644
--- a/drivers/net/ethernet/sfc/falcon/farch.c
+++ b/drivers/net/ethernet/sfc/falcon/farch.c
@@ -2711,7 +2711,7 @@ void ef4_farch_filter_table_remove(struct ef4_nic *efx)
 	enum ef4_farch_filter_table_id table_id;
 
 	for (table_id = 0; table_id < EF4_FARCH_FILTER_TABLE_COUNT; table_id++) {
-		kfree(state->table[table_id].used_bitmap);
+		bitmap_free(state->table[table_id].used_bitmap);
 		vfree(state->table[table_id].spec);
 	}
 	kfree(state);
@@ -2740,9 +2740,7 @@ int ef4_farch_filter_table_probe(struct ef4_nic *efx)
 		table = &state->table[table_id];
 		if (table->size == 0)
 			continue;
-		table->used_bitmap = kcalloc(BITS_TO_LONGS(table->size),
-					     sizeof(unsigned long),
-					     GFP_KERNEL);
+		table->used_bitmap = bitmap_zalloc(table->size, GFP_KERNEL);
 		if (!table->used_bitmap)
 			goto fail;
 		table->spec = vzalloc(array_size(sizeof(*table->spec),
-- 
2.34.1

