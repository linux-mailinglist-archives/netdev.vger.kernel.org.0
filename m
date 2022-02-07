Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E1E4AC575
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 17:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243841AbiBGQZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 11:25:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387626AbiBGQQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 11:16:23 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2051.outbound.protection.outlook.com [40.107.21.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16216C0401CE
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 08:16:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f0kIIBuldKNeCD2V1fHiTm5JfDhQ1pR1ds6utzgrkzoDX5SF8ZoFxkrWQS56utuix6qv9jno6gQAsuEfHBKTWrT13JgvUL8CeT+15jaorxykTioM3kQ4EuP290cww9Vy0JndzI/DNSOwFbomz1Ty094zmInSbTZstQpM5nZZDC5rlNof87V25WlbLKmo/GOMsBpTzhB7MRDIvrXH/JGfLLgM+HYFVcJUsvcCND3ycqMxntxZjC2438kV5qNT8+Atw7+YGwhzy+RFtHiOroyqsorQAIWbRB+dfOqabfZgUDUTLdsoHLKbi4J52Wm3QrPQldy9//KxmHiqEpFnYmlQZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f70b8i1eG8i2jX+1ionxt88JLC3i3/8OawWiyuXZw2E=;
 b=c0NlmCN7WbNb19W5nwz4P/Xyo4FvQEjzafknavcAgGJJbbQj+JgrGSBWU+12obiDDEymalIASRZC6nRmqPDWYu6CycTZ5XxNFPIZZ03PjqcQkzIFJidKCtR1TjxqTXVU1Hseb735+HHlc4Vq1oknwPBVctc7K3GFruVbUSQN+FL07vK59/9ANXs2ZC9Vud2UXFV97QuMzOfD5g72jf3y6sPZlnQjCqMZmPbOlIbZUU6lGg8r8Ft8TZjRwgjZl+Yd+SjjiI7OcxxhiQqaiBs0waM4hYAk+PMf/MZlptSMTik48MHFrqYgHzTXZYkIXDvoMcnTxSia5sT8LrGTVoPFXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f70b8i1eG8i2jX+1ionxt88JLC3i3/8OawWiyuXZw2E=;
 b=YbiZePXeF1yErBw00evl3yZBK6T5uui0VBnyh0pI9zt0MNwcfOKRZ5SUJj9ERQJEBpVHes6+ye/kki+z0EWl8+UduBjEmwLs3oJ5xdipi6VzmJ97jmiBoAuq738QPKOvSnay+5I29CSKHJd3mG1o5zTe4O1bzbjrsbQiV0ht2lw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR0402MB3910.eurprd04.prod.outlook.com (2603:10a6:209:1b::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Mon, 7 Feb
 2022 16:16:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.018; Mon, 7 Feb 2022
 16:16:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Oleksij Rempel <linux@rempel-privat.de>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>
Subject: [PATCH net 3/7] net: dsa: bcm_sf2: don't use devres for mdiobus
Date:   Mon,  7 Feb 2022 18:15:49 +0200
Message-Id: <20220207161553.579933-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220207161553.579933-1-vladimir.oltean@nxp.com>
References: <20220207161553.579933-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0066.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::19) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1cef842a-dfde-49da-3fbe-08d9ea552d0b
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3910:EE_
X-Microsoft-Antispam-PRVS: <AM6PR0402MB39100F1F67A633013DB15922E02C9@AM6PR0402MB3910.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4eAquVgvqZwFRN/O7JKLac7AvAudICZB4AEox9SlpSmz+vbGfnlFCuC0jlJ6MtIYFYEIJpWSvDDXESEgbsNXwiMtYnY2Xl6nA7fhJKcDsBYCIavjdazMorHyXMfnXPh6++hTu1ZkcdioTyGtfcgMGg4Ujd4Kt9rrBtONEToIBzBB94FokmVdMkv6q1kW+XZW1kBDLlqV1oy6J4qEQP+OL3/vRhq2Z4HKIoPui0yJ3MsGlBu7cyFMt1RgpFQpanFw6FhUCxaGqlG8qqdKkMxkSd8civ6amLKLG776FI8I6t5IxkmTC9cJgDKtYMaxdz81l1FS8lm9VWoFDA8vKwkGz71ae30GZbU6EEGhMpMlJjcZjTQEaF/V53lKacIFEElRLyOkJpU01jgoSC7TFoGC/Qe+y9dCydPGXM6mwWwf6SI3RgrNSysoP0HY1jDImFccKcXst1DerfDxQ4L2+kl7oY9B9gQXIS7WbvmSrmAWOhcuEyomK1wH3/apWRu9CKNpNaFCD+eJ+b/DP/eS7E/ZWpJMJZGAkinx+5x7QpM8UzLFuQ6HJFjuPbYT9fXtyl3pEhnK9wAHTv7QBGjGyA2wNDEn2BssrrFTTXqGg3I0zHVkF0DdttCgHUuInX5rQOEoz9QPnrXluOiq7i7ju+s4uvb8GUaPxHmpvO6n3m6uxSlMyaER2+VSs9l8yn90HB0V/S8jbzl50APNil8/bXh4jA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(36756003)(186003)(6506007)(316002)(6666004)(54906003)(6512007)(6916009)(38100700002)(2906002)(38350700002)(2616005)(52116002)(1076003)(86362001)(66946007)(44832011)(83380400001)(5660300002)(508600001)(8936002)(7416002)(4326008)(8676002)(66476007)(6486002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xpaPpDijn11JI1mRXCnS+diNVtH2dyLgxzxNAIj9jsNUatkN8bp2jR/Mx218?=
 =?us-ascii?Q?NVr+Ep5y3y0P1Fd118oZbFoFPSSM9j5q0wVJBTaWAYQGfv9/dvFiOxunQU2R?=
 =?us-ascii?Q?k+HgdYEG1l6zkn4Jx5e9Lj81e1CNXRNc+qSsRWDlD/c31UIO3vcAkicns+1C?=
 =?us-ascii?Q?Dkslpaw8dxVTW7HCdhsJGQDcmTyj2xKkJWdrwbDqHIlJen/Tv+UR+AB/UqAG?=
 =?us-ascii?Q?+Zg3DUUoyApONpagkZnLRFFQu+MBXLX54Cw0nto9+OCNljeBfBDwJJLkThai?=
 =?us-ascii?Q?FYi+mMBf4wkyLRKNRZSz13KyGXis9p8NG2xSWVM7f+6Oz1V7cLgJ64fTMnuu?=
 =?us-ascii?Q?T/vKr6K18vN2JamUZYCSMhPIcdQxTTIKQBzP6rzzD/r6cEX5hY8/tWRxmGpb?=
 =?us-ascii?Q?o+RnKqgnL1AFnzLMsyjR4oWjTKVLHDI4HdNJceJ4PLPSbGOSmdUZPtzG9mxG?=
 =?us-ascii?Q?s7/YQtVnAWbheMIf0uro2uoxtJKTaQVAQYFML6Ot1du5O/TByQ06MWg2T6ky?=
 =?us-ascii?Q?Cbv13XG7tAOxK1gT4Yl7gLNjM1jkxEyjhNbvU1gbwqDCUrEKlhQZU2uNaPHo?=
 =?us-ascii?Q?hll/IJVtImYb9EcGttWsfF+9pWJmzLxrS6SarZ+yg9EflFo4qvXNxcO8TROu?=
 =?us-ascii?Q?PmrlLrmhFQFDlwD4V8Ybrx3NxFgAIVrs38yYhiMXkuuZMwIrxO1DjzCfy+Tz?=
 =?us-ascii?Q?GviWTESnHQs4YVWU0Qqa1KQI58fdeVOpipsxJY8WZSRcyI1Bp4p/wrVFYzWa?=
 =?us-ascii?Q?dH97Pi6e8c9GpnF6fuis2/gzdge9X5/CyWM8saWCzZAYMbRzxSCRVUzGAWHi?=
 =?us-ascii?Q?wV/sViKtKVavclD/QurWmdxGJrNsTcr0BFoRsOQqiDwZdofff1aWgCVaosG5?=
 =?us-ascii?Q?IlzQEfZg241e+UWxPKXjQQirUDM1wApPNJhxWPhzQSfCFxkvCqmWfSG9m3I+?=
 =?us-ascii?Q?64kag5SoSFv0m3NwfeeCZnuBp2eESS4e+rVTReadRxHJw/6peePTM+ykdNhU?=
 =?us-ascii?Q?fKZP+aHZpYm5iDvn3iTUwAGeb9n9fGL/QYVCA4GTZ1umavDMg51mWm8x3Pk2?=
 =?us-ascii?Q?U8gIggqrStze1b8I0BGgWFlX5g7wYrK8CYEJWlFWqc7lBH+9DMiLasrBPZcp?=
 =?us-ascii?Q?Alb1lMXtA0hqaxX4lDR1SzKQSh2BkOgpiG0/lZ0OeNlsHTctrlL9AaqhEuzF?=
 =?us-ascii?Q?ZuQ+lrSkXdH/EPdZEdkDMevDDo7+ZljmLTckFLT2pJhPE61tiFfubCDApY0A?=
 =?us-ascii?Q?pV98+ggHiYudvEylme9hkcaYU+KZPWxzYfai4hZ3bRUgDw13CgW4CC/AHIh+?=
 =?us-ascii?Q?+VxROCwWlcEOAwUQvxtvxhNjPCulWOotIKs7qn/K+iC/M/QVPys7sJHN9JEl?=
 =?us-ascii?Q?V29fPbAkK2W1PkPut74N/exbT+cpSzPvfPotFi6GPHB1YZfOs9eSQrcmsJFN?=
 =?us-ascii?Q?ZfywfV3xTHx4Ntp5jYz/22kwmHCVBxJ7E/KSXZTl4Vef8IOT7gsBYY6r8bl4?=
 =?us-ascii?Q?d3CiRWUb1F8nJl5YKvWEryAKiayxL5egM+M9JIMkRrj0ZejSXKUJdVtcd2BJ?=
 =?us-ascii?Q?VElg+nWWx8WNu49SLvARZR43NYqH+YdMye3tGThEf5dIS89rcu0bKGmaWY5T?=
 =?us-ascii?Q?XrBbb5EAwoFpXGllSCN78Lo=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cef842a-dfde-49da-3fbe-08d9ea552d0b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 16:16:20.0029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E6a1YdXlayhV033PxaQC6zMFck7T7jZk5nZID/EDP6L5RduvnSmSyxPpFCjOTMN/BLu/RiqX/nFL1AFLvd+sGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3910
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As explained in commits:
74b6d7d13307 ("net: dsa: realtek: register the MDIO bus under devres")
5135e96a3dd2 ("net: dsa: don't allocate the slave_mii_bus using devres")

mdiobus_free() will panic when called from devm_mdiobus_free() <-
devres_release_all() <- __device_release_driver(), and that mdiobus was
not previously unregistered.

The Starfighter 2 is a platform device, so the initial set of
constraints that I thought would cause this (I2C or SPI buses which call
->remove on ->shutdown) do not apply. But there is one more which
applies here.

If the DSA master itself is on a bus that calls ->remove from ->shutdown
(like dpaa2-eth, which is on the fsl-mc bus), there is a device link
between the switch and the DSA master, and device_links_unbind_consumers()
will unbind the bcm_sf2 switch driver on shutdown.

So the same treatment must be applied to all DSA switch drivers, which
is: either use devres for both the mdiobus allocation and registration,
or don't use devres at all.

The bcm_sf2 driver has the code structure in place for orderly mdiobus
removal, so just replace devm_mdiobus_alloc() with the non-devres
variant, and add manual free where necessary, to ensure that we don't
let devres free a still-registered bus.

Fixes: ac3a68d56651 ("net: phy: don't abuse devres in devm_mdiobus_register()")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/bcm_sf2.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 9161ce4ca352..cf82b1fa9725 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -621,7 +621,7 @@ static int bcm_sf2_mdio_register(struct dsa_switch *ds)
 	get_device(&priv->master_mii_bus->dev);
 	priv->master_mii_dn = dn;
 
-	priv->slave_mii_bus = devm_mdiobus_alloc(ds->dev);
+	priv->slave_mii_bus = mdiobus_alloc();
 	if (!priv->slave_mii_bus) {
 		of_node_put(dn);
 		return -ENOMEM;
@@ -681,8 +681,10 @@ static int bcm_sf2_mdio_register(struct dsa_switch *ds)
 	}
 
 	err = mdiobus_register(priv->slave_mii_bus);
-	if (err && dn)
+	if (err && dn) {
+		mdiobus_free(priv->slave_mii_bus);
 		of_node_put(dn);
+	}
 
 	return err;
 }
@@ -690,6 +692,7 @@ static int bcm_sf2_mdio_register(struct dsa_switch *ds)
 static void bcm_sf2_mdio_unregister(struct bcm_sf2_priv *priv)
 {
 	mdiobus_unregister(priv->slave_mii_bus);
+	mdiobus_free(priv->slave_mii_bus);
 	of_node_put(priv->master_mii_dn);
 }
 
-- 
2.25.1

