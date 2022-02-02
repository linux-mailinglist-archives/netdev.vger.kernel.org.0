Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62334A6B2F
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 06:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbiBBFGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 00:06:43 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49026 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbiBBFGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 00:06:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD09F6172A
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 05:06:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85353C340F0;
        Wed,  2 Feb 2022 05:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643778394;
        bh=eI6WBy5i5v+RehOq7W5o5OhIb2MK2Po8C2xZav9ewv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zf6Pjaw34fayob3ycCGw9o/gK+ushET8TV5GLMk0vp1Dexo1aE93M8FKKX6HgYGtE
         AxNI3TrrrFOPWMm6pVvarUf+7jOa77jskqRVFC3AXjdx8bg/aXJlnoYnE4EzcoZcxk
         bAjtmiKaxZpgkU8wY8N8YELasW9OVNVjwGPi0UHkjUgkSrxA7r/PExV0MKhZvALi41
         SUqauALG+6MjeGJrxEnffOkaoKyLPTQz3VIqcliKPeOQUTRHibUXMB+2qWpjGn/4ji
         O8yHyFJxB+p7xxQCdXgrXZO3LYcG6yKnUkqgIW5ryrnmoTq08i1hFGclN+txJAUzUT
         mUlaZuNzQlzKQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
        Wang Yugui <wangyugui@e16-tech.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 04/18] net/mlx5e: Fix module EEPROM query
Date:   Tue,  1 Feb 2022 21:03:50 -0800
Message-Id: <20220202050404.100122-5-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220202050404.100122-1-saeed@kernel.org>
References: <20220202050404.100122-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>

When querying the module EEPROM, there was a misusage of the 'offset'
variable vs the 'query.offset' field.
Fix that by always using 'offset' and assigning its value to
'query.offset' right before the mcia register read call.

While at it, the cross-pages read size adjustment was changed to be more
intuitive.

Fixes: e19b0a3474ab ("net/mlx5: Refactor module EEPROM query")
Reported-by: Wang Yugui <wangyugui@e16-tech.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/port.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index 1ef2b6a848c1..7b16a1188aab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -406,23 +406,24 @@ int mlx5_query_module_eeprom(struct mlx5_core_dev *dev,
 
 	switch (module_id) {
 	case MLX5_MODULE_ID_SFP:
-		mlx5_sfp_eeprom_params_set(&query.i2c_address, &query.page, &query.offset);
+		mlx5_sfp_eeprom_params_set(&query.i2c_address, &query.page, &offset);
 		break;
 	case MLX5_MODULE_ID_QSFP:
 	case MLX5_MODULE_ID_QSFP_PLUS:
 	case MLX5_MODULE_ID_QSFP28:
-		mlx5_qsfp_eeprom_params_set(&query.i2c_address, &query.page, &query.offset);
+		mlx5_qsfp_eeprom_params_set(&query.i2c_address, &query.page, &offset);
 		break;
 	default:
 		mlx5_core_err(dev, "Module ID not recognized: 0x%x\n", module_id);
 		return -EINVAL;
 	}
 
-	if (query.offset + size > MLX5_EEPROM_PAGE_LENGTH)
+	if (offset + size > MLX5_EEPROM_PAGE_LENGTH)
 		/* Cross pages read, read until offset 256 in low page */
-		size -= offset + size - MLX5_EEPROM_PAGE_LENGTH;
+		size = MLX5_EEPROM_PAGE_LENGTH - offset;
 
 	query.size = size;
+	query.offset = offset;
 
 	return mlx5_query_mcia(dev, &query, data);
 }
-- 
2.34.1

