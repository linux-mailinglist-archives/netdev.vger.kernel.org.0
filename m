Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6634127F8B7
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 06:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730333AbgJAEd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 00:33:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgJAEdR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 00:33:17 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21CCE221E7;
        Thu,  1 Oct 2020 04:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601526797;
        bh=SfJlRAh/d580cw4lXOoom/HxOvfaO09xe9yhaT6a/cE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=knxEylo5aC8aU1rwzF4tlD2DAtt8XI0CppUE24rz2+xdD2AVj5CUOk44c0cNuj9Qk
         QrLHaCMTW4tVwCy9Mk1bluIsL0wH5zlOUIUxHOrgN63ql1S/bZWLU0t6TbpISxh83O
         4cw0bSO18GqCtcHRRsDgmlSYeWmBl7VXQVJfhmps=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/15] net/mlx5: E-switch, Add helper to check egress ACL need
Date:   Wed, 30 Sep 2020 21:32:55 -0700
Message-Id: <20201001043302.48113-9-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001043302.48113-1-saeed@kernel.org>
References: <20201001043302.48113-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Currently only VF vports need egress ACL table.
Add a generic helper to check whether a vport need egress
ACL table or not.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c | 8 ++++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c    | 8 +++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
index 07b2acd7e6b3..c3faae67e4d6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
@@ -148,6 +148,11 @@ static void esw_acl_egress_ofld_groups_destroy(struct mlx5_vport *vport)
 	esw_acl_egress_vlan_grp_destroy(vport);
 }
 
+static bool esw_acl_egress_needed(const struct mlx5_eswitch *esw, u16 vport_num)
+{
+	return mlx5_eswitch_is_vf_vport(esw, vport_num);
+}
+
 int esw_acl_egress_ofld_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
 {
 	int table_size = 0;
@@ -157,6 +162,9 @@ int esw_acl_egress_ofld_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport
 	    !MLX5_CAP_GEN(esw->dev, prio_tag_required))
 		return 0;
 
+	if (!esw_acl_egress_needed(esw, vport->vport))
+		return 0;
+
 	esw_acl_egress_ofld_rules_destroy(vport);
 
 	if (mlx5_esw_acl_egress_fwd2vport_supported(esw))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 6b49c0d59099..eea16a21fb01 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2108,11 +2108,9 @@ esw_vport_create_offloads_acl_tables(struct mlx5_eswitch *esw,
 	if (err)
 		return err;
 
-	if (mlx5_eswitch_is_vf_vport(esw, vport->vport)) {
-		err = esw_acl_egress_ofld_setup(esw, vport);
-		if (err)
-			goto egress_err;
-	}
+	err = esw_acl_egress_ofld_setup(esw, vport);
+	if (err)
+		goto egress_err;
 
 	return 0;
 
-- 
2.26.2

