Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A95D3D1F87
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 09:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbhGVHSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 03:18:15 -0400
Received: from mail-sn1anam02on2093.outbound.protection.outlook.com ([40.107.96.93]:59110
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231232AbhGVHSL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 03:18:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QDjdYhDu5Cw2GSAFoQN+cvwKjRxyVfq4QcehKyOAHOkbfmAaDeExrDCmW5kZulAceS8YuxsmCRVINIaiagFwWrbogtRiyZghKa5pjW6syfxi9+089hEL5WM9PrSzuuD0wgrCZZ+QdgJ6XGmIlFGKi/JW0KqXJd0ML8qPPTakguJ4Nr6gBFrYyXADPLFNhJFth4Q5ueVGZUqhSEgk1lXaVY5FJZ5uFomCkPOHlU1B82LLXab7hQ27jQQ9q8lK7hRnn8fnDCO4+90EaMTE1/pK80fnM/aRW7HrUqIt5VyMHOjD/vzTin7+DViOJy+6X1N6Ova4Y2MrV5XEUiLiBteiVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HvfA56G63wbRvRyuupyX7BCDW7gg2yoEdx0YsTMhWUI=;
 b=GToPBUrVWd0u35j1tA0wjQ+mYec83yE8D3WjZVDqDKS37TLfi7yCSH8l5WMPJmgxKcQPfiOcNlpvrWXt/ZVKS2veWcAjhjCXesltjdDsx2xVnzaFwH7bs3lb0wZH9QEGVs7GGKjpw18hjX+Mx8fxkcMGLcH/mmEr58cJf0TgTrzGElbB/s2Pq6LhHen4NY1Gi5CUSmECSBiXLQcZ60kgrfaqm3KnUSTFRl+766Tclz5olLwqqOsLHVbClviDhiZ+IHxUburoXGwdnh9uyVqM2GRUChcIgT9RBT3+ZbnwouAdk2oVuuuf5t6RG//AsbXmF/Budi5VgLM4HrSHhecZlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HvfA56G63wbRvRyuupyX7BCDW7gg2yoEdx0YsTMhWUI=;
 b=r3XCEjMNxK0/z5irsQqq4FWTvfUXock04ff1vC+8M9oaR366KHu+CXblyO2x+UxTXV4u7y1E5wVIGB2dezsvYj3EFquOYWm8p9kUyJyuCW/jLiL1Kq1YLlh7HEQDH5WwiTy1QHzP2fwZ4Ah5bcIUgKMgkQlkQB3bR+6OvsDBz1M=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4778.namprd13.prod.outlook.com (2603:10b6:510:76::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24; Thu, 22 Jul
 2021 07:58:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%7]) with mapi id 15.20.4352.024; Thu, 22 Jul 2021
 07:58:40 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 7/9] nfp: flower-ct: add flow_pay to the offload table
Date:   Thu, 22 Jul 2021 09:58:06 +0200
Message-Id: <20210722075808.10095-8-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210722075808.10095-1-simon.horman@corigine.com>
References: <20210722075808.10095-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0136.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::41) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM0PR06CA0136.eurprd06.prod.outlook.com (2603:10a6:208:ab::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 07:58:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 739aaae3-a90a-4db6-49b9-08d94ce68491
X-MS-TrafficTypeDiagnostic: PH0PR13MB4778:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB477819397EDF46B7110C9732E8E49@PH0PR13MB4778.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pEkPYG1No6mBrH98gOgjV0RYmQ6AcLSz8xGCU67RtsxKBTPVh8v9VpMq6PnYdKoWwqUwVyJHIum/qe3bS2PPOoUCJ6ZxlK0m1nnAvCJwzk1PiyYOS1NeenHwzLb0MRV8Krj3iZcIsO8PFb7Gov3ezGSqiWbfWFR+kz2tfcwL6QwXjHOQ+tuUUHsJ8GCKi8c5HFyI6SU55UGTV6mbhrYC+UofJ/6nGiiWvM3xWXT8xgh/nYCHaT7GQlNDUdYsFxynAMTYEt/J6gAIo795pL0cVFdwkPzHPz7dRL+Dy2QPNAm8d4kTSVnH367q0ewOTvHm8tvk3Indn/8phJ97ZzSIiwY0g+jteXEHXbB0+io9pUcPwIazTT9JcOef4wh7ru+p/yxCC+FxZPyAbVPJWQrVLq/9Kii7V2tsNMpyfi/0JNF+Zl/wKkdi8Vp6MpOnRCTKk1TnoR258RZoBgPEJ+J16P9ZaRTGVoEkXeUX57WzMv5aGqUgaP9mPSq5j6triOHwYIDRP8rRtU1d4VTqFPYM/n5fdUPawVFHO4JkWOpKOqYfV9+/imhDPeYMdMyK+g8d4bc8QRW7Yk+cbbLYTYzxZB9gWYuuKMuyvvndZiXtlyNeOy1YcMO7difJU5X/lXNchWqjTz33SR4zKKO5k2uHng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(396003)(366004)(39830400003)(44832011)(2616005)(36756003)(66476007)(8936002)(66556008)(8676002)(5660300002)(54906003)(6486002)(107886003)(186003)(38100700002)(6666004)(478600001)(2906002)(66946007)(6512007)(52116002)(1076003)(6506007)(110136005)(83380400001)(86362001)(4326008)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LLPLtut6u8MY+iR2FFLM6FyJYowUrDq68sQKBotDjApCmrfzYH+iXXZO+86k?=
 =?us-ascii?Q?B1Re9WZ5Aoel+Z79Klg0d18juwjx/zu2C1EVLd9+CZOQHpQNc1FDPJ7QW14n?=
 =?us-ascii?Q?CtLVIh+TUxNXfoWSJHQAP1QgSHKsFbNw8+S44yJYm84qFhr+Do7+qHL8x2DO?=
 =?us-ascii?Q?35ItEaGKXAKYdjAlMFrhzGKkJ5PBQkYSlgpgZ6B+Bw5y1dr5TQvLz9yVetAa?=
 =?us-ascii?Q?mrmosKjhKa4JBJplFC6rAC7W47i9U0oiWMkrSSvmGvdE7PneX4foOzbiUF+U?=
 =?us-ascii?Q?mv+WoYx+Wtig+M4rtZN7qoEmg/2H498pujiQHHFW66FP5dGfUU2PidEh+rVN?=
 =?us-ascii?Q?zH28sM3mHFn3iTV44zf8MZGvyxxwUAefs5atfgCtqAZCopeXmWZKV+Ql1Djz?=
 =?us-ascii?Q?DfyaqSTD08GqqjlyBu4eMC21A+l2Vs52H1yZHnJC6/IGUHgry8OOhlVuTXZd?=
 =?us-ascii?Q?vbP7RmlvpeGwLwWDD11VymKue3yRS1KqIpH82AwlJWFbYBwRejJtG7OirCdQ?=
 =?us-ascii?Q?dnf2/VqkcQReNUph/UAW9xHkWOOhFIqoX0dyHUtlwiEub9qofQni5UHlZzIY?=
 =?us-ascii?Q?qd9QkY4+hQqXMAP6ldzWQ/ViB7xjiKTP4CjMEgDHxp5xXh19YmFIX6CylEG8?=
 =?us-ascii?Q?pL/V++EkDJ8Qid4ao+WFphswJgFUtsRThj2VwZoObpI4a9Ql2e/JQ3GeaQAp?=
 =?us-ascii?Q?AHGaVyqgxyFhLgtN8B81geVmiwXuFwEJH/esJRwxLdA6Na8e8B0E267zacnh?=
 =?us-ascii?Q?tv5FGeHjS2XkiuSvHW3G2vBLbBJYn2dVtje+ZiB6z+8GkuZ/9FXBxU6dX255?=
 =?us-ascii?Q?m4xj/O2G1KB1PpNxkv+2FHWvxj/vJFgsKfPGAXP8IudEPaAj8WirTj/a4QEp?=
 =?us-ascii?Q?/Qd2UnyE9YMg2njb85Ptq+Bz4G5q9J7p0TJN09rxBGYNokoohdjsvoFcSk2r?=
 =?us-ascii?Q?lGq/EIGVDxZnktomV1xgdYI6bXvhNpaWJgAolwjEiGkfkLE1FhMEs09W+qA9?=
 =?us-ascii?Q?Wi60bmuNBA1mOaa5iG+fHZ48W1uSSlx5A7/Mos1elbYSSHJC4/Zff+Wlo9SX?=
 =?us-ascii?Q?/wD2cSZfO9Uh/FpeWSu0ZRQ/O2/lAiEscgmKaS4D0ufc/fFoGaV1cDBsAdH/?=
 =?us-ascii?Q?XrSgXfqt7nAUKp/Ilz3U3PF3NxQZ5H3kdb0Zl8GpvWOiYXvx75YefjO6o9FT?=
 =?us-ascii?Q?anzRDJU161l8eVG3EuF40+H+t6LvIN413gQxwCI0DeD7uKcgwg2I91pwnqIP?=
 =?us-ascii?Q?p8mpzCESZSpnVuet4jZHswZEiYi1AEjVlCdEPWY8csOtf9fnj1qf/spSjDQf?=
 =?us-ascii?Q?uFDUkdra2CwgplOVLUKuzgtV3wo61Q+PlqSviQJR34zWlr9iSYqAQd6qZAW/?=
 =?us-ascii?Q?pjhe/5tgYRJckZhIIAl4Up/AfjSO?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 739aaae3-a90a-4db6-49b9-08d94ce68491
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 07:58:40.0914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RdUrNfgttmj0UJ3UtwOgsDickqxc4kG6YsYp66PUl1UMu8IrCr+V2R/fViGLaeY7RggKKK2kr+tyirNDrIGYl+HkZPB0i1LEFbZWHx6rVZ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4778
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

Compile the offload flow metadata and add flow_pay to the offload
table. Also add in the delete paths. This does not include actual
offloading to the card yet, this will follow soon.

Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/conntrack.c | 75 ++++++++++++++++++-
 .../net/ethernet/netronome/nfp/flower/main.h  |  3 +
 .../ethernet/netronome/nfp/flower/offload.c   |  2 +-
 3 files changed, 78 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index 41b1f9773d46..8ab7c7e8792d 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -2,6 +2,7 @@
 /* Copyright (C) 2021 Corigine, Inc. */
 
 #include "conntrack.h"
+#include "../nfp_port.h"
 
 const struct rhashtable_params nfp_tc_ct_merge_params = {
 	.head_offset		= offsetof(struct nfp_fl_ct_tc_merge,
@@ -549,6 +550,7 @@ static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
 
 	struct flow_rule *rules[_CT_TYPE_MAX];
 	u8 *key, *msk, *kdata, *mdata;
+	struct nfp_port *port = NULL;
 	struct net_device *netdev;
 	bool qinq_sup;
 	u32 port_id;
@@ -792,7 +794,40 @@ static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
 	if (err)
 		goto ct_offload_err;
 
+	/* Use the pointer address as the cookie, but set the last bit to 1.
+	 * This is to avoid the 'is_merge_flow' check from detecting this as
+	 * an already merged flow. This works since address alignment means
+	 * that the last bit for pointer addresses will be 0.
+	 */
+	flow_pay->tc_flower_cookie = ((unsigned long)flow_pay) | 0x1;
+	err = nfp_compile_flow_metadata(priv->app, flow_pay->tc_flower_cookie,
+					flow_pay, netdev, NULL);
+	if (err)
+		goto ct_offload_err;
+
+	if (nfp_netdev_is_nfp_repr(netdev))
+		port = nfp_port_from_netdev(netdev);
+
+	err = rhashtable_insert_fast(&priv->flow_table, &flow_pay->fl_node,
+				     nfp_flower_table_params);
+	if (err)
+		goto ct_release_offload_meta_err;
+
+	m_entry->tc_flower_cookie = flow_pay->tc_flower_cookie;
+	m_entry->flow_pay = flow_pay;
+
+	if (port)
+		port->tc_offload_cnt++;
+
+	return err;
+
+ct_release_offload_meta_err:
+	nfp_modify_flow_metadata(priv->app, flow_pay);
 ct_offload_err:
+	if (flow_pay->nfp_tun_ipv4_addr)
+		nfp_tunnel_del_ipv4_off(priv->app, flow_pay->nfp_tun_ipv4_addr);
+	if (flow_pay->nfp_tun_ipv6)
+		nfp_tunnel_put_ipv6_off(priv->app, flow_pay->nfp_tun_ipv6);
 	kfree(flow_pay->action_data);
 	kfree(flow_pay->mask_data);
 	kfree(flow_pay->unmasked_data);
@@ -803,7 +838,45 @@ static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
 static int nfp_fl_ct_del_offload(struct nfp_app *app, unsigned long cookie,
 				 struct net_device *netdev)
 {
-	return 0;
+	struct nfp_flower_priv *priv = app->priv;
+	struct nfp_fl_payload *flow_pay;
+	struct nfp_port *port = NULL;
+	int err = 0;
+
+	if (nfp_netdev_is_nfp_repr(netdev))
+		port = nfp_port_from_netdev(netdev);
+
+	flow_pay = nfp_flower_search_fl_table(app, cookie, netdev);
+	if (!flow_pay)
+		return -ENOENT;
+
+	err = nfp_modify_flow_metadata(app, flow_pay);
+	if (err)
+		goto err_free_merge_flow;
+
+	if (flow_pay->nfp_tun_ipv4_addr)
+		nfp_tunnel_del_ipv4_off(app, flow_pay->nfp_tun_ipv4_addr);
+
+	if (flow_pay->nfp_tun_ipv6)
+		nfp_tunnel_put_ipv6_off(app, flow_pay->nfp_tun_ipv6);
+
+	if (!flow_pay->in_hw) {
+		err = 0;
+		goto err_free_merge_flow;
+	}
+
+err_free_merge_flow:
+	nfp_flower_del_linked_merge_flows(app, flow_pay);
+	if (port)
+		port->tc_offload_cnt--;
+	kfree(flow_pay->action_data);
+	kfree(flow_pay->mask_data);
+	kfree(flow_pay->unmasked_data);
+	WARN_ON_ONCE(rhashtable_remove_fast(&priv->flow_table,
+					    &flow_pay->fl_node,
+					    nfp_flower_table_params));
+	kfree_rcu(flow_pay, rcu);
+	return err;
 }
 
 static int nfp_ct_do_nft_merge(struct nfp_fl_ct_zone_entry *zt,
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 226bcbf6e5b5..9e933deabfe2 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -560,4 +560,7 @@ int nfp_flower_calculate_key_layers(struct nfp_app *app,
 				    struct flow_rule *flow,
 				    enum nfp_flower_tun_type *tun_type,
 				    struct netlink_ext_ack *extack);
+void
+nfp_flower_del_linked_merge_flows(struct nfp_app *app,
+				  struct nfp_fl_payload *sub_flow);
 #endif
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 87a32e9fe4e5..e510711f6398 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1470,7 +1470,7 @@ nfp_flower_remove_merge_flow(struct nfp_app *app,
 	kfree_rcu(merge_flow, rcu);
 }
 
-static void
+void
 nfp_flower_del_linked_merge_flows(struct nfp_app *app,
 				  struct nfp_fl_payload *sub_flow)
 {
-- 
2.20.1

