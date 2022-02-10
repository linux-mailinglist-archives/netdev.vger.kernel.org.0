Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA9E54B1921
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 00:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345479AbiBJXKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 18:10:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345468AbiBJXKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 18:10:30 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8D5F91105;
        Thu, 10 Feb 2022 15:10:30 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8FF49601D9;
        Fri, 11 Feb 2022 00:10:13 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 6/6] selftests: netfilter: disable rp_filter on router
Date:   Fri, 11 Feb 2022 00:10:21 +0100
Message-Id: <20220210231021.204488-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220210231021.204488-1-pablo@netfilter.org>
References: <20220210231021.204488-1-pablo@netfilter.org>
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

From: Hangbin Liu <liuhangbin@gmail.com>

Some distros may enable rp_filter by default. After ns1 change addr to
10.0.2.99 and set default router to 10.0.2.1, while the connected router
address is still 10.0.1.1. The router will not reply the arp request
from ns1. Fix it by setting the router's veth0 rp_filter to 0.

Before the fix:
  # ./nft_fib.sh
  PASS: fib expression did not cause unwanted packet drops
  Netns nsrouter-HQkDORO2 fib counter doesn't match expected packet count of 1 for 1.1.1.1
  table inet filter {
          chain prerouting {
                  type filter hook prerouting priority filter; policy accept;
                  ip daddr 1.1.1.1 fib saddr . iif oif missing counter packets 0 bytes 0 drop
                  ip6 daddr 1c3::c01d fib saddr . iif oif missing counter packets 0 bytes 0 drop
          }
  }

After the fix:
  # ./nft_fib.sh
  PASS: fib expression did not cause unwanted packet drops
  PASS: fib expression did drop packets for 1.1.1.1
  PASS: fib expression did drop packets for 1c3::c01d

Fixes: 82944421243e ("selftests: netfilter: add fib test case")
Signed-off-by: Yi Chen <yiche@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/netfilter/nft_fib.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/netfilter/nft_fib.sh b/tools/testing/selftests/netfilter/nft_fib.sh
index 6caf6ac8c285..695a1958723f 100755
--- a/tools/testing/selftests/netfilter/nft_fib.sh
+++ b/tools/testing/selftests/netfilter/nft_fib.sh
@@ -174,6 +174,7 @@ test_ping() {
 ip netns exec ${nsrouter} sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
 ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
 ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
+ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth0.rp_filter=0 > /dev/null
 
 sleep 3
 
-- 
2.30.2

