Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A496B3FF3D4
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 21:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347319AbhIBTHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 15:07:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347265AbhIBTHI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 15:07:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5032160F21;
        Thu,  2 Sep 2021 19:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630609569;
        bh=zmQRImXug+aMp0HX6fm5FgIAq70Fgi9BnDY2gEr5iMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dYsWILwgSietvDc2+/p+C7b2GpYkUnNKAg9D30DWdCuZq9fGBPfl7Ylebrr4pENss
         wHbykN4vO4PPy+CqpDMG55KExYVhqQuna+TBwvjUHCs+E0L68kt0O/iAxBYqQvpXyS
         JxHiGW9Qq4hviri+/N/9De47Pvv3mK6ZnszqPDrQ3W+rBerCjv0Qw1eUTzpom2AhTI
         tplgxK56rprKr3egza3iI6v6G5XnoFSPzzfHL2ytO289LGzs73KU+et7U56MMybs+m
         xmFJQ90BXnkW2ft4ipP+TVF3/cD+76UiKOiJd4oz22MQlEeuRZXE3aDSBJgDqNlQwg
         LZ9KcVgmLofNA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dima Chumak <dchumak@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/15] net/mlx5e: Enable TC offload for egress MACVLAN
Date:   Thu,  2 Sep 2021 12:05:50 -0700
Message-Id: <20210902190554.211497-12-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210902190554.211497-1-saeed@kernel.org>
References: <20210902190554.211497-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dima Chumak <dchumak@nvidia.com>

Support offloading of TC rules that mirror/redirect egress traffic to a
MACVLAN device, which is attached to mlx5 representor net device.

Signed-off-by: Dima Chumak <dchumak@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 07ab02f7b284..0e03cefc5eeb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -39,6 +39,7 @@
 #include <linux/rhashtable.h>
 #include <linux/refcount.h>
 #include <linux/completion.h>
+#include <linux/if_macvlan.h>
 #include <net/tc_act/tc_pedit.h>
 #include <net/tc_act/tc_csum.h>
 #include <net/psample.h>
@@ -3907,6 +3908,9 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 						return err;
 				}
 
+				if (netif_is_macvlan(out_dev))
+					out_dev = macvlan_dev_real_dev(out_dev);
+
 				err = verify_uplink_forwarding(priv, flow, out_dev, extack);
 				if (err)
 					return err;
-- 
2.31.1

