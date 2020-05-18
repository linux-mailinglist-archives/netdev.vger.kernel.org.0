Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D21861D896A
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 22:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgERUkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 16:40:33 -0400
Received: from novek.ru ([213.148.174.62]:49096 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726378AbgERUk1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 16:40:27 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id D8AC050294C;
        Mon, 18 May 2020 23:34:16 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru D8AC050294C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1589834062; bh=HHYIxdKLQzrD3cTtammRZmJYL2tBjyhPweHe3rzaGOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HPDi9kUeuXLj5QPXoVQAcfjEt1XlYfmvveXQHjCwgbGsuL+emg69M4xh0EaNC6wCd
         CzuZ+nMj/t47uijoMYx4bBB3wdNPTAASQsZBD380TDJnStOIlmBsuNs1Y8xV2sVUpI
         e/T477VrOy9NdBOntj3zF5qTfHNGKefBtjnIGNg4=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [net-next 4/5] ip6_tunnel: add generic MPLS receive support
Date:   Mon, 18 May 2020 23:33:47 +0300
Message-Id: <1589834028-9929-5-git-send-email-vfedorenko@novek.ru>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1589834028-9929-1-git-send-email-vfedorenko@novek.ru>
References: <1589834028-9929-1-git-send-email-vfedorenko@novek.ru>
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for MPLS in receive side.

Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 net/ipv6/ip6_tunnel.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 00ddd57..a17639f 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -718,6 +718,22 @@ __u16 ip6_tnl_parse_tlv_enc_lim(struct sk_buff *skb, __u8 *raw)
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_MPLS)
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
+#endif
+
 static int ip4ip6_dscp_ecn_decapsulate(const struct ip6_tnl *t,
 				       const struct ipv6hdr *ipv6h,
 				       struct sk_buff *skb)
@@ -740,6 +756,16 @@ static int ip6ip6_dscp_ecn_decapsulate(const struct ip6_tnl *t,
 	return IP6_ECN_decapsulate(ipv6h, skb);
 }
 
+#if IS_ENABLED(CONFIG_MPLS)
+static inline int mplsip6_dscp_ecn_decapsulate(const struct ip6_tnl *t,
+					       const struct ipv6hdr *ipv6h,
+					       struct sk_buff *skb)
+{
+	/* ECN is not supported in AF_MPLS */
+	return 0;
+}
+#endif
+
 __u32 ip6_tnl_get_cap(struct ip6_tnl *t,
 			     const struct in6_addr *laddr,
 			     const struct in6_addr *raddr)
@@ -901,6 +927,13 @@ int ip6_tnl_rcv(struct ip6_tnl *t, struct sk_buff *skb,
 	.proto = htons(ETH_P_IP),
 };
 
+#if IS_ENABLED(CONFIG_MPLS)
+static const struct tnl_ptk_info tpi_mpls = {
+	/* no tunnel info required for mplsip6. */
+	.proto = htons(ETH_P_MPLS_UC),
+};
+#endif
+
 static int ipxip6_rcv(struct sk_buff *skb, u8 ipproto,
 		      const struct tnl_ptk_info *tpi,
 		      int (*dscp_ecn_decapsulate)(const struct ip6_tnl *t,
@@ -958,6 +991,14 @@ static int ip6ip6_rcv(struct sk_buff *skb)
 			  ip6ip6_dscp_ecn_decapsulate);
 }
 
+#if IS_ENABLED(CONFIG_MPLS)
+static int mplsip6_rcv(struct sk_buff *skb)
+{
+	return ipxip6_rcv(skb, IPPROTO_MPLS, &tpi_mpls,
+			  mplsip6_dscp_ecn_decapsulate);
+}
+#endif
+
 struct ipv6_tel_txoption {
 	struct ipv6_txoptions ops;
 	__u8 dst_opt[8];
@@ -2200,6 +2241,14 @@ struct net *ip6_tnl_get_link_net(const struct net_device *dev)
 	.priority	=	1,
 };
 
+#if IS_ENABLED(CONFIG_MPLS)
+static struct xfrm6_tunnel mplsip6_handler __read_mostly = {
+	.handler	= mplsip6_rcv,
+	.err_handler	= mplsip6_err,
+	.priority	=	1,
+};
+#endif
+
 static void __net_exit ip6_tnl_destroy_tunnels(struct net *net, struct list_head *list)
 {
 	struct ip6_tnl_net *ip6n = net_generic(net, ip6_tnl_net_id);
@@ -2314,6 +2363,14 @@ static int __init ip6_tunnel_init(void)
 		pr_err("%s: can't register ip6ip6\n", __func__);
 		goto out_ip6ip6;
 	}
+#if IS_ENABLED(CONFIG_MPLS)
+	err = xfrm6_tunnel_register(&mplsip6_handler, AF_MPLS);
+	if (err < 0) {
+		pr_err("%s: can't register mplsip6\n", __func__);
+		goto out_mplsip6;
+	}
+#endif
+
 	err = rtnl_link_register(&ip6_link_ops);
 	if (err < 0)
 		goto rtnl_link_failed;
@@ -2321,6 +2378,10 @@ static int __init ip6_tunnel_init(void)
 	return 0;
 
 rtnl_link_failed:
+#if IS_ENABLED(CONFIG_MPLS)
+	xfrm6_tunnel_deregister(&mplsip6_handler, AF_MPLS);
+out_mplsip6:
+#endif
 	xfrm6_tunnel_deregister(&ip6ip6_handler, AF_INET6);
 out_ip6ip6:
 	xfrm6_tunnel_deregister(&ip4ip6_handler, AF_INET);
@@ -2343,6 +2404,10 @@ static void __exit ip6_tunnel_cleanup(void)
 	if (xfrm6_tunnel_deregister(&ip6ip6_handler, AF_INET6))
 		pr_info("%s: can't deregister ip6ip6\n", __func__);
 
+#if IS_ENABLED(CONFIG_MPLS)
+	if (xfrm6_tunnel_deregister(&mplsip6_handler, AF_MPLS))
+		pr_info("%s: can't deregister mplsip6\n", __func__);
+#endif
 	unregister_pernet_device(&ip6_tnl_net_ops);
 }
 
-- 
1.8.3.1

