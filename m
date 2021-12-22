Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADEB747D88E
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 22:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237897AbhLVVMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 16:12:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237896AbhLVVMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 16:12:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB31EC061574
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 13:12:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57D3761D09
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 21:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4993BC36AED;
        Wed, 22 Dec 2021 21:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640207525;
        bh=KEbfdZDu+GX5u1oeQnorZYqSMWD00oTAQkkv9SQgQMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VcT2oBBSUxUZogqUWEJJ82SmRNt/91wYWMN9Fim5/cX/omnQO31gz5FPH+xLtzjgQ
         /Lk02L3kRPx44cweld/UMYLw2Xx/H4yQeWLd2U4TzweM3KziEhJdbrD20j13iQMkAY
         gg3bdk6du9I9Dw90WRwwXYCOj/uLpLQ+sLLTNxaxkvDnRXQbRoEcnJNt9H01ZQASR3
         fQTn3kXvwVnPTwcHp8ceWm4zlh/cO/L45S4+hpYjRwbzz6nIBIDLsc3Pc5PArxoMqY
         tdoD4XEcckjo4qUaJ8+EqmQVgx9IyRKtcHNOhGjS0n/v+hp7fwDvi/aHtYgqFY6Dff
         +Qm+XUbobLarw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 02/11] net/mlx5: DR, Fix querying eswitch manager vport for ECPF
Date:   Wed, 22 Dec 2021 13:11:52 -0800
Message-Id: <20211222211201.77469-3-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211222211201.77469-1-saeed@kernel.org>
References: <20211222211201.77469-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

On BlueField the E-Switch manager is the ECPF (vport 0xFFFE), but when
querying capabilities of ECPF eswitch manager, need to query vport 0
with other_vport = 0.

Fixes: 9091b821aaa4 ("net/mlx5: DR, Handle eswitch manager and uplink vports separately")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
index f6e6d9209766..c54cc45f63dc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -164,9 +164,7 @@ static int dr_domain_query_vport(struct mlx5dr_domain *dmn,
 
 static int dr_domain_query_esw_mngr(struct mlx5dr_domain *dmn)
 {
-	return dr_domain_query_vport(dmn,
-				     dmn->info.caps.is_ecpf ? MLX5_VPORT_ECPF : 0,
-				     false,
+	return dr_domain_query_vport(dmn, 0, false,
 				     &dmn->info.caps.vports.esw_manager_caps);
 }
 
-- 
2.33.1

