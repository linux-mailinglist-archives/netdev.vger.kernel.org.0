Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA7A458990
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 08:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238710AbhKVHGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 02:06:21 -0500
Received: from out0.migadu.com ([94.23.1.103]:57962 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238645AbhKVHGQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 02:06:16 -0500
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1637564587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Gm4Rs72PHuHNHcW6ViEPu/5zqhq+qlChz2IJ0J5+d8Y=;
        b=Lyjal9bHyGqpDrZYacX4/1DfIM/TqJVVH0kFjn166qIA0Bj+hzeYehYUsRaC4fg14onryr
        Bmz50kfDjviIHXS5K8d71Z+o0OAaX2JY+hzyMacwgCyOco3fk22cWyiG6pvqsuCfPlyU0N
        YHk6FLjuCsLvppwjXc2xzAHVMFRBYuA=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next] arp: Remove #ifdef CONFIG_PROC_FS
Date:   Mon, 22 Nov 2021 15:02:36 +0800
Message-Id: <20211122070236.14218-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

proc_create_net() and remove_proc_entry() already contain the case
whether to define CONFIG_PROC_FS, so remove #ifdef CONFIG_PROC_FS.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/ipv4/arp.c | 33 ++++++++-------------------------
 1 file changed, 8 insertions(+), 25 deletions(-)

diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 857a144b1ea9..4db0325f6e1a 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -1299,21 +1299,6 @@ static struct packet_type arp_packet_type __read_mostly = {
 	.func =	arp_rcv,
 };
 
-static int arp_proc_init(void);
-
-void __init arp_init(void)
-{
-	neigh_table_init(NEIGH_ARP_TABLE, &arp_tbl);
-
-	dev_add_pack(&arp_packet_type);
-	arp_proc_init();
-#ifdef CONFIG_SYSCTL
-	neigh_sysctl_register(NULL, &arp_tbl.parms, NULL);
-#endif
-	register_netdevice_notifier(&arp_netdev_notifier);
-}
-
-#ifdef CONFIG_PROC_FS
 #if IS_ENABLED(CONFIG_AX25)
 
 /* ------------------------------------------------------------------------ */
@@ -1451,16 +1436,14 @@ static struct pernet_operations arp_net_ops = {
 	.exit = arp_net_exit,
 };
 
-static int __init arp_proc_init(void)
+void __init arp_init(void)
 {
-	return register_pernet_subsys(&arp_net_ops);
-}
-
-#else /* CONFIG_PROC_FS */
+	neigh_table_init(NEIGH_ARP_TABLE, &arp_tbl);
 
-static int __init arp_proc_init(void)
-{
-	return 0;
+	dev_add_pack(&arp_packet_type);
+	register_pernet_subsys(&arp_net_ops);
+#ifdef CONFIG_SYSCTL
+	neigh_sysctl_register(NULL, &arp_tbl.parms, NULL);
+#endif
+	register_netdevice_notifier(&arp_netdev_notifier);
 }
-
-#endif /* CONFIG_PROC_FS */
-- 
2.32.0

