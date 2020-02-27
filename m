Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A30261711B8
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 08:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbgB0Huf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 02:50:35 -0500
Received: from mail-wr1-f44.google.com ([209.85.221.44]:38900 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728506AbgB0Hue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 02:50:34 -0500
Received: by mail-wr1-f44.google.com with SMTP id e8so2051693wrm.5
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 23:50:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uIiGWek2/G6dZi5fJLTVDeUbi91g0b9JWYOcfcj1ltY=;
        b=NvpZ4YlBItAlUhNLAoIYIAL2ytqkHLYU8v7Tm3a4fHjGtmLkShF653nS/c00q8WUSR
         Ks8b60u53jN43erFdcDMFrMRDCAA/tUNEsYw05yMNMkKWisML4q1ckMzP0pdh+dd/VL/
         lotMvdnyu1ZH/050AniqwGi9EzvJW1pT1okFNu7CgsXsnizVZQ0HtwLn6VDRCjeZTQJo
         7tJ1rdP8oA8U5sUwv8vkie/fL45a+6AVXO2oSKNgS/Oxth9WFupgvH43UZvoqZpcFJRT
         zLI0StlBnZ2QQhKbJarP7Lk7rFTYebVedT/UPuOJVYjV9BoDfA/+wmxJUE81CYEowo7w
         fRJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uIiGWek2/G6dZi5fJLTVDeUbi91g0b9JWYOcfcj1ltY=;
        b=soAGL1pnal56UekW2Nf58mSnBIW5z2m9GfxCUQwlpqeh9cHytuHOam+CSZ9lJI1PA9
         mAbmwCDoCs/PS/Nra8c2Dp4pnY2jb67l5EjGhTOi1kEAPMaAhwZTCkeJOq5/jVXHYYAj
         sBjHcefCjkS9/IWfBV0trWeNp+qjtME+zOnqxrJ8gGXQf2ADlDZ/FyCCGAgMag3QxNN4
         ocBXu1kVBZbTdm+ynMJD3+8oPCSc4Yw+0hjQ8jU61RC8R7Ja71qtqtWT48cdNRyL+jcm
         hiSAYiMvf+99E95IopUcwoPX9wbZt9iPoD7TkpvbHqHXYQySm76gLUhaWvXobiGAtKlD
         pIyA==
X-Gm-Message-State: APjAAAWvcVkUbDhIFA7ZBp5KVOzM3E6KxCA5wc1PW6K6eQPTaT7MreK4
        LVHCcN7VSMP89s4SzgJDoKePxZxieLc=
X-Google-Smtp-Source: APXvYqxehE1bpQKHA8gxASxuzjGG7ZY2tCeN23YbY9z4ULGfBLEihSndfDAgI9zjT8Rc8g7jpYNqkw==
X-Received: by 2002:a5d:504e:: with SMTP id h14mr3224841wrt.82.1582789830992;
        Wed, 26 Feb 2020 23:50:30 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id q125sm6759970wme.19.2020.02.26.23.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 23:50:30 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com, shuah@kernel.org
Subject: [patch net-next 07/16] selftests: mlxsw: Use busywait helper in vxlan test
Date:   Thu, 27 Feb 2020 08:50:12 +0100
Message-Id: <20200227075021.3472-8-jiri@resnulli.us>
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

Vxlan test uses offload indication checks.

Use a busywait helper and wait until the offload indication is set or
fail if it reaches timeout.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 .../selftests/drivers/net/mlxsw/vxlan.sh      | 206 ++++++++++--------
 tools/testing/selftests/net/forwarding/lib.sh |  22 ++
 2 files changed, 139 insertions(+), 89 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/vxlan.sh b/tools/testing/selftests/drivers/net/mlxsw/vxlan.sh
index 15eb0dc9a685..729a86cc4ede 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/vxlan.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/vxlan.sh
@@ -9,6 +9,7 @@ lib_dir=$(dirname $0)/../../../net/forwarding
 ALL_TESTS="sanitization_test offload_indication_test \
 	sanitization_vlan_aware_test offload_indication_vlan_aware_test"
 NUM_NETIFS=2
+: ${TIMEOUT:=20000} # ms
 source $lib_dir/lib.sh
 
 setup_prepare()
@@ -470,8 +471,8 @@ offload_indication_fdb_flood_test()
 
 	bridge fdb append 00:00:00:00:00:00 dev vxlan0 self dst 198.51.100.2
 
-	bridge fdb show brport vxlan0 | grep 00:00:00:00:00:00 \
-		| grep -q offload
+	busywait "$TIMEOUT" wait_for_offload grep_bridge_fdb 00:00:00:00:00:00 \
+		bridge fdb show brport vxlan0
 	check_err $?
 
 	bridge fdb del 00:00:00:00:00:00 dev vxlan0 self
@@ -486,11 +487,11 @@ offload_indication_fdb_bridge_test()
 	bridge fdb add de:ad:be:ef:13:37 dev vxlan0 self master static \
 		dst 198.51.100.2
 
-	bridge fdb show brport vxlan0 | grep de:ad:be:ef:13:37 | grep self \
-		| grep -q offload
+	busywait "$TIMEOUT" wait_for_offload grep_bridge_fdb \
+		de:ad:be:ef:13:37 self bridge fdb show brport vxlan0
 	check_err $?
-	bridge fdb show brport vxlan0 | grep de:ad:be:ef:13:37 | grep -v self \
-		| grep -q offload
+	busywait "$TIMEOUT" wait_for_offload grep_bridge_fdb \
+		de:ad:be:ef:13:37 self -v bridge fdb show brport vxlan0
 	check_err $?
 
 	log_test "vxlan entry offload indication - initial state"
@@ -500,9 +501,9 @@ offload_indication_fdb_bridge_test()
 	RET=0
 
 	bridge fdb del de:ad:be:ef:13:37 dev vxlan0 master
-	bridge fdb show brport vxlan0 | grep de:ad:be:ef:13:37 | grep self \
-		| grep -q offload
-	check_fail $?
+	busywait "$TIMEOUT" not wait_for_offload grep_bridge_fdb \
+		de:ad:be:ef:13:37 self bridge fdb show brport vxlan0
+	check_err $?
 
 	log_test "vxlan entry offload indication - after removal from bridge"
 
@@ -511,11 +512,11 @@ offload_indication_fdb_bridge_test()
 	RET=0
 
 	bridge fdb add de:ad:be:ef:13:37 dev vxlan0 master static
-	bridge fdb show brport vxlan0 | grep de:ad:be:ef:13:37 | grep self \
-		| grep -q offload
+	busywait "$TIMEOUT" wait_for_offload grep_bridge_fdb \
+		de:ad:be:ef:13:37 self bridge fdb show brport vxlan0
 	check_err $?
-	bridge fdb show brport vxlan0 | grep de:ad:be:ef:13:37 | grep -v self \
-		| grep -q offload
+	busywait "$TIMEOUT" wait_for_offload grep_bridge_fdb \
+		de:ad:be:ef:13:37 self -v bridge fdb show brport vxlan0
 	check_err $?
 
 	log_test "vxlan entry offload indication - after re-add to bridge"
@@ -525,9 +526,9 @@ offload_indication_fdb_bridge_test()
 	RET=0
 
 	bridge fdb del de:ad:be:ef:13:37 dev vxlan0 self
-	bridge fdb show brport vxlan0 | grep de:ad:be:ef:13:37 | grep -v self \
-		| grep -q offload
-	check_fail $?
+	busywait "$TIMEOUT" not wait_for_offload grep_bridge_fdb \
+		de:ad:be:ef:13:37 self -v bridge fdb show brport vxlan0
+	check_err $?
 
 	log_test "vxlan entry offload indication - after removal from vxlan"
 
@@ -536,11 +537,11 @@ offload_indication_fdb_bridge_test()
 	RET=0
 
 	bridge fdb add de:ad:be:ef:13:37 dev vxlan0 self dst 198.51.100.2
-	bridge fdb show brport vxlan0 | grep de:ad:be:ef:13:37 | grep self \
-		| grep -q offload
+	busywait "$TIMEOUT" wait_for_offload grep_bridge_fdb \
+		de:ad:be:ef:13:37 self bridge fdb show brport vxlan0
 	check_err $?
-	bridge fdb show brport vxlan0 | grep de:ad:be:ef:13:37 | grep -v self \
-		| grep -q offload
+	busywait "$TIMEOUT" wait_for_offload grep_bridge_fdb \
+		de:ad:be:ef:13:37 self -v bridge fdb show brport vxlan0
 	check_err $?
 
 	log_test "vxlan entry offload indication - after re-add to vxlan"
@@ -558,27 +559,32 @@ offload_indication_decap_route_test()
 {
 	RET=0
 
-	ip route show table local | grep 198.51.100.1 | grep -q offload
+	busywait "$TIMEOUT" wait_for_offload \
+		ip route show table local 198.51.100.1
 	check_err $?
 
 	ip link set dev vxlan0 down
-	ip route show table local | grep 198.51.100.1 | grep -q offload
+	busywait "$TIMEOUT" wait_for_offload \
+		ip route show table local 198.51.100.1
 	check_err $?
 
 	ip link set dev vxlan1 down
-	ip route show table local | grep 198.51.100.1 | grep -q offload
-	check_fail $?
+	busywait "$TIMEOUT" not wait_for_offload \
+		ip route show table local 198.51.100.1
+	check_err $?
 
 	log_test "vxlan decap route - vxlan device down"
 
 	RET=0
 
 	ip link set dev vxlan1 up
-	ip route show table local | grep 198.51.100.1 | grep -q offload
+	busywait "$TIMEOUT" wait_for_offload \
+		ip route show table local 198.51.100.1
 	check_err $?
 
 	ip link set dev vxlan0 up
-	ip route show table local | grep 198.51.100.1 | grep -q offload
+	busywait "$TIMEOUT" wait_for_offload \
+		ip route show table local 198.51.100.1
 	check_err $?
 
 	log_test "vxlan decap route - vxlan device up"
@@ -586,11 +592,13 @@ offload_indication_decap_route_test()
 	RET=0
 
 	ip address delete 198.51.100.1/32 dev lo
-	ip route show table local | grep 198.51.100.1 | grep -q offload
-	check_fail $?
+	busywait "$TIMEOUT" not wait_for_offload \
+		ip route show table local 198.51.100.1
+	check_err $?
 
 	ip address add 198.51.100.1/32 dev lo
-	ip route show table local | grep 198.51.100.1 | grep -q offload
+	busywait "$TIMEOUT" wait_for_offload \
+		ip route show table local 198.51.100.1
 	check_err $?
 
 	log_test "vxlan decap route - add local route"
@@ -598,16 +606,19 @@ offload_indication_decap_route_test()
 	RET=0
 
 	ip link set dev $swp1 nomaster
-	ip route show table local | grep 198.51.100.1 | grep -q offload
+	busywait "$TIMEOUT" wait_for_offload \
+		ip route show table local 198.51.100.1
 	check_err $?
 
 	ip link set dev $swp2 nomaster
-	ip route show table local | grep 198.51.100.1 | grep -q offload
-	check_fail $?
+	busywait "$TIMEOUT" not wait_for_offload \
+		ip route show table local 198.51.100.1
+	check_err $?
 
 	ip link set dev $swp1 master br0
 	ip link set dev $swp2 master br1
-	ip route show table local | grep 198.51.100.1 | grep -q offload
+	busywait "$TIMEOUT" wait_for_offload \
+		ip route show table local 198.51.100.1
 	check_err $?
 
 	log_test "vxlan decap route - local ports enslavement"
@@ -615,12 +626,14 @@ offload_indication_decap_route_test()
 	RET=0
 
 	ip link del dev br0
-	ip route show table local | grep 198.51.100.1 | grep -q offload
+	busywait "$TIMEOUT" wait_for_offload \
+		ip route show table local 198.51.100.1
 	check_err $?
 
 	ip link del dev br1
-	ip route show table local | grep 198.51.100.1 | grep -q offload
-	check_fail $?
+	busywait "$TIMEOUT" not wait_for_offload \
+		ip route show table local 198.51.100.1
+	check_err $?
 
 	log_test "vxlan decap route - bridge device deletion"
 
@@ -632,16 +645,19 @@ offload_indication_decap_route_test()
 	ip link set dev $swp2 master br1
 	ip link set dev vxlan0 master br0
 	ip link set dev vxlan1 master br1
-	ip route show table local | grep 198.51.100.1 | grep -q offload
+	busywait "$TIMEOUT" wait_for_offload \
+		ip route show table local 198.51.100.1
 	check_err $?
 
 	ip link del dev vxlan0
-	ip route show table local | grep 198.51.100.1 | grep -q offload
+	busywait "$TIMEOUT" wait_for_offload \
+		ip route show table local 198.51.100.1
 	check_err $?
 
 	ip link del dev vxlan1
-	ip route show table local | grep 198.51.100.1 | grep -q offload
-	check_fail $?
+	busywait "$TIMEOUT" not wait_for_offload \
+		ip route show table local 198.51.100.1
+	check_err $?
 
 	log_test "vxlan decap route - vxlan device deletion"
 
@@ -656,12 +672,15 @@ check_fdb_offloaded()
 	local mac=00:11:22:33:44:55
 	local zmac=00:00:00:00:00:00
 
-	bridge fdb show dev vxlan0 | grep $mac | grep self | grep -q offload
+	busywait "$TIMEOUT" wait_for_offload grep_bridge_fdb $mac self \
+		bridge fdb show dev vxlan0
 	check_err $?
-	bridge fdb show dev vxlan0 | grep $mac | grep master | grep -q offload
+	busywait "$TIMEOUT" wait_for_offload grep_bridge_fdb $mac master \
+		bridge fdb show dev vxlan0
 	check_err $?
 
-	bridge fdb show dev vxlan0 | grep $zmac | grep self | grep -q offload
+	busywait "$TIMEOUT" wait_for_offload grep_bridge_fdb $zmac self \
+		bridge fdb show dev vxlan0
 	check_err $?
 }
 
@@ -672,13 +691,15 @@ check_vxlan_fdb_not_offloaded()
 
 	bridge fdb show dev vxlan0 | grep $mac | grep -q self
 	check_err $?
-	bridge fdb show dev vxlan0 | grep $mac | grep self | grep -q offload
-	check_fail $?
+	busywait "$TIMEOUT" not wait_for_offload grep_bridge_fdb $mac self \
+		bridge fdb show dev vxlan0
+	check_err $?
 
 	bridge fdb show dev vxlan0 | grep $zmac | grep -q self
 	check_err $?
-	bridge fdb show dev vxlan0 | grep $zmac | grep self | grep -q offload
-	check_fail $?
+	busywait "$TIMEOUT" not wait_for_offload grep_bridge_fdb $zmac self \
+		bridge fdb show dev vxlan0
+	check_err $?
 }
 
 check_bridge_fdb_not_offloaded()
@@ -688,8 +709,9 @@ check_bridge_fdb_not_offloaded()
 
 	bridge fdb show dev vxlan0 | grep $mac | grep -q master
 	check_err $?
-	bridge fdb show dev vxlan0 | grep $mac | grep master | grep -q offload
-	check_fail $?
+	busywait "$TIMEOUT" not wait_for_offload grep_bridge_fdb $mac master \
+		bridge fdb show dev vxlan0
+	check_err $?
 }
 
 __offload_indication_join_vxlan_first()
@@ -771,12 +793,14 @@ __offload_indication_join_vxlan_last()
 
 	ip link set dev $swp1 master br0
 
-	bridge fdb show dev vxlan0 | grep $zmac | grep self | grep -q offload
-	check_fail $?
+	busywait "$TIMEOUT" not wait_for_offload grep_bridge_fdb $zmac self \
+		bridge fdb show dev vxlan0
+	check_err $?
 
 	ip link set dev vxlan0 master br0
 
-	bridge fdb show dev vxlan0 | grep $zmac | grep self | grep -q offload
+	busywait "$TIMEOUT" wait_for_offload grep_bridge_fdb $zmac self \
+		bridge fdb show dev vxlan0
 	check_err $?
 
 	log_test "offload indication - attach vxlan last"
@@ -866,8 +890,9 @@ sanitization_vlan_aware_test()
 	ip link set dev $swp1 master br0 &> /dev/null
 	check_fail $?
 
-	ip route show table local | grep 198.51.100.1 | grep -q offload
-	check_fail $?
+	busywait "$TIMEOUT" not wait_for_offload \
+		ip route show table local 198.51.100.1
+	check_err $?
 
 	log_test "vlan-aware - failed enslavement to bridge due to conflict"
 
@@ -929,11 +954,11 @@ offload_indication_vlan_aware_fdb_test()
 	bridge fdb add de:ad:be:ef:13:37 dev vxlan10 self master static \
 		dst 198.51.100.2 vlan 10
 
-	bridge fdb show brport vxlan10 | grep de:ad:be:ef:13:37 | grep self \
-		| grep -q offload
+	busywait "$TIMEOUT" wait_for_offload grep_bridge_fdb \
+		de:ad:be:ef:13:37 self bridge fdb show brport vxlan10
 	check_err $?
-	bridge fdb show brport vxlan10 | grep de:ad:be:ef:13:37 | grep -v self \
-		| grep -q offload
+	busywait "$TIMEOUT" wait_for_offload grep_bridge_fdb \
+		de:ad:be:ef:13:37 self -v bridge fdb show brport vxlan10
 	check_err $?
 
 	log_test "vxlan entry offload indication - initial state"
@@ -943,9 +968,9 @@ offload_indication_vlan_aware_fdb_test()
 	RET=0
 
 	bridge fdb del de:ad:be:ef:13:37 dev vxlan10 master vlan 10
-	bridge fdb show brport vxlan10 | grep de:ad:be:ef:13:37 | grep self \
-		| grep -q offload
-	check_fail $?
+	busywait "$TIMEOUT" not wait_for_offload grep_bridge_fdb \
+		de:ad:be:ef:13:37 self bridge fdb show brport vxlan10
+	check_err $?
 
 	log_test "vxlan entry offload indication - after removal from bridge"
 
@@ -954,11 +979,11 @@ offload_indication_vlan_aware_fdb_test()
 	RET=0
 
 	bridge fdb add de:ad:be:ef:13:37 dev vxlan10 master static vlan 10
-	bridge fdb show brport vxlan10 | grep de:ad:be:ef:13:37 | grep self \
-		| grep -q offload
+	busywait "$TIMEOUT" wait_for_offload grep_bridge_fdb \
+		de:ad:be:ef:13:37 self bridge fdb show brport vxlan10
 	check_err $?
-	bridge fdb show brport vxlan10 | grep de:ad:be:ef:13:37 | grep -v self \
-		| grep -q offload
+	busywait "$TIMEOUT" wait_for_offload grep_bridge_fdb \
+		de:ad:be:ef:13:37 self -v bridge fdb show brport vxlan10
 	check_err $?
 
 	log_test "vxlan entry offload indication - after re-add to bridge"
@@ -968,9 +993,9 @@ offload_indication_vlan_aware_fdb_test()
 	RET=0
 
 	bridge fdb del de:ad:be:ef:13:37 dev vxlan10 self
-	bridge fdb show brport vxlan10 | grep de:ad:be:ef:13:37 | grep -v self \
-		| grep -q offload
-	check_fail $?
+	busywait "$TIMEOUT" not wait_for_offload grep_bridge_fdb \
+		de:ad:be:ef:13:37 self -v bridge fdb show brport vxlan10
+	check_err $?
 
 	log_test "vxlan entry offload indication - after removal from vxlan"
 
@@ -979,11 +1004,11 @@ offload_indication_vlan_aware_fdb_test()
 	RET=0
 
 	bridge fdb add de:ad:be:ef:13:37 dev vxlan10 self dst 198.51.100.2
-	bridge fdb show brport vxlan10 | grep de:ad:be:ef:13:37 | grep self \
-		| grep -q offload
+	busywait "$TIMEOUT" wait_for_offload grep_bridge_fdb \
+		de:ad:be:ef:13:37 self bridge fdb show brport vxlan10
 	check_err $?
-	bridge fdb show brport vxlan10 | grep de:ad:be:ef:13:37 | grep -v self \
-		| grep -q offload
+	busywait "$TIMEOUT" wait_for_offload grep_bridge_fdb \
+		de:ad:be:ef:13:37 self -v bridge fdb show brport vxlan10
 	check_err $?
 
 	log_test "vxlan entry offload indication - after re-add to vxlan"
@@ -995,28 +1020,31 @@ offload_indication_vlan_aware_decap_route_test()
 {
 	RET=0
 
-	ip route show table local | grep 198.51.100.1 | grep -q offload
+	busywait "$TIMEOUT" wait_for_offload \
+		ip route show table local 198.51.100.1
 	check_err $?
 
 	# Toggle PVID flag on one VxLAN device and make sure route is still
 	# marked as offloaded
 	bridge vlan add vid 10 dev vxlan10 untagged
 
-	ip route show table local | grep 198.51.100.1 | grep -q offload
+	busywait "$TIMEOUT" wait_for_offload \
+		ip route show table local 198.51.100.1
 	check_err $?
 
 	# Toggle PVID flag on second VxLAN device and make sure route is no
 	# longer marked as offloaded
 	bridge vlan add vid 20 dev vxlan20 untagged
 
-	ip route show table local | grep 198.51.100.1 | grep -q offload
-	check_fail $?
+	busywait "$TIMEOUT" not wait_for_offload \
+		ip route show table local 198.51.100.1
+	check_err $?
 
 	# Toggle PVID flag back and make sure route is marked as offloaded
 	bridge vlan add vid 10 dev vxlan10 pvid untagged
 	bridge vlan add vid 20 dev vxlan20 pvid untagged
 
-	ip route show table local | grep 198.51.100.1 | grep -q offload
+	busywait "$TIMEOUT" wait_for_offload ip route show table local 198.51.100.1
 	check_err $?
 
 	log_test "vxlan decap route - vni map/unmap"
@@ -1069,33 +1097,33 @@ offload_indication_vlan_aware_l3vni_test()
 	ip link set dev vxlan0 master br0
 	bridge vlan add dev vxlan0 vid 10 pvid untagged
 
-	bridge fdb show brport vxlan0 | grep $zmac | grep self \
-		| grep -q offload
+	busywait "$TIMEOUT" wait_for_offload grep_bridge_fdb $zmac self \
+		bridge fdb show brport vxlan0
 	check_err $? "vxlan tunnel not offloaded when should"
 
 	# Configure a VLAN interface and make sure tunnel is offloaded
 	ip link add link br0 name br10 up type vlan id 10
 	sysctl_set net.ipv6.conf.br10.disable_ipv6 0
 	ip -6 address add 2001:db8:1::1/64 dev br10
-	bridge fdb show brport vxlan0 | grep $zmac | grep self \
-		| grep -q offload
+	busywait "$TIMEOUT" wait_for_offload grep_bridge_fdb $zmac self \
+		bridge fdb show brport vxlan0
 	check_err $? "vxlan tunnel not offloaded when should"
 
 	# Unlink the VXLAN device, make sure tunnel is no longer offloaded,
 	# then add it back to the bridge and make sure it is offloaded
 	ip link set dev vxlan0 nomaster
-	bridge fdb show brport vxlan0 | grep $zmac | grep self \
-		| grep -q offload
-	check_fail $? "vxlan tunnel offloaded after unlinked from bridge"
+	busywait "$TIMEOUT" not wait_for_offload grep_bridge_fdb $zmac self \
+		bridge fdb show brport vxlan0
+	check_err $? "vxlan tunnel offloaded after unlinked from bridge"
 
 	ip link set dev vxlan0 master br0
-	bridge fdb show brport vxlan0 | grep $zmac | grep self \
-		| grep -q offload
-	check_fail $? "vxlan tunnel offloaded despite no matching vid"
+	busywait "$TIMEOUT" not wait_for_offload grep_bridge_fdb $zmac self \
+		bridge fdb show brport vxlan0
+	check_err $? "vxlan tunnel offloaded despite no matching vid"
 
 	bridge vlan add dev vxlan0 vid 10 pvid untagged
-	bridge fdb show brport vxlan0 | grep $zmac | grep self \
-		| grep -q offload
+	busywait "$TIMEOUT" wait_for_offload grep_bridge_fdb $zmac self \
+		bridge fdb show brport vxlan0
 	check_err $? "vxlan tunnel not offloaded after adding vid"
 
 	log_test "vxlan - l3 vni"
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 5ea33c72f468..83fd15e3e545 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -248,6 +248,28 @@ busywait()
 	done
 }
 
+not()
+{
+	"$@"
+	[[ $? != 0 ]]
+}
+
+grep_bridge_fdb()
+{
+	local addr=$1; shift
+	local word
+	local flag
+
+	if [ "$1" == "self" ] || [ "$1" == "master" ]; then
+		word=$1; shift
+		if [ "$1" == "-v" ]; then
+			flag=$1; shift
+		fi
+	fi
+
+	$@ | grep $addr | grep $flag "$word"
+}
+
 wait_for_offload()
 {
 	"$@" | grep -q offload
-- 
2.21.1

