Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C632568483
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 12:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiGFKB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 06:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiGFKB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 06:01:27 -0400
Received: from eidolon.nox.tf (eidolon.nox.tf [IPv6:2a07:2ec0:2185::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D68A248CF
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 03:01:25 -0700 (PDT)
Received: from [2a02:169:59c5:1:9612:ceb5:7280:92fe] (helo=areia)
        by eidolon.nox.tf with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <equinox@diac24.net>)
        id 1o91qU-001imW-Hu; Wed, 06 Jul 2022 12:01:22 +0200
Received: from equinox by areia with local (Exim 4.96)
        (envelope-from <equinox@diac24.net>)
        id 1o91q7-000TAM-2o;
        Wed, 06 Jul 2022 12:00:59 +0200
From:   David Lamparter <equinox@diac24.net>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Lamparter <equinox@diac24.net>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net-next v4] net: ip6mr: add RTM_GETROUTE netlink op
Date:   Wed,  6 Jul 2022 12:00:24 +0200
Message-Id: <20220706100024.112074-1-equinox@diac24.net>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IPv6 multicast routing code previously implemented only the dump
variant of RTM_GETROUTE.  Implement single MFC item retrieval by copying
and adapting the respective IPv4 code.

Tested against FRRouting's IPv6 PIM stack.

Signed-off-by: David Lamparter <equinox@diac24.net>
Cc: David Ahern <dsahern@kernel.org>
Cc: Nikolay Aleksandrov <razor@blackwall.org>
---

v4: rename policy to indicate it is dedicated for getroute, remove
extra validation loop to reject attrs, and add missing "static".

v3: reorder/remove some redundant bits, fix style.  Thanks Nikolay for
pointing them out.  The "extra" validation loop is still there for the
time being;  happy to drop it if that's the consensus.

v2: changeover to strict netlink attribute parsing.  Doing so actually
exposed a bunch of other issues, first and foremost that rtm_ipv6_policy
does not have RTA_SRC or RTA_DST.  This made reusing that policy rather
pointless so I changed it to use a separate rtm_ipv6_mr_policy.

Thanks again dsahern@ for the feedback on the previous version!

---
 net/ipv6/ip6mr.c | 102 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 101 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index ec6e1509fc7c..f567c055dba4 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -95,6 +95,8 @@ static int ip6mr_cache_report(const struct mr_table *mrt, struct sk_buff *pkt,
 static void mr6_netlink_event(struct mr_table *mrt, struct mfc6_cache *mfc,
 			      int cmd);
 static void mrt6msg_netlink_event(const struct mr_table *mrt, struct sk_buff *pkt);
+static int ip6mr_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
+			      struct netlink_ext_ack *extack);
 static int ip6mr_rtm_dumproute(struct sk_buff *skb,
 			       struct netlink_callback *cb);
 static void mroute_clean_tables(struct mr_table *mrt, int flags);
@@ -1390,7 +1392,7 @@ int __init ip6_mr_init(void)
 	}
 #endif
 	err = rtnl_register_module(THIS_MODULE, RTNL_FAMILY_IP6MR, RTM_GETROUTE,
-				   NULL, ip6mr_rtm_dumproute, 0);
+				   ip6mr_rtm_getroute, ip6mr_rtm_dumproute, 0);
 	if (err == 0)
 		return 0;
 
@@ -2510,6 +2512,104 @@ static void mrt6msg_netlink_event(const struct mr_table *mrt, struct sk_buff *pk
 	rtnl_set_sk_err(net, RTNLGRP_IPV6_MROUTE_R, -ENOBUFS);
 }
 
+static const struct nla_policy ip6mr_getroute_policy[RTA_MAX + 1] = {
+	[RTA_SRC]		= NLA_POLICY_EXACT_LEN(sizeof(struct in6_addr)),
+	[RTA_DST]		= NLA_POLICY_EXACT_LEN(sizeof(struct in6_addr)),
+	[RTA_TABLE]		= { .type = NLA_U32 },
+};
+
+static int ip6mr_rtm_valid_getroute_req(struct sk_buff *skb,
+					const struct nlmsghdr *nlh,
+					struct nlattr **tb,
+					struct netlink_ext_ack *extack)
+{
+	struct rtmsg *rtm;
+	int err;
+
+	err = nlmsg_parse(nlh, sizeof(*rtm), tb, RTA_MAX, ip6mr_getroute_policy,
+			  extack);
+	if (err)
+		return err;
+
+	rtm = nlmsg_data(nlh);
+	if ((rtm->rtm_src_len && rtm->rtm_src_len != 128) ||
+	    (rtm->rtm_dst_len && rtm->rtm_dst_len != 128) ||
+	    rtm->rtm_tos || rtm->rtm_table || rtm->rtm_protocol ||
+	    rtm->rtm_scope || rtm->rtm_type || rtm->rtm_flags) {
+		NL_SET_ERR_MSG(extack,
+			       "ipv6: Invalid values in header for multicast route get request");
+		return -EINVAL;
+	}
+
+	if ((tb[RTA_SRC] && !rtm->rtm_src_len) ||
+	    (tb[RTA_DST] && !rtm->rtm_dst_len)) {
+		NL_SET_ERR_MSG(extack, "ipv6: rtm_src_len and rtm_dst_len must be 128 for IPv6");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int ip6mr_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
+			      struct netlink_ext_ack *extack)
+{
+	struct net *net = sock_net(in_skb->sk);
+	struct in6_addr src = {}, grp = {};
+	struct nlattr *tb[RTA_MAX + 1];
+	struct sk_buff *skb = NULL;
+	struct mfc6_cache *cache;
+	struct mr_table *mrt;
+	u32 tableid;
+	int err;
+
+	err = ip6mr_rtm_valid_getroute_req(in_skb, nlh, tb, extack);
+	if (err < 0)
+		goto errout;
+
+	if (tb[RTA_SRC])
+		src = nla_get_in6_addr(tb[RTA_SRC]);
+	if (tb[RTA_DST])
+		grp = nla_get_in6_addr(tb[RTA_DST]);
+	tableid = tb[RTA_TABLE] ? nla_get_u32(tb[RTA_TABLE]) : 0;
+
+	mrt = ip6mr_get_table(net, tableid ? tableid : RT_TABLE_DEFAULT);
+	if (!mrt) {
+		NL_SET_ERR_MSG_MOD(extack, "ipv6 MR table does not exist");
+		err = -ENOENT;
+		goto errout_free;
+	}
+
+	/* entries are added/deleted only under RTNL */
+	rcu_read_lock();
+	cache = ip6mr_cache_find(mrt, &src, &grp);
+	rcu_read_unlock();
+	if (!cache) {
+		NL_SET_ERR_MSG_MOD(extack, "ipv6 MR cache entry not found");
+		err = -ENOENT;
+		goto errout_free;
+	}
+
+	skb = nlmsg_new(mr6_msgsize(false, mrt->maxvif), GFP_KERNEL);
+	if (!skb) {
+		err = -ENOBUFS;
+		goto errout_free;
+	}
+
+	err = ip6mr_fill_mroute(mrt, skb, NETLINK_CB(in_skb).portid,
+				nlh->nlmsg_seq, cache, RTM_NEWROUTE, 0);
+	if (err < 0)
+		goto errout_free;
+
+	err = rtnl_unicast(skb, net, NETLINK_CB(in_skb).portid);
+
+errout:
+	return err;
+
+errout_free:
+	kfree_skb(skb);
+	goto errout;
+}
+
 static int ip6mr_rtm_dumproute(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	const struct nlmsghdr *nlh = cb->nlh;
-- 
2.36.1

