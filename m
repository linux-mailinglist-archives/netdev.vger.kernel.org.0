Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E287E1E52C6
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 03:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725960AbgE1BRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 21:17:40 -0400
Received: from mail-am6eur05on2065.outbound.protection.outlook.com ([40.107.22.65]:34369
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725747AbgE1BRj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 21:17:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kEywIrrtx4J4StngRk6VqyxmeRN5KFjU6LcEPdNs2RnC+e/CZqWk6MPylypXgus7PC1KWZaZjVDBgV0spprYr5pBykOPPMi8Qpc53K+dGwT4z+auY7V2ms+bDKtLiiW8bMB20mNkrpNqXjJV3Z9+yDeJpBB4u/s2asYyAlOzBOZmpt+lsrQu18Z/fT65tpcY2UItn3m+dQ38McHQxpaNk/Yb83lmlfILeuCD6V56hnK52ute2ztArhF9ww30DMCici9AejRmCxT2DDq+lh4MQAMg+3BsEzCq1396flyDOM9tlxS6/7hdwL+TdA5kFYFXu7TdY2SBjAaSdOavqn8PtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8+KSfIsOBvRyrpu1Le3ue7jNW9TWx3rcxMSl78b0PNI=;
 b=oOCbTevhAamwZZly2c+XDTtnrRAXAWtiKWDBZfRVZr3Cw/+YOMPPuBigzoVEEQ9CVd+X3tf5MilIF0Oxqr146WSBVqdx2jvjXrimfxtuqBhlJHyO3nRnM+j+uvQjvu2gsUBJmT2ciV3pU5FB2pCJ/nxUjz0DyN9++Vg8BTC1TmkbcExBueHGyW1eflBaGbkBPhiXhtqTwbhuPw9vTJwuMM9gl+JStv+idm1o4zoMqx9mdhHurOkUEx9Rs5ZXIxxMqFdjt70c7w98zP1TFuUCV5HslX3Fiw69wloxxSvACmUJOx8W8a7W6BdfVezKESzbt1AAmqUhKI1AgyfCy4v1Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8+KSfIsOBvRyrpu1Le3ue7jNW9TWx3rcxMSl78b0PNI=;
 b=Lg5kKy/JDlSFcbJcO4aleb6p/AU9i3e6yw0mx4GfrYKTGp+YNJBddrDfYCEFiGRDWcC+YN3Y/knpkmkWC2dEZkcAS44/StwZ84CtUZGupRc8N8cX+7GWIS0ImskLC9S5y4XsdrnVAbJSWvU3KUHnEibgmx/i811Q3Rnj334W3so=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4368.eurprd05.prod.outlook.com (2603:10a6:803:44::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Thu, 28 May
 2020 01:17:27 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Thu, 28 May 2020
 01:17:27 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Vu Pham <vuhuong@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V3 01/15] net/mlx5: E-Switch, Refactor eswitch egress acl codes
Date:   Wed, 27 May 2020 18:16:42 -0700
Message-Id: <20200528011656.559914-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528011656.559914-1-saeedm@mellanox.com>
References: <20200528011656.559914-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::11) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0001.namprd04.prod.outlook.com (2603:10b6:a03:1d0::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Thu, 28 May 2020 01:17:25 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ca65be87-8b93-442b-434a-08d802a4e258
X-MS-TrafficTypeDiagnostic: VI1PR05MB4368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB43684682CA94ECCC15E81F1BBE8E0@VI1PR05MB4368.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NYQgpGjj335Ti+LI9EcCtzgWbfdZmMgQPtPe7MjK+aNXLMU6Hz2h+ty15MCPlXBJezt1J7K0XEAqgm775hPffO1oPZdsb9yVYvZDIruuj3teAZJ2nfX6JQTRyXKRepQyhlccPXdklGNgSLu4HJfg0v1KWNYKCJClRaJ9ufJGc2EuYgFiXHJzvCiOhFMvYUZSCovietMAsEYKQ7L+7GyFZjXf82iZuFTIU2aaplDU6XWmoWP87ft21tsaf9GAooX+B7HH0acZ86V1jXCebMfR1ab+mYCjkXZcaLjq1RU+ssb7c+hbShuIISDtMxjPob5pGnKzgJpxnUKngB4yWDMjXYHs/2DmSvObny9CTvp1NBo3z0Q/geNRnlQOx+Hj0aGW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(346002)(136003)(396003)(39860400002)(26005)(54906003)(52116002)(66946007)(66476007)(86362001)(316002)(83380400001)(66556008)(5660300002)(6506007)(956004)(2616005)(1076003)(30864003)(6666004)(16526019)(36756003)(8676002)(6486002)(478600001)(8936002)(2906002)(4326008)(107886003)(186003)(6512007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: z+sM48THDtPYI7yCELwH6mKc53xTKllP91bMzW3np8qfCduguICgAJ3yEgHZpNUk+8WzPMAN2ZqULN+u5r7zV9CinCdTHHf7JJhuJpm9ezaKp7CIps1Pjtr8XzMlJhPIv/Q7n+PsWJDoyjUvdZRvxtNsjnE/HsgIlHqtcq3CfWCbgMusKgPWpyJdrgbfAXhim/kmlOzeH3kM/GhvmSq5c/cLD0asjWyezL1BELmixCl2ALFfcoHJas0zygxoKZFq6IXkWKvWoSKq86VRz48Aae1SknQhprNxoNMoVE6bbi0WdDnUmTxMFZ8ajTfwK7HjMZl84mxr8ds8VsLp0QtPrwo+lHGykTpGxbMj9KiRHcOQkUKMqNw+De7A6bcfHM9x2AEGI0pqusUd2G4a/iWf05lT9f+sPIH+E2gIKRKDu9GbZNgRA1wU3dOmNDNAPqyXOmiI4jFMl3BUIgL/LUoqM06T0gFUXRG8ce46XmwD2Mk=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca65be87-8b93-442b-434a-08d802a4e258
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 01:17:27.2020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2/mboPClcnmOIwqNKOcyRAnOuBzQ3SMUUiHD9b9qkS4Kw9fS9vNUAIp7rv/KF6m1cwqfLtoMrQm5rJhgTeqfDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4368
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vu Pham <vuhuong@mellanox.com>

Refactor the egress acl codes so that offloads and legacy modes
can configure specifically their own needs of egress acl table,
groups and rules. While at it, restructure the eswitch egress
acl codes into eswitch directory and different files:
. Acl egress helper functions to acl_helper.c/h
. Acl egress functions used in offloads mode to acl_egress_ofld.c
. Acl egress functions used in legacy mode to acl_egress_lgy.c

This patch does not change any functionality.

Signed-off-by: Vu Pham <vuhuong@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   3 +
 .../mellanox/mlx5/core/esw/acl/egress_lgcy.c  | 170 +++++++++++++
 .../mellanox/mlx5/core/esw/acl/egress_ofld.c  |  88 +++++++
 .../mellanox/mlx5/core/esw/acl/helper.c       | 142 +++++++++++
 .../mellanox/mlx5/core/esw/acl/helper.h       |  22 ++
 .../mellanox/mlx5/core/esw/acl/lgcy.h         |  13 +
 .../mellanox/mlx5/core/esw/acl/ofld.h         |  13 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 235 +-----------------
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  15 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     |  36 +--
 10 files changed, 462 insertions(+), 275 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/lgcy.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index e5ee9103fefb..ad046b2ea4f9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -46,6 +46,9 @@ mlx5_core-$(CONFIG_MLX5_TC_CT)	     += en/tc_ct.o
 #
 mlx5_core-$(CONFIG_MLX5_ESWITCH)   += eswitch.o eswitch_offloads.o eswitch_offloads_termtbl.o \
 				      ecpf.o rdma.o
+mlx5_core-$(CONFIG_MLX5_ESWITCH)   += esw/acl/helper.o \
+				      esw/acl/egress_lgcy.o esw/acl/egress_ofld.o
+
 mlx5_core-$(CONFIG_MLX5_MPFS)      += lib/mpfs.o
 mlx5_core-$(CONFIG_VXLAN)          += lib/vxlan.o
 mlx5_core-$(CONFIG_PTP_1588_CLOCK) += lib/clock.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
new file mode 100644
index 000000000000..d46f8b225ebe
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
@@ -0,0 +1,170 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2020 Mellanox Technologies Inc. All rights reserved. */
+
+#include "mlx5_core.h"
+#include "eswitch.h"
+#include "helper.h"
+#include "lgcy.h"
+
+static void esw_acl_egress_lgcy_rules_destroy(struct mlx5_vport *vport)
+{
+	esw_acl_egress_vlan_destroy(vport);
+	if (!IS_ERR_OR_NULL(vport->egress.legacy.drop_rule)) {
+		mlx5_del_flow_rules(vport->egress.legacy.drop_rule);
+		vport->egress.legacy.drop_rule = NULL;
+	}
+}
+
+static int esw_acl_egress_lgcy_groups_create(struct mlx5_eswitch *esw,
+					     struct mlx5_vport *vport)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	struct mlx5_core_dev *dev = esw->dev;
+	struct mlx5_flow_group *drop_grp;
+	u32 *flow_group_in;
+	int err = 0;
+
+	err = esw_acl_egress_vlan_grp_create(esw, vport);
+	if (err)
+		return err;
+
+	flow_group_in = kvzalloc(inlen, GFP_KERNEL);
+	if (!flow_group_in) {
+		err = -ENOMEM;
+		goto alloc_err;
+	}
+
+	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 1);
+	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 1);
+	drop_grp = mlx5_create_flow_group(vport->egress.acl, flow_group_in);
+	if (IS_ERR(drop_grp)) {
+		err = PTR_ERR(drop_grp);
+		esw_warn(dev, "Failed to create E-Switch vport[%d] egress drop flow group, err(%d)\n",
+			 vport->vport, err);
+		goto drop_grp_err;
+	}
+
+	vport->egress.legacy.drop_grp = drop_grp;
+	kvfree(flow_group_in);
+	return 0;
+
+drop_grp_err:
+	kvfree(flow_group_in);
+alloc_err:
+	esw_acl_egress_vlan_grp_destroy(vport);
+	return err;
+}
+
+static void esw_acl_egress_lgcy_groups_destroy(struct mlx5_vport *vport)
+{
+	if (!IS_ERR_OR_NULL(vport->egress.legacy.drop_grp)) {
+		mlx5_destroy_flow_group(vport->egress.legacy.drop_grp);
+		vport->egress.legacy.drop_grp = NULL;
+	}
+	esw_acl_egress_vlan_grp_destroy(vport);
+}
+
+int esw_acl_egress_lgcy_setup(struct mlx5_eswitch *esw,
+			      struct mlx5_vport *vport)
+{
+	struct mlx5_flow_destination drop_ctr_dst = {};
+	struct mlx5_flow_destination *dst = NULL;
+	struct mlx5_fc *drop_counter = NULL;
+	struct mlx5_flow_act flow_act = {};
+	/* The egress acl table contains 2 rules:
+	 * 1)Allow traffic with vlan_tag=vst_vlan_id
+	 * 2)Drop all other traffic.
+	 */
+	int table_size = 2;
+	int dest_num = 0;
+	int err = 0;
+
+	if (MLX5_CAP_ESW_EGRESS_ACL(esw->dev, flow_counter)) {
+		drop_counter = mlx5_fc_create(esw->dev, false);
+		if (IS_ERR(drop_counter))
+			esw_warn(esw->dev,
+				 "vport[%d] configure egress drop rule counter err(%ld)\n",
+				 vport->vport, PTR_ERR(drop_counter));
+		vport->egress.legacy.drop_counter = drop_counter;
+	}
+
+	esw_acl_egress_lgcy_rules_destroy(vport);
+
+	if (!vport->info.vlan && !vport->info.qos) {
+		esw_acl_egress_lgcy_cleanup(esw, vport);
+		return 0;
+	}
+
+	if (!IS_ERR_OR_NULL(vport->egress.acl))
+		return 0;
+
+	vport->egress.acl = esw_acl_table_create(esw, vport->vport,
+						 MLX5_FLOW_NAMESPACE_ESW_EGRESS,
+						 table_size);
+	if (IS_ERR_OR_NULL(vport->egress.acl)) {
+		err = PTR_ERR(vport->egress.acl);
+		vport->egress.acl = NULL;
+		goto out;
+	}
+
+	err = esw_acl_egress_lgcy_groups_create(esw, vport);
+	if (err)
+		goto out;
+
+	esw_debug(esw->dev,
+		  "vport[%d] configure egress rules, vlan(%d) qos(%d)\n",
+		  vport->vport, vport->info.vlan, vport->info.qos);
+
+	/* Allowed vlan rule */
+	err = esw_egress_acl_vlan_create(esw, vport, NULL, vport->info.vlan,
+					 MLX5_FLOW_CONTEXT_ACTION_ALLOW);
+	if (err)
+		goto out;
+
+	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_DROP;
+
+	/* Attach egress drop flow counter */
+	if (!IS_ERR_OR_NULL(drop_counter)) {
+		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
+		drop_ctr_dst.type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
+		drop_ctr_dst.counter_id = mlx5_fc_id(drop_counter);
+		dst = &drop_ctr_dst;
+		dest_num++;
+	}
+	vport->egress.legacy.drop_rule =
+		mlx5_add_flow_rules(vport->egress.acl, NULL,
+				    &flow_act, dst, dest_num);
+	if (IS_ERR(vport->egress.legacy.drop_rule)) {
+		err = PTR_ERR(vport->egress.legacy.drop_rule);
+		esw_warn(esw->dev,
+			 "vport[%d] configure egress drop rule failed, err(%d)\n",
+			 vport->vport, err);
+		vport->egress.legacy.drop_rule = NULL;
+		goto out;
+	}
+
+	return err;
+
+out:
+	esw_acl_egress_lgcy_cleanup(esw, vport);
+	return err;
+}
+
+void esw_acl_egress_lgcy_cleanup(struct mlx5_eswitch *esw,
+				 struct mlx5_vport *vport)
+{
+	if (IS_ERR_OR_NULL(vport->egress.acl))
+		goto clean_drop_counter;
+
+	esw_debug(esw->dev, "Destroy vport[%d] E-Switch egress ACL\n", vport->vport);
+
+	esw_acl_egress_lgcy_rules_destroy(vport);
+	esw_acl_egress_lgcy_groups_destroy(vport);
+	esw_acl_egress_table_destroy(vport);
+
+clean_drop_counter:
+	if (!IS_ERR_OR_NULL(vport->egress.legacy.drop_counter)) {
+		mlx5_fc_destroy(esw->dev, vport->egress.legacy.drop_counter);
+		vport->egress.legacy.drop_counter = NULL;
+	}
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
new file mode 100644
index 000000000000..49a53ebf56dd
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_ofld.c
@@ -0,0 +1,88 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2020 Mellanox Technologies Inc. All rights reserved. */
+
+#include "mlx5_core.h"
+#include "eswitch.h"
+#include "helper.h"
+#include "ofld.h"
+
+static int esw_acl_egress_ofld_rules_create(struct mlx5_eswitch *esw,
+					    struct mlx5_vport *vport)
+{
+	if (!MLX5_CAP_GEN(esw->dev, prio_tag_required))
+		return 0;
+
+	/* For prio tag mode, there is only 1 FTEs:
+	 * 1) prio tag packets - pop the prio tag VLAN, allow
+	 * Unmatched traffic is allowed by default
+	 */
+	esw_debug(esw->dev,
+		  "vport[%d] configure prio tag egress rules\n", vport->vport);
+
+	/* prio tag vlan rule - pop it so vport receives untagged packets */
+	return esw_egress_acl_vlan_create(esw, vport, NULL, 0,
+					  MLX5_FLOW_CONTEXT_ACTION_VLAN_POP |
+					  MLX5_FLOW_CONTEXT_ACTION_ALLOW);
+}
+
+static void esw_acl_egress_ofld_rules_destroy(struct mlx5_vport *vport)
+{
+	esw_acl_egress_vlan_destroy(vport);
+}
+
+static int esw_acl_egress_ofld_groups_create(struct mlx5_eswitch *esw,
+					     struct mlx5_vport *vport)
+{
+	if (!MLX5_CAP_GEN(esw->dev, prio_tag_required))
+		return 0;
+
+	return esw_acl_egress_vlan_grp_create(esw, vport);
+}
+
+static void esw_acl_egress_ofld_groups_destroy(struct mlx5_vport *vport)
+{
+	esw_acl_egress_vlan_grp_destroy(vport);
+}
+
+int esw_acl_egress_ofld_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
+{
+	int err;
+
+	if (!MLX5_CAP_GEN(esw->dev, prio_tag_required))
+		return 0;
+
+	esw_acl_egress_ofld_rules_destroy(vport);
+
+	vport->egress.acl = esw_acl_table_create(esw, vport->vport,
+						 MLX5_FLOW_NAMESPACE_ESW_EGRESS, 0);
+	if (IS_ERR_OR_NULL(vport->egress.acl)) {
+		err = PTR_ERR(vport->egress.acl);
+		vport->egress.acl = NULL;
+		return err;
+	}
+
+	err = esw_acl_egress_ofld_groups_create(esw, vport);
+	if (err)
+		goto group_err;
+
+	esw_debug(esw->dev, "vport[%d] configure egress rules\n", vport->vport);
+
+	err = esw_acl_egress_ofld_rules_create(esw, vport);
+	if (err)
+		goto rules_err;
+
+	return 0;
+
+rules_err:
+	esw_acl_egress_ofld_groups_destroy(vport);
+group_err:
+	esw_acl_egress_table_destroy(vport);
+	return err;
+}
+
+void esw_acl_egress_ofld_cleanup(struct mlx5_vport *vport)
+{
+	esw_acl_egress_ofld_rules_destroy(vport);
+	esw_acl_egress_ofld_groups_destroy(vport);
+	esw_acl_egress_table_destroy(vport);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c
new file mode 100644
index 000000000000..8b7996721a7c
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c
@@ -0,0 +1,142 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2020 Mellanox Technologies Inc. All rights reserved. */
+
+#include "mlx5_core.h"
+#include "eswitch.h"
+#include "helper.h"
+
+struct mlx5_flow_table *
+esw_acl_table_create(struct mlx5_eswitch *esw, u16 vport_num, int ns, int size)
+{
+	struct mlx5_core_dev *dev = esw->dev;
+	struct mlx5_flow_namespace *root_ns;
+	struct mlx5_flow_table *acl;
+	int acl_supported;
+	int vport_index;
+	int err;
+
+	acl_supported = (ns == MLX5_FLOW_NAMESPACE_ESW_INGRESS) ?
+			MLX5_CAP_ESW_INGRESS_ACL(dev, ft_support) :
+			MLX5_CAP_ESW_EGRESS_ACL(dev, ft_support);
+
+	if (!acl_supported)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	esw_debug(dev, "Create vport[%d] %s ACL table\n", vport_num,
+		  ns == MLX5_FLOW_NAMESPACE_ESW_INGRESS ? "ingress" : "egress");
+
+	vport_index = mlx5_eswitch_vport_num_to_index(esw, vport_num);
+	root_ns = mlx5_get_flow_vport_acl_namespace(dev, ns, vport_index);
+	if (!root_ns) {
+		esw_warn(dev, "Failed to get E-Switch root namespace for vport (%d)\n",
+			 vport_num);
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+
+	acl = mlx5_create_vport_flow_table(root_ns, 0, size, 0, vport_num);
+	if (IS_ERR(acl)) {
+		err = PTR_ERR(acl);
+		esw_warn(dev, "vport[%d] create %s ACL table, err(%d)\n", vport_num,
+			 ns == MLX5_FLOW_NAMESPACE_ESW_INGRESS ? "ingress" : "egress", err);
+	}
+	return acl;
+}
+
+int esw_egress_acl_vlan_create(struct mlx5_eswitch *esw,
+			       struct mlx5_vport *vport,
+			       struct mlx5_flow_destination *fwd_dest,
+			       u16 vlan_id, u32 flow_action)
+{
+	struct mlx5_flow_act flow_act = {};
+	struct mlx5_flow_spec *spec;
+	int err = 0;
+
+	if (vport->egress.allowed_vlan)
+		return -EEXIST;
+
+	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
+	if (!spec)
+		return -ENOMEM;
+
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.cvlan_tag);
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_value, outer_headers.cvlan_tag);
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.first_vid);
+	MLX5_SET(fte_match_param, spec->match_value, outer_headers.first_vid, vlan_id);
+
+	spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS;
+	flow_act.action = flow_action;
+	vport->egress.allowed_vlan =
+		mlx5_add_flow_rules(vport->egress.acl, spec,
+				    &flow_act, fwd_dest, 0);
+	if (IS_ERR(vport->egress.allowed_vlan)) {
+		err = PTR_ERR(vport->egress.allowed_vlan);
+		esw_warn(esw->dev,
+			 "vport[%d] configure egress vlan rule failed, err(%d)\n",
+			 vport->vport, err);
+		vport->egress.allowed_vlan = NULL;
+	}
+
+	kvfree(spec);
+	return err;
+}
+
+void esw_acl_egress_vlan_destroy(struct mlx5_vport *vport)
+{
+	if (!IS_ERR_OR_NULL(vport->egress.allowed_vlan)) {
+		mlx5_del_flow_rules(vport->egress.allowed_vlan);
+		vport->egress.allowed_vlan = NULL;
+	}
+}
+
+int esw_acl_egress_vlan_grp_create(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	struct mlx5_flow_group *vlan_grp;
+	void *match_criteria;
+	u32 *flow_group_in;
+	int ret = 0;
+
+	flow_group_in = kvzalloc(inlen, GFP_KERNEL);
+	if (!flow_group_in)
+		return -ENOMEM;
+
+	MLX5_SET(create_flow_group_in, flow_group_in,
+		 match_criteria_enable, MLX5_MATCH_OUTER_HEADERS);
+	match_criteria = MLX5_ADDR_OF(create_flow_group_in,
+				      flow_group_in, match_criteria);
+	MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.cvlan_tag);
+	MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.first_vid);
+	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 0);
+	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 0);
+
+	vlan_grp = mlx5_create_flow_group(vport->egress.acl, flow_group_in);
+	if (IS_ERR(vlan_grp)) {
+		ret = PTR_ERR(vlan_grp);
+		esw_warn(esw->dev,
+			 "Failed to create E-Switch vport[%d] egress pop vlans flow group, err(%d)\n",
+			 vport->vport, ret);
+		goto out;
+	}
+	vport->egress.vlan_grp = vlan_grp;
+
+out:
+	kvfree(flow_group_in);
+	return ret;
+}
+
+void esw_acl_egress_vlan_grp_destroy(struct mlx5_vport *vport)
+{
+	if (!IS_ERR_OR_NULL(vport->egress.vlan_grp)) {
+		mlx5_destroy_flow_group(vport->egress.vlan_grp);
+		vport->egress.vlan_grp = NULL;
+	}
+}
+
+void esw_acl_egress_table_destroy(struct mlx5_vport *vport)
+{
+	if (IS_ERR_OR_NULL(vport->egress.acl))
+		return;
+
+	mlx5_destroy_flow_table(vport->egress.acl);
+	vport->egress.acl = NULL;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.h
new file mode 100644
index 000000000000..543372df6196
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2020 Mellanox Technologies Inc. All rights reserved. */
+
+#ifndef __MLX5_ESWITCH_ACL_HELPER_H__
+#define __MLX5_ESWITCH_ACL_HELPER_H__
+
+#include "eswitch.h"
+
+/* General acl helper functions */
+struct mlx5_flow_table *
+esw_acl_table_create(struct mlx5_eswitch *esw, u16 vport_num, int ns, int size);
+
+/* Egress acl helper functions */
+void esw_acl_egress_table_destroy(struct mlx5_vport *vport);
+int esw_egress_acl_vlan_create(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
+			       struct mlx5_flow_destination *fwd_dest,
+			       u16 vlan_id, u32 flow_action);
+void esw_acl_egress_vlan_destroy(struct mlx5_vport *vport);
+int esw_acl_egress_vlan_grp_create(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
+void esw_acl_egress_vlan_grp_destroy(struct mlx5_vport *vport);
+
+#endif /* __MLX5_ESWITCH_ACL_HELPER_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/lgcy.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/lgcy.h
new file mode 100644
index 000000000000..6b05a3af4462
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/lgcy.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2020 Mellanox Technologies Inc. All rights reserved. */
+
+#ifndef __MLX5_ESWITCH_ACL_LGCY_H__
+#define __MLX5_ESWITCH_ACL_LGCY_H__
+
+#include "eswitch.h"
+
+/* Eswitch acl egress external APIs */
+int esw_acl_egress_lgcy_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
+void esw_acl_egress_lgcy_cleanup(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
+
+#endif /* __MLX5_ESWITCH_ACL_LGCY_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h
new file mode 100644
index 000000000000..fc912b254226
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2020 Mellanox Technologies Inc. All rights reserved. */
+
+#ifndef __MLX5_ESWITCH_ACL_OFLD_H__
+#define __MLX5_ESWITCH_ACL_OFLD_H__
+
+#include "eswitch.h"
+
+/* Eswitch acl egress external APIs */
+int esw_acl_egress_ofld_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
+void esw_acl_egress_ofld_cleanup(struct mlx5_vport *vport);
+
+#endif /* __MLX5_ESWITCH_ACL_OFLD_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index ac79b7c9aeb3..ae74486b9c9e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -35,6 +35,7 @@
 #include <linux/mlx5/mlx5_ifc.h>
 #include <linux/mlx5/vport.h>
 #include <linux/mlx5/fs.h>
+#include "esw/acl/lgcy.h"
 #include "mlx5_core.h"
 #include "lib/eq.h"
 #include "eswitch.h"
@@ -936,121 +937,6 @@ static void esw_vport_change_handler(struct work_struct *work)
 	mutex_unlock(&esw->state_lock);
 }
 
-int esw_vport_enable_egress_acl(struct mlx5_eswitch *esw,
-				struct mlx5_vport *vport)
-{
-	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
-	struct mlx5_flow_group *vlan_grp = NULL;
-	struct mlx5_flow_group *drop_grp = NULL;
-	struct mlx5_core_dev *dev = esw->dev;
-	struct mlx5_flow_namespace *root_ns;
-	struct mlx5_flow_table *acl;
-	void *match_criteria;
-	u32 *flow_group_in;
-	/* The egress acl table contains 2 rules:
-	 * 1)Allow traffic with vlan_tag=vst_vlan_id
-	 * 2)Drop all other traffic.
-	 */
-	int table_size = 2;
-	int err = 0;
-
-	if (!MLX5_CAP_ESW_EGRESS_ACL(dev, ft_support))
-		return -EOPNOTSUPP;
-
-	if (!IS_ERR_OR_NULL(vport->egress.acl))
-		return 0;
-
-	esw_debug(dev, "Create vport[%d] egress ACL log_max_size(%d)\n",
-		  vport->vport, MLX5_CAP_ESW_EGRESS_ACL(dev, log_max_ft_size));
-
-	root_ns = mlx5_get_flow_vport_acl_namespace(dev, MLX5_FLOW_NAMESPACE_ESW_EGRESS,
-			mlx5_eswitch_vport_num_to_index(esw, vport->vport));
-	if (!root_ns) {
-		esw_warn(dev, "Failed to get E-Switch egress flow namespace for vport (%d)\n", vport->vport);
-		return -EOPNOTSUPP;
-	}
-
-	flow_group_in = kvzalloc(inlen, GFP_KERNEL);
-	if (!flow_group_in)
-		return -ENOMEM;
-
-	acl = mlx5_create_vport_flow_table(root_ns, 0, table_size, 0, vport->vport);
-	if (IS_ERR(acl)) {
-		err = PTR_ERR(acl);
-		esw_warn(dev, "Failed to create E-Switch vport[%d] egress flow Table, err(%d)\n",
-			 vport->vport, err);
-		goto out;
-	}
-
-	MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable, MLX5_MATCH_OUTER_HEADERS);
-	match_criteria = MLX5_ADDR_OF(create_flow_group_in, flow_group_in, match_criteria);
-	MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.cvlan_tag);
-	MLX5_SET_TO_ONES(fte_match_param, match_criteria, outer_headers.first_vid);
-	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 0);
-	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 0);
-
-	vlan_grp = mlx5_create_flow_group(acl, flow_group_in);
-	if (IS_ERR(vlan_grp)) {
-		err = PTR_ERR(vlan_grp);
-		esw_warn(dev, "Failed to create E-Switch vport[%d] egress allowed vlans flow group, err(%d)\n",
-			 vport->vport, err);
-		goto out;
-	}
-
-	memset(flow_group_in, 0, inlen);
-	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 1);
-	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index, 1);
-	drop_grp = mlx5_create_flow_group(acl, flow_group_in);
-	if (IS_ERR(drop_grp)) {
-		err = PTR_ERR(drop_grp);
-		esw_warn(dev, "Failed to create E-Switch vport[%d] egress drop flow group, err(%d)\n",
-			 vport->vport, err);
-		goto out;
-	}
-
-	vport->egress.acl = acl;
-	vport->egress.drop_grp = drop_grp;
-	vport->egress.allowed_vlans_grp = vlan_grp;
-out:
-	kvfree(flow_group_in);
-	if (err && !IS_ERR_OR_NULL(vlan_grp))
-		mlx5_destroy_flow_group(vlan_grp);
-	if (err && !IS_ERR_OR_NULL(acl))
-		mlx5_destroy_flow_table(acl);
-	return err;
-}
-
-void esw_vport_cleanup_egress_rules(struct mlx5_eswitch *esw,
-				    struct mlx5_vport *vport)
-{
-	if (!IS_ERR_OR_NULL(vport->egress.allowed_vlan)) {
-		mlx5_del_flow_rules(vport->egress.allowed_vlan);
-		vport->egress.allowed_vlan = NULL;
-	}
-
-	if (!IS_ERR_OR_NULL(vport->egress.legacy.drop_rule)) {
-		mlx5_del_flow_rules(vport->egress.legacy.drop_rule);
-		vport->egress.legacy.drop_rule = NULL;
-	}
-}
-
-void esw_vport_disable_egress_acl(struct mlx5_eswitch *esw,
-				  struct mlx5_vport *vport)
-{
-	if (IS_ERR_OR_NULL(vport->egress.acl))
-		return;
-
-	esw_debug(esw->dev, "Destroy vport[%d] E-Switch egress ACL\n", vport->vport);
-
-	esw_vport_cleanup_egress_rules(esw, vport);
-	mlx5_destroy_flow_group(vport->egress.allowed_vlans_grp);
-	mlx5_destroy_flow_group(vport->egress.drop_grp);
-	mlx5_destroy_flow_table(vport->egress.acl);
-	vport->egress.allowed_vlans_grp = NULL;
-	vport->egress.drop_grp = NULL;
-	vport->egress.acl = NULL;
-}
-
 static int
 esw_vport_create_legacy_ingress_acl_groups(struct mlx5_eswitch *esw,
 					   struct mlx5_vport *vport)
@@ -1346,102 +1232,6 @@ static int esw_vport_ingress_config(struct mlx5_eswitch *esw,
 	return err;
 }
 
-int mlx5_esw_create_vport_egress_acl_vlan(struct mlx5_eswitch *esw,
-					  struct mlx5_vport *vport,
-					  u16 vlan_id, u32 flow_action)
-{
-	struct mlx5_flow_act flow_act = {};
-	struct mlx5_flow_spec *spec;
-	int err = 0;
-
-	if (vport->egress.allowed_vlan)
-		return -EEXIST;
-
-	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
-	if (!spec)
-		return -ENOMEM;
-
-	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.cvlan_tag);
-	MLX5_SET_TO_ONES(fte_match_param, spec->match_value, outer_headers.cvlan_tag);
-	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.first_vid);
-	MLX5_SET(fte_match_param, spec->match_value, outer_headers.first_vid, vlan_id);
-
-	spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS;
-	flow_act.action = flow_action;
-	vport->egress.allowed_vlan =
-		mlx5_add_flow_rules(vport->egress.acl, spec,
-				    &flow_act, NULL, 0);
-	if (IS_ERR(vport->egress.allowed_vlan)) {
-		err = PTR_ERR(vport->egress.allowed_vlan);
-		esw_warn(esw->dev,
-			 "vport[%d] configure egress vlan rule failed, err(%d)\n",
-			 vport->vport, err);
-		vport->egress.allowed_vlan = NULL;
-	}
-
-	kvfree(spec);
-	return err;
-}
-
-static int esw_vport_egress_config(struct mlx5_eswitch *esw,
-				   struct mlx5_vport *vport)
-{
-	struct mlx5_fc *counter = vport->egress.legacy.drop_counter;
-	struct mlx5_flow_destination drop_ctr_dst = {0};
-	struct mlx5_flow_destination *dst = NULL;
-	struct mlx5_flow_act flow_act = {0};
-	int dest_num = 0;
-	int err = 0;
-
-	esw_vport_cleanup_egress_rules(esw, vport);
-
-	if (!vport->info.vlan && !vport->info.qos) {
-		esw_vport_disable_egress_acl(esw, vport);
-		return 0;
-	}
-
-	err = esw_vport_enable_egress_acl(esw, vport);
-	if (err) {
-		mlx5_core_warn(esw->dev,
-			       "failed to enable egress acl (%d) on vport[%d]\n",
-			       err, vport->vport);
-		return err;
-	}
-
-	esw_debug(esw->dev,
-		  "vport[%d] configure egress rules, vlan(%d) qos(%d)\n",
-		  vport->vport, vport->info.vlan, vport->info.qos);
-
-	/* Allowed vlan rule */
-	err = mlx5_esw_create_vport_egress_acl_vlan(esw, vport, vport->info.vlan,
-						    MLX5_FLOW_CONTEXT_ACTION_ALLOW);
-	if (err)
-		return err;
-
-	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_DROP;
-
-	/* Attach egress drop flow counter */
-	if (counter) {
-		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
-		drop_ctr_dst.type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
-		drop_ctr_dst.counter_id = mlx5_fc_id(counter);
-		dst = &drop_ctr_dst;
-		dest_num++;
-	}
-	vport->egress.legacy.drop_rule =
-		mlx5_add_flow_rules(vport->egress.acl, NULL,
-				    &flow_act, dst, dest_num);
-	if (IS_ERR(vport->egress.legacy.drop_rule)) {
-		err = PTR_ERR(vport->egress.legacy.drop_rule);
-		esw_warn(esw->dev,
-			 "vport[%d] configure egress drop rule failed, err(%d)\n",
-			 vport->vport, err);
-		vport->egress.legacy.drop_rule = NULL;
-	}
-
-	return err;
-}
-
 static bool element_type_supported(struct mlx5_eswitch *esw, int type)
 {
 	const struct mlx5_core_dev *dev = esw->dev;
@@ -1667,17 +1457,7 @@ static int esw_vport_create_legacy_acl_tables(struct mlx5_eswitch *esw,
 	if (ret)
 		goto ingress_err;
 
-	if (MLX5_CAP_ESW_EGRESS_ACL(esw->dev, flow_counter)) {
-		vport->egress.legacy.drop_counter = mlx5_fc_create(esw->dev, false);
-		if (IS_ERR(vport->egress.legacy.drop_counter)) {
-			esw_warn(esw->dev,
-				 "vport[%d] configure egress drop rule counter failed\n",
-				 vport->vport);
-			vport->egress.legacy.drop_counter = NULL;
-		}
-	}
-
-	ret = esw_vport_egress_config(esw, vport);
+	ret = esw_acl_egress_lgcy_setup(esw, vport);
 	if (ret)
 		goto egress_err;
 
@@ -1685,9 +1465,6 @@ static int esw_vport_create_legacy_acl_tables(struct mlx5_eswitch *esw,
 
 egress_err:
 	esw_vport_disable_legacy_ingress_acl(esw, vport);
-	mlx5_fc_destroy(esw->dev, vport->egress.legacy.drop_counter);
-	vport->egress.legacy.drop_counter = NULL;
-
 ingress_err:
 	mlx5_fc_destroy(esw->dev, vport->ingress.legacy.drop_counter);
 	vport->ingress.legacy.drop_counter = NULL;
@@ -1710,9 +1487,7 @@ static void esw_vport_destroy_legacy_acl_tables(struct mlx5_eswitch *esw,
 	if (mlx5_esw_is_manager_vport(esw, vport->vport))
 		return;
 
-	esw_vport_disable_egress_acl(esw, vport);
-	mlx5_fc_destroy(esw->dev, vport->egress.legacy.drop_counter);
-	vport->egress.legacy.drop_counter = NULL;
+	esw_acl_egress_lgcy_cleanup(esw, vport);
 
 	esw_vport_disable_legacy_ingress_acl(esw, vport);
 	mlx5_fc_destroy(esw->dev, vport->ingress.legacy.drop_counter);
@@ -2433,7 +2208,7 @@ int __mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw,
 		err = esw_vport_ingress_config(esw, evport);
 		if (err)
 			return err;
-		err = esw_vport_egress_config(esw, evport);
+		err = esw_acl_egress_lgcy_setup(esw, evport);
 	}
 
 	return err;
@@ -2734,7 +2509,7 @@ static int mlx5_eswitch_query_vport_drop_stats(struct mlx5_core_dev *dev,
 	if (!vport->enabled)
 		goto unlock;
 
-	if (vport->egress.legacy.drop_counter)
+	if (!IS_ERR_OR_NULL(vport->egress.legacy.drop_counter))
 		mlx5_fc_query(dev, vport->egress.legacy.drop_counter,
 			      &stats->rx_dropped, &bytes);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index ccbbea3e0505..490410401631 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -99,10 +99,10 @@ struct vport_ingress {
 
 struct vport_egress {
 	struct mlx5_flow_table *acl;
-	struct mlx5_flow_group *allowed_vlans_grp;
-	struct mlx5_flow_group *drop_grp;
 	struct mlx5_flow_handle  *allowed_vlan;
+	struct mlx5_flow_group *vlan_grp;
 	struct {
+		struct mlx5_flow_group *drop_grp;
 		struct mlx5_flow_handle *drop_rule;
 		struct mlx5_fc *drop_counter;
 	} legacy;
@@ -291,12 +291,7 @@ int esw_vport_create_ingress_acl_table(struct mlx5_eswitch *esw,
 				       struct mlx5_vport *vport,
 				       int table_size);
 void esw_vport_destroy_ingress_acl_table(struct mlx5_vport *vport);
-void esw_vport_cleanup_egress_rules(struct mlx5_eswitch *esw,
-				    struct mlx5_vport *vport);
-int esw_vport_enable_egress_acl(struct mlx5_eswitch *esw,
-				struct mlx5_vport *vport);
-void esw_vport_disable_egress_acl(struct mlx5_eswitch *esw,
-				  struct mlx5_vport *vport);
+
 int mlx5_esw_modify_vport_rate(struct mlx5_eswitch *esw, u16 vport_num,
 			       u32 rate_mbps);
 
@@ -458,10 +453,6 @@ int mlx5_eswitch_del_vlan_action(struct mlx5_eswitch *esw,
 int __mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw,
 				  u16 vport, u16 vlan, u8 qos, u8 set_flags);
 
-int mlx5_esw_create_vport_egress_acl_vlan(struct mlx5_eswitch *esw,
-					  struct mlx5_vport *vport,
-					  u16 vlan_id, u32 flow_action);
-
 static inline bool mlx5_esw_qos_enabled(struct mlx5_eswitch *esw)
 {
 	return esw->qos.enabled;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 554fc64d8ef6..0b00b30187ce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -37,6 +37,7 @@
 #include <linux/mlx5/fs.h>
 #include "mlx5_core.h"
 #include "eswitch.h"
+#include "esw/acl/ofld.h"
 #include "esw/chains.h"
 #include "rdma.h"
 #include "en.h"
@@ -2093,37 +2094,6 @@ static int esw_vport_ingress_config(struct mlx5_eswitch *esw,
 	return err;
 }
 
-static int esw_vport_egress_config(struct mlx5_eswitch *esw,
-				   struct mlx5_vport *vport)
-{
-	int err;
-
-	if (!MLX5_CAP_GEN(esw->dev, prio_tag_required))
-		return 0;
-
-	esw_vport_cleanup_egress_rules(esw, vport);
-
-	err = esw_vport_enable_egress_acl(esw, vport);
-	if (err)
-		return err;
-
-	/* For prio tag mode, there is only 1 FTEs:
-	 * 1) prio tag packets - pop the prio tag VLAN, allow
-	 * Unmatched traffic is allowed by default
-	 */
-	esw_debug(esw->dev,
-		  "vport[%d] configure prio tag egress rules\n", vport->vport);
-
-	/* prio tag vlan rule - pop it so VF receives untagged packets */
-	err = mlx5_esw_create_vport_egress_acl_vlan(esw, vport, 0,
-						    MLX5_FLOW_CONTEXT_ACTION_VLAN_POP |
-						    MLX5_FLOW_CONTEXT_ACTION_ALLOW);
-	if (err)
-		esw_vport_disable_egress_acl(esw, vport);
-
-	return err;
-}
-
 static bool
 esw_check_vport_match_metadata_supported(const struct mlx5_eswitch *esw)
 {
@@ -2167,7 +2137,7 @@ esw_vport_create_offloads_acl_tables(struct mlx5_eswitch *esw,
 		return err;
 
 	if (mlx5_eswitch_is_vf_vport(esw, vport->vport)) {
-		err = esw_vport_egress_config(esw, vport);
+		err = esw_acl_egress_ofld_setup(esw, vport);
 		if (err) {
 			esw_vport_cleanup_ingress_rules(esw, vport);
 			esw_vport_del_ingress_acl_modify_metadata(esw, vport);
@@ -2182,7 +2152,7 @@ void
 esw_vport_destroy_offloads_acl_tables(struct mlx5_eswitch *esw,
 				      struct mlx5_vport *vport)
 {
-	esw_vport_disable_egress_acl(esw, vport);
+	esw_acl_egress_ofld_cleanup(vport);
 	esw_vport_cleanup_ingress_rules(esw, vport);
 	esw_vport_del_ingress_acl_modify_metadata(esw, vport);
 	esw_vport_destroy_ingress_acl_group(vport);
-- 
2.26.2

