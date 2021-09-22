Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310504145FE
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 12:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234788AbhIVKSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 06:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234722AbhIVKSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 06:18:30 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59740C061574
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 03:17:00 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id l6so1414415plh.9
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 03:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HhcP5q0wOaPjd7oSpAPTSn+qyDdm/T12elKB63DT/Tk=;
        b=WWTlnE/sKZZV/ZzUNfcNIOsodEnfcPT/Ylq0KgXKIex9spGa2a2PACYk4g5duhEdAZ
         zEN667D9NgUJIsBdirwoxsiPsO8DQrzO59FDvvgSUOIT99c0yrLmrNtv9MCrlqzRz7ri
         TB940Z26lM0OPxVviiGWKBPA4l0IGzxZvgOL6BAvZW70kjdjK5gY3t0y4E63ubx47pFi
         APfCJ4rbeXOWiEKVeJMKa3BQS9H4S+Pmv0rZkgJgS4MhuUrWmPLtLwIcSIv4+I2HWk2n
         /timyw6lwh3G7D+QCJKEREUDO7nS82H51H9E6+sNagUC088ipb/ZYpHsuOhMQf5W+P2j
         jATw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HhcP5q0wOaPjd7oSpAPTSn+qyDdm/T12elKB63DT/Tk=;
        b=4pLJcBEz3dE7Bjo+ruRMH+2OxzwRtfAQJx4ZMMx1C6SL3oeYR2yRjzQO8uLaetYR9N
         wCFEn7GJMGhXhHSeuxOyIh9lhy7cqzveYKahZfyyu8GbpjeHdxz0CzVdyTB6kBuraNd8
         MW8PGTobsM5EVqtrC6MdC2a9VYOSi3t49WIqiJm1pe1trL+meEOPU5R5xZo6i5CjvY9C
         dHAlqdlN18PiUGiwNG1BrYtA26DsZ9P2/iTV00mEB+ezKTARugfuRE8HaDRXgK/oAkoh
         GA+MESD4aKy79XpHLUGhiUKiYggwAqJUcdQjT/Uf+Vy1wNwyTmn51YKNNGNMy9ikCZtO
         b/kQ==
X-Gm-Message-State: AOAM533Aw7aTNNbpV4N3C851xIhhXrO5ryM3DFu43sOT272GJaurEQWb
        jhZBVIir22Km8xt204Y27yBsnen2yCI0T94D
X-Google-Smtp-Source: ABdhPJxCFfn964bnjF3HbxbfeC8ibjBXrrn03OAwEu91c5szq41wuvTZZ87FMqiUlFTFHc04nCR5xw==
X-Received: by 2002:a17:90b:4c05:: with SMTP id na5mr10570604pjb.49.1632305819816;
        Wed, 22 Sep 2021 03:16:59 -0700 (PDT)
Received: from nova-ws.. ([103.29.142.250])
        by smtp.gmail.com with ESMTPSA id x18sm1980170pfq.130.2021.09.22.03.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 03:16:59 -0700 (PDT)
From:   Xiao Liang <shaw.leon@gmail.com>
To:     netdev <netdev@vger.kernel.org>
Cc:     Xiao Liang <shaw.leon@gmail.com>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, davem@davemloft.net
Subject: [PATCH net] net: ipv4: Fix rtnexthop len when RTA_FLOW is present
Date:   Wed, 22 Sep 2021 18:16:54 +0800
Message-Id: <20210922101654.7775-1-shaw.leon@gmail.com>
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

