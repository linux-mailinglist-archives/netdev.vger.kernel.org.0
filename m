Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7405F6C7B
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 19:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbiJFRDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 13:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbiJFRDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 13:03:02 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00049.outbound.protection.outlook.com [40.107.0.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF376550BE
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 10:02:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=buMuTqgv6AfZMIjHmt314ZXCF2aCd8mZ5o/hrktrEo+bVHwjK31tKMP+YasDAeNMCMMD00BxW1kzFul0OaCyKmQMhcXbdT1OHuKQE2N/aIy1yKgLddNArrWs1fQ1+oUFSpuZTuglzMorqIdvkZgNjfOMl1WU6ihyB6wTwlkXsA+XMuEyghvEGw/b1Ug75x6LSN1xlRIg3VsAI2hl3RbKw9oQOQoSQ9VBN+6OTfGSsAMEZIpihvKZFoeJLz8ZKw6duU3RnvUA8VYQU46cYl4XmAIFezUhPmMx25vZV9hun4acWn/ziZRZ0WuCCBqF7FIMGL8zBgL9qn5Ff5aN2slpBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QLgEbTyScnoAFkPE9Omey/Dav1+50vXXPmQCtyUo+Rg=;
 b=MqNp24kZWq9Q80R8Mx1ggQr7erwwaFBINpmWZn1kzNLm6d8myqvpyhyZ3wmTd5q81yWb58eOwu2q1cBbF4bDQyj0BFEn4xol8xvVrisciYPymxaUJtic450PYhP5F5rEYvbd+pe+gQxSu3bo7kaqmV2D11I4JgEgeQP0UbLtvWb+YFxehQCgLjM7dl14yagWU4dHZvxiFZ5LvyYgZ6lsnf1oMdBaVeWgPehicbSIXRi/hxMudoAJ1R/J7lv2FvyeDinkt7+TkuxobSdaflfbV43CCAP/7WJtl8DFEDwIWRDGSlSPej1SWdweEcTidzFX79pFlmZXUGNDcsPxyVUOvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QLgEbTyScnoAFkPE9Omey/Dav1+50vXXPmQCtyUo+Rg=;
 b=rAFif4HQoLsymUlhy39q7r9VzVL7fjQd1dicyHqbThdKmqbn+Ule/I4rEz5tCiac37Fre6Mr+f1mpEtCMk2JvbgQM1Qb53q3fEO7FzC4Pkn5ZemiXzOzug1CzVmHXqiBoFXjHkptI/HxUv9AjDnPFgdM8E//2i625h1LSNPPiTQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by PAXPR04MB8509.eurprd04.prod.outlook.com (2603:10a6:102:210::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.34; Thu, 6 Oct
 2022 17:02:57 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::fdea:3753:5715:9758]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::fdea:3753:5715:9758%7]) with mapi id 15.20.5676.033; Thu, 6 Oct 2022
 17:02:56 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, imx@lists.linux.dev,
        Shenwei Wang <shenwei.wang@nxp.com>
Subject: [PATCH 1/1] net: phylink: add phylink_set_mac_pm() helper
Date:   Thu,  6 Oct 2022 12:02:37 -0500
Message-Id: <20221006170237.784639-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA1PR05CA0007.namprd05.prod.outlook.com
 (2603:10b6:806:2d2::9) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|PAXPR04MB8509:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bc839fd-e86d-4aab-567a-08daa7bc9d7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G6hGzBRKgjx/kiyFTToIhRWHUxWoO9tYPCYtw7Aj76Ao+c+cq3zoiayntO+VLGDi60Uw1Dk2V4FIej97U2mZ0uKvS/8C5WHtBH0YzzBJ4ee/GH4/ytgceAwTZhfudAgPe5yR39aopJZ06arT8x6hJurG5CcYUZ0/ix5UFytVqAdYN7Ev15oteU8d5MJr7olihxlyBe5M6wrrm85Y03e2FGtyXt+nqq7WyFJvX8cNIr72Vq/iZgTk/buMvqkKUF6XWDHc5bc6ofo/fFknANpOD6y/Eamr2Slb/tY6J/QqRWo64plLC11X2eDpNO/h9BalMexiwtfDS5415z/ciSbLtbsAsHhQEMMqDxGg9Xpj4F8HFTaE0svhxUZGhpsAPfq0bOpWHm9VchyXuAVdqpAuGM741AnoqnkfsOMBy8j1wHrLsPZBiapX7mP9hOb7kYX+uPAq21x6687lf7FFhVZwOKjIJXD6h5FHVl/Nw8M5pB4aYFuFLRUPaMxA6tvddd7dq5TPCgKwRgdS0f9c3XI5CeZLlrNmZVKuJnjr72tq4Ok1qlaJO1ccvq19oE5q8m8QB+hh7EVC59oK23YJC+LjVCxXsPU7v/mGQrAmFmAhjRi0wJF0rkYCu0xOm7BjhE6ar+pS1LVqDhmdHb97NWO2ZXW06ii9AXSED1GzOQ8MVd6KN8X8+16NLWIrRPzd6ZkvgNn19YXhkM8TNT53b3WQ+pOHpxsHPmR5OnI0kKxeuu+DJnV6IOsa4FQdBRzUgqLcTPBbzhxtXTUaZDjdYctYyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(136003)(346002)(366004)(451199015)(1076003)(44832011)(186003)(38100700002)(38350700002)(86362001)(83380400001)(66476007)(8936002)(5660300002)(110136005)(66946007)(52116002)(8676002)(4326008)(66556008)(6512007)(6506007)(2616005)(55236004)(6486002)(41300700001)(26005)(316002)(478600001)(6666004)(2906002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hd76qLOEfI+ShwSBrT3V5jsHumyqcAU39sdkSXlUAZNVE0BZuvYO8ZicRxo4?=
 =?us-ascii?Q?L7+onpelj1LMBWZpW1uQvJF9GR0x9m2Asy8SrfwQgmqkPpj6YXCHRfQYaXD1?=
 =?us-ascii?Q?gIUcVtv5GngQ9hj/SMP+wlyrRJCmXOpFuIjN4JL79MBfWrmZ7s8ux72g3+NX?=
 =?us-ascii?Q?rXj2AYxMZBL/Uxjd9TFk+QVfHq3ephETRxuSatuj2TbIeZYZhS34PZ1Wrd9m?=
 =?us-ascii?Q?ZGoO78AiyhiqRrqUo5UPI7JUolVLyx+3ZZaSHjXVmT8fVor/P2AzOlseAz4z?=
 =?us-ascii?Q?5kv1XbrnFsyZakBYlK/Z20em/qROZBw19/VoxSXEKtDofGoMLKHEf9Qj8ZyA?=
 =?us-ascii?Q?m3+KOwuiADzDz28QyjLIoymTXPyL09Q7oZRDao9Vs2GZ4xuap7GuiYMw2zLZ?=
 =?us-ascii?Q?LGhi2AkG3VfBGYK+aMmwa2FsWVRDZ7nUF2C5IqybhKlGHAzY7F3G4/LCLTxw?=
 =?us-ascii?Q?wIPZaJRt7QI4bAYZs0EpKkGtQV5wR/qLiqwFqmh0Tw3T3DXyKdBsPYDqskeq?=
 =?us-ascii?Q?Br4NA4VReeODf9cntbQSg/dwUonqOkMSYSMw2vK/O/hIJbH34/bD1E8zEpHM?=
 =?us-ascii?Q?NeVFP4M2jxi+Q6UqAqf/Dbypm9ZuQtYWGtiOJkKmZUUfoqroFLN0xJ59YpBZ?=
 =?us-ascii?Q?T0xdBYtrv1hQDYMixOMCQImvlge7r7ScdNPcbaeqVJ8YS0pImmv4NkVawUcc?=
 =?us-ascii?Q?l9qjR9Ny2+0EUsruSMNr5nDQiYPcrXYeE8vzvVLCu1EW5Na/zL+KwV/sLGY/?=
 =?us-ascii?Q?LZEYRSgKyUQCfKYsNoDzbkCdrG4M6gMIR9UIjQ6XuZ99T6jG9JvgtQddQztQ?=
 =?us-ascii?Q?xJHyhLWz4Ewks75Y9z+ItcREjQYn84STXLsv7V2rIo52GoGP5d1D9kFfmpx/?=
 =?us-ascii?Q?m75K+uUY+uqKs02ftKEZDwF5qPdiyft0WboCq15zPmiutj9OfFZJLr6neBZ2?=
 =?us-ascii?Q?sMqEUrIfC5ZmB/jAMzWDL0hPF1+GNy6jJ/pVMA5iwIVPS7b+N1HWH6yWqg+4?=
 =?us-ascii?Q?vRWzYWOEEcPXG/ijFNfEm1T1oB+CUY2qLYoiDUM8tvGWuGyuJW+DMD9HGqT3?=
 =?us-ascii?Q?UDbcy4NLcwsCXpdpwL3WNB2BbIIIW/hMFizbdYcYW0Q+8QJgUCpsBHsxmXXF?=
 =?us-ascii?Q?xcyRVWyTakJ+t3+yWJm50wILvZswGqqBdKsS86PnvUmp4BiFZ1AAP9gmqvFI?=
 =?us-ascii?Q?Uam4UbawKH72KOLoP+fJbUizYf73xSA5Cw+pwL4xr5ez+rwejhXVaHt6Et4O?=
 =?us-ascii?Q?h/Hhl0tctiUglF8F6XvouPBFktNXrFjesb0m+yVNfL6iyV+W7UGeFTKyY18A?=
 =?us-ascii?Q?m4MegJT63ARHDk8RSjm663x24aqPg0zCMbIcwNoG6bL4b/6LPyc7CWqEGl8u?=
 =?us-ascii?Q?Ithli4TsRqKinVapiG4F6ID7Lg3RajXjskRBzlb9OLPw44N3F0Cn9dXy5kPg?=
 =?us-ascii?Q?/YEGmBtKZo5Wj0YtbkpwNSErlrGbiqUZbFQXj0B8mrMEGlbdlZYaDtQ89AEu?=
 =?us-ascii?Q?PiMUqZxD662jv+NZ5U+mpbYpqmuXpRU6xbE0OB3dBFQs7GOBJK9Ud98QvwFo?=
 =?us-ascii?Q?sl7qbIzrMP888VH2ubFGj97aGbG2DareY1YqIDhSAds7os2IBwbcEKbT3FLf?=
 =?us-ascii?Q?Eg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bc839fd-e86d-4aab-567a-08daa7bc9d7e
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2022 17:02:56.7112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bhe6wrUHlExBphqzlMWWpwvI6iBlEY5EYo0X39VeK92VyFt+INIQcMvdiAEHyJOKUdc+HvakyI93m3LOpJDW5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8509
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
 drivers/net/phy/phylink.c | 9 +++++++++
 include/linux/phylink.h   | 1 +
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index e9d62f9598f9..a741c4bb5dd5 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1722,6 +1722,15 @@ void phylink_stop(struct phylink *pl)
 }
 EXPORT_SYMBOL_GPL(phylink_stop);
 
+void phylink_set_mac_pm(struct phylink *pl)
+{
+	ASSERT_RTNL();
+
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

