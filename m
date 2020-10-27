Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEA829C813
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 20:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829214AbgJ0TBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 15:01:23 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:32985 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S371381AbgJ0TAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 15:00:22 -0400
Received: by mail-wr1-f66.google.com with SMTP id b8so3161224wrn.0
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 12:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eDTIDQ54v3hNLISIhSoICwr0iuL2p884XIbh/Sf6EKU=;
        b=KmGEcWTDbqnHdqrNBpRKUInzMHv+8ZUJruW6v/H03R6LZoawPwpuXxsUUwwKPR3VGU
         UUporxwy+TgwVoLAykrTEBArjA7iV1HgFfyn/prCeDWc9UmrDG4EBWJj+mjLOMk8Uvjx
         fsELqDbhoyJS9kMBHmRUAXMaSHAhorADYmfd6MEgq+ApxowwjXX/PO+UrwzGkitn6xzL
         40hLEpBeuUvXzmoYorTksBtVBwie0VyVXCodvAzACqm+0wkRxWC6C5kDpr3qnsfQyH93
         DtBIuMW60mB/PbKoTw1gpVefxMtCp8pd947xJ8ccuOwvbHy2FpyRlNoyDx7vQVd3aKhZ
         QQRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eDTIDQ54v3hNLISIhSoICwr0iuL2p884XIbh/Sf6EKU=;
        b=NgOYK5ibtmeomSqkGA89HKeIt696eVVExWCVMOr9lmJuwgJC2CazXvTIKP7Ji08Z2T
         o1goHxgsgZh2boYM4WdwnzwOwX1CLiWPDvtjw3xYysYF9zZT1eJjQbinn2KSjX4lWljD
         tYMuTsSpyN4nSTpwyvDynVIwoqMYftGKkRlyIe+DXG96ETSg/9wuN0cNg5Ppto/JIe/6
         NsNXxowA+URilOkTzClZBnO9B9HYPOzxE6UTxHA3HgNPD9PlkB3J6Sy+G453ziR7Bwgx
         904MUijFlTcWElDPPV+BsjdzGTq2yixfZIBQV8wmRlwAn0ToQ9Ur19SLZgvS99NaNXig
         8nwA==
X-Gm-Message-State: AOAM530gVyZ5bWcbsD5DMiXxtOLjYhGbitsAall8AxNFZX7NoU3mii7s
        5RRTA/6QOtlbK1tEEB/4mkmKFqXoTt0AzuNd
X-Google-Smtp-Source: ABdhPJzVoVoeLcMMm7ezUBF93U4f4/e8VwW037i0ic+ZzNql6LkMaAp+ueBwletke7z9/jks/K3mOA==
X-Received: by 2002:adf:ce8a:: with SMTP id r10mr4717292wrn.188.1603825219281;
        Tue, 27 Oct 2020 12:00:19 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x6sm3219803wmb.17.2020.10.27.12.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 12:00:18 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 11/16] selftests: net: bridge: add test for igmpv3 exc -> is_exclude report
Date:   Tue, 27 Oct 2020 20:59:29 +0200
Message-Id: <20201027185934.227040-12-razor@blackwall.org>
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
   EXCLUDE (X,Y)  IS_EX (A)     EXCLUDE (A-Y,Y*A)        (A-X-Y)=GMI
                                                         Delete (X-A)
                                                         Delete (Y-A)
                                                         Group Timer=GMI

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 .../selftests/net/forwarding/bridge_igmp.sh   | 28 ++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_igmp.sh b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
index b2b0f7d7e860..91b0b26428f6 100755
--- a/tools/testing/selftests/net/forwarding/bridge_igmp.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
@@ -2,7 +2,8 @@
 # SPDX-License-Identifier: GPL-2.0
 
 ALL_TESTS="v2reportleave_test v3include_test v3inc_allow_test v3inc_is_include_test \
-	   v3inc_is_exclude_test v3inc_to_exclude_test v3exc_allow_test v3exc_is_include_test"
+	   v3inc_is_exclude_test v3inc_to_exclude_test v3exc_allow_test v3exc_is_include_test \
+	   v3exc_is_exclude_test"
 NUM_NETIFS=4
 CHECK_TC="yes"
 TEST_GROUP="239.10.10.10"
@@ -23,6 +24,8 @@ MZPKT_ALLOW="22:00:99:c3:00:00:00:01:05:00:00:03:ef:0a:0a:0a:c0:00:02:0a:c0:00:0
 MZPKT_ALLOW2="22:00:5b:b4:00:00:00:01:05:00:00:02:ef:0a:0a:0a:c0:00:02:14:c0:00:02:1e"
 # IGMPv3 is_ex report: grp 239.10.10.10 is_exclude 192.0.2.1,192.0.2.2,192.0.2.20,192.0.2.21
 MZPKT_IS_EXC="22:00:da:b6:00:00:00:01:02:00:00:04:ef:0a:0a:0a:c0:00:02:01:c0:00:02:02:c0:00:02:14:c0:00:02:15"
+# IGMPv3 is_ex report: grp 239.10.10.10 is_exclude 192.0.2.20,192.0.2.30
+MZPKT_IS_EXC2="22:00:5e:b4:00:00:00:01:02:00:00:02:ef:0a:0a:0a:c0:00:02:14:c0:00:02:1e"
 # IGMPv3 to_ex report: grp 239.10.10.10 to_exclude 192.0.2.1,192.0.2.20,192.0.2.30
 MZPKT_TO_EXC="22:00:9a:b1:00:00:00:01:04:00:00:03:ef:0a:0a:0a:c0:00:02:01:c0:00:02:14:c0:00:02:1e"
 
@@ -461,6 +464,29 @@ v3exc_is_include_test()
 	v3cleanup $swp1 $TEST_GROUP
 }
 
+v3exc_is_exclude_test()
+{
+	RET=0
+	local X=("192.0.2.30")
+	local Y=("192.0.2.20")
+
+	v3exclude_prepare $h1 $ALL_MAC $ALL_GROUP
+
+	$MZ $h1 -c 1 -b $ALL_MAC -B $ALL_GROUP -t ip "proto=2,p=$MZPKT_IS_EXC2" -q
+	sleep 1
+	check_sg_entries "is_exclude" "${X[@]}" "${Y[@]}"
+
+	check_sg_state 0 "${X[@]}"
+	check_sg_state 1 "${Y[@]}"
+
+	check_sg_fwding 1 "${X[@]}" 192.0.2.100
+	check_sg_fwding 0 "${Y[@]}"
+
+	log_test "IGMPv3 report $TEST_GROUP exclude -> is_exclude"
+
+	v3cleanup $swp1 $TEST_GROUP
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.25.4

