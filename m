Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2644A90ED
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 23:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243088AbiBCWzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 17:55:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238236AbiBCWzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 17:55:52 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B350C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 14:55:52 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id j16so3518109plx.4
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 14:55:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=otjxgyJ8DzTJqghxp7XZI9W3AlAtUB0pFwVu699GQdo=;
        b=ekzKCQQ361f2FGWIaZdgNPHUci955FpzBeMRyuBl8BJV2q/MLkv7Je7MFDc3utNNrX
         roiWdTpWeYcNAW6AoFRvBqFobv8bRxKVJ2DMfux78cSymmdN+0cTD0qyMVIIw//Y61+x
         3MgR8VNvwdznickuzQO9b7MuZT2fM3fiBORzvHXO6DFsefhQpOBVaPoSZHrqws+2JgkZ
         g4nlv7xunjzcTNbdNnNKzF1W5s9IS0+oHYVOzOUY91z5Ule139vxv4l9ru53ffCzfWIv
         5RmobA973B6FLSDRbjwH4pHQN3FDZnkpd79wspCkbzzfPlncr4+NzBx9O5TxLxsqETSI
         XvIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=otjxgyJ8DzTJqghxp7XZI9W3AlAtUB0pFwVu699GQdo=;
        b=WK+moy6zuRh1K5vXVlsdSGDFq+CtR46VhH5zXnp4SN+Urv3Znp2DEz4Umhd9fUvT4G
         3wFlAmrPv8bHyBnqkOBexEBCfGomGTqRDCpW+0/6TXsh5IjDaKpmu/+jQs+2D+p5GuOI
         ODPeboR2xf7vRdkkXUqR3djeLmh/oaV4u+zuDo64Mbc3R5eeKPVf4XL5+tEHFRJvIpXG
         2l/F+0XWjYKg52AO1JnHNlCMeOw/95GpVSwbWAnhNj286gGrN/9GQVwSUcoar9C9Ah93
         f9jeoHSzfD7T6YkJAWBUO3ln5qDdgQntOTTs4Wgq22WPTRQGKhXJMD1rsX/SrnyrxDV6
         ursQ==
X-Gm-Message-State: AOAM532gA6eicJTYFZ6eUbP3cMrRhkq0lSp0IPpBVWlG8WeQ5w9bMUov
        78d0Vb/OnvOzEB8V2xQgaKtgLnZg62A=
X-Google-Smtp-Source: ABdhPJxeOgJSWt8jBRJ0eSehtb5gJPkZDjkJjSqxudt0e8NPQ9y81tajMVJKdhIcywE1SsEuxsqmPg==
X-Received: by 2002:a17:90b:3eca:: with SMTP id rm10mr12244623pjb.211.1643928951693;
        Thu, 03 Feb 2022 14:55:51 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b3be:296f:182e:18d5])
        by smtp.gmail.com with ESMTPSA id j14sm55228pfj.218.2022.02.03.14.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 14:55:51 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Talal Ahmad <talalahmad@google.com>,
        Arjun Roy <arjunroy@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Subject: [PATCH net] tcp: take care of mixed splice()/sendmsg(MSG_ZEROCOPY) case
Date:   Thu,  3 Feb 2022 14:55:47 -0800
Message-Id: <20220203225547.665114-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

syzbot found that mixing sendpage() and sendmsg(MSG_ZEROCOPY)
calls over the same TCP socket would again trigger the
infamous warning in inet_sock_destruct()

	WARN_ON(sk_forward_alloc_get(sk));

While Talal took into account a mix of regular copied data
and MSG_ZEROCOPY one in the same skb, the sendpage() path
has been forgotten.

We want the charging to happen for sendpage(), because
pages could be coming from a pipe. What is missing is the
downgrading of pure zerocopy status to make sure
sk_forward_alloc will stay synced.

Add tcp_downgrade_zcopy_pure() helper so that we can
use it from the two callers.

Fixes: 9b65b17db723 ("net: avoid double accounting for pure zerocopy skbs")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Talal Ahmad <talalahmad@google.com>
Cc: Arjun Roy <arjunroy@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
---
 net/ipv4/tcp.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index bdf108f544a45a2aa24bc962fb81dfd0ca1e0682..e1f259da988df7493ce7d71ad8743ec5025e4e7c 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -937,6 +937,22 @@ void tcp_remove_empty_skb(struct sock *sk)
 	}
 }
 
+/* skb changing from pure zc to mixed, must charge zc */
+static int tcp_downgrade_zcopy_pure(struct sock *sk, struct sk_buff *skb)
+{
+	if (unlikely(skb_zcopy_pure(skb))) {
+		u32 extra = skb->truesize -
+			    SKB_TRUESIZE(skb_end_offset(skb));
+
+		if (!sk_wmem_schedule(sk, extra))
+			return ENOMEM;
+
+		sk_mem_charge(sk, extra);
+		skb_shinfo(skb)->flags &= ~SKBFL_PURE_ZEROCOPY;
+	}
+	return 0;
+}
+
 static struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
 				      struct page *page, int offset, size_t *size)
 {
@@ -972,7 +988,7 @@ static struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
 		tcp_mark_push(tp, skb);
 		goto new_segment;
 	}
-	if (!sk_wmem_schedule(sk, copy))
+	if (tcp_downgrade_zcopy_pure(sk, skb) || !sk_wmem_schedule(sk, copy))
 		return NULL;
 
 	if (can_coalesce) {
@@ -1320,19 +1336,8 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 
 			copy = min_t(int, copy, pfrag->size - pfrag->offset);
 
-			/* skb changing from pure zc to mixed, must charge zc */
-			if (unlikely(skb_zcopy_pure(skb))) {
-				u32 extra = skb->truesize -
-					    SKB_TRUESIZE(skb_end_offset(skb));
-
-				if (!sk_wmem_schedule(sk, extra))
-					goto wait_for_space;
-
-				sk_mem_charge(sk, extra);
-				skb_shinfo(skb)->flags &= ~SKBFL_PURE_ZEROCOPY;
-			}
-
-			if (!sk_wmem_schedule(sk, copy))
+			if (tcp_downgrade_zcopy_pure(sk, skb) ||
+			    !sk_wmem_schedule(sk, copy))
 				goto wait_for_space;
 
 			err = skb_copy_to_page_nocache(sk, &msg->msg_iter, skb,
-- 
2.35.0.263.gb82422642f-goog

