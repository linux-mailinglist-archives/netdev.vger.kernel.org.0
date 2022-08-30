Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1215A6DF8
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 22:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbiH3T75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 15:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbiH3T7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 15:59:52 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2063.outbound.protection.outlook.com [40.107.20.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8360A108E;
        Tue, 30 Aug 2022 12:59:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+iSGpAwRIF+8Zje9nmC/8SPLrPBe3UZXlxESKxLWWpLPbO9wJfORTNSuf7ByTPYtTpHAHPB3ULqIu4Wb65mH64aNr5unACdsBnlGi6beNZR9HMpntaqnzvwEvcr9akYeDrKfh6H4P1uUGBqLytGPu/ujdNXZ3oyadF/2I7ohSlL9y6srcxA71cvBDwLyHEaKMZfjh8UYuBihMqoNG9BCdp+2TDUjmizjXbpsTOtlQYUjkYzCwftKBA3yUFDd1T9fz6Yiv/eL3RKCdGxRzT2Rqc7aOTSG4grKydAN69Xitjk7H3/XgmQ4sr8A4WHz2Vtiw6sx+VZa1wpNA0aBfW80Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=umXZbWuDzLvhEefwGTx3wHuHvXFqLYhD8d2S6wz7vaY=;
 b=ey6dsRYHLoBcU5PJGslLRHeTNlo4kKHPyHwDoxtIdVshBUVTwZMWz3DUFqmuAgGrn+nimEMyD4QucLf7tRxHCKVSQvgD1rgkiF3ge5CV+TKU96oW9UwTDNbmvXZBKW2PAwdaW+Z9YXR5ct2khMSKGqn+bykwlgaitGyebz9gMvYnSl4/rlb3JE7pwtKKBqHsRT18ZJOmomDLAP8IzpHvgwHEDNHaWEZQJaENeYTNdRL45N+QhqSQl+VfOnri17j+Ak+74qPTQ8Jn7Nm2y54cA78ee4DIeko6g2OagnOWn0TfduLfD21SM+OTzSCTKUDsML0JUvmu2El7K36bjDvdWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=umXZbWuDzLvhEefwGTx3wHuHvXFqLYhD8d2S6wz7vaY=;
 b=QNjF1+Z5GlScJ0sSPvjxK26A3V7a03OBP/VWb2iEcDw8NwUZNuAIFpD8daumnXFKRi3lIlDLmf4q3bR9sUUtXzF1cPWWFXTKnrC939n7uu6FoQwhE8axfTZUQijUKyXnesUME2MLSxGY08B3CCxd8YJ5/6mhm8i2AA2oR41Wqcc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6270.eurprd04.prod.outlook.com (2603:10a6:803:fb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Tue, 30 Aug
 2022 19:59:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.010; Tue, 30 Aug 2022
 19:59:43 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH net-next 1/9] net: introduce iterators over synced hw addresses
Date:   Tue, 30 Aug 2022 22:59:24 +0300
Message-Id: <20220830195932.683432-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220830195932.683432-1-vladimir.oltean@nxp.com>
References: <20220830195932.683432-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE0P281CA0005.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e3fcd36-97fa-4ec4-2559-08da8ac22ea4
X-MS-TrafficTypeDiagnostic: VI1PR04MB6270:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B5BR5EaM+ztyS2T30mSQTEKPvWdpa/KQVGG5EJq4y0RplQPSTdTaR9kR/mb9KNVG9U+pm3Kpmro2vF5NxSy8TOx8Ugzjn0H+gsZkgHKJHRzWe84+zHodtPupD+QgCGiWglEpiS7eZX3JRaTS8f95levzzoRF+hxxXLIg15pUCPWXn3qszsVGiZ1eRPyhmxr17kyK60pH1VUYDS9LkpfJgLY23x9sqmVq13ga0oDik0oB6L5mQBrTZtq/HTHmwKspB7X3fkQGKDTgxIh0/GzxcdkrGIr+iyIYirC3f3IfRSzL9wj2v5FbdPIZI34ZxmgLD8I03gYHBdfSJqfe0yuaNFXDnnzWBPzJBS4tLqn7o/NtbEi0ReISeRdM3Bt9szpZtRdN1Jh1f8ie7/T+0jCvDaFCtZ7SpxcB+NOxX4PZxF1ETgQSDj7m7O1BEgum5XyWKysf6ZEYZ4K9TlLxpjDi/rLQ0FifKg10IIb0FAi9ZOasTixiwcYmOkCn574PYmQYjJ+CfZ0GrLihpqctV8mSUewJRz+oyYPkj5PzB3hf1Xc9mlT2RvWDINke/DO0AsY7SN4KuHsS9H6lDHIVqZsN1yhmrFFiENE6h5Jxnn75Hy0RJ6SpeFzM3eUJEAZVyDvGZdM02nv/5fZFKrnL8t4c8zqQe+CYZAByypyuzNG8H0Yd/1EcL/+gbeIfZjRfXGX1hx2JL1qtczuHU1GCMgrcy1jrf6CUAFDD7H0YmaplKOJUADXaW7szWQ59FLcOZtmR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(366004)(39860400002)(136003)(376002)(41300700001)(66476007)(6486002)(8676002)(4326008)(66946007)(478600001)(66556008)(52116002)(2906002)(83380400001)(44832011)(26005)(5660300002)(6506007)(6512007)(7416002)(6666004)(8936002)(2616005)(316002)(86362001)(6916009)(54906003)(36756003)(38350700002)(1076003)(38100700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+6n6ddAECgAdvap7qsUsgd8hOrkLGVCkilvPmY6+uz4ucwMwqUu3DtMddJbQ?=
 =?us-ascii?Q?L75per88oEXLSwbyhq/R5Don8ZculB5xtF3d32Nt+fETtfVPOPG2x4CPATe9?=
 =?us-ascii?Q?AKxHkA/r8AEj10EGT3BN3/B7GZ2PdwnOJ5AkSTaOAu0IWeSG/JGCDovAlBHB?=
 =?us-ascii?Q?u2spp88aAt+W0wRj8e5hKF5s5ZAiGdGHpaMHwEacylkemDyTRcz/rCxSC1Fc?=
 =?us-ascii?Q?bJmhKIl7Tu/FEt4qa4vySlx1v7xKiBO5zytxaIw3yC7RIHe+UFuWioudjVXh?=
 =?us-ascii?Q?dT45YBep5Hm8aXqbB+ViNIUg6nYhNx3YN9gRzwKDpsWkVbVKRrpo03GsNkVI?=
 =?us-ascii?Q?FV3CzHd1ZuI9kxcn8yQECFMWEKDpYzFbcJhBfV2Gs7h8nTYdRDE6V+1OjiU8?=
 =?us-ascii?Q?aGO1qSVRjsoF40txqMQjoUFLPWwgAm2cZoCmVUFcZTHCWoW+LH0SUkKfDFRH?=
 =?us-ascii?Q?feMQbiJd8jxRSsKsETK6kyiEefMbmSo1uZl+TJ2d3bhor+hAtamTSlrHtXLr?=
 =?us-ascii?Q?r4RBsmHku0GzOqY7Yt5R+2Jcy7VlB1j10xVyZj47BNRvAdDT0RTbiYLBtDtH?=
 =?us-ascii?Q?M/ozrQet4sbt2eYBxdqOT+VYijhLnlNYIgK1yRSLodenhmyC9iWwOw7olFpA?=
 =?us-ascii?Q?BfxRMQQiMSdidSX8ZQ2APBJsTYQl+0qSiGD+ffPS9GzsGW/mWACLPURYyzdu?=
 =?us-ascii?Q?k9PTz1vUSOWVeax3VPbkDkG9fgVgGBTWg5oh0QS65ZeoemI2cFqiQ3eEPC7o?=
 =?us-ascii?Q?Ndh8vpzqxewE9aUvdglaXmdZKPsKiu1Mshd+I3IypW0aqGW+Daq+rVVCEhwG?=
 =?us-ascii?Q?bOZCHz+COfcIGOFApf3PBJuxeXYB9hFZQuO/pEqQSbViZ5iShs9/htpM508P?=
 =?us-ascii?Q?foUkvUsphLwOYoZiOm5g65/2/FZQ3u5Hux0D3AIqx5COYIqoV185gL6TMEse?=
 =?us-ascii?Q?MM2iS8set350tPGiRFM7xd3hT3Q1yHCbQrOu8Jc7ofB4mw5qDhLpvawrIalY?=
 =?us-ascii?Q?853Xn8M8YN80GwoG8bXfcwVjwhu4gK1rPVyt0HT/zFYDzS9KoaKi/5Y2o9rF?=
 =?us-ascii?Q?mWzO+m+Mn1sgRV8uAO26xUX/Tm5iB+ek5l46iUvc+oDC5hy7xpXFsSQg+Qcw?=
 =?us-ascii?Q?F4xqbjFYmUuTnJNMwTncxdFC51Md2eYKTt458fRpnnuyJDRr/5X5TqE6/6mv?=
 =?us-ascii?Q?U+656vZFad0MCoVT0wBZu/yYbqe33CUjIWUTUeEy0e/8XP/vgWpplPUvf8B4?=
 =?us-ascii?Q?tk7tUYh58rkqjL++m2JwEvEJ+aEcFbm3+p2Gk0RjUzuyfkdRgGhVW3ywNHM/?=
 =?us-ascii?Q?OwOk6HwR1IH/l1AtkNadgUtga2BNu59zYf/lnsLcsQrgoGLrrmXhu0Nr4bgY?=
 =?us-ascii?Q?mI9LQXIOBOc+lDaKgwP3oEHb0144KvXWfx0iAHkqx+9je9mecDvwmIO+WkBA?=
 =?us-ascii?Q?T13fTfVG6mUN6mUCV/VcXVD7o7Wx1DIDN1XayVYjKzBUr5iPwtrORqdntFDk?=
 =?us-ascii?Q?2+G0sDGh8wk6VyxBECQh/abKeziwc/j/GIR64xLs34m018G15e+6G+aDJOAw?=
 =?us-ascii?Q?vfAlSPPYxLMf+0g1RMZR4eol3Q+EeGEB5r7y2ZG+f1+HyBKYQf0lhWjSg6+n?=
 =?us-ascii?Q?6Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e3fcd36-97fa-4ec4-2559-08da8ac22ea4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 19:59:43.9488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5+h8oljntjcF+3hKDuz4UJ5nrDDiyHaEcrVI0uceru6pKNCyx1r9Epdbhz3mCH420u67KFqwWF4Uh+/ybQ1dWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6270
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some network drivers use __dev_mc_sync()/__dev_uc_sync() and therefore
program the hardware only with addresses with a non-zero sync_cnt.

Some of the above drivers also need to save/restore the address
filtering lists when certain events happen, and they need to walk
through the struct net_device :: uc and struct net_device :: mc lists.
But these lists contain unsynced addresses too.

To keep the appearance of an elementary form of data encapsulation,
provide iterators through these lists that only look at entries with a
non-zero sync_cnt, instead of filtering entries out from device drivers.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/linux/netdevice.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index eec35f9b6616..2979293b966c 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -253,11 +253,17 @@ struct netdev_hw_addr_list {
 #define netdev_uc_empty(dev) netdev_hw_addr_list_empty(&(dev)->uc)
 #define netdev_for_each_uc_addr(ha, dev) \
 	netdev_hw_addr_list_for_each(ha, &(dev)->uc)
+#define netdev_for_each_synced_uc_addr(_ha, _dev) \
+	netdev_for_each_uc_addr((_ha), (_dev)) \
+		if ((_ha)->sync_cnt)
 
 #define netdev_mc_count(dev) netdev_hw_addr_list_count(&(dev)->mc)
 #define netdev_mc_empty(dev) netdev_hw_addr_list_empty(&(dev)->mc)
 #define netdev_for_each_mc_addr(ha, dev) \
 	netdev_hw_addr_list_for_each(ha, &(dev)->mc)
+#define netdev_for_each_synced_mc_addr(_ha, _dev) \
+	netdev_for_each_mc_addr((_ha), (_dev)) \
+		if ((_ha)->sync_cnt)
 
 struct hh_cache {
 	unsigned int	hh_len;
-- 
2.34.1

