Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7BC3054C6
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 08:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbhA0HgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 02:36:24 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7587 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S317437AbhA0AA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 19:00:27 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6010a9870000>; Tue, 26 Jan 2021 15:45:11 -0800
Received: from sx1.mtl.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 23:45:10 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Paul Blakey <paulb@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 12/12] net/mlx5: CT: Fix incorrect removal of tuple_nat_node from nat rhashtable
Date:   Tue, 26 Jan 2021 15:43:45 -0800
Message-ID: <20210126234345.202096-13-saeedm@nvidia.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126234345.202096-1-saeedm@nvidia.com>
References: <20210126234345.202096-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611704711; bh=G4ZBqPijOMv4OqGf21FqpCixXy8Uk5TBskf3z/7ZtSY=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=b/LE0ioCqaJEjsIuMWhnwxZdJY0nv6/D8ihxRfHwI7O2W3sIC5TfqYwFhIpUwLi4k
         EYwLstbY2bqMajRXN7DtvDaV6C7z1N8LI5iatXQgJTWc4ISlG7+c/s8+Vpe+HfVarq
         W/zitu7F8Rp7tsJY8gSMaE5qAuTBLBv6Nn8WdXDD1V99hsQJYtT5LkhGqoCEdMByxd
         tLLOUS9Qsu0BFRFpA9pjXPvXjGJZtMXCMtQZUTrUlLETnNwdXJPj1BOolKpbjhJOPr
         nBf5iXWEAYHYSxmWZQ5evXxp1hT983a/dKX1a9lX1V17y6593ODj43spgnLM6QnWLc
         gIWcP6lKGLJpQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

If a non nat tuple entry is inserted just to the regular tuples
rhashtable (ct_tuples_ht) and not to natted tuples rhashtable
(ct_nat_tuples_ht). Commit bc562be9674b ("net/mlx5e: CT: Save ct entries
tuples in hashtables") mixed up the return labels and names sot that on
cleanup or failure we still try to remove for the natted tuples rhashtable.

Fix that by correctly checking if a natted tuples insertion
before removing it. While here make it more readable.

Fixes: bc562be9674b ("net/mlx5e: CT: Save ct entries tuples in hashtables")
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 20 ++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 072363e73f1c..6bc6b48a56dc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -167,6 +167,12 @@ static const struct rhashtable_params tuples_nat_ht_pa=
rams =3D {
 	.min_size =3D 16 * 1024,
 };
=20
+static bool
+mlx5_tc_ct_entry_has_nat(struct mlx5_ct_entry *entry)
+{
+	return !!(entry->tuple_nat_node.next);
+}
+
 static int
 mlx5_tc_ct_rule_to_tuple(struct mlx5_ct_tuple *tuple, struct flow_rule *ru=
le)
 {
@@ -911,13 +917,13 @@ mlx5_tc_ct_block_flow_offload_add(struct mlx5_ct_ft *=
ft,
 err_insert:
 	mlx5_tc_ct_entry_del_rules(ct_priv, entry);
 err_rules:
-	rhashtable_remove_fast(&ct_priv->ct_tuples_nat_ht,
-			       &entry->tuple_nat_node, tuples_nat_ht_params);
+	if (mlx5_tc_ct_entry_has_nat(entry))
+		rhashtable_remove_fast(&ct_priv->ct_tuples_nat_ht,
+				       &entry->tuple_nat_node, tuples_nat_ht_params);
 err_tuple_nat:
-	if (entry->tuple_node.next)
-		rhashtable_remove_fast(&ct_priv->ct_tuples_ht,
-				       &entry->tuple_node,
-				       tuples_ht_params);
+	rhashtable_remove_fast(&ct_priv->ct_tuples_ht,
+			       &entry->tuple_node,
+			       tuples_ht_params);
 err_tuple:
 err_set:
 	kfree(entry);
@@ -932,7 +938,7 @@ mlx5_tc_ct_del_ft_entry(struct mlx5_tc_ct_priv *ct_priv=
,
 {
 	mlx5_tc_ct_entry_del_rules(ct_priv, entry);
 	mutex_lock(&ct_priv->shared_counter_lock);
-	if (entry->tuple_node.next)
+	if (mlx5_tc_ct_entry_has_nat(entry))
 		rhashtable_remove_fast(&ct_priv->ct_tuples_nat_ht,
 				       &entry->tuple_nat_node,
 				       tuples_nat_ht_params);
--=20
2.29.2

