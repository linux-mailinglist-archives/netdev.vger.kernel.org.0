Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6929D1ABCDD
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 11:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503725AbgDPJeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 05:34:24 -0400
Received: from mail-vi1eur05on2074.outbound.protection.outlook.com ([40.107.21.74]:59648
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2503642AbgDPJeO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Apr 2020 05:34:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fMYSF9Z1hEKDtRqidSZycwnc0hGIz+htf9PBRGfPvzyjAmeRO2xXyd/3j5S9xyPIBcWqM9vsq196DLH8VojIXXEV1yFG1NuGYJT7j7DC5g919LjEkLPTcZoyJSyW7YiVBNQuNMgdO7rStCLjMzos/48Anokvyygf+Uj1MsTJRNCmcfDLuOHycloRvoI1RA2HSB9UA+YMnBCFZgi+ShffSedC1Eno65kPTCqjIblrl58+gTmuXmqG0wlTmlHQOsKzG6iXVUrToc5i5PtQGKwvRR07AQORwWsQ9oVh5kT/jIEFI/3AFQuVIC0rIgEz1SPmGKjGDzOl6W0xnTKfxLv9sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ak/1t+kUdXufDoourcp2s5L9gEico9oEbzynRkx7yEU=;
 b=I9V9Tk5QiHOfu+MCQTxPzlMi4IBnJ8q4684hassTuhUI7cL+lqe66evpYH7wFHcB6IxPMaBHxYptedYxFeFt38tobnx6LIGe7WiuKUCqNtK+90Ct0LfYu8ghiZAlVKuDgadbE7wqtCLOPuMm5iZpAeJvNYjVFnY0eDonssjbL09bNIx+m8jd08sZ1w2ab6fRk5602m46muaiXGS+JfTjeIsBqJN9rjC6PZuN2KeCO0rZIsUG0uaVgXjPKO4lpIu0ZjgsxZLPJc6TZ0GcgNreCxFfvyZDRU8Q+EO8jD3i4YUaJHyNcb8QtnqPur7XSreRjQ3zcE/+oN+1GMAPpLfSkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ak/1t+kUdXufDoourcp2s5L9gEico9oEbzynRkx7yEU=;
 b=PeTxZbiJ0P8Cx/vbhZgQLDZ1xLfd0HnIdX9I6oW58/w4OQUVPrOG03AGJWMgagtxSgmxxhsCxCD9PjNf+6zBeKgo8i0W8yUuUK/+HjRNc+iE6LwKY/xbrxvsc3di4rULI62rXjF4svkqJXSbePG0YxghOoJAcpDf3PQ0Q+1DEPs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6969.eurprd04.prod.outlook.com (2603:10a6:10:11b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15; Thu, 16 Apr
 2020 09:34:08 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::2924:94ba:2206:216e]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::2924:94ba:2206:216e%8]) with mapi id 15.20.2921.027; Thu, 16 Apr 2020
 09:34:08 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, linux-can@vger.kernel.org
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org
Subject: [PATCH linux-can-next/flexcan] can: flexcan: fix TDC feature
Date:   Thu, 16 Apr 2020 17:31:26 +0800
Message-Id: <20200416093126.15242-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200416093126.15242-1-qiangqing.zhang@nxp.com>
References: <20200416093126.15242-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0015.APCP153.PROD.OUTLOOK.COM (2603:1096::25) To
 DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2P153CA0015.APCP153.PROD.OUTLOOK.COM (2603:1096::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.3 via Frontend Transport; Thu, 16 Apr 2020 09:34:06 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.71]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 139028b2-98cf-44d6-2b90-08d7e1e94fc4
X-MS-TrafficTypeDiagnostic: DB8PR04MB6969:|DB8PR04MB6969:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB6969E4B305F56C0482EC4A34E6D80@DB8PR04MB6969.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0375972289
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(376002)(366004)(136003)(39860400002)(396003)(956004)(66556008)(6512007)(36756003)(478600001)(66946007)(2616005)(69590400007)(2906002)(66476007)(1076003)(6486002)(5660300002)(52116002)(4326008)(316002)(86362001)(6506007)(16526019)(26005)(186003)(6666004)(81156014)(8676002)(8936002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bPUjflMuhs0iOe34u3+Wgyi0u3wFIIMl8eiM2yHWOVnYx7deU/wvMSEj+ZZXSv0dJdnv0hpOhKPGBr6gAG5q6OEz6PiwHBd6Hpz2yOXGNq4sgA0fxgfsgEf6bD0PyM747urOx+6u8YhscInGT+7YOADHMvvafJi04/bZYY2w0JGLR4v103lQdDzrtL3+VfA9GL6h7DJOSVbmeYbVMd2GOWilGlwAvYy+GjjHoQD0IVm+SpW21gqvcDa2qB42nO70gUAxKq4tpAN+4zKakiTKXXNIC5c2iVsjzx/OPzHdU8th3gEX4j45nWvJM9i3FFcvA3VLM7+bftaIM8gCE/9XVUqreHr2mJ3RXqhl+JZT8FboU579k3xmiS7NKgP5vuJh771NNatanMzKUeM0Ukh76lZ+I3jQpkWkMN/fccW0aoN2wrmJ8bc97UWXtLU/YzM2rPeT5z2jwnhXEZoLCIFolEwUQP0+DtWB9qoOpr212AZ0oGf2AyfNbAd5r0a0sqAm
X-MS-Exchange-AntiSpam-MessageData: kCWoQyVQC9EE5axhiRVGcRoA7893c8JH9spAhzrZnqoWzLX1ZeRvv4u27AweA0nCLbt5wc30fsFLjIQXR8Y/DZdLDg2XlXFCvfaFklRABZcmkHGjBCSknQdrK+D5TKAtmV9jQ9voyeim7GhG2vftfQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 139028b2-98cf-44d6-2b90-08d7e1e94fc4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2020 09:34:08.1156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TkIjqqs9nK8KgaTN+K9hI7FAUABGYnNIVV0qKe2YrzPlN6SLlPR1vQZoogpvqg2++3MEraXwZ6L92hsUIyAKTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6969
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We enable TDC feature in flexcan_set_bittiming when loopback off, but
disable it by mistake after calling flexcan_set_bittiming.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index b16b8abc1c2c..27f4541d9400 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1202,6 +1202,8 @@ static void flexcan_set_bittiming(struct net_device *dev)
 				/* for the TDC to work reliably, the offset has to use optimal settings */
 				reg_fdctrl |= FLEXCAN_FDCTRL_TDCOFF(((dbt->phase_seg1 - 1) + dbt->prop_seg + 2) *
 								    ((dbt->brp -1) + 1));
+			} else {
+				reg_fdctrl &= ~FLEXCAN_FDCTRL_TDCEN;
 			}
 			priv->write(reg_fdctrl, &regs->fdctrl);
 
@@ -1354,7 +1356,6 @@ static int flexcan_chip_start(struct net_device *dev)
 	/* FDCTRL */
 	if (priv->can.ctrlmode_supported & CAN_CTRLMODE_FD) {
 		reg_fdctrl = priv->read(&regs->fdctrl) & ~FLEXCAN_FDCTRL_FDRATE;
-		reg_fdctrl &= ~FLEXCAN_FDCTRL_TDCEN;
 		reg_fdctrl &= ~(FLEXCAN_FDCTRL_MBDSR1(0x3) | FLEXCAN_FDCTRL_MBDSR0(0x3));
 		reg_mcr = priv->read(&regs->mcr) & ~FLEXCAN_MCR_FDEN;
 		reg_ctrl2 = priv->read(&regs->ctrl2) & ~FLEXCAN_CTRL2_ISOCANFDEN;
-- 
2.17.1

