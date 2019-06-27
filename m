Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9094658213
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 14:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfF0MDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 08:03:46 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:47464 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726809AbfF0MDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 08:03:44 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hgT7u-0002lP-WF; Thu, 27 Jun 2019 14:03:43 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     ranro@mellanox.com, tariqt@mellanox.com,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 2/2] selftests: rtnetlink: add small test case with 'promote_secondaries' enabled
Date:   Thu, 27 Jun 2019 14:03:33 +0200
Message-Id: <20190627120333.12469-3-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190627120333.12469-1-fw@strlen.de>
References: <20190627120333.12469-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This exercises the 'promote_secondaries' code path.

Without previous fix, this triggers infinite loop/soft lockup:
ifconfig process spinning at 100%, never to return.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/testing/selftests/net/rtnetlink.sh | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
index ed606a2e3865..505628884783 100755
--- a/tools/testing/selftests/net/rtnetlink.sh
+++ b/tools/testing/selftests/net/rtnetlink.sh
@@ -269,6 +269,25 @@ kci_test_addrlft()
 	echo "PASS: preferred_lft addresses have expired"
 }
 
+kci_test_promote_secondaries()
+{
+	promote=$(sysctl -n net.ipv4.conf.$devdummy.promote_secondaries)
+
+	sysctl -q net.ipv4.conf.$devdummy.promote_secondaries=1
+
+	for i in $(seq 2 254);do
+		IP="10.23.11.$i"
+		ip -f inet addr add $IP/16 brd + dev "$devdummy"
+		ifconfig "$devdummy" $IP netmask 255.255.0.0
+	done
+
+	ip addr flush dev "$devdummy"
+
+	[ $promote -eq 0 ] && sysctl -q net.ipv4.conf.$devdummy.promote_secondaries=0
+
+	echo "PASS: promote_secondaries complete"
+}
+
 kci_test_addrlabel()
 {
 	ret=0
@@ -1161,6 +1180,7 @@ kci_test_rtnl()
 	kci_test_polrouting
 	kci_test_route_get
 	kci_test_addrlft
+	kci_test_promote_secondaries
 	kci_test_tc
 	kci_test_gre
 	kci_test_gretap
-- 
2.21.0

