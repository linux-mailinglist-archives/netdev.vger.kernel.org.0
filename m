Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3174229362C
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 09:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729526AbgJTHyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 03:54:31 -0400
Received: from mail-eopbgr80059.outbound.protection.outlook.com ([40.107.8.59]:37251
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405574AbgJTHy2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 03:54:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AyDhIDsQO/1BBPgCLRe9n2M+pYiT5YEsuUVbYWUCDM8FzlJp7Sp2C+utTG1BiLKrk4EOB+ZdktKLB835IBWWTWmDBAdx8GZS5isGxR78CWcQNUCa5nCV3Gf/OV1A3db+xrG+CRX2NQLk7UZ8/PLa36kObcD6kggpEpiccMEmsLy0sckqBX3MMm80zhOJwfThdMzOgQmqTxveojwqk1V5UaODEjKN/WGgg/KVojsk/Bh23hoJCwoAkPyteOgjRLMW16Lrv7T8zI/KuOQs6eaYbzlLmfynLJEGGtzOg66IHj+E+bG6M1ZDcpwT1PrQqfnIBuOjibzczpdHRarmO7o7MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x5xuKQAQda6WMgDOX2SvDxTU5/aWbfXr5OA6dTBscEI=;
 b=eDvY+3xmF5feqVptB+aqfRXwmf+LTMS6jyvvmgrkALxN7W5hUy0DXf+NgWsSGdAJTQQELXtzFU8tz25xAFtOxAmuu8yBFLHYsduqrXK8VYST1c31VzR/gMQgf38OHLAXu+2fzG0EYFC9ubHbun7kIXQTjbz7F+taq5jU/UUXcmjWsyp2b+e11b3wysJ+7tLw0a/4j4kagNMEpHsnbPIYC1bCRFyDaBSS6F/dipVNFJ2+uIaKiZttd38xoRfy5B3n6V3t0bxxo8qRJgvGQmz8YX15235aR4jtlNFSOGoyB5z93t5NYcEfhACgb3ztcWe3E6JFUJ11OtKLHdI8zqw2/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x5xuKQAQda6WMgDOX2SvDxTU5/aWbfXr5OA6dTBscEI=;
 b=hRoZ5OcKHj1qK6RKRfIiyhH19WdKOqDA81hn28O4euPfwULSXGQMrnHntQO6Z7Thd/o6+Wwspn0YyEzTbwfbxEerwZMdRpqWsgns7Yg92YnjtKm1dW0tLK6Okngghm564Yp2oyOrVR7fzwRAqtXKc+06p6mouFmdr/k+H8poRRw=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7333.eurprd04.prod.outlook.com (2603:10a6:10:1b2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Tue, 20 Oct
 2020 07:54:25 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 07:54:25 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        linux-can@vger.kernel.org, pankaj.bansal@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V3 05/10] can: flexcan: add ECC initialization for VF610
Date:   Tue, 20 Oct 2020 23:53:57 +0800
Message-Id: <20201020155402.30318-6-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201020155402.30318-1-qiangqing.zhang@nxp.com>
References: <20201020155402.30318-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SGBP274CA0015.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::27)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGBP274CA0015.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Tue, 20 Oct 2020 07:54:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 22689466-5d82-4967-0d84-08d874cd5ce8
X-MS-TrafficTypeDiagnostic: DBAPR04MB7333:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB7333542572FD772BCE94D3CDE61F0@DBAPR04MB7333.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vg6Crz5YDd7vMBFuwSSTfoZixR+BMtNimLNn0jWvR8c1Iw+5jX6M4t1JkFQhvHf7ktB+UJut/D2/30tqKLIdPUDxc3xVdtsncEdmo8dcY6d4iYY1VTFh/ub175GMXYBk9gwvtUgoCLWugBKuu8RfAdeDBIH5NiYrhgpdayblqGdoC5TfuV85Lg56f7mWDehlrqJZiLsfnQXwn3BFc/DO9fYiZSCuJ9o2x6fbK6g85/Dm7pHkqGhuxUnIxKve50BS/c7oaLJxjmTrMp6SejQftG1vgLzB+9bWpecxy0WYPsy/6lN6QTCZw1Y3jcZQLUcbxuQEbmrGYtrZKai+mYSsRlBwwUCUWlCfWrN7VG7UV/MsC8IvIsWLJu2mr6mDT6C8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(39860400002)(346002)(396003)(6512007)(2906002)(66476007)(52116002)(66946007)(956004)(2616005)(36756003)(1076003)(6666004)(83380400001)(69590400008)(66556008)(26005)(316002)(4326008)(6506007)(8676002)(16526019)(5660300002)(186003)(8936002)(6486002)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 7A8hpWdT8UMjanYi+S/bWpS1W3hd5vDx0y+uAX1HT+jVYdXGw46gPu3zr9Vm5A1wupeGr9nUACPFVSdpXgSoXuCYWXHlV3GStzRRSROetGFhhHmXypMXdul2wnf/T5JdzUwcuNlXTCL7Cz0uMz/gr3HsukbsdfFQpgkdMd2PWnJUt/Xsgkwi5LlTaFYQTVsjdYD4aKdowHPVbnAXWPWG2ZBc3nSVSECnE6Hpq9PKmf/51VRnrbrB3eOBCsLuwXC1H7BSFoqROfBLvR8YlNAgZxr1b1hQ45WpyQQ6TDvNL15PQZIJ4fosmjBR32ciet8HskaqSSe0cZJtnlTn1xaU21HJbkRgnoI1ECdHDNGL0TXNZ1hB3p9NxUHcFo38h4iFkWKWt0NzknW3UH8c1GypGCL57mc8Dknnh/evKqx//UbE9r2O7IYpxwxg1I3ab9Qo+CKB6KSW6IVx8FkxqPQiyafkh2JMFttxXT58kS2pEq/xd378J6UWz9VuQ3NhhwQBqjZEXletSdIyfjQfnYrD159Wc1V7ki4kqo6w8C2Am5DgjoPmz58jK5zyIPckIXp+rRUhTq9IeNP1qX4KJmlIIaAd11froiV+uEPNqSkQfC298i/asRzwhooL8ThFowrmGKAWZCYEXwSNtfgqOVbNNw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22689466-5d82-4967-0d84-08d874cd5ce8
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2020 07:54:25.2179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FjbHpwjXcz6AhYj4+lHBbdpmpfHIEpJ88fsNeVDN1KHsp9PvOHuuXoCZR7QmReDQPDrSmhudv6Dom00ts3rFNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7333
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For SoCs with ECC supported, even use FLEXCAN_QUIRK_DISABLE_MECR quirk to
disable non-correctable errors interrupt and freeze mode, had better use
FLEXCAN_QUIRK_SUPPORT_ECC quirk to initialize all memory.

Fixes: cdce844865bea ("can: flexcan: add vf610 support for FlexCAN")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index c2330eab3595..06f94b6f0ebe 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -400,7 +400,7 @@ static struct flexcan_devtype_data fsl_imx8mp_devtype_data = {
 static const struct flexcan_devtype_data fsl_vf610_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
 		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_USE_OFF_TIMESTAMP |
-		FLEXCAN_QUIRK_BROKEN_PERR_STATE,
+		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_SUPPORT_ECC,
 };
 
 static const struct flexcan_devtype_data fsl_ls1021a_r2_devtype_data = {
-- 
2.17.1

