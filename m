Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8D0441CB0A
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 19:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344601AbhI2R1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 13:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344525AbhI2R1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 13:27:00 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F035C06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 10:25:19 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id h4-20020a05620a244400b004334ede5036so10256249qkn.13
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 10:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=iAHVRqgozoYYpjblOI/kZSepQ+x+Hd8y/EKzWq06DbY=;
        b=m1CaQAzy2Jdcn3/3CNuFvK0NkM7WFAZwf1g+bHdx+8sSHAEEqFrkKfiFXKW9u1QNIl
         n61uy4KlA4LJX5IhqBT11fyJ+LdCoMAFxX12HqY3uWbPNpPwy3vuo7Av76IrEQW+Y2Nx
         jzepVFLAyZH8Sbjrgsh/onXA1TGyLS0HX1+5IYu/8o4/yipSDeOKkpcLQo/4AJiGeHZi
         L+/bovsIuhgXFcaSZgyldxfWNJ1oai1h3r3u4k8R0IaqJ0iLopAZIbcc1XOtQEC7k92u
         0wNzxEJkKld1y9Vlqob3i3b1Lckkvqc94vVae4WMg1OMQ9pUEwX774puG8HmPFj+dQwS
         S4oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=iAHVRqgozoYYpjblOI/kZSepQ+x+Hd8y/EKzWq06DbY=;
        b=hbvYlZd9ZCKsr/oAMyvq/NQorUpGbJCZNCOEaCyKcSNuFI7E9BKPsBQHeBHk+EUrl7
         tHsLab/Nku3irZz6GVhF8ipErPOVWHTRUqPe+jjTx+d6We2qQPGuCrjDe7UF46b247WQ
         9MABUAPI/fu+0t1/cmKNI3koUC+/DMD8Nd3k0OYX8SUq6r4ww+TA0tgX2cArbpWkOB4R
         S7iQxFno88vusfaZh0gOA2qdNOO1wpbRFKoxfeyFVx+sroWRIs3NTbhpREZOJKwIOYUE
         LtaxUSskIYwnqK64H1R8Aq4/CPl5I+PrvwuKDf4S5Jz54yJtBWL3X7yoqn9QQtbGbbI4
         UlvQ==
X-Gm-Message-State: AOAM530uIwifKgreyu4ghYFZEO5pKBAhFrIiuKqc4Xm9Tl2gX7cyB7+W
        idh+dCwhKTVB4fDtOyerdH0s3S0faJQ=
X-Google-Smtp-Source: ABdhPJwsBycipuI9jSfQLa7i6b0U2tjqMnG7hNBlpe5TkR9rDT/iBPbFrKWA55ygDlyDtwNix6iRoeZvBGk=
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:a9d9:bcda:fa5:99c6])
 (user=weiwan job=sendgmr) by 2002:ad4:43c6:: with SMTP id o6mr855288qvs.12.1632936318335;
 Wed, 29 Sep 2021 10:25:18 -0700 (PDT)
Date:   Wed, 29 Sep 2021 10:25:12 -0700
In-Reply-To: <20210929172513.3930074-1-weiwan@google.com>
Message-Id: <20210929172513.3930074-3-weiwan@google.com>
Mime-Version: 1.0
References: <20210929172513.3930074-1-weiwan@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v3 net-next 2/3] tcp: adjust sndbuf according to sk_reserved_mem
From:   Wei Wang <weiwan@google.com>
To:     "'David S . Miller'" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Shakeel Butt <shakeelb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If user sets SO_RESERVE_MEM socket option, in order to fully utilize the
reserved memory in memory pressure state on the tx path, we modify the
logic in sk_stream_moderate_sndbuf() to set sk_sndbuf according to
available reserved memory, instead of MIN_SOCK_SNDBUF, and adjust it
when new data is acked.

Signed-off-by: Wei Wang <weiwan@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com> 
---
 include/net/sock.h   |  1 +
 net/ipv4/tcp_input.c | 14 ++++++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 447fddb384a4..c3af696258fe 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2378,6 +2378,7 @@ static inline void sk_stream_moderate_sndbuf(struct sock *sk)
 		return;
 
 	val = min(sk->sk_sndbuf, sk->sk_wmem_queued >> 1);
+	val = max_t(u32, val, sk_unused_reserved_mem(sk));
 
 	WRITE_ONCE(sk->sk_sndbuf, max_t(u32, val, SOCK_MIN_SNDBUF));
 }
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 53675e284841..06020395cc8d 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5380,7 +5380,7 @@ static int tcp_prune_queue(struct sock *sk)
 	return -1;
 }
 
-static bool tcp_should_expand_sndbuf(const struct sock *sk)
+static bool tcp_should_expand_sndbuf(struct sock *sk)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
 
@@ -5391,8 +5391,18 @@ static bool tcp_should_expand_sndbuf(const struct sock *sk)
 		return false;
 
 	/* If we are under global TCP memory pressure, do not expand.  */
-	if (tcp_under_memory_pressure(sk))
+	if (tcp_under_memory_pressure(sk)) {
+		int unused_mem = sk_unused_reserved_mem(sk);
+
+		/* Adjust sndbuf according to reserved mem. But make sure
+		 * it never goes below SOCK_MIN_SNDBUF.
+		 * See sk_stream_moderate_sndbuf() for more details.
+		 */
+		if (unused_mem > SOCK_MIN_SNDBUF)
+			WRITE_ONCE(sk->sk_sndbuf, unused_mem);
+
 		return false;
+	}
 
 	/* If we are under soft global TCP memory pressure, do not expand.  */
 	if (sk_memory_allocated(sk) >= sk_prot_mem_limits(sk, 0))
-- 
2.33.0.685.g46640cef36-goog

