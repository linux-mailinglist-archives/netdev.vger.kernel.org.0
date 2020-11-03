Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950362A4CC8
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728922AbgKCRYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:24:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728858AbgKCRYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:24:36 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3966FC061A04
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 09:24:36 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id h62so91183wme.3
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 09:24:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LpHznR+IRzgzH6in5jT7JKWaQCGzhh8Iu4vmSBYkhkE=;
        b=tcBSgeO6Y6En6bJnm5gjagFeSQzIw2tQJ55bKAjwjyblN3cms+MzI0JryX7VsHZ0ER
         DV9UwwGbFCmrrzXu8Vt9sEUiM7Ut8M5lbWHAXWs+QQF6RsiiD4gjJjrQDt3AohxNlVq0
         1PfbySXy8TZ2UnhLlXNnEruuk8Gea+RKHpgift8LJ2sBLowOCqm9lbe3R6WmeDAGlsJk
         4l0ByErFqMZliMwgtq53bgGPOmQf/1RkG+i0m09Hwsmy4uuRQYkAtzwzsedzq9qEr46T
         b1AKginq/caTTSUS7Hq0WOdY7oDypFT269EmLeniwce5xnbgtxMmFS9on43WqLh47GG3
         m2gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LpHznR+IRzgzH6in5jT7JKWaQCGzhh8Iu4vmSBYkhkE=;
        b=hbd4L80o2scZkAV+x5XEhlPbXVCctktwOeUwPW30YW1WQRM+FBnn2ftIvlh6t/Fz6J
         ChwrtJrPgHd7s7UOIIdYyLA5gUaOLFNJbgtjelcP/go6JRuJdK4lC3v1s4oagf2tfOeh
         QEBt0byN+uuIpIuAwM2MiviulpLGLn36/SPJguU7LE0l3wVcHvkspQpyKt4VUfS+HIwb
         2veeyoH4arE5P87uflhgLOEPRrIi80/p6f9xtA1IToE95SOH3fIKT+KM4x2Jn8pjGTzH
         FiYEI3dFlZ4iZc+CbFgowDVQs0qx6ngl8woqGQ9ZO6MJy8iZkMaKj8/IPuWmoNeh5ud7
         32xQ==
X-Gm-Message-State: AOAM532tGTyCjQIbNV01M1ZDl7queQlDpgMoux/BpxyZys6v/h9k+1O4
        cVVebIJGu2z+xOmxHgEYgjx/djfT0NcndTmo
X-Google-Smtp-Source: ABdhPJzlowO5W6emfveN52bPRVddvBFLSj8d6aR76y/8zs3oN46MDdf4d8XaW0c3FaLbvwaZEN/Q7g==
X-Received: by 2002:a1c:87:: with SMTP id 129mr249691wma.34.1604424271757;
        Tue, 03 Nov 2020 09:24:31 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id a128sm2650795wmf.5.2020.11.03.09.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 09:24:31 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 14/16] selftests: net: bridge: add test for mldv2 exc -> block report
Date:   Tue,  3 Nov 2020 19:24:10 +0200
Message-Id: <20201103172412.1044840-15-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201103172412.1044840-1-razor@blackwall.org>
References: <20201103172412.1044840-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

The test checks for the following case:
   Router State  Report Received  New Router State     Actions
   EXCLUDE (X,Y)   BLOCK (A)      EXCLUDE (X+(A-Y),Y)  (A-X-Y) =
                                                            Filter Timer
                                                       Send Q(MA,A-Y)

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 .../selftests/net/forwarding/bridge_mld.sh    | 31 ++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_mld.sh b/tools/testing/selftests/net/forwarding/bridge_mld.sh
index a3c405b2fd6f..c498e51b8d2b 100755
--- a/tools/testing/selftests/net/forwarding/bridge_mld.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_mld.sh
@@ -3,7 +3,8 @@
 
 ALL_TESTS="mldv2include_test mldv2inc_allow_test mldv2inc_is_include_test mldv2inc_is_exclude_test \
 	   mldv2inc_to_exclude_test mldv2exc_allow_test mldv2exc_is_include_test \
-	   mldv2exc_is_exclude_test mldv2exc_to_exclude_test mldv2inc_block_test"
+	   mldv2exc_is_exclude_test mldv2exc_to_exclude_test mldv2inc_block_test \
+	   mldv2exc_block_test"
 NUM_NETIFS=4
 CHECK_TC="yes"
 TEST_GROUP="ff02::cc"
@@ -444,6 +445,34 @@ mldv2inc_block_test()
 	mldv2cleanup $swp1
 }
 
+mldv2exc_block_test()
+{
+	RET=0
+	local X=("2001:db8:1::1" "2001:db8:1::2" "2001:db8:1::30")
+	local Y=("2001:db8:1::20" "2001:db8:1::21")
+
+	mldv2exclude_prepare $h1
+
+	ip link set dev br0 type bridge mcast_last_member_interval 500
+	check_err $? "Could not change mcast_last_member_interval to 5s"
+
+	$MZ $h1 -c 1 $MZPKT_BLOCK -q
+	sleep 1
+	brmcast_check_sg_entries "block" "${X[@]}" "${Y[@]}"
+
+	brmcast_check_sg_state 0 "${X[@]}"
+	brmcast_check_sg_state 1 "${Y[@]}"
+
+	brmcast_check_sg_fwding 1 "${X[@]}" 2001:db8:1::100
+	brmcast_check_sg_fwding 0 "${Y[@]}"
+
+	log_test "MLDv2 report $TEST_GROUP exclude -> block"
+
+	ip link set dev br0 type bridge mcast_last_member_interval 100
+
+	mldv2cleanup $swp1
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.25.4

