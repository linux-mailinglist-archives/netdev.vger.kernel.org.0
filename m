Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0D3481051
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 07:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238963AbhL2GZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 01:25:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58268 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238946AbhL2GZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 01:25:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E047B81829
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 06:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7C4C36AE9;
        Wed, 29 Dec 2021 06:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640759107;
        bh=dYuqV+fMvKlVczTo3uGWCZx32SFEv7gpUtAeaWIUWKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T2CDsHHDFXukLQdC48CSyzIqzmofb9wZLkn659OxQIV7K37W5kB06d1cxDJQJoDFp
         yA5eisFm/UaEsDAwLT/zsHbnvcICtr7alYOAUfii8qx+vJ9KKKSYLa8jndMV6nJs4S
         INhEJpNSlp2gedxNltvgtheNx6y81nf/sErVh/NX2lGX9sju6mIXiKEWKCzlOYQclQ
         t4n7OgQKPI93utWsRnLKPME+E48h3LCiBjQIid1SCrx9JUqrdbvaS2wDTtLAp6Mvjp
         /yjUDZT0kZ7phwE8wyKW5k9Usu6MCbMFcjr7Bi8mWlrx11Ozrl5BvVNog/f/119ktE
         x42DsUSrVJFgw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Hamdan Igbaria <hamdani@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next  05/16] net/mlx5: DR, Add check for flex parser ID value
Date:   Tue, 28 Dec 2021 22:24:51 -0800
Message-Id: <20211229062502.24111-6-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211229062502.24111-1-saeed@kernel.org>
References: <20211229062502.24111-1-saeed@kernel.org>
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
Reviewed-by: Alex Vesker <valex@nvidia.com>
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

