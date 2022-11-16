Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD27062B72C
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 11:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbiKPKHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 05:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbiKPKHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 05:07:14 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2062.outbound.protection.outlook.com [40.107.22.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC8DB7E5
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 02:07:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nu3B4ohl2Fd2o9oEAMU7RK0PTnCwAA2oFnjMVvGGvDXsanPIKndK4dm0Whimlxwkf79EugA0DmfII6TBeQ1XXM1AYTgH6fVQM9P8/4KCYDeW+30vA5uqX7NMW91mAJND7kzn46m7DE0i877OsXn4p44LV5nmcLN8iBblMAiNvI7hzzVwgvn+6lmGeBuAhjXJEsSu8ye6tQa8G7yOaZRLf0+/dRFdjGbNcgKd5i0rzRsQ57nHxUDbdzYDE8mrV7cf85iLjZ18oSYgIz1hTIdeEAvynCjd3+yT/MeWgtiDpkyt/JY77bq0Nz9nIBQQTjG48c0ZzuHMITXvZ1+6Jf2Tcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QH0XfigZrrQeeYomG0XtLkZ4Xq4BIJ3EfnzSb6Kqzzc=;
 b=nr4mP7o6cGYsAzSXxdWX3mImwwWOwspY3mpspTq2A6aF3FH70Iz8Ijdu5Je34UDD2zghbvsBElN2aaQbl6FfRoPX8wMjQSZx6AFEbMa2nzJktR82oe0jBhrUKma5FPYR+A4ZWi1LKgLqcJxEjfV2prZXjY80tM2cjIDJiOrOqFyMiVrWYInzzBcqI8KBu6z1I9M/aqjYtk7IOJv9y46aa5KBwlhdpetTW3C3zeJ3S4p/VEIpTSSEFXIqdUDvS9JBxVSwC5aQQ3HT+Bf2m2i0basQuaYPW/iHF+fwJzaqn8shqHrNIXvyWuYqGaEkquEC05TbfqGfFLzZ17QxNWnUHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QH0XfigZrrQeeYomG0XtLkZ4Xq4BIJ3EfnzSb6Kqzzc=;
 b=EsH64l9y+buFBwEHF8jD1E3H+Ng3dw3JyusxM+9XFYEOQYlbB3eRTmFgsLgOUHoXxyG2hkipHgL6jdtBO/Csx0fFwXGSjjndKTCPoIJI3SS0IO9JnDdgroPzwTeIafVbA0sidIfOMkz32U+wpwv1dMwAJTfKsF8LWRphP8vv+AA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8779.eurprd04.prod.outlook.com (2603:10a6:20b:40a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Wed, 16 Nov
 2022 10:07:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.018; Wed, 16 Nov 2022
 10:07:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net] net: dsa: sja1105: disallow C45 transactions on the BASE-TX MDIO bus
Date:   Wed, 16 Nov 2022 12:06:53 +0200
Message-Id: <20221116100653.3839654-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0244.eurprd08.prod.outlook.com
 (2603:10a6:803:dc::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8779:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f8d592c-d011-4fcb-1d4a-08dac7ba53c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nOkC/+6ocsTgFp24EfV0sXasN9iPq6y9e4I4AhZP+9YyReDmpFQ+SaURD4MJwNpzEXxoKR31SKQTtez04NizIpCj/ieqjU9OqijmFPQidgO9pF/a6PN/VQqxkwiXdgTqy4YGZ90xX+CWQrninwNbgGvTOFlIOW2vTgusUuRDxaVLCzDSBErnDHdwdiIkJNHnvzfPIuTbM1/xe1ZMaHjAW5Ks/Wse88RSLshuIsutKMSoq1Ch14ivnfvU8svfEmmOD85lnK5PlnhE5H8TG84oYH3CImZnaG6geTW03ivKRhFp0eD+PKUqTjHVF+1PQyiq1IW9w4l+dlHU/EHrjWnuErDO5gRF2mwsf9KWOe/c18qlLOQP57ddjZi6VwOv+N5M4vHN8CeI07ZLXeQRV0z/JfivtX89rptq4+GH7H76NJRcOwOWCVLeOqK6aHY/IvA5+XlyXudS4qI1X6h1iULKN9CJCpPv6ZA2p8PHrU+hGxzdHrCQq8JSY6d6IvIdTZk0JsLgSXzYxCY2L2zbQo5rI5rZSqNp+x1lMN8VpJiNGjf/Dk5PEgUCx5AkWVbTQlK23eOQqk4W6LQS2/XBuU7EDlSDDmyDNgPWC+b8lpwPBXC0SCSj66JRWnU2xSNLZl48BKi3psJNL4fptYQuWqP88BWpPyI/s7z6phfH4tGfJ9CQmaEe/erfORouSC1BaiQJ8sxjcM4/7ptZGddyZMuJdZHwD1nsNB4fvVhuXYO/QAWANTwThNDdNV35A0na3cFS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(366004)(346002)(396003)(376002)(451199015)(8676002)(38100700002)(38350700002)(4326008)(5660300002)(54906003)(66556008)(66476007)(66946007)(8936002)(316002)(44832011)(6916009)(2906002)(41300700001)(6486002)(86362001)(6666004)(478600001)(6512007)(6506007)(26005)(52116002)(36756003)(186003)(83380400001)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HWdTiGoRxS0jlz2b1/iXV+1mMmifvLOuyRpGEasvnpB2IVQ6SH0MGEEd0U3s?=
 =?us-ascii?Q?hkEm+csXer6bFOu6LpqeWaZSiQjfGOPIbVl7EXVh0Tkppiak2kPg64mMyQvV?=
 =?us-ascii?Q?mtIEI7Brrr7gPM3anyayfEK4iWLIgOyH1MnVWxtR+K/f2kDJC1x7+r8RWota?=
 =?us-ascii?Q?1a2ZjLCqAAZMb2nJaWbAPJOIXXXKresNNBelMdaL6hPbBPlSd+q0tPajLR5V?=
 =?us-ascii?Q?g5wsiBS+HqL56o2/n8bWMWmCGE1QybaiphHgQ4BCRX71bRcE9Ro3zvhYDQtn?=
 =?us-ascii?Q?oifNiu391d+PBNgilbxdRBeHJwJgXQCQ/LCzuAKLo7qZHeAwFhBB4kPB3CAA?=
 =?us-ascii?Q?udV3LhTmEslp4bdBnSNe8rzJaWtuAmSOSIvqC8TfwRnmGAqUdUX7uMGZIkov?=
 =?us-ascii?Q?Acy2ACIxQwpcRFTVRRgMDIXP3kXHOWSidAJQKIFrvuP84YgdeExmu6wa97Ep?=
 =?us-ascii?Q?7/1TxTXP1NxvPUXIOYP8Aea+qWdKVktWGCQlD5qgaX1N9LruY3A3I5UTziH3?=
 =?us-ascii?Q?yGHtfr3dNNoVxsjD4VIx3/UnvxPzYqYSxzaIG76GKOlhRI6//ZnsrkhkWfrA?=
 =?us-ascii?Q?11PQ0oLhrsRst+v4EyDwYkO040ZSwdPqTqIH0vvvA3iwFJ2HIiRX6L+OIYxi?=
 =?us-ascii?Q?ItNJhLrhJgJpXDQ8NFWA5BowW64oFwWNbv2vOXFO3JKZuGUaxxFVtSsJEsJU?=
 =?us-ascii?Q?XvYw1I6uvPVTKsWwbw5auC4KyOkBe795uk3Lfuxq0ng5n8i3Cvwi+dO8VMzj?=
 =?us-ascii?Q?Ja9/srTi44CqFPK21ZijUFkvYMUrYChyjay0xITBZM9UXhwB1qP5eFK3IOzv?=
 =?us-ascii?Q?sRe2g17RySD9TOVpLGx3xkoY7IX+XHuuO3sps8NHYEKATR12XztEK9rVsCMa?=
 =?us-ascii?Q?AZMoqq4M/ESTymdzjcBU13jsrLX0O4DA+3nV9WN1D2SIkDT9d31P+t1TxhYX?=
 =?us-ascii?Q?5StcrtLioTbKdPe45HbQul8Fp+mBh513t2yp7uJIAb77mRqx8FhBfYhWOIYT?=
 =?us-ascii?Q?/eUMARwbFdnSM1CyQskKGaw8tYzXAHota+SVjzccVRQcaixYmGE327XG+urQ?=
 =?us-ascii?Q?za4POKxQf8BZmi2hDRFRGOJ+ukWpYqrBMON2SOkY5ZHifJWdlZdvrGFDZZM/?=
 =?us-ascii?Q?PZp00OrYSA4E+3pbzcUc/gy+QAzwX7/KLZfulLGjGt3/05Lf94n6rKPqDXhZ?=
 =?us-ascii?Q?EKExte7/h5DpHCMkXatIccMq98oOy1/9MVbtGanj1EimFmF71UqxN6AebPzT?=
 =?us-ascii?Q?2myq8E0A1KdkVrLfjBou/HnHMPYuffsdC0lq4bypKnaw/rFbXhtVn5zZmg3X?=
 =?us-ascii?Q?BFmFul1sY438ARVcLKRu6v1Twe8BZEZb+3JdRqWHnt8xKr7kg50a6NnHM4zz?=
 =?us-ascii?Q?BlLvwBgJZFRPzc6XW3TFyGS1F3iknCEmwyx3NMq6KfqvJSEx1iFr7zugzSnf?=
 =?us-ascii?Q?BWh4prhCUYFIQK0tDePQ2/lXwZMio7wq3xw4x0AcyPRmXTOaQ3RRnO6x9xIN?=
 =?us-ascii?Q?DN3DD7SsE/7AJX5tmVOS64sXqjEwrremdl2P8hgeu/3AKn0iYV6nB8HBanwW?=
 =?us-ascii?Q?WKfwoDdlmldSHhMDbzRLdDkPwzrhRmCRWsfYUu3S?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f8d592c-d011-4fcb-1d4a-08dac7ba53c9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 10:07:11.1598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PstBIEwQQE3TiL7wvjhRqwrDu5KdKaTAoldnFApxCorzYglQTsYC9Ii9hSaGDVem8ScF+BfZdnUnl4jJ4NwcIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8779
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

You'd think people know that the internal 100BASE-TX PHY on the SJA1110
responds only to clause 22 MDIO transactions, but they don't :)

When a clause 45 transaction is attempted, sja1105_base_tx_mdio_read()
and sja1105_base_tx_mdio_write() don't expect "reg" to contain bit 30
set (MII_ADDR_C45) and pack this value into the SPI transaction buffer.

But the field in the SPI buffer has a width smaller than 30 bits, so we
see this confusing message from the packing() API rather than a proper
rejection of C45 transactions:

Call trace:
 dump_stack+0x1c/0x38
 sja1105_pack+0xbc/0xc0 [sja1105]
 sja1105_xfer+0x114/0x2b0 [sja1105]
 sja1105_xfer_u32+0x44/0xf4 [sja1105]
 sja1105_base_tx_mdio_read+0x44/0x7c [sja1105]
 mdiobus_read+0x44/0x80
 get_phy_c45_ids+0x70/0x234
 get_phy_device+0x68/0x15c
 fwnode_mdiobus_register_phy+0x74/0x240
 of_mdiobus_register+0x13c/0x380
 sja1105_mdiobus_register+0x368/0x490 [sja1105]
 sja1105_setup+0x94/0x119c [sja1105]
Cannot store 401d2405 inside bits 24-4 (would truncate)

Fixes: 5a8f09748ee7 ("net: dsa: sja1105: register the MDIO buses for 100base-T1 and 100base-TX")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_mdio.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_mdio.c b/drivers/net/dsa/sja1105/sja1105_mdio.c
index 215dd17ca790..4059fcc8c832 100644
--- a/drivers/net/dsa/sja1105/sja1105_mdio.c
+++ b/drivers/net/dsa/sja1105/sja1105_mdio.c
@@ -256,6 +256,9 @@ static int sja1105_base_tx_mdio_read(struct mii_bus *bus, int phy, int reg)
 	u32 tmp;
 	int rc;
 
+	if (reg & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
 	rc = sja1105_xfer_u32(priv, SPI_READ, regs->mdio_100base_tx + reg,
 			      &tmp, NULL);
 	if (rc < 0)
@@ -272,6 +275,9 @@ static int sja1105_base_tx_mdio_write(struct mii_bus *bus, int phy, int reg,
 	const struct sja1105_regs *regs = priv->info->regs;
 	u32 tmp = val;
 
+	if (reg & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
 	return sja1105_xfer_u32(priv, SPI_WRITE, regs->mdio_100base_tx + reg,
 				&tmp, NULL);
 }
-- 
2.34.1

