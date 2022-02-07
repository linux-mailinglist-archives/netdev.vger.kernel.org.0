Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB164AC567
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 17:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235723AbiBGQYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 11:24:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387624AbiBGQQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 11:16:22 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2051.outbound.protection.outlook.com [40.107.21.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37EF8C0401CE
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 08:16:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gYZRoG4xbNYVVjPnUilRpSgwep8pAYy2+K7fPSkpdDO/kg/P5kiN5SzYmZiJqnbbCb/e9EHy26A79NPsvka73qfPpN7iwzWLCVydFIDvlOI7WTjazS22FeI+i9owaZ6WC6eBGSQ4z19ZjmJ/NH2p3YgspziW66TgTZGf/iqrTQSTcJDSt5VOloUw7P+qv7VUr4Trm0S/TuEF9A2Y+LcrkJExBMjcC9ln3eOYpwTf45w9yipek3xfJKS+Z2ICZOGxbh0w9v7du6d4F2hzxs2b5p7eqj0IIxzoYd2Ba4J9FrT2GvUb2hKw60NCkjkF/zCWEWX/R4AF57naWtGCXwJiXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WIb8isWxnAJMGmm5GRBLHYsswNTsG01hj5zuWx/hL3Y=;
 b=HZxncPeBHh88uUL/g1ehKzGidyGGFbgsldDhT1wKI3mxTpYs5qdYGQPiiFH11T+cUfmAAMahr9QQ+NyFJTHwgbushz+dz9JBiY4+KY8WgN7++zXuuxE/bQBa2U5TJzjEmHkz9bGhAjO1D8lFMEzBYqud4DBqs8hOBoppMBpgqlShiPAcbO4S0YN6cLHvU2eKovjbYt4Zo/LjmyiweqwiqE3rrUqC8d5tuv+0gxDlAPyc7P+6xqJgzWApbRpFzMX1Ub/F5ef7JdxA1P4cNmpau7FGccrsMGMnto2ncQDyjRhi5YmkHIejyD9SK7zKhyDBaFm8VH+II55d92/Z8ZsRlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WIb8isWxnAJMGmm5GRBLHYsswNTsG01hj5zuWx/hL3Y=;
 b=jFBOyiKa2pJvtagMJswzidEacHLDqtAKdWHrcBY7dJPrx9bSQ40SHD7gNWRsjRjvvSE8OCtxLULFlxSWeY76bd7U0gm9+rsaxZDBbUlwjzPX+TJkBynNOcMDCog1h29C0cp1gceZMYC+3SCgmqHFALZdpeOq/4ayoFGi9Mgq0xI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR0402MB3910.eurprd04.prod.outlook.com (2603:10a6:209:1b::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Mon, 7 Feb
 2022 16:16:19 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.018; Mon, 7 Feb 2022
 16:16:18 +0000
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
Subject: [PATCH net 2/7] net: dsa: ar9331: register the mdiobus under devres
Date:   Mon,  7 Feb 2022 18:15:48 +0200
Message-Id: <20220207161553.579933-3-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: ff1259e0-7ba6-4f7e-e979-08d9ea552c4e
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3910:EE_
X-Microsoft-Antispam-PRVS: <AM6PR0402MB3910D057B0E3B400DB3D2C5DE02C9@AM6PR0402MB3910.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wAqPe9pHqQwJpWukPfsRBs/hlcLOBBR6+5+0hYGu8/N4ksoOhge8pyi3pjXVYZwOzYYnQkwP0zPMDGhabO1Wb4C7pnizHg0uPUyQMqYmcabMW5cqMhGSTn0rKxg9WZS3lTuNebBELxZQX7lELHADmFFKejegmEv8OmwY0iIRL4t3bDtqQqG+Pcj99EvImeqXVncZCV/8nMIvOe7rsIGwVKtLlcYlVYq+1DgPdKXhX2+0HLVacGHDG8mlip4FAXNTbFKcIxa9y3+LPWHqdv5HQWbPi3mDIYXf7eq8+Sl53bvzn96gHpm1R74E0l6v60L4Ygjm8DixlNpzVz9DrV2v+tVnPY+w32bKgSAiGDsEL/durF/uCOvvhzc2lJaG/pZmq6xyek8kuUyUx0Sqre0NEnv8DpsLGK3Aw4Vol9HDQaZYCyMeQ8Nlb0W4DVRsHZPovv833pHYzu/DenbPpbjP53X94wTzRmUtr0ioUCh67RM2rTb0524HBQdFNcEqIT5587qR1cH8jCykmoleDW2s2oqnfjoDJ6sgArDMB40wQIRVI1vDNVzwCpg7aS6qIgtlZOK4hJv/DWKPbSNncfx3FwawnRUss4dlz0RJ86Vj9fFXn2StdYLVWBSWaEz6qFfP5xWM9xkaIyyAsjqQRTf/xHoaLB/Bu5l9yEjVXgIreM4LCtov8fGTJoKOjtE46lC++Dm8rREhaf0lZ8KjXF9rDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(36756003)(186003)(6506007)(316002)(6666004)(54906003)(6512007)(6916009)(38100700002)(2906002)(38350700002)(2616005)(52116002)(1076003)(86362001)(66946007)(44832011)(83380400001)(5660300002)(508600001)(8936002)(7416002)(4326008)(8676002)(66476007)(6486002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?49KrkhTrCeVk7mPOsK3tPoCvIVfflN4OIq+1f3YlNrtBS5kYMZACZLR7bbmm?=
 =?us-ascii?Q?tEUp+Rmzb+jBQYKvkS+p4rN9UN6/kc7pMH1XGYnBZHjEtHvvZFyCZfDHOGIj?=
 =?us-ascii?Q?gm0NijYnzlqBBmyXX0ZgOC2OBto8g9rlJYuIAEqDJoUVADu+DcVuBli0QgFI?=
 =?us-ascii?Q?SUKlozvDvux4oL7nAH4/5F5FOXUMALvvsNk4ZzTxVTcPYa93MeZfc0Amt33d?=
 =?us-ascii?Q?x3d4DjoXrmfZoscoWW4cUCN4YQSz2WVgBDdQYJnnEOQCYArkMbcN12ZoYHBs?=
 =?us-ascii?Q?NzcXl3/NcK2PecSDeP+KHx43sftsWI+Hi1Lb5ljG+PfCNSUucuKusQ8IwUnq?=
 =?us-ascii?Q?KB3epbg+mp0Ac/DMxF3fh7uADToKEPdezlZceyzoU3sqZHNdCQRqA6wwKXCP?=
 =?us-ascii?Q?JMLxv+5Y6T9YehIWXhPYxBeoLzZ4NUe11l6LGwzD1NtHSylC166nxd95BsXN?=
 =?us-ascii?Q?KzZ41U99PAjUqfQbcNABIm6BZKlqFaQCkXV+RjbIrW5jZp5QjQz6GKy5D8SI?=
 =?us-ascii?Q?j0HyglSgccZZwZMurP40ioRFHazgyuTvjfqyROtLy/nSsEFQhpKBwZjQdbWJ?=
 =?us-ascii?Q?NAN9IkaVu6F3kU9shV2dfGht53/z0+pz8eiM9xjaU4ylQgjXVeDq0uel0QUq?=
 =?us-ascii?Q?xW3QycvSO8GoP1p2At26uZpe7tyUgBE41m/MhQi/x+BaaJ8tsRHCuIFW0q1f?=
 =?us-ascii?Q?H4pBPNwGzb01uaBEIoRS0/5piJ5Zl+fm+IJ1TtN/i5HGvzXpxxHtv3hDtFr2?=
 =?us-ascii?Q?ASAIFOx8/FDLkVb1+y905p7keiizZeZaTymdMU2KB7i0o1N+m22eSETinm8U?=
 =?us-ascii?Q?PgnF9dOwa2bKEEJaPnqVECV2R0/UNmL0Mf1CmmrwM9wIURAnwmskKoxXhroN?=
 =?us-ascii?Q?rFU7Fzz2CXKjZ9dE/9+nQGtEN8WHk9Tc8jcGFgM48M7vDLl+rvZmwEX4rC6Y?=
 =?us-ascii?Q?cqD0O0Dnu2ZAwFhixAbN+BDWg14PgTFzSnl1nPJ3l5DTTRlk6aFw3de2afDv?=
 =?us-ascii?Q?khlY0k8ckMTFmzt8RQKHIK95qI066+SAd5BpcNI8xaQHAfm6pcsSf9x+tdLS?=
 =?us-ascii?Q?/FB6JyqWBc2PkXcHdg0PxmM1USvXv526tIFQ/TliQ8wToFgDzjtZiZT/+Tx4?=
 =?us-ascii?Q?ULrIvNzSZc6NiIjyBuSUEIaosDXE0h7463F/YJCfAXsPtdmzK6ns5SLPD0Z4?=
 =?us-ascii?Q?ks2aeTJLtWSlAtTzH68QBhSdbKGoK9ZeJtWHTdeMCod7j7ZSLUwztOmH3G0G?=
 =?us-ascii?Q?0KkZRAqHgPXktrIyp+YKct8M56K873aHIIF5l24gt/OiN98Lb9kppj/08t9x?=
 =?us-ascii?Q?CJo5h2/RhuAk0HBh9KHJ2A6m7pypSMs58BcHvbcZbOv2QUOVhudVGq1IeP0J?=
 =?us-ascii?Q?JcaH2Ymiiq5PaT9AlWo0d73GY91zQxTpDplTshX86NHlH+5at0E/PfzT6RM8?=
 =?us-ascii?Q?GHjFc2ouiibh3Rbfl+IWCWBLZlGbC1DrmtSMRoKnbKKE9cCSm0amv4un2ra3?=
 =?us-ascii?Q?itYYDQBcubW3vQXDfst0iXJo7OiNECLjwy4LPGJ1tqZbym8wksB2k3gUXlOj?=
 =?us-ascii?Q?bb7UFZZiHHOxGM5BPQ4sQJynh9eqrsg2n2DVh/sDR6H71i5iNEqgTcgAHo0m?=
 =?us-ascii?Q?9qVQ/aU39zxbC5O5SmjYe6A=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff1259e0-7ba6-4f7e-e979-08d9ea552c4e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 16:16:18.8624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FwEQbX4pF0sHJcmbuZ9VE/C/gNsKmlVv9X2n5bVeeYuScgvy3Ik8nLGkStLUsYrQPS50fPcLO3DJTO9Z23F0tw==
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

The ar9331 is an MDIO device, so the initial set of constraints that I
thought would cause this (I2C or SPI buses which call ->remove on
->shutdown) do not apply. But there is one more which applies here.

If the DSA master itself is on a bus that calls ->remove from ->shutdown
(like dpaa2-eth, which is on the fsl-mc bus), there is a device link
between the switch and the DSA master, and device_links_unbind_consumers()
will unbind the ar9331 switch driver on shutdown.

So the same treatment must be applied to all DSA switch drivers, which
is: either use devres for both the mdiobus allocation and registration,
or don't use devres at all.

The ar9331 driver doesn't have a complex code structure for mdiobus
removal, so just replace of_mdiobus_register with the devres variant in
order to be all-devres and ensure that we don't free a still-registered
bus.

Fixes: ac3a68d56651 ("net: phy: don't abuse devres in devm_mdiobus_register()")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/qca/ar9331.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
index 3bda7015f0c1..e5098cfe44bc 100644
--- a/drivers/net/dsa/qca/ar9331.c
+++ b/drivers/net/dsa/qca/ar9331.c
@@ -378,7 +378,7 @@ static int ar9331_sw_mbus_init(struct ar9331_sw_priv *priv)
 	if (!mnp)
 		return -ENODEV;
 
-	ret = of_mdiobus_register(mbus, mnp);
+	ret = devm_of_mdiobus_register(dev, mbus, mnp);
 	of_node_put(mnp);
 	if (ret)
 		return ret;
@@ -1066,7 +1066,6 @@ static void ar9331_sw_remove(struct mdio_device *mdiodev)
 	}
 
 	irq_domain_remove(priv->irqdomain);
-	mdiobus_unregister(priv->mbus);
 	dsa_unregister_switch(&priv->ds);
 
 	reset_control_assert(priv->sw_reset);
-- 
2.25.1

