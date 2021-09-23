Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF9F4158F7
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 09:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239508AbhIWHYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 03:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234343AbhIWHYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 03:24:22 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09455C061574
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 00:22:51 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id v19so3845426pjh.2
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 00:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bghwosJlnRpEqG3QdyBeTnpcqPVy3npXwSyvsNk7E+4=;
        b=DbmWzKOu5wAJmMo5HrABQkhIlq+bf4Ra1Yr5EdoTweyeEOL53M8NOaGF5ngudQW3F+
         c7reFC0nwsE+MuVlyYnU+RhxTYdQRxl/vjY2Ja4HJ/9lvSf5cIepyene3RPuPPb4w9Cx
         1xjcy8LrjnHTwro5gO/WgPQi8NfiFf+EhC9nHgDEOtd3NwE+m3udFfOkAzCcir4AfEAT
         ywTMohSlu/2H0wahSnawjhQ9KmEHbJxhaaopLGnhsrcCscrNRkhzxpbgNeyhHfY79fnj
         U/N9uZqU3uSgoPxo+BUKTEQKI0KSyqCPPArKPKwz9bLDH+/ffh+6FIEn4y0XpZSgRbAu
         QbAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bghwosJlnRpEqG3QdyBeTnpcqPVy3npXwSyvsNk7E+4=;
        b=cfwVso6BoJX7tnHiPrG0JbdOSAHQSuPCGzYlK6BggMQ8LmlHd1FSnTudQnLPj7T+Of
         T/NWuopjDtuLJxjenOAz1Dlu0mWpR+lf9nhpa1lpIRDxlOUnjN91+E/px9eodSNdZEhu
         c40ae4mCYRXw2htsUXnwGi08sOIHnB+opu4Ttipx7zvlwoexZvtOQCTCHyBxQp3OgADa
         yjMa2gvNnwKFGfWl67474oaZOX9CeD+RxYc5hnOSJl+5jnNmlljVRG35Vw+p9SCbRYwd
         Q0K+rg0180NPpvwo3sRBkpW4E4XVLLEXVDAMYQ9Rn1+uw8474Tt9wPW4jAYfugo/RwOz
         VSZw==
X-Gm-Message-State: AOAM531/5yMPP9mg1zKTIU3lZDWIoDJpfyW/ckWbXJblWh72LJGIG6rl
        +6BDpnQyCpe9O9d4CXTsI88ePGt02aurFujS
X-Google-Smtp-Source: ABdhPJzSDkeu/b4DKwUjZjbE/Zexabv5cqUodRqhG8eeV4aoFO9EfEzGjfp1ne+UqggiUS+dm8d6Rg==
X-Received: by 2002:a17:90a:430f:: with SMTP id q15mr3621806pjg.2.1632381770286;
        Thu, 23 Sep 2021 00:22:50 -0700 (PDT)
Received: from nova-ws.. ([103.29.142.250])
        by smtp.gmail.com with ESMTPSA id p16sm4169087pja.24.2021.09.23.00.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 00:22:49 -0700 (PDT)
From:   Xiao Liang <shaw.leon@gmail.com>
To:     netdev <netdev@vger.kernel.org>
Cc:     Xiao Liang <shaw.leon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH net v2] net: ipv4: Fix rtnexthop len when RTA_FLOW is present
Date:   Thu, 23 Sep 2021 15:22:46 +0800
Message-Id: <20210923072246.351699-1-shaw.leon@gmail.com>
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
 net/ipv4/fib_semantics.c | 15 ++++++++-------
 net/ipv6/route.c         |  5 +++--
 4 files changed, 13 insertions(+), 11 deletions(-)

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
index b42c429cebbe..e9818faaff4d 100644
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
@@ -1679,6 +1679,12 @@ int fib_add_nexthop(struct sk_buff *skb, const struct fib_nh_common *nhc,
 
 	rtnh->rtnh_flags = flags;
 
+#ifdef CONFIG_IP_ROUTE_CLASSID
+	if (nh_tclassid &&
+	    nla_put_u32(skb, RTA_FLOW, nh_tclassid))
+		goto nla_put_failure;
+#endif
+
 	/* length of rtnetlink header + attributes */
 	rtnh->rtnh_len = nlmsg_get_pos(skb) - (void *)rtnh;
 
@@ -1707,13 +1713,8 @@ static int fib_add_multipath(struct sk_buff *skb, struct fib_info *fi)
 
 	for_nexthops(fi) {
 		if (fib_add_nexthop(skb, &nh->nh_common, nh->fib_nh_weight,
-				    AF_INET) < 0)
+				    AF_INET, nh->nh_tclassid) < 0)
 			goto nla_put_failure;
-#ifdef CONFIG_IP_ROUTE_CLASSID
-		if (nh->nh_tclassid &&
-		    nla_put_u32(skb, RTA_FLOW, nh->nh_tclassid))
-			goto nla_put_failure;
-#endif
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

