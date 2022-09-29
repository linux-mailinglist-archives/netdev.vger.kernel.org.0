Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C82435EF6D2
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 15:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235170AbiI2Nnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 09:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235090AbiI2Nnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 09:43:53 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253A31B2D23
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 06:43:52 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MdZGX4X0nz1P6w8;
        Thu, 29 Sep 2022 21:39:32 +0800 (CST)
Received: from huawei.com (10.175.101.6) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 29 Sep
 2022 21:43:49 +0800
From:   Liu Jian <liujian56@huawei.com>
To:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     <liujian56@huawei.com>
Subject: [PATCH net-next v3 1/2] net: Add helper function to parse netlink msg of ip_tunnel_encap
Date:   Thu, 29 Sep 2022 21:52:02 +0800
Message-ID: <20220929135203.235212-2-liujian56@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220929135203.235212-1-liujian56@huawei.com>
References: <20220929135203.235212-1-liujian56@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ip_tunnel_netlink_encap_parms to parse netlink msg of ip_tunnel_encap.
Reduces duplicate code, no actual functional changes.

Signed-off-by: Liu Jian <liujian56@huawei.com>
---
v2->v3: Change EXPORT_SYMBOL to EXPORT_SYMBOL_GPL
 include/net/ip_tunnels.h  |  3 +++
 net/ipv4/ip_tunnel_core.c | 35 +++++++++++++++++++++++++++++++++++
 net/ipv4/ipip.c           | 38 ++------------------------------------
 net/ipv6/ip6_tunnel.c     | 37 ++-----------------------------------
 net/ipv6/sit.c            | 38 ++------------------------------------
 5 files changed, 44 insertions(+), 107 deletions(-)

diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index ced80e2f8b58..51da2957cf48 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -302,6 +302,9 @@ int ip_tunnel_newlink(struct net_device *dev, struct nlattr *tb[],
 		      struct ip_tunnel_parm *p, __u32 fwmark);
 void ip_tunnel_setup(struct net_device *dev, unsigned int net_id);
 
+bool ip_tunnel_netlink_encap_parms(struct nlattr *data[],
+				   struct ip_tunnel_encap *encap);
+
 extern const struct header_ops ip_tunnel_header_ops;
 __be16 ip_tunnel_parse_protocol(const struct sk_buff *skb);
 
diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index cc1caab4a654..6d08f7e39191 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -1079,3 +1079,38 @@ EXPORT_SYMBOL(ip_tunnel_parse_protocol);
 
 const struct header_ops ip_tunnel_header_ops = { .parse_protocol = ip_tunnel_parse_protocol };
 EXPORT_SYMBOL(ip_tunnel_header_ops);
+
+/* This function returns true when ENCAP attributes are present in the nl msg */
+bool ip_tunnel_netlink_encap_parms(struct nlattr *data[],
+				   struct ip_tunnel_encap *encap)
+{
+	bool ret = false;
+
+	memset(encap, 0, sizeof(*encap));
+
+	if (!data)
+		return ret;
+
+	if (data[IFLA_IPTUN_ENCAP_TYPE]) {
+		ret = true;
+		encap->type = nla_get_u16(data[IFLA_IPTUN_ENCAP_TYPE]);
+	}
+
+	if (data[IFLA_IPTUN_ENCAP_FLAGS]) {
+		ret = true;
+		encap->flags = nla_get_u16(data[IFLA_IPTUN_ENCAP_FLAGS]);
+	}
+
+	if (data[IFLA_IPTUN_ENCAP_SPORT]) {
+		ret = true;
+		encap->sport = nla_get_be16(data[IFLA_IPTUN_ENCAP_SPORT]);
+	}
+
+	if (data[IFLA_IPTUN_ENCAP_DPORT]) {
+		ret = true;
+		encap->dport = nla_get_be16(data[IFLA_IPTUN_ENCAP_DPORT]);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ip_tunnel_netlink_encap_parms);
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 123ea63a04cb..7c64ca06adf3 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -448,40 +448,6 @@ static void ipip_netlink_parms(struct nlattr *data[],
 		*fwmark = nla_get_u32(data[IFLA_IPTUN_FWMARK]);
 }
 
-/* This function returns true when ENCAP attributes are present in the nl msg */
-static bool ipip_netlink_encap_parms(struct nlattr *data[],
-				     struct ip_tunnel_encap *ipencap)
-{
-	bool ret = false;
-
-	memset(ipencap, 0, sizeof(*ipencap));
-
-	if (!data)
-		return ret;
-
-	if (data[IFLA_IPTUN_ENCAP_TYPE]) {
-		ret = true;
-		ipencap->type = nla_get_u16(data[IFLA_IPTUN_ENCAP_TYPE]);
-	}
-
-	if (data[IFLA_IPTUN_ENCAP_FLAGS]) {
-		ret = true;
-		ipencap->flags = nla_get_u16(data[IFLA_IPTUN_ENCAP_FLAGS]);
-	}
-
-	if (data[IFLA_IPTUN_ENCAP_SPORT]) {
-		ret = true;
-		ipencap->sport = nla_get_be16(data[IFLA_IPTUN_ENCAP_SPORT]);
-	}
-
-	if (data[IFLA_IPTUN_ENCAP_DPORT]) {
-		ret = true;
-		ipencap->dport = nla_get_be16(data[IFLA_IPTUN_ENCAP_DPORT]);
-	}
-
-	return ret;
-}
-
 static int ipip_newlink(struct net *src_net, struct net_device *dev,
 			struct nlattr *tb[], struct nlattr *data[],
 			struct netlink_ext_ack *extack)
@@ -491,7 +457,7 @@ static int ipip_newlink(struct net *src_net, struct net_device *dev,
 	struct ip_tunnel_encap ipencap;
 	__u32 fwmark = 0;
 
-	if (ipip_netlink_encap_parms(data, &ipencap)) {
+	if (ip_tunnel_netlink_encap_parms(data, &ipencap)) {
 		int err = ip_tunnel_encap_setup(t, &ipencap);
 
 		if (err < 0)
@@ -512,7 +478,7 @@ static int ipip_changelink(struct net_device *dev, struct nlattr *tb[],
 	bool collect_md;
 	__u32 fwmark = t->fwmark;
 
-	if (ipip_netlink_encap_parms(data, &ipencap)) {
+	if (ip_tunnel_netlink_encap_parms(data, &ipencap)) {
 		int err = ip_tunnel_encap_setup(t, &ipencap);
 
 		if (err < 0)
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 9e97f3b4c7e8..cc5d5e75b658 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1988,39 +1988,6 @@ static void ip6_tnl_netlink_parms(struct nlattr *data[],
 		parms->fwmark = nla_get_u32(data[IFLA_IPTUN_FWMARK]);
 }
 
-static bool ip6_tnl_netlink_encap_parms(struct nlattr *data[],
-					struct ip_tunnel_encap *ipencap)
-{
-	bool ret = false;
-
-	memset(ipencap, 0, sizeof(*ipencap));
-
-	if (!data)
-		return ret;
-
-	if (data[IFLA_IPTUN_ENCAP_TYPE]) {
-		ret = true;
-		ipencap->type = nla_get_u16(data[IFLA_IPTUN_ENCAP_TYPE]);
-	}
-
-	if (data[IFLA_IPTUN_ENCAP_FLAGS]) {
-		ret = true;
-		ipencap->flags = nla_get_u16(data[IFLA_IPTUN_ENCAP_FLAGS]);
-	}
-
-	if (data[IFLA_IPTUN_ENCAP_SPORT]) {
-		ret = true;
-		ipencap->sport = nla_get_be16(data[IFLA_IPTUN_ENCAP_SPORT]);
-	}
-
-	if (data[IFLA_IPTUN_ENCAP_DPORT]) {
-		ret = true;
-		ipencap->dport = nla_get_be16(data[IFLA_IPTUN_ENCAP_DPORT]);
-	}
-
-	return ret;
-}
-
 static int ip6_tnl_newlink(struct net *src_net, struct net_device *dev,
 			   struct nlattr *tb[], struct nlattr *data[],
 			   struct netlink_ext_ack *extack)
@@ -2033,7 +2000,7 @@ static int ip6_tnl_newlink(struct net *src_net, struct net_device *dev,
 
 	nt = netdev_priv(dev);
 
-	if (ip6_tnl_netlink_encap_parms(data, &ipencap)) {
+	if (ip_tunnel_netlink_encap_parms(data, &ipencap)) {
 		err = ip6_tnl_encap_setup(nt, &ipencap);
 		if (err < 0)
 			return err;
@@ -2070,7 +2037,7 @@ static int ip6_tnl_changelink(struct net_device *dev, struct nlattr *tb[],
 	if (dev == ip6n->fb_tnl_dev)
 		return -EINVAL;
 
-	if (ip6_tnl_netlink_encap_parms(data, &ipencap)) {
+	if (ip_tunnel_netlink_encap_parms(data, &ipencap)) {
 		int err = ip6_tnl_encap_setup(t, &ipencap);
 
 		if (err < 0)
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 98f1cf40746f..a8a258f672fa 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1534,40 +1534,6 @@ static void ipip6_netlink_parms(struct nlattr *data[],
 		*fwmark = nla_get_u32(data[IFLA_IPTUN_FWMARK]);
 }
 
-/* This function returns true when ENCAP attributes are present in the nl msg */
-static bool ipip6_netlink_encap_parms(struct nlattr *data[],
-				      struct ip_tunnel_encap *ipencap)
-{
-	bool ret = false;
-
-	memset(ipencap, 0, sizeof(*ipencap));
-
-	if (!data)
-		return ret;
-
-	if (data[IFLA_IPTUN_ENCAP_TYPE]) {
-		ret = true;
-		ipencap->type = nla_get_u16(data[IFLA_IPTUN_ENCAP_TYPE]);
-	}
-
-	if (data[IFLA_IPTUN_ENCAP_FLAGS]) {
-		ret = true;
-		ipencap->flags = nla_get_u16(data[IFLA_IPTUN_ENCAP_FLAGS]);
-	}
-
-	if (data[IFLA_IPTUN_ENCAP_SPORT]) {
-		ret = true;
-		ipencap->sport = nla_get_be16(data[IFLA_IPTUN_ENCAP_SPORT]);
-	}
-
-	if (data[IFLA_IPTUN_ENCAP_DPORT]) {
-		ret = true;
-		ipencap->dport = nla_get_be16(data[IFLA_IPTUN_ENCAP_DPORT]);
-	}
-
-	return ret;
-}
-
 #ifdef CONFIG_IPV6_SIT_6RD
 /* This function returns true when 6RD attributes are present in the nl msg */
 static bool ipip6_netlink_6rd_parms(struct nlattr *data[],
@@ -1619,7 +1585,7 @@ static int ipip6_newlink(struct net *src_net, struct net_device *dev,
 
 	nt = netdev_priv(dev);
 
-	if (ipip6_netlink_encap_parms(data, &ipencap)) {
+	if (ip_tunnel_netlink_encap_parms(data, &ipencap)) {
 		err = ip_tunnel_encap_setup(nt, &ipencap);
 		if (err < 0)
 			return err;
@@ -1671,7 +1637,7 @@ static int ipip6_changelink(struct net_device *dev, struct nlattr *tb[],
 	if (dev == sitn->fb_tunnel_dev)
 		return -EINVAL;
 
-	if (ipip6_netlink_encap_parms(data, &ipencap)) {
+	if (ip_tunnel_netlink_encap_parms(data, &ipencap)) {
 		err = ip_tunnel_encap_setup(t, &ipencap);
 		if (err < 0)
 			return err;
-- 
2.17.1

