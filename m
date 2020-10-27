Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B941329C811
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 20:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S371418AbgJ0TBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 15:01:19 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35482 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S371363AbgJ0TAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 15:00:17 -0400
Received: by mail-wr1-f68.google.com with SMTP id n15so3145922wrq.2
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 12:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eYSlfHy2do06FrpDILVFhyJwEe8Ff8TXqbs1TkvRaIw=;
        b=nocgw/xfVwwoDjAjQ31KC5TBrwADhL2dJhYVpsDe6nRPDw0ZKWhyVCyeoBrtmHldN8
         TEBuh6LUFvtpb09qZwBq3md71I2+FEkmdJE8hPw472nYt8eGabksZHC2oeY+4oIO2n/T
         UOhBp/YDKfmkGF2k3zsI76rgZ+p2J/8aeP+s6t1vvyKmyMcDXkB2NpaoDsbKILs2ikpF
         dmz3rSEm4mKFFhbFhwU2L8TRgGL+1iuQBOhKXstRPyfkSQ/CNcoWeBwPcg2svEW01EGa
         RLqFRHVr469yOGlaHMgGM8+nQ7i5i2E3IuQNcP6kwDO3vRr9W2aHjTwRltZku4D+aTIA
         yOSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eYSlfHy2do06FrpDILVFhyJwEe8Ff8TXqbs1TkvRaIw=;
        b=gqMSywMGJj5BjZ9xoq2YsQaw9GSTltkguYbOp2wbltQl9Hxu/maFKL7PxG+qRyFR8u
         +sgOnD8oWOrNdmuE6x/o3TGxql5v9X8E5u8jWcicuchjIxO1S0UUG6i6gFjfiXXyh/vJ
         90h5ArzMQr8+bJVI7+exiOo/k6kgjh4hVOga14roiUenj6jJWSOLWAlDn9ApjLUe8+aP
         8fvyiNlONum4nxBMrujTYfg8xmqPckH5eOJCwMHzsxmpahuCqsaUHJyVX0Wh60K2eYHV
         BxK35W+sY5LQuws3Uay861DjfnHP8gg2HGI4uBwXbUEKxVezmcw6LceQhX5sWLf+r1kq
         bM8Q==
X-Gm-Message-State: AOAM5339X8JWDaV5zL2NUKOREpaH8M7c5a9C+/eVfJuSSoQmDpgZH80m
        GxsoicwtgTLbaCofZBwZcp9JBAyZoEONor+s
X-Google-Smtp-Source: ABdhPJxIQAZSVVyNAoP6ud8NkOxkxwUErE0BTsdVKLdYGr/l1bOhmh/adiFe/AJbCpSkUa4M+suhJg==
X-Received: by 2002:adf:fe8b:: with SMTP id l11mr4665168wrr.9.1603825214566;
        Tue, 27 Oct 2020 12:00:14 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x6sm3219803wmb.17.2020.10.27.12.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 12:00:14 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 07/16] selftests: net: bridge: add test for igmpv3 inc -> is_exclude report
Date:   Tue, 27 Oct 2020 20:59:25 +0200
Message-Id: <20201027185934.227040-8-razor@blackwall.org>
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
   state          report        result                 action
  INCLUDE (A)    IS_EX (B)     EXCLUDE (A*B,B-A)      (B-A)=0
                                                      Delete (A-B)
                                                      Group Timer=GMI

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 .../selftests/net/forwarding/bridge_igmp.sh   | 41 ++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_igmp.sh b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
index added5c69e8b..34d2c4370fa6 100755
--- a/tools/testing/selftests/net/forwarding/bridge_igmp.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
@@ -1,7 +1,8 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
-ALL_TESTS="v2reportleave_test v3include_test v3inc_allow_test v3inc_is_include_test"
+ALL_TESTS="v2reportleave_test v3include_test v3inc_allow_test v3inc_is_include_test \
+	   v3inc_is_exclude_test"
 NUM_NETIFS=4
 CHECK_TC="yes"
 TEST_GROUP="239.10.10.10"
@@ -16,6 +17,8 @@ MZPKT_IS_INC="22:00:9d:de:00:00:00:01:01:00:00:03:ef:0a:0a:0a:c0:00:02:01:c0:00:
 MZPKT_IS_INC2="22:00:9d:c3:00:00:00:01:01:00:00:03:ef:0a:0a:0a:c0:00:02:0a:c0:00:02:0b:c0:00:02:0c"
 # IGMPv3 allow report: grp 239.10.10.10 allow 192.0.2.10,192.0.2.11,192.0.2.12
 MZPKT_ALLOW="22:00:99:c3:00:00:00:01:05:00:00:03:ef:0a:0a:0a:c0:00:02:0a:c0:00:02:0b:c0:00:02:0c"
+# IGMPv3 is_ex report: grp 239.10.10.10 is_exclude 192.0.2.1,192.0.2.2,192.0.2.20,192.0.2.21
+MZPKT_IS_EXC="22:00:da:b6:00:00:00:01:02:00:00:04:ef:0a:0a:0a:c0:00:02:01:c0:00:02:02:c0:00:02:14:c0:00:02:15"
 
 source lib.sh
 
@@ -313,6 +316,42 @@ v3inc_is_include_test()
 	v3cleanup $swp1 $TEST_GROUP
 }
 
+v3inc_is_exclude_test()
+{
+	RET=0
+	local X=("192.0.2.1" "192.0.2.2")
+	local Y=("192.0.2.20" "192.0.2.21")
+
+	v3include_prepare $h1 $ALL_MAC $ALL_GROUP
+
+	$MZ $h1 -c 1 -b $ALL_MAC -B $ALL_GROUP -t ip "proto=2,p=$MZPKT_IS_EXC" -q
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
+
+	check_sg_fwding 1 "${X[@]}" 192.0.2.100
+	check_sg_fwding 0 "${Y[@]}"
+
+	log_test "IGMPv3 report $TEST_GROUP include -> is_exclude"
+
+	v3cleanup $swp1 $TEST_GROUP
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.25.4

