Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23EFB374497
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237141AbhEEQ6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:58:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236868AbhEEQzB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:55:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EFA861992;
        Wed,  5 May 2021 16:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232723;
        bh=sZURDu140O4z/6zp/lezuwLrla+Z+0BMu7Yr4aR4Sfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GTaxlvMiGXygUiNFIQ/xe/1pDgfgGD3Ikpj62yq5xqNC/s681M/THiin5LxZjX4/G
         /h36mg+kXz8WWH64prhscYl8rg59uS3E+vnWw9f1qSeL2M+5jC5awLEaKuZwfGUO22
         wFFhbN4hRceFcdznEO+yoXBBY7mJD8n3gVc6aapA9PZqBXYNQbewKX8RD895XXNMh5
         SbIJm7hPAo2/BrWEZdTXPjb+0VAyMUV2ofBbvEkGyebsRigQiKJHUjmOWFpPC5oB1n
         BI+VLbl0oJi948dXdF7Pam2mnNefuXysq1faI+iR6ONfvj1O1G73CrPcBToV6fKZcV
         I6sSOdSDqzOCQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petr Machata <petrm@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 78/85] selftests: mlxsw: Fix mausezahn invocation in ERSPAN scale test
Date:   Wed,  5 May 2021 12:36:41 -0400
Message-Id: <20210505163648.3462507-78-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit 1233898ab758cbcf5f6fea10b8dd16a0b2c24fab ]

The mirror_gre_scale test creates as many ERSPAN sessions as the underlying
chip supports, and tests that they all work. In order to determine that it
issues a stream of ICMP packets and checks if they are mirrored as
expected.

However, the mausezahn invocation missed the -6 flag to identify the use of
IPv6 protocol, and was sending ICMP messages over IPv6, as opposed to
ICMP6. It also didn't pass an explicit source IP address, which apparently
worked at some point in the past, but does not anymore.

To fix these issues, extend the function mirror_test() in mirror_lib by
detecting the IPv6 protocol addresses, and using a different ICMP scheme.
Fix __mirror_gre_test() in the selftest itself to pass a source IP address.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drivers/net/mlxsw/mirror_gre_scale.sh     |  3 ++-
 .../selftests/net/forwarding/mirror_lib.sh    | 19 +++++++++++++++++--
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/mirror_gre_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/mirror_gre_scale.sh
index 6f3a70df63bc..e00435753008 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/mirror_gre_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/mirror_gre_scale.sh
@@ -120,12 +120,13 @@ __mirror_gre_test()
 	sleep 5
 
 	for ((i = 0; i < count; ++i)); do
+		local sip=$(mirror_gre_ipv6_addr 1 $i)::1
 		local dip=$(mirror_gre_ipv6_addr 1 $i)::2
 		local htun=h3-gt6-$i
 		local message
 
 		icmp6_capture_install $htun
-		mirror_test v$h1 "" $dip $htun 100 10
+		mirror_test v$h1 $sip $dip $htun 100 10
 		icmp6_capture_uninstall $htun
 	done
 }
diff --git a/tools/testing/selftests/net/forwarding/mirror_lib.sh b/tools/testing/selftests/net/forwarding/mirror_lib.sh
index 13db1cb50e57..6406cd76a19d 100644
--- a/tools/testing/selftests/net/forwarding/mirror_lib.sh
+++ b/tools/testing/selftests/net/forwarding/mirror_lib.sh
@@ -20,6 +20,13 @@ mirror_uninstall()
 	tc filter del dev $swp1 $direction pref 1000
 }
 
+is_ipv6()
+{
+	local addr=$1; shift
+
+	[[ -z ${addr//[0-9a-fA-F:]/} ]]
+}
+
 mirror_test()
 {
 	local vrf_name=$1; shift
@@ -29,9 +36,17 @@ mirror_test()
 	local pref=$1; shift
 	local expect=$1; shift
 
+	if is_ipv6 $dip; then
+		local proto=-6
+		local type="icmp6 type=128" # Echo request.
+	else
+		local proto=
+		local type="icmp echoreq"
+	fi
+
 	local t0=$(tc_rule_stats_get $dev $pref)
-	$MZ $vrf_name ${sip:+-A $sip} -B $dip -a own -b bc -q \
-	    -c 10 -d 100msec -t icmp type=8
+	$MZ $proto $vrf_name ${sip:+-A $sip} -B $dip -a own -b bc -q \
+	    -c 10 -d 100msec -t $type
 	sleep 0.5
 	local t1=$(tc_rule_stats_get $dev $pref)
 	local delta=$((t1 - t0))
-- 
2.30.2

