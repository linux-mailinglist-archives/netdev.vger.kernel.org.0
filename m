Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF34C49C9
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 10:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbfJBIlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 04:41:49 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54665 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727930AbfJBIls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 04:41:48 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 2E77621FBF;
        Wed,  2 Oct 2019 04:41:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 02 Oct 2019 04:41:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=XZoyd2MuCodMVSxDhS7DwXO2NoENrErsEC0ikRUSuy8=; b=my7B1HkU
        L/XvA+ZCKbKp2HwjIdMmvNRfGkJBMprWmoWNErAkjD2rONneQ1O3NWpm3hSikvr7
        O5WRV2ZNVF/PVAA0hDVKBwcSFbRCZN3wjUMjbGBqrpuqdP2V92cHLtHnJgOF/ujp
        OrWTA+A4uIlREqGcad8KyMg1DT1/4TGRV3Yrl+/m3xs+isDcS9sHy7OG3W1y0RKb
        Xzn+MeVuvc/bKdLSCRYxqBiYdtYsGKEvdSCD3Rte9v/LlM+3GxLyYlgWvRUz3+Sv
        TjCoaDmJtkYzk+3hmqs4E25TLJLFR2bkaybrKg9hF2mNIacDtoi1geNXM7ve1MQF
        Mmf3N45BMZ2O0g==
X-ME-Sender: <xms:ymKUXRF1wEe8lGoL5eYQhnf62IqnjybzuJV7Zf3k-Jbh_GHAIwxxBA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeeigddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepuddt
X-ME-Proxy: <xmx:y2KUXaTdgbtZHqxe9RIohghyKmnfi8CjWt_nihtFYMEGPF3z19z3gQ>
    <xmx:y2KUXXttkxKf7_rydZ9r-c_eozYxECi9UP6-oM4PqRNCuYLCmK6Kcg>
    <xmx:y2KUXfAoLAp3M4goVKOhIjXfNC645GRZIrWcr6XyMy0y7Jjkc27VYQ>
    <xmx:y2KUXSSKUONbcxpGU0pVbpjEIb9h6DVRkFDYGlRbJXS7RmMDp5VVBg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 93A35D60057;
        Wed,  2 Oct 2019 04:41:45 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, jiri@mellanox.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 11/15] ipv4: Encapsulate function arguments in a struct
Date:   Wed,  2 Oct 2019 11:40:59 +0300
Message-Id: <20191002084103.12138-12-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191002084103.12138-1-idosch@idosch.org>
References: <20191002084103.12138-1-idosch@idosch.org>
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

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 net/ipv4/fib_lookup.h    | 14 +++++++++++---
 net/ipv4/fib_semantics.c | 26 ++++++++++++++++----------
 net/ipv4/fib_trie.c      | 14 +++++++++-----
 net/ipv4/route.c         | 12 +++++++++---
 4 files changed, 45 insertions(+), 21 deletions(-)

diff --git a/net/ipv4/fib_lookup.h b/net/ipv4/fib_lookup.h
index a68b5e21ec51..b34594a9965f 100644
--- a/net/ipv4/fib_lookup.h
+++ b/net/ipv4/fib_lookup.h
@@ -21,6 +21,15 @@ struct fib_alias {
 
 #define FA_S_ACCESSED	0x01
 
+struct fib_rt_info {
+	struct fib_info		*fi;
+	u32			tb_id;
+	__be32			dst;
+	int			dst_len;
+	u8			tos;
+	u8			type;
+};
+
 /* Dont write on fa_state unless needed, to keep it shared on all cpus */
 static inline void fib_alias_accessed(struct fib_alias *fa)
 {
@@ -35,9 +44,8 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 int fib_nh_match(struct fib_config *cfg, struct fib_info *fi,
 		 struct netlink_ext_ack *extack);
 bool fib_metrics_match(struct fib_config *cfg, struct fib_info *fi);
-int fib_dump_info(struct sk_buff *skb, u32 pid, u32 seq, int event, u32 tb_id,
-		  u8 type, __be32 dst, int dst_len, u8 tos, struct fib_info *fi,
-		  unsigned int);
+int fib_dump_info(struct sk_buff *skb, u32 pid, u32 seq, int event,
+		  struct fib_rt_info *fri, unsigned int);
 void rtmsg_fib(int event, __be32 key, struct fib_alias *fa, int dst_len,
 	       u32 tb_id, const struct nl_info *info, unsigned int nlm_flags);
 
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 0913a090b2bf..3c9d47804d93 100644
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
index 9ea9610eebfd..646542de83ca 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -2210,14 +2210,18 @@ static int fn_trie_dump_leaf(struct key_vector *l, struct fib_table *tb,
 
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
index 7dcce724c78b..15674e446d4b 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -3179,16 +3179,22 @@ static int inet_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
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
2.21.0

