Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70C134994D
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 19:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhCYSPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 14:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbhCYSO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 14:14:57 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A602C06174A
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 11:14:57 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id j25so2907991pfe.2
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 11:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AYIlH9cIXO/E7cDJJ8qi3PLWsH1+bok7oMXF3sRyZz0=;
        b=FxPrHeFh9TbshTjvRLOM8SSb1ggUyETo+aYrdqIECch673JSn36mEOryinPlFN2Bb7
         cI9U57fQOsMgPnNa1YFk4g4Rvbx0tMLmc9KXU7jgeggjUbuSGALX3Zxr5s8il7hkzQZW
         65ZV0I95QVHF2P31zYLS1fuT3pZXiwVh8glJr++jWwGnkDHvLxOg6QHOu87iyawHq/Nk
         Z8ELNBBFyjyE4TbcMvgvHfaLsZngsRDi7zqxIDwqc25kYcBMbvDanCw8Gj/EiR6AWYGP
         9R1YXmTE1FhZ783xT8uGqRcP4lQJfAbUzN2wPfO7vXpiYyvstqfc+X/UimBYMt6goCeg
         q2Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AYIlH9cIXO/E7cDJJ8qi3PLWsH1+bok7oMXF3sRyZz0=;
        b=E9+yKMcuKIqJxniWrsTZnNzE4HxjWP6UJZafaNxbnA1ucA8AZm267Sg+CRPYVfsML+
         Zr9PnhKUMFyypzuhMWVbgXsz7H6uX75qe7Fuv613x7AbhcFPIMkE9JwFouLXkrQD9kt+
         9oUmO8qF2VUsDckIKy3U1xVJCw3Vzr3Jf1sWWRNWh6LswaTCZ+KPRNXKPHJPj4Dl/fOd
         K5kfC0xrzfo9lXXWZPERzg8A0iID550idOP1DMjZhfH2Orlhtg2ITCRqfklklHROmHKY
         fDA02mEWcz5/7DuBfIK3VPosHk1ih7VPX4n2VY+V28w1atrSuDlezMY0X8jMRaCws3ga
         zmvg==
X-Gm-Message-State: AOAM532t37ReM4lOAsuTlRfihaVyEFB92Y8CKzg087wIXXNxHinrgnJT
        ydIcBn1Jz9+W5sGowCzanxo=
X-Google-Smtp-Source: ABdhPJw49n4tXg3rjaZc3MASVan1EwS30C3Ng9QSI/ge0GeKLNP2gnkbov8cgv7OYSGMIpirPIU9fA==
X-Received: by 2002:a63:2345:: with SMTP id u5mr9002286pgm.326.1616696096875;
        Thu, 25 Mar 2021 11:14:56 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:2c0c:35d8:b060:81b3])
        by smtp.gmail.com with ESMTPSA id i17sm6833253pfq.135.2021.03.25.11.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 11:14:56 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] sch_red: fix off-by-one checks in red_check_params()
Date:   Thu, 25 Mar 2021 11:14:53 -0700
Message-Id: <20210325181453.993235-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This fixes following syzbot report:

UBSAN: shift-out-of-bounds in ./include/net/red.h:237:23
shift exponent 32 is too large for 32-bit type 'unsigned int'
CPU: 1 PID: 8418 Comm: syz-executor170 Not tainted 5.12.0-rc4-next-20210324-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:327
 red_set_parms include/net/red.h:237 [inline]
 choke_change.cold+0x3c/0xc8 net/sched/sch_choke.c:414
 qdisc_create+0x475/0x12f0 net/sched/sch_api.c:1247
 tc_modify_qdisc+0x4c8/0x1a50 net/sched/sch_api.c:1663
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5553
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43f039
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdfa725168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043f039
RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000004
RBP: 0000000000403020 R08: 0000000000400488 R09: 0000000000400488
R10: 0000000000400488 R11: 0000000000000246 R12: 00000000004030b0
R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488

Fixes: 8afa10cbe281 ("net_sched: red: Avoid illegal values")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 include/net/red.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/red.h b/include/net/red.h
index 0b39eff1d50aebc43784ebec3fe615fec0bf995c..be11dbd26492094e8b477339c66b3a098e06c39f 100644
--- a/include/net/red.h
+++ b/include/net/red.h
@@ -171,9 +171,9 @@ static inline void red_set_vars(struct red_vars *v)
 static inline bool red_check_params(u32 qth_min, u32 qth_max, u8 Wlog,
 				    u8 Scell_log, u8 *stab)
 {
-	if (fls(qth_min) + Wlog > 32)
+	if (fls(qth_min) + Wlog >= 32)
 		return false;
-	if (fls(qth_max) + Wlog > 32)
+	if (fls(qth_max) + Wlog >= 32)
 		return false;
 	if (Scell_log >= 32)
 		return false;
-- 
2.31.0.291.g576ba9dcdaf-goog

