Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB0B10C8C0
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 13:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbfK1MjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 07:39:02 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39437 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfK1MjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 07:39:02 -0500
Received: by mail-wm1-f65.google.com with SMTP id s14so4700078wmh.4
        for <netdev@vger.kernel.org>; Thu, 28 Nov 2019 04:38:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=heCUQ7mmRjnHfzNJl8bAAtOV5SgKG2zv87RA2Z+HlU8=;
        b=DSME8o2Ns/qXONuV7tzZuXoBgBl9IWxWcBQV3rHlGGSM34H2VjvXyTxakIfZzNY6qZ
         VAfLzPUEj3NBIQi60EQwhMq2pxA4Y1qgPctiAd2PqGVbwAn/dXQSg0OUb0TfKim4wncu
         5CkWB1H/lqCyfQT5St9tOCiEqsmfQBy8eBCQgInIjEuMwvWlxApSZDqEOFoGpQl65SK0
         oZ+Ri2rwIKd8hXXsfu5vPrTeHSGRQZGpMdE884OA+ENkZ8uJfWCGit70CCXWUCkwr6Z/
         i2RWw7wGrpFHhrEMjUdx4hM42fJWGS+txvzqjjTTG7SHmU8gkKPk5OANv9HzP70pf1Ar
         ZZpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=heCUQ7mmRjnHfzNJl8bAAtOV5SgKG2zv87RA2Z+HlU8=;
        b=ZFE5GaW02h5watbRgmZnTyhtIcqV2Abw0CBmySi07yfBBvl0WWFTg6cfHJkqQOxkU+
         YeyFIvwzEWtwp+OmYbtUSr8SJ80pnAEUIH2xROak7XqoFPKZ+TjBvpFqqtarF8JXx9E/
         7NykkZjqXFZHUbCadPZXLb+Mwyx7vG2HxGszo47KZtyKfxTjqdx2b1Ic9hemQwr/waof
         cjG0B1SQEBZ2XvqvU6yRAxhbKvN831q5wI4OKC/z/MQi6oCIb2p/mXRQ1TxcdSDxZ664
         vC2+e6NAy9LRQnTkySe55w4j0mNuFShStLvxp3sgBHydNLig7neOp3nz7XFS1Ch5ErP8
         3cIA==
X-Gm-Message-State: APjAAAUyspfkyw0wkoLXMGWQKaUn7GIoMWKl2frfKr4TNeyOHTF+Sdcf
        74IzFP8oJn9ox6puhPyPYAETrBjKVAY=
X-Google-Smtp-Source: APXvYqyeLHBEkzOZMbeeYTnj3/J3bP8eyZp/kQYJf/1dQdUkKS9fgDCUgQ9w5hLz2oa72YfbxZp8KQ==
X-Received: by 2002:a1c:3c86:: with SMTP id j128mr9345786wma.137.1574944738188;
        Thu, 28 Nov 2019 04:38:58 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id f24sm9644429wmb.37.2019.11.28.04.38.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 04:38:57 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com
Subject: [patch net] selftests: forwarding: fix race between packet receive and tc check
Date:   Thu, 28 Nov 2019 13:38:57 +0100
Message-Id: <20191128123857.1216-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

It is possible that tc stats get checked before the packet we check for
actually arrived into the interface and accounted for.
Fix it by checking for the expected result in a loop until
timeout is reached (by default 1 second).

Fixes: 07e5c75184a1 ("selftests: forwarding: Introduce tc flower matching tests")
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 .../selftests/net/forwarding/tc_common.sh     | 39 +++++++++++++++----
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/tc_common.sh b/tools/testing/selftests/net/forwarding/tc_common.sh
index d93589bd4d1d..64f652633585 100644
--- a/tools/testing/selftests/net/forwarding/tc_common.sh
+++ b/tools/testing/selftests/net/forwarding/tc_common.sh
@@ -3,16 +3,42 @@
 
 CHECK_TC="yes"
 
+# Can be overridden by the configuration file. See lib.sh
+TC_HIT_TIMEOUT=${TC_HIT_TIMEOUT:=1000} # ms
+
+__tc_check_packets()
+{
+	local id=$1
+	local handle=$2
+	local count=$3
+	local operator=$4
+
+	start_time="$(date -u +%s%3N)"
+	while true
+	do
+		cmd_jq "tc -j -s filter show $id" \
+		       ".[] | select(.options.handle == $handle) | \
+			    select(.options.actions[0].stats.packets $operator $count)" \
+		    &> /dev/null
+		ret=$?
+		if [[ $ret -eq 0 ]]; then
+			return $ret
+		fi
+		current_time="$(date -u +%s%3N)"
+		diff=$(expr $current_time - $start_time)
+		if [ "$diff" -gt "$TC_HIT_TIMEOUT" ]; then
+			return 1
+		fi
+	done
+}
+
 tc_check_packets()
 {
 	local id=$1
 	local handle=$2
 	local count=$3
 
-	cmd_jq "tc -j -s filter show $id" \
-	       ".[] | select(.options.handle == $handle) | \
-	              select(.options.actions[0].stats.packets == $count)" \
-	       &> /dev/null
+	__tc_check_packets "$id" "$handle" "$count" "=="
 }
 
 tc_check_packets_hitting()
@@ -20,8 +46,5 @@ tc_check_packets_hitting()
 	local id=$1
 	local handle=$2
 
-	cmd_jq "tc -j -s filter show $id" \
-	       ".[] | select(.options.handle == $handle) | \
-		      select(.options.actions[0].stats.packets > 0)" \
-	       &> /dev/null
+	__tc_check_packets "$id" "$handle" 0 ">"
 }
-- 
2.20.1

