Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4DBF45DC15
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 15:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355680AbhKYOOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 09:14:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354702AbhKYOMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 09:12:38 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14CF2C0613E0
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 06:09:27 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id o20so25928930eds.10
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 06:09:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zYFf5rleB9ec1h6L5Rsg6C85Sz0GkYn54vaAI/sfBKM=;
        b=TZ4dGHtEEfqktYYq6EH4whBPY2645fhRxPiV/i9ULpr6ozh9oLTyJ4GXOSpkcT0IyA
         pEWrfUX5fWk6L5QENIVhdpd3+TXwh/SAzZSDFKX06XcNNYospIL4eEPKBBzcyYnoqfhQ
         1Z9D+zD3BoVGjiWsZIu//sCxU+jxOBVfdzWX5EFgBldvOGJYobXOZ9FnYRoqZQH0spq4
         ZhAqxcqLXfezrGJJL5/yaRcNyEK7OADcIjdOABNNAntNRm9xjA3OK2Aok2xumniYRfcf
         e3jjNq+nvx8IqA2VFa/04bovWO6A8SkSMEAzDuY+3RBL0q984PWfpEhyNkXqfv2R8cxR
         6EqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zYFf5rleB9ec1h6L5Rsg6C85Sz0GkYn54vaAI/sfBKM=;
        b=qZNRIPgIe4ortturHDIBoEIqZldlZhX5Ng5RZfSsazDv3h89LJlD1N6GTv7tE6HMZW
         QUV3aopnyWbhdJBIvzShWy/CNzAtp92+BavccE8/jE0PdWyDYxjYXmwaUqe0NVzP94XE
         CrBUDbpTa8OolICqyDn0CShdip4ypB+YDZStJMMn2V/OlUELt8s8cQyprFR0gFDqwCuJ
         VLDsbfxNDTk7ltTSP+SBb6qG8crFkvgPUPyMk5ZWrx7fKs1h/ATEi2ajPoolMjUjUhOV
         VfARbLjZZea5HMroap7XZIgTjBxqdjlSYbO8Ons8ECWJHMk5NIl+eSlRS5rRpl1S97IL
         AoTA==
X-Gm-Message-State: AOAM531JNTnZfR11OZPwFj6x9ahLAJAsny5lTNIzFxH2pYL54GGp9PBN
        hKiZFb/cNhYs4Lt+daJ9MdE1hO6neIZ8R+g6
X-Google-Smtp-Source: ABdhPJzVR17R/4LvQ9RZgjUp76vKCtEMbSLHQAs27urE23gUQgCXvgHXevUiptGreLeIBrA9X4qbUA==
X-Received: by 2002:a17:907:7da8:: with SMTP id oz40mr31380601ejc.105.1637849364878;
        Thu, 25 Nov 2021 06:09:24 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id sc7sm1889863ejc.50.2021.11.25.06.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 06:09:24 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, ivecera@redhat.com,
        bridge@lists.linux-foundation.org, davem@davemloft.net,
        kuba@kernel.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 06/10] selftests: net: bridge: add vlan mcast_membership_interval test
Date:   Thu, 25 Nov 2021 16:08:54 +0200
Message-Id: <20211125140858.3639139-7-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211125140858.3639139-1-razor@blackwall.org>
References: <20211125140858.3639139-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add a test which changes the new per-vlan mcast_membership_interval and
verifies that a newly learned mdb entry would expire in that interval.

TEST: Vlan mcast_membership_interval global option default value    [ OK ]
TEST: Vlan 10 mcast_membership_interval option changed to 200       [ OK ]
TEST: Vlan 10 mcast_membership_interval mdb entry expire            [ OK ]

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 .../net/forwarding/bridge_vlan_mcast.sh       | 28 ++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh b/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh
index 0070d8292569..87dcd49b0a8d 100755
--- a/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh
@@ -2,7 +2,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
 ALL_TESTS="vlmc_control_test vlmc_querier_test vlmc_igmp_mld_version_test \
-	   vlmc_last_member_test vlmc_startup_query_test"
+	   vlmc_last_member_test vlmc_startup_query_test vlmc_membership_test"
 NUM_NETIFS=4
 CHECK_TC="yes"
 TEST_GROUP="239.10.10.10"
@@ -358,6 +358,32 @@ vlmc_startup_query_test()
 	bridge vlan global set vid 10 dev br0 mcast_snooping 1 mcast_startup_query_count 2
 }
 
+vlmc_membership_test()
+{
+	RET=0
+	local goutput=`bridge -j vlan global show`
+	echo -n $goutput |
+		jq -e ".[].vlans[] | select(.vlan == 10)" &>/dev/null
+	check_err $? "Could not find vlan 10's global options"
+
+	echo -n $goutput |
+		jq -e ".[].vlans[] | select(.vlan == 10 and \
+					    .mcast_membership_interval == 26000) " &>/dev/null
+	check_err $? "Wrong default mcast_membership_interval global vlan option value"
+	log_test "Vlan mcast_membership_interval global option default value"
+
+	RET=0
+	bridge vlan global set vid 10 dev br0 mcast_snooping 1 mcast_membership_interval 200
+	check_err $? "Could not set mcast_membership_interval in vlan 10"
+	log_test "Vlan 10 mcast_membership_interval option changed to 200"
+
+	RET=0
+	vlmc_v2join_test 1
+	log_test "Vlan 10 mcast_membership_interval mdb entry expire"
+
+	bridge vlan global set vid 10 dev br0 mcast_snooping 1 mcast_membership_interval 26000
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.31.1

