Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE5494AC56C
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 17:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242818AbiBGQZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 11:25:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387614AbiBGQQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 11:16:19 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2083.outbound.protection.outlook.com [40.107.21.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B65C0401CC
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 08:16:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V49iyD+nHIvadetesMe5rsGxCJFIMboGizq8Krr+IFnTyEUm9FQVPJEvSSblxo3ggK0/3rcoaGgRFhJLU3OpiiRgZi4vaF/bqFtxVN6sZ+DXRZBMgQXoNyqoQ2D7ZqC87sNPlYkh6429ylabhWr4paaD3pXMvxSR3Izc0Jb5ehlqMHRBjD+XsWuWTh5tZ1+hmlVKUWXGiXpEVNnbIaGYEThlq1Bynkw/ZKd4aUOH2sI8EjfnIq9AkKITSMS9FlWJh4AuBDZzLQO9pOJqdW1EpXD9uERbAVxMDfvzwp9iLNGUhsADGhno83fs/jkGveUodJTfrk9AosE2ek9MGGyuPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a0qyMzB09gfbNSJUZKsOJ85syuiFwWw+BeZDWOdRvdo=;
 b=EfcEK6mH5MnSMR2KQYk42Meztmisc8AqIko9sxYXXysAO+2fRrKIfei9WgDOujk2Xk1c1cnDAp+HEvYH2FF4/AaVvuAHZqAjJFgOi+329ZhSn8ngNqoDcrnzw1UYr6dVCHC7a9myTQ3voYR6yMpgEMOgFZ1x7GOBr4FJIZ4t6kEOPSMDzpQ3kea4OXYoD4RLyFgk0bm5Iz+XYuMUz3lK6fRTdx/DRSPhoei9XDVIvWk/9y7veOxZ3qV3C1cNe2F0yBswJbp0cprSPmsZM1lKdG0STABT0a+dKGii6lJwGWLpJHirg220xBNzbGsfJSj5LKHrHCT299BvS9oPenT+jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a0qyMzB09gfbNSJUZKsOJ85syuiFwWw+BeZDWOdRvdo=;
 b=hskT9PeqP5IFj09F5DfhlqTFTZGoy3pmMwpaVCj9P0E3bMoMpzfsvUFQ0oQoxvdafWCGrXiABqEiQ8Zv8tPKrtCqsebEbRD0uV6R7QkdC6LHGMDabEgg6v6qlCBkoWGeqaDgKAzypYtqQXC7QFHXU98f+Fc1C4PtGaj+U5ZGsX0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM5PR04MB3185.eurprd04.prod.outlook.com (2603:10a6:206:c::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Mon, 7 Feb
 2022 16:16:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.018; Mon, 7 Feb 2022
 16:16:16 +0000
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
Subject: [PATCH net 0/7] More DSA fixes for devres + mdiobus_{alloc,register}
Date:   Mon,  7 Feb 2022 18:15:46 +0200
Message-Id: <20220207161553.579933-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0066.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::19) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e165a764-b363-4883-9eff-08d9ea552ad8
X-MS-TrafficTypeDiagnostic: AM5PR04MB3185:EE_
X-Microsoft-Antispam-PRVS: <AM5PR04MB3185B80CCDDFB674F9E9C40DE02C9@AM5PR04MB3185.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uAUSnkf3ykvCDx7lA/cOOD58ofsDJ2Ayv+EsGqgrcVLWd3gMpNXj34CXwGBsti5F6T8IlgY5ovyVRZ/3ppMdojWO9Qi5NSRCoAdyg/p/1+m1pZ/oyLFfi+kfzXfp+yONKMZSY12Iuu2CiweQ/hFRXsUNrSV3qJ4DP9Nx3/jDtAVcFITk74jj15n7eG7/sGjMz2uR0JvbytN0TSA4aDkkPuL2wArztG6hrjVevSn+RyiyRHGbKDLwb6V+OymyeMATyajisNsdQ3YN4vPreLC5XJYZ4KeiLWlyVyfQGWJKDJjbp1YAJWfmGlFzQ++kRDCqx2JaJvgk7nFOn9V3jlkSoAbyeLycE3Yh/nrOzyHiTzCD28enQaePnceX/bO0RpDLQALDq1sJ/ZZFGKxyvcl62ra2OHbdQfeLbrezl8u+OFU6Sc08/YcFw4ubFoOJQ37H9iDi2sq8MWpW0XzHfk6yWsN8BBV9ivinzHpqd8aS7QnLAJf6jhreCLU7JyaBSRjRH+xfK59ylJVdmEpe0TVJ6jNlxSjl13znabXyrTqksQ26zXywd8YvS3hRHihLvOeyHcSaRzgptNDrlx5IeVpAbdmz++JtufDe1XhfQCxKIj+kEICpI7XKDrxlas8vS+xfBh7MAJ9h7GmeWfbX3uZZ+AjaBSAlTiYuMnnUHUKcLNfXtJknI/fK+cjmsh3EhTdwbsNOuJbuDjDBA2wpI0Z2uHw/6FoIF/rgCtncS1tf59ZAxAMV/o0u5gcZTpNMw9/9AshZAR9hXCb85kQD0ABKSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(4326008)(66556008)(66476007)(8936002)(83380400001)(36756003)(508600001)(8676002)(1076003)(966005)(26005)(6486002)(38100700002)(86362001)(6512007)(52116002)(44832011)(5660300002)(38350700002)(7416002)(316002)(66946007)(54906003)(6666004)(6506007)(186003)(2906002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g4WkWPlK70m748CIVTRQGsDeEtvZuDg/MwuhLvVWQ+Df8hf0ZmVZMLE9EPU8?=
 =?us-ascii?Q?94CR+8N7v778X7Pt7iXXoDVCLDKka81mDCoqeJXw+XpQUX7FByAnU8Pw2CkS?=
 =?us-ascii?Q?t32Hpb5MHPwIRGv6iBFHdN7vnZjYE2+tnreGjPdf1zb2Hjmyr0fo2MjftDU7?=
 =?us-ascii?Q?+tYQPpu+zfF8fEB4Rod3IFw4C6O/uzCb/hHFUiCQtxXGBYCNH7CHlgYtD1ll?=
 =?us-ascii?Q?6R9Hkc0YF0lSLwV0hhE2mNEhbiHlFY9qFAeM70D+BMGrmek1iSTs6J6id4iu?=
 =?us-ascii?Q?HWhFbFek2C/fXwn6fUqhU7A2xq1qq8dehX1Dk1KkGOEBPnf3KQNRliJUlvH/?=
 =?us-ascii?Q?M6pJNudJ/o2yZOC9RZQw9MkjOOaMQTYIDxI+q4ZT56N7dF75msBH6Y2IDVAy?=
 =?us-ascii?Q?2n3MB5bQSRtN3oUcu1TII5JWOwMsQCaRSzz2Dkpo6VQQeYu/MS8eAFkFwruy?=
 =?us-ascii?Q?rHarcoencoiwW1B8xiOxvPUWR12pp/UzBGN+N94N+T6x0w/qbkPJ0xt9oKzL?=
 =?us-ascii?Q?iIPvd3acsx24voRny3MpfoOMkpxVj0CGmjzsj68e7b61SVvN47b/2f5TwvMF?=
 =?us-ascii?Q?HgrQHiuC1fCZZyW5UFSU57dznLFJcYGD1nDKVVRWQkl0k7ktfjs8eOkXkK/a?=
 =?us-ascii?Q?/lA9qyogctUy90Z3DgoLc9tVFvOVyH9dqFPoR/kaUalsVKgOlT3ECoQRPd7z?=
 =?us-ascii?Q?D8KgYibSQQ7cHLn+xogrrZkjDncGLx8herXnIO+RS6xITRuP7wTScEDzDZxt?=
 =?us-ascii?Q?O9BxDv8CW9bZqGZNxQCPaK8UKOGYEUV/RKTgneKFfOYWA9YT2mH9Ef9PYK1l?=
 =?us-ascii?Q?0ffjJf2GLQ7IaH4ZGepDHjxkZpK36lltiDzjtKkKUPAQ6AiPHAiXKvgZXpR5?=
 =?us-ascii?Q?tHOAv7gvhdE7/M9ZvUpuQf/FezT6LguGBEDcxI4Aw6KcXOwmMcam/NgofFMD?=
 =?us-ascii?Q?JYfrjds9f9GlNv9OoF+SqiatlmIL5ih9f+/O6gnk/Qhx6yhCiHRqFhfOpp9c?=
 =?us-ascii?Q?BpyYnCAnO2/qYxaX60Dmz+GNBmUHRkMEv7RnBwXMeJrnk3TtUfY7bmTbQQer?=
 =?us-ascii?Q?JF6SSI1RZS4WzNLt+cZxTZBm1QWEaYfeOsMCyQlC7ot6gtDyf8J8m+L+4HUn?=
 =?us-ascii?Q?27oDAXEZ9Do3Cw4y/lpHwk2tVScW7R8rfQWMn7UpWRbVMILMG1uvthIOqZSb?=
 =?us-ascii?Q?4THmq9jntKOOXavTP2OzfJdM0hBZ4PNGy3uliglHmP+BfMTY9EYbMhKR3i2s?=
 =?us-ascii?Q?1xMmU32NIqBy9I3m6moJHMYd9n8SWlmiNVzOqr7DOSsu+e582iHfL9Nb3G4/?=
 =?us-ascii?Q?CDUDVCKMOXsgWqWVNke3yJI9qGkFK62MXdiK/9EdHjhuOZmZxSY0Z1hmzRCk?=
 =?us-ascii?Q?UBZGdAFW9DQ6+EfcYIOIAg9Zx20zAUAMsw3+UMc1yJbrCx/cNBLu3/HtC8bi?=
 =?us-ascii?Q?XgnaurdqA5BBuwE5pdc3e5BErkRPK5AeEoagxMRFyEGimQD/iB6trDBCGh2A?=
 =?us-ascii?Q?fG9ez7c3TqHOBDUP/PPSMb1fhYzAXDKx18h0qNaPkLJtSOUWrg/mK3TG6O45?=
 =?us-ascii?Q?hyGmJ55OK+j6PI1nDko0zFx8mbciq+7TKLpcAb1lmeIKZk6xDz0KEakPTILj?=
 =?us-ascii?Q?E1xWPYuEdBzISktL/KCUw3I=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e165a764-b363-4883-9eff-08d9ea552ad8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 16:16:16.4407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cqQvbt7/BvjobQOvhH36qHIbs3lNKQrOyr1LghYV6CvylTy5eTbq1/O2rUjoRTIKP06tVGQeQ+YrqQ0FAQEWqg==
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

The initial patch series "[net,0/2] Fix mdiobus users with devres"
https://patchwork.kernel.org/project/netdevbpf/cover/20210920214209.1733768-1-vladimir.oltean@nxp.com/
fixed some instances where DSA drivers on slow buses (SPI, I2C) trigger
a panic (changed since then to a warn) in mdiobus_free. That was due to
devres calling mdiobus_free() with no prior mdiobus_unregister(), which
again was due to commit ac3a68d56651 ("net: phy: don't abuse devres in
devm_mdiobus_register()") by Bartosz Golaszewski.

Rafael Richter and Daniel Klauer report yet another variation on that
theme, but this time it applies to any DSA switch driver, not just those
on buses which have a "->shutdown() calls ->remove() which unregisters
children" sequence.

Their setup is that of an LX2160A DPAA2 SoC driving a Marvell DSA switch
(MDIO). DPAA2 Ethernet drivers probe on the "fsl-mc" bus
(drivers/bus/fsl-mc/fsl-mc-bus.c). This bus is meant to be the
kernel-side representation of the networking objects kept by the
Management Complex (MC) firmware.

The fsl-mc bus driver has this pattern:

static void fsl_mc_bus_shutdown(struct platform_device *pdev)
{
	fsl_mc_bus_remove(pdev);
}

which proceeds to remove the children on the bus. Among those children,
the dpaa2-eth network driver.

When dpaa2-eth is a DSA master, this removal of the master on shutdown
trips up the device link created by dsa_master_setup(), and as such, the
Marvell switch is also removed.

From this point on, readers can revisit the description of commits
74b6d7d13307 ("net: dsa: realtek: register the MDIO bus under devres")
5135e96a3dd2 ("net: dsa: don't allocate the slave_mii_bus using devres")

since the prerequisites for the BUG_ON in mdiobus_free() have been
accomplished if there is a devres mismatch between mdiobus_alloc() and
mdiobus_register().

Most DSA drivers have this kind of mismatch, and upon my initial
assessment I had not realized the possibility described above, so I
didn't fix it. This patch series walks through all drivers and makes
them use either fully devres, or no devres.

I am aware that there are DSA drivers that are only known to be tested
with a single DSA master, so some patches are probably overkill for
them. But code is copy-pasted from so many sources without fully
understanding the differences, that I think it's better to not leave an
in-tree source of inspiration that may lead to subtle breakage if not
adapted properly.

Vladimir Oltean (7):
  net: dsa: mv88e6xxx: don't use devres for mdiobus
  net: dsa: ar9331: register the mdiobus under devres
  net: dsa: bcm_sf2: don't use devres for mdiobus
  net: dsa: felix: don't use devres for mdiobus
  net: dsa: seville: register the mdiobus under devres
  net: dsa: mt7530: fix kernel bug in mdiobus_free() when unbinding
  net: dsa: lantiq_gswip: don't use devres for mdiobus

 drivers/net/dsa/bcm_sf2.c                |  7 +++++--
 drivers/net/dsa/lantiq_gswip.c           | 14 +++++++++++---
 drivers/net/dsa/mt7530.c                 |  2 +-
 drivers/net/dsa/mv88e6xxx/chip.c         | 11 ++++++++---
 drivers/net/dsa/ocelot/felix_vsc9959.c   |  4 +++-
 drivers/net/dsa/ocelot/seville_vsc9953.c |  5 +++--
 drivers/net/dsa/qca/ar9331.c             |  3 +--
 7 files changed, 32 insertions(+), 14 deletions(-)

-- 
2.25.1

