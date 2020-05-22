Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6671DF35C
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 01:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387412AbgEVXyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 19:54:05 -0400
Received: from mail-db8eur05on2063.outbound.protection.outlook.com ([40.107.20.63]:35520
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726546AbgEVXyE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 19:54:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NU4eqe4HImh5ohsTUGWB9G7JXeYK0OMqL5PKGAb1tNNNNTFTWpMf5vTVH0YyLcJXlQOoqPI+FGXRZZMrLXd0jJ/Rf2Px9WJGvsNGthsT+AVMb8gJJamtUePRUXqJKoAmMu30dw3RXeJVij5qMe393vpuJiLKnfMSZLLSZuMmhybxBZ7dvJOy6k5txNSS5ntFC/YqxDehCubLJAIASPUJMrutX2jgRoM1n3z6nOq/YKOGPgzR1iaRboljV0/zlzczwjo2zdu3OakewpxruJm0XTmM5JpTX3skrsdnmHUijqzD/Fggq7GKfiUQYC4XekQCMqkX6iBsfIH6JNRwyM9zCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/PxvMeN/KXaRI5jGagKT4oKo6e2RycIkZZ37TjdcUF8=;
 b=Ni9sFAcgZMeY9XarbebJTu4enMBqLZmnNL10JISUjXvmZHbsiQBE/aLxBu0ZZxKVJiy2IWJ2eH3+VdZLBXLUAZy6+hficPK0FD9CyEbAoJ46bhKqf/XyM8Kd7ME6YzwojbvT/7e6202D8xPaov9yaH3tPKFaPJaKuc+ozwHty1Ap5bsvhyYKNk+intybTVEuhmDJ6v1o8LGUn+OVlVcUagUM7cCJ045okDe6Xs+upO6bIldYitjefl7bhbgJO1OqabS0SYMJyRLV26t6nf31gqtjgIPpZFv2oAxZ3a8VE24KyKMAjTcUxDliiyPcblSUVbveUHdxiMcrlLkiOJkvvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/PxvMeN/KXaRI5jGagKT4oKo6e2RycIkZZ37TjdcUF8=;
 b=lzlsQe9H4g0oPXxZlD6hMI6Lu1hKQTiPxf9aKyLO9PUpJXBvURH+8Vfb7g1Uw8KtDtkYG2m4Eunw1+ornDmDSolfqBtQhyjBLuaL3OTQMVXMR7b7j+gx/7Ary9FtWtOCcWVINhCVLJvXsp0yhwhi5zpg/85XhgsMFtAUF2bT/LI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4544.eurprd05.prod.outlook.com (2603:10a6:802:5e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Fri, 22 May
 2020 23:52:13 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.026; Fri, 22 May 2020
 23:52:13 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 02/10] net/mlx5e: Extract TC-specific code from en_rep.c to rep/tc.c
Date:   Fri, 22 May 2020 16:51:40 -0700
Message-Id: <20200522235148.28987-3-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BY3PR10CA0015.namprd10.prod.outlook.com (2603:10b6:a03:255::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24 via Frontend Transport; Fri, 22 May 2020 23:52:11 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ef055ac0-7c0a-4cd8-f4f6-08d7feab2669
X-MS-TrafficTypeDiagnostic: VI1PR05MB4544:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4544AE4E64B27AE86533B685BEB40@VI1PR05MB4544.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 04111BAC64
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6lj24a6i46suAWHE97/ziGGJxhgw0s/Y+4yfF9pLabUAPH02v9oAIRqQV4wP5grUSQI3YTRfrFpYhkDjmb3NEy4g/QPiD3hvi58LNh1Jl6fy4UD+EUMWVdUdUA0BSje50wSwdYhe0/HdjCNOl+VwgpNgK43D6+9po2lh/DCFTryP7+/y+yQ1N5mHq6Mo//xpbiqOOPheHpVxOS0SCWHechJy/1W35ye9OIss4Q0A5AIUWQViaB3fvE0VjgwE/0F/xzjt4KJN7uxqNx8a3I7rz8hih2Hjyt1sqaRjjSOXD2vsaTFLFRuriLgJaPIDRFRVqOifsYGvsvrMIw4mDU4MkrLLaWWGBYVltGYrV7i2bJDo6s0OJGBNy/Qgvf7dErLK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(66476007)(956004)(6506007)(66556008)(2616005)(66946007)(107886003)(6512007)(1076003)(16526019)(478600001)(186003)(52116002)(26005)(4326008)(6666004)(30864003)(316002)(6486002)(86362001)(8676002)(54906003)(36756003)(8936002)(2906002)(5660300002)(54420400002)(559001)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: UokilDIQbL867kZ9Oxq3CPqe1qvjcQfpuoul55kND4W+f/dQ/WJ6twrqGbFcLXr5g80axkXLbFA4zIyqcNY6N4IbUFENq1h6NKNVWAROLPSnNFn50rcDTLW2sOH1uJDxPmWL2eDsbWtppQFRXaJLG4e+DXdSobeMCh4i6sGudH38dgUjfSfHkENwBTlX7UqCDArZKVcq99rOmxkPhkC6TerwqXn7aWjlb2bGBtoZRVH0t0mkpRYqAyZgrmjUw+eLWw7Vz1oQOdFXWzGvNq+NAEJt88QPo+eN1JS3rdw8qT1PdFjkA8OSigUhdsN23GvPmEVfo4bDarGdauNYKYFuq2hn5bskOt81Yvnq0qRmH2KlpGOvec6vmAZqKaJxXe/BVIwFVTbNw+//xKFC5yBoHxgXCUIUuJlPKHieVZbwWc02KkYKSlDjFxSEB5IkFiVCQo55xe9DSwGYnsEGyu2FFE1o8BWFzPaaKjra0/ztIiI=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef055ac0-7c0a-4cd8-f4f6-08d7feab2669
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2020 23:52:13.7713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vzax90ezjuZ1Y83l0tAkIrgMeYGzr6TkJw3RtPu9XlkYaWbVS39pD3AKe/iNdt1ArJHw4TtfKuhdLnzaikCkMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4544
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

As a preparation for introducing new kconfig option that controls
compilation of all TC offloads code in mlx5, extract TC-specific code from
en_rep.c to standalone file. This allows easily compiling out the code by
only including new source in make file when corresponding kconfig is
enabled instead of adding multiple ifdef blocks to en_rep.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   3 +-
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   | 710 ++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en/rep/tc.h   |  45 ++
 .../ethernet/mellanox/mlx5/core/en/tc_tun.c   |   1 +
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 543 +-------------
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |  13 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   9 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 170 +----
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  35 +-
 9 files changed, 821 insertions(+), 708 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index d3c7dbd7f1d5..c21453970dbb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -33,7 +33,8 @@ mlx5_core-$(CONFIG_MLX5_CORE_EN) += en_main.o en_common.o en_fs.o en_ethtool.o \
 mlx5_core-$(CONFIG_MLX5_EN_ARFS)     += en_arfs.o
 mlx5_core-$(CONFIG_MLX5_EN_RXNFC)    += en_fs_ethtool.o
 mlx5_core-$(CONFIG_MLX5_CORE_EN_DCB) += en_dcbnl.o en/port_buffer.o
-mlx5_core-$(CONFIG_MLX5_ESWITCH)     += en_rep.o en_tc.o en/tc_tun.o lib/port_tun.o lag_mp.o \
+mlx5_core-$(CONFIG_MLX5_ESWITCH)     += en_rep.o en_tc.o en/rep/tc.o en/tc_tun.o lib/port_tun.o \
+					lag_mp.o \
 					lib/geneve.o en/mapping.o en/tc_tun_vxlan.o en/tc_tun_gre.o \
 					en/tc_tun_geneve.o diag/en_tc_tracepoint.o
 mlx5_core-$(CONFIG_PCI_HYPERV_INTERFACE) += en/hv_vhca_stats.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
new file mode 100644
index 000000000000..edc574582135
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -0,0 +1,710 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2020 Mellanox Technologies. */
+
+#include <net/dst_metadata.h>
+#include <linux/netdevice.h>
+#include <linux/list.h>
+#include <linux/rculist.h>
+#include <linux/rtnetlink.h>
+#include <linux/workqueue.h>
+#include <linux/spinlock.h>
+#include "tc.h"
+#include "en_rep.h"
+#include "eswitch.h"
+#include "esw/chains.h"
+#include "en/tc_ct.h"
+#include "en/mapping.h"
+#include "en/tc_tun.h"
+#include "lib/port_tun.h"
+
+struct mlx5e_rep_indr_block_priv {
+	struct net_device *netdev;
+	struct mlx5e_rep_priv *rpriv;
+
+	struct list_head list;
+};
+
+int mlx5e_rep_encap_entry_attach(struct mlx5e_priv *priv,
+				 struct mlx5e_encap_entry *e)
+{
+	struct mlx5e_rep_priv *rpriv = priv->ppriv;
+	struct mlx5_rep_uplink_priv *uplink_priv = &rpriv->uplink_priv;
+	struct mlx5_tun_entropy *tun_entropy = &uplink_priv->tun_entropy;
+	struct mlx5e_neigh_hash_entry *nhe;
+	int err;
+
+	err = mlx5_tun_entropy_refcount_inc(tun_entropy, e->reformat_type);
+	if (err)
+		return err;
+
+	mutex_lock(&rpriv->neigh_update.encap_lock);
+	nhe = mlx5e_rep_neigh_entry_lookup(priv, &e->m_neigh);
+	if (!nhe) {
+		err = mlx5e_rep_neigh_entry_create(priv, e, &nhe);
+		if (err) {
+			mutex_unlock(&rpriv->neigh_update.encap_lock);
+			mlx5_tun_entropy_refcount_dec(tun_entropy,
+						      e->reformat_type);
+			return err;
+		}
+	}
+
+	e->nhe = nhe;
+	spin_lock(&nhe->encap_list_lock);
+	list_add_rcu(&e->encap_list, &nhe->encap_list);
+	spin_unlock(&nhe->encap_list_lock);
+
+	mutex_unlock(&rpriv->neigh_update.encap_lock);
+
+	return 0;
+}
+
+void mlx5e_rep_encap_entry_detach(struct mlx5e_priv *priv,
+				  struct mlx5e_encap_entry *e)
+{
+	struct mlx5e_rep_priv *rpriv = priv->ppriv;
+	struct mlx5_rep_uplink_priv *uplink_priv = &rpriv->uplink_priv;
+	struct mlx5_tun_entropy *tun_entropy = &uplink_priv->tun_entropy;
+
+	if (!e->nhe)
+		return;
+
+	spin_lock(&e->nhe->encap_list_lock);
+	list_del_rcu(&e->encap_list);
+	spin_unlock(&e->nhe->encap_list_lock);
+
+	mlx5e_rep_neigh_entry_release(e->nhe);
+	e->nhe = NULL;
+	mlx5_tun_entropy_refcount_dec(tun_entropy, e->reformat_type);
+}
+
+void mlx5e_rep_update_flows(struct mlx5e_priv *priv,
+			    struct mlx5e_encap_entry *e,
+			    bool neigh_connected,
+			    unsigned char ha[ETH_ALEN])
+{
+	struct ethhdr *eth = (struct ethhdr *)e->encap_header;
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	bool encap_connected;
+	LIST_HEAD(flow_list);
+
+	ASSERT_RTNL();
+
+	/* wait for encap to be fully initialized */
+	wait_for_completion(&e->res_ready);
+
+	mutex_lock(&esw->offloads.encap_tbl_lock);
+	encap_connected = !!(e->flags & MLX5_ENCAP_ENTRY_VALID);
+	if (e->compl_result < 0 || (encap_connected == neigh_connected &&
+				    ether_addr_equal(e->h_dest, ha)))
+		goto unlock;
+
+	mlx5e_take_all_encap_flows(e, &flow_list);
+
+	if ((e->flags & MLX5_ENCAP_ENTRY_VALID) &&
+	    (!neigh_connected || !ether_addr_equal(e->h_dest, ha)))
+		mlx5e_tc_encap_flows_del(priv, e, &flow_list);
+
+	if (neigh_connected && !(e->flags & MLX5_ENCAP_ENTRY_VALID)) {
+		ether_addr_copy(e->h_dest, ha);
+		ether_addr_copy(eth->h_dest, ha);
+		/* Update the encap source mac, in case that we delete
+		 * the flows when encap source mac changed.
+		 */
+		ether_addr_copy(eth->h_source, e->route_dev->dev_addr);
+
+		mlx5e_tc_encap_flows_add(priv, e, &flow_list);
+	}
+unlock:
+	mutex_unlock(&esw->offloads.encap_tbl_lock);
+	mlx5e_put_encap_flow_list(priv, &flow_list);
+}
+
+static int
+mlx5e_rep_setup_tc_cls_flower(struct mlx5e_priv *priv,
+			      struct flow_cls_offload *cls_flower, int flags)
+{
+	switch (cls_flower->command) {
+	case FLOW_CLS_REPLACE:
+		return mlx5e_configure_flower(priv->netdev, priv, cls_flower,
+					      flags);
+	case FLOW_CLS_DESTROY:
+		return mlx5e_delete_flower(priv->netdev, priv, cls_flower,
+					   flags);
+	case FLOW_CLS_STATS:
+		return mlx5e_stats_flower(priv->netdev, priv, cls_flower,
+					  flags);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static
+int mlx5e_rep_setup_tc_cls_matchall(struct mlx5e_priv *priv,
+				    struct tc_cls_matchall_offload *ma)
+{
+	switch (ma->command) {
+	case TC_CLSMATCHALL_REPLACE:
+		return mlx5e_tc_configure_matchall(priv, ma);
+	case TC_CLSMATCHALL_DESTROY:
+		return mlx5e_tc_delete_matchall(priv, ma);
+	case TC_CLSMATCHALL_STATS:
+		mlx5e_tc_stats_matchall(priv, ma);
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int mlx5e_rep_setup_tc_cb(enum tc_setup_type type, void *type_data,
+				 void *cb_priv)
+{
+	unsigned long flags = MLX5_TC_FLAG(INGRESS) | MLX5_TC_FLAG(ESW_OFFLOAD);
+	struct mlx5e_priv *priv = cb_priv;
+
+	switch (type) {
+	case TC_SETUP_CLSFLOWER:
+		return mlx5e_rep_setup_tc_cls_flower(priv, type_data, flags);
+	case TC_SETUP_CLSMATCHALL:
+		return mlx5e_rep_setup_tc_cls_matchall(priv, type_data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int mlx5e_rep_setup_ft_cb(enum tc_setup_type type, void *type_data,
+				 void *cb_priv)
+{
+	struct flow_cls_offload tmp, *f = type_data;
+	struct mlx5e_priv *priv = cb_priv;
+	struct mlx5_eswitch *esw;
+	unsigned long flags;
+	int err;
+
+	flags = MLX5_TC_FLAG(INGRESS) |
+		MLX5_TC_FLAG(ESW_OFFLOAD) |
+		MLX5_TC_FLAG(FT_OFFLOAD);
+	esw = priv->mdev->priv.eswitch;
+
+	switch (type) {
+	case TC_SETUP_CLSFLOWER:
+		memcpy(&tmp, f, sizeof(*f));
+
+		if (!mlx5_esw_chains_prios_supported(esw))
+			return -EOPNOTSUPP;
+
+		/* Re-use tc offload path by moving the ft flow to the
+		 * reserved ft chain.
+		 *
+		 * FT offload can use prio range [0, INT_MAX], so we normalize
+		 * it to range [1, mlx5_esw_chains_get_prio_range(esw)]
+		 * as with tc, where prio 0 isn't supported.
+		 *
+		 * We only support chain 0 of FT offload.
+		 */
+		if (tmp.common.prio >= mlx5_esw_chains_get_prio_range(esw))
+			return -EOPNOTSUPP;
+		if (tmp.common.chain_index != 0)
+			return -EOPNOTSUPP;
+
+		tmp.common.chain_index = mlx5_esw_chains_get_ft_chain(esw);
+		tmp.common.prio++;
+		err = mlx5e_rep_setup_tc_cls_flower(priv, &tmp, flags);
+		memcpy(&f->stats, &tmp.stats, sizeof(f->stats));
+		return err;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static LIST_HEAD(mlx5e_rep_block_tc_cb_list);
+static LIST_HEAD(mlx5e_rep_block_ft_cb_list);
+int mlx5e_rep_setup_tc(struct net_device *dev, enum tc_setup_type type,
+		       void *type_data)
+{
+	struct mlx5e_priv *priv = netdev_priv(dev);
+	struct flow_block_offload *f = type_data;
+
+	f->unlocked_driver_cb = true;
+
+	switch (type) {
+	case TC_SETUP_BLOCK:
+		return flow_block_cb_setup_simple(type_data,
+						  &mlx5e_rep_block_tc_cb_list,
+						  mlx5e_rep_setup_tc_cb,
+						  priv, priv, true);
+	case TC_SETUP_FT:
+		return flow_block_cb_setup_simple(type_data,
+						  &mlx5e_rep_block_ft_cb_list,
+						  mlx5e_rep_setup_ft_cb,
+						  priv, priv, true);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+int mlx5e_rep_tc_init(struct mlx5e_rep_priv *rpriv)
+{
+	struct mlx5_rep_uplink_priv *uplink_priv = &rpriv->uplink_priv;
+	int err;
+
+	mutex_init(&uplink_priv->unready_flows_lock);
+	INIT_LIST_HEAD(&uplink_priv->unready_flows);
+
+	/* init shared tc flow table */
+	err = mlx5e_tc_esw_init(&uplink_priv->tc_ht);
+	return err;
+}
+
+void mlx5e_rep_tc_cleanup(struct mlx5e_rep_priv *rpriv)
+{
+	/* delete shared tc flow table */
+	mlx5e_tc_esw_cleanup(&rpriv->uplink_priv.tc_ht);
+	mutex_destroy(&rpriv->uplink_priv.unready_flows_lock);
+}
+
+void mlx5e_rep_tc_enable(struct mlx5e_priv *priv)
+{
+	struct mlx5e_rep_priv *rpriv = priv->ppriv;
+
+	INIT_WORK(&rpriv->uplink_priv.reoffload_flows_work,
+		  mlx5e_tc_reoffload_flows_work);
+}
+
+void mlx5e_rep_tc_disable(struct mlx5e_priv *priv)
+{
+	struct mlx5e_rep_priv *rpriv = priv->ppriv;
+
+	cancel_work_sync(&rpriv->uplink_priv.reoffload_flows_work);
+}
+
+int mlx5e_rep_tc_event_port_affinity(struct mlx5e_priv *priv)
+{
+	struct mlx5e_rep_priv *rpriv = priv->ppriv;
+
+	queue_work(priv->wq, &rpriv->uplink_priv.reoffload_flows_work);
+
+	return NOTIFY_OK;
+}
+
+static struct mlx5e_rep_indr_block_priv *
+mlx5e_rep_indr_block_priv_lookup(struct mlx5e_rep_priv *rpriv,
+				 struct net_device *netdev)
+{
+	struct mlx5e_rep_indr_block_priv *cb_priv;
+
+	/* All callback list access should be protected by RTNL. */
+	ASSERT_RTNL();
+
+	list_for_each_entry(cb_priv,
+			    &rpriv->uplink_priv.tc_indr_block_priv_list,
+			    list)
+		if (cb_priv->netdev == netdev)
+			return cb_priv;
+
+	return NULL;
+}
+
+static void mlx5e_rep_indr_unregister_block(struct mlx5e_rep_priv *rpriv,
+					    struct net_device *netdev);
+
+void mlx5e_rep_indr_clean_block_privs(struct mlx5e_rep_priv *rpriv)
+{
+	struct mlx5e_rep_indr_block_priv *cb_priv, *temp;
+	struct list_head *head = &rpriv->uplink_priv.tc_indr_block_priv_list;
+
+	list_for_each_entry_safe(cb_priv, temp, head, list) {
+		mlx5e_rep_indr_unregister_block(rpriv, cb_priv->netdev);
+		kfree(cb_priv);
+	}
+}
+
+static int
+mlx5e_rep_indr_offload(struct net_device *netdev,
+		       struct flow_cls_offload *flower,
+		       struct mlx5e_rep_indr_block_priv *indr_priv,
+		       unsigned long flags)
+{
+	struct mlx5e_priv *priv = netdev_priv(indr_priv->rpriv->netdev);
+	int err = 0;
+
+	switch (flower->command) {
+	case FLOW_CLS_REPLACE:
+		err = mlx5e_configure_flower(netdev, priv, flower, flags);
+		break;
+	case FLOW_CLS_DESTROY:
+		err = mlx5e_delete_flower(netdev, priv, flower, flags);
+		break;
+	case FLOW_CLS_STATS:
+		err = mlx5e_stats_flower(netdev, priv, flower, flags);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+	}
+
+	return err;
+}
+
+static int mlx5e_rep_indr_setup_tc_cb(enum tc_setup_type type,
+				      void *type_data, void *indr_priv)
+{
+	unsigned long flags = MLX5_TC_FLAG(EGRESS) | MLX5_TC_FLAG(ESW_OFFLOAD);
+	struct mlx5e_rep_indr_block_priv *priv = indr_priv;
+
+	switch (type) {
+	case TC_SETUP_CLSFLOWER:
+		return mlx5e_rep_indr_offload(priv->netdev, type_data, priv,
+					      flags);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int mlx5e_rep_indr_setup_ft_cb(enum tc_setup_type type,
+				      void *type_data, void *indr_priv)
+{
+	struct mlx5e_rep_indr_block_priv *priv = indr_priv;
+	struct flow_cls_offload *f = type_data;
+	struct flow_cls_offload tmp;
+	struct mlx5e_priv *mpriv;
+	struct mlx5_eswitch *esw;
+	unsigned long flags;
+	int err;
+
+	mpriv = netdev_priv(priv->rpriv->netdev);
+	esw = mpriv->mdev->priv.eswitch;
+
+	flags = MLX5_TC_FLAG(EGRESS) |
+		MLX5_TC_FLAG(ESW_OFFLOAD) |
+		MLX5_TC_FLAG(FT_OFFLOAD);
+
+	switch (type) {
+	case TC_SETUP_CLSFLOWER:
+		memcpy(&tmp, f, sizeof(*f));
+
+		/* Re-use tc offload path by moving the ft flow to the
+		 * reserved ft chain.
+		 *
+		 * FT offload can use prio range [0, INT_MAX], so we normalize
+		 * it to range [1, mlx5_esw_chains_get_prio_range(esw)]
+		 * as with tc, where prio 0 isn't supported.
+		 *
+		 * We only support chain 0 of FT offload.
+		 */
+		if (!mlx5_esw_chains_prios_supported(esw) ||
+		    tmp.common.prio >= mlx5_esw_chains_get_prio_range(esw) ||
+		    tmp.common.chain_index)
+			return -EOPNOTSUPP;
+
+		tmp.common.chain_index = mlx5_esw_chains_get_ft_chain(esw);
+		tmp.common.prio++;
+		err = mlx5e_rep_indr_offload(priv->netdev, &tmp, priv, flags);
+		memcpy(&f->stats, &tmp.stats, sizeof(f->stats));
+		return err;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static void mlx5e_rep_indr_block_unbind(void *cb_priv)
+{
+	struct mlx5e_rep_indr_block_priv *indr_priv = cb_priv;
+
+	list_del(&indr_priv->list);
+	kfree(indr_priv);
+}
+
+static LIST_HEAD(mlx5e_block_cb_list);
+
+static int
+mlx5e_rep_indr_setup_block(struct net_device *netdev,
+			   struct mlx5e_rep_priv *rpriv,
+			   struct flow_block_offload *f,
+			   flow_setup_cb_t *setup_cb)
+{
+	struct mlx5e_rep_indr_block_priv *indr_priv;
+	struct flow_block_cb *block_cb;
+
+	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
+		return -EOPNOTSUPP;
+
+	f->unlocked_driver_cb = true;
+	f->driver_block_list = &mlx5e_block_cb_list;
+
+	switch (f->command) {
+	case FLOW_BLOCK_BIND:
+		indr_priv = mlx5e_rep_indr_block_priv_lookup(rpriv, netdev);
+		if (indr_priv)
+			return -EEXIST;
+
+		indr_priv = kmalloc(sizeof(*indr_priv), GFP_KERNEL);
+		if (!indr_priv)
+			return -ENOMEM;
+
+		indr_priv->netdev = netdev;
+		indr_priv->rpriv = rpriv;
+		list_add(&indr_priv->list,
+			 &rpriv->uplink_priv.tc_indr_block_priv_list);
+
+		block_cb = flow_block_cb_alloc(setup_cb, indr_priv, indr_priv,
+					       mlx5e_rep_indr_block_unbind);
+		if (IS_ERR(block_cb)) {
+			list_del(&indr_priv->list);
+			kfree(indr_priv);
+			return PTR_ERR(block_cb);
+		}
+		flow_block_cb_add(block_cb, f);
+		list_add_tail(&block_cb->driver_list, &mlx5e_block_cb_list);
+
+		return 0;
+	case FLOW_BLOCK_UNBIND:
+		indr_priv = mlx5e_rep_indr_block_priv_lookup(rpriv, netdev);
+		if (!indr_priv)
+			return -ENOENT;
+
+		block_cb = flow_block_cb_lookup(f->block, setup_cb, indr_priv);
+		if (!block_cb)
+			return -ENOENT;
+
+		flow_block_cb_remove(block_cb, f);
+		list_del(&block_cb->driver_list);
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+	return 0;
+}
+
+static
+int mlx5e_rep_indr_setup_cb(struct net_device *netdev, void *cb_priv,
+			    enum tc_setup_type type, void *type_data)
+{
+	switch (type) {
+	case TC_SETUP_BLOCK:
+		return mlx5e_rep_indr_setup_block(netdev, cb_priv, type_data,
+						  mlx5e_rep_indr_setup_tc_cb);
+	case TC_SETUP_FT:
+		return mlx5e_rep_indr_setup_block(netdev, cb_priv, type_data,
+						  mlx5e_rep_indr_setup_ft_cb);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int mlx5e_rep_indr_register_block(struct mlx5e_rep_priv *rpriv,
+					 struct net_device *netdev)
+{
+	int err;
+
+	err = __flow_indr_block_cb_register(netdev, rpriv,
+					    mlx5e_rep_indr_setup_cb,
+					    rpriv);
+	if (err) {
+		struct mlx5e_priv *priv = netdev_priv(rpriv->netdev);
+
+		mlx5_core_err(priv->mdev, "Failed to register remote block notifier for %s err=%d\n",
+			      netdev_name(netdev), err);
+	}
+	return err;
+}
+
+static void mlx5e_rep_indr_unregister_block(struct mlx5e_rep_priv *rpriv,
+					    struct net_device *netdev)
+{
+	__flow_indr_block_cb_unregister(netdev, mlx5e_rep_indr_setup_cb,
+					rpriv);
+}
+
+static int mlx5e_nic_rep_netdevice_event(struct notifier_block *nb,
+					 unsigned long event, void *ptr)
+{
+	struct mlx5e_rep_priv *rpriv = container_of(nb, struct mlx5e_rep_priv,
+						     uplink_priv.netdevice_nb);
+	struct mlx5e_priv *priv = netdev_priv(rpriv->netdev);
+	struct net_device *netdev = netdev_notifier_info_to_dev(ptr);
+
+	if (!mlx5e_tc_tun_device_to_offload(priv, netdev) &&
+	    !(is_vlan_dev(netdev) && vlan_dev_real_dev(netdev) == rpriv->netdev))
+		return NOTIFY_OK;
+
+	switch (event) {
+	case NETDEV_REGISTER:
+		mlx5e_rep_indr_register_block(rpriv, netdev);
+		break;
+	case NETDEV_UNREGISTER:
+		mlx5e_rep_indr_unregister_block(rpriv, netdev);
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+int mlx5e_rep_tc_netdevice_event_register(struct mlx5e_rep_priv *rpriv)
+{
+	struct mlx5_rep_uplink_priv *uplink_priv = &rpriv->uplink_priv;
+	int err;
+
+	/* init indirect block notifications */
+	INIT_LIST_HEAD(&uplink_priv->tc_indr_block_priv_list);
+
+	uplink_priv->netdevice_nb.notifier_call = mlx5e_nic_rep_netdevice_event;
+	err = register_netdevice_notifier_dev_net(rpriv->netdev,
+						  &uplink_priv->netdevice_nb,
+						  &uplink_priv->netdevice_nn);
+	return err;
+}
+
+void mlx5e_rep_tc_netdevice_event_unregister(struct mlx5e_rep_priv *rpriv)
+{
+	struct mlx5_rep_uplink_priv *uplink_priv = &rpriv->uplink_priv;
+
+	/* clean indirect TC block notifications */
+	unregister_netdevice_notifier_dev_net(rpriv->netdev,
+					      &uplink_priv->netdevice_nb,
+					      &uplink_priv->netdevice_nn);
+}
+
+#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+static bool mlx5e_restore_tunnel(struct mlx5e_priv *priv, struct sk_buff *skb,
+				 struct mlx5e_tc_update_priv *tc_priv,
+				 u32 tunnel_id)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct tunnel_match_enc_opts enc_opts = {};
+	struct mlx5_rep_uplink_priv *uplink_priv;
+	struct mlx5e_rep_priv *uplink_rpriv;
+	struct metadata_dst *tun_dst;
+	struct tunnel_match_key key;
+	u32 tun_id, enc_opts_id;
+	struct net_device *dev;
+	int err;
+
+	enc_opts_id = tunnel_id & ENC_OPTS_BITS_MASK;
+	tun_id = tunnel_id >> ENC_OPTS_BITS;
+
+	if (!tun_id)
+		return true;
+
+	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
+	uplink_priv = &uplink_rpriv->uplink_priv;
+
+	err = mapping_find(uplink_priv->tunnel_mapping, tun_id, &key);
+	if (err) {
+		WARN_ON_ONCE(true);
+		netdev_dbg(priv->netdev,
+			   "Couldn't find tunnel for tun_id: %d, err: %d\n",
+			   tun_id, err);
+		return false;
+	}
+
+	if (enc_opts_id) {
+		err = mapping_find(uplink_priv->tunnel_enc_opts_mapping,
+				   enc_opts_id, &enc_opts);
+		if (err) {
+			netdev_dbg(priv->netdev,
+				   "Couldn't find tunnel (opts) for tun_id: %d, err: %d\n",
+				   enc_opts_id, err);
+			return false;
+		}
+	}
+
+	tun_dst = tun_rx_dst(enc_opts.key.len);
+	if (!tun_dst) {
+		WARN_ON_ONCE(true);
+		return false;
+	}
+
+	ip_tunnel_key_init(&tun_dst->u.tun_info.key,
+			   key.enc_ipv4.src, key.enc_ipv4.dst,
+			   key.enc_ip.tos, key.enc_ip.ttl,
+			   0, /* label */
+			   key.enc_tp.src, key.enc_tp.dst,
+			   key32_to_tunnel_id(key.enc_key_id.keyid),
+			   TUNNEL_KEY);
+
+	if (enc_opts.key.len)
+		ip_tunnel_info_opts_set(&tun_dst->u.tun_info,
+					enc_opts.key.data,
+					enc_opts.key.len,
+					enc_opts.key.dst_opt_type);
+
+	skb_dst_set(skb, (struct dst_entry *)tun_dst);
+	dev = dev_get_by_index(&init_net, key.filter_ifindex);
+	if (!dev) {
+		netdev_dbg(priv->netdev,
+			   "Couldn't find tunnel device with ifindex: %d\n",
+			   key.filter_ifindex);
+		return false;
+	}
+
+	/* Set tun_dev so we do dev_put() after datapath */
+	tc_priv->tun_dev = dev;
+
+	skb->dev = dev;
+
+	return true;
+}
+#endif /* CONFIG_NET_TC_SKB_EXT */
+
+bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
+			     struct sk_buff *skb,
+			     struct mlx5e_tc_update_priv *tc_priv)
+{
+#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+	u32 chain = 0, reg_c0, reg_c1, tunnel_id, tuple_id;
+	struct mlx5_rep_uplink_priv *uplink_priv;
+	struct mlx5e_rep_priv *uplink_rpriv;
+	struct tc_skb_ext *tc_skb_ext;
+	struct mlx5_eswitch *esw;
+	struct mlx5e_priv *priv;
+	int tunnel_moffset;
+	int err;
+
+	reg_c0 = (be32_to_cpu(cqe->sop_drop_qpn) & MLX5E_TC_FLOW_ID_MASK);
+	if (reg_c0 == MLX5_FS_DEFAULT_FLOW_TAG)
+		reg_c0 = 0;
+	reg_c1 = be32_to_cpu(cqe->ft_metadata);
+
+	if (!reg_c0)
+		return true;
+
+	priv = netdev_priv(skb->dev);
+	esw = priv->mdev->priv.eswitch;
+
+	err = mlx5_eswitch_get_chain_for_tag(esw, reg_c0, &chain);
+	if (err) {
+		netdev_dbg(priv->netdev,
+			   "Couldn't find chain for chain tag: %d, err: %d\n",
+			   reg_c0, err);
+		return false;
+	}
+
+	if (chain) {
+		tc_skb_ext = skb_ext_add(skb, TC_SKB_EXT);
+		if (!tc_skb_ext) {
+			WARN_ON(1);
+			return false;
+		}
+
+		tc_skb_ext->chain = chain;
+
+		tuple_id = reg_c1 & TUPLE_ID_MAX;
+
+		uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
+		uplink_priv = &uplink_rpriv->uplink_priv;
+		if (!mlx5e_tc_ct_restore_flow(uplink_priv, skb, tuple_id))
+			return false;
+	}
+
+	tunnel_moffset = mlx5e_tc_attr_to_reg_mappings[TUNNEL_TO_REG].moffset;
+	tunnel_id = reg_c1 >> (8 * tunnel_moffset);
+	return mlx5e_restore_tunnel(priv, skb, tc_priv, tunnel_id);
+#endif /* CONFIG_NET_TC_SKB_EXT */
+
+	return true;
+}
+
+void mlx5_rep_tc_post_napi_receive(struct mlx5e_tc_update_priv *tc_priv)
+{
+	if (tc_priv->tun_dev)
+		dev_put(tc_priv->tun_dev);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.h
new file mode 100644
index 000000000000..90da00626b97
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.h
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2020 Mellanox Technologies. */
+
+#ifndef __MLX5_EN_REP_TC_H__
+#define __MLX5_EN_REP_TC_H__
+
+#include <linux/skbuff.h>
+#include "en.h"
+#include "en_tc.h"
+#include "en_rep.h"
+
+struct mlx5e_rep_priv;
+int mlx5e_rep_tc_init(struct mlx5e_rep_priv *rpriv);
+void mlx5e_rep_tc_cleanup(struct mlx5e_rep_priv *rpriv);
+
+int mlx5e_rep_tc_netdevice_event_register(struct mlx5e_rep_priv *rpriv);
+void mlx5e_rep_tc_netdevice_event_unregister(struct mlx5e_rep_priv *rpriv);
+
+void mlx5e_rep_tc_enable(struct mlx5e_priv *priv);
+void mlx5e_rep_tc_disable(struct mlx5e_priv *priv);
+
+int mlx5e_rep_tc_event_port_affinity(struct mlx5e_priv *priv);
+
+struct mlx5e_encap_entry;
+void mlx5e_rep_update_flows(struct mlx5e_priv *priv,
+			    struct mlx5e_encap_entry *e,
+			    bool neigh_connected,
+			    unsigned char ha[ETH_ALEN]);
+
+int mlx5e_rep_encap_entry_attach(struct mlx5e_priv *priv,
+				 struct mlx5e_encap_entry *e);
+void mlx5e_rep_encap_entry_detach(struct mlx5e_priv *priv,
+				  struct mlx5e_encap_entry *e);
+
+int mlx5e_rep_setup_tc(struct net_device *dev, enum tc_setup_type type,
+		       void *type_data);
+void mlx5e_rep_indr_clean_block_privs(struct mlx5e_rep_priv *rpriv);
+
+struct mlx5e_tc_update_priv;
+bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
+			     struct sk_buff *skb,
+			     struct mlx5e_tc_update_priv *tc_priv);
+void mlx5_rep_tc_post_napi_receive(struct mlx5e_tc_update_priv *tc_priv);
+
+#endif /* __MLX5_EN_REP_TC_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index 9f50a1d3c5cc..9fdd79afa6e4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -6,6 +6,7 @@
 #include <net/geneve.h>
 #include "en/tc_tun.h"
 #include "en_tc.h"
+#include "rep/tc.h"
 
 struct mlx5e_tc_tunnel *mlx5e_get_tc_tun(struct net_device *tunnel_dev)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 52351c105627..c84f0d9b516e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -45,9 +45,8 @@
 #include "en.h"
 #include "en_rep.h"
 #include "en_tc.h"
-#include "en/tc_tun.h"
+#include "en/rep/tc.h"
 #include "fs_core.h"
-#include "lib/port_tun.h"
 #include "lib/mlx5.h"
 #define CREATE_TRACE_POINTS
 #include "diag/en_rep_tracepoint.h"
@@ -58,16 +57,6 @@
 
 static const char mlx5e_rep_driver_name[] = "mlx5e_rep";
 
-struct mlx5e_rep_indr_block_priv {
-	struct net_device *netdev;
-	struct mlx5e_rep_priv *rpriv;
-
-	struct list_head list;
-};
-
-static void mlx5e_rep_indr_unregister_block(struct mlx5e_rep_priv *rpriv,
-					    struct net_device *netdev);
-
 static void mlx5e_rep_get_drvinfo(struct net_device *dev,
 				  struct ethtool_drvinfo *drvinfo)
 {
@@ -521,7 +510,7 @@ static bool mlx5e_rep_neigh_entry_hold(struct mlx5e_neigh_hash_entry *nhe)
 
 static void mlx5e_rep_neigh_entry_remove(struct mlx5e_neigh_hash_entry *nhe);
 
-static void mlx5e_rep_neigh_entry_release(struct mlx5e_neigh_hash_entry *nhe)
+void mlx5e_rep_neigh_entry_release(struct mlx5e_neigh_hash_entry *nhe)
 {
 	if (refcount_dec_and_test(&nhe->refcnt)) {
 		mlx5e_rep_neigh_entry_remove(nhe);
@@ -579,48 +568,6 @@ static void mlx5e_rep_neigh_stats_work(struct work_struct *work)
 	rtnl_unlock();
 }
 
-static void mlx5e_rep_update_flows(struct mlx5e_priv *priv,
-				   struct mlx5e_encap_entry *e,
-				   bool neigh_connected,
-				   unsigned char ha[ETH_ALEN])
-{
-	struct ethhdr *eth = (struct ethhdr *)e->encap_header;
-	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-	bool encap_connected;
-	LIST_HEAD(flow_list);
-
-	ASSERT_RTNL();
-
-	/* wait for encap to be fully initialized */
-	wait_for_completion(&e->res_ready);
-
-	mutex_lock(&esw->offloads.encap_tbl_lock);
-	encap_connected = !!(e->flags & MLX5_ENCAP_ENTRY_VALID);
-	if (e->compl_result < 0 || (encap_connected == neigh_connected &&
-				    ether_addr_equal(e->h_dest, ha)))
-		goto unlock;
-
-	mlx5e_take_all_encap_flows(e, &flow_list);
-
-	if ((e->flags & MLX5_ENCAP_ENTRY_VALID) &&
-	    (!neigh_connected || !ether_addr_equal(e->h_dest, ha)))
-		mlx5e_tc_encap_flows_del(priv, e, &flow_list);
-
-	if (neigh_connected && !(e->flags & MLX5_ENCAP_ENTRY_VALID)) {
-		ether_addr_copy(e->h_dest, ha);
-		ether_addr_copy(eth->h_dest, ha);
-		/* Update the encap source mac, in case that we delete
-		 * the flows when encap source mac changed.
-		 */
-		ether_addr_copy(eth->h_source, e->route_dev->dev_addr);
-
-		mlx5e_tc_encap_flows_add(priv, e, &flow_list);
-	}
-unlock:
-	mutex_unlock(&esw->offloads.encap_tbl_lock);
-	mlx5e_put_encap_flow_list(priv, &flow_list);
-}
-
 static void mlx5e_rep_neigh_update(struct work_struct *work)
 {
 	struct mlx5e_neigh_hash_entry *nhe =
@@ -662,254 +609,6 @@ static void mlx5e_rep_neigh_update(struct work_struct *work)
 	neigh_release(n);
 }
 
-static struct mlx5e_rep_indr_block_priv *
-mlx5e_rep_indr_block_priv_lookup(struct mlx5e_rep_priv *rpriv,
-				 struct net_device *netdev)
-{
-	struct mlx5e_rep_indr_block_priv *cb_priv;
-
-	/* All callback list access should be protected by RTNL. */
-	ASSERT_RTNL();
-
-	list_for_each_entry(cb_priv,
-			    &rpriv->uplink_priv.tc_indr_block_priv_list,
-			    list)
-		if (cb_priv->netdev == netdev)
-			return cb_priv;
-
-	return NULL;
-}
-
-static void mlx5e_rep_indr_clean_block_privs(struct mlx5e_rep_priv *rpriv)
-{
-	struct mlx5e_rep_indr_block_priv *cb_priv, *temp;
-	struct list_head *head = &rpriv->uplink_priv.tc_indr_block_priv_list;
-
-	list_for_each_entry_safe(cb_priv, temp, head, list) {
-		mlx5e_rep_indr_unregister_block(rpriv, cb_priv->netdev);
-		kfree(cb_priv);
-	}
-}
-
-static int
-mlx5e_rep_indr_offload(struct net_device *netdev,
-		       struct flow_cls_offload *flower,
-		       struct mlx5e_rep_indr_block_priv *indr_priv,
-		       unsigned long flags)
-{
-	struct mlx5e_priv *priv = netdev_priv(indr_priv->rpriv->netdev);
-	int err = 0;
-
-	switch (flower->command) {
-	case FLOW_CLS_REPLACE:
-		err = mlx5e_configure_flower(netdev, priv, flower, flags);
-		break;
-	case FLOW_CLS_DESTROY:
-		err = mlx5e_delete_flower(netdev, priv, flower, flags);
-		break;
-	case FLOW_CLS_STATS:
-		err = mlx5e_stats_flower(netdev, priv, flower, flags);
-		break;
-	default:
-		err = -EOPNOTSUPP;
-	}
-
-	return err;
-}
-
-static int mlx5e_rep_indr_setup_tc_cb(enum tc_setup_type type,
-				      void *type_data, void *indr_priv)
-{
-	unsigned long flags = MLX5_TC_FLAG(EGRESS) | MLX5_TC_FLAG(ESW_OFFLOAD);
-	struct mlx5e_rep_indr_block_priv *priv = indr_priv;
-
-	switch (type) {
-	case TC_SETUP_CLSFLOWER:
-		return mlx5e_rep_indr_offload(priv->netdev, type_data, priv,
-					      flags);
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
-static int mlx5e_rep_indr_setup_ft_cb(enum tc_setup_type type,
-				      void *type_data, void *indr_priv)
-{
-	struct mlx5e_rep_indr_block_priv *priv = indr_priv;
-	struct flow_cls_offload *f = type_data;
-	struct flow_cls_offload tmp;
-	struct mlx5e_priv *mpriv;
-	struct mlx5_eswitch *esw;
-	unsigned long flags;
-	int err;
-
-	mpriv = netdev_priv(priv->rpriv->netdev);
-	esw = mpriv->mdev->priv.eswitch;
-
-	flags = MLX5_TC_FLAG(EGRESS) |
-		MLX5_TC_FLAG(ESW_OFFLOAD) |
-		MLX5_TC_FLAG(FT_OFFLOAD);
-
-	switch (type) {
-	case TC_SETUP_CLSFLOWER:
-		memcpy(&tmp, f, sizeof(*f));
-
-		/* Re-use tc offload path by moving the ft flow to the
-		 * reserved ft chain.
-		 *
-		 * FT offload can use prio range [0, INT_MAX], so we normalize
-		 * it to range [1, mlx5_esw_chains_get_prio_range(esw)]
-		 * as with tc, where prio 0 isn't supported.
-		 *
-		 * We only support chain 0 of FT offload.
-		 */
-		if (!mlx5_esw_chains_prios_supported(esw) ||
-		    tmp.common.prio >= mlx5_esw_chains_get_prio_range(esw) ||
-		    tmp.common.chain_index)
-			return -EOPNOTSUPP;
-
-		tmp.common.chain_index = mlx5_esw_chains_get_ft_chain(esw);
-		tmp.common.prio++;
-		err = mlx5e_rep_indr_offload(priv->netdev, &tmp, priv, flags);
-		memcpy(&f->stats, &tmp.stats, sizeof(f->stats));
-		return err;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
-static void mlx5e_rep_indr_block_unbind(void *cb_priv)
-{
-	struct mlx5e_rep_indr_block_priv *indr_priv = cb_priv;
-
-	list_del(&indr_priv->list);
-	kfree(indr_priv);
-}
-
-static LIST_HEAD(mlx5e_block_cb_list);
-
-static int
-mlx5e_rep_indr_setup_block(struct net_device *netdev,
-			   struct mlx5e_rep_priv *rpriv,
-			   struct flow_block_offload *f,
-			   flow_setup_cb_t *setup_cb)
-{
-	struct mlx5e_rep_indr_block_priv *indr_priv;
-	struct flow_block_cb *block_cb;
-
-	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	f->unlocked_driver_cb = true;
-	f->driver_block_list = &mlx5e_block_cb_list;
-
-	switch (f->command) {
-	case FLOW_BLOCK_BIND:
-		indr_priv = mlx5e_rep_indr_block_priv_lookup(rpriv, netdev);
-		if (indr_priv)
-			return -EEXIST;
-
-		indr_priv = kmalloc(sizeof(*indr_priv), GFP_KERNEL);
-		if (!indr_priv)
-			return -ENOMEM;
-
-		indr_priv->netdev = netdev;
-		indr_priv->rpriv = rpriv;
-		list_add(&indr_priv->list,
-			 &rpriv->uplink_priv.tc_indr_block_priv_list);
-
-		block_cb = flow_block_cb_alloc(setup_cb, indr_priv, indr_priv,
-					       mlx5e_rep_indr_block_unbind);
-		if (IS_ERR(block_cb)) {
-			list_del(&indr_priv->list);
-			kfree(indr_priv);
-			return PTR_ERR(block_cb);
-		}
-		flow_block_cb_add(block_cb, f);
-		list_add_tail(&block_cb->driver_list, &mlx5e_block_cb_list);
-
-		return 0;
-	case FLOW_BLOCK_UNBIND:
-		indr_priv = mlx5e_rep_indr_block_priv_lookup(rpriv, netdev);
-		if (!indr_priv)
-			return -ENOENT;
-
-		block_cb = flow_block_cb_lookup(f->block, setup_cb, indr_priv);
-		if (!block_cb)
-			return -ENOENT;
-
-		flow_block_cb_remove(block_cb, f);
-		list_del(&block_cb->driver_list);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-	return 0;
-}
-
-static
-int mlx5e_rep_indr_setup_cb(struct net_device *netdev, void *cb_priv,
-			    enum tc_setup_type type, void *type_data)
-{
-	switch (type) {
-	case TC_SETUP_BLOCK:
-		return mlx5e_rep_indr_setup_block(netdev, cb_priv, type_data,
-						  mlx5e_rep_indr_setup_tc_cb);
-	case TC_SETUP_FT:
-		return mlx5e_rep_indr_setup_block(netdev, cb_priv, type_data,
-						  mlx5e_rep_indr_setup_ft_cb);
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
-static int mlx5e_rep_indr_register_block(struct mlx5e_rep_priv *rpriv,
-					 struct net_device *netdev)
-{
-	int err;
-
-	err = __flow_indr_block_cb_register(netdev, rpriv,
-					    mlx5e_rep_indr_setup_cb,
-					    rpriv);
-	if (err) {
-		struct mlx5e_priv *priv = netdev_priv(rpriv->netdev);
-
-		mlx5_core_err(priv->mdev, "Failed to register remote block notifier for %s err=%d\n",
-			      netdev_name(netdev), err);
-	}
-	return err;
-}
-
-static void mlx5e_rep_indr_unregister_block(struct mlx5e_rep_priv *rpriv,
-					    struct net_device *netdev)
-{
-	__flow_indr_block_cb_unregister(netdev, mlx5e_rep_indr_setup_cb,
-					rpriv);
-}
-
-static int mlx5e_nic_rep_netdevice_event(struct notifier_block *nb,
-					 unsigned long event, void *ptr)
-{
-	struct mlx5e_rep_priv *rpriv = container_of(nb, struct mlx5e_rep_priv,
-						     uplink_priv.netdevice_nb);
-	struct mlx5e_priv *priv = netdev_priv(rpriv->netdev);
-	struct net_device *netdev = netdev_notifier_info_to_dev(ptr);
-
-	if (!mlx5e_tc_tun_device_to_offload(priv, netdev) &&
-	    !(is_vlan_dev(netdev) && vlan_dev_real_dev(netdev) == rpriv->netdev))
-		return NOTIFY_OK;
-
-	switch (event) {
-	case NETDEV_REGISTER:
-		mlx5e_rep_indr_register_block(rpriv, netdev);
-		break;
-	case NETDEV_UNREGISTER:
-		mlx5e_rep_indr_unregister_block(rpriv, netdev);
-		break;
-	}
-	return NOTIFY_OK;
-}
-
 static void
 mlx5e_rep_queue_neigh_update_work(struct mlx5e_priv *priv,
 				  struct mlx5e_neigh_hash_entry *nhe,
@@ -932,10 +631,6 @@ mlx5e_rep_queue_neigh_update_work(struct mlx5e_priv *priv,
 	}
 }
 
-static struct mlx5e_neigh_hash_entry *
-mlx5e_rep_neigh_entry_lookup(struct mlx5e_priv *priv,
-			     struct mlx5e_neigh *m_neigh);
-
 static int mlx5e_rep_netevent_event(struct notifier_block *nb,
 				    unsigned long event, void *ptr)
 {
@@ -1091,7 +786,7 @@ static void mlx5e_rep_neigh_entry_remove(struct mlx5e_neigh_hash_entry *nhe)
 /* This function must only be called under the representor's encap_lock or
  * inside rcu read lock section.
  */
-static struct mlx5e_neigh_hash_entry *
+struct mlx5e_neigh_hash_entry *
 mlx5e_rep_neigh_entry_lookup(struct mlx5e_priv *priv,
 			     struct mlx5e_neigh *m_neigh)
 {
@@ -1104,9 +799,9 @@ mlx5e_rep_neigh_entry_lookup(struct mlx5e_priv *priv,
 	return nhe && mlx5e_rep_neigh_entry_hold(nhe) ? nhe : NULL;
 }
 
-static int mlx5e_rep_neigh_entry_create(struct mlx5e_priv *priv,
-					struct mlx5e_encap_entry *e,
-					struct mlx5e_neigh_hash_entry **nhe)
+int mlx5e_rep_neigh_entry_create(struct mlx5e_priv *priv,
+				 struct mlx5e_encap_entry *e,
+				 struct mlx5e_neigh_hash_entry **nhe)
 {
 	int err;
 
@@ -1131,60 +826,6 @@ static int mlx5e_rep_neigh_entry_create(struct mlx5e_priv *priv,
 	return err;
 }
 
-int mlx5e_rep_encap_entry_attach(struct mlx5e_priv *priv,
-				 struct mlx5e_encap_entry *e)
-{
-	struct mlx5e_rep_priv *rpriv = priv->ppriv;
-	struct mlx5_rep_uplink_priv *uplink_priv = &rpriv->uplink_priv;
-	struct mlx5_tun_entropy *tun_entropy = &uplink_priv->tun_entropy;
-	struct mlx5e_neigh_hash_entry *nhe;
-	int err;
-
-	err = mlx5_tun_entropy_refcount_inc(tun_entropy, e->reformat_type);
-	if (err)
-		return err;
-
-	mutex_lock(&rpriv->neigh_update.encap_lock);
-	nhe = mlx5e_rep_neigh_entry_lookup(priv, &e->m_neigh);
-	if (!nhe) {
-		err = mlx5e_rep_neigh_entry_create(priv, e, &nhe);
-		if (err) {
-			mutex_unlock(&rpriv->neigh_update.encap_lock);
-			mlx5_tun_entropy_refcount_dec(tun_entropy,
-						      e->reformat_type);
-			return err;
-		}
-	}
-
-	e->nhe = nhe;
-	spin_lock(&nhe->encap_list_lock);
-	list_add_rcu(&e->encap_list, &nhe->encap_list);
-	spin_unlock(&nhe->encap_list_lock);
-
-	mutex_unlock(&rpriv->neigh_update.encap_lock);
-
-	return 0;
-}
-
-void mlx5e_rep_encap_entry_detach(struct mlx5e_priv *priv,
-				  struct mlx5e_encap_entry *e)
-{
-	struct mlx5e_rep_priv *rpriv = priv->ppriv;
-	struct mlx5_rep_uplink_priv *uplink_priv = &rpriv->uplink_priv;
-	struct mlx5_tun_entropy *tun_entropy = &uplink_priv->tun_entropy;
-
-	if (!e->nhe)
-		return;
-
-	spin_lock(&e->nhe->encap_list_lock);
-	list_del_rcu(&e->encap_list);
-	spin_unlock(&e->nhe->encap_list_lock);
-
-	mlx5e_rep_neigh_entry_release(e->nhe);
-	e->nhe = NULL;
-	mlx5_tun_entropy_refcount_dec(tun_entropy, e->reformat_type);
-}
-
 static int mlx5e_rep_open(struct net_device *dev)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
@@ -1225,129 +866,6 @@ static int mlx5e_rep_close(struct net_device *dev)
 	return ret;
 }
 
-static int
-mlx5e_rep_setup_tc_cls_flower(struct mlx5e_priv *priv,
-			      struct flow_cls_offload *cls_flower, int flags)
-{
-	switch (cls_flower->command) {
-	case FLOW_CLS_REPLACE:
-		return mlx5e_configure_flower(priv->netdev, priv, cls_flower,
-					      flags);
-	case FLOW_CLS_DESTROY:
-		return mlx5e_delete_flower(priv->netdev, priv, cls_flower,
-					   flags);
-	case FLOW_CLS_STATS:
-		return mlx5e_stats_flower(priv->netdev, priv, cls_flower,
-					  flags);
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
-static
-int mlx5e_rep_setup_tc_cls_matchall(struct mlx5e_priv *priv,
-				    struct tc_cls_matchall_offload *ma)
-{
-	switch (ma->command) {
-	case TC_CLSMATCHALL_REPLACE:
-		return mlx5e_tc_configure_matchall(priv, ma);
-	case TC_CLSMATCHALL_DESTROY:
-		return mlx5e_tc_delete_matchall(priv, ma);
-	case TC_CLSMATCHALL_STATS:
-		mlx5e_tc_stats_matchall(priv, ma);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
-static int mlx5e_rep_setup_tc_cb(enum tc_setup_type type, void *type_data,
-				 void *cb_priv)
-{
-	unsigned long flags = MLX5_TC_FLAG(INGRESS) | MLX5_TC_FLAG(ESW_OFFLOAD);
-	struct mlx5e_priv *priv = cb_priv;
-
-	switch (type) {
-	case TC_SETUP_CLSFLOWER:
-		return mlx5e_rep_setup_tc_cls_flower(priv, type_data, flags);
-	case TC_SETUP_CLSMATCHALL:
-		return mlx5e_rep_setup_tc_cls_matchall(priv, type_data);
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
-static int mlx5e_rep_setup_ft_cb(enum tc_setup_type type, void *type_data,
-				 void *cb_priv)
-{
-	struct flow_cls_offload tmp, *f = type_data;
-	struct mlx5e_priv *priv = cb_priv;
-	struct mlx5_eswitch *esw;
-	unsigned long flags;
-	int err;
-
-	flags = MLX5_TC_FLAG(INGRESS) |
-		MLX5_TC_FLAG(ESW_OFFLOAD) |
-		MLX5_TC_FLAG(FT_OFFLOAD);
-	esw = priv->mdev->priv.eswitch;
-
-	switch (type) {
-	case TC_SETUP_CLSFLOWER:
-		memcpy(&tmp, f, sizeof(*f));
-
-		if (!mlx5_esw_chains_prios_supported(esw))
-			return -EOPNOTSUPP;
-
-		/* Re-use tc offload path by moving the ft flow to the
-		 * reserved ft chain.
-		 *
-		 * FT offload can use prio range [0, INT_MAX], so we normalize
-		 * it to range [1, mlx5_esw_chains_get_prio_range(esw)]
-		 * as with tc, where prio 0 isn't supported.
-		 *
-		 * We only support chain 0 of FT offload.
-		 */
-		if (tmp.common.prio >= mlx5_esw_chains_get_prio_range(esw))
-			return -EOPNOTSUPP;
-		if (tmp.common.chain_index != 0)
-			return -EOPNOTSUPP;
-
-		tmp.common.chain_index = mlx5_esw_chains_get_ft_chain(esw);
-		tmp.common.prio++;
-		err = mlx5e_rep_setup_tc_cls_flower(priv, &tmp, flags);
-		memcpy(&f->stats, &tmp.stats, sizeof(f->stats));
-		return err;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
-static LIST_HEAD(mlx5e_rep_block_tc_cb_list);
-static LIST_HEAD(mlx5e_rep_block_ft_cb_list);
-static int mlx5e_rep_setup_tc(struct net_device *dev, enum tc_setup_type type,
-			      void *type_data)
-{
-	struct mlx5e_priv *priv = netdev_priv(dev);
-	struct flow_block_offload *f = type_data;
-
-	f->unlocked_driver_cb = true;
-
-	switch (type) {
-	case TC_SETUP_BLOCK:
-		return flow_block_cb_setup_simple(type_data,
-						  &mlx5e_rep_block_tc_cb_list,
-						  mlx5e_rep_setup_tc_cb,
-						  priv, priv, true);
-	case TC_SETUP_FT:
-		return flow_block_cb_setup_simple(type_data,
-						  &mlx5e_rep_block_ft_cb_list,
-						  mlx5e_rep_setup_ft_cb,
-						  priv, priv, true);
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 bool mlx5e_is_uplink_rep(struct mlx5e_priv *priv)
 {
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
@@ -1791,31 +1309,23 @@ static int mlx5e_init_uplink_rep_tx(struct mlx5e_rep_priv *rpriv)
 	priv = netdev_priv(netdev);
 	uplink_priv = &rpriv->uplink_priv;
 
-	mutex_init(&uplink_priv->unready_flows_lock);
-	INIT_LIST_HEAD(&uplink_priv->unready_flows);
-
-	/* init shared tc flow table */
-	err = mlx5e_tc_esw_init(&uplink_priv->tc_ht);
+	err = mlx5e_rep_tc_init(rpriv);
 	if (err)
 		return err;
 
 	mlx5_init_port_tun_entropy(&uplink_priv->tun_entropy, priv->mdev);
 
-	/* init indirect block notifications */
-	INIT_LIST_HEAD(&uplink_priv->tc_indr_block_priv_list);
-	uplink_priv->netdevice_nb.notifier_call = mlx5e_nic_rep_netdevice_event;
-	err = register_netdevice_notifier_dev_net(rpriv->netdev,
-						  &uplink_priv->netdevice_nb,
-						  &uplink_priv->netdevice_nn);
+	err = mlx5e_rep_tc_netdevice_event_register(rpriv);
 	if (err) {
-		mlx5_core_err(priv->mdev, "Failed to register netdev notifier\n");
-		goto tc_esw_cleanup;
+		mlx5_core_err(priv->mdev, "Failed to register netdev notifier, err: %d\n",
+			      err);
+		goto tc_rep_cleanup;
 	}
 
 	return 0;
 
-tc_esw_cleanup:
-	mlx5e_tc_esw_cleanup(&uplink_priv->tc_ht);
+tc_rep_cleanup:
+	mlx5e_rep_tc_cleanup(rpriv);
 	return err;
 }
 
@@ -1845,17 +1355,10 @@ static int mlx5e_init_rep_tx(struct mlx5e_priv *priv)
 
 static void mlx5e_cleanup_uplink_rep_tx(struct mlx5e_rep_priv *rpriv)
 {
-	struct mlx5_rep_uplink_priv *uplink_priv = &rpriv->uplink_priv;
-
-	/* clean indirect TC block notifications */
-	unregister_netdevice_notifier_dev_net(rpriv->netdev,
-					      &uplink_priv->netdevice_nb,
-					      &uplink_priv->netdevice_nn);
+	mlx5e_rep_tc_netdevice_event_unregister(rpriv);
 	mlx5e_rep_indr_clean_block_privs(rpriv);
 
-	/* delete shared tc flow table */
-	mlx5e_tc_esw_cleanup(&rpriv->uplink_priv.tc_ht);
-	mutex_destroy(&rpriv->uplink_priv.unready_flows_lock);
+	mlx5e_rep_tc_cleanup(rpriv);
 }
 
 static void mlx5e_cleanup_rep_tx(struct mlx5e_priv *priv)
@@ -1897,13 +1400,8 @@ static int uplink_rep_async_event(struct notifier_block *nb, unsigned long event
 		return NOTIFY_OK;
 	}
 
-	if (event == MLX5_DEV_EVENT_PORT_AFFINITY) {
-		struct mlx5e_rep_priv *rpriv = priv->ppriv;
-
-		queue_work(priv->wq, &rpriv->uplink_priv.reoffload_flows_work);
-
-		return NOTIFY_OK;
-	}
+	if (event == MLX5_DEV_EVENT_PORT_AFFINITY)
+		return mlx5e_rep_tc_event_port_affinity(priv);
 
 	return NOTIFY_DONE;
 }
@@ -1912,7 +1410,6 @@ static void mlx5e_uplink_rep_enable(struct mlx5e_priv *priv)
 {
 	struct net_device *netdev = priv->netdev;
 	struct mlx5_core_dev *mdev = priv->mdev;
-	struct mlx5e_rep_priv *rpriv = priv->ppriv;
 	u16 max_mtu;
 
 	netdev->min_mtu = ETH_MIN_MTU;
@@ -1920,8 +1417,7 @@ static void mlx5e_uplink_rep_enable(struct mlx5e_priv *priv)
 	netdev->max_mtu = MLX5E_HW2SW_MTU(&priv->channels.params, max_mtu);
 	mlx5e_set_dev_port_mtu(priv);
 
-	INIT_WORK(&rpriv->uplink_priv.reoffload_flows_work,
-		  mlx5e_tc_reoffload_flows_work);
+	mlx5e_rep_tc_enable(priv);
 
 	mlx5_lag_add(mdev, netdev);
 	priv->events_nb.notifier_call = uplink_rep_async_event;
@@ -1933,11 +1429,10 @@ static void mlx5e_uplink_rep_enable(struct mlx5e_priv *priv)
 static void mlx5e_uplink_rep_disable(struct mlx5e_priv *priv)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
-	struct mlx5e_rep_priv *rpriv = priv->ppriv;
 
 	mlx5e_dcbnl_delete_app(priv);
 	mlx5_notifier_unregister(mdev, &priv->events_nb);
-	cancel_work_sync(&rpriv->uplink_priv.reoffload_flows_work);
+	mlx5e_rep_tc_disable(priv);
 	mlx5_lag_remove(mdev);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 6a2337900420..74d46e9a201a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -203,16 +203,19 @@ void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
 void mlx5e_handle_rx_cqe_mpwrq_rep(struct mlx5e_rq *rq,
 				   struct mlx5_cqe64 *cqe);
 
-int mlx5e_rep_encap_entry_attach(struct mlx5e_priv *priv,
-				 struct mlx5e_encap_entry *e);
-void mlx5e_rep_encap_entry_detach(struct mlx5e_priv *priv,
-				  struct mlx5e_encap_entry *e);
-
 void mlx5e_rep_queue_neigh_stats_work(struct mlx5e_priv *priv);
 
 bool mlx5e_eswitch_rep(struct net_device *netdev);
 bool mlx5e_eswitch_uplink_rep(struct net_device *netdev);
 
+struct mlx5e_neigh_hash_entry *
+mlx5e_rep_neigh_entry_lookup(struct mlx5e_priv *priv,
+			     struct mlx5e_neigh *m_neigh);
+int mlx5e_rep_neigh_entry_create(struct mlx5e_priv *priv,
+				 struct mlx5e_encap_entry *e,
+				 struct mlx5e_neigh_hash_entry **nhe);
+void mlx5e_rep_neigh_entry_release(struct mlx5e_neigh_hash_entry *nhe);
+
 #else /* CONFIG_MLX5_ESWITCH */
 static inline bool mlx5e_is_uplink_rep(struct mlx5e_priv *priv) { return false; }
 static inline int mlx5e_add_sqs_fwd_rules(struct mlx5e_priv *priv) { return 0; }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index a514685fb560..1b60aeebab48 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -42,6 +42,7 @@
 #include "en_tc.h"
 #include "eswitch.h"
 #include "en_rep.h"
+#include "en/rep/tc.h"
 #include "ipoib/ipoib.h"
 #include "en_accel/ipsec_rxtx.h"
 #include "en_accel/tls_rxtx.h"
@@ -1216,12 +1217,12 @@ void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	if (rep->vlan && skb_vlan_tag_present(skb))
 		skb_vlan_pop(skb);
 
-	if (!mlx5e_tc_rep_update_skb(cqe, skb, &tc_priv))
+	if (!mlx5e_rep_tc_update_skb(cqe, skb, &tc_priv))
 		goto free_wqe;
 
 	napi_gro_receive(rq->cq.napi, skb);
 
-	mlx5_tc_rep_post_napi_receive(&tc_priv);
+	mlx5_rep_tc_post_napi_receive(&tc_priv);
 
 free_wqe:
 	mlx5e_free_rx_wqe(rq, wi, true);
@@ -1272,12 +1273,12 @@ void mlx5e_handle_rx_cqe_mpwrq_rep(struct mlx5e_rq *rq,
 
 	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
 
-	if (!mlx5e_tc_rep_update_skb(cqe, skb, &tc_priv))
+	if (!mlx5e_rep_tc_update_skb(cqe, skb, &tc_priv))
 		goto mpwrq_cqe_out;
 
 	napi_gro_receive(rq->cq.napi, skb);
 
-	mlx5_tc_rep_post_napi_receive(&tc_priv);
+	mlx5_rep_tc_post_napi_receive(&tc_priv);
 
 mpwrq_cqe_out:
 	if (likely(wi->consumed_strides < rq->mpwqe.num_strides))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index a050808f2128..251975ccbdf7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -49,6 +49,7 @@
 #include <net/ipv6_stubs.h>
 #include "en.h"
 #include "en_rep.h"
+#include "en/rep/tc.h"
 #include "en_tc.h"
 #include "eswitch.h"
 #include "esw/chains.h"
@@ -158,35 +159,6 @@ struct mlx5e_tc_flow_parse_attr {
 #define MLX5E_TC_TABLE_NUM_GROUPS 4
 #define MLX5E_TC_TABLE_MAX_GROUP_SIZE BIT(16)
 
-struct tunnel_match_key {
-	struct flow_dissector_key_control enc_control;
-	struct flow_dissector_key_keyid enc_key_id;
-	struct flow_dissector_key_ports enc_tp;
-	struct flow_dissector_key_ip enc_ip;
-	union {
-		struct flow_dissector_key_ipv4_addrs enc_ipv4;
-		struct flow_dissector_key_ipv6_addrs enc_ipv6;
-	};
-
-	int filter_ifindex;
-};
-
-struct tunnel_match_enc_opts {
-	struct flow_dissector_key_enc_opts key;
-	struct flow_dissector_key_enc_opts mask;
-};
-
-/* Tunnel_id mapping is TUNNEL_INFO_BITS + ENC_OPTS_BITS.
- * Upper TUNNEL_INFO_BITS for general tunnel info.
- * Lower ENC_OPTS_BITS bits for enc_opts.
- */
-#define TUNNEL_INFO_BITS 6
-#define TUNNEL_INFO_BITS_MASK GENMASK(TUNNEL_INFO_BITS - 1, 0)
-#define ENC_OPTS_BITS 2
-#define ENC_OPTS_BITS_MASK GENMASK(ENC_OPTS_BITS - 1, 0)
-#define TUNNEL_ID_BITS (TUNNEL_INFO_BITS + ENC_OPTS_BITS)
-#define TUNNEL_ID_MASK GENMASK(TUNNEL_ID_BITS - 1, 0)
-
 struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[] = {
 	[CHAIN_TO_REG] = {
 		.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_C_0,
@@ -4806,146 +4778,6 @@ void mlx5e_tc_reoffload_flows_work(struct work_struct *work)
 	mutex_unlock(&rpriv->unready_flows_lock);
 }
 
-#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
-static bool mlx5e_restore_tunnel(struct mlx5e_priv *priv, struct sk_buff *skb,
-				 struct mlx5e_tc_update_priv *tc_priv,
-				 u32 tunnel_id)
-{
-	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-	struct tunnel_match_enc_opts enc_opts = {};
-	struct mlx5_rep_uplink_priv *uplink_priv;
-	struct mlx5e_rep_priv *uplink_rpriv;
-	struct metadata_dst *tun_dst;
-	struct tunnel_match_key key;
-	u32 tun_id, enc_opts_id;
-	struct net_device *dev;
-	int err;
-
-	enc_opts_id = tunnel_id & ENC_OPTS_BITS_MASK;
-	tun_id = tunnel_id >> ENC_OPTS_BITS;
-
-	if (!tun_id)
-		return true;
-
-	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
-	uplink_priv = &uplink_rpriv->uplink_priv;
-
-	err = mapping_find(uplink_priv->tunnel_mapping, tun_id, &key);
-	if (err) {
-		WARN_ON_ONCE(true);
-		netdev_dbg(priv->netdev,
-			   "Couldn't find tunnel for tun_id: %d, err: %d\n",
-			   tun_id, err);
-		return false;
-	}
-
-	if (enc_opts_id) {
-		err = mapping_find(uplink_priv->tunnel_enc_opts_mapping,
-				   enc_opts_id, &enc_opts);
-		if (err) {
-			netdev_dbg(priv->netdev,
-				   "Couldn't find tunnel (opts) for tun_id: %d, err: %d\n",
-				   enc_opts_id, err);
-			return false;
-		}
-	}
-
-	tun_dst = tun_rx_dst(enc_opts.key.len);
-	if (!tun_dst) {
-		WARN_ON_ONCE(true);
-		return false;
-	}
-
-	ip_tunnel_key_init(&tun_dst->u.tun_info.key,
-			   key.enc_ipv4.src, key.enc_ipv4.dst,
-			   key.enc_ip.tos, key.enc_ip.ttl,
-			   0, /* label */
-			   key.enc_tp.src, key.enc_tp.dst,
-			   key32_to_tunnel_id(key.enc_key_id.keyid),
-			   TUNNEL_KEY);
-
-	if (enc_opts.key.len)
-		ip_tunnel_info_opts_set(&tun_dst->u.tun_info,
-					enc_opts.key.data,
-					enc_opts.key.len,
-					enc_opts.key.dst_opt_type);
-
-	skb_dst_set(skb, (struct dst_entry *)tun_dst);
-	dev = dev_get_by_index(&init_net, key.filter_ifindex);
-	if (!dev) {
-		netdev_dbg(priv->netdev,
-			   "Couldn't find tunnel device with ifindex: %d\n",
-			   key.filter_ifindex);
-		return false;
-	}
-
-	/* Set tun_dev so we do dev_put() after datapath */
-	tc_priv->tun_dev = dev;
-
-	skb->dev = dev;
-
-	return true;
-}
-#endif /* CONFIG_NET_TC_SKB_EXT */
-
-bool mlx5e_tc_rep_update_skb(struct mlx5_cqe64 *cqe,
-			     struct sk_buff *skb,
-			     struct mlx5e_tc_update_priv *tc_priv)
-{
-#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
-	u32 chain = 0, reg_c0, reg_c1, tunnel_id, tuple_id;
-	struct mlx5_rep_uplink_priv *uplink_priv;
-	struct mlx5e_rep_priv *uplink_rpriv;
-	struct tc_skb_ext *tc_skb_ext;
-	struct mlx5_eswitch *esw;
-	struct mlx5e_priv *priv;
-	int tunnel_moffset;
-	int err;
-
-	reg_c0 = (be32_to_cpu(cqe->sop_drop_qpn) & MLX5E_TC_FLOW_ID_MASK);
-	if (reg_c0 == MLX5_FS_DEFAULT_FLOW_TAG)
-		reg_c0 = 0;
-	reg_c1 = be32_to_cpu(cqe->ft_metadata);
-
-	if (!reg_c0)
-		return true;
-
-	priv = netdev_priv(skb->dev);
-	esw = priv->mdev->priv.eswitch;
-
-	err = mlx5_eswitch_get_chain_for_tag(esw, reg_c0, &chain);
-	if (err) {
-		netdev_dbg(priv->netdev,
-			   "Couldn't find chain for chain tag: %d, err: %d\n",
-			   reg_c0, err);
-		return false;
-	}
-
-	if (chain) {
-		tc_skb_ext = skb_ext_add(skb, TC_SKB_EXT);
-		if (!tc_skb_ext) {
-			WARN_ON(1);
-			return false;
-		}
-
-		tc_skb_ext->chain = chain;
-
-		tuple_id = reg_c1 & TUPLE_ID_MAX;
-
-		uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
-		uplink_priv = &uplink_rpriv->uplink_priv;
-		if (!mlx5e_tc_ct_restore_flow(uplink_priv, skb, tuple_id))
-			return false;
-	}
-
-	tunnel_moffset = mlx5e_tc_attr_to_reg_mappings[TUNNEL_TO_REG].moffset;
-	tunnel_id = reg_c1 >> (8 * tunnel_moffset);
-	return mlx5e_restore_tunnel(priv, skb, tc_priv, tunnel_id);
-#endif /* CONFIG_NET_TC_SKB_EXT */
-
-	return true;
-}
-
 void mlx5_tc_rep_post_napi_receive(struct mlx5e_tc_update_priv *tc_priv)
 {
 	if (tc_priv->tun_dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index abdcfa4c4e0e..1d8d85b842fe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -34,11 +34,41 @@
 #define __MLX5_EN_TC_H__
 
 #include <net/pkt_cls.h>
+#include "en.h"
 
 #define MLX5E_TC_FLOW_ID_MASK 0x0000ffff
 
 #ifdef CONFIG_MLX5_ESWITCH
 
+struct tunnel_match_key {
+	struct flow_dissector_key_control enc_control;
+	struct flow_dissector_key_keyid enc_key_id;
+	struct flow_dissector_key_ports enc_tp;
+	struct flow_dissector_key_ip enc_ip;
+	union {
+		struct flow_dissector_key_ipv4_addrs enc_ipv4;
+		struct flow_dissector_key_ipv6_addrs enc_ipv6;
+	};
+
+	int filter_ifindex;
+};
+
+struct tunnel_match_enc_opts {
+	struct flow_dissector_key_enc_opts key;
+	struct flow_dissector_key_enc_opts mask;
+};
+
+/* Tunnel_id mapping is TUNNEL_INFO_BITS + ENC_OPTS_BITS.
+ * Upper TUNNEL_INFO_BITS for general tunnel info.
+ * Lower ENC_OPTS_BITS bits for enc_opts.
+ */
+#define TUNNEL_INFO_BITS 6
+#define TUNNEL_INFO_BITS_MASK GENMASK(TUNNEL_INFO_BITS - 1, 0)
+#define ENC_OPTS_BITS 2
+#define ENC_OPTS_BITS_MASK GENMASK(ENC_OPTS_BITS - 1, 0)
+#define TUNNEL_ID_BITS (TUNNEL_INFO_BITS + ENC_OPTS_BITS)
+#define TUNNEL_ID_MASK GENMASK(TUNNEL_ID_BITS - 1, 0)
+
 enum {
 	MLX5E_TC_FLAG_INGRESS_BIT,
 	MLX5E_TC_FLAG_EGRESS_BIT,
@@ -119,11 +149,6 @@ struct mlx5e_tc_update_priv {
 	struct net_device *tun_dev;
 };
 
-bool mlx5e_tc_rep_update_skb(struct mlx5_cqe64 *cqe, struct sk_buff *skb,
-			     struct mlx5e_tc_update_priv *tc_priv);
-
-void mlx5_tc_rep_post_napi_receive(struct mlx5e_tc_update_priv *tc_priv);
-
 struct mlx5e_tc_mod_hdr_acts {
 	int num_actions;
 	int max_actions;
-- 
2.25.4

