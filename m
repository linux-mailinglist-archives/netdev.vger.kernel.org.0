Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2722A4CB9
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbgKCRYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:24:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728821AbgKCRYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:24:30 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3908FC0617A6
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 09:24:30 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id k10so18044275wrw.13
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 09:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AljBPvTdQf08XgUiIoBG1AwZ1XMPoLbTfc2XOI1hK4I=;
        b=ra/PTyyeu8IP583NglFaT/w2Y+hX1bR4M8Ces4suL/MKzK3BjelRqYWbEyqEdC62mG
         XIJ6M8hfQMUZ/d0hy5fKBHU/nKii8vAaSvVvdPiulClGgTpzCLRRuZDSNufLascVFcDr
         SrMeqMuYXiXmEuyh8jYrIr9C3c6wWmt9ZMOvnILWSW7l99U6MSa4GRuH6D+GLxzof+mD
         dj7QW96HoRBFEH4N+2fbB338XlohxGv7JHn7Okr3mMUMP7OQO/QPKMt50EdxRjnmI8d9
         BFFU7yQANd1K8vR+73EtYRbOCfwlvQHumLDxByIYZvJjjNoxemgt7o/pH+y/SwkEnlKy
         IiIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AljBPvTdQf08XgUiIoBG1AwZ1XMPoLbTfc2XOI1hK4I=;
        b=PwmZnOVmPKdiIwc2C6Wuz/R0pGh8qf8kmTT1JzZaVvL9OFLoa3A5DSHO/ZQjTrGzXQ
         ZywrclAsGdvLkijP1//HKOC0Rnnkst1a689dc8eHblYQj5kNQOANXnBg2swe2+QaY101
         NvX/MCPhC3L0lmqktvw7j2QgqI7UjrytQkP9DzwKGcbEUls4mM1as1UThD4+6bDJRTad
         zBuRgd6+1oJ8r8LRtzIOF7gTSXxxYFQ32SogxgCMZfrsPR/8ghLawBqt2wIG9XfFuC5c
         JOAAuOeIEHOTI254aDewGjSVBGLofO7WmLIgN7WkppKdd/GZktE3t32yddFYWX37qNIe
         NuOA==
X-Gm-Message-State: AOAM532Y55tZc/cf4OdfQF7jM7J8v4s7TLO8dEzerIH4betJ2FzQom7I
        zclWHj6Wt040GrmiXnjE1hpCdDQkfm2emvpI
X-Google-Smtp-Source: ABdhPJzxju+OoCNsm/myW1fJHM1rJ6XDMcMA+Zfftps4C2FxNErZNUaDrVR3ljaqYxCjM6mVx2J+9g==
X-Received: by 2002:adf:f185:: with SMTP id h5mr12152550wro.10.1604424268647;
        Tue, 03 Nov 2020 09:24:28 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id a128sm2650795wmf.5.2020.11.03.09.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 09:24:28 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 11/16] selftests: net: bridge: add test for mldv2 exc -> is_exclude report
Date:   Tue,  3 Nov 2020 19:24:07 +0200
Message-Id: <20201103172412.1044840-12-razor@blackwall.org>
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
   EXCLUDE (X,Y)     IS_EX (A)     EXCLUDE (A-Y, Y*A)  (A-X-Y)=MALI
                                                       Delete (X-A)
                                                       Delete (Y-A)
                                                       Filter Timer=MALI

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 .../selftests/net/forwarding/bridge_mld.sh    | 31 ++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_mld.sh b/tools/testing/selftests/net/forwarding/bridge_mld.sh
index bae865b5bc8c..0f48c8da041b 100755
--- a/tools/testing/selftests/net/forwarding/bridge_mld.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_mld.sh
@@ -2,7 +2,8 @@
 # SPDX-License-Identifier: GPL-2.0
 
 ALL_TESTS="mldv2include_test mldv2inc_allow_test mldv2inc_is_include_test mldv2inc_is_exclude_test \
-	   mldv2inc_to_exclude_test mldv2exc_allow_test mldv2exc_is_include_test"
+	   mldv2inc_to_exclude_test mldv2exc_allow_test mldv2exc_is_include_test \
+	   mldv2exc_is_exclude_test"
 NUM_NETIFS=4
 CHECK_TC="yes"
 TEST_GROUP="ff02::cc"
@@ -42,6 +43,11 @@ MZPKT_IS_EXC="33:33:00:00:00:01:fe:54:00:04:5e:ba:86:dd:60:0a:2d:ae:00:64:00:01:
 00:00:00:8f:00:5f:d0:00:00:00:01:02:00:00:04:ff:02:00:00:00:00:00:00:00:00:00:00:00:00:00:cc:20:\
 01:0d:b8:00:01:00:00:00:00:00:00:00:00:00:01:20:01:0d:b8:00:01:00:00:00:00:00:00:00:00:00:02:20:\
 01:0d:b8:00:01:00:00:00:00:00:00:00:00:00:20:20:01:0d:b8:00:01:00:00:00:00:00:00:00:00:00:21"
+# MLDv2 is_ex report: grp ff02::cc is_exclude 2001:db8:1::20,2001:db8:1::30
+MZPKT_IS_EXC2="33:33:00:00:00:01:fe:54:00:04:5e:ba:86:dd:60:0a:2d:ae:00:44:00:01:fe:80:00:00:00:\
+00:00:00:fc:54:00:ff:fe:04:5e:ba:ff:02:00:00:00:00:00:00:00:00:00:00:00:00:00:01:3a:00:05:02:00:\
+00:00:00:8f:00:bb:5a:00:00:00:01:02:00:00:02:ff:02:00:00:00:00:00:00:00:00:00:00:00:00:00:cc:20:\
+01:0d:b8:00:01:00:00:00:00:00:00:00:00:00:20:20:01:0d:b8:00:01:00:00:00:00:00:00:00:00:00:30"
 # MLDv2 to_ex report: grp ff02::cc to_exclude 2001:db8:1::1,2001:db8:1::20,2001:db8:1::30
 MZPKT_TO_EXC="33:33:00:00:00:01:fe:54:00:04:5e:ba:86:dd:60:0a:2d:ae:00:54:00:01:fe:80:00:00:00:\
 00:00:00:fc:54:00:ff:fe:04:5e:ba:ff:02:00:00:00:00:00:00:00:00:00:00:00:00:00:01:3a:00:05:02:00:\
@@ -352,6 +358,29 @@ mldv2exc_is_include_test()
 	mldv2cleanup $swp1
 }
 
+mldv2exc_is_exclude_test()
+{
+	RET=0
+	local X=("2001:db8:1::30")
+	local Y=("2001:db8:1::20")
+
+	mldv2exclude_prepare $h1
+
+	$MZ $h1 -c 1 $MZPKT_IS_EXC2 -q
+	sleep 1
+	brmcast_check_sg_entries "is_exclude" "${X[@]}" "${Y[@]}"
+
+	brmcast_check_sg_state 0 "${X[@]}"
+	brmcast_check_sg_state 1 "${Y[@]}"
+
+	brmcast_check_sg_fwding 1 "${X[@]}" 2001:db8:1::100
+	brmcast_check_sg_fwding 0 "${Y[@]}"
+
+	log_test "MLDv2 report $TEST_GROUP exclude -> is_exclude"
+
+	mldv2cleanup $swp1
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.25.4

