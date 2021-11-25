Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9697945DC18
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 15:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355714AbhKYOOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 09:14:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355611AbhKYOMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 09:12:54 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE076C0613E1
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 06:09:27 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id r25so26155089edq.7
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 06:09:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DYxPRHRLEYcQrka7MbONriR7V5sW93K2rC+A+CbWUo0=;
        b=16Km5yqD1Jq7DqqEExTSa8dTgydtuWXkbRI5Ua4QUtOuXqQSDk5JBX9Kk+rxevcQDN
         k+xgovQkOr0B9aF8hdIj9f6KCj9srlwk0EmuIYDCBqQ7dCA759Rlo831pOZek6OViGie
         nzORFaOJDeHw9EtShM7FVXaEw4tHSWGa0dSoNA0+7LCrL8phbzO2DisADNWu9nI6uVM/
         Ff1cnAuwnDtcX+pfb+tCm2V58UQBwDtzplViNpHLL4Pa6SOsmQGXOM8RQLSg+pW6ZsGC
         YqT88vZLmuI9D4gufEHFMqx8a1+paH+s35KH4LtVjNIGy+NKxulKQCsAqCwni3W8JPhd
         0jBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DYxPRHRLEYcQrka7MbONriR7V5sW93K2rC+A+CbWUo0=;
        b=og7B0u/3Gn2xs1W4p64kDtCuIjQGVhcUu3mDbJ24oDjzBRhuWnuPLdIOkCMI4r4R+w
         VnuM5rFO/G1AHcSNW/2okFWU/6uShWKNaTWdpsEppruohjpxjZk4UXJA5d+P48JBnwSU
         XEs89qQr0/bLgu9sv3HXj6mP7169+yd34ZLgGeW8WGtcsEpD/HH2B72OZ4Wbhk3221Ku
         RA4MKS7hW8K4EsnUKjjQ/ds1nMcToBZ3gu+VtIXbjZdaG8AeVQPZMNEJU07V9pT8mxfx
         dOtH2aK4SQD9I8nEmKFCFwl2iarvu5ip6xguu8IMPUJj2L/9kvoNcOyUc2vorcHOEqkE
         R0BA==
X-Gm-Message-State: AOAM533m8MEuGhvXw4yoeug3SSImblSQBJpa5OhW610APRZWn6HtThrT
        Wy2c15jqCAjE47jnT9obYOmjYK2cLO48u7pa
X-Google-Smtp-Source: ABdhPJzlFtYQnVuZVy5yHi28cZn17LwIKrH5XB4Kpl+/O4mXZh1KAREofI4NpQNHAV7OqqaIwJxb4Q==
X-Received: by 2002:a05:6402:84f:: with SMTP id b15mr37664622edz.323.1637849366194;
        Thu, 25 Nov 2021 06:09:26 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id sc7sm1889863ejc.50.2021.11.25.06.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 06:09:25 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, ivecera@redhat.com,
        bridge@lists.linux-foundation.org, davem@davemloft.net,
        kuba@kernel.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 07/10] selftests: net: bridge: add vlan mcast_querier_interval tests
Date:   Thu, 25 Nov 2021 16:08:55 +0200
Message-Id: <20211125140858.3639139-8-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211125140858.3639139-1-razor@blackwall.org>
References: <20211125140858.3639139-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add tests which change the new per-vlan mcast_querier_interval and
verify that it is taken into account when an outside querier is present.

TEST: Vlan mcast_querier_interval global option default value       [ OK ]
TEST: Vlan 10 mcast_querier_interval option changed to 100          [ OK ]
TEST: Vlan 10 mcast_querier_interval expire after outside query     [ OK ]

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 .../net/forwarding/bridge_vlan_mcast.sh       | 40 ++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh b/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh
index 87dcd49b0a8d..9a68d56fd74c 100755
--- a/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh
@@ -2,7 +2,8 @@
 # SPDX-License-Identifier: GPL-2.0
 
 ALL_TESTS="vlmc_control_test vlmc_querier_test vlmc_igmp_mld_version_test \
-	   vlmc_last_member_test vlmc_startup_query_test vlmc_membership_test"
+	   vlmc_last_member_test vlmc_startup_query_test vlmc_membership_test \
+	   vlmc_querier_intvl_test"
 NUM_NETIFS=4
 CHECK_TC="yes"
 TEST_GROUP="239.10.10.10"
@@ -384,6 +385,43 @@ vlmc_membership_test()
 	bridge vlan global set vid 10 dev br0 mcast_snooping 1 mcast_membership_interval 26000
 }
 
+vlmc_querier_intvl_test()
+{
+	RET=0
+	local goutput=`bridge -j vlan global show`
+	echo -n $goutput |
+		jq -e ".[].vlans[] | select(.vlan == 10)" &>/dev/null
+	check_err $? "Could not find vlan 10's global options"
+
+	echo -n $goutput |
+		jq -e ".[].vlans[] | select(.vlan == 10 and \
+					    .mcast_querier_interval == 25500) " &>/dev/null
+	check_err $? "Wrong default mcast_querier_interval global vlan option value"
+	log_test "Vlan mcast_querier_interval global option default value"
+
+	RET=0
+	bridge vlan global set vid 10 dev br0 mcast_snooping 1 mcast_querier_interval 100
+	check_err $? "Could not set mcast_querier_interval in vlan 10"
+	log_test "Vlan 10 mcast_querier_interval option changed to 100"
+
+	RET=0
+	ip link add dev br1 type bridge mcast_snooping 1 mcast_querier 1 vlan_filtering 1 \
+					mcast_vlan_snooping 1
+	bridge vlan add vid 10 dev br1 self pvid untagged
+	ip link set dev $h1 master br1
+	ip link set dev br1 up
+	bridge vlan add vid 10 dev $h1 master
+	bridge vlan global set vid 10 dev br1 mcast_snooping 1 mcast_querier 1
+	sleep 2
+	ip link del dev br1
+	ip addr replace 2001:db8:1::1/64 dev $h1
+	vlmc_check_query igmp 2 $swp1 1 1
+	check_err $? "Wrong number of IGMPv2 general queries after querier interval"
+	log_test "Vlan 10 mcast_querier_interval expire after outside query"
+
+	bridge vlan global set vid 10 dev br0 mcast_snooping 1 mcast_querier_interval 25500
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.31.1

