Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE874565A4
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 23:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbhKRW3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 17:29:36 -0500
Received: from mail.netfilter.org ([217.70.188.207]:58272 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbhKRW3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 17:29:33 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id BC392649C0;
        Thu, 18 Nov 2021 23:24:24 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 04/11] selftests: nft_nat: Improve port shadow test stability
Date:   Thu, 18 Nov 2021 23:26:11 +0100
Message-Id: <20211118222618.433273-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211118222618.433273-1-pablo@netfilter.org>
References: <20211118222618.433273-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

Setup phase in test_port_shadow() relied upon a race-condition:
Listening nc on port 1405 was started in background before attempting to
create the fake conntrack entry using the same source port. If listening
nc won, fake conntrack entry could not be created causing wrong
behaviour. Reorder nc calls to fix this and introduce a short delay
before testing the setup to wait for listening nc process startup.

Fixes: 465f15a6d1a8f ("selftests: nft_nat: add udp hole punch test case")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/netfilter/nft_nat.sh | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_nat.sh b/tools/testing/selftests/netfilter/nft_nat.sh
index da1c1e4b6c86..905c033db74d 100755
--- a/tools/testing/selftests/netfilter/nft_nat.sh
+++ b/tools/testing/selftests/netfilter/nft_nat.sh
@@ -759,14 +759,16 @@ test_port_shadow()
 	local result=""
 	local logmsg=""
 
+	# make shadow entry, from client (ns2), going to (ns1), port 41404, sport 1405.
+	echo "fake-entry" | ip netns exec "$ns2" nc -w 1 -p 1405 -u "$daddrc" 41404 > /dev/null
+
 	echo ROUTER | ip netns exec "$ns0" nc -w 5 -u -l -p 1405 >/dev/null 2>&1 &
 	nc_r=$!
 
 	echo CLIENT | ip netns exec "$ns2" nc -w 5 -u -l -p 1405 >/dev/null 2>&1 &
 	nc_c=$!
 
-	# make shadow entry, from client (ns2), going to (ns1), port 41404, sport 1405.
-	echo "fake-entry" | ip netns exec "$ns2" nc -w 1 -p 1405 -u "$daddrc" 41404 > /dev/null
+	sleep 0.3
 
 	# ns1 tries to connect to ns0:1405.  With default settings this should connect
 	# to client, it matches the conntrack entry created above.
-- 
2.30.2

