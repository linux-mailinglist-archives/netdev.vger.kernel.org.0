Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20C7E278145
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 09:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbgIYHKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 03:10:43 -0400
Received: from mail-eopbgr150084.outbound.protection.outlook.com ([40.107.15.84]:22663
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726990AbgIYHKl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 03:10:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UPI3XisofNI9I2t5WhBpwHhnZ5kQXuw+g0VisasKTTb7pb9hF0PGwLqDoXZnMZI6crbuuDpxwi5Bb6FsGSJmXqZ6xm881KI70DzwyhVHwJ0Trh5fP7iiesjcQ42IUZkyZW1wyt1nEWRPDf4PZIARFuFzt9P57oxDwasEUaP8U3lgli1CtW8STsgQwLGFTxY60Q/gwXREv0ZeT/Bb9xqNZ0uhMdg1tEIInX3B9aqxNxZuUFLaVTi2D3OKNL1ulsEbJzogXFN/dpV0Lkakb6lgTIFiJH30HRcs/+QYqYaTzE1PAwRrng2Ar8Jft+hW2RrYE8HbRIgl15TKt5DyRF5ASg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LexpzSwMskeXHuas+NJHPkwc+F6/7yiRxDzzTeDJd/M=;
 b=X7F10+CyFLkcx/e+Xa9HxamDQnQBeQau2/uxYKC0EWsYehCzRAZ3him3aSY+IIXwrmGgfnghgcFv25nx2LBn2N/vD5z6HVD5AVH7c7zr0h8lDYWYZqWSEWVdN8l2kMNWAo9pwuBk88a5msJai5gZhFGZCSszcms68R5/vyf1nPR1YjiEdgjb+gr4vZp264Iw5fbF1EBUJI4dWgoT8QxSPWzN64Qn29YC8+35ozeXB5rM0OuSJ2grACt9kb4FryW5rEvv+x3wW4vyd8kRTf1eaFAJ/RHI1f4eKAw0PTvM/TkDM9ahNgt0bZVhUhZ32oH/0CeAqZ7jMZK3TUC4S6lfNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LexpzSwMskeXHuas+NJHPkwc+F6/7yiRxDzzTeDJd/M=;
 b=Lly11WW/q071c7ThuILVZD4hdU8QYUz7pCGAftjcVi/Pz28fQpQtIkdet97yXbEvtT/ZEzdinPyghVIcp5jgmYIzk7NRr3+hCCFZYykMuiVo5QPioCe85VbKlD3SJ6Hf86gbQoU/rcLTWhaEVd6DcccpYIiXYm2HipLLBjnrKwU=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6971.eurprd04.prod.outlook.com (2603:10a6:10:113::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.23; Fri, 25 Sep
 2020 07:10:32 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.022; Fri, 25 Sep 2020
 07:10:32 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, linux-can@vger.kernel.org
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org
Subject: [PATCH linux-can-next/flexcan 4/4] can: flexcan: disable runtime PM if register flexcandev failed
Date:   Fri, 25 Sep 2020 23:10:28 +0800
Message-Id: <20200925151028.11004-5-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200925151028.11004-1-qiangqing.zhang@nxp.com>
References: <20200925151028.11004-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0240.apcprd06.prod.outlook.com
 (2603:1096:4:ac::24) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR06CA0240.apcprd06.prod.outlook.com (2603:1096:4:ac::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Fri, 25 Sep 2020 07:10:30 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.71]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 26560574-1c12-4657-376e-08d86122173e
X-MS-TrafficTypeDiagnostic: DB8PR04MB6971:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB697159E8567E9CDF4C7C58C2E6360@DB8PR04MB6971.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:421;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: csGhwMRID+7CebGhFMkVGJ7wJybpWCCe9yZBq2TzabWfFRo9Tt9KTVOZhZSNF178Yj/z2KT2pxU7HCWqtTsjv2mxn1n+SZrVflGWodGFNju1DauYxIbLkBMJG2XUSRJWTtg2MmBGMr8rz9ZzcNByz7NUB5Nua0GKceCynxlAm5lvHBY9BgoEyWuG00uVxb9pBexCVUqqfLsSrDKg0gfEANm9W7S03aU7hnvsIU1qJMN8Z3gKssYUKTgNZKRIVsDHIB1bmS2u0kG3k7ZTeG2uQG8krRRBTKoJev35jnyqdIdYv9QaVQGPd9W/1Fl/OfhtkEXCEHElLtSvGT+X/7kW6yVLllFnpElB576z36KoBONidB/AggGeR+S8whjERB6QGOkp2wwPb85fG+cQ2+Kaxh21uIaDG2xq925550rMEk9JAWfUxvvXKZdpUY522CrC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(136003)(396003)(39860400002)(478600001)(6486002)(66556008)(956004)(2616005)(1076003)(66476007)(36756003)(16526019)(186003)(5660300002)(4744005)(26005)(66946007)(69590400008)(316002)(8936002)(6506007)(4326008)(2906002)(86362001)(6512007)(52116002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: UO3rjNXbLBOKyCJ75vJMkvbuaZDAVeRtPFFS9yWewipnDFVH/tPXMHW6h2AfkhRwRvuodQ9X7YG4MFhP3uAiT95LJUx012q1THXi1pQPGgtsz6RnXO5i/+F6Eh9+Z+8RJR+Zmx3HQE+Wnvnr5wYAaK7AazYaoDqs7QOcEls8eHwe8FK/lehrNQm/VRfQRFBYjZsHve9jlfMbbzxUtf6pH2OLR/h8NVxdJlqK6p+Mf9olS2mb+Iq4VO9xTHRv+KM8OQUfq5/yJUAcBAWI3d7gndwa2xBs8NYUfgNjcXJwN/eNMw+BmY+0O15VvJyuzRaHib9Pz379eu+r3m04YTFOHha39+U1/oRu5KyhrYClZbKXXcWgva+BXA/qqplsrfes1Iz63eaHImgghmnYlkOAkZW+Cj3CC2lEPIEKBnlkX/WHVIZhtz9c7ATheO39NfefG1z5pIyBI64QTAIIn+HyVrdNLMM8vu1FxygiZVJOX9vUVGg/WsQOVHyWfQYDOL/O5TCTcBpUfQxGsboHTkd40i/6ncRnf8X5kOGgzhW9aJ7o6nhllV/bJzS+RCQgm1izvRGvwaCmj6XFgXhFFtOouDNPrvG+SjYHONDtZz6CdriQNS9xZdgpZwV6/uZTgSgG4N+ltY3IAP7zyYJlTMHK4g==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26560574-1c12-4657-376e-08d86122173e
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 07:10:32.2827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Auky8fRsW/u0Qp3w6MWx7ragcPTDj106DRGwAvwBn+ReTSLVILXf0tQy8QdisqAzvTHk0bq3kBvpXJqixNN+FQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6971
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Disable runtime PM if register flexcandev failed, and balance reference
of usage_count.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 41b52cb56f93..dd9845146982 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -2151,6 +2151,8 @@ static int flexcan_probe(struct platform_device *pdev)
 	return 0;
 
  failed_register:
+	pm_runtime_put_noidle(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
 	free_candev(dev);
 	return err;
 }
-- 
2.17.1

