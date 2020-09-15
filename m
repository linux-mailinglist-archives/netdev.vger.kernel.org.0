Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C13926B03F
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgIOWFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:05:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:54390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727788AbgIOU0w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 16:26:52 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5114F21D91;
        Tue, 15 Sep 2020 20:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600201559;
        bh=Otn5AXqU7jSSGF4Kp7jdoMkKIFC8yC7olVrEaqpjakU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jjgDLvZbJwFFNo9P9d43IHhM9Ajy1aoRH6yBrDJN6UgWezxv8Ft338VPjd0o+t+fN
         jCKC/wwJM4Ohv/IZjwIVn6AtOooWZEEUV7UCDbLdt5hAH3yhoNKQKYcSGgENeWgzvG
         gKSI0b5+mzde/g00OtlqrTa6nU+YYo0+Yr88wLMg=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vu Pham <vuhuong@mellanox.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/16] net/mlx5: E-Switch, Dedicated metadata for uplink vport
Date:   Tue, 15 Sep 2020 13:25:28 -0700
Message-Id: <20200915202533.64389-12-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915202533.64389-1-saeed@kernel.org>
References: <20200915202533.64389-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vu Pham <vuhuong@mellanox.com>

Uplink vport must have a dedicated metadata with vhca_id
being part of the metadata.

Fixes: 133dcfc577ea ("net/mlx5: E-Switch, Alloc and free unique metadata for match")
Signed-off-by: Vu Pham <vuhuong@mellanox.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 4cbadb15297c..9c740ce73085 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1908,9 +1908,6 @@ void mlx5_esw_match_metadata_free(struct mlx5_eswitch *esw, u32 metadata)
 static int esw_offloads_vport_metadata_setup(struct mlx5_eswitch *esw,
 					     struct mlx5_vport *vport)
 {
-	if (vport->vport == MLX5_VPORT_UPLINK)
-		return 0;
-
 	vport->default_metadata = mlx5_esw_match_metadata_alloc(esw);
 	vport->metadata = vport->default_metadata;
 	return vport->metadata ? 0 : -ENOSPC;
@@ -1919,7 +1916,7 @@ static int esw_offloads_vport_metadata_setup(struct mlx5_eswitch *esw,
 static void esw_offloads_vport_metadata_cleanup(struct mlx5_eswitch *esw,
 						struct mlx5_vport *vport)
 {
-	if (vport->vport == MLX5_VPORT_UPLINK || !vport->default_metadata)
+	if (!vport->default_metadata)
 		return;
 
 	WARN_ON(vport->metadata != vport->default_metadata);
-- 
2.26.2

