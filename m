Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3D04F203F
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 21:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbfKFU7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 15:59:40 -0500
Received: from mail-vk1-f202.google.com ([209.85.221.202]:39276 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727351AbfKFU7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 15:59:39 -0500
Received: by mail-vk1-f202.google.com with SMTP id l4so37176vkn.6
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 12:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=y6+OgBdaVazoYQ3Zsb/g9VIXHgoWIg8+1fkGYDtCvc0=;
        b=XnFOq9nIU2FcE74t4s4Oq2Ts3sea/UCxoVpfe30f9F2FkMunV/zckC1TUpYuSKxw+z
         XMWMKz2hkeqqDs5YdNSRBWb0YozjkzIxH6SU8QW+b13hQAHX3PpkIzbD/oObg/6BlhlF
         OQ1s5DIxDQyHWHcAsZNzRuunt0NMSYbJNcnwFDS56CTB7fFqgL/1MBYsoK3JuOdgeuqF
         sIPNo4NTYwhV9AJL8r6gbPYxJHIZcGd0J6rNYLUUMp+YlnESlFWwQmAIgondveE+QtLj
         Ymo4D8QMWJFG/vyJ+I1JQ3G6bLQpmfYe1BZth7C9YcH4VKINXi97zNXruR/Mixx2PE4Q
         teIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=y6+OgBdaVazoYQ3Zsb/g9VIXHgoWIg8+1fkGYDtCvc0=;
        b=a0UDNlh3ddRVhoHmK3pz+sE5CJtWo/aqxf+czQaDuTLRLZaNVMwj4UPxga/uHDN+RA
         p0drkDxxBYCGRKYQbSzbzkS/vxv3Pqle9Ko/8645LZAayLPjJBFymxc11EO7whk56CeQ
         ytsBUjGvDqBUofXp9gKMH2bPiba7UZptV9hWUch0Rc0Hwqc4gpy/uu/SQa3d+2oBlpVb
         bruAdKyBHwXQKCq7/bajPkqpgrNNnu/c1ZmF7cliny8sU4abioRq8i+CwmrhFPv1czxs
         ttg7JGjeRsXQlUT5RK0hdCf4+uleJL0qN5Ioh+1HFT1BacEL1KCA8iVhFRm4RgOR6Wb1
         TYaQ==
X-Gm-Message-State: APjAAAUoR7flKKF9+aFMXBhpo1Dv6/Rw+635U8CMP7Vh5pzS7rSpdE8b
        wpOyZOJQn1baOlziR1HgGSAb/2rUQRlkUg==
X-Google-Smtp-Source: APXvYqxA6zpaQyhnUOa5mxjkf8KToFV8BPO5lztJ89SZIJwNJ1FkWkbKt+TCgDTDQcXmfLINSaHyV+2qb53HLg==
X-Received: by 2002:a67:fbd9:: with SMTP id o25mr2695759vsr.70.1573073976676;
 Wed, 06 Nov 2019 12:59:36 -0800 (PST)
Date:   Wed,  6 Nov 2019 12:59:33 -0800
Message-Id: <20191106205933.149697-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH net-next] tcp: fix data-race in tcp_recvmsg()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reading tp->recvmsg_inq after socket lock is released
raises a KCSAN warning [1]

Replace has_tss & has_cmsg by cmsg_flags and make
sure to not read tp->recvmsg_inq a second time.

[1]
BUG: KCSAN: data-race in tcp_chrono_stop / tcp_recvmsg

write to 0xffff888126adef24 of 2 bytes by interrupt on cpu 0:
 tcp_chrono_set net/ipv4/tcp_output.c:2309 [inline]
 tcp_chrono_stop+0x14c/0x280 net/ipv4/tcp_output.c:2338
 tcp_clean_rtx_queue net/ipv4/tcp_input.c:3165 [inline]
 tcp_ack+0x274f/0x3170 net/ipv4/tcp_input.c:3688
 tcp_rcv_established+0x37e/0xf50 net/ipv4/tcp_input.c:5696
 tcp_v4_do_rcv+0x381/0x4e0 net/ipv4/tcp_ipv4.c:1561
 tcp_v4_rcv+0x19dc/0x1bb0 net/ipv4/tcp_ipv4.c:1942
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
 netif_receive_skb_internal+0x59/0x190 net/core/dev.c:5214
 napi_skb_finish net/core/dev.c:5677 [inline]
 napi_gro_receive+0x28f/0x330 net/core/dev.c:5710

read to 0xffff888126adef25 of 1 bytes by task 7275 on cpu 1:
 tcp_recvmsg+0x77b/0x1a30 net/ipv4/tcp.c:2187
 inet_recvmsg+0xbb/0x250 net/ipv4/af_inet.c:838
 sock_recvmsg_nosec net/socket.c:871 [inline]
 sock_recvmsg net/socket.c:889 [inline]
 sock_recvmsg+0x92/0xb0 net/socket.c:885
 sock_read_iter+0x15f/0x1e0 net/socket.c:967
 call_read_iter include/linux/fs.h:1889 [inline]
 new_sync_read+0x389/0x4f0 fs/read_write.c:414
 __vfs_read+0xb1/0xc0 fs/read_write.c:427
 vfs_read fs/read_write.c:461 [inline]
 vfs_read+0x143/0x2c0 fs/read_write.c:446
 ksys_read+0xd5/0x1b0 fs/read_write.c:587
 __do_sys_read fs/read_write.c:597 [inline]
 __se_sys_read fs/read_write.c:595 [inline]
 __x64_sys_read+0x4c/0x60 fs/read_write.c:595
 do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 7275 Comm: sshd Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: b75eba76d3d7 ("tcp: send in-queue bytes in cmsg upon read")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv4/tcp.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 8fb4fefcfd544943e9c92870d4d0da25f3813448..9b48aec29aca6317adf7e96c8d058c859b1309c6 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1958,8 +1958,7 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 	struct sk_buff *skb, *last;
 	u32 urg_hole = 0;
 	struct scm_timestamping_internal tss;
-	bool has_tss = false;
-	bool has_cmsg;
+	int cmsg_flags;
 
 	if (unlikely(flags & MSG_ERRQUEUE))
 		return inet_recv_error(sk, msg, len, addr_len);
@@ -1974,7 +1973,7 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 	if (sk->sk_state == TCP_LISTEN)
 		goto out;
 
-	has_cmsg = tp->recvmsg_inq;
+	cmsg_flags = tp->recvmsg_inq ? 1 : 0;
 	timeo = sock_rcvtimeo(sk, nonblock);
 
 	/* Urgent data needs to be handled specially. */
@@ -2157,8 +2156,7 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 
 		if (TCP_SKB_CB(skb)->has_rxtstamp) {
 			tcp_update_recv_tstamps(skb, &tss);
-			has_tss = true;
-			has_cmsg = true;
+			cmsg_flags |= 2;
 		}
 		if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN)
 			goto found_fin_ok;
@@ -2183,10 +2181,10 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 
 	release_sock(sk);
 
-	if (has_cmsg) {
-		if (has_tss)
+	if (cmsg_flags) {
+		if (cmsg_flags & 2)
 			tcp_recv_timestamp(msg, sk, &tss);
-		if (tp->recvmsg_inq) {
+		if (cmsg_flags & 1) {
 			inq = tcp_inq_hint(sk);
 			put_cmsg(msg, SOL_TCP, TCP_CM_INQ, sizeof(inq), &inq);
 		}
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

