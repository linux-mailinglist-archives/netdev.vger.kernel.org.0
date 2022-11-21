Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D30663246A
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbiKUN4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:56:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbiKUN4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:56:20 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2057.outbound.protection.outlook.com [40.107.21.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F6E7BF80D
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 05:56:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oATI8XSX2uiauAWH91b5EbnX27sZB0zaGzBESeDarLYMRjrpEPiqWxYNNRU4LsaAru/2GZCA+g6lGj+9ctZh6iWFCWtRY4QC/bSbxHxmb1w8y6Se93cTErxmeGKlwYM2L1+MHV15U2Z8p0pvKXuBacBq4xGp8U5BQRClpS2g3JmoCbM4ohEfNbb/L58TbMY1p4i6iOBPPwKa1zL2xIJYSvG5NbLOjOe7N0sIsX9X8HER4/v6i30El27dYFlii3Qab9AFkJT4kF3RTnzcsvrTGgnoXvpk+mhzS/TH3Hk+1I8rfaruQvpq6+2EIh1d3FvQCUTGf6q+rufo3LcbMWXuLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w8/do7ilgc/9ew3ZwrFQ5IkLg2VAehZMWcj2TRnCHPg=;
 b=C6ZGsT2Je1Ld6RvdvOdE3YNxwb9GfamZ63Rtp/v8SwDcnBlXb2HWb0I8W+ds+yXM3jjKKd0U2R3/e8cH9tZ665ydV4rmmuAoiBOusMoMM0+3Voe/dAZ0M/86TFVw7hquLFKeIocQO4eMpm1M3vIJjdtljw7QNhI14owlbhdFRYA/6lRG6kBmIVRXFpx0zZDfdwE4xZvzTqwVJ+yJR0kgyM451//XwK16qqzmHdnc18FGJz1geE+eGBlOzddugM0tQnUbyk760TB1DuNoloSkVSnCauRpnM/DBDZd4dEZQfy+87ENuA3XTsXXkH+QSmhbx/EBvRHsRRjVcy6Zvk4RFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w8/do7ilgc/9ew3ZwrFQ5IkLg2VAehZMWcj2TRnCHPg=;
 b=FS+BJaKRnacGGVjwnTBAYDLcmDa8JXT1mwoPjB5+2aNyWgf7AohRpxopt8eFWTsdfYoQhp1oWHY4A4P2oeaONXLdbPnRmuQdn8T2qmHdKw560qD1AetDU0N3EZcUDpS16DbH1aOrCeY0CPky7SblRCgrFgGfdSi9Gv1jlpyfhhU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8134.eurprd04.prod.outlook.com (2603:10a6:20b:3f1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Mon, 21 Nov
 2022 13:56:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 13:56:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 03/17] net: dsa: move bulk of devlink code to devlink.{c,h}
Date:   Mon, 21 Nov 2022 15:55:41 +0200
Message-Id: <20221121135555.1227271-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
References: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P194CA0015.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:800:be::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8134:EE_
X-MS-Office365-Filtering-Correlation-Id: 409c0800-6fc9-43eb-b4d7-08dacbc82752
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dKuroofk/rWMmXnFFityIwD52eOnn5Y4cMsfRqryqy9wg3V9D+fm+66H0/EygaN4ylm99I9EIrGkuLm4CQYlWCjtAuKEB2owxM8t8bcZl02eQYAyuqLOUPfCtcoPkUAyJCXkv4N9HdOIMNAlj2bpjlFdFnmRwNh3gYdTv13A33BX0UTSiVnUvHg0JLLKav0nEUxR+B1kgRxxfgu2v7isrxSfvYekYmeWp6JaPtkbCR+U9NM0zVEJs7zxmSvQi2tE/3hzOubCkE/7tWql/JKIpEW/UT0S3q37dDG9RF0irycsESaqrrl7cU3cTscpnEVZoSfOu35CnGMvF2uZQCAa2NylDjDCgSCkOmuqmnf0fQDh0sacXBX1yOygit9HBI+COmbuHL/xrsiWD+20ofJhFxqWWP6ilhlAdvglv4OXy6T2NSk2CJTtpgq66K+pAYr7Sqn2BQaMeHQqEQx11UAOHtrNpCMo7upaCjZEcbhaFTczmN2VmzQmubW2WujEcpIhs8LgyhWaBJigefY9bXjQMmFmHrUyS71uxocKS5Tp/73TxPBd/35whHtCV4L1ROszNbkhJdRYSsZDNFRut/p3p1Gggz6w97HLgomlt9l7Pq040rID06R46/d/WFAwGpnPiIRp5otjfCifHNkMObpxl8DI6QZl/sa6QHlkOMJ4I0Taf3oAj6qN43PQQ03qD3l77ia1gRhDHsl2KBtl6e5x8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(451199015)(36756003)(30864003)(478600001)(5660300002)(44832011)(6512007)(66946007)(54906003)(66476007)(26005)(6916009)(4326008)(8676002)(316002)(2616005)(6506007)(52116002)(66556008)(41300700001)(1076003)(186003)(8936002)(38350700002)(38100700002)(83380400001)(2906002)(86362001)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YiP9DgbBs1D2UxE9OU9ROlFzapp64X6W3u5fbAAlcrV31TlW3lRJJoKcXhWJ?=
 =?us-ascii?Q?XmTentBQChmOvhW/DQAfOnsQQyakHZjJMWd+2aRX06uhTPuNgPTT6HJEyq8r?=
 =?us-ascii?Q?3CnvsirasS/ETR3SUCtoRVWUeVHtkgwB7Zki1mUb/TjPz2Hd7WlcP+nLrIED?=
 =?us-ascii?Q?209VLO7NIfagDHd3uFpbLt0yHy8ur7aciK5dfrqDpMa+IHSVqtlsPQ+8ZngK?=
 =?us-ascii?Q?CGO9jpxAnv9RD0OjyQq9rYh1N9v31qApIA8G3fN0M+CYsAsFC1Ell3E6XFhm?=
 =?us-ascii?Q?f4ha+lrZS2HcYSkyWIFnNqSJBhuR1X6iYiP+BC1fPA2GCS3pfDPoEdXzohcc?=
 =?us-ascii?Q?rBxkiQtEVuu2QI5xgkskGioI2A6Ul8EuCDDBRid9GbJO3PBfHbIOLbiP0E30?=
 =?us-ascii?Q?/SPsHIITrkxmA1PH8C49xGeYI/MoKomT38Tiwj4V3mvVhix85HW8FOyPwlbe?=
 =?us-ascii?Q?V+OZ7cUx7YOqwu5Xp0ENp13mlQryDH12E/zEZZOiTV731F6LswHwGcLr7G0P?=
 =?us-ascii?Q?GbRfYOmzTsI83xqlVyPweY+efdocg71aWbXNq/mMtnuJINOhZLMyccK7NcTr?=
 =?us-ascii?Q?Fq6jHqBLxv88osLgSUPHWfWEcxJahGRTlqADOyhaJz63/qqYLMjdLXB1W5tO?=
 =?us-ascii?Q?jLVw7ztI9V2Wq+J7hjQjio0nrZHrqh4gf1vRYU3uJfFx11CP/QukuiVYHyNj?=
 =?us-ascii?Q?O4M8fTlf66ZsknAotH2p4Bfm8mzZHIohUUTF0KcsvWVJ6aPE2A1x3ZfjzoIf?=
 =?us-ascii?Q?ebZ+ALp+XgR4+kBdU4o3eOASwcnyLyoFLvS+nVmLEwyV86VVTBULld9PSAsu?=
 =?us-ascii?Q?JeDyPKTtfeUUqdhhglvLrhbXSb5augDLY6asdqoqFmiMN9PWZMD7DptNsPV5?=
 =?us-ascii?Q?YOBaFqdkWDBMKb8fDmq8e1WeEKoUbRHsA+RDZTurY4jn/Ph8o8UfkFk0u9jd?=
 =?us-ascii?Q?75mXjrPfBSv4Kzj44SsQLIJe5f3C5r8WVpMy3HSNbr1CUf4sWI/JgVCUovfo?=
 =?us-ascii?Q?LNZJMqOE9um+1fy5oksoN7APySZcDsf7YNVysbK/9qoh6Y32dMGnrI04s99s?=
 =?us-ascii?Q?41/r9rvs6XNv27KvXSvQCoH/MXKJznu8+skqgshlDabnpZnW7DrdUI0I63rL?=
 =?us-ascii?Q?WtG9hH/DY/BG0uTkQ72O2ImpfnkhI072h7H4CsM7ImeQ/wvyjxqaIeTsES6E?=
 =?us-ascii?Q?KmQokwZsXA8YGvBJLKbR3gMTLFgOdXVaOW4j6E8ik9rUfcYXi5Q4YU8J8TsX?=
 =?us-ascii?Q?AFCqI+z0XrR2jwaxFKz5QNFzn4LhKP6Ltfekun1bfaGzn5GBIzVt8LGWKE2c?=
 =?us-ascii?Q?xa+8bY7TZwScd+EfijhDklV2OUKm49/VFCHfIkhK1kvycwQZaHLbpHJlovYa?=
 =?us-ascii?Q?JzAa7rGztXIOu0lmuKX+jErn7KlI/9HjaeOVIgZICrCtfrdCtmYp7lQeIpTT?=
 =?us-ascii?Q?gisw8jVk+IRCDMzyVOtvvAcwXa5QqQZUwDglUwv0RlKL1jF9LeQm8so23GQP?=
 =?us-ascii?Q?cNm5JT44igQqUHRMgIlICym4L+QjwlUFpWZj938jYaR/0P0yVKBJZGjVX331?=
 =?us-ascii?Q?GEwrQDWheQN4SISUQJeilG48ltTGXQ63XitvpKIUeerXNAc0g336VLj8OBcS?=
 =?us-ascii?Q?LA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 409c0800-6fc9-43eb-b4d7-08dacbc82752
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 13:56:14.3413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GNKkTezIFpCnDrnThIRLH9Wimx1VNfPs8MJmpUWWKViZKjZIs0gUFLHknTvaim7cVwBvfw4MYBUso8XB25zyJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8134
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dsa.c and dsa2.c are bloated with too much off-topic code. Identify all
code related to devlink and move it to a new devlink.c file.

Steer clear of the dsa_priv.h dumping ground antipattern and create a
dedicated devlink.h for it, which will be included only by the C files
which need it. Usage of dsa_priv.h will be minimized in later patches.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/Makefile  |   1 +
 net/dsa/devlink.c | 355 ++++++++++++++++++++++++++++++++++++++++++++++
 net/dsa/devlink.h |  13 ++
 net/dsa/dsa.c     | 107 --------------
 net/dsa/dsa2.c    | 240 +------------------------------
 5 files changed, 370 insertions(+), 346 deletions(-)
 create mode 100644 net/dsa/devlink.c
 create mode 100644 net/dsa/devlink.h

diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index 14e05ab64135..bc872c0d7011 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -2,6 +2,7 @@
 # the core
 obj-$(CONFIG_NET_DSA) += dsa_core.o
 dsa_core-y += \
+	devlink.o \
 	dsa.o \
 	dsa2.o \
 	master.o \
diff --git a/net/dsa/devlink.c b/net/dsa/devlink.c
new file mode 100644
index 000000000000..eff440b2b3c5
--- /dev/null
+++ b/net/dsa/devlink.c
@@ -0,0 +1,355 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * DSA devlink handling
+ */
+
+#include <net/dsa.h>
+#include <net/devlink.h>
+
+#include "devlink.h"
+
+static int dsa_devlink_info_get(struct devlink *dl,
+				struct devlink_info_req *req,
+				struct netlink_ext_ack *extack)
+{
+	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
+
+	if (ds->ops->devlink_info_get)
+		return ds->ops->devlink_info_get(ds, req, extack);
+
+	return -EOPNOTSUPP;
+}
+
+static int dsa_devlink_sb_pool_get(struct devlink *dl,
+				   unsigned int sb_index, u16 pool_index,
+				   struct devlink_sb_pool_info *pool_info)
+{
+	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
+
+	if (!ds->ops->devlink_sb_pool_get)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_pool_get(ds, sb_index, pool_index,
+					    pool_info);
+}
+
+static int dsa_devlink_sb_pool_set(struct devlink *dl, unsigned int sb_index,
+				   u16 pool_index, u32 size,
+				   enum devlink_sb_threshold_type threshold_type,
+				   struct netlink_ext_ack *extack)
+{
+	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
+
+	if (!ds->ops->devlink_sb_pool_set)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_pool_set(ds, sb_index, pool_index, size,
+					    threshold_type, extack);
+}
+
+static int dsa_devlink_sb_port_pool_get(struct devlink_port *dlp,
+					unsigned int sb_index, u16 pool_index,
+					u32 *p_threshold)
+{
+	struct dsa_switch *ds = dsa_devlink_port_to_ds(dlp);
+	int port = dsa_devlink_port_to_port(dlp);
+
+	if (!ds->ops->devlink_sb_port_pool_get)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_port_pool_get(ds, port, sb_index,
+						 pool_index, p_threshold);
+}
+
+static int dsa_devlink_sb_port_pool_set(struct devlink_port *dlp,
+					unsigned int sb_index, u16 pool_index,
+					u32 threshold,
+					struct netlink_ext_ack *extack)
+{
+	struct dsa_switch *ds = dsa_devlink_port_to_ds(dlp);
+	int port = dsa_devlink_port_to_port(dlp);
+
+	if (!ds->ops->devlink_sb_port_pool_set)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_port_pool_set(ds, port, sb_index,
+						 pool_index, threshold, extack);
+}
+
+static int
+dsa_devlink_sb_tc_pool_bind_get(struct devlink_port *dlp,
+				unsigned int sb_index, u16 tc_index,
+				enum devlink_sb_pool_type pool_type,
+				u16 *p_pool_index, u32 *p_threshold)
+{
+	struct dsa_switch *ds = dsa_devlink_port_to_ds(dlp);
+	int port = dsa_devlink_port_to_port(dlp);
+
+	if (!ds->ops->devlink_sb_tc_pool_bind_get)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_tc_pool_bind_get(ds, port, sb_index,
+						    tc_index, pool_type,
+						    p_pool_index, p_threshold);
+}
+
+static int
+dsa_devlink_sb_tc_pool_bind_set(struct devlink_port *dlp,
+				unsigned int sb_index, u16 tc_index,
+				enum devlink_sb_pool_type pool_type,
+				u16 pool_index, u32 threshold,
+				struct netlink_ext_ack *extack)
+{
+	struct dsa_switch *ds = dsa_devlink_port_to_ds(dlp);
+	int port = dsa_devlink_port_to_port(dlp);
+
+	if (!ds->ops->devlink_sb_tc_pool_bind_set)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_tc_pool_bind_set(ds, port, sb_index,
+						    tc_index, pool_type,
+						    pool_index, threshold,
+						    extack);
+}
+
+static int dsa_devlink_sb_occ_snapshot(struct devlink *dl,
+				       unsigned int sb_index)
+{
+	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
+
+	if (!ds->ops->devlink_sb_occ_snapshot)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_occ_snapshot(ds, sb_index);
+}
+
+static int dsa_devlink_sb_occ_max_clear(struct devlink *dl,
+					unsigned int sb_index)
+{
+	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
+
+	if (!ds->ops->devlink_sb_occ_max_clear)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_occ_max_clear(ds, sb_index);
+}
+
+static int dsa_devlink_sb_occ_port_pool_get(struct devlink_port *dlp,
+					    unsigned int sb_index,
+					    u16 pool_index, u32 *p_cur,
+					    u32 *p_max)
+{
+	struct dsa_switch *ds = dsa_devlink_port_to_ds(dlp);
+	int port = dsa_devlink_port_to_port(dlp);
+
+	if (!ds->ops->devlink_sb_occ_port_pool_get)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_occ_port_pool_get(ds, port, sb_index,
+						     pool_index, p_cur, p_max);
+}
+
+static int
+dsa_devlink_sb_occ_tc_port_bind_get(struct devlink_port *dlp,
+				    unsigned int sb_index, u16 tc_index,
+				    enum devlink_sb_pool_type pool_type,
+				    u32 *p_cur, u32 *p_max)
+{
+	struct dsa_switch *ds = dsa_devlink_port_to_ds(dlp);
+	int port = dsa_devlink_port_to_port(dlp);
+
+	if (!ds->ops->devlink_sb_occ_tc_port_bind_get)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_occ_tc_port_bind_get(ds, port,
+							sb_index, tc_index,
+							pool_type, p_cur,
+							p_max);
+}
+
+const struct devlink_ops dsa_devlink_ops = {
+	.info_get			= dsa_devlink_info_get,
+	.sb_pool_get			= dsa_devlink_sb_pool_get,
+	.sb_pool_set			= dsa_devlink_sb_pool_set,
+	.sb_port_pool_get		= dsa_devlink_sb_port_pool_get,
+	.sb_port_pool_set		= dsa_devlink_sb_port_pool_set,
+	.sb_tc_pool_bind_get		= dsa_devlink_sb_tc_pool_bind_get,
+	.sb_tc_pool_bind_set		= dsa_devlink_sb_tc_pool_bind_set,
+	.sb_occ_snapshot		= dsa_devlink_sb_occ_snapshot,
+	.sb_occ_max_clear		= dsa_devlink_sb_occ_max_clear,
+	.sb_occ_port_pool_get		= dsa_devlink_sb_occ_port_pool_get,
+	.sb_occ_tc_port_bind_get	= dsa_devlink_sb_occ_tc_port_bind_get,
+};
+
+int dsa_devlink_param_get(struct devlink *dl, u32 id,
+			  struct devlink_param_gset_ctx *ctx)
+{
+	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
+
+	if (!ds->ops->devlink_param_get)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_param_get(ds, id, ctx);
+}
+EXPORT_SYMBOL_GPL(dsa_devlink_param_get);
+
+int dsa_devlink_param_set(struct devlink *dl, u32 id,
+			  struct devlink_param_gset_ctx *ctx)
+{
+	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
+
+	if (!ds->ops->devlink_param_set)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_param_set(ds, id, ctx);
+}
+EXPORT_SYMBOL_GPL(dsa_devlink_param_set);
+
+int dsa_devlink_params_register(struct dsa_switch *ds,
+				const struct devlink_param *params,
+				size_t params_count)
+{
+	return devlink_params_register(ds->devlink, params, params_count);
+}
+EXPORT_SYMBOL_GPL(dsa_devlink_params_register);
+
+void dsa_devlink_params_unregister(struct dsa_switch *ds,
+				   const struct devlink_param *params,
+				   size_t params_count)
+{
+	devlink_params_unregister(ds->devlink, params, params_count);
+}
+EXPORT_SYMBOL_GPL(dsa_devlink_params_unregister);
+
+int dsa_devlink_resource_register(struct dsa_switch *ds,
+				  const char *resource_name,
+				  u64 resource_size,
+				  u64 resource_id,
+				  u64 parent_resource_id,
+				  const struct devlink_resource_size_params *size_params)
+{
+	return devlink_resource_register(ds->devlink, resource_name,
+					 resource_size, resource_id,
+					 parent_resource_id,
+					 size_params);
+}
+EXPORT_SYMBOL_GPL(dsa_devlink_resource_register);
+
+void dsa_devlink_resources_unregister(struct dsa_switch *ds)
+{
+	devlink_resources_unregister(ds->devlink);
+}
+EXPORT_SYMBOL_GPL(dsa_devlink_resources_unregister);
+
+void dsa_devlink_resource_occ_get_register(struct dsa_switch *ds,
+					   u64 resource_id,
+					   devlink_resource_occ_get_t *occ_get,
+					   void *occ_get_priv)
+{
+	return devlink_resource_occ_get_register(ds->devlink, resource_id,
+						 occ_get, occ_get_priv);
+}
+EXPORT_SYMBOL_GPL(dsa_devlink_resource_occ_get_register);
+
+void dsa_devlink_resource_occ_get_unregister(struct dsa_switch *ds,
+					     u64 resource_id)
+{
+	devlink_resource_occ_get_unregister(ds->devlink, resource_id);
+}
+EXPORT_SYMBOL_GPL(dsa_devlink_resource_occ_get_unregister);
+
+struct devlink_region *
+dsa_devlink_region_create(struct dsa_switch *ds,
+			  const struct devlink_region_ops *ops,
+			  u32 region_max_snapshots, u64 region_size)
+{
+	return devlink_region_create(ds->devlink, ops, region_max_snapshots,
+				     region_size);
+}
+EXPORT_SYMBOL_GPL(dsa_devlink_region_create);
+
+struct devlink_region *
+dsa_devlink_port_region_create(struct dsa_switch *ds,
+			       int port,
+			       const struct devlink_port_region_ops *ops,
+			       u32 region_max_snapshots, u64 region_size)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+
+	return devlink_port_region_create(&dp->devlink_port, ops,
+					  region_max_snapshots,
+					  region_size);
+}
+EXPORT_SYMBOL_GPL(dsa_devlink_port_region_create);
+
+void dsa_devlink_region_destroy(struct devlink_region *region)
+{
+	devlink_region_destroy(region);
+}
+EXPORT_SYMBOL_GPL(dsa_devlink_region_destroy);
+
+int dsa_port_devlink_setup(struct dsa_port *dp)
+{
+	struct devlink_port *dlp = &dp->devlink_port;
+	struct dsa_switch_tree *dst = dp->ds->dst;
+	struct devlink_port_attrs attrs = {};
+	struct devlink *dl = dp->ds->devlink;
+	struct dsa_switch *ds = dp->ds;
+	const unsigned char *id;
+	unsigned char len;
+	int err;
+
+	memset(dlp, 0, sizeof(*dlp));
+	devlink_port_init(dl, dlp);
+
+	if (ds->ops->port_setup) {
+		err = ds->ops->port_setup(ds, dp->index);
+		if (err)
+			return err;
+	}
+
+	id = (const unsigned char *)&dst->index;
+	len = sizeof(dst->index);
+
+	attrs.phys.port_number = dp->index;
+	memcpy(attrs.switch_id.id, id, len);
+	attrs.switch_id.id_len = len;
+
+	switch (dp->type) {
+	case DSA_PORT_TYPE_UNUSED:
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_UNUSED;
+		break;
+	case DSA_PORT_TYPE_CPU:
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_CPU;
+		break;
+	case DSA_PORT_TYPE_DSA:
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_DSA;
+		break;
+	case DSA_PORT_TYPE_USER:
+		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
+		break;
+	}
+
+	devlink_port_attrs_set(dlp, &attrs);
+	err = devlink_port_register(dl, dlp, dp->index);
+	if (err) {
+		if (ds->ops->port_teardown)
+			ds->ops->port_teardown(ds, dp->index);
+		return err;
+	}
+
+	return 0;
+}
+
+void dsa_port_devlink_teardown(struct dsa_port *dp)
+{
+	struct devlink_port *dlp = &dp->devlink_port;
+	struct dsa_switch *ds = dp->ds;
+
+	devlink_port_unregister(dlp);
+
+	if (ds->ops->port_teardown)
+		ds->ops->port_teardown(ds, dp->index);
+
+	devlink_port_fini(dlp);
+}
diff --git a/net/dsa/devlink.h b/net/dsa/devlink.h
new file mode 100644
index 000000000000..d077c7f336da
--- /dev/null
+++ b/net/dsa/devlink.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef __DSA_DEVLINK_H
+#define __DSA_DEVLINK_H
+
+struct dsa_port;
+
+extern const struct devlink_ops dsa_devlink_ops;
+
+int dsa_port_devlink_setup(struct dsa_port *dp);
+void dsa_port_devlink_teardown(struct dsa_port *dp);
+
+#endif
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index e609d64a2216..842a1f2488b2 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -344,113 +344,6 @@ void dsa_flush_workqueue(void)
 }
 EXPORT_SYMBOL_GPL(dsa_flush_workqueue);
 
-int dsa_devlink_param_get(struct devlink *dl, u32 id,
-			  struct devlink_param_gset_ctx *ctx)
-{
-	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
-
-	if (!ds->ops->devlink_param_get)
-		return -EOPNOTSUPP;
-
-	return ds->ops->devlink_param_get(ds, id, ctx);
-}
-EXPORT_SYMBOL_GPL(dsa_devlink_param_get);
-
-int dsa_devlink_param_set(struct devlink *dl, u32 id,
-			  struct devlink_param_gset_ctx *ctx)
-{
-	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
-
-	if (!ds->ops->devlink_param_set)
-		return -EOPNOTSUPP;
-
-	return ds->ops->devlink_param_set(ds, id, ctx);
-}
-EXPORT_SYMBOL_GPL(dsa_devlink_param_set);
-
-int dsa_devlink_params_register(struct dsa_switch *ds,
-				const struct devlink_param *params,
-				size_t params_count)
-{
-	return devlink_params_register(ds->devlink, params, params_count);
-}
-EXPORT_SYMBOL_GPL(dsa_devlink_params_register);
-
-void dsa_devlink_params_unregister(struct dsa_switch *ds,
-				   const struct devlink_param *params,
-				   size_t params_count)
-{
-	devlink_params_unregister(ds->devlink, params, params_count);
-}
-EXPORT_SYMBOL_GPL(dsa_devlink_params_unregister);
-
-int dsa_devlink_resource_register(struct dsa_switch *ds,
-				  const char *resource_name,
-				  u64 resource_size,
-				  u64 resource_id,
-				  u64 parent_resource_id,
-				  const struct devlink_resource_size_params *size_params)
-{
-	return devlink_resource_register(ds->devlink, resource_name,
-					 resource_size, resource_id,
-					 parent_resource_id,
-					 size_params);
-}
-EXPORT_SYMBOL_GPL(dsa_devlink_resource_register);
-
-void dsa_devlink_resources_unregister(struct dsa_switch *ds)
-{
-	devlink_resources_unregister(ds->devlink);
-}
-EXPORT_SYMBOL_GPL(dsa_devlink_resources_unregister);
-
-void dsa_devlink_resource_occ_get_register(struct dsa_switch *ds,
-					   u64 resource_id,
-					   devlink_resource_occ_get_t *occ_get,
-					   void *occ_get_priv)
-{
-	return devlink_resource_occ_get_register(ds->devlink, resource_id,
-						 occ_get, occ_get_priv);
-}
-EXPORT_SYMBOL_GPL(dsa_devlink_resource_occ_get_register);
-
-void dsa_devlink_resource_occ_get_unregister(struct dsa_switch *ds,
-					     u64 resource_id)
-{
-	devlink_resource_occ_get_unregister(ds->devlink, resource_id);
-}
-EXPORT_SYMBOL_GPL(dsa_devlink_resource_occ_get_unregister);
-
-struct devlink_region *
-dsa_devlink_region_create(struct dsa_switch *ds,
-			  const struct devlink_region_ops *ops,
-			  u32 region_max_snapshots, u64 region_size)
-{
-	return devlink_region_create(ds->devlink, ops, region_max_snapshots,
-				     region_size);
-}
-EXPORT_SYMBOL_GPL(dsa_devlink_region_create);
-
-struct devlink_region *
-dsa_devlink_port_region_create(struct dsa_switch *ds,
-			       int port,
-			       const struct devlink_port_region_ops *ops,
-			       u32 region_max_snapshots, u64 region_size)
-{
-	struct dsa_port *dp = dsa_to_port(ds, port);
-
-	return devlink_port_region_create(&dp->devlink_port, ops,
-					  region_max_snapshots,
-					  region_size);
-}
-EXPORT_SYMBOL_GPL(dsa_devlink_port_region_create);
-
-void dsa_devlink_region_destroy(struct devlink_region *region)
-{
-	devlink_region_destroy(region);
-}
-EXPORT_SYMBOL_GPL(dsa_devlink_region_destroy);
-
 struct dsa_port *dsa_port_from_netdev(struct net_device *netdev)
 {
 	if (!netdev || !dsa_slave_dev_check(netdev))
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index f8df55e2e23a..05e682c25590 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -18,6 +18,7 @@
 #include <net/devlink.h>
 #include <net/sch_generic.h>
 
+#include "devlink.h"
 #include "dsa_priv.h"
 
 static DEFINE_MUTEX(dsa2_mutex);
@@ -461,72 +462,6 @@ static void dsa_tree_teardown_cpu_ports(struct dsa_switch_tree *dst)
 			dp->cpu_dp = NULL;
 }
 
-static int dsa_port_devlink_setup(struct dsa_port *dp)
-{
-	struct devlink_port *dlp = &dp->devlink_port;
-	struct dsa_switch_tree *dst = dp->ds->dst;
-	struct devlink_port_attrs attrs = {};
-	struct devlink *dl = dp->ds->devlink;
-	struct dsa_switch *ds = dp->ds;
-	const unsigned char *id;
-	unsigned char len;
-	int err;
-
-	memset(dlp, 0, sizeof(*dlp));
-	devlink_port_init(dl, dlp);
-
-	if (ds->ops->port_setup) {
-		err = ds->ops->port_setup(ds, dp->index);
-		if (err)
-			return err;
-	}
-
-	id = (const unsigned char *)&dst->index;
-	len = sizeof(dst->index);
-
-	attrs.phys.port_number = dp->index;
-	memcpy(attrs.switch_id.id, id, len);
-	attrs.switch_id.id_len = len;
-
-	switch (dp->type) {
-	case DSA_PORT_TYPE_UNUSED:
-		attrs.flavour = DEVLINK_PORT_FLAVOUR_UNUSED;
-		break;
-	case DSA_PORT_TYPE_CPU:
-		attrs.flavour = DEVLINK_PORT_FLAVOUR_CPU;
-		break;
-	case DSA_PORT_TYPE_DSA:
-		attrs.flavour = DEVLINK_PORT_FLAVOUR_DSA;
-		break;
-	case DSA_PORT_TYPE_USER:
-		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
-		break;
-	}
-
-	devlink_port_attrs_set(dlp, &attrs);
-	err = devlink_port_register(dl, dlp, dp->index);
-	if (err) {
-		if (ds->ops->port_teardown)
-			ds->ops->port_teardown(ds, dp->index);
-		return err;
-	}
-
-	return 0;
-}
-
-static void dsa_port_devlink_teardown(struct dsa_port *dp)
-{
-	struct devlink_port *dlp = &dp->devlink_port;
-	struct dsa_switch *ds = dp->ds;
-
-	devlink_port_unregister(dlp);
-
-	if (ds->ops->port_teardown)
-		ds->ops->port_teardown(ds, dp->index);
-
-	devlink_port_fini(dlp);
-}
-
 static int dsa_port_setup(struct dsa_port *dp)
 {
 	bool dsa_port_link_registered = false;
@@ -638,179 +573,6 @@ static int dsa_port_setup_as_unused(struct dsa_port *dp)
 	return dsa_port_setup(dp);
 }
 
-static int dsa_devlink_info_get(struct devlink *dl,
-				struct devlink_info_req *req,
-				struct netlink_ext_ack *extack)
-{
-	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
-
-	if (ds->ops->devlink_info_get)
-		return ds->ops->devlink_info_get(ds, req, extack);
-
-	return -EOPNOTSUPP;
-}
-
-static int dsa_devlink_sb_pool_get(struct devlink *dl,
-				   unsigned int sb_index, u16 pool_index,
-				   struct devlink_sb_pool_info *pool_info)
-{
-	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
-
-	if (!ds->ops->devlink_sb_pool_get)
-		return -EOPNOTSUPP;
-
-	return ds->ops->devlink_sb_pool_get(ds, sb_index, pool_index,
-					    pool_info);
-}
-
-static int dsa_devlink_sb_pool_set(struct devlink *dl, unsigned int sb_index,
-				   u16 pool_index, u32 size,
-				   enum devlink_sb_threshold_type threshold_type,
-				   struct netlink_ext_ack *extack)
-{
-	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
-
-	if (!ds->ops->devlink_sb_pool_set)
-		return -EOPNOTSUPP;
-
-	return ds->ops->devlink_sb_pool_set(ds, sb_index, pool_index, size,
-					    threshold_type, extack);
-}
-
-static int dsa_devlink_sb_port_pool_get(struct devlink_port *dlp,
-					unsigned int sb_index, u16 pool_index,
-					u32 *p_threshold)
-{
-	struct dsa_switch *ds = dsa_devlink_port_to_ds(dlp);
-	int port = dsa_devlink_port_to_port(dlp);
-
-	if (!ds->ops->devlink_sb_port_pool_get)
-		return -EOPNOTSUPP;
-
-	return ds->ops->devlink_sb_port_pool_get(ds, port, sb_index,
-						 pool_index, p_threshold);
-}
-
-static int dsa_devlink_sb_port_pool_set(struct devlink_port *dlp,
-					unsigned int sb_index, u16 pool_index,
-					u32 threshold,
-					struct netlink_ext_ack *extack)
-{
-	struct dsa_switch *ds = dsa_devlink_port_to_ds(dlp);
-	int port = dsa_devlink_port_to_port(dlp);
-
-	if (!ds->ops->devlink_sb_port_pool_set)
-		return -EOPNOTSUPP;
-
-	return ds->ops->devlink_sb_port_pool_set(ds, port, sb_index,
-						 pool_index, threshold, extack);
-}
-
-static int
-dsa_devlink_sb_tc_pool_bind_get(struct devlink_port *dlp,
-				unsigned int sb_index, u16 tc_index,
-				enum devlink_sb_pool_type pool_type,
-				u16 *p_pool_index, u32 *p_threshold)
-{
-	struct dsa_switch *ds = dsa_devlink_port_to_ds(dlp);
-	int port = dsa_devlink_port_to_port(dlp);
-
-	if (!ds->ops->devlink_sb_tc_pool_bind_get)
-		return -EOPNOTSUPP;
-
-	return ds->ops->devlink_sb_tc_pool_bind_get(ds, port, sb_index,
-						    tc_index, pool_type,
-						    p_pool_index, p_threshold);
-}
-
-static int
-dsa_devlink_sb_tc_pool_bind_set(struct devlink_port *dlp,
-				unsigned int sb_index, u16 tc_index,
-				enum devlink_sb_pool_type pool_type,
-				u16 pool_index, u32 threshold,
-				struct netlink_ext_ack *extack)
-{
-	struct dsa_switch *ds = dsa_devlink_port_to_ds(dlp);
-	int port = dsa_devlink_port_to_port(dlp);
-
-	if (!ds->ops->devlink_sb_tc_pool_bind_set)
-		return -EOPNOTSUPP;
-
-	return ds->ops->devlink_sb_tc_pool_bind_set(ds, port, sb_index,
-						    tc_index, pool_type,
-						    pool_index, threshold,
-						    extack);
-}
-
-static int dsa_devlink_sb_occ_snapshot(struct devlink *dl,
-				       unsigned int sb_index)
-{
-	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
-
-	if (!ds->ops->devlink_sb_occ_snapshot)
-		return -EOPNOTSUPP;
-
-	return ds->ops->devlink_sb_occ_snapshot(ds, sb_index);
-}
-
-static int dsa_devlink_sb_occ_max_clear(struct devlink *dl,
-					unsigned int sb_index)
-{
-	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
-
-	if (!ds->ops->devlink_sb_occ_max_clear)
-		return -EOPNOTSUPP;
-
-	return ds->ops->devlink_sb_occ_max_clear(ds, sb_index);
-}
-
-static int dsa_devlink_sb_occ_port_pool_get(struct devlink_port *dlp,
-					    unsigned int sb_index,
-					    u16 pool_index, u32 *p_cur,
-					    u32 *p_max)
-{
-	struct dsa_switch *ds = dsa_devlink_port_to_ds(dlp);
-	int port = dsa_devlink_port_to_port(dlp);
-
-	if (!ds->ops->devlink_sb_occ_port_pool_get)
-		return -EOPNOTSUPP;
-
-	return ds->ops->devlink_sb_occ_port_pool_get(ds, port, sb_index,
-						     pool_index, p_cur, p_max);
-}
-
-static int
-dsa_devlink_sb_occ_tc_port_bind_get(struct devlink_port *dlp,
-				    unsigned int sb_index, u16 tc_index,
-				    enum devlink_sb_pool_type pool_type,
-				    u32 *p_cur, u32 *p_max)
-{
-	struct dsa_switch *ds = dsa_devlink_port_to_ds(dlp);
-	int port = dsa_devlink_port_to_port(dlp);
-
-	if (!ds->ops->devlink_sb_occ_tc_port_bind_get)
-		return -EOPNOTSUPP;
-
-	return ds->ops->devlink_sb_occ_tc_port_bind_get(ds, port,
-							sb_index, tc_index,
-							pool_type, p_cur,
-							p_max);
-}
-
-static const struct devlink_ops dsa_devlink_ops = {
-	.info_get			= dsa_devlink_info_get,
-	.sb_pool_get			= dsa_devlink_sb_pool_get,
-	.sb_pool_set			= dsa_devlink_sb_pool_set,
-	.sb_port_pool_get		= dsa_devlink_sb_port_pool_get,
-	.sb_port_pool_set		= dsa_devlink_sb_port_pool_set,
-	.sb_tc_pool_bind_get		= dsa_devlink_sb_tc_pool_bind_get,
-	.sb_tc_pool_bind_set		= dsa_devlink_sb_tc_pool_bind_set,
-	.sb_occ_snapshot		= dsa_devlink_sb_occ_snapshot,
-	.sb_occ_max_clear		= dsa_devlink_sb_occ_max_clear,
-	.sb_occ_port_pool_get		= dsa_devlink_sb_occ_port_pool_get,
-	.sb_occ_tc_port_bind_get	= dsa_devlink_sb_occ_tc_port_bind_get,
-};
-
 static int dsa_switch_setup_tag_protocol(struct dsa_switch *ds)
 {
 	const struct dsa_device_ops *tag_ops = ds->dst->tag_ops;
-- 
2.34.1

