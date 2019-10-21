Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B810DF005
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 16:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729433AbfJUOh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 10:37:56 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:54270 "EHLO
        xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727309AbfJUOhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 10:37:55 -0400
Received: from ramsan ([84.194.98.4])
        by xavier.telenet-ops.be with bizsmtp
        id GEdo2100C05gfCL01Edox6; Mon, 21 Oct 2019 16:37:54 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iMYoe-0007cx-CY; Mon, 21 Oct 2019 16:37:48 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iMYoe-0003ma-AN; Mon, 21 Oct 2019 16:37:48 +0200
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
Subject: [PATCH 1/7] debugfs: Add debugfs_create_xul() for hexadecimal unsigned long
Date:   Mon, 21 Oct 2019 16:37:36 +0200
Message-Id: <20191021143742.14487-2-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191021143742.14487-1-geert+renesas@glider.be>
References: <20191021143742.14487-1-geert+renesas@glider.be>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The existing debugfs_create_ulong() function supports objects of
type "unsigned long", which are 32-bit or 64-bit depending on the
platform, in decimal form.  To format objects in hexadecimal, various
debugfs_create_x*() functions exist, but all of them take fixed-size
types.

Add a debugfs helper for "unsigned long" objects in hexadecimal format.
This avoids the need for users to open-code the same, or introduce
bugs when casting the value pointer to "u32 *" or "u64 *" to call
debugfs_create_x{32,64}().

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 include/linux/debugfs.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index 33690949b45d6904..d7b2aebcc277d65e 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -356,4 +356,14 @@ static inline ssize_t debugfs_write_file_bool(struct file *file,
 
 #endif
 
+static inline void debugfs_create_xul(const char *name, umode_t mode,
+				      struct dentry *parent,
+				      unsigned long *value)
+{
+	if (sizeof(*value) == sizeof(u32))
+		debugfs_create_x32(name, mode, parent, (u32 *)value);
+	else
+		debugfs_create_x64(name, mode, parent, (u64 *)value);
+}
+
 #endif
-- 
2.17.1

