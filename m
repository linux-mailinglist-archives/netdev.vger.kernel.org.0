Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE65286D2C
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 05:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgJHDbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 23:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727449AbgJHDbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 23:31:13 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C00CC061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 20:31:13 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 7so3049468pgm.11
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 20:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Es3m/cmjQjKxJAujsQdOQ0HD+2pxPVO7acZ1i2IhzqM=;
        b=AtISJzcwEiIn05QZ830HD6kYdZpbUl7fsKCg510A/rjSQxCSwJwtdBoKVPfedZSgDq
         L2pXZLdn4GUsYqb6ItD38QzRS7WwPEun7eh3oxoL0hN0coV/k8WixBXvgPEa8y5Gy3E9
         OiUK4+d60w1ynA4GhvNTxgXw1iSN1ie/Y1CvKpMB/k6qx9dPBNHOnDRcgXgHEELymQqv
         yTHkBjtF9DPIbKve+TefVj0a1RTSDUEcYGwW1in8pQ+P5V46M/AFLiWeiZ74m5rLVUF0
         DmFOF8ZT+/o9XEEiCQxgZBY5QVqEECn+tcbhuaMt9uAMPYE0sjzwbk1Lrom0MjfBnOkR
         cWyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Es3m/cmjQjKxJAujsQdOQ0HD+2pxPVO7acZ1i2IhzqM=;
        b=LLOjTV33yPBpkKjsP5ajjSmXxzARnHWZYJC1Nc4DpFIepc0tAGOxf8HG8ebEKqlOKg
         9HGfiKcg9qPF/N0ZJ4KG2FEe13xVfzKrdpjIrX2tnUyFPmem6sPXNy7hdg7xRr3GgpXj
         +10uOZv4XuqbNLQnysLOoRRMfn6BzgTwpzQMLwa5WDOLGX/SQwNe4wbH+8wWc0YlASLL
         NAZveBQN5ZJ9AR0Cs65LAjUkVxFHnwdh5soMlmUvsQacBZx61zKstR9cOCmjtyYjSqKz
         qnUQTK9zWZa9OJG/dOaRg6LQ9z1tNpCZscmeQNgVdPG/LJYTnhAnESFK9ApvNHisy9qS
         cNyA==
X-Gm-Message-State: AOAM531MwPTYhJbiIjOPlyhG+cRFzGP3tKd0na1ZBPebpVoP99IqSuy1
        v3vwbGjBKHQXus9hHsMjesU=
X-Google-Smtp-Source: ABdhPJzPLpkEVKyVQPa47WuMz2qnD1twlx2wixT5euunbgsZzNy/Q6plvIieu2UgGLUR7PJXCrDLAw==
X-Received: by 2002:a17:90b:3649:: with SMTP id nh9mr5848400pjb.123.1602127872434;
        Wed, 07 Oct 2020 20:31:12 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:a28c:fdff:fee1:f370])
        by smtp.gmail.com with ESMTPSA id 32sm5241161pgu.17.2020.10.07.20.31.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 20:31:11 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        Sunmeet Gill <sgill@quicinc.com>,
        Vinay Paradkar <vparadka@qti.qualcomm.com>,
        Tyler Wear <twear@quicinc.com>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH 1/2] net/ipv6: always honour route mtu during forwarding
Date:   Wed,  7 Oct 2020 20:31:01 -0700
Message-Id: <20201008033102.623894-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This matches the new ipv4 behaviour as of commit:
  commit 02a1b175b0e92d9e0fa5df3957ade8d733ceb6a0
  Author: Maciej Żenczykowski <maze@google.com>
  Date:   Wed Sep 23 13:18:15 2020 -0700

  net/ipv4: always honour route mtu during forwarding

The reasoning is similar: There doesn't seem to be any reason
why you would want to ignore route mtu.

There are two potential sources of ipv6 route mtu:
  - manually configured by NET_ADMIN, since you configured
    a route mtu explicitly you probably know best...
  - derived from mtu information from RA messages,
    but this is the network telling you what will work,
    again presumably whatever network admin configured
    the RA content knows best what the network conditions are.

One could argue that RAs can be spoofed, but if we get spoofed
RAs we're *already* screwed, and erroneous mtu information is
less dangerous then the erroneous routes themselves...
(The proper place to do RA filtering is in the switch/router)

Additionally, a reduction from 1500 to 1280 (min ipv6 mtu) is
not very noticable on performance (especially with gro/gso/tso),
while packets getting lost (due to rx buffer overruns) or
generating icmpv6 packet too big errors and needing to be
retransmitted is very noticable (guaranteed impact of full rtt)

It is pretty common to have a higher device mtu to allow receiving
large (jumbo) frames, while having some routes via that interface
(potentially including the default route to the internet) specify
a lower mtu.

There might also be use cases around xfrm/ipsec/tunnels.
Especially for something like sit/6to4/6rd, where you may have one
sit device, but traffic through it will flow over different
underlying paths and thus is per subnet and not per device.

(Note that this function does not honour pmtu, which can be spoofed
via icmpv6 messages, but see also ip6_mtu_from_fib6() which honours
pmtu for ipv6 'locked mtu' routes)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Lorenzo Colitti <lorenzo@google.com>
Cc: Sunmeet Gill (Sunny) <sgill@quicinc.com>
Cc: Vinay Paradkar <vparadka@qti.qualcomm.com>
Cc: Tyler Wear <twear@quicinc.com>
Cc: David Ahern <dsahern@kernel.org>
---
 include/net/ip6_route.h | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 2a5277758379..598415743f46 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -311,19 +311,13 @@ static inline bool rt6_duplicate_nexthop(struct fib6_info *a, struct fib6_info *
 static inline unsigned int ip6_dst_mtu_forward(const struct dst_entry *dst)
 {
 	struct inet6_dev *idev;
-	unsigned int mtu;
+	unsigned int mtu = dst_metric_raw(dst, RTAX_MTU);
+	if (mtu)
+		return mtu;
 
-	if (dst_metric_locked(dst, RTAX_MTU)) {
-		mtu = dst_metric_raw(dst, RTAX_MTU);
-		if (mtu)
-			return mtu;
-	}
-
-	mtu = IPV6_MIN_MTU;
 	rcu_read_lock();
 	idev = __in6_dev_get(dst->dev);
-	if (idev)
-		mtu = idev->cnf.mtu6;
+	mtu = idev ? idev->cnf.mtu6 : IPV6_MIN_MTU;
 	rcu_read_unlock();
 
 	return mtu;
-- 
2.28.0.806.g8561365e88-goog

