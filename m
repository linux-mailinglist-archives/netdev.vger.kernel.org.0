Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753F02A4CC6
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728934AbgKCRYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:24:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728784AbgKCRY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:24:26 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EDFDC0617A6
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 09:24:26 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id d142so93657wmd.4
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 09:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7gEjJWV+umySqk07uezM2KFdZejL2mgBfGXLYK38GRc=;
        b=GP4dMhZcYmhWpTyvlGvIDAL0UgplapxDYCzG2iCazo6A8g63WABrTZIKgPppIWtYhG
         8tg6DZcImbEx++w1H84dkkOA7ipsckN5rxvQ542v0yfK31tw55eG3r0J7wNx1Yb/dAsn
         x/qSPyBjnoBRILCiNTntn7g0voKYSVSzcJtavqKUvDgqOnu567GPDS/P1mjP4+k59T3L
         L26pUCELcVr/Fl85ZqLidbFTQnz41cDM+wevPf3NmxaQvzQCWEpKYAd1RVlcw69FMCQz
         1yusJNvgMNDqkeWyj/3Y5KdN8VZk0cHUok5i+vRy6PfEeatfMC2Br9hIpqu6v2o+d1ar
         AogA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7gEjJWV+umySqk07uezM2KFdZejL2mgBfGXLYK38GRc=;
        b=qgtwLDH/H3xah4harPx7vsp19l9nYhlo6ekM5UHkDIOhRmpSOtsrX68K9x7E13FL0o
         /EdPgTurNxxqkzt7vR2qXrM/q9etpTrGgNP18NBRyI8rQf+eNPkSiY7z45Ty132L7NG1
         h1YQ15LJxBRgpTm2LOmSczSC/qdtHiRubfh1ZSebkYLITL4eNVSj94CoH4K2NYd2lG/1
         ZvoCabWkMsbXSJ79XFLOnWi+nJlDC7D2eghcr17t3OLX+bmm6yhyktVPwDF3LTcXcF3u
         rNaq7OOrLc2RqoQiAwhPqtkPE4G56yxQm039tQmMq1u9gi0QSV6upxcz8xpWNjTbfBYX
         jBUg==
X-Gm-Message-State: AOAM5323Tql3PAn+hre5fDi/6Wm6e8cGTe+xxVc9IVEVjMdx0dYB9l1J
        rQBQ/cZpwqPSO2MegSVQ7tq0M42D7pkpMuMX
X-Google-Smtp-Source: ABdhPJx/Jz0lEYHY45Eur9Vbf73REK77AG+hhiaxjNORvzrPDTNtQtDHNvrOYSpXZENVSmAjIaib/g==
X-Received: by 2002:a1c:c912:: with SMTP id f18mr214386wmb.150.1604424264538;
        Tue, 03 Nov 2020 09:24:24 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id a128sm2650795wmf.5.2020.11.03.09.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 09:24:24 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 07/16] selftests: net: bridge: add test for mldv2 inc -> is_exclude report
Date:   Tue,  3 Nov 2020 19:24:03 +0200
Message-Id: <20201103172412.1044840-8-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201103172412.1044840-1-razor@blackwall.org>
References: <20201103172412.1044840-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

The test checks for the following case:
   Router State  Report Received  New Router State     Actions
   INCLUDE (A)       IS_EX (B)     EXCLUDE (A*B, B-A)  (B-A)=0
                                                       Delete (A-B)
                                                       Filter Timer=MALI

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 .../selftests/net/forwarding/bridge_mld.sh    | 54 ++++++++++++++++++-
 1 file changed, 53 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_mld.sh b/tools/testing/selftests/net/forwarding/bridge_mld.sh
index a93bf6fa6caa..ddef8699be7d 100755
--- a/tools/testing/selftests/net/forwarding/bridge_mld.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_mld.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
-ALL_TESTS="mldv2include_test mldv2inc_allow_test mldv2inc_is_include_test"
+ALL_TESTS="mldv2include_test mldv2inc_allow_test mldv2inc_is_include_test mldv2inc_is_exclude_test"
 NUM_NETIFS=4
 CHECK_TC="yes"
 TEST_GROUP="ff02::cc"
@@ -25,6 +25,12 @@ MZPKT_ALLOW="33:33:00:00:00:01:fe:54:00:04:5e:ba:86:dd:60:0a:2d:ae:00:54:00:01:f
 02:00:00:00:00:8f:00:8a:ac:00:00:00:01:05:00:00:03:ff:02:00:00:00:00:00:00:00:00:00:00:00:00:\
 00:cc:20:01:0d:b8:00:01:00:00:00:00:00:00:00:00:00:10:20:01:0d:b8:00:01:00:00:00:00:00:00:00:\
 00:00:11:20:01:0d:b8:00:01:00:00:00:00:00:00:00:00:00:12"
+# MLDv2 is_ex report: grp ff02::cc is_exclude 2001:db8:1::1,2001:db8:1::2,2001:db8:1::20,2001:db8:1::21
+MZPKT_IS_EXC="33:33:00:00:00:01:fe:54:00:04:5e:ba:86:dd:60:0a:2d:ae:00:64:00:01:fe:80:00:00:00:\
+00:00:00:fc:54:00:ff:fe:04:5e:ba:ff:02:00:00:00:00:00:00:00:00:00:00:00:00:00:01:3a:00:05:02:00:\
+00:00:00:8f:00:5f:d0:00:00:00:01:02:00:00:04:ff:02:00:00:00:00:00:00:00:00:00:00:00:00:00:cc:20:\
+01:0d:b8:00:01:00:00:00:00:00:00:00:00:00:01:20:01:0d:b8:00:01:00:00:00:00:00:00:00:00:00:02:20:\
+01:0d:b8:00:01:00:00:00:00:00:00:00:00:00:20:20:01:0d:b8:00:01:00:00:00:00:00:00:00:00:00:21"
 
 source lib.sh
 
@@ -123,6 +129,38 @@ mldv2include_prepare()
 	brmcast_check_sg_entries "is_include" "${X[@]}"
 }
 
+mldv2exclude_prepare()
+{
+	local host1_if=$1
+	local mac=$2
+	local group=$3
+	local pkt=$4
+	local X=("2001:db8:1::1" "2001:db8:1::2")
+	local Y=("2001:db8:1::20" "2001:db8:1::21")
+
+	mldv2include_prepare $h1
+
+	$MZ $host1_if -c 1 $MZPKT_IS_EXC -q
+	sleep 1
+	bridge -j -d -s mdb show dev br0 \
+		| jq -e ".[].mdb[] | \
+			 select(.grp == \"$TEST_GROUP\" and \
+			 .source_list != null and .filter_mode == \"exclude\")" &>/dev/null
+	check_err $? "Wrong *,G entry filter mode"
+
+	brmcast_check_sg_entries "is_exclude" "${X[@]}" "${Y[@]}"
+
+	brmcast_check_sg_state 0 "${X[@]}"
+	brmcast_check_sg_state 1 "${Y[@]}"
+
+	bridge -j -d -s mdb show dev br0 \
+		| jq -e ".[].mdb[] | \
+			 select(.grp == \"$TEST_GROUP\" and \
+				.source_list != null and
+				.source_list[].address == \"2001:db8:1::3\")" &>/dev/null
+	check_fail $? "Wrong *,G entry source list, 2001:db8:1::3 entry still exists"
+}
+
 mldv2cleanup()
 {
 	local port=$1
@@ -190,6 +228,20 @@ mldv2inc_is_include_test()
 	mldv2cleanup $swp1
 }
 
+mldv2inc_is_exclude_test()
+{
+	RET=0
+
+	mldv2exclude_prepare $h1
+
+	brmcast_check_sg_fwding 1 "${X[@]}" 2001:db8:1::100
+	brmcast_check_sg_fwding 0 "${Y[@]}"
+
+	log_test "MLDv2 report $TEST_GROUP include -> is_exclude"
+
+	mldv2cleanup $swp1
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.25.4

