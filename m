Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A50F1AFBCF
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 17:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgDSPzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 11:55:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbgDSPzg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 11:55:36 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2C4E21744;
        Sun, 19 Apr 2020 15:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587311735;
        bh=AXjjzm0OAJt2Bp3VoxLeT77TO2+mdY+nGusLXaZbMbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B9qZpO+eBiFSNRCmnj5JJrPgrEj+pseH3LcGKrUmk5Q6FmMx7WUOaKY6C53+ktwhw
         4ris4gcbbEUYe4azOVzwuIotnS+9YgGrmo/TXSaF9wP3TCPEk9+6DZEVHwCj74T1R6
         OHRS8/wGel8+Emno/5wGdsR5aVtZ3h/XWDL+kua8=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Borislav Petkov <bp@suse.de>, Jessica Yu <jeyu@kernel.org>,
        linux-kbuild@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 4/4] kernel/module: Hide vermagic header file from general use
Date:   Sun, 19 Apr 2020 18:55:06 +0300
Message-Id: <20200419155506.129392-1-leon@kernel.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200419141850.126507-1-leon@kernel.org>
References: <20200419141850.126507-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

VERMAGIC* definitions are not supposed to be used by the drivers,
see this [1] bug report, so introduce special define to guard inclusion
of this header file and define it in kernel/modules.h and in internal
script that generates *.mod.c files.

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
Acked-by: Jessica Yu <jeyu@kernel.org>
Co-developed-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/linux/vermagic.h | 5 +++++
 kernel/module.c          | 3 +++
 scripts/mod/modpost.c    | 1 +
 3 files changed, 9 insertions(+)

diff --git a/include/linux/vermagic.h b/include/linux/vermagic.h
index 9aced11e9000..7768d20ada39 100644
--- a/include/linux/vermagic.h
+++ b/include/linux/vermagic.h
@@ -1,4 +1,9 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef INCLUDE_VERMAGIC
+#error "This header can be included from kernel/module.c or *.mod.c only"
+#endif
+
 #include <generated/utsrelease.h>

 /* Simply sanity version stamp for modules. */
diff --git a/kernel/module.c b/kernel/module.c
index 646f1e2330d2..8833e848b73c 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -4,6 +4,9 @@
    Copyright (C) 2001 Rusty Russell, 2002, 2010 Rusty Russell IBM.

 */
+
+#define INCLUDE_VERMAGIC
+
 #include <linux/export.h>
 #include <linux/extable.h>
 #include <linux/moduleloader.h>
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 5c3c50c5ec52..7f7d4ee7b652 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -2251,6 +2251,7 @@ static void add_header(struct buffer *b, struct module *mod)
 	 * Include build-salt.h after module.h in order to
 	 * inherit the definitions.
 	 */
+	buf_printf(b, "#define INCLUDE_VERMAGIC\n");
 	buf_printf(b, "#include <linux/build-salt.h>\n");
 	buf_printf(b, "#include <linux/vermagic.h>\n");
 	buf_printf(b, "#include <linux/compiler.h>\n");
--
2.25.2

