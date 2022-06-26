Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E20AC55B1BF
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 14:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234432AbiFZMFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 08:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234413AbiFZMFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 08:05:39 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2046.outbound.protection.outlook.com [40.107.104.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ECEF13CFD;
        Sun, 26 Jun 2022 05:05:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lulTXRz5zTAUzdZOJRqXkCKIMcnrudt8F79o/h/FOaxmKx7v1qzuihALYQXg6f1j3JfF7UqDlp6O/bb3JeSd78uivJEL3kNg9YYHvtnxEvGKvRIhdKOFJ3q33x3+/xtp0emk5tAOTyJ/AtWho5OjNYFqh1yw+zUzdzT7NM/aufBjBE15wQcK+Z5s/ejixZVozoMqUpJBofvmKYtXlfYvPfJQia0xrdTHY2N42uTvuiKlzUvTuMH+c9fuml7kSirThXgFoQ5I+80Y0JntZ/3VayDxKsxg0JIPW5uPhpkI2LxQySMI96DtLDWvsQiqBTr3PS3si9xpgSfa27jkRJWYmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u2CWzUwfTmi69rRRopT8r58PkrAYFlpdBLCv2NGY408=;
 b=MjuhKaUbokVcYHM8s/4DyUvN9F+sRwBN4ClQivFcN0yr33A0HGoM7dpzbVUscn7hcWbpKvRfNcX0OwpcoGwvfzkFUZ5v5IsrTaVJplIZ/Lt3yBPu9rI4IxpSGaxWtq6f+SUvhhANyl/UBVGPz2lktyPMmiR7qbVWRZ6W/kMcIW0r7ocx+V/uMSGyFnz4gNCM31SNTnqlr+tR9UqzSIlewXgB9KF60qB6mj9TPeNlXJ3vlcampFFQzfr2CFLDh3WAx+x0yEaQKJ1XqjhGdntglWmy4Zuk+i9uwXcOv4QM13uvKGXCxg6UCY4KZd/85kNgFsGKPzlZRYVkczMkUQ3I0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u2CWzUwfTmi69rRRopT8r58PkrAYFlpdBLCv2NGY408=;
 b=CZ3w5orFgwza7m3QWA/TJPlSGfR/2N1Habg0pjA2gxHBNl93A56HTrcR4irl+dyj6lS+PukWmQ52qoBRQ/7GsA9qpH33IfBQr0vZV6OxMQXewlYVdAiI4xun8Fq2vuFZbNFcmibLYsEuYjj4fbdymjBq7J4SD0dVx+nGNrBWxeo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4273.eurprd04.prod.outlook.com (2603:10a6:208:67::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Sun, 26 Jun
 2022 12:05:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea%7]) with mapi id 15.20.5373.018; Sun, 26 Jun 2022
 12:05:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/4] net: dsa: felix: keep QSYS_TAG_CONFIG_INIT_GATE_STATE(0xFF) out of rmw
Date:   Sun, 26 Jun 2022 15:05:04 +0300
Message-Id: <20220626120505.2369600-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220626120505.2369600-1-vladimir.oltean@nxp.com>
References: <20220626120505.2369600-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0401.eurprd06.prod.outlook.com
 (2603:10a6:20b:461::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e638888-8b17-41cc-9419-08da576c2e2d
X-MS-TrafficTypeDiagnostic: AM0PR04MB4273:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PXu7nhXmROO2jlmpYO7W62K8Xcn34La/350JdlmEcWhpSktYF6vdf1rxBXqvKIPufH3ukwNOev4GDS3AcmdLOpfxGhMmtCYosG8Z73lNUR7YJNrexVrdwio8Q/6DK9iMkAVJOCGmTzQDKPUjfa9ynZ7IGPv4GqgjeYtIrKvkN0LyoKx6qAzmmLNANiJRveFeFM+vv1SOUKLQi0KPEOdo0fmBtxDtqqf48sn6KccqNIWFbK+ROclElIoFGDTidycuKk7APkVwB3j3sDe8AMOuJmkWpas8eYSnr845dTeT9337R6zQQUfQGEWsE6YtnEECtkf7LRDvrAVa69gf5IOI3yYZl0am5z48jPhIOXagvbSpQ5CdBus+vnR8Mjx2AoUSxwoBE0tH73WOb3gYVK2gr1aE26whvYAsqx+N3YhOUNG6etIGX0/IrcIPIvl/4Ys3exo3C+OhILOnhdKp6fNy8KCHUsJkKm1ELuL4r7CpK6bxMeqbliNGwvKxJ+QscH3yZqWSPdsw6FoCe0royl9Fq4ZgODy7N8UmjXDL4r8JbjzUUToUbCxC3wubQG6+T4SVMDmPkwoGhV9rOBmy/TCzvctOqDWHq3uMiW3r7i57nAW8zU+LZG7vIp3LeGKG8cei7619cYVO64EXpk7ODgzjP0O9x1ko6IuG78jhQTFW6xVdhmjcYECAhjOXhmvudd2bjr7+HJdByCuL1Im7BL7UTUODTKXD8fDZbElJil03Y4MrC5wUQZ9yzPy1wILo5TquC3GIL89WzGXqh25AhjOAvJKorv7yxP6/2o/v3neXNN8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(38100700002)(316002)(83380400001)(86362001)(52116002)(2616005)(36756003)(6506007)(38350700002)(66556008)(66476007)(66946007)(4326008)(8676002)(5660300002)(8936002)(7416002)(1076003)(186003)(41300700001)(54906003)(2906002)(26005)(478600001)(6512007)(6666004)(6486002)(6916009)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5SuPhR8HpcxDBQxxZ32m+YUdHH3uExxBIYdGdKfKuxYCXrJT+4txK2FtUxHT?=
 =?us-ascii?Q?X/+GrWSZYmquMWiZc6GIjBHZZNr3OVOoVR0F1NyDv83kkMHXj67NVWloMHIe?=
 =?us-ascii?Q?jx004Hv/jYFw8XlK1vjhIWwcax74bY0cKBjZY+iRf9gSaiAnma1BL2bEhJD/?=
 =?us-ascii?Q?2oqgnR0TALa+VXd009VcgTIxwCQLPC/pzcPHr3du3BC9lZlE5Q26jHzPCv7s?=
 =?us-ascii?Q?ls5aMbB2Dz3HdeGTBOGSAhdo2XsOXBzYimiYVhIkC4a+yYPZ8ZaSoSq/Oasg?=
 =?us-ascii?Q?ewriR1uRsuKQPX8b6jIzTwgSCxBqHocZS5xpHHzZ8y9nCGyPc+TjSlnMokdA?=
 =?us-ascii?Q?Vj5x8Kx21pPcsAyUVJe9xheC/ErQb+zyOlyhPz+3TWRWi6xGsZpmR1FWcUpW?=
 =?us-ascii?Q?FrQo620AOi1Rp1Jfd0VtTgxXDFVmS+ZCBav5BttzvReXfKEJSwfaSJgdgukK?=
 =?us-ascii?Q?Y2tRN4ZqetW7FmpCDhfmQmRMprJuxIRdWTtn9o/Xz1jaa5kwjiQgfHXG6XFn?=
 =?us-ascii?Q?tyCsq6baCB989HTVkTf1dLrDYf9cLKDkwP0TE6Bjq7voJDSUiw+JHnS4JkNB?=
 =?us-ascii?Q?K6gYtLG03UMd5f9d8KIwcCXeGcpCIfe1un50ZTUYMv1kMLY9kcrUWVA42/av?=
 =?us-ascii?Q?4Yazc7R5thUcvh28rrU970jj8DIHvzVfQxxfeclEyRnx7+Rd94oAJyDfN/f4?=
 =?us-ascii?Q?L4C+hXnG1aOK73xgLAmtEDK0bqHf5M1p4DryRtwQylnQp+K9aZ35UOQP+puJ?=
 =?us-ascii?Q?7Ze5u2q03HkYclCnHPCfVOwIUjaa1858hLGGP3Guc02USrhRBaDuCcQVLfr0?=
 =?us-ascii?Q?J5gMB06z1/mX5KsVPS8GfVjKm6DzUonaXNT42wCYe6Yzh8seg/B2MHcLy+Vp?=
 =?us-ascii?Q?tsmZy/FlzWsWjd0mFcEFyfIfEuzHOKXx3CIG7vbmifo+1mNjwichwe4PqbXO?=
 =?us-ascii?Q?rt2yeGQIU85w4v2th/PvfIHoFT8nBta8bU3dwapkCHlobmH701v+llJ8EdO2?=
 =?us-ascii?Q?Y5QmVq8ZM8gAYrJDR5HlYNFkeoxWNsDUTvJdIuS/R7cbsDniqTrQkBkBJ3AT?=
 =?us-ascii?Q?MIC3hHlrjz9yhCAgsK1J8Qhl/Mr9u0vEjtLLvbSesd/oM8woCyvg9rYD7Hqu?=
 =?us-ascii?Q?1xrCaACxKZqEkrfadg9eSKxiBb6bXRbKYT/pFbxHzThHeOiVDUApGQg9OyDC?=
 =?us-ascii?Q?abGZ6EUQXFlaVi9JkP8UWypuDhT99gkH9j/07kYdk9IqeJ/KQve7Hei1nViv?=
 =?us-ascii?Q?12JQUdTEQtC014TSmzqFac8UHEBkD01xlNik9Hn6kf2rKQCuyGape8D1RzHm?=
 =?us-ascii?Q?zre1WYv+Qcv8gupRxn1QlfEosD996FXqoLkCh4E2gjurSAHh1lsNcc+DwAdd?=
 =?us-ascii?Q?YWOvDvX5Z44LXnKjffWwKsy3QjctLZOmGfpF+dYmAoGDjHDHZwGLcGkTgGFg?=
 =?us-ascii?Q?pi5v7gvOrDevoUHfy0lN3b18T3MMXMJiccmcoE2v24X8D5yzSoxIpRo1waS+?=
 =?us-ascii?Q?gD9ufLXlv2ha+eP/789dtypAp0HYIV0bmNTrNi6uFy+x7HQuEFQVGXEucPyB?=
 =?us-ascii?Q?lziWT9nM/wrM8fnsJUudWhvUaAHKtuX7PAtxD4xoJb47zLmJOBiBXTMovQMd?=
 =?us-ascii?Q?eQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e638888-8b17-41cc-9419-08da576c2e2d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2022 12:05:37.0732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c2d+Fk/vkXcgyqRICi+/AXQdTF0KMJ1ygX8/WfM7X2l8zQyn3VOMUhzWUKuC16a4RREl72zspvnCyq1FDT8v1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4273
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In vsc9959_tas_clock_adjust(), the INIT_GATE_STATE field is not changed,
only the ENABLE field. Similarly for the disabling of the time-aware
shaper in vsc9959_qos_port_tas_set().

To reflect this, keep the QSYS_TAG_CONFIG_INIT_GATE_STATE_M mask out of
the read-modify-write procedure to make it clearer what is the intention
of the code.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 44bbbba4d528..7573254274b3 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1204,10 +1204,7 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 	mutex_lock(&ocelot->tas_lock);
 
 	if (!taprio->enable) {
-		ocelot_rmw_rix(ocelot,
-			       QSYS_TAG_CONFIG_INIT_GATE_STATE(0xFF),
-			       QSYS_TAG_CONFIG_ENABLE |
-			       QSYS_TAG_CONFIG_INIT_GATE_STATE_M,
+		ocelot_rmw_rix(ocelot, 0, QSYS_TAG_CONFIG_ENABLE,
 			       QSYS_TAG_CONFIG, port);
 
 		taprio_offload_free(ocelot_port->taprio);
@@ -1315,10 +1312,8 @@ static void vsc9959_tas_clock_adjust(struct ocelot *ocelot)
 			   QSYS_TAS_PARAM_CFG_CTRL_PORT_NUM_M,
 			   QSYS_TAS_PARAM_CFG_CTRL);
 
-		ocelot_rmw_rix(ocelot,
-			       QSYS_TAG_CONFIG_INIT_GATE_STATE(0xFF),
-			       QSYS_TAG_CONFIG_ENABLE |
-			       QSYS_TAG_CONFIG_INIT_GATE_STATE_M,
+		/* Disable time-aware shaper */
+		ocelot_rmw_rix(ocelot, 0, QSYS_TAG_CONFIG_ENABLE,
 			       QSYS_TAG_CONFIG, port);
 
 		vsc9959_new_base_time(ocelot, taprio->base_time,
@@ -1337,11 +1332,9 @@ static void vsc9959_tas_clock_adjust(struct ocelot *ocelot)
 			   QSYS_TAS_PARAM_CFG_CTRL_CONFIG_CHANGE,
 			   QSYS_TAS_PARAM_CFG_CTRL);
 
-		ocelot_rmw_rix(ocelot,
-			       QSYS_TAG_CONFIG_INIT_GATE_STATE(0xFF) |
+		/* Re-enable time-aware shaper */
+		ocelot_rmw_rix(ocelot, QSYS_TAG_CONFIG_ENABLE,
 			       QSYS_TAG_CONFIG_ENABLE,
-			       QSYS_TAG_CONFIG_ENABLE |
-			       QSYS_TAG_CONFIG_INIT_GATE_STATE_M,
 			       QSYS_TAG_CONFIG, port);
 	}
 	mutex_unlock(&ocelot->tas_lock);
-- 
2.25.1

