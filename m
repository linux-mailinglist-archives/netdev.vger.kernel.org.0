Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B72862CE5EE
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 03:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgLDCre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 21:47:34 -0500
Received: from mail-eopbgr140081.outbound.protection.outlook.com ([40.107.14.81]:37121
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725847AbgLDCre (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 21:47:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FfmHCWDDQ4XX/XgoLwXBvyP7w8Jy6afNeVQT3UkFNbXXHAlxrpzyO6TbcFNXo71zOV8+H9+6ph9v7wc9u2RIGCyS7aJSJse4byNgq9HN8yqtZq0ZmG1HCsuanSOsvqWaMIKi5foSzEmWJzURdE4JMA/jrxf6inn9tmT8leSKa0knm4I8SliwMCDu69aK9edIURIpMUfjC1Wffu04Rwx7iC3DLG+FNBGdhMI6Y7Kzi/ZH9mLE2Iqep5NRxsFmxiXtwQplbBakhq1RGgACDZVkn+7x8hxaejWJzz3qGloq/1uBU04TBt4Lk9I4EIQDKnsEzdMZ6SqsRHaYmDrl9k/LiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i3fvrFeNCKOZe1LfevmI8lb66EX3HQ/9xsBhU0yn488=;
 b=HVdV4uvt51kv9W/fYFoYElxXlUlM4enUV2yCxSt+PuIITM8q3gNT3LnY3HFhLqY+r695EqNsgWoWUd6ydXK+2Kd3qcG3SdL/UaHCRTs5w5NtOxaAxMzraVrD4xoyXDKUuOnwJ+3jvxY4EOYmk7uqF62PTEllXYoqEuUO3zqhsPg1b5HZjsz1llzkMyy2PVoFDIfO5Ix19y2QGFO93s1zVnIP6whZ6ViMhAeqYcQO1/sSrMxudS2PM+2TaLkaMlCgIlMQaPa8FJkdtIa4f4uZXxb084N06tpl+Xj1sI7JJoRpciRD+bQyOs0TRzs+1AoHNuy5etNHj173QpmjOISxWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i3fvrFeNCKOZe1LfevmI8lb66EX3HQ/9xsBhU0yn488=;
 b=KLfZxJ/4RcmqQMenI6lqFXqTdR8hfqV1V73LbdH/Q7usFi766Co4uX3UZ+N69SdHwyQPQUzZozW+HD4iGm862qrXVdYzXLoXu3FvHiohar1MIUSL2/ou6UnnWPcT+7OPNjRPk0QKicnj3wBV5xCN+FavreeFEYW5idff9mYPBpw=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB3PR0402MB3707.eurprd04.prod.outlook.com (2603:10a6:8:2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Fri, 4 Dec
 2020 02:46:25 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%4]) with mapi id 15.20.3632.021; Fri, 4 Dec 2020
 02:46:25 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V2 1/5] net: stmmac: increase the timeout for dma reset
Date:   Fri,  4 Dec 2020 10:46:34 +0800
Message-Id: <20201204024638.31351-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201204024638.31351-1-qiangqing.zhang@nxp.com>
References: <20201204024638.31351-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0052.apcprd02.prod.outlook.com
 (2603:1096:4:54::16) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0052.apcprd02.prod.outlook.com (2603:1096:4:54::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Fri, 4 Dec 2020 02:46:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2e58b61a-1a38-4521-9f41-08d897fecaae
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3707:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB3PR0402MB37075AE6653F590D7ACD334AE6F10@DB3PR0402MB3707.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RnlGQLkUd4JNlp9mHI+zSB4nddP2ztudZ+f64DM5M7Iqy6+zE6NBIwYtOb+02PzjgJ47t1wJcRGoKAOEVb6YnHLWmkvXm0OX4muVKM+sLTqY8GUD0+sLgQk2e53rxo+n0XqpAlf+MMoX7iG4HLjqsxVJ7p7S+EiFRZJFTY3e4gAhTdCvECktEJSM5pMLztpzuqnVnQCY6psOuznd7drYtwdXBEA8+08B9+g7KY4VyZ5h/DS916KDSiIhdRWgOLt7q76aY6FGZRllgzNoS41t5yzLAQeQnuz433FNBvk3NqzDz6GJN9QxKD2Qm2b6h17xQagd3nG22+fbd0j2nXS9zVSxKiz6y+f2L0BcJ3Jehky2ZCO8b7xNlfxrbPNFee4F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(478600001)(69590400008)(1076003)(6512007)(66946007)(2616005)(4744005)(4326008)(5660300002)(8676002)(956004)(86362001)(66476007)(66556008)(2906002)(316002)(36756003)(83380400001)(6486002)(26005)(6506007)(52116002)(16526019)(8936002)(6666004)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2hhon/tbjXNaL1Idr71ZZ1/xbBCq8r1Ot30iuiY8DKTdyhlfqJ/n80o3+u6K?=
 =?us-ascii?Q?jz051D1DY3Xpjcf3T8iiBSpyn3UlpznuYAS/EyXAuu0TPyM0H6WTpQe8DmM+?=
 =?us-ascii?Q?9wXbh5wBAXiRdCm70T8M7Mc9SswaaOh5WUQACZ1W5zJChlBc7Z6UPwIUNMhj?=
 =?us-ascii?Q?5I1kPUB3aH3YTRdeMh2o5tZu03tiMwBpTrnCXUajC8nu7AFbhq8rUTXYsoC7?=
 =?us-ascii?Q?Ak3VynBnAt7/o+eRCcGmrJOgqJ45vudAkdfODsVADksiw/FmQbvliQIV4KHC?=
 =?us-ascii?Q?EzjWyQC5QQa+mxTSna/NUK1ZC+FsxRYzyjYML9xinnb+Ux0LROGgVLk9iF4l?=
 =?us-ascii?Q?iE25Bnhk1HaUuOxT7uDshoakP0ItARZT/sUaGSmEUrqU8Y8WHEnR3yxDFgST?=
 =?us-ascii?Q?JTxq0nptqimF6K259auJun1PHtWx69Am9NdxpNzr74HktxSaJ7Fi1kcZwD8l?=
 =?us-ascii?Q?epBAk+fscF1IBwAGPtJPQVirmLvKp5Bfoh5WRnR1JVTNr0KyRTC94glBe97K?=
 =?us-ascii?Q?zNIpVMPTjwwCeOLQ/PwviCHezazF3txgAmdlyY1Masu8EFaI/myZfZcH6kNU?=
 =?us-ascii?Q?b7wc90rU9dezUYXlVoTQiTlu7dl+0k2O5VvhXeR1FATCqV8ZQ+PURJymM1iq?=
 =?us-ascii?Q?DeF+DYln/kHobIz3fOPDRudDAAATqaU0GVA2rjtysGXWqA6N1+UKFEAETUre?=
 =?us-ascii?Q?EkybWyYLDwWVqLgqySHiJPKghPoGojz8O+jOjbJlov4cKaD8//PQFpaqbTLt?=
 =?us-ascii?Q?0rroHaqeKEjeLVZqWic/AKWyTfiJ2hj4HRGPvlVobUSS1yHVZFlIbnfQcwVN?=
 =?us-ascii?Q?dMOcWBFJDl3yWG5/cn3KJ57LKATtYICG97iQgTWRbnO0up+0i4c8KL97nPDp?=
 =?us-ascii?Q?0kp8SFGirk2lzYDiCxBuKa8Z6hX0NZBnHXiA+ksdaDqLDFk63EvizFs48apo?=
 =?us-ascii?Q?HBVH6r5GPqPx5QfdnZJsjo6oUG9qcOpG1SNyjIwy+aNHLAOS7jnPGr12QozW?=
 =?us-ascii?Q?FGej?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e58b61a-1a38-4521-9f41-08d897fecaae
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2020 02:46:25.4727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ULl31ZMdnen5ih2GjnQtrvR2BEfw7jGEl/STQFIkaWBREisNH1EoZySa6+/Ev3GkZaWF/OZbcwm5BG+HbSPCAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3707
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

