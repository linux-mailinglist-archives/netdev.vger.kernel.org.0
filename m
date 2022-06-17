Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5956954F3BB
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 10:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381439AbiFQI5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 04:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381427AbiFQI53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 04:57:29 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A690C5250B;
        Fri, 17 Jun 2022 01:57:27 -0700 (PDT)
Received: (Authenticated sender: pbl@bestov.io)
        by mail.gandi.net (Postfix) with ESMTPSA id 99015FF803;
        Fri, 17 Jun 2022 08:57:19 +0000 (UTC)
From:   Riccardo Paolo Bestetti <pbl@bestov.io>
To:     Carlos Llamas <cmllamas@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Riccardo Paolo Bestetti <pbl@bestov.io>
Cc:     kernel-team@android.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Subject: [PATCH v2] ipv4: ping: fix bind address validity check
Date:   Fri, 17 Jun 2022 10:54:35 +0200
Message-Id: <20220617085435.193319-1-pbl@bestov.io>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 8ff978b8b222 ("ipv4/raw: support binding to nonlocal addresses")
introduced a helper function to fold duplicated validity checks of bind
addresses into inet_addr_valid_or_nonlocal(). However, this caused an
unintended regression in ping_check_bind_addr(), which previously would
reject binding to multicast and broadcast addresses, but now these are
both incorrectly allowed as reported in [1].

This patch restores the original check. A simple reordering is done to
improve readability and make it evident that multicast and broadcast
addresses should not be allowed. Also, add an early exit for INADDR_ANY
which replaces lost behavior added by commit 0ce779a9f501 ("net: Avoid
unnecessary inet_addr_type() call when addr is INADDR_ANY").

Furthermore, this patch introduces regression selftests to catch these
specific cases.

[1] https://lore.kernel.org/netdev/CANP3RGdkAcDyAZoT1h8Gtuu0saq+eOrrTiWbxnOs+5zn+cpyKg@mail.gmail.com/

Fixes: 8ff978b8b222 ("ipv4/raw: support binding to nonlocal addresses")
Cc: Miaohe Lin <linmiaohe@huawei.com>
Reported-by: Maciej Żenczykowski <maze@google.com>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Riccardo Paolo Bestetti <pbl@bestov.io>
---
This patch is sent as a follow-up to the discussion on the v1 by Carlos
Llamas.

Original thread:
https://lore.kernel.org/netdev/20220617020213.1881452-1-cmllamas@google.com/

 net/ipv4/ping.c                           | 10 ++++---
 tools/testing/selftests/net/fcnal-test.sh | 33 +++++++++++++++++++++++
 2 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 1a43ca73f94d..3c6101def7d6 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -319,12 +319,16 @@ static int ping_check_bind_addr(struct sock *sk, struct inet_sock *isk,
 		pr_debug("ping_check_bind_addr(sk=%p,addr=%pI4,port=%d)\n",
 			 sk, &addr->sin_addr.s_addr, ntohs(addr->sin_port));
 
+		if (addr->sin_addr.s_addr == htonl(INADDR_ANY))
+			return 0;
+
 		tb_id = l3mdev_fib_table_by_index(net, sk->sk_bound_dev_if) ? : tb_id;
 		chk_addr_ret = inet_addr_type_table(net, addr->sin_addr.s_addr, tb_id);
 
-		if (!inet_addr_valid_or_nonlocal(net, inet_sk(sk),
-					         addr->sin_addr.s_addr,
-	                                         chk_addr_ret))
+		if (chk_addr_ret == RTN_MULTICAST ||
+		    chk_addr_ret == RTN_BROADCAST ||
+		    (chk_addr_ret != RTN_LOCAL &&
+		     !inet_can_nonlocal_bind(net, isk)))
 			return -EADDRNOTAVAIL;
 
 #if IS_ENABLED(CONFIG_IPV6)
diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 54701c8b0cd7..75223b63e3c8 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -70,6 +70,10 @@ NSB_LO_IP6=2001:db8:2::2
 NL_IP=172.17.1.1
 NL_IP6=2001:db8:4::1
 
+# multicast and broadcast addresses
+MCAST_IP=224.0.0.1
+BCAST_IP=255.255.255.255
+
 MD5_PW=abc123
 MD5_WRONG_PW=abc1234
 
@@ -308,6 +312,9 @@ addr2str()
 	127.0.0.1) echo "loopback";;
 	::1) echo "IPv6 loopback";;
 
+	${BCAST_IP}) echo "broadcast";;
+	${MCAST_IP}) echo "multicast";;
+
 	${NSA_IP})	echo "ns-A IP";;
 	${NSA_IP6})	echo "ns-A IPv6";;
 	${NSA_LO_IP})	echo "ns-A loopback IP";;
@@ -1800,6 +1807,19 @@ ipv4_addr_bind_novrf()
 	run_cmd nettest -s -R -P icmp -f -l ${a} -I ${NSA_DEV} -b
 	log_test_addr ${a} $? 0 "Raw socket bind to nonlocal address after device bind"
 
+	#
+	# check that ICMP sockets cannot bind to broadcast and multicast addresses
+	#
+	a=${BCAST_IP}
+	log_start
+	run_cmd nettest -s -R -P icmp -l ${a} -b
+	log_test_addr ${a} $? 1 "ICMP socket bind to broadcast address"
+
+	a=${MCAST_IP}
+	log_start
+	run_cmd nettest -s -R -P icmp -f -l ${a} -b
+	log_test_addr ${a} $? 1 "ICMP socket bind to multicast address"
+
 	#
 	# tcp sockets
 	#
@@ -1857,6 +1877,19 @@ ipv4_addr_bind_vrf()
 	run_cmd nettest -s -R -P icmp -f -l ${a} -I ${VRF} -b
 	log_test_addr ${a} $? 0 "Raw socket bind to nonlocal address after VRF bind"
 
+	#
+	# check that ICMP sockets cannot bind to broadcast and multicast addresses
+	#
+	a=${BCAST_IP}
+	log_start
+	run_cmd nettest -s -R -P icmp -l ${a} -I ${VRF} -b
+	log_test_addr ${a} $? 1 "ICMP socket bind to broadcast address after VRF bind"
+
+	a=${MCAST_IP}
+	log_start
+	run_cmd nettest -s -R -P icmp -f -l ${a} -I ${VRF} -b
+	log_test_addr ${a} $? 1 "ICMP socket bind to multicast address after VRF bind"
+
 	#
 	# tcp sockets
 	#
-- 
2.36.1

