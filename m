Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3981892EE
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 01:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbgCRAkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 20:40:14 -0400
Received: from correo.us.es ([193.147.175.20]:45598 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727186AbgCRAkM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 20:40:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0F78B27F8B3
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 012DEDA3A8
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:42 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EAC4CDA3A3; Wed, 18 Mar 2020 01:39:41 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0317DDA39F;
        Wed, 18 Mar 2020 01:39:40 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 18 Mar 2020 01:39:39 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id CD25F426CCB9;
        Wed, 18 Mar 2020 01:39:39 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 03/29] netfilter: nft_tunnel: add support for geneve opts
Date:   Wed, 18 Mar 2020 01:39:30 +0100
Message-Id: <20200318003956.73573-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200318003956.73573-1-pablo@netfilter.org>
References: <20200318003956.73573-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

Like vxlan and erspan opts, geneve opts should also be supported in
nft_tunnel. The difference is geneve RFC (draft-ietf-nvo3-geneve-14)
allows a geneve packet to carry multiple geneve opts. So with this
patch, nftables/libnftnl would do:

  # nft add table ip filter
  # nft add chain ip filter input { type filter hook input priority 0 \; }
  # nft add tunnel filter geneve_02 { type geneve\; id 2\; \
    ip saddr 192.168.1.1\; ip daddr 192.168.1.2\; \
    sport 9000\; dport 9001\; dscp 1234\; ttl 64\; flags 1\; \
    opts \"1:1:34567890,2:2:12121212,3:3:1212121234567890\"\; }
  # nft list tunnels table filter
    table ip filter {
    	tunnel geneve_02 {
    		id 2
    		ip saddr 192.168.1.1
    		ip daddr 192.168.1.2
    		sport 9000
    		dport 9001
    		tos 18
    		ttl 64
    		flags 1
    		geneve opts 1:1:34567890,2:2:12121212,3:3:1212121234567890
    	}
    }

v1->v2:
  - no changes, just post it separately.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |  10 +++
 net/netfilter/nft_tunnel.c               | 110 +++++++++++++++++++++++++++----
 2 files changed, 108 insertions(+), 12 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 065218a20bb7..9c3d2d04d6a1 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1770,6 +1770,7 @@ enum nft_tunnel_opts_attributes {
 	NFTA_TUNNEL_KEY_OPTS_UNSPEC,
 	NFTA_TUNNEL_KEY_OPTS_VXLAN,
 	NFTA_TUNNEL_KEY_OPTS_ERSPAN,
+	NFTA_TUNNEL_KEY_OPTS_GENEVE,
 	__NFTA_TUNNEL_KEY_OPTS_MAX
 };
 #define NFTA_TUNNEL_KEY_OPTS_MAX	(__NFTA_TUNNEL_KEY_OPTS_MAX - 1)
@@ -1791,6 +1792,15 @@ enum nft_tunnel_opts_erspan_attributes {
 };
 #define NFTA_TUNNEL_KEY_ERSPAN_MAX	(__NFTA_TUNNEL_KEY_ERSPAN_MAX - 1)
 
+enum nft_tunnel_opts_geneve_attributes {
+	NFTA_TUNNEL_KEY_GENEVE_UNSPEC,
+	NFTA_TUNNEL_KEY_GENEVE_CLASS,
+	NFTA_TUNNEL_KEY_GENEVE_TYPE,
+	NFTA_TUNNEL_KEY_GENEVE_DATA,
+	__NFTA_TUNNEL_KEY_GENEVE_MAX
+};
+#define NFTA_TUNNEL_KEY_GENEVE_MAX	(__NFTA_TUNNEL_KEY_GENEVE_MAX - 1)
+
 enum nft_tunnel_flags {
 	NFT_TUNNEL_F_ZERO_CSUM_TX	= (1 << 0),
 	NFT_TUNNEL_F_DONT_FRAGMENT	= (1 << 1),
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 764e88682a81..30be5787fbde 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -11,6 +11,7 @@
 #include <net/ip_tunnels.h>
 #include <net/vxlan.h>
 #include <net/erspan.h>
+#include <net/geneve.h>
 
 struct nft_tunnel {
 	enum nft_tunnel_keys	key:8;
@@ -144,6 +145,7 @@ struct nft_tunnel_opts {
 	union {
 		struct vxlan_metadata	vxlan;
 		struct erspan_metadata	erspan;
+		u8	data[IP_TUNNEL_OPTS_MAX];
 	} u;
 	u32	len;
 	__be16	flags;
@@ -301,9 +303,53 @@ static int nft_tunnel_obj_erspan_init(const struct nlattr *attr,
 	return 0;
 }
 
+static const struct nla_policy nft_tunnel_opts_geneve_policy[NFTA_TUNNEL_KEY_GENEVE_MAX + 1] = {
+	[NFTA_TUNNEL_KEY_GENEVE_CLASS]	= { .type = NLA_U16 },
+	[NFTA_TUNNEL_KEY_GENEVE_TYPE]	= { .type = NLA_U8 },
+	[NFTA_TUNNEL_KEY_GENEVE_DATA]	= { .type = NLA_BINARY, .len = 128 },
+};
+
+static int nft_tunnel_obj_geneve_init(const struct nlattr *attr,
+				      struct nft_tunnel_opts *opts)
+{
+	struct geneve_opt *opt = (struct geneve_opt *)opts->u.data + opts->len;
+	struct nlattr *tb[NFTA_TUNNEL_KEY_GENEVE_MAX + 1];
+	int err, data_len;
+
+	err = nla_parse_nested(tb, NFTA_TUNNEL_KEY_GENEVE_MAX, attr,
+			       nft_tunnel_opts_geneve_policy, NULL);
+	if (err < 0)
+		return err;
+
+	if (!tb[NFTA_TUNNEL_KEY_GENEVE_CLASS] ||
+	    !tb[NFTA_TUNNEL_KEY_GENEVE_TYPE] ||
+	    !tb[NFTA_TUNNEL_KEY_GENEVE_DATA])
+		return -EINVAL;
+
+	attr = tb[NFTA_TUNNEL_KEY_GENEVE_DATA];
+	data_len = nla_len(attr);
+	if (data_len % 4)
+		return -EINVAL;
+
+	opts->len += sizeof(*opt) + data_len;
+	if (opts->len > IP_TUNNEL_OPTS_MAX)
+		return -EINVAL;
+
+	memcpy(opt->opt_data, nla_data(attr), data_len);
+	opt->length = data_len / 4;
+	opt->opt_class = nla_get_be16(tb[NFTA_TUNNEL_KEY_GENEVE_CLASS]);
+	opt->type = nla_get_u8(tb[NFTA_TUNNEL_KEY_GENEVE_TYPE]);
+	opts->flags = TUNNEL_GENEVE_OPT;
+
+	return 0;
+}
+
 static const struct nla_policy nft_tunnel_opts_policy[NFTA_TUNNEL_KEY_OPTS_MAX + 1] = {
+	[NFTA_TUNNEL_KEY_OPTS_UNSPEC]	= {
+		.strict_start_type = NFTA_TUNNEL_KEY_OPTS_GENEVE },
 	[NFTA_TUNNEL_KEY_OPTS_VXLAN]	= { .type = NLA_NESTED, },
 	[NFTA_TUNNEL_KEY_OPTS_ERSPAN]	= { .type = NLA_NESTED, },
+	[NFTA_TUNNEL_KEY_OPTS_GENEVE]	= { .type = NLA_NESTED, },
 };
 
 static int nft_tunnel_obj_opts_init(const struct nft_ctx *ctx,
@@ -311,22 +357,43 @@ static int nft_tunnel_obj_opts_init(const struct nft_ctx *ctx,
 				    struct ip_tunnel_info *info,
 				    struct nft_tunnel_opts *opts)
 {
-	struct nlattr *tb[NFTA_TUNNEL_KEY_OPTS_MAX + 1];
-	int err;
+	int err, rem, type = 0;
+	struct nlattr *nla;
 
-	err = nla_parse_nested_deprecated(tb, NFTA_TUNNEL_KEY_OPTS_MAX, attr,
-					  nft_tunnel_opts_policy, NULL);
+	err = nla_validate_nested_deprecated(attr, NFTA_TUNNEL_KEY_OPTS_MAX,
+					     nft_tunnel_opts_policy, NULL);
 	if (err < 0)
 		return err;
 
-	if (tb[NFTA_TUNNEL_KEY_OPTS_VXLAN]) {
-		err = nft_tunnel_obj_vxlan_init(tb[NFTA_TUNNEL_KEY_OPTS_VXLAN],
-						opts);
-	} else if (tb[NFTA_TUNNEL_KEY_OPTS_ERSPAN]) {
-		err = nft_tunnel_obj_erspan_init(tb[NFTA_TUNNEL_KEY_OPTS_ERSPAN],
-						 opts);
-	} else {
-		return -EOPNOTSUPP;
+	nla_for_each_attr(nla, nla_data(attr), nla_len(attr), rem) {
+		switch (nla_type(nla)) {
+		case NFTA_TUNNEL_KEY_OPTS_VXLAN:
+			if (type)
+				return -EINVAL;
+			err = nft_tunnel_obj_vxlan_init(nla, opts);
+			if (err)
+				return err;
+			type = TUNNEL_VXLAN_OPT;
+			break;
+		case NFTA_TUNNEL_KEY_OPTS_ERSPAN:
+			if (type)
+				return -EINVAL;
+			err = nft_tunnel_obj_erspan_init(nla, opts);
+			if (err)
+				return err;
+			type = TUNNEL_ERSPAN_OPT;
+			break;
+		case NFTA_TUNNEL_KEY_OPTS_GENEVE:
+			if (type && type != TUNNEL_GENEVE_OPT)
+				return -EINVAL;
+			err = nft_tunnel_obj_geneve_init(nla, opts);
+			if (err)
+				return err;
+			type = TUNNEL_GENEVE_OPT;
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
 	}
 
 	return err;
@@ -518,6 +585,25 @@ static int nft_tunnel_opts_dump(struct sk_buff *skb,
 			break;
 		}
 		nla_nest_end(skb, inner);
+	} else if (opts->flags & TUNNEL_GENEVE_OPT) {
+		struct geneve_opt *opt;
+		int offset = 0;
+
+		inner = nla_nest_start_noflag(skb, NFTA_TUNNEL_KEY_OPTS_GENEVE);
+		if (!inner)
+			goto failure;
+		while (opts->len > offset) {
+			opt = (struct geneve_opt *)opts->u.data + offset;
+			if (nla_put_be16(skb, NFTA_TUNNEL_KEY_GENEVE_CLASS,
+					 opt->opt_class) ||
+			    nla_put_u8(skb, NFTA_TUNNEL_KEY_GENEVE_TYPE,
+				       opt->type) ||
+			    nla_put(skb, NFTA_TUNNEL_KEY_GENEVE_DATA,
+				    opt->length * 4, opt->opt_data))
+				goto inner_failure;
+			offset += sizeof(*opt) + opt->length * 4;
+		}
+		nla_nest_end(skb, inner);
 	}
 	nla_nest_end(skb, nest);
 	return 0;
-- 
2.11.0

