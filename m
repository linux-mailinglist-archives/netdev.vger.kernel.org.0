Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D8A457772
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 20:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235074AbhKSUBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 15:01:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:49816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234371AbhKSUBV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 15:01:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2FE561B39;
        Fri, 19 Nov 2021 19:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637351899;
        bh=LeN4n+LgVwGlxSKYNOW2g9G7+oZ2PGVzLc/S7GtItF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bsJZ4SI9WUtPc1/tr43I+KETO7AM2Gt/n0vZAqDxS27TKk2gVi5cKyH3S/vnmWg74
         DY7Kyyte2UffAZ9Qh3jC1W5WYPXPWocD1U5iGW8etIufrPXR8U3hZPJLZwIkWHaOqh
         oY0hW0qYmNqkzXKjdjsELWsUUzcKfwpgAJ4LWIuxLMJk5Yyjv78NIFOWiyFAurHaNP
         0cOYPDhQu5Lg0Ya9f/gJw8e95RsLI9rYbkGHWCSkNbLT6Tu7tU73uhNROLpZEOIu5v
         ZuuKZlw9ZiQimdKXSrA1EtvOprUOPG+dOYETWpIHAVSds8Poe+GSBAQc7rABiDzPYt
         Q+LYe0y6UWyDQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dmytro Linkin <dlinkin@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Parav Pandit <parav@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 01/10] net/mlx5: E-switch, Respect BW share of the new group
Date:   Fri, 19 Nov 2021 11:58:04 -0800
Message-Id: <20211119195813.739586-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211119195813.739586-1-saeed@kernel.org>
References: <20211119195813.739586-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

To enable transmit schduler on vport FW require non-zero configuration
for vport's TSAR. If vport added to the group which has configured BW
share value and TX rate values of the vport are zero, then scheduler
wouldn't be enabled on this vport.
Fix that by calling BW normalization if BW share of the new group is
configured.

Fixes: 0fe132eac38c ("net/mlx5: E-switch, Allow to add vports to rate groups")
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index c6cc67cb4f6a..4501e3d737f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -423,7 +423,7 @@ static int esw_qos_vport_update_group(struct mlx5_eswitch *esw,
 		return err;
 
 	/* Recalculate bw share weights of old and new groups */
-	if (vport->qos.bw_share) {
+	if (vport->qos.bw_share || new_group->bw_share) {
 		esw_qos_normalize_vports_min_rate(esw, curr_group, extack);
 		esw_qos_normalize_vports_min_rate(esw, new_group, extack);
 	}
-- 
2.31.1

