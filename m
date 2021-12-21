Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A55B847C795
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 20:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241834AbhLUTjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 14:39:51 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46792 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234416AbhLUTju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 14:39:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CEB6B816B3;
        Tue, 21 Dec 2021 19:39:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D628C36AE8;
        Tue, 21 Dec 2021 19:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640115588;
        bh=bNfUoZedx6yXkJHuvzaeMl8iyE0ktEf9fQ6+7LtJZWY=;
        h=From:To:Cc:Subject:Date:From;
        b=Spc7MnxE9o+x2TwYu/sgN3HGbzPb2DbsH5IuMZ1mG/w/Rc0CgIoCSbjnojjU/DCOz
         e629SJi+PZ0hkbd6SBkv6L2qxDBTlCDYYNuJ9qgITj4w0EJe5oxqDy1tqBefpfAJ9h
         mqejR2NhJCQdhnu3LRPqw68lN1IC2ABUViqkkDq+FExPz6BNTyEhS/74anffxCB5Cp
         XuXfXQk3QB6Nxu7xNKq0VLpkQkfWAZRL0XfJZpFdol4lLFlZf6wcperMVrWDSRAVFh
         vryUXC9MaoAtAwBXW2raStQbRrC5AuqTceH7D2y0mN5UqV4cLGxrlWZldyY1I8P4R8
         /Ne1WXyWW9YkA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        kvalo@kernel.org, pkshih@realtek.com, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH net-next 1/2] codel: remove unnecessary sock.h include
Date:   Tue, 21 Dec 2021 11:39:40 -0800
Message-Id: <20211221193941.3805147-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since sock.h is modified relatively often (60 times in the last
12 months) it seems worthwhile to decrease the incremental build
work.

CoDel's header includes net/inet_ecn.h which in turn includes net/sock.h.
codel.h is itself included by mac80211 which is included by much of
the WiFi stack and drivers. Removing the net/inet_ecn.h include from
CoDel breaks the dependecy between WiFi and sock.h.

Commit d068ca2ae2e6 ("codel: split into multiple files") moved all
the code which actually needs ECN helpers out to net/codel_impl.h,
the include can be moved there as well.

This decreases the incremental build size after touching sock.h
from 4999 objects to 4051 objects.

Fix unmasked missing includes in WiFi drivers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: kvalo@kernel.org
CC: pkshih@realtek.com
CC: ath11k@lists.infradead.org
CC: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/ath/ath11k/debugfs.c  | 2 ++
 drivers/net/wireless/realtek/rtw89/core.c  | 2 ++
 drivers/net/wireless/realtek/rtw89/debug.c | 2 ++
 include/net/codel.h                        | 1 -
 include/net/codel_impl.h                   | 2 ++
 5 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/debugfs.c b/drivers/net/wireless/ath/ath11k/debugfs.c
index dba055d085be..eb8b4f20c95e 100644
--- a/drivers/net/wireless/ath/ath11k/debugfs.c
+++ b/drivers/net/wireless/ath/ath11k/debugfs.c
@@ -3,6 +3,8 @@
  * Copyright (c) 2018-2020 The Linux Foundation. All rights reserved.
  */
 
+#include <linux/vmalloc.h>
+
 #include "debugfs.h"
 
 #include "core.h"
diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index cf05baf88640..a0737eea9f81 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /* Copyright(c) 2019-2020  Realtek Corporation
  */
+#include <linux/ip.h>
+#include <linux/udp.h>
 
 #include "coex.h"
 #include "core.h"
diff --git a/drivers/net/wireless/realtek/rtw89/debug.c b/drivers/net/wireless/realtek/rtw89/debug.c
index 9756d75ef24e..22bd1d03e722 100644
--- a/drivers/net/wireless/realtek/rtw89/debug.c
+++ b/drivers/net/wireless/realtek/rtw89/debug.c
@@ -2,6 +2,8 @@
 /* Copyright(c) 2019-2020  Realtek Corporation
  */
 
+#include <linux/vmalloc.h>
+
 #include "coex.h"
 #include "debug.h"
 #include "fw.h"
diff --git a/include/net/codel.h b/include/net/codel.h
index a6c9e34e62b8..d74dd8fda54e 100644
--- a/include/net/codel.h
+++ b/include/net/codel.h
@@ -45,7 +45,6 @@
 #include <linux/ktime.h>
 #include <linux/skbuff.h>
 #include <net/pkt_sched.h>
-#include <net/inet_ecn.h>
 
 /* Controlling Queue Delay (CoDel) algorithm
  * =========================================
diff --git a/include/net/codel_impl.h b/include/net/codel_impl.h
index 137d40d8cbeb..78a27ac73070 100644
--- a/include/net/codel_impl.h
+++ b/include/net/codel_impl.h
@@ -49,6 +49,8 @@
  * Implemented on linux by Dave Taht and Eric Dumazet
  */
 
+#include <net/inet_ecn.h>
+
 static void codel_params_init(struct codel_params *params)
 {
 	params->interval = MS2TIME(100);
-- 
2.31.1

