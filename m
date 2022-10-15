Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 194C85FFBFE
	for <lists+netdev@lfdr.de>; Sat, 15 Oct 2022 23:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiJOVYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 17:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiJOVYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 17:24:46 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2EA41F2D5
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 14:24:44 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id gd8-20020a05622a5c0800b0039cb77202eeso5980674qtb.0
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 14:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uhxuYddBPHLon2cYwVoQaa4QvTGei/lcTkN1Oqxr6ts=;
        b=ZTqySwtlyT9hhi8G0+AQuRa/wECq2HD9FPXOZz0erScYPnZyyBeQeRHPj8f8m4dJmq
         8h8HhtegcDyU8YmOd8GxUmYq3vWiaReXYROOMISlOsIz7F2kkanfvAUz7G6pnnVXC+rd
         M/8Hr2UJJs+HtRxh2vMT6Oa0Qy1E8J3JsJ79fgvqUgztoa7Uvd7bHQEtgLClg/zBAZfW
         M0IhDGnRrofts6sUnEcgLZunHlpz0OAOcw5YOrSSJkcaH5Z4ex8gvsd4qTI96e1TqFjU
         tBDAj4P1fS/gLUmVBMikYsrhiStaDmPhmH5evhnMpsDnxcItoRJNJ4vtoJg21u1NeUS3
         YWJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uhxuYddBPHLon2cYwVoQaa4QvTGei/lcTkN1Oqxr6ts=;
        b=Xc/UdPBWdvC8VLcrEw6ILjIyK0lZhN1MM+YnW3UYARionwG820zsaIhJN+K5KyIjQO
         pbW1IA2rqcdQXpdM1xQG1aESg4x2jWr8srr4KwDYEUBG1zJozwKiki+OCk36KyXVFcn8
         W6kDOFl8nbA1kKXKaP4KOcpPQ3fGNN2YHyCzEjjsGGZ14PNS1+zqtoec97XHoyS0wHVb
         oiVjNx1PB2ZNEIafP3TtYk/7DN77KRP9HyrSZGwi9T2WNoa4vOXZd2KV3L0XtJipBbtX
         e6P9CLTm8yEkJ/RWpJp9dCoNQLhbjI+cBeKYDUozfJ7yqHbvkGouICdtbzHbOXOsiLbG
         M3dg==
X-Gm-Message-State: ACrzQf1iHKlaiwF+3p1GN5W+HITaapyBSoFuJ/BbhefzhcYbJjmYwwp7
        TaqvvP7vfOWbBEdn371uSyWUTbI6LcQ2yw==
X-Google-Smtp-Source: AMsMyM7X7QT6vO2x5TXclSLleRK+YHpMGbtik899y/2fG/ALfpkafAYteOfMqWt3+O4gpb6vYMSvIyNPmk+8YA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:620a:4054:b0:6ec:56e0:bb87 with SMTP
 id i20-20020a05620a405400b006ec56e0bb87mr2973513qko.782.1665869083942; Sat,
 15 Oct 2022 14:24:43 -0700 (PDT)
Date:   Sat, 15 Oct 2022 21:24:41 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221015212441.1824736-1-edumazet@google.com>
Subject: [PATCH net] skmsg: pass gfp argument to alloc_sk_msg()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot found that alloc_sk_msg() could be called from a
non sleepable context. sk_psock_verdict_recv() uses
rcu_read_lock() protection.

We need the callers to pass a gfp_t argument to avoid issues.

syzbot report was:

BUG: sleeping function called from invalid context at include/linux/sched/mm.h:274
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 3613, name: syz-executor414
preempt_count: 0, expected: 0
RCU nest depth: 1, expected: 0
INFO: lockdep is turned off.
CPU: 0 PID: 3613 Comm: syz-executor414 Not tainted 6.0.0-syzkaller-09589-g55be6084c8e0 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
Call Trace:
<TASK>
__dump_stack lib/dump_stack.c:88 [inline]
dump_stack_lvl+0x1e3/0x2cb lib/dump_stack.c:106
__might_resched+0x538/0x6a0 kernel/sched/core.c:9877
might_alloc include/linux/sched/mm.h:274 [inline]
slab_pre_alloc_hook mm/slab.h:700 [inline]
slab_alloc_node mm/slub.c:3162 [inline]
slab_alloc mm/slub.c:3256 [inline]
kmem_cache_alloc_trace+0x59/0x310 mm/slub.c:3287
kmalloc include/linux/slab.h:600 [inline]
kzalloc include/linux/slab.h:733 [inline]
alloc_sk_msg net/core/skmsg.c:507 [inline]
sk_psock_skb_ingress_self+0x5c/0x330 net/core/skmsg.c:600
sk_psock_verdict_apply+0x395/0x440 net/core/skmsg.c:1014
sk_psock_verdict_recv+0x34d/0x560 net/core/skmsg.c:1201
tcp_read_skb+0x4a1/0x790 net/ipv4/tcp.c:1770
tcp_rcv_established+0x129d/0x1a10 net/ipv4/tcp_input.c:5971
tcp_v4_do_rcv+0x479/0xac0 net/ipv4/tcp_ipv4.c:1681
sk_backlog_rcv include/net/sock.h:1109 [inline]
__release_sock+0x1d8/0x4c0 net/core/sock.c:2906
release_sock+0x5d/0x1c0 net/core/sock.c:3462
tcp_sendmsg+0x36/0x40 net/ipv4/tcp.c:1483
sock_sendmsg_nosec net/socket.c:714 [inline]
sock_sendmsg net/socket.c:734 [inline]
__sys_sendto+0x46d/0x5f0 net/socket.c:2117
__do_sys_sendto net/socket.c:2129 [inline]
__se_sys_sendto net/socket.c:2125 [inline]
__x64_sys_sendto+0xda/0xf0 net/socket.c:2125
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: 43312915b5ba ("skmsg: Get rid of unncessary memset()")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Cong Wang <cong.wang@bytedance.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index ca70525621c7162da52b9ae446337cbaac378f78..1efdc47a999b44089e1abfee15a5a93269851997 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -500,11 +500,11 @@ bool sk_msg_is_readable(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(sk_msg_is_readable);
 
-static struct sk_msg *alloc_sk_msg(void)
+static struct sk_msg *alloc_sk_msg(gfp_t gfp)
 {
 	struct sk_msg *msg;
 
-	msg = kzalloc(sizeof(*msg), __GFP_NOWARN | GFP_KERNEL);
+	msg = kzalloc(sizeof(*msg), gfp | __GFP_NOWARN);
 	if (unlikely(!msg))
 		return NULL;
 	sg_init_marker(msg->sg.data, NR_MSG_FRAG_IDS);
@@ -520,7 +520,7 @@ static struct sk_msg *sk_psock_create_ingress_msg(struct sock *sk,
 	if (!sk_rmem_schedule(sk, skb, skb->truesize))
 		return NULL;
 
-	return alloc_sk_msg();
+	return alloc_sk_msg(GFP_KERNEL);
 }
 
 static int sk_psock_skb_ingress_enqueue(struct sk_buff *skb,
@@ -597,7 +597,7 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb,
 static int sk_psock_skb_ingress_self(struct sk_psock *psock, struct sk_buff *skb,
 				     u32 off, u32 len)
 {
-	struct sk_msg *msg = alloc_sk_msg();
+	struct sk_msg *msg = alloc_sk_msg(GFP_ATOMIC);
 	struct sock *sk = psock->sk;
 	int err;
 
-- 
2.38.0.413.g74048e4d9e-goog

