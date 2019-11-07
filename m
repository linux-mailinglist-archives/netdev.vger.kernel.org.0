Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAAB7F3749
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 19:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfKGSdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 13:33:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:56724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725823AbfKGSdB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 13:33:01 -0500
Received: from localhost.localdomain (unknown [157.245.11.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE9EB214D8;
        Thu,  7 Nov 2019 18:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573151581;
        bh=Mpr2j47DEtBTnHEBL3n2nmd3d4DK8AvWcjTIwGhD8IM=;
        h=From:To:Cc:Subject:Date:From;
        b=y5DAu2db5uwnn587axLF8E6KGs8EJagssBWh/FF+ImTnCnTn46fAAYdIgEZU5JkDl
         snqJsHqsSJad9eipVqvLd0RU1/91d5a3H16cj+WDavAOIje6KLNbuxUsTOEr9lTFju
         duDDve5e030yaOzryRtO/sgwvyzbeP2fpNa8xWxc=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>
Subject: [PATCH net-next] selftests: Add source route tests to fib_tests
Date:   Thu,  7 Nov 2019 18:32:32 +0000
Message-Id: <20191107183232.4510-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests to verify routes with source address set are deleted when
source address is deleted.

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 tools/testing/selftests/net/fib_tests.sh | 52 +++++++++++++++++++++++-
 1 file changed, 51 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index 76c1897e6352..dd35b7071b8b 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -9,7 +9,7 @@ ret=0
 ksft_skip=4
 
 # all tests in this script. Can be overridden with -t option
-TESTS="unregister down carrier nexthop suppress ipv6_rt ipv4_rt ipv6_addr_metric ipv4_addr_metric ipv6_route_metrics ipv4_route_metrics ipv4_route_v6_gw rp_filter"
+TESTS="unregister down carrier nexthop suppress ipv6_rt ipv4_rt ipv6_addr_metric ipv4_addr_metric ipv6_route_metrics ipv4_route_metrics ipv4_route_v6_gw rp_filter ipv4_del_addr"
 
 VERBOSE=0
 PAUSE_ON_FAIL=no
@@ -1500,6 +1500,55 @@ ipv4_route_metrics_test()
 	route_cleanup
 }
 
+ipv4_del_addr_test()
+{
+	echo
+	echo "IPv4 delete address route tests"
+
+	setup
+
+	set -e
+	$IP li add dummy1 type dummy
+	$IP li set dummy1 up
+	$IP li add dummy2 type dummy
+	$IP li set dummy2 up
+	$IP li add red type vrf table 1111
+	$IP li set red up
+	$IP ro add vrf red unreachable default 
+	$IP li set dummy2 vrf red
+
+	$IP addr add dev dummy1 172.16.104.1/24
+	$IP addr add dev dummy1 172.16.104.11/24
+	$IP addr add dev dummy2 172.16.104.1/24
+	$IP addr add dev dummy2 172.16.104.11/24
+	$IP route add 172.16.105.0/24 via 172.16.104.2 src 172.16.104.11
+	$IP route add vrf red 172.16.105.0/24 via 172.16.104.2 src 172.16.104.11
+	set +e
+
+	# removing address from device in vrf should only remove route from vrf table
+	$IP addr del dev dummy2 172.16.104.11/24
+	$IP ro ls vrf red | grep -q 172.16.105.0/24
+	log_test $? 1 "Route removed from VRF when source address deleted"
+
+	$IP ro ls | grep -q 172.16.105.0/24
+	log_test $? 0 "Route in default VRF not removed"
+
+	$IP addr add dev dummy2 172.16.104.11/24
+	$IP route add vrf red 172.16.105.0/24 via 172.16.104.2 src 172.16.104.11
+
+	$IP addr del dev dummy1 172.16.104.11/24
+	$IP ro ls | grep -q 172.16.105.0/24
+	log_test $? 1 "Route removed in default VRF when source address deleted"
+
+	$IP ro ls vrf red | grep -q 172.16.105.0/24
+	log_test $? 0 "Route in VRF is not removed by address delete"
+
+	$IP li del dummy1
+	$IP li del dummy2
+	cleanup
+}
+
+
 ipv4_route_v6_gw_test()
 {
 	local rc
@@ -1633,6 +1682,7 @@ do
 	ipv4_route_test|ipv4_rt)	ipv4_route_test;;
 	ipv6_addr_metric)		ipv6_addr_metric_test;;
 	ipv4_addr_metric)		ipv4_addr_metric_test;;
+	ipv4_del_addr)			ipv4_del_addr_test;;
 	ipv6_route_metrics)		ipv6_route_metrics_test;;
 	ipv4_route_metrics)		ipv4_route_metrics_test;;
 	ipv4_route_v6_gw)		ipv4_route_v6_gw_test;;
-- 
2.21.0

