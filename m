Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB495EA913
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 16:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234650AbiIZOwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 10:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234118AbiIZOvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 10:51:50 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12CED175A5
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 06:18:24 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Mbjtt3bJFzHqTw;
        Mon, 26 Sep 2022 21:16:06 +0800 (CST)
Received: from huawei.com (10.175.101.6) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 26 Sep
 2022 21:18:21 +0800
From:   Liu Jian <liujian56@huawei.com>
To:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     <liujian56@huawei.com>
Subject: [PATCH net-next 2/2] net: Add helper function to parse netlink msg of ip_tunnel_parm
Date:   Mon, 26 Sep 2022 21:19:44 +0800
Message-ID: <20220926131944.137094-3-liujian56@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220926131944.137094-1-liujian56@huawei.com>
References: <20220926131944.137094-1-liujian56@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ip_tunnel_netlink_parms to parse netlink msg of ip_tunnel_parm.
Reduces duplicate code, no actual functional changes.

Signed-off-by: Liu Jian <liujian56@huawei.com>
---
 include/net/ip_tunnels.h | 32 ++++++++++++++++++++++++++++++++
 net/ipv4/ipip.c          | 24 +-----------------------
 net/ipv6/sit.c           | 27 +--------------------------
 3 files changed, 34 insertions(+), 49 deletions(-)

diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index e8bb8944ce3f..ea047de92e83 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -17,6 +17,7 @@
 #include <net/rtnetlink.h>
 #include <net/lwtunnel.h>
 #include <net/dst_cache.h>
+#include <net/ip.h>
 
 #if IS_ENABLED(CONFIG_IPV6)
 #include <net/ipv6.h>
@@ -336,6 +337,37 @@ static inline bool ip_tunnel_netlink_encap_parms(struct nlattr *data[],
 	return ret;
 }
 
+static inline void ip_tunnel_netlink_parms(struct nlattr *data[],
+					   struct ip_tunnel_parm *parms)
+{
+	if (data[IFLA_IPTUN_LINK])
+		parms->link = nla_get_u32(data[IFLA_IPTUN_LINK]);
+
+	if (data[IFLA_IPTUN_LOCAL])
+		parms->iph.saddr = nla_get_be32(data[IFLA_IPTUN_LOCAL]);
+
+	if (data[IFLA_IPTUN_REMOTE])
+		parms->iph.daddr = nla_get_be32(data[IFLA_IPTUN_REMOTE]);
+
+	if (data[IFLA_IPTUN_TTL]) {
+		parms->iph.ttl = nla_get_u8(data[IFLA_IPTUN_TTL]);
+		if (parms->iph.ttl)
+			parms->iph.frag_off = htons(IP_DF);
+	}
+
+	if (data[IFLA_IPTUN_TOS])
+		parms->iph.tos = nla_get_u8(data[IFLA_IPTUN_TOS]);
+
+	if (!data[IFLA_IPTUN_PMTUDISC] || nla_get_u8(data[IFLA_IPTUN_PMTUDISC]))
+		parms->iph.frag_off = htons(IP_DF);
+
+	if (data[IFLA_IPTUN_FLAGS])
+		parms->i_flags = nla_get_be16(data[IFLA_IPTUN_FLAGS]);
+
+	if (data[IFLA_IPTUN_PROTO])
+		parms->iph.protocol = nla_get_u8(data[IFLA_IPTUN_PROTO]);
+}
+
 extern const struct header_ops ip_tunnel_header_ops;
 __be16 ip_tunnel_parse_protocol(const struct sk_buff *skb);
 
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 7c64ca06adf3..180f9daf5bec 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -417,29 +417,7 @@ static void ipip_netlink_parms(struct nlattr *data[],
 	if (!data)
 		return;
 
-	if (data[IFLA_IPTUN_LINK])
-		parms->link = nla_get_u32(data[IFLA_IPTUN_LINK]);
-
-	if (data[IFLA_IPTUN_LOCAL])
-		parms->iph.saddr = nla_get_in_addr(data[IFLA_IPTUN_LOCAL]);
-
-	if (data[IFLA_IPTUN_REMOTE])
-		parms->iph.daddr = nla_get_in_addr(data[IFLA_IPTUN_REMOTE]);
-
-	if (data[IFLA_IPTUN_TTL]) {
-		parms->iph.ttl = nla_get_u8(data[IFLA_IPTUN_TTL]);
-		if (parms->iph.ttl)
-			parms->iph.frag_off = htons(IP_DF);
-	}
-
-	if (data[IFLA_IPTUN_TOS])
-		parms->iph.tos = nla_get_u8(data[IFLA_IPTUN_TOS]);
-
-	if (data[IFLA_IPTUN_PROTO])
-		parms->iph.protocol = nla_get_u8(data[IFLA_IPTUN_PROTO]);
-
-	if (!data[IFLA_IPTUN_PMTUDISC] || nla_get_u8(data[IFLA_IPTUN_PMTUDISC]))
-		parms->iph.frag_off = htons(IP_DF);
+	ip_tunnel_netlink_parms(data, parms);
 
 	if (data[IFLA_IPTUN_COLLECT_METADATA])
 		*collect_md = true;
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index a8a258f672fa..d27683e3fc97 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1503,32 +1503,7 @@ static void ipip6_netlink_parms(struct nlattr *data[],
 	if (!data)
 		return;
 
-	if (data[IFLA_IPTUN_LINK])
-		parms->link = nla_get_u32(data[IFLA_IPTUN_LINK]);
-
-	if (data[IFLA_IPTUN_LOCAL])
-		parms->iph.saddr = nla_get_be32(data[IFLA_IPTUN_LOCAL]);
-
-	if (data[IFLA_IPTUN_REMOTE])
-		parms->iph.daddr = nla_get_be32(data[IFLA_IPTUN_REMOTE]);
-
-	if (data[IFLA_IPTUN_TTL]) {
-		parms->iph.ttl = nla_get_u8(data[IFLA_IPTUN_TTL]);
-		if (parms->iph.ttl)
-			parms->iph.frag_off = htons(IP_DF);
-	}
-
-	if (data[IFLA_IPTUN_TOS])
-		parms->iph.tos = nla_get_u8(data[IFLA_IPTUN_TOS]);
-
-	if (!data[IFLA_IPTUN_PMTUDISC] || nla_get_u8(data[IFLA_IPTUN_PMTUDISC]))
-		parms->iph.frag_off = htons(IP_DF);
-
-	if (data[IFLA_IPTUN_FLAGS])
-		parms->i_flags = nla_get_be16(data[IFLA_IPTUN_FLAGS]);
-
-	if (data[IFLA_IPTUN_PROTO])
-		parms->iph.protocol = nla_get_u8(data[IFLA_IPTUN_PROTO]);
+	ip_tunnel_netlink_parms(data, parms);
 
 	if (data[IFLA_IPTUN_FWMARK])
 		*fwmark = nla_get_u32(data[IFLA_IPTUN_FWMARK]);
-- 
2.17.1

