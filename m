Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7BF4704F
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 16:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfFOOJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 10:09:27 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48043 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726400AbfFOOJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 10:09:26 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 105D021EAE;
        Sat, 15 Jun 2019 10:09:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 15 Jun 2019 10:09:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=5mCpImxeFQGqxjmOGo7PQW49dmItElDN7pB8f/MSIhQ=; b=ck4TeMPf
        RgK5OHUoZEmKh9+TLrRoey3dAX8d3EJ5qymRk7/e2GfHpVy7ybSPO9QGq+0Yx85+
        Sgc9aOqrCgdX+rfLLJyzCAIkI0v5y7IcbRYPHVZc/cLPzziPvsXZlYo2rXXWbmEz
        4uFWg77HbZLEdxYNlrhWy/5vtREw05utXlMGBoukYsP3/ZX8gxBdTQpGVBEh4LrA
        2XbuAztDJP/bL8fyzFcQtjr5HhMRfxe+5EnotdSFYAARONSCZlPIq974WfRjrk3z
        yobJ2FDu0ptIUGrWzrrklS3L/Eh0YT4iEn2ojrFFlzWR8WPcGoC1DgsUEwDqwWny
        JQL9VKYRMP6sdA==
X-ME-Sender: <xms:FfwEXUz9ETZ53ls1UMATtq8gvViVHG7hd_TzJR76yA1l7qK8Nos2fg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeifedgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudejkedrgeefrddvudeknecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepge
X-ME-Proxy: <xmx:FfwEXUnrzEapYV_jzFJnGAq08EcJlyJ93WajGGBSxSDwq7gyFSzUSQ>
    <xmx:FfwEXX9m5S8nVykzcAdjTP5ab7NRLs54LrGT_RA_FtI1GJjJEEGhtA>
    <xmx:FfwEXfp8G2d-GuBmW1w99K_0VfHcmGgUELXope9xNj-Y6TqL2eCq2Q>
    <xmx:FvwEXaIky_gG-8KVkRoQ1IVd6YGQR8OL96SpfdrWRqyVq2kCedSsNQ>
Received: from splinter.mtl.com (bzq-79-178-43-218.red.bezeqint.net [79.178.43.218])
        by mail.messagingengine.com (Postfix) with ESMTPA id DE6B8380085;
        Sat, 15 Jun 2019 10:09:22 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, jiri@mellanox.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 06/17] ipv6: Add IPv6 multipath notifications for add / replace
Date:   Sat, 15 Jun 2019 17:07:40 +0300
Message-Id: <20190615140751.17661-7-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190615140751.17661-1-idosch@idosch.org>
References: <20190615140751.17661-1-idosch@idosch.org>
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

