Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6164161AB
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 17:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241895AbhIWPFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 11:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241735AbhIWPFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 11:05:15 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A759C061574
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 08:03:44 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id 5so4209993plo.5
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 08:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ExBixuEkV9jvQtJcn4iKj6YJlnqPBUdh7ZMXl9hPJBs=;
        b=J21bMEZzXQ+HpkcA2K9xmHaFLXAV6mhLjkU/6ayeJKfxzSxTLK9JWj9a0xuxTsRxyL
         KJBrF96Gn30u8uWyz0qMArltU2cursXzHDPaMI69+qmdnqaGsDeLjY3b5suU+c8o2qwX
         HwwJrYn628S5IW0n+1c1Dwk8V/TpVzdjuaMjiN7p9eOgwurXJFBZMnut6JgfusPrekmA
         xa1M9nqJ7CKdiGmTYfvYIx5DibOixUiTeJDzEGw9XaWFLt6x2YsAkEWBuS0RPkSI4U7/
         EimBJyoreniX2jYUiOyi86gW7zwNKU17XE4rdd1kNECLRIF4ay0eWrAHya7oFP2npHH8
         EXVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ExBixuEkV9jvQtJcn4iKj6YJlnqPBUdh7ZMXl9hPJBs=;
        b=TgKyp7GBqOm83Pwi3XYj93YQ0n8S6rlCY++viuwwIzNAq9IMCQGKYlGoQHfSPILsMA
         ofQfRZwCSnyG6VJGXVMJAn4eDOVv7X9cCUsRz26IopZt87Yak8+PIYuwc41lF72MqZQi
         tTgi1XN/NCQ6EveXXtVUKCb6jiCqjboXagnNNBqBfVBFSiKE2ieaTO/hBPs+I09fzRoC
         VH+T/SdoP0EWi23hvc4uUk+/gtQaZwPSYtOugg/jkxmLjbOE4RRnCRPIJh2Xg2ioij6z
         9JUnz0XxWiT4pnNaSENzYBE4bCYHi1bARTjqQse6QFFF8UiQ9A6HIilsu43eLKvyTMFG
         Xq+w==
X-Gm-Message-State: AOAM532taKtzFfZBRI3Xc0EQdhmeKQP6QRzEgUPXzbNNSgwAfD6rJ9Zk
        GzFKPSxiXc79Whf4CLESbjzXkY7C2MUu4tiP
X-Google-Smtp-Source: ABdhPJzKsAlSNcUAPspR4AG+jdSUwxjtKtcr0a6mRO5Zr56glDdTm6+o8NUEVGAlZKwB9Fn5ocgp0A==
X-Received: by 2002:a17:90a:f0cc:: with SMTP id fa12mr5867042pjb.215.1632409423687;
        Thu, 23 Sep 2021 08:03:43 -0700 (PDT)
Received: from nova-ws.. ([103.29.142.250])
        by smtp.gmail.com with ESMTPSA id b3sm5998174pfo.23.2021.09.23.08.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 08:03:43 -0700 (PDT)
From:   Xiao Liang <shaw.leon@gmail.com>
To:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>
Cc:     Xiao Liang <shaw.leon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH net v3] net: ipv4: Fix rtnexthop len when RTA_FLOW is present
Date:   Thu, 23 Sep 2021 23:03:19 +0800
Message-Id: <20210923150319.974-1-shaw.leon@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Multipath RTA_FLOW is embedded in nexthop. Dump it in fib_add_nexthop()
to get the length of rtnexthop correct.

Fixes: b0f60193632e ("ipv4: Refactor nexthop attributes in fib_dump_info")
Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
---
 include/net/ip_fib.h     |  2 +-
 include/net/nexthop.h    |  2 +-
 net/ipv4/fib_semantics.c | 16 +++++++++-------
 net/ipv6/route.c         |  5 +++--
 4 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 21c5386d4a6d..ab5348e57db1 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -597,5 +597,5 @@ int ip_valid_fib_dump_req(struct net *net, const struct nlmsghdr *nlh,
 int fib_nexthop_info(struct sk_buff *skb, const struct fib_nh_common *nh,
 		     u8 rt_family, unsigned char *flags, bool skip_oif);
 int fib_add_nexthop(struct sk_buff *skb, const struct fib_nh_common *nh,
-		    int nh_weight, u8 rt_family);
+		    int nh_weight, u8 rt_family, u32 nh_tclassid);
 #endif  /* _NET_FIB_H */
diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 10e1777877e6..28085b995ddc 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -325,7 +325,7 @@ int nexthop_mpath_fill_node(struct sk_buff *skb, struct nexthop *nh,
 		struct fib_nh_common *nhc = &nhi->fib_nhc;
 		int weight = nhg->nh_entries[i].weight;
 
-		if (fib_add_nexthop(skb, nhc, weight, rt_family) < 0)
+		if (fib_add_nexthop(skb, nhc, weight, rt_family, 0) < 0)
 			return -EMSGSIZE;
 	}
 
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index b42c429cebbe..3364cb9c67e0 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1661,7 +1661,7 @@ EXPORT_SYMBOL_GPL(fib_nexthop_info);
 
 #if IS_ENABLED(CONFIG_IP_ROUTE_MULTIPATH) || IS_ENABLED(CONFIG_IPV6)
 int fib_add_nexthop(struct sk_buff *skb, const struct fib_nh_common *nhc,
-		    int nh_weight, u8 rt_family)
+		    int nh_weight, u8 rt_family, u32 nh_tclassid)
 {
 	const struct net_device *dev = nhc->nhc_dev;
 	struct rtnexthop *rtnh;
@@ -1679,6 +1679,9 @@ int fib_add_nexthop(struct sk_buff *skb, const struct fib_nh_common *nhc,
 
 	rtnh->rtnh_flags = flags;
 
+	if (nh_tclassid && nla_put_u32(skb, RTA_FLOW, nh_tclassid))
+		goto nla_put_failure;
+
 	/* length of rtnetlink header + attributes */
 	rtnh->rtnh_len = nlmsg_get_pos(skb) - (void *)rtnh;
 
@@ -1706,14 +1709,13 @@ static int fib_add_multipath(struct sk_buff *skb, struct fib_info *fi)
 	}
 
 	for_nexthops(fi) {
-		if (fib_add_nexthop(skb, &nh->nh_common, nh->fib_nh_weight,
-				    AF_INET) < 0)
-			goto nla_put_failure;
+		u32 nh_tclassid = 0;
 #ifdef CONFIG_IP_ROUTE_CLASSID
-		if (nh->nh_tclassid &&
-		    nla_put_u32(skb, RTA_FLOW, nh->nh_tclassid))
-			goto nla_put_failure;
+		nh_tclassid = nh->nh_tclassid;
 #endif
+		if (fib_add_nexthop(skb, &nh->nh_common, nh->fib_nh_weight,
+				    AF_INET, nh_tclassid) < 0)
+			goto nla_put_failure;
 	} endfor_nexthops(fi);
 
 mp_end:
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index dbc224023977..9b9ef09382ab 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5681,14 +5681,15 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
 			goto nla_put_failure;
 
 		if (fib_add_nexthop(skb, &rt->fib6_nh->nh_common,
-				    rt->fib6_nh->fib_nh_weight, AF_INET6) < 0)
+				    rt->fib6_nh->fib_nh_weight, AF_INET6,
+				    0) < 0)
 			goto nla_put_failure;
 
 		list_for_each_entry_safe(sibling, next_sibling,
 					 &rt->fib6_siblings, fib6_siblings) {
 			if (fib_add_nexthop(skb, &sibling->fib6_nh->nh_common,
 					    sibling->fib6_nh->fib_nh_weight,
-					    AF_INET6) < 0)
+					    AF_INET6, 0) < 0)
 				goto nla_put_failure;
 		}
 
-- 
2.33.0

