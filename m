Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B731363247F
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbiKUN5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:57:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbiKUN4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:56:37 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2085.outbound.protection.outlook.com [40.107.249.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE1EEC4C37
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 05:56:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZS5MC1SxOpfhSeXfG+rMeYbGMi+Pgcsq4DOX4Bjx7hyy3Nb83YMUxXJDEHh2DC/+3ntU59KlwRzx0UQkC7XKw90UkhZdMlayNJ5mdcQ5fRPtt9YmL/hi1A4pqgp02XIg9DZYNcvfjW4CxBG2nfErVrTAhgua88ZzDKrCIZs8DrC+EFIUHhowZ2Ry79M1nQzuVP8j9esKcsdUrwkiWmHcjdbilQ4Z99umZlT+KllR49zpGhkWRyfaeR39rnw2PDBvNqCXXkcRBVS7OpnOvc/v3iuNb+o1cF8lDqf3g1FJ1oirubR8bu7YJZ0vyr4EAQdAOZxLX7Udp7V4YgSOLxEtHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LpROFB3Dq/54j/uP6rLwBsuYVRCldaiGZcwlXql4fHQ=;
 b=FK3RZH+3t3bYmjxhfm0bMuX4lyoTHzXWRS9h1rl2tJp7EOPBZx+I7HfwdpBszTG0MP5ZS/Zz9zd84AYlqQIyuj+NzFHFLmkUG7lLDLZFZ9wmPxT/kSJmGoL7fGJw+CMVjPgzvO0VGR4q/HOEuSodDYOJWHVuU2wUvKWlox35s8fxsd9d9Y0lYbthR9b044uTrtz9UfEHjOAM6QwI7Bqq31bgDQS7iOKpKGEop/t4xcufLartp5nDDmZwUmQIjAteaHCRO96URIEZA0joCIDvK79Lvval3KzXwTqA2T4eI5LeRlBbfwUIxq5PhAViVBxIWaT9G8BKtAbOEog7ZZ/6JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LpROFB3Dq/54j/uP6rLwBsuYVRCldaiGZcwlXql4fHQ=;
 b=Cer11zkyB5uA6nClTgueFb1Vbz0olEQpC3Pt0o4ReSWDj7ulJPsBjxiI6VCShWKZxB1hkgPks6VsngMP5AQMWCYlfdwnl4tDTn3o1YP0efXINfggyGoeIYLv9QzKZrIULam3HzwL5ItCN4sxlYJOL45MSlEFs0ymHmYwnmOaD+g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6829.eurprd04.prod.outlook.com (2603:10a6:803:13b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Mon, 21 Nov
 2022 13:56:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 13:56:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 15/17] net: dsa: move definitions from dsa_priv.h to slave.c
Date:   Mon, 21 Nov 2022 15:55:53 +0200
Message-Id: <20221121135555.1227271-16-vladimir.oltean@nxp.com>
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
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|VI1PR04MB6829:EE_
X-MS-Office365-Filtering-Correlation-Id: 86cabc6e-59e1-4ccd-c3c8-08dacbc82c6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pcf8fcN136zjh6rvumCMhBzsucsNs0DBuzwWGCP/hUEG1jV8KA8j1w5dbwzkXiIRsb8ZitLPrAnMWc7gGq8+47sEcTXuu1Aqo/Ef0Ib3nBwLGq7WDEgdXxQuQUIzEnxVgUmmbljdziOgyQcHf2SibwjoVxPh7NPNbdw5L42B2SGGfa2Awpf2s/V+uajnl12n1rr3+Bxh/5E0tl1aA9A0nUsxm3Om+a82iqGgwXC8BcDL43rqxQyTdQyu/F0QPFHx8SE0701/pIBDWsa939nVGBFctqRYAPQ+CMEGOIGHPBxM0bTMV/c/r3cupkEHY375cKwsjEljUhQ8oW+IHJWhLdQmZM9F7By6BiONZmoPFPAV1UDLZ3TNdNkTWB3l8utCmPQ3M6dLlHKT4ySRnQE5TVAAAE9K8n8TWeaBUArTRPb88ADJHzhiOWIYgW7LAFkZhfSDCDlpVCCwD/IydDiSM/WzpIl2OD9PDu1mGx7hrs/KvsF8iFI0ZMcd1WnSVVpPslotJE3QDNQso/tWPGfXtkJokbYFF4vdAzMz/GZ0PY08MC4yMEd9f8Z2KfapkRvzxBy8SjahL4laJRC3PVSIYYGDYIgtNxXozMyr1IiqfWCWwrRBvutwlaleM7zqEMJXGMP+V1j46uMjR4WCto6MdAmqBPu4YWLb7adLN7dlCqgCErwFNqlVNFnypfTC34JD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(376002)(136003)(346002)(39860400002)(451199015)(6486002)(26005)(2906002)(86362001)(36756003)(6506007)(6666004)(478600001)(83380400001)(38350700002)(6512007)(38100700002)(52116002)(1076003)(2616005)(186003)(44832011)(8936002)(41300700001)(66556008)(4326008)(66476007)(8676002)(5660300002)(66946007)(6916009)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NJjMiQBdlJ3GFWqyhJYV66QCBJDeVSxsuC9g2IL1C8kY2yB9dDQIBvHwz/SS?=
 =?us-ascii?Q?mE51Jauq7w2n/slgi+oOjUOHro0kfc3gh/uwUEd8s5wPQcQ9j+6RaFzLL3QN?=
 =?us-ascii?Q?HXwmcOVoYig1d0BLtIXf97d3P0Ipx3yj+AfxtRcQY/67z9kmtKL6XBBbuVeD?=
 =?us-ascii?Q?PQlHgQF1IjSKmDpKARjDart6AqGymAZIpQrGXcP/whvIgc4qLxS81++snxl2?=
 =?us-ascii?Q?ah/ZKTAMdBh2GwW/U9xYB77RA0hh0xSocy4pf2+CpQaQY2o54nZaAkOsLgsW?=
 =?us-ascii?Q?+haGMZv2cZLMggDptWLwoN+fNDxNpgXZ2DUYRdRFpynLqcgeq+zyBf5wiywt?=
 =?us-ascii?Q?iLmHKVTpe0Cf1EDDjWQV1nsKd+ftu4hpi6gfI6OT7qWXCg5hO6pymdfM5l/e?=
 =?us-ascii?Q?iOVYbM8TqKdbXhNm94vc3JqlHD3wCGJ1UN3IXcZc0kkGyrECHRR5xEQ83VoL?=
 =?us-ascii?Q?zpNuqzwGDEFz+5/RveW9AbIF0CHcpICTnX3qo2FJxlIMQAJ5lfAEumzRuWPW?=
 =?us-ascii?Q?+3fe6kw/Pgi97zhDE23t46p9A74PvIe6zR2duFNaFDWcAyxFZb/LtqfCoBxX?=
 =?us-ascii?Q?+5ipI+AlUhEWUSUgR5eQGLPcxkzeuUqbwCuVd9hOO5wQnhfRH3C2A/Qk3GaK?=
 =?us-ascii?Q?pcOTty32g3W+txSRB3dh2Ex+SdeY5U/I/C5UGqP1Tye+0WLPYnV+rG2BHc96?=
 =?us-ascii?Q?54FKo6oRiaM42bisVVpkq2b9qsSPXZURW1XICKf5iJWu/DTv0L9Ja9GAkMos?=
 =?us-ascii?Q?iiqGF3+iz6KaILfnEpR7BaUg6Xo98fjfqLrlMdLQ9rBEeGC1D1kCgar8vALT?=
 =?us-ascii?Q?jSDPRTL/lmsNwj5pxchUG/wXCdnpDDRn+vpfC5f9ycD+5a+uCOP7Fk/3iMki?=
 =?us-ascii?Q?GZb4wPqdOgrPnhG28xQhO52dNetplYDrp5EBJVLmuXmMbzza+PUor2zLbJUX?=
 =?us-ascii?Q?F8zVIFhiIwqWvEOs5OEJDFuYHVrQUs+3eLsfNotMrUo53wKOeMGMIzMZ6CW9?=
 =?us-ascii?Q?M8dZCvvt/KixeWbyyL1YaKpGTLkT3rJC52sgSoylnaZTxqDyY431CQik7b7e?=
 =?us-ascii?Q?S5mdKPT73fqWDpuG8iKttPuG7v3NuMJZLganUyJg6v0qxSZVIeGgl2S/XLZ6?=
 =?us-ascii?Q?mGw4lQcRnhLj47bMqClIQEuW85VmQdpT1uE1Rfe926ze0wP+p2C9RMuCb/eI?=
 =?us-ascii?Q?HTKEcQ4Miots5o/U2hfubpMShthfy0Rzj+4IVGqntjaXpx4Ro1hBgHDJh9HG?=
 =?us-ascii?Q?HvOgh5eNsAAy5EbAT4Rs7XiEyhCgZ9nLQ+Me3drzqQAB7Tc8GxtplirvunD7?=
 =?us-ascii?Q?bqaRTjD2fRPaeQD0Cav/uANoZLxSHu4w9iwAPhI+68kgJyG+O2MBdpMBSEJU?=
 =?us-ascii?Q?9Uq2YfBgOxTc+T2c3trxJ5MKiZVgeGead9tgFVwEhmYDsnPuf4C6t1K29xef?=
 =?us-ascii?Q?oFmyRxC5O6J4hH6N/vny90WWWg3rH0D5kl5BfmEnajl2woThTwRxC+goA8P1?=
 =?us-ascii?Q?QyjpWHcEAJdNnZ1OhpKzMOKDWoDfQ9NuLPGtMEPHBaD8WUyOG0F/7/lfrExq?=
 =?us-ascii?Q?Xooab0pfnkkWXUqUWf10JuE94MzQHrnPnGgaaFI6JrPNZNFKIPk9YbMsuj+r?=
 =?us-ascii?Q?kQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86cabc6e-59e1-4ccd-c3c8-08dacbc82c6a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 13:56:22.7001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t4RxxZlnucoBlkrb6Gri3xSms1/Le8ZIragTYVkoV4xDxuI60k8zi6B2+G3eBGxYXKU7RvHpwXiySARMcexABA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6829
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some definitions in dsa_priv.h which are only used from
slave.c. So move them to slave.c.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h | 42 ------------------------------------------
 net/dsa/slave.c    | 42 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index b7ec6efe8b74..aa685d2309e0 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -15,51 +15,9 @@
 
 struct dsa_notifier_tag_8021q_vlan_info;
 
-struct dsa_switchdev_event_work {
-	struct net_device *dev;
-	struct net_device *orig_dev;
-	struct work_struct work;
-	unsigned long event;
-	/* Specific for SWITCHDEV_FDB_ADD_TO_DEVICE and
-	 * SWITCHDEV_FDB_DEL_TO_DEVICE
-	 */
-	unsigned char addr[ETH_ALEN];
-	u16 vid;
-	bool host_addr;
-};
-
-enum dsa_standalone_event {
-	DSA_UC_ADD,
-	DSA_UC_DEL,
-	DSA_MC_ADD,
-	DSA_MC_DEL,
-};
-
-struct dsa_standalone_event_work {
-	struct work_struct work;
-	struct net_device *dev;
-	enum dsa_standalone_event event;
-	unsigned char addr[ETH_ALEN];
-	u16 vid;
-};
-
 /* netlink.c */
 extern struct rtnl_link_ops dsa_link_ops __read_mostly;
 
-static inline bool dsa_switch_supports_uc_filtering(struct dsa_switch *ds)
-{
-	return ds->ops->port_fdb_add && ds->ops->port_fdb_del &&
-	       ds->fdb_isolation && !ds->vlan_filtering_is_global &&
-	       !ds->needs_standalone_vlan_filtering;
-}
-
-static inline bool dsa_switch_supports_mc_filtering(struct dsa_switch *ds)
-{
-	return ds->ops->port_mdb_add && ds->ops->port_mdb_del &&
-	       ds->fdb_isolation && !ds->vlan_filtering_is_global &&
-	       !ds->needs_standalone_vlan_filtering;
-}
-
 /* tag_8021q.c */
 int dsa_switch_tag_8021q_vlan_add(struct dsa_switch *ds,
 				  struct dsa_notifier_tag_8021q_vlan_info *info);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index d4c436930a04..337cbd80633a 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -29,6 +29,48 @@
 #include "slave.h"
 #include "tag.h"
 
+struct dsa_switchdev_event_work {
+	struct net_device *dev;
+	struct net_device *orig_dev;
+	struct work_struct work;
+	unsigned long event;
+	/* Specific for SWITCHDEV_FDB_ADD_TO_DEVICE and
+	 * SWITCHDEV_FDB_DEL_TO_DEVICE
+	 */
+	unsigned char addr[ETH_ALEN];
+	u16 vid;
+	bool host_addr;
+};
+
+enum dsa_standalone_event {
+	DSA_UC_ADD,
+	DSA_UC_DEL,
+	DSA_MC_ADD,
+	DSA_MC_DEL,
+};
+
+struct dsa_standalone_event_work {
+	struct work_struct work;
+	struct net_device *dev;
+	enum dsa_standalone_event event;
+	unsigned char addr[ETH_ALEN];
+	u16 vid;
+};
+
+static bool dsa_switch_supports_uc_filtering(struct dsa_switch *ds)
+{
+	return ds->ops->port_fdb_add && ds->ops->port_fdb_del &&
+	       ds->fdb_isolation && !ds->vlan_filtering_is_global &&
+	       !ds->needs_standalone_vlan_filtering;
+}
+
+static bool dsa_switch_supports_mc_filtering(struct dsa_switch *ds)
+{
+	return ds->ops->port_mdb_add && ds->ops->port_mdb_del &&
+	       ds->fdb_isolation && !ds->vlan_filtering_is_global &&
+	       !ds->needs_standalone_vlan_filtering;
+}
+
 static void dsa_slave_standalone_event_work(struct work_struct *work)
 {
 	struct dsa_standalone_event_work *standalone_work =
-- 
2.34.1

