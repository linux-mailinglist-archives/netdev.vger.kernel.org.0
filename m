Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE50F3EB6
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 05:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729443AbfKHEIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 23:08:23 -0500
Received: from mail-yb1-f201.google.com ([209.85.219.201]:44357 "EHLO
        mail-yb1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729641AbfKHEIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 23:08:23 -0500
Received: by mail-yb1-f201.google.com with SMTP id 63so3894744ybv.11
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 20:08:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=lm+XHYVFulxIN4eYqVUzaa8YkbE181nEoYdhPg41czI=;
        b=nocGgv7k8Vid13U0s9Ej/4YwLTBEA6UJO7wpWxkv6dTT3BcGO/XeHpiHLWQOm4ictg
         HBz1g8Li4qiXz5sXzJUOHr2JdDGQhSIsHcLifhStNgd3HC2PUbnNOaEYew6Mx2mLUHS+
         rRewEZmHqn1WogQyNcMv72GY+rXUODWrrPannmB5fuoYqbsu4QTQncKgpPF6ZRsOlUfj
         HiRca48UgOOrDgceGbfylyo1L4ggfLfgEhfsX2KyjhQTqG9XwaysI1pE7ovuYB77hp4d
         1TiyjtqLL79YBU9b0L1SBpzALm8i+EgBz0HlAjuiEva+UUcIMk/u7pSShmxxiLAsUaCI
         3MPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=lm+XHYVFulxIN4eYqVUzaa8YkbE181nEoYdhPg41czI=;
        b=koR3uI9tcf9/XGJb9ym/w0xVW4T0EuQAC1DJb8K1cfVcGwO+0J0URjCstxz12RFs7U
         iJLvVwREbglwXpfPGqLzprpTbF9F/qFtu/xiHFe/PNiO8ZotkaspoztE4J6vmBos49Gd
         bcij6CDgLq1/f0QqqDlFm9BfcWpGwNHF/Df/xWMu8fe9OwMXr6dduIWiIXxXCc/yBACv
         6AvngUInhMCc5z0i8o7PnaMWzv/jEvWDIxFYYmcxISHTqInFYceQDTwJltOWDxRYbsTT
         nMAkdiK5JqrM7oCNAFSGmDC061Jy1zwdzYqULy0RZ4DWBiHX1vw66XRUpJCUDyyd6TPZ
         G6wQ==
X-Gm-Message-State: APjAAAX10a+0taLwn/8WkQc3d1zaHFzd4jr/01Rp6qLbyZdtR/nhazNp
        r/kTTeUTJaH7E+ObmroqKbjq1e9Fvor6NA==
X-Google-Smtp-Source: APXvYqw37z8xuYsYnVSlgwhq0p+uk0kvj7HSa4G+vD1dlKhQeD4g/QI1TEJ/gXJcPQGOjX3MQjlSGUQ3di1a4Q==
X-Received: by 2002:a0d:df48:: with SMTP id i69mr5443805ywe.4.1573186102229;
 Thu, 07 Nov 2019 20:08:22 -0800 (PST)
Date:   Thu,  7 Nov 2019 20:08:19 -0800
Message-Id: <20191108040819.85664-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH net] net: fix data-race in neigh_event_send()
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

KCSAN reported the following data-race [1]

The fix will also prevent the compiler from optimizing out
the condition.

[1]

BUG: KCSAN: data-race in neigh_resolve_output / neigh_resolve_output

write to 0xffff8880a41dba78 of 8 bytes by interrupt on cpu 1:
 neigh_event_send include/net/neighbour.h:443 [inline]
 neigh_resolve_output+0x78/0x480 net/core/neighbour.c:1474
 neigh_output include/net/neighbour.h:511 [inline]
 ip_finish_output2+0x4af/0xe40 net/ipv4/ip_output.c:228
 __ip_finish_output net/ipv4/ip_output.c:308 [inline]
 __ip_finish_output+0x23a/0x490 net/ipv4/ip_output.c:290
 ip_finish_output+0x41/0x160 net/ipv4/ip_output.c:318
 NF_HOOK_COND include/linux/netfilter.h:294 [inline]
 ip_output+0xdf/0x210 net/ipv4/ip_output.c:432
 dst_output include/net/dst.h:436 [inline]
 ip_local_out+0x74/0x90 net/ipv4/ip_output.c:125
 __ip_queue_xmit+0x3a8/0xa40 net/ipv4/ip_output.c:532
 ip_queue_xmit+0x45/0x60 include/net/ip.h:237
 __tcp_transmit_skb+0xe81/0x1d60 net/ipv4/tcp_output.c:1169
 tcp_transmit_skb net/ipv4/tcp_output.c:1185 [inline]
 __tcp_retransmit_skb+0x4bd/0x15f0 net/ipv4/tcp_output.c:2976
 tcp_retransmit_skb+0x36/0x1a0 net/ipv4/tcp_output.c:2999
 tcp_retransmit_timer+0x719/0x16d0 net/ipv4/tcp_timer.c:515
 tcp_write_timer_handler+0x42d/0x510 net/ipv4/tcp_timer.c:598
 tcp_write_timer+0xd1/0xf0 net/ipv4/tcp_timer.c:618

read to 0xffff8880a41dba78 of 8 bytes by interrupt on cpu 0:
 neigh_event_send include/net/neighbour.h:442 [inline]
 neigh_resolve_output+0x57/0x480 net/core/neighbour.c:1474
 neigh_output include/net/neighbour.h:511 [inline]
 ip_finish_output2+0x4af/0xe40 net/ipv4/ip_output.c:228
 __ip_finish_output net/ipv4/ip_output.c:308 [inline]
 __ip_finish_output+0x23a/0x490 net/ipv4/ip_output.c:290
 ip_finish_output+0x41/0x160 net/ipv4/ip_output.c:318
 NF_HOOK_COND include/linux/netfilter.h:294 [inline]
 ip_output+0xdf/0x210 net/ipv4/ip_output.c:432
 dst_output include/net/dst.h:436 [inline]
 ip_local_out+0x74/0x90 net/ipv4/ip_output.c:125
 __ip_queue_xmit+0x3a8/0xa40 net/ipv4/ip_output.c:532
 ip_queue_xmit+0x45/0x60 include/net/ip.h:237
 __tcp_transmit_skb+0xe81/0x1d60 net/ipv4/tcp_output.c:1169
 tcp_transmit_skb net/ipv4/tcp_output.c:1185 [inline]
 __tcp_retransmit_skb+0x4bd/0x15f0 net/ipv4/tcp_output.c:2976
 tcp_retransmit_skb+0x36/0x1a0 net/ipv4/tcp_output.c:2999
 tcp_retransmit_timer+0x719/0x16d0 net/ipv4/tcp_timer.c:515
 tcp_write_timer_handler+0x42d/0x510 net/ipv4/tcp_timer.c:598

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 include/net/neighbour.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 6a86e49181db0f47cf8188ccf92fc7bd0553a4be..6ad9ad47a9c54bfbd1772f404f4ae81bf9cc6dd3 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -439,8 +439,8 @@ static inline int neigh_event_send(struct neighbour *neigh, struct sk_buff *skb)
 {
 	unsigned long now = jiffies;
 	
-	if (neigh->used != now)
-		neigh->used = now;
+	if (READ_ONCE(neigh->used) != now)
+		WRITE_ONCE(neigh->used, now);
 	if (!(neigh->nud_state&(NUD_CONNECTED|NUD_DELAY|NUD_PROBE)))
 		return __neigh_event_send(neigh, skb);
 	return 0;
-- 
2.24.0.432.g9d3f5f5b63-goog

