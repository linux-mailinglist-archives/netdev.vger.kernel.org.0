Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E750D1DB803
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 17:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgETPWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 11:22:01 -0400
Received: from novek.ru ([213.148.174.62]:60476 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726819AbgETPV5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 11:21:57 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 661DB50297E;
        Wed, 20 May 2020 18:21:52 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 661DB50297E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1589988113; bh=EATzDn8CkuoD8KA25LhgqUy+/2tX4p+oXKUVvfG58ZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BjS7Kvr4jUwFM35872HQTpuRh5B+iWaC0jA9AqMBqLB4gIG4uC4hU16+w27bDQWHg
         43zmizurk43ze80o1w27bHmtwNwDohWAT7UMDLq2pu7O7DhFGX7EKquuPFuITLct+4
         oIS9uWG8Zh/nS7ikgUN0wN0sgpVdQM5ouGjobcQ4=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [net-next v2 4/5] ip6_tunnel: add generic MPLS receive support
Date:   Wed, 20 May 2020 18:21:38 +0300
Message-Id: <1589988099-13095-5-git-send-email-vfedorenko@novek.ru>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1589988099-13095-1-git-send-email-vfedorenko@novek.ru>
References: <1589988099-13095-1-git-send-email-vfedorenko@novek.ru>
X-Spam-Status: No, score=1.7 required=5.0 tests=UNPARSEABLE_RELAY,URIBL_BLACK
        autolearn=no autolearn_force=no version=3.4.1
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for MPLS in receive side.

Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 net/ipv6/ip6_tunnel.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 6b94c87..821d96c 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -89,6 +89,11 @@ struct ip6_tnl_net {
 	struct ip6_tnl __rcu *collect_md_tun;
 };
 
+static inline int ip6_tnl_mpls_supported(void)
+{
+	return IS_ENABLED(CONFIG_MPLS);
+}
+
 static struct net_device_stats *ip6_get_stats(struct net_device *dev)
 {
 	struct pcpu_sw_netstats tmp, sum = { 0 };
@@ -718,6 +723,20 @@ __u16 ip6_tnl_parse_tlv_enc_lim(struct sk_buff *skb, __u8 *raw)
 	return 0;
 }
 
+static int
+mplsip6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
+	    u8 type, u8 code, int offset, __be32 info)
+{
+	__u32 rel_info = ntohl(info);
+	int err, rel_msg = 0;
+	u8 rel_type = type;
+	u8 rel_code = code;
+
+	err = ip6_tnl_err(skb, IPPROTO_MPLS, opt, &rel_type, &rel_code,
+			  &rel_msg, &rel_info, offset);
+	return err;
+}
+
 static int ip4ip6_dscp_ecn_decapsulate(const struct ip6_tnl *t,
 				       const struct ipv6hdr *ipv6h,
 				       struct sk_buff *skb)
@@ -740,6 +759,14 @@ static int ip6ip6_dscp_ecn_decapsulate(const struct ip6_tnl *t,
 	return IP6_ECN_decapsulate(ipv6h, skb);
 }
 
+static inline int mplsip6_dscp_ecn_decapsulate(const struct ip6_tnl *t,
+					       const struct ipv6hdr *ipv6h,
+					       struct sk_buff *skb)
+{
+	/* ECN is not supported in AF_MPLS */
+	return 0;
+}
+
 __u32 ip6_tnl_get_cap(struct ip6_tnl *t,
 			     const struct in6_addr *laddr,
 			     const struct in6_addr *raddr)
@@ -901,6 +928,11 @@ int ip6_tnl_rcv(struct ip6_tnl *t, struct sk_buff *skb,
 	.proto = htons(ETH_P_IP),
 };
 
+static const struct tnl_ptk_info tpi_mpls = {
+	/* no tunnel info required for mplsip6. */
+	.proto = htons(ETH_P_MPLS_UC),
+};
+
 static int ipxip6_rcv(struct sk_buff *skb, u8 ipproto,
 		      const struct tnl_ptk_info *tpi,
 		      int (*dscp_ecn_decapsulate)(const struct ip6_tnl *t,
@@ -958,6 +990,12 @@ static int ip6ip6_rcv(struct sk_buff *skb)
 			  ip6ip6_dscp_ecn_decapsulate);
 }
 
+static int mplsip6_rcv(struct sk_buff *skb)
+{
+	return ipxip6_rcv(skb, IPPROTO_MPLS, &tpi_mpls,
+			  mplsip6_dscp_ecn_decapsulate);
+}
+
 struct ipv6_tel_txoption {
 	struct ipv6_txoptions ops;
 	__u8 dst_opt[8];
@@ -2198,6 +2236,12 @@ struct net *ip6_tnl_get_link_net(const struct net_device *dev)
 	.priority	=	1,
 };
 
+static struct xfrm6_tunnel mplsip6_handler __read_mostly = {
+	.handler	= mplsip6_rcv,
+	.err_handler	= mplsip6_err,
+	.priority	=	1,
+};
+
 static void __net_exit ip6_tnl_destroy_tunnels(struct net *net, struct list_head *list)
 {
 	struct ip6_tnl_net *ip6n = net_generic(net, ip6_tnl_net_id);
@@ -2312,6 +2356,15 @@ static int __init ip6_tunnel_init(void)
 		pr_err("%s: can't register ip6ip6\n", __func__);
 		goto out_ip6ip6;
 	}
+
+	if (ip6_tnl_mpls_supported()) {
+		err = xfrm6_tunnel_register(&mplsip6_handler, AF_MPLS);
+		if (err < 0) {
+			pr_err("%s: can't register mplsip6\n", __func__);
+			goto out_mplsip6;
+		}
+	}
+
 	err = rtnl_link_register(&ip6_link_ops);
 	if (err < 0)
 		goto rtnl_link_failed;
@@ -2319,6 +2372,9 @@ static int __init ip6_tunnel_init(void)
 	return 0;
 
 rtnl_link_failed:
+	if (ip6_tnl_mpls_supported())
+		xfrm6_tunnel_deregister(&mplsip6_handler, AF_MPLS);
+out_mplsip6:
 	xfrm6_tunnel_deregister(&ip6ip6_handler, AF_INET6);
 out_ip6ip6:
 	xfrm6_tunnel_deregister(&ip4ip6_handler, AF_INET);
@@ -2341,6 +2397,9 @@ static void __exit ip6_tunnel_cleanup(void)
 	if (xfrm6_tunnel_deregister(&ip6ip6_handler, AF_INET6))
 		pr_info("%s: can't deregister ip6ip6\n", __func__);
 
+	if (ip6_tnl_mpls_supported() &&
+	    xfrm6_tunnel_deregister(&mplsip6_handler, AF_MPLS))
+		pr_info("%s: can't deregister mplsip6\n", __func__);
 	unregister_pernet_device(&ip6_tnl_net_ops);
 }
 
-- 
1.8.3.1

