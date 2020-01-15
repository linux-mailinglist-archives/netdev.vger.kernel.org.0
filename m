Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9D3713BEEA
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 12:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730191AbgAOLyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 06:54:19 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:37479 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730166AbgAOLyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 06:54:18 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C9D0B2207F;
        Wed, 15 Jan 2020 06:54:17 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 15 Jan 2020 06:54:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=D3i1JmeFAwsJ5CpQHqA/fqC6YT2L/rJwbmBXt8WF5M4=; b=qjP5+0pb
        OmoxWFLZynVCHPdXZPM914NAAV+5vZqmiiRlmymkzzcuCXSTG9r8OrhQcdE70dw8
        PMPgSuzEtOTviMF2qeqlOj3x38Q23ygDNiylBL7xC+Hep9/GlYtbHoPOM9n9HzzM
        O9MlaevcOEUBgoj/nETHuKLVppIIFDsSia4OGey76JFWg0AP9h/hF+44wsqLznYx
        j9MpSZySEpr9NxpRNpEqOab8LebRVGedanXVxSMP6klFbTunGpssIgtzJOxWHX4u
        i8S+vQ2IyoFSzlj8CBdSX6wSmMYdNiWCQ1eMZm3oXiQEqNkwggnkSsfoQrAH5NM8
        McP8K+6qfxso+Q==
X-ME-Sender: <xms:af0eXtGVHLiQGrzXC9rmeTieynipfxM-0tgihAFV8Pypu03Eq7PGlg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrtdefgdeffecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppeduleefrd
    egjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehi
    ughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedv
X-ME-Proxy: <xmx:af0eXi8AVc71xg0Y6h3grmQZz4OmC3c1Y-6qwTTYcTBKUL3hjHpCNA>
    <xmx:af0eXqQdQXwW1ZqDY8ZSv7LZiS-vzy6DencXvyfFv3rdYDpo-Q88Fg>
    <xmx:af0eXnoBNg4A4UnUXdr6sCx-tIwDo1Bn2RCgVWRbsUd60PdD8tGQWA>
    <xmx:af0eXqKoDLKh0eSxPzxiwrd9ObPusTcuhE9g4BrbOqQ3c0sMOZb7Lw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5CC8B80065;
        Wed, 15 Jan 2020 06:54:16 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net v2 4/6] selftests: mlxsw: qos_mc_aware: Fix mausezahn invocation
Date:   Wed, 15 Jan 2020 13:53:47 +0200
Message-Id: <20200115115349.1273610-5-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200115115349.1273610-1-idosch@idosch.org>
References: <20200115115349.1273610-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Mausezahn does not recognize "own" as a keyword on source IP address. As a
result, the MC stream is not running at all, and therefore no UC
degradation can be observed even in principle.

Fix the invocation, and tighten the test: due to the minimum shaper
configured at the MC TCs, we always expect about 20% degradation. Fail the
test if it is lower.

Fixes: 573363a68f27 ("selftests: mlxsw: Add qos_lib.sh")
Signed-off-by: Petr Machata <petrm@mellanox.com>
Reported-by: Amit Cohen <amitc@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh
index 47315fe48d5a..24dd8ed48580 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh
@@ -232,7 +232,7 @@ test_mc_aware()
 	stop_traffic
 	local ucth1=${uc_rate[1]}
 
-	start_traffic $h1 own bc bc
+	start_traffic $h1 192.0.2.65 bc bc
 
 	local d0=$(date +%s)
 	local t0=$(ethtool_stats_get $h3 rx_octets_prio_0)
@@ -254,7 +254,11 @@ test_mc_aware()
 			ret = 100 * ($ucth1 - $ucth2) / $ucth1
 			if (ret > 0) { ret } else { 0 }
 		    ")
-	check_err $(bc <<< "$deg > 25")
+
+	# Minimum shaper of 200Mbps on MC TCs should cause about 20% of
+	# degradation on 1Gbps link.
+	check_err $(bc <<< "$deg < 15") "Minimum shaper not in effect"
+	check_err $(bc <<< "$deg > 25") "MC traffic degrades UC performance too much"
 
 	local interval=$((d1 - d0))
 	local mc_ir=$(rate $u0 $u1 $interval)
-- 
2.24.1

