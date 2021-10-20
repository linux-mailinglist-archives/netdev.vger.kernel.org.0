Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC38D435215
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 19:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhJTR6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 13:58:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230328AbhJTR6o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 13:58:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E99ED6138F;
        Wed, 20 Oct 2021 17:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634752590;
        bh=NOgUolFnCQ3EHwDDf6+qMAIN4JNUlCP/sDZMVHNJW6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VI4vjJOIWwEsrwYEftGgEED9nz/4VWEZFBG4Ow1KjDRAeTar8CxXr9gbWFP1lR6u4
         FoChrloCqYAQ1t4HoelB1J1cRL81PzQuvMHc4k8VkkuopLQtnzshSeoCDQkBrw7brd
         lt2m17nY2QcKibIDx9MUXkdbPH93Su2+YBI30GCerSLAode1YTUCS0WVvDrzHC6YOM
         cstiWMRBd45uYPDvHAfecaTymy+EQSUXEhNJmswVv+lXSPegVQWqfxw7JlOc/eVbll
         RGCFu7kJeWMgWg6hVoX1p9R9ggIRxBnbDJWnPxIu3mmAsKzyDOswHDoqyhPBR8frwf
         jwpAMXKzf6MFg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dmytro Linkin <dlinkin@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 2/5] net/mlx5: E-switch, Return correct error code on group creation failure
Date:   Wed, 20 Oct 2021 10:56:24 -0700
Message-Id: <20211020175627.269138-3-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211020175627.269138-1-saeed@kernel.org>
References: <20211020175627.269138-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Dan Carpenter report:
The patch f47e04eb96e0: "net/mlx5: E-switch, Allow setting share/max
tx rate limits of rate groups" from May 31, 2021, leads to the
following Smatch static checker warning:

	drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c:483 esw_qos_create_rate_group()
	warn: passing zero to 'ERR_PTR'

If min rate normalization failed then error code may be overwritten to 0
if scheduling element destruction succeed. Ignore this value and always
return initial one.

Fixes: f47e04eb96e0 ("net/mlx5: E-switch, Allow setting share/max tx rate limits of rate groups")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index 985e305179d1..c6cc67cb4f6a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -473,10 +473,9 @@ esw_qos_create_rate_group(struct mlx5_eswitch *esw, struct netlink_ext_ack *exta
 
 err_min_rate:
 	list_del(&group->list);
-	err = mlx5_destroy_scheduling_element_cmd(esw->dev,
-						  SCHEDULING_HIERARCHY_E_SWITCH,
-						  group->tsar_ix);
-	if (err)
+	if (mlx5_destroy_scheduling_element_cmd(esw->dev,
+						SCHEDULING_HIERARCHY_E_SWITCH,
+						group->tsar_ix))
 		NL_SET_ERR_MSG_MOD(extack, "E-Switch destroy TSAR for group failed");
 err_sched_elem:
 	kfree(group);
-- 
2.31.1

