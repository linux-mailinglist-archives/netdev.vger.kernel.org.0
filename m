Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3FED27F8B8
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 06:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730198AbgJAEd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 00:33:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725823AbgJAEdT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 00:33:19 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76C70221F0;
        Thu,  1 Oct 2020 04:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601526798;
        bh=98zRqR0G5GbOYDoOyQL8i9lmDcMx4Ic+Y3Ih5UruPYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M6swIijhkjfj9p4F4uzazb1bDoPcx3goSqKbySG8hnOs+RzYmgFtvgKjhj/76AFqN
         fQ07iLB4TeSdxDbkUw4WzM8ehKyH/ilsycKqc2J9TibIr5GGSQD6jQkviE0eavrylj
         7pi7OrvM+qqKq5Jq7hWAr98gIXQEhyorJ8pQbNfA=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Hamdan Igbaria <hamdani@mellanox.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/15] net/mlx5: E-Switch, Support flow source for local vport
Date:   Wed, 30 Sep 2020 21:32:58 -0700
Message-Id: <20201001043302.48113-12-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001043302.48113-1-saeed@kernel.org>
References: <20201001043302.48113-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hamdan Igbaria <hamdani@mellanox.com>

Set flow source as hint for local vport.

Signed-off-by: Hamdan Igbaria <hamdani@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index e977d857f969..c9c2962ad49f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -247,8 +247,11 @@ mlx5_eswitch_set_rule_flow_source(struct mlx5_eswitch *esw,
 				  struct mlx5_esw_flow_attr *attr)
 {
 	if (MLX5_CAP_ESW_FLOWTABLE(esw->dev, flow_source) &&
-	    attr && attr->in_rep && attr->in_rep->vport == MLX5_VPORT_UPLINK)
-		spec->flow_context.flow_source = MLX5_FLOW_CONTEXT_FLOW_SOURCE_UPLINK;
+	    attr && attr->in_rep)
+		spec->flow_context.flow_source =
+			attr->in_rep->vport == MLX5_VPORT_UPLINK ?
+				MLX5_FLOW_CONTEXT_FLOW_SOURCE_UPLINK :
+				MLX5_FLOW_CONTEXT_FLOW_SOURCE_LOCAL_VPORT;
 }
 
 static void
-- 
2.26.2

