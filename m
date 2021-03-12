Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4360B339425
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 18:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbhCLRAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 12:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232389AbhCLQ77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 11:59:59 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E50C061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 08:59:59 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id p21so16252461pgl.12
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 08:59:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R4e0vHpXmVEA0zpvL1or9GwOS3zC6hREPl8g9mZwthg=;
        b=dZV7MBFapJ1xt29/IgWx9ylnQPZ89lJhaZBuGj7J4XbfTmjgnReAsv7DW8rjprrmV3
         ZVmeL6aP9j1ohBOpQQWOLGZhB6G8JlYjxt4ig9V2WIjOmWaTXikGJVFBlRkzsmPilBiZ
         gNptAnFLUBHqd+rznn7aa5nasOuNA0RTJw5m00d5EzqXVndIthSzFiUyciL9rQdRyCPZ
         ykAEEXYbHOlielSFhM8dMAWJrmRNtqjwfmPuzh0zJ2BfdylwWjXRSL9RU+Pxggy4Bv2I
         F67/C2YMUFE0/iYhJk3xoGMU/LS/NuhFzaZkbJ0GHyU3X9yKa5TgghGiuQtrj4kSIIRu
         YCYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R4e0vHpXmVEA0zpvL1or9GwOS3zC6hREPl8g9mZwthg=;
        b=nTjiXhVLQx9f76//uS2ZwCndmgfL9PCRH9Qz8lGUiPntIdQPY/Xsb6jifq9/UTf5tH
         9M1OVYqi7U7sWpmJFtYIOJQEgnf949VKWkRU/XiyQ/ZLY3MrhsYgXLz4Ur/KDTRGUepN
         xWjQicZhyRU0hVVTGEzU0bQM5C3mtcZds11kQY0nwHt+JgAYof37fXB6e3yOqKC0CWMp
         gCrC0OY44STe6YWZ0/t5Zxp55ISt6WJEZoQgY4bbWXCSALDmKx5R2n8L8myRB16RXiFt
         u2JRfaC5i/W2MDcu/TG0vEm+3+/pIxBGODWVeV/4jS1pxiRLlYOgaFN0EfzzyGVW4F49
         RhFA==
X-Gm-Message-State: AOAM532GDjFm8/tEyCicmJQ9CWSRxQ/G/oEeUnYhUyQ4jepuN+8BOF4i
        RcDx1NUnTYUZmBIj7E4r7qs=
X-Google-Smtp-Source: ABdhPJxkeRZY9t1wLn5Nuwht6aKGwY1NY1ap9A01c9OV4Ly09D7I1KQmBNEapHBr3D7id3CJ9gzKRg==
X-Received: by 2002:a63:d0f:: with SMTP id c15mr12342258pgl.367.1615568399077;
        Fri, 12 Mar 2021 08:59:59 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6452:a7e2:4139:2684])
        by smtp.gmail.com with ESMTPSA id m21sm6044811pff.61.2021.03.12.08.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 08:59:58 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] net: qrtr: fix a kernel-infoleak in qrtr_recvmsg()
Date:   Fri, 12 Mar 2021 08:59:48 -0800
Message-Id: <20210312165948.909295-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

struct sockaddr_qrtr has a 2-byte hole, and qrtr_recvmsg() currently
does not clear it before copying kernel data to user space.

It might be too late to name the hole since sockaddr_qrtr structure is uapi.

BUG: KMSAN: kernel-infoleak in kmsan_copy_to_user+0x9c/0xb0 mm/kmsan/kmsan_hooks.c:249
CPU: 0 PID: 29705 Comm: syz-executor.3 Not tainted 5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 kmsan_internal_check_memory+0x202/0x520 mm/kmsan/kmsan.c:402
 kmsan_copy_to_user+0x9c/0xb0 mm/kmsan/kmsan_hooks.c:249
 instrument_copy_to_user include/linux/instrumented.h:121 [inline]
 _copy_to_user+0x1ac/0x270 lib/usercopy.c:33
 copy_to_user include/linux/uaccess.h:209 [inline]
 move_addr_to_user+0x3a2/0x640 net/socket.c:237
 ____sys_recvmsg+0x696/0xd50 net/socket.c:2575
 ___sys_recvmsg net/socket.c:2610 [inline]
 do_recvmmsg+0xa97/0x22d0 net/socket.c:2710
 __sys_recvmmsg net/socket.c:2789 [inline]
 __do_sys_recvmmsg net/socket.c:2812 [inline]
 __se_sys_recvmmsg+0x24a/0x410 net/socket.c:2805
 __x64_sys_recvmmsg+0x62/0x80 net/socket.c:2805
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x465f69
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f43659d6188 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
RAX: ffffffffffffffda RBX: 000000000056bf60 RCX: 0000000000465f69
RDX: 0000000000000008 RSI: 0000000020003e40 RDI: 0000000000000003
RBP: 00000000004bfa8f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000010060 R11: 0000000000000246 R12: 000000000056bf60
R13: 0000000000a9fb1f R14: 00007f43659d6300 R15: 0000000000022000

Local variable ----addr@____sys_recvmsg created at:
 ____sys_recvmsg+0x168/0xd50 net/socket.c:2550
 ____sys_recvmsg+0x168/0xd50 net/socket.c:2550

Bytes 2-3 of 12 are uninitialized
Memory access of size 12 starts at ffff88817c627b40
Data copied to user address 0000000020000140

Fixes: bdabad3e363d ("net: Add Qualcomm IPC router")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Courtney Cavin <courtney.cavin@sonymobile.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/qrtr/qrtr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index edb6ac17cecabd94fe392eb4f589dbbbf7bfa2c0..dfc820ee553a0948cc64f25f5b8f9c5d0061cfd4 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -1058,6 +1058,11 @@ static int qrtr_recvmsg(struct socket *sock, struct msghdr *msg,
 	rc = copied;
 
 	if (addr) {
+		/* There is an anonymous 2-byte hole after sq_family,
+		 * make sure to clear it.
+		 */
+		memset(addr, 0, sizeof(*addr));
+
 		addr->sq_family = AF_QIPCRTR;
 		addr->sq_node = cb->src_node;
 		addr->sq_port = cb->src_port;
-- 
2.31.0.rc2.261.g7f71774620-goog

