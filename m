Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A29377C89
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 08:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhEJGzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 02:55:33 -0400
Received: from mail-eopbgr70075.outbound.protection.outlook.com ([40.107.7.75]:40356
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229863AbhEJGzb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 02:55:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dOVpN6o+czR9c83ySUBN21vW+tt62oWLuCZ10eqZT5MFFPBtybWxy/2acCGStOElmoU6pGdhcVovUMrOIbX2D0j31LrRpqTomjUO189JAmDlBl/Ovi3UPzo3Ot1A9+v72E/unoJPpMddJ3Bk2ivRdFKKHCFxa/KxiP9z9wUMjm3wYgN/adgR7NEh6HwWLDZlfSX0YZ+z+jKojR4CeA765/jmTk6IPuW1Pw9YGImM91GNMgNOrqV6jxkI2VxD/4GQJWpkMa82f46algs/Useac4xaHC352/roQSZ24eAvjgm9w2R5ztkZysypPuQDGv1a2F0j+2LdzvjTOH6NJh07gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y3pEUsEGDmBnvLSWu4kY0hxXDXyrhstmVyjZRRtWloY=;
 b=LcrPj3wvdBgO58njHZWbQjc4pSfPQtnPt+iudCrbrrGafyOHIX2r0CidqwcMZiPBtKGUkl7PrEODj9KpJXUz29vNaDYDNE+mpcvnXbSzfNMjtsXPiIIDt9LPkXrodZXUDW3X59AvIGRGH6aB9ahfTxGxEVq6BdTh6h7ifIoaU2K26jZuTNrXXnFGg+2hYuf1IbJVHSSIbXkpObgTmW7exrvUW7NrdHFC2AOMUCvhy6ty/YhKO0qR6trRMUGw7riXndLZtuXMQuT+fzn/LYcBuT8pZ1jRmOQdV9/RQnzY9nCn1lsUxcFQqq430aYb7kM+uFNmeEQM3uf1c+4CcuVfZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y3pEUsEGDmBnvLSWu4kY0hxXDXyrhstmVyjZRRtWloY=;
 b=UFDOIRF3MP/7Vj4MB9iepw0nDzD47d3V0lqAIUQDR1dqfRer/1N42sA3Gl4YTQPGGbbHUzOfDSn5FcJeXrdIJqRLPewCxi8TcxLcIhxq9BgFIaZ4AbE4co5Kc4P+xMZ0D7rMLV5aNwDYtnpCkGVr3eneWBP38F/mCWtX/titi6w=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4780.eurprd04.prod.outlook.com (2603:10a6:10:1c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.28; Mon, 10 May
 2021 06:54:23 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4108.031; Mon, 10 May 2021
 06:54:23 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch
Cc:     Jisheng.Zhang@synaptics.com, netdev@vger.kernel.org,
        linux-imx@nxp.com
Subject: [PATCH V5 net] net: stmmac: Fix MAC WoL not working if PHY does not support WoL
Date:   Mon, 10 May 2021 14:55:09 +0800
Message-Id: <20210510065509.27923-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR0401CA0021.apcprd04.prod.outlook.com
 (2603:1096:3:1::31) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR0401CA0021.apcprd04.prod.outlook.com (2603:1096:3:1::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Mon, 10 May 2021 06:54:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ffe2a510-ec26-4474-7f54-08d9138071b3
X-MS-TrafficTypeDiagnostic: DB7PR04MB4780:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB4780255C7CED0D8D6BFC14A3E6549@DB7PR04MB4780.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:369;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l4JcKz3g8aLNv9vLHmibDa8INNihzdDe3y+X1GdAmH73QsvexeF2ton7gL6xeOuRRamggG7Hsy4yDuIzX47YCUeq/CWLlwK1Cq11/U/8w1bozaEhJQWUtWavrethyCVdoOg7TI9gFBfc2RYKiNtOJjqTNeBaHyUjLEyTgGlYDVtddZY7VLUgktj8P1gJseOHMljurHkb4Uw5kR2GeOwG2BhLNMxMmbjpl4zNOvoURsEzvGbaaeBI2j6eq036oiCJgZwG4HqvJF/RMXR5IMvlV9YTNL2F4ZSyKzoFGFBJrqTJD5CGQ+eezu6Q+bVnOTvlAMI8amDIAhMO0DYiapuAFO6exmvOIVOT7FzhusBb1YtO2nT5LAzrjc9WgUklyU0Zr1YhNG60gWD0q2i+lJiYwmJSl9FZ0haUWyglOTqKVyVmoIjRxFWuxVv8w4oqF+hPVgRHnAO6VSYjcLy/GxuDhDZ3qkgavdCSILEtpqvR/Un2CpFAitLU9mj0Td+spQf0BY8x5YY5z9amB4qOYxACrEi7BsGBXezGQKO1sV/RG6mFZ47RFA7EN4pAr8obySSe3OuCfZD+Vlv4gJEceTDbBlLiv+A1J7IvLj7WiSpaJnquUz9/Q4iyPQda+TR2V0blFQyy6dGwtKSrLElt3swkNa0yLDWWtp4uzTl52G6hdQ4dSj6MrKsb8ljFgUZte+/T4x0HYJqa5AaBj6EoAEF5sQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(376002)(136003)(39860400002)(2616005)(6512007)(83380400001)(26005)(38350700002)(4326008)(1076003)(8676002)(66556008)(478600001)(186003)(66476007)(16526019)(36756003)(86362001)(5660300002)(6666004)(66946007)(38100700002)(956004)(316002)(2906002)(52116002)(6506007)(8936002)(6486002)(69590400013)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?cIRlKpm7mR62MPylOvjVrJb2fRUZewEn5eAuOalFo1kNKi17YTayPl6GldOG?=
 =?us-ascii?Q?lqrRdq2qwawycFlUdxte65KjZ6lo+lEiHSqUm52rLe7O7gw381wHKVdgD/sD?=
 =?us-ascii?Q?BgLXDWoPcPmAbvNFAtc/QQrB2KT9VfqIgiiRNlFtU6K8NCtpJ5g/MV/oG20x?=
 =?us-ascii?Q?7iEfqBYEBfcZu6MdKM0iDYqOVJgGAzYKCWQpODUoAsQ4iIaSLhahKjsVGVux?=
 =?us-ascii?Q?UlPn4bw0HeNljBKKaMZuH7m2OiRXQrjgJKXLg53KHS38Vc6wYILNzUSIZAvY?=
 =?us-ascii?Q?/8OEb3/htBQdf92LM6Ad10OaWNrdDPRLtEASGd0xqj3Bw+BRJzmn75sCn8Dd?=
 =?us-ascii?Q?2wzglnRHYm68guLLZyvAsOccnz+GxQ6+PwhEF5YvB4iD1gFbZpT/OSEhd+J0?=
 =?us-ascii?Q?U8oC9RdHFVg0OsX17JSe6ZKiGuiGsE14/c9Sng7fZlE2eSpFNBaj11IRuZH8?=
 =?us-ascii?Q?GT5ZG+GjuIP93a6racu2gi/bN4MvdQDW81Ozc8RBMs/Tr+kQWS+77+V8JAdd?=
 =?us-ascii?Q?uE7d8L4ssmkEJ0hK3zHFMZ9qMb3MxMF2ITH00nIdpNCPHPbP2uTMXJftFryy?=
 =?us-ascii?Q?XlxJTYxPhd7GzaYNylQUtsDRibwvIm9vhqChr1TIXNjd+sU/nNTMS8MGt0fI?=
 =?us-ascii?Q?p2J6ybZ+V+YsXa5L/I0WjRrcj7GYPZb9PHejDf4SbPZe9u4J7fZPFBc8Aaln?=
 =?us-ascii?Q?qdryvWzxr3ZhUWEV8f+clK5UXTvJ3EogpdRfDh8KhKgi4lfA9iRWnEky71V+?=
 =?us-ascii?Q?TtIQA1eZiHZOU3fRID1QM81ji9zp5xePCo3NhWE7V4oOUcR843BN6YuThkU2?=
 =?us-ascii?Q?aFVABaaCNPTWTxDOK1S3WxO8DMIsz62DSkG7LcW9IDLoxxAT7LjB0MlrKiOR?=
 =?us-ascii?Q?vF/7RlLuX7jB9E4PtA6ZTlOEc6OslwvsPmz+5xaTplyRXw+WXgaNbDG1Zj26?=
 =?us-ascii?Q?SPIqGArMUUUbyJNn5Zt5Pq43TL1/wynPClcTUkARtk4N9kO5MArGBJdLvyxf?=
 =?us-ascii?Q?6fwD59Qp+rmQ878uLZrfH3M+Yqq8MoVFUrsZuBQHKaFJd2iPgDbmFHiJYTI/?=
 =?us-ascii?Q?HY/gJyLOta2/2+OPRLx5eLHMlEUZrdcWlTVdpqYrwfqhHenNOrDqG6g60PSI?=
 =?us-ascii?Q?+b9Jjp38ZUrgERlCHjRs6FMQgxtaPq3bHD+qOaWwjNXyIKhVL1bk8yGJUPW2?=
 =?us-ascii?Q?Sbx0xhc56/e2z6tkVJkBl4HJCP8vQZUu8WuEnPrQ1Wrr+yCydEvZb5HjsEST?=
 =?us-ascii?Q?8DM4bh40e/3ohjStvfqCFN5OIgnns+XwjGMnxFXqSSu+XMthnEraV9yc5FPT?=
 =?us-ascii?Q?jNO7vadihNwJZt18gAOpaqs2?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffe2a510-ec26-4474-7f54-08d9138071b3
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2021 06:54:23.5708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gJIgG0YFH7+tqWhYosCmAyKDOkaKkDC41ZLHp4Lh/HthfBB2d5u4ZMC8+fagsJwzVHogwu60au/xyAFvEf2CBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4780
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both get and set WoL will check device_can_wakeup(), if MAC supports PMT, it
will set device wakeup capability. After commit 1d8e5b0f3f2c ("net: stmmac:
Support WOL with phy"), device wakeup capability will be overwrite in
stmmac_init_phy() according to phy's Wol feature. If phy doesn't support WoL,
then MAC will lose wakeup capability. To fix this issue, only overwrite device
wakeup capability when MAC doesn't support PMT.

For STMMAC now driver checks MAC's WoL capability if MAC supports PMT, if
not support, driver will check PHY's WoL capability.

Fixes: 1d8e5b0f3f2c ("net: stmmac: Support WOL with phy")
Reviewed-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 345b4c6d1fd4..fea3bf07ae89 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1196,7 +1196,6 @@ static void stmmac_check_pcs_mode(struct stmmac_priv *priv)
  */
 static int stmmac_init_phy(struct net_device *dev)
 {
-	struct ethtool_wolinfo wol = { .cmd = ETHTOOL_GWOL };
 	struct stmmac_priv *priv = netdev_priv(dev);
 	struct device_node *node;
 	int ret;
@@ -1222,8 +1221,12 @@ static int stmmac_init_phy(struct net_device *dev)
 		ret = phylink_connect_phy(priv->phylink, phydev);
 	}
 
-	phylink_ethtool_get_wol(priv->phylink, &wol);
-	device_set_wakeup_capable(priv->device, !!wol.supported);
+	if (!priv->plat->pmt) {
+		struct ethtool_wolinfo wol = { .cmd = ETHTOOL_GWOL };
+
+		phylink_ethtool_get_wol(priv->phylink, &wol);
+		device_set_wakeup_capable(priv->device, !!wol.supported);
+	}
 
 	return ret;
 }
-- 
2.17.1

