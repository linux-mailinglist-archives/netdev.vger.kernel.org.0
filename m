Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1404D4BF07F
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 05:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240980AbiBVDWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 22:22:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241386AbiBVDV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 22:21:59 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88AB1193CB
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 19:21:22 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id gi6so7437838pjb.1
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 19:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SUujqcLr9UEzdWSTe25ghQksX8qS3CZxTzLGpT8kqSo=;
        b=Zao/Me2y5Y4cu61C4TLYiOcUQqC9LXufs1JbYn5V90hhUoWhHUB4O+JIZigB2EKrtW
         TWshwYeUBxhe9qa7He27U5If0hCM+iK4Aztjjzm6+vs8niBRG0+UUJPfMlIra86LydlQ
         r9mtQHC84haPM1XawvPIUI9m6r8Brbbe3c0i3Mdp1Sy3Pnqral+8LOUXx5kCVgDmvkL2
         MXpe9CCZGzhsgXK4piKsOiSfB5aIF/MpEnZoJ5TDwasqVUaknjQPVV0hRz+ra1fMO00U
         w/MskEAEzoEVm98sIP0xk8vUFKYIu5XXQKHsiK7uivtK+kHH/Wq0S+r5OidY4oxqx1gG
         KR+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SUujqcLr9UEzdWSTe25ghQksX8qS3CZxTzLGpT8kqSo=;
        b=XwnGEVoF0RFTD5pDNNaNpg3sNt7T4DwR7aUoVAYsh/aVxab6ATuTRy6rP8GqJl6Zbx
         T7yCwyR17E5taR8vNopZJ+jkImDniBP91Ue3EYIf/BwfXqD3BbEQ0VjvuSbOLd/Pg7J4
         mkDU7OxHgCMobUxeiRMbuWKMzBRYDcHC13FDYfKAFCevkwr8dkjJNyFHC55uniAgjkjQ
         iM72mwPG03IahHMjOk0/ZWlDVqV3gKu7jKOLiYTvk0aQS+UMLfmTFABXraKIGBI4DjfG
         5NT/TUE3NFvbqaE8M16BWwxRHGm8AhZTyXsyJaXfjm/zuHHRuVBi2kV947331vbJ8rO8
         lepA==
X-Gm-Message-State: AOAM533+Cy0hmcZZIPaQoC+Xov4+rSld7CaXDN9bb5pNv3AtpZkxPE6I
        TW+gcoCUuwKRRC2SP9OYThs=
X-Google-Smtp-Source: ABdhPJzqRbWxXy/e/7lmDebQrsyqUZV9SCv0BciB7qBg3EjLNIzlxqPZ5jJl9iTZ/QYrSScPn54CuA==
X-Received: by 2002:a17:90b:4a02:b0:1b8:d3c7:7a2b with SMTP id kk2-20020a17090b4a0200b001b8d3c77a2bmr2029643pjb.194.1645500082085;
        Mon, 21 Feb 2022 19:21:22 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f99a:9263:216c:fd72])
        by smtp.gmail.com with ESMTPSA id w198sm14799662pff.96.2022.02.21.19.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 19:21:21 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Marco Elver <elver@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net-next 2/2] net: preserve skb_end_offset() in skb_unclone_keeptruesize()
Date:   Mon, 21 Feb 2022 19:21:13 -0800
Message-Id: <20220222032113.4005821-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
In-Reply-To: <20220222032113.4005821-1-eric.dumazet@gmail.com>
References: <20220222032113.4005821-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

syzbot found another way to trigger the infamous WARN_ON_ONCE(delta < len)
in skb_try_coalesce() [1]

I was able to root cause the issue to kfence.

When kfence is in action, the following assertion is no longer true:

int size = xxxx;
void *ptr1 = kmalloc(size, gfp);
void *ptr2 = kmalloc(size, gfp);

if (ptr1 && ptr2)
	ASSERT(ksize(ptr1) == ksize(ptr2));

We attempted to fix these issues in the blamed commits, but forgot
that TCP was possibly shifting data after skb_unclone_keeptruesize()
has been used, notably from tcp_retrans_try_collapse().

So we not only need to keep same skb->truesize value,
we also need to make sure TCP wont fill new tailroom
that pskb_expand_head() was able to get from a
addr = kmalloc(...) followed by ksize(addr)

Split skb_unclone_keeptruesize() into two parts:

1) Inline skb_unclone_keeptruesize() for the common case,
   when skb is not cloned.

2) Out of line __skb_unclone_keeptruesize() for the 'slow path'.

WARNING: CPU: 1 PID: 6490 at net/core/skbuff.c:5295 skb_try_coalesce+0x1235/0x1560 net/core/skbuff.c:5295
Modules linked in:
CPU: 1 PID: 6490 Comm: syz-executor161 Not tainted 5.17.0-rc4-syzkaller-00229-g4f12b742eb2b #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:skb_try_coalesce+0x1235/0x1560 net/core/skbuff.c:5295
Code: bf 01 00 00 00 0f b7 c0 89 c6 89 44 24 20 e8 62 24 4e fa 8b 44 24 20 83 e8 01 0f 85 e5 f0 ff ff e9 87 f4 ff ff e8 cb 20 4e fa <0f> 0b e9 06 f9 ff ff e8 af b2 95 fa e9 69 f0 ff ff e8 95 b2 95 fa
RSP: 0018:ffffc900063af268 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 00000000ffffffd5 RCX: 0000000000000000
RDX: ffff88806fc05700 RSI: ffffffff872abd55 RDI: 0000000000000003
RBP: ffff88806e675500 R08: 00000000ffffffd5 R09: 0000000000000000
R10: ffffffff872ab659 R11: 0000000000000000 R12: ffff88806dd554e8
R13: ffff88806dd9bac0 R14: ffff88806dd9a2c0 R15: 0000000000000155
FS:  00007f18014f9700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020002000 CR3: 000000006be7a000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 tcp_try_coalesce net/ipv4/tcp_input.c:4651 [inline]
 tcp_try_coalesce+0x393/0x920 net/ipv4/tcp_input.c:4630
 tcp_queue_rcv+0x8a/0x6e0 net/ipv4/tcp_input.c:4914
 tcp_data_queue+0x11fd/0x4bb0 net/ipv4/tcp_input.c:5025
 tcp_rcv_established+0x81e/0x1ff0 net/ipv4/tcp_input.c:5947
 tcp_v4_do_rcv+0x65e/0x980 net/ipv4/tcp_ipv4.c:1719
 sk_backlog_rcv include/net/sock.h:1037 [inline]
 __release_sock+0x134/0x3b0 net/core/sock.c:2779
 release_sock+0x54/0x1b0 net/core/sock.c:3311
 sk_wait_data+0x177/0x450 net/core/sock.c:2821
 tcp_recvmsg_locked+0xe28/0x1fd0 net/ipv4/tcp.c:2457
 tcp_recvmsg+0x137/0x610 net/ipv4/tcp.c:2572
 inet_recvmsg+0x11b/0x5e0 net/ipv4/af_inet.c:850
 sock_recvmsg_nosec net/socket.c:948 [inline]
 sock_recvmsg net/socket.c:966 [inline]
 sock_recvmsg net/socket.c:962 [inline]
 ____sys_recvmsg+0x2c4/0x600 net/socket.c:2632
 ___sys_recvmsg+0x127/0x200 net/socket.c:2674
 __sys_recvmsg+0xe2/0x1a0 net/socket.c:2704
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: c4777efa751d ("net: add and use skb_unclone_keeptruesize() helper")
Fixes: 097b9146c0e2 ("net: fix up truesize of cloned skb in skb_prepare_for_shift()")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Marco Elver <elver@google.com>
---
 include/linux/skbuff.h | 20 +++++++++++---------
 net/core/skbuff.c      | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 115be7f7348759f33bb7a7c77e3341e6fefd3796..36e9f3f6e1b43ee16f0eb5c807aaad60e521d015 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1795,20 +1795,22 @@ static inline int skb_unclone(struct sk_buff *skb, gfp_t pri)
 	return 0;
 }
 
-/* This variant of skb_unclone() makes sure skb->truesize is not changed */
+/* This variant of skb_unclone() makes sure skb->truesize
+ * and skb_end_offset() are not changed, whenever a new skb->head is needed.
+ *
+ * Indeed there is no guarantee that ksize(kmalloc(X)) == ksize(kmalloc(X))
+ * when various debugging features are in place.
+ */
+int __skb_unclone_keeptruesize(struct sk_buff *skb, gfp_t pri);
 static inline int skb_unclone_keeptruesize(struct sk_buff *skb, gfp_t pri)
 {
+
 	might_sleep_if(gfpflags_allow_blocking(pri));
 
-	if (skb_cloned(skb)) {
-		unsigned int save = skb->truesize;
-		int res;
-
-		res = pskb_expand_head(skb, 0, 0, pri);
-		skb->truesize = save;
-		return res;
-	}
+	if (skb_cloned(skb))
+		return __skb_unclone_keeptruesize(skb, pri);
 	return 0;
+
 }
 
 /**
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 27a2296241c9a1b174495cc8f67c4274aec9cca3..725f2b3567698f91f2b0ee9e9b461bcfe07af737 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1787,6 +1787,38 @@ struct sk_buff *skb_realloc_headroom(struct sk_buff *skb, unsigned int headroom)
 }
 EXPORT_SYMBOL(skb_realloc_headroom);
 
+int __skb_unclone_keeptruesize(struct sk_buff *skb, gfp_t pri)
+{
+	unsigned int saved_end_offset, saved_truesize;
+	struct skb_shared_info *shinfo;
+	int res;
+
+	saved_end_offset = skb_end_offset(skb);
+	saved_truesize = skb->truesize;
+
+	res = pskb_expand_head(skb, 0, 0, pri);
+	if (res)
+		return res;
+
+	skb->truesize = saved_truesize;
+
+	if (likely(skb_end_offset(skb) == saved_end_offset))
+		return 0;
+
+	shinfo = skb_shinfo(skb);
+
+	/* We are about to change back skb->end,
+	 * we need to move skb_shinfo() to its new location.
+	 */
+	memmove(skb->head + saved_end_offset,
+		shinfo,
+		offsetof(struct skb_shared_info, frags[shinfo->nr_frags]));
+
+	skb_set_end_offset(skb, saved_end_offset);
+
+	return 0;
+}
+
 /**
  *	skb_expand_head - reallocate header of &sk_buff
  *	@skb: buffer to reallocate
-- 
2.35.1.473.g83b2b277ed-goog

