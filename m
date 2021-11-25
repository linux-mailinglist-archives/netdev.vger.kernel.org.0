Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF24A45DC13
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 15:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355670AbhKYOOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 09:14:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352322AbhKYOMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 09:12:37 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA50C0613D7
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 06:09:25 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id t5so26452187edd.0
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 06:09:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jDgbRWbHqWtsaVeh+4rNPIsENfs+qLEuUZMgVdJDcfw=;
        b=saZZVnYLTtWITiQYzBL+L1wPU01pMugwFRwS0HyBsP1zl2v+21xj2jCBo4f/PbOJXa
         qJNMR9Q4MJiXFwP7jjQdciNVRlQ5YX9ZS1ynXMM7OawOtAja/QjbjEhnCDXnO4mMsXSY
         4evNrOuFgOc3cneku9JItIszBnxMDUcjsrva/RQb2maiCNZYrkwN+eZJIiU0vkPxgEDj
         meyLFRHSpaPGHzq3VfPDxGJghLKmK8yLzWZADTFt+p0wmFqQDpIKIS1Wq7bQbwAWbS6W
         zSiq3sL4EQUyqy/LkujM4pW4aOrp6tO+EqGCeh3F54KEajRU56pg5gaIaettRnoVi5it
         aeQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jDgbRWbHqWtsaVeh+4rNPIsENfs+qLEuUZMgVdJDcfw=;
        b=ld2ZwHbznVzp3ZZ+3/avUiRw1Cu9VIK+z35C9dojdh3VoIEUITNYSeF1YKzpbgNf2C
         5rpSELjEbanASRVZ52XbDr0Ji9J43JbG22Ik+KQuEOmOu2bm+eP0LYGsR2wWvs1GC7zW
         kCcg2AxubYGYUvmrm/YZ+JlAdpJHX0j+QB8aLA0c4wqk2dBvKIzHrrjx2Y2tDnE4sh97
         oXY1H9DSfrcsWuMd/65TvRvYtDQkHTPfGskEKZz/kZJiWjaj9vRCflRO4EyL0hknRU6r
         Lh6ut1CCZFnOjUy/RvZOwKUs3f6sX8ogqRMUKfjRhtGf1TzYqxYpa1gLGcG74JzCJ5i0
         77EQ==
X-Gm-Message-State: AOAM530T0KZHCqGOvZ4VLOK8qcCzCozlbO93emvtReuoGOSUwM0EfoNl
        b5siOBFEhBiI+DgfbXfB4+wQBz7yC0rYfIfs
X-Google-Smtp-Source: ABdhPJzS3zkpWwrd4BGX0vjMO9TWZvqGd1SYTeFWh8DZbwcd2s91LHv1BUqrr6YYd2MK1GXTyWWj2g==
X-Received: by 2002:a17:907:1c15:: with SMTP id nc21mr32003003ejc.510.1637849363872;
        Thu, 25 Nov 2021 06:09:23 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id sc7sm1889863ejc.50.2021.11.25.06.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 06:09:23 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, ivecera@redhat.com,
        bridge@lists.linux-foundation.org, davem@davemloft.net,
        kuba@kernel.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 05/10] selftests: net: bridge: add vlan mcast_startup_query_count/interval tests
Date:   Thu, 25 Nov 2021 16:08:53 +0200
Message-Id: <20211125140858.3639139-6-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211125140858.3639139-1-razor@blackwall.org>
References: <20211125140858.3639139-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add tests which change the new per-vlan startup query count/interval
options and verify the proper number of queries are sent in the expected
interval.

TEST: Vlan mcast_startup_query_interval global option default value   [ OK ]
TEST: Vlan mcast_startup_query_count global option default value    [ OK ]
TEST: Vlan 10 mcast_startup_query_interval option changed to 100    [ OK ]
TEST: Vlan 10 mcast_startup_query_count option changed to 3         [ OK ]

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 .../net/forwarding/bridge_vlan_mcast.sh       | 42 ++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh b/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh
index 85146c998316..0070d8292569 100755
--- a/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh
@@ -1,7 +1,8 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
-ALL_TESTS="vlmc_control_test vlmc_querier_test vlmc_igmp_mld_version_test vlmc_last_member_test"
+ALL_TESTS="vlmc_control_test vlmc_querier_test vlmc_igmp_mld_version_test \
+	   vlmc_last_member_test vlmc_startup_query_test"
 NUM_NETIFS=4
 CHECK_TC="yes"
 TEST_GROUP="239.10.10.10"
@@ -318,6 +319,45 @@ vlmc_last_member_test()
 	bridge vlan global set vid 10 dev br0 mcast_snooping 1 mcast_last_member_interval 100
 }
 
+vlmc_startup_query_test()
+{
+	RET=0
+	local goutput=`bridge -j vlan global show`
+	echo -n $goutput |
+		jq -e ".[].vlans[] | select(.vlan == 10)" &>/dev/null
+	check_err $? "Could not find vlan 10's global options"
+
+	echo -n $goutput |
+		jq -e ".[].vlans[] | select(.vlan == 10 and \
+					    .mcast_startup_query_interval == 3125) " &>/dev/null
+	check_err $? "Wrong default mcast_startup_query_interval global vlan option value"
+	log_test "Vlan mcast_startup_query_interval global option default value"
+
+	RET=0
+	echo -n $goutput |
+		jq -e ".[].vlans[] | select(.vlan == 10 and \
+					    .mcast_startup_query_count == 2) " &>/dev/null
+	check_err $? "Wrong default mcast_startup_query_count global vlan option value"
+	log_test "Vlan mcast_startup_query_count global option default value"
+
+	RET=0
+	bridge vlan global set vid 10 dev br0 mcast_snooping 1 mcast_startup_query_interval 100
+	check_err $? "Could not set mcast_startup_query_interval in vlan 10"
+	vlmc_check_query igmp 2 $swp1 2 3
+	check_err $? "Wrong number of tagged IGMPv2 general queries sent"
+	log_test "Vlan 10 mcast_startup_query_interval option changed to 100"
+
+	RET=0
+	bridge vlan global set vid 10 dev br0 mcast_snooping 1 mcast_startup_query_count 3
+	check_err $? "Could not set mcast_startup_query_count in vlan 10"
+	vlmc_check_query igmp 2 $swp1 3 4
+	check_err $? "Wrong number of tagged IGMPv2 general queries sent"
+	log_test "Vlan 10 mcast_startup_query_count option changed to 3"
+
+	bridge vlan global set vid 10 dev br0 mcast_snooping 1 mcast_startup_query_interval 3125
+	bridge vlan global set vid 10 dev br0 mcast_snooping 1 mcast_startup_query_count 2
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.31.1

