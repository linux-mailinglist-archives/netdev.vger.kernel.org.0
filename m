Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAEF94A4E1
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 17:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729496AbfFRPNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 11:13:33 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:47405 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728905AbfFRPNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 11:13:32 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id DD6822241B;
        Tue, 18 Jun 2019 11:13:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 18 Jun 2019 11:13:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Ylkf/zOUwUKxo2L0677muym4IakcrnXwoMoLu3ll55Q=; b=mmau/7Mb
        BX8hBoj90Xk90bGq8Y04jlOY7oTqE5je6AYEykvPS8etYH8NnTJ3CUjQb/tuXioN
        hjDbPlfr9cbOo3q1K0Lbs91BvGxIe0FTte9HJF8xRK99fw0P7599sOFONhGE/tkH
        AS/8AtUKqkR2f198qdF3HtmUy2faHri6ScTRBZ/XYhi4LHt2S0YGYeNNop6kIYnP
        ST326Drp8obYivBr/RfPj1fYF0+83Jadyg6oBZFyTlftRb7qy7yVl+U3eUwcTHjT
        KV3V+zBGu2fHYZUJ8jEi0jQAniXt3fHuaQojkl+ozDGOHFGMXqjpXpRFOa26fEiD
        isXs22QGG7m6iA==
X-ME-Sender: <xms:mv8IXVFDowLTOm-uDMWBYO47OWdcgoN1DVgjATJBOf7GvHW6UDSJEw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtddtgdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:mv8IXQG10AWhEeqgBc0vUTeq1rbLbuOuho6szrV3KN74Ovz6j_NHLA>
    <xmx:mv8IXd-YlixydKkXNdX2JEtdTTHKKb6CQiZ71kCmX8miiAXKtsmh_Q>
    <xmx:mv8IXSQInFQBdsCNFVFnMiHY7TcbWssBjDkok39ECcVno0HIk9KFGg>
    <xmx:mv8IXX-F6zk8Kdweczb6EUAmuiprBjHVPeJsoHh2yCFlJ7seCt-x1Q>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4E130380088;
        Tue, 18 Jun 2019 11:13:29 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, dsahern@gmail.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 02/16] netlink: Add field to skip in-kernel notifications
Date:   Tue, 18 Jun 2019 18:12:44 +0300
Message-Id: <20190618151258.23023-3-idosch@idosch.org>
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

The struct includes a 'skip_notify' flag that indicates if netlink
notifications to user space should be suppressed. As explained in commit
3b1137fe7482 ("net: ipv6: Change notifications for multipath add to
RTA_MULTIPATH"), this is useful to suppress per-nexthop RTM_NEWROUTE
notifications when an IPv6 multipath route is added / deleted. Instead,
one notification is sent for the entire multipath route.

This concept is also useful for in-kernel notifications. Sending one
in-kernel notification for the addition / deletion of an IPv6 multipath
route - instead of one per-nexthop - provides a significant increase in
the insertion / deletion rate to underlying devices.

Add a 'skip_notify_kernel' flag to suppress in-kernel notifications.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
---
 include/net/netlink.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index ce66e43b9b6a..e4650e5b64a1 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -381,12 +381,14 @@ struct nla_policy {
  * @nl_net: Network namespace
  * @portid: Netlink PORTID of requesting application
  * @skip_notify: Skip netlink notifications to user space
+ * @skip_notify_kernel: Skip selected in-kernel notifications
  */
 struct nl_info {
 	struct nlmsghdr		*nlh;
 	struct net		*nl_net;
 	u32			portid;
-	bool			skip_notify;
+	u8			skip_notify:1,
+				skip_notify_kernel:1;
 };
 
 /**
-- 
2.20.1

