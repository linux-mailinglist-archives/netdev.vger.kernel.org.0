Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0F32A4FE4
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729526AbgKCTTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:19:01 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:15794 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729248AbgKCTTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 14:19:00 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa1ad230002>; Tue, 03 Nov 2020 11:18:59 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 3 Nov
 2020 19:18:59 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Maor Dickman" <maord@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 1/9] net/mlx5e: Fix modify header actions memory leak
Date:   Tue, 3 Nov 2020 11:18:22 -0800
Message-ID: <20201103191830.60151-2-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103191830.60151-1-saeedm@nvidia.com>
References: <20201103191830.60151-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604431139; bh=Sjjv+B7Sym9tfWVa1TPvk+rg1wiMJpx5dBuTH4GJV7U=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=ZD0xaH8/gFdvoqy+QNAOMB3HggNsdzgPJSyzo/KmRzK2kqGk3yucMtqoOXxUHlJ2f
         slqtsOupwz47DmCbfIML7JW17sEB+7WCUR5C31mlZfuZ3Jr1Xcv2xnGWZNeFTZJEWs
         hwduRN4uvMyCKNLufh4vG4B3i+m6DxM2KUI14KOpTpwGAZj8iR/3sa7OpNuv09qc7j
         FAOZVFZgP72g+srHXP4eqlQo4Tb8m4AF2gXhpJpLsWuxFJWa1gPI7z0jZ4je9hHebQ
         66YqRg3iJ28VVwFRRxRhslLUDYuslhQwQ4ezyUqRE2X641mafyBBIjDo0eXLu4JLmj
         cgfyYQ7xKoheg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

Modify header actions are allocated during parse tc actions and only
freed during the flow creation, however, on error flow the allocated
memory is wrongly unfreed.

Fix this by calling dealloc_mod_hdr_actions in __mlx5e_add_fdb_flow
and mlx5e_add_nic_flow error flow.

Fixes: d7e75a325cb2 ("net/mlx5e: Add offloading of E-Switch TC pedit (heade=
r re-write) action"')
Fixes: 2f4fe4cab073 ("net/mlx5e: Add offloading of NIC TC pedit (header re-=
write) actions")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index e3a968e9e2a0..2e2fa0440032 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4658,6 +4658,7 @@ __mlx5e_add_fdb_flow(struct mlx5e_priv *priv,
 	return flow;
=20
 err_free:
+	dealloc_mod_hdr_actions(&parse_attr->mod_hdr_acts);
 	mlx5e_flow_put(priv, flow);
 out:
 	return ERR_PTR(err);
@@ -4802,6 +4803,7 @@ mlx5e_add_nic_flow(struct mlx5e_priv *priv,
 	return 0;
=20
 err_free:
+	dealloc_mod_hdr_actions(&parse_attr->mod_hdr_acts);
 	mlx5e_flow_put(priv, flow);
 out:
 	return err;
--=20
2.26.2

