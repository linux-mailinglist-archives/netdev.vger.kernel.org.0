Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 786E54DE1C
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 02:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbfFUAhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 20:37:06 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46835 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbfFUAhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 20:37:05 -0400
Received: by mail-pf1-f193.google.com with SMTP id 81so2591902pfy.13
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 17:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7n5xH40ZDxLwphsyvmrwkspOEWJvQI5lqk0em1IDBjM=;
        b=MGUJelnPYGTM6jzLJSzrAotw1nm7sAuVL9jDy4V4pgDR7Gfzk7ZMuR9bj36NMu6uka
         vs/HiJtJ9ewGw1s5tIdM0ZyHQPWUISSocmRNEexscJ+bLUK6QdHYgreuaYQSRCo40wgl
         o9l7IEaCPOLOnijd63J5QYvETJt4TAfZY2CVecmgFZAVgkgOzEnbs7qAaBSPVJSEqxtl
         d9C6Dlo6tFrDP6+I92BcgH4qWoLxjVgMlsHrB+kB2/OA9mSWeuo1M62PsjK7aSdT+fpi
         I6xgLO2dVtEO8npeqb0BA1mQTUenXqViZzySKr6sdM1vSczZorO+JerWLM4hq3CrRzoj
         HSTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7n5xH40ZDxLwphsyvmrwkspOEWJvQI5lqk0em1IDBjM=;
        b=C0p4a8R4Tv+emSuhQBlPU8Ujji7qHCdySsC9eH/wqQTye66iSta1DRLESRa0JS2DBT
         pWvB5J8/D10zNRVKxWJU4nTlEtxlKkGRKt45obuUP3kie51FFmhdU/SJ2BCyvdCsBJf4
         RTRBSdBhnZ34TtxsmKzEeeXorMQoL4WjvfuZl5dxky8g0oeoXfHqIsEPdFjoZx9gG9JG
         sNx9ibwGukSNCkNy3m+K7Wqp6a2vxQUlrTKTjGPqEkonIvZqxjbK6ZwrJNmkx3bwqQJ4
         JiIFuYg7ziS9c4blfBwV+3zxXZxqe31mRU3E/YQEz0FyobMsUkup/X9aqy2vlPHhnT8D
         M4pg==
X-Gm-Message-State: APjAAAVPYgDSZHQm3OPwXmlZgfd9X26ndBbVyHzfkVIWZz/i1yEG13VR
        3+3YKsdVqo1PkMAgypkBcSQ=
X-Google-Smtp-Source: APXvYqz8g6shV8DfkGCpzkRepVeOsOOTVtJ9fsngmnratjZSquFPHH6ymhQ+WQD8JceP4jhHf1mbiQ==
X-Received: by 2002:a63:2a83:: with SMTP id q125mr462305pgq.102.1561077424781;
        Thu, 20 Jun 2019 17:37:04 -0700 (PDT)
Received: from weiwan0.svl.corp.google.com ([2620:15c:2c4:201:9310:64cb:677b:dcba])
        by smtp.gmail.com with ESMTPSA id 2sm588206pff.174.2019.06.20.17.37.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 17:37:04 -0700 (PDT)
From:   Wei Wang <tracywwnj@gmail.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Ahern <dsahern@gmail.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Wei Wang <weiwan@google.com>
Subject: [PATCH v3 net-next 3/5] ipv6: honor RT6_LOOKUP_F_DST_NOREF in rule lookup logic
Date:   Thu, 20 Jun 2019 17:36:39 -0700
Message-Id: <20190621003641.168591-4-tracywwnj@gmail.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190621003641.168591-1-tracywwnj@gmail.com>
References: <20190621003641.168591-1-tracywwnj@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Wang <weiwan@google.com>

This patch specifically converts the rule lookup logic to honor this
flag and not release refcnt when traversing each rule and calling
lookup() on each routing table.
Similar to previous patch, we also need some special handling of dst
entries in uncached list because there is always 1 refcnt taken for them
even if RT6_LOOKUP_F_DST_NOREF flag is set.

Signed-off-by: Wei Wang <weiwan@google.com>
---
 include/net/ip6_route.h | 10 ++++++++++
 net/ipv6/fib6_rules.c   | 12 +++++++-----
 net/ipv6/ip6_fib.c      |  5 +++--
 3 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 82bced2fc1e3..0709835c01ad 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -94,6 +94,16 @@ static inline struct dst_entry *ip6_route_output(struct net *net,
 	return ip6_route_output_flags(net, sk, fl6, 0);
 }
 
+/* Only conditionally release dst if flags indicates
+ * !RT6_LOOKUP_F_DST_NOREF or dst is in uncached_list.
+ */
+static inline void ip6_rt_put_flags(struct rt6_info *rt, int flags)
+{
+	if (!(flags & RT6_LOOKUP_F_DST_NOREF) ||
+	    !list_empty(&rt->rt6i_uncached))
+		ip6_rt_put(rt);
+}
+
 struct dst_entry *ip6_route_lookup(struct net *net, struct flowi6 *fl6,
 				   const struct sk_buff *skb, int flags);
 struct rt6_info *ip6_pol_route(struct net *net, struct fib6_table *table,
diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
index bcfae13409b5..d22b6c140f23 100644
--- a/net/ipv6/fib6_rules.c
+++ b/net/ipv6/fib6_rules.c
@@ -113,14 +113,15 @@ struct dst_entry *fib6_rule_lookup(struct net *net, struct flowi6 *fl6,
 		rt = lookup(net, net->ipv6.fib6_local_tbl, fl6, skb, flags);
 		if (rt != net->ipv6.ip6_null_entry && rt->dst.error != -EAGAIN)
 			return &rt->dst;
-		ip6_rt_put(rt);
+		ip6_rt_put_flags(rt, flags);
 		rt = lookup(net, net->ipv6.fib6_main_tbl, fl6, skb, flags);
 		if (rt->dst.error != -EAGAIN)
 			return &rt->dst;
-		ip6_rt_put(rt);
+		ip6_rt_put_flags(rt, flags);
 	}
 
-	dst_hold(&net->ipv6.ip6_null_entry->dst);
+	if (!(flags & RT6_LOOKUP_F_DST_NOREF))
+		dst_hold(&net->ipv6.ip6_null_entry->dst);
 	return &net->ipv6.ip6_null_entry->dst;
 }
 
@@ -237,13 +238,14 @@ static int __fib6_rule_action(struct fib_rule *rule, struct flowi *flp,
 			goto out;
 	}
 again:
-	ip6_rt_put(rt);
+	ip6_rt_put_flags(rt, flags);
 	err = -EAGAIN;
 	rt = NULL;
 	goto out;
 
 discard_pkt:
-	dst_hold(&rt->dst);
+	if (!(flags & RT6_LOOKUP_F_DST_NOREF))
+		dst_hold(&rt->dst);
 out:
 	res->rt6 = rt;
 	return err;
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 1d16a01eccf5..5b1c9b5b9247 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -316,9 +316,10 @@ struct dst_entry *fib6_rule_lookup(struct net *net, struct flowi6 *fl6,
 
 	rt = lookup(net, net->ipv6.fib6_main_tbl, fl6, skb, flags);
 	if (rt->dst.error == -EAGAIN) {
-		ip6_rt_put(rt);
+		ip6_rt_put_flags(rt, flags);
 		rt = net->ipv6.ip6_null_entry;
-		dst_hold(&rt->dst);
+		if (!(flags | RT6_LOOKUP_F_DST_NOREF))
+			dst_hold(&rt->dst);
 	}
 
 	return &rt->dst;
-- 
2.22.0.410.gd8fdbe21b5-goog

