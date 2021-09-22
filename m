Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF95641451E
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 11:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234412AbhIVJ3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 05:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234256AbhIVJ3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 05:29:11 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34EEC061760
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 02:27:41 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id t11so1330627plq.11
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 02:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x9jp8opWkAsXHNaehT7C+jlMdigNHdlLNeHc2TGfJ3k=;
        b=eKIfDGkHLrwy5vV0XroQK2s+EARGuR8OvhGaik8gfkNwc4mM9tEybpDHE0p66sDse3
         xUvikQyhmGGBI6oF5jA1pvO3wfl3mwjRPI6vDb7zGFRuaQSOmpVjNESU2NzFNXCDsR4u
         +wVofZ0YO9ZQgjipagL54r61LVv9u1bq/oKaqWH2LmwuBCzs9yWmacyu2yZRluz5+Tdn
         Y60VKWiPmIbBcu3dRx7SacpxIuBT++n/XMCwBhYubL8cXsZLoe5ADW7h+0Z1YkUr9TlQ
         VppscNGzRkAEzrkkPUDCGNtOSYbUG32Wt6H2EFT8kxJQusSmV9nh0ClGxuUTLEdWtMlv
         CP9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x9jp8opWkAsXHNaehT7C+jlMdigNHdlLNeHc2TGfJ3k=;
        b=4BLXsTSkOFVUe+F1ntGMua01gJZVdXTLhhZEFi/mVVzEbHKxVlL4N4J+lHynAWhz7t
         VeF+nlOQzlIAX1tF6mc3FK6970bzJSmCHbUXVoRisxJh8TvTJFRN4CK/UoWDlrL+cUI5
         ozm8Dp+SmU0mwXBl1YVnp3zjv3u7ko60qsEIWKQrbRJz5xYCjtufWNxIM5J5szjI91Ad
         hmHK1B0raMXjSXJw7yJL4WbsJiTOzG7LAh9XFHY5o67Uz3bivS2XjcA6AbJqNWCoP+eX
         l1A9A6x7UKuPNy0wheOeEDsKAQw4k0SL9g1PgH6jwzH0SYUgaPtC3X4AvLPUTZOQdZ2v
         2f4g==
X-Gm-Message-State: AOAM5330gpodZOuHCII9/4cbs1H4DcXSPT9E/GMnzSydxat2kZnxZK9u
        FxMxmpOcEpPMSM9QXj98L5msIo1ZNaareA==
X-Google-Smtp-Source: ABdhPJxObjsteS/s/qWN3ZOWzm2F/d8Gef+735Wnz8Ws3Z1VHHXx1NHM5cF7cQi04yvUAytfF1Oyuw==
X-Received: by 2002:a17:90a:5d0f:: with SMTP id s15mr10239282pji.10.1632302861337;
        Wed, 22 Sep 2021 02:27:41 -0700 (PDT)
Received: from nova-ws.. ([103.29.142.250])
        by smtp.gmail.com with ESMTPSA id u194sm1897893pfc.177.2021.09.22.02.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 02:27:41 -0700 (PDT)
From:   Xiao Liang <shaw.leon@gmail.com>
To:     netdev <netdev@vger.kernel.org>
Cc:     Xiao Liang <shaw.leon@gmail.com>
Subject: [PATCH net] net: ipv4: Fix rtnexthop len when RTA_FLOW is present
Date:   Wed, 22 Sep 2021 17:27:19 +0800
Message-Id: <20210922092719.7158-1-shaw.leon@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Multipath RTA_FLOW is embedded in nexthop, thus add it to rtnexthop
length.

Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
---
 net/ipv4/fib_semantics.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index b42c429cebbe..a07883ba8748 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1660,8 +1660,9 @@ int fib_nexthop_info(struct sk_buff *skb, const struct fib_nh_common *nhc,
 EXPORT_SYMBOL_GPL(fib_nexthop_info);
 
 #if IS_ENABLED(CONFIG_IP_ROUTE_MULTIPATH) || IS_ENABLED(CONFIG_IPV6)
-int fib_add_nexthop(struct sk_buff *skb, const struct fib_nh_common *nhc,
-		    int nh_weight, u8 rt_family)
+static inline struct rtnexthop *__fib_add_nexthop(struct sk_buff *skb,
+					const struct fib_nh_common *nhc,
+					int nh_weight, u8 rt_family)
 {
 	const struct net_device *dev = nhc->nhc_dev;
 	struct rtnexthop *rtnh;
@@ -1682,10 +1683,16 @@ int fib_add_nexthop(struct sk_buff *skb, const struct fib_nh_common *nhc,
 	/* length of rtnetlink header + attributes */
 	rtnh->rtnh_len = nlmsg_get_pos(skb) - (void *)rtnh;
 
-	return 0;
+	return rtnh;
 
 nla_put_failure:
-	return -EMSGSIZE;
+	return ERR_PTR(-EMSGSIZE);
+}
+
+int fib_add_nexthop(struct sk_buff *skb, const struct fib_nh_common *nhc,
+		    int nh_weight, u8 rt_family)
+{
+	return PTR_ERR_OR_ZERO(__fib_add_nexthop(skb, nhc, nh_weight, rt_family));
 }
 EXPORT_SYMBOL_GPL(fib_add_nexthop);
 #endif
@@ -1706,13 +1713,17 @@ static int fib_add_multipath(struct sk_buff *skb, struct fib_info *fi)
 	}
 
 	for_nexthops(fi) {
-		if (fib_add_nexthop(skb, &nh->nh_common, nh->fib_nh_weight,
-				    AF_INET) < 0)
+		struct rtnexthop *rtnh = __fib_add_nexthop(skb, &nh->nh_common,
+							   nh->fib_nh_weight,
+							   AF_INET);
+		if (IS_ERR(rtnh))
 			goto nla_put_failure;
 #ifdef CONFIG_IP_ROUTE_CLASSID
-		if (nh->nh_tclassid &&
-		    nla_put_u32(skb, RTA_FLOW, nh->nh_tclassid))
-			goto nla_put_failure;
+		if (nh->nh_tclassid) {
+			if (nla_put_u32(skb, RTA_FLOW, nh->nh_tclassid))
+				goto nla_put_failure;
+			rtnh->rtnh_len += nla_total_size(4);
+		}
 #endif
 	} endfor_nexthops(fi);
 
-- 
2.33.0

