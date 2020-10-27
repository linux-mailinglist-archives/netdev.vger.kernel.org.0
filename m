Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723CD29C817
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 20:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829221AbgJ0TB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 15:01:29 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36867 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S371396AbgJ0TAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 15:00:25 -0400
Received: by mail-wm1-f67.google.com with SMTP id c16so2552192wmd.2
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 12:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rXvOjoiXH/uQM8+37yEq6MrhKgtwR9L0eCrT9iLe6Qo=;
        b=OxLVWQZtWHZlEulGIv4IbCCbNIE6gv5fH5OiotJy3xUlgg589tHOt+uawVwbXKZbIx
         snj1C4jhT6jyqLp5+sU2OAEFt8jByqWjEbYqkgSsrnXNy8L0YXQMlP91joSQY7cpnJun
         cSaY7t0DuugTuLZXI8J904bPjZkD5x+Gj+n7w2VwnCrq3PrECOKew+v9cwQkqgEC3yJ7
         VSl6DQp5WpmkjgrcQJFkVVTDwxlkTcdo+/4PjrvswJ670GbRCPzxVCNVSV5oCeXCu6na
         1Jbwuud5wkAGyroCRHHS/iFhfGkMDMd1YyeelAR29PMr5sbyOF0Rqfza8qGEcpXintVb
         0QNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rXvOjoiXH/uQM8+37yEq6MrhKgtwR9L0eCrT9iLe6Qo=;
        b=bKfSivUjAXtBsJfL3STLtdjF/1vR4tVTo5XQ9/mqwMjVhmLmes6oKk9iN+w7mRIfj1
         u/3xHxmJhwiBlxeefKVeQEU08eHzI4EJwL7jyhgo9h7BI/zytrf/vm73T7xTDnWEexQz
         dc+DL2dZwu/vaW/LwlUmEekqnu7W0jKbdXuHraUnXZISzRa3U3otQw2mRxeoN/nO1bBH
         KpT0hHqku19+bjprHLwpApBBmdJuTbhbxrJVtRJNGP187F111cJUM09A2RujshimDEzh
         S/4ey/LzA1Qp2G8EIptQHo4Efc5LVLZucxcCAihLSOOJQ9+TC7vAX54rxpvy4IY+xXKK
         Ow5Q==
X-Gm-Message-State: AOAM530wv7YuiYHg7/FQIPagcOZ3o4PC1HwAcSNbIiVtDbRPqUmFbT6A
        FxJyK/0l6nKHNyncElmtDqfLOmSLp1911cpP
X-Google-Smtp-Source: ABdhPJwAcaW1ba5rriVUYmgUsDy++FgCYJBlbpV9zOSafij9Xtz9VWEdU0OfSNh/DKOasbFGUHRYmw==
X-Received: by 2002:a7b:c113:: with SMTP id w19mr4437014wmi.25.1603825222840;
        Tue, 27 Oct 2020 12:00:22 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x6sm3219803wmb.17.2020.10.27.12.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 12:00:22 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 14/16] selftests: net: bridge: add test for igmpv3 exc -> block report
Date:   Tue, 27 Oct 2020 20:59:32 +0200
Message-Id: <20201027185934.227040-15-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201027185934.227040-1-razor@blackwall.org>
References: <20201027185934.227040-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

The test checks for the following case:
   state          report        result                  action
 EXCLUDE (X,Y)  BLOCK (A)     EXCLUDE (X+(A-Y),Y)      (A-X-Y)=Group Timer
                                                       Send Q(G,A-Y)

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 .../selftests/net/forwarding/bridge_igmp.sh   | 30 ++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_igmp.sh b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
index 3772c7a066c9..45c5619666d8 100755
--- a/tools/testing/selftests/net/forwarding/bridge_igmp.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
@@ -3,7 +3,7 @@
 
 ALL_TESTS="v2reportleave_test v3include_test v3inc_allow_test v3inc_is_include_test \
 	   v3inc_is_exclude_test v3inc_to_exclude_test v3exc_allow_test v3exc_is_include_test \
-	   v3exc_is_exclude_test v3exc_to_exclude_test v3inc_block_test"
+	   v3exc_is_exclude_test v3exc_to_exclude_test v3inc_block_test v3exc_block_test"
 NUM_NETIFS=4
 CHECK_TC="yes"
 TEST_GROUP="239.10.10.10"
@@ -546,6 +546,34 @@ v3inc_block_test()
 	v3cleanup $swp1 $TEST_GROUP
 }
 
+v3exc_block_test()
+{
+	RET=0
+	local X=("192.0.2.1" "192.0.2.2" "192.0.2.30")
+	local Y=("192.0.2.20" "192.0.2.21")
+
+	v3exclude_prepare $h1 $ALL_MAC $ALL_GROUP
+
+	ip link set dev br0 type bridge mcast_last_member_interval 500
+	check_err $? "Could not change mcast_last_member_interval to 5s"
+
+	$MZ $h1 -c 1 -b $ALL_MAC -B $ALL_GROUP -t ip "proto=2,p=$MZPKT_BLOCK" -q
+	sleep 1
+	check_sg_entries "block" "${X[@]}" "${Y[@]}"
+
+	check_sg_state 0 "${X[@]}"
+	check_sg_state 1 "${Y[@]}"
+
+	check_sg_fwding 1 "${X[@]}" 192.0.2.100
+	check_sg_fwding 0 "${Y[@]}"
+
+	log_test "IGMPv3 report $TEST_GROUP exclude -> block"
+
+	ip link set dev br0 type bridge mcast_last_member_interval 100
+
+	v3cleanup $swp1 $TEST_GROUP
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.25.4

