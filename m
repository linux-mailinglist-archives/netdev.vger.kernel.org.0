Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82EFCDEFF1
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 16:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729463AbfJUOiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 10:38:13 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:57608 "EHLO
        michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729415AbfJUOh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 10:37:57 -0400
Received: from ramsan ([84.194.98.4])
        by michel.telenet-ops.be with bizsmtp
        id GEdo2100S05gfCL06Edorm; Mon, 21 Oct 2019 16:37:54 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iMYoe-0007cz-DO; Mon, 21 Oct 2019 16:37:48 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iMYoe-0003mc-C6; Mon, 21 Oct 2019 16:37:48 +0200
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
Subject: [PATCH 2/7] mac80211: Use debugfs_create_xul() helper
Date:   Mon, 21 Oct 2019 16:37:37 +0200
Message-Id: <20191021143742.14487-3-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191021143742.14487-1-geert+renesas@glider.be>
References: <20191021143742.14487-1-geert+renesas@glider.be>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new debugfs_create_xul() helper instead of open-coding the same
operation.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 net/mac80211/debugfs_sta.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index c8ad20c28c438dab..ca34dcdac8c0bd4d 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -928,12 +928,7 @@ STA_OPS(he_capa);
 		sta->debugfs_dir, sta, &sta_ ##name## _ops);
 
 #define DEBUGFS_ADD_COUNTER(name, field)				\
-	if (sizeof(sta->field) == sizeof(u32))				\
-		debugfs_create_u32(#name, 0400, sta->debugfs_dir,	\
-			(u32 *) &sta->field);				\
-	else								\
-		debugfs_create_u64(#name, 0400, sta->debugfs_dir,	\
-			(u64 *) &sta->field);
+	debugfs_create_ulong(#name, 0400, sta->debugfs_dir, &sta->field);
 
 void ieee80211_sta_debugfs_add(struct sta_info *sta)
 {
@@ -978,14 +973,8 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 				    NL80211_EXT_FEATURE_AIRTIME_FAIRNESS))
 		DEBUGFS_ADD(airtime);
 
-	if (sizeof(sta->driver_buffered_tids) == sizeof(u32))
-		debugfs_create_x32("driver_buffered_tids", 0400,
-				   sta->debugfs_dir,
-				   (u32 *)&sta->driver_buffered_tids);
-	else
-		debugfs_create_x64("driver_buffered_tids", 0400,
-				   sta->debugfs_dir,
-				   (u64 *)&sta->driver_buffered_tids);
+	debugfs_create_xul("driver_buffered_tids", 0400, sta->debugfs_dir,
+			   &sta->driver_buffered_tids);
 
 	drv_sta_add_debugfs(local, sdata, &sta->sta, sta->debugfs_dir);
 }
-- 
2.17.1

