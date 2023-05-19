Return-Path: <netdev+bounces-3982-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D63C8709EAB
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 19:59:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39E84280EFC
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 17:59:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EF6D14275;
	Fri, 19 May 2023 17:56:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF6F13AC2
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 17:56:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0585CC43322;
	Fri, 19 May 2023 17:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684518978;
	bh=v9OWZLlEfTcFQc6JpgDnovXnjjr4zIKgXYDMcZs1gpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lWvjJXaP6zeJVgbWZqtbbqb9QWhgEOaadaMl01U7v0O79KfSjZ2nrjcvNvi56jSSr
	 n+gPVdGzLujHa0XEESRaqg3LFmeivkW4PxMqsV89U8tqeSwumG9E+tcFPPd02TrsVU
	 kCtfLFw+4VTTBdG5E7QgoOLB+B0un7SkeWLMnQhYJBJZ1y+nGEk7Z5039gu+SBl03F
	 Z4EVxhKkxJngzxirjF7V3K018Z7NZzBkfZBkCDH33s3fX5OLeRTw8hPCZCWKcqvpeK
	 Kuth5cW3L8duhPW5DH7OiJvtldgLRWe9qXhQTenS5ozQ52UE14XHiwmByoUxXVmZgj
	 o1r5LoIfNsuhQ==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Maor Dickman <maord@nvidia.com>
Subject: [net-next 10/15] net/mlx5e: E-Switch: move debug print of adding mac to correct place
Date: Fri, 19 May 2023 10:55:52 -0700
Message-Id: <20230519175557.15683-11-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230519175557.15683-1-saeed@kernel.org>
References: <20230519175557.15683-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Roi Dayan <roid@nvidia.com>

Move the debug print inside the if clause that actually does the change.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 692cea3a6383..3e3963424285 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -310,11 +310,12 @@ static int esw_add_uc_addr(struct mlx5_eswitch *esw, struct vport_addr *vaddr)
 
 fdb_add:
 	/* SRIOV is enabled: Forward UC MAC to vport */
-	if (esw->fdb_table.legacy.fdb && esw->mode == MLX5_ESWITCH_LEGACY)
+	if (esw->fdb_table.legacy.fdb && esw->mode == MLX5_ESWITCH_LEGACY) {
 		vaddr->flow_rule = esw_fdb_set_vport_rule(esw, mac, vport);
 
-	esw_debug(esw->dev, "\tADDED UC MAC: vport[%d] %pM fr(%p)\n",
-		  vport, mac, vaddr->flow_rule);
+		esw_debug(esw->dev, "\tADDED UC MAC: vport[%d] %pM fr(%p)\n",
+			  vport, mac, vaddr->flow_rule);
+	}
 
 	return 0;
 }
-- 
2.40.1


