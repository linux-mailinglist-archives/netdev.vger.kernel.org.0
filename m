Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61322CB7F3
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 10:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388006AbgLBJAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 04:00:43 -0500
Received: from mail-eopbgr50065.outbound.protection.outlook.com ([40.107.5.65]:54606
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387643AbgLBJAn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 04:00:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n3TS53VAoPlDiqbYvCm+ZdLYyMYIc2d7ZUXJ+62SUZGQ84KbjhJiadxcPR+eTtrD3IoPjKVlzAqhU0TAa3IxAItz7gRbY738k6C/dNe9KL9GKA7Q0SAqQ+3e/GmYXDAHT5eWAfvZJFC71ee8k3pLIZ4K6rYa7nvxwCz70ayhFB0GRsYwJRmd/m2pHOUL6wDWM7teLi3bN7KqyPWYj5C7hVtnXGv9CjnOnIlKSv3ggRa5iytXCHQ+GwALga2XkW28N6lqUUaWIXRv9ulEE7gjO22QXLb9Z/znpDKO3sSulwAhJaxIaSIK+DTTBrft3G53i99tu5picapBaJMo1+aNrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i3fvrFeNCKOZe1LfevmI8lb66EX3HQ/9xsBhU0yn488=;
 b=gJBMKowFaHBEHkdzRngBXkM8TEVgFY0/uY5Qmv2vHcNuN4U16AuUkmjwR26eBGs5nP8w/tO8HhmRgaVvqPp6CeA2IE3u+0BkIBnGZ8siFHE94DOvg1bEs0Iki423RELQad6aKwqkwZugzImUYaeF9Ai2E+fh8m4tnpuKtoqdKkLiWZ4037/IjVYMhZpwlTiXGen0gI7kuD3E/ashmaeJN4F0zX4++PuSJ0KwFNHPCH5aI1SeFFyaPOPClUsod/94waHKQnZCfhWi8wa8xv7i5pc6cP1x0ZUXAtsTSLCpK2fa37Te+nqlYL7p3XEVFGV6gBxTtrSVtfj3yN/ajbC2Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i3fvrFeNCKOZe1LfevmI8lb66EX3HQ/9xsBhU0yn488=;
 b=MduFhEO/biaXp3b5Hturksmh96tPKRjD6eqYzJsGKiQsyRt3fwQygIOY0Aolk+pjdDkEFfqY2rNceuCcFIfjZi8C48iBriC6EtfCxM3wm6Lg/vgWofqKDhcf7/TW8ZDItiQB7HYUpGBJncEu4jHUM+UrJCWWzeWxh6XYuIvuKz4=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4107.eurprd04.prod.outlook.com (2603:10a6:5:1e::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22; Wed, 2 Dec
 2020 08:59:52 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%4]) with mapi id 15.20.3632.017; Wed, 2 Dec 2020
 08:59:52 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-imx@nxp.com
Subject: [PATCH 1/4] net: stmmac: dwmac4_lib: increase the timeout for dma reset
Date:   Wed,  2 Dec 2020 16:59:46 +0800
Message-Id: <20201202085949.3279-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201202085949.3279-1-qiangqing.zhang@nxp.com>
References: <20201202085949.3279-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR04CA0132.apcprd04.prod.outlook.com
 (2603:1096:3:16::16) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR04CA0132.apcprd04.prod.outlook.com (2603:1096:3:16::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Wed, 2 Dec 2020 08:59:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 78b91c14-5514-4036-6a59-08d896a0a14a
X-MS-TrafficTypeDiagnostic: DB7PR04MB4107:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB41078B34581DCCB6555F61C8E6F30@DB7PR04MB4107.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I+eXJ8J1HLxvsfMm6IkFbad3HlRmL6/aGal38VPnld8JDP2OffujgVSng9sixmc5p6zJyddld73scjoCZ29i87euupNmr5JJQK8duOSTX4gE73TZq8jXHee/a/vvI9upox/Up7oXexOl69EUqnPPcOeo0eOW7Vm8nxyddfsOwrWFDSwU2CKOS6QH6Xw9TZ9l4Y3MUeMvIXqK0rA2jkeDehRz9D3oUDARD8q19G1Ob5m81ZQdn364q2nXfDpHO1Fnuh/6JDSVkM9AyUEFlGE1u3aARb/Hy0LHtwr4bYucesDOedExqVafW2I3pRqgAXUVwWmTx6C4PYbxhKwyk5mFfMliNI8QiuCileH8pTDCYQ7by9wxefsSPZN3kSPBz6Eq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(376002)(136003)(39860400002)(2616005)(8676002)(956004)(316002)(66556008)(6512007)(36756003)(66476007)(5660300002)(4326008)(66946007)(2906002)(6666004)(69590400008)(478600001)(16526019)(52116002)(8936002)(4744005)(1076003)(26005)(6506007)(86362001)(83380400001)(186003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?aLbJ9FngWUa95Tpw505wwxDcJyso/p36JnHebW18eOea3ZvMi7zxi4Ox1b1T?=
 =?us-ascii?Q?vjSp9UY9NYQnuTgu7QcKfupxn77C0OctMZpcwwE2egEjiE+9gDW0CGyUmng6?=
 =?us-ascii?Q?jZDYjm7oSjIeWJhFOQPuidVNiy3k2dUYfNBH+JFKhGTEofWFkG3ISQlLfv+g?=
 =?us-ascii?Q?vWtiIpbnD4ehvcRdoqlVFfLmSvrtYh+OtGEfuDb2+7qveUrYoE/QpdG5HGOC?=
 =?us-ascii?Q?1pHXl75G7Hltcq525Yi17nGoM0XrPMMVZFB87Xfi/xHAuNBnXt/uRQB/Z4ka?=
 =?us-ascii?Q?omN7W8W7d51uuSW5J3i4L3NTOD45wQcsIYnoKJqAey1tKrcdzAxXUhlNbOUd?=
 =?us-ascii?Q?KzkyiY+aXaZJKCoOSx8Z7g1wGkteaB42C/rheX+Mk6NvdUzaZqME82iS6xll?=
 =?us-ascii?Q?AkX+dTMjx84xTz9w5AMpZXzwSsPGygMCOlJJWlSk3Sgy8Hw49VUyuVUlgpYt?=
 =?us-ascii?Q?2gddI2/7jVh67w7Ns9SWwG0wiKh3dTNRNXGdKZ9SXKUse7g67cKJQtqL93j4?=
 =?us-ascii?Q?o4YgfzqOGp3pjPh+YKau64lAwlMqals/gMQcBKx5rZLKGd/wKcfm67acmS4F?=
 =?us-ascii?Q?Ff0WiXofixjKvgrN5k5XExwDvtLauyNsVpM7vZNLtWIsdEnztk5vgZQIZ/TW?=
 =?us-ascii?Q?SaTdvgVVpfvo9acm4D5v+EzfCkaFy/L4FD7/xZzbfhYFdU62rQRVIy4FqaYX?=
 =?us-ascii?Q?xxdzwCMcrumxe5KuvFgLurB4nch0JGcFyrwSJfcRIa33pcwzEs3LZpRIOzg/?=
 =?us-ascii?Q?fch+zHRtjUiBkO8Wb+q2c878/tmkg66UMufi3Mdhl6RJJ0dwkbG9M70tzz0l?=
 =?us-ascii?Q?FVCdD425vc2vFpaWI4LfDdTdWaL8QxtJQAfp1BDydMkLzaWxjvVm23L8TiUU?=
 =?us-ascii?Q?ZCkoisoDvoaJ2DjLk+7+0bZIc7LzpCrMR5fksLRQ3yDZK4O4eUmbCw1+kJ3P?=
 =?us-ascii?Q?/ghH7PrnLyRFJStp8SVz4V9KV3+0zdraG9MwSC3KBJLBm8hVlkNJGzw+clUe?=
 =?us-ascii?Q?V/lK?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78b91c14-5514-4036-6a59-08d896a0a14a
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2020 08:59:52.0914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LbGb6d5sJHdAhJ1i7MsBHFr5JH08WvgzPu/UojpJ/lbvE522ExOIgRZ8Yjcb1rXoYRlKTuG35DFt4rg8+KU+gQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4107
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

Current timeout value is not enough for gmac5 dma reset
on imx8mp platform, increase the timeout range.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
index 6e30d7eb4983..0b4ee2dbb691 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
@@ -22,7 +22,7 @@ int dwmac4_dma_reset(void __iomem *ioaddr)
 
 	return readl_poll_timeout(ioaddr + DMA_BUS_MODE, value,
 				 !(value & DMA_BUS_MODE_SFT_RESET),
-				 10000, 100000);
+				 10000, 1000000);
 }
 
 void dwmac4_set_rx_tail_ptr(void __iomem *ioaddr, u32 tail_ptr, u32 chan)
-- 
2.17.1

