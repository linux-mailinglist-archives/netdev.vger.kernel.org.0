Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F03374494
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237085AbhEEQ6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:58:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236717AbhEEQyq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:54:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EE096197D;
        Wed,  5 May 2021 16:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232722;
        bh=UWpbrYskpnh6yjz5JX5jnlSxDsV2p+ybcsR7Fj3BBc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C9dFVgi/f26//h5+iO/PYEMUcmOJbK0r/hqQAW//CC3vV/qbyHtf73EFfbniG+Nqc
         AFOVmFoZgo4m459gDFVyg/ltIoeU+K5Lb8ZhAD2KNgehbbVSSWVRgbLBvH4CZmRb7Q
         fDcviMqhumtWcvso3DlI1Io6TWOS3azkFg19pLhhwk9poPO/hYfQmOV/3F7tK/xM8e
         3hgJVbAfvR/USGm0fwkzxKakvEvYudP+Y4B5K7DenFBz97Bgze5Q8xYn0yHXT//Vm7
         ASoRd0c6QzJrW9IYxhkkexCO+WbBsWMRbLxX/keTaIJCTAktJHofZCN52DdAxGLz70
         M/ZlKr0JOoj5A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petr Machata <petrm@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 77/85] selftests: mlxsw: Increase the tolerance of backlog buildup
Date:   Wed,  5 May 2021 12:36:40 -0400
Message-Id: <20210505163648.3462507-77-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
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

