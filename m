Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C524E6CAC5E
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbjC0Ryx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbjC0Ryw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:54:52 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A79E10E;
        Mon, 27 Mar 2023 10:54:51 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id cu12so6226606pfb.13;
        Mon, 27 Mar 2023 10:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679939691;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OpJzN70oPUzh0zn7YxxB2eKnGbh8qoYQfWsq6BBmv1Y=;
        b=KiR3a+Uwx2hSg4HBAA4OZ7g2fyB2HRivC6HzjPg4Wn86I9dIGtIg0F8FHJOcLqwfUA
         NQerfiyi1GvhNTM+3bEZjnJNFRnnPxNXLj+umeUSNc20/O2D54oPhu4v3fxsLsHdmJF2
         9+g/4rB4aDPt+LMKci9BMh3w5tVI6dvcP6c0KyBqgBH7NUfwf7ul+ejUgMp2EptF62OP
         Dgr9JJhPwD5f1OagBrRlsWVi34ykEomzvvo3z7sLfuWEb8+7rRKu+aDS9beBMAfQM5IV
         El7I91p+x/JmQcK1pHCgAV4f+bYBTQ5FywcWNfTSq+9nZJRmKNuqwTg+vMCsCdV/BdVY
         wgZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679939691;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OpJzN70oPUzh0zn7YxxB2eKnGbh8qoYQfWsq6BBmv1Y=;
        b=zTqKwq+p1k7kAIPFlVp/aHoaEySj8NNu0VGt9WR02SF8zZVL3JdX68D80ZTCpYy9Tb
         p6exoTUbTzM3G2cB9CEzpBjIb/TMOOFWGdEnRbdHoel5emAqrWqcjeT3Gbxgn++BesM4
         fnaoMN7OjwmpRh2Em0jtLWdHrRjrrQ3SsjhkEtYDnfXs7oON4p2dUUS1QUasY/AyGuJ2
         snqqt/Bp0iYTAvufcbAOPe/Bhz8peoVSBgBre/m2pl/hDJehwc1Lm24REk/BrZkayAin
         qkBbDjaLGR/P2PWGg45yGg11K/WlSmwHxTKlBbn9x/80qvhWqcoTWscQQ6Cj7hQA/61S
         10ww==
X-Gm-Message-State: AAQBX9fw+AB5/h9r5EZ3fZJCPekjN3L92iQbawCPbkiCqdccLjOBE/qU
        hvi6VO5meqhP5wAFl24vm4w=
X-Google-Smtp-Source: AKy350aDMh9p3JyXABfEU8CulMMukL4hDd1TxZHOuzrm37kSO5xD2lOfh/vdj0kIcMs5BrDsNaxyMw==
X-Received: by 2002:aa7:9477:0:b0:628:0:7939 with SMTP id t23-20020aa79477000000b0062800007939mr13282813pfq.26.1679939690781;
        Mon, 27 Mar 2023 10:54:50 -0700 (PDT)
Received: from john.lan ([98.97.117.131])
        by smtp.gmail.com with ESMTPSA id r1-20020a62e401000000b005a8ba70315bsm19408316pfh.6.2023.03.27.10.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 10:54:50 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     cong.wang@bytedance.com, jakub@cloudflare.com,
        daniel@iogearbox.net, lmb@isovalent.com, edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v2 01/12] bpf: sockmap, pass skb ownership through read_skb
Date:   Mon, 27 Mar 2023 10:54:35 -0700
Message-Id: <20230327175446.98151-2-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230327175446.98151-1-john.fastabend@gmail.com>
References: <20230327175446.98151-1-john.fastabend@gmail.com>
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
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c   | 2 --
 net/ipv4/tcp.c     | 1 -
 net/ipv4/udp.c     | 5 +----
 net/unix/af_unix.c | 5 +----
 4 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 53d0251788aa..2b6d9519ff29 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -1180,8 +1180,6 @@ static int sk_psock_verdict_recv(struct sock *sk, struct sk_buff *skb)
 	int ret = __SK_DROP;
 	int len = skb->len;
 
-	skb_get(skb);
-
 	rcu_read_lock();
 	psock = sk_psock(sk);
 	if (unlikely(!psock)) {
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 33f559f491c8..6572962b0237 100644
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
index 9592fe3e444a..04e8c6385246 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
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
index f0c2293f1d3b..a5dd2ee0cfed 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2554,10 +2554,7 @@ static int unix_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
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

