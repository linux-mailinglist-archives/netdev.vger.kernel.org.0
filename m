Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE722156EE5
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 06:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgBJFlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 00:41:31 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41908 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgBJFlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 00:41:31 -0500
Received: by mail-pg1-f194.google.com with SMTP id 70so1162921pgf.8;
        Sun, 09 Feb 2020 21:41:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1W5XcRqVmJmMMk1wLIPd/WaJz48kiVMXCekGZFNA3CA=;
        b=ODjtxhPDHvBplnZKIaS9fRWXC3AbbGxPXiGzG8ITT4xAJ4qIJOKr5YFFWvHK0XjVjO
         F1uSutuQASjvLr7fDgoSG6hKOXXXfw71gp9bxa0LLdkjollR6dQqPt/uhVPsw+dXuDC7
         P7Y5g/Aizd9jn4HvH4dxQ/hxYg9vmq1QBWDBnUXJ+tPRRJNkhUWPCe0A8O3Eu6x8GP5B
         O2GgqdsQh13fsEYua2XwBCtIyRzMMdGBe7YRKPNvoqZRhdq74DZ2ov6KyBPEqto16aoz
         lgacmrXvRXyjp5urESMyT9C0cwv8btx8WQPsm7/2UoHfy8iAWTgDd09R77IuXNIX8g03
         Y5/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1W5XcRqVmJmMMk1wLIPd/WaJz48kiVMXCekGZFNA3CA=;
        b=hMjMLzOl9482G6Q//JraGYyBb1gsxLQms6lZtdV3Hwq82CBkMQxTGQYqxtN+ZDzh3G
         l/WTzeWN4BeQMmODfIWP9ivDjfQkP1FAPWcV7Cf8R7iqEqHZuXjEnOI8infwziKGjdDi
         DK5rLxtizQVSm2rk7mPtiJJ0d7g0JH3yF84MppQmjT/g7SyH/wl1/bmbiXrA+K8kjYwT
         liriVCrcZ3pLRMSGrKI9dyD+CVPx78Sg4HQXLoB6cOhy7++zNMiGpZfLsKfTK2k0ADZs
         LEEsQwq5iiPI0RnGqamB2NNJs+96u4hIvgYb+uVi8L89mxR4Mzf6jhs+LU589mo2iky2
         vPiA==
X-Gm-Message-State: APjAAAWYYpxefR/y66KxsdViLtip2bL6+opYlSSWvRVaFGns4ilLAvaE
        uqpzFJUT81msg4s+BdGXX7s2VVYOIsw=
X-Google-Smtp-Source: APXvYqzJRVC8XENq9SJBQ5u45QGMI8ThC+rOrQgvJNxty9grFl4vqDVtssO5hO4Nu/lE25nU4X/TKQ==
X-Received: by 2002:aa7:8088:: with SMTP id v8mr11764630pff.142.1581313290429;
        Sun, 09 Feb 2020 21:41:30 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i68sm10735094pfe.173.2020.02.09.21.41.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Feb 2020 21:41:29 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCHv2 nf-next] netfilter: nft_tunnel: add support for geneve opts
Date:   Mon, 10 Feb 2020 13:41:22 +0800
Message-Id: <0711b62fce237dfde2d02e92d4d273c9578818ef.1581313282.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 include/uapi/linux/netfilter/nf_tables.h |  10 +++
 net/netfilter/nft_tunnel.c               | 110 +++++++++++++++++++++++++++----
 2 files changed, 108 insertions(+), 12 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 065218a..9c3d2d0 100644
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
index 4c3f2e24..3a60794 100644
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
@@ -516,6 +583,25 @@ static int nft_tunnel_opts_dump(struct sk_buff *skb,
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
2.1.0

