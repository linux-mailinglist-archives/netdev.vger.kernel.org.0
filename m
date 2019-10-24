Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFA4CE3B31
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 20:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504104AbfJXSni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 14:43:38 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:57282 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437045AbfJXSnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 14:43:37 -0400
Received: by mail-pf1-f202.google.com with SMTP id b17so19691792pfo.23
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 11:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=SWHBwJpY+mbEJjd0jDnR51hAwk0LjNuD7KeX5zYB1k4=;
        b=DbIxIjpWbAHzkhmaxO3Wz9cV8ARCqsDe/PvaH57j1Gxq/Gw4eKhPL4M+OdYpXp3BiG
         DR9Y8CZhFhyJC4jGtLPcE2w1BBhzdCrjaD/zUypiE9TZJRyKZNOmSCB6yyAQvwtMxpWg
         6P/FhlVhq3k5bWpZyrJId0bmHQ0jlDdjHRJRfP6prtPzCLQ+4d6bZ8fSqwOU/h/sl8AR
         7D49YV9t69TUQjzXTGLL4QnyNQKxV2rvHKYe5F5uRALg/WeJPmSqdl43lGlvq+5qOBbY
         aclr5VMYzZPXAviUkOOzcn/dnWzM8x3B69f/GDCsTs/XhdbHYBHt0JSER/pkbYIfB68c
         EuZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=SWHBwJpY+mbEJjd0jDnR51hAwk0LjNuD7KeX5zYB1k4=;
        b=BQyTVqZC56q5YA7PApRPZJe2sfzSEpLvi+CCN6i7lsNI6brkBxrDs1rU7jrEAr1WmC
         s34uaFhsveh7AkHWJrahZYtn+obhQthejO8OnzdDBHeLMsH2aKraTLAul27Z+wYlMYCT
         2wF1CGxqOXgI97ZtnpUFVe+vkVqkC6OJEdki9MCHmGVSO/4YX5yfOl/EnZQ9KEKliRbM
         0S/V/ZzpOQGbjseqIcWz6rMdsaAYojzyq8FsrOf/+XyvCrtFhAsCnWKzpmGij5q4VGoe
         aYpHNjhLEo1AK/2B7EBcv37NlAWN9i0rsrslVNeGmgYEV2e3bovEUJxOYz3m5KrnRvmN
         WJww==
X-Gm-Message-State: APjAAAWpWg8X5NTkuyHdhOTucNmOJ9PwHWq26ruWXh8lla0uaEAmkSNo
        ypAFe9t+pjJbFaf54G/5pBFCFeDfc7tT+Q==
X-Google-Smtp-Source: APXvYqyJwPapnnrpf2lbk1VnQ+OZUES3QDl/o4U8gCxxK4vMXkw+OJw2TibQLmXAM17E/Olc2n+juyUWO01tWQ==
X-Received: by 2002:a63:e20c:: with SMTP id q12mr16230268pgh.275.1571942615238;
 Thu, 24 Oct 2019 11:43:35 -0700 (PDT)
Date:   Thu, 24 Oct 2019 11:43:31 -0700
Message-Id: <20191024184331.28920-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH net] udp: fix data-race in udp_set_dev_scratch()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

KCSAN reported a data-race in udp_set_dev_scratch() [1]

The issue here is that we must not write over skb fields
if skb is shared. A similar issue has been fixed in commit
89c22d8c3b27 ("net: Fix skb csum races when peeking")

While we are at it, use a helper only dealing with
udp_skb_scratch(skb)->csum_unnecessary, as this allows
udp_set_dev_scratch() to be called once and thus inlined.

[1]
BUG: KCSAN: data-race in udp_set_dev_scratch / udpv6_recvmsg

write to 0xffff888120278317 of 1 bytes by task 10411 on cpu 1:
 udp_set_dev_scratch+0xea/0x200 net/ipv4/udp.c:1308
 __first_packet_length+0x147/0x420 net/ipv4/udp.c:1556
 first_packet_length+0x68/0x2a0 net/ipv4/udp.c:1579
 udp_poll+0xea/0x110 net/ipv4/udp.c:2720
 sock_poll+0xed/0x250 net/socket.c:1256
 vfs_poll include/linux/poll.h:90 [inline]
 do_select+0x7d0/0x1020 fs/select.c:534
 core_sys_select+0x381/0x550 fs/select.c:677
 do_pselect.constprop.0+0x11d/0x160 fs/select.c:759
 __do_sys_pselect6 fs/select.c:784 [inline]
 __se_sys_pselect6 fs/select.c:769 [inline]
 __x64_sys_pselect6+0x12e/0x170 fs/select.c:769
 do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

read to 0xffff888120278317 of 1 bytes by task 10413 on cpu 0:
 udp_skb_csum_unnecessary include/net/udp.h:358 [inline]
 udpv6_recvmsg+0x43e/0xe90 net/ipv6/udp.c:310
 inet6_recvmsg+0xbb/0x240 net/ipv6/af_inet6.c:592
 sock_recvmsg_nosec+0x5c/0x70 net/socket.c:871
 ___sys_recvmsg+0x1a0/0x3e0 net/socket.c:2480
 do_recvmmsg+0x19a/0x5c0 net/socket.c:2601
 __sys_recvmmsg+0x1ef/0x200 net/socket.c:2680
 __do_sys_recvmmsg net/socket.c:2703 [inline]
 __se_sys_recvmmsg net/socket.c:2696 [inline]
 __x64_sys_recvmmsg+0x89/0xb0 net/socket.c:2696
 do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 10413 Comm: syz-executor.0 Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 2276f58ac589 ("udp: use a separate rx queue for packet reception")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Paolo Abeni <pabeni@redhat.com>
---
 net/ipv4/udp.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 345a3d43f5a655e009e99c16bb19e047cdf003c6..d1ed160af202c054839387201abd3f13b55d00e9 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1316,6 +1316,20 @@ static void udp_set_dev_scratch(struct sk_buff *skb)
 		scratch->_tsize_state |= UDP_SKB_IS_STATELESS;
 }
 
+static void udp_skb_csum_unnecessary_set(struct sk_buff *skb)
+{
+	/* We come here after udp_lib_checksum_complete() returned 0.
+	 * This means that __skb_checksum_complete() might have
+	 * set skb->csum_valid to 1.
+	 * On 64bit platforms, we can set csum_unnecessary
+	 * to true, but only if the skb is not shared.
+	 */
+#if BITS_PER_LONG == 64
+	if (!skb_shared(skb))
+		udp_skb_scratch(skb)->csum_unnecessary = true;
+#endif
+}
+
 static int udp_skb_truesize(struct sk_buff *skb)
 {
 	return udp_skb_scratch(skb)->_tsize_state & ~UDP_SKB_IS_STATELESS;
@@ -1550,10 +1564,7 @@ static struct sk_buff *__first_packet_length(struct sock *sk,
 			*total += skb->truesize;
 			kfree_skb(skb);
 		} else {
-			/* the csum related bits could be changed, refresh
-			 * the scratch area
-			 */
-			udp_set_dev_scratch(skb);
+			udp_skb_csum_unnecessary_set(skb);
 			break;
 		}
 	}
-- 
2.23.0.866.gb869b98d4c-goog

