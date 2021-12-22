Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7487447D892
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 22:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238328AbhLVVML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 16:12:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238012AbhLVVMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 16:12:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909EFC06173F
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 13:12:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30E7461C5E
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 21:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6796C36AE8;
        Wed, 22 Dec 2021 21:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640207528;
        bh=R54urKv5SKkq9+4bwdg/bmaYR+eb1LICW5jKG402pso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CondwWs7qFNrAQ3N3AgUUE7kRKIV5dMELC87bHpv8QM8URR6NcjlwCtMM+vtAPujk
         ugZWhiBmZuqLhA/jDBQ9WaPnIpswbcGSujtji3oetWE+ExaDzw6IRqu793feQRDNdX
         1/0gw38sADED/grW7yh8PZzuE29JvdrMVwrnz97eIxCIXfeVJoet6emLCidF8VBh/2
         H+uF1omS2L+MO0UdPp/LF4zTs/3Y0YwUXwcyTl/YENKRLtKscMWzk4sGbfUXCWH9sy
         OD0ER43qPtoA4Mo3DHF5x6Y5ipz6FhFwpceLsrOf1a5GV2INuUNV6tnvKSiw8ooMPY
         oS6or7eL1tjNA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Chris Mi <cmi@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 06/11] net/mlx5: Fix tc max supported prio for nic mode
Date:   Wed, 22 Dec 2021 13:11:56 -0800
Message-Id: <20211222211201.77469-7-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211222211201.77469-1-saeed@kernel.org>
References: <20211222211201.77469-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

Only prio 1 is supported if firmware doesn't support ignore flow
level for nic mode. The offending commit removed the check wrongly.
Add it back.

Fixes: 9a99c8f1253a ("net/mlx5e: E-Switch, Offload all chain 0 priorities when modify header and forward action is not supported")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
index 97e5845b4cfd..d5e47630e284 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
@@ -121,6 +121,9 @@ u32 mlx5_chains_get_nf_ft_chain(struct mlx5_fs_chains *chains)
 
 u32 mlx5_chains_get_prio_range(struct mlx5_fs_chains *chains)
 {
+	if (!mlx5_chains_prios_supported(chains))
+		return 1;
+
 	if (mlx5_chains_ignore_flow_level_supported(chains))
 		return UINT_MAX;
 
-- 
2.33.1

