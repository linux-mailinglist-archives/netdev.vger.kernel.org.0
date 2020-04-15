Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842231AA8D8
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 15:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2636179AbgDONhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 09:37:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2636157AbgDONhJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 09:37:09 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57A08206F9;
        Wed, 15 Apr 2020 13:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586957829;
        bh=UplFaPlcIonIevpQ2fKvq31zD8DuiqpQXFn4HXlzmVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H+J3jd8HAduTSP10LpHtaJ2ktC8pC2t7rh1fUPU9kTSxqtzTFBrQpF+uNPs0VSwiy
         aEQXax6V9cK7TKX3nCUv5G5KhaeGHs6J4gM4/46M8P0t7p2MpNyCXj+OfUwmkJJ4JY
         +PM9fzbiiCs04FwCRhbbVxshEx6rAMzpdqz31LlU=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Borislav Petkov <bp@suse.de>, Jessica Yu <jeyu@kernel.org>,
        linux-kbuild@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>, netdev@vger.kernel.org
Subject: [PATCH net-next v1 4/4] kernel/module: Hide vermagic header file from general use
Date:   Wed, 15 Apr 2020 16:36:48 +0300
Message-Id: <20200415133648.1306956-5-leon@kernel.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200415133648.1306956-1-leon@kernel.org>
References: <20200415133648.1306956-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

VERMAGIC* definitions are not supposed to be used by the drivers,
see this [1] bug report, so simply move this header file to be visible
to kernel/* and scripts files only.

In-tree module build:
➜  kernel git:(vermagic) ✗ make clean
➜  kernel git:(vermagic) ✗ make M=drivers/infiniband/hw/mlx5
➜  kernel git:(vermagic) ✗ modinfo drivers/infiniband/hw/mlx5/mlx5_ib.ko
filename:	/images/leonro/src/kernel/drivers/infiniband/hw/mlx5/mlx5_ib.ko
<...>
vermagic:       5.6.0+ SMP mod_unload modversions

Out-of-tree module build:
➜  mlx5 make -C /images/leonro/src/kernel clean M=/tmp/mlx5
➜  mlx5 make -C /images/leonro/src/kernel M=/tmp/mlx5
➜  mlx5 modinfo /tmp/mlx5/mlx5_ib.ko
filename:       /tmp/mlx5/mlx5_ib.ko
<...>
vermagic:       5.6.0+ SMP mod_unload modversions

[1] https://lore.kernel.org/lkml/20200411155623.GA22175@zn.tnic
Reported-by: Borislav Petkov <bp@suse.de>
Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 kernel/module.c                      | 2 +-
 {include/linux => kernel}/vermagic.h | 0
 scripts/mod/modpost.c                | 2 +-
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename {include/linux => kernel}/vermagic.h (100%)

diff --git a/kernel/module.c b/kernel/module.c
index 3447f3b74870..fce06095d341 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -29,7 +29,6 @@
 #include <linux/moduleparam.h>
 #include <linux/errno.h>
 #include <linux/err.h>
-#include <linux/vermagic.h>
 #include <linux/notifier.h>
 #include <linux/sched.h>
 #include <linux/device.h>
@@ -55,6 +54,7 @@
 #include <linux/audit.h>
 #include <uapi/linux/module.h>
 #include "module-internal.h"
+#include "vermagic.h"

 #define CREATE_TRACE_POINTS
 #include <trace/events/module.h>
diff --git a/include/linux/vermagic.h b/kernel/vermagic.h
similarity index 100%
rename from include/linux/vermagic.h
rename to kernel/vermagic.h
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 5c3c50c5ec52..91f86261bcfe 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -2252,7 +2252,7 @@ static void add_header(struct buffer *b, struct module *mod)
 	 * inherit the definitions.
 	 */
 	buf_printf(b, "#include <linux/build-salt.h>\n");
-	buf_printf(b, "#include <linux/vermagic.h>\n");
+	buf_printf(b, "#include <../kernel/vermagic.h>\n");
 	buf_printf(b, "#include <linux/compiler.h>\n");
 	buf_printf(b, "\n");
 	buf_printf(b, "BUILD_SALT;\n");
--
2.25.2

