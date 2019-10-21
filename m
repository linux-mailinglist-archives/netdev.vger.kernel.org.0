Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F04B2DEFF7
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 16:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729534AbfJUOiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 10:38:16 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:49110 "EHLO
        albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729376AbfJUOh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 10:37:56 -0400
Received: from ramsan ([84.194.98.4])
        by albert.telenet-ops.be with bizsmtp
        id GEdo2100C05gfCL06EdoBi; Mon, 21 Oct 2019 16:37:54 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iMYoe-0007d1-Dw; Mon, 21 Oct 2019 16:37:48 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iMYoe-0003mg-Ct; Mon, 21 Oct 2019 16:37:48 +0200
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
Subject: [PATCH 3/7] net: caif: Fix debugfs on 64-bit platforms
Date:   Mon, 21 Oct 2019 16:37:38 +0200
Message-Id: <20191021143742.14487-4-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191021143742.14487-1-geert+renesas@glider.be>
References: <20191021143742.14487-1-geert+renesas@glider.be>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"ser_device.state" is "unsigned long", i.e. 32-bit or 64-bit, depending
on the platform.  Hence casting its address to "u32 *", and calling
debugfs_create_x32() breaks operation on 64-bit platforms.

Fix this by using the new debugfs_create_xul() helper instead.

Fixes: 9b27105b4a44c54b ("net-caif-driver: add CAIF serial driver (ldisc)")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/caif/caif_serial.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/caif_serial.c
index 40b079162804fb0c..bd40b114d6cd7214 100644
--- a/drivers/net/caif/caif_serial.c
+++ b/drivers/net/caif/caif_serial.c
@@ -102,8 +102,8 @@ static inline void debugfs_init(struct ser_device *ser, struct tty_struct *tty)
 	debugfs_create_blob("last_rx_msg", 0400, ser->debugfs_tty_dir,
 			    &ser->rx_blob);
 
-	debugfs_create_x32("ser_state", 0400, ser->debugfs_tty_dir,
-			   (u32 *)&ser->state);
+	debugfs_create_xul("ser_state", 0400, ser->debugfs_tty_dir,
+			   &ser->state);
 
 	debugfs_create_x8("tty_status", 0400, ser->debugfs_tty_dir,
 			  &ser->tty_status);
-- 
2.17.1

