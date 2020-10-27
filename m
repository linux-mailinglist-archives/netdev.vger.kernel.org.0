Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143A329C80B
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 20:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1821237AbgJ0TAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 15:00:55 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:32969 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S371358AbgJ0TAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 15:00:13 -0400
Received: by mail-wr1-f68.google.com with SMTP id b8so3160751wrn.0
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 12:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W8178pAv6uDZvuBR8Wd4aVbByEM9iWD9JrBfg6O4nCE=;
        b=ZLJj6Z3orbJ+wULGft+hxYNzeLu0dElfr6eP44nItmYtg2ZpXuVRpD4ikfpOk5Hrr+
         vJOPhyXUuR7P0hvBiyIBcWQz0c36R8pjYFZ5unQM6APXma7LMwiJoI1nS+Ixnh8hlm2j
         p9DSk4Tqno9xp4/X2G5I9ocH6Oi2+sgYlgMLfUB6UO5ldL5Qm5Q0YS63U3ASShTdi2hA
         cudHgyLzAs/Z0YbECGOV5XO767qC4L1TMrjSUIKxDO7ooJCdGwy1J8tC9NkZMjU86TSG
         okweKJ+iu2hdtmuq3rN71PX8W27PdtXDswETnO5Gm+0XKnp33MrowprW1bUgDJ/2KV0x
         67pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W8178pAv6uDZvuBR8Wd4aVbByEM9iWD9JrBfg6O4nCE=;
        b=FOHtYy4RrtAl4w6NIl/OPqi6uMvia1FbXq020IE27INJUJJqtDenQiKlNMAQCY+EOz
         rom0MlUNHKfyjCXv4UoDm13ca1WhsBl2ZRRJv4EYzW6aYAB58Giu/0etmMXlMSeC12N0
         vC5r32bEd2WmdWYl0R3b+l7iC01jqTyJN7xtOhXBS0ZjuVN48mlsGY/H++nnXPIz0SYs
         76oCopX4gakCYbNCm9NxwNAhNnzo8IkOaLyTyK+tL2Zs5wWBJ+pm7K2q/XRWb8BZVNGE
         gS5PQxmi/tKSoa0RrVj4RW7cXuwaadT6y+/FfjVgfSYaQYThch69g9KWh2FEjaLAqlbF
         A2/A==
X-Gm-Message-State: AOAM533te4X4Yu3v0RVzicFRu1cKDSZEwh0LDq0sf8wqehUpJV2pEn07
        IGrUnOnVdT766BA930XaRfJIFpv/xhlWpC9h
X-Google-Smtp-Source: ABdhPJwlp72VfrmJW+ImKhnPmyj3OZMtZSFRGMIIX+1N2LfBXruPyt+pw5NIMJyevtxNZGPofAAcJg==
X-Received: by 2002:adf:bc4a:: with SMTP id a10mr4513195wrh.253.1603825210774;
        Tue, 27 Oct 2020 12:00:10 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x6sm3219803wmb.17.2020.10.27.12.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 12:00:10 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 04/16] selftests: net: bridge: igmp: add IGMPv3 entries' state helpers
Date:   Tue, 27 Oct 2020 20:59:22 +0200
Message-Id: <20201027185934.227040-5-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201027185934.227040-1-razor@blackwall.org>
References: <20201027185934.227040-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add helpers which will be used in subsequent tests, they are:
 - check_sg_entries: check for proper source list and S,G entry
   existence
 - check_sg_fwding: check for proper traffic forwarding/blocking
 - check_sg_state: check for proper blocked/forwarding entry state

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 .../selftests/net/forwarding/bridge_igmp.sh   | 67 +++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/bridge_igmp.sh b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
index 5562aef14c0a..19c1f46d1151 100755
--- a/tools/testing/selftests/net/forwarding/bridge_igmp.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
@@ -143,6 +143,73 @@ v2reportleave_test()
 	log_test "IGMPv2 leave $TEST_GROUP"
 }
 
+check_sg_entries()
+{
+	local report=$1; shift
+	local slist=("$@")
+	local sarg=""
+
+	for src in "${slist[@]}"; do
+		sarg="${sarg} and .source_list[].address == \"$src\""
+	done
+	bridge -j -d -s mdb show dev br0 \
+		| jq -e ".[].mdb[] | \
+			 select(.grp == \"$TEST_GROUP\" and .source_list != null $sarg)" &>/dev/null
+	check_err $? "Wrong *,G entry source list after $report report"
+
+	for sgent in "${slist[@]}"; do
+		bridge -j -d -s mdb show dev br0 \
+			| jq -e ".[].mdb[] | \
+				 select(.grp == \"$TEST_GROUP\" and .src == \"$sgent\")" &>/dev/null
+		check_err $? "Missing S,G entry ($sgent, $TEST_GROUP)"
+	done
+}
+
+check_sg_fwding()
+{
+	local should_fwd=$1; shift
+	local sources=("$@")
+
+	for src in "${sources[@]}"; do
+		local retval=0
+
+		mcast_packet_test $TEST_GROUP_MAC $src $TEST_GROUP $h2 $h1
+		retval=$?
+		if [ $should_fwd -eq 1 ]; then
+			check_fail $retval "Didn't forward traffic from S,G ($src, $TEST_GROUP)"
+		else
+			check_err $retval "Forwarded traffic for blocked S,G ($src, $TEST_GROUP)"
+		fi
+	done
+}
+
+check_sg_state()
+{
+	local is_blocked=$1; shift
+	local sources=("$@")
+	local should_fail=1
+
+	if [ $is_blocked -eq 1 ]; then
+		should_fail=0
+	fi
+
+	for src in "${sources[@]}"; do
+		bridge -j -d -s mdb show dev br0 \
+			| jq -e ".[].mdb[] | \
+				 select(.grp == \"$TEST_GROUP\" and .source_list != null) |
+				 .source_list[] |
+				 select(.address == \"$src\") |
+				 select(.timer == \"0.00\")" &>/dev/null
+		check_err_fail $should_fail $? "Entry $src has zero timer"
+
+		bridge -j -d -s mdb show dev br0 \
+			| jq -e ".[].mdb[] | \
+				 select(.grp == \"$TEST_GROUP\" and .src == \"$src\" and \
+				 .flags[] == \"blocked\")" &>/dev/null
+		check_err_fail $should_fail $? "Entry $src has blocked flag"
+	done
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.25.4

