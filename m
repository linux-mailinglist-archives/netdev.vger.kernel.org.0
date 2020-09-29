Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42D0327CBEE
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 14:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733004AbgI2Mbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 08:31:50 -0400
Received: from mail-eopbgr10050.outbound.protection.outlook.com ([40.107.1.50]:51335
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732809AbgI2Maj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 08:30:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=drlJ7eUjGPFQdhBrlJ07JX1zOc50oYRp5pF6HgUudTLBCiT/5YkN2hKiJwL7Cwp+9IqkfTgcZCWEbMDFQR2SBqmLE7TjA8orGMWh57I89hk3A8U5uKxnWrnm/2tARw/SMj0kpV8Qt9QW0A84aUy6FimjxoM9OnWIOhxkv68NyKBbtIW1p9RmU/0D0V8I/15f2B9QnODpcOhWljSUI7Ky0bmH2awbbRLAgJmuuxdkX0W+LD/SRVoFJnLhCKvUAlC2pVM1prAey1m0q0hxtR4wy4XsSfY4zSA0ZdsNNq2aEp3O22L0BGl/bDblE2q3ft+6QY2uQnM226e1ov44L/VYLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I91AcSuzKyAYGCoISsPI6FfSuBDE73if+Yri1zvrdsM=;
 b=QWv1tycDVlpn+Ch61od2pwTw5yvc+J3VGlWa46RnN6tVQ68n5r5IBkxPQJJtT5RRtrlNtHSl+tjLtbPydRjwZVWNDG7+jtQxT4G5geXIFgnQv44E75tlv0ssw9+uMcdeUkWudmrbyLHly38EaBTDoz66VUtRn1/w/sXmyKclFAabfTfOBemlkYBrwWK3r36JK1AYtS/hu/UKtwtHAbByz2Ccum+D9H9iDDzE0xpD6bcXlBZTGom4Wb9MZqSsb1JDL0ThULye+LxmiMM/35ljaGUyhP0fJ6ziVZO/TWDh/6QmptcXHS1JFW+qoalVGMH0z7bm5wcy5uq3uHDMMYDIIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I91AcSuzKyAYGCoISsPI6FfSuBDE73if+Yri1zvrdsM=;
 b=Srhz4rtgswPO9me3N+UJ3aYMqNRoHZevLgvBx3cc6QZcq50dTD4CvRLvZGUP+Q/7xPloscKhP5GwVByyNtuXz8x/Say039YP4ztKDxc6DnypwtF8tMO7qJCLQL+S1BlXTmHrZiRG22iiCL8ze8aTBQ0pP8e3v6trtD8Ue7KIiiU=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7400.eurprd04.prod.outlook.com (2603:10a6:10:1b3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.21; Tue, 29 Sep
 2020 12:30:35 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.029; Tue, 29 Sep 2020
 12:30:35 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V4 3/3] can: flexcan: disable runtime PM if register flexcandev failed
Date:   Wed, 30 Sep 2020 04:30:41 +0800
Message-Id: <20200929203041.29758-4-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200929203041.29758-1-qiangqing.zhang@nxp.com>
References: <20200929203041.29758-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0063.apcprd02.prod.outlook.com
 (2603:1096:4:54::27) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0063.apcprd02.prod.outlook.com (2603:1096:4:54::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.24 via Frontend Transport; Tue, 29 Sep 2020 12:30:33 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.71]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 94ec1639-a858-4d12-42b7-08d8647376a6
X-MS-TrafficTypeDiagnostic: DBAPR04MB7400:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB7400FDF3ED121161E4572C05E6320@DBAPR04MB7400.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:421;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +6xucmIT/hk5JL3Nf3MMFBKYqScrtALZ1j6NqUHjRnDpLMxx2jYgPSOf3QcifurlOWU7oiJjgJQHc3hXXW2deIdEZL+TotZKjpf70kRrgnAt3HsomsJ0TnsCQh1vF+2eavhRPI3bVoXnKYVG82JZAtyVQhiO5HbBmds0kvzwUb7lRSMIXN+lrVPmADvnrcAg8d3NE3X2sWGspCdPsOWfFK+dSGYmV+uXo5S9CxlA+e/+d7hkby78jETr0YpxT/uMlIpgj3aoVHYcpn7Lvzns2tnJAVqulvYKEqfcbeV6+ZqIvG+8gKL3OMNkE3hcaKgFhe8O2bWxEi8PXOb5cvojlaLJL+8JOyIhkgpSe0sIDiFXCnSfbXYi17qxwEPNxpOI0XAOMxMehtiTMqqXq6dHGu/my8JGMMAxekNHOHBJ9HL2ia7Kn4E68Tr7M8zmlxUc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(66476007)(36756003)(8676002)(66946007)(66556008)(5660300002)(8936002)(16526019)(26005)(186003)(4326008)(6486002)(6506007)(6512007)(52116002)(86362001)(6666004)(4744005)(2906002)(498600001)(2616005)(69590400008)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: L53E4b9FqUpnSmCf3sibnlBae/3CVinAfrterbEV/beMjJ4E5y5qyQDlduMSxVKX+7JIxzEOCAH6mhA1Wqvbn1oqf7WXGRaXqpG6uWuSy64lmUIxRFuyUXnk/ILsbyrRFPJHGyuG5s087clsYNYTmy3gOlnmIqUq0i1C8U2wnKEtausQjt6DdNgA3r6VtR8vCYKi/5/vMEVUg3g/6AyRHMFfMymC/s39ewUJsf0rOvD0Xv+F0aeHb2zQb2nfh5Foy7CSvdP8JQNj2JxX3TuyjRySHZYDOGvju80C4XEhMEtHEQzM3GmhtoSLsSv5KwH47JMA1SkyXgw1Ubtfs71S8pM1kXSrNNQ/buf8otFjTdLYuLFjdGT1g3ebu/NgdxOzl2ZbTAlXkvaQBMsJrduiU1FHt3XEon2f524biYpx0RlJR93flaLnt8+7PX4l1FrOYacy0P1TbZ/hY/F6rH7nVUoMhuq865Cofc09sAQab6Vhdh0dDdigmFv/3QHEJfI9SbZNp8S98rRbpNFwBmV1lmzhL49liAwscPQmspn2uGtpZac1d3jPHcSFkZ5INOg7MZsp2yxLR/BOk9FxItOS5oCS16u73C7UPMUCDjFUwyXcOVJJOmXoOyf0EftVeaqA3kuThAW1BqVw6vkZ0jSJpw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94ec1639-a858-4d12-42b7-08d8647376a6
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 12:30:35.1143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5SQl6Q3nNNv6N8gKglGtEiKyACG+483kQ7Ytxnd4JWXVgi4VbueqcCk07bjz0iASb5CI/Iad/Z9KORSIxIRkNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7400
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Disable runtime PM if register flexcandev failed, and balance reference
of usage_count.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
ChangeLogs:
V1->V4:
	* no changes.
---
 drivers/net/can/flexcan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 1dc088984125..8d41c4ea403a 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -2055,6 +2055,8 @@ static int flexcan_probe(struct platform_device *pdev)
 	return 0;
 
  failed_register:
+	pm_runtime_put_noidle(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
 	free_candev(dev);
 	return err;
 }
-- 
2.17.1

