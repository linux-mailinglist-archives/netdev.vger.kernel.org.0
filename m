Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4CE4AC585
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 17:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380425AbiBGQZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 11:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387619AbiBGQQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 11:16:20 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2083.outbound.protection.outlook.com [40.107.21.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DAE1C0401D1
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 08:16:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FPsrK8yzmIgTNO0YN7VzVZzu6Gl+u5PBdWLDOB+Ff5qkt2yZfAL+Hnsl4TxrigaN5hclkpgextvNXFXVsjRwqD8qSbFTUq0a7dyIlSzGmBn3NlBg3hlcnIY7ATtZupoiE1nurNi6Wczlyqc6E+K/7JkpzgKbZS1CM9n135pxU+mbHRh0gSXQmbZDr/J7IO/tgSeq3BRVJsUKtynbGXdTwWYZp+md3hpqBoqMdjs3FhPRUcmJryEYmzApkyASeiA6s/txxh93/nq/RItUbOPEafWMuJkHCJ9PAfZhEOrKdaFXQ0XjXy5OA9cahCFO1gHgWbj6zGa37FwHmfQgVGH6KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S35rRopJrtHbOZAlXfqTWD3+fqQEaQDj0Tf1Yw2zE8k=;
 b=WnJXNVBeaQtpGNhkqpg1EHAEHCJr7IEsw5puTj3oVfDf4xsT7gqegcsAat/V3ubRVJCcUmsBFeOB/GRa98ZL8C7mgi9H32Nlvpw1RWG82TETbnftWlZfy+CVDuSJoq70Bw4Z062ptysyoz7jVtb+lia/OoKa/1WVUPw+KYTjdknyLmbjVABDZhSUyHJgNvK5gzNoZUtIJMdeQFSG//VqsrBNEv9IceuATPqHEMWt8hwgWGTj15VrGuX3JJ2Zzh5pF2syl0IRPJWw29k7ELnZoVCv/J4tpF8f6/uGNHv6+woUBfdw+1zRsFMUUC2NNR5Pic3OK5XGA/hr1wqnTqozvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S35rRopJrtHbOZAlXfqTWD3+fqQEaQDj0Tf1Yw2zE8k=;
 b=OsIke6P+5282DB47i2FjHuATdHEdC8nPIhZg/vtwOYl7QM2sjyp7H711IsSJSeIxcEWgzTzKEzOfdeWcVRJIFXIn/PVFl2tFwUcaVgWlEtC+5+Qft6i6QJLI51383hmrGbxdas1yDRucQTRtKxqDAExkz23KlodtaVCzTSGthes=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM5PR04MB3185.eurprd04.prod.outlook.com (2603:10a6:206:c::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Mon, 7 Feb
 2022 16:16:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.018; Mon, 7 Feb 2022
 16:16:17 +0000
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
        Daniel Klauer <daniel.klauer@gin.de>,
        Rafael Richter <Rafael.Richter@gin.de>
Subject: [PATCH net 1/7] net: dsa: mv88e6xxx: don't use devres for mdiobus
Date:   Mon,  7 Feb 2022 18:15:47 +0200
Message-Id: <20220207161553.579933-2-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: d5b50564-76f1-4e0c-7ea0-08d9ea552b9e
X-MS-TrafficTypeDiagnostic: AM5PR04MB3185:EE_
X-Microsoft-Antispam-PRVS: <AM5PR04MB3185E2D88718F76D3F45C60AE02C9@AM5PR04MB3185.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d8oL+BswWKPM/2zOInYPDXVRDzZJ9j/RKk1R/N3vsgYiefGqNljWRENWgr9yUR5Xg2bmazFVtlnI60y+gyoy1luxalctHzvYJdB4YQ9D+uGjLX/w9Qa70Gy/L04PpMCahxnMIkZh98Uwgd2vs1F1bmfDcVxRQuo6tTiZkmkaoDEoScQS4AXs+YSpICt3Ts4dwVQezEl0nvLVcPsiNLMy508o7jqEnFYSX2Gls0WEOKnlbmNq51BLbrrNnBDZoRUndCIScVFifBNYb/m5UYSTv9Ltn7tGOP8BUFlgqAX0tHKRYouoLlHkGZRq7232n5opfKCX8haYDXYy9fekDbe0ZikApmuX1TsH4pnEsRnuU27u/8hRjWoEfFplcNPpHI4O0VhndsoPpEXVqUsOXNQBBQz2BnETT7uzD/dmMes6fY0UMRksD9RXo5VpjraHHupkYhO+5H33yI5Q/3Zrdy5lFqBPsO6qwqjTM8uOA15GvD65Li+wl4yhsA1KXh+fboQoO2hXZe94SAnBjkxSTvgudssbPGJBHGzcZ3H9M9kcd/so3cVD6mEnTUPiWMcKFfKKS6ls/WLFrtVR50oqw61Z2uvZvunB0K1+XgMnZD9ojn7maqmZfKVaHCPrEybEs78cThYwm7asy1QAeiIMSrr4gSyWVJgcf81tRPZTcXrk59RP9yYfpwhlAlfuAdtPfnzii8WYhOYB5UDXCkZplmJ2GA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(4326008)(66556008)(66476007)(8936002)(83380400001)(36756003)(508600001)(8676002)(1076003)(26005)(45080400002)(6486002)(38100700002)(86362001)(6512007)(52116002)(44832011)(5660300002)(38350700002)(7416002)(316002)(66946007)(54906003)(6666004)(6506007)(186003)(2906002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ec1Qk5uSyAHyDgAJ+zuhU0aEUqDDpQk2Fzur1g73t1onEiBLT4OzlBQtv4TZ?=
 =?us-ascii?Q?AHBeClb83BMML4DyHr7cUxhmnEdwngzr5YFgSODH7++f5BO3UDl8a9qw+Q3Q?=
 =?us-ascii?Q?ooTwP3H+vcZl0sBfIl/eQpPqLphgKRQSWbND2odsjJErI73G2xrzPzwPps1k?=
 =?us-ascii?Q?OtbQqk0VpIdiztNy06W1on05licoqNEWc8oPQh0r0w+bZaDZjr8KuSzM/HTH?=
 =?us-ascii?Q?9700wQkTBaq+CeHzPiFSA6RCRPPOTrfRjokAlTtOGgyr8QApX3TIpY1Mkg/6?=
 =?us-ascii?Q?wRRKUY+3F+Iqtt+qF+VsFBltVZlIZ/CV6QNtSbheOLfq2ILgdByV37/Bgqfh?=
 =?us-ascii?Q?WWu/7UTH3zhB68B8mZMWt6C8j3Y0wkbfCXfrxX5hlMdXXO/yf2FGsUpkij6u?=
 =?us-ascii?Q?CiRuAbhiCz2W7MUjcHQOhExS5w3rVW0JWe5Fw/sstXYgAeJJPU0v6WjDV422?=
 =?us-ascii?Q?UYw/QTMbFuyhO9renz5PCOzHlNxGu6JUcQGNUknIElcWOOTZEJUOEwNQouow?=
 =?us-ascii?Q?gZyceH24Pf0958E9Gtl1Dq6kJzyqxDzv8nW3rxMfW1gGsGHChTjEo4VM4n8F?=
 =?us-ascii?Q?CBTWNG+yHpgHq+4AqtAXnVGzRy06QgRG/z4UAz34+MVScBq/okxV/hC/ATJf?=
 =?us-ascii?Q?uzUgLxR1lnZjKL4Ct3wnz0xENeWu4WUL9SJqvVJsW6lMUNp3csv/NPvgHiC0?=
 =?us-ascii?Q?HPuo7rK97a1e35hvKYM0Mh5ii9c2kQYKQMu4jukROZUj3VBwzj2oHS600J/A?=
 =?us-ascii?Q?QykD58EtgOiWXEc/ezsUOYJJT3PDSi2v12C2qmbxgCQ1GxpOfyXy0dmnreSz?=
 =?us-ascii?Q?CucMt0KAaGBvWnvUsSWzlcJnl8XN6IQng+/QN0uTFB91TdD5T+NGd+vDJPHF?=
 =?us-ascii?Q?8qMOjMb2gYnoSwlLsBlicQTNIU0ijciarGx9iBP98UBC/W3CIyDGjdUXRuLc?=
 =?us-ascii?Q?Vb8qpFLS/mt+rCrURF3Vy1j/xlZwj9AZ3YG2fbxORpGOkXgWAcnxWuVaqZH8?=
 =?us-ascii?Q?h0EC5TOMIGx/l+JmpfiFiR94GlhAKzaFg2/lyk3EGN2OvGbsfXdY90jce63p?=
 =?us-ascii?Q?GlhuclleGAuXRzgPNKf5g8ZtX0cdSs7xJor9+PtDyQrlVeuAOgBJ85F6wom5?=
 =?us-ascii?Q?BwINRyaA1EipxHcQVzkrnG8ASJsNu3BMjdNarKhczluYIS8bxC55rH+pOB/Y?=
 =?us-ascii?Q?ZJViSqgoxlr0qtIHgAOydydbtogteqS+vSJos8Gwd1oAiBWsn8ZgPF0Hozte?=
 =?us-ascii?Q?1FklKdOgRMn01NM7nAuLRg/G7W6xY5k3Q8WhnkNueut8xzRRS8BmFWy3z+9S?=
 =?us-ascii?Q?JvpmKYToLQHifxW8Za7QP1uY9hQiHBtDDuYqBf5zcJRmeF5qXF3XHhh8g7hr?=
 =?us-ascii?Q?Gq4cVR1okD93C3w5jvANQTzTOQd+9YKQNzazrf5SvPZatOjVPzVtJxheuiyv?=
 =?us-ascii?Q?sQhBifw+n9eKqLyGjy9QQgcddcv4IOvhjeni/gpwjIAaOkvDBKlvjRlb+7dN?=
 =?us-ascii?Q?a9f369jSPGDeaneFgVC9lyJcVlA/W1aNvAPYztfcPX878OMfrSxoRFzCGkQK?=
 =?us-ascii?Q?vlAiQ+jpXnNcirRZfDZaSvp+cl1kGjl+l0GxwPOCippkMgsoJQJJgX3Z6Rln?=
 =?us-ascii?Q?qOzDEJZz4gVx/tyQxQtB3ck=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5b50564-76f1-4e0c-7ea0-08d9ea552b9e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 16:16:17.6437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P7tZzoyX0jwn5i0vLxfAOmK2AhMCDm3dMM66ul3wPpPlnDnuZqe2y2EIUSJT5JvyRQDg5KT4pVvaVEtuaZBvwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR04MB3185
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

The mv88e6xxx is an MDIO device, so the initial set of constraints that
I thought would cause this (I2C or SPI buses which call ->remove on
->shutdown) do not apply. But there is one more which applies here.

If the DSA master itself is on a bus that calls ->remove from ->shutdown
(like dpaa2-eth, which is on the fsl-mc bus), there is a device link
between the switch and the DSA master, and device_links_unbind_consumers()
will unbind the Marvell switch driver on shutdown.

systemd-shutdown[1]: Powering off.
mv88e6085 0x0000000008b96000:00 sw_gl0: Link is Down
fsl-mc dpbp.9: Removing from iommu group 7
fsl-mc dpbp.8: Removing from iommu group 7
------------[ cut here ]------------
kernel BUG at drivers/net/phy/mdio_bus.c:677!
Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 PID: 1 Comm: systemd-shutdow Not tainted 5.16.5-00040-gdc05f73788e5 #15
pc : mdiobus_free+0x44/0x50
lr : devm_mdiobus_free+0x10/0x20
Call trace:
 mdiobus_free+0x44/0x50
 devm_mdiobus_free+0x10/0x20
 devres_release_all+0xa0/0x100
 __device_release_driver+0x190/0x220
 device_release_driver_internal+0xac/0xb0
 device_links_unbind_consumers+0xd4/0x100
 __device_release_driver+0x4c/0x220
 device_release_driver_internal+0xac/0xb0
 device_links_unbind_consumers+0xd4/0x100
 __device_release_driver+0x94/0x220
 device_release_driver+0x28/0x40
 bus_remove_device+0x118/0x124
 device_del+0x174/0x420
 fsl_mc_device_remove+0x24/0x40
 __fsl_mc_device_remove+0xc/0x20
 device_for_each_child+0x58/0xa0
 dprc_remove+0x90/0xb0
 fsl_mc_driver_remove+0x20/0x5c
 __device_release_driver+0x21c/0x220
 device_release_driver+0x28/0x40
 bus_remove_device+0x118/0x124
 device_del+0x174/0x420
 fsl_mc_bus_remove+0x80/0x100
 fsl_mc_bus_shutdown+0xc/0x1c
 platform_shutdown+0x20/0x30
 device_shutdown+0x154/0x330
 kernel_power_off+0x34/0x6c
 __do_sys_reboot+0x15c/0x250
 __arm64_sys_reboot+0x20/0x30
 invoke_syscall.constprop.0+0x4c/0xe0
 do_el0_svc+0x4c/0x150
 el0_svc+0x24/0xb0
 el0t_64_sync_handler+0xa8/0xb0
 el0t_64_sync+0x178/0x17c

So the same treatment must be applied to all DSA switch drivers, which
is: either use devres for both the mdiobus allocation and registration,
or don't use devres at all.

The Marvell driver already has a good structure for mdiobus removal, so
just plug in mdiobus_free and get rid of devres.

Fixes: ac3a68d56651 ("net: phy: don't abuse devres in devm_mdiobus_register()")
Reported-by: Rafael Richter <Rafael.Richter@gin.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 7670796c2aa1..8986dafb892a 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3566,7 +3566,7 @@ static int mv88e6xxx_mdio_register(struct mv88e6xxx_chip *chip,
 			return err;
 	}
 
-	bus = devm_mdiobus_alloc_size(chip->dev, sizeof(*mdio_bus));
+	bus = mdiobus_alloc_size(sizeof(*mdio_bus));
 	if (!bus)
 		return -ENOMEM;
 
@@ -3591,14 +3591,14 @@ static int mv88e6xxx_mdio_register(struct mv88e6xxx_chip *chip,
 	if (!external) {
 		err = mv88e6xxx_g2_irq_mdio_setup(chip, bus);
 		if (err)
-			return err;
+			goto out;
 	}
 
 	err = of_mdiobus_register(bus, np);
 	if (err) {
 		dev_err(chip->dev, "Cannot register MDIO bus (%d)\n", err);
 		mv88e6xxx_g2_irq_mdio_free(chip, bus);
-		return err;
+		goto out;
 	}
 
 	if (external)
@@ -3607,6 +3607,10 @@ static int mv88e6xxx_mdio_register(struct mv88e6xxx_chip *chip,
 		list_add(&mdio_bus->list, &chip->mdios);
 
 	return 0;
+
+out:
+	mdiobus_free(bus);
+	return err;
 }
 
 static void mv88e6xxx_mdios_unregister(struct mv88e6xxx_chip *chip)
@@ -3622,6 +3626,7 @@ static void mv88e6xxx_mdios_unregister(struct mv88e6xxx_chip *chip)
 			mv88e6xxx_g2_irq_mdio_free(chip, bus);
 
 		mdiobus_unregister(bus);
+		mdiobus_free(bus);
 	}
 }
 
-- 
2.25.1

