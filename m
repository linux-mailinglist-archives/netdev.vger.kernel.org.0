Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75558694BEE
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 17:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbjBMQBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 11:01:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbjBMQBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 11:01:08 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131DA30E6
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 08:01:02 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-52ec8c88d75so103548737b3.12
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 08:01:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2ab4fW4k4TLn439311K4mzRuvIGPfMvP6kZKB4N0qY0=;
        b=N++qFJl6vVJAiz5WQEv4dOb+kRbMEy4ywAfiJZQIM/2EeTWBosHJiV6yAu+HAEoFX+
         qXVO+DoXaDK0TpuZxBQNl2/TO3SF9VitfSM7SugkwOTNxmUzeGgWNugpguF48pITGNMk
         ewZ1OGn02hcGxEVpoORXrBTC0oeduKVrKOxapMqzFbOieR0gQ8RuquYOjDEi8gchXvOb
         2JbgdedZ/ILPUPvdoc7NtQya0OYkwaagOHmGq0OU6qRaPfTZbL8UZ/+NtRvNUU7fxz4g
         eRVhx+W13I0wa7icmLNFZcnC44+jIAjD00UmiVIoNgpMBe+KOT/FJ/B81ki9L0Gw+6qM
         z4EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2ab4fW4k4TLn439311K4mzRuvIGPfMvP6kZKB4N0qY0=;
        b=pdn4AC0p17okzUMX26xioTZSGjQuZQokJ5viLZeow0FK0l3R00UBpHrm6ZJ8+rqBmu
         pFcmFTe00N+wGdCNQIRTQHByZnsD9DCNplNuIdpar7NjoJIk+rdxlgi88qb5C5JgI197
         2rN/EJ8cxdNX0+mRGwxGPbVZYeBRiv66uPSaEbrDg0y8xBrMn/XBhtdRAXz1OfAYnczZ
         MrKwE78q9gbIEO0wl3DBZugZeUEwQMzei7rJIFQ0y1ECyXapsE3mtRH95qcuZ6YRfVRA
         6mmO8qaDjL/gHBvbPzz7+jusLDwBu8xWntDCtCmb1Bft2zNR4T3H0z42r/1F7HgqGvyV
         hjPg==
X-Gm-Message-State: AO0yUKWQBtRMxXzqlXprbIa39IPMX2r+Rvy7XJII20GRwJ7hQJ0rc69l
        9GwRX0S7Lw2lydVQZLOtKQycHrz6c2OjHA==
X-Google-Smtp-Source: AK7set+7+GqSwfRYWdaGePhla5fKBdiveA32P7Bomp/acu73uvR1wrYGseF5xfkqB5hm9gfVTPA3zRNqrfz7Cw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:6983:0:b0:502:349d:a151 with SMTP id
 e125-20020a816983000000b00502349da151mr3344714ywc.295.1676304061226; Mon, 13
 Feb 2023 08:01:01 -0800 (PST)
Date:   Mon, 13 Feb 2023 16:00:59 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230213160059.3829741-1-edumazet@google.com>
Subject: [PATCH net] net: use a bounce buffer for copying skb->mark
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Erin MacNeil <lnx.erin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot found arm64 builds would crash in sock_recv_mark()
when CONFIG_HARDENED_USERCOPY=y

x86 and powerpc are not detecting the issue because
they define user_access_begin.
This will be handled in a different patch,
because a check_object_size() is missing.

Only data from skb->cb[] can be copied directly to/from user space,
as explained in commit 79a8a642bf05 ("net: Whitelist
the skbuff_head_cache "cb" field")

syzbot report was:
usercopy: Kernel memory exposure attempt detected from SLUB object 'skbuff_head_cache' (offset 168, size 4)!
------------[ cut here ]------------
kernel BUG at mm/usercopy.c:102 !
Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 PID: 4410 Comm: syz-executor533 Not tainted 6.2.0-rc7-syzkaller-17907-g2d3827b3f393 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/21/2023
pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : usercopy_abort+0x90/0x94 mm/usercopy.c:90
lr : usercopy_abort+0x90/0x94 mm/usercopy.c:90
sp : ffff80000fb9b9a0
x29: ffff80000fb9b9b0 x28: ffff0000c6073400 x27: 0000000020001a00
x26: 0000000000000014 x25: ffff80000cf52000 x24: fffffc0000000000
x23: 05ffc00000000200 x22: fffffc000324bf80 x21: ffff0000c92fe1a8
x20: 0000000000000001 x19: 0000000000000004 x18: 0000000000000000
x17: 656a626f2042554c x16: ffff0000c6073dd0 x15: ffff80000dbd2118
x14: ffff0000c6073400 x13: 00000000ffffffff x12: ffff0000c6073400
x11: ff808000081bbb4c x10: 0000000000000000 x9 : 7b0572d7cc0ccf00
x8 : 7b0572d7cc0ccf00 x7 : ffff80000bf650d4 x6 : 0000000000000000
x5 : 0000000000000001 x4 : 0000000000000001 x3 : 0000000000000000
x2 : ffff0001fefbff08 x1 : 0000000100000000 x0 : 000000000000006c
Call trace:
usercopy_abort+0x90/0x94 mm/usercopy.c:90
__check_heap_object+0xa8/0x100 mm/slub.c:4761
check_heap_object mm/usercopy.c:196 [inline]
__check_object_size+0x208/0x6b8 mm/usercopy.c:251
check_object_size include/linux/thread_info.h:199 [inline]
__copy_to_user include/linux/uaccess.h:115 [inline]
put_cmsg+0x408/0x464 net/core/scm.c:238
sock_recv_mark net/socket.c:975 [inline]
__sock_recv_cmsgs+0x1fc/0x248 net/socket.c:984
sock_recv_cmsgs include/net/sock.h:2728 [inline]
packet_recvmsg+0x2d8/0x678 net/packet/af_packet.c:3482
____sys_recvmsg+0x110/0x3a0
___sys_recvmsg net/socket.c:2737 [inline]
__sys_recvmsg+0x194/0x210 net/socket.c:2767
__do_sys_recvmsg net/socket.c:2777 [inline]
__se_sys_recvmsg net/socket.c:2774 [inline]
__arm64_sys_recvmsg+0x2c/0x3c net/socket.c:2774
__invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
invoke_syscall+0x64/0x178 arch/arm64/kernel/syscall.c:52
el0_svc_common+0xbc/0x180 arch/arm64/kernel/syscall.c:142
do_el0_svc+0x48/0x110 arch/arm64/kernel/syscall.c:193
el0_svc+0x58/0x14c arch/arm64/kernel/entry-common.c:637
el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:591
Code: 91388800 aa0903e1 f90003e8 94e6d752 (d4210000)

Fixes: 6fd1d51cfa25 ("net: SO_RCVMARK socket option for SO_MARK with recvmsg()")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Erin MacNeil <lnx.erin@gmail.com>
---
 net/socket.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index 77626e4d96900b946e340e59e6984e5bab672bbe..4080b4ba7daf35a3a0b88a160299f4abd3afc88f 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -982,9 +982,12 @@ static inline void sock_recv_drops(struct msghdr *msg, struct sock *sk,
 static void sock_recv_mark(struct msghdr *msg, struct sock *sk,
 			   struct sk_buff *skb)
 {
-	if (sock_flag(sk, SOCK_RCVMARK) && skb)
-		put_cmsg(msg, SOL_SOCKET, SO_MARK, sizeof(__u32),
-			 &skb->mark);
+	if (sock_flag(sk, SOCK_RCVMARK) && skb) {
+		/* We must use a bounce buffer for CONFIG_HARDENED_USERCOPY=y */
+		__u32 mark = skb->mark;
+
+		put_cmsg(msg, SOL_SOCKET, SO_MARK, sizeof(__u32), &mark);
+	}
 }
 
 void __sock_recv_cmsgs(struct msghdr *msg, struct sock *sk,
-- 
2.39.1.581.gbfd45094c4-goog

