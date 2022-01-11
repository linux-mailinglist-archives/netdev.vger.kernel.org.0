Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB1348A540
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346276AbiAKBoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:44:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346270AbiAKBn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 20:43:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2856AC06175A
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 17:43:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E4C96149C
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 01:43:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E680C36AE5;
        Tue, 11 Jan 2022 01:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641865434;
        bh=5EygMjZnu1iSniO3xt5Vu5t0+06A1g5PlZQTypW94y4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o0hldvzruQawYeWnuvKAhZKId92prYpouLhRBXiRvfgEY8g8Y4NLaQ0m/TAPG4pus
         0DyiLcyCgK7tK5RH1Vg1fqmC6NN7MUPRiu3qJZZ5OMllx8iSKcQAVtWq1nZ6mh4Rk+
         3aMvra9duaHdC/ExcDWie9wpAp/rYVaKWSM9/pI6wPaPpfVeM2a2vnLRR+BPVV2VGP
         kq2ow4tVJ/AENZVY85J/m2gD82+w9R000mg0kAfUaH0VES8zsMtn8osGN/Xrk18bxM
         F208HCLsCpLG1HfF5/J5yPua3hg+e3GQu65JE4XwBeibrY+4mLsWC7KiW7pWui7WpG
         RRDs2+xYVOdDQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dima Chumak <dchumak@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 17/17] net/mlx5: VLAN push on RX, pop on TX
Date:   Mon, 10 Jan 2022 17:43:35 -0800
Message-Id: <20220111014335.178121-18-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220111014335.178121-1-saeed@kernel.org>
References: <20220111014335.178121-1-saeed@kernel.org>
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

