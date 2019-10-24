Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41CD3E2A11
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 07:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437590AbfJXFpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 01:45:12 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:36099 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437581AbfJXFpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 01:45:12 -0400
Received: by mail-pl1-f202.google.com with SMTP id s24so14369543plp.3
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 22:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=KWqneFFvWQsghUOSDd8vZNE2ta0jAGm1kVbWJbU2MWU=;
        b=Q50vZ48U4LOdbJJH5u2uR2zqpXoOwkbLK9dgdUYd49Z/aBZ8nFEeHke1uvspq5+G2A
         injB0ja1GOt3x2WtmyR/dMe2uOr5CxyQMf/66+e0jCOIPyzOkwGxcqFsPVDgrwHIdVJ7
         gTQ54XKcx93n6dhkDb2e1eALl3IHP1yukKzlmzaCTrqlVKR4T6rxD3uF0f5aUNLwkYpk
         Fu1PSGE0rHzOhL4mgCsuy2ghixbJZCOEaBBQpFEFmntPLOD/WKrBpgLS+he1oVm4mjbu
         z6JLPbG/VP2c4YKXlSes41rjDS0m47emYeYBPRbHZuSU0qaHh29lSf+vHLjS4uCJsDmt
         vVmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KWqneFFvWQsghUOSDd8vZNE2ta0jAGm1kVbWJbU2MWU=;
        b=qT6EX67NxoVRXoaGbzim78vF3zlTL2k26J5QK+vdL+iHRVaw5+ql0n2gceoS6JZ7b9
         0DDPfj+DNdEaxoBGIEewXFoJ0C9JZVwaDFJuqkz1/t4XMCbvUqBJ/cb1bWBxXTC2JU3C
         6PWXra3xsspy1M0W2DMncmIaqeHm+3R8eAzGkMXD2ZWA08EiRIRsB6aIeBsZhuGE4eZ5
         bDoJmvfzQtiqBIn2StmX3KhgyQZDDrTEfpqiP4hWv3Sq99PoKVxUEyV1E99mXGOE//Kn
         WBezk1YektTOC2XWak+5CgUD7viNeb13b7b9ww0hPx9x7VPspXD7BYvKbKI6s4eEmz3W
         q9Lg==
X-Gm-Message-State: APjAAAVuiwt+N8Qb3Inahd2BIzykGFwkvN+61bTIDRB1GWnjezhNGyjh
        l3NRTcfq+Qc7scnoIeVVi+pTpp4QNoH09g==
X-Google-Smtp-Source: APXvYqx5dxTy+OpAGW8pOkVx5EuK48eE11xFwEs3wmAtldhcU9O3h5Jf1u+JLqc9vbv0+K50zfjrxnbnsF92Cw==
X-Received: by 2002:a63:3c19:: with SMTP id j25mr14896283pga.12.1571895911304;
 Wed, 23 Oct 2019 22:45:11 -0700 (PDT)
Date:   Wed, 23 Oct 2019 22:44:52 -0700
In-Reply-To: <20191024054452.81661-1-edumazet@google.com>
Message-Id: <20191024054452.81661-6-edumazet@google.com>
Mime-Version: 1.0
References: <20191024054452.81661-1-edumazet@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH net 5/5] net: add READ_ONCE() annotation in __skb_wait_for_more_packets()
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

__skb_wait_for_more_packets() can be called while other cpus
can feed packets to the socket receive queue.

KCSAN reported :

BUG: KCSAN: data-race in __skb_wait_for_more_packets / __udp_enqueue_schedule_skb

write to 0xffff888102e40b58 of 8 bytes by interrupt on cpu 0:
 __skb_insert include/linux/skbuff.h:1852 [inline]
 __skb_queue_before include/linux/skbuff.h:1958 [inline]
 __skb_queue_tail include/linux/skbuff.h:1991 [inline]
 __udp_enqueue_schedule_skb+0x2d7/0x410 net/ipv4/udp.c:1470
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

read to 0xffff888102e40b58 of 8 bytes by task 13035 on cpu 1:
 __skb_wait_for_more_packets+0xfa/0x320 net/core/datagram.c:100
 __skb_recv_udp+0x374/0x500 net/ipv4/udp.c:1683
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
CPU: 1 PID: 13035 Comm: syz-executor.3 Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/core/datagram.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index 03515e46a49ab60cdd5f643efb3459d16f6021e5..da3c24ed129cd64db8bdb1916afa552a47c1a5a3 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -97,7 +97,7 @@ int __skb_wait_for_more_packets(struct sock *sk, int *err, long *timeo_p,
 	if (error)
 		goto out_err;
 
-	if (sk->sk_receive_queue.prev != skb)
+	if (READ_ONCE(sk->sk_receive_queue.prev) != skb)
 		goto out;
 
 	/* Socket shut down? */
-- 
2.23.0.866.gb869b98d4c-goog

