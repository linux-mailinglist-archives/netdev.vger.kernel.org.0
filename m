Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D54D486F49
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344927AbiAGA65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:58:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344885AbiAGA6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:58:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835BDC0611FF
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 16:58:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4C4AB824A2
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 00:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385BAC36AE0;
        Fri,  7 Jan 2022 00:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641517125;
        bh=ZOYenHzMn7wIOXk8PbLdv9Q0+i4+EWKx3hAps4IPEPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W2vVLKQRGxLJAVn5Fzns4A8rsl1TzemZyU8kB80vCmKIL94vGZKKHWYbu03d4Ihs6
         ecXodTjZ6wJxxREkh+tbMey4cGbQLOtbum7U8eMn8/Vq/aw2l65GtS6OPgu27NQYmZ
         WCHzvTb/eO7//9iHcpa7cfZllUdvn4P0iomLcHDbP4DIR9/22jCkNAhcBgEJoaEtbY
         HvHf1H2g09VNT7fIU78JzzhWbkD89hy02XWrAKYgsv0cxL0mceI52SAkwhCyh5zdu8
         l5ohBzk+MFa25LaAoX4ivifnTQ13dRwEvnkSVnFqxb7m1e/l+H5MttOCd0iXwqXpyy
         JB/0kMLN7ZKZw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 04/11] net/mlx5e: Don't block routes with nexthop objects in SW
Date:   Thu,  6 Jan 2022 16:58:24 -0800
Message-Id: <20220107005831.78909-5-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220107005831.78909-1-saeed@kernel.org>
References: <20220107005831.78909-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

Routes with nexthop objects is currently not supported by multipath offload
and any attempts to use it is blocked, however this also block adding SW
routes with nexthop.

Resolve this by returning NOTIFY_DONE instead of an error which will allow such
a route to be created in SW but not offloaded.

This fix also solve an issue which block adding such routes on different devices
due to missing check if the route FIB device is one of multipath devices.

Fixes: 6a87afc072c3 ("mlx5: Fail attempts to use routes with nexthop objects")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
index bf4d3cbefa63..1ca01a5b6cdd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
@@ -268,10 +268,8 @@ static int mlx5_lag_fib_event(struct notifier_block *nb,
 		fen_info = container_of(info, struct fib_entry_notifier_info,
 					info);
 		fi = fen_info->fi;
-		if (fi->nh) {
-			NL_SET_ERR_MSG_MOD(info->extack, "IPv4 route with nexthop objects is not supported");
-			return notifier_from_errno(-EINVAL);
-		}
+		if (fi->nh)
+			return NOTIFY_DONE;
 		fib_dev = fib_info_nh(fen_info->fi, 0)->fib_nh_dev;
 		if (fib_dev != ldev->pf[MLX5_LAG_P1].netdev &&
 		    fib_dev != ldev->pf[MLX5_LAG_P2].netdev) {
-- 
2.33.1

