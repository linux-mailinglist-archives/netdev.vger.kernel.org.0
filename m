Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9514B3D0B
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 20:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237914AbiBMTGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 14:06:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235146AbiBMTGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 14:06:19 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4024D583BC;
        Sun, 13 Feb 2022 11:06:13 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id p10so4908140pfo.12;
        Sun, 13 Feb 2022 11:06:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ju4vVtu45RWP83gU9vonrmnI1ObnSxSxWN+cCJKH5Sg=;
        b=d1uI8/GralqlyxemI2HOwJpRya0QXqUcwWvSfYZ9e6a1eFkFsOajf0rvWLI9Vo8iFH
         ftN4pfukip1/nsa5t6fYzCIDy40zEpKTyyuBCA1h2FYKaj96zOIbPyk1WT242sxkx6Ta
         0s0qRgCnsu93qrWVxZA3O7VOx4vqF75AvcYr4e0yyHUf3ml+01luwqSBJfd0peKu3vnE
         a3zdQctQwO0Wf6SWjx84h6Goiqmx4VkIY2FfABNSQ/E1p+nhw/FZD6L4WFI+5FTsB00j
         hYJmhh0YcyAe9rUwbDEPJCWGfQ+sBB2MzXfmix/LpjS6XPJLqMBbMFbIK8H0l0MuqIN2
         DCkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ju4vVtu45RWP83gU9vonrmnI1ObnSxSxWN+cCJKH5Sg=;
        b=ueyXpRkk1MF6DAToRmWdMcWLo7AJv+yOILQBDCgG5RIjubpzuBjFb3GOvIgee7Xr+S
         nv+LsYwHw3MPHM1jlHSZzAe5Fwdl1+hAnaKsrCQTr1fly6Hkid7Bzk1J/BW0RgXjPzXS
         4wH6uaYs+vSUzu8YAjj+uVUy1ryhKq3h3sCVig1vaBZw57JTih7pEV+z0NGAzNLLjy4a
         bIy8zCn5mLkE6xTFikgKQBjiGM7GPKDhhhs+8mtLoPX6XVrLG1z7Ny4BERNzYbncKu7L
         a7RvC6OfgdaDWEMZF60UQUQZVw5prtffkB8TK1ts2U60FQY05TVK2Jf4pkVV9L2UDkY3
         bFLg==
X-Gm-Message-State: AOAM5310V/ik2bIofFikV5Swylvt4E94kPvlvoFh4u9ImX5iw/lzILmT
        GghVNR1XBltI52gCn5Y8TQEqCHDDpl0=
X-Google-Smtp-Source: ABdhPJzTMzPu2k7yIcWXqE+i7bh7Dagy1n7+oOV/Geed8Fp0XSbJTTxXEoGd2dTafo0Eg5UbMAmFTA==
X-Received: by 2002:a05:6a00:1ac9:: with SMTP id f9mr11057233pfv.65.1644779172490;
        Sun, 13 Feb 2022 11:06:12 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7e68:a272:168b:5cac])
        by smtp.gmail.com with ESMTPSA id k12sm35516493pfc.107.2022.02.13.11.06.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Feb 2022 11:06:11 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux crypto <linux-crypto@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Wei Wang <weiwan@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH] crypto: af_alg - get rid of alg_memory_allocated
Date:   Sun, 13 Feb 2022 11:06:07 -0800
Message-Id: <20220213190607.183394-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
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

alg_memory_allocated does not seem to be really used.

alg_proto does have a .memory_allocated field, but no
corresponding .sysctl_mem.

This means sk_has_account() returns true, but all sk_prot_mem_limits()
users will trigger a NULL dereference [1].

THis was not a problem until SO_RESERVE_MEM addition.

general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 1 PID: 3591 Comm: syz-executor153 Not tainted 5.17.0-rc3-syzkaller-00316-gb81b1829e7e3 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:sk_prot_mem_limits include/net/sock.h:1523 [inline]
RIP: 0010:sock_reserve_memory+0x1d7/0x330 net/core/sock.c:1000
Code: 08 00 74 08 48 89 ef e8 27 20 bb f9 4c 03 7c 24 10 48 8b 6d 00 48 83 c5 08 48 89 e8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 48 89 ef e8 fb 1f bb f9 48 8b 6d 00 4c 89 ff 48
RSP: 0018:ffffc90001f1fb68 EFLAGS: 00010202
RAX: 0000000000000001 RBX: ffff88814aabc000 RCX: dffffc0000000000
RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffffffff90e18120
RBP: 0000000000000008 R08: dffffc0000000000 R09: fffffbfff21c3025
R10: fffffbfff21c3025 R11: 0000000000000000 R12: ffffffff8d109840
R13: 0000000000001002 R14: 0000000000000001 R15: 0000000000000001
FS:  0000555556e08300(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc74416f130 CR3: 0000000073d9e000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 sock_setsockopt+0x14a9/0x3a30 net/core/sock.c:1446
 __sys_setsockopt+0x5af/0x980 net/socket.c:2176
 __do_sys_setsockopt net/socket.c:2191 [inline]
 __se_sys_setsockopt net/socket.c:2188 [inline]
 __x64_sys_setsockopt+0xb1/0xc0 net/socket.c:2188
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fc7440fddc9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 51 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe98f07968 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fc7440fddc9
RDX: 0000000000000049 RSI: 0000000000000001 RDI: 0000000000000004
RBP: 0000000000000000 R08: 0000000000000004 R09: 00007ffe98f07990
R10: 0000000020000000 R11: 0000000000000246 R12: 00007ffe98f0798c
R13: 00007ffe98f079a0 R14: 00007ffe98f079e0 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:sk_prot_mem_limits include/net/sock.h:1523 [inline]
RIP: 0010:sock_reserve_memory+0x1d7/0x330 net/core/sock.c:1000
Code: 08 00 74 08 48 89 ef e8 27 20 bb f9 4c 03 7c 24 10 48 8b 6d 00 48 83 c5 08 48 89 e8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 48 89 ef e8 fb 1f bb f9 48 8b 6d 00 4c 89 ff 48
RSP: 0018:ffffc90001f1fb68 EFLAGS: 00010202
RAX: 0000000000000001 RBX: ffff88814aabc000 RCX: dffffc0000000000
RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffffffff90e18120
RBP: 0000000000000008 R08: dffffc0000000000 R09: fffffbfff21c3025
R10: fffffbfff21c3025 R11: 0000000000000000 R12: ffffffff8d109840
R13: 0000000000001002 R14: 0000000000000001 R15: 0000000000000001
FS:  0000555556e08300(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc74416f130 CR3: 0000000073d9e000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000

Fixes: 2bb2f5fb21b0 ("net: add new socket option SO_RESERVE_MEM")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Wei Wang <weiwan@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 crypto/af_alg.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index e1ea18536a5f085c816c88bb28da029a5f3a1d3e..c8289b7a85baaa0a83fefcfc0928ea67d522f98c 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -25,12 +25,9 @@ struct alg_type_list {
 	struct list_head list;
 };
 
-static atomic_long_t alg_memory_allocated;
-
 static struct proto alg_proto = {
 	.name			= "ALG",
 	.owner			= THIS_MODULE,
-	.memory_allocated	= &alg_memory_allocated,
 	.obj_size		= sizeof(struct alg_sock),
 };
 
-- 
2.35.1.265.g69c8d7142f-goog

