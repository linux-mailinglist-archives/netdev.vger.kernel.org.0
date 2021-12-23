Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 797EC47E7DE
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 20:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244876AbhLWTEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 14:04:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244865AbhLWTEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 14:04:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D9BC061401
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 11:04:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F56C61F6D
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 19:04:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277E8C36AEC;
        Thu, 23 Dec 2021 19:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640286287;
        bh=KEbfdZDu+GX5u1oeQnorZYqSMWD00oTAQkkv9SQgQMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LoimuE1qnHb5lwBDlzJ7TBooAvSz0pRVB5cxDDsaU6aFqFEotrEHr8tAUgIMPwBZ1
         gLyhI8HloVQul2pXih+Uv7U2M3Ox1bKyG2+PsZGpH7d4sV+hkBaIYnFcw+we/8jcjo
         Sd6WjtUMDyGUFn8SfxsTDUfZ3NGChSiYZerntDN4C+SdWkrJj7LAETLD3bzh5l1HaJ
         MAUsSQz9qxQCND+kj3bw5WhAipcTzpagrSL0gKDQt0m+mMRe1Jizo6lSKTHSTiAnBT
         R0oqvjSQMbsKk2+450Vsj+t/MyqIVGIpaQX5iqkZf8pnDKzHD/LSlfpIL/oIpucaOK
         x4BEDy94GZV5A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [v2 net 02/12] net/mlx5: DR, Fix querying eswitch manager vport for ECPF
Date:   Thu, 23 Dec 2021 11:04:31 -0800
Message-Id: <20211223190441.153012-3-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211223190441.153012-1-saeed@kernel.org>
References: <20211223190441.153012-1-saeed@kernel.org>
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

