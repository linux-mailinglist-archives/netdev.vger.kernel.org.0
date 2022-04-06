Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15D24F6167
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 16:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233952AbiDFOAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 10:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234172AbiDFOAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 10:00:20 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2125.outbound.protection.outlook.com [40.107.255.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48CD341F61A;
        Wed,  6 Apr 2022 02:17:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d7z0i1CjSS/XWtsgtr2csk2AFpFApcL7mIMyYzmpCVPYjY4Vn1y6/ucPgR8flp/13xVLazvtGyIY39TL4XKxDpj+jQxvGy7M28iFCoGr3F33wXIGCxn1B3SX27GYcoUEgmuB5muydjp1C3n+k+vt8yRxscD8+D6lAsrsRs0VA2CY1tTn073dvW9T9pIlna4KCTnHSApe8F6wWwqC1WvWAppjWDcdj7cHsyLf0GcqnK+FoYsultTS/dqYPXR//N3r28AbHLMOOhgpOHTCsQmHRTIAVjXXbGUatT5KrBfUitT5qITVZmhnb8+deULDfyDzJtiUuCeKlfWUqmJkNe9MvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WzaTI8isN2L2nFbXn2wHNEiF9xB0iVzX4iHh8M+Sh3A=;
 b=gfPSdKC7plmR68x37B8lFWsZ7hm+aeSlRBHE2R9bon1xBnV4TKl2tmlOa3JETP+VJ1IbiZMF7bdZZjceUMHIqV5p9iRPmIDCW0aJizjNkrpv1oo1AfAEmJB7kwjvwNFf49Rbtn9lKvH3LrJR9DDMP71F8LbWux3wzJ4B9kC1vrEXOiTt36a2EkshHeRYvu8SpqTBtdREi6/61Q8/nbhgZIhsxad8pdLG3CTbfffP0SUDTv/B0jPAzG+ccYBqn1XQ8fG83CjMi7w38L7Hrv1EOHZTTmoZ42OM4uun0kyBREMEGQ8U+RN8/r67kfcjiolfABETAEI/eiOqeeK/k28Ugg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WzaTI8isN2L2nFbXn2wHNEiF9xB0iVzX4iHh8M+Sh3A=;
 b=hR1mT11m20Zh/AQYUXT2+MYkAE62oryQ1aO8lLIKffL8s4htMlaXhP1crqbMNT/xhWlSttUjlKw3s6K7Q2zmEFLE6nIg6kFuAuSM9+8KRF0Lc9pF1OILwylRuJUY2rV7ixSpsCJDcBGDK3BR4ZKOXeJxa3ohHZWlAWLCxKm8kjg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by SEYPR06MB5255.apcprd06.prod.outlook.com (2603:1096:101:84::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 09:17:38 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::e468:c298:cfe5:84fc]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::e468:c298:cfe5:84fc%6]) with mapi id 15.20.5144.019; Wed, 6 Apr 2022
 09:17:38 +0000
From:   Qing Wang <wangqing@vivo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH RESEND] net: ethernet: xilinx: use of_property_read_bool() instead of of_get_property
Date:   Wed,  6 Apr 2022 02:17:26 -0700
Message-Id: <1649236646-4257-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0201.apcprd02.prod.outlook.com
 (2603:1096:201:20::13) To SL2PR06MB3082.apcprd06.prod.outlook.com
 (2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee40ddc8-630b-4a75-cb2a-08da17ae4b15
X-MS-TrafficTypeDiagnostic: SEYPR06MB5255:EE_
X-Microsoft-Antispam-PRVS: <SEYPR06MB52552919F281BEAEFF163769BDE79@SEYPR06MB5255.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wifTB6T+QW2VJpvia3LsWRAgX4txE5wYDc/MmFOL5pyhVvJ9E/9gYCvqWpmWpfu26TvIs2o4S/JnCq8hnUOo6tYOV3QPI1chxvThTN4f1jIOH9a9Syj499NBdc+SbYgML0TyCuqd3pV0G8ziUWfLtB+pAi/OCSVN3LV/tWCxq0dJL5kY2xKr4R2AfRMFW/TqrM1IAp1TLspk1098/V43TSE/semucv/AwwoH1aaznToUN9aJLa5Uu/MsA41+6E6+IBgMXD3JKi8YyKS90TqPjmM4VT5bBmZGBdlZtMVXjmMQ5sU44L6UPOJfR4IeKS29+DBweplGkCeCjxJ2KBRKkRGECTIeRbf1iJu7E6zOQXq1W2zgQX1k7Q8Vtuo5bEbO69J6ltevhs+endY5p+orO4lNhxDM+21vYBLo3jEjBUkdPgcUxi+aDJdSTSlVOuyoLO2ZzFpBJm9BV7h6pVwiB+lXtmNSNvqx9kCqRtAFNmTHbADa0RKur4qmC8mzZFdlFypDx54kaEKM7zyVllaFCUYKcnz8DnSzun22b7ojq3UMDOgjKuxYWBFtWbXbU2OMUp3u+mzBNjzCPSmOzc2NHBIUH/1gjsuc+C0icR4RfC8HJYwukqUUjQAzqLLWQPQUTkh9XD3mxAkNFEgB9xzhXlpWidKRz6m8SVxuS70ZcdTMD0xVLMWEmK0q56xWGSxFKuZh9xsKp8wBj+g9G/VWfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52116002)(6486002)(4744005)(83380400001)(6506007)(8676002)(508600001)(4326008)(66476007)(66946007)(66556008)(2906002)(86362001)(2616005)(38100700002)(8936002)(36756003)(186003)(107886003)(110136005)(38350700002)(316002)(26005)(6512007)(5660300002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MoTOxbUyoyVcQfa0nwGxDRL2IWwRvifUfEFwFx02WTrj7AtNtwoQMvz84xoU?=
 =?us-ascii?Q?yZ2j79chY4K8k9ikQ0U2p3J4bzPmyJfD70oiEZOIq8cL3QFqVhMxb4pPCjah?=
 =?us-ascii?Q?ayowruXYcbJ3rOXD2AiWxhrBrEeNrP6UkVxHpr7KKxEwu0qq3d/K0aaRpikF?=
 =?us-ascii?Q?5aGUQHW4Lx9YOW9CvW/PVihuS8+89PziH81p8Jk/Y1ARTfERDrARw9/Nw1to?=
 =?us-ascii?Q?9XQEOZK5keErpercBL7ANct5IZk+otFW5MR1GEuK6NiJgDXIY4v1cL4QRGak?=
 =?us-ascii?Q?Z4Td89ZQflYZlSvE9iKy75v1EuXrfVyfEULTJchDQUvmJu00ZKnK0ndiS/su?=
 =?us-ascii?Q?80DFLWESpRFYB2L+DxYUTyUSJHiuIoEaxV2hl7Fw5G0OBjV6e8yJJ2aIWeSf?=
 =?us-ascii?Q?cOODy7LzvOezqhEn0fwH2UTuJaAMf+Ze+WHLRVu28OaVT7lkpjX5BvIyW1P/?=
 =?us-ascii?Q?+U6NEHixiqgJjVnD4i+xgBi8iiO56I2F2Mk0FIPOCBLSmuXd3RlRphtpYrr/?=
 =?us-ascii?Q?GgziFwqsp7rxV1OgXlXw4iPIKqMuNHMYbXJQX717u9neV/29+BZ88KFs3FGb?=
 =?us-ascii?Q?E+My8CwoRu/L30sM5NoJXcg62qpGtIoq7L47R/a6d9DOU5tZcBLL4+HfxpdW?=
 =?us-ascii?Q?qfCDim3rXO6r+TX2qvXHDIHxeLVxIbDn/XE0mfcPhjo//Kn5gJYfYc6XfSjZ?=
 =?us-ascii?Q?v3M368PY1X2aFD0HcXWVQBnlxbQoNAekjXccz6/lZCHYxNihAP08W1cw0Yqx?=
 =?us-ascii?Q?KWBby0AK54g7UT8sEh2DQz3+ClJLQHpIp71Q20J6sywXxRRO39XZwoTvpN/g?=
 =?us-ascii?Q?vnJBtYFX6p+vbPPKgGtPzhOroPhrLo3gds0sJUxSuEkkW2NZPuEDX9oMjTyv?=
 =?us-ascii?Q?ZgbFKBCeMWuQei/+wzNP+jyDTFgLsQwMRxe08Gq7UEfImMhqs3hwHGeR6hlw?=
 =?us-ascii?Q?6Wcx3MhVcEOfR8O5bjftdeb1bJ8KXclSuirEP4uu5rHGgeAYKnC91EGGJu17?=
 =?us-ascii?Q?06GKYdivDk9lHgkCDiG7qbYXY7COe7hp9yvuiKRnqyVz7fDaQjmuFXo8pMvN?=
 =?us-ascii?Q?0LmI/rc/+1MwzWTDTiw6guODcc08p2QRErk/PjdwTCgKD8tTGdXc0Z4skdBm?=
 =?us-ascii?Q?R97MogYXRF5ByQVfGE/enGGOrpvIyc0Mvd9hF9izN3iCIH59vZW0RX52WCYS?=
 =?us-ascii?Q?n2Sq2vuarGrc6kDF3n5ZfPDiDIN9KIhHAve4OKnKVQ2qPznZyxLX9afYZ409?=
 =?us-ascii?Q?qcyQF/n2KkvLRgSCZHW9zpaKpv9PjXMHP52P20IgDUcFEDewjaQ9JXyLat/q?=
 =?us-ascii?Q?Y9U0w1VaKKKU22bAAjhLwiPTJjHAH/47F8R6f+L0TdqplamKav9oyTxTD1EY?=
 =?us-ascii?Q?4IWFm0hyChKgVxfqNkWpnQl5y6+3NWXLU8bUbyAwMD89MUTP787shxLg//65?=
 =?us-ascii?Q?A5KRx2EQZuIRbfk58vB77z/QJXvqgf/bLfeVs2SIf0AAKZW1P256R2wpEoTu?=
 =?us-ascii?Q?DHmlxCawnnMM1rNDuewgOONZ9Y21OXc5k6zNb0806TBYMuHtRHoThgWJihGb?=
 =?us-ascii?Q?Bdxr9Oe2B4jlx4Zgb2+BzcNdmM4Cqcy7s1y0Gqv5WbiBbZXIkJ6rfXh3gc0K?=
 =?us-ascii?Q?pVnAf6R1HT2qGYlI7UzROu2GStMl++91ULfrP8uG368XU2QVrF5Od7Hk2ewc?=
 =?us-ascii?Q?Fnxo+IbVbXoQed74T6L42qLLSbUi3GJgP/L5ZDxMDkDzDt+2jLVC+eEJ8sNZ?=
 =?us-ascii?Q?aAHZ2auB/w=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee40ddc8-630b-4a75-cb2a-08da17ae4b15
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 09:17:38.0626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8jKU6YOlUFVgwjVr/Nblj9AqK57XlBGfiDKQ7Dk5HHj0Bg4tK5Ky62uDF8eFZQmNkFaeHMsTo48saHnCvtjPpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB5255
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Qing <wangqing@vivo.com>

"little-endian" has no specific content, use more helper function
of_property_read_bool() instead of of_get_property()

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 869e362..3f6b9df
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1515,7 +1515,7 @@ static int temac_probe(struct platform_device *pdev)
 				of_node_put(dma_np);
 				return PTR_ERR(lp->sdma_regs);
 			}
-			if (of_get_property(dma_np, "little-endian", NULL)) {
+			if (of_property_read_bool(dma_np, "little-endian")) {
 				lp->dma_in = temac_dma_in32_le;
 				lp->dma_out = temac_dma_out32_le;
 			} else {
-- 
2.7.4

