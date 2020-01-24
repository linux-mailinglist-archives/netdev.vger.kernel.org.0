Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFB6149176
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 23:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387554AbgAXW50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 17:57:26 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:54700 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387550AbgAXW5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 17:57:24 -0500
Received: by mail-pg1-f202.google.com with SMTP id i21so2240834pgm.21
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 14:57:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=IjGvDuUL7AXWsVnCU08U2H3PMwPG6Eg1LahKBHNNTiw=;
        b=WC2m1PsIjTc4JcxLqkKP7XXJr3/LePBEz1zFTnhTKtUJ9o0tu3AUm1rp5BgoGrSFYe
         qf3bEyroxWu76AwVP3JigoM8+VKyOoPgqHfxmKaY1PMhb1xpY6w5BG7cug+JnnlQdB4e
         h7WqdBR1bwOlqdEUEkg7CEePyG4/qCCGipfH6QsS41+PO3pEFPLPqlNBzk79MXMP6fF1
         GKoHYUZ+r7DAVMPmI8w8gLsdWGw+FaS9IZphNUaHWIIHW/SoYEpGNQKyvgBX1bzHcM0H
         QEaNI98iaNJyG6FDZysW7B9yqXEmAkMyR/1kILtnUIZzAUCWvND0QDAreKhvC4WHfEXp
         cxdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=IjGvDuUL7AXWsVnCU08U2H3PMwPG6Eg1LahKBHNNTiw=;
        b=Vz1y+wfReh5i9ofuLLNgCOEl1jkKlRHDESAwPYT1EqG3Kc9dFz0E43TRAL405AsGki
         3B+xQ13Y6JRYHVi18RW5BKEwcS3WDOEA+TVVG8PGlslj5NG17jHRRTde0OaU5IVw+Lzp
         FKylLYv7hNkIuQHP30JupVevzgm6dUAGX1lwzozIC0l3DmiSrxjaO33fKEbbQF7eZnrl
         CEdkfLOc9+bI+l6zTFE6avtxC3y9oksOs8UnM/1W/weitVf7qBGXTrkLkIjYbRAwhbWi
         x8x0IbwUeVxpuoshkIspf/uYtWZr8lkAN8hHSs2yz1fLASe5YVlDyeJGO9/UTABk1U9G
         UxzQ==
X-Gm-Message-State: APjAAAXpF9AoLW42+UoxRv0Hm2nbrkPBYgV4m66UqJMHsO4+sXuEcaKX
        hfMPR0yBX3nEhfJQiolYCpYOvXOmp3uG7Q==
X-Google-Smtp-Source: APXvYqwuYMU8IAsawPrGJi29DpQMt1NDwFSDX8UZpwOd70KWo6rkiYQqVnoGCC8wZmTZr6m2sUtDK1mEWlvItQ==
X-Received: by 2002:a63:6e04:: with SMTP id j4mr6528835pgc.175.1579906644020;
 Fri, 24 Jan 2020 14:57:24 -0800 (PST)
Date:   Fri, 24 Jan 2020 14:57:20 -0800
Message-Id: <20200124225720.150449-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH net] net_sched: ematch: reject invalid TCF_EM_SIMPLE
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot+03c4738ed29d5d366ddf@syzkaller.appspotmail.com,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is possible for malicious userspace to set TCF_EM_SIMPLE bit
even for matches that should not have this bit set.

This can fool two places using tcf_em_is_simple()

1) tcf_em_tree_destroy() -> memory leak of em->data
   if ops->destroy() is NULL

2) tcf_em_tree_dump() wrongly report/leak 4 low-order bytes
   of a kernel pointer.

BUG: memory leak
unreferenced object 0xffff888121850a40 (size 32):
  comm "syz-executor927", pid 7193, jiffies 4294941655 (age 19.840s)
  hex dump (first 32 bytes):
    00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000f67036ea>] kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
    [<00000000f67036ea>] slab_post_alloc_hook mm/slab.h:586 [inline]
    [<00000000f67036ea>] slab_alloc mm/slab.c:3320 [inline]
    [<00000000f67036ea>] __do_kmalloc mm/slab.c:3654 [inline]
    [<00000000f67036ea>] __kmalloc_track_caller+0x165/0x300 mm/slab.c:3671
    [<00000000fab0cc8e>] kmemdup+0x27/0x60 mm/util.c:127
    [<00000000d9992e0a>] kmemdup include/linux/string.h:453 [inline]
    [<00000000d9992e0a>] em_nbyte_change+0x5b/0x90 net/sched/em_nbyte.c:32
    [<000000007e04f711>] tcf_em_validate net/sched/ematch.c:241 [inline]
    [<000000007e04f711>] tcf_em_tree_validate net/sched/ematch.c:359 [inline]
    [<000000007e04f711>] tcf_em_tree_validate+0x332/0x46f net/sched/ematch.c:300
    [<000000007a769204>] basic_set_parms net/sched/cls_basic.c:157 [inline]
    [<000000007a769204>] basic_change+0x1d7/0x5f0 net/sched/cls_basic.c:219
    [<00000000e57a5997>] tc_new_tfilter+0x566/0xf70 net/sched/cls_api.c:2104
    [<0000000074b68559>] rtnetlink_rcv_msg+0x3b2/0x4b0 net/core/rtnetlink.c:5415
    [<00000000b7fe53fb>] netlink_rcv_skb+0x61/0x170 net/netlink/af_netlink.c:2477
    [<00000000e83a40d0>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5442
    [<00000000d62ba933>] netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
    [<00000000d62ba933>] netlink_unicast+0x223/0x310 net/netlink/af_netlink.c:1328
    [<0000000088070f72>] netlink_sendmsg+0x2c0/0x570 net/netlink/af_netlink.c:1917
    [<00000000f70b15ea>] sock_sendmsg_nosec net/socket.c:639 [inline]
    [<00000000f70b15ea>] sock_sendmsg+0x54/0x70 net/socket.c:659
    [<00000000ef95a9be>] ____sys_sendmsg+0x2d0/0x300 net/socket.c:2330
    [<00000000b650f1ab>] ___sys_sendmsg+0x8a/0xd0 net/socket.c:2384
    [<0000000055bfa74a>] __sys_sendmsg+0x80/0xf0 net/socket.c:2417
    [<000000002abac183>] __do_sys_sendmsg net/socket.c:2426 [inline]
    [<000000002abac183>] __se_sys_sendmsg net/socket.c:2424 [inline]
    [<000000002abac183>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2424

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot+03c4738ed29d5d366ddf@syzkaller.appspotmail.com
Cc: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/ematch.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/ematch.c b/net/sched/ematch.c
index d0140a92694a4e6185ff80bdd00ef75b7267872c..dd3b8c11a2e0d4808a767041378604f494f4a9af 100644
--- a/net/sched/ematch.c
+++ b/net/sched/ematch.c
@@ -238,6 +238,9 @@ static int tcf_em_validate(struct tcf_proto *tp,
 			goto errout;
 
 		if (em->ops->change) {
+			err = -EINVAL;
+			if (em_hdr->flags & TCF_EM_SIMPLE)
+				goto errout;
 			err = em->ops->change(net, data, data_len, em);
 			if (err < 0)
 				goto errout;
-- 
2.25.0.341.g760bfbb309-goog

