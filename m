Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73FAA13A851
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 12:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729262AbgANLXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 06:23:49 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:36709 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726053AbgANLXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 06:23:48 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id AE0E221DC6;
        Tue, 14 Jan 2020 06:23:47 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 14 Jan 2020 06:23:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=WDmrJ+52J8h23G9TCXjkyjtxEyJk7FyLkaNizgrIW6I=; b=XMPKQ9e9
        HhaFbzsr5V0Nd23y6Osi8uLR6lqifNkQK89SY58Lx3xUzMjOunk3/jCy7Am5frpO
        kaSj8oiwcRhljH3iso0TK4apzK2pkoDvlonp5YK0pw+gYyiOc8I1IxxXRGx/XuSg
        1pkUMDIVrLt9u9uoVehtKT/NgE0SbLuLShUEhIeknQbLOFoPz/gwCv7WPbZSVQlR
        Fct7l918WOpmMLZycuW0zu91qb8jQQ0E0HRW5VBwYzRtxaQhqZjdADoY2TvM+5Ap
        qpL4oo82smJLcmMIu4rh8W7NXwpaAuHt6cgZvbqYHh4yPK7Ftm5T5e/a3vLhMa/X
        PJmcki/BsQ31Ug==
X-ME-Sender: <xms:w6QdXoDe3_inCyUQYWDU6zb0WYH-WqpkPmCtkVt77HZVxV8T6xk_4g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrtddtgddtlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:w6QdXnMI40S_4H_K_hmirRffsxGbCpBvhxq4IOh6TEu5PX6ucUertg>
    <xmx:w6QdXvfNM0yCd_BKDBZDHFcVWmPXROWJ0kRwaOZhlDjjEgTVTrS4_w>
    <xmx:w6QdXo6PlKwoGZmDD0sf9cz3VSJ4eurFAMzhh8Ma9ozNjIZm4jIQiQ>
    <xmx:w6QdXrk2CyGDbXoekSFxQJV5DYaStYDgzQvpNQ2S0jKRoGgkPY1HkQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2015A8005A;
        Tue, 14 Jan 2020 06:23:46 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 02/10] ipv4: Encapsulate function arguments in a struct
Date:   Tue, 14 Jan 2020 13:23:10 +0200
Message-Id: <20200114112318.876378-3-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114112318.876378-1-idosch@idosch.org>
References: <20200114112318.876378-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

fib_dump_info() is used to prepare RTM_{NEW,DEL}ROUTE netlink messages
using the passed arguments. Currently, the function takes 11 arguments,
6 of which are attributes of the route being dumped (e.g., prefix, TOS).

The next patch will need the function to also dump to user space an
indication if the route is present in hardware or not. Instead of
passing yet another argument, change the function to take a struct
containing the different route attributes.

v2:
* Name last argument of fib_dump_info()
* Move 'struct fib_rt_info' to include/net/ip_fib.h so that it could
  later be passed to fib_alias_hw_flags_set()

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 include/net/ip_fib.h     |  9 +++++++++
 net/ipv4/fib_lookup.h    |  5 ++---
 net/ipv4/fib_semantics.c | 26 ++++++++++++++++----------
 net/ipv4/fib_trie.c      | 14 +++++++++-----
 net/ipv4/route.c         | 12 +++++++++---
 5 files changed, 45 insertions(+), 21 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index b9cba41c6d4f..0c071c820e33 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -204,6 +204,15 @@ __be32 fib_result_prefsrc(struct net *net, struct fib_result *res);
 #define FIB_RES_DEV(res)	(FIB_RES_NHC(res)->nhc_dev)
 #define FIB_RES_OIF(res)	(FIB_RES_NHC(res)->nhc_oif)
 
+struct fib_rt_info {
+	struct fib_info		*fi;
+	u32			tb_id;
+	__be32			dst;
+	int			dst_len;
+	u8			tos;
+	u8			type;
+};
+
 struct fib_entry_notifier_info {
 	struct fib_notifier_info info; /* must be first */
 	u32 dst;
diff --git a/net/ipv4/fib_lookup.h b/net/ipv4/fib_lookup.h
index a68b5e21ec51..a4b829358bfa 100644
--- a/net/ipv4/fib_lookup.h
+++ b/net/ipv4/fib_lookup.h
@@ -35,9 +35,8 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 int fib_nh_match(struct fib_config *cfg, struct fib_info *fi,
 		 struct netlink_ext_ack *extack);
 bool fib_metrics_match(struct fib_config *cfg, struct fib_info *fi);
-int fib_dump_info(struct sk_buff *skb, u32 pid, u32 seq, int event, u32 tb_id,
-		  u8 type, __be32 dst, int dst_len, u8 tos, struct fib_info *fi,
-		  unsigned int);
+int fib_dump_info(struct sk_buff *skb, u32 pid, u32 seq, int event,
+		  struct fib_rt_info *fri, unsigned int flags);
 void rtmsg_fib(int event, __be32 key, struct fib_alias *fa, int dst_len,
 	       u32 tb_id, const struct nl_info *info, unsigned int nlm_flags);
 
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index f1888c683426..3ed1349be428 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -504,6 +504,7 @@ void rtmsg_fib(int event, __be32 key, struct fib_alias *fa,
 	       int dst_len, u32 tb_id, const struct nl_info *info,
 	       unsigned int nlm_flags)
 {
+	struct fib_rt_info fri;
 	struct sk_buff *skb;
 	u32 seq = info->nlh ? info->nlh->nlmsg_seq : 0;
 	int err = -ENOBUFS;
@@ -512,9 +513,13 @@ void rtmsg_fib(int event, __be32 key, struct fib_alias *fa,
 	if (!skb)
 		goto errout;
 
-	err = fib_dump_info(skb, info->portid, seq, event, tb_id,
-			    fa->fa_type, key, dst_len,
-			    fa->fa_tos, fa->fa_info, nlm_flags);
+	fri.fi = fa->fa_info;
+	fri.tb_id = tb_id;
+	fri.dst = key;
+	fri.dst_len = dst_len;
+	fri.tos = fa->fa_tos;
+	fri.type = fa->fa_type;
+	err = fib_dump_info(skb, info->portid, seq, event, &fri, nlm_flags);
 	if (err < 0) {
 		/* -EMSGSIZE implies BUG in fib_nlmsg_size() */
 		WARN_ON(err == -EMSGSIZE);
@@ -1725,10 +1730,11 @@ static int fib_add_multipath(struct sk_buff *skb, struct fib_info *fi)
 #endif
 
 int fib_dump_info(struct sk_buff *skb, u32 portid, u32 seq, int event,
-		  u32 tb_id, u8 type, __be32 dst, int dst_len, u8 tos,
-		  struct fib_info *fi, unsigned int flags)
+		  struct fib_rt_info *fri, unsigned int flags)
 {
-	unsigned int nhs = fib_info_num_path(fi);
+	unsigned int nhs = fib_info_num_path(fri->fi);
+	struct fib_info *fi = fri->fi;
+	u32 tb_id = fri->tb_id;
 	struct nlmsghdr *nlh;
 	struct rtmsg *rtm;
 
@@ -1738,22 +1744,22 @@ int fib_dump_info(struct sk_buff *skb, u32 portid, u32 seq, int event,
 
 	rtm = nlmsg_data(nlh);
 	rtm->rtm_family = AF_INET;
-	rtm->rtm_dst_len = dst_len;
+	rtm->rtm_dst_len = fri->dst_len;
 	rtm->rtm_src_len = 0;
-	rtm->rtm_tos = tos;
+	rtm->rtm_tos = fri->tos;
 	if (tb_id < 256)
 		rtm->rtm_table = tb_id;
 	else
 		rtm->rtm_table = RT_TABLE_COMPAT;
 	if (nla_put_u32(skb, RTA_TABLE, tb_id))
 		goto nla_put_failure;
-	rtm->rtm_type = type;
+	rtm->rtm_type = fri->type;
 	rtm->rtm_flags = fi->fib_flags;
 	rtm->rtm_scope = fi->fib_scope;
 	rtm->rtm_protocol = fi->fib_protocol;
 
 	if (rtm->rtm_dst_len &&
-	    nla_put_in_addr(skb, RTA_DST, dst))
+	    nla_put_in_addr(skb, RTA_DST, fri->dst))
 		goto nla_put_failure;
 	if (fi->fib_priority &&
 	    nla_put_u32(skb, RTA_PRIORITY, fi->fib_priority))
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 39f56d68ec19..75af3f8ae50e 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -2194,14 +2194,18 @@ static int fn_trie_dump_leaf(struct key_vector *l, struct fib_table *tb,
 
 		if (filter->dump_routes) {
 			if (!s_fa) {
+				struct fib_rt_info fri;
+
+				fri.fi = fi;
+				fri.tb_id = tb->tb_id;
+				fri.dst = xkey;
+				fri.dst_len = KEYLENGTH - fa->fa_slen;
+				fri.tos = fa->fa_tos;
+				fri.type = fa->fa_type;
 				err = fib_dump_info(skb,
 						    NETLINK_CB(cb->skb).portid,
 						    cb->nlh->nlmsg_seq,
-						    RTM_NEWROUTE,
-						    tb->tb_id, fa->fa_type,
-						    xkey,
-						    KEYLENGTH - fa->fa_slen,
-						    fa->fa_tos, fi, flags);
+						    RTM_NEWROUTE, &fri, flags);
 				if (err < 0)
 					goto stop;
 			}
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 87e979f2b74a..167a7357d12a 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -3223,16 +3223,22 @@ static int inet_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 	skb_reset_mac_header(skb);
 
 	if (rtm->rtm_flags & RTM_F_FIB_MATCH) {
+		struct fib_rt_info fri;
+
 		if (!res.fi) {
 			err = fib_props[res.type].error;
 			if (!err)
 				err = -EHOSTUNREACH;
 			goto errout_rcu;
 		}
+		fri.fi = res.fi;
+		fri.tb_id = table_id;
+		fri.dst = res.prefix;
+		fri.dst_len = res.prefixlen;
+		fri.tos = fl4.flowi4_tos;
+		fri.type = rt->rt_type;
 		err = fib_dump_info(skb, NETLINK_CB(in_skb).portid,
-				    nlh->nlmsg_seq, RTM_NEWROUTE, table_id,
-				    rt->rt_type, res.prefix, res.prefixlen,
-				    fl4.flowi4_tos, res.fi, 0);
+				    nlh->nlmsg_seq, RTM_NEWROUTE, &fri, 0);
 	} else {
 		err = rt_fill_info(net, dst, src, rt, table_id, &fl4, skb,
 				   NETLINK_CB(in_skb).portid,
-- 
2.24.1

