Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA005D2BB
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 17:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfGBPXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 11:23:51 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35115 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbfGBPXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 11:23:51 -0400
Received: by mail-pl1-f196.google.com with SMTP id w24so560081plp.2
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 08:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=X9SDYFp5Naacs2SwDBiTXVoaA0ayqjfZ49wY2trQA3s=;
        b=PPSmaLlRrA5JCjIoZCOLqJ4vCPsMcPIwggpcrEcoG31Bh/MpYIvWuY7TfOu58a2hKh
         zWrmGOjRZImPFciT11GZy+8GlMvzCzUacin6gaJqONjAEUQM5OPa8W0N9StUbtElWfi8
         85lh46vWC+5l7sHa9fuEEYuPNmeKcNDynYtEng5srUPae6MgHqqTIK0ExBKbIg/7tB0B
         Xoa1NbmjlYS2Bboivj5U3+dpgjlIEo1sQIoNt+ktvZfCuZeyplUXC6Be+M6FEu93Cf1e
         9btYhnlH0ssGXyeE7gdE1hh5wGkkbOxcEMqU2sXF4zqFCnD1LSKrRi9tF2I2c1EtXK3x
         QYfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=X9SDYFp5Naacs2SwDBiTXVoaA0ayqjfZ49wY2trQA3s=;
        b=hKRe8XfxgwTU+YgvEHvH3ylvfmtPUmcn181YBaHFy9/30u2PQZpXld/vbMU7LLznVW
         QQPu4aAtbL241OCUuccizKaL7g9mFIyybcKBZCcnSThGeKUXCe9uTlC9gvT1QKo70Nes
         Ah5v3/kHA32+3gXz/1jY/TO2pbLmmE7FfRd9MvqNmXe39F1kfU3F5Kh2ncX9lZQfpD6f
         5uS0PQPTVSRC3KK2yO0f1M2Lq467eP8RUqymsjGcSDDT5ClXYrlNfe1+eIvUnod8Di81
         oAWZ04gLpizshLIutBsQg1n1gjBs1o9Q6Ykke4U4JgyYMLuMLJTbZ/xg/USpXuGzFsAh
         3ToQ==
X-Gm-Message-State: APjAAAUC5MAHY1b1vLXpozTs6Ijl4p2cK1EJL6P4vnbTiqBocKn1Ehk/
        I96V1nSp4udYvjoKmzgdNKI=
X-Google-Smtp-Source: APXvYqz7X1KDisFaIpxdxy8MuLoiV//sMk7hdhtvfGdVAbQlLLjEt3R5BZ4Wo+JguK/ezAf+psQfQA==
X-Received: by 2002:a17:902:b093:: with SMTP id p19mr34755421plr.141.1562081030644;
        Tue, 02 Jul 2019 08:23:50 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id 85sm18600914pfv.130.2019.07.02.08.23.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 08:23:50 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, pablo@netfilter.org, laforge@gnumonks.org,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 5/6] gtp: fix use-after-free in gtp_newlink()
Date:   Wed,  3 Jul 2019 00:23:42 +0900
Message-Id: <20190702152342.23099-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current gtp_newlink() could be called after unregister_pernet_subsys().
gtp_newlink() uses gtp_net but it can be destroyed by
unregister_pernet_subsys().
So unregister_pernet_subsys() should be called after
rtnl_link_unregister().

Test commands:
   #SHELL 1
   while :
   do
	   for i in {1..5}
	   do
		./gtp-link add gtp$i &
	   done
	   killall gtp-link
   done

   #SHELL 2
   while :
   do
	modprobe -rv gtp
   done

Splat looks like:
[  753.176631] BUG: KASAN: use-after-free in gtp_newlink+0x9b4/0xa5c [gtp]
[  753.177722] Read of size 8 at addr ffff8880d48f2458 by task gtp-link/7126
[  753.179082] CPU: 0 PID: 7126 Comm: gtp-link Tainted: G        W         5.2.0-rc6+ #50
[  753.185801] Call Trace:
[  753.186264]  dump_stack+0x7c/0xbb
[  753.186863]  ? gtp_newlink+0x9b4/0xa5c [gtp]
[  753.187583]  print_address_description+0xc7/0x240
[  753.188382]  ? gtp_newlink+0x9b4/0xa5c [gtp]
[  753.189097]  ? gtp_newlink+0x9b4/0xa5c [gtp]
[  753.189846]  __kasan_report+0x12a/0x16f
[  753.190542]  ? gtp_newlink+0x9b4/0xa5c [gtp]
[  753.191298]  kasan_report+0xe/0x20
[  753.191893]  gtp_newlink+0x9b4/0xa5c [gtp]
[  753.192580]  ? __netlink_ns_capable+0xc3/0xf0
[  753.193370]  __rtnl_newlink+0xb9f/0x11b0
[ ... ]
[  753.241201] Allocated by task 7186:
[  753.241844]  save_stack+0x19/0x80
[  753.242399]  __kasan_kmalloc.constprop.3+0xa0/0xd0
[  753.243192]  __kmalloc+0x13e/0x300
[  753.243764]  ops_init+0xd6/0x350
[  753.244314]  register_pernet_operations+0x249/0x6f0
[ ... ]
[  753.251770] Freed by task 7178:
[  753.252288]  save_stack+0x19/0x80
[  753.252833]  __kasan_slab_free+0x111/0x150
[  753.253962]  kfree+0xc7/0x280
[  753.254509]  ops_free_list.part.11+0x1c4/0x2d0
[  753.255241]  unregister_pernet_operations+0x262/0x390
[ ... ]
[  753.285883] list_add corruption. next->prev should be prev (ffff8880d48f2458), but was ffff8880d497d878. (next.
[  753.287241] ------------[ cut here ]------------
[  753.287794] kernel BUG at lib/list_debug.c:25!
[  753.288364] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
[  753.289099] CPU: 0 PID: 7126 Comm: gtp-link Tainted: G    B   W         5.2.0-rc6+ #50
[  753.291036] RIP: 0010:__list_add_valid+0x74/0xd0
[  753.291589] Code: 48 39 da 75 27 48 39 f5 74 36 48 39 dd 74 31 48 83 c4 08 b8 01 00 00 00 5b 5d c3 48 89 d9 48b
[  753.293779] RSP: 0018:ffff8880cae8f398 EFLAGS: 00010286
[  753.294401] RAX: 0000000000000075 RBX: ffff8880d497d878 RCX: 0000000000000000
[  753.296260] RDX: 0000000000000075 RSI: 0000000000000008 RDI: ffffed10195d1e69
[  753.297070] RBP: ffff8880cd250ae0 R08: ffffed101b4bff21 R09: ffffed101b4bff21
[  753.297899] R10: 0000000000000001 R11: ffffed101b4bff20 R12: ffff8880d497d878
[  753.298703] R13: 0000000000000000 R14: ffff8880cd250ae0 R15: ffff8880d48f2458
[  753.299564] FS:  00007f5f79805740(0000) GS:ffff8880da400000(0000) knlGS:0000000000000000
[  753.300533] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  753.301231] CR2: 00007fe8c7ef4f10 CR3: 00000000b71a6006 CR4: 00000000000606f0
[  753.302183] Call Trace:
[  753.302530]  gtp_newlink+0x5f6/0xa5c [gtp]
[  753.303037]  ? __netlink_ns_capable+0xc3/0xf0
[  753.303576]  __rtnl_newlink+0xb9f/0x11b0
[  753.304092]  ? rtnl_link_unregister+0x230/0x230

Fixes: 459aa660eb1d ("gtp: add initial driver for datapath of GPRS Tunneling Protocol (GTP-U)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/gtp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 52f35cbeb1dc..b3ccac54e204 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -1376,9 +1376,9 @@ late_initcall(gtp_init);
 
 static void __exit gtp_fini(void)
 {
-	unregister_pernet_subsys(&gtp_net_ops);
 	genl_unregister_family(&gtp_genl_family);
 	rtnl_link_unregister(&gtp_link_ops);
+	unregister_pernet_subsys(&gtp_net_ops);
 
 	pr_info("GTP module unloaded\n");
 }
-- 
2.17.1

