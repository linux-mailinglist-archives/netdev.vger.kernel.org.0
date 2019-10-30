Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B59E2EA482
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 21:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfJ3UAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 16:00:09 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:57314 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbfJ3UAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 16:00:08 -0400
Received: by mail-pf1-f201.google.com with SMTP id v11so2535307pfm.23
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 13:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=rzMd9jqubAJbDJ6CUOPIPUJp5SvM8POe2jbzapzCQW0=;
        b=oiNkVjvuv1SGyL5d3i+iXRLnOyGf+38mcXaL7RkWYkQOjwdSLjMNTbttJdyR+Bj7S/
         VxObXjjksbRlaMA+eI97+sQ+kly1pL5folKk2Rb7wbccPmw2i++j7sfwP0/1BepiOv0R
         uyW8C9RGGZJKxaA+16U46FBu8mdQU52c2o3csAjpk08Wid9D2MQ40B+uVjADCEkGdclz
         4S3uyxW9pmIGBOjEfevvSNDmARfhJUdt8rjPXaWJvSotTzjPDamj7SeO44asduUfARD4
         7de7X/s98LJ2Fd2/9gVmLJMFcd5+zpv+zrOayiV5+0Ou2sNJxibHi+rKaXu6jCGmWPG9
         iCAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=rzMd9jqubAJbDJ6CUOPIPUJp5SvM8POe2jbzapzCQW0=;
        b=s2e1BGggzS4lAAgA1XoZSZUekZT+kT3zEEbreI5JUMcSjbId9aQ1teeltAZuqE5tzu
         7MdHe+O1QV0Y2RFkyq6Ro9pXMa6bZCM+YT+d0GqV7BaX1VHGAxlsJEwMt1JSQA3RzCLT
         Yq+K2Imps6XLbCp6mqOLNa5mwkbjY5sAruPjeiSqL9S1CpytrfG15nmJZQxkSLBCBxxv
         Yvh1rMGLXycPhE8jjPxa9XM4Dlsk0GwRYh9aGRdX2UFe+aVJj+rbKdaC5XaL/26qLtGu
         S0kN2hlXb3UHoYg+3BZRjQgIvxAyXNqdLtQONsJrv+fKfBWn8B06x5zwvO9Ryo9NFIR5
         HPTg==
X-Gm-Message-State: APjAAAVn4b8kF2x7LiZpiZLiAK01bM12xfbWO+DU5OpJD/YJOaZY5Yug
        SJAEILwl/OHWc+0DiVjdemk+7Y9rVP7mJg==
X-Google-Smtp-Source: APXvYqxFtPphNu8MXScbA3tcneYeQic6Az2smhg+iB1x9ra1QOeE5ivJ4LVqYEUUOU7K0vcpGG3IFIz4uH9GnQ==
X-Received: by 2002:a63:3603:: with SMTP id d3mr1407167pga.208.1572465607696;
 Wed, 30 Oct 2019 13:00:07 -0700 (PDT)
Date:   Wed, 30 Oct 2019 13:00:04 -0700
Message-Id: <20191030200004.234357-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH net] net: annotate accesses to sk->sk_incoming_cpu
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

This socket field can be read and written by concurrent cpus.

Use READ_ONCE() and WRITE_ONCE() annotations to document this,
and avoid some compiler 'optimizations'.

KCSAN reported :

BUG: KCSAN: data-race in tcp_v4_rcv / tcp_v4_rcv

write to 0xffff88812220763c of 4 bytes by interrupt on cpu 0:
 sk_incoming_cpu_update include/net/sock.h:953 [inline]
 tcp_v4_rcv+0x1b3c/0x1bb0 net/ipv4/tcp_ipv4.c:1934
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
 napi_poll net/core/dev.c:6392 [inline]
 net_rx_action+0x3ae/0xa90 net/core/dev.c:6460
 __do_softirq+0x115/0x33f kernel/softirq.c:292
 do_softirq_own_stack+0x2a/0x40 arch/x86/entry/entry_64.S:1082
 do_softirq.part.0+0x6b/0x80 kernel/softirq.c:337
 do_softirq kernel/softirq.c:329 [inline]
 __local_bh_enable_ip+0x76/0x80 kernel/softirq.c:189

read to 0xffff88812220763c of 4 bytes by interrupt on cpu 1:
 sk_incoming_cpu_update include/net/sock.h:952 [inline]
 tcp_v4_rcv+0x181a/0x1bb0 net/ipv4/tcp_ipv4.c:1934
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
 napi_poll net/core/dev.c:6392 [inline]
 net_rx_action+0x3ae/0xa90 net/core/dev.c:6460
 __do_softirq+0x115/0x33f kernel/softirq.c:292
 run_ksoftirqd+0x46/0x60 kernel/softirq.c:603
 smpboot_thread_fn+0x37d/0x4a0 kernel/smpboot.c:165

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 16 Comm: ksoftirqd/1 Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 include/net/sock.h          | 4 ++--
 net/core/sock.c             | 4 ++--
 net/ipv4/inet_hashtables.c  | 2 +-
 net/ipv4/udp.c              | 2 +-
 net/ipv6/inet6_hashtables.c | 2 +-
 net/ipv6/udp.c              | 2 +-
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index c31a9ed86d5a58be7f1ca9933c48c40f12d0e57f..8f9adcfac41bea7e46062851a25c042261323679 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -954,8 +954,8 @@ static inline void sk_incoming_cpu_update(struct sock *sk)
 {
 	int cpu = raw_smp_processor_id();
 
-	if (unlikely(sk->sk_incoming_cpu != cpu))
-		sk->sk_incoming_cpu = cpu;
+	if (unlikely(READ_ONCE(sk->sk_incoming_cpu) != cpu))
+		WRITE_ONCE(sk->sk_incoming_cpu, cpu);
 }
 
 static inline void sock_rps_record_flow_hash(__u32 hash)
diff --git a/net/core/sock.c b/net/core/sock.c
index b8e758bcb6ad65c93e93fb64f70a61e353a5737e..ac78a570e43add1ce263841212b3759dbbfd8eae 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1127,7 +1127,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		break;
 		}
 	case SO_INCOMING_CPU:
-		sk->sk_incoming_cpu = val;
+		WRITE_ONCE(sk->sk_incoming_cpu, val);
 		break;
 
 	case SO_CNX_ADVICE:
@@ -1476,7 +1476,7 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case SO_INCOMING_CPU:
-		v.val = sk->sk_incoming_cpu;
+		v.val = READ_ONCE(sk->sk_incoming_cpu);
 		break;
 
 	case SO_MEMINFO:
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 97824864e40d13bac71510920ae125c6a89fef1d..83fb00153018f16678e71695134f7ae4d30ee0a3 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -240,7 +240,7 @@ static inline int compute_score(struct sock *sk, struct net *net,
 			return -1;
 
 		score = sk->sk_family == PF_INET ? 2 : 1;
-		if (sk->sk_incoming_cpu == raw_smp_processor_id())
+		if (READ_ONCE(sk->sk_incoming_cpu) == raw_smp_processor_id())
 			score++;
 	}
 	return score;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index d1ed160af202c054839387201abd3f13b55d00e9..1d58ce829dcae476a7a32a6ab5fa8bb91ec8ae67 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -388,7 +388,7 @@ static int compute_score(struct sock *sk, struct net *net,
 		return -1;
 	score += 4;
 
-	if (sk->sk_incoming_cpu == raw_smp_processor_id())
+	if (READ_ONCE(sk->sk_incoming_cpu) == raw_smp_processor_id())
 		score++;
 	return score;
 }
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index cf60fae9533b230455d89007a9ac45af958f2efe..fbe9d4295eac38d247aca362d6006cdec2d7f7da 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -105,7 +105,7 @@ static inline int compute_score(struct sock *sk, struct net *net,
 			return -1;
 
 		score = 1;
-		if (sk->sk_incoming_cpu == raw_smp_processor_id())
+		if (READ_ONCE(sk->sk_incoming_cpu) == raw_smp_processor_id())
 			score++;
 	}
 	return score;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 6324d3a8cb53dd76ea0deaf4358e33e529ce56ec..9fec580c968e0d331fcaf54289364526ebd902c2 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -135,7 +135,7 @@ static int compute_score(struct sock *sk, struct net *net,
 		return -1;
 	score++;
 
-	if (sk->sk_incoming_cpu == raw_smp_processor_id())
+	if (READ_ONCE(sk->sk_incoming_cpu) == raw_smp_processor_id())
 		score++;
 
 	return score;
-- 
2.24.0.rc0.303.g954a862665-goog

