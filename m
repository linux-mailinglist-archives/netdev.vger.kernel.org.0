Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13E74D1B95
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 00:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731959AbfJIWVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 18:21:19 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:50487 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730675AbfJIWVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 18:21:18 -0400
Received: by mail-pf1-f201.google.com with SMTP id q127so2966628pfc.17
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 15:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=9iI3atwAociXdMcoq1O/wEZBO8lgguiqqOosAgbC//k=;
        b=S/eBKFfGnV7iKLP3qXOIcy3E5OoHXWyvYMbwcn8kkqeBSC3sQ0fwh77hdeND9Y0zmn
         FbSnpJeL59B6ycSLR9Tn0Zh2uAOCCWl0Xia1q5fBS9Y9em2Yp7SyoSPh8VVJT9VqPHar
         x0CCjoTRD9MhEY4ukqyzPh48h7ZtZGlIc60OWUlDXDUxTuib1CzeH/OVpToyKiV+Kojm
         88PWHP8oBtRRjH+MGtNI5ZOpO0v00tMGWrzHmziiWuHdt7ZY5JvNXemLwvfHI+JPU03F
         hRvdjcTO739m9B7rxoHY8KiYQJHANfthWT6id+la7p6V3D9zjbzm2t71uz7hmEw+vdnI
         x1cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=9iI3atwAociXdMcoq1O/wEZBO8lgguiqqOosAgbC//k=;
        b=CARRznx/8oTgpvvlTNG45VudQpbxdWB4wk5s0lLf2efiCiDIp8J2lECwcmOIBpZxgp
         RCKy0B0T0XpvWU8Cesrvc2JCitplgPVCCtXRqWo6GLgz7GO55/CqIy8zZTNxoBvaAWWB
         M4poYHscVHVm/PwiPcDQpNmepPiaaoTS5XlaqGAJZpOO+xSfx/2Ysc9nptsyHjX1tj0F
         lt0Y61ATEW705uyhqqvJPL/SuwAmPl1rFShLWp1VvvxOaNmTfpLddtaKRwK4zaUv74aq
         K1X4eUAFZ6lnjjzqDLy8IHZNcMBrDJ78nEYCCIC4sTeZIYuaB1SuS+HlNoTNtPYPB2Lt
         275g==
X-Gm-Message-State: APjAAAVxAiMuxyfhnwQtwzOKeml9DJrTs3fWMObNKCUCLscjhvq4aFKr
        1+opQTNopdcSU0Wodl0lSTkeADJaR+1XKA==
X-Google-Smtp-Source: APXvYqyCb5v1a3vdZFfRkPxO8r/D83IjAsiQmf61LL/prlS3KrGlgS5bARgtsByMItF6ezFy9qP2zqKGmYPWcA==
X-Received: by 2002:a63:5d06:: with SMTP id r6mr6835135pgb.216.1570659676322;
 Wed, 09 Oct 2019 15:21:16 -0700 (PDT)
Date:   Wed,  9 Oct 2019 15:21:13 -0700
Message-Id: <20191009222113.43209-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [PATCH net] net: silence KCSAN warnings around sk_add_backlog() calls
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

sk_add_backlog() callers usually read sk->sk_rcvbuf without
owning the socket lock. This means sk_rcvbuf value can
be changed by other cpus, and KCSAN complains.

Add READ_ONCE() annotations to document the lockless nature
of these reads.

Note that writes over sk_rcvbuf should also use WRITE_ONCE(),
but this will be done in separate patches to ease stable
backports (if we decide this is relevant for stable trees).

BUG: KCSAN: data-race in tcp_add_backlog / tcp_recvmsg

write to 0xffff88812ab369f8 of 8 bytes by interrupt on cpu 1:
 __sk_add_backlog include/net/sock.h:902 [inline]
 sk_add_backlog include/net/sock.h:933 [inline]
 tcp_add_backlog+0x45a/0xcc0 net/ipv4/tcp_ipv4.c:1737
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

read to 0xffff88812ab369f8 of 8 bytes by task 7271 on cpu 0:
 tcp_recvmsg+0x470/0x1a30 net/ipv4/tcp.c:2047
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
 ksys_read+0xd5/0x1b0 fs/read_write.c:587
 __do_sys_read fs/read_write.c:597 [inline]
 __se_sys_read fs/read_write.c:595 [inline]
 __x64_sys_read+0x4c/0x60 fs/read_write.c:595
 do_syscall_64+0xcf/0x2f0 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 7271 Comm: syz-fuzzer Not tainted 5.3.0+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/core/sock.c     | 2 +-
 net/ipv4/tcp_ipv4.c | 2 +-
 net/llc/llc_conn.c  | 2 +-
 net/sctp/input.c    | 4 ++--
 net/tipc/socket.c   | 6 +++---
 net/x25/x25_dev.c   | 2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 50647a10fdb7f050e963e2734f0d3555fa4bd7aa..1cf06934da50b98fccc849d396680cee46badb7d 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -522,7 +522,7 @@ int __sk_receive_skb(struct sock *sk, struct sk_buff *skb,
 		rc = sk_backlog_rcv(sk, skb);
 
 		mutex_release(&sk->sk_lock.dep_map, 1, _RET_IP_);
-	} else if (sk_add_backlog(sk, skb, sk->sk_rcvbuf)) {
+	} else if (sk_add_backlog(sk, skb, READ_ONCE(sk->sk_rcvbuf))) {
 		bh_unlock_sock(sk);
 		atomic_inc(&sk->sk_drops);
 		goto discard_and_relse;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index bf124b1742df864a3007d137ff31c8bfb2bee12a..492bf6a6b0237a677aae5d7ef365a5fc7356e238 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1644,7 +1644,7 @@ int tcp_v4_early_demux(struct sk_buff *skb)
 
 bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
 {
-	u32 limit = sk->sk_rcvbuf + sk->sk_sndbuf;
+	u32 limit = READ_ONCE(sk->sk_rcvbuf) + READ_ONCE(sk->sk_sndbuf);
 	struct skb_shared_info *shinfo;
 	const struct tcphdr *th;
 	struct tcphdr *thtail;
diff --git a/net/llc/llc_conn.c b/net/llc/llc_conn.c
index a79b739eb223668aa837ac08bbcebc0ae5750a0a..7b620acaca9ec194e03b590c21fb004401dbc7ce 100644
--- a/net/llc/llc_conn.c
+++ b/net/llc/llc_conn.c
@@ -813,7 +813,7 @@ void llc_conn_handler(struct llc_sap *sap, struct sk_buff *skb)
 	else {
 		dprintk("%s: adding to backlog...\n", __func__);
 		llc_set_backlog_type(skb, LLC_PACKET);
-		if (sk_add_backlog(sk, skb, sk->sk_rcvbuf))
+		if (sk_add_backlog(sk, skb, READ_ONCE(sk->sk_rcvbuf)))
 			goto drop_unlock;
 	}
 out:
diff --git a/net/sctp/input.c b/net/sctp/input.c
index 5a070fb5b278f031339c8a239406ee0e019ff943..a700660f64616857423de50c0b578ba0740d527c 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -322,7 +322,7 @@ int sctp_backlog_rcv(struct sock *sk, struct sk_buff *skb)
 		bh_lock_sock(sk);
 
 		if (sock_owned_by_user(sk)) {
-			if (sk_add_backlog(sk, skb, sk->sk_rcvbuf))
+			if (sk_add_backlog(sk, skb, READ_ONCE(sk->sk_rcvbuf)))
 				sctp_chunk_free(chunk);
 			else
 				backloged = 1;
@@ -358,7 +358,7 @@ static int sctp_add_backlog(struct sock *sk, struct sk_buff *skb)
 	struct sctp_ep_common *rcvr = chunk->rcvr;
 	int ret;
 
-	ret = sk_add_backlog(sk, skb, sk->sk_rcvbuf);
+	ret = sk_add_backlog(sk, skb, READ_ONCE(sk->sk_rcvbuf));
 	if (!ret) {
 		/* Hold the assoc/ep while hanging on the backlog queue.
 		 * This way, we know structures we need will not disappear
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 3b9f8cc328f5c3aa2f39b5a8267bd206e714835f..7c736cfec57f8428cdc16500fa70845716ed9fae 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -2119,13 +2119,13 @@ static unsigned int rcvbuf_limit(struct sock *sk, struct sk_buff *skb)
 	struct tipc_msg *hdr = buf_msg(skb);
 
 	if (unlikely(msg_in_group(hdr)))
-		return sk->sk_rcvbuf;
+		return READ_ONCE(sk->sk_rcvbuf);
 
 	if (unlikely(!msg_connected(hdr)))
-		return sk->sk_rcvbuf << msg_importance(hdr);
+		return READ_ONCE(sk->sk_rcvbuf) << msg_importance(hdr);
 
 	if (likely(tsk->peer_caps & TIPC_BLOCK_FLOWCTL))
-		return sk->sk_rcvbuf;
+		return READ_ONCE(sk->sk_rcvbuf);
 
 	return FLOWCTL_MSG_LIM;
 }
diff --git a/net/x25/x25_dev.c b/net/x25/x25_dev.c
index 5c111bc3c8ea5a8c079cd0d83733e7b253d47158..00e782335cb0740daa172f0c1835bcc3285ba46b 100644
--- a/net/x25/x25_dev.c
+++ b/net/x25/x25_dev.c
@@ -55,7 +55,7 @@ static int x25_receive_data(struct sk_buff *skb, struct x25_neigh *nb)
 		if (!sock_owned_by_user(sk)) {
 			queued = x25_process_rx_frame(sk, skb);
 		} else {
-			queued = !sk_add_backlog(sk, skb, sk->sk_rcvbuf);
+			queued = !sk_add_backlog(sk, skb, READ_ONCE(sk->sk_rcvbuf));
 		}
 		bh_unlock_sock(sk);
 		sock_put(sk);
-- 
2.23.0.581.g78d2f28ef7-goog

