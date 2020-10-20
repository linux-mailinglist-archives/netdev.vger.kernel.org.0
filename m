Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A0529362F
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 09:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405630AbgJTHyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 03:54:38 -0400
Received: from mail-eopbgr30052.outbound.protection.outlook.com ([40.107.3.52]:10466
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405589AbgJTHya (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 03:54:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XeYsSC3bllcZivGSw+KuyKuwA0nOt4U95281Qr/09cowk/1KI8WU2AnWd6mRVZIHC/zGFBAtAuPdUPcsDshsS7dx4AYPM8MKD9+qVF/iVcNvEtBtWIhIivPoNMa8hbw+ey8jLMOFJfuKdFdJs/QspYW9ywBw7KhEXDDA2fNDtjzUOCM6wIaqaK11CRW69x1ebE5ltpIl0N1IpTJDKX/uiKfMpQZ/UgEE9sK2IQF+SbKIJtdqbIACUYax1ET7GJqI52tdd5pXNBHbA+4oZajbnshjngNwbgqxTdkKzoyaK1aOKyVAQv9rKEH233+bICoGr8txobZQqTLqveuzV673XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o6JwQvlBzuwxX1Zc6gPv6hmT5UCvH4gTICaEy/wIRQY=;
 b=mf7Ka6qdFJfA316ZhSk3CYPS3l7Xuv4Q8XLYsk+PTb/Y6Ip3EeEYdgGY2IleGnKVLycGrPjqJBrO2/jVkLoJmYE7N+p1jtuDqX/r4PiRkrT3fsXEjCEros+iAcRbra2UaJR+jV03+Qsr8kU69Jv2oW/yUikIDugX0FzgDValyCncLBJ2WazFuBo4A5effyV3xNobMjHi/ftTlWpE71FXgDq6jlVjSTMd6sKc0Q66duAAUQJ/qkQrSe6FzbSANjOKLD7lkauWQlQ1/ak8e3Jc1zsAkIu8/Kl+oEU0s+RqsBcbPlilReBN9+QEYEzz9PVydHrrhkoxigtbq64+6leLgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o6JwQvlBzuwxX1Zc6gPv6hmT5UCvH4gTICaEy/wIRQY=;
 b=XZ14sCzfYaZsQoKnClCRjzdEdFV1+1stNnAE1mqabK2ShOiNP+U1vxQGUJUHct/QwPzDxz4cepIvWyOJSDKp4VWF9N/cQc5fPFBdewhGOcpW6LiCmu7VxPWOWlwecdcQus4nUJR+jt4q//3UQchYyRtrR68Pu2ZGLaBj8O/FiXM=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4106.eurprd04.prod.outlook.com (2603:10a6:5:19::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Tue, 20 Oct
 2020 07:54:29 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 07:54:29 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        linux-can@vger.kernel.org, pankaj.bansal@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V3 06/10] can: flexcan: disable wakeup in flexcan_remove()
Date:   Tue, 20 Oct 2020 23:53:58 +0800
Message-Id: <20201020155402.30318-7-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201020155402.30318-1-qiangqing.zhang@nxp.com>
References: <20201020155402.30318-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SGBP274CA0015.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::27)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGBP274CA0015.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Tue, 20 Oct 2020 07:54:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2249435d-6a5c-43b0-a1a2-08d874cd5f4f
X-MS-TrafficTypeDiagnostic: DB7PR04MB4106:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB410653DD77B48DE28AD2985BE61F0@DB7PR04MB4106.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uKZrvVA0AEncV/78D1gc5a9PaPhiv7BrGecZ63ZTMCCM7t050/7ZPxCvzHnAXR1eM815xBDkkoJZPwd9YW45qH2Jv7pxTeTVkrdGeJAijWDAxLcehVOGQVZG7bu/mvKyczJuCZPIcLgjYG0lYyymBBzLuvAukotYk2vzYcdmcpgNMPep7kHwfsyjekxOySXBiBHxmjEBA3BZHRtpsMD7qWKbIIUgS9w2B60MSeCAbSbvgQ7W8BX6wWiq7Xa2tiOeLRxR4oWRyHnFBmvUSmkwTxcOyHytHeSaRsGg0opgrmNv4XADgeQLnaUvfP+GC7XUWWtCrRglUnQQos5Trx+r3oGNwM1ljQ/ZrG8oz/OdvzMrtxl5ljwB9BS5KNZuYsjT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(346002)(376002)(396003)(36756003)(6512007)(2906002)(4744005)(69590400008)(956004)(2616005)(6666004)(5660300002)(66556008)(66476007)(66946007)(1076003)(16526019)(26005)(186003)(316002)(478600001)(6486002)(8676002)(6506007)(86362001)(4326008)(8936002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: bsULIR6YEtDTrEEDxCoxlP8ozTVfvzwMaj/41si2IyNnyuMsRIsNcVkKrO96I+isWwD9MDatNSGCcDCYXCrcrtLwv66egUB2zAvKaETWClXTQ0wU6W2uOFLJ17AUE5onW49EM1GqpO2dWBn+unbvf4StuiDbEJfttvHKEAoNAseJhoJX4CJuPldiNOeSFYvLfsz+Bznz8WIC2BkYSM/AttZqi1VYqMjlhNxdfjWOV2LG9NC0WxqtZu27eAs5ytpbPrFrHrlxAMW+C9iLfnXgchfn5hCDqW5lXrRPetyNrqBoz16DLwke0+XxGqPaIbjL5w+s5JdU9AQ+Ds+qKRZTZWz8LcLfYn28Yk0n3w+e1J/jN69kyfYH8jqgBiWCyTGeW00iZQ6DhEbJ3Jams/Q/MsKpKEnWQs1oDWJm3NfhN0SsfYqyhEhKinrcgv2Av6BW6XKosiMgByzABKCFNWDx8SxN0hF9TbP671y+6IzSxPEDiqqz1mAXdNaTaCaw+aM9Dv55eCrvPvcDY1hcVfH6WTaEfTlzMVKB43TBvRpPKC8Ay/KkcnB3t+l/zia57LinRbskWhFWcbjvH9hhVHfeexFOzf+iHSOXF1f8laRO7fIlT0Sj/IP9HoafNTvR+mFzAPCyHAmW4ZGfmjdnHacnXg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2249435d-6a5c-43b0-a1a2-08d874cd5f4f
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2020 07:54:29.2163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XNkfpvNhN/qs4BRG0XQaf0P/sI6dIlHrztvGd6PbyRZLrDeAFK0q2RCdmyUY6QWvcXBdqyh1UDvtjv3vDdulag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4106
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Disable wakeup in flexcan_remove().

Fixes: de3578c198c6 ("can: flexcan: add self wakeup support")
Fixes: 915f9666421c ("can: flexcan: add support for DT property 'wakeup-source'")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 06f94b6f0ebe..881799bd9c5e 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -2062,6 +2062,8 @@ static int flexcan_remove(struct platform_device *pdev)
 {
 	struct net_device *dev = platform_get_drvdata(pdev);
 
+	device_set_wakeup_enable(&pdev->dev, false);
+	device_set_wakeup_capable(&pdev->dev, false);
 	unregister_flexcandev(dev);
 	pm_runtime_disable(&pdev->dev);
 	free_candev(dev);
-- 
2.17.1

