Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B29F639EA45
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 01:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhFGXpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 19:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbhFGXpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 19:45:13 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7412AC061574
        for <netdev@vger.kernel.org>; Mon,  7 Jun 2021 16:43:16 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id v11so1136659ply.6
        for <netdev@vger.kernel.org>; Mon, 07 Jun 2021 16:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2E1Q0F8ylqPOOQuk5XAq2joum+NYJvYjkGmbCi8++CM=;
        b=mBr7T5eLNw7KFVJsiPJ3K4OrZQH9obNvi4+RPeCrhJuoYmvZQsOLd3s37NeYXV3Z/Y
         fUjHvcyB2ni5H0IazC35+eaKjRM8srQotgbOJutwcNCMBTT3iQitbRw+kyrcXWt3BxE7
         7JJ6DyQuMbm/RJr3KI953Kc4ITieVDD4eN4Rd+EVSgXVIc8xk9SJtzOhSFIqoXg5ADHy
         MdxPCn5rmUO+Qc+PLLXEb8YEYKOMFeSVgA4s4n5jOGEL9SCIunu7RjeDF6eaOXD1W4Ex
         SBBydEHZovrqVEaXlXxpDEPUvZSO9vyT2WuliljNytYKir/6XtaBrnN2yeVLLRcg8F2X
         eKhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2E1Q0F8ylqPOOQuk5XAq2joum+NYJvYjkGmbCi8++CM=;
        b=mo2emdI/aaz0fE2JNV3agzQKT9cQMmL6ENsYuhpBSszwIU0NvRAYJ7utBmHlobkZPp
         3uEEPNALx+lg0IiF7x62AcrF6uPjKSoRnOIoWbpI0jjWwRQlekhKkl1lCFFVsH9MT5aw
         7hDBNDGbu5cQCIj7cyGAcARa8vzM1eDQHcVyktjIHjYLQqCd7ts+vsdxDbJPti9MVEYr
         g7/X/XfEJeP9bP+xyhVQKTGdNKUsUMjsjaGZLavFN1t8OooezPAnaK4KOZvQ1gStvs7W
         o/VS5O7JOvJeSgK2Dh0kKOzmPXXNjRTIHhh0EIFS+wB0alLorgTkk2Ezgwd3mtnG/7fJ
         rCdA==
X-Gm-Message-State: AOAM531JuFBkRpfS+X7xRYGLRoDqAkhulUsnSxB7lQa/1xYWKKyAr01T
        nmwV1bH0ke0G0OskSvSaDJk=
X-Google-Smtp-Source: ABdhPJxbpZ2EekRbY85lfKb8rDuF8dVuEHv9WaziNGyJCHCf5b/cp+OJ3+cjm7KFpvQtWS9tvIHl/A==
X-Received: by 2002:a17:90b:1991:: with SMTP id mv17mr16718540pjb.109.1623109395958;
        Mon, 07 Jun 2021 16:43:15 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:34c3:22d8:b92a:ddfa])
        by smtp.gmail.com with ESMTPSA id o7sm10125120pgs.45.2021.06.07.16.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 16:43:15 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] ipv6: ensure ip6_dst_mtu_forward() returns at least IPV6_MIN_MTU
Date:   Mon,  7 Jun 2021 16:43:07 -0700
Message-Id: <20210607234307.3375806-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

ip6_dst_mtu_forward() has just two call sites, one of which already
enforces the minimum mtu (which we can now remove), but it does
materially affect the other (presumably buggy) call site in:
  net/netfilter/nf_flow_table_core.c
  flow_offload_fill_route()

Cc: David S. Miller <davem@davemloft.net>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: David Ahern <dsahern@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 include/net/ip6_route.h | 4 ++--
 net/ipv6/ip6_output.c   | 2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 9dd3c75a4d62..e01364c0821d 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -315,14 +315,14 @@ static inline unsigned int ip6_dst_mtu_forward(const struct dst_entry *dst)
 	unsigned int mtu = dst_metric_raw(dst, RTAX_MTU);
 
 	if (mtu)
-		return mtu;
+		return max_t(unsigned int, mtu, IPV6_MIN_MTU);
 
 	rcu_read_lock();
 	idev = __in6_dev_get(dst->dev);
 	mtu = idev ? idev->cnf.mtu6 : IPV6_MIN_MTU;
 	rcu_read_unlock();
 
-	return mtu;
+	return max_t(unsigned int, mtu, IPV6_MIN_MTU);
 }
 
 u32 ip6_mtu_from_fib6(const struct fib6_result *res,
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index ff4f9ebcf7f6..8e56378713cd 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -578,8 +578,6 @@ int ip6_forward(struct sk_buff *skb)
 	}
 
 	mtu = ip6_dst_mtu_forward(dst);
-	if (mtu < IPV6_MIN_MTU)
-		mtu = IPV6_MIN_MTU;
 
 	if (ip6_pkt_too_big(skb, mtu)) {
 		/* Again, force OUTPUT device used as source address */
-- 
2.32.0.rc1.229.g3e70b5a671-goog

