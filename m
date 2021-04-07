Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0773562BB
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 06:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348541AbhDGEyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 00:54:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344853AbhDGEyq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 00:54:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAC7F613D4;
        Wed,  7 Apr 2021 04:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617771277;
        bh=eKECfj9qkCvgOYdLUSUuDluZmj5O/0YE08RRp39/xO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LqdYsBqOoVvdgs5bbS41kyvJ2E3Kh4x2BG1a2c6hWFI5sys0uqYw7fqFqIqL5Zn0W
         S6rIQvcQzc8BRusHLIS4D1FJTI+dMzj15+iXkymDptaS314SKoU9njnLEyNRrpc2GD
         WTgNLIrQj4rruzRT11pWvQcm2fODNkvkz7Y/n/uxTh+LySfT5xqU5PP6zIhIEgRc4z
         +Z0mzCU39dui/ojE9BA1/Rekl6xxb1sWsvuZd9JdnyIyPG2UWwBll06xEHiDfMGdsT
         NDJUhJ7KUbUpzoviF5/DS9aMHnMyPF1os618DwwPmJ+EOXEgfQXuAWFMFCJdxnja+F
         V8/GJIlZTcCVA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Chris Mi <cmi@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/13] net/mlx5: E-switch, Set per vport table default group number
Date:   Tue,  6 Apr 2021 21:54:12 -0700
Message-Id: <20210407045421.148987-5-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210407045421.148987-1-saeed@kernel.org>
References: <20210407045421.148987-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

Different per voprt table is created using a different per vport table
namespace. Because we can't use variable to set the namespace member
value.  If max group number is 0 in the namespace, use the eswitch
default max group number.

Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/vporttbl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/vporttbl.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/vporttbl.c
index abba1b801048..9e72118f2e4c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/vporttbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/vporttbl.c
@@ -28,7 +28,10 @@ esw_vport_tbl_create(struct mlx5_eswitch *esw, struct mlx5_flow_namespace *ns,
 	struct mlx5_flow_table_attr ft_attr = {};
 	struct mlx5_flow_table *fdb;
 
-	ft_attr.autogroup.max_num_groups = vport_ns->max_num_groups;
+	if (vport_ns->max_num_groups)
+		ft_attr.autogroup.max_num_groups = vport_ns->max_num_groups;
+	else
+		ft_attr.autogroup.max_num_groups = esw->params.large_group_num;
 	ft_attr.max_fte = vport_ns->max_fte;
 	ft_attr.prio = FDB_PER_VPORT;
 	ft_attr.flags = vport_ns->flags;
-- 
2.30.2

