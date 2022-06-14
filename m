Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB9E54B779
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 19:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245219AbiFNRRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 13:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343936AbiFNRRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 13:17:44 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7942A94F
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 10:17:42 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id i1so8287085plg.7
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 10:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I10loRCx1v/FiORX/MxdDpDS1tHCZbVNhB/v5HsfQsg=;
        b=nP85rZjTtglIB1tg5HRFfEC6aaTGv7i8+k1jX6oth5ng+NoK+7ET7OIYe5i606NzH4
         kr8aRuYSqYOTdmFQXoEaX+6pXF+yWGD6XWGBiZxYJF5mzYBeS8xPuk0WCGUFv0o7PQ+W
         yjfKOhm3RsWAxnwlcCTaKeOcfvWJ0V5+p7vVZuv9xh0/tllbY4smh1ifEddJ4/IySdTy
         8/GaTfm2dmGpbDBQZ53MId0McJx9DPPL5p6q1S4FMy7hSIVfaUeFzQgksbpiKCrXKp3w
         iQP1hqMfehFduANsqqoWvy/NFTSCw8Qpcl3RQ7YWI7MpgB9qHUt1dPLDeBuZyGPPlqF8
         Bbxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I10loRCx1v/FiORX/MxdDpDS1tHCZbVNhB/v5HsfQsg=;
        b=o/WJ7pOs3aYULoyei8+2o9rf7LHZuRTe2/9Qa++VL3hWAJMOCsW7FwIoE0CU2pzwfp
         VlomhdNCLhH2QUtY4eDT52SHbFc2XqFFF71zuX6w+yu1y7gVjw4sgDtcjEmPoYDdLR1H
         ducI2GFLYUh4MPM8/RrPaNtVfTNx5w+ydo2BgdYEOthu2DT1k1GzQbf+dPhkGzADvY99
         IqYFRk1m9yPr7MG0BuK98V0Ey50P66WF4lzaFgUwu2XDCNmSYwHrpmbMy8/g4lXRHs+f
         qrSJ6mXYjjdphu5uxyFCHTCtjNiL4RunhYu8uokLFzW0TQ2ZQkRC92JQfs7Jyji3//ke
         4zyg==
X-Gm-Message-State: AJIora8fmeKp/MBMZIuu0PuX1H2dUH2YzUyf2c70ecKXbf3ryIhUMLZ+
        WemJ2cK98DTdp5sgnCGEY5s=
X-Google-Smtp-Source: AGRyM1vfiC8kmsMJO9Wiv45Vezkc6/7qS++vJ01FvHkqg1W9LZO6N10al4o+comsRvRSn0ZUwZ2UZw==
X-Received: by 2002:a17:903:1211:b0:15e:8208:8cc0 with SMTP id l17-20020a170903121100b0015e82088cc0mr5551713plh.52.1655227062401;
        Tue, 14 Jun 2022 10:17:42 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:2dbb:8c54:2434:5ada])
        by smtp.gmail.com with ESMTPSA id d20-20020a170902e15400b00168c523032fsm7435883pla.269.2022.06.14.10.17.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 10:17:42 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 2/2] tcp: fix possible freeze in tx path under memory pressure
Date:   Tue, 14 Jun 2022 10:17:34 -0700
Message-Id: <20220614171734.1103875-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
In-Reply-To: <20220614171734.1103875-1-eric.dumazet@gmail.com>
References: <20220614171734.1103875-1-eric.dumazet@gmail.com>
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

Blamed commit only dealt with applications issuing small writes.

Issue here is that we allow to force memory schedule for the sk_buff
allocation, but we have no guarantee that sendmsg() is able to
copy some payload in it.

In this patch, I make sure the socket can use up to tcp_wmem[0] bytes.

For example, if we consider tcp_wmem[0] = 4096 (default on x86),
and initial skb->truesize being 1280, tcp_sendmsg() is able to
copy up to 2816 bytes under memory pressure.

Before this patch a sendmsg() sending more than 2816 bytes
would either block forever (if persistent memory pressure),
or return -EAGAIN.

For bigger MTU networks, it is advised to increase tcp_wmem[0]
to avoid sending too small packets.

v2: deal with zero copy paths.

Fixes: 8e4d980ac215 ("tcp: fix behavior for epoll edge trigger")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 14ebb4ec4a51f3c55501aa53423ce897599e8637..56083c2497f0b695c660256aa43f8a743d481697 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -951,6 +951,23 @@ static int tcp_downgrade_zcopy_pure(struct sock *sk, struct sk_buff *skb)
 	return 0;
 }
 
+static int tcp_wmem_schedule(struct sock *sk, int copy)
+{
+	int left;
+
+	if (likely(sk_wmem_schedule(sk, copy)))
+		return copy;
+
+	/* We could be in trouble if we have nothing queued.
+	 * Use whatever is left in sk->sk_forward_alloc and tcp_wmem[0]
+	 * to guarantee some progress.
+	 */
+	left = sock_net(sk)->ipv4.sysctl_tcp_wmem[0] - sk->sk_wmem_queued;
+	if (left > 0)
+		sk_forced_mem_schedule(sk, min(left, copy));
+	return min(copy, sk->sk_forward_alloc);
+}
+
 static struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
 				      struct page *page, int offset, size_t *size)
 {
@@ -986,7 +1003,11 @@ static struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
 		tcp_mark_push(tp, skb);
 		goto new_segment;
 	}
-	if (tcp_downgrade_zcopy_pure(sk, skb) || !sk_wmem_schedule(sk, copy))
+	if (tcp_downgrade_zcopy_pure(sk, skb))
+		return NULL;
+
+	copy = tcp_wmem_schedule(sk, copy);
+	if (!copy)
 		return NULL;
 
 	if (can_coalesce) {
@@ -1334,8 +1355,11 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 
 			copy = min_t(int, copy, pfrag->size - pfrag->offset);
 
-			if (tcp_downgrade_zcopy_pure(sk, skb) ||
-			    !sk_wmem_schedule(sk, copy))
+			if (tcp_downgrade_zcopy_pure(sk, skb))
+				goto wait_for_space;
+
+			copy = tcp_wmem_schedule(sk, copy);
+			if (!copy)
 				goto wait_for_space;
 
 			err = skb_copy_to_page_nocache(sk, &msg->msg_iter, skb,
@@ -1362,7 +1386,8 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 				skb_shinfo(skb)->flags |= SKBFL_PURE_ZEROCOPY;
 
 			if (!skb_zcopy_pure(skb)) {
-				if (!sk_wmem_schedule(sk, copy))
+				copy = tcp_wmem_schedule(sk, copy);
+				if (!copy)
 					goto wait_for_space;
 			}
 
-- 
2.36.1.476.g0c4daa206d-goog

