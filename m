Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E55DEDEFEF
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 16:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729507AbfJUOiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 10:38:06 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:34772 "EHLO
        andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729453AbfJUOh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 10:37:59 -0400
Received: from ramsan ([84.194.98.4])
        by andre.telenet-ops.be with bizsmtp
        id GEdo2100G05gfCL01EdoDj; Mon, 21 Oct 2019 16:37:56 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iMYoe-0007d7-Ef; Mon, 21 Oct 2019 16:37:48 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iMYoe-0003mj-DW; Mon, 21 Oct 2019 16:37:48 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 4/7] mmc: atmel-mci: Fix debugfs on 64-bit platforms
Date:   Mon, 21 Oct 2019 16:37:39 +0200
Message-Id: <20191021143742.14487-5-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191021143742.14487-1-geert+renesas@glider.be>
References: <20191021143742.14487-1-geert+renesas@glider.be>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"atmel_mci.pending_events" and "atmel_mci.completed_events" are
"unsigned long", i.e. 32-bit or 64-bit, depending on the platform.
Hence casting their addresses to "u32 *", and calling
debugfs_create_x32() breaks operation on 64-bit platforms.

Fix this by using the new debugfs_create_xul() helper instead.

Fixes: deec9ae31e607955 ("atmel-mci: debugfs support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/mmc/host/atmel-mci.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index c26fbe5f22221d95..ef2eb9e7c75a32a1 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -584,10 +584,10 @@ static void atmci_init_debugfs(struct atmel_mci_slot *slot)
 	debugfs_create_file("regs", S_IRUSR, root, host, &atmci_regs_fops);
 	debugfs_create_file("req", S_IRUSR, root, slot, &atmci_req_fops);
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
 
 #if defined(CONFIG_OF)
-- 
2.17.1

