Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320CD29C812
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 20:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S371425AbgJ0TBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 15:01:21 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36361 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S371361AbgJ0TAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 15:00:16 -0400
Received: by mail-wr1-f68.google.com with SMTP id x7so3130160wrl.3
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 12:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6HkZ/6PSGeiabpA/B/b1jjSowyj9GrVJsqEVL3OW8Gg=;
        b=EaoDx91o8fUnm+lClViM5aHRXCtgSqhpTvwagt0QiZHxRXIG3ecz2TV5FXYqwvZy/7
         WfTOwmHr9FuytAtR4t1WHSoXgJWOhZaLPmgD9oaoP8s9KZ0/JLVLSfbp219p549kTkAL
         huDVbXJvA+dein2g84RfRSCUYq2fWYegvCM3M/WMH4VZZSKzR7jBiKCKYXUQWjpzpfrX
         4KsjZLQxfUaspFK+Nyv4FH6+k40pEpnHgjqtJxfa4b2MZgyHeZC6wG8CBU8ZkUwfUYWg
         NenQfUaYyhQdjCpZCr3bZ5g2f/eX94etr3sLMzInM41du1AKFkUE75yDjge2ZDwITFAe
         v2bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6HkZ/6PSGeiabpA/B/b1jjSowyj9GrVJsqEVL3OW8Gg=;
        b=KR3jOGKJO6dCB0RwVvU47lK3UbeLJt7CHGssYbwwlDZx2OZ2kvgEkHnAuPrTAJT6xg
         6G3I74ORAvj9ocGRzXDdwNw+ZZ/oPvUgARVwQvRuEaWhAlXnO4bv+LnLKHNet5p+POru
         at7+f+F9VQdl/1d6lV+UqPTPUMlT6Kql/BRGtLR9gzXeN/h8n9ZWz8JAoKUBymnKlidu
         qrbF+W/dIup5izaQeGpdaj0Ix89EG6cakQno61q/Jyul7Q4ckDxfBsIBvD7ocA/u3NZi
         0kXKrs9zP5wbNF8UTn+YSubDLw5FsUkamtZFqmkp/fXDgxlTIgfAReEVw2fSCq1gHUde
         9BzA==
X-Gm-Message-State: AOAM532GJV7zAHn25UPIfLBrHK8HjBV3K2shI7jiwOk21Fxn2XrZV2jb
        CTEnrABHSo1nMGky7x+2IIsec5K3v9GEZu2i
X-Google-Smtp-Source: ABdhPJwVyXBlPxDCcS/ezwgZhQ9U5RFWEwJvAKWbxEftL+IxAF+WoSxAwD3UCUVXxJDFlvwjeKaD0w==
X-Received: by 2002:adf:a557:: with SMTP id j23mr4716801wrb.95.1603825213429;
        Tue, 27 Oct 2020 12:00:13 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x6sm3219803wmb.17.2020.10.27.12.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 12:00:12 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 06/16] selftests: net: bridge: add test for igmpv3 inc -> is_include report
Date:   Tue, 27 Oct 2020 20:59:24 +0200
Message-Id: <20201027185934.227040-7-razor@blackwall.org>
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
   state          report        result                 action
 INCLUDE (A)    IS_IN (B)     INCLUDE (A+B)            (B)=GMI

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 .../selftests/net/forwarding/bridge_igmp.sh   | 25 ++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_igmp.sh b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
index e9999e346ea6..added5c69e8b 100755
--- a/tools/testing/selftests/net/forwarding/bridge_igmp.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
-ALL_TESTS="v2reportleave_test v3include_test v3inc_allow_test"
+ALL_TESTS="v2reportleave_test v3include_test v3inc_allow_test v3inc_is_include_test"
 NUM_NETIFS=4
 CHECK_TC="yes"
 TEST_GROUP="239.10.10.10"
@@ -12,6 +12,8 @@ ALL_MAC="01:00:5e:00:00:01"
 
 # IGMPv3 is_in report: grp 239.10.10.10 is_include 192.0.2.1,192.0.2.2,192.0.2.3
 MZPKT_IS_INC="22:00:9d:de:00:00:00:01:01:00:00:03:ef:0a:0a:0a:c0:00:02:01:c0:00:02:02:c0:00:02:03"
+# IGMPv3 is_in report: grp 239.10.10.10 is_include 192.0.2.10,192.0.2.11,192.0.2.12
+MZPKT_IS_INC2="22:00:9d:c3:00:00:00:01:01:00:00:03:ef:0a:0a:0a:c0:00:02:0a:c0:00:02:0b:c0:00:02:0c"
 # IGMPv3 allow report: grp 239.10.10.10 allow 192.0.2.10,192.0.2.11,192.0.2.12
 MZPKT_ALLOW="22:00:99:c3:00:00:00:01:05:00:00:03:ef:0a:0a:0a:c0:00:02:0a:c0:00:02:0b:c0:00:02:0c"
 
@@ -290,6 +292,27 @@ v3inc_allow_test()
 	v3cleanup $swp1 $TEST_GROUP
 }
 
+v3inc_is_include_test()
+{
+	RET=0
+	local X=("192.0.2.10" "192.0.2.11" "192.0.2.12")
+
+	v3include_prepare $h1 $ALL_MAC $ALL_GROUP
+
+	$MZ $h1 -c 1 -b $ALL_MAC -B $ALL_GROUP -t ip "proto=2,p=$MZPKT_IS_INC2" -q
+	sleep 1
+	check_sg_entries "is_include" "${X[@]}"
+
+	check_sg_state 0 "${X[@]}"
+
+	check_sg_fwding 1 "${X[@]}"
+	check_sg_fwding 0 "192.0.2.100"
+
+	log_test "IGMPv3 report $TEST_GROUP include -> is_include"
+
+	v3cleanup $swp1 $TEST_GROUP
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.25.4

