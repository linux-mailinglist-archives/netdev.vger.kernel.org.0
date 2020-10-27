Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDA0629C80D
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 20:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829211AbgJ0TBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 15:01:03 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:45061 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S371356AbgJ0TAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 15:00:10 -0400
Received: by mail-wr1-f53.google.com with SMTP id e17so3085440wru.12
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 12:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tLPWNUeiDX6YqJv0P1s9lGNPu+RgfZ8zS9WrTNhZtwU=;
        b=Pbbgzu7Uim9URoVPsODKBzIRpIWNZUV/sc1OsVCs/ctmhcIQJuqP1Da07kJ2ti9/rK
         zwadkwjLlxDK6vSMPMNy7hOKGF9z/TVWXc++pM9nsU6I2AuCe/CIsrnng25YCjNkjb4f
         nyOsGMfA8wywQAx2ipPq2e+Cm42KAUKXLliz5jwbRyp1GGAZtlPV0gPBOKSl6pt+XRkh
         jhlsFvNWPtpOonDa/1z7uV3cBIFFMK7HjMxd29Pc6KJwjY0diRy6Y9jWj3DpTW9TVLii
         jpwVVOEsvNW0ITz2hhefUMxxEdpP8Qt870u1sEdMawZhO0x30jL4RKpm3No+NrtAJE0S
         WLTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tLPWNUeiDX6YqJv0P1s9lGNPu+RgfZ8zS9WrTNhZtwU=;
        b=F5NKwBvaYg5eMtIoSMmyBb0GblSMJKsJEIYMMIYsHHGyfXE+KU7ymyTqQoA6qSGz2c
         hL6HIjvCSzUodmkFKkWIicDnI5Xl60CXBfzDeGtNIL8FIiTo4B5xFQIDcsX+n2zjmDfC
         mzo3srsIQPu1P1BfKi+/mvbpay2Pr6FNbSVlljLKVjotKcIVj58pPvGvaaW0ZJFB9mAU
         OvfSlwgizTn4qR6fJAY5p0MMpET6dWwNxYMujNc7hriITYvlmnryQd/BR8OOLAxo9w5I
         xEQJ5you028sgsnBfkwgmLKOqp7DsC8ENUYyyZEtS2j4n8bypTBS2lNCvvS1GQXByKFX
         5eZQ==
X-Gm-Message-State: AOAM530hqO1OfUcYszSUJvU16o7MOnmD8rETUCALvtRFnuXtJGejDzsJ
        SpBlQV9RZ9DWGX9hm2Y/Fv5sCf02/6P0Gov6
X-Google-Smtp-Source: ABdhPJzG/OSgYLmz2HBNiIC8mB9c1vzZDllDh54O3gAqpvWndh4V2M5gurPd/JiO/Om2Nd0bKkjvbA==
X-Received: by 2002:adf:94e6:: with SMTP id 93mr4299190wrr.190.1603825207449;
        Tue, 27 Oct 2020 12:00:07 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x6sm3219803wmb.17.2020.10.27.12.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 12:00:07 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 02/16] selftests: net: bridge: igmp: add support for packet source address
Date:   Tue, 27 Oct 2020 20:59:20 +0200
Message-Id: <20201027185934.227040-3-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201027185934.227040-1-razor@blackwall.org>
References: <20201027185934.227040-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add support for one more argument which specifies the source address to
use. It will be later used for IGMPv3 S,G entry testing.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 .../testing/selftests/net/forwarding/bridge_igmp.sh | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_igmp.sh b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
index 481198300b72..1c19459dbc58 100755
--- a/tools/testing/selftests/net/forwarding/bridge_igmp.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
@@ -83,9 +83,10 @@ cleanup()
 mcast_packet_test()
 {
 	local mac=$1
-	local ip=$2
-	local host1_if=$3
-	local host2_if=$4
+	local src_ip=$2
+	local ip=$3
+	local host1_if=$4
+	local host2_if=$5
 	local seen=0
 
 	# Add an ACL on `host2_if` which will tell us whether the packet
@@ -94,7 +95,7 @@ mcast_packet_test()
 	tc filter add dev $host2_if ingress protocol ip pref 1 handle 101 \
 		flower dst_mac $mac action drop
 
-	$MZ $host1_if -c 1 -p 64 -b $mac -B $ip -t udp "dp=4096,sp=2048" -q
+	$MZ $host1_if -c 1 -p 64 -b $mac -A $src_ip -B $ip -t udp "dp=4096,sp=2048" -q
 	sleep 1
 
 	tc -j -s filter show dev $host2_if ingress \
@@ -120,7 +121,7 @@ v2reportleave_test()
 	bridge mdb show dev br0 | grep $TEST_GROUP 1>/dev/null
 	check_err $? "IGMPv2 report didn't create mdb entry for $TEST_GROUP"
 
-	mcast_packet_test $TEST_GROUP_MAC $TEST_GROUP $h1 $h2
+	mcast_packet_test $TEST_GROUP_MAC 192.0.2.1 $TEST_GROUP $h1 $h2
 	check_fail $? "Traffic to $TEST_GROUP wasn't forwarded"
 
 	log_test "IGMPv2 report $TEST_GROUP"
@@ -136,7 +137,7 @@ v2reportleave_test()
 	bridge mdb show dev br0 | grep $TEST_GROUP 1>/dev/null
 	check_fail $? "Leave didn't delete mdb entry for $TEST_GROUP"
 
-	mcast_packet_test $TEST_GROUP_MAC $TEST_GROUP $h1 $h2
+	mcast_packet_test $TEST_GROUP_MAC 192.0.2.1 $TEST_GROUP $h1 $h2
 	check_err $? "Traffic to $TEST_GROUP was forwarded without mdb entry"
 
 	log_test "IGMPv2 leave $TEST_GROUP"
-- 
2.25.4

