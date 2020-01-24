Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 422AD1485F0
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 14:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389738AbgAXNYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 08:24:31 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45007 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389695AbgAXNY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 08:24:29 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 4B11521F4C;
        Fri, 24 Jan 2020 08:24:28 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 24 Jan 2020 08:24:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=OvfWuicFqsSS6m0RjsJZ5MsWdR4Kf1HbOb8IZPdRoDY=; b=xdEFb9LU
        NEGNIS2tG+VOOY/XVlqQb379wRWYm2E5l3VMBIG+ODT4z7YMjzYYX0OGODWyF+VQ
        X0dBUvLWs5Ou01W4tBEK6pQwGL7/PS/ngddx+gKAw0NLVkmsY3CSehT5zNy1znh2
        6VobtqQr/JIn1RvdDQwLqbyj9UypmfxHZ/IpmE0pGOuZ3Xq2yHh0kBil2Vyh+y/j
        cOZ9fa2W11sPYFcIUo2cxsAGxq2tRk4VSDqwoMS0WaJQuXQS+Ld+VMOK4IGevGRn
        +rBirRzYwzUk8KnInD2lXEOa+78iDxdXwatJ0gLUCPwJSF/kzHjVAWD21a8RZghd
        cDtf8JkDLIdb9Q==
X-ME-Sender: <xms:DPAqXkTXdpO9vaXL0CJ7dbAT2q6puo-RpUCVKGmu3mpjRAnZ-m-UFQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrvdeggdehudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukeefrddutdejrdduvddtnecuvehluhhsthgvrh
    fuihiivgepuddtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:DPAqXlt_Z5VIkDHw2sKVlaQUPpBD8Fj7GAoFXEZjG5yjXruNPjtTLw>
    <xmx:DPAqXmayV-9aTu0NTD8g9md8VRiO8s1qsbC7lojvjM0Tzf2kaXgAww>
    <xmx:DPAqXv-iTLIdSK89vK8M837pmYqVGAIkG5HAQQjJ6JADRMw0OMUNVg>
    <xmx:DPAqXisusZMYvAijjnixaDtd-Bc5BIJZ2157lfhTwZzE9m7CPT6ucg>
Received: from splinter.mtl.com (bzq-79-183-107-120.red.bezeqint.net [79.183.107.120])
        by mail.messagingengine.com (Postfix) with ESMTPA id 13D4E3061106;
        Fri, 24 Jan 2020 08:24:25 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 11/14] selftests: Move two functions from mlxsw's qos_lib to lib
Date:   Fri, 24 Jan 2020 15:23:15 +0200
Message-Id: <20200124132318.712354-12-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200124132318.712354-1-idosch@idosch.org>
References: <20200124132318.712354-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

The function humanize() is used for converting value in bits/s to a
human-friendly approximate value in Kbps, Mbps or Gbps. There is nothing
hardware-specific in that, so move the function to lib.sh.

Similarly for the rate() function, which just does a bit of math to
calculate a rate, given two counter values and a time interval.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../selftests/drivers/net/mlxsw/qos_lib.sh    | 24 -------------------
 tools/testing/selftests/net/forwarding/lib.sh | 24 +++++++++++++++++++
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_lib.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_lib.sh
index a5937069ac16..faa51012cdac 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_lib.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_lib.sh
@@ -1,29 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
 
-humanize()
-{
-	local speed=$1; shift
-
-	for unit in bps Kbps Mbps Gbps; do
-		if (($(echo "$speed < 1024" | bc))); then
-			break
-		fi
-
-		speed=$(echo "scale=1; $speed / 1024" | bc)
-	done
-
-	echo "$speed${unit}"
-}
-
-rate()
-{
-	local t0=$1; shift
-	local t1=$1; shift
-	local interval=$1; shift
-
-	echo $((8 * (t1 - t0) / interval))
-}
-
 check_rate()
 {
 	local rate=$1; shift
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 8dc5fac98cbc..10cdfc0adca8 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -588,6 +588,30 @@ ethtool_stats_get()
 	ethtool -S $dev | grep "^ *$stat:" | head -n 1 | cut -d: -f2
 }
 
+humanize()
+{
+	local speed=$1; shift
+
+	for unit in bps Kbps Mbps Gbps; do
+		if (($(echo "$speed < 1024" | bc))); then
+			break
+		fi
+
+		speed=$(echo "scale=1; $speed / 1024" | bc)
+	done
+
+	echo "$speed${unit}"
+}
+
+rate()
+{
+	local t0=$1; shift
+	local t1=$1; shift
+	local interval=$1; shift
+
+	echo $((8 * (t1 - t0) / interval))
+}
+
 mac_get()
 {
 	local if_name=$1
-- 
2.24.1

