Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C977B327297
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 15:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhB1O2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 09:28:21 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:49337 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230140AbhB1O2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 09:28:18 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 417A05C00F9;
        Sun, 28 Feb 2021 09:27:32 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 28 Feb 2021 09:27:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=4VB76095Bw982CVtQ1qUdYMlMzFApFwppMpMwLk8PRM=; b=waXvwZQl
        RKqj/hyEbPHJd8GaYov9EYqqP/nNU0Sdfzqryx7jr/UGBWteEGgjeSLomhN3Xac8
        zAaRc+upvuBExB0LQQRhplcImsr0ZSCvI8FK4wkK6mbjQqETykcI9FMDOIOJoXoX
        R8qUwDc6vyDtESdZRGs3g/ItYOVvLO59iArM6Yb3LRPz6QInFZQGcjSFihTQ3rhV
        D4gidwDgeLdndWKNRSByUQWdCYij+XcdxcJwD5WKAVstOUv743qdWqnxkR61xBfw
        6JJqVpQP4Sdc6vS+YYrJCHS5jeTqhof5yT4etOBHQbkXVAKhZGf9f4jhH1mWHiyT
        ksgtnf3g3pX03A==
X-ME-Sender: <xms:VKg7YEMxZTcaOnbpJoQjn-l5VaSt8buGTgeHdxsD3bF4tr4Yu3tNiw>
    <xme:VKg7YK9HEkwSfcf3iEhuveYXI4JjyHLgbPRo5o3mhI8KuF_3kq3GxDnsBHmOEnWYc
    XesapSFaSKAo0E>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleeigdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeggeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:VKg7YLQX5J6TUlDB6bFQA1HikNnEyN3fFNp0xoK9_fD-tDXTCkChAQ>
    <xmx:VKg7YMs7PcvN5A5kd6nCePFC8BQifwNQzaf05l5-LNPzTaSMBGSqYg>
    <xmx:VKg7YMebMvJoiyE4sA8V8-01jpEFUfSDXlpKs0uySOSUU7V7FIFdJw>
    <xmx:VKg7YL44TST4VHZ6LdSHO8HIrjbtXydyaHbNZIWwfDst1FcPk_uRLg>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1E05E1080057;
        Sun, 28 Feb 2021 09:27:29 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        roopa@nvidia.com, sharpd@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net 2/2] selftests: fib_nexthops: Test blackhole nexthops when loopback goes down
Date:   Sun, 28 Feb 2021 16:26:13 +0200
Message-Id: <20210228142613.1642938-3-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210228142613.1642938-1-idosch@idosch.org>
References: <20210228142613.1642938-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Test that blackhole nexthops are not flushed when the loopback device
goes down.

Output without previous patch:

 # ./fib_nexthops.sh -t basic

 Basic functional tests
 ----------------------
 TEST: List with nothing defined                                     [ OK ]
 TEST: Nexthop get on non-existent id                                [ OK ]
 TEST: Nexthop with no device or gateway                             [ OK ]
 TEST: Nexthop with down device                                      [ OK ]
 TEST: Nexthop with device that is linkdown                          [ OK ]
 TEST: Nexthop with device only                                      [ OK ]
 TEST: Nexthop with duplicate id                                     [ OK ]
 TEST: Blackhole nexthop                                             [ OK ]
 TEST: Blackhole nexthop with other attributes                       [ OK ]
 TEST: Blackhole nexthop with loopback device down                   [FAIL]
 TEST: Create group                                                  [ OK ]
 TEST: Create group with blackhole nexthop                           [FAIL]
 TEST: Create multipath group where 1 path is a blackhole            [ OK ]
 TEST: Multipath group can not have a member replaced by blackhole   [ OK ]
 TEST: Create group with non-existent nexthop                        [ OK ]
 TEST: Create group with same nexthop multiple times                 [ OK ]
 TEST: Replace nexthop with nexthop group                            [ OK ]
 TEST: Replace nexthop group with nexthop                            [ OK ]
 TEST: Nexthop group and device                                      [ OK ]
 TEST: Test proto flush                                              [ OK ]
 TEST: Nexthop group and blackhole                                   [ OK ]

 Tests passed:  19
 Tests failed:   2

Output with previous patch:

 # ./fib_nexthops.sh -t basic

 Basic functional tests
 ----------------------
 TEST: List with nothing defined                                     [ OK ]
 TEST: Nexthop get on non-existent id                                [ OK ]
 TEST: Nexthop with no device or gateway                             [ OK ]
 TEST: Nexthop with down device                                      [ OK ]
 TEST: Nexthop with device that is linkdown                          [ OK ]
 TEST: Nexthop with device only                                      [ OK ]
 TEST: Nexthop with duplicate id                                     [ OK ]
 TEST: Blackhole nexthop                                             [ OK ]
 TEST: Blackhole nexthop with other attributes                       [ OK ]
 TEST: Blackhole nexthop with loopback device down                   [ OK ]
 TEST: Create group                                                  [ OK ]
 TEST: Create group with blackhole nexthop                           [ OK ]
 TEST: Create multipath group where 1 path is a blackhole            [ OK ]
 TEST: Multipath group can not have a member replaced by blackhole   [ OK ]
 TEST: Create group with non-existent nexthop                        [ OK ]
 TEST: Create group with same nexthop multiple times                 [ OK ]
 TEST: Replace nexthop with nexthop group                            [ OK ]
 TEST: Replace nexthop group with nexthop                            [ OK ]
 TEST: Nexthop group and device                                      [ OK ]
 TEST: Test proto flush                                              [ OK ]
 TEST: Nexthop group and blackhole                                   [ OK ]

 Tests passed:  21
 Tests failed:   0

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 tools/testing/selftests/net/fib_nexthops.sh | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index 4c7d33618437..d98fb85e201c 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -1524,6 +1524,14 @@ basic()
 	run_cmd "$IP nexthop replace id 2 blackhole dev veth1"
 	log_test $? 2 "Blackhole nexthop with other attributes"
 
+	# blackhole nexthop should not be affected by the state of the loopback
+	# device
+	run_cmd "$IP link set dev lo down"
+	check_nexthop "id 2" "id 2 blackhole"
+	log_test $? 0 "Blackhole nexthop with loopback device down"
+
+	run_cmd "$IP link set dev lo up"
+
 	#
 	# groups
 	#
-- 
2.29.2

