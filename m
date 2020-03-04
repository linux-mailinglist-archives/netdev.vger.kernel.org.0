Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C06B1794FF
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 17:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388053AbgCDQYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 11:24:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:42236 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729906AbgCDQYH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 11:24:07 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5F335B486;
        Wed,  4 Mar 2020 16:24:05 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id E48B6E037F; Wed,  4 Mar 2020 17:24:04 +0100 (CET)
Message-Id: <a0639d80f9f35717cad0e2cd27283c580f701a71.1583337972.git.mkubecek@suse.cz>
In-Reply-To: <cover.1583337972.git.mkubecek@suse.cz>
References: <cover.1583337972.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next 2/5] tun: get rid of DBG1() macro
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Date:   Wed,  4 Mar 2020 17:24:04 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This macro is no-op unless TUN_DEBUG is defined (which requires editing and
recompiling the source) and only does something if variable debug is 2 but
that variable is zero initialized and never set to anything else. Moreover,
the only use of the macro informs about entering function tun_chr_open()
which can be easily achieved using ftrace or kprobe.

Drop DBG1() macro, its only use and global variable debug.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 drivers/net/tun.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index ea64c311a554..59290ef07497 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -79,29 +79,17 @@ static void tun_default_link_ksettings(struct net_device *dev,
 /* #define TUN_DEBUG 1 */
 
 #ifdef TUN_DEBUG
-static int debug;
-
 #define tun_debug(level, tun, fmt, args...)			\
 do {								\
 	if (tun->debug)						\
 		netdev_printk(level, tun->dev, fmt, ##args);	\
 } while (0)
-#define DBG1(level, fmt, args...)				\
-do {								\
-	if (debug == 2)						\
-		printk(level fmt, ##args);			\
-} while (0)
 #else
 #define tun_debug(level, tun, fmt, args...)			\
 do {								\
 	if (0)							\
 		netdev_printk(level, tun->dev, fmt, ##args);	\
 } while (0)
-#define DBG1(level, fmt, args...)				\
-do {								\
-	if (0)							\
-		printk(level fmt, ##args);			\
-} while (0)
 #endif
 
 #define TUN_RX_PAD (NET_IP_ALIGN + NET_SKB_PAD)
@@ -3415,8 +3403,6 @@ static int tun_chr_open(struct inode *inode, struct file * file)
 	struct net *net = current->nsproxy->net_ns;
 	struct tun_file *tfile;
 
-	DBG1(KERN_INFO, "tunX: tun_chr_open\n");
-
 	tfile = (struct tun_file *)sk_alloc(net, AF_UNSPEC, GFP_KERNEL,
 					    &tun_proto, 0);
 	if (!tfile)
-- 
2.25.1

