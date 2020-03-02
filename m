Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8A801761D4
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 19:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbgCBSEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 13:04:15 -0500
Received: from mout-u-204.mailbox.org ([91.198.250.253]:65444 "EHLO
        mout-u-204.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbgCBSEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 13:04:14 -0500
Received: from mout-u-107.mailbox.org (mout-u-107.mailbox.org [91.198.250.252])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-u-204.mailbox.org (Postfix) with ESMTPS id 48WSXX2hP6zQlFj;
        Mon,  2 Mar 2020 18:57:32 +0100 (CET)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-u-107.mailbox.org (Postfix) with ESMTPS id 48WSXX27VWzKmkd;
        Mon,  2 Mar 2020 18:57:32 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1583171850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EFNTj2brS+Suz58LeVaHlX6Fl9PpRMaDjJlJxRijkYk=;
        b=xp63USG+5hKY8Y+gpBOPGHYASY+r+fjo7cJpEvl+kLDkLNw1xUjcVFy1STnKF8jsKEcVvS
        Aq/zmOQiPGwswOFLJeU6EA36lik0V2HX8sbQbSMky8doyaDZZpR6zT0ZhoZ/VIGFjMk+WN
        7QYEulr4TfyBM6XDofoPCGvoUXLMpN326bUWv7OCP/q2zu92GjllmmWd3uvK1oP1p5CvhF
        pFCuVaXwC61rnn1+7l73U9rzyVtirAmmw63hwnoIaYHTFolBSdO+rKuCidmMdduo3PBmZP
        N6x+ivrHdEmH2/LIXIZ3pzyqd27J4M9jbbKpHLmh2ccnnuQLzzQDUwL3ffr/cg==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id 3hKnbCX2WzJd; Mon,  2 Mar 2020 18:57:29 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@mellanox.com>,
        Petr Machata <petrm@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Amit Cohen <amitc@mellanox.com>
Subject: [PATCH net-next 2/4] selftests: forwarding: Convert until_counter_is() to take expression
Date:   Mon,  2 Mar 2020 19:56:03 +0200
Message-Id: <6b4f73d1ec3d11920c5beed8eec7289c74eb66b2.1583170249.git.petrm@mellanox.com>
In-Reply-To: <cover.1583170249.git.petrm@mellanox.com>
References: <cover.1583170249.git.petrm@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

until_counter_is() currently takes as an argument a number and the
condition holds when the current counter value is >= that number. Make the
function more generic by taking a partial expression instead of just the
number.

Convert the two existing users.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Amit Cohen <amitc@mellanox.com>
---
 tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh | 6 +++---
 tools/testing/selftests/net/forwarding/lib.sh             | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
index ebf7752f6d93..8f833678ac4d 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
@@ -351,7 +351,7 @@ build_backlog()
 	local i=0
 
 	while :; do
-		local cur=$(busywait 1100 until_counter_is $((cur + 1)) \
+		local cur=$(busywait 1100 until_counter_is "> $cur" \
 					    get_qdisc_backlog $vlan)
 		local diff=$((size - cur))
 		local pkts=$(((diff + 7999) / 8000))
@@ -481,14 +481,14 @@ do_mc_backlog_test()
 	start_tcp_traffic $h1.$vlan $(ipaddr 1 $vlan) $(ipaddr 3 $vlan) bc
 	start_tcp_traffic $h2.$vlan $(ipaddr 2 $vlan) $(ipaddr 3 $vlan) bc
 
-	qbl=$(busywait 5000 until_counter_is 500000 \
+	qbl=$(busywait 5000 until_counter_is ">= 500000" \
 		       get_qdisc_backlog $vlan)
 	check_err $? "Could not build MC backlog"
 
 	# Verify that we actually see the backlog on BUM TC. Do a busywait as
 	# well, performance blips might cause false fail.
 	local ebl
-	ebl=$(busywait 5000 until_counter_is 500000 \
+	ebl=$(busywait 5000 until_counter_is ">= 500000" \
 		       get_mc_transmit_queue $vlan)
 	check_err $? "MC backlog reported by qdisc not visible in ethtool"
 
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index de57e8887a7c..7ecce65d08f9 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -277,11 +277,11 @@ wait_for_offload()
 
 until_counter_is()
 {
-	local value=$1; shift
+	local expr=$1; shift
 	local current=$("$@")
 
 	echo $((current))
-	((current >= value))
+	((current $expr))
 }
 
 busywait_for_counter()
@@ -290,7 +290,7 @@ busywait_for_counter()
 	local delta=$1; shift
 
 	local base=$("$@")
-	busywait "$timeout" until_counter_is $((base + delta)) "$@"
+	busywait "$timeout" until_counter_is ">= $((base + delta))" "$@"
 }
 
 setup_wait_dev()
-- 
2.20.1

