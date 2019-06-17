Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BACA48505
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 16:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbfFQOOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 10:14:19 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:44740 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725906AbfFQOOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 10:14:19 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hcsOk-0005vT-Ik; Mon, 17 Jun 2019 16:14:15 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     tariqt@mellanox.com, ranro@mellanox.com, maorg@mellanox.com,
        edumazet@google.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 2/2] selftests: rtnetlink: add addresses with fixed life time
Date:   Mon, 17 Jun 2019 16:02:28 +0200
Message-Id: <20190617140228.12523-3-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617140228.12523-1-fw@strlen.de>
References: <20190617140228.12523-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This exercises kernel code path that deal with addresses that have
a limited lifetime.

Without previous fix, this triggers following crash on net-next:
 BUG: KASAN: null-ptr-deref in check_lifetime+0x403/0x670
 Read of size 8 at addr 0000000000000010 by task kworker [..]

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/testing/selftests/net/rtnetlink.sh | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
index b25c9fe019d2..ed606a2e3865 100755
--- a/tools/testing/selftests/net/rtnetlink.sh
+++ b/tools/testing/selftests/net/rtnetlink.sh
@@ -249,6 +249,26 @@ kci_test_route_get()
 	echo "PASS: route get"
 }
 
+kci_test_addrlft()
+{
+	for i in $(seq 10 100) ;do
+		lft=$(((RANDOM%3) + 1))
+		ip addr add 10.23.11.$i/32 dev "$devdummy" preferred_lft $lft valid_lft $((lft+1))
+		check_err $?
+	done
+
+	sleep 5
+
+	ip addr show dev "$devdummy" | grep "10.23.11."
+	if [ $? -eq 0 ]; then
+		echo "FAIL: preferred_lft addresses remaining"
+		check_err 1
+		return
+	fi
+
+	echo "PASS: preferred_lft addresses have expired"
+}
+
 kci_test_addrlabel()
 {
 	ret=0
@@ -1140,6 +1160,7 @@ kci_test_rtnl()
 
 	kci_test_polrouting
 	kci_test_route_get
+	kci_test_addrlft
 	kci_test_tc
 	kci_test_gre
 	kci_test_gretap
-- 
2.21.0

