Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF402A4CC1
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728877AbgKCRYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:24:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728833AbgKCRYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:24:32 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43620C0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 09:24:32 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id p22so99818wmg.3
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 09:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bc4VDKLFfRtDvy2e5Zsnlq8PlNzZNU+VRXlP4XcvGWU=;
        b=X4427bX6KLsZipwexz/bDyeMNMiQP7dxD1gBoGluxdYi4uUpRPahjavU8I2OPUbaLU
         CYNGUaBqR7oEu0AEqgLZgAh4ONIL3jiT+pCEO/YaLn88SBrNNr07dMHFEDowxZtTUcDs
         VmWswbOVWjzDaZmSaHhwUK+r5MFFv/n9AtV/dRWF+wnlEb8QRvM6GuEy6ZjMOf+UKqBX
         VW+uhzXEijsYEvQ+U4HPtFcfjEOeQHAi39ArEGi88eZEQLxwT1gaNIYeFnfbhm4KHGUa
         gT4AaKo38jLrPjdeGslVvnd56JcTXap7LpOvbh9GS8C6FhxfKWE/lqud+3nAF7Rg2Vdj
         Qq/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bc4VDKLFfRtDvy2e5Zsnlq8PlNzZNU+VRXlP4XcvGWU=;
        b=JYY7IF5RuDlleA6YV8v2IOVXgeD5GPiY1w6QAkaL/ttYjQl4DNzX0fzKkBKuEC0FrX
         7XDwen3QxIn4Lh971LJoQJHXE0ebWpYONSxMg8A05OJQsmYiyLu3BGYbHqpM7NzTGQVa
         MV2PPsNavzB9N5ZFvhp8YGHHaDzv4zOODwkKQh2o9FCI93dZYt3cowNrtXA4ynWT4kme
         iiQQ55V7oke4sClr9zItwSWb/etQ8zK3Wm/e6QraqpHCm2aRztDMw9iEeVsJemIjJa/P
         /+7aFUOTvWRxFn/qVyWCaXA2DRWnjyv4Vjplo0SUEnm2euTd7WUOBW7UtAdu/7+TmHty
         Gi3Q==
X-Gm-Message-State: AOAM530g3xwGTnVPcgOuTp1QXVp6MB+XoAPLMFtP/wn37FXO3bh7xgWl
        fKEqXRrynxQZTikgBuWBmGJOb/iln+K9qD69
X-Google-Smtp-Source: ABdhPJxFu4be/8zPQYWMfSKDaM79AsTb/5bF87GhkTA9eWGRnR31eTjQ3S1PzIeG+yZKSzv0Kj9+nA==
X-Received: by 2002:a1c:3846:: with SMTP id f67mr200371wma.33.1604424270730;
        Tue, 03 Nov 2020 09:24:30 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id a128sm2650795wmf.5.2020.11.03.09.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 09:24:30 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 13/16] selftests: net: bridge: add test for mldv2 inc -> block report
Date:   Tue,  3 Nov 2020 19:24:09 +0200
Message-Id: <20201103172412.1044840-14-razor@blackwall.org>
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
   INCLUDE (A)     BLOCK (B)      INCLUDE (A)          Send Q(MA,A*B)

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 .../selftests/net/forwarding/bridge_mld.sh    | 37 ++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_mld.sh b/tools/testing/selftests/net/forwarding/bridge_mld.sh
index 024fa22fa3c2..a3c405b2fd6f 100755
--- a/tools/testing/selftests/net/forwarding/bridge_mld.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_mld.sh
@@ -3,7 +3,7 @@
 
 ALL_TESTS="mldv2include_test mldv2inc_allow_test mldv2inc_is_include_test mldv2inc_is_exclude_test \
 	   mldv2inc_to_exclude_test mldv2exc_allow_test mldv2exc_is_include_test \
-	   mldv2exc_is_exclude_test mldv2exc_to_exclude_test"
+	   mldv2exc_is_exclude_test mldv2exc_to_exclude_test mldv2inc_block_test"
 NUM_NETIFS=4
 CHECK_TC="yes"
 TEST_GROUP="ff02::cc"
@@ -54,6 +54,12 @@ MZPKT_TO_EXC="33:33:00:00:00:01:fe:54:00:04:5e:ba:86:dd:60:0a:2d:ae:00:54:00:01:
 00:00:00:8f:00:8b:8e:00:00:00:01:04:00:00:03:ff:02:00:00:00:00:00:00:00:00:00:00:00:00:00:cc:20:\
 01:0d:b8:00:01:00:00:00:00:00:00:00:00:00:01:20:01:0d:b8:00:01:00:00:00:00:00:00:00:00:00:20:20:\
 01:0d:b8:00:01:00:00:00:00:00:00:00:00:00:30"
+# MLDv2 block report: grp ff02::cc block 2001:db8:1::1,2001:db8:1::20,2001:db8:1::30
+MZPKT_BLOCK="33:33:00:00:00:01:fe:54:00:04:5e:ba:86:dd:60:0a:2d:ae:00:54:00:01:fe:80:00:00:00:00:\
+00:00:fc:54:00:ff:fe:04:5e:ba:ff:02:00:00:00:00:00:00:00:00:00:00:00:00:00:01:3a:00:05:02:00:00:\
+00:00:8f:00:89:8e:00:00:00:01:06:00:00:03:ff:02:00:00:00:00:00:00:00:00:00:00:00:00:00:cc:20:01:\
+0d:b8:00:01:00:00:00:00:00:00:00:00:00:01:20:01:0d:b8:00:01:00:00:00:00:00:00:00:00:00:20:20:01:\
+0d:b8:00:01:00:00:00:00:00:00:00:00:00:30"
 
 source lib.sh
 
@@ -409,6 +415,35 @@ mldv2exc_to_exclude_test()
 	mldv2cleanup $swp1
 }
 
+mldv2inc_block_test()
+{
+	RET=0
+	local X=("2001:db8:1::2" "2001:db8:1::3")
+
+	mldv2include_prepare $h1
+
+	$MZ $h1 -c 1 $MZPKT_BLOCK -q
+	# make sure the lowered timers have expired (by default 2 seconds)
+	sleep 3
+	brmcast_check_sg_entries "block" "${X[@]}"
+
+	brmcast_check_sg_state 0 "${X[@]}"
+
+	bridge -j -d -s mdb show dev br0 \
+		| jq -e ".[].mdb[] | \
+			 select(.grp == \"$TEST_GROUP\" and \
+				.source_list != null and
+				.source_list[].address == \"2001:db8:1::1\")" &>/dev/null
+	check_fail $? "Wrong *,G entry source list, 2001:db8:1::1 entry still exists"
+
+	brmcast_check_sg_fwding 1 "${X[@]}"
+	brmcast_check_sg_fwding 0 2001:db8:1::100
+
+	log_test "MLDv2 report $TEST_GROUP include -> block"
+
+	mldv2cleanup $swp1
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.25.4

