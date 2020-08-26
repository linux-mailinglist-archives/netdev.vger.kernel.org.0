Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8A6253565
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 18:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbgHZQtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 12:49:40 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47129 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728030AbgHZQta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 12:49:30 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 7F7125C00F2;
        Wed, 26 Aug 2020 12:49:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 26 Aug 2020 12:49:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Hde/DC5XY4uXJJQ6rgwXFRqkV073vFNYHG5Bz+CxK9c=; b=ATTFPTLL
        VKZVgkVGt6q1mNQHcN/g97sX/eam6ByFzqAtXlZ3tYiG6eneKeueMPGh53MKSDvN
        4YOq5C7vvO4S4M3E+dGO+hGyE8BRCrR55WXiU495v3BYK7xTMKmz4CY5WgzNb/cG
        j/RmqwZOeM86JluyGBfgQchjBw48bihV3OqK0NR+1z4cuCTBJUitrjOkuldjIkUr
        d7sw4QIKca0mb7eXPHbiDYa9BCCGrcb/MaZcHQdcbrbmYMEfDsZnq1C8IGgqGX3D
        NRTDczgQZSdfihaVuDon3RBlN/hTV4C6e49u947iSm2HELPqajhgbFqaglIldGni
        dKLf0nRj9jwOYw==
X-ME-Sender: <xms:mZJGX1o5BxMUT4dcPgbNV6ZvHc7ZnAclM1vjtMvaCYhI_SNgoV2SuQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddvvddguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdefjedrudei
    keenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:mZJGX3pjiMqlrqkdCRR85tfUj0sxue1Pplye17DmjLqNVupWj8YSng>
    <xmx:mZJGXyNPSj17lnLez9-OH3CbrfOQgYmzTTl8N3PLQqY9lXYy1IY1ZQ>
    <xmx:mZJGXw6Q5G5EoZ50j0uJqZzX9LU6SWhpQxJDxZLJvRJEKxArQPbfuw>
    <xmx:mZJGXyRPTODHjrv0zf1C3h5dYlPaXO3LlRF4VuLP2nwiqasWySp_-A>
Received: from shredder.mtl.com (igld-84-229-37-168.inter.net.il [84.229.37.168])
        by mail.messagingengine.com (Postfix) with ESMTPA id A5DBB328005E;
        Wed, 26 Aug 2020 12:49:27 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/7] selftests: fib_nexthops: Test IPv6 route with group after removing IPv4 nexthops
Date:   Wed, 26 Aug 2020 19:48:55 +0300
Message-Id: <20200826164857.1029764-6-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200826164857.1029764-1-idosch@idosch.org>
References: <20200826164857.1029764-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Test that an IPv6 route can not use a nexthop group with mixed IPv4 and
IPv6 nexthops, but can use it after deleting the IPv4 nexthops.

Output without previous patch:

# ./fib_nexthops.sh -t ipv6_fcnal_runtime

IPv6 functional runtime
-----------------------
TEST: Route add                                                     [ OK ]
TEST: Route delete                                                  [ OK ]
TEST: Ping with nexthop                                             [ OK ]
TEST: Ping - multipath                                              [ OK ]
TEST: Ping - blackhole                                              [ OK ]
TEST: Ping - blackhole replaced with gateway                        [ OK ]
TEST: Ping - gateway replaced by blackhole                          [ OK ]
TEST: Ping - group with blackhole                                   [ OK ]
TEST: Ping - group blackhole replaced with gateways                 [ OK ]
TEST: IPv6 route with device only nexthop                           [ OK ]
TEST: IPv6 multipath route with nexthop mix - dev only + gw         [ OK ]
TEST: IPv6 route can not have a v4 gateway                          [ OK ]
TEST: Nexthop replace - v6 route, v4 nexthop                        [ OK ]
TEST: Nexthop replace of group entry - v6 route, v4 nexthop         [ OK ]
TEST: IPv6 route can not have a group with v4 and v6 gateways       [ OK ]
TEST: IPv6 route can not have a group with v4 and v6 gateways       [ OK ]
TEST: IPv6 route using a group after deleting v4 gateways           [FAIL]
TEST: Nexthop with default route and rpfilter                       [ OK ]
TEST: Nexthop with multipath default route and rpfilter             [ OK ]

Tests passed:  18
Tests failed:   1

Output with previous patch:

bash-5.0# ./fib_nexthops.sh -t ipv6_fcnal_runtime

IPv6 functional runtime
-----------------------
TEST: Route add                                                     [ OK ]
TEST: Route delete                                                  [ OK ]
TEST: Ping with nexthop                                             [ OK ]
TEST: Ping - multipath                                              [ OK ]
TEST: Ping - blackhole                                              [ OK ]
TEST: Ping - blackhole replaced with gateway                        [ OK ]
TEST: Ping - gateway replaced by blackhole                          [ OK ]
TEST: Ping - group with blackhole                                   [ OK ]
TEST: Ping - group blackhole replaced with gateways                 [ OK ]
TEST: IPv6 route with device only nexthop                           [ OK ]
TEST: IPv6 multipath route with nexthop mix - dev only + gw         [ OK ]
TEST: IPv6 route can not have a v4 gateway                          [ OK ]
TEST: Nexthop replace - v6 route, v4 nexthop                        [ OK ]
TEST: Nexthop replace of group entry - v6 route, v4 nexthop         [ OK ]
TEST: IPv6 route can not have a group with v4 and v6 gateways       [ OK ]
TEST: IPv6 route can not have a group with v4 and v6 gateways       [ OK ]
TEST: IPv6 route using a group after deleting v4 gateways           [ OK ]
TEST: Nexthop with default route and rpfilter                       [ OK ]
TEST: Nexthop with multipath default route and rpfilter             [ OK ]

Tests passed:  19
Tests failed:   0

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 tools/testing/selftests/net/fib_nexthops.sh | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index 22dc2f3d428b..06e4f12e838d 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -739,6 +739,21 @@ ipv6_fcnal_runtime()
 	run_cmd "$IP nexthop replace id 81 via 172.16.1.1 dev veth1"
 	log_test $? 2 "Nexthop replace of group entry - v6 route, v4 nexthop"
 
+	run_cmd "$IP nexthop add id 86 via 2001:db8:92::2 dev veth3"
+	run_cmd "$IP nexthop add id 87 via 172.16.1.1 dev veth1"
+	run_cmd "$IP nexthop add id 88 via 172.16.1.1 dev veth1"
+	run_cmd "$IP nexthop add id 124 group 86/87/88"
+	run_cmd "$IP ro replace 2001:db8:101::1/128 nhid 124"
+	log_test $? 2 "IPv6 route can not have a group with v4 and v6 gateways"
+
+	run_cmd "$IP nexthop del id 88"
+	run_cmd "$IP ro replace 2001:db8:101::1/128 nhid 124"
+	log_test $? 2 "IPv6 route can not have a group with v4 and v6 gateways"
+
+	run_cmd "$IP nexthop del id 87"
+	run_cmd "$IP ro replace 2001:db8:101::1/128 nhid 124"
+	log_test $? 0 "IPv6 route using a group after removing v4 gateways"
+
 	$IP nexthop flush >/dev/null 2>&1
 
 	#
-- 
2.26.2

