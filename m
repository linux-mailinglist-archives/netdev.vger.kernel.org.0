Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8917AD185F
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 21:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731779AbfJITN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 15:13:26 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:45249 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732004AbfJITL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 15:11:26 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MF3Y8-1iKR6136kK-00FVc7; Wed, 09 Oct 2019 21:11:21 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-kernel@vger.kernel.org, y2038@lists.linaro.org,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, linux-ppp@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH v6 40/43] compat_ioctl: ppp: move simple commands into ppp_generic.c
Date:   Wed,  9 Oct 2019 21:10:41 +0200
Message-Id: <20191009191044.308087-41-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191009190853.245077-1-arnd@arndb.de>
References: <20191009190853.245077-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:GXKtyh7vsF4FiTtWLqzwMcIgXtk7RdFF+r5QNo7+0Nai2sQ9ZhK
 i9SPNDUUDqHigBCgTOYByVDXaADBCY/hfUWfQhV7WNKnbp8kRzv8dfcdVmE7KnqpMWsUZIH
 K3ikAZd0KxhjAEJ+tl/PIU48VlX9i8BvVvO8G30rqK5OnH2DKFaZ12/MqG5+Q+rZ+XXTNGu
 ZIArRzmduuzDYGKk1acEQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:3LrnoRLdkyI=:MmdFQK6DFWyq3jJb8N7RUn
 IL12ltoI2RKH1Z7YqWoUeNsmeAMI9FDC/Uz17lQPjNA1ZEjhhqaTQzP7NHuD0MreGbUhtvqSL
 En1x8SnofFrD3GHk0fVJKFM3fLj0mGZpj0AhhD5M8C4ZvfWmDXbVavPYoisq4mzZEl2BNOamg
 7IWHFsuiVDocZEu4YTjNLM0xMGV4MnHrmXnfLiyWjDpoQjPqRoPMB4ndrUN13tIsom2GKDc/w
 cKX1YU2W/UsTHrPdnz4ogyT5r5NTUFq+LNOECzfqX/cqw8ILrB0Y0InFFgQXCuy/U/ZJJgQpx
 SFtqgdWeCtlY4uxb7T+vJgrvH/QQcp7Q8pbFeN9Lai/QSWsM8KgIKn9F/4uf2d9iT3kbQ55VR
 PZ3wWqRCyCHCh00d0ZzrUfZ8jRM00jaxwy6tUDjfIghLQ8Qtqc8VLsUyP27YwXpqfJjWJBaNE
 JyfSe2zvAjXtf274fiEEoUGfggeodfq2pbe6xylyPZhhBhrITJhDWGxQIoDKCp9b79blI6/TI
 74Noka0qP0upaDaemC8U8f3kGDkpQA/eIZnqpRcc8ScBrd/vZswIdZYCF0JLlBfD4zCZDr2HW
 lgQsa3gMghBFFqxXhOUGBuoqqw1raOWU81Bg1zGdE+nBVFi3e5awK2n8Sz/L1gK4EwYn7DWNq
 RO+6ZzYjwS6UwsrEnZNMyuR2cNaab3A6CyDon9W3whXkKuHq7ZIma079IboVuPB38PWU5kPHw
 jlCpJ8un80WGpqU2t/mPiMcGISukA4qb3BzoJYrzDFKpVz9jn7IoQcDT9OUUG7HpVMZIhb2wX
 zwwZKHMbKwwB77X8PSGHiQVX44xYXSAR26wsIdUa4Vwxy1C8F7sW3gVnzBg1VPahqoHia+xK3
 b8BRFozz+zjiahuPb+2Q==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All ppp commands that are not already handled in ppp_compat_ioctl()
are compatible, so they can now handled by calling the native
ppp_ioctl() directly.

Without CONFIG_BLOCK, the generic compat_ioctl table is now empty,
so add a check to avoid a build failure in the looking function for
that configuration.

Cc: netdev@vger.kernel.org
Cc: linux-ppp@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ppp/ppp_generic.c |  4 ++++
 fs/compat_ioctl.c             | 36 ++++-------------------------------
 2 files changed, 8 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index ce4dd45c541d..267fe2c58087 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -903,6 +903,10 @@ static long ppp_compat_ioctl(struct file *file, unsigned int cmd, unsigned long
 	}
 	mutex_unlock(&ppp_mutex);
 
+	/* all other commands have compatible arguments */
+	if (err == -ENOIOCTLCMD)
+		err = ppp_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
+
 	return err;
 }
 #endif
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 5e59101ef981..3cf8b6d113c3 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -144,38 +144,6 @@ COMPATIBLE_IOCTL(SG_GET_REQUEST_TABLE)
 COMPATIBLE_IOCTL(SG_SET_KEEP_ORPHAN)
 COMPATIBLE_IOCTL(SG_GET_KEEP_ORPHAN)
 #endif
-/* PPP stuff */
-COMPATIBLE_IOCTL(PPPIOCGFLAGS)
-COMPATIBLE_IOCTL(PPPIOCSFLAGS)
-COMPATIBLE_IOCTL(PPPIOCGASYNCMAP)
-COMPATIBLE_IOCTL(PPPIOCSASYNCMAP)
-COMPATIBLE_IOCTL(PPPIOCGUNIT)
-COMPATIBLE_IOCTL(PPPIOCGRASYNCMAP)
-COMPATIBLE_IOCTL(PPPIOCSRASYNCMAP)
-COMPATIBLE_IOCTL(PPPIOCGMRU)
-COMPATIBLE_IOCTL(PPPIOCSMRU)
-COMPATIBLE_IOCTL(PPPIOCSMAXCID)
-COMPATIBLE_IOCTL(PPPIOCGXASYNCMAP)
-COMPATIBLE_IOCTL(PPPIOCSXASYNCMAP)
-COMPATIBLE_IOCTL(PPPIOCXFERUNIT)
-/* PPPIOCSCOMPRESS is translated */
-COMPATIBLE_IOCTL(PPPIOCGNPMODE)
-COMPATIBLE_IOCTL(PPPIOCSNPMODE)
-COMPATIBLE_IOCTL(PPPIOCGDEBUG)
-COMPATIBLE_IOCTL(PPPIOCSDEBUG)
-/* PPPIOCSPASS is translated */
-/* PPPIOCSACTIVE is translated */
-COMPATIBLE_IOCTL(PPPIOCGIDLE32)
-COMPATIBLE_IOCTL(PPPIOCGIDLE64)
-COMPATIBLE_IOCTL(PPPIOCNEWUNIT)
-COMPATIBLE_IOCTL(PPPIOCATTACH)
-COMPATIBLE_IOCTL(PPPIOCDETACH)
-COMPATIBLE_IOCTL(PPPIOCSMRRU)
-COMPATIBLE_IOCTL(PPPIOCCONNECT)
-COMPATIBLE_IOCTL(PPPIOCDISCONN)
-COMPATIBLE_IOCTL(PPPIOCATTCHAN)
-COMPATIBLE_IOCTL(PPPIOCGCHAN)
-COMPATIBLE_IOCTL(PPPIOCGL2TPSTATS)
 };
 
 /*
@@ -202,6 +170,7 @@ static long do_ioctl_trans(unsigned int cmd,
 
 static int compat_ioctl_check_table(unsigned int xcmd)
 {
+#ifdef CONFIG_BLOCK
 	int i;
 	const int max = ARRAY_SIZE(ioctl_pointer) - 1;
 
@@ -220,6 +189,9 @@ static int compat_ioctl_check_table(unsigned int xcmd)
 		i--;
 
 	return ioctl_pointer[i] == xcmd;
+#else
+	return 0;
+#endif
 }
 
 COMPAT_SYSCALL_DEFINE3(ioctl, unsigned int, fd, unsigned int, cmd,
-- 
2.20.0

