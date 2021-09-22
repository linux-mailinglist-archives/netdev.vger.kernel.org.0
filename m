Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA32A414583
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 11:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234421AbhIVJvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 05:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234387AbhIVJvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 05:51:05 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65765C061574
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 02:49:34 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id lb1-20020a17090b4a4100b001993f863df2so1818336pjb.5
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 02:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HhcP5q0wOaPjd7oSpAPTSn+qyDdm/T12elKB63DT/Tk=;
        b=enWZ5C/d9FCYrcwhbkjAqxAUBaEiRlqE0TmsM+bplsGajINygsitizD+yrH0YZLMiq
         pWIrW/M3HN81fcV8G4NkgYfTGNbX4JTFWgWM32/FF4CPWfCQy6YFMhqDa8jkDXvGx15N
         guh5PLueCQFEwpuaoNnqXVA+2/O2Sw08rJfr4h6EbIHb5YEJh9VoJgim+aGphIraIERu
         SQVlXQC7Xyr+enmbj2eGmjZB39InNLG3CyezRqVHi56yxFjaw8+Zp/xqHncDSfmXiJHa
         n2rBgBS5XckEut8bfb2xdhn9Ug/1QwDTl4Qpp1wii9fVOlmYLINGGQqSsWRQRQXIa6e/
         6PuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HhcP5q0wOaPjd7oSpAPTSn+qyDdm/T12elKB63DT/Tk=;
        b=X+Ky8vUagE90oxTAXl9ijxe2770d2qX8lmjNsgB3KVkLBFiZUSEsS7BuzFJySzrVkR
         9YAtnCg4sTesH+AdQco6fpSDv2lQ3w1SrzB6YRsjx755e7aYlZARuwhFFrXn4RO4wkXm
         TQ/OQvWOKTVSdc1GGKzYhtiXpA99b0sobwLJw0WPNCdkby1QxvndGknZU+b0AEVWJsfp
         zWelAM9Zqv7v26ObOah7eOi+EphGTJm5K4S9rmPlEfkU4EiFAQ5zursiO6QmDFf19utG
         LvCKGwOxSotI+/gxXkkVE94pgNb8wT7dV0MGFfAI1TZeHkyds6+kUZ3Kkwn6r/9mXrQb
         apYw==
X-Gm-Message-State: AOAM532agIQ+r5r0meBGJHjFAvbUtKb3UpIOBalZmF4Qh3SHp6vWefPZ
        wVbfz4cQYhopK0mYRPZ+4mJ/kJPLgOqZsg==
X-Google-Smtp-Source: ABdhPJweHmYizvGi0Fv1z16DZTAwuuQXWXUeqBBnx69ntr6SQ5OY5cfzUX10uUPS+MCM+bU+uoj8IQ==
X-Received: by 2002:a17:90a:7342:: with SMTP id j2mr10417751pjs.59.1632304173703;
        Wed, 22 Sep 2021 02:49:33 -0700 (PDT)
Received: from nova-ws.. ([103.29.142.250])
        by smtp.gmail.com with ESMTPSA id cp17sm1722727pjb.3.2021.09.22.02.49.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 02:49:33 -0700 (PDT)
From:   Xiao Liang <shaw.leon@gmail.com>
To:     netdev <netdev@vger.kernel.org>
Cc:     Xiao Liang <shaw.leon@gmail.com>
Subject: [PATCH] net: ipv4: Fix rtnexthop len when RTA_FLOW is present
Date:   Wed, 22 Sep 2021 17:49:35 +0800
Message-Id: <20210922094935.7582-1-shaw.leon@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Multipath RTA_FLOW is embedded in nexthop, thus add it to rtnexthop
length.

Fixes: b0f60193632e ("ipv4: Refactor nexthop attributes in fib_dump_info")
Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
---
 net/ipv4/fib_semantics.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index b42c429cebbe..62b74edb5240 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1660,8 +1660,9 @@ int fib_nexthop_info(struct sk_buff *skb, const struct fib_nh_common *nhc,
 EXPORT_SYMBOL_GPL(fib_nexthop_info);
 
 #if IS_ENABLED(CONFIG_IP_ROUTE_MULTIPATH) || IS_ENABLED(CONFIG_IPV6)
-int fib_add_nexthop(struct sk_buff *skb, const struct fib_nh_common *nhc,
-		    int nh_weight, u8 rt_family)
+static struct rtnexthop *__fib_add_nexthop(struct sk_buff *skb,
+					   const struct fib_nh_common *nhc,
+					   int nh_weight, u8 rt_family)
 {
 	const struct net_device *dev = nhc->nhc_dev;
 	struct rtnexthop *rtnh;
@@ -1682,10 +1683,17 @@ int fib_add_nexthop(struct sk_buff *skb, const struct fib_nh_common *nhc,
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
+	return PTR_ERR_OR_ZERO(__fib_add_nexthop(skb, nhc, nh_weight,
+						 rt_family));
 }
 EXPORT_SYMBOL_GPL(fib_add_nexthop);
 #endif
@@ -1706,13 +1714,17 @@ static int fib_add_multipath(struct sk_buff *skb, struct fib_info *fi)
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

