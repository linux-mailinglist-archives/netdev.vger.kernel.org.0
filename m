Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF6B45DC12
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 15:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355661AbhKYOOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 09:14:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231550AbhKYOMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 09:12:30 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB55CC061763
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 06:09:18 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id w1so26287339edc.6
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 06:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FzgAx/GM5UY7f5TX8VZkJRzCg4EVgCVxeMVd/CytlKU=;
        b=kVCq5pWtzAWSHFYGKKnoa+wROir6oCgaHq8S/t7k0/VnVWnx2tlLcVzoF/81ImvC2W
         L4LnH3d61VE8JTaMpI6aUcmjeqheIEboLwgiIlj6flPJLV55AwsIGXGHRx7TB/qeGfrg
         f28bpDm68q9KcAfybVWFNcXnxltwpEs/TwkSUtxZX1RZFo4zXgI1GKbXDU1jYyWoHlNu
         yqTKL4DBFI1SoVFJYCnAyBxk6ZwK4K6hiwgWauHgmRT47huWzRTDVlwD3L+/qNF0ygpf
         5Jzjs8Now3cL+BgyMzgL++n0O/ptuouqzzYa4IKxVvV/4sTlhMRkarFdlxaesLq4e7gy
         pKzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FzgAx/GM5UY7f5TX8VZkJRzCg4EVgCVxeMVd/CytlKU=;
        b=aElxgqSxD3mNb/rt1X309pcCI0MwSihSp8EXzuHPPeeGrzcJluXyPfmtni+suE6521
         55/0FDBBqZH6DAkQrObPb6Zm9q468/0wvStIyqODjn0BVwZxsaPqonmTP+CiyrL1FLxy
         ND0i84z69mVXYLcGeioQcawTCR/EtUCxQ37prHgq1fos+0Qbebci6ZXlaXm8FF+lgdwr
         Ph5b+f6Q3mtBLv7ubvqR1a1ATKircUE+zGZr8yGc7HvFG7fCN3fUpt3jsNnALyvAAkpm
         hBVb91D9drlIGp7zhs0xYTKsh+NZiDSGzOLt7W8pN83+r3Y2s4HaK0e7YLQ90PDCnxwg
         Hy0A==
X-Gm-Message-State: AOAM533rsElWs49YNPeRyDPGRWz3kOBavU1/qy80IYjM3Qyy2YqVa6xB
        Ed8coAJuYKM22kxRowPBHmdf4/XcFOu8lnSD
X-Google-Smtp-Source: ABdhPJybo0OICHJGzFirHRDPUPSja8NYuLoyAWJRXRl/kCcpxPylRZbw4iLn5N/myyLCw/hIbhSwhg==
X-Received: by 2002:a17:907:86a1:: with SMTP id qa33mr31819212ejc.142.1637849356887;
        Thu, 25 Nov 2021 06:09:16 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id sc7sm1889863ejc.50.2021.11.25.06.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 06:09:16 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, ivecera@redhat.com,
        bridge@lists.linux-foundation.org, davem@davemloft.net,
        kuba@kernel.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 03/10] selftests: net: bridge: add vlan mcast igmp/mld version tests
Date:   Thu, 25 Nov 2021 16:08:51 +0200
Message-Id: <20211125140858.3639139-4-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211125140858.3639139-1-razor@blackwall.org>
References: <20211125140858.3639139-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add tests which change the new per-vlan IGMP/MLD versions and verify
that proper tagged general query packets are sent.

TEST: Vlan mcast_igmp_version global option default value           [ OK ]
TEST: Vlan mcast_mld_version global option default value            [ OK ]
TEST: Vlan 10 mcast_igmp_version option changed to 3                [ OK ]
TEST: Vlan 10 tagged IGMPv3 general query sent                      [ OK ]
TEST: Vlan 10 mcast_mld_version option changed to 2                 [ OK ]
TEST: Vlan 10 tagged MLDv2 general query sent                       [ OK ]

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 .../net/forwarding/bridge_vlan_mcast.sh       | 45 ++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh b/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh
index aa23764a328b..1b91778fac2f 100755
--- a/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
-ALL_TESTS="vlmc_control_test vlmc_querier_test"
+ALL_TESTS="vlmc_control_test vlmc_querier_test vlmc_igmp_mld_version_test"
 NUM_NETIFS=4
 CHECK_TC="yes"
 TEST_GROUP="239.10.10.10"
@@ -241,6 +241,49 @@ vlmc_querier_test()
 	log_test "Vlan 10 tagged MLD general query sent"
 }
 
+vlmc_igmp_mld_version_test()
+{
+	RET=0
+	local goutput=`bridge -j vlan global show`
+	echo -n $goutput |
+		jq -e ".[].vlans[] | select(.vlan == 10)" &>/dev/null
+	check_err $? "Could not find vlan 10's global options"
+
+	echo -n $goutput |
+		jq -e ".[].vlans[] | select(.vlan == 10 and .mcast_igmp_version == 2) " &>/dev/null
+	check_err $? "Wrong default mcast_igmp_version global vlan option value"
+	log_test "Vlan mcast_igmp_version global option default value"
+
+	RET=0
+	echo -n $goutput |
+		jq -e ".[].vlans[] | select(.vlan == 10 and .mcast_mld_version == 1) " &>/dev/null
+	check_err $? "Wrong default mcast_mld_version global vlan option value"
+	log_test "Vlan mcast_mld_version global option default value"
+
+	RET=0
+	bridge vlan global set vid 10 dev br0 mcast_snooping 1 mcast_igmp_version 3
+	check_err $? "Could not set mcast_igmp_version in vlan 10"
+	log_test "Vlan 10 mcast_igmp_version option changed to 3"
+
+	RET=0
+	vlmc_check_query igmp 3 $swp1 1 1
+	check_err $? "No vlan tagged IGMPv3 general query packets sent"
+	log_test "Vlan 10 tagged IGMPv3 general query sent"
+
+	RET=0
+	bridge vlan global set vid 10 dev br0 mcast_snooping 1 mcast_mld_version 2
+	check_err $? "Could not set mcast_mld_version in vlan 10"
+	log_test "Vlan 10 mcast_mld_version option changed to 2"
+
+	RET=0
+	vlmc_check_query mld 2 $swp1 1 1
+	check_err $? "No vlan tagged MLDv2 general query packets sent"
+	log_test "Vlan 10 tagged MLDv2 general query sent"
+
+	bridge vlan global set vid 10 dev br0 mcast_snooping 1 mcast_igmp_version 2
+	bridge vlan global set vid 10 dev br0 mcast_snooping 1 mcast_mld_version 1
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.31.1

