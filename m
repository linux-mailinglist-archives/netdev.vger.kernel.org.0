Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605DB48108D
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 07:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239043AbhL2Gx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 01:53:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239042AbhL2Gx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 01:53:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0EEC061574
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 22:53:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F89B6144D
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 06:53:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2982EC36AE7;
        Wed, 29 Dec 2021 06:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640760836;
        bh=PsKXlnm81B/bSHwF86xHvRG9fMY698VPMbNxbZAe2CM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sdg5cnUTyjja/iHVr0dzKr2fIAA+2mzAnpHM3GMPBD3OdXSZN6ccAwlAPGiHwBwzP
         S00kHnekH0DPM9725gpKZygIgkF4XbHJX/qs9lhdWwJIi7g09NbhOBLnwJ+oYxKDoc
         aK4sWZbv5qgBSfPw6gfe5fCMaUIiERr0aJ2vPG/nYzRicRKZyd/xJN8MAftdokp74q
         eLZge/CV897OrZ0eEegQV9RLr292FFSLr7D1faKyGhHZwJ90SxNEBoLwt6Qvwuss23
         Vb2ksv6g6Jvu7DgIE9OgzO6NIBWhd7GkDNgocQG8nIPGmhUhLK+RMbD3Y9lbqYClW2
         WOYuEuJRDzYeg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 1/2] net/mlx5e: TC, Fix memory leak with rules with internal port
Date:   Tue, 28 Dec 2021 22:53:51 -0800
Message-Id: <20211229065352.30178-2-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211229065352.30178-1-saeed@kernel.org>
References: <20211229065352.30178-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Fix a memory leak with decap rule with internal port as destination
device. The driver allocates a modify hdr action but doesn't set
the flow attr modify hdr action which results in skipping releasing
the modify hdr action when releasing the flow.

backtrace:
    [<000000005f8c651c>] krealloc+0x83/0xd0
    [<000000009f59b143>] alloc_mod_hdr_actions+0x156/0x310 [mlx5_core]
    [<000000002257f342>] mlx5e_tc_match_to_reg_set_and_get_id+0x12a/0x360 [mlx5_core]
    [<00000000b44ea75a>] mlx5e_tc_add_fdb_flow+0x962/0x1470 [mlx5_core]
    [<0000000003e384a0>] __mlx5e_add_fdb_flow+0x54c/0xb90 [mlx5_core]
    [<00000000ed8b22b6>] mlx5e_configure_flower+0xe45/0x4af0 [mlx5_core]
    [<00000000024f4ab5>] mlx5e_rep_indr_offload.isra.0+0xfe/0x1b0 [mlx5_core]
    [<000000006c3bb494>] mlx5e_rep_indr_setup_tc_cb+0x90/0x130 [mlx5_core]
    [<00000000d3dac2ea>] tc_setup_cb_add+0x1d2/0x420

Fixes: b16eb3c81fe2 ("net/mlx5: Support internal port as decap route device")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index a60c7680fd2b..5e454a14428f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1441,6 +1441,8 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 							metadata);
 			if (err)
 				goto err_out;
+
+			attr->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
 		}
 	}
 
-- 
2.33.1

