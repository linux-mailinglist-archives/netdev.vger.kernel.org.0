Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8297A5F7AC1
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 17:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiJGPnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 11:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiJGPnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 11:43:17 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70052.outbound.protection.outlook.com [40.107.7.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5ADD73D2
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 08:43:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PufbrgwD/xYW/4+x2VxVtuSEvgCMt/VziTrloeUI3L7EGVvIXdxe9NMGjPi+TujRMZ2EjCYFSQftTcKzZK7Z0hg61gf0KOkiucbNdeH0aMmDAfOiKHKDtdg8Myv0u1PIycJQQ7nONc8KCqkRmwHxqQ/iIZ63K8YiAS2KDlVLL7E64W9dDIozJg/gpRHRHQEo+/v0+j4MRi2yKcg8TicYVUqgk+3BQvl2c5n2hIqdiqQRb2ACeR4gi9Eg8h0SNHt3/4JgxAOifp4arjrF6RI3Cb8OlrD5Hb6JGY8P4yWdhLp2SObUC3I6DPMDCwrGIFEJIKTXCHFVWdiGiQQ4VI94ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uCaLSo5b++WEnGu+FWWxrAEtaFScnDS/vHKKk/BrneU=;
 b=RIx2sYY8xDfQE2yXaqyxqigtWRvhmV9BVPHI7Di8nRz9aAUT53wUMuZQ0hXPMvMWzY72VlBrZQkUG3rb2rYO6AuNkfiilexySFUKp+3ebOS/dgOzPi0TvJncCmAFHAQU3kFgQzwumFgM71fSl0vcZkR92kX9BNCvxZHvjA0VL/6XMS245omuoreFN7rH98upr8dtrovZteqnljBMlIXb3AWZaZgON0ONXBFxW0zt3ABGMADXmYtSUQAcb05yBJEJPh0ZC1/xk75UOBE/T4e+0GoyXH9PoMDhDLgK0pzyTekXLK7kIAuEysVNVfElswD4ncHGz7MHtpU8E511p6sDjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uCaLSo5b++WEnGu+FWWxrAEtaFScnDS/vHKKk/BrneU=;
 b=Ors6WebHNFUXqKnIT/wNK8Rp6SGyNy0m+SQs6IE/tk5RlnucZXjMqnjdL1/PhTVDOb8iUB1Ph4Rg79JXHCyCjdxLiFawD0NB7EMAxjGh4EWhiiPKfbtN3W8ua7KHr4HZZj9rjicjGQMmQUUDjjUjkBJ3MoviUcgChzzLskRcWQ4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AM9PR04MB8356.eurprd04.prod.outlook.com (2603:10a6:20b:3b4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.38; Fri, 7 Oct
 2022 15:43:10 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4d83:404:c74a:7563]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4d83:404:c74a:7563%5]) with mapi id 15.20.5676.036; Fri, 7 Oct 2022
 15:43:08 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, imx@lists.linux.dev,
        Shenwei Wang <shenwei.wang@nxp.com>
Subject: [PATCH v3 1/1] net: phylink: add phylink_set_mac_pm() helper
Date:   Fri,  7 Oct 2022 10:42:46 -0500
Message-Id: <20221007154246.838404-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0033.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::8) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|AM9PR04MB8356:EE_
X-MS-Office365-Filtering-Correlation-Id: f654c202-1ae5-4d34-1056-08daa87a9e77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zFms6A/AqhaWiLY1ZOOLuHXkcE8bE0Bue7RPr6J9R9uR7YvJa6ISTVUmmab4VGA0Fq/RtvHDcJo4mpMViVvUuLKcVuh1hZ+f9aL3DV6E+zPWlpjZnz7ZhuFLtqsFPDgWHITmR91LULraMIDLGsFxgHyH28n/fWVegrl5y/07vfTwWF7qyRKIbyU1JZ7iXk2+oocSlItLKmWBmHcsErplUcVzkyNAA0/gv8l7ibS6R9K9rwF+EhttHkm39KCiISCvFOd/B8QiE2WwBdzV3pCtGCY1jrACfEQGStXn1ecGaxnKpI094XHjBPAj+wz2IYG4fDAE5gOldgM0syt1oOiu8tU5k6TRJNtV5VtUqFygdXwE6Myeg+iVi8KqcWRYxAlaUVdbv+dBonW/inbMCkvcWTC4UGnxIuAFsZ6b9m0IsmG4KWW5CwcM9TvJAa4EiDXE9W5Y97mFxMZ1cDrQzbIpcl5nJSv9ll8y3o3h5EfYmZ81h4ydYs3o10RmLS8PICo/0Cz99JPy1HJsWtDcmTbzXjQ9OmUq24hXr12CNqckx5UDtRuoL4mBA9wXvKcvWOmFZiaw5oOJ1On0EvoDmdpfXN6gCzR8bRZ+2XRsFMRdkudPgrGeyf7YGVBf3RIxIiRCwRf58vfM4ApDEDIifwcuAUnnyMGG/Z1mL5/rCTapJNjbNITyVdDW/U/w7S8X0uO+JtWtK+A7VKsHRSPPgzxGmbleJyD4l3r6GDp7p+/ZN9+mbngHylwK4Cicqv8qcHjBOeJM62DGBfR0eqm7DO5bNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(136003)(366004)(39860400002)(376002)(451199015)(36756003)(38350700002)(38100700002)(83380400001)(8936002)(86362001)(186003)(26005)(1076003)(2616005)(44832011)(6512007)(55236004)(478600001)(5660300002)(6486002)(6666004)(2906002)(6506007)(316002)(8676002)(41300700001)(66476007)(66946007)(4326008)(66556008)(110136005)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vub2mYJ9Rqg2FDq2cwxHDSaouW2osr5p2imVazTo045IKAFRLwKIVGeyaIBG?=
 =?us-ascii?Q?F5EUNUzRIFRT3yjcyMifeeUVkfb2c7Ad3KqYhep0sqyxUqzQdOBeePl6oOuC?=
 =?us-ascii?Q?8OsgucuJxs9+g/r+20FxS9zEcjbcpVlXWm27XJuyJGozTHjTk+YM/lHOGptF?=
 =?us-ascii?Q?NQwOVh/VZ+SldNhymwHrtIZI9lcPRqUylAbN90Pre5ycUTqPQlbcNKXZJ7bz?=
 =?us-ascii?Q?mEQWaI7BwQ4hnvY2qAi5shKP31b7R2H4hoKccpgEFR467DXgBiOYdBmW+wpT?=
 =?us-ascii?Q?B5O9/uVXigzxn9E/R92uYJzQsNjJH4BugGiFn14L/c27pa3KH413QR8rme/J?=
 =?us-ascii?Q?RAb4jH4KruGtf859ZsoEpTwW+VnuPUspzV9r4SADkeciB77pcMM+WN88VIDq?=
 =?us-ascii?Q?J2JKerSa53259C7RwrT/UL558wKDhqfhx5jBk6byC1wHiK9YMW+/qmgEz451?=
 =?us-ascii?Q?QSXO5lMQ/p7jn7R4yZ77uvIFR1+t5rsIZdvNKMSnxW7D529Nd4VCRo8j7QgV?=
 =?us-ascii?Q?423+/adcr4KQdxBjdo3xiHhh3yN+TU6i4Em0ATRWe1gkHAvJCW5SQioB8l51?=
 =?us-ascii?Q?7dLhmpSjhb7Av2o1gZtHd7etbojpUy7oe+4QjhJDWTHuIRofzpiQtxvd+C4z?=
 =?us-ascii?Q?hC1Ofc6EfsmIxzNfnvEHVVOwfVN1tqycEdp1OxJynDVG5lAoPNNEq9JdaeGc?=
 =?us-ascii?Q?tfOeOVsAD7F/G4xVcXtoBrqe/uzUMbrmGxnJwNxDqkdxxGrBCc0JBGuY0Uth?=
 =?us-ascii?Q?z5e4LuCn0at9OjSrJ7ZsKRD9iK5v0VQge5F1sLJgHPAMFDushBaBmn9l3db4?=
 =?us-ascii?Q?XLI8mAIziUe4l08Exa/y8R68dj3JPvLfjtONEC9++0V4nW1xSozqitIomlsi?=
 =?us-ascii?Q?66lKPCZzPajxpAUQeXnPsJOpVw7T1UOxza7dbGV1QuTIaGlxsmUL/cNrtWOn?=
 =?us-ascii?Q?Pm41kO1VLZ2xM0nhfA5h6wWnd14H2xywTzYmyJ78fKJtQzEg3vePCSzWJe/N?=
 =?us-ascii?Q?WuO2gUVjjydZA06eMl3XCdKhsAU3h3u7HIyFT42bGZIZOUCoEmpuw0wkvA5l?=
 =?us-ascii?Q?M2nYiiXqCu2F89lDwv23Me2WDdivnWQPK0q+ryarK+bBVNfDa6cT7A6SabNa?=
 =?us-ascii?Q?Dxo0xgd3cQG3+B9bSqrRBPgNKcjpKTYSiT5wnNFGpvciBi0jjdxMU63mZQks?=
 =?us-ascii?Q?wz0u9yLaWN6n/uWOCtuYiM4MYVFsK6/iOS29L2Ct+qF8WehnlgTQzR0+D7Gs?=
 =?us-ascii?Q?LuXhZ4rRphDYSqJfA6ElKczPgtvurJ8KFxZj5Ialj8gmRdZmpuEV0LgKhVPX?=
 =?us-ascii?Q?wMEcVEh/3m+DePPEPLZgD1AFvs/zG7SVdEk5F1PD8A03UayZ9uQDQoSZt/PZ?=
 =?us-ascii?Q?TBacUngLW13+qBBxIzdGfl1MCqgjOxyLtNlLK0vQJ+6sgTOdas5yau+pQcFz?=
 =?us-ascii?Q?T4rzGHzGfURSG1HJIPA2+PCUE0KPnMGTcCaxG7CtPn6O5hAJr8Z4OCtOljd1?=
 =?us-ascii?Q?CE3LsBu6gmmud4qaBa/++T4XdpTPlMxId6VjxUTi1az0vKMioKKGFFPVVXtC?=
 =?us-ascii?Q?CzlLtqyuhyfUF137lBwpKf2I+eQc3JztqRZpEKKDp8cZMfOuwXNd/99R9f06?=
 =?us-ascii?Q?hw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f654c202-1ae5-4d34-1056-08daa87a9e77
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2022 15:43:08.8107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oZpUvpxBQfFMgHyHHodCsfH0rpEcaG0APpQgua1bNUmpkeqIvvMGME+SIf07woNna8Z9T/GyPcFlFq6eFgC5LQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8356
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The recent commit

'commit 47ac7b2f6a1f ("net: phy: Warn about incorrect
mdio_bus_phy_resume() state")'

requires the MAC driver explicitly tell the phy driver who is
managing the PM, otherwise you will see warning during resume
stage.

Add a helper to let the MAC driver has a way to tell the PHY
driver it will manage the PM.

Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---
 Changes in v3:
  - update the API description according to Russell's feedback.

 Changes in v2:
  - add the API description
  - remove the unneccesary ASSERT_RTNL();

 drivers/net/phy/phylink.c | 18 ++++++++++++++++++
 include/linux/phylink.h   |  1 +
 2 files changed, 19 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index e9d62f9598f9..e78d9aef7a7c 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1722,6 +1722,24 @@ void phylink_stop(struct phylink *pl)
 }
 EXPORT_SYMBOL_GPL(phylink_stop);

+/**
+ * phylink_set_mac_pm() - set phydev->mac_managed_pm to true
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ *
+ * Set the phydev->mac_managed_pm, which is under the phylink instance
+ * specified by @pl, to true. This is to indicate that the MAC driver is
+ * responsible for PHY PM.
+ *
+ * The function can be called in the end of net_device_ops ndo_open() method
+ * or any place after phy is connected.
+ */
+void phylink_set_mac_pm(struct phylink *pl)
+{
+	if (pl->phydev)
+		pl->phydev->mac_managed_pm = true;
+}
+EXPORT_SYMBOL_GPL(phylink_set_mac_pm);
+
 /**
  * phylink_suspend() - handle a network device suspend event
  * @pl: a pointer to a &struct phylink returned from phylink_create()
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 6d06896fc20d..cfcc680462b9 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -540,6 +540,7 @@ void phylink_mac_change(struct phylink *, bool up);

 void phylink_start(struct phylink *);
 void phylink_stop(struct phylink *);
+void phylink_set_mac_pm(struct phylink *pl);

 void phylink_suspend(struct phylink *pl, bool mac_wol);
 void phylink_resume(struct phylink *pl);
--
2.34.1

