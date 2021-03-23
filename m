Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444A5345EB3
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 13:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbhCWM5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 08:57:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:41446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231475AbhCWM52 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 08:57:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79F01619B9;
        Tue, 23 Mar 2021 12:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616504247;
        bh=KFyvKHQFlrz0ttTR9uhddPSigUqRv7aIt+l1vkmpXBk=;
        h=From:To:Cc:Subject:Date:From;
        b=KzngoMGoICqflWzvgtnmxdzBD0Ik6qmeV1Q45PSqrJA6jkO921Zxc7XC6RmKlaiN3
         TuPEyhyZeFH6pAyRnaJF2z4lK/rxYrtvCX5+OvSipM7Vz8n8LpbLC9mxsz0V/GZCnp
         j+Mc+g2p5CJnnC7/cePlpS3ocrOwuPWpwty3rKbi0vMkfldKx0D7ebgLB4HVe5dFWO
         4MW4Oy2odfU4BX7f4qM05/ENEJ2HKODbPaY8VJ5VhcTbq+zv7uFALV3I09Dj4rlCMm
         8yUdJt3zfdUuCHjvShh1F5v+wHjuo4Wjo38tpSvIRMvjWgcHTXQk0pHWjmk2bG19Xb
         +OCkh9F580gtQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Lee Jones <lee.jones@linaro.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] wlcore: fix overlapping snprintf arguments in debugfs
Date:   Tue, 23 Mar 2021 13:57:14 +0100
Message-Id: <20210323125723.1961432-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

gcc complains about undefined behavior in calling snprintf()
with the same buffer as input and output:

drivers/net/wireless/ti/wl18xx/debugfs.c: In function 'diversity_num_of_packets_per_ant_read':
drivers/net/wireless/ti/wl18xx/../wlcore/debugfs.h:86:3: error: 'snprintf' argument 4 overlaps destination object 'buf' [-Werror=restrict]
   86 |   snprintf(buf, sizeof(buf), "%s[%d] = %d\n",  \
      |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   87 |     buf, i, stats->sub.name[i]);   \
      |     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/wireless/ti/wl18xx/debugfs.c:24:2: note: in expansion of macro 'DEBUGFS_FWSTATS_FILE_ARRAY'
   24 |  DEBUGFS_FWSTATS_FILE_ARRAY(a, b, c, wl18xx_acx_statistics)
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/wireless/ti/wl18xx/debugfs.c:159:1: note: in expansion of macro 'WL18XX_DEBUGFS_FWSTATS_FILE_ARRAY'
  159 | WL18XX_DEBUGFS_FWSTATS_FILE_ARRAY(diversity, num_of_packets_per_ant,

There are probably other ways of handling the debugfs file, without
using on-stack buffers, but a simple workaround here is to remember the
current position in the buffer and just keep printing in there.

Fixes: bcca1bbdd412 ("wlcore: add debugfs macro to help print fw statistics arrays")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/ti/wlcore/boot.c    | 13 ++++++++-----
 drivers/net/wireless/ti/wlcore/debugfs.h |  7 ++++---
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/boot.c b/drivers/net/wireless/ti/wlcore/boot.c
index e14d88e558f0..85abd0a2d1c9 100644
--- a/drivers/net/wireless/ti/wlcore/boot.c
+++ b/drivers/net/wireless/ti/wlcore/boot.c
@@ -72,6 +72,7 @@ static int wlcore_validate_fw_ver(struct wl1271 *wl)
 	unsigned int *min_ver = (wl->fw_type == WL12XX_FW_TYPE_MULTI) ?
 		wl->min_mr_fw_ver : wl->min_sr_fw_ver;
 	char min_fw_str[32] = "";
+	int off = 0;
 	int i;
 
 	/* the chip must be exactly equal */
@@ -105,13 +106,15 @@ static int wlcore_validate_fw_ver(struct wl1271 *wl)
 	return 0;
 
 fail:
-	for (i = 0; i < NUM_FW_VER; i++)
+	for (i = 0; i < NUM_FW_VER && off < sizeof(min_fw_str); i++)
 		if (min_ver[i] == WLCORE_FW_VER_IGNORE)
-			snprintf(min_fw_str, sizeof(min_fw_str),
-				  "%s*.", min_fw_str);
+			off += snprintf(min_fw_str + off,
+					sizeof(min_fw_str) - off,
+					"*.");
 		else
-			snprintf(min_fw_str, sizeof(min_fw_str),
-				  "%s%u.", min_fw_str, min_ver[i]);
+			off += snprintf(min_fw_str + off,
+					sizeof(min_fw_str) - off,
+					"%u.", min_ver[i]);
 
 	wl1271_error("Your WiFi FW version (%u.%u.%u.%u.%u) is invalid.\n"
 		     "Please use at least FW %s\n"
diff --git a/drivers/net/wireless/ti/wlcore/debugfs.h b/drivers/net/wireless/ti/wlcore/debugfs.h
index b143293e694f..715edfa5f89f 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.h
+++ b/drivers/net/wireless/ti/wlcore/debugfs.h
@@ -78,13 +78,14 @@ static ssize_t sub## _ ##name## _read(struct file *file,		\
 	struct wl1271 *wl = file->private_data;				\
 	struct struct_type *stats = wl->stats.fw_stats;			\
 	char buf[DEBUGFS_FORMAT_BUFFER_SIZE] = "";			\
+	int pos = 0;							\
 	int i;								\
 									\
 	wl1271_debugfs_update_stats(wl);				\
 									\
-	for (i = 0; i < len; i++)					\
-		snprintf(buf, sizeof(buf), "%s[%d] = %d\n",		\
-			 buf, i, stats->sub.name[i]);			\
+	for (i = 0; i < len && pos < sizeof(buf); i++)			\
+		pos += snprintf(buf + pos, sizeof(buf),			\
+			 "[%d] = %d\n", i, stats->sub.name[i]);		\
 									\
 	return wl1271_format_buffer(userbuf, count, ppos, "%s", buf);	\
 }									\
-- 
2.29.2

