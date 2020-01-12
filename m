Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 783FC1386FE
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 17:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733118AbgALQHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 11:07:14 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34425 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733064AbgALQHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jan 2020 11:07:12 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id ECCD42207A;
        Sun, 12 Jan 2020 11:07:11 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 12 Jan 2020 11:07:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=D3i1JmeFAwsJ5CpQHqA/fqC6YT2L/rJwbmBXt8WF5M4=; b=WDz7dMdQ
        hsphRNAwaTR8Temk5U5diRIPK4kq1xMxxulCu7SfQMQCeKMG/EEUkwFVa07JHZMa
        elbDmE4Cbp4omYrdWQ7COOfo8/B279BX51whd6rwF4LWLNfeKBw9BQ3qazb0Vmyt
        HRDZ9PnoUosf1alzVqK7FjWQjT8ocs95iS89SbT83dAmxCbUPzL3xQprUtBND+xp
        B7ZSr/WovEIJdDSxzhBQbxbYHsPGEQkO+8qBBMDHDMBCdc4ANh4kj0/VfADEsHHn
        NW7hziSCf4Kzr6vqjz97fWXevbIOmkjMJ6QCVEPSHVocscuLEh8ooyAn5tg/TeTM
        6+Ouczbx+IMPiw==
X-ME-Sender: <xms:L0QbXlNmbS0vbyiFrwkvNRsQZwMSCqUmtMNkud-WwmvfVWLECaDyOQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeikedgkeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepudelfe
    drgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:L0QbXqyyi8ngrHJ6SWXV20HKCfmwmjTcNP26cMBiFOO1k7sOI6p2WA>
    <xmx:L0QbXprU-d3U5UaxJZc3T_Vyzlw9Jog7isfSNo7eiA_yS1Rtpfeuaw>
    <xmx:L0QbXvdgqxCYgRBvuJDASEPdE5p0r8D356VkR6gO4aVtJIxEhb7uMw>
    <xmx:L0QbXo055uz0qPEUNY3_fQkG3QhUdCSg0XPAnHl_iW4sLlS9ToxzYA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3DA6480059;
        Sun, 12 Jan 2020 11:07:10 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 4/4] selftests: mlxsw: qos_mc_aware: Fix mausezahn invocation
Date:   Sun, 12 Jan 2020 18:06:41 +0200
Message-Id: <20200112160641.282108-5-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200112160641.282108-1-idosch@idosch.org>
References: <20200112160641.282108-1-idosch@idosch.org>
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

