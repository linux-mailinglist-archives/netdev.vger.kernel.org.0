Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A97029C819
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 20:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S371435AbgJ0TBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 15:01:31 -0400
Received: from mail-wm1-f49.google.com ([209.85.128.49]:52914 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S371395AbgJ0TAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 15:00:24 -0400
Received: by mail-wm1-f49.google.com with SMTP id c194so2387463wme.2
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 12:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hkVjZ+YIjaJPktJubl8CMRKBr4zOyIIs4Cgi4AHtLdg=;
        b=PTJAjWIXqOo10ByygiLJ17DkXHRBd0InDc1XoZkYKuJDCetemkNTNVfz90gu14BKh7
         0BrMoX5uDOM0VJX9WcgZ4lqupcvM6DzRH9vBAbuq+/OfpLCjfR9dpU4gkopT3DAZuME9
         M7qalhxnqYzcc7QCLJxbxNqFxk2HzsZcTviDPVGh2Tf3Ut4p6hHK8xrIPbjiTx2ANOKf
         Ooa/o+G7i9+OwYkAkt5+4gnJnAxAuGqioCvIJ8483O0aLVk5aN5JgDb0CIVPPstjHnXo
         9KA90zhtNs/+EP5N8JDxEOcu7xn0Ste9Ck3JDQRrIJh7brvgRhMCyyJ1m5m+WXJbtMBq
         0d8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hkVjZ+YIjaJPktJubl8CMRKBr4zOyIIs4Cgi4AHtLdg=;
        b=dCx1x+p7nvxE6ImwVRQ+NkSW+zCy3NBWl3NUB3ldmirsrqGkRw5fexpA2CRNqt8tL0
         /M0OUtMQlxWUdI8yK7cxy8JnD2akyTG4//XuH6LQLDvy0fX8RPpQ7XC2lyamFNMUCXcM
         xr6RdresKaOcwcfIIsDk2qddl238/lVZwF43eKNmlcCS3jn6hbTvg8vlLdXD5jmf+BgP
         TvOLgzLrsUojDleXVkrW4LM+kzjNThHXUkP1M2YhrGx2GR2yS9aThRmw7R7NNaColdhs
         WvdPKp92qqcYVmW36KXntGoSOvEcs4r25AOjAZAKMY+lAvzzJ+P7QEddQBNW3SmKUxxE
         lshw==
X-Gm-Message-State: AOAM532j8ux7Eafx8uqQi9UbPwfx3nrYxNxO1KX1amy4t+1rLitvtO8N
        OkOFHj1UIFkxOeOtJEjwgPOgVeCPiBoXmZ/a
X-Google-Smtp-Source: ABdhPJzykSANs+MMEVckVqeXmwguDl6k4AlfnQ9uUtkIG4KhetLOK2QqJDR7NQLT6HotSLqdyArmsw==
X-Received: by 2002:a1c:9641:: with SMTP id y62mr4356126wmd.145.1603825221626;
        Tue, 27 Oct 2020 12:00:21 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x6sm3219803wmb.17.2020.10.27.12.00.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 12:00:21 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 13/16] selftests: net: bridge: add test for igmpv3 inc -> block report
Date:   Tue, 27 Oct 2020 20:59:31 +0200
Message-Id: <20201027185934.227040-14-razor@blackwall.org>
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
  INCLUDE (A)    BLOCK (B)     INCLUDE (A)              Send Q(G,A*B)

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 .../selftests/net/forwarding/bridge_igmp.sh   | 33 ++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_igmp.sh b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
index 3cfc30b88285..3772c7a066c9 100755
--- a/tools/testing/selftests/net/forwarding/bridge_igmp.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
@@ -3,7 +3,7 @@
 
 ALL_TESTS="v2reportleave_test v3include_test v3inc_allow_test v3inc_is_include_test \
 	   v3inc_is_exclude_test v3inc_to_exclude_test v3exc_allow_test v3exc_is_include_test \
-	   v3exc_is_exclude_test v3exc_to_exclude_test"
+	   v3exc_is_exclude_test v3exc_to_exclude_test v3inc_block_test"
 NUM_NETIFS=4
 CHECK_TC="yes"
 TEST_GROUP="239.10.10.10"
@@ -28,6 +28,8 @@ MZPKT_IS_EXC="22:00:da:b6:00:00:00:01:02:00:00:04:ef:0a:0a:0a:c0:00:02:01:c0:00:
 MZPKT_IS_EXC2="22:00:5e:b4:00:00:00:01:02:00:00:02:ef:0a:0a:0a:c0:00:02:14:c0:00:02:1e"
 # IGMPv3 to_ex report: grp 239.10.10.10 to_exclude 192.0.2.1,192.0.2.20,192.0.2.30
 MZPKT_TO_EXC="22:00:9a:b1:00:00:00:01:04:00:00:03:ef:0a:0a:0a:c0:00:02:01:c0:00:02:14:c0:00:02:1e"
+# IGMPv3 block report: grp 239.10.10.10 block 192.0.2.1,192.0.2.20,192.0.2.30
+MZPKT_BLOCK="22:00:98:b1:00:00:00:01:06:00:00:03:ef:0a:0a:0a:c0:00:02:01:c0:00:02:14:c0:00:02:1e"
 
 source lib.sh
 
@@ -515,6 +517,35 @@ v3exc_to_exclude_test()
 	v3cleanup $swp1 $TEST_GROUP
 }
 
+v3inc_block_test()
+{
+	RET=0
+	local X=("192.0.2.2" "192.0.2.3")
+
+	v3include_prepare $h1 $ALL_MAC $ALL_GROUP
+
+	$MZ $h1 -c 1 -b $ALL_MAC -B $ALL_GROUP -t ip "proto=2,p=$MZPKT_BLOCK" -q
+	# make sure the lowered timers have expired (by default 2 seconds)
+	sleep 3
+	check_sg_entries "block" "${X[@]}"
+
+	check_sg_state 0 "${X[@]}"
+
+	bridge -j -d -s mdb show dev br0 \
+		| jq -e ".[].mdb[] | \
+			 select(.grp == \"$TEST_GROUP\" and \
+				.source_list != null and
+				.source_list[].address == \"192.0.2.1\")" &>/dev/null
+	check_fail $? "Wrong *,G entry source list, 192.0.2.1 entry still exists"
+
+	check_sg_fwding 1 "${X[@]}"
+	check_sg_fwding 0 "192.0.2.100"
+
+	log_test "IGMPv3 report $TEST_GROUP include -> block"
+
+	v3cleanup $swp1 $TEST_GROUP
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.25.4

