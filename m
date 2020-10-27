Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C89629C815
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 20:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S371434AbgJ0TB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 15:01:27 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37875 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S371371AbgJ0TAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 15:00:21 -0400
Received: by mail-wm1-f65.google.com with SMTP id c16so2551943wmd.2
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 12:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Asc85PeAu34wOOUcZ5M4BI/jMYTqZqHRSKn8fRmFp+Q=;
        b=NRIRVoObB74sv3K3+hxR4HW1wX78cjMhupA5bRlj+8nJTuZ9MYgojs81gDBM/niY8o
         Fj8uKXZvLxaYYc+zsO30MLCgqwiLldUeQcuQSnmi1cXFKwjixQtgv4YmXz+GUnIDuoXD
         hQPQRuynPvAlIS7vM6kQXZXmB1vm2wxxnunCFknDQ5agLf8twnBnsjpVZLtZCBbNlL9/
         9a/xzzZoOdyfHLU4GBQhlHP2kGjZHetDc+miIswIDLqIic8HaSiDVO2y4t6YoR4W560W
         /odot+qz7elCLafQIH1RKcnCowgo1G7Fo2G+mU5RGZoiOmXiBreP5RzpM/e8lSeBhKGO
         tkaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Asc85PeAu34wOOUcZ5M4BI/jMYTqZqHRSKn8fRmFp+Q=;
        b=UzZAWeibJw+64t+9Bu1Ud7UMJdrsiRzFneh3YnGD1lA9W4l5zyhwbCGs/L4S5zCU2A
         vm10wVHx/Hv9POnbyjBKDW/wYgbACegJa3nEFrCxaqlYLUL6RopSx2ynC7oIDsVI44io
         5/OY9PvDbwQKQc0+mxUEWz9oNA6YWIUT1J9cP78cxP8nr3fEmPEpg2ozXE3NctMw+Gow
         uAB9k6MO69hqa1OOXbOjE6i1DdM/VF3xNoS2BOdoP5C6h5J8oy/53u2epmToE35QxCl7
         yoXtsyRYIlsu1bdVFsU+a0OVqCr5c2qaaslnVhbWSMbDEfqkbnvW9gF9WA9EGtukzvo9
         LFDw==
X-Gm-Message-State: AOAM531696dcZZnbBRrxrsEgEB1g3MbWRISOhxwG1eDaaR5emP/TpOn1
        l5kO8xrbzsCLq7qcJiV87asQ0wa5+tgCAcHJ
X-Google-Smtp-Source: ABdhPJz6HKK/h/k1yqee0HneGTNOMuCc/QnrFT6p+vKJyGWponzQy7Xl18wdF9hms41zfsEiVhmL5Q==
X-Received: by 2002:a7b:cf04:: with SMTP id l4mr4297731wmg.33.1603825217071;
        Tue, 27 Oct 2020 12:00:17 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x6sm3219803wmb.17.2020.10.27.12.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 12:00:16 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 09/16] selftests: net: bridge: add test for igmpv3 exc -> allow report
Date:   Tue, 27 Oct 2020 20:59:27 +0200
Message-Id: <20201027185934.227040-10-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201027185934.227040-1-razor@blackwall.org>
References: <20201027185934.227040-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

The test checks for the following case:
   state          report        result                  action
  EXCLUDE (X,Y)  ALLOW (A)     EXCLUDE (X+A,Y-A)       (A)=GMI

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 .../selftests/net/forwarding/bridge_igmp.sh   | 83 +++++++++++++------
 1 file changed, 59 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_igmp.sh b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
index 36f10a3168cc..d786e75abe2c 100755
--- a/tools/testing/selftests/net/forwarding/bridge_igmp.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
@@ -2,7 +2,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
 ALL_TESTS="v2reportleave_test v3include_test v3inc_allow_test v3inc_is_include_test \
-	   v3inc_is_exclude_test v3inc_to_exclude_test"
+	   v3inc_is_exclude_test v3inc_to_exclude_test v3exc_allow_test"
 NUM_NETIFS=4
 CHECK_TC="yes"
 TEST_GROUP="239.10.10.10"
@@ -17,6 +17,8 @@ MZPKT_IS_INC="22:00:9d:de:00:00:00:01:01:00:00:03:ef:0a:0a:0a:c0:00:02:01:c0:00:
 MZPKT_IS_INC2="22:00:9d:c3:00:00:00:01:01:00:00:03:ef:0a:0a:0a:c0:00:02:0a:c0:00:02:0b:c0:00:02:0c"
 # IGMPv3 allow report: grp 239.10.10.10 allow 192.0.2.10,192.0.2.11,192.0.2.12
 MZPKT_ALLOW="22:00:99:c3:00:00:00:01:05:00:00:03:ef:0a:0a:0a:c0:00:02:0a:c0:00:02:0b:c0:00:02:0c"
+# IGMPv3 allow report: grp 239.10.10.10 allow 192.0.2.20,192.0.2.30
+MZPKT_ALLOW2="22:00:5b:b4:00:00:00:01:05:00:00:02:ef:0a:0a:0a:c0:00:02:14:c0:00:02:1e"
 # IGMPv3 is_ex report: grp 239.10.10.10 is_exclude 192.0.2.1,192.0.2.2,192.0.2.20,192.0.2.21
 MZPKT_IS_EXC="22:00:da:b6:00:00:00:01:02:00:00:04:ef:0a:0a:0a:c0:00:02:01:c0:00:02:02:c0:00:02:14:c0:00:02:15"
 # IGMPv3 to_ex report: grp 239.10.10.10 to_exclude 192.0.2.1,192.0.2.20,192.0.2.30
@@ -250,6 +252,38 @@ v3include_prepare()
 	check_sg_entries "is_include" "${X[@]}"
 }
 
+v3exclude_prepare()
+{
+	local host1_if=$1
+	local mac=$2
+	local group=$3
+	local pkt=$4
+	local X=("192.0.2.1" "192.0.2.2")
+	local Y=("192.0.2.20" "192.0.2.21")
+
+	v3include_prepare $host1_if $mac $group
+
+	$MZ $host1_if -c 1 -b $mac -B $group -t ip "proto=2,p=$MZPKT_IS_EXC" -q
+	sleep 1
+	bridge -j -d -s mdb show dev br0 \
+		| jq -e ".[].mdb[] | \
+			 select(.grp == \"$TEST_GROUP\" and \
+				.source_list != null and .filter_mode == \"exclude\")" &>/dev/null
+	check_err $? "Wrong *,G entry filter mode"
+
+	check_sg_entries "is_exclude" "${X[@]}" "${Y[@]}"
+
+	check_sg_state 0 "${X[@]}"
+	check_sg_state 1 "${Y[@]}"
+
+	bridge -j -d -s mdb show dev br0 \
+		| jq -e ".[].mdb[] | \
+			 select(.grp == \"$TEST_GROUP\" and \
+				.source_list != null and
+				.source_list[].address == \"192.0.2.3\")" &>/dev/null
+	check_fail $? "Wrong *,G entry source list, 192.0.2.3 entry still exists"
+}
+
 v3cleanup()
 {
 	local port=$1
@@ -321,30 +355,8 @@ v3inc_is_include_test()
 v3inc_is_exclude_test()
 {
 	RET=0
-	local X=("192.0.2.1" "192.0.2.2")
-	local Y=("192.0.2.20" "192.0.2.21")
-
-	v3include_prepare $h1 $ALL_MAC $ALL_GROUP
-
-	$MZ $h1 -c 1 -b $ALL_MAC -B $ALL_GROUP -t ip "proto=2,p=$MZPKT_IS_EXC" -q
-	sleep 1
-	bridge -j -d -s mdb show dev br0 \
-		| jq -e ".[].mdb[] | \
-			 select(.grp == \"$TEST_GROUP\" and \
-				.source_list != null and .filter_mode == \"exclude\")" &>/dev/null
-	check_err $? "Wrong *,G entry filter mode"
-
-	check_sg_entries "is_exclude" "${X[@]}" "${Y[@]}"
 
-	check_sg_state 0 "${X[@]}"
-	check_sg_state 1 "${Y[@]}"
-
-	bridge -j -d -s mdb show dev br0 \
-		| jq -e ".[].mdb[] | \
-			 select(.grp == \"$TEST_GROUP\" and \
-				.source_list != null and
-				.source_list[].address == \"192.0.2.3\")" &>/dev/null
-	check_fail $? "Wrong *,G entry source list, 192.0.2.3 entry still exists"
+	v3exclude_prepare $h1 $ALL_MAC $ALL_GROUP
 
 	check_sg_fwding 1 "${X[@]}" 192.0.2.100
 	check_sg_fwding 0 "${Y[@]}"
@@ -401,6 +413,29 @@ v3inc_to_exclude_test()
 	v3cleanup $swp1 $TEST_GROUP
 }
 
+v3exc_allow_test()
+{
+	RET=0
+	local X=("192.0.2.1" "192.0.2.2" "192.0.2.20" "192.0.2.30")
+	local Y=("192.0.2.21")
+
+	v3exclude_prepare $h1 $ALL_MAC $ALL_GROUP
+
+	$MZ $h1 -c 1 -b $ALL_MAC -B $ALL_GROUP -t ip "proto=2,p=$MZPKT_ALLOW2" -q
+	sleep 1
+	check_sg_entries "allow" "${X[@]}" "${Y[@]}"
+
+	check_sg_state 0 "${X[@]}"
+	check_sg_state 1 "${Y[@]}"
+
+	check_sg_fwding 1 "${X[@]}" 192.0.2.100
+	check_sg_fwding 0 "${Y[@]}"
+
+	log_test "IGMPv3 report $TEST_GROUP exclude -> allow"
+
+	v3cleanup $swp1 $TEST_GROUP
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.25.4

