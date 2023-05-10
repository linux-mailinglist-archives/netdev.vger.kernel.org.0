Return-Path: <netdev+bounces-1432-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 32EAD6FDC7E
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 13:18:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58A601C20D46
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:18:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 837158C17;
	Wed, 10 May 2023 11:17:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7754D8C13
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 11:17:55 +0000 (UTC)
Received: from smtp.uniroma2.it (smtp.uniroma2.it [160.80.6.22])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5C41A6;
	Wed, 10 May 2023 04:17:53 -0700 (PDT)
Received: from localhost.localdomain ([160.80.103.126])
	by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 34ABHOim003525
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 10 May 2023 13:17:25 +0200
From: Andrea Mayer <andrea.mayer@uniroma2.it>
To: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [net 1/2] selftests: seg6: disable DAD on IPv6 router cfg for srv6_end_dt4_l3vpn_test
Date: Wed, 10 May 2023 13:16:37 +0200
Message-Id: <20230510111638.12408-2-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230510111638.12408-1-andrea.mayer@uniroma2.it>
References: <20230510111638.12408-1-andrea.mayer@uniroma2.it>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The srv6_end_dt4_l3vpn_test instantiates a virtual network consisting of
several routers (rt-1, rt-2) and hosts.
When the IPv6 addresses of rt-{1,2} routers are configured, the Deduplicate
Address Detection (DAD) kicks in when enabled in the Linux distros running
the selftests. DAD is used to check whether an IPv6 address is already
assigned in a network. Such a mechanism consists of sending an ICMPv6 Echo
Request and waiting for a reply.
As the DAD process could take too long to complete, it may cause the
failing of some tests carried out by the srv6_end_dt4_l3vpn_test script.

To make the srv6_end_dt4_l3vpn_test more robust, we disable DAD on routers
since we configure the virtual network manually and do not need any address
deduplication mechanism at all.

Fixes: 2195444e09b4 ("selftests: add selftest for the SRv6 End.DT4 behavior")
Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
---
 tools/testing/selftests/net/srv6_end_dt4_l3vpn_test.sh | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/srv6_end_dt4_l3vpn_test.sh b/tools/testing/selftests/net/srv6_end_dt4_l3vpn_test.sh
index 1003119773e5..37f08d582d2f 100755
--- a/tools/testing/selftests/net/srv6_end_dt4_l3vpn_test.sh
+++ b/tools/testing/selftests/net/srv6_end_dt4_l3vpn_test.sh
@@ -232,10 +232,14 @@ setup_rt_networking()
 	local nsname=rt-${rt}
 
 	ip netns add ${nsname}
+
+	ip netns exec ${nsname} sysctl -wq net.ipv6.conf.all.accept_dad=0
+	ip netns exec ${nsname} sysctl -wq net.ipv6.conf.default.accept_dad=0
+
 	ip link set veth-rt-${rt} netns ${nsname}
 	ip -netns ${nsname} link set veth-rt-${rt} name veth0
 
-	ip -netns ${nsname} addr add ${IPv6_RT_NETWORK}::${rt}/64 dev veth0
+	ip -netns ${nsname} addr add ${IPv6_RT_NETWORK}::${rt}/64 dev veth0 nodad
 	ip -netns ${nsname} link set veth0 up
 	ip -netns ${nsname} link set lo up
 
-- 
2.20.1


