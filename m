Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC68E6C2851
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 03:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbjCUCt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 22:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjCUCt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 22:49:56 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BF02943C
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 19:49:52 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id y2so14251205pjg.3
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 19:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=theori.io; s=google; t=1679366992;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qZnmqti1kKvJtdCDGtIyOX5rZ5k0sOrbrmv7P0JPFUA=;
        b=WGYru/o04WHzWOUEOhfIT7viJVz9xH+WTGz6yKm+sQZy0StzaYqhF3q82jxmaDkA8i
         lKSvbwKKBsxut2nGg1/a1fsqxCe4bRJKnuTfvAFMjc3gxQY8TyThANMTuEEoggqHJyAc
         Juadl2vuy2lmNg1+B3o7GrbPUcpeO07UVnmts=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679366992;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qZnmqti1kKvJtdCDGtIyOX5rZ5k0sOrbrmv7P0JPFUA=;
        b=Yw6B1vfSdzR4GDc3pocDCLRm29oC/ahZNjXmfUjKx85XSS9bpGHZX2QGUi/97bJQrK
         7lNeMpMiL35bvGjLuGyKrtGui0uHRZ4NbVhpepbRKc/zS2uAMxtXtiKHE2s6ARJC3CEd
         7AyLyR3K6OIEQipssR3cRyv2AlTA4auaRTxGYx2mW5XfDqNy0z2aL5vplqGlafvk7I4O
         p3qvbyNRL3GRPRO+NQQXCCXPRgB6I/THGRle/sEG4XuW5EXPxKMjbnQGjUEmTVfwXWvR
         NarPXdNsP1Fvw5GW+CesUQpjyjTweIRcyWVyXgrKIOEc//o9P4xpRwmPeF3XWK/Ln45q
         FQ7A==
X-Gm-Message-State: AO0yUKXRwjaB4NtX5jsSCJ/SRc7XZ6jprjhLTa3SinRnOJSlBLWqXEv1
        /h/wKLcLUPefW7UCb2j1bKDdRA==
X-Google-Smtp-Source: AK7set9aY4fzSd3lk2vwG5IQaPm5q/XEImEd1oL3IcqCvC+T7UEDwTtsiqNPTcZt5+U6c3GBnc+x/g==
X-Received: by 2002:a05:6a20:b829:b0:cd:74aa:df76 with SMTP id fi41-20020a056a20b82900b000cd74aadf76mr488174pzb.50.1679366991894;
        Mon, 20 Mar 2023 19:49:51 -0700 (PDT)
Received: from ubuntu ([121.133.63.188])
        by smtp.gmail.com with ESMTPSA id h17-20020aa786d1000000b00627fafe49f9sm2740852pfo.106.2023.03.20.19.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 19:49:51 -0700 (PDT)
Date:   Mon, 20 Mar 2023 19:49:46 -0700
From:   Hyunwoo Kim <v4bel@theori.io>
To:     Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Dmitry Kozlov <xeb@mail.ru>,
        David Ahern <dsahern@kernel.org>
Cc:     tudordana@google.com, netdev@vger.kernel.org, imv4bel@gmail.com,
        v4bel@theori.io
Subject: [PATCH] net: Fix invalid ip_route_output_ports() call
Message-ID: <20230321024946.GA21870@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If you pass the address of the struct flowi4 you declared as a
local variable as the fl4 argument to ip_route_output_ports(),
the subsequent call to xfrm_state_find() will read the local
variable by AF_INET6 rather than AF_INET as per policy,
which could cause it to go out of scope on the kernel stack.

Reported-by: syzbot+ada7c035554bcee65580@syzkaller.appspotmail.com
Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
---
 drivers/net/amt.c                                | 15 +++++++++------
 .../net/ethernet/chelsio/libcxgb/libcxgb_cm.c    |  5 +++--
 drivers/net/ppp/pptp.c                           | 14 ++++++++------
 net/ipv4/datagram.c                              |  5 +++--
 net/ipv4/igmp.c                                  | 16 +++++++++-------
 net/ipv4/ipmr.c                                  |  7 ++++---
 net/ipv6/ip6_tunnel.c                            |  7 ++++---
 net/ipv6/sit.c                                   |  5 +++--
 8 files changed, 43 insertions(+), 31 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 2d20be6ffb7e..4d8caaedc9d4 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -617,7 +617,8 @@ static void amt_send_discovery(struct amt_dev *amt)
 	struct sk_buff *skb;
 	struct iphdr *iph;
 	struct rtable *rt;
-	struct flowi4 fl4;
+	struct flowi fl;
+	struct flowi4 *fl4 = &fl.u.ip4;
 	u32 len;
 	int err;
 
@@ -629,7 +630,7 @@ static void amt_send_discovery(struct amt_dev *amt)
 	if (!netif_running(amt->stream_dev) || !netif_running(amt->dev))
 		goto out;
 
-	rt = ip_route_output_ports(amt->net, &fl4, sock->sk,
+	rt = ip_route_output_ports(amt->net, fl4, sock->sk,
 				   amt->discovery_ip, amt->local_ip,
 				   amt->gw_port, amt->relay_port,
 				   IPPROTO_UDP, 0,
@@ -706,7 +707,8 @@ static void amt_send_request(struct amt_dev *amt, bool v6)
 	struct sk_buff *skb;
 	struct iphdr *iph;
 	struct rtable *rt;
-	struct flowi4 fl4;
+	struct flowi fl;
+	struct flowi4 *fl4 = &fl.u.ip4;
 	u32 len;
 	int err;
 
@@ -718,7 +720,7 @@ static void amt_send_request(struct amt_dev *amt, bool v6)
 	if (!netif_running(amt->stream_dev) || !netif_running(amt->dev))
 		goto out;
 
-	rt = ip_route_output_ports(amt->net, &fl4, sock->sk,
+	rt = ip_route_output_ports(amt->net, fl4, sock->sk,
 				   amt->remote_ip, amt->local_ip,
 				   amt->gw_port, amt->relay_port,
 				   IPPROTO_UDP, 0,
@@ -2554,7 +2556,8 @@ static void amt_send_advertisement(struct amt_dev *amt, __be32 nonce,
 	struct sk_buff *skb;
 	struct iphdr *iph;
 	struct rtable *rt;
-	struct flowi4 fl4;
+	struct flowi fl;
+	struct flowi4 *fl4 = &fl.u.ip4;
 	u32 len;
 	int err;
 
@@ -2566,7 +2569,7 @@ static void amt_send_advertisement(struct amt_dev *amt, __be32 nonce,
 	if (!netif_running(amt->stream_dev) || !netif_running(amt->dev))
 		goto out;
 
-	rt = ip_route_output_ports(amt->net, &fl4, sock->sk,
+	rt = ip_route_output_ports(amt->net, fl4, sock->sk,
 				   daddr, amt->local_ip,
 				   dport, amt->relay_port,
 				   IPPROTO_UDP, 0,
diff --git a/drivers/net/ethernet/chelsio/libcxgb/libcxgb_cm.c b/drivers/net/ethernet/chelsio/libcxgb/libcxgb_cm.c
index da8d10475a08..e06a6d0a3595 100644
--- a/drivers/net/ethernet/chelsio/libcxgb/libcxgb_cm.c
+++ b/drivers/net/ethernet/chelsio/libcxgb/libcxgb_cm.c
@@ -95,10 +95,11 @@ cxgb_find_route(struct cxgb4_lld_info *lldi,
 		__be16 peer_port, u8 tos)
 {
 	struct rtable *rt;
-	struct flowi4 fl4;
+	struct flowi fl;
+	struct flowi4 *fl4 = &fl.u.ip4;
 	struct neighbour *n;
 
-	rt = ip_route_output_ports(&init_net, &fl4, NULL, peer_ip, local_ip,
+	rt = ip_route_output_ports(&init_net, fl4, NULL, peer_ip, local_ip,
 				   peer_port, local_port, IPPROTO_TCP,
 				   tos & ~INET_ECN_MASK, 0);
 	if (IS_ERR(rt))
diff --git a/drivers/net/ppp/pptp.c b/drivers/net/ppp/pptp.c
index 0fe78826c8fa..6e4422ce89b5 100644
--- a/drivers/net/ppp/pptp.c
+++ b/drivers/net/ppp/pptp.c
@@ -136,7 +136,8 @@ static int pptp_xmit(struct ppp_channel *chan, struct sk_buff *skb)
 	struct pptp_opt *opt = &po->proto.pptp;
 	struct pptp_gre_header *hdr;
 	unsigned int header_len = sizeof(*hdr);
-	struct flowi4 fl4;
+	struct flowi fl;
+	struct flowi4 *fl4 = &fl.u.ip4;
 	int islcp;
 	int len;
 	unsigned char *data;
@@ -151,7 +152,7 @@ static int pptp_xmit(struct ppp_channel *chan, struct sk_buff *skb)
 	if (sk_pppox(po)->sk_state & PPPOX_DEAD)
 		goto tx_error;
 
-	rt = ip_route_output_ports(net, &fl4, NULL,
+	rt = ip_route_output_ports(net, fl4, NULL,
 				   opt->dst_addr.sin_addr.s_addr,
 				   opt->src_addr.sin_addr.s_addr,
 				   0, 0, IPPROTO_GRE,
@@ -230,8 +231,8 @@ static int pptp_xmit(struct ppp_channel *chan, struct sk_buff *skb)
 		iph->frag_off	=	0;
 	iph->protocol = IPPROTO_GRE;
 	iph->tos      = 0;
-	iph->daddr    = fl4.daddr;
-	iph->saddr    = fl4.saddr;
+	iph->daddr    = fl4->daddr;
+	iph->saddr    = fl4->saddr;
 	iph->ttl      = ip4_dst_hoplimit(&rt->dst);
 	iph->tot_len  = htons(skb->len);
 
@@ -405,7 +406,8 @@ static int pptp_connect(struct socket *sock, struct sockaddr *uservaddr,
 	struct pppox_sock *po = pppox_sk(sk);
 	struct pptp_opt *opt = &po->proto.pptp;
 	struct rtable *rt;
-	struct flowi4 fl4;
+	struct flowi fl;
+	struct flowi4 *fl4 = &fl.u.ip4;
 	int error = 0;
 
 	if (sockaddr_len < sizeof(struct sockaddr_pppox))
@@ -438,7 +440,7 @@ static int pptp_connect(struct socket *sock, struct sockaddr *uservaddr,
 	po->chan.private = sk;
 	po->chan.ops = &pptp_chan_ops;
 
-	rt = ip_route_output_ports(sock_net(sk), &fl4, sk,
+	rt = ip_route_output_ports(sock_net(sk), fl4, sk,
 				   opt->dst_addr.sin_addr.s_addr,
 				   opt->src_addr.sin_addr.s_addr,
 				   0, 0,
diff --git a/net/ipv4/datagram.c b/net/ipv4/datagram.c
index 4d1af0cd7d99..12656eb49e50 100644
--- a/net/ipv4/datagram.c
+++ b/net/ipv4/datagram.c
@@ -103,7 +103,8 @@ void ip4_datagram_release_cb(struct sock *sk)
 	const struct ip_options_rcu *inet_opt;
 	__be32 daddr = inet->inet_daddr;
 	struct dst_entry *dst;
-	struct flowi4 fl4;
+	struct flowi fl;
+	struct flowi4 *fl4 = &fl.u.ip4;
 	struct rtable *rt;
 
 	rcu_read_lock();
@@ -116,7 +117,7 @@ void ip4_datagram_release_cb(struct sock *sk)
 	inet_opt = rcu_dereference(inet->inet_opt);
 	if (inet_opt && inet_opt->opt.srr)
 		daddr = inet_opt->opt.faddr;
-	rt = ip_route_output_ports(sock_net(sk), &fl4, sk, daddr,
+	rt = ip_route_output_ports(sock_net(sk), fl4, sk, daddr,
 				   inet->inet_saddr, inet->inet_dport,
 				   inet->inet_sport, sk->sk_protocol,
 				   RT_CONN_FLAGS(sk), sk->sk_bound_dev_if);
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index c920aa9a62a9..b7de65708b37 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -350,7 +350,8 @@ static struct sk_buff *igmpv3_newpack(struct net_device *dev, unsigned int mtu)
 	struct iphdr *pip;
 	struct igmpv3_report *pig;
 	struct net *net = dev_net(dev);
-	struct flowi4 fl4;
+	struct flowi fl;
+	struct flowi4 *fl4 = &fl.u.ip4;
 	int hlen = LL_RESERVED_SPACE(dev);
 	int tlen = dev->needed_tailroom;
 	unsigned int size = mtu;
@@ -366,7 +367,7 @@ static struct sk_buff *igmpv3_newpack(struct net_device *dev, unsigned int mtu)
 	}
 	skb->priority = TC_PRIO_CONTROL;
 
-	rt = ip_route_output_ports(net, &fl4, NULL, IGMPV3_ALL_MCR, 0,
+	rt = ip_route_output_ports(net, fl4, NULL, IGMPV3_ALL_MCR, 0,
 				   0, 0,
 				   IPPROTO_IGMP, 0, dev->ifindex);
 	if (IS_ERR(rt)) {
@@ -389,10 +390,10 @@ static struct sk_buff *igmpv3_newpack(struct net_device *dev, unsigned int mtu)
 	pip->tos      = 0xc0;
 	pip->frag_off = htons(IP_DF);
 	pip->ttl      = 1;
-	pip->daddr    = fl4.daddr;
+	pip->daddr    = fl4->daddr;
 
 	rcu_read_lock();
-	pip->saddr    = igmpv3_get_srcaddr(dev, &fl4);
+	pip->saddr    = igmpv3_get_srcaddr(dev, fl4);
 	rcu_read_unlock();
 
 	pip->protocol = IPPROTO_IGMP;
@@ -730,7 +731,8 @@ static int igmp_send_report(struct in_device *in_dev, struct ip_mc_list *pmc,
 	struct net_device *dev = in_dev->dev;
 	struct net *net = dev_net(dev);
 	__be32	group = pmc ? pmc->multiaddr : 0;
-	struct flowi4 fl4;
+	struct flowi fl;
+	struct flowi4 *fl4 = &fl.u.ip4;
 	__be32	dst;
 	int hlen, tlen;
 
@@ -746,7 +748,7 @@ static int igmp_send_report(struct in_device *in_dev, struct ip_mc_list *pmc,
 	else
 		dst = group;
 
-	rt = ip_route_output_ports(net, &fl4, NULL, dst, 0,
+	rt = ip_route_output_ports(net, fl4, NULL, dst, 0,
 				   0, 0,
 				   IPPROTO_IGMP, 0, dev->ifindex);
 	if (IS_ERR(rt))
@@ -775,7 +777,7 @@ static int igmp_send_report(struct in_device *in_dev, struct ip_mc_list *pmc,
 	iph->frag_off = htons(IP_DF);
 	iph->ttl      = 1;
 	iph->daddr    = dst;
-	iph->saddr    = fl4.saddr;
+	iph->saddr    = fl4->saddr;
 	iph->protocol = IPPROTO_IGMP;
 	ip_select_ident(net, skb, NULL);
 	((u8 *)&iph[1])[0] = IPOPT_RA;
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index eec1f6df80d8..994dd589835c 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1829,7 +1829,8 @@ static void ipmr_queue_xmit(struct net *net, struct mr_table *mrt,
 	struct net_device *vif_dev;
 	struct net_device *dev;
 	struct rtable *rt;
-	struct flowi4 fl4;
+	struct flowi fl;
+	struct flowi4 *fl4 = &fl.u.ip4;
 	int    encap = 0;
 
 	vif_dev = vif_dev_read(vif);
@@ -1849,7 +1850,7 @@ static void ipmr_queue_xmit(struct net *net, struct mr_table *mrt,
 		goto out_free;
 
 	if (vif->flags & VIFF_TUNNEL) {
-		rt = ip_route_output_ports(net, &fl4, NULL,
+		rt = ip_route_output_ports(net, fl4, NULL,
 					   vif->remote, vif->local,
 					   0, 0,
 					   IPPROTO_IPIP,
@@ -1858,7 +1859,7 @@ static void ipmr_queue_xmit(struct net *net, struct mr_table *mrt,
 			goto out_free;
 		encap = sizeof(struct iphdr);
 	} else {
-		rt = ip_route_output_ports(net, &fl4, NULL, iph->daddr, 0,
+		rt = ip_route_output_ports(net, fl4, NULL, iph->daddr, 0,
 					   0, 0,
 					   IPPROTO_IPIP,
 					   RT_TOS(iph->tos), vif->link);
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 47b6607a1370..078a97742b7d 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -567,7 +567,8 @@ ip4ip6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	u8 rel_type = type;
 	u8 rel_code = code;
 	struct rtable *rt;
-	struct flowi4 fl4;
+	struct flowi fl;
+	struct flowi4 *fl4 = &fl.u.ip4;
 
 	err = ip6_tnl_err(skb, IPPROTO_IPIP, opt, &rel_type, &rel_code,
 			  &rel_msg, &rel_info, offset);
@@ -608,7 +609,7 @@ ip4ip6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	eiph = ip_hdr(skb2);
 
 	/* Try to guess incoming interface */
-	rt = ip_route_output_ports(dev_net(skb->dev), &fl4, NULL, eiph->saddr,
+	rt = ip_route_output_ports(dev_net(skb->dev), fl4, NULL, eiph->saddr,
 				   0, 0, 0, IPPROTO_IPIP, RT_TOS(eiph->tos), 0);
 	if (IS_ERR(rt))
 		goto out;
@@ -618,7 +619,7 @@ ip4ip6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 
 	/* route "incoming" packet */
 	if (rt->rt_flags & RTCF_LOCAL) {
-		rt = ip_route_output_ports(dev_net(skb->dev), &fl4, NULL,
+		rt = ip_route_output_ports(dev_net(skb->dev), fl4, NULL,
 					   eiph->daddr, eiph->saddr, 0, 0,
 					   IPPROTO_IPIP, RT_TOS(eiph->tos), 0);
 		if (IS_ERR(rt) || rt->dst.dev->type != ARPHRD_TUNNEL6) {
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 70d81bba5093..fc2fb6bae588 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1098,13 +1098,14 @@ static void ipip6_tunnel_bind_dev(struct net_device *dev)
 	struct net_device *tdev = NULL;
 	struct ip_tunnel *tunnel;
 	const struct iphdr *iph;
-	struct flowi4 fl4;
+	struct flowi fl;
+	struct flowi4 *fl4 = &fl.u.ip4;
 
 	tunnel = netdev_priv(dev);
 	iph = &tunnel->parms.iph;
 
 	if (iph->daddr) {
-		struct rtable *rt = ip_route_output_ports(tunnel->net, &fl4,
+		struct rtable *rt = ip_route_output_ports(tunnel->net, fl4,
 							  NULL,
 							  iph->daddr, iph->saddr,
 							  0, 0,
-- 
2.25.1

