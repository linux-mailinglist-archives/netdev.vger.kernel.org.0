Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52A53741C9
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234717AbhEEQlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:41:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:39568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235309AbhEEQjK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:39:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7822261574;
        Wed,  5 May 2021 16:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232435;
        bh=UWpbrYskpnh6yjz5JX5jnlSxDsV2p+ybcsR7Fj3BBc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p+nKMUFNHruH4kMSyMIAoslUkBEAUGuxYNhMP21PP/wVU32FidyGtAskDRx7L0cor
         R9bhX9HhqaKytpavXHn+2DWcp+dsUCxORCz3xcxRatjalhgYKpNXrsOzgTBCOIjetm
         D0mDAYNJoH8658O4G/ZS29i/Vt/osXn4lISf3et5chcv+EoLnZXjtcbtD70m2zzRpW
         S6rfd7E6rJ2L6aSgKZYQ8T2YdyKhPuPGo6Cu+MEtyjsXT6UThFSK7mWxI5RN4Vvjqs
         0HvG7Ah988Bbn9imclf6EogTUklns9oO1+nK4GlMsOEAOvDFDybjpdW1oFuyrm6WTT
         iWttvlwH0pNJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petr Machata <petrm@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 106/116] selftests: mlxsw: Increase the tolerance of backlog buildup
Date:   Wed,  5 May 2021 12:31:14 -0400
Message-Id: <20210505163125.3460440-106-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit dda7f4fa55839baeb72ae040aeaf9ccf89d3e416 ]

The intention behind this test is to make sure that qdisc limit is
correctly projected to the HW. However, first, due to rounding in the
qdisc, and then in the driver, the number cannot actually be accurate. And
second, the approach to testing this is to oversubscribe the port with
traffic generated on the same switch. The actual backlog size therefore
fluctuates.

In practice, this test proved to be noisier than the rest, and spuriously
fails every now and then. Increase the tolerance to 10 % to avoid these
issues.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Acked-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
index b0cb1aaffdda..33ddd01689be 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
@@ -507,8 +507,8 @@ do_red_test()
 	check_err $? "backlog $backlog / $limit Got $pct% marked packets, expected == 0."
 	local diff=$((limit - backlog))
 	pct=$((100 * diff / limit))
-	((0 <= pct && pct <= 5))
-	check_err $? "backlog $backlog / $limit expected <= 5% distance"
+	((0 <= pct && pct <= 10))
+	check_err $? "backlog $backlog / $limit expected <= 10% distance"
 	log_test "TC $((vlan - 10)): RED backlog > limit"
 
 	stop_traffic
-- 
2.30.2

