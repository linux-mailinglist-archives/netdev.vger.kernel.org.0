Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 620534A4E5
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 17:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729605AbfFRPNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 11:13:39 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:52759 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729572AbfFRPNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 11:13:37 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id ED37D223A4;
        Tue, 18 Jun 2019 11:13:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 18 Jun 2019 11:13:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=f1pi5d37NchtbwXPsLPoLBepUGO2FEn5yQ3uU8lUw4c=; b=PzZUEHt+
        PHgzbLajOMCRmodqPMBWY7RZHTdJ9nSOveABl4ZHjmqiCmkKELhNBa3TB2vLBBFB
        p0LiUE+i/2qoDDmWm/iA+NtDio1rwtWz3zDJjjBcMii814bOwkpRY3ImS4xop3YB
        qtpk86gR2i8eTU5hqMw7Rum5utjOtGSe0by/VzxGPRBT/U/OZhWZBb+sRjLiJN3k
        p6gQxX/IX0E/LClDgXQ6Zjsm54JUG5gICISLWtPmzJpcayeibwTgpvpFdLOioiDE
        upxFlsT7k8oVI7kSWJ4gxyt0VuHcuiJMtCCK3rDkyBrsGRvK085byKajAdp7Bzoq
        xVu1HcZ74rZgzg==
X-ME-Sender: <xms:oP8IXRvBMozyy7_bGn-4-aU8EH3csydlG62f6gf3c16sak_KdoCQGw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtddtgdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepvd
X-ME-Proxy: <xmx:oP8IXSbgZu_OYhIqMvJhd58uLOQckFmYdTSiENpZi9XH33-V1yfZjw>
    <xmx:oP8IXbHbkbAFTIwqaBhZdgp1IFZZuJ0MJpnlQBQLY0Rv45YBsvp5YA>
    <xmx:oP8IXQsts8IRsDgvKezd0j17Zw5dsJlsqouopwpgLOITZ8Ya4Zgr9g>
    <xmx:oP8IXQatpki9m8pgI6MkUveYDt3Z_p2cVRJg4r49qTIh_chexUWdDw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 66938380089;
        Tue, 18 Jun 2019 11:13:35 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, dsahern@gmail.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 06/16] ipv6: Add IPv6 multipath notifications for add / replace
Date:   Tue, 18 Jun 2019 18:12:48 +0300
Message-Id: <20190618151258.23023-7-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618151258.23023-1-idosch@idosch.org>
References: <20190618151258.23023-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Emit a notification when a multipath routes is added or replace.

Note that unlike the replace notifications sent from fib6_add_rt2node(),
it is possible we are sending a 'FIB_EVENT_ENTRY_REPLACE' when a route
was merely added and not replaced.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
---
 net/ipv6/route.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index f7257a56072a..da504d36ce54 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4965,6 +4965,7 @@ static int ip6_route_multipath_add(struct fib6_config *cfg,
 {
 	struct fib6_info *rt_notif = NULL, *rt_last = NULL;
 	struct nl_info *info = &cfg->fc_nlinfo;
+	enum fib_event_type event_type;
 	struct fib6_config r_cfg;
 	struct rtnexthop *rtnh;
 	struct fib6_info *rt;
@@ -5042,6 +5043,11 @@ static int ip6_route_multipath_add(struct fib6_config *cfg,
 	 */
 	info->skip_notify = 1;
 
+	/* For add and replace, send one notification with all nexthops. For
+	 * append, send one notification with all appended nexthops.
+	 */
+	info->skip_notify_kernel = 1;
+
 	err_nh = NULL;
 	list_for_each_entry(nh, &rt6_nh_list, next) {
 		err = __ip6_ins_rt(nh->fib6_info, info, extack);
@@ -5078,6 +5084,15 @@ static int ip6_route_multipath_add(struct fib6_config *cfg,
 		nhn++;
 	}
 
+	event_type = replace ? FIB_EVENT_ENTRY_REPLACE : FIB_EVENT_ENTRY_ADD;
+	err = call_fib6_multipath_entry_notifiers(info->nl_net, event_type,
+						  rt_notif, nhn - 1, extack);
+	if (err) {
+		/* Delete all the siblings that were just added */
+		err_nh = NULL;
+		goto add_errout;
+	}
+
 	/* success ... tell user about new route */
 	ip6_route_mpath_notify(rt_notif, rt_last, info, nlflags);
 	goto cleanup;
-- 
2.20.1

