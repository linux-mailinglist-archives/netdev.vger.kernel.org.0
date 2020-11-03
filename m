Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B61C2A4CA8
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbgKCRYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:24:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728550AbgKCRYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:24:19 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F9EC0617A6
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 09:24:19 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id p22so99244wmg.3
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 09:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xBm95jl2xW7HhQ7hwk4jZB0S0Y7wQfebO/eBHZqjNWo=;
        b=MqzUiWrQhY5xpB2YoBUurz8HpgeL4rD0U/WPxFKSRrv83ZBc6jSVrCVdx8rk/Pq3CS
         I8jdO2PTuajjv7UegAo7D6AnccQFOkWAOSDQ+SiLDG4OTFynJhx9izQO2/nbr1dQQBxE
         3yoq7NqaeFfhln1CNJOI067Zqmcpd0Vy8xWAtJ0jGRx/BywDQHiGY1jnPA1cfSpUaV7m
         USgfyueHQ64pmPimxsOsz9h9IQYUzAOGDKAdXg+78ZOkiz++2HeXCnpf0C9Bb5z/Kleb
         lfYzoLM8Wk3DAGSHOTUjMsEumGKT7h5t7r4GuBb8e30w0K4wUi78bmE6r9QASRUP5L+L
         kvpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xBm95jl2xW7HhQ7hwk4jZB0S0Y7wQfebO/eBHZqjNWo=;
        b=UQFlzdgSnsDGYBxUjGTCfV9QT9YOXAwOS+btXLRGNNv+aZajx3raqsGN8bv42bib7M
         xDPa0JGfLnFd8uEEFnMSMahXAv17Mcdl8vGcIoSF+7a7AT1HHGu00gwR+Mf6z+umgepj
         z1T7Ir1eEStvN6w0Bf2tZ4r6YatiOAO0BHY6bA6akKxqwvZumjngZ1X2aN4wRrBXS4qq
         OOSerzexO7aJkL0t+iRTJvkce98CgqURSW93TqjUo0JUjqaI1+fcoeDU4CnqaJ0ltbum
         dOUifiZXNMbumSeKdS+gGhKYAe/pC6UDzxNEDbBFJgPTs7qqQ6HFbfJLnkRR/plR34Pm
         /j7w==
X-Gm-Message-State: AOAM532xJaq9qyz0bHAUJcOvH7kvVbZHZJKbMmeTIZNeTw7+PPa3UlW7
        656Ci+NLTiXQQrSrVjvNvZuNO7M9d+c5oaOr
X-Google-Smtp-Source: ABdhPJwCmHQRlzOe8Sz/VWtIyaNseKz0zgnrUmtmbUdUByHCZrPtIFFD6fMCz/oy1M+X9RNK7nhj8A==
X-Received: by 2002:a7b:cd92:: with SMTP id y18mr202822wmj.178.1604424258113;
        Tue, 03 Nov 2020 09:24:18 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id a128sm2650795wmf.5.2020.11.03.09.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 09:24:17 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 01/16] selftests: net: bridge: factor out mcast_packet_test
Date:   Tue,  3 Nov 2020 19:23:57 +0200
Message-Id: <20201103172412.1044840-2-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201103172412.1044840-1-razor@blackwall.org>
References: <20201103172412.1044840-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Factor out mcast_packet_test into lib.sh so it can be later extended and
reused by MLDv2 tests.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 .../selftests/net/forwarding/bridge_igmp.sh   | 32 -------------------
 tools/testing/selftests/net/forwarding/lib.sh | 32 +++++++++++++++++++
 2 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_igmp.sh b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
index 0e71abdd7a03..50a48ce16ba1 100755
--- a/tools/testing/selftests/net/forwarding/bridge_igmp.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
@@ -105,38 +105,6 @@ cleanup()
 	vrf_cleanup
 }
 
-# return 0 if the packet wasn't seen on host2_if or 1 if it was
-mcast_packet_test()
-{
-	local mac=$1
-	local src_ip=$2
-	local ip=$3
-	local host1_if=$4
-	local host2_if=$5
-	local seen=0
-
-	# Add an ACL on `host2_if` which will tell us whether the packet
-	# was received by it or not.
-	tc qdisc add dev $host2_if ingress
-	tc filter add dev $host2_if ingress protocol ip pref 1 handle 101 \
-		flower ip_proto udp dst_mac $mac action drop
-
-	$MZ $host1_if -c 1 -p 64 -b $mac -A $src_ip -B $ip -t udp "dp=4096,sp=2048" -q
-	sleep 1
-
-	tc -j -s filter show dev $host2_if ingress \
-		| jq -e ".[] | select(.options.handle == 101) \
-		| select(.options.actions[0].stats.packets == 1)" &> /dev/null
-	if [[ $? -eq 0 ]]; then
-		seen=1
-	fi
-
-	tc filter del dev $host2_if ingress protocol ip pref 1 handle 101 flower
-	tc qdisc del dev $host2_if ingress
-
-	return $seen
-}
-
 v2reportleave_test()
 {
 	RET=0
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 927f9ba49e08..bb3ccc6d2165 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -1270,3 +1270,35 @@ tcpdump_show()
 {
 	tcpdump -e -n -r $capfile 2>&1
 }
+
+# return 0 if the packet wasn't seen on host2_if or 1 if it was
+mcast_packet_test()
+{
+	local mac=$1
+	local src_ip=$2
+	local ip=$3
+	local host1_if=$4
+	local host2_if=$5
+	local seen=0
+
+	# Add an ACL on `host2_if` which will tell us whether the packet
+	# was received by it or not.
+	tc qdisc add dev $host2_if ingress
+	tc filter add dev $host2_if ingress protocol ip pref 1 handle 101 \
+		flower ip_proto udp dst_mac $mac action drop
+
+	$MZ $host1_if -c 1 -p 64 -b $mac -A $src_ip -B $ip -t udp "dp=4096,sp=2048" -q
+	sleep 1
+
+	tc -j -s filter show dev $host2_if ingress \
+		| jq -e ".[] | select(.options.handle == 101) \
+		| select(.options.actions[0].stats.packets == 1)" &> /dev/null
+	if [[ $? -eq 0 ]]; then
+		seen=1
+	fi
+
+	tc filter del dev $host2_if ingress protocol ip pref 1 handle 101 flower
+	tc qdisc del dev $host2_if ingress
+
+	return $seen
+}
-- 
2.25.4

