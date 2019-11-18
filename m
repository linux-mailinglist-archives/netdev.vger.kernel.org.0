Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF1F5FFFC9
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 08:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfKRHum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 02:50:42 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51463 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726830AbfKRHuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 02:50:40 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C39A2221D1;
        Mon, 18 Nov 2019 02:50:39 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 18 Nov 2019 02:50:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=MfFxlCOIvsF41TNhHO1CQ/2jUGCuJw8wEqZ1JfiuQTU=; b=p1uZ+TSu
        yYFjSM3959QclcY45tFrxcbq1NG7JePXhoJhGxvd+UpKOoeeAtwBewF8lfIe5GBt
        Si9rdlqWoULH0FmUZnk8ywo32MvJpLffqSlse3Je52fBnDu7LL742l9FXY8FQwRw
        /670W+/lQwow4LMIVooVbJZTyB9AZ5q+lqNw1g1q48dFh9+256ONIW3ovvxrOZcz
        yCw9CHGJ4tUEUo4B2u2vlCZc14TW7qh6V1Fn0hCJ5T8+RzhQnI6UuTYU8ystsYyl
        +MEYkrm92iRf+iA+fDspHkMbnGB4yQqReqrpP4mnGg2rPL3qqCW6KHdkJ7tZxlkJ
        jybkvaE5RFFy/A==
X-ME-Sender: <xms:T03SXRq4S6TV6rwsHGPJ-lqh_z1UwShfoULJhH1Bgox0VAr4MxjSRg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeggedguddugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppedule
    efrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:T03SXdyQbaKOOdA1qj5x_uxizkjftie-24e7oiCk3zQpRAzOsk9uBg>
    <xmx:T03SXTPf7v3jmI9mZwZlA9-STSRn4aJv2u_BFno7vXUW_2UvVUKF1g>
    <xmx:T03SXRDmhb-MP6K9Z1512Hbk9Gj4jk8xcQjgJH5CstSzCScU0RzCIw>
    <xmx:T03SXeFlIFN0UhVD2j7RmoaVZCERJV6vnZYhzjQeIbMXnvZFEbTHnw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 542E4306005F;
        Mon, 18 Nov 2019 02:50:38 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        mlxsw@mellanox.com, Amit Cohen <amitc@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 4/5] selftests: forwarding: lib.sh: Add wait for dev with timeout
Date:   Mon, 18 Nov 2019 09:50:01 +0200
Message-Id: <20191118075002.1699-5-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191118075002.1699-1-idosch@idosch.org>
References: <20191118075002.1699-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Add a function that waits for device with maximum number of iterations.
It enables to limit the waiting and prevent infinite loop.

This will be used by the subsequent patch which will set two ports to
different speeds in order to make sure they cannot negotiate a link.

Waiting for all the setup is limited with 10 minutes for each device.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 tools/testing/selftests/net/forwarding/lib.sh | 29 +++++++++++++++++--
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 8b48ec54d058..1f64e7348f69 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -18,6 +18,8 @@ NETIF_CREATE=${NETIF_CREATE:=yes}
 MCD=${MCD:=smcrouted}
 MC_CLI=${MC_CLI:=smcroutectl}
 PING_TIMEOUT=${PING_TIMEOUT:=5}
+WAIT_TIMEOUT=${WAIT_TIMEOUT:=20}
+INTERFACE_TIMEOUT=${INTERFACE_TIMEOUT:=600}
 
 relative_path="${BASH_SOURCE%/*}"
 if [[ "$relative_path" == "${BASH_SOURCE}" ]]; then
@@ -226,24 +228,45 @@ log_info()
 setup_wait_dev()
 {
 	local dev=$1; shift
+	local wait_time=${1:-$WAIT_TIME}; shift
 
-	while true; do
+	setup_wait_dev_with_timeout "$dev" $INTERFACE_TIMEOUT $wait_time
+
+	if (($?)); then
+		check_err 1
+		log_test setup_wait_dev ": Interface $dev does not come up."
+		exit 1
+	fi
+}
+
+setup_wait_dev_with_timeout()
+{
+	local dev=$1; shift
+	local max_iterations=${1:-$WAIT_TIMEOUT}; shift
+	local wait_time=${1:-$WAIT_TIME}; shift
+	local i
+
+	for ((i = 1; i <= $max_iterations; ++i)); do
 		ip link show dev $dev up \
 			| grep 'state UP' &> /dev/null
 		if [[ $? -ne 0 ]]; then
 			sleep 1
 		else
-			break
+			sleep $wait_time
+			return 0
 		fi
 	done
+
+	return 1
 }
 
 setup_wait()
 {
 	local num_netifs=${1:-$NUM_NETIFS}
+	local i
 
 	for ((i = 1; i <= num_netifs; ++i)); do
-		setup_wait_dev ${NETIFS[p$i]}
+		setup_wait_dev ${NETIFS[p$i]} 0
 	done
 
 	# Make sure links are ready.
-- 
2.21.0

