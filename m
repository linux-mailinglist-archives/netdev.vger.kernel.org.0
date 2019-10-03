Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4B6CC96EC
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 05:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728507AbfJCDUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 23:20:07 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:44614 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728432AbfJCDUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 23:20:06 -0400
Received: by mail-pf1-f201.google.com with SMTP id b204so1083228pfb.11
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 20:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=7mvO5xNauCshK5y/aDFS2tqp481mA6WcOqYrTpHAqT0=;
        b=dLVGDKVIl2m75hXUF4s9ZPwrzylSPO/huAM6F+xYMBQWcI+SoCc4CnbrzbDS/rgxsp
         TonPXbxMvS1P8KyJ0IeLsJWBlZ4Hn8MceqUK3aB2B+iqi/mRh+TxGyucl9veQlPwj4JE
         dLWETgVL2nLAy44hjQaMj+HHT66PAzXPjm+MrhAb7jKchfTiamc3sqL882KBD8metn5r
         Y6qaCFpbxGVQ9XMjxKSd/z5Prg/atBiedn5ad9av3ln1mKJh6wf0vodlJAJ5F5m+ShZB
         ozB3Q8I8GMXkFjUlZeVy2si+QYurvkTB8Q0pAUmZf8XbjyupHGdjH41V7x7r0l/VEJij
         Jv0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=7mvO5xNauCshK5y/aDFS2tqp481mA6WcOqYrTpHAqT0=;
        b=X8aptVCwUrNXSoaR/j3lPS7HrPg6RYBB2jeQHiZHNRp1KUJ5/GUJMnRRSE0hBLvGk4
         uiQiogJeiHMXqL9eZhwR+SKxdEzhfbpeace8bUiMhyEqiDvelC1T7sPMHODn99XoR7j6
         L1ZLISTE0Oq6PvpF98L/bQugUmuhq3PlHR6vAFTu/Q1Km1ji09t/KBxYhwJYP9nY3RnU
         nx9iPiXOO5/z2E55X0Sj2YIWRp4O5BIbRFYZ8vXgh0o5qZuL8tf7d62ZCjUbAUzWIvbZ
         RstnF922SNAXIa+FZHTLc01HfN3lysPeNq9QYYoCKMrWxUkhkLYcWmEFQKwvA3EbUWqf
         zImg==
X-Gm-Message-State: APjAAAVk+E7zhxrsv6gNAa3v/VcPE0d7GAFypxpGW4/9obEy+Xkv0g29
        O9A0lsV9qjWIQ0+T3aP92q3sGUifRESJEQ==
X-Google-Smtp-Source: APXvYqyWY5x0iZqrAoSRBDqtNXirdCV5fJKlPosgmrzYkNhpo3WqB3wGZtoyAZC5RrC6l47ttYIrMUoiWK/pcg==
X-Received: by 2002:a63:1950:: with SMTP id 16mr7424241pgz.213.1570072805688;
 Wed, 02 Oct 2019 20:20:05 -0700 (PDT)
Date:   Wed,  2 Oct 2019 20:19:59 -0700
Message-Id: <20191003031959.165054-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [PATCH net] tcp: fix slab-out-of-bounds in tcp_zerocopy_receive()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Apparently a refactoring patch brought a bug, that was caught
by syzbot [1]

Original code was correct, do not try to be smarter than the
compiler :/

[1]
BUG: KASAN: slab-out-of-bounds in tcp_zerocopy_receive net/ipv4/tcp.c:1807 [inline]
BUG: KASAN: slab-out-of-bounds in do_tcp_getsockopt.isra.0+0x2c6c/0x3120 net/ipv4/tcp.c:3654
Read of size 4 at addr ffff8880943cf188 by task syz-executor.2/17508

CPU: 0 PID: 17508 Comm: syz-executor.2 Not tainted 5.3.0-rc7+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x172/0x1f0 lib/dump_stack.c:113
 print_address_description.cold+0xd4/0x306 mm/kasan/report.c:351
 __kasan_report.cold+0x1b/0x36 mm/kasan/report.c:482
 kasan_report+0x12/0x17 mm/kasan/common.c:618
 __asan_report_load4_noabort+0x14/0x20 mm/kasan/generic_report.c:131
 tcp_zerocopy_receive net/ipv4/tcp.c:1807 [inline]
 do_tcp_getsockopt.isra.0+0x2c6c/0x3120 net/ipv4/tcp.c:3654
 tcp_getsockopt+0xbf/0xe0 net/ipv4/tcp.c:3680
 sock_common_getsockopt+0x94/0xd0 net/core/sock.c:3098
 __sys_getsockopt+0x16d/0x310 net/socket.c:2129
 __do_sys_getsockopt net/socket.c:2144 [inline]
 __se_sys_getsockopt net/socket.c:2141 [inline]
 __x64_sys_getsockopt+0xbe/0x150 net/socket.c:2141
 do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296

Fixes: d8e18a516f8f ("net: Use skb accessors in network core")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv4/tcp.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 79c325a07ba5dc7cfad0a846d1f03bf1787f840b..f98a1882e537dca0102e829cb349be50302d83ab 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1798,13 +1798,11 @@ static int tcp_zerocopy_receive(struct sock *sk,
 		}
 		if (skb_frag_size(frags) != PAGE_SIZE || skb_frag_off(frags)) {
 			int remaining = zc->recv_skip_hint;
-			int size = skb_frag_size(frags);
 
-			while (remaining && (size != PAGE_SIZE ||
+			while (remaining && (skb_frag_size(frags) != PAGE_SIZE ||
 					     skb_frag_off(frags))) {
-				remaining -= size;
+				remaining -= skb_frag_size(frags);
 				frags++;
-				size = skb_frag_size(frags);
 			}
 			zc->recv_skip_hint -= remaining;
 			break;
-- 
2.23.0.581.g78d2f28ef7-goog

