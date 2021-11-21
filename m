Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2513A45861B
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 20:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238812AbhKUTQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 14:16:08 -0500
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:61782 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238807AbhKUTQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 14:16:04 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id osGlmoFqxPnAJosGlmBzhH; Sun, 21 Nov 2021 20:12:56 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 21 Nov 2021 20:12:56 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, kuba@kernel.org, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] qed: Use the bitmap API to simplify some functions
Date:   Sun, 21 Nov 2021 20:12:54 +0100
Message-Id: <5f585ae692e1045b9f12c483cdaf87ee5db9a716.1637521924.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'cid_map' is a bitmap. So use 'bitmap_zalloc()' to simplify code,
improve the semantic and avoid some open-coded arithmetic in allocator
arguments.

Also change the corresponding 'kfree()' into 'bitmap_free()' to keep
consistency.

Also change some 'memset()' into 'bitmap_zero()' to keep consistency. This
is also much less verbose.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/qlogic/qed/qed_cxt.c | 24 +++++------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_cxt.c b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
index 452494f8c298..65e20693c549 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_cxt.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_cxt.c
@@ -1036,12 +1036,12 @@ static void qed_cid_map_free(struct qed_hwfn *p_hwfn)
 	u32 type, vf;
 
 	for (type = 0; type < MAX_CONN_TYPES; type++) {
-		kfree(p_mngr->acquired[type].cid_map);
+		bitmap_free(p_mngr->acquired[type].cid_map);
 		p_mngr->acquired[type].max_count = 0;
 		p_mngr->acquired[type].start_cid = 0;
 
 		for (vf = 0; vf < MAX_NUM_VFS; vf++) {
-			kfree(p_mngr->acquired_vf[type][vf].cid_map);
+			bitmap_free(p_mngr->acquired_vf[type][vf].cid_map);
 			p_mngr->acquired_vf[type][vf].max_count = 0;
 			p_mngr->acquired_vf[type][vf].start_cid = 0;
 		}
@@ -1054,15 +1054,10 @@ qed_cid_map_alloc_single(struct qed_hwfn *p_hwfn,
 			 u32 cid_start,
 			 u32 cid_count, struct qed_cid_acquired_map *p_map)
 {
-	u32 size;
-
 	if (!cid_count)
 		return 0;
 
-	size = DIV_ROUND_UP(cid_count,
-			    sizeof(unsigned long) * BITS_PER_BYTE) *
-	       sizeof(unsigned long);
-	p_map->cid_map = kzalloc(size, GFP_KERNEL);
+	p_map->cid_map = bitmap_zalloc(cid_count, GFP_KERNEL);
 	if (!p_map->cid_map)
 		return -ENOMEM;
 
@@ -1216,7 +1211,6 @@ void qed_cxt_mngr_setup(struct qed_hwfn *p_hwfn)
 	struct qed_cid_acquired_map *p_map;
 	struct qed_conn_type_cfg *p_cfg;
 	int type;
-	u32 len;
 
 	/* Reset acquired cids */
 	for (type = 0; type < MAX_CONN_TYPES; type++) {
@@ -1225,11 +1219,7 @@ void qed_cxt_mngr_setup(struct qed_hwfn *p_hwfn)
 		p_cfg = &p_mngr->conn_cfg[type];
 		if (p_cfg->cid_count) {
 			p_map = &p_mngr->acquired[type];
-			len = DIV_ROUND_UP(p_map->max_count,
-					   sizeof(unsigned long) *
-					   BITS_PER_BYTE) *
-			      sizeof(unsigned long);
-			memset(p_map->cid_map, 0, len);
+			bitmap_zero(p_map->cid_map, p_map->max_count);
 		}
 
 		if (!p_cfg->cids_per_vf)
@@ -1237,11 +1227,7 @@ void qed_cxt_mngr_setup(struct qed_hwfn *p_hwfn)
 
 		for (vf = 0; vf < MAX_NUM_VFS; vf++) {
 			p_map = &p_mngr->acquired_vf[type][vf];
-			len = DIV_ROUND_UP(p_map->max_count,
-					   sizeof(unsigned long) *
-					   BITS_PER_BYTE) *
-			      sizeof(unsigned long);
-			memset(p_map->cid_map, 0, len);
+			bitmap_zero(p_map->cid_map, p_map->max_count);
 		}
 	}
 }
-- 
2.30.2

