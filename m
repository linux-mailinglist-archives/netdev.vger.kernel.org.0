Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0298E4658DC
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 23:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343702AbhLAWJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 17:09:16 -0500
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:49822 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353550AbhLAWIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 17:08:41 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id sXj2ml4As65jHsXj3mTVw0; Wed, 01 Dec 2021 23:05:17 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Wed, 01 Dec 2021 23:05:17 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     chunkeey@googlemail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] carl9170: Use the bitmap API when applicable
Date:   Wed,  1 Dec 2021 23:05:15 +0100
Message-Id: <1fe18fb73f71d855043c40c83865ad539f326478.1638396221.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use 'bitmap_zalloc()' to simplify code, improve the semantic and avoid some
open-coded arithmetic in allocator arguments.

Note, that this 'bitmap_zalloc()' divides by BITS_PER_LONG the amount of
memory allocated.
The 'roundup()' used to computed the number of needed long should have
been a DIV_ROUND_UP.


Also change the corresponding 'kfree()' into 'bitmap_free()' to keep
consistency.

Use 'bitmap_zero()' to avoid hand writing it.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
All uses of 'mem_bitmap' in 'carl9170/debug.c', 'carl9170/main.c' and
'carl9170/tx.c' are consistent with a 'ar->fw.mem_blocks' bits long bitmap.

So the smaller memory allocation of this patch looks correct to me.
... but review with care :)
---
 drivers/net/wireless/ath/carl9170/main.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index cca3b086aa70..49f7ee1c912b 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -307,8 +307,7 @@ static void carl9170_zap_queues(struct ar9170 *ar)
 	for (i = 0; i < ar->hw->queues; i++)
 		ar->tx_stats[i].limit = CARL9170_NUM_TX_LIMIT_HARD;
 
-	for (i = 0; i < DIV_ROUND_UP(ar->fw.mem_blocks, BITS_PER_LONG); i++)
-		ar->mem_bitmap[i] = 0;
+	bitmap_zero(ar->mem_bitmap, ar->fw.mem_blocks);
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(cvif, &ar->vif_list, list) {
@@ -1968,9 +1967,7 @@ int carl9170_register(struct ar9170 *ar)
 	if (WARN_ON(ar->mem_bitmap))
 		return -EINVAL;
 
-	ar->mem_bitmap = kcalloc(roundup(ar->fw.mem_blocks, BITS_PER_LONG),
-				 sizeof(unsigned long),
-				 GFP_KERNEL);
+	ar->mem_bitmap = bitmap_zalloc(ar->fw.mem_blocks, GFP_KERNEL);
 
 	if (!ar->mem_bitmap)
 		return -ENOMEM;
@@ -2085,7 +2082,7 @@ void carl9170_free(struct ar9170 *ar)
 	kfree_skb(ar->rx_failover);
 	ar->rx_failover = NULL;
 
-	kfree(ar->mem_bitmap);
+	bitmap_free(ar->mem_bitmap);
 	ar->mem_bitmap = NULL;
 
 	kfree(ar->survey);
-- 
2.30.2

