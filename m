Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B298A29C81E
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 20:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829241AbgJ0TBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 15:01:37 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33989 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S371382AbgJ0TAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 15:00:23 -0400
Received: by mail-wr1-f67.google.com with SMTP id i1so3157412wro.1
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 12:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GkauxuTNWiSF9oMdr/Q/tgJ/GE3iMvf1VO5Jw7M5+xs=;
        b=uFAh3qD+tDMpttSW6AZo2oHmMqnlE/L9/+Hto2jryq9hxQWSn7IW0ju6HGCycstPp0
         H0f6qtJqmac7tUfLC4b7nNKIFi/021FZUX0STCsIysgbaN6NIOgUZEHytzNwAAXZmDSV
         Qr1esn/thg3+Dx1UYG4ul1cmqB/LNJCUvpPHK4bzXBNUeUfWGViXsSr2GcxNob8IZiRW
         k6BDsH4PovXv/VUBlcOloRE4WEStDzZLFH4YcDG3Z/kEBRD9o5ZY7DeP+RE0BjOZpimq
         4MDQNQU6jjdhSNsZ+f9MH8JGza0NaBmOOC5D9JIeP5NWqYwwuUNhWBR1yod++gkD1shl
         GXQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GkauxuTNWiSF9oMdr/Q/tgJ/GE3iMvf1VO5Jw7M5+xs=;
        b=FXwdUYuoAUdcC+bGB8d69aaeF0XrSY87UvmMzOdMDH0iiG11Qw2NBpOBX5IQNo9+18
         CLq69+Q8SYmJ9wkeYtiB0S7XdjSRZAI60zGbSyYJHjwEnFeKDhC/wZIT2ZlUgb3M2uMy
         ax5DD1m7abO5wR0mLKMjPq8CZMkdLitVRd94Nw1/aaEYGVo6JCBSSQ/vDEGbLUDyDOJF
         JITRKi8SzmWNgJQhi5Ys3TFi7e32YJEWko9guW4/6Cg4vxuuVp/Ag+2DvNCEZEkK+Sqm
         RHJ+ZxMP8DUI5p2CyRr4aAV3eJPq5hc0Tue1eSmDtHLSWB1VUOI+009Vt1o+DtG1L3up
         WzTg==
X-Gm-Message-State: AOAM532xGVGZeR7WQZobuArELl2eZhdYcl13O9DD91b+hi1g8KyS931p
        +otCBGwOUpLOHL7x61BIEfpiICUaDghnxExc
X-Google-Smtp-Source: ABdhPJzeAzyPZ503wQzC31NBDWhLz0G6RpVsHLo4W4PaX1fa3CRC6CqBBsE/4zLiXLtFF2amELEfwg==
X-Received: by 2002:adf:bc4a:: with SMTP id a10mr4513962wrh.253.1603825220478;
        Tue, 27 Oct 2020 12:00:20 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x6sm3219803wmb.17.2020.10.27.12.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 12:00:20 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 12/16] selftests: net: bridge: add test for igmpv3 exc -> to_exclude report
Date:   Tue, 27 Oct 2020 20:59:30 +0200
Message-Id: <20201027185934.227040-13-razor@blackwall.org>
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
  EXCLUDE (X,Y)  TO_EX (A)     EXCLUDE (A-Y,Y*A)        (A-X-Y)=Group Timer
                                                        Delete (X-A)
                                                        Delete (Y-A)
                                                        Send Q(G,A-Y)
                                                        Group Timer=GMI

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 .../selftests/net/forwarding/bridge_igmp.sh   | 30 ++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_igmp.sh b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
index 91b0b26428f6..3cfc30b88285 100755
--- a/tools/testing/selftests/net/forwarding/bridge_igmp.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
@@ -3,7 +3,7 @@
 
 ALL_TESTS="v2reportleave_test v3include_test v3inc_allow_test v3inc_is_include_test \
 	   v3inc_is_exclude_test v3inc_to_exclude_test v3exc_allow_test v3exc_is_include_test \
-	   v3exc_is_exclude_test"
+	   v3exc_is_exclude_test v3exc_to_exclude_test"
 NUM_NETIFS=4
 CHECK_TC="yes"
 TEST_GROUP="239.10.10.10"
@@ -487,6 +487,34 @@ v3exc_is_exclude_test()
 	v3cleanup $swp1 $TEST_GROUP
 }
 
+v3exc_to_exclude_test()
+{
+	RET=0
+	local X=("192.0.2.1" "192.0.2.30")
+	local Y=("192.0.2.20")
+
+	v3exclude_prepare $h1 $ALL_MAC $ALL_GROUP
+
+	ip link set dev br0 type bridge mcast_last_member_interval 500
+	check_err $? "Could not change mcast_last_member_interval to 5s"
+
+	$MZ $h1 -c 1 -b $ALL_MAC -B $ALL_GROUP -t ip "proto=2,p=$MZPKT_TO_EXC" -q
+	sleep 1
+	check_sg_entries "to_exclude" "${X[@]}" "${Y[@]}"
+
+	check_sg_state 0 "${X[@]}"
+	check_sg_state 1 "${Y[@]}"
+
+	check_sg_fwding 1 "${X[@]}" 192.0.2.100
+	check_sg_fwding 0 "${Y[@]}"
+
+	log_test "IGMPv3 report $TEST_GROUP exclude -> to_exclude"
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

