Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8435FBCF1
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 23:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiJKV2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 17:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiJKV2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 17:28:09 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34944A2861
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 14:27:58 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id c24so14407936pls.9
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 14:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k4IDfbeYPOrUaQfGQFEqZ0sBW64WvbtmwcCR7SxhJZM=;
        b=MqcDCPSQ3zNF0n22eUc2bX6fdE0hFnWyvWFbc78oAI+zt1UbF27NZzuWwaVCarh16I
         Z8mi9Wta7oTB0NNmtpYWW7byu4rC8Do/6QHvt4uTnfFPRvyvsMjmSjnzODl01EGBS6cP
         1y21c9IxsmxuZQXiJ5BHm8S6pogr22JQXcswoP5yDv6CKNTnqYs8MrvqSEmKksqe+r5R
         X0fCXTF0E18l00EGWACWGF262LOxkzWGG0CsK/I9S8YgyXEzu2tDkFRzdUsSbfAEw2Rm
         j3LumOx8ILN1UA9sEMa1+5tT+hKw4tZAtTsUkM+P166pl2TGHi/5SGpX/YdEJBPBFLuR
         Ue7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k4IDfbeYPOrUaQfGQFEqZ0sBW64WvbtmwcCR7SxhJZM=;
        b=7mCXW569W8S2QQJH3SUkdnkvs5UVkfDMXV6T6Lu7VPUI61obKa3opxpuiu2nSDaJAn
         +4j77FX919gTkB3QoKQ6+SSixLYiS8nMXYop71IyRk+kWE+rFpM8FUbRHdV0t1/cu7NK
         fhruRngUqzaXhqFhzBULsrPfP66GI2Oy6i1WxeOkufuEIJasSwIZhi7feoMafNdWXYwP
         Lw1d0k6FsH1JOzIONSMDWqrmki9rEU20x9Aiy3eQmakxRSgGaAH1pLGLwdBnP5YTh/yv
         RxRcwtWQKqyvFytiYDBNkIMeivNki7SD4Ie4mdkwt4cUTWtnSm9VvAXi1ykgwH9cMLk5
         YnyQ==
X-Gm-Message-State: ACrzQf2bPegJLoVXcX79RoaFGakCF5wFm4jlfRUxQq4HqbYOe52cKELj
        WTEH38wBsGLa0kPVgCSiQBM=
X-Google-Smtp-Source: AMsMyM513fl8zkMJh13nHN6SVIHEAZ3HS8zLbP8whAUqZm2WW9MiHAQXA6sV/S6stlWAKWY9OhasGg==
X-Received: by 2002:a17:90b:4f45:b0:20d:3282:e5e0 with SMTP id pj5-20020a17090b4f4500b0020d3282e5e0mr1378598pjb.8.1665523662605;
        Tue, 11 Oct 2022 14:27:42 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:245b:b683:5ec3:7a71])
        by smtp.gmail.com with ESMTPSA id ix21-20020a170902f81500b001750792f20asm936592plb.238.2022.10.11.14.27.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 14:27:42 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net 2/2] inet: ping: fix recent breakage
Date:   Tue, 11 Oct 2022 14:27:29 -0700
Message-Id: <20221011212729.3777710-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
In-Reply-To: <20221011212729.3777710-1-eric.dumazet@gmail.com>
References: <20221011212729.3777710-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Blamed commit broke the assumption used by ping sendmsg() that
allocated skb would have MAX_HEADER bytes in skb->head.

This patch changes the way ping works, by making sure
the skb head contains space for the icmp header,
and adjusting ping_getfrag() which was desperate
about going past the icmp header :/

This is adopting what UDP does, mostly.

syzbot is able to crash a host using both kfence and following repro in a loop.

fd = socket(AF_INET6, SOCK_DGRAM, IPPROTO_ICMPV6)
connect(fd, {sa_family=AF_INET6, sin6_port=htons(0), sin6_flowinfo=htonl(0),
		inet_pton(AF_INET6, "::1", &sin6_addr), sin6_scope_id=0}, 28
sendmsg(fd, {msg_name=NULL, msg_namelen=0, msg_iov=[
		{iov_base="\200\0\0\0\23\0\0\0\0\0\0\0\0\0"..., iov_len=65496}],
		msg_iovlen=1, msg_controllen=0, msg_flags=0}, 0

When kfence triggers, skb->head only has 64 bytes, immediately followed
by struct skb_shared_info (no extra headroom based on ksize(ptr))

Then icmpv6_push_pending_frames() is overwriting first bytes
of skb_shinfo(skb), making nr_frags bigger than MAX_SKB_FRAGS,
and/or setting shinfo->gso_size to a non zero value.

If nr_frags is mangled, a crash happens in skb_release_data()

If gso_size is mangled, we have the following report:

lo: caps=(0x00000516401d7c69, 0x00000516401d7c69)
WARNING: CPU: 0 PID: 7548 at net/core/dev.c:3239 skb_warn_bad_offload+0x119/0x230 net/core/dev.c:3239
Modules linked in:
CPU: 0 PID: 7548 Comm: syz-executor268 Not tainted 6.0.0-syzkaller-02754-g557f050166e5 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
RIP: 0010:skb_warn_bad_offload+0x119/0x230 net/core/dev.c:3239
Code: 70 03 00 00 e8 58 c3 24 fa 4c 8d a5 e8 00 00 00 e8 4c c3 24 fa 4c 89 e9 4c 89 e2 4c 89 f6 48 c7 c7 00 53 f5 8a e8 13 ac e7 01 <0f> 0b 5b 5d 41 5c 41 5d 41 5e e9 28 c3 24 fa e8 23 c3 24 fa 48 89
RSP: 0018:ffffc9000366f3e8 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff88807a9d9d00 RCX: 0000000000000000
RDX: ffff8880780c0000 RSI: ffffffff8160f6f8 RDI: fffff520006cde6f
RBP: ffff888079952000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000400 R11: 0000000000000000 R12: ffff8880799520e8
R13: ffff88807a9da070 R14: ffff888079952000 R15: 0000000000000000
FS: 0000555556be6300(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020010000 CR3: 000000006eb7b000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
gso_features_check net/core/dev.c:3521 [inline]
netif_skb_features+0x83e/0xb90 net/core/dev.c:3554
validate_xmit_skb+0x2b/0xf10 net/core/dev.c:3659
__dev_queue_xmit+0x998/0x3ad0 net/core/dev.c:4248
dev_queue_xmit include/linux/netdevice.h:3008 [inline]
neigh_hh_output include/net/neighbour.h:530 [inline]
neigh_output include/net/neighbour.h:544 [inline]
ip6_finish_output2+0xf97/0x1520 net/ipv6/ip6_output.c:134
__ip6_finish_output net/ipv6/ip6_output.c:195 [inline]
ip6_finish_output+0x690/0x1160 net/ipv6/ip6_output.c:206
NF_HOOK_COND include/linux/netfilter.h:291 [inline]
ip6_output+0x1ed/0x540 net/ipv6/ip6_output.c:227
dst_output include/net/dst.h:445 [inline]
ip6_local_out+0xaf/0x1a0 net/ipv6/output_core.c:161
ip6_send_skb+0xb7/0x340 net/ipv6/ip6_output.c:1966
ip6_push_pending_frames+0xdd/0x100 net/ipv6/ip6_output.c:1986
icmpv6_push_pending_frames+0x2af/0x490 net/ipv6/icmp.c:303
ping_v6_sendmsg+0xc44/0x1190 net/ipv6/ping.c:190
inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:819
sock_sendmsg_nosec net/socket.c:714 [inline]
sock_sendmsg+0xcf/0x120 net/socket.c:734
____sys_sendmsg+0x712/0x8c0 net/socket.c:2482
___sys_sendmsg+0x110/0x1b0 net/socket.c:2536
__sys_sendmsg+0xf3/0x1c0 net/socket.c:2565
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f21aab42b89
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 41 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff1729d038 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f21aab42b89
RDX: 0000000000000000 RSI: 0000000020000180 RDI: 0000000000000003
RBP: 0000000000000000 R08: 000000000000000d R09: 000000000000000d
R10: 000000000000000d R11: 0000000000000246 R12: 00007fff1729d050
R13: 00000000000f4240 R14: 0000000000021dd1 R15: 00007fff1729d044
</TASK>

Fixes: 47cf88993c91 ("net: unify alloclen calculation for paged requests")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Lorenzo Colitti <lorenzo@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Maciej Żenczykowski <maze@google.com>
---
 net/ipv4/ping.c | 21 +++++----------------
 net/ipv6/ping.c |  2 +-
 2 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 705672f319e16645d5fe2f333ed00dbd020e1ea2..bde333b24837aef2f23f588210de483540e9f252 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -617,21 +617,9 @@ int ping_getfrag(void *from, char *to,
 {
 	struct pingfakehdr *pfh = from;
 
-	if (offset == 0) {
-		fraglen -= sizeof(struct icmphdr);
-		if (fraglen < 0)
-			BUG();
-		if (!csum_and_copy_from_iter_full(to + sizeof(struct icmphdr),
-			    fraglen, &pfh->wcheck,
-			    &pfh->msg->msg_iter))
-			return -EFAULT;
-	} else if (offset < sizeof(struct icmphdr)) {
-			BUG();
-	} else {
-		if (!csum_and_copy_from_iter_full(to, fraglen, &pfh->wcheck,
-					    &pfh->msg->msg_iter))
-			return -EFAULT;
-	}
+	if (!csum_and_copy_from_iter_full(to, fraglen, &pfh->wcheck,
+					  &pfh->msg->msg_iter))
+		return -EFAULT;
 
 #if IS_ENABLED(CONFIG_IPV6)
 	/* For IPv6, checksum each skb as we go along, as expected by
@@ -842,7 +830,8 @@ static int ping_v4_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	pfh.family = AF_INET;
 
 	err = ip_append_data(sk, &fl4, ping_getfrag, &pfh, len,
-			0, &ipc, &rt, msg->msg_flags);
+			     sizeof(struct icmphdr), &ipc, &rt,
+			     msg->msg_flags);
 	if (err)
 		ip_flush_pending_frames(sk);
 	else
diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index 5f2ef84937142734f1df0d3b20ca1ae60ae5b70e..86c26e48d065a17bf59571c563d3efb25f21fbbf 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -179,7 +179,7 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	lock_sock(sk);
 	err = ip6_append_data(sk, ping_getfrag, &pfh, len,
-			      0, &ipc6, &fl6, rt,
+			      sizeof(struct icmp6hdr), &ipc6, &fl6, rt,
 			      MSG_DONTWAIT);
 
 	if (err) {
-- 
2.38.0.rc1.362.ged0d419d3c-goog

