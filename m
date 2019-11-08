Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2590F4CA8
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 14:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727659AbfKHNHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 08:07:52 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:36470 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfKHNHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 08:07:51 -0500
Received: by mail-pg1-f202.google.com with SMTP id h12so4751779pgd.3
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 05:07:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=EZOwXJW4ARX5jySHqItE1eMZvjNmNcFHRLOoO3CUzPQ=;
        b=FIELr9AH1pO/KcQ1r3XbmttJBWJ0o5F0ZpPqtQRhf+N/041bSpeSxT+lLzJqgLK9Vw
         w6hVGBCrC7EkFD2Cb0pE0OFitgYCMY1eIWzJkhbkicB1aTfMdcZD9zl29G9QYqEd85Yn
         ZYvfIechaeSU+ArXzz43G9w61tlJK8/c2Sah9JzcgQDpTrKwhYGK8T0SAET42amKUSY0
         7wk8wWjYRTVlen1qPQ5opPoeZtcMa0sjOSnv5hS7S2IvvRmXFlTx5qiOQ4IN49digH3h
         RpyTucu6tt6XxdR4hmh31WA3S13OLYE6GKcjxudnA3545cz0yRkCBRSRc3iUwHEJO0bM
         hb8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=EZOwXJW4ARX5jySHqItE1eMZvjNmNcFHRLOoO3CUzPQ=;
        b=lxGXFLi7OgNVrKYsweOo5zABl9ESx7lNQzI9NxMi085taCnjSPmXcKAHtgnTo9DwIx
         iXX6OYKUPglk1i8liHaP9uqak4Ztq7ukFRgOQ2jkR0tysIVEmmAE1039xnExlDFE4FRK
         3w7hcodE+TmyOtjDJFooQ8Uv+qJee/++R+NLxRNAssfDSjRA4GBL9Vs888VxgxnEumru
         St+nBZB2bc/WqEcejAUNGYmQPno1KocvRB0ITZWK9Ozr859Z5jUemZUN8hs+jbUb4FNX
         mp+iwzh/omRFEmccEmwoRak0Xa97ZnPhsTUZTs/zYhDJAAd5+NzXqpoYxR64dDich/fK
         k2Iw==
X-Gm-Message-State: APjAAAX48OswmfKV/MkWVlNa8uF2cpNbd3q3F6jIRru5NeOq9sXomGkQ
        7l/WEB2Kw7HhKlNmjl3lq3q6uPtJlwXhVw==
X-Google-Smtp-Source: APXvYqxFLr0q8Jb4BhMKUR2XSGBF0IbFonj6DvgUi5vK/DbBBWIDt6YxJs9DOlN1TZa1bTXK/uXL2MdPSk7Dcw==
X-Received: by 2002:a63:3847:: with SMTP id h7mr12189675pgn.364.1573218470040;
 Fri, 08 Nov 2019 05:07:50 -0800 (PST)
Date:   Fri,  8 Nov 2019 05:07:46 -0800
Message-Id: <20191108130746.172131-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH net-next] packet: fix data-race in fanout_flow_is_huge()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

KCSAN reported the following data-race [1]

Adding a couple of READ_ONCE()/WRITE_ONCE() should silence it.

Since the report hinted about multiple cpus using the history
concurrently, I added a test avoiding writing on it if the
victim slot already contains the desired value.

[1]

BUG: KCSAN: data-race in fanout_demux_rollover / fanout_demux_rollover

read to 0xffff8880b01786cc of 4 bytes by task 18921 on cpu 1:
 fanout_flow_is_huge net/packet/af_packet.c:1303 [inline]
 fanout_demux_rollover+0x33e/0x3f0 net/packet/af_packet.c:1353
 packet_rcv_fanout+0x34e/0x490 net/packet/af_packet.c:1453
 deliver_skb net/core/dev.c:1888 [inline]
 dev_queue_xmit_nit+0x15b/0x540 net/core/dev.c:1958
 xmit_one net/core/dev.c:3195 [inline]
 dev_hard_start_xmit+0x3f5/0x430 net/core/dev.c:3215
 __dev_queue_xmit+0x14ab/0x1b40 net/core/dev.c:3792
 dev_queue_xmit+0x21/0x30 net/core/dev.c:3825
 neigh_direct_output+0x1f/0x30 net/core/neighbour.c:1530
 neigh_output include/net/neighbour.h:511 [inline]
 ip6_finish_output2+0x7a2/0xec0 net/ipv6/ip6_output.c:116
 __ip6_finish_output net/ipv6/ip6_output.c:142 [inline]
 __ip6_finish_output+0x2d7/0x330 net/ipv6/ip6_output.c:127
 ip6_finish_output+0x41/0x160 net/ipv6/ip6_output.c:152
 NF_HOOK_COND include/linux/netfilter.h:294 [inline]
 ip6_output+0xf2/0x280 net/ipv6/ip6_output.c:175
 dst_output include/net/dst.h:436 [inline]
 ip6_local_out+0x74/0x90 net/ipv6/output_core.c:179
 ip6_send_skb+0x53/0x110 net/ipv6/ip6_output.c:1795
 udp_v6_send_skb.isra.0+0x3ec/0xa70 net/ipv6/udp.c:1173
 udpv6_sendmsg+0x1906/0x1c20 net/ipv6/udp.c:1471
 inet6_sendmsg+0x6d/0x90 net/ipv6/af_inet6.c:576
 sock_sendmsg_nosec net/socket.c:637 [inline]
 sock_sendmsg+0x9f/0xc0 net/socket.c:657
 ___sys_sendmsg+0x2b7/0x5d0 net/socket.c:2311
 __sys_sendmmsg+0x123/0x350 net/socket.c:2413
 __do_sys_sendmmsg net/socket.c:2442 [inline]
 __se_sys_sendmmsg net/socket.c:2439 [inline]
 __x64_sys_sendmmsg+0x64/0x80 net/socket.c:2439
 do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

write to 0xffff8880b01786cc of 4 bytes by task 18922 on cpu 0:
 fanout_flow_is_huge net/packet/af_packet.c:1306 [inline]
 fanout_demux_rollover+0x3a4/0x3f0 net/packet/af_packet.c:1353
 packet_rcv_fanout+0x34e/0x490 net/packet/af_packet.c:1453
 deliver_skb net/core/dev.c:1888 [inline]
 dev_queue_xmit_nit+0x15b/0x540 net/core/dev.c:1958
 xmit_one net/core/dev.c:3195 [inline]
 dev_hard_start_xmit+0x3f5/0x430 net/core/dev.c:3215
 __dev_queue_xmit+0x14ab/0x1b40 net/core/dev.c:3792
 dev_queue_xmit+0x21/0x30 net/core/dev.c:3825
 neigh_direct_output+0x1f/0x30 net/core/neighbour.c:1530
 neigh_output include/net/neighbour.h:511 [inline]
 ip6_finish_output2+0x7a2/0xec0 net/ipv6/ip6_output.c:116
 __ip6_finish_output net/ipv6/ip6_output.c:142 [inline]
 __ip6_finish_output+0x2d7/0x330 net/ipv6/ip6_output.c:127
 ip6_finish_output+0x41/0x160 net/ipv6/ip6_output.c:152
 NF_HOOK_COND include/linux/netfilter.h:294 [inline]
 ip6_output+0xf2/0x280 net/ipv6/ip6_output.c:175
 dst_output include/net/dst.h:436 [inline]
 ip6_local_out+0x74/0x90 net/ipv6/output_core.c:179
 ip6_send_skb+0x53/0x110 net/ipv6/ip6_output.c:1795
 udp_v6_send_skb.isra.0+0x3ec/0xa70 net/ipv6/udp.c:1173
 udpv6_sendmsg+0x1906/0x1c20 net/ipv6/udp.c:1471
 inet6_sendmsg+0x6d/0x90 net/ipv6/af_inet6.c:576
 sock_sendmsg_nosec net/socket.c:637 [inline]
 sock_sendmsg+0x9f/0xc0 net/socket.c:657
 ___sys_sendmsg+0x2b7/0x5d0 net/socket.c:2311
 __sys_sendmmsg+0x123/0x350 net/socket.c:2413
 __do_sys_sendmmsg net/socket.c:2442 [inline]
 __se_sys_sendmmsg net/socket.c:2439 [inline]
 __x64_sys_sendmmsg+0x64/0x80 net/socket.c:2439
 do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 18922 Comm: syz-executor.3 Not tainted 5.4.0-rc6+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 3b3a5b0aab5b ("packet: rollover huge flows before small flows")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
---
 net/packet/af_packet.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 82a50e850245ec56d258687f8f2dcdd411603df6..53c1d41fb1c98219be5667214a6c05fb674c887d 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1295,15 +1295,21 @@ static void packet_sock_destruct(struct sock *sk)
 
 static bool fanout_flow_is_huge(struct packet_sock *po, struct sk_buff *skb)
 {
-	u32 rxhash;
+	u32 *history = po->rollover->history;
+	u32 victim, rxhash;
 	int i, count = 0;
 
 	rxhash = skb_get_hash(skb);
 	for (i = 0; i < ROLLOVER_HLEN; i++)
-		if (po->rollover->history[i] == rxhash)
+		if (READ_ONCE(history[i]) == rxhash)
 			count++;
 
-	po->rollover->history[prandom_u32() % ROLLOVER_HLEN] = rxhash;
+	victim = prandom_u32() % ROLLOVER_HLEN;
+
+	/* Avoid dirtying the cache line if possible */
+	if (READ_ONCE(history[victim]) != rxhash)
+		WRITE_ONCE(history[victim], rxhash);
+
 	return count > (ROLLOVER_HLEN >> 1);
 }
 
-- 
2.24.0.432.g9d3f5f5b63-goog

