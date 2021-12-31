Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F145E482198
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 03:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbhLaCfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 21:35:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbhLaCfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 21:35:34 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34340C061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 18:35:34 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id l10so22787015pgm.7
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 18:35:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=S5nvdcCF2To0R9Yo6+8R5iGeQBa+UttNhX6XSiIX+FI=;
        b=R/pXmkaQPWYozoCUzEaCTaVyvjrqRA4IHpNAJLHHVHcjc6LmHTraaUGx+PzsBRiWFK
         mCi8SwG/XwfCyISLElLCXph0vvzblXqCL9HEFTxCf5UL+bP5zLsOxtZUzJ7Oje1GZ0qG
         tT0olGRdFzaL0UxY0la0QsKQk2znu0P9yYN/yJ6V6paF957BfN1s7Y5em/OEwdP/fNqe
         a4zjvBOowb7Kf/bCVktF43YNfU5zPV4bbtHtOS33sTHgeKSW4c1qCnD/TmKmS9b9HLG7
         v2ZKPof7RLzYrLM4K+AnLapN5SiwS812ckiCdLZijUftO2WV9gG3imrgw5O5NaYL1Jo4
         X0nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=S5nvdcCF2To0R9Yo6+8R5iGeQBa+UttNhX6XSiIX+FI=;
        b=0xIDTGNKgFrmUlLdhcst3QR7ia+70QRkA7tT9KgWg66dlb9HR/ntUCmntuRaiIl/9i
         XyHtz1CezhHmEs99szI0YQ4BFDS9yqbwNdfNHksS4RuAz6MOk2IPneNlosiyugQ1QqNP
         BT2mfJs5WLpDOEFxwDdNmSNaBL8j9moBhNpITWQAKM1iGuTTuviA9wFCOVjiOi0SNDe+
         V3SYXbcFex6FTFVELVT1SpmO7GAJPe9/GNSGyK+0GE+tl0MoOwaq7hCM/xVhtq9r++tj
         ZIwnq0O3kwE8B2BfeFeXkgDnCB6yMxtRVOhAQ478HK7XGSJv0IgzMv2YntwNWN0U+VVn
         B5nA==
X-Gm-Message-State: AOAM532IhySJSozceBG3dei6GBFnE2hS2DWw7hn2WlrIWpuhQie4lUxF
        Gp54l0U2LmnuQyipYhqWRC4=
X-Google-Smtp-Source: ABdhPJxvP6pxVGEy9qzxkAUdhMaZIMASUa0JPhRuZA3rfpITUneSwoJuRFiXI23UoXP1+JLV7uLgwQ==
X-Received: by 2002:a63:81c1:: with SMTP id t184mr29525892pgd.481.1640918133720;
        Thu, 30 Dec 2021 18:35:33 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id b6sm23568558pjk.29.2021.12.30.18.35.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Dec 2021 18:35:33 -0800 (PST)
From:   tcs.kernel@gmail.com
To:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Cc:     Haimin Zhang <tcs_kernel@tencent.com>
Subject: [PATCH v2] net ticp:fix a kernel-infoleak in __tipc_sendmsg()
Date:   Fri, 31 Dec 2021 10:35:23 +0800
Message-Id: <1640918123-14547-1-git-send-email-tcs.kernel@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haimin Zhang <tcs_kernel@tencent.com>

struct tipc_socket_addr.ref has a 4-byte hole,and __tipc_getname() currently
copying it to user space,causing kernel-infoleak.

BUG: KMSAN: kernel-infoleak in instrument_copy_to_user include/linux/instrumented.h:121 [inline]
BUG: KMSAN: kernel-infoleak in instrument_copy_to_user include/linux/instrumented.h:121 [inline] lib/usercopy.c:33
BUG: KMSAN: kernel-infoleak in _copy_to_user+0x1c9/0x270 lib/usercopy.c:33 lib/usercopy.c:33
 instrument_copy_to_user include/linux/instrumented.h:121 [inline]
 instrument_copy_to_user include/linux/instrumented.h:121 [inline] lib/usercopy.c:33
 _copy_to_user+0x1c9/0x270 lib/usercopy.c:33 lib/usercopy.c:33
 copy_to_user include/linux/uaccess.h:209 [inline]
 copy_to_user include/linux/uaccess.h:209 [inline] net/socket.c:287
 move_addr_to_user+0x3f6/0x600 net/socket.c:287 net/socket.c:287
 __sys_getpeername+0x470/0x6b0 net/socket.c:1987 net/socket.c:1987
 __do_sys_getpeername net/socket.c:1997 [inline]
 __se_sys_getpeername net/socket.c:1994 [inline]
 __do_sys_getpeername net/socket.c:1997 [inline] net/socket.c:1994
 __se_sys_getpeername net/socket.c:1994 [inline] net/socket.c:1994
 __x64_sys_getpeername+0xda/0x120 net/socket.c:1994 net/socket.c:1994
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_x64 arch/x86/entry/common.c:51 [inline] arch/x86/entry/common.c:82
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Uninit was stored to memory at:
 tipc_getname+0x575/0x5e0 net/tipc/socket.c:757 net/tipc/socket.c:757
 __sys_getpeername+0x3b3/0x6b0 net/socket.c:1984 net/socket.c:1984
 __do_sys_getpeername net/socket.c:1997 [inline]
 __se_sys_getpeername net/socket.c:1994 [inline]
 __do_sys_getpeername net/socket.c:1997 [inline] net/socket.c:1994
 __se_sys_getpeername net/socket.c:1994 [inline] net/socket.c:1994
 __x64_sys_getpeername+0xda/0x120 net/socket.c:1994 net/socket.c:1994
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_x64 arch/x86/entry/common.c:51 [inline] arch/x86/entry/common.c:82
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Uninit was stored to memory at:
 msg_set_word net/tipc/msg.h:212 [inline]
 msg_set_destport net/tipc/msg.h:619 [inline]
 msg_set_word net/tipc/msg.h:212 [inline] net/tipc/socket.c:1486
 msg_set_destport net/tipc/msg.h:619 [inline] net/tipc/socket.c:1486
 __tipc_sendmsg+0x44fa/0x5890 net/tipc/socket.c:1486 net/tipc/socket.c:1486
 tipc_sendmsg+0xeb/0x140 net/tipc/socket.c:1402 net/tipc/socket.c:1402
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 sock_sendmsg_nosec net/socket.c:704 [inline] net/socket.c:2409
 sock_sendmsg net/socket.c:724 [inline] net/socket.c:2409
 ____sys_sendmsg+0xe11/0x12c0 net/socket.c:2409 net/socket.c:2409
 ___sys_sendmsg net/socket.c:2463 [inline]
 ___sys_sendmsg net/socket.c:2463 [inline] net/socket.c:2492
 __sys_sendmsg+0x704/0x840 net/socket.c:2492 net/socket.c:2492
 __do_sys_sendmsg net/socket.c:2501 [inline]
 __se_sys_sendmsg net/socket.c:2499 [inline]
 __do_sys_sendmsg net/socket.c:2501 [inline] net/socket.c:2499
 __se_sys_sendmsg net/socket.c:2499 [inline] net/socket.c:2499
 __x64_sys_sendmsg+0xe2/0x120 net/socket.c:2499 net/socket.c:2499
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_x64 arch/x86/entry/common.c:51 [inline] arch/x86/entry/common.c:82
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Local variable skaddr created at:
 __tipc_sendmsg+0x2d0/0x5890 net/tipc/socket.c:1419 net/tipc/socket.c:1419
 tipc_sendmsg+0xeb/0x140 net/tipc/socket.c:1402 net/tipc/socket.c:1402

Bytes 4-7 of 16 are uninitialized
Memory access of size 16 starts at ffff888113753e00
Data copied to user address 0000000020000280

Reported-by: syzbot+cdbd40e0c3ca02cae3b7@syzkaller.appspotmail.com
Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
---
 net/tipc/socket.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index ad570c2..3e63c83 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1461,6 +1461,8 @@ static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dlen)
 		msg_set_syn(hdr, 1);
 	}
 
+	memset(&skaddr, 0, sizeof(skaddr));
+
 	/* Determine destination */
 	if (atype == TIPC_SERVICE_RANGE) {
 		return tipc_sendmcast(sock, ua, m, dlen, timeout);
-- 
1.8.3.1

