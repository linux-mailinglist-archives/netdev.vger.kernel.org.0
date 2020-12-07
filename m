Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E34912D0E75
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 11:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgLGKxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 05:53:03 -0500
Received: from mail-db8eur05on2040.outbound.protection.outlook.com ([40.107.20.40]:45665
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726254AbgLGKxC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 05:53:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ht4tBIF2RzKQJtCyqAaJa9xc/YIh5/Uipc5Y27QmCR68D717MWJMEDWUfZ23iUJAHl6uKQSanfxIocUQtPVJ1RRh7VhX2xYwaEoLce32rI8IyDcRjnxH19+2yxn0I4AbUqkKfZXp6PfONSAoEJ5X0gaCNY29L+drX3U+goeROWfiC0kK5C+K1b2SoCF3Alu8oU5Vtp2Qbo9rlNPUXHAHN4LTaXdMMzGMFzr/sYxhe7qr7OqCJ3UZwYTO+hwGrkq4ioV3VXbqf00quROwgtP8bwGGJx1qA3iIpA6zo27kfmjRYibu3IA3ZvTFJY+UsMIAp3Oi/aEAqyr/eKK79JrU8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gm0cGqJ25vmOmxC3QOO04sjnIKhgRfNY29lKWlSTcMo=;
 b=JAD21XOcWS+B3kB469KjzGNtC78a+A004WNhF0RjoS0R+U4K2fzbfO/tvCUf+vsN0J+yfah59b0+4E1vGfO8qJGM/AAJkHh5IY5s9eu7E7ZEfksy64/BXym48MR+prCheqeScdQdtBXqAm91kvYaqhI606UT0dMYJ59x9B22Rv/Drg/FFkobpG3Epl9PYbAoiTSUEUB7OkRvOEZWcPE+2qMbPqzde8lovn0K8GRolboaS0n0oDE27+nn8DWEWlG58cXvNKtmcGkP5kTySMDYf0H4cVYNJ1wV5DqZ0PJpc0YWPB1Q5wvkMjS4De6KSi/Q5R8BqOzW1Q2i7WrQIzHqLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gm0cGqJ25vmOmxC3QOO04sjnIKhgRfNY29lKWlSTcMo=;
 b=fcKYRWexCFSAUDeTvpwG3XmufgZH/VkZDhgQKuBqUJIuXztG8R39K4aocVCRnItlhlHhgj3Z3sDk8bkeCUqP7CTrkiinHcjyjq74t7v0Jxz6669zddYivCBL8T+22LoWGfQxq1K3YxAM6FqysNANMWdsdTNraYkAvsQepyVYoHU=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0401MB2328.eurprd04.prod.outlook.com (2603:10a6:4:46::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Mon, 7 Dec
 2020 10:51:33 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%4]) with mapi id 15.20.3632.023; Mon, 7 Dec 2020
 10:51:33 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V3 2/5] net: stmmac: start phylink instance before stmmac_hw_setup()
Date:   Mon,  7 Dec 2020 18:51:38 +0800
Message-Id: <20201207105141.12550-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201207105141.12550-1-qiangqing.zhang@nxp.com>
References: <20201207105141.12550-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR0601CA0018.apcprd06.prod.outlook.com (2603:1096:3::28)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR0601CA0018.apcprd06.prod.outlook.com (2603:1096:3::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Mon, 7 Dec 2020 10:51:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4e46c1d2-637f-4747-0679-08d89a9e0fb9
X-MS-TrafficTypeDiagnostic: DB6PR0401MB2328:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0401MB23283BBCD2A58BAB77C4F3F2E6CE0@DB6PR0401MB2328.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: baWH0KEzkneAJk8SjMxGFLaD1R3xtCRDf5ml/aDzhXlCgoPPFSaDJHu9QsV3GLhLjRrxXwO7yeBLh2bjgF6IYR0nUQbWUqpoL7F6Pe00KPhd2ZsNkwCSAU40SgEDZ8XFUoN1DtlVcptbOoYEJh5TFpKXNcu20bqN38anYl9wai4KwiEyQqY3x3jmL0mQj6wIjck3QqnkZI1/3HwPuXQr3+xE5wppxhUkvBxA+5OYBwNVXzfy/UiOfUezchMibDG5pcma9Ja3qDEmZusRWm/LTpSYUB/IaoOBRjozyKYViVgMuj+0zP/IwSN3UyG/L9uofZ2WcXjVjCHe7QMC/jBtRt7reiPa2P+yb2oZKREKspgd4xpjV6lMN8azqfPYylSb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(66556008)(66476007)(6486002)(186003)(956004)(16526019)(6506007)(8936002)(1076003)(86362001)(26005)(4326008)(8676002)(66946007)(316002)(83380400001)(2906002)(52116002)(478600001)(69590400008)(5660300002)(6512007)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?NfOhKy+d016AnizFN51YMlup8yj/L9ubGLaYtZqtFDA5KncdH2QgoMdmsy8s?=
 =?us-ascii?Q?uYYgJ8XIirhFYSsXnaWT9YvgjedviHZ7Ix5z/obEMBu5ZTd4FjuLC7u4pHIV?=
 =?us-ascii?Q?Cg1BGiLofrj9aRS+vPCQc7zRpR+FxDKtphwRF6O2f0QYyOFmPj7sU2S92ooG?=
 =?us-ascii?Q?8+3Rakb2kfPjthAK340KpKC2MaF2jC3tckLNPpO6wF6ivY17uS6mK2GxveOZ?=
 =?us-ascii?Q?3dZMiJzLoTwGHHVhqv/dgknFSa5fXV2QBo8rfrYBE1uZ7XpDVhdwn+kFNJYB?=
 =?us-ascii?Q?NDvnuhysDEJQf2yljQJHVJOS3Rl5tLpEXyNz+YVVd9PRTKjZz2RKGzs+lpFH?=
 =?us-ascii?Q?dfeYCTxl1nJIk4+RLQSTuarPXULd8lYnQ+pV5lJzjPUoQ+xC83sG26RyNqFV?=
 =?us-ascii?Q?0DxmswyHctnQUd2wCAOZy+bF1dKa+JbAEO9wGNEl2ZG3r87yyHNnRGQd9Bi6?=
 =?us-ascii?Q?oE4clFhO/OlxYqv2+qO1AzKD5JYnwkzCucswGFCaMqK+CDgDAJ3L1c2SEO4v?=
 =?us-ascii?Q?ElUy7LeqNZGtGjYi4NjwXr9FCaJuGyjeYCfBw5V4nEeTMlKy5OfaVx8akb04?=
 =?us-ascii?Q?4Peya/jNCuHFgJ9hiMmrPv5ltJLW1/z7QdqYiRp/FUxsvU02ujuObKUJlYme?=
 =?us-ascii?Q?XC20AC14xxSIJwxMvs3vrv/z5um4NrQW38h8bCXWHEf0RkTUk1lecOGsJnUa?=
 =?us-ascii?Q?JXHbi8jDYgGdxXwsWUDJeGVmiJRROcUN4Mgk161pQYQx1YbxvybJX/tB+Clc?=
 =?us-ascii?Q?bF7lHybEUSnFny7VfuLGBxGJ0UjtU1Q8qaAJUE3TWvgZmdQmqpmjQyJlLjG7?=
 =?us-ascii?Q?e9erIrRa70WliQaBm+UNjsH/uCfNftKMOnjCIKINoGVnNeU6DBXdN/Dbx4kU?=
 =?us-ascii?Q?35X2TCVpI9TgVsV/HOrdPdfLUcShlvH3WBCTEkxpPsQWF1fbloV4Dx3OYmF6?=
 =?us-ascii?Q?udZFc/f6uzHpxua/1WNJADpdDYQiMT+VLcU4PJWz+lhRm6nUl9JP9yBkdRkg?=
 =?us-ascii?Q?DZ1j?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e46c1d2-637f-4747-0679-08d89a9e0fb9
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2020 10:51:33.4101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RgA4XyVztX2uEN+qxfT/2CC2t9HTKftnm4w/1UvNI3Qe3O+/7JvbNv6JFJ3lzWcMzFrNKy59Qhywo2kPrBJ3HQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2328
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

Start phylink instance and resume back the PHY to supply
RX clock to MAC before MAC layer initialization by calling
.stmmac_hw_setup(), since DMA reset depends on the RX clock,
otherwise DMA reset cost maximum timeout value then finally
timeout.

Fixes: 74371272f97f ("net: stmmac: Convert to phylink and remove phylib logic")
Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c    | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index ba45fe237512..0cef414f1289 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5247,6 +5247,14 @@ int stmmac_resume(struct device *dev)
 			return ret;
 	}
 
+	if (!device_may_wakeup(priv->device) || !priv->plat->pmt) {
+		rtnl_lock();
+		phylink_start(priv->phylink);
+		/* We may have called phylink_speed_down before */
+		phylink_speed_up(priv->phylink);
+		rtnl_unlock();
+	}
+
 	rtnl_lock();
 	mutex_lock(&priv->lock);
 
@@ -5265,14 +5273,6 @@ int stmmac_resume(struct device *dev)
 	mutex_unlock(&priv->lock);
 	rtnl_unlock();
 
-	if (!device_may_wakeup(priv->device) || !priv->plat->pmt) {
-		rtnl_lock();
-		phylink_start(priv->phylink);
-		/* We may have called phylink_speed_down before */
-		phylink_speed_up(priv->phylink);
-		rtnl_unlock();
-	}
-
 	phylink_mac_change(priv->phylink, true);
 
 	netif_device_attach(ndev);
-- 
2.17.1

