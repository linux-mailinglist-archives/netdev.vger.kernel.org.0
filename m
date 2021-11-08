Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4CA5449E37
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 22:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240306AbhKHVbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 16:31:45 -0500
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:58172 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239399AbhKHVbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 16:31:44 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id kCCGmjvWff6fnkCCGmJNY2; Mon, 08 Nov 2021 22:28:59 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Mon, 08 Nov 2021 22:28:59 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     grygorii.strashko@ti.com, davem@davemloft.net, kuba@kernel.org,
        shenyang39@huawei.com, vigneshr@ti.com
Cc:     linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: ethernet: ti: cpsw_ale: Fix access to un-initialized memory
Date:   Mon,  8 Nov 2021 22:28:55 +0100
Message-Id: <c709f0325a7244ff133e405d017d9efba3b200f6.1636406827.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is spurious to allocate a bitmap without initializing it.
So, better safe than sorry, initialize it to 0 at least to have some known
values.

While at it, switch to the devm_bitmap_ API which is less verbose.

Fixes: 4b41d3436796 ("net: ethernet: ti: cpsw: allow untagged traffic on host port")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Maybe this patch is useless, because of some _add_vlan _del_vlan stuff that
initialize things correctly before they are used, but it really looks
spurious to me.
IIUC, cpsw_rx_vlan_encap() (and the embedded cpsw_ale_get_vlan_p0_untag()
could test any bit in the un-initialized bitmap)

Just a guess, I've not tried to understand all the logic involved.
---
 drivers/net/ethernet/ti/cpsw_ale.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index 0c75e0576ee1..1ef0aaef5c61 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -1299,10 +1299,8 @@ struct cpsw_ale *cpsw_ale_create(struct cpsw_ale_params *params)
 	if (!ale)
 		return ERR_PTR(-ENOMEM);
 
-	ale->p0_untag_vid_mask =
-		devm_kmalloc_array(params->dev, BITS_TO_LONGS(VLAN_N_VID),
-				   sizeof(unsigned long),
-				   GFP_KERNEL);
+	ale->p0_untag_vid_mask = devm_bitmap_zalloc(params->dev, VLAN_N_VID,
+						    GFP_KERNEL);
 	if (!ale->p0_untag_vid_mask)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.30.2

