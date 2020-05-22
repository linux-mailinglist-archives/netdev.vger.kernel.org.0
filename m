Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB93E1DF34D
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 01:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731328AbgEVXwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 19:52:38 -0400
Received: from mail-eopbgr80041.outbound.protection.outlook.com ([40.107.8.41]:15428
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731169AbgEVXwi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 19:52:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LN2DtjttluHXyxQgyrz4TEWkVrfv4DyCuWiZ1x72wxehHZCmXWu/ylTiLRjh1S9VwYugb75RJqN7aQLbVE+IYXZVXH7ZCn/stOJVc2FYW0WRv2Q0Av1w4R63L0gi647LwJMUvRTrMTA6Nc7s2Lz4+OmoKDK9VCQ4Hvyxuee+qoLQlrt+ZATvm5OMinLChUwoYtDiWapDo38w4b07z6zj3FlCwZXleBP8ZKDcnNujuYDPyILUOo/WPXBQISTHRWTxB8HZmwLAAPeNF8i6GBcUuR9QUDvZ39MVvWtibQBHV1ZqSmK8Az4LcZfvr78XAAx+h+CcWLHZjAB0W6xFyY8Y/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ONp0Nk7GHY1xuNU+xfbHlpwBJwS4osoTlBwCPGlcReI=;
 b=KFJCLtwlOcDMvz+cEycikMJsDVCGyU38WydqsylWEoef51D68fW4lntP1MFrWgk84jpwzmrGysD8H10ZPP0FbuRBFgzprR61Xq2Y9A2BWXlHFyxCbdDjAF4zV1clbPSnUaboO8nyy8kRT8rWaxx+3Bk/aflpzLH9scKpJqUCgafcNlk00VVlm3PMr/oFGgHpSjD33qrB9yt4irRM4athG6fuwG0SP77K1k2acpNJUpZa9nYbo/68iNLsgB7NJFByJ1ELFnvNve2M8qK2KtZ2V31ZOA2vlzVT8rAiUUU5A663R7XSul6INqE0HUaEpTVIGe6CYnCsuS6d6cggmcAj1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ONp0Nk7GHY1xuNU+xfbHlpwBJwS4osoTlBwCPGlcReI=;
 b=IEP5b9ngVw/GuWtYHELSZpjzhwRvZ437ATeWzT7ZVS9HmyfRtqc8uI+IVfWEFkKE/P2IKJy83WHPwInSgr10/zh76Lw80CT/SfMl1eGqKv8xhYqdKUpwtehNY6nO1RCD0/RYuDVc03D1XdvTV7qrIz2dLkinHYL1kjcpukhWw+Y=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4544.eurprd05.prod.outlook.com (2603:10a6:802:5e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Fri, 22 May
 2020 23:52:16 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.026; Fri, 22 May 2020
 23:52:16 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 03/10] net/mlx5e: Extract neigh-specific code from en_rep.c to rep/neigh.c
Date:   Fri, 22 May 2020 16:51:41 -0700
Message-Id: <20200522235148.28987-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200522235148.28987-1-saeedm@mellanox.com>
References: <20200522235148.28987-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0015.namprd10.prod.outlook.com
 (2603:10b6:a03:255::20) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR10CA0015.namprd10.prod.outlook.com (2603:10b6:a03:255::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24 via Frontend Transport; Fri, 22 May 2020 23:52:14 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 56c441a7-4210-4669-1887-08d7feab27d1
X-MS-TrafficTypeDiagnostic: VI1PR05MB4544:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB45447546DFBEE0B3EF198E09BEB40@VI1PR05MB4544.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 04111BAC64
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TzB1DI/R1mXtAWhSqnmPSCGIwFH7pwfkqP3aVOUmS1FB5qUI7R7ZIhs6qU7suVsjJD9N5AOLUNy6cRqPfyaNPGnBXEt/4RBKGJEjC8OPg5gqndaOKs1ej3EX8EvIO8FS8WMDucIrjXVXGU6FC0ExRXeOqmC+FV8W2YeWgfIV+4EWF3dxuQgwRrpULV98Y8IYAPf6BzpdXtCJSrbpKOvM6MQh2v/oG8B/nsTyr8JnoLKxdHjMXB3Pgt3BK0rZReP7zNcXHL95bcz3POm1iP0NDroG7lBXUQ+Nrr92rFU708iD4B17KqBM1qjCi0fMHIcypYm9/j6Dqd/JL3hK2yIqMKYnXRc62E2w3WK17nEUdrQHsyHsynbkYqpxSghm+Zy+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(66476007)(956004)(6506007)(66556008)(2616005)(66946007)(107886003)(6512007)(1076003)(16526019)(478600001)(186003)(52116002)(26005)(4326008)(6666004)(30864003)(316002)(6486002)(86362001)(8676002)(54906003)(36756003)(8936002)(2906002)(5660300002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: StBcro9j395WyQWg/AmpFvvkihFpOE87uGYUIMlg6fxHumLb8oDhJG+y+l2jbZ5U/0orkz5D7O+sCCN5TfNlNPSO9YTyiixsOV3xaXS1Z7NQN4qu30S8qUpd0aM6kf9ggtwRzmXuSHkwc6K/MUwxMa7W73BWWsWdVWLe68W4X9UvJCybdEEBcxk2LrqyytEdORGKRlzbS/vnNsyFkeCeyOpiPK34hDDqggV2wEdDxThdR8dJ9p2wz1gPb9UnPvHG2J73I9Fi5h36bmhmwE5vAYc2uLt82gf+91jHPf5P0iakXZJ3+vlLMCYXFw2T4n7edR/JROvc2nY2AANNjs7z208uFeDLrALgDur/A9FtWKwXqqvybeOkMIOf8UFkKAe5GAIJ6ssdWaTUhEyfPRAJZ/BPQ2WsO+yBtXWzBefFtHHBbbCloJSwjgNmldq34LrkI550pgA55SUrcMBEqAtSeYF/0aRBvfIF5Cin0XM4WUk=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56c441a7-4210-4669-1887-08d7feab27d1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2020 23:52:16.0130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uxroeRp4T6LUGmiw9Xt5Mk8xjhuOU6kdsgSanA5UjDOlnzldFOPtkOAko3JLyn7pBUocIbBRijE9FcmuFV0IlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4544
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

As a preparation for introducing new kconfig option that controls
compilation of all TC offloads code in mlx5, extract neigh-specific code
from en_rep.c to standalone file. This allows easily compiling out the code
by only including new source in make file when corresponding kconfig is
enabled instead of adding multiple ifdef blocks to en_rep.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../mellanox/mlx5/core/en/rep/neigh.c         | 368 ++++++++++++++++++
 .../mellanox/mlx5/core/en/rep/neigh.h         |  23 ++
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |   1 +
 .../ethernet/mellanox/mlx5/core/en/tc_tun.c   |   1 +
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 354 +----------------
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |   8 -
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   6 -
 8 files changed, 395 insertions(+), 368 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index c21453970dbb..3c9d78e6695c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -33,7 +33,7 @@ mlx5_core-$(CONFIG_MLX5_CORE_EN) += en_main.o en_common.o en_fs.o en_ethtool.o \
 mlx5_core-$(CONFIG_MLX5_EN_ARFS)     += en_arfs.o
 mlx5_core-$(CONFIG_MLX5_EN_RXNFC)    += en_fs_ethtool.o
 mlx5_core-$(CONFIG_MLX5_CORE_EN_DCB) += en_dcbnl.o en/port_buffer.o
-mlx5_core-$(CONFIG_MLX5_ESWITCH)     += en_rep.o en_tc.o en/rep/tc.o en/tc_tun.o lib/port_tun.o \
+mlx5_core-$(CONFIG_MLX5_ESWITCH)     += en_rep.o en_tc.o en/rep/tc.o en/rep/neigh.o en/tc_tun.o lib/port_tun.o \
 					lag_mp.o \
 					lib/geneve.o en/mapping.o en/tc_tun_vxlan.o en/tc_tun_gre.o \
 					en/tc_tun_geneve.o diag/en_tc_tracepoint.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c
new file mode 100644
index 000000000000..baa162432e75
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c
@@ -0,0 +1,368 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2020 Mellanox Technologies. */
+
+#include <linux/refcount.h>
+#include <linux/list.h>
+#include <linux/rculist.h>
+#include <linux/rtnetlink.h>
+#include <linux/workqueue.h>
+#include <linux/rwlock.h>
+#include <linux/spinlock.h>
+#include <linux/notifier.h>
+#include <net/netevent.h>
+#include "neigh.h"
+#include "tc.h"
+#include "en_rep.h"
+#include "fs_core.h"
+#include "diag/en_rep_tracepoint.h"
+
+static unsigned long mlx5e_rep_ipv6_interval(void)
+{
+	if (IS_ENABLED(CONFIG_IPV6) && ipv6_stub->nd_tbl)
+		return NEIGH_VAR(&ipv6_stub->nd_tbl->parms, DELAY_PROBE_TIME);
+
+	return ~0UL;
+}
+
+static void mlx5e_rep_neigh_update_init_interval(struct mlx5e_rep_priv *rpriv)
+{
+	unsigned long ipv4_interval = NEIGH_VAR(&arp_tbl.parms, DELAY_PROBE_TIME);
+	unsigned long ipv6_interval = mlx5e_rep_ipv6_interval();
+	struct net_device *netdev = rpriv->netdev;
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+
+	rpriv->neigh_update.min_interval = min_t(unsigned long, ipv6_interval, ipv4_interval);
+	mlx5_fc_update_sampling_interval(priv->mdev, rpriv->neigh_update.min_interval);
+}
+
+void mlx5e_rep_queue_neigh_stats_work(struct mlx5e_priv *priv)
+{
+	struct mlx5e_rep_priv *rpriv = priv->ppriv;
+	struct mlx5e_neigh_update_table *neigh_update = &rpriv->neigh_update;
+
+	mlx5_fc_queue_stats_work(priv->mdev,
+				 &neigh_update->neigh_stats_work,
+				 neigh_update->min_interval);
+}
+
+static bool mlx5e_rep_neigh_entry_hold(struct mlx5e_neigh_hash_entry *nhe)
+{
+	return refcount_inc_not_zero(&nhe->refcnt);
+}
+
+static void mlx5e_rep_neigh_entry_remove(struct mlx5e_neigh_hash_entry *nhe);
+
+void mlx5e_rep_neigh_entry_release(struct mlx5e_neigh_hash_entry *nhe)
+{
+	if (refcount_dec_and_test(&nhe->refcnt)) {
+		mlx5e_rep_neigh_entry_remove(nhe);
+		kfree_rcu(nhe, rcu);
+	}
+}
+
+static struct mlx5e_neigh_hash_entry *
+mlx5e_get_next_nhe(struct mlx5e_rep_priv *rpriv,
+		   struct mlx5e_neigh_hash_entry *nhe)
+{
+	struct mlx5e_neigh_hash_entry *next = NULL;
+
+	rcu_read_lock();
+
+	for (next = nhe ?
+		     list_next_or_null_rcu(&rpriv->neigh_update.neigh_list,
+					   &nhe->neigh_list,
+					   struct mlx5e_neigh_hash_entry,
+					   neigh_list) :
+		     list_first_or_null_rcu(&rpriv->neigh_update.neigh_list,
+					    struct mlx5e_neigh_hash_entry,
+					    neigh_list);
+	     next;
+	     next = list_next_or_null_rcu(&rpriv->neigh_update.neigh_list,
+					  &next->neigh_list,
+					  struct mlx5e_neigh_hash_entry,
+					  neigh_list))
+		if (mlx5e_rep_neigh_entry_hold(next))
+			break;
+
+	rcu_read_unlock();
+
+	if (nhe)
+		mlx5e_rep_neigh_entry_release(nhe);
+
+	return next;
+}
+
+static void mlx5e_rep_neigh_stats_work(struct work_struct *work)
+{
+	struct mlx5e_rep_priv *rpriv = container_of(work, struct mlx5e_rep_priv,
+						    neigh_update.neigh_stats_work.work);
+	struct net_device *netdev = rpriv->netdev;
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5e_neigh_hash_entry *nhe = NULL;
+
+	rtnl_lock();
+	if (!list_empty(&rpriv->neigh_update.neigh_list))
+		mlx5e_rep_queue_neigh_stats_work(priv);
+
+	while ((nhe = mlx5e_get_next_nhe(rpriv, nhe)) != NULL)
+		mlx5e_tc_update_neigh_used_value(nhe);
+
+	rtnl_unlock();
+}
+
+static void mlx5e_rep_neigh_update(struct work_struct *work)
+{
+	struct mlx5e_neigh_hash_entry *nhe =
+		container_of(work, struct mlx5e_neigh_hash_entry, neigh_update_work);
+	struct neighbour *n = nhe->n;
+	struct mlx5e_encap_entry *e;
+	unsigned char ha[ETH_ALEN];
+	struct mlx5e_priv *priv;
+	bool neigh_connected;
+	u8 nud_state, dead;
+
+	rtnl_lock();
+
+	/* If these parameters are changed after we release the lock,
+	 * we'll receive another event letting us know about it.
+	 * We use this lock to avoid inconsistency between the neigh validity
+	 * and it's hw address.
+	 */
+	read_lock_bh(&n->lock);
+	memcpy(ha, n->ha, ETH_ALEN);
+	nud_state = n->nud_state;
+	dead = n->dead;
+	read_unlock_bh(&n->lock);
+
+	neigh_connected = (nud_state & NUD_VALID) && !dead;
+
+	trace_mlx5e_rep_neigh_update(nhe, ha, neigh_connected);
+
+	list_for_each_entry(e, &nhe->encap_list, encap_list) {
+		if (!mlx5e_encap_take(e))
+			continue;
+
+		priv = netdev_priv(e->out_dev);
+		mlx5e_rep_update_flows(priv, e, neigh_connected, ha);
+		mlx5e_encap_put(priv, e);
+	}
+	mlx5e_rep_neigh_entry_release(nhe);
+	rtnl_unlock();
+	neigh_release(n);
+}
+
+static void mlx5e_rep_queue_neigh_update_work(struct mlx5e_priv *priv,
+					      struct mlx5e_neigh_hash_entry *nhe,
+					      struct neighbour *n)
+{
+	/* Take a reference to ensure the neighbour and mlx5 encap
+	 * entry won't be destructed until we drop the reference in
+	 * delayed work.
+	 */
+	neigh_hold(n);
+
+	/* This assignment is valid as long as the the neigh reference
+	 * is taken
+	 */
+	nhe->n = n;
+
+	if (!queue_work(priv->wq, &nhe->neigh_update_work)) {
+		mlx5e_rep_neigh_entry_release(nhe);
+		neigh_release(n);
+	}
+}
+
+static int mlx5e_rep_netevent_event(struct notifier_block *nb,
+				    unsigned long event, void *ptr)
+{
+	struct mlx5e_rep_priv *rpriv = container_of(nb, struct mlx5e_rep_priv,
+						    neigh_update.netevent_nb);
+	struct mlx5e_neigh_update_table *neigh_update = &rpriv->neigh_update;
+	struct net_device *netdev = rpriv->netdev;
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5e_neigh_hash_entry *nhe = NULL;
+	struct mlx5e_neigh m_neigh = {};
+	struct neigh_parms *p;
+	struct neighbour *n;
+	bool found = false;
+
+	switch (event) {
+	case NETEVENT_NEIGH_UPDATE:
+		n = ptr;
+#if IS_ENABLED(CONFIG_IPV6)
+		if (n->tbl != ipv6_stub->nd_tbl && n->tbl != &arp_tbl)
+#else
+		if (n->tbl != &arp_tbl)
+#endif
+			return NOTIFY_DONE;
+
+		m_neigh.dev = n->dev;
+		m_neigh.family = n->ops->family;
+		memcpy(&m_neigh.dst_ip, n->primary_key, n->tbl->key_len);
+
+		rcu_read_lock();
+		nhe = mlx5e_rep_neigh_entry_lookup(priv, &m_neigh);
+		rcu_read_unlock();
+		if (!nhe)
+			return NOTIFY_DONE;
+
+		mlx5e_rep_queue_neigh_update_work(priv, nhe, n);
+		break;
+
+	case NETEVENT_DELAY_PROBE_TIME_UPDATE:
+		p = ptr;
+
+		/* We check the device is present since we don't care about
+		 * changes in the default table, we only care about changes
+		 * done per device delay prob time parameter.
+		 */
+#if IS_ENABLED(CONFIG_IPV6)
+		if (!p->dev || (p->tbl != ipv6_stub->nd_tbl && p->tbl != &arp_tbl))
+#else
+		if (!p->dev || p->tbl != &arp_tbl)
+#endif
+			return NOTIFY_DONE;
+
+		rcu_read_lock();
+		list_for_each_entry_rcu(nhe, &neigh_update->neigh_list,
+					neigh_list) {
+			if (p->dev == nhe->m_neigh.dev) {
+				found = true;
+				break;
+			}
+		}
+		rcu_read_unlock();
+		if (!found)
+			return NOTIFY_DONE;
+
+		neigh_update->min_interval = min_t(unsigned long,
+						   NEIGH_VAR(p, DELAY_PROBE_TIME),
+						   neigh_update->min_interval);
+		mlx5_fc_update_sampling_interval(priv->mdev,
+						 neigh_update->min_interval);
+		break;
+	}
+	return NOTIFY_DONE;
+}
+
+static const struct rhashtable_params mlx5e_neigh_ht_params = {
+	.head_offset = offsetof(struct mlx5e_neigh_hash_entry, rhash_node),
+	.key_offset = offsetof(struct mlx5e_neigh_hash_entry, m_neigh),
+	.key_len = sizeof(struct mlx5e_neigh),
+	.automatic_shrinking = true,
+};
+
+int mlx5e_rep_neigh_init(struct mlx5e_rep_priv *rpriv)
+{
+	struct mlx5e_neigh_update_table *neigh_update = &rpriv->neigh_update;
+	int err;
+
+	err = rhashtable_init(&neigh_update->neigh_ht, &mlx5e_neigh_ht_params);
+	if (err)
+		return err;
+
+	INIT_LIST_HEAD(&neigh_update->neigh_list);
+	mutex_init(&neigh_update->encap_lock);
+	INIT_DELAYED_WORK(&neigh_update->neigh_stats_work,
+			  mlx5e_rep_neigh_stats_work);
+	mlx5e_rep_neigh_update_init_interval(rpriv);
+
+	rpriv->neigh_update.netevent_nb.notifier_call = mlx5e_rep_netevent_event;
+	err = register_netevent_notifier(&rpriv->neigh_update.netevent_nb);
+	if (err)
+		goto out_err;
+	return 0;
+
+out_err:
+	rhashtable_destroy(&neigh_update->neigh_ht);
+	return err;
+}
+
+void mlx5e_rep_neigh_cleanup(struct mlx5e_rep_priv *rpriv)
+{
+	struct mlx5e_neigh_update_table *neigh_update = &rpriv->neigh_update;
+	struct mlx5e_priv *priv = netdev_priv(rpriv->netdev);
+
+	unregister_netevent_notifier(&neigh_update->netevent_nb);
+
+	flush_workqueue(priv->wq); /* flush neigh update works */
+
+	cancel_delayed_work_sync(&rpriv->neigh_update.neigh_stats_work);
+
+	mutex_destroy(&neigh_update->encap_lock);
+	rhashtable_destroy(&neigh_update->neigh_ht);
+}
+
+static int mlx5e_rep_neigh_entry_insert(struct mlx5e_priv *priv,
+					struct mlx5e_neigh_hash_entry *nhe)
+{
+	struct mlx5e_rep_priv *rpriv = priv->ppriv;
+	int err;
+
+	err = rhashtable_insert_fast(&rpriv->neigh_update.neigh_ht,
+				     &nhe->rhash_node,
+				     mlx5e_neigh_ht_params);
+	if (err)
+		return err;
+
+	list_add_rcu(&nhe->neigh_list, &rpriv->neigh_update.neigh_list);
+
+	return err;
+}
+
+static void mlx5e_rep_neigh_entry_remove(struct mlx5e_neigh_hash_entry *nhe)
+{
+	struct mlx5e_rep_priv *rpriv = nhe->priv->ppriv;
+
+	mutex_lock(&rpriv->neigh_update.encap_lock);
+
+	list_del_rcu(&nhe->neigh_list);
+
+	rhashtable_remove_fast(&rpriv->neigh_update.neigh_ht,
+			       &nhe->rhash_node,
+			       mlx5e_neigh_ht_params);
+	mutex_unlock(&rpriv->neigh_update.encap_lock);
+}
+
+/* This function must only be called under the representor's encap_lock or
+ * inside rcu read lock section.
+ */
+struct mlx5e_neigh_hash_entry *
+mlx5e_rep_neigh_entry_lookup(struct mlx5e_priv *priv,
+			     struct mlx5e_neigh *m_neigh)
+{
+	struct mlx5e_rep_priv *rpriv = priv->ppriv;
+	struct mlx5e_neigh_update_table *neigh_update = &rpriv->neigh_update;
+	struct mlx5e_neigh_hash_entry *nhe;
+
+	nhe = rhashtable_lookup_fast(&neigh_update->neigh_ht, m_neigh,
+				     mlx5e_neigh_ht_params);
+	return nhe && mlx5e_rep_neigh_entry_hold(nhe) ? nhe : NULL;
+}
+
+int mlx5e_rep_neigh_entry_create(struct mlx5e_priv *priv,
+				 struct mlx5e_encap_entry *e,
+				 struct mlx5e_neigh_hash_entry **nhe)
+{
+	int err;
+
+	*nhe = kzalloc(sizeof(**nhe), GFP_KERNEL);
+	if (!*nhe)
+		return -ENOMEM;
+
+	(*nhe)->priv = priv;
+	memcpy(&(*nhe)->m_neigh, &e->m_neigh, sizeof(e->m_neigh));
+	INIT_WORK(&(*nhe)->neigh_update_work, mlx5e_rep_neigh_update);
+	spin_lock_init(&(*nhe)->encap_list_lock);
+	INIT_LIST_HEAD(&(*nhe)->encap_list);
+	refcount_set(&(*nhe)->refcnt, 1);
+
+	err = mlx5e_rep_neigh_entry_insert(priv, *nhe);
+	if (err)
+		goto out_free;
+	return 0;
+
+out_free:
+	kfree(*nhe);
+	return err;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.h b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.h
new file mode 100644
index 000000000000..8eddb3ac0d74
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2020 Mellanox Technologies. */
+
+#ifndef __MLX5_EN_REP_NEIGH__
+#define __MLX5_EN_REP_NEIGH__
+
+#include "en.h"
+#include "en_rep.h"
+
+int mlx5e_rep_neigh_init(struct mlx5e_rep_priv *rpriv);
+void mlx5e_rep_neigh_cleanup(struct mlx5e_rep_priv *rpriv);
+
+struct mlx5e_neigh_hash_entry *
+mlx5e_rep_neigh_entry_lookup(struct mlx5e_priv *priv,
+			     struct mlx5e_neigh *m_neigh);
+int mlx5e_rep_neigh_entry_create(struct mlx5e_priv *priv,
+				 struct mlx5e_encap_entry *e,
+				 struct mlx5e_neigh_hash_entry **nhe);
+void mlx5e_rep_neigh_entry_release(struct mlx5e_neigh_hash_entry *nhe);
+
+void mlx5e_rep_queue_neigh_stats_work(struct mlx5e_priv *priv);
+
+#endif /* __MLX5_EN_REP_NEIGH__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index edc574582135..c609a5e50ebc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -9,6 +9,7 @@
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
 #include "tc.h"
+#include "neigh.h"
 #include "en_rep.h"
 #include "eswitch.h"
 #include "esw/chains.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index 9fdd79afa6e4..9be1fcc269b2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -7,6 +7,7 @@
 #include "en/tc_tun.h"
 #include "en_tc.h"
 #include "rep/tc.h"
+#include "rep/neigh.h"
 
 struct mlx5e_tc_tunnel *mlx5e_get_tc_tun(struct net_device *tunnel_dev)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index c84f0d9b516e..a46405c6d560 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -35,7 +35,6 @@
 #include <net/switchdev.h>
 #include <net/pkt_cls.h>
 #include <net/act_api.h>
-#include <net/netevent.h>
 #include <net/arp.h>
 #include <net/devlink.h>
 #include <net/ipv6_stubs.h>
@@ -46,6 +45,7 @@
 #include "en_rep.h"
 #include "en_tc.h"
 #include "en/rep/tc.h"
+#include "en/rep/neigh.h"
 #include "fs_core.h"
 #include "lib/mlx5.h"
 #define CREATE_TRACE_POINTS
@@ -474,358 +474,6 @@ void mlx5e_remove_sqs_fwd_rules(struct mlx5e_priv *priv)
 	mlx5e_sqs2vport_stop(esw, rep);
 }
 
-static unsigned long mlx5e_rep_ipv6_interval(void)
-{
-	if (IS_ENABLED(CONFIG_IPV6) && ipv6_stub->nd_tbl)
-		return NEIGH_VAR(&ipv6_stub->nd_tbl->parms, DELAY_PROBE_TIME);
-
-	return ~0UL;
-}
-
-static void mlx5e_rep_neigh_update_init_interval(struct mlx5e_rep_priv *rpriv)
-{
-	unsigned long ipv4_interval = NEIGH_VAR(&arp_tbl.parms, DELAY_PROBE_TIME);
-	unsigned long ipv6_interval = mlx5e_rep_ipv6_interval();
-	struct net_device *netdev = rpriv->netdev;
-	struct mlx5e_priv *priv = netdev_priv(netdev);
-
-	rpriv->neigh_update.min_interval = min_t(unsigned long, ipv6_interval, ipv4_interval);
-	mlx5_fc_update_sampling_interval(priv->mdev, rpriv->neigh_update.min_interval);
-}
-
-void mlx5e_rep_queue_neigh_stats_work(struct mlx5e_priv *priv)
-{
-	struct mlx5e_rep_priv *rpriv = priv->ppriv;
-	struct mlx5e_neigh_update_table *neigh_update = &rpriv->neigh_update;
-
-	mlx5_fc_queue_stats_work(priv->mdev,
-				 &neigh_update->neigh_stats_work,
-				 neigh_update->min_interval);
-}
-
-static bool mlx5e_rep_neigh_entry_hold(struct mlx5e_neigh_hash_entry *nhe)
-{
-	return refcount_inc_not_zero(&nhe->refcnt);
-}
-
-static void mlx5e_rep_neigh_entry_remove(struct mlx5e_neigh_hash_entry *nhe);
-
-void mlx5e_rep_neigh_entry_release(struct mlx5e_neigh_hash_entry *nhe)
-{
-	if (refcount_dec_and_test(&nhe->refcnt)) {
-		mlx5e_rep_neigh_entry_remove(nhe);
-		kfree_rcu(nhe, rcu);
-	}
-}
-
-static struct mlx5e_neigh_hash_entry *
-mlx5e_get_next_nhe(struct mlx5e_rep_priv *rpriv,
-		   struct mlx5e_neigh_hash_entry *nhe)
-{
-	struct mlx5e_neigh_hash_entry *next = NULL;
-
-	rcu_read_lock();
-
-	for (next = nhe ?
-		     list_next_or_null_rcu(&rpriv->neigh_update.neigh_list,
-					   &nhe->neigh_list,
-					   struct mlx5e_neigh_hash_entry,
-					   neigh_list) :
-		     list_first_or_null_rcu(&rpriv->neigh_update.neigh_list,
-					    struct mlx5e_neigh_hash_entry,
-					    neigh_list);
-	     next;
-	     next = list_next_or_null_rcu(&rpriv->neigh_update.neigh_list,
-					  &next->neigh_list,
-					  struct mlx5e_neigh_hash_entry,
-					  neigh_list))
-		if (mlx5e_rep_neigh_entry_hold(next))
-			break;
-
-	rcu_read_unlock();
-
-	if (nhe)
-		mlx5e_rep_neigh_entry_release(nhe);
-
-	return next;
-}
-
-static void mlx5e_rep_neigh_stats_work(struct work_struct *work)
-{
-	struct mlx5e_rep_priv *rpriv = container_of(work, struct mlx5e_rep_priv,
-						    neigh_update.neigh_stats_work.work);
-	struct net_device *netdev = rpriv->netdev;
-	struct mlx5e_priv *priv = netdev_priv(netdev);
-	struct mlx5e_neigh_hash_entry *nhe = NULL;
-
-	rtnl_lock();
-	if (!list_empty(&rpriv->neigh_update.neigh_list))
-		mlx5e_rep_queue_neigh_stats_work(priv);
-
-	while ((nhe = mlx5e_get_next_nhe(rpriv, nhe)) != NULL)
-		mlx5e_tc_update_neigh_used_value(nhe);
-
-	rtnl_unlock();
-}
-
-static void mlx5e_rep_neigh_update(struct work_struct *work)
-{
-	struct mlx5e_neigh_hash_entry *nhe =
-		container_of(work, struct mlx5e_neigh_hash_entry, neigh_update_work);
-	struct neighbour *n = nhe->n;
-	struct mlx5e_encap_entry *e;
-	unsigned char ha[ETH_ALEN];
-	struct mlx5e_priv *priv;
-	bool neigh_connected;
-	u8 nud_state, dead;
-
-	rtnl_lock();
-
-	/* If these parameters are changed after we release the lock,
-	 * we'll receive another event letting us know about it.
-	 * We use this lock to avoid inconsistency between the neigh validity
-	 * and it's hw address.
-	 */
-	read_lock_bh(&n->lock);
-	memcpy(ha, n->ha, ETH_ALEN);
-	nud_state = n->nud_state;
-	dead = n->dead;
-	read_unlock_bh(&n->lock);
-
-	neigh_connected = (nud_state & NUD_VALID) && !dead;
-
-	trace_mlx5e_rep_neigh_update(nhe, ha, neigh_connected);
-
-	list_for_each_entry(e, &nhe->encap_list, encap_list) {
-		if (!mlx5e_encap_take(e))
-			continue;
-
-		priv = netdev_priv(e->out_dev);
-		mlx5e_rep_update_flows(priv, e, neigh_connected, ha);
-		mlx5e_encap_put(priv, e);
-	}
-	mlx5e_rep_neigh_entry_release(nhe);
-	rtnl_unlock();
-	neigh_release(n);
-}
-
-static void
-mlx5e_rep_queue_neigh_update_work(struct mlx5e_priv *priv,
-				  struct mlx5e_neigh_hash_entry *nhe,
-				  struct neighbour *n)
-{
-	/* Take a reference to ensure the neighbour and mlx5 encap
-	 * entry won't be destructed until we drop the reference in
-	 * delayed work.
-	 */
-	neigh_hold(n);
-
-	/* This assignment is valid as long as the the neigh reference
-	 * is taken
-	 */
-	nhe->n = n;
-
-	if (!queue_work(priv->wq, &nhe->neigh_update_work)) {
-		mlx5e_rep_neigh_entry_release(nhe);
-		neigh_release(n);
-	}
-}
-
-static int mlx5e_rep_netevent_event(struct notifier_block *nb,
-				    unsigned long event, void *ptr)
-{
-	struct mlx5e_rep_priv *rpriv = container_of(nb, struct mlx5e_rep_priv,
-						    neigh_update.netevent_nb);
-	struct mlx5e_neigh_update_table *neigh_update = &rpriv->neigh_update;
-	struct net_device *netdev = rpriv->netdev;
-	struct mlx5e_priv *priv = netdev_priv(netdev);
-	struct mlx5e_neigh_hash_entry *nhe = NULL;
-	struct mlx5e_neigh m_neigh = {};
-	struct neigh_parms *p;
-	struct neighbour *n;
-	bool found = false;
-
-	switch (event) {
-	case NETEVENT_NEIGH_UPDATE:
-		n = ptr;
-#if IS_ENABLED(CONFIG_IPV6)
-		if (n->tbl != ipv6_stub->nd_tbl && n->tbl != &arp_tbl)
-#else
-		if (n->tbl != &arp_tbl)
-#endif
-			return NOTIFY_DONE;
-
-		m_neigh.dev = n->dev;
-		m_neigh.family = n->ops->family;
-		memcpy(&m_neigh.dst_ip, n->primary_key, n->tbl->key_len);
-
-		rcu_read_lock();
-		nhe = mlx5e_rep_neigh_entry_lookup(priv, &m_neigh);
-		rcu_read_unlock();
-		if (!nhe)
-			return NOTIFY_DONE;
-
-		mlx5e_rep_queue_neigh_update_work(priv, nhe, n);
-		break;
-
-	case NETEVENT_DELAY_PROBE_TIME_UPDATE:
-		p = ptr;
-
-		/* We check the device is present since we don't care about
-		 * changes in the default table, we only care about changes
-		 * done per device delay prob time parameter.
-		 */
-#if IS_ENABLED(CONFIG_IPV6)
-		if (!p->dev || (p->tbl != ipv6_stub->nd_tbl && p->tbl != &arp_tbl))
-#else
-		if (!p->dev || p->tbl != &arp_tbl)
-#endif
-			return NOTIFY_DONE;
-
-		rcu_read_lock();
-		list_for_each_entry_rcu(nhe, &neigh_update->neigh_list,
-					neigh_list) {
-			if (p->dev == nhe->m_neigh.dev) {
-				found = true;
-				break;
-			}
-		}
-		rcu_read_unlock();
-		if (!found)
-			return NOTIFY_DONE;
-
-		neigh_update->min_interval = min_t(unsigned long,
-						   NEIGH_VAR(p, DELAY_PROBE_TIME),
-						   neigh_update->min_interval);
-		mlx5_fc_update_sampling_interval(priv->mdev,
-						 neigh_update->min_interval);
-		break;
-	}
-	return NOTIFY_DONE;
-}
-
-static const struct rhashtable_params mlx5e_neigh_ht_params = {
-	.head_offset = offsetof(struct mlx5e_neigh_hash_entry, rhash_node),
-	.key_offset = offsetof(struct mlx5e_neigh_hash_entry, m_neigh),
-	.key_len = sizeof(struct mlx5e_neigh),
-	.automatic_shrinking = true,
-};
-
-static int mlx5e_rep_neigh_init(struct mlx5e_rep_priv *rpriv)
-{
-	struct mlx5e_neigh_update_table *neigh_update = &rpriv->neigh_update;
-	int err;
-
-	err = rhashtable_init(&neigh_update->neigh_ht, &mlx5e_neigh_ht_params);
-	if (err)
-		return err;
-
-	INIT_LIST_HEAD(&neigh_update->neigh_list);
-	mutex_init(&neigh_update->encap_lock);
-	INIT_DELAYED_WORK(&neigh_update->neigh_stats_work,
-			  mlx5e_rep_neigh_stats_work);
-	mlx5e_rep_neigh_update_init_interval(rpriv);
-
-	rpriv->neigh_update.netevent_nb.notifier_call = mlx5e_rep_netevent_event;
-	err = register_netevent_notifier(&rpriv->neigh_update.netevent_nb);
-	if (err)
-		goto out_err;
-	return 0;
-
-out_err:
-	rhashtable_destroy(&neigh_update->neigh_ht);
-	return err;
-}
-
-static void mlx5e_rep_neigh_cleanup(struct mlx5e_rep_priv *rpriv)
-{
-	struct mlx5e_neigh_update_table *neigh_update = &rpriv->neigh_update;
-	struct mlx5e_priv *priv = netdev_priv(rpriv->netdev);
-
-	unregister_netevent_notifier(&neigh_update->netevent_nb);
-
-	flush_workqueue(priv->wq); /* flush neigh update works */
-
-	cancel_delayed_work_sync(&rpriv->neigh_update.neigh_stats_work);
-
-	mutex_destroy(&neigh_update->encap_lock);
-	rhashtable_destroy(&neigh_update->neigh_ht);
-}
-
-static int mlx5e_rep_neigh_entry_insert(struct mlx5e_priv *priv,
-					struct mlx5e_neigh_hash_entry *nhe)
-{
-	struct mlx5e_rep_priv *rpriv = priv->ppriv;
-	int err;
-
-	err = rhashtable_insert_fast(&rpriv->neigh_update.neigh_ht,
-				     &nhe->rhash_node,
-				     mlx5e_neigh_ht_params);
-	if (err)
-		return err;
-
-	list_add_rcu(&nhe->neigh_list, &rpriv->neigh_update.neigh_list);
-
-	return err;
-}
-
-static void mlx5e_rep_neigh_entry_remove(struct mlx5e_neigh_hash_entry *nhe)
-{
-	struct mlx5e_rep_priv *rpriv = nhe->priv->ppriv;
-
-	mutex_lock(&rpriv->neigh_update.encap_lock);
-
-	list_del_rcu(&nhe->neigh_list);
-
-	rhashtable_remove_fast(&rpriv->neigh_update.neigh_ht,
-			       &nhe->rhash_node,
-			       mlx5e_neigh_ht_params);
-	mutex_unlock(&rpriv->neigh_update.encap_lock);
-}
-
-/* This function must only be called under the representor's encap_lock or
- * inside rcu read lock section.
- */
-struct mlx5e_neigh_hash_entry *
-mlx5e_rep_neigh_entry_lookup(struct mlx5e_priv *priv,
-			     struct mlx5e_neigh *m_neigh)
-{
-	struct mlx5e_rep_priv *rpriv = priv->ppriv;
-	struct mlx5e_neigh_update_table *neigh_update = &rpriv->neigh_update;
-	struct mlx5e_neigh_hash_entry *nhe;
-
-	nhe = rhashtable_lookup_fast(&neigh_update->neigh_ht, m_neigh,
-				     mlx5e_neigh_ht_params);
-	return nhe && mlx5e_rep_neigh_entry_hold(nhe) ? nhe : NULL;
-}
-
-int mlx5e_rep_neigh_entry_create(struct mlx5e_priv *priv,
-				 struct mlx5e_encap_entry *e,
-				 struct mlx5e_neigh_hash_entry **nhe)
-{
-	int err;
-
-	*nhe = kzalloc(sizeof(**nhe), GFP_KERNEL);
-	if (!*nhe)
-		return -ENOMEM;
-
-	(*nhe)->priv = priv;
-	memcpy(&(*nhe)->m_neigh, &e->m_neigh, sizeof(e->m_neigh));
-	INIT_WORK(&(*nhe)->neigh_update_work, mlx5e_rep_neigh_update);
-	spin_lock_init(&(*nhe)->encap_list_lock);
-	INIT_LIST_HEAD(&(*nhe)->encap_list);
-	refcount_set(&(*nhe)->refcnt, 1);
-
-	err = mlx5e_rep_neigh_entry_insert(priv, *nhe);
-	if (err)
-		goto out_free;
-	return 0;
-
-out_free:
-	kfree(*nhe);
-	return err;
-}
-
 static int mlx5e_rep_open(struct net_device *dev)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 74d46e9a201a..81ed06e58fea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -208,14 +208,6 @@ void mlx5e_rep_queue_neigh_stats_work(struct mlx5e_priv *priv);
 bool mlx5e_eswitch_rep(struct net_device *netdev);
 bool mlx5e_eswitch_uplink_rep(struct net_device *netdev);
 
-struct mlx5e_neigh_hash_entry *
-mlx5e_rep_neigh_entry_lookup(struct mlx5e_priv *priv,
-			     struct mlx5e_neigh *m_neigh);
-int mlx5e_rep_neigh_entry_create(struct mlx5e_priv *priv,
-				 struct mlx5e_encap_entry *e,
-				 struct mlx5e_neigh_hash_entry **nhe);
-void mlx5e_rep_neigh_entry_release(struct mlx5e_neigh_hash_entry *nhe);
-
 #else /* CONFIG_MLX5_ESWITCH */
 static inline bool mlx5e_is_uplink_rep(struct mlx5e_priv *priv) { return false; }
 static inline int mlx5e_add_sqs_fwd_rules(struct mlx5e_priv *priv) { return 0; }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 251975ccbdf7..749390dc7aaa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4777,9 +4777,3 @@ void mlx5e_tc_reoffload_flows_work(struct work_struct *work)
 	}
 	mutex_unlock(&rpriv->unready_flows_lock);
 }
-
-void mlx5_tc_rep_post_napi_receive(struct mlx5e_tc_update_priv *tc_priv)
-{
-	if (tc_priv->tun_dev)
-		dev_put(tc_priv->tun_dev);
-}
-- 
2.25.4

