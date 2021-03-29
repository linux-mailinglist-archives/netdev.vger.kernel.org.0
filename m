Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3CA534D7E8
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 21:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbhC2TNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 15:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbhC2TM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 15:12:58 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC867C061574
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 12:12:58 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id kr3-20020a17090b4903b02900c096fc01deso6404271pjb.4
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 12:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h4fhbSE7DTIdgN26xFWwTxk5fBSRiGCSGdu+yOAmxXg=;
        b=V2QT+abceb12TOwfxGT8k+A0IjZfnX/nnORIk0NRRBlPpBNymw3tpmRBVlcu/lD9sP
         RSJnTNEH6LPoqm4BgVEbK/6yvbD21AuSdgeMC+qnYlrItdY3GqeQLK56uzXHUZC7Lgo/
         ZIG1JIVXiBr/55KuoDjDLmubVM4Wx07+X+f5yDYI5Eu64dfPVisjhjDWHxNDg5hAqjQW
         XXpdOhtveLbgyDdO3JjkmwEfYD1E3gpwFI13kg53IBzQmxOmfjlwXtmgDZFGp0bTtnX0
         krcmrQRduF7IOGvW4o+HChJPd0fzPp5Jd2QO0NuV0BMLzm7PsqN5IInonNA0JrbWcOA3
         WZJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h4fhbSE7DTIdgN26xFWwTxk5fBSRiGCSGdu+yOAmxXg=;
        b=gTg+FMC8x3M6WOhwQrQ0hVL5xMcbsxx5Ch/aXdsCAz2r4HfPDXmr/jbBbKLkYLw8W6
         leJkUR5gRO2Nl/KUzts2bqjEnwRxVZzgXbwt10dvjwJYvX9/z6w0q33Oa6TqMQElXOOb
         tgES+WVAhZHC7ZgRT9cpCV/NRv2Vo+sVWE+A+FE3LxR/kXx04OOLqtsWg8UtjNO7VBa6
         FO6bcOMcdI4U/oy3SWPR4hdddK3midgm5PXuajEpgT43QcuKYn2tKx6l8P66egjlGQv5
         QxSJc1htcOKKOzZcLzM7UYb5zJO0X02jgaJnowhWQqRJEG4fHyNrGabzcwk7Mrbsd0ta
         h2WQ==
X-Gm-Message-State: AOAM532dkBsPv/8agZLMxUDTAFIqEIfMIUMQPTE7uhb9IEXCsLzUgkHN
        M45S7jYORoPAuU6Tpc/kAZM=
X-Google-Smtp-Source: ABdhPJw+RU0O/F+PUtKyc5ieLBu8k0pnHBXbRdjoIFuMkHxtsNBChJXl48+IKe5dE1DWAkqAmeY4Kg==
X-Received: by 2002:a17:90a:1b08:: with SMTP id q8mr546673pjq.203.1617045178295;
        Mon, 29 Mar 2021 12:12:58 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:78a0:7565:129d:828c])
        by smtp.gmail.com with ESMTPSA id c128sm17753196pfc.76.2021.03.29.12.12.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 12:12:57 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] ip6_vti: proper dev_{hold|put} in ndo_[un]init methods
Date:   Mon, 29 Mar 2021 12:12:54 -0700
Message-Id: <20210329191254.137053-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

After adopting CONFIG_PCPU_DEV_REFCNT=n option, syzbot was able to trigger
a warning [1]

Issue here is that:

- all dev_put() should be paired with a corresponding prior dev_hold().

- A driver doing a dev_put() in its ndo_uninit() MUST also
  do a dev_hold() in its ndo_init(), only when ndo_init()
  is returning 0.

Otherwise, register_netdevice() would call ndo_uninit()
in its error path and release a refcount too soon.

Therefore, we need to move dev_hold() call from
vti6_tnl_create2() to vti6_dev_init_gen()

[1]
WARNING: CPU: 0 PID: 15951 at lib/refcount.c:31 refcount_warn_saturate+0xbf/0x1e0 lib/refcount.c:31
Modules linked in:
CPU: 0 PID: 15951 Comm: syz-executor.3 Not tainted 5.12.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:refcount_warn_saturate+0xbf/0x1e0 lib/refcount.c:31
Code: 1d 6a 5a e8 09 31 ff 89 de e8 8d 1a ab fd 84 db 75 e0 e8 d4 13 ab fd 48 c7 c7 a0 e1 c1 89 c6 05 4a 5a e8 09 01 e8 2e 36 fb 04 <0f> 0b eb c4 e8 b8 13 ab fd 0f b6 1d 39 5a e8 09 31 ff 89 de e8 58
RSP: 0018:ffffc90001eaef28 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000040000 RSI: ffffffff815c51f5 RDI: fffff520003d5dd7
RBP: 0000000000000004 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815bdf8e R11: 0000000000000000 R12: ffff88801bb1c568
R13: ffff88801f69e800 R14: 00000000ffffffff R15: ffff888050889d40
FS:  00007fc79314e700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1c1ff47108 CR3: 0000000020fd5000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __refcount_dec include/linux/refcount.h:344 [inline]
 refcount_dec include/linux/refcount.h:359 [inline]
 dev_put include/linux/netdevice.h:4135 [inline]
 vti6_dev_uninit+0x31a/0x360 net/ipv6/ip6_vti.c:297
 register_netdevice+0xadf/0x1500 net/core/dev.c:10308
 vti6_tnl_create2+0x1b5/0x400 net/ipv6/ip6_vti.c:190
 vti6_newlink+0x9d/0xd0 net/ipv6/ip6_vti.c:1020
 __rtnl_newlink+0x1062/0x1710 net/core/rtnetlink.c:3443
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3491
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5553
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x331/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmmsg+0x195/0x470 net/socket.c:2490
 __do_sys_sendmmsg net/socket.c:2519 [inline]
 __se_sys_sendmmsg net/socket.c:2516 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2516

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/ip6_vti.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index f10e7a72ea6248e5ec1fbdb8b4e1c4e0e874cb96..a018afdb3e062c9e664d4ca424176a859f0a332c 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -193,7 +193,6 @@ static int vti6_tnl_create2(struct net_device *dev)
 
 	strcpy(t->parms.name, dev->name);
 
-	dev_hold(dev);
 	vti6_tnl_link(ip6n, t);
 
 	return 0;
@@ -932,6 +931,7 @@ static inline int vti6_dev_init_gen(struct net_device *dev)
 	dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
 	if (!dev->tstats)
 		return -ENOMEM;
+	dev_hold(dev);
 	return 0;
 }
 
-- 
2.31.0.291.g576ba9dcdaf-goog

