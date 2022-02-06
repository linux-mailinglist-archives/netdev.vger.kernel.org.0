Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2520F4AADF1
	for <lists+netdev@lfdr.de>; Sun,  6 Feb 2022 06:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiBFFFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Feb 2022 00:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiBFFFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 00:05:22 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86DF9C06173B
        for <netdev@vger.kernel.org>; Sat,  5 Feb 2022 21:05:21 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id c9so8645724plg.11
        for <netdev@vger.kernel.org>; Sat, 05 Feb 2022 21:05:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gK7ZL4D9eJEdKdBgLXNsu43fhc3IhyNb4+U5FQaEJoI=;
        b=QoExXMwLA8LkybaTTXr9SC8NZfT7Kg87JKL5K5FRZDWC7QYQkSd+AGMrHsirEAT4kT
         DVFi5BOwx/4cfjyAl/XNpFPkobudOGLKR/CrF4IS6xvg5QCSKFUe5f1vydyc7To8P3zr
         PnSVjlTa7lDwQiqLRloSyMeue5Y7MbvHTO09wn646nsaVlxze4wX6h9dsZhCPieIkdAo
         GAbEBFsW0p4+T5QITiuLBl7Zni5az6uk4eOtsDvWuzCaOogWFIKUzShGFCVf6DTHeLVn
         e9aXG/vs5b5yqlzq2B7IrJRctYzERy2xIFMlT8jk5S4yqFSmrUinPJ+pUQ58oG/lkMsP
         OH8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gK7ZL4D9eJEdKdBgLXNsu43fhc3IhyNb4+U5FQaEJoI=;
        b=pXiKPFvioGv6MV2rsrk1/CJVwD+KENKe0iLqF7rP00GHRrQDUYaiO4NJ4OnXbPH58O
         GbuNXGtoDfwRRYFVdmxaITed+ErImeNYzwJOud7PtXR/ejQlCbmd08N8lCA043eFzPlB
         hiTwWcLwXYAJ7XTw65gWvFKE8LxMZA8gzp3x2xMAyDX9Wu/hd7vZQRqmcncWjaZRBuzp
         cGvoi7bEt6yYLNtxOHH20vNwDvFrcKWPoCW0L2LrZ1uZzwQaOJ9NaG9KPcjD0VTltipv
         jAodbUzcyLQ74vWwfInjBlwJoiHwM6Rk35L7oo4ekJXR7WeWO1Zk6UyHvm7YKhwNRBWf
         DSJA==
X-Gm-Message-State: AOAM531dkrjx6QoFXUSNHwwQysFa0qUIU8J0qFH+YxxUhE1Ct/lwO39G
        pd1iDl3/fZLZAZuLVagn7cg=
X-Google-Smtp-Source: ABdhPJxJr7uNm5u6MfstXsqOW4mEjVoxGZ28LsvCkMN/oyZIl/zfmRXHPyCyNMhj8ppb/Ge6zDY/1w==
X-Received: by 2002:a17:90a:2e03:: with SMTP id q3mr7385715pjd.184.1644123920791;
        Sat, 05 Feb 2022 21:05:20 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8eb:b7ed:dbe7:a81f])
        by smtp.gmail.com with ESMTPSA id p64sm4920728pga.13.2022.02.05.21.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 21:05:20 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] net/smc: fix ref_tracker issue in smc_pnet_add()
Date:   Sat,  5 Feb 2022 21:05:16 -0800
Message-Id: <20220206050516.23178-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

I added the netdev_tracker_alloc() right after ndev was
stored into the newly allocated object:

  new_pe->ndev = ndev;
  if (ndev)
      netdev_tracker_alloc(ndev, &new_pe->dev_tracker, GFP_KERNEL);

But I missed that later, we could end up freeing new_pe,
then calling dev_put(ndev) to release the reference on ndev.

The new_pe->dev_tracker would not be freed.

To solve this issue, move the netdev_tracker_alloc() call to
the point we know for sure new_pe will be kept.

syzbot report (on net-next tree, but the bug is present in net tree)
WARNING: CPU: 0 PID: 6019 at lib/refcount.c:31 refcount_warn_saturate+0xbf/0x1e0 lib/refcount.c:31
Modules linked in:
CPU: 0 PID: 6019 Comm: syz-executor.3 Not tainted 5.17.0-rc2-syzkaller-00650-g5a8fb33e5305 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:refcount_warn_saturate+0xbf/0x1e0 lib/refcount.c:31
Code: 1d f4 70 a0 09 31 ff 89 de e8 4d bc 99 fd 84 db 75 e0 e8 64 b8 99 fd 48 c7 c7 20 0c 06 8a c6 05 d4 70 a0 09 01 e8 9e 4e 28 05 <0f> 0b eb c4 e8 48 b8 99 fd 0f b6 1d c3 70 a0 09 31 ff 89 de e8 18
RSP: 0018:ffffc900043b7400 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000040000 RSI: ffffffff815fb318 RDI: fffff52000876e72
RBP: 0000000000000004 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815f507e R11: 0000000000000000 R12: 1ffff92000876e85
R13: 0000000000000000 R14: ffff88805c1c6600 R15: 0000000000000000
FS:  00007f1ef6feb700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2d02b000 CR3: 00000000223f4000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __refcount_dec include/linux/refcount.h:344 [inline]
 refcount_dec include/linux/refcount.h:359 [inline]
 ref_tracker_free+0x53f/0x6c0 lib/ref_tracker.c:119
 netdev_tracker_free include/linux/netdevice.h:3867 [inline]
 dev_put_track include/linux/netdevice.h:3884 [inline]
 dev_put_track include/linux/netdevice.h:3880 [inline]
 dev_put include/linux/netdevice.h:3910 [inline]
 smc_pnet_add_eth net/smc/smc_pnet.c:399 [inline]
 smc_pnet_enter net/smc/smc_pnet.c:493 [inline]
 smc_pnet_add+0x5fc/0x15f0 net/smc/smc_pnet.c:556
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:731
 genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:792
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:803
 netlink_unicast_kernel net/netlink/af_netlink.c:1317 [inline]
 netlink_unicast+0x539/0x7e0 net/netlink/af_netlink.c:1343
 netlink_sendmsg+0x904/0xe00 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:725
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2413
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2467
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2496
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: b60645248af3 ("net/smc: add net device tracker to struct smc_pnetentry")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/smc/smc_pnet.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 291f1484a1b74c0a793ab3c4f3ef90804d1f9932..fb6331d97185a5db9b4539e7f081e9fa469bc44b 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -368,9 +368,6 @@ static int smc_pnet_add_eth(struct smc_pnettable *pnettable, struct net *net,
 	new_pe->type = SMC_PNET_ETH;
 	memcpy(new_pe->pnet_name, pnet_name, SMC_MAX_PNETID_LEN);
 	strncpy(new_pe->eth_name, eth_name, IFNAMSIZ);
-	new_pe->ndev = ndev;
-	if (ndev)
-		netdev_tracker_alloc(ndev, &new_pe->dev_tracker, GFP_KERNEL);
 	rc = -EEXIST;
 	new_netdev = true;
 	write_lock(&pnettable->lock);
@@ -382,6 +379,11 @@ static int smc_pnet_add_eth(struct smc_pnettable *pnettable, struct net *net,
 		}
 	}
 	if (new_netdev) {
+		if (ndev) {
+			new_pe->ndev = ndev;
+			netdev_tracker_alloc(ndev, &new_pe->dev_tracker,
+					     GFP_KERNEL);
+		}
 		list_add_tail(&new_pe->list, &pnettable->pnetlist);
 		write_unlock(&pnettable->lock);
 	} else {
-- 
2.35.0.263.gb82422642f-goog

