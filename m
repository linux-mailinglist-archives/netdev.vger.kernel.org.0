Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65276562D4B
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 10:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235865AbiGAH7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 03:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235524AbiGAH7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 03:59:00 -0400
Received: from eidolon.nox.tf (eidolon.nox.tf [IPv6:2a07:2ec0:2185::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24FE6EE88
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 00:58:59 -0700 (PDT)
Received: from [2a02:169:59c5:1:7d5c:5092:64f9:9cbc] (helo=areia)
        by eidolon.nox.tf with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <equinox@diac24.net>)
        id 1o7BYH-00F8tJ-Hb; Fri, 01 Jul 2022 09:58:57 +0200
Received: from equinox by areia with local (Exim 4.96)
        (envelope-from <equinox@diac24.net>)
        id 1o7BXv-000HAX-0p;
        Fri, 01 Jul 2022 09:58:35 +0200
From:   David Lamparter <equinox@diac24.net>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Lamparter <equinox@diac24.net>
Subject: [PATCH net-next 2/2] net: ip6mr: add RTM_GETROUTE netlink op
Date:   Fri,  1 Jul 2022 09:58:05 +0200
Message-Id: <20220701075805.65978-3-equinox@diac24.net>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220701075805.65978-1-equinox@diac24.net>
References: <20220630202706.33555ad2@kernel.org>
 <20220701075805.65978-1-equinox@diac24.net>
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
---

Pretty much copypasted from IPv4.

---
 net/ipv6/ip6mr.c | 119 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 118 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index ec6e1509fc7c..a10bed171417 100644
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
 
@@ -2510,6 +2512,121 @@ static void mrt6msg_netlink_event(const struct mr_table *mrt, struct sk_buff *pk
 	rtnl_set_sk_err(net, RTNLGRP_IPV6_MROUTE_R, -ENOBUFS);
 }
 
+static int ip6mr_rtm_valid_getroute_req(struct sk_buff *skb,
+					const struct nlmsghdr *nlh,
+					struct nlattr **tb,
+					struct netlink_ext_ack *extack)
+{
+	struct rtmsg *rtm;
+	int i, err;
+
+	if (nlh->nlmsg_len < nlmsg_msg_size(sizeof(*rtm))) {
+		NL_SET_ERR_MSG(extack, "ipv6: Invalid header for multicast route get request");
+		return -EINVAL;
+	}
+
+	if (!netlink_strict_get_check(skb))
+		return nlmsg_parse_deprecated(nlh, sizeof(*rtm), tb, RTA_MAX,
+					      rtm_ipv6_policy, extack);
+
+	rtm = nlmsg_data(nlh);
+	if ((rtm->rtm_src_len && rtm->rtm_src_len != 128) ||
+	    (rtm->rtm_dst_len && rtm->rtm_dst_len != 128) ||
+	    rtm->rtm_tos || rtm->rtm_table || rtm->rtm_protocol ||
+	    rtm->rtm_scope || rtm->rtm_type || rtm->rtm_flags) {
+		NL_SET_ERR_MSG(extack, "ipv6: Invalid values in header for multicast route get request");
+		return -EINVAL;
+	}
+
+	err = nlmsg_parse_deprecated_strict(nlh, sizeof(*rtm), tb, RTA_MAX,
+					    rtm_ipv6_policy, extack);
+	if (err)
+		return err;
+
+	if ((tb[RTA_SRC] && !rtm->rtm_src_len) ||
+	    (tb[RTA_DST] && !rtm->rtm_dst_len)) {
+		NL_SET_ERR_MSG(extack, "ipv6: rtm_src_len and rtm_dst_len must be 128 for IPv6");
+		return -EINVAL;
+	}
+
+	for (i = 0; i <= RTA_MAX; i++) {
+		if (!tb[i])
+			continue;
+
+		switch (i) {
+		case RTA_SRC:
+		case RTA_DST:
+		case RTA_TABLE:
+			break;
+		default:
+			NL_SET_ERR_MSG(extack, "ipv6: Unsupported attribute in multicast route get request");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static int ip6mr_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
+			      struct netlink_ext_ack *extack)
+{
+	struct net *net = sock_net(in_skb->sk);
+	struct nlattr *tb[RTA_MAX + 1];
+	struct sk_buff *skb = NULL;
+	struct mfc6_cache *cache;
+	struct mr_table *mrt;
+	struct in6_addr src = {}, grp = {};
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

