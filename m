Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73BCAE2A0E
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 07:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407045AbfJXFpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 01:45:04 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:42175 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407031AbfJXFpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 01:45:04 -0400
Received: by mail-pl1-f201.google.com with SMTP id c21so11304647plz.9
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 22:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=m8VXTyMGW090ZZQAjsN0J4kvxsKRd8oUWpIOWfQhqMA=;
        b=YjzXVJY+klJYhxPoHz79lWDqZgPwkqCs2OKbgs7Ho2nTmFLHNKSaKR8AUL9e+quz7e
         n+94v7Iv3ot8cMTWJF3/tMIISDu58gwgFqh2Ss0RHEXnnvXQcGwgo8V+/HaACsr143p/
         pJMRE694AF2T8hVqtP+/M/FAgEV4MX79YIITOcg8p5rAGsi5FRRIbI5+uw2iLgkR7cfL
         GvgR+3qXHYVyQncr5JdZc6LERE3GWNS2XYPKef0DQm8LeL0X3ShURQUVicGrt40kyW8F
         jAs2zu8cYrbLzqnZSgIpanDcCIOb4eF69Zm4o16zqfeHMi1AYgWanHYKgIjtXDbKKFtB
         u6Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=m8VXTyMGW090ZZQAjsN0J4kvxsKRd8oUWpIOWfQhqMA=;
        b=LDVKHcjmhk0h5ZSy/iQw6ugjtbSPR662uj6RkjixV7EBR2qG/ZlQgn7qxRvefKRfC1
         KkWPqjwCTAjryqGBxJkv3s8hfJe2ctU3mp+zbLqiFEVdy35uWjcQgJIENcpLJ8eoF5FO
         9UABaQmAd7JYwLcvw8DFHIlIQAK6y+IpwIjmpE5WQ8+NpSsParnwbzWGxfzphiAPAJfG
         BFRjzBgWjgKuab5rkWUmhTjutZmaQFIbT8cAyJouEaRPQSwoP5FNemkHwOJhNa1hh8Q3
         JWPJqOO7eBfaOyfTF8DbeeZASbPN5D1gKRJXGQnQoe4UBZyCwRVep83W1MqZCXoicEAO
         s76A==
X-Gm-Message-State: APjAAAUvTXYRRLUjUl4ufA/fnCN9egTjzuZIpVXCWqlMDgedIMZb4vm9
        gPJ3UHdZtJhi32rB8Jf+fymkT3Yi9RQV/A==
X-Google-Smtp-Source: APXvYqw3LptO4n49jezReX+OYT8aBH7QIioQigLmsfL/5Hi3s9ca++VwZm8Agp2zPLRRlUiDvn7BuHxbY879Tw==
X-Received: by 2002:a63:6f02:: with SMTP id k2mr112537pgc.163.1571895901821;
 Wed, 23 Oct 2019 22:45:01 -0700 (PDT)
Date:   Wed, 23 Oct 2019 22:44:49 -0700
In-Reply-To: <20191024054452.81661-1-edumazet@google.com>
Message-Id: <20191024054452.81661-3-edumazet@google.com>
Mime-Version: 1.0
References: <20191024054452.81661-1-edumazet@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH net 2/5] udp: use skb_queue_empty_lockless()
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

syzbot reported a data-race [1].

We should use skb_queue_empty_lockless() to document that we are
not ensuring a mutual exclusion and silence KCSAN.

[1]
BUG: KCSAN: data-race in __skb_recv_udp / __udp_enqueue_schedule_skb

write to 0xffff888122474b50 of 8 bytes by interrupt on cpu 0:
 __skb_insert include/linux/skbuff.h:1852 [inline]
 __skb_queue_before include/linux/skbuff.h:1958 [inline]
 __skb_queue_tail include/linux/skbuff.h:1991 [inline]
 __udp_enqueue_schedule_skb+0x2c1/0x410 net/ipv4/udp.c:1470
 __udp_queue_rcv_skb net/ipv4/udp.c:1940 [inline]
 udp_queue_rcv_one_skb+0x7bd/0xc70 net/ipv4/udp.c:2057
 udp_queue_rcv_skb+0xb5/0x400 net/ipv4/udp.c:2074
 udp_unicast_rcv_skb.isra.0+0x7e/0x1c0 net/ipv4/udp.c:2233
 __udp4_lib_rcv+0xa44/0x17c0 net/ipv4/udp.c:2300
 udp_rcv+0x2b/0x40 net/ipv4/udp.c:2470
 ip_protocol_deliver_rcu+0x4d/0x420 net/ipv4/ip_input.c:204
 ip_local_deliver_finish+0x110/0x140 net/ipv4/ip_input.c:231
 NF_HOOK include/linux/netfilter.h:305 [inline]
 NF_HOOK include/linux/netfilter.h:299 [inline]
 ip_local_deliver+0x133/0x210 net/ipv4/ip_input.c:252
 dst_input include/net/dst.h:442 [inline]
 ip_rcv_finish+0x121/0x160 net/ipv4/ip_input.c:413
 NF_HOOK include/linux/netfilter.h:305 [inline]
 NF_HOOK include/linux/netfilter.h:299 [inline]
 ip_rcv+0x18f/0x1a0 net/ipv4/ip_input.c:523
 __netif_receive_skb_one_core+0xa7/0xe0 net/core/dev.c:5010
 __netif_receive_skb+0x37/0xf0 net/core/dev.c:5124
 process_backlog+0x1d3/0x420 net/core/dev.c:5955

read to 0xffff888122474b50 of 8 bytes by task 8921 on cpu 1:
 skb_queue_empty include/linux/skbuff.h:1494 [inline]
 __skb_recv_udp+0x18d/0x500 net/ipv4/udp.c:1653
 udp_recvmsg+0xe1/0xb10 net/ipv4/udp.c:1712
 inet_recvmsg+0xbb/0x250 net/ipv4/af_inet.c:838
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
CPU: 1 PID: 8921 Comm: syz-executor.4 Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv4/udp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 14bc654b6842003b325efe268041749c6770947f..2cc259736c2e0d10f16dcd5333925e2a369843b9 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1577,7 +1577,7 @@ static int first_packet_length(struct sock *sk)
 
 	spin_lock_bh(&rcvq->lock);
 	skb = __first_packet_length(sk, rcvq, &total);
-	if (!skb && !skb_queue_empty(sk_queue)) {
+	if (!skb && !skb_queue_empty_lockless(sk_queue)) {
 		spin_lock(&sk_queue->lock);
 		skb_queue_splice_tail_init(sk_queue, rcvq);
 		spin_unlock(&sk_queue->lock);
@@ -1650,7 +1650,7 @@ struct sk_buff *__skb_recv_udp(struct sock *sk, unsigned int flags,
 				return skb;
 			}
 
-			if (skb_queue_empty(sk_queue)) {
+			if (skb_queue_empty_lockless(sk_queue)) {
 				spin_unlock_bh(&queue->lock);
 				goto busy_check;
 			}
@@ -1676,7 +1676,7 @@ struct sk_buff *__skb_recv_udp(struct sock *sk, unsigned int flags,
 				break;
 
 			sk_busy_loop(sk, flags & MSG_DONTWAIT);
-		} while (!skb_queue_empty(sk_queue));
+		} while (!skb_queue_empty_lockless(sk_queue));
 
 		/* sk_queue is empty, reader_queue may contain peeked packets */
 	} while (timeo &&
-- 
2.23.0.866.gb869b98d4c-goog

