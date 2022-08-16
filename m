Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F100595DD5
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 15:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234955AbiHPNyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 09:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234250AbiHPNyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 09:54:20 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80055.outbound.protection.outlook.com [40.107.8.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701C032DAB
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 06:54:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hshEz2Ipda00b1mDO+/ALmIiDQrxe1Q1/pv+KRC42xP2/yCygbponn4U8TCbAdFsBxBx34oCqUnsu+HHcYSaIFhKTG1RSsSW1Ps7lVILU+2l5ihn1YpktZIty3avYEJzPWrtzG9JV731yolR85f34XUqb085DKgtE3BaB2TTrTt5WfmSeJyvfhz/U22tovqBklhdtecztLx/YTEIxrRE5e9mMJ0eYDmG257wLL2AQAUm+pki1Gxrkplm/pAjei5iRYVTq6mvCv/J2uk5kb9TxxjXUqqM5kysX0j4azXoNaRwASaB+RZHvzmVb4QR9V7M4qF6nFTjCjlo2eLcMDF2qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ib8qaFuDLrNj7qsoQXmTrXb8Iv8tOInbxCxJMkL3l04=;
 b=HTKlCtWY6tkTBcn9VD7cd6WAqm30CXyCdB4bmvC7+D6v3V0lr98UbBeUHOxLjEZ41AD8/p0M584MIkWLn+1JbF7ZrjZiC5TzRtTyzOP7Hr7Dt9HtO8t7pqafH/6YR6nlF/mk2vZW1erOWDXs9aQc3frfzKxFP3txw1mRWVUUki2NNw0+uKNZ0HfMoSeoNsrCBgg3TYQMRZ++zfa8hyHWNh8dpQziNLdNaAJG5V9NwGrPbRbcyT8x/GSKjmf8oTi1/5gx1Mdx+VdgoUSOf7AiPeQF2YK5kvyt1EmoIHlzI1FT5TfwOXoOCeX/67cSO9JDrbk378li/jiPsJCMqBVGuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ib8qaFuDLrNj7qsoQXmTrXb8Iv8tOInbxCxJMkL3l04=;
 b=CZrfGHHaUtY27sJgh9dg1zMo85s2RhFsGXHsDDZ7EALiw2RUpV1eU/MUNzFV/U7wc+oHsT4Bl80z3u4yVFo8a7azWfizLV7lpBUeEyHcnu7sbkZ2agIZnw3aIvlRPlwIyjOf4THttABbo8SCLBXvAx3whtqe5FbR2MD0BGf+nks=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB4583.eurprd04.prod.outlook.com (2603:10a6:20b:1f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.20; Tue, 16 Aug
 2022 13:54:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Tue, 16 Aug 2022
 13:54:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: [PATCH net 4/8] net: mscc: ocelot: turn stats_lock into a spinlock
Date:   Tue, 16 Aug 2022 16:53:48 +0300
Message-Id: <20220816135352.1431497-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220816135352.1431497-1-vladimir.oltean@nxp.com>
References: <20220816135352.1431497-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0244.eurprd08.prod.outlook.com
 (2603:10a6:803:dc::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9ba0200-c92e-4303-c940-08da7f8ecf0b
X-MS-TrafficTypeDiagnostic: AM6PR04MB4583:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z77Ku+OIlTFcez38wk0cYJ0a7a/7TeNCCZDw2VTDM07b7NlS1o+I6SkJijHiRUFMZgnv4IjGN9JqCOp8fNw6oidysyO37ThN33pC23OsXS2hp3UMnDxQEMD7EgsCEEMdJ1xk1txBoXFkC1V4eRzh0qfP5EdqAiIkOR+LFRzt5vGnCoEKlexUTcauxC+5A4HI6/bCt8F1FShlvw2+nVU6vPXp35PrkM8damq68y9n++21fB7rJPngPIkrYxVK1B1YjWPWZvM4nWBFWoar7lWpiLXmdGF+L0g2CMU5kZS2zn8R+w+SfvWZwKOOFf7p4uZzS7irwHGb6+16HdmgbPJ36u+F6SnRM6d7NjXwH1nad3pTiWO4y+/ydKwHGf1bfMmV2FETvDABlmfnSJOSs3bq/+lUzSTq5pfjwWz4rpY9TU0XAfnuDNwpFW1kyYb+f9cjc9wpaxXOwTaMrZ3me83AYYXhudmg3cIBLhiOMWJt5MFP8rcHx/48EUoNvthWDX9gtZMjUYMCPPdTdOYGibgzpYDTvzxSQzyOHRv7TwaThjSQ3sQXnb+JERqNMYbmX3HjuH2FqEhtpGGGT/8T2p0LebuLA8xkQInvspTkM00gz3vgJGzSV9foieajSbPtHmbxENRRL+X5O7m4e8Hi6zAWQN1a787fAjuzw5lIkHiqCGMtm5hJh9onGPCAhHs0s8PXkNKOyae4bmXaWWfZXtXDSGO+iFU3qvUVxP00zHxxI4pgvGNZvLVkI6v3Wcelt9exlWkQLko50FMnli7n83T0jWcZJZpp79cbLSHdgs9SzNk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(396003)(376002)(136003)(39860400002)(86362001)(478600001)(41300700001)(6916009)(38100700002)(6486002)(316002)(36756003)(38350700002)(2616005)(54906003)(83380400001)(26005)(186003)(52116002)(6506007)(6666004)(6512007)(66946007)(4326008)(2906002)(8676002)(66476007)(1076003)(7416002)(44832011)(8936002)(5660300002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n1V1E068z0gwd32ij3hwGXGrb7jSQByNtW0Jy0xbKKERM1haXEgjn1Y9dvQA?=
 =?us-ascii?Q?3Lt0TNMP+eHimnoNvf03ggkMxSMf9PPj7dmZNdoiB7A3FzfTOJR2aSGWNhXd?=
 =?us-ascii?Q?lI7PtrKibyCia6Zb5dbb2y3rpBBZI3NUvWUAmtuBw4F79t2m1mFGr71ROn0W?=
 =?us-ascii?Q?Me6Xz0TjDiqkpllNUI08jiiv/42WVZXAfnLv3AUwKenuY9jT2aCsb9KDHKCr?=
 =?us-ascii?Q?aQonQz5IJ09yNXzVaviZzk1jpRrnjYa9MAcXOojcH16q4iQA+NcSfEknx/Va?=
 =?us-ascii?Q?Hp7wgtJMLg2MWKQDCffoejKPFyWjsyrlLM7PeHo8G5oTili8M0PEhRD9EN0k?=
 =?us-ascii?Q?bicC4sf+ht8kV2/K3XG8OF64bIDvsWiqB1Mi0oOkPVddf1KXMZORMvBaxoId?=
 =?us-ascii?Q?60EYAwhqNYC8pFCFCnnkMUworqh9igUH8bxlttxOhvqF2bl0F0W1mhL8RoMb?=
 =?us-ascii?Q?9WZFKRRIbi1GEYyWPBLOLtCh28JOIIsVIGU1QGdH/2ERbQFzD76DV6GkWjlJ?=
 =?us-ascii?Q?LH565c3vvOjXJdGyzGPl/OcHOYt4n+pNtxSlmYe+PySg82OBNWVVzrAoI4Kq?=
 =?us-ascii?Q?z5xFYNihl6pDu+LkwGTNli9Z0BSiz1RupfKTn13GaPEuwcDayr79QOtBrept?=
 =?us-ascii?Q?Yxe+8BWgK6iEYFqpjubGYAed0AnuQ8MZzVa7QZPvbAHRa+FjkXgDHap4Zjoi?=
 =?us-ascii?Q?bOOkJlFdcdI+sDcQDaYcrWLW8PRxq+w/y7kmHpCCBbMZgFUYOwy+XOCmBy7y?=
 =?us-ascii?Q?/4F8DzfmOOkpkA+BYA45BCjAmC35Jsv/JsqjvW13RVd9PfbjhD/t1gAl5oil?=
 =?us-ascii?Q?oEADr4iop54pQF7V+DtvSecmsZhDI+ZKzXK8RpeiUpZAJHjlRYDanZiBybg1?=
 =?us-ascii?Q?2Pp7EXu4tUDPUXod2vKjGI2fcTx3WjwwWVvp8QLg9imIlhnxrd+3pvnxXyfp?=
 =?us-ascii?Q?lRAoExmeoQsoQ900wwJloCc5tI0a9xA/lHlAbNtgDnuEMCN7iENmVRlptJ2O?=
 =?us-ascii?Q?Y3kStB7DbPTzZS6OR10WAh6Pe3ptDJ+PO1NPwHBuIPdVwCTubW/8hNXxtqmF?=
 =?us-ascii?Q?0t0Xhh9GEJCwzoR1Jr+J2NpAp4uuqmpJDe9xmf75cMKaxZxavvSbkJiMwZl7?=
 =?us-ascii?Q?OGweQRyaZAYbFvlW9Y1NmiAwuNLZgm6/5Rkw+UwN0EJuWd79r78yhUIzRwQl?=
 =?us-ascii?Q?n47yjlhUqkxuQ7P5hFB3asO7hKFcHllNbRxoBkUfaDSOjwIMTF0G2/4X7qmj?=
 =?us-ascii?Q?HtIU36hE0yzEgJ1xjAv2WK7xH7+ze12sLTIPyVxd6V7TDXPVJAHM/zimdlFa?=
 =?us-ascii?Q?Mm6TsO/Q13PbsamABnCxKvxxgnZGLZryHA8I3LEzYJWMcjF4DFuJ+H1iMYDJ?=
 =?us-ascii?Q?P5i7R8TBEfZTO5N8zF3ZR4VelO0NRirhCqW3Qj5DbVrh60Xyi2lRKwjxVzwK?=
 =?us-ascii?Q?VeoApMuoXTrXMT/ViMutqHXvPEODZsyeaaA2i6akjAySAMrcFUutzgLQ0ZI3?=
 =?us-ascii?Q?2JNtrHsien1etzdJa2jsM7LEOehxa9IU1EmeJ3T1nAylUOoTKQWXpghMg87R?=
 =?us-ascii?Q?RQP2PR4o6gwriifyd7coweMpvu3X0kjg9Yl7fMsXJMW7httq4RNi8tNWZK2m?=
 =?us-ascii?Q?pw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9ba0200-c92e-4303-c940-08da7f8ecf0b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 13:54:16.3961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 01VNoLvQy0grKY6i1ZwNaVS+ucd06shMjfTn761ERDwt4iJ86UoQQeYL1aYkI4awqkR8y3YQGwerAxhQ/S/rRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4583
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ocelot_get_stats64() currently runs unlocked and therefore may collide
with ocelot_port_update_stats() which indirectly accesses the same
counters. However, ocelot_get_stats64() runs in atomic context, and we
cannot simply take the sleepable ocelot->stats_lock mutex. We need to
convert it to an atomic spinlock first. Do that as a preparatory change.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c |  4 ++--
 drivers/net/ethernet/mscc/ocelot.c     | 11 +++++------
 include/soc/mscc/ocelot.h              |  2 +-
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index e1ebe21cad00..46fd6cd0d8f3 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -2171,7 +2171,7 @@ static void vsc9959_psfp_sgi_table_del(struct ocelot *ocelot,
 static void vsc9959_psfp_counters_get(struct ocelot *ocelot, u32 index,
 				      struct felix_stream_filter_counters *counters)
 {
-	mutex_lock(&ocelot->stats_lock);
+	spin_lock(&ocelot->stats_lock);
 
 	ocelot_rmw(ocelot, SYS_STAT_CFG_STAT_VIEW(index),
 		   SYS_STAT_CFG_STAT_VIEW_M,
@@ -2188,7 +2188,7 @@ static void vsc9959_psfp_counters_get(struct ocelot *ocelot, u32 index,
 		     SYS_STAT_CFG_STAT_CLEAR_SHOT(0x10),
 		     SYS_STAT_CFG);
 
-	mutex_unlock(&ocelot->stats_lock);
+	spin_unlock(&ocelot->stats_lock);
 }
 
 static int vsc9959_psfp_filter_add(struct ocelot *ocelot, int port,
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index d4649e4ee0e7..c67f162f8ab5 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1906,13 +1906,13 @@ static void ocelot_check_stats_work(struct work_struct *work)
 					     stats_work);
 	int i, err;
 
-	mutex_lock(&ocelot->stats_lock);
+	spin_lock(&ocelot->stats_lock);
 	for (i = 0; i < ocelot->num_phys_ports; i++) {
 		err = ocelot_port_update_stats(ocelot, i);
 		if (err)
 			break;
 	}
-	mutex_unlock(&ocelot->stats_lock);
+	spin_unlock(&ocelot->stats_lock);
 
 	if (err)
 		dev_err(ocelot->dev, "Error %d updating ethtool stats\n",  err);
@@ -1925,7 +1925,7 @@ void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data)
 {
 	int i, err;
 
-	mutex_lock(&ocelot->stats_lock);
+	spin_lock(&ocelot->stats_lock);
 
 	/* check and update now */
 	err = ocelot_port_update_stats(ocelot, port);
@@ -1934,7 +1934,7 @@ void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data)
 	for (i = 0; i < ocelot->num_stats; i++)
 		*data++ = ocelot->stats[port * ocelot->num_stats + i];
 
-	mutex_unlock(&ocelot->stats_lock);
+	spin_unlock(&ocelot->stats_lock);
 
 	if (err)
 		dev_err(ocelot->dev, "Error %d updating ethtool stats\n", err);
@@ -3363,7 +3363,7 @@ int ocelot_init(struct ocelot *ocelot)
 	if (!ocelot->stats)
 		return -ENOMEM;
 
-	mutex_init(&ocelot->stats_lock);
+	spin_lock_init(&ocelot->stats_lock);
 	mutex_init(&ocelot->ptp_lock);
 	mutex_init(&ocelot->mact_lock);
 	mutex_init(&ocelot->fwd_domain_lock);
@@ -3511,7 +3511,6 @@ void ocelot_deinit(struct ocelot *ocelot)
 	cancel_delayed_work(&ocelot->stats_work);
 	destroy_workqueue(ocelot->stats_queue);
 	destroy_workqueue(ocelot->owq);
-	mutex_destroy(&ocelot->stats_lock);
 }
 EXPORT_SYMBOL(ocelot_deinit);
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index e7e5b06deb2d..72b9474391da 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -752,7 +752,7 @@ struct ocelot {
 	struct ocelot_psfp_list		psfp;
 
 	/* Workqueue to check statistics for overflow with its lock */
-	struct mutex			stats_lock;
+	spinlock_t			stats_lock;
 	u64				*stats;
 	struct delayed_work		stats_work;
 	struct workqueue_struct		*stats_queue;
-- 
2.34.1

