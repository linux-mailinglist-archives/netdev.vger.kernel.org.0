Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0920DF663F
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 04:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbfKJCnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 21:43:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:40686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728191AbfKJCnL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:43:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6CEB21D82;
        Sun, 10 Nov 2019 02:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353790;
        bh=QBninmn1N0bnodZPUNG5LFWIH1SXzGqrLbKpZ9NwMJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r9AygsUkmvWFQPwintV9fYBXWmrhYceVdTxHoAUj0FHfLH/pk5gvGiEBvO9hhU65U
         KkFU4qsamBWzxYF8TIHGZGfmdjXjrY1BfnO/dWX4VDjh6GFKr2aSyNGZYmTQ1yyH/U
         uO9DjAEaqngPmJJUmD15a3NbU6Mrgexch7I7kHIA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 091/191] mlxsw: Make MLXSW_SP1_FWREV_MINOR a hard requirement
Date:   Sat,  9 Nov 2019 21:38:33 -0500
Message-Id: <20191110024013.29782-91-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

[ Upstream commit 12ba7e1045521ec9f251c93ae0a6735cc3f42337 ]

Up until now, mlxsw tolerated firmware versions that weren't exactly
matching the required version, if the branch number matched. That
allowed the users to test various firmware versions as long as they were
on the right branch.

On the other hand, it made it impossible for mlxsw to put a hard lower
bound on a version that fixes all problems known to date. If a user had
a somewhat older FW version installed, mlxsw would start up just fine,
possibly performing non-optimally as it would use features that trigger
problematic behavior.

Therefore tweak the check to accept any FW version that is:

- on the same branch as the preferred version, and
- the same as or newer than the preferred version.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 1c170a0fd2cc9..e498ee95bacab 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -336,7 +336,10 @@ static int mlxsw_sp_fw_rev_validate(struct mlxsw_sp *mlxsw_sp)
 		return -EINVAL;
 	}
 	if (MLXSW_SP_FWREV_MINOR_TO_BRANCH(rev->minor) ==
-	    MLXSW_SP_FWREV_MINOR_TO_BRANCH(req_rev->minor))
+	    MLXSW_SP_FWREV_MINOR_TO_BRANCH(req_rev->minor) &&
+	    (rev->minor > req_rev->minor ||
+	     (rev->minor == req_rev->minor &&
+	      rev->subminor >= req_rev->subminor)))
 		return 0;
 
 	dev_info(mlxsw_sp->bus_info->dev, "The firmware version %d.%d.%d is incompatible with the driver\n",
-- 
2.20.1

