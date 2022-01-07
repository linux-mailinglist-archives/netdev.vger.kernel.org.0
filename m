Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CADF486ED9
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344322AbiAGAai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344325AbiAGAaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:30:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19AE1C034006
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 16:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC685B822D8
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 00:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5239FC36AEF;
        Fri,  7 Jan 2022 00:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641515416;
        bh=Xa/Z0J4arGYoq9Dt/4s+O8pBZ0CjeUNtcNBEOS0W+eU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IObkfA2j5UkVOmKvG+MTblaSIPqXIrsk1PACioEJHLyfHqOAlYg6B3hzWnqbCY+y3
         BwuC1K5dtmBBYEKRZuxeSqbjIgYblHoHExkAVR535ZmnvYMnhV8WHVp2eljz/Sok2G
         ED1DVJ3nM30lZReGQwd3yNFgIqc3tE/9ZuhJ80XF2NoqR7xhtnPXv+DH3/HCCq86/u
         3yhmAKhUxd9vfuWmefNLbsll4G9xBxlm5r/3nD+pBMJMs5555yooHB6wl0f816PAo1
         rrGSuJ5C+7d0FaFwEYBhCb3tpewRE6yw4J9h9aBp7E3u9uL3ull/GaF41Kz0nKex2d
         xn5fMvRfBZhwQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next 13/15] net/mlx5e: TC, Remove redundant error logging
Date:   Thu,  6 Jan 2022 16:29:54 -0800
Message-Id: <20220107002956.74849-14-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220107002956.74849-1-saeed@kernel.org>
References: <20220107002956.74849-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Remove redundant and trivial error logging when trying to
offload mirred device with unsupported devices.
Using OVS could hit those a lot and the errors are still
logged in extack.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c    | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
index a0832b86016c..c614fc7fdc9c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
@@ -45,14 +45,10 @@ verify_uplink_forwarding(struct mlx5e_priv *priv,
 					termination_table_raw_traffic)) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "devices are both uplink, can't offload forwarding");
-			pr_err("devices %s %s are both uplink, can't offload forwarding\n",
-			       priv->netdev->name, out_dev->name);
 			return -EOPNOTSUPP;
 	} else if (out_dev != rep_priv->netdev) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "devices are not the same uplink, can't offload forwarding");
-		pr_err("devices %s %s are both uplink but not the same, can't offload forwarding\n",
-		       priv->netdev->name, out_dev->name);
 		return -EOPNOTSUPP;
 	}
 	return 0;
@@ -160,10 +156,6 @@ tc_act_can_offload_mirred(struct mlx5e_tc_act_parse_state *parse_state,
 	}
 
 	NL_SET_ERR_MSG_MOD(extack, "devices are not on same switch HW, can't offload forwarding");
-	netdev_warn(priv->netdev,
-		    "devices %s %s not on same switch HW, can't offload forwarding\n",
-		    netdev_name(priv->netdev),
-		    out_dev->name);
 
 	return false;
 }
-- 
2.33.1

