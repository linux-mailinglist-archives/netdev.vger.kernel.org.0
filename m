Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E18071711BF
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 08:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbgB0Hus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 02:50:48 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42919 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728547AbgB0Hul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 02:50:41 -0500
Received: by mail-wr1-f65.google.com with SMTP id p18so2029311wre.9
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 23:50:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u+69PkjTDlqhdwSpfojKEXU9sYxW/SQJqES4cIW7flI=;
        b=S+e2A6pdXwBkywG6IUabR/anyFZmCd8sNYmW96jhwcZfY8j3gVOL9JajUrqcg1EM40
         1kUEKwxXijGJfyDmwLpacmF8mvJRI5X/hmVuLjmMR1IiN3iUWNVVEdffVCXY4x1UHWsu
         CE73KlxxGFigMRjTwQWmB/cFTpI0WLpGiIhauq3L64vhf39pTy3Y0WoZWkE1az1B79O0
         CaVQE8E8W8zWasY4UzWdfSJI6nx997efBr1JYsXL8lWWjmH5zZ247+6dKPNlnahK+ff0
         f8h+0fESGebjFAVH6GcdACEgEsOisqnnzQz+8kRnhTxnWx2uPotSRyeOodoULBXLZNwJ
         rTRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u+69PkjTDlqhdwSpfojKEXU9sYxW/SQJqES4cIW7flI=;
        b=ZrZtsy4nuA94r68J1UWSri+vXbf964CjvLkLDHdDwyybfs9iubOJarWNSnTDHaef+2
         Na/+X/mnAkX6GfAtmrBAp5GShqBIvYkg2n0WM4dbi+sSH+r0UrckItwBQ+YZHqU2ppbc
         8be8mtHDxK2WFkbRmYtB5QMFzT7go+F57dtrhvbya7zWdT3GHMGB6dRoNWglzTqgowox
         22WfNfucGTXq+U4tJ2l7gk50ArFC1rcdrjMwSqHeYcvKiAqNct881JhDu8vIQMAyCvkW
         3ZsNDrjRjKqISLJI4c2wb5gvzwD67nzF+y0fW/EKDpg/SJ91iVeka35WeqBaLx6KTbrk
         jxAQ==
X-Gm-Message-State: APjAAAXKVOr+2dh7+38U2vkWeo4F2hrDzoDg2nftACJkUdSfid0SQCfZ
        lNgni5ULi1r5iABXznEoXL4fWAw8Sew=
X-Google-Smtp-Source: APXvYqyhxy4IuQFxB+rGykXsPOIB4SwOo90BzbdadV3ywojN2fAaSra4WQ5i84DJ0+DwY1TAjbGftg==
X-Received: by 2002:a5d:6986:: with SMTP id g6mr3262927wru.421.1582789839844;
        Wed, 26 Feb 2020 23:50:39 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id i2sm6392615wmb.28.2020.02.26.23.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 23:50:38 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com, shuah@kernel.org
Subject: [patch net-next 14/16] selftests: mlxsw: Reduce running time using offload indication
Date:   Thu, 27 Feb 2020 08:50:19 +0100
Message-Id: <20200227075021.3472-15-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200227075021.3472-1-jiri@resnulli.us>
References: <20200227075021.3472-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@mellanox.com>

After adding a given number of flower rules for different IPv6
addresses, the test generates traffic and ensures that each packet is
received, which is time-consuming.

Instead, test the offload indication of the tc flower rules and reduce
the running time by half.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 .../drivers/net/mlxsw/tc_flower_scale.sh      | 31 +++++++------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/tc_flower_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/tc_flower_scale.sh
index a6d733d2a4b4..cc0f07e72cf2 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/tc_flower_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/tc_flower_scale.sh
@@ -2,9 +2,9 @@
 # SPDX-License-Identifier: GPL-2.0
 
 # Test for resource limit of offloaded flower rules. The test adds a given
-# number of flower matches for different IPv6 addresses, then generates traffic,
-# and ensures each was hit exactly once. This file contains functions to set up
-# a testing topology and run the test, and is meant to be sourced from a test
+# number of flower matches for different IPv6 addresses, then check the offload
+# indication for all of the tc flower rules. This file contains functions to set
+# up a testing topology and run the test, and is meant to be sourced from a test
 # script that calls the testing routine with a given number of rules.
 
 TC_FLOWER_NUM_NETIFS=2
@@ -94,22 +94,15 @@ __tc_flower_test()
 
 	tc_flower_rules_create $count $should_fail
 
-	for ((i = 0; i < count; ++i)); do
-		$MZ $h1 -q -c 1 -t ip -p 20 -b bc -6 \
-			-A 2001:db8:2::1 \
-			-B $(tc_flower_addr $i)
-	done
-
-	MISMATCHES=$(
-		tc -j -s filter show dev $h2 ingress |
-		jq -r '[ .[] | select(.kind == "flower") | .options |
-		         values as $rule | .actions[].stats.packets |
-		         select(. != 1) | "\(.) on \($rule.keys.dst_ip)" ] |
-		       join(", ")'
-	)
-
-	test -z "$MISMATCHES"
-	check_err $? "Expected to capture 1 packet for each IP, but got $MISMATCHES"
+	offload_count=$(tc -j -s filter show dev $h2 ingress    |
+			jq -r '[ .[] | select(.kind == "flower") |
+			.options | .in_hw ]' | jq .[] | wc -l)
+	[[ $((offload_count - 1)) -eq $count ]]
+	if [[ $should_fail -eq 0 ]]; then
+		check_err $? "Offload mismatch"
+	else
+		check_err_fail $should_fail $? "Offload more than expacted"
+	fi
 }
 
 tc_flower_test()
-- 
2.21.1

