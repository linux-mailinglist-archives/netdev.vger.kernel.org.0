Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7E3DF5399
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 19:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730047AbfKHSey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 13:34:54 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:48738 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728075AbfKHSey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 13:34:54 -0500
Received: by mail-pl1-f202.google.com with SMTP id t5so4905105plz.15
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 10:34:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=w9auUL/pXvLfDOJ80JbBGba1Iwj6VsJgzQ11234hDGQ=;
        b=Jpk3QvwHlIXyJE83WnUh7kvCctj9Lzjkr5R8XU+pogTZGCN37o9iB0QzPfaVe3+S2q
         1ybX9mRDFEqbE4uoZL7Q1i5IC2F/ZAlOt9aGOtWsQ2LRZ9/vvwvidL4IPTHWNAYYG27a
         NdxheQs4fCeuWHWqG7CqIdH8Rg0f8M99HcamQQkgi6UgQbhfBrtaUHeG+4G2lFo/nEtZ
         NokvNu7YUWWt/X4SAWEQ4ea/lfo2MQDOU6PCQM0JxUF6Klh7wztaqnpygyElsmKt2eUl
         USkM+QYbyAnlwXapN1C6DF/Req0rChGruBPdf7OmGN7vcD7xNBOrGK6kAlTh8H4Dt2z6
         w5dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=w9auUL/pXvLfDOJ80JbBGba1Iwj6VsJgzQ11234hDGQ=;
        b=jV0eAFnhWdIbZksEdKYa77eu6VUi8T1MnQCifiLMEvipa1BGdw9L5qmvo+xkVJZaEk
         gXcnkvUhFyu2gVsUBRpZiFfpPL8SE23O5ZMUU6kthwosVigcX2m7JEvt4kJl/dOUa/Nv
         +Lo+puwX13YP6cDWknAQBACG93szQNkPrsEA/712z/SELFxqiPE6qK2mqMxjFUl6XJYj
         NlgHgm1PR26vDL5pPC/rozKny1rNHEDvZwodljXFlZW747Mkwr7D9cRrFv9kBBxGWKe+
         u6M3Ujws45Zbd1gb6NJqqfqnr+Bvh/nvu1W7qlsG+XgegbZtEC/Xye8x1tF0iPGWW2kS
         kzSg==
X-Gm-Message-State: APjAAAVDTaN+w40Ljh00PsGadTLKyEL6BpBTt7akjIyZgTK2kvXbv1bd
        tvg0/YrNxKgPzKV/A/YXlwvPE5dEitGKgw==
X-Google-Smtp-Source: APXvYqwIQMEFnvBF9QGTXjTO6JHkvJyZeQ+vQaPxXirruWegwz8yZOhieeUfMZ+TsNUgL7Uyb+GyqX3hwvB33g==
X-Received: by 2002:a63:81:: with SMTP id 123mr13901969pga.47.1573238091196;
 Fri, 08 Nov 2019 10:34:51 -0800 (PST)
Date:   Fri,  8 Nov 2019 10:34:47 -0800
Message-Id: <20191108183447.16085-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH net-next] net: icmp: fix data-race in cmp_global_allow()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This code reads two global variables without protection
of a lock. We need READ_ONCE()/WRITE_ONCE() pairs to
avoid load/store-tearing and better document the intent.

KCSAN reported :
BUG: KCSAN: data-race in icmp_global_allow / icmp_global_allow

read to 0xffffffff861a8014 of 4 bytes by task 11201 on cpu 0:
 icmp_global_allow+0x36/0x1b0 net/ipv4/icmp.c:254
 icmpv6_global_allow net/ipv6/icmp.c:184 [inline]
 icmpv6_global_allow net/ipv6/icmp.c:179 [inline]
 icmp6_send+0x493/0x1140 net/ipv6/icmp.c:514
 icmpv6_send+0x71/0xb0 net/ipv6/ip6_icmp.c:43
 ip6_link_failure+0x43/0x180 net/ipv6/route.c:2640
 dst_link_failure include/net/dst.h:419 [inline]
 vti_xmit net/ipv4/ip_vti.c:243 [inline]
 vti_tunnel_xmit+0x27f/0xa50 net/ipv4/ip_vti.c:279
 __netdev_start_xmit include/linux/netdevice.h:4420 [inline]
 netdev_start_xmit include/linux/netdevice.h:4434 [inline]
 xmit_one net/core/dev.c:3280 [inline]
 dev_hard_start_xmit+0xef/0x430 net/core/dev.c:3296
 __dev_queue_xmit+0x14c9/0x1b60 net/core/dev.c:3873
 dev_queue_xmit+0x21/0x30 net/core/dev.c:3906
 neigh_direct_output+0x1f/0x30 net/core/neighbour.c:1530
 neigh_output include/net/neighbour.h:511 [inline]
 ip6_finish_output2+0x7a6/0xec0 net/ipv6/ip6_output.c:116
 __ip6_finish_output net/ipv6/ip6_output.c:142 [inline]
 __ip6_finish_output+0x2d7/0x330 net/ipv6/ip6_output.c:127
 ip6_finish_output+0x41/0x160 net/ipv6/ip6_output.c:152
 NF_HOOK_COND include/linux/netfilter.h:294 [inline]
 ip6_output+0xf2/0x280 net/ipv6/ip6_output.c:175
 dst_output include/net/dst.h:436 [inline]
 ip6_local_out+0x74/0x90 net/ipv6/output_core.c:179

write to 0xffffffff861a8014 of 4 bytes by task 11183 on cpu 1:
 icmp_global_allow+0x174/0x1b0 net/ipv4/icmp.c:272
 icmpv6_global_allow net/ipv6/icmp.c:184 [inline]
 icmpv6_global_allow net/ipv6/icmp.c:179 [inline]
 icmp6_send+0x493/0x1140 net/ipv6/icmp.c:514
 icmpv6_send+0x71/0xb0 net/ipv6/ip6_icmp.c:43
 ip6_link_failure+0x43/0x180 net/ipv6/route.c:2640
 dst_link_failure include/net/dst.h:419 [inline]
 vti_xmit net/ipv4/ip_vti.c:243 [inline]
 vti_tunnel_xmit+0x27f/0xa50 net/ipv4/ip_vti.c:279
 __netdev_start_xmit include/linux/netdevice.h:4420 [inline]
 netdev_start_xmit include/linux/netdevice.h:4434 [inline]
 xmit_one net/core/dev.c:3280 [inline]
 dev_hard_start_xmit+0xef/0x430 net/core/dev.c:3296
 __dev_queue_xmit+0x14c9/0x1b60 net/core/dev.c:3873
 dev_queue_xmit+0x21/0x30 net/core/dev.c:3906
 neigh_direct_output+0x1f/0x30 net/core/neighbour.c:1530
 neigh_output include/net/neighbour.h:511 [inline]
 ip6_finish_output2+0x7a6/0xec0 net/ipv6/ip6_output.c:116
 __ip6_finish_output net/ipv6/ip6_output.c:142 [inline]
 __ip6_finish_output+0x2d7/0x330 net/ipv6/ip6_output.c:127
 ip6_finish_output+0x41/0x160 net/ipv6/ip6_output.c:152
 NF_HOOK_COND include/linux/netfilter.h:294 [inline]
 ip6_output+0xf2/0x280 net/ipv6/ip6_output.c:175

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 11183 Comm: syz-executor.2 Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 4cdf507d5452 ("icmp: add a global rate limitation")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv4/icmp.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index a72fbdf1fb85ccb7359229a7b9bbed0c6a67edf4..18068ed42f258349a07248a85acdf93b8c2f1749 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -249,10 +249,11 @@ bool icmp_global_allow(void)
 	bool rc = false;
 
 	/* Check if token bucket is empty and cannot be refilled
-	 * without taking the spinlock.
+	 * without taking the spinlock. The READ_ONCE() are paired
+	 * with the following WRITE_ONCE() in this same function.
 	 */
-	if (!icmp_global.credit) {
-		delta = min_t(u32, now - icmp_global.stamp, HZ);
+	if (!READ_ONCE(icmp_global.credit)) {
+		delta = min_t(u32, now - READ_ONCE(icmp_global.stamp), HZ);
 		if (delta < HZ / 50)
 			return false;
 	}
@@ -262,14 +263,14 @@ bool icmp_global_allow(void)
 	if (delta >= HZ / 50) {
 		incr = sysctl_icmp_msgs_per_sec * delta / HZ ;
 		if (incr)
-			icmp_global.stamp = now;
+			WRITE_ONCE(icmp_global.stamp, now);
 	}
 	credit = min_t(u32, icmp_global.credit + incr, sysctl_icmp_msgs_burst);
 	if (credit) {
 		credit--;
 		rc = true;
 	}
-	icmp_global.credit = credit;
+	WRITE_ONCE(icmp_global.credit, credit);
 	spin_unlock(&icmp_global.lock);
 	return rc;
 }
-- 
2.24.0.432.g9d3f5f5b63-goog

