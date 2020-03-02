Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 640831761D3
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 19:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbgCBSEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 13:04:15 -0500
Received: from mout-u-204.mailbox.org ([91.198.250.253]:65448 "EHLO
        mout-u-204.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727250AbgCBSEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 13:04:14 -0500
Received: from mout-u-107.mailbox.org (mout-u-107.mailbox.org [91.198.250.252])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-u-204.mailbox.org (Postfix) with ESMTPS id 48WSXY245JzQlFk;
        Mon,  2 Mar 2020 18:57:33 +0100 (CET)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-u-107.mailbox.org (Postfix) with ESMTPS id 48WSXY1ZG2zKmkd;
        Mon,  2 Mar 2020 18:57:33 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1583171851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ly331UmSRuFnyUT3f5xDX0sIPjxf59acPiLjIQfcUxA=;
        b=Qz6/hJ5v1x+ifhPUVdxgW5OtYqt6zn8MmDUeNHtyeUWbWe6bn87j51ZkvU5S/4sR3YRg3P
        HOROTcbYhC0GIbcatY1l7d0cvwrpMOjALcQXUnC5bpUWU+URn2KcjK5gf9cQbEKvOxxg6y
        cVOTdbQnRB62bEg/qdhD/3LpODA0sk0LrfwJ81rK6CLHkI5LqMknbiu1Z7IvZ0Jlg+1QcW
        V0qJHaenHyPBtGT4RL9GERvQYHeVehO0FxIby1hIZEJNgyd5fGBnuwL1KjTKZR4bbZJVrv
        38dvsHtV4amss88WXs0UCr81WuhgrmFaPbvSIxKUanveS1AIopPTm8PFEf8mmA==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id EwO27NcyP0Oy; Mon,  2 Mar 2020 18:57:30 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@mellanox.com>,
        Petr Machata <petrm@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Amit Cohen <amitc@mellanox.com>
Subject: [PATCH net-next 3/4] selftests: forwarding: tc_common: Convert to use busywait
Date:   Mon,  2 Mar 2020 19:56:04 +0200
Message-Id: <69173a424aefde8eaef0f25aaf5c7c17790fc384.1583170249.git.petrm@mellanox.com>
In-Reply-To: <cover.1583170249.git.petrm@mellanox.com>
References: <cover.1583170249.git.petrm@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

A function busywait() was recently added based on the logic in
__tc_check_packets(). Convert the code in tc_common to use the new
function.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Amit Cohen <amitc@mellanox.com>
---
 .../selftests/net/forwarding/tc_common.sh     | 32 +++----------------
 1 file changed, 4 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/tc_common.sh b/tools/testing/selftests/net/forwarding/tc_common.sh
index 64f652633585..0e18e8be6e2a 100644
--- a/tools/testing/selftests/net/forwarding/tc_common.sh
+++ b/tools/testing/selftests/net/forwarding/tc_common.sh
@@ -6,39 +6,14 @@ CHECK_TC="yes"
 # Can be overridden by the configuration file. See lib.sh
 TC_HIT_TIMEOUT=${TC_HIT_TIMEOUT:=1000} # ms
 
-__tc_check_packets()
-{
-	local id=$1
-	local handle=$2
-	local count=$3
-	local operator=$4
-
-	start_time="$(date -u +%s%3N)"
-	while true
-	do
-		cmd_jq "tc -j -s filter show $id" \
-		       ".[] | select(.options.handle == $handle) | \
-			    select(.options.actions[0].stats.packets $operator $count)" \
-		    &> /dev/null
-		ret=$?
-		if [[ $ret -eq 0 ]]; then
-			return $ret
-		fi
-		current_time="$(date -u +%s%3N)"
-		diff=$(expr $current_time - $start_time)
-		if [ "$diff" -gt "$TC_HIT_TIMEOUT" ]; then
-			return 1
-		fi
-	done
-}
-
 tc_check_packets()
 {
 	local id=$1
 	local handle=$2
 	local count=$3
 
-	__tc_check_packets "$id" "$handle" "$count" "=="
+	busywait "$TC_HIT_TIMEOUT" until_counter_is "== $count" \
+		 tc_rule_handle_stats_get "$id" "$handle" > /dev/null
 }
 
 tc_check_packets_hitting()
@@ -46,5 +21,6 @@ tc_check_packets_hitting()
 	local id=$1
 	local handle=$2
 
-	__tc_check_packets "$id" "$handle" 0 ">"
+	busywait "$TC_HIT_TIMEOUT" until_counter_is "> 0" \
+		 tc_rule_handle_stats_get "$id" "$handle" > /dev/null
 }
-- 
2.20.1

