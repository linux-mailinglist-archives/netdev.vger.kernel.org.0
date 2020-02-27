Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 459721711B9
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 08:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbgB0Huh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 02:50:37 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39699 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728515AbgB0Hue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 02:50:34 -0500
Received: by mail-wm1-f68.google.com with SMTP id c84so2195893wme.4
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 23:50:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BEok8qy4oCPS0IomUC3NLwFLec0QwhSl930Djm/sr7U=;
        b=lWo02HS+PUiRV6SSNkjbS6IfNba9ZZhxdDFPEm/Sl0rJYaMqcWFNJSYg9+kTcf6YJz
         n6Exo/7Y7gVFARa6nyUOUryViiz4bB4PkqIPXpy3QJlXaqBDHx0190aXxNIHpo2QFL9W
         VWAeKNpT8/NR0aqoDw7kF5OMwVAe1QkeKNRjvZK/q5eMWFtoQs3t8DvfH1XncLDno3Pc
         aemJaPmKC8gi9gT2NIUIOsCofEReDArutUvHp2ER56DMLuT9OE4c0CnxAWv1f513KX3b
         ucEAXlPhXPHndFFAA/sT2PkRC1Nfd3mA+tGVesizXun3VVgbEjgc4fzJe4zbigG/J9gn
         cjSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BEok8qy4oCPS0IomUC3NLwFLec0QwhSl930Djm/sr7U=;
        b=ONujfB1/jzPDHNv8/tOsYVDoi+s3kRlID/Ek1Z4aX9Gf7nmnjKWRed4yih1+aE5Q2/
         u6CNWdUgoRSE35BQETcZONgGWp7caLVyRdH9qpKZMvKm4iDT8iMiT34Ndln9w2b0YFNQ
         8/4blcHCnl0R9FXtfIQqzEGFxlrFA3vaxXq4DoX6tBAyKCaRvNovO/9SEUv+4PQQt4vV
         2m0mJ7ruY0vG365RRL0AnPeyF6zGwu2aK/NCwBPWgCaCYp1EMNEWD3tM+byDw4+2T+UB
         VCIejFNLnEP9EJCtjEWN1DApfaw9txaM01mM5X/qNoANTBED0ziIEfKtBgi1gpEPIbQB
         SeoA==
X-Gm-Message-State: APjAAAVHoukL6cWpa7yMlXyBCf2vIldzCsLU8e7PTkzoJ+beQoB0AlAk
        TY8/6Q9mU10+obVrN+gooWGHS5rVoaQ=
X-Google-Smtp-Source: APXvYqwbdkWwSsppPYkmATM4q2uK8Cj9rEzAcnRKiILqTWuzIgcGqNt693oa6cbvbqQtL255TIn4dQ==
X-Received: by 2002:a7b:ce0b:: with SMTP id m11mr3694963wmc.4.1582789832076;
        Wed, 26 Feb 2020 23:50:32 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id u8sm6683788wmm.15.2020.02.26.23.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 23:50:31 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com, shuah@kernel.org
Subject: [patch net-next 08/16] selftests: mlxsw: Use busywait helper in rtnetlink test
Date:   Thu, 27 Feb 2020 08:50:13 +0100
Message-Id: <20200227075021.3472-9-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200227075021.3472-1-jiri@resnulli.us>
References: <20200227075021.3472-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@mellanox.com>

Rtnetlink test uses offload indication checks.

Use a busywait helper and wait until the offload indication is set or
fail if it reaches timeout.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 .../selftests/drivers/net/mlxsw/rtnetlink.sh  | 68 ++++++++++++-------
 1 file changed, 44 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/rtnetlink.sh b/tools/testing/selftests/drivers/net/mlxsw/rtnetlink.sh
index 5c39e5f6a480..f4031002d5e9 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/rtnetlink.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/rtnetlink.sh
@@ -32,6 +32,7 @@ ALL_TESTS="
 	devlink_reload_test
 "
 NUM_NETIFS=2
+: ${TIMEOUT:=20000} # ms
 source $lib_dir/lib.sh
 source $lib_dir/devlink_lib.sh
 
@@ -360,20 +361,24 @@ vlan_rif_refcount_test()
 	ip link add link br0 name br0.10 up type vlan id 10
 	ip -6 address add 2001:db8:1::1/64 dev br0.10
 
-	ip -6 route get fibmatch 2001:db8:1::2 dev br0.10 | grep -q offload
+	busywait "$TIMEOUT" wait_for_offload \
+		ip -6 route get fibmatch 2001:db8:1::2 dev br0.10
 	check_err $? "vlan rif was not created before adding port to vlan"
 
 	bridge vlan add vid 10 dev $swp1
-	ip -6 route get fibmatch 2001:db8:1::2 dev br0.10 | grep -q offload
+	busywait "$TIMEOUT" wait_for_offload \
+		ip -6 route get fibmatch 2001:db8:1::2 dev br0.10
 	check_err $? "vlan rif was destroyed after adding port to vlan"
 
 	bridge vlan del vid 10 dev $swp1
-	ip -6 route get fibmatch 2001:db8:1::2 dev br0.10 | grep -q offload
+	busywait "$TIMEOUT" wait_for_offload \
+		ip -6 route get fibmatch 2001:db8:1::2 dev br0.10
 	check_err $? "vlan rif was destroyed after removing port from vlan"
 
 	ip link set dev $swp1 nomaster
-	ip -6 route get fibmatch 2001:db8:1::2 dev br0.10 | grep -q offload
-	check_fail $? "vlan rif was not destroyed after unlinking port from bridge"
+	busywait "$TIMEOUT" not wait_for_offload \
+		ip -6 route get fibmatch 2001:db8:1::2 dev br0.10
+	check_err $? "vlan rif was not destroyed after unlinking port from bridge"
 
 	log_test "vlan rif refcount"
 
@@ -401,22 +406,28 @@ subport_rif_refcount_test()
 	ip -6 address add 2001:db8:1::1/64 dev bond1
 	ip -6 address add 2001:db8:2::1/64 dev bond1.10
 
-	ip -6 route get fibmatch 2001:db8:1::2 dev bond1 | grep -q offload
+	busywait "$TIMEOUT" wait_for_offload \
+		ip -6 route get fibmatch 2001:db8:1::2 dev bond1
 	check_err $? "subport rif was not created on lag device"
-	ip -6 route get fibmatch 2001:db8:2::2 dev bond1.10 | grep -q offload
+	busywait "$TIMEOUT" wait_for_offload \
+		ip -6 route get fibmatch 2001:db8:2::2 dev bond1.10
 	check_err $? "subport rif was not created on vlan device"
 
 	ip link set dev $swp1 nomaster
-	ip -6 route get fibmatch 2001:db8:1::2 dev bond1 | grep -q offload
+	busywait "$TIMEOUT" wait_for_offload \
+		ip -6 route get fibmatch 2001:db8:1::2 dev bond1
 	check_err $? "subport rif of lag device was destroyed when should not"
-	ip -6 route get fibmatch 2001:db8:2::2 dev bond1.10 | grep -q offload
+	busywait "$TIMEOUT" wait_for_offload \
+		ip -6 route get fibmatch 2001:db8:2::2 dev bond1.10
 	check_err $? "subport rif of vlan device was destroyed when should not"
 
 	ip link set dev $swp2 nomaster
-	ip -6 route get fibmatch 2001:db8:1::2 dev bond1 | grep -q offload
-	check_fail $? "subport rif of lag device was not destroyed when should"
-	ip -6 route get fibmatch 2001:db8:2::2 dev bond1.10 | grep -q offload
-	check_fail $? "subport rif of vlan device was not destroyed when should"
+	busywait "$TIMEOUT" not wait_for_offload \
+		ip -6 route get fibmatch 2001:db8:1::2 dev bond1
+	check_err $? "subport rif of lag device was not destroyed when should"
+	busywait "$TIMEOUT" not wait_for_offload \
+		ip -6 route get fibmatch 2001:db8:2::2 dev bond1.10
+	check_err $? "subport rif of vlan device was not destroyed when should"
 
 	log_test "subport rif refcount"
 
@@ -575,7 +586,8 @@ bridge_extern_learn_test()
 
 	bridge fdb add de:ad:be:ef:13:37 dev $swp1 master extern_learn
 
-	bridge fdb show brport $swp1 | grep de:ad:be:ef:13:37 | grep -q offload
+	busywait "$TIMEOUT" wait_for_offload \
+		bridge fdb show brport $swp1 de:ad:be:ef:13:37
 	check_err $? "fdb entry not marked as offloaded when should"
 
 	log_test "externally learned fdb entry"
@@ -595,9 +607,11 @@ neigh_offload_test()
 	ip -6 neigh add 2001:db8:1::2 lladdr de:ad:be:ef:13:37 nud perm \
 		dev $swp1
 
-	ip -4 neigh show dev $swp1 | grep 192.0.2.2 | grep -q offload
+	busywait "$TIMEOUT" wait_for_offload \
+		ip -4 neigh show dev $swp1 192.0.2.2
 	check_err $? "ipv4 neigh entry not marked as offloaded when should"
-	ip -6 neigh show dev $swp1 | grep 2001:db8:1::2 | grep -q offload
+	busywait "$TIMEOUT" wait_for_offload \
+		ip -6 neigh show dev $swp1 2001:db8:1::2
 	check_err $? "ipv6 neigh entry not marked as offloaded when should"
 
 	log_test "neighbour offload indication"
@@ -623,25 +637,31 @@ nexthop_offload_test()
 	ip -6 route add 2001:db8:2::/64 vrf v$swp1 \
 		nexthop via 2001:db8:1::2 dev $swp1
 
-	ip -4 route show 198.51.100.0/24 vrf v$swp1 | grep -q offload
+	busywait "$TIMEOUT" wait_for_offload \
+		ip -4 route show 198.51.100.0/24 vrf v$swp1
 	check_err $? "ipv4 nexthop not marked as offloaded when should"
-	ip -6 route show 2001:db8:2::/64 vrf v$swp1 | grep -q offload
+	busywait "$TIMEOUT" wait_for_offload \
+		ip -6 route show 2001:db8:2::/64 vrf v$swp1
 	check_err $? "ipv6 nexthop not marked as offloaded when should"
 
 	ip link set dev $swp2 down
 	sleep 1
 
-	ip -4 route show 198.51.100.0/24 vrf v$swp1 | grep -q offload
-	check_fail $? "ipv4 nexthop marked as offloaded when should not"
-	ip -6 route show 2001:db8:2::/64 vrf v$swp1 | grep -q offload
-	check_fail $? "ipv6 nexthop marked as offloaded when should not"
+	busywait "$TIMEOUT" not wait_for_offload \
+		ip -4 route show 198.51.100.0/24 vrf v$swp1
+	check_err $? "ipv4 nexthop marked as offloaded when should not"
+	busywait "$TIMEOUT" not wait_for_offload \
+		ip -6 route show 2001:db8:2::/64 vrf v$swp1
+	check_err $? "ipv6 nexthop marked as offloaded when should not"
 
 	ip link set dev $swp2 up
 	setup_wait
 
-	ip -4 route show 198.51.100.0/24 vrf v$swp1 | grep -q offload
+	busywait "$TIMEOUT" wait_for_offload \
+		ip -4 route show 198.51.100.0/24 vrf v$swp1
 	check_err $? "ipv4 nexthop not marked as offloaded after neigh add"
-	ip -6 route show 2001:db8:2::/64 vrf v$swp1 | grep -q offload
+	busywait "$TIMEOUT" wait_for_offload \
+		ip -6 route show 2001:db8:2::/64 vrf v$swp1
 	check_err $? "ipv6 nexthop not marked as offloaded after neigh add"
 
 	log_test "nexthop offload indication"
-- 
2.21.1

