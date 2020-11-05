Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78CFF2A87FA
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 21:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732538AbgKEUWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 15:22:24 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:6732 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732498AbgKEUWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 15:22:13 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa45ef60000>; Thu, 05 Nov 2020 12:22:14 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 5 Nov
 2020 20:22:12 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Maor Gottlieb" <maorg@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net v2 4/7] net/mlx5: Fix deletion of duplicate rules
Date:   Thu, 5 Nov 2020 12:21:26 -0800
Message-ID: <20201105202129.23644-5-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201105202129.23644-1-saeedm@nvidia.com>
References: <20201105202129.23644-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604607734; bh=hZw4cR2iwc3qCOadGAQRRSPM4uxfq7okWlnuj2wf6/c=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=Y90l9eZ6+0PEXnf81dZSL/ANmLCmoMIv5RsO9IMvMkP8NHdgu/PfBBtE2+7ZjgHny
         ygQQzfj7lt/9D6TkSBYDgMos0nuO4HXyO6mETcFHA30ixtrU78B14m1DQgf5IXx3BJ
         ex/LtsJYv0PAF5RijNnUsiCAmQVp8Jt51B7/Y4emZikJw86w+om08HiSDVr8t/vl4U
         aM9LPF3Pt9AkFpENyV7KD36/tNN7sd25oTzti6IYxQRT1vojaa+6KjAXgsc4LfDOxD
         isSdYegDlPjlTsIUE+xQUyF0hz+Txcu61Q3gX57tHl5P9WnRRUAuhKc+eDhZlUdi+X
         qL0UMlwAfzgVA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

When a rule is duplicated, the refcount of the rule is increased so only
the second deletion of the rule should cause destruction of the FTE.
Currently, the FTE will be destroyed in the first deletion of rule since
the modify_mask will be 0.
Fix it and call to destroy FTE only if all the rules (FTE's children)
have been removed.

Fixes: 718ce4d601db ("net/mlx5: Consolidate update FTE for all removal chan=
ges")
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/fs_core.c
index 16091838bfcf..325a5b0d6829 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2010,10 +2010,11 @@ void mlx5_del_flow_rules(struct mlx5_flow_handle *h=
andle)
 	down_write_ref_node(&fte->node, false);
 	for (i =3D handle->num_rules - 1; i >=3D 0; i--)
 		tree_remove_node(&handle->rule[i]->node, true);
-	if (fte->modify_mask && fte->dests_size) {
-		modify_fte(fte);
+	if (fte->dests_size) {
+		if (fte->modify_mask)
+			modify_fte(fte);
 		up_write_ref_node(&fte->node, false);
-	} else {
+	} else if (list_empty(&fte->node.children)) {
 		del_hw_fte(&fte->node);
 		/* Avoid double call to del_hw_fte */
 		fte->node.del_hw_func =3D NULL;
--=20
2.26.2

