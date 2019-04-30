Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B88BFA43
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 15:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728095AbfD3N2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 09:28:07 -0400
Received: from mail-qk1-f202.google.com ([209.85.222.202]:39413 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbfD3N2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 09:28:06 -0400
Received: by mail-qk1-f202.google.com with SMTP id z20so9415620qkj.6
        for <netdev@vger.kernel.org>; Tue, 30 Apr 2019 06:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=/Td7ewRncZw8zWQgW52avsDZApGkr9VpOs8XHUojrHo=;
        b=OQPAW4MRLR1X18yZ4J4rirqkYM+A1Fp2q59jAhMsc0b8t8nDZq6hyuIsyFs/QC9MOv
         W3/8tUaPvZhricFYipti006sJ94OnEeZQNZvHxQVefh73OYGrSFKUF0dBmT/LXsTmMOT
         ySr2wSmVVfrGq+IJZ/KwDn3m4mFiJ+tGCsO6N0xaO1p8MJfqmPhQ9mlGnAIX0R5+vuTz
         5C/xwandvRAF9cSI/khQrLkQ1BC2C97G0ewHfNdFxRh2K/LW4+J0bFdkw410nWAY/9pe
         xuE079zWdFNfGZ6xfW6n9soUOl66GnvZwB64P1XBhvCLDEmXVhXuSTuzMHa5MXzEAFOP
         cnQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=/Td7ewRncZw8zWQgW52avsDZApGkr9VpOs8XHUojrHo=;
        b=TzKFQZus3+2akPmZY2zKXhnvmAtbVAaUawg8KygbAFIGY3xuR8wX4MpQXuwBKeoJsp
         79vEehll21PyeXGpTLh1HBHKcKOwj4RMrKAs4G3ni1ZA6kIm8IqGiyzHZyGM6Y/djaQe
         hCaZA3N9YJe2gTmgeAcx4VFm1tre6AMUax1zQ+fLcEZ3b5NydeUdJHgCkQV1naZRm2uk
         uMerndJjX0EWQkSIAOpg2QpNSORkePyuMEN9Gh6lJ31pxQcBquYyZa1wh9vV7Wct6sqi
         tT5qgyJuQ44e54WbUs3ltfTPlAWZmos2DuaVMz/5W2IRozxP0IO1s13PvEGT+mOEYfG9
         3S/A==
X-Gm-Message-State: APjAAAWZsFHRxzjmr6qNPogHS7vUD8dD2Y/82EDgKW4VlH0w5hxrEFk2
        iMEA7O6wGx59Kcd8UiLO5AoqjYPiSO05Fw==
X-Google-Smtp-Source: APXvYqxMheWpZhIwzYd8CqPQzg8qcQi9KOEcdCCwloFUpYKRuLYW2ile86WDZVuZfSUsXqYEAbhrE/YKZRqVkA==
X-Received: by 2002:a0c:b6c8:: with SMTP id h8mr52020310qve.67.1556630885163;
 Tue, 30 Apr 2019 06:28:05 -0700 (PDT)
Date:   Tue, 30 Apr 2019 06:27:58 -0700
Message-Id: <20190430132758.163542-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
Subject: [PATCH net] l2ip: fix possible use-after-free
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Guillaume Nault <g.nault@alphalink.fr>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before taking a refcount on a rcu protected structure,
we need to make sure the refcount is not zero.

syzbot reported :

refcount_t: increment on 0; use-after-free.
WARNING: CPU: 1 PID: 23533 at lib/refcount.c:156 refcount_inc_checked lib/refcount.c:156 [inline]
WARNING: CPU: 1 PID: 23533 at lib/refcount.c:156 refcount_inc_checked+0x61/0x70 lib/refcount.c:154
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 23533 Comm: syz-executor.2 Not tainted 5.1.0-rc7+ #93
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x172/0x1f0 lib/dump_stack.c:113
 panic+0x2cb/0x65c kernel/panic.c:214
 __warn.cold+0x20/0x45 kernel/panic.c:571
 report_bug+0x263/0x2b0 lib/bug.c:186
 fixup_bug arch/x86/kernel/traps.c:179 [inline]
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:272
 do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:291
 invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:973
RIP: 0010:refcount_inc_checked lib/refcount.c:156 [inline]
RIP: 0010:refcount_inc_checked+0x61/0x70 lib/refcount.c:154
Code: 1d 98 2b 2a 06 31 ff 89 de e8 db 2c 40 fe 84 db 75 dd e8 92 2b 40 fe 48 c7 c7 20 7a a1 87 c6 05 78 2b 2a 06 01 e8 7d d9 12 fe <0f> 0b eb c1 90 90 90 90 90 90 90 90 90 90 90 55 48 89 e5 41 57 41
RSP: 0018:ffff888069f0fba8 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 000000000000f353 RSI: ffffffff815afcb6 RDI: ffffed100d3e1f67
RBP: ffff888069f0fbb8 R08: ffff88809b1845c0 R09: ffffed1015d23ef1
R10: ffffed1015d23ef0 R11: ffff8880ae91f787 R12: ffff8880a8f26968
R13: 0000000000000004 R14: dffffc0000000000 R15: ffff8880a49a6440
 l2tp_tunnel_inc_refcount net/l2tp/l2tp_core.h:240 [inline]
 l2tp_tunnel_get+0x250/0x580 net/l2tp/l2tp_core.c:173
 pppol2tp_connect+0xc00/0x1c70 net/l2tp/l2tp_ppp.c:702
 __sys_connect+0x266/0x330 net/socket.c:1808
 __do_sys_connect net/socket.c:1819 [inline]
 __se_sys_connect net/socket.c:1816 [inline]
 __x64_sys_connect+0x73/0xb0 net/socket.c:1816

Fixes: 54652eb12c1b ("l2tp: hold tunnel while looking up sessions in l2tp_netlink")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Guillaume Nault <g.nault@alphalink.fr>
---

 net/l2tp/l2tp_core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index aee33d1320184e411dbedff72b5bf5199481e53f..52b5a2797c0c6e85e0cd2f8203616b536b86d178 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -169,8 +169,8 @@ struct l2tp_tunnel *l2tp_tunnel_get(const struct net *net, u32 tunnel_id)
 
 	rcu_read_lock_bh();
 	list_for_each_entry_rcu(tunnel, &pn->l2tp_tunnel_list, list) {
-		if (tunnel->tunnel_id == tunnel_id) {
-			l2tp_tunnel_inc_refcount(tunnel);
+		if (tunnel->tunnel_id == tunnel_id &&
+		    refcount_inc_not_zero(&tunnel->ref_count)) {
 			rcu_read_unlock_bh();
 
 			return tunnel;
@@ -190,8 +190,8 @@ struct l2tp_tunnel *l2tp_tunnel_get_nth(const struct net *net, int nth)
 
 	rcu_read_lock_bh();
 	list_for_each_entry_rcu(tunnel, &pn->l2tp_tunnel_list, list) {
-		if (++count > nth) {
-			l2tp_tunnel_inc_refcount(tunnel);
+		if (++count > nth &&
+		    refcount_inc_not_zero(&tunnel->ref_count)) {
 			rcu_read_unlock_bh();
 			return tunnel;
 		}
-- 
2.21.0.593.g511ec345e18-goog

