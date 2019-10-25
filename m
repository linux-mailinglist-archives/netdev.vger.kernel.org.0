Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35678E4945
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 13:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503449AbfJYLIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 07:08:53 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:34332 "EHLO
        andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503468AbfJYLIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 07:08:51 -0400
Received: from ramsan ([84.195.182.253])
        by andre.telenet-ops.be with bizsmtp
        id Hn8b210055USYZQ01n8bdL; Fri, 25 Oct 2019 13:08:50 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iNxSN-0003rD-4F; Fri, 25 Oct 2019 13:08:35 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iNw6A-0006n7-O6; Fri, 25 Oct 2019 11:41:34 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-doc@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v2 6/7] mmc: dw_mmc: Fix debugfs on 64-bit platforms
Date:   Fri, 25 Oct 2019 11:41:29 +0200
Message-Id: <20191025094130.26033-7-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191025094130.26033-1-geert+renesas@glider.be>
References: <20191025094130.26033-1-geert+renesas@glider.be>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"dw_mci.pending_events" and "dw_mci.completed_events" are "unsigned
long", i.e. 32-bit or 64-bit, depending on the platform.  Hence casting
their addresses to "u32 *", and calling debugfs_create_x32() breaks
operation on 64-bit platforms.

Fix this by using the new debugfs_create_xul() helper instead.

Fixes: f95f3850f7a9e1d4 ("mmc: dw_mmc: Add Synopsys DesignWare mmc host driver.")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
---
v2:
  - Add Acked-by.
---
 drivers/mmc/host/dw_mmc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index bf0048ebbda356a7..b4c4a9cd6365f122 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -177,10 +177,10 @@ static void dw_mci_init_debugfs(struct dw_mci_slot *slot)
 	debugfs_create_file("regs", S_IRUSR, root, host, &dw_mci_regs_fops);
 	debugfs_create_file("req", S_IRUSR, root, slot, &dw_mci_req_fops);
 	debugfs_create_u32("state", S_IRUSR, root, (u32 *)&host->state);
-	debugfs_create_x32("pending_events", S_IRUSR, root,
-			   (u32 *)&host->pending_events);
-	debugfs_create_x32("completed_events", S_IRUSR, root,
-			   (u32 *)&host->completed_events);
+	debugfs_create_xul("pending_events", S_IRUSR, root,
+			   &host->pending_events);
+	debugfs_create_xul("completed_events", S_IRUSR, root,
+			   &host->completed_events);
 }
 #endif /* defined(CONFIG_DEBUG_FS) */
 
-- 
2.17.1

