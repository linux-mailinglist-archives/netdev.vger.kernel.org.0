Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7011C5706
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 15:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729119AbgEENdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 09:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728990AbgEENdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 09:33:13 -0400
X-Greylist: delayed 301 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 05 May 2020 06:33:13 PDT
Received: from baptiste.telenet-ops.be (baptiste.telenet-ops.be [IPv6:2a02:1800:120:4::f00:13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2F7C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 06:33:12 -0700 (PDT)
Received: from ramsan ([IPv6:2a02:1810:ac12:ed60:bd97:8453:3b10:1832])
        by baptiste.telenet-ops.be with bizsmtp
        id b1U92200E3VwRR3011U9X9; Tue, 05 May 2020 15:28:09 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1jVxcI-0007yK-1e; Tue, 05 May 2020 15:28:10 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1jVxcI-0004bV-0H; Tue, 05 May 2020 15:28:10 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v2] ionic: Use debugfs_create_bool() to export bool
Date:   Tue,  5 May 2020 15:28:09 +0200
Message-Id: <20200505132809.17655-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently bool ionic_cq.done_color is exported using
debugfs_create_u8(), which requires a cast, preventing further compiler
checks.

Fix this by switching to debugfs_create_bool(), and dropping the cast.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Shannon Nelson <snelson@pensando.io>
---
v2:
  - Add Acked-by.
---
 drivers/net/ethernet/pensando/ionic/ionic_debugfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
index 5f8fc58d42b3d31c..11621ccc1faf0837 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
@@ -170,8 +170,7 @@ void ionic_debugfs_add_qcq(struct ionic_lif *lif, struct ionic_qcq *qcq)
 	debugfs_create_x64("base_pa", 0400, cq_dentry, &cq->base_pa);
 	debugfs_create_u32("num_descs", 0400, cq_dentry, &cq->num_descs);
 	debugfs_create_u32("desc_size", 0400, cq_dentry, &cq->desc_size);
-	debugfs_create_u8("done_color", 0400, cq_dentry,
-			  (u8 *)&cq->done_color);
+	debugfs_create_bool("done_color", 0400, cq_dentry, &cq->done_color);
 
 	debugfs_create_file("tail", 0400, cq_dentry, cq, &cq_tail_fops);
 
-- 
2.17.1

