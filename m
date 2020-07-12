Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3498C21CB44
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 22:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbgGLUHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 16:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729012AbgGLUHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 16:07:35 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8503EC061794
        for <netdev@vger.kernel.org>; Sun, 12 Jul 2020 13:07:35 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1juiG6-0002dh-4g; Sun, 12 Jul 2020 22:07:34 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     aconole@redhat.com, sbrivio@redhat.com,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 3/3] geneve: allow disabling of pmtu detection on encap sk
Date:   Sun, 12 Jul 2020 22:07:05 +0200
Message-Id: <20200712200705.9796-4-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200712200705.9796-1-fw@strlen.de>
References: <20200712200705.9796-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

same as vxlan change, compile tested only.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 drivers/net/geneve.c         | 59 ++++++++++++++++++++++++++++++++----
 include/uapi/linux/if_link.h |  1 +
 2 files changed, 54 insertions(+), 6 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 49b00def2eef..19c1c74f6b5e 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -53,6 +53,8 @@ struct geneve_config {
 	bool			collect_md;
 	bool			use_udp6_rx_checksums;
 	bool			ttl_inherit;
+	u8			pmtudisc:1;
+	u8			pmtudiscv:3;
 	enum ifla_geneve_df	df;
 };
 
@@ -442,8 +444,10 @@ static int geneve_udp_encap_err_lookup(struct sock *sk, struct sk_buff *skb)
 }
 
 static struct socket *geneve_create_sock(struct net *net, bool ipv6,
-					 __be16 port, bool ipv6_rx_csum)
+					 const struct geneve_config *cfg)
 {
+	bool ipv6_rx_csum = cfg->use_udp6_rx_checksums;
+	__be16 port = cfg->info.key.tp_dst;
 	struct socket *sock;
 	struct udp_port_cfg udp_conf;
 	int err;
@@ -459,6 +463,11 @@ static struct socket *geneve_create_sock(struct net *net, bool ipv6,
 		udp_conf.local_ip.s_addr = htonl(INADDR_ANY);
 	}
 
+	if (cfg->pmtudisc) {
+		udp_conf.ip_pmtudisc = 1;
+		udp_conf.ip_pmtudiscv = cfg->pmtudiscv;
+	}
+
 	udp_conf.local_udp_port = port;
 
 	/* Open UDP socket */
@@ -564,8 +573,9 @@ static int geneve_gro_complete(struct sock *sk, struct sk_buff *skb,
 }
 
 /* Create new listen socket if needed */
-static struct geneve_sock *geneve_socket_create(struct net *net, __be16 port,
-						bool ipv6, bool ipv6_rx_csum)
+static struct geneve_sock *geneve_socket_create(struct net *net,
+						const struct geneve_config *cfg,
+						bool ipv6)
 {
 	struct geneve_net *gn = net_generic(net, geneve_net_id);
 	struct geneve_sock *gs;
@@ -577,7 +587,7 @@ static struct geneve_sock *geneve_socket_create(struct net *net, __be16 port,
 	if (!gs)
 		return ERR_PTR(-ENOMEM);
 
-	sock = geneve_create_sock(net, ipv6, port, ipv6_rx_csum);
+	sock = geneve_create_sock(net, ipv6, cfg);
 	if (IS_ERR(sock)) {
 		kfree(gs);
 		return ERR_CAST(sock);
@@ -664,8 +674,7 @@ static int geneve_sock_add(struct geneve_dev *geneve, bool ipv6)
 		goto out;
 	}
 
-	gs = geneve_socket_create(net, geneve->cfg.info.key.tp_dst, ipv6,
-				  geneve->cfg.use_udp6_rx_checksums);
+	gs = geneve_socket_create(net, &geneve->cfg, ipv6);
 	if (IS_ERR(gs))
 		return PTR_ERR(gs);
 
@@ -1173,6 +1182,7 @@ static const struct nla_policy geneve_policy[IFLA_GENEVE_MAX + 1] = {
 	[IFLA_GENEVE_UDP_ZERO_CSUM6_RX]	= { .type = NLA_U8 },
 	[IFLA_GENEVE_TTL_INHERIT]	= { .type = NLA_U8 },
 	[IFLA_GENEVE_DF]		= { .type = NLA_U8 },
+	[IFLA_GENEVE_PMTUDISC]		= { .type = NLA_U8 },
 };
 
 static int geneve_validate(struct nlattr *tb[], struct nlattr *data[],
@@ -1411,6 +1421,21 @@ static int geneve_nl2info(struct nlattr *tb[], struct nlattr *data[],
 		info->key.ttl = nla_get_u8(data[IFLA_GENEVE_TTL]);
 		cfg->ttl_inherit = false;
 	}
+	if (data[IFLA_GENEVE_PMTUDISC]) {
+		int pmtuv = nla_get_u8(data[IFLA_GENEVE_PMTUDISC]);
+
+		if (pmtuv < IP_PMTUDISC_DONT) {
+			NL_SET_ERR_MSG_ATTR(extack, tb[IFLA_GENEVE_PMTUDISC], "PMTUDISC Value < 0");
+			return -EOPNOTSUPP;
+		}
+		if (pmtuv > IP_PMTUDISC_OMIT) {
+			NL_SET_ERR_MSG_ATTR(extack, tb[IFLA_GENEVE_PMTUDISC], "PMTUDISC Value > IP_PMTUDISC_OMIT");
+			return -EOPNOTSUPP;
+		}
+
+		cfg->pmtudisc = 1;
+		cfg->pmtudiscv = pmtuv;
+	}
 
 	if (data[IFLA_GENEVE_TOS])
 		info->key.tos = nla_get_u8(data[IFLA_GENEVE_TOS]);
@@ -1634,6 +1659,23 @@ static int geneve_changelink(struct net_device *dev, struct nlattr *tb[],
 	}
 
 	geneve_quiesce(geneve, &gs4, &gs6);
+
+	if (cfg.pmtudisc && cfg.pmtudiscv != geneve->cfg.pmtudiscv) {
+		struct socket *sock;
+
+		if (gs4) {
+			sock = gs4->sock;
+			ip_sock_set_mtu_discover(sock->sk, cfg.pmtudiscv);
+		}
+#if IS_ENABLED(CONFIG_IPV6)
+		if (gs6) {
+			sock = gs6->sock;
+			ip6_sock_set_mtu_discover(sock->sk, cfg.pmtudiscv);
+			ip_sock_set_mtu_discover(sock->sk, cfg.pmtudiscv);
+		}
+#endif
+	}
+
 	memcpy(&geneve->cfg, &cfg, sizeof(cfg));
 	geneve_unquiesce(geneve, gs4, gs6);
 
@@ -1655,6 +1697,7 @@ static size_t geneve_get_size(const struct net_device *dev)
 		nla_total_size(sizeof(__u8)) +  /* IFLA_GENEVE_TTL */
 		nla_total_size(sizeof(__u8)) +  /* IFLA_GENEVE_TOS */
 		nla_total_size(sizeof(__u8)) +	/* IFLA_GENEVE_DF */
+		nla_total_size(sizeof(__u8)) +	/* IFLA_GENEVE_PMTUDISC */
 		nla_total_size(sizeof(__be32)) +  /* IFLA_GENEVE_LABEL */
 		nla_total_size(sizeof(__be16)) +  /* IFLA_GENEVE_PORT */
 		nla_total_size(0) +	 /* IFLA_GENEVE_COLLECT_METADATA */
@@ -1706,6 +1749,10 @@ static int geneve_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	if (nla_put_u8(skb, IFLA_GENEVE_DF, geneve->cfg.df))
 		goto nla_put_failure;
 
+	if (geneve->cfg.pmtudisc &&
+	    nla_put_u8(skb, IFLA_GENEVE_PMTUDISC, geneve->cfg.pmtudiscv))
+		goto nla_put_failure;
+
 	if (nla_put_be16(skb, IFLA_GENEVE_PORT, info->key.tp_dst))
 		goto nla_put_failure;
 
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index f22cf508871c..2ca0059b7d1a 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -582,6 +582,7 @@ enum {
 	IFLA_GENEVE_LABEL,
 	IFLA_GENEVE_TTL_INHERIT,
 	IFLA_GENEVE_DF,
+	IFLA_GENEVE_PMTUDISC,
 	__IFLA_GENEVE_MAX
 };
 #define IFLA_GENEVE_MAX	(__IFLA_GENEVE_MAX - 1)
-- 
2.26.2

