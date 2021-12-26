Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42DC947F711
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 15:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbhLZOG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 09:06:26 -0500
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:52998 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233661AbhLZOGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Dec 2021 09:06:25 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id 1UAEniLEj1UGB1UAEnOMxS; Sun, 26 Dec 2021 15:06:22 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 26 Dec 2021 15:06:22 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     snelson@pensando.io, drivers@pensando.io, davem@davemloft.net,
        kuba@kernel.org, allenbh@pensando.io
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] ionic: Initialize the 'lif->dbid_inuse' bitmap
Date:   Sun, 26 Dec 2021 15:06:17 +0100
Message-Id: <6a478eae0b5e6c63774e1f0ddb1a3f8c38fa8ade.1640527506.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When allocated, this bitmap is not initialized. Only the first bit is set a
few lines below.

Use bitmap_zalloc() to make sure that it is cleared before being used.

Fixes: 6461b446f2a0 ("ionic: Add interrupts and doorbells")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
The 'dbid_inuse' bitmap seems to be unused.
So it is certainly better to remove it completely instead of "fixing" it.

Let me know if it is the way to go or if it is there for future use.

If it should be left in place, the corresponding kfree() should also be
replaces by some bitmap_free() to keep consistency.
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 63f8a8163b5f..2ff7be17e5af 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -3135,7 +3135,7 @@ int ionic_lif_init(struct ionic_lif *lif)
 		return -EINVAL;
 	}
 
-	lif->dbid_inuse = bitmap_alloc(lif->dbid_count, GFP_KERNEL);
+	lif->dbid_inuse = bitmap_zalloc(lif->dbid_count, GFP_KERNEL);
 	if (!lif->dbid_inuse) {
 		dev_err(dev, "Failed alloc doorbell id bitmap, aborting\n");
 		return -ENOMEM;
-- 
2.32.0

