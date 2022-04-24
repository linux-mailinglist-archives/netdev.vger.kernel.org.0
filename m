Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 300F150D516
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 22:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239585AbiDXUiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 16:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239581AbiDXUiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 16:38:15 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E6A644D1
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 13:35:13 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id s17so22704045plg.9
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 13:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7HO0jzjb7JO+HXqzRnWkAeAIEP4UJiL+srj42ZoD/MM=;
        b=UR8m4CpoQVVroHm2coSPMCN0naRZxcwppQqLgGKSNtQok2q5ymj6kd/VEthKGYjCii
         zC9Smj8osmioMlUexlFX+mzwHcV5I1l3M4aD/04rsw5+UEnaK6VTXLqQATUo/ck8SrpD
         Xfk/VZ+EZ//N4zQXBRmwy8opQgAcMxuxiu5vpku6Zczn4izEY/vpZECXK/qCr9kN4fYB
         r0qhjVxiKpcUBVJ6yPMtZhX4+7w5464BpHaZjpkHmx7UCuxpaoiGhcvT9PcgBS+Ox2Nb
         t5q6t9DYCBDyMQTlGZ1tasYLtKIt6JpM3qNiPFhRSXRfVb+yyFsflBn+tEhLNOLxw73v
         xTbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7HO0jzjb7JO+HXqzRnWkAeAIEP4UJiL+srj42ZoD/MM=;
        b=OmOY5y7HbEJy1COze8xu5r+byeiCwspbZrjyNrrWS9w8HIsitOhNp1vWC1dABscF0i
         6Xt9VEo3W3a/p6BE633Tdgm76YLFavx0CP/97JsmC/pHMbfnVjGW0i/VV4DE2lhZ8K/p
         mnwODyq0s4KaNhY7BzQ27Ts3LSs5RJuoEC81PB+SC/978wJaaVJ5OsDH+kvsvvq/r6yz
         B6K096qAzp8LAkOaNiiDY4ceCCCwrLg1taedPkiYSGCOOeA7RGUMcz6JqOzfMOCapfM6
         KxS9Tz5IjjPMoEA/PlArwDESuVAlWdoyXhhy9KqV1lHSpIGddWagZsXUqzKzjNk+RveN
         W5Ug==
X-Gm-Message-State: AOAM533t4DN33k5YnixUZx50gKQVuOpaD9aIncI2l1UY8hkVXtyN+lmm
        Fc14n3VaQDl1TMhcQn2d2VU=
X-Google-Smtp-Source: ABdhPJydRxxyeop/A0cit23DWUjE7kTOMnwIx9Mw4r/GBkpiTG8M/5OIoj6jK1bnOW+Wc+uXelJCwA==
X-Received: by 2002:a17:902:aa88:b0:156:914b:dc79 with SMTP id d8-20020a170902aa8800b00156914bdc79mr14747826plr.138.1650832513042;
        Sun, 24 Apr 2022 13:35:13 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:deb1:6b52:39aa:3e96])
        by smtp.gmail.com with ESMTPSA id z28-20020a62d11c000000b0050d2daec38esm3737493pfg.113.2022.04.24.13.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Apr 2022 13:35:12 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>
Subject: [PATCH net] tcp: make sure treq->af_specific is initialized
Date:   Sun, 24 Apr 2022 13:35:09 -0700
Message-Id: <20220424203509.2801158-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

syzbot complained about a recent change in TCP stack,
hitting a NULL pointer [1]

tcp request sockets have an af_specific pointer, which
was used before the blamed change only for SYNACK generation
in non SYNCOOKIE mode.

tcp requests sockets momentarily created when third packet
coming from client in SYNCOOKIE mode were not using
treq->af_specific.

Make sure this field is populated, in the same way normal
TCP requests sockets do in tcp_conn_request().

[1]
TCP: request_sock_TCPv6: Possible SYN flooding on port 20002. Sending cookies.  Check SNMP counters.
general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 1 PID: 3695 Comm: syz-executor864 Not tainted 5.18.0-rc3-syzkaller-00224-g5fd1fe4807f9 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:tcp_create_openreq_child+0xe16/0x16b0 net/ipv4/tcp_minisocks.c:534
Code: 48 c1 ea 03 80 3c 02 00 0f 85 e5 07 00 00 4c 8b b3 28 01 00 00 48 b8 00 00 00 00 00 fc ff df 49 8d 7e 08 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 c9 07 00 00 48 8b 3c 24 48 89 de 41 ff 56 08 48
RSP: 0018:ffffc90000de0588 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff888076490330 RCX: 0000000000000100
RDX: 0000000000000001 RSI: ffffffff87d67ff0 RDI: 0000000000000008
RBP: ffff88806ee1c7f8 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff87d67f00 R11: 0000000000000000 R12: ffff88806ee1bfc0
R13: ffff88801b0e0368 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f517fe58700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffcead76960 CR3: 000000006f97b000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 tcp_v6_syn_recv_sock+0x199/0x23b0 net/ipv6/tcp_ipv6.c:1267
 tcp_get_cookie_sock+0xc9/0x850 net/ipv4/syncookies.c:207
 cookie_v6_check+0x15c3/0x2340 net/ipv6/syncookies.c:258
 tcp_v6_cookie_check net/ipv6/tcp_ipv6.c:1131 [inline]
 tcp_v6_do_rcv+0x1148/0x13b0 net/ipv6/tcp_ipv6.c:1486
 tcp_v6_rcv+0x3305/0x3840 net/ipv6/tcp_ipv6.c:1725
 ip6_protocol_deliver_rcu+0x2e9/0x1900 net/ipv6/ip6_input.c:422
 ip6_input_finish+0x14c/0x2c0 net/ipv6/ip6_input.c:464
 NF_HOOK include/linux/netfilter.h:307 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip6_input+0x9c/0xd0 net/ipv6/ip6_input.c:473
 dst_input include/net/dst.h:461 [inline]
 ip6_rcv_finish net/ipv6/ip6_input.c:76 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ipv6_rcv+0x27f/0x3b0 net/ipv6/ip6_input.c:297
 __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5405
 __netif_receive_skb+0x24/0x1b0 net/core/dev.c:5519
 process_backlog+0x3a0/0x7c0 net/core/dev.c:5847
 __napi_poll+0xb3/0x6e0 net/core/dev.c:6413
 napi_poll net/core/dev.c:6480 [inline]
 net_rx_action+0x8ec/0xc60 net/core/dev.c:6567
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 invoke_softirq kernel/softirq.c:432 [inline]
 __irq_exit_rcu+0x123/0x180 kernel/softirq.c:637
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:649
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1097

Fixes: 5b0b9e4c2c89 ("tcp: md5: incorrect tcp_header_len for incoming connections")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Francesco Ruggeri <fruggeri@arista.com>
---
 include/net/tcp.h     | 1 +
 net/ipv4/syncookies.c | 8 +++++++-
 net/ipv6/syncookies.c | 3 ++-
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index be712fb9ddd71b2b320356677f3aa1c6759e2698..9987b3fba9f202632916cc439af9d17f1e68bcd3 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -480,6 +480,7 @@ int __cookie_v4_check(const struct iphdr *iph, const struct tcphdr *th,
 		      u32 cookie);
 struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb);
 struct request_sock *cookie_tcp_reqsk_alloc(const struct request_sock_ops *ops,
+					    const struct tcp_request_sock_ops *af_ops,
 					    struct sock *sk, struct sk_buff *skb);
 #ifdef CONFIG_SYN_COOKIES
 
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 2cb3b852d14861231ac47f0b3e4daeb57682ffd2..f33c31dd7366c06a642bdc5954856efa9d8da0ac 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -281,6 +281,7 @@ bool cookie_ecn_ok(const struct tcp_options_received *tcp_opt,
 EXPORT_SYMBOL(cookie_ecn_ok);
 
 struct request_sock *cookie_tcp_reqsk_alloc(const struct request_sock_ops *ops,
+					    const struct tcp_request_sock_ops *af_ops,
 					    struct sock *sk,
 					    struct sk_buff *skb)
 {
@@ -297,6 +298,10 @@ struct request_sock *cookie_tcp_reqsk_alloc(const struct request_sock_ops *ops,
 		return NULL;
 
 	treq = tcp_rsk(req);
+
+	/* treq->af_specific might be used to perform TCP_MD5 lookup */
+	treq->af_specific = af_ops;
+
 	treq->syn_tos = TCP_SKB_CB(skb)->ip_dsfield;
 #if IS_ENABLED(CONFIG_MPTCP)
 	treq->is_mptcp = sk_is_mptcp(sk);
@@ -364,7 +369,8 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 		goto out;
 
 	ret = NULL;
-	req = cookie_tcp_reqsk_alloc(&tcp_request_sock_ops, sk, skb);
+	req = cookie_tcp_reqsk_alloc(&tcp_request_sock_ops,
+				     &tcp_request_sock_ipv4_ops, sk, skb);
 	if (!req)
 		goto out;
 
diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
index d1b61d00368e1f58725e9997f74a0b144901277e..9cc123f000fbcfbeff7728bfee5339d6dd6470f9 100644
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -170,7 +170,8 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
 		goto out;
 
 	ret = NULL;
-	req = cookie_tcp_reqsk_alloc(&tcp6_request_sock_ops, sk, skb);
+	req = cookie_tcp_reqsk_alloc(&tcp6_request_sock_ops,
+				     &tcp_request_sock_ipv6_ops, sk, skb);
 	if (!req)
 		goto out;
 
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

