Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E51812C2982
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 15:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388963AbgKXO0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 09:26:07 -0500
Received: from m12-11.163.com ([220.181.12.11]:60573 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388847AbgKXO0E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 09:26:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=Qid/xS3X8ptRmr6qcN
        tUBWX3+AdSSzykCmHbw+dEXCM=; b=FO94fehuvM6TX50kJVtAuzE9fwftFCWp0Z
        TRHmjnVnP5GGA1LIDNo6zbAwJ56tdqQ+72yUzyoGazuNSyfglOI+EDam6q/K8epQ
        qflqWgQd55MJefK4ZQ3NLVCCb5ouJauVdJ+nfXAnYKJgiOgJPScH3NVV4YCZuOCK
        LN6wCxlB8=
Received: from hby-server.localdomain (unknown [27.18.76.181])
        by smtp7 (Coremail) with SMTP id C8CowABHQZnEF71f8BJyAA--.2076S2;
        Tue, 24 Nov 2020 22:25:09 +0800 (CST)
From:   hby <hby2003@163.com>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hby <hby2003@163.com>
Subject: [PATCH v2] brmcfmac: fix compile when DEBUG is defined
Date:   Tue, 24 Nov 2020 22:24:40 +0800
Message-Id: <20201124142440.67554-1-hby2003@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: C8CowABHQZnEF71f8BJyAA--.2076S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CF13CFWftw4xtr1fXw1rXrb_yoW5Jr4fpw
        srGa4qyr18u3y3Kay8JFZrAF1rKas7G34qk3y8uw13GFykAw1Fqr40gFyrur1jkF4xJ3y7
        AF10qr9xJFW7K3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRBWlQUUUUU=
X-Originating-IP: [27.18.76.181]
X-CM-SenderInfo: hke1jiiqt6il2tof0z/1tbiQAXmHFSIhGHHKAAAsp
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The steps:
1. add "#define DEBUG" in drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c line 61.
2. make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- O=../Out_Linux bcm2835_defconfig
3. make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- O=../Out_Linux/ zImage modules dtbs -j8

Then, it will fail, the compile log described below:

Kernel: arch/arm/boot/zImage is ready
MODPOST Module.symvers
ERROR: modpost: "brcmf_debugfs_add_entry" [drivers/net/wireless/broadcom/brcm80211/brcmfmac/brcmfmac.ko] undefined!
ERROR: modpost: "brcmf_debugfs_get_devdir" [drivers/net/wireless/broadcom/brcm80211/brcmfmac/brcmfmac.ko] undefined!
ERROR: modpost: "__brcmf_dbg" [drivers/net/wireless/broadcom/brcm80211/brcmfmac/brcmfmac.ko] undefined!
scripts/Makefile.modpost:111: recipe for target 'Module.symvers' failed
make[2]: *** [Module.symvers] Error 1
make[2]: *** Deleting file 'Module.symvers'
Makefile:1390: recipe for target 'modules' failed
make[1]: *** [modules] Error 2
make[1]: Leaving directory '/home/hby/gitee/linux_origin/Out_Linux'
Makefile:185: recipe for target '__sub-make' failed
make: *** [__sub-make] Error 2

Signed-off-by: hby <hby2003@163.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
index 4146faeed..c2eb3aa67 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
@@ -60,7 +60,7 @@ void __brcmf_err(struct brcmf_bus *bus, const char *func, const char *fmt, ...);
 				  ##__VA_ARGS__);			\
 	} while (0)
 
-#if defined(DEBUG) || defined(CONFIG_BRCM_TRACING)
+#if defined(CONFIG_BRCM_TRACING) || defined(CONFIG_BRCMDBG)
 
 /* For debug/tracing purposes treat info messages as errors */
 #define brcmf_info brcmf_err
@@ -114,7 +114,7 @@ extern int brcmf_msg_level;
 
 struct brcmf_bus;
 struct brcmf_pub;
-#ifdef DEBUG
+#if defined(CONFIG_BRCMDBG)
 struct dentry *brcmf_debugfs_get_devdir(struct brcmf_pub *drvr);
 void brcmf_debugfs_add_entry(struct brcmf_pub *drvr, const char *fn,
 			     int (*read_fn)(struct seq_file *seq, void *data));
-- 
2.17.1

