Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E551F3E91C9
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 14:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbhHKMqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 08:46:01 -0400
Received: from mail-eopbgr70052.outbound.protection.outlook.com ([40.107.7.52]:64836
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229617AbhHKMqA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 08:46:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b2XB1mRPL+LdYaUg8tykCe2WxY9JFtcQUI6O0mS4w1JjodGIzETSFlpFEEl7xV+2GHjgN+eW2OjyaPmckLlz6uKRYkXK/0NCTf+nAZWWulsoi4wpTHukkTzbxxd+DTCUyLt6hcH5RVkj/GCUPaWqt4i0CzS68O2EZY0ToHmjAG2rRMiw+j0xriGUbR4w+xGY3fvKkiNTVIV8ZMQQvCUyQvgWrBgZMPwgHO9YSqhwba0CZigXLPzx22j0jeiZ2dAV1PEi2GPFCxl1elSsBlQK22zTZCMdIZSkjP5S1sH7sB1JROC3tnaSsLXtovCE9ob3WgEeyFhH1ji82kOdnURE6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fOOsK4aR4Ae3Uto91F/CbSG7gg7S5guLb+GFE0uWqKI=;
 b=Hp36rYTBrZpfm2CF7YkOd3FXtQkmJhV+aTPIwty1XvD8Z1fSd9pgNFyCasfW2zcWA2u/jr4r79PYlGu9P8e4GTq08es6LQMnj76zizMoJ4CZYAneVr0QB94hnOzX3JXN08ZFt0tJe6fOXVK7Pwt0bunmIxyOXudmgWTFhDlt1QHYB1lE3WE4vnytUHSZ5pZ0zFypnQtHhI7Oe/T6ag2UJN43iBDmhQmnunlN3X1CGw/p6VEmXdwXqCessDfKBOZYmUwiOj478boYI7xe52w1fDqOQVSzY3S+aM6qdvYFyVjqePUvi8pnkSm15t/byVJ6L+Oi/Lm8ZDqh8kzFdJkG2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fOOsK4aR4Ae3Uto91F/CbSG7gg7S5guLb+GFE0uWqKI=;
 b=MMDmAeaBuh4QJcbMjOs0pVOgAhKhHFTXc+frVmUboFTFUKnevlzVjRQAZAsP+x4ug4cKT0qql2ElMUhABSBBj+lGCXk+a13SrT0QOCE3FHKRGA7igTjzUXscVMlK33VcpAO30DwoJi71KKX2j9wogiXHV/NSyz3s67S6raVZsv4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5344.eurprd04.prod.outlook.com (2603:10a6:803:4b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Wed, 11 Aug
 2021 12:45:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.016; Wed, 11 Aug 2021
 12:45:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net] net: dsa: apply MTU normalization for ports that join a LAG under a bridge too
Date:   Wed, 11 Aug 2021 15:45:20 +0300
Message-Id: <20210811124520.2689663-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P190CA0012.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM8P190CA0012.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16 via Frontend Transport; Wed, 11 Aug 2021 12:45:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85869e51-2148-43ec-3eaf-08d95cc5e9a2
X-MS-TrafficTypeDiagnostic: VI1PR04MB5344:
X-Microsoft-Antispam-PRVS: <VI1PR04MB534432E4700FFDCA3DB4BD59E0F89@VI1PR04MB5344.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xfp9yUgR87K1nFbgnN7EaFjgBWBQXFzT6n0knCGZ7cdyOb7DcFaJ+ZaohOdWAlJlvxVGeqK9WJ+JNe4tiQJVGzQNDeC7S72esh+01xaQrDoNFmOnmF5qsu+HY5pqPHT3j54O9/lvY3dcfdYcK8AuDTLXNGHCVrWFgIsw0duzPQarYCZ3YpWCIxX2Xa62SIMvRYhc0ohhUZS/8AoCb8Z1PUrU355oqybK8XjuJbfq6UNyMFCOTJBwuZJ8q2dpGOWonoS7hbxbnTD69zL/FgubNYapfIqUqjNUhNP8Rs6fbEkxGwbzif+C8ZPTJRxgpES0kS7dXh+Xk6G5A6IESoc5oCA6iZAnY83doWna7jhe/26nHHJj10bApDZ67258KwyTND7JB0FWBZv2fXbwSudhXeVOYdJpEJH6eInxoKcZO24C2FF4QcZ2DotTmpL2xeQUEnGeutmSKcJJvBM3b/sidQYiMkx4ZwN64MOHpyM5gR6XfDTHcaxe4JSS3ho5vFNUnqP/s+Zrd+cG6Glbp+YTuFdDxTS1EbkSYP9z3ObEb8wYml11ymB4/0EHToP60CfYD/GtE3QLpDbcd5X0Dz0MiY/DP8xHZIvFgFpeOU7i7D9IKoFkEIUkjNNldISsif20Zq79cCKb19AnccUbjm3ccoS/UupbeUnbSaAPWzvoQ2tJwq+4WF/uHz0nrK0O+bcnEsICQfgJykyGxt/tEGJwWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39850400004)(376002)(366004)(346002)(52116002)(6506007)(66476007)(8936002)(66556008)(6486002)(66946007)(2906002)(6666004)(38350700002)(5660300002)(110136005)(38100700002)(8676002)(36756003)(316002)(1076003)(54906003)(86362001)(83380400001)(186003)(26005)(6512007)(4326008)(956004)(2616005)(44832011)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tQkP1iAqTFiF9DKNwUl1lVg74QQ0/XFz9eki+a0qX+023Lmf1PvzBCNC8yWX?=
 =?us-ascii?Q?e0BzMlJ9nLiyvbRfuWQ7wlIEM/Gcn4jLULc383vhisbjxfYjyVdVlJvq2gcT?=
 =?us-ascii?Q?83p0Sl6JfsV1A42f7hBSpjkK5GoB+M8EOZ5ppCH6bKPj3evgcQNr8fUYr26Q?=
 =?us-ascii?Q?+p2HgcZRr2PnSXwR+OiPIGBQy2d58LjiaYs14yfUo7JqYql8QAdiyT03HcW1?=
 =?us-ascii?Q?dFbLREVy1j1kCgXfhdwda+MdQ10WX8wrOEZFGEjVQcvy/0BSGLtsO2PzJdR0?=
 =?us-ascii?Q?xF8I4MnRY1xZ5sfMSRwjOBp/5hznQx4A3uVcTGeG+JumTr6u4KDGNMdpEixl?=
 =?us-ascii?Q?W2QABfB3z/q7RwZ78Gjt4trsVrTGi/JJx3iSxcH7l5CtoDOcg2L8wNGvDQdw?=
 =?us-ascii?Q?Xgwqz9OZkTEyzs0erT5DYUYixc+UtUnG9lTfWAhVEeSbRgEo5XCh5Q1/DpBW?=
 =?us-ascii?Q?5pUn4bhsvLF4oKazCL7QMnZGCacXeF/NpdQAu/Ui0ae1d6wjInPNuWhoTQUQ?=
 =?us-ascii?Q?83dSbNCyLdY7raFrEYBWMKGhOkBiKaaU0kbd25IoGqhLt6KdZdHXy/EOpGco?=
 =?us-ascii?Q?gUk3O078EEJ5DG/C7jcBrJY43RhZRNdxZ6hGDxn4/dYg8HtHz/Tum8HxBc+I?=
 =?us-ascii?Q?3MRp/y6Qxy9BzMhxLqGYFnvkB3Co75Y0MaDK6j+nZbwNVwTl0F/bNV06zQcG?=
 =?us-ascii?Q?Lis86JYjvlDZqv4Q+iHpCm0zfCtlLXAxuRsmfjgSHQbd4ZLCSMoQIYkuxUWQ?=
 =?us-ascii?Q?M3BhgjKk68Tpu0HkDmx2WHQiwidWCKIEu7rktJYG2ZA44pQ5uK57dm/NYJCm?=
 =?us-ascii?Q?No/E/fRXKJ3ikbPpFFXJIlaD+JJnznyuMfv9OCU7xpFzV+3NTNC8WiydGHPh?=
 =?us-ascii?Q?vC8el/13SvU+uk0TvXCOKYx/h025IubfEGpGXWwiLSu5zsZiBX9RvQdToiuV?=
 =?us-ascii?Q?eSG/kY5I6v9qXEBvHnnRev7y8G7VaB5PXzt7K9Y1WRoZ9KeiuItlWTrigA6N?=
 =?us-ascii?Q?Sad/US2IMoeJTB/2nbyMerKneg0rV//3bT2UaJ7G2KC18QtlGYIj/OLAEIJE?=
 =?us-ascii?Q?XoFV3C1Uo9WMfA1xH+b+HqvtK/TyF60n8G4+3b2UdHyiIqVpUwGjIT7akcya?=
 =?us-ascii?Q?oJ/5p7AJDkhHIp5XVpjnY5u7exnVrEY+26htkY1i6LuE2hJOvKXRb/DbQ+0y?=
 =?us-ascii?Q?7cys9in937TlHbb0/aOUadIfQumbuJSgJZd7woW+2Ey/Zkq8zSrjheY6O3uj?=
 =?us-ascii?Q?B6PKWG54Uf6EJ9PLnJakkT4HBmxrayv9/e+HewtSJ6NQU6vdY5lHjyJUaYgX?=
 =?us-ascii?Q?QsLJGdYGFUdqOYsSxWfbcTyH?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85869e51-2148-43ec-3eaf-08d95cc5e9a2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2021 12:45:34.9121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9oDPp4JSesmEOXhsU0u60TIxWfBg1DzACmOxz/qMbVDws/G3fCsKXEF14yAYIMkckSMrBaAk+Tay1sz21EDj0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5344
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We want the MTU normalization logic to apply each time
dsa_port_bridge_join is called, so instead of chasing all callers of
that function, we should move the call within the bridge_join function
itself.

Fixes: 185c9a760a61 ("net: dsa: call dsa_port_bridge_join when joining a LAG that is already in a bridge")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h | 1 +
 net/dsa/port.c     | 2 ++
 net/dsa/slave.c    | 4 +---
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 6988066d937f..6e01e796920f 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -325,6 +325,7 @@ int dsa_slave_register_notifier(void);
 void dsa_slave_unregister_notifier(void);
 void dsa_slave_setup_tagger(struct net_device *slave);
 int dsa_slave_change_mtu(struct net_device *dev, int new_mtu);
+void dsa_bridge_mtu_normalization(struct dsa_port *dp);
 
 static inline struct dsa_port *dsa_slave_to_port(const struct net_device *dev)
 {
diff --git a/net/dsa/port.c b/net/dsa/port.c
index b6208eecdf4b..eedd9881e1ba 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -386,6 +386,8 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 	if (err)
 		goto out_rollback_unoffload;
 
+	dsa_bridge_mtu_normalization(dp);
+
 	return 0;
 
 out_rollback_unoffload:
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index b08b2c70702d..124e01ca3312 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1456,7 +1456,7 @@ static void dsa_hw_port_list_free(struct list_head *hw_port_list)
 }
 
 /* Make the hardware datapath to/from @dev limited to a common MTU */
-static void dsa_bridge_mtu_normalization(struct dsa_port *dp)
+void dsa_bridge_mtu_normalization(struct dsa_port *dp)
 {
 	struct list_head hw_port_list;
 	struct dsa_switch_tree *dst;
@@ -2013,8 +2013,6 @@ static int dsa_slave_changeupper(struct net_device *dev,
 	if (netif_is_bridge_master(info->upper_dev)) {
 		if (info->linking) {
 			err = dsa_port_bridge_join(dp, info->upper_dev, extack);
-			if (!err)
-				dsa_bridge_mtu_normalization(dp);
 			err = notifier_from_errno(err);
 		} else {
 			dsa_port_bridge_leave(dp, info->upper_dev);
-- 
2.25.1

