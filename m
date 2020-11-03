Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1098A2A4CC3
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbgKCRYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:24:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728850AbgKCRYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:24:35 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ABEDC0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 09:24:34 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id c18so102749wme.2
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 09:24:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gOOQHtOX6w4d/nnhTN7xuIIArAAXX7jfcR/5MZf9CcQ=;
        b=MVxyWoYMT/dNrrNoy0pKOM7oUG4gcNl0f7D/EXoZgrUK7eMdDa3wkQNasvjtRxHlju
         O0zIVwVyE4N+SRFeN9Lie40vPtXDqLSrNkhgiMEJz7kpPXDznc3xKDsUsJpuXlBsKpow
         0ROekGogck6G+AaLClyE6EvuBQmj+A3TRKn5BnL2j+SHENh+/qK2L9Bw3pB4jXj4bhjR
         qjmHX55W+6CDuvdDrO6/xWYQ8bJWor57vWQudWp45oDDX+mwGGxQGD4Yht0vN6XdfFEx
         +32xRLunOOkxHblgEfFzDsPhn35PIp65Na+TJTvtB4khw2BhPH3OFaD1NM8tJelXgFV1
         rFxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gOOQHtOX6w4d/nnhTN7xuIIArAAXX7jfcR/5MZf9CcQ=;
        b=ZoukKep8S6xj0EhsABvQVXxT8yh+fysD3IOTy7EfrAtFzPY8tt5PdmpgP/W8eI+CRb
         Z7jb9VpR5+UFTAJ8AIIueQYjJJMjw/ATJrV9RZusvNwRBJMSlAIcvhqc8Dh7sMlOh0x+
         6tktytmdGS4V93LakePNmFSpVTdQJZzqevFWOg35mtufkMp5yeN90Mp2O4QUMBxNI+hk
         gVMHIcHN0QdgBHBXwPaj4GS8AY6a2gcgZV35lQLfUhIurszkSM0oZrXz7STL6waMvFy6
         UH9zyDAiXUwCxZg/6FVmpFyieHfK7uWIBFQDM7rDLWh7t8byEZMLlp65t1gOA1p2/vVH
         //Dw==
X-Gm-Message-State: AOAM533743rmG8WFmqPoNeWw+2JaChFjGrCL0Wy00TgbWpcEeb4AzG5Y
        Rqtn/9chmOszvpsMuWpe3bAW3bHP+WYF95OT
X-Google-Smtp-Source: ABdhPJwpIo7PahMGlPfdl8VLdYvwUQ68+oeROQ9Hgi5d4uO/c99jWh3GMWf9AmtP7f2aKwU3sdfpzQ==
X-Received: by 2002:a1c:2d8f:: with SMTP id t137mr237414wmt.26.1604424272680;
        Tue, 03 Nov 2020 09:24:32 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id a128sm2650795wmf.5.2020.11.03.09.24.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 09:24:32 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 15/16] selftests: net: bridge: add test for mldv2 exclude timeout
Date:   Tue,  3 Nov 2020 19:24:11 +0200
Message-Id: <20201103172412.1044840-16-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201103172412.1044840-1-razor@blackwall.org>
References: <20201103172412.1044840-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Test that when a group in exclude mode expires it changes mode to
include and the blocked entries are deleted.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 .../selftests/net/forwarding/bridge_mld.sh    | 48 ++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_mld.sh b/tools/testing/selftests/net/forwarding/bridge_mld.sh
index c498e51b8d2b..b34cf4c6ceba 100755
--- a/tools/testing/selftests/net/forwarding/bridge_mld.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_mld.sh
@@ -4,7 +4,7 @@
 ALL_TESTS="mldv2include_test mldv2inc_allow_test mldv2inc_is_include_test mldv2inc_is_exclude_test \
 	   mldv2inc_to_exclude_test mldv2exc_allow_test mldv2exc_is_include_test \
 	   mldv2exc_is_exclude_test mldv2exc_to_exclude_test mldv2inc_block_test \
-	   mldv2exc_block_test"
+	   mldv2exc_block_test mldv2exc_timeout_test"
 NUM_NETIFS=4
 CHECK_TC="yes"
 TEST_GROUP="ff02::cc"
@@ -473,6 +473,52 @@ mldv2exc_block_test()
 	mldv2cleanup $swp1
 }
 
+mldv2exc_timeout_test()
+{
+	RET=0
+	local X=("2001:db8:1::20" "2001:db8:1::30")
+
+	# GMI should be 3 seconds
+	ip link set dev br0 type bridge mcast_query_interval 100 mcast_query_response_interval 100
+
+	mldv2exclude_prepare $h1
+	ip link set dev br0 type bridge mcast_query_interval 500 mcast_query_response_interval 500
+	$MZ $h1 -c 1 $MZPKT_ALLOW2 -q
+	sleep 3
+	bridge -j -d -s mdb show dev br0 \
+		| jq -e ".[].mdb[] | \
+			 select(.grp == \"$TEST_GROUP\" and \
+				.source_list != null and .filter_mode == \"include\")" &>/dev/null
+	check_err $? "Wrong *,G entry filter mode"
+
+	bridge -j -d -s mdb show dev br0 \
+		| jq -e ".[].mdb[] | \
+			 select(.grp == \"$TEST_GROUP\" and \
+				.source_list != null and
+				.source_list[].address == \"2001:db8:1::1\")" &>/dev/null
+	check_fail $? "Wrong *,G entry source list, 2001:db8:1::1 entry still exists"
+	bridge -j -d -s mdb show dev br0 \
+		| jq -e ".[].mdb[] | \
+			 select(.grp == \"$TEST_GROUP\" and \
+				.source_list != null and
+				.source_list[].address == \"2001:db8:1::2\")" &>/dev/null
+	check_fail $? "Wrong *,G entry source list, 2001:db8:1::2 entry still exists"
+
+	brmcast_check_sg_entries "allow" "${X[@]}"
+
+	brmcast_check_sg_state 0 "${X[@]}"
+
+	brmcast_check_sg_fwding 1 "${X[@]}"
+	brmcast_check_sg_fwding 0 2001:db8:1::100
+
+	log_test "MLDv2 group $TEST_GROUP exclude timeout"
+
+	ip link set dev br0 type bridge mcast_query_interval 12500 \
+					mcast_query_response_interval 1000
+
+	mldv2cleanup $swp1
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.25.4

