Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5C8C486EDA
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344323AbiAGAaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:30:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55062 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344234AbiAGAaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:30:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 149EEB822D9
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 00:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B266C36AEF;
        Fri,  7 Jan 2022 00:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641515414;
        bh=AbFgw8oo5k+Y3D2F1Praxgoo0PyLl6qhMsXPOxcjoZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DWceNeuXUv61Y8nmoZgaVEfCCKLltKx0XI1h8/gmmlPy0bwxsLiuG+QZDRykZT9TQ
         +fqr+Du8NLVq0JgGnTxY8lXubdFZJ5BWDPBWcXZ9Ky9B25W2zFDES3O2+5sBFj4WPk
         fIU6djW2RyaqrnZ9BOE6r/8kYoiQtcaNxRm8yzrNOvyWpfbn4TGEWcnfkYRkdzsbdn
         TotsAy6sswF3ouCcqL4onqxU07/+dojTUTCRnXyUJFxQcCujUA5zWRfyz9hwKKcCEV
         qrvZWqvnzvug6/gKpME4j7JyZPw/zm88owdsWIXiE4LBvGiAbSd69AuFmGzrlF8j0R
         D+fK4NhzIB1Qw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next 09/15] net/mlx5e: Unblock setting vid 0 for VF in case PF isn't eswitch manager
Date:   Thu,  6 Jan 2022 16:29:50 -0800
Message-Id: <20220107002956.74849-10-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220107002956.74849-1-saeed@kernel.org>
References: <20220107002956.74849-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

When using libvirt to passthrough VF to VM it will always set the VF vlan
to 0 even if user didn’t request it, this will cause libvirt to fail to
boot in case the PF isn't eswitch owner.

Example of such case is the DPU host PF which isn't eswitch manager, so
any attempt to passthrough VF of it using libvirt will fail.

Fix it by not returning error in case set VF vlan is called with vid 0.

Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
index 2b52f7c09152..9d17206d1625 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
@@ -431,7 +431,7 @@ int mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw,
 	int err = 0;
 
 	if (!mlx5_esw_allowed(esw))
-		return -EPERM;
+		return vlan ? -EPERM : 0;
 
 	if (vlan || qos)
 		set_flags = SET_VLAN_STRIP | SET_VLAN_INSERT;
-- 
2.33.1

