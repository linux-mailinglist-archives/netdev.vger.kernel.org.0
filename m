Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466432A4CCA
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728946AbgKCRY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:24:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728768AbgKCRY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:24:26 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D72C0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 09:24:25 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id w14so19339724wrs.9
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 09:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KO2EAh20S+jttJfdSLEE5yEDM/k15rSunKbDPOOTJes=;
        b=CpoVo36jIhGru423S6ZZ+KEA62pfHYhtHX75TAtU4d/iaaVq5dPgh4/L8M0cKeErIK
         2wa4ureCWN9627FLkzzejE9Xvkc/S9VfMc2klxTpK28cT1mZUMPmLLFTmhsX1PazLoVy
         Z4sdZxl7Yp5lXCJlFTTot2JESnzWEZdxOMSlU/SsAagNgWIcSB+wi6RxNGNSXi0mAwJ1
         4YeL1Jun58S7SeLe96iGpS4tHmRJ41aBfoSQJQSOUNQ9WAe0MaHbs6IayPNvOiMDyWFH
         g1JwFfKk+yxKQgcLmoaN4bZpv7X29zfiJbOWmmtIJuSz7sy5zHIOazYvmKhbVFSAn6T3
         TbKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KO2EAh20S+jttJfdSLEE5yEDM/k15rSunKbDPOOTJes=;
        b=aH4UBms5vLcTm6CpD2m2bC4H9WKq7MQjj05H3McxcVa772ArrIga7bUY3PliZKTHy4
         Phyqfc1O0kUSVCs07E7NgGLcMq7oO/wkXcd8ugWhEqNzQdJwlsigyxXVwcU8XE/+JhmF
         tod4rorw6wbGoaiZWM6l6NSbvquvUXn4BfE4jUf+QvPt43LwBECDo/UkBruKW13DpQGM
         P+e8EnsGm/mjIbSN/smMLgjjq/YvlqOLNs8IYAInlyU0POni47j/qHuc+9CiHkextpse
         7e0i8oEbiW42IyGih3v2/xvICX+SOSJViWUf1Tmmsslqo+zz75QFREjuEKN5F6u/EQNb
         zjsg==
X-Gm-Message-State: AOAM5303/GwSjCx9CVv0ErqW7Pm9IfHOSy05Pp2cmSKJvdGuTkD+7+rH
        tw6/t7SdKmJjl37C2ms2T8Na7ZoW+oBnH5RP
X-Google-Smtp-Source: ABdhPJwT5K8GxkYFIBG0R5CzU/wqLGgy8JbIkUS1I0qVzBHyYisJ44b8UUHG8DkVq2dQQ0R3755n2w==
X-Received: by 2002:adf:84a5:: with SMTP id 34mr27108832wrg.8.1604424263639;
        Tue, 03 Nov 2020 09:24:23 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id a128sm2650795wmf.5.2020.11.03.09.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 09:24:23 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 06/16] selftests: net: bridge: add test for mldv2 inc -> is_include report
Date:   Tue,  3 Nov 2020 19:24:02 +0200
Message-Id: <20201103172412.1044840-7-razor@blackwall.org>
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
   INCLUDE (A)       IS_IN (B)     INCLUDE (A+B)       (B)=MALI

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 .../selftests/net/forwarding/bridge_mld.sh    | 29 ++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_mld.sh b/tools/testing/selftests/net/forwarding/bridge_mld.sh
index accc4ec2dcce..a93bf6fa6caa 100755
--- a/tools/testing/selftests/net/forwarding/bridge_mld.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_mld.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
-ALL_TESTS="mldv2include_test mldv2inc_allow_test"
+ALL_TESTS="mldv2include_test mldv2inc_allow_test mldv2inc_is_include_test"
 NUM_NETIFS=4
 CHECK_TC="yes"
 TEST_GROUP="ff02::cc"
@@ -13,6 +13,12 @@ MZPKT_IS_INC="33:33:00:00:00:01:fe:54:00:04:5e:ba:86:dd:60:0a:2d:ae:00:54:00:01:
 00:05:02:00:00:00:00:8f:00:8e:d9:00:00:00:01:01:00:00:03:ff:02:00:00:00:00:00:00:00:00:00:\
 00:00:00:00:cc:20:01:0d:b8:00:01:00:00:00:00:00:00:00:00:00:01:20:01:0d:b8:00:01:00:00:00:\
 00:00:00:00:00:00:02:20:01:0d:b8:00:01:00:00:00:00:00:00:00:00:00:03"
+# MLDv2 is_in report: grp ff02::cc is_include 2001:db8:1::10,2001:db8:1::11,2001:db8:1::12
+MZPKT_IS_INC2="33:33:00:00:00:01:fe:54:00:04:5e:ba:86:dd:60:0a:2d:ae:00:54:00:01:fe:80:00:\
+00:00:00:00:00:fc:54:00:ff:fe:04:5e:ba:ff:02:00:00:00:00:00:00:00:00:00:00:00:00:00:01:3a:00:\
+05:02:00:00:00:00:8f:00:8e:ac:00:00:00:01:01:00:00:03:ff:02:00:00:00:00:00:00:00:00:00:00:00:\
+00:00:cc:20:01:0d:b8:00:01:00:00:00:00:00:00:00:00:00:10:20:01:0d:b8:00:01:00:00:00:00:00:00:\
+00:00:00:11:20:01:0d:b8:00:01:00:00:00:00:00:00:00:00:00:12"
 # MLDv2 allow report: grp ff02::cc allow 2001:db8:1::10,2001:db8:1::11,2001:db8:1::12
 MZPKT_ALLOW="33:33:00:00:00:01:fe:54:00:04:5e:ba:86:dd:60:0a:2d:ae:00:54:00:01:fe:80:00:00:\
 00:00:00:00:fc:54:00:ff:fe:04:5e:ba:ff:02:00:00:00:00:00:00:00:00:00:00:00:00:00:01:3a:00:05:\
@@ -163,6 +169,27 @@ mldv2inc_allow_test()
 	mldv2cleanup $swp1
 }
 
+mldv2inc_is_include_test()
+{
+	RET=0
+	local X=("2001:db8:1::10" "2001:db8:1::11" "2001:db8:1::12")
+
+	mldv2include_prepare $h1
+
+	$MZ $h1 -c 1 $MZPKT_IS_INC2 -q
+	sleep 1
+	brmcast_check_sg_entries "is_include" "${X[@]}"
+
+	brmcast_check_sg_state 0 "${X[@]}"
+
+	brmcast_check_sg_fwding 1 "${X[@]}"
+	brmcast_check_sg_fwding 0 "2001:db8:1::100"
+
+	log_test "MLDv2 report $TEST_GROUP include -> is_include"
+
+	mldv2cleanup $swp1
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.25.4

