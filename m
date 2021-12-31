Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B259D4822B9
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 09:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242740AbhLaIUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 03:20:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60650 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242710AbhLaIUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 03:20:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15704B81D5F
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 08:20:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750AEC36AED;
        Fri, 31 Dec 2021 08:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640938845;
        bh=FRFi4aH5f8PIGr2iNaBd8/IQ8uY9CuB0y7WvijtMPyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o39kA5hUhLc4fF9Yu/A1/Ym0uePCcVvDzE2t2k3oq/OsxbaDNy2swu7NN34ZeBmx5
         MYFfGFV4DZikO8Fmmv2Wpbvf3lSPvEQfqB2TF0FIXxezkjdUMR5QIKY4M78rQz2vQq
         V01F7tmiKH/RpeFQJPf38r7Fxx06r99bSwP93CrEnO74RTTYkMcOPAto4TKTf2yeMT
         RRocBo5345epWJaI90cybhS0NZXPbPkY1h9R+D9AzLq729+fC9dgmhCnxwghoAH5fK
         SrZjE2UDkGdb+BWQTLZAtSl1FGxjLouS9d2kSou+JYosMhMQ2B+pUEfzu+okLCDmmn
         fpiSBpirMzFLQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Hamdan Igbaria <hamdani@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v2 05/16] net/mlx5: DR, Add check for flex parser ID value
Date:   Fri, 31 Dec 2021 00:20:27 -0800
Message-Id: <20211231082038.106490-6-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211231082038.106490-1-saeed@kernel.org>
References: <20211231082038.106490-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Allow only legal values for flex parser ID - values from 0 to 7.
For other values skip the parser, and as a result the matcher creation
will fail for using invalid flex parser ID.

Signed-off-by: Hamdan Igbaria <hamdani@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
index b0649c2877dd..17bfd1ec0589 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
@@ -1704,7 +1704,7 @@ static void dr_ste_v0_set_flex_parser(u32 *misc4_field_id,
 	u32 id = *misc4_field_id;
 	u8 *parser_ptr;
 
-	if (parser_is_used[id])
+	if (id >= DR_NUM_OF_FLEX_PARSERS || parser_is_used[id])
 		return;
 
 	parser_is_used[id] = true;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index cb9cf67b0a02..a7772804f8e5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -1833,7 +1833,7 @@ static void dr_ste_v1_set_flex_parser(u32 *misc4_field_id,
 	u32 id = *misc4_field_id;
 	u8 *parser_ptr;
 
-	if (parser_is_used[id])
+	if (id >= DR_NUM_OF_FLEX_PARSERS || parser_is_used[id])
 		return;
 
 	parser_is_used[id] = true;
-- 
2.33.1

