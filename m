Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93CA0400A44
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 09:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234128AbhIDHf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Sep 2021 03:35:56 -0400
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:35340 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233528AbhIDHf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Sep 2021 03:35:56 -0400
Received: from pop-os.home ([90.126.253.178])
        by mwinf5d51 with ME
        id pjat2500E3riaq203jat7U; Sat, 04 Sep 2021 09:34:54 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 04 Sep 2021 09:34:54 +0200
X-ME-IP: 90.126.253.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        davem@davemloft.net, kuba@kernel.org, skori@marvell.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 2/2] octeontx2-af: Fix some memory leaks in the error handling path of 'cgx_lmac_init()'
Date:   Sat,  4 Sep 2021 09:34:51 +0200
Message-Id: <2211b712ceaf313e69740ec9374ce6190c4fa00a.1630738450.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <37f3e7e21a1c0f29244b807e5b995b2abeec6c3e.1630738450.git.christophe.jaillet@wanadoo.fr>
References: <37f3e7e21a1c0f29244b807e5b995b2abeec6c3e.1630738450.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Memory allocated before 'lmac' is stored in 'cgx->lmac_idmap[]' must be
freed explicitly. Otherwise, in case of error, it will leak.

Rename the 'err_irq' label to better describe what is done at this place in
the error handling path.

Fixes: 6f14078e3ee5 ("octeontx2-af: DMAC filter support in MAC block")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 7f3d01059e19..34a089b71e55 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -1487,7 +1487,7 @@ static int cgx_lmac_init(struct cgx *cgx)
 				MAX_DMAC_ENTRIES_PER_CGX / cgx->lmac_count;
 		err = rvu_alloc_bitmap(&lmac->mac_to_index_bmap);
 		if (err)
-			return err;
+			goto err_name_free;
 
 		/* Reserve first entry for default MAC address */
 		set_bit(0, lmac->mac_to_index_bmap.bmap);
@@ -1497,7 +1497,7 @@ static int cgx_lmac_init(struct cgx *cgx)
 		spin_lock_init(&lmac->event_cb_lock);
 		err = cgx_configure_interrupt(cgx, lmac, lmac->lmac_id, false);
 		if (err)
-			goto err_irq;
+			goto err_bitmap_free;
 
 		/* Add reference */
 		cgx->lmac_idmap[lmac->lmac_id] = lmac;
@@ -1507,7 +1507,9 @@ static int cgx_lmac_init(struct cgx *cgx)
 
 	return cgx_lmac_verify_fwi_version(cgx);
 
-err_irq:
+err_bitmap_free:
+	rvu_free_bitmap(&lmac->mac_to_index_bmap);
+err_name_free:
 	kfree(lmac->name);
 err_lmac_free:
 	kfree(lmac);
-- 
2.30.2

