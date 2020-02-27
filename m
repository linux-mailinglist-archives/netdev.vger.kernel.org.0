Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 464511711BE
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 08:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbgB0Hur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 02:50:47 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37724 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728571AbgB0Hum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 02:50:42 -0500
Received: by mail-wm1-f65.google.com with SMTP id a141so2211236wme.2
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 23:50:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KLhwaBZkXGmkpFc/z5iy+wUb5vcsy23hwueBrbtIHGo=;
        b=iV/35PwDE8AyLyNwOF7ubcChjOZqOZT66pZTgIOsP4ORwGWcmWsJTMVcJchQM+wiMS
         jSS1d3DdTBcIgYruCfenikmDARejEGUKBfL9FkmzUOUr5ss7KlBerkZ8Z8wNqyaRfJvM
         4WOrl8K/4860lWHpXsDPzs/AuogKz2uVcdHskzIvvrP+MIa61AuGAdD/vWxg/Pp1VuWW
         CZzVFZ7FLtoPdcPNNnNZTOgagCBuaDrTDpDzH34XmZK1yFNisOtR+vwP8lG4O9oYHYij
         v6nXhlq6ka35MIXNeAwNNn3nVoaSFN9aeeTrBSiuw1XJCMC2uSPWYH95GR1wYGgKM2o2
         gUNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KLhwaBZkXGmkpFc/z5iy+wUb5vcsy23hwueBrbtIHGo=;
        b=O1LRNq3e61AsQLbbkG1lCJhTdZjRnmfwX7CpwUYX6Sxh8OM/c3wJRluy647aY+331z
         CdelWo0WaYdysaU5iQTn6gqzmIYVqfqg0DHLc4eelEQB33jWC+HZvFnZDoZVZLfczaVK
         QBM8Y57o3qZQxkbzkxMrVpyn5qLws8s4Yl7rSXC+/Hh6o6vmLEIfUbwekI27LuNbHp08
         BUaqsg92Pg0ANhw/0h09OlcNUjB3q25ZPo30nyvN/WdJU1BgyS2wojLssWZ1e/lDwh00
         WRXYdy8K9HS5JTjI11Er7Ms8AueeWo0OalyllnNxDk48PvMHBLfd3oTQhym1daSCIYd5
         aaBg==
X-Gm-Message-State: APjAAAVHB7m5MMMCbxPpPRhUUIsKl4bKpGYFv1mQYK9JRTUdgyj0ce/s
        74vp3ZKUiN8Xz3+vlJiCYnlCN+epCZQ=
X-Google-Smtp-Source: APXvYqyWbfDhuc7ntY3bgZBSY3w+MVVZMsvnP0XHcpTwWskaSFqHDRKu4rU8xwxkJk8I1MfcEgfEHQ==
X-Received: by 2002:a7b:c935:: with SMTP id h21mr3470073wml.173.1582789840921;
        Wed, 26 Feb 2020 23:50:40 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id l6sm7165943wrn.26.2020.02.26.23.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 23:50:40 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com, shuah@kernel.org
Subject: [patch net-next 15/16] selftests: mlxsw: Reduce router scale running time using offload indication
Date:   Thu, 27 Feb 2020 08:50:20 +0100
Message-Id: <20200227075021.3472-16-jiri@resnulli.us>
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

Currently, the test inserts X /32 routes and for each route it is
testing that a packet sent from the first host is received by the second
host, which is very time-consuming.

Instead only validate the offload flag of each route and get the same result.

Wait between the creation of the routes and the offload validation in
order to make sure that all the routes were successfully offloaded.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 .../drivers/net/mlxsw/router_scale.sh         | 53 +++++--------------
 1 file changed, 14 insertions(+), 39 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/router_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/router_scale.sh
index d231649b4f01..e93878d42596 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/router_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/router_scale.sh
@@ -2,16 +2,15 @@
 # SPDX-License-Identifier: GPL-2.0
 
 ROUTER_NUM_NETIFS=4
+: ${TIMEOUT:=20000} # ms
 
 router_h1_create()
 {
 	simple_if_init $h1 192.0.1.1/24
-	ip route add 193.0.0.0/8 via 192.0.1.2 dev $h1
 }
 
 router_h1_destroy()
 {
-	ip route del 193.0.0.0/8 via 192.0.1.2 dev $h1
 	simple_if_fini $h1 192.0.1.1/24
 }
 
@@ -64,13 +63,15 @@ router_setup_prepare()
 	router_create
 }
 
-router_offload_validate()
+wait_for_routes()
 {
-	local route_count=$1
-	local offloaded_count
+	local t0=$1; shift
+	local route_count=$1; shift
 
-	offloaded_count=$(ip route | grep -o 'offload' | wc -l)
-	[[ $offloaded_count -ge $route_count ]]
+	local t1=$(ip route | grep -o 'offload' | wc -l)
+	local delta=$((t1 - t0))
+	echo $delta
+	[[ $delta -ge $route_count ]]
 }
 
 router_routes_create()
@@ -90,8 +91,8 @@ router_routes_create()
 					break 3
 				fi
 
-				echo route add 193.${i}.${j}.${k}/32 via \
-				       192.0.2.1 dev $rp2  >> $ROUTE_FILE
+				echo route add 193.${i}.${j}.${k}/32 dev $rp2 \
+					>> $ROUTE_FILE
 				((count++))
 			done
 		done
@@ -111,45 +112,19 @@ router_test()
 {
 	local route_count=$1
 	local should_fail=$2
-	local count=0
+	local delta
 
 	RET=0
 
+	local t0=$(ip route | grep -o 'offload' | wc -l)
 	router_routes_create $route_count
+	delta=$(busywait "$TIMEOUT" wait_for_routes $t0 $route_count)
 
-	router_offload_validate $route_count
-	check_err_fail $should_fail $? "Offload of $route_count routes"
+	check_err_fail $should_fail $? "Offload routes: Expected $route_count, got $delta."
 	if [[ $RET -ne 0 ]] || [[ $should_fail -eq 1 ]]; then
 		return
 	fi
 
-	tc filter add dev $h2 ingress protocol ip pref 1 flower \
-		skip_sw dst_ip 193.0.0.0/8 action drop
-
-	for i in {0..255}
-	do
-		for j in {0..255}
-		do
-			for k in {0..255}
-			do
-				if [[ $count -eq $route_count ]]; then
-					break 3
-				fi
-
-				$MZ $h1 -c 1 -p 64 -a $h1mac -b $rp1mac \
-					-A 192.0.1.1 -B 193.${i}.${j}.${k} \
-					-t ip -q
-				((count++))
-			done
-		done
-	done
-
-	tc_check_packets "dev $h2 ingress" 1 $route_count
-	check_err $? "Offload mismatch"
-
-	tc filter del dev $h2 ingress protocol ip pref 1 flower \
-		skip_sw dst_ip 193.0.0.0/8 action drop
-
 	router_routes_destroy
 }
 
-- 
2.21.1

