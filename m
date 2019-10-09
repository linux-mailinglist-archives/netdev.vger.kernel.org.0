Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64A3ED1BFB
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 00:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732412AbfJIWlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 18:41:07 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:37591 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730815AbfJIWlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 18:41:07 -0400
Received: by mail-pl1-f202.google.com with SMTP id p15so2432558plq.4
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 15:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=fjR2qy7ed811wyEm7oWElU90Pdhry8ybjRIcT5EV/AI=;
        b=cRvVPUZRfZjSftCD4Pu44kWfQMCbWAPWMAjUy/vt217Qe47kBL2rbGBv7UNxNCf4DK
         BFSUGAXv10sEHBrYv+kPrVoCZvW0XGfU5JqU3l7wScIwfwX1TQmgVJeNKl1TYFLhroKa
         SUPQeVQYdfP4uWx+cFyVccRda8l5NahFpfXRfr0TgYeW9FYjnU0aMNKdIrrQ9sUFYQRD
         ydrnwDtIARz+7E3V4odr9BcZksoY/kQrHVjtmxwAhP2bHZhDwjnmmQo6TaBMychFqYZ4
         5A7euRGnpeTVssvVoolZeMhSLER75y1FKX4K3fET5u3ETHQZ/80LLm2HqSgOg1ZgmM+k
         Nghw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=fjR2qy7ed811wyEm7oWElU90Pdhry8ybjRIcT5EV/AI=;
        b=gQxwAi2S0w/YcvkIGhxaKLmbL7o6ipL8c8fyZohCfzhU1YNvpBowbN/rYQ54SFUZK6
         w5ueWFZoa5mo5rRQECORucDbWVXM7sen+yirykzIOZL8QnVoo5061adhppWMUd1taT0A
         Aj83UK3VOBgm7U/XmtvZr8VV7UBamJoMah5VfecxnTL10DwozZ/DyHzEjjyrgv7Jqn/Y
         WOimTG8anOs4U7ao+QSTq5YuePgD6TYt1e7zam1Du7R9w00tKqbjhgtOgUpi26BqRYhK
         nZF92A4bjS61RCn8S4lzNsCZ1hMVO8fJieqtyb1lS2l7P5MxihqYv3mXQk6TDu3+rBFL
         RZIQ==
X-Gm-Message-State: APjAAAW/pAiBaAi2hrScBg7Ru3av98F9s5Mss7TpO3N1Pg8EQTH2XF3u
        I6YAydUWtkjd8PWSf1BnY7BDfMsjQNCayg==
X-Google-Smtp-Source: APXvYqxjhARm6SIoSv1NXY1vCOnOEn+xecIu6vFcr8dY6cKaYyyjepvR5wGFtRIfFWDLnyFpHdAgIPDFc0QeXw==
X-Received: by 2002:a63:ff56:: with SMTP id s22mr6826095pgk.44.1570660866332;
 Wed, 09 Oct 2019 15:41:06 -0700 (PDT)
Date:   Wed,  9 Oct 2019 15:41:03 -0700
Message-Id: <20191009224103.96473-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [PATCH net] net: silence KCSAN warnings about sk->sk_backlog.len reads
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sk->sk_backlog.len can be written by BH handlers, and read
from process contexts in a lockless way.

Note the write side should also use WRITE_ONCE() or a variant.
We need some agreement about the best way to do this.

syzbot reported :

BUG: KCSAN: data-race in tcp_add_backlog / tcp_grow_window.isra.0

write to 0xffff88812665f32c of 4 bytes by interrupt on cpu 1:
 sk_add_backlog include/net/sock.h:934 [inline]
 tcp_add_backlog+0x4a0/0xcc0 net/ipv4/tcp_ipv4.c:1737
 tcp_v4_rcv+0x1aba/0x1bf0 net/ipv4/tcp_ipv4.c:1925
 ip_protocol_deliver_rcu+0x51/0x470 net/ipv4/ip_input.c:204
 ip_local_deliver_finish+0x110/0x140 net/ipv4/ip_input.c:231
 NF_HOOK include/linux/netfilter.h:305 [inline]
 NF_HOOK include/linux/netfilter.h:299 [inline]
 ip_local_deliver+0x133/0x210 net/ipv4/ip_input.c:252
 dst_input include/net/dst.h:442 [inline]
 ip_rcv_finish+0x121/0x160 net/ipv4/ip_input.c:413
 NF_HOOK include/linux/netfilter.h:305 [inline]
 NF_HOOK include/linux/netfilter.h:299 [inline]
 ip_rcv+0x18f/0x1a0 net/ipv4/ip_input.c:523
 __netif_receive_skb_one_core+0xa7/0xe0 net/core/dev.c:5004
 __netif_receive_skb+0x37/0xf0 net/core/dev.c:5118
 netif_receive_skb_internal+0x59/0x190 net/core/dev.c:5208
 napi_skb_finish net/core/dev.c:5671 [inline]
 napi_gro_receive+0x28f/0x330 net/core/dev.c:5704
 receive_buf+0x284/0x30b0 drivers/net/virtio_net.c:1061
 virtnet_receive drivers/net/virtio_net.c:1323 [inline]
 virtnet_poll+0x436/0x7d0 drivers/net/virtio_net.c:1428
 napi_poll net/core/dev.c:6352 [inline]
 net_rx_action+0x3ae/0xa50 net/core/dev.c:6418

read to 0xffff88812665f32c of 4 bytes by task 7292 on cpu 0:
 tcp_space include/net/tcp.h:1373 [inline]
 tcp_grow_window.isra.0+0x6b/0x480 net/ipv4/tcp_input.c:413
 tcp_event_data_recv+0x68f/0x990 net/ipv4/tcp_input.c:717
 tcp_rcv_established+0xbfe/0xf50 net/ipv4/tcp_input.c:5618
 tcp_v4_do_rcv+0x381/0x4e0 net/ipv4/tcp_ipv4.c:1542
 sk_backlog_rcv include/net/sock.h:945 [inline]
 __release_sock+0x135/0x1e0 net/core/sock.c:2427
 release_sock+0x61/0x160 net/core/sock.c:2943
 tcp_recvmsg+0x63b/0x1a30 net/ipv4/tcp.c:2181
 inet_recvmsg+0xbb/0x250 net/ipv4/af_inet.c:838
 sock_recvmsg_nosec net/socket.c:871 [inline]
 sock_recvmsg net/socket.c:889 [inline]
 sock_recvmsg+0x92/0xb0 net/socket.c:885
 sock_read_iter+0x15f/0x1e0 net/socket.c:967
 call_read_iter include/linux/fs.h:1864 [inline]
 new_sync_read+0x389/0x4f0 fs/read_write.c:414
 __vfs_read+0xb1/0xc0 fs/read_write.c:427
 vfs_read fs/read_write.c:461 [inline]
 vfs_read+0x143/0x2c0 fs/read_write.c:446

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 7292 Comm: syz-fuzzer Not tainted 5.3.0+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 include/net/tcp.h | 3 ++-
 net/core/sock.c   | 2 +-
 net/sctp/diag.c   | 2 +-
 net/tipc/socket.c | 2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 88e63d64c698229379a953101a8aab2bca55ed1a..35f6f7e0fdc29d303614c101d172d87d9a4ed28d 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1380,7 +1380,8 @@ static inline int tcp_win_from_space(const struct sock *sk, int space)
 /* Note: caller must be prepared to deal with negative returns */
 static inline int tcp_space(const struct sock *sk)
 {
-	return tcp_win_from_space(sk, sk->sk_rcvbuf - sk->sk_backlog.len -
+	return tcp_win_from_space(sk, sk->sk_rcvbuf -
+				  READ_ONCE(sk->sk_backlog.len) -
 				  atomic_read(&sk->sk_rmem_alloc));
 }
 
diff --git a/net/core/sock.c b/net/core/sock.c
index b7c5c6ea51baf88548e73abd85c8f77cf29a2249..2a053999df112665bbd8d0b5a8a59cd587e786c9 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3210,7 +3210,7 @@ void sk_get_meminfo(const struct sock *sk, u32 *mem)
 	mem[SK_MEMINFO_FWD_ALLOC] = sk->sk_forward_alloc;
 	mem[SK_MEMINFO_WMEM_QUEUED] = sk->sk_wmem_queued;
 	mem[SK_MEMINFO_OPTMEM] = atomic_read(&sk->sk_omem_alloc);
-	mem[SK_MEMINFO_BACKLOG] = sk->sk_backlog.len;
+	mem[SK_MEMINFO_BACKLOG] = READ_ONCE(sk->sk_backlog.len);
 	mem[SK_MEMINFO_DROPS] = atomic_read(&sk->sk_drops);
 }
 
diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index fc9a4c6629ce04b38b3882666ef0abbd5ea8705d..0851166b917597b08becf9bf9d5873287b375828 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -175,7 +175,7 @@ static int inet_sctp_diag_fill(struct sock *sk, struct sctp_association *asoc,
 		mem[SK_MEMINFO_FWD_ALLOC] = sk->sk_forward_alloc;
 		mem[SK_MEMINFO_WMEM_QUEUED] = sk->sk_wmem_queued;
 		mem[SK_MEMINFO_OPTMEM] = atomic_read(&sk->sk_omem_alloc);
-		mem[SK_MEMINFO_BACKLOG] = sk->sk_backlog.len;
+		mem[SK_MEMINFO_BACKLOG] = READ_ONCE(sk->sk_backlog.len);
 		mem[SK_MEMINFO_DROPS] = atomic_read(&sk->sk_drops);
 
 		if (nla_put(skb, INET_DIAG_SKMEMINFO, sizeof(mem), &mem) < 0)
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 7c736cfec57f8428cdc16500fa70845716ed9fae..f8bbc4aab21397ecb184a6b869327a5b124cb7e4 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -3790,7 +3790,7 @@ int tipc_sk_dump(struct sock *sk, u16 dqueues, char *buf)
 	i += scnprintf(buf + i, sz - i, " %d", sk->sk_sndbuf);
 	i += scnprintf(buf + i, sz - i, " | %d", sk_rmem_alloc_get(sk));
 	i += scnprintf(buf + i, sz - i, " %d", sk->sk_rcvbuf);
-	i += scnprintf(buf + i, sz - i, " | %d\n", sk->sk_backlog.len);
+	i += scnprintf(buf + i, sz - i, " | %d\n", READ_ONCE(sk->sk_backlog.len));
 
 	if (dqueues & TIPC_DUMP_SK_SNDQ) {
 		i += scnprintf(buf + i, sz - i, "sk_write_queue: ");
-- 
2.23.0.581.g78d2f28ef7-goog

