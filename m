Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E72B229C81A
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 20:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829226AbgJ0TBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 15:01:34 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36871 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S371399AbgJ0TA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 15:00:28 -0400
Received: by mail-wm1-f67.google.com with SMTP id c16so2552288wmd.2
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 12:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HWwH1mzK26OWStIyr7YQx947cp92x7ujWn8BN7kPbwM=;
        b=OpuUHStqMculoVADiWHShDs8jkbf6mK4yTc4KiX2t5Tru35iyhx3OjPGf4omufYeJq
         48Vha9bTSNQ45A6ZbF97QFusOaeyQ5pzXRWZ0Xnbulxx8HIoCbsX9e6GC98u7nLDLkyy
         NtvzKZEc9WEvGEPNL3D3/TOah2z7SRiLsW91bmPgqDzy9zgi3oJS7GOqPZZH1da+rwo1
         SJtGDzjkc/ZB9nABYEHVPuzazu7Xz+qwytjWc3VetNZjerP0G/QiiUDKHWNEomjhWJzZ
         etO5OfBG4tyTCvLJy5cm6N/nNGlzoKyqshPzi52Nxo4nEr9ma8U0UGgAnm493MKwl3gC
         Bb7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HWwH1mzK26OWStIyr7YQx947cp92x7ujWn8BN7kPbwM=;
        b=S+uz+xBei/1un7ZOhKdHFgt1O2OLCW9+ti4oPSNHA4dziywoz3WoONo6QPaBOmgkc9
         ccv130vbt8A3y9Mcw0aWMkpLTBK+QJstbTs8KH8uYsFVIGHjCA3+puYPKHo4DvTEurSN
         d6AC/x6hbnq/+q+VIjaeP+ry+LCFbQEXPmDK6zmqUAEIW2Gia8XNsWoffGQeynOzR1Ti
         LLH8Uqo0BMJcRBXTVp39UDYnu2LV9tPhmAmtEjfwQun5dukiKEWKk6PPwDfba9aUHJnH
         WJ6I44DrCACqx5vNr8qXW0RM/gELH9pjeu1KbedW5CA1t92APng+OL7G3aJgLkzbgh3E
         krBQ==
X-Gm-Message-State: AOAM5320kNIPP/tNBoIyj407lCJoN606rM/DbMnKGYQ68BUnep+YZrJM
        swYxey5ScGPk0j5cLfcCUd5xgH0Jl+GjT80E
X-Google-Smtp-Source: ABdhPJxxo103u+lxleVTEnlhpF+mLQdkEkTDFatbmlZ4/KjzqV69h9H52pHB2LImZcZmsTNPIa/tmw==
X-Received: by 2002:a7b:cc09:: with SMTP id f9mr4166353wmh.93.1603825225122;
        Tue, 27 Oct 2020 12:00:25 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x6sm3219803wmb.17.2020.10.27.12.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 12:00:24 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 16/16] selftests: net: bridge: add test for igmpv3 *,g auto-add
Date:   Tue, 27 Oct 2020 20:59:34 +0200
Message-Id: <20201027185934.227040-17-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201027185934.227040-1-razor@blackwall.org>
References: <20201027185934.227040-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

When we have *,G ports in exclude mode and a new S,G,port is added
the kernel has to automatically create an S,G entry for each exclude
port to get proper forwarding.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 .../selftests/net/forwarding/bridge_igmp.sh   | 31 ++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_igmp.sh b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
index db0a03e30868..0e71abdd7a03 100755
--- a/tools/testing/selftests/net/forwarding/bridge_igmp.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
@@ -4,7 +4,7 @@
 ALL_TESTS="v2reportleave_test v3include_test v3inc_allow_test v3inc_is_include_test \
 	   v3inc_is_exclude_test v3inc_to_exclude_test v3exc_allow_test v3exc_is_include_test \
 	   v3exc_is_exclude_test v3exc_to_exclude_test v3inc_block_test v3exc_block_test \
-	   v3exc_timeout_test"
+	   v3exc_timeout_test v3star_ex_auto_add_test"
 NUM_NETIFS=4
 CHECK_TC="yes"
 TEST_GROUP="239.10.10.10"
@@ -621,6 +621,35 @@ v3exc_timeout_test()
 	v3cleanup $swp1 $TEST_GROUP
 }
 
+v3star_ex_auto_add_test()
+{
+	RET=0
+
+	v3exclude_prepare $h1 $ALL_MAC $ALL_GROUP
+
+	$MZ $h2 -c 1 -b $ALL_MAC -B $ALL_GROUP -t ip "proto=2,p=$MZPKT_IS_INC" -q
+	sleep 1
+	bridge -j -d -s mdb show dev br0 \
+		| jq -e ".[].mdb[] | \
+			 select(.grp == \"$TEST_GROUP\" and .src == \"192.0.2.3\" and \
+				.port == \"$swp1\")" &>/dev/null
+	check_err $? "S,G entry for *,G port doesn't exist"
+
+	bridge -j -d -s mdb show dev br0 \
+		| jq -e ".[].mdb[] | \
+			 select(.grp == \"$TEST_GROUP\" and .src == \"192.0.2.3\" and \
+				.port == \"$swp1\" and \
+				.flags[] == \"added_by_star_ex\")" &>/dev/null
+	check_err $? "Auto-added S,G entry doesn't have added_by_star_ex flag"
+
+	check_sg_fwding 1 192.0.2.3
+
+	log_test "IGMPv3 S,G port entry automatic add to a *,G port"
+
+	v3cleanup $swp1 $TEST_GROUP
+	v3cleanup $swp2 $TEST_GROUP
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.25.4

