Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8F729C814
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 20:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829219AbgJ0TBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 15:01:25 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36372 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S371380AbgJ0TAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 15:00:21 -0400
Received: by mail-wr1-f68.google.com with SMTP id x7so3130404wrl.3
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 12:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eh7WAxMOPKXXzFs26VQMmI3KTTBmFoUGd5NShuFmYTI=;
        b=y044UhrUzUTQHrbOmghMxJAowA7TXmIo5m0dxTpVuGY6BerjGF90KmoVYELavc/tRo
         zR7ON80BmM2fNY3m+UvIMxRue0crw0AtRBP0tXW7b/pIAiYc4hrWmj4LoVifM4RD8n3w
         2pRRBVb8WwUvUsRf86eoZQAGdSPInowb+xCnFEX1BNxoAFSB/IDD1A6OuOuXVfIhAR3r
         goLXAVUKtP5LBjZtUaJmHcHM0e9T2FSu5a63xdNcNXos4oCb32r0WL9rB1gp/Ljdl8pF
         QYtY4EfHaPtMJ9khsNFAzfiecSeTMP1FQaD+3ck3b2vjQgkv8nrdPbHspMAFN0NhjUB/
         V1fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eh7WAxMOPKXXzFs26VQMmI3KTTBmFoUGd5NShuFmYTI=;
        b=bZat/IyUyrMZ3XisUh7HN5b6PkaVtl3IrD3qH9wyzfSFCX0EXLtbaEcbtLbDU/Paeh
         lFDPUD+TBY3dNu3J0p7AtkkKix2ujrSFLTPnDkhuCYVzusXlZEx4kiHBNeMJZctb0Fbw
         dfXoO4C3zewC9H/oY4YPF9Ore0PldTowC25T8xehAgFoWZdVRMzn5Dk+26r7G/9z6rMX
         8ZyjLVTzFHjvmaJfktuJIk7opGm5cKeiz85LOwoYqpnrqtmj5n/ZrviE5FObblF0psd3
         PA2YUj0p+FzP7be0ShWXcJ+ZEG8VKmql3dkg9EuDrZeffrulS4hWbDr24sTcYGZiYUqy
         4PpQ==
X-Gm-Message-State: AOAM533Fdlq9kZngFSVdoz1NV7qO4FMHJ7GJd94fk+4XDVXr06Cf+CN0
        qQN01rOkVNJ3GIZhi4IIhN1nmn4YumccIXjv
X-Google-Smtp-Source: ABdhPJwsDoeyXL33OZHujXDCVYr7wQXd77jty6Brgedv4cdnELOfAEC7WuNO5OrheGMnlibYKylEKw==
X-Received: by 2002:a5d:5748:: with SMTP id q8mr4418940wrw.299.1603825218168;
        Tue, 27 Oct 2020 12:00:18 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x6sm3219803wmb.17.2020.10.27.12.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 12:00:17 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 10/16] selftests: net: bridge: add test for igmpv3 exc -> is_include report
Date:   Tue, 27 Oct 2020 20:59:28 +0200
Message-Id: <20201027185934.227040-11-razor@blackwall.org>
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
   EXCLUDE (X,Y)  IS_IN (A)     EXCLUDE (X+A,Y-A)       (A)=GMI

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 .../selftests/net/forwarding/bridge_igmp.sh   | 27 ++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_igmp.sh b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
index d786e75abe2c..b2b0f7d7e860 100755
--- a/tools/testing/selftests/net/forwarding/bridge_igmp.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
@@ -2,7 +2,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
 ALL_TESTS="v2reportleave_test v3include_test v3inc_allow_test v3inc_is_include_test \
-	   v3inc_is_exclude_test v3inc_to_exclude_test v3exc_allow_test"
+	   v3inc_is_exclude_test v3inc_to_exclude_test v3exc_allow_test v3exc_is_include_test"
 NUM_NETIFS=4
 CHECK_TC="yes"
 TEST_GROUP="239.10.10.10"
@@ -15,6 +15,8 @@ ALL_MAC="01:00:5e:00:00:01"
 MZPKT_IS_INC="22:00:9d:de:00:00:00:01:01:00:00:03:ef:0a:0a:0a:c0:00:02:01:c0:00:02:02:c0:00:02:03"
 # IGMPv3 is_in report: grp 239.10.10.10 is_include 192.0.2.10,192.0.2.11,192.0.2.12
 MZPKT_IS_INC2="22:00:9d:c3:00:00:00:01:01:00:00:03:ef:0a:0a:0a:c0:00:02:0a:c0:00:02:0b:c0:00:02:0c"
+# IGMPv3 is_in report: grp 239.10.10.10 is_include 192.0.2.20,192.0.2.30
+MZPKT_IS_INC3="22:00:5f:b4:00:00:00:01:01:00:00:02:ef:0a:0a:0a:c0:00:02:14:c0:00:02:1e"
 # IGMPv3 allow report: grp 239.10.10.10 allow 192.0.2.10,192.0.2.11,192.0.2.12
 MZPKT_ALLOW="22:00:99:c3:00:00:00:01:05:00:00:03:ef:0a:0a:0a:c0:00:02:0a:c0:00:02:0b:c0:00:02:0c"
 # IGMPv3 allow report: grp 239.10.10.10 allow 192.0.2.20,192.0.2.30
@@ -436,6 +438,29 @@ v3exc_allow_test()
 	v3cleanup $swp1 $TEST_GROUP
 }
 
+v3exc_is_include_test()
+{
+	RET=0
+	local X=("192.0.2.1" "192.0.2.2" "192.0.2.20" "192.0.2.30")
+	local Y=("192.0.2.21")
+
+	v3exclude_prepare $h1 $ALL_MAC $ALL_GROUP
+
+	$MZ $h1 -c 1 -b $ALL_MAC -B $ALL_GROUP -t ip "proto=2,p=$MZPKT_IS_INC3" -q
+	sleep 1
+	check_sg_entries "is_include" "${X[@]}" "${Y[@]}"
+
+	check_sg_state 0 "${X[@]}"
+	check_sg_state 1 "${Y[@]}"
+
+	check_sg_fwding 1 "${X[@]}" 192.0.2.100
+	check_sg_fwding 0 "${Y[@]}"
+
+	log_test "IGMPv3 report $TEST_GROUP exclude -> is_include"
+
+	v3cleanup $swp1 $TEST_GROUP
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.25.4

