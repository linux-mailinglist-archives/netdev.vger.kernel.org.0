Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9FC4253566
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 18:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbgHZQtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 12:49:47 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57161 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728111AbgHZQte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 12:49:34 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 61FAD5C01C4;
        Wed, 26 Aug 2020 12:49:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 26 Aug 2020 12:49:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=qr1gEb0wz6G/8lIu18yHNyBenk9c96Y9+ywrv2o5c+Q=; b=Zlufk2du
        EUfxi6GE4WP9FFkMzSn/ensuQs4JLBzijdmbx6B6/FVAu+ysKmIR0B3GJJCcecDG
        jrFJq4A0eWAx9Rzy87HcKNTMhRs7JfvKguBCY13DXVEkQp60o4UaZJ+/qa6o5mOg
        xlQNJZHjsI2WKqEB7hKbY7YdDD2oBGc5Flsj+W5uT40yho5N0p40bb8r+x9rAmsA
        SKTgxWeYA+It4euZDGbA6ozbq1TYjU6FQl6F0fwNyQz6hGFulRdhZea0aUe3fJqZ
        3ib7Cdp+oij4r94bq4atkRAnqseMYp61WLmGWUY4umfe55XD4+bac6vTeEE5BPcU
        9g+Hgk41FqR9eA==
X-ME-Sender: <xms:nZJGX91aWgtgEBAugxoCpKr74aXug2FfDrXqioiJJMnYvdEVH73yQw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddvvddguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdefjedrudei
    keenucevlhhushhtvghrufhiiigvpeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:nZJGX0FazbSurnnJAvx9GkC1q47EnA07CiWS1AJTY5luS8tZoGtDvQ>
    <xmx:nZJGX94r0gPiCQ4ULzdcTmixgUE1jlNzU8lVKPB3PwoI9OCyvM-qCQ>
    <xmx:nZJGX62Nca2a7GeEwFbMNWCKBJuWZ77lJKmSKROFaCeIoagG8J7I_w>
    <xmx:nZJGX6PB-eqI3leW9bbWXVhT2wtEIU3WaSiZGYvqO5s1VLBB3mTSNg>
Received: from shredder.mtl.com (igld-84-229-37-168.inter.net.il [84.229.37.168])
        by mail.messagingengine.com (Postfix) with ESMTPA id A43A3328005E;
        Wed, 26 Aug 2020 12:49:31 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 7/7] selftests: fib_nexthops: Test IPv6 route with group after replacing IPv4 nexthops
Date:   Wed, 26 Aug 2020 19:48:57 +0300
Message-Id: <20200826164857.1029764-8-idosch@idosch.org>
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
IPv6 nexthops, but can use it after replacing the IPv4 nexthops with
IPv6 nexthops.

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
TEST: IPv6 route using a group after removing v4 gateways           [ OK ]
TEST: IPv6 route can not have a group with v4 and v6 gateways       [ OK ]
TEST: IPv6 route can not have a group with v4 and v6 gateways       [ OK ]
TEST: IPv6 route using a group after replacing v4 gateways          [FAIL]
TEST: Nexthop with default route and rpfilter                       [ OK ]
TEST: Nexthop with multipath default route and rpfilter             [ OK ]

Tests passed:  21
Tests failed:   1

Output with previous patch:

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
TEST: IPv6 route using a group after removing v4 gateways           [ OK ]
TEST: IPv6 route can not have a group with v4 and v6 gateways       [ OK ]
TEST: IPv6 route can not have a group with v4 and v6 gateways       [ OK ]
TEST: IPv6 route using a group after replacing v4 gateways          [ OK ]
TEST: Nexthop with default route and rpfilter                       [ OK ]
TEST: Nexthop with multipath default route and rpfilter             [ OK ]

Tests passed:  22
Tests failed:   0

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 tools/testing/selftests/net/fib_nexthops.sh | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index 06e4f12e838d..b74884d52913 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -754,6 +754,21 @@ ipv6_fcnal_runtime()
 	run_cmd "$IP ro replace 2001:db8:101::1/128 nhid 124"
 	log_test $? 0 "IPv6 route using a group after removing v4 gateways"
 
+	run_cmd "$IP ro delete 2001:db8:101::1/128"
+	run_cmd "$IP nexthop add id 87 via 172.16.1.1 dev veth1"
+	run_cmd "$IP nexthop add id 88 via 172.16.1.1 dev veth1"
+	run_cmd "$IP nexthop replace id 124 group 86/87/88"
+	run_cmd "$IP ro replace 2001:db8:101::1/128 nhid 124"
+	log_test $? 2 "IPv6 route can not have a group with v4 and v6 gateways"
+
+	run_cmd "$IP nexthop replace id 88 via 2001:db8:92::2 dev veth3"
+	run_cmd "$IP ro replace 2001:db8:101::1/128 nhid 124"
+	log_test $? 2 "IPv6 route can not have a group with v4 and v6 gateways"
+
+	run_cmd "$IP nexthop replace id 87 via 2001:db8:92::2 dev veth3"
+	run_cmd "$IP ro replace 2001:db8:101::1/128 nhid 124"
+	log_test $? 0 "IPv6 route using a group after replacing v4 gateways"
+
 	$IP nexthop flush >/dev/null 2>&1
 
 	#
-- 
2.26.2

