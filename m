Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6832292334
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 09:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbgJSH56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 03:57:58 -0400
Received: from mail-db8eur05on2066.outbound.protection.outlook.com ([40.107.20.66]:52033
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728340AbgJSH54 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 03:57:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VwuwUXOrYr0Qq+6TSNUUywhBXHPL/uRiBvmtfuOkZcQxwS6WGgoIPWLLWUub1B1kebywWUQ74+IoRT6ADJnCkzvpEWwWBBhfFXRcCMS3Gx4gOK04R5Td6peHZyMn2LQ43W0589iqasQi6n2qr4/PhltARKd3wx6miGAidx49S0rdn+DtYNRlPfQp3ZvcLc3v2LNXNPnrDUgII0EhudfJGQ1zGnZ8UbdY/JyZEPFAqqVkLh3EakX/yHgqXDU58VSvpG4+KEIWZbqoVjJrLM0YpTW/tQO0yAwpjFcYSDXa3bX5sGcmD1eG9X6drr91GCB9TYGsNJugMEqcfocWTyxrow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wCJodCo2r/+Tzl+AgQJiLwFEQJopamT1XfSgrEiYf+8=;
 b=CrpD0hOz7QiWkxqmZz7F3JmUPPxtJ1uw/GrtfONBI3QfnoHPDZmMiSN6B3g1Iw034g8/OgbCSNXsGYQcYe03doDfN1U+zpk+CPjIKUJHs2NhJu+CiziT5vVxMHBi/uQGslE3wkTURDiErIaJgp1H35dFnF+hAZVcNH+N+fIoZM5z1dy5QJtJ7DmJKKIlIDtMBOCFRYMUoWBDMR1+To1c2g7iCqb3EnGm+oPX2XddFssu2FUYlP/7/ao8ZdltMD8Dkos8iUY9aitpWu48zTHQEM3klZyFnXwaSJ4dEx0YtskSJWv/hrxZcwuDxoyyzR2Yh1kDzMdvtC08d51zqQHlkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wCJodCo2r/+Tzl+AgQJiLwFEQJopamT1XfSgrEiYf+8=;
 b=libpq5Qa4VXXdzVubahlTH+SClGW7u/UwKqs3y2hf0CzV8EgmMwSZW2nP+v1FTaPpWGf3hKqq2iVV1VfWHpqBYMaIcOPfkTabrxJKX+2kgbQGUr1r9nuhiH8O1bRn235jpS1WsgtVNbaBiBdf9QNW1M/0p+v8oFlY3eYU0/V0sI=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7430.eurprd04.prod.outlook.com (2603:10a6:10:1aa::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.22; Mon, 19 Oct
 2020 07:57:54 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 07:57:54 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        linux-can@vger.kernel.org, pankaj.bansal@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 4/8] can: flexcan: add ECC initialization for LX2160A
Date:   Mon, 19 Oct 2020 23:57:33 +0800
Message-Id: <20201019155737.26577-5-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201019155737.26577-1-qiangqing.zhang@nxp.com>
References: <20201019155737.26577-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0107.apcprd02.prod.outlook.com
 (2603:1096:4:92::23) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0107.apcprd02.prod.outlook.com (2603:1096:4:92::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Mon, 19 Oct 2020 07:57:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f1876f5a-c193-491f-cd92-08d87404af0a
X-MS-TrafficTypeDiagnostic: DBAPR04MB7430:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB74305613965A58143E9B441EE61E0@DBAPR04MB7430.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CuqXsbX+UraTGeA+AITl00OwFIPAtUMqQvvzJzflffUlCamDePZINkZVL9ksReAgYEKKNlDouzlRT4IIVmkCADvK5N/2530MutZEyVqEGqk+ytxPTPlPcMO/ywpIZEGPfUt1PFbeA6vwr4CfKRBUjl4d32EwAIophe1PL9HJJC8rZPPjVxc/KnlFJ6beLfX3bEmxNphXz+TPRZNN3CiCld5ZchhmBsE8cjq8PzJ09DCbqJUB1fJZmP1RER3ob3jEC+/jXho2NdhlKFFtsBDpv9soUFvVpE7eRTFmDh96OIrU6/HIZY7SvEgM9fo9tSTd6wy+1MG/OA21w+UcoaU+7wtEuTOP+nms9WkaAvMSy1USgFpVtqQj+CIk+Uegcocj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(1076003)(6666004)(2906002)(4326008)(956004)(2616005)(316002)(5660300002)(52116002)(36756003)(8676002)(8936002)(6512007)(6486002)(6506007)(16526019)(26005)(186003)(86362001)(66946007)(66556008)(478600001)(66476007)(83380400001)(69590400008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 6Pstc2n9ZtMNrj7jPIkngVZb5v3Ni6r1V4AEaEfm3ARAEICGKrY8DtZz6UE4kMb+cEhSf501UIDPMxJXWarze1hOBiV1Zx/40DL+sYvmxQMr2d3BIcvlc1GkDOdZaE61rAnGl+tXBvwsmb9OKswBZvmcE2++eLIQmJRAchhoMBHkvDTAQfEd21QeJh9XIFgnD1as9xAYrayxZmDNx4Nm79f+Z701Zw+x2jMI7wfddlSrWgnjgU5pZCc74EXwVPKD1rsmaIoBuXdkxXfNCEeSJp6mNBm7QDS/hgqQQewppFf4Y7W2yN1DOWXiN8iarP7Z1s4kCxy0Drqs/JvdBA1c55hYzOHWxJ+C8owRWJECB4GFGen0GHRMLu/WBHhghBPcZq1A27J6pKH9chDT9XTwXCRxGZ0cqM7GHwg88daAdUMb27SbMhIybiGmSHNcGgaaqnz1PvlNRIxNqHPYaZb5Gvttjgj6BOBC7lV+V9042GpU3rn8rjB7EbPkJdajCgYywDUe6UyDevVC4AyNl8+vV3r4264JjHgOSO0zPp4WNAzm+24sR8a7TIWuDLPbrdF8Opq+pYS0cxDiahFm+1MwFNABRXTXc2Z/kmrn3dyVaDWFYBpbrhvmhco0cx7xEJp49ws1X7R73ad7Vs6E9nvPEA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1876f5a-c193-491f-cd92-08d87404af0a
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2020 07:57:54.0895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZZrvi4+gd1CDJnU85JN7/ANg4zws/rI0WFWKHwS1tTOtoQNS6OI6m06zq9egJT4f8XizRUV3sjwrVIqPiZrJbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7430
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After double check with Layerscape CAN owner (Pankaj Bansal), confirm
that LX2160A indeed supports ECC feature, so correct the feature table.

For SoCs with ECC supported, even use FLEXCAN_QUIRK_DISABLE_MECR quirk to
disable non-correctable errors interrupt and freeze mode, had better use
FLEXCAN_QUIRK_SUPPORT_ECC quirk to initialize all memory.

Fixes: 2c19bb43e5572 ("can: flexcan: add lx2160ar1 support")
Cc: Pankaj Bansal <pankaj.bansal@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 586e1417a697..c2330eab3595 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -217,7 +217,7 @@
  *   MX8MP FlexCAN3  03.00.17.01    yes       yes        no      yes       yes          yes
  *   VF610 FlexCAN3  ?               no       yes        no      yes       yes?          no
  * LS1021A FlexCAN2  03.00.04.00     no       yes        no       no       yes           no
- * LX2160A FlexCAN3  03.00.23.00     no       yes        no       no       yes          yes
+ * LX2160A FlexCAN3  03.00.23.00     no       yes        no      yes       yes          yes
  *
  * Some SOCs do not have the RX_WARN & TX_WARN interrupt line connected.
  */
@@ -411,7 +411,8 @@ static const struct flexcan_devtype_data fsl_ls1021a_r2_devtype_data = {
 static const struct flexcan_devtype_data fsl_lx2160a_r1_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
 		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
-		FLEXCAN_QUIRK_USE_OFF_TIMESTAMP | FLEXCAN_QUIRK_SUPPORT_FD,
+		FLEXCAN_QUIRK_USE_OFF_TIMESTAMP | FLEXCAN_QUIRK_SUPPORT_FD |
+		FLEXCAN_QUIRK_SUPPORT_ECC,
 };
 
 static const struct can_bittiming_const flexcan_bittiming_const = {
-- 
2.17.1

