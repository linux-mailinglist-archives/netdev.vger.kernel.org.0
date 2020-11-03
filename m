Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 159342A4CBA
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728851AbgKCRYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:24:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728805AbgKCRYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:24:31 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441B4C061A04
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 09:24:31 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id 205so85575wma.4
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 09:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5omufXisHiGeceucrVlpU04whsxgLcRcTFbs2Kn5Krg=;
        b=PwZpr/Cg4gZJf7QDpiN8c3rht0+scf85e7FTrVdSxG1DxBtvGNn771zi2rtjHbQLjc
         jAAPWayS9osj34H+tRvUj5W/LJjOtzVGz7+NO5g3lS9cOedTFZxZR/nSmakaxIa+8g07
         k8GujvckHla5iZNh5hnB0vgf4AtOCKfyrJ6ZrmSMMzF3dCBkpylhOICfwcJjugXaRW/L
         98GC5r6Q1yKiXB5dcjUSRDSNQ8V5SLcM7Saf2rSIxuP50PamOQlfWLw3TuysLZwCHczC
         n7LO7ErGEpfyY2hx+sa1hctfg4YL+vWtQrL2lOAxs2STUWGc6Kak0mxLqScLO+ekR4HP
         Cibw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5omufXisHiGeceucrVlpU04whsxgLcRcTFbs2Kn5Krg=;
        b=grcRtmTyGcYHbmrXkd1ESWOe8pWpI3tVEmnBBSQX7vRAkgR5CR+lOv4mlwkCug3U3j
         VQQV3IQ+L0k6GnXvcUAPsKXk2Y+xpyoyOxJbE6gy4Lz+Fddu2oFBUwUZjcaN/vQrzzXS
         F/S5wToVcnplkD5XUBvNPyx7cSFLNQTOxHniBHXLIP5VKXJABERjiZTT+okEnfXegxGA
         u86u+3ZEhLEpV0Bb6u1nVit/UzFIch62HjA+S5ZWDoXDn5yGew2bEzU2PmoRDMSV5Qlt
         /wUKPDUiqBAGZDzLnopV6TXM+fxxkhq/7FiHMHYVONVRg3vqDgDQaMZ0oy0ZbFb3lPDU
         voig==
X-Gm-Message-State: AOAM530O56veKRL9iBeeJxKOxkzkU5IIi7lyUyHuePpE2b160SqWf8L5
        AvlCvUUUazzTu0wQdNkHwQorh/63o5HgB+Nz
X-Google-Smtp-Source: ABdhPJw7YQqxc9h1LI4jJ/h8YilAjdO7Rc52iqX6kaQXnBVSruC7At7I/tgH9CKGpoR/qOZ8NvJQOw==
X-Received: by 2002:a1c:2c2:: with SMTP id 185mr178744wmc.103.1604424269694;
        Tue, 03 Nov 2020 09:24:29 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id a128sm2650795wmf.5.2020.11.03.09.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 09:24:29 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 12/16] selftests: net: bridge: add test for mldv2 exc -> to_exclude report
Date:   Tue,  3 Nov 2020 19:24:08 +0200
Message-Id: <20201103172412.1044840-13-razor@blackwall.org>
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
   EXCLUDE (X,Y)   TO_EX (A)      EXCLUDE (A-Y,Y*A)    (A-X-Y) =
                                                            Filter Timer
                                                       Delete (X-A)
                                                       Delete (Y-A)
                                                       Send Q(MA,A-Y)
                                                       Filter Timer=MALI

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 .../selftests/net/forwarding/bridge_mld.sh    | 30 ++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_mld.sh b/tools/testing/selftests/net/forwarding/bridge_mld.sh
index 0f48c8da041b..024fa22fa3c2 100755
--- a/tools/testing/selftests/net/forwarding/bridge_mld.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_mld.sh
@@ -3,7 +3,7 @@
 
 ALL_TESTS="mldv2include_test mldv2inc_allow_test mldv2inc_is_include_test mldv2inc_is_exclude_test \
 	   mldv2inc_to_exclude_test mldv2exc_allow_test mldv2exc_is_include_test \
-	   mldv2exc_is_exclude_test"
+	   mldv2exc_is_exclude_test mldv2exc_to_exclude_test"
 NUM_NETIFS=4
 CHECK_TC="yes"
 TEST_GROUP="ff02::cc"
@@ -381,6 +381,34 @@ mldv2exc_is_exclude_test()
 	mldv2cleanup $swp1
 }
 
+mldv2exc_to_exclude_test()
+{
+	RET=0
+	local X=("2001:db8:1::1" "2001:db8:1::30")
+	local Y=("2001:db8:1::20")
+
+	mldv2exclude_prepare $h1
+
+	ip link set dev br0 type bridge mcast_last_member_interval 500
+	check_err $? "Could not change mcast_last_member_interval to 5s"
+
+	$MZ $h1 -c 1 $MZPKT_TO_EXC -q
+	sleep 1
+	brmcast_check_sg_entries "to_exclude" "${X[@]}" "${Y[@]}"
+
+	brmcast_check_sg_state 0 "${X[@]}"
+	brmcast_check_sg_state 1 "${Y[@]}"
+
+	brmcast_check_sg_fwding 1 "${X[@]}" 2001:db8:1::100
+	brmcast_check_sg_fwding 0 "${Y[@]}"
+
+	log_test "MLDv2 report $TEST_GROUP exclude -> to_exclude"
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

