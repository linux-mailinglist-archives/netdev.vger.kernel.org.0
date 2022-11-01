Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C09E6153D7
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 22:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbiKAVO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 17:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbiKAVOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 17:14:53 -0400
Received: from smtp.smtpout.orange.fr (smtp-16.smtpout.orange.fr [80.12.242.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BADB11DDDE
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 14:14:51 -0700 (PDT)
Received: from pop-os.home ([86.243.100.34])
        by smtp.orange.fr with ESMTPA
        id pyanoKD2rsfCIpyauoWfGf; Tue, 01 Nov 2022 22:14:49 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 01 Nov 2022 22:14:49 +0100
X-ME-IP: 86.243.100.34
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 02/30] wifi: Use kstrtobool() instead of strtobool()
Date:   Tue,  1 Nov 2022 22:13:50 +0100
Message-Id: <1ff34549af5ad6f7c80d5b9e11872b5499065fc1.1667336095.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1667336095.git.christophe.jaillet@wanadoo.fr>
References: <cover.1667336095.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

strtobool() is the same as kstrtobool().
However, the latter is more used within the kernel.

In order to remove strtobool() and slightly simplify kstrtox.h, switch to
the other function name.

While at it, include the corresponding header file (<linux/kstrtox.h>)

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
This patch is part of a serie that axes all usages of strtobool().
Each patch can be applied independently from the other ones.

The last patch of the serie removes the definition of strtobool().

You may not be in copy of the cover letter. So, if needed, it is available
at [1].

[1]: https://lore.kernel.org/all/cover.1667336095.git.christophe.jaillet@wanadoo.fr/
---
 drivers/net/wireless/ath/ath10k/debug.c        | 5 +++--
 drivers/net/wireless/ath/ath9k/ath9k.h         | 1 +
 drivers/net/wireless/ath/ath9k/tx99.c          | 2 +-
 drivers/net/wireless/marvell/mwifiex/debugfs.c | 2 +-
 drivers/net/wireless/marvell/mwifiex/main.h    | 1 +
 5 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index c861e66ef6bc..b9aea1510f7b 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -10,6 +10,7 @@
 #include <linux/vmalloc.h>
 #include <linux/crc32.h>
 #include <linux/firmware.h>
+#include <linux/kstrtox.h>
 
 #include "core.h"
 #include "debug.h"
@@ -1975,7 +1976,7 @@ static ssize_t ath10k_write_btcoex(struct file *file,
 
 	buf[buf_size] = '\0';
 
-	if (strtobool(buf, &val) != 0)
+	if (kstrtobool(buf, &val) != 0)
 		return -EINVAL;
 
 	if (!ar->coex_support)
@@ -2113,7 +2114,7 @@ static ssize_t ath10k_write_peer_stats(struct file *file,
 
 	buf[buf_size] = '\0';
 
-	if (strtobool(buf, &val) != 0)
+	if (kstrtobool(buf, &val) != 0)
 		return -EINVAL;
 
 	mutex_lock(&ar->conf_mutex);
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 3ccf8cfc6b63..2cc23605c9fc 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -20,6 +20,7 @@
 #include <linux/etherdevice.h>
 #include <linux/device.h>
 #include <linux/interrupt.h>
+#include <linux/kstrtox.h>
 #include <linux/leds.h>
 #include <linux/completion.h>
 #include <linux/time.h>
diff --git a/drivers/net/wireless/ath/ath9k/tx99.c b/drivers/net/wireless/ath/ath9k/tx99.c
index 95544ce05acf..8a996ed9a3be 100644
--- a/drivers/net/wireless/ath/ath9k/tx99.c
+++ b/drivers/net/wireless/ath/ath9k/tx99.c
@@ -189,7 +189,7 @@ static ssize_t write_file_tx99(struct file *file, const char __user *user_buf,
 
 	buf[len] = '\0';
 
-	if (strtobool(buf, &start))
+	if (kstrtobool(buf, &start))
 		return -EINVAL;
 
 	mutex_lock(&sc->mutex);
diff --git a/drivers/net/wireless/marvell/mwifiex/debugfs.c b/drivers/net/wireless/marvell/mwifiex/debugfs.c
index bda53cb91f37..52b18f4a774b 100644
--- a/drivers/net/wireless/marvell/mwifiex/debugfs.c
+++ b/drivers/net/wireless/marvell/mwifiex/debugfs.c
@@ -874,7 +874,7 @@ mwifiex_timeshare_coex_write(struct file *file, const char __user *ubuf,
 	if (copy_from_user(&kbuf, ubuf, min_t(size_t, sizeof(kbuf) - 1, count)))
 		return -EFAULT;
 
-	if (strtobool(kbuf, &timeshare_coex))
+	if (kstrtobool(kbuf, &timeshare_coex))
 		return -EINVAL;
 
 	ret = mwifiex_send_cmd(priv, HostCmd_CMD_ROBUST_COEX,
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 63f861e6b28a..b95886e1413e 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -10,6 +10,7 @@
 
 #include <linux/completion.h>
 #include <linux/kernel.h>
+#include <linux/kstrtox.h>
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/semaphore.h>
-- 
2.34.1

