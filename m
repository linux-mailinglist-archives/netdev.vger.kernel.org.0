Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2F2F519B2C
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 11:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346852AbiEDJLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 05:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345902AbiEDJLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 05:11:39 -0400
Received: from smtpservice.6wind.com (unknown [185.13.181.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC70E1A827;
        Wed,  4 May 2022 02:08:03 -0700 (PDT)
Received: from bretzel (bretzel.dev.6wind.com [10.17.1.57])
        by smtpservice.6wind.com (Postfix) with ESMTPS id 7E686600EB;
        Wed,  4 May 2022 11:08:02 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1nmAzK-0005gJ-Dg; Wed, 04 May 2022 11:08:02 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        stable@vger.kernel.org
Subject: [PATCH net v3 1/2] ping: fix address binding wrt vrf
Date:   Wed,  4 May 2022 11:07:38 +0200
Message-Id: <20220504090739.21821-2-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220504090739.21821-1-nicolas.dichtel@6wind.com>
References: <1238b102-f491-a917-3708-0df344015a5b@kernel.org>
 <20220504090739.21821-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When ping_group_range is updated, 'ping' uses the DGRAM ICMP socket,
instead of an IP raw socket. In this case, 'ping' is unable to bind its
socket to a local address owned by a vrflite.

Before the patch:
$ sysctl -w net.ipv4.ping_group_range='0  2147483647'
$ ip link add blue type vrf table 10
$ ip link add foo type dummy
$ ip link set foo master blue
$ ip link set foo up
$ ip addr add 192.168.1.1/24 dev foo
$ ip addr add 2001::1/64 dev foo
$ ip vrf exec blue ping -c1 -I 192.168.1.1 192.168.1.2
ping: bind: Cannot assign requested address
$ ip vrf exec blue ping6 -c1 -I 2001::1 2001::2
ping6: bind icmp socket: Cannot assign requested address

CC: stable@vger.kernel.org
Fixes: 1b69c6d0ae90 ("net: Introduce L3 Master device abstraction")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 net/ipv4/ping.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 3ee947557b88..aa9a11b20d18 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -305,6 +305,7 @@ static int ping_check_bind_addr(struct sock *sk, struct inet_sock *isk,
 	struct net *net = sock_net(sk);
 	if (sk->sk_family == AF_INET) {
 		struct sockaddr_in *addr = (struct sockaddr_in *) uaddr;
+		u32 tb_id = RT_TABLE_LOCAL;
 		int chk_addr_ret;
 
 		if (addr_len < sizeof(*addr))
@@ -318,7 +319,8 @@ static int ping_check_bind_addr(struct sock *sk, struct inet_sock *isk,
 		pr_debug("ping_check_bind_addr(sk=%p,addr=%pI4,port=%d)\n",
 			 sk, &addr->sin_addr.s_addr, ntohs(addr->sin_port));
 
-		chk_addr_ret = inet_addr_type(net, addr->sin_addr.s_addr);
+		tb_id = l3mdev_fib_table_by_index(net, sk->sk_bound_dev_if) ? : tb_id;
+		chk_addr_ret = inet_addr_type_table(net, addr->sin_addr.s_addr, tb_id);
 
 		if (!inet_addr_valid_or_nonlocal(net, inet_sk(sk),
 					         addr->sin_addr.s_addr,
@@ -355,6 +357,14 @@ static int ping_check_bind_addr(struct sock *sk, struct inet_sock *isk,
 				return -ENODEV;
 			}
 		}
+
+		if (!dev && sk->sk_bound_dev_if) {
+			dev = dev_get_by_index_rcu(net, sk->sk_bound_dev_if);
+			if (!dev) {
+				rcu_read_unlock();
+				return -ENODEV;
+			}
+		}
 		has_addr = pingv6_ops.ipv6_chk_addr(net, &addr->sin6_addr, dev,
 						    scoped);
 		rcu_read_unlock();
-- 
2.33.0

