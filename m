Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB4AC45DC1A
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 15:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355626AbhKYOPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 09:15:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355639AbhKYONj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 09:13:39 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1C6C0613F1
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 06:09:29 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id r11so26170441edd.9
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 06:09:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rsXnOvd5nwBThD2qTg9D1pYE4X40JBYkDShPIF1srm0=;
        b=AuWU0dI8dq+Am1E5pw+6CORB6nijQMNR5dkWuKAcGZOilRKprNir0VkqxJGMJsJniP
         SMz3WfKNtQzQK03zbaRkGVGQFeI0FpCwG0YIlzCs2tlcJ5YnBDwrrtJcrndqJu/KUlZV
         0CEAx/HfVOIwn8WOr1EPnpOUGyVAvUS3yrG873SuxG0UMYGBqKTV0YGIS/9AvFVVL1h4
         ZATIIMEAn/teDTyn9+2uTH24RCY5GUs9mmXkeHwavtsgMdQvjXemrPxP0LmriDMldGJH
         wba/rZ7bbwVOtkfyneUtm2EPl2PscriY8HesZtwgeQCGs8BweoNz6dGsYH2Amubuoa12
         gxcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rsXnOvd5nwBThD2qTg9D1pYE4X40JBYkDShPIF1srm0=;
        b=jEO11qNCW/4vXZpDwjzA8yshcM/Cm8anRJMWupc5Qq+IWvOlNLQI+ypr91TGbvV+0t
         yvSiYkVHFX/BzU5+gmE6E9Eh2eJgd5L/a54zqYuR5pl5HD6lQRIddTOhYL47wQMgYspk
         krkphVKLlw0BZ0ZpbEM7HMbGdY2/b2A1Hb1P56kHCPjreRNmBqI7pTqrgBmkQzsFWvbT
         NKeCO2/sN7206LIU+TJAk0Zph0HaVZZYajwFAD06EAheFXSrxi45pYPMH3oGq3IxyygS
         6Dm+3UyAXLBoPiSexdo7eGidNmnpu2eJomVxbB4gioVWUldmQmPhv5yTWqVLHrv7BPoH
         4cKQ==
X-Gm-Message-State: AOAM533IBRRNh+joKOlv0sSr9U8xphaODbITxqk+1MUKXjXw9XxHmd3i
        4wxDJ1ctVrrU8sdLo/00kORahaNElrvb1bUM
X-Google-Smtp-Source: ABdhPJxblp2v2lk/tLcjsRDEZHAcXI6hscD+GNZOSNFDOZb7G4Ir17j6WzYkMv1keK3waViyJETafQ==
X-Received: by 2002:a05:6402:40c3:: with SMTP id z3mr38076605edb.203.1637849368029;
        Thu, 25 Nov 2021 06:09:28 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id sc7sm1889863ejc.50.2021.11.25.06.09.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 06:09:27 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, ivecera@redhat.com,
        bridge@lists.linux-foundation.org, davem@davemloft.net,
        kuba@kernel.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 09/10] selftests: net: bridge: add vlan mcast_router tests
Date:   Thu, 25 Nov 2021 16:08:57 +0200
Message-Id: <20211125140858.3639139-10-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211125140858.3639139-1-razor@blackwall.org>
References: <20211125140858.3639139-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add tests for the new per-port/vlan mcast_router option, verify that
unknown multicast packets are flooded only to router ports.

TEST: Port vlan 10 option mcast_router default value                [ OK ]
TEST: Port vlan 10 mcast_router option changed to 2                 [ OK ]
TEST: Flood unknown vlan multicast packets to router port only      [ OK ]

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 .../net/forwarding/bridge_vlan_mcast.sh       | 54 ++++++++++++++++++-
 1 file changed, 53 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh b/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh
index fbc7f5045b26..898a70f4d226 100755
--- a/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh
@@ -3,7 +3,8 @@
 
 ALL_TESTS="vlmc_control_test vlmc_querier_test vlmc_igmp_mld_version_test \
 	   vlmc_last_member_test vlmc_startup_query_test vlmc_membership_test \
-	   vlmc_querier_intvl_test vlmc_query_intvl_test vlmc_query_response_intvl_test"
+	   vlmc_querier_intvl_test vlmc_query_intvl_test vlmc_query_response_intvl_test \
+	   vlmc_router_port_test"
 NUM_NETIFS=4
 CHECK_TC="yes"
 TEST_GROUP="239.10.10.10"
@@ -471,6 +472,57 @@ vlmc_query_response_intvl_test()
 	bridge vlan global set vid 10 dev br0 mcast_snooping 1 mcast_query_response_interval 1000
 }
 
+vlmc_router_port_test()
+{
+	RET=0
+	local goutput=`bridge -j -d vlan show`
+	echo -n $goutput |
+		jq -e ".[] | select(.ifname == \"$swp1\" and \
+				    .vlans[].vlan == 10)" &>/dev/null
+	check_err $? "Could not find port vlan 10's options"
+
+	echo -n $goutput |
+		jq -e ".[] | select(.ifname == \"$swp1\" and \
+				    .vlans[].vlan == 10 and \
+				    .vlans[].mcast_router == 1)" &>/dev/null
+	check_err $? "Wrong default port mcast_router option value"
+	log_test "Port vlan 10 option mcast_router default value"
+
+	RET=0
+	bridge vlan set vid 10 dev $swp1 mcast_router 2
+	check_err $? "Could not set port vlan 10's mcast_router option"
+	log_test "Port vlan 10 mcast_router option changed to 2"
+
+	RET=0
+	tc filter add dev $swp1 egress pref 10 prot 802.1Q \
+		flower vlan_id 10 vlan_ethtype ipv4 dst_ip 239.1.1.1 ip_proto udp action pass
+	tc filter add dev $swp2 egress pref 10 prot 802.1Q \
+		flower vlan_id 10 vlan_ethtype ipv4 dst_ip 239.1.1.1 ip_proto udp action pass
+	bridge vlan set vid 10 dev $swp2 mcast_router 0
+	# we need to enable querier and disable query response interval to
+	# make sure packets are flooded only to router ports
+	bridge vlan global set vid 10 dev br0 mcast_snooping 1 mcast_querier 1 \
+					      mcast_query_response_interval 0
+	bridge vlan add vid 10 dev br0 self
+	sleep 1
+	mausezahn br0 -Q 10 -c 10 -p 128 -b 01:00:5e:01:01:01 -B 239.1.1.1 \
+			-t udp "dp=1024" &>/dev/null
+	local swp1_tcstats=$(tc_rule_stats_get $swp1 10 egress)
+	if [[ $swp1_tcstats != 10 ]]; then
+		check_err 1 "Wrong number of vlan 10 multicast packets flooded"
+	fi
+	local swp2_tcstats=$(tc_rule_stats_get $swp2 10 egress)
+	check_err $swp2_tcstats "Vlan 10 multicast packets flooded to non-router port"
+	log_test "Flood unknown vlan multicast packets to router port only"
+
+	tc filter del dev $swp2 egress pref 10
+	tc filter del dev $swp1 egress pref 10
+	bridge vlan del vid 10 dev br0 self
+	bridge vlan global set vid 10 dev br0 mcast_snooping 1 mcast_query_response_interval 1000
+	bridge vlan set vid 10 dev $swp2 mcast_router 1
+	bridge vlan set vid 10 dev $swp1 mcast_router 1
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.31.1

