Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69D4249EC97
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 21:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344101AbiA0Uk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 15:40:28 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46352 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344076AbiA0UkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 15:40:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAF2FB8238F
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 20:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 614DDC340EA;
        Thu, 27 Jan 2022 20:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643316019;
        bh=5EygMjZnu1iSniO3xt5Vu5t0+06A1g5PlZQTypW94y4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=elR4I7Ph1WwlBvBsqASKXhgYbYgM5QxfXsg15ff0Gy6flhyE8tdkJ2gd3Th6O12ZM
         J3YxT9bQ45QGGjUYWPLjZpo+9fvHtV3J0bIiTEy2wkASzsqQoBueZff2bNjFCZVSbJ
         DjJctYYyKjE20o3/w3uny1Wrr6QR6KZ+CWuCZY3b2sB5PzYX7G7wfmjoIfBJgiIL1+
         DFPzCUomYluA3UTZ7ucxuMKFngoybS8s7R73bIuBDJpvmCoOA1oaV66WhBiLAoxFR5
         VP7qA0CUZ0vuz86k9MWS2NOBSrTLcO3KPlAWEt/HarFRWsalvywvHJH2xtBZv3oVKZ
         kPnV5yjf3P3nQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dima Chumak <dchumak@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next RESEND 17/17] net/mlx5: VLAN push on RX, pop on TX
Date:   Thu, 27 Jan 2022 12:40:07 -0800
Message-Id: <20220127204007.146300-18-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220127204007.146300-1-saeed@kernel.org>
References: <20220127204007.146300-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dima Chumak <dchumak@nvidia.com>

Some older NIC hardware isn't capable of doing VLAN push on RX and pop
on TX.

A workaround has been added in software to support it, but it has a
performance penalty since it requires a hairpin + loopback.

There's no such limitation with the newer NICs, so no need to pay the
price of the w/a. With this change the software w/a is disabled for
certain HW versions and steering modes that support it.

Signed-off-by: Dima Chumak <dchumak@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c    | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index 4b354aed784a..ee568bf34ae2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -224,7 +224,9 @@ mlx5_eswitch_termtbl_required(struct mlx5_eswitch *esw,
 		return false;
 
 	/* push vlan on RX */
-	if (flow_act->action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH)
+	if (flow_act->action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH &&
+	    !(mlx5_fs_get_capabilities(esw->dev, MLX5_FLOW_NAMESPACE_FDB) &
+	      MLX5_FLOW_STEERING_CAP_VLAN_PUSH_ON_RX))
 		return true;
 
 	/* hairpin */
-- 
2.34.1

