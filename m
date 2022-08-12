Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC40590C2A
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 08:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237079AbiHLG4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 02:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237065AbiHLG4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 02:56:13 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70053.outbound.protection.outlook.com [40.107.7.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141F49D121;
        Thu, 11 Aug 2022 23:56:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nouQDmB6n8CkaqFClQo5DKK/TAOV+44qDrgZ7qR6alUHpAapOx6CFAxSg6wsR80+4JFuedF9srsJzaQqMyCZ95YHmCja/P5XoZU8beAL/GsWDxEAiBsUjer7L5Mro6mHgPDjDVKDvGecIBUndpJoZBuD+BEy1jFdLpKN8dqMxSeVh30nN4SzY45kjmovk6yq6U+/6J46N5Bkk9S3a8wicBgInXlL7fnfsJM9VtOpMCQm9scxnzCa9RhsZIddeJbGkn/YIF52iD74rn/HnLbT9s49GJA+ztjKie6Rp5A9t/nZRNKRkju5IcRgLWsCrLSXwDnnds0AVUv2ZIFZK5ht9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H9kFpWFdm2tN0N3Rk455RHeJiUNoHlqbIKymdnhKuDs=;
 b=lL97QFwxPVMKtf2hU/hyb2BQu01fKDQAhEZ8WM5dxvNDQs2VM2pUQsh/55gdsnMl6sRO/ZA0ttzl2KLNpofbY6KyvMfMLt9vVmv+Lt5wtKaNYf314H0aibkxkw7SHSsKcJXiC0wNf4rG0y7Rthp7x6WGAxtZG+1QWcEp9zCIvV7Kmp2vL+PyPg61QRknTxdV7SLWlq8H26oP3j5flq1jWNnpGDF1vpamrMBEDvMw0WqjVmsza6CL3YHSnarq9U8/Q8QsUETk23ZzqpL76P1sJbTStJBGeMZ2JmphNDhCaukzUm0SNLOnMHhPM+Y7K2Q+EjqZ+946S4ChecT87pGCHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H9kFpWFdm2tN0N3Rk455RHeJiUNoHlqbIKymdnhKuDs=;
 b=DLkfVnws6LmJ9LwcZJ8an+UVnAt7iqlFR3yZuqVEpVkz9dk1zsWV7+gfFvWWb6XvhoJGmjfiJynqZtHaXqSgfgSgDb0PgBIRbkGnpb/cD17qFs9Egmif+PcOVA45Iy6Y3UzwJdkGf0MsDF4dG8UmcSRrpBgldSSCxy6F1+teD5k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by DU2PR04MB8616.eurprd04.prod.outlook.com (2603:10a6:10:2db::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Fri, 12 Aug
 2022 06:56:08 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279%9]) with mapi id 15.20.5525.010; Fri, 12 Aug 2022
 06:56:08 +0000
From:   wei.fang@nxp.com
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, f.fainelli@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 1/2] dt: ar803x: Document disable-hibernation property
Date:   Sat, 13 Aug 2022 00:50:08 +1000
Message-Id: <20220812145009.1229094-2-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220812145009.1229094-1-wei.fang@nxp.com>
References: <20220812145009.1229094-1-wei.fang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0207.apcprd06.prod.outlook.com
 (2603:1096:4:68::15) To DB9PR04MB8106.eurprd04.prod.outlook.com
 (2603:10a6:10:24b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d6c6c7a-fe2f-4f6f-3c33-08da7c2fbb8f
X-MS-TrafficTypeDiagnostic: DU2PR04MB8616:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tcDfuGqDvYEAUZPhBw+64Ea+nxj5evf1EM/S3zotdA0zXFHkK9WCqZrd15GlSz0nhDRaaohwlLqbNJ9Dzx2IgVMQZ5N5/pWlOjMFbRpZU6D+rT9fgXcPu6jNw3jFo5kPu665vv2ckyN2+kXkPk45JseOoJjIBk7Hi2vAiZYGpGvU3bSxKAmz/ve6h7wlK1iEJAuUcjzUL9/BfVv+r/dn7bNa61U49mrPwKuLLpcScsc7kw7eG/K6h9G5OMl/RAvy2EO01zhE5dgW48vffkmec/gU4NqffVp0FR7e/F+GAHbrC088RHFWn5Wk01vzD6bk6d6nKmkKEpo1/Zhsh840xbo/j8XWnk7+jooM52r+P+D68NNRmgH7mnK//2XTTbWEL7dV8kFp0C6oJhXdObOfQMMM44M62bOzvRubVsMxgwEy2eeVG/9dOq3sevCv4ry7gdV9Cm/SSJzdy+nKVyhVD+OevwVi/wTScV/qERtY0g+ObboOsgZ8nyO/uL2f28RQojSWxsW5XBAObrRDa51wBy3GrfAflKYx7Ae6aareFGSFppT0tu+ZcQr7DomANzW9WBy76bFaDsov79S+YteGp7Xo+XGiAqzY7dmWwz/Zfa5SQspLssrZhR2Yq1DowL3bISs0a9Pt7VraiqJYdy8eJZbz4OeIguPY7Z6aS6//57BteBeeG2aDc+eZFilcUTiAnuPro+qpknpgKotmhE0i9o0g/frI8cG15LlaXd5OnYdsWSSu2tCSYk99sFDFdD8IDLFwBwJzdw3dXMvTzfMbcNedeom/+4pJZegK/FW0DIFkkcixlFFVwWmrGqtKHIl0OdsJw8bCYzspWvep7LeDpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(8676002)(66476007)(66556008)(66946007)(5660300002)(316002)(7416002)(2906002)(8936002)(38100700002)(38350700002)(921005)(26005)(36756003)(6506007)(6512007)(86362001)(478600001)(9686003)(41300700001)(83380400001)(6486002)(52116002)(2616005)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GqhRM81pkTkVPJiTOqkbtVJyak4M5oZwBs6suYsZQqQ5XKMNB+/H5LfL5gcy?=
 =?us-ascii?Q?ajFH+dLynNw4izuhbtQb5k/qV7Nc4BD5k8ekLc5WIgge1rRICrHyDjvAFmmo?=
 =?us-ascii?Q?W17BY0uMCt/N+YeIjglcW6acSihdBNKYeP6XRyI2rwgWUX4IYbBR8r24dv/s?=
 =?us-ascii?Q?taRF5HVPDPrIgWx34Q7OsOf9zh/eVOhupL7DR3k/losicnOd2gKwTKETALn6?=
 =?us-ascii?Q?2kYAhA9JjNKNCVdCDWlQ2GBvfmV30M/5SvuNkJjLAsy9Y6uqCGhd/Mz+ALGR?=
 =?us-ascii?Q?qXWR5G5KjNnXUcn3S0nrWnlW4O8fhQX0HyGHmKyRCVW7vQr6mcNX5aXCf9yB?=
 =?us-ascii?Q?xy0w3GmtcEBQsEthk72V+FHvlqnAjXa+XHHsDPtDEAo6L/G2rED8ny1sADsT?=
 =?us-ascii?Q?MforeTGiB34Bp1eH7RLij2aTmdhtprv8yOmzTfoOR+g6e2Je67ngI0yPVPRq?=
 =?us-ascii?Q?wseuWEyX8+BkoS5pGts3uupnFlTjGbUiWlD1Zee0uj20iswzcOwAWDC8nH4P?=
 =?us-ascii?Q?Q2TUwOrf6T0PXxA5IOYToEq5YSweTt6691XtOF0RAdVQ7jq5NpdcrHij66ru?=
 =?us-ascii?Q?3dp7eKqbVnht2RgE3kja34x6VC64FdhKkWgA9U+91/8eFH28Io9QRdxF0aWx?=
 =?us-ascii?Q?VY1HtKqsbN4/bYpyfZsJZA4zh/R8oTUqq6/72crNlquHO9huV0hPNHRPHrPY?=
 =?us-ascii?Q?MJ+iCyq6JOcFWNvAaz2/6UBU5aQCAoDTYGgv04iMEySuP0QPjb2jZum7N8pW?=
 =?us-ascii?Q?y8VWD4TNTrv7MTH6px9J9gPyOPvGgpMFqoZXXi2apIj8U/x3Al3Q4l4UelN/?=
 =?us-ascii?Q?MyGqMEO3XgH4zfUbrpDffTAxdzVyGsS9Pzgm6fCL5mfnVOJYLojwH5SX/2/t?=
 =?us-ascii?Q?SHzoNN8TwYGAtuI9xA3anT4cJHxSyMEJaQU2OeBTK9NSMFFdUlZCxCVFkXuy?=
 =?us-ascii?Q?Az0DierDtSEVdrG6OS/nsH/nPlR78ss1EN58L9pvZk/qpOgxyUX04KXAQ3VL?=
 =?us-ascii?Q?jxq39ToRWEEkh+mVGmjvkhNSBg8v3y/Z95kgpZXu3x2ZHHksI/8Unm+/eiym?=
 =?us-ascii?Q?ExCbljh9nvobMNV2KGi8t1euPxru6LDkR7F4yCJeWNpIqI8bNw7U9PIXEXaU?=
 =?us-ascii?Q?NC7q/JplMlwfvxxpF6mG0CFOHz9sNrt8VH8C0aMF6YIsDoDUwPMmHVNfJ9Wz?=
 =?us-ascii?Q?cp5IIi2eHIxmYJiNyIEy99pdYCKjpP3t7hAOW/73XmWg9HtYxfg5GFt2/cAl?=
 =?us-ascii?Q?dGFaxduAauhH7Q3AafFH2zrllE6v729ozGtrOIODTzauP7xa3+XN5YcB/7il?=
 =?us-ascii?Q?2zWly3GtHf4iEG9KtDkBhPluR8qUhxoeAuqAQB8xyRHBKFaH70Pq7mIH/zL2?=
 =?us-ascii?Q?UFC7H1GUNsMkcql5kGjSgKm0SgmFkBAc0zpax1Sbub9/+iDl1Zz+ql4I7DWk?=
 =?us-ascii?Q?3NfLxdov2eSUZ0W5wBh/GPNY3PwP9/bycQ+N7iMYA06Nx9ubhTrWwR3x1ptF?=
 =?us-ascii?Q?96UYvG0gP9u6l+YNHRjGISC4a/iQHZn3m/GplZVHbbc8pHosiAIdAz+OHELL?=
 =?us-ascii?Q?IieRM/3IwNbG21rBobtPo1ntM3H28XF1wDYSb4J8?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d6c6c7a-fe2f-4f6f-3c33-08da7c2fbb8f
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2022 06:56:08.1191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PJYoqt96hRP3JHdbJg4s4unb/Dewa/hgnLxbPbrZd0Drvu79+r4T9q+72de73/N6TGez1Thbzw+Mj5DoW4n63g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8616
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>

The hibernation mode of Atheros AR803x PHYs is default enabled.
When the cable is unplugged, the PHY will enter hibernation
mode and the PHY clock does down. For some MACs, it needs the
clock to support it's logic. For instance, stmmac needs the PHY
inputs clock is present for software reset completion. Therefore,
It is reasonable to add a DT property to disable hibernation mode.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
 Documentation/devicetree/bindings/net/qca,ar803x.yaml | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/qca,ar803x.yaml b/Documentation/devicetree/bindings/net/qca,ar803x.yaml
index b3d4013b7ca6..d08431d79b83 100644
--- a/Documentation/devicetree/bindings/net/qca,ar803x.yaml
+++ b/Documentation/devicetree/bindings/net/qca,ar803x.yaml
@@ -40,6 +40,12 @@ properties:
       Only supported on the AR8031.
     type: boolean
 
+  qca,disable-hibernation:
+    description: |
+    If set, the PHY will not enter hibernation mode when the cable is
+    unplugged.
+    type: boolean
+
   qca,smarteee-tw-us-100m:
     description: EEE Tw parameter for 100M links.
     $ref: /schemas/types.yaml#/definitions/uint32
-- 
2.25.1

