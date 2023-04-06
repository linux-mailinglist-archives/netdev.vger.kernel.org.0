Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD4E66D8C4A
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 03:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234159AbjDFBBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 21:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233483AbjDFBBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 21:01:02 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B9AB7D9A;
        Wed,  5 Apr 2023 18:00:38 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id o2so36070101plg.4;
        Wed, 05 Apr 2023 18:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680742837; x=1683334837;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=huaGQx94IhqjlpBZz9Dh/6dEAcqnZNQFnDotU/ZG3V0=;
        b=g0ySK+0rDy11T7CsDufcbcB12QlsNgyf8p0q2PZ+vsaqwv5dJ5ByKx3FA+6Vlg1SLF
         3Df3W4em1ygeqgaxUqoSWFoSRPAZJYu9bGGYu9OJmKxeu5yaYp+qcbPD+BOy55M0aIDc
         Pk4VpPlyMMxj87YTAiLQrS1YRO/RItUFI4b7q6m+zaHWYuGQ+NIU1UgiYP3zli1/P+6w
         HxI98JDly/RPki7GG9sQmXuVQv2fj213ZrZH3+p/XwlAjpiEJLJdK2LirdFknrFFBJFT
         s7LjCXjTD1soHgok+WVJlNRFQPx/jzU6bUZM9c/9c+Kh8oZD6mcmWXbSWpWQBRtOGWMs
         MGIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680742837; x=1683334837;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=huaGQx94IhqjlpBZz9Dh/6dEAcqnZNQFnDotU/ZG3V0=;
        b=nrtHkxPzYnM1FuorQxmUYyG8/Obn7xoISroBef5nTHOuEXQ2AFaWaC06i2iZuQdi/M
         XM4NWuIZu7BDgQOudjxlLnHlbDErZo33zM9UpAXZit67TRTZ/Wu+fdr1VxQwIvr5+7g/
         vKt0fTo6E0/MWTSYWbkjNrsBsMOIPeTscid1GHS/pqPux43v5wG33ZnvHH1np6Rfw/br
         OOVqoyVx2nt7s0xnRYhFsXxn2ke597+OlBchXot6FZPxQ1+ruSfyVMFxkynb0rBkuc5V
         FulW+utjIjsiirddpiPO+lUDhpLfTY2n0hmjvOe1++ErgqabLJ7j7HCmqNl3unoaSNbo
         9PVA==
X-Gm-Message-State: AAQBX9dxwchoj9MXEZluAmbyJP1pmmOi4AtVVFOMh9mnwGbHmPm1Gr9A
        VDmjN+92qDUFZ2lxDdL3nik=
X-Google-Smtp-Source: AKy350a8lRiTZR8CnsE6ag9lO2woYqrP4qd+GPaqoqV5s+EjQlNTLwQU9cN/tAOaDm7f85KcRpL0Zw==
X-Received: by 2002:a05:6a20:af94:b0:d4:979a:e31c with SMTP id ds20-20020a056a20af9400b000d4979ae31cmr846166pzb.62.1680742836969;
        Wed, 05 Apr 2023 18:00:36 -0700 (PDT)
Received: from john.lan ([98.97.117.85])
        by smtp.gmail.com with ESMTPSA id c14-20020aa78c0e000000b0062c0c3da6b8sm35377pfd.13.2023.04.05.18.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 18:00:36 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v5 01/12] bpf: sockmap, pass skb ownership through read_skb
Date:   Wed,  5 Apr 2023 18:00:20 -0700
Message-Id: <20230406010031.3354-2-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230406010031.3354-1-john.fastabend@gmail.com>
References: <20230406010031.3354-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The read_skb hook calls consume_skb() now, but this means that if the
recv_actor program wants to use the skb it needs to inc the ref cnt
so that the consume_skb() doesn't kfree the sk_buff.

This is problematic because in some error cases under memory pressure
we may need to linearize the sk_buff from sk_psock_skb_ingress_enqueue().
Then we get this,

 skb_linearize()
   __pskb_pull_tail()
     pskb_expand_head()
       BUG_ON(skb_shared(skb))

Because we incremented users refcnt from sk_psock_verdict_recv() we
hit the bug on with refcnt > 1 and trip it.

To fix lets simply pass ownership of the sk_buff through the skb_read
call. Then we can drop the consume from read_skb handlers and assume
the verdict recv does any required kfree.

Bug found while testing in our CI which runs in VMs that hit memory
constraints rather regularly. William tested TCP read_skb handlers.

[  106.536188] ------------[ cut here ]------------
[  106.536197] kernel BUG at net/core/skbuff.c:1693!
[  106.536479] invalid opcode: 0000 [#1] PREEMPT SMP PTI
[  106.536726] CPU: 3 PID: 1495 Comm: curl Not tainted 5.19.0-rc5 #1
[  106.537023] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ArchLinux 1.16.0-1 04/01/2014
[  106.537467] RIP: 0010:pskb_expand_head+0x269/0x330
[  106.538585] RSP: 0018:ffffc90000138b68 EFLAGS: 00010202
[  106.538839] RAX: 000000000000003f RBX: ffff8881048940e8 RCX: 0000000000000a20
[  106.539186] RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffff8881048940e8
[  106.539529] RBP: ffffc90000138be8 R08: 00000000e161fd1a R09: 0000000000000000
[  106.539877] R10: 0000000000000018 R11: 0000000000000000 R12: ffff8881048940e8
[  106.540222] R13: 0000000000000003 R14: 0000000000000000 R15: ffff8881048940e8
[  106.540568] FS:  00007f277dde9f00(0000) GS:ffff88813bd80000(0000) knlGS:0000000000000000
[  106.540954] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  106.541227] CR2: 00007f277eeede64 CR3: 000000000ad3e000 CR4: 00000000000006e0
[  106.541569] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  106.541915] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  106.542255] Call Trace:
[  106.542383]  <IRQ>
[  106.542487]  __pskb_pull_tail+0x4b/0x3e0
[  106.542681]  skb_ensure_writable+0x85/0xa0
[  106.542882]  sk_skb_pull_data+0x18/0x20
[  106.543084]  bpf_prog_b517a65a242018b0_bpf_skskb_http_verdict+0x3a9/0x4aa9
[  106.543536]  ? migrate_disable+0x66/0x80
[  106.543871]  sk_psock_verdict_recv+0xe2/0x310
[  106.544258]  ? sk_psock_write_space+0x1f0/0x1f0
[  106.544561]  tcp_read_skb+0x7b/0x120
[  106.544740]  tcp_data_queue+0x904/0xee0
[  106.544931]  tcp_rcv_established+0x212/0x7c0
[  106.545142]  tcp_v4_do_rcv+0x174/0x2a0
[  106.545326]  tcp_v4_rcv+0xe70/0xf60
[  106.545500]  ip_protocol_deliver_rcu+0x48/0x290
[  106.545744]  ip_local_deliver_finish+0xa7/0x150

Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
Reported-by: William Findlay <will@isovalent.com>
Tested-by: William Findlay <will@isovalent.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c   | 2 --
 net/ipv4/tcp.c     | 1 -
 net/ipv4/udp.c     | 7 ++-----
 net/unix/af_unix.c | 7 ++-----
 4 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index f81883759d38..4a3dc8d27295 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -1183,8 +1183,6 @@ static int sk_psock_verdict_recv(struct sock *sk, struct sk_buff *skb)
 	int ret = __SK_DROP;
 	int len = skb->len;
 
-	skb_get(skb);
-
 	rcu_read_lock();
 	psock = sk_psock(sk);
 	if (unlikely(!psock)) {
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 288693981b00..1be305e3d3c7 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1770,7 +1770,6 @@ int tcp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 		WARN_ON_ONCE(!skb_set_owner_sk_safe(skb, sk));
 		tcp_flags = TCP_SKB_CB(skb)->tcp_flags;
 		used = recv_actor(sk, skb);
-		consume_skb(skb);
 		if (used < 0) {
 			if (!copied)
 				copied = used;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index c605d171eb2d..8aaae82e78ae 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1813,7 +1813,7 @@ EXPORT_SYMBOL(__skb_recv_udp);
 int udp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 {
 	struct sk_buff *skb;
-	int err, copied;
+	int err;
 
 try_again:
 	skb = skb_recv_udp(sk, MSG_DONTWAIT, &err);
@@ -1832,10 +1832,7 @@ int udp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 	}
 
 	WARN_ON_ONCE(!skb_set_owner_sk_safe(skb, sk));
-	copied = recv_actor(sk, skb);
-	kfree_skb(skb);
-
-	return copied;
+	return recv_actor(sk, skb);
 }
 EXPORT_SYMBOL(udp_read_skb);
 
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 0b0f18ecce44..bb34852bf947 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2553,7 +2553,7 @@ static int unix_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 {
 	struct unix_sock *u = unix_sk(sk);
 	struct sk_buff *skb;
-	int err, copied;
+	int err;
 
 	mutex_lock(&u->iolock);
 	skb = skb_recv_datagram(sk, MSG_DONTWAIT, &err);
@@ -2561,10 +2561,7 @@ static int unix_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 	if (!skb)
 		return err;
 
-	copied = recv_actor(sk, skb);
-	kfree_skb(skb);
-
-	return copied;
+	return recv_actor(sk, skb);
 }
 
 /*
-- 
2.33.0

