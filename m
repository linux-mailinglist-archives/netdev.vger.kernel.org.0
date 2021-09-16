Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB06640D115
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 03:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbhIPBLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 21:11:42 -0400
Received: from mail-dm6nam10on2107.outbound.protection.outlook.com ([40.107.93.107]:50016
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232762AbhIPBLl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 21:11:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K8KlHuPq4EaRwYQY2B1DG8lKkEPddX5tTFzje2b5jh3sJc3xxx36ybYbBxsxT+tpML9dYm3wpfRdAVqZMy1yfGJ9C+r2Ac9G7iM9LEngHMhRzG792zeHHQXWI4oGdHp09M7pCbVvrUpn6W7He4McGy/oQLkPaPzGDDFv0ZDtajmvjhLpmKB/xmZY7s7OL72OArOaGWJro+2PHSGOqHpQ7/w/XSJzrWmges7zXbBgPtqPUTIKI07MR1RqQESw6Ym/HryBp8dHhZxeK0RoUrDR2sBAZPglzbRSXIv2AIjpBs8+sQbpUVROqzEXdnpzlGM7bIKOOFD4xr8mx/FRqnL6Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ZRGn4isaMORgxxrgUdz64X4smL2R4lI/zIMHL9pgM2g=;
 b=MLxjLWH70XlbQqV6IJG4n9vck2VxWMnxEnsaGPoHLHIuG378qT4nD7fiftZkn+Mr20sRgjaf7QYrfIUKmb36/4gZEFWkMB9CRcZx27b9q2EmRmW4CJC5Q45Crf7nMoy/0LQcsyJ9m0jBfeo8xioOrWUYPO3MOl9RoDRvg1SnT7D7sROfZN8A2O3a0os+uZS1ALdsKy/Cwvh9PlEEbpJIuWru9k4/+rbIiiSSPpGMTvsf0+bc1JszvWppYOKdi2wuOqdvHOwLnzWhEOTe9hNZ1UZ0OuV8FYSF/d+HHjRHLaaFU4akV2ebHPhD6h2hc7Rk0UZ3RMvwoUAPMXk4BgU0/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZRGn4isaMORgxxrgUdz64X4smL2R4lI/zIMHL9pgM2g=;
 b=zvxNQnHVjtEw8+2vg2qTwl1H9yT+Q5Y6x7QvVMuY7ae6CeuEn3drHfGUiyxpiqwBRl3pCC4u1sbWq6X475Kti1L/EoCbltzvNcZdGllzbQeZIobfBZVJApz2Rgys3ZUj6hcmQOnzFQAljUYJAdTenjtNwK8wzCVfhnW0pOIdul4=
Authentication-Results: in-advantage.com; dkim=none (message not signed)
 header.d=none;in-advantage.com; dmarc=none action=none
 header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1598.namprd10.prod.outlook.com
 (2603:10b6:300:2a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 16 Sep
 2021 01:10:19 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::bc3f:264a:a18d:cf93]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::bc3f:264a:a18d:cf93%7]) with mapi id 15.20.4500.020; Thu, 16 Sep 2021
 01:10:19 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     colin.foster@in-advantage.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 net] net: mscc: ocelot: remove buggy and useless write to ANA_PFC_PFC_CFG
Date:   Wed, 15 Sep 2021 18:09:37 -0700
Message-Id: <20210916010938.517698-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0300.namprd03.prod.outlook.com
 (2603:10b6:303:b5::35) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MW4PR03CA0300.namprd03.prod.outlook.com (2603:10b6:303:b5::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 01:10:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b4cf925-daf5-4323-4818-08d978aebfd7
X-MS-TrafficTypeDiagnostic: MWHPR10MB1598:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1598A705C579059B76EE24CEA4DC9@MWHPR10MB1598.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ldAyOo+EEunyo+RznREjbADXgPeWs6AsRHHDb8PUw7hMcNFZZs8EaQtPLHAinTL2maRXtTFA7xBfR5xD/PBhpdsNcmH8EjlBPEfoaJ0WiAWS3zmjAo8h0jqavwfLtJEASMEbmu/U1kd9kwSRe+ToHnVCn6EJZf7xlb+/609dezeAEDG7HqpddZBgANeUwltByFK8EC8nwdjrVnnFq9oGcECWNqw47IpdOmuOd70KX76Oz2DtEISAtQyKmkLLSKrtZSNbWJ9/2wp7JaRKOpPkjLq4sraUkG/TTPUrTrSuBND9kTd/hhT0wEo1cswCm/bx+DydD9+yB7JhI+n1jDhAR5KHIbYhgRxloKz7SjnYRtoMYUljxw++rpMxZ3lj9UcHSqmZCvLRlYOdn65ztwBXEYPaA8A2SLqCmgR9YkNyLrM8wsTASwRU/xJjURcIs58YKUajXNqlKsPXMrZnrcM7RgaxYVR2iJLIJCxMWCdDjnNfCJqPIyiSIv4rfeCj3kgTaaaVsDHEb/hnufTkwYNqasc16rwQvYI5t54eMombvxK2aOmC0IKYCdyd5JWmzAcATyca169nm9OgtMGqnTeQidldCA7INLeYwFfZn/CxLgcPbT2Fexm5jaAyvxMxAGU6rKFUAgHXVVwIgZfHlxI5xHlMFgV7cmPc6oxq5S5uRpYkdt7ZGPCcMUOt5LgjAMBX0iZLKvdEdBD8xRRCuuIGjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(366004)(396003)(39830400003)(2906002)(83380400001)(36756003)(956004)(1076003)(2616005)(66476007)(6512007)(110136005)(66556008)(6486002)(4326008)(8936002)(86362001)(66946007)(316002)(478600001)(26005)(186003)(44832011)(5660300002)(6666004)(6506007)(8676002)(38100700002)(38350700002)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cxX4uMECOx75Bueu1Gw9x+dL1Jp8/uARtAJB/zmUUMyFXoeLKS2LmiHwIXDs?=
 =?us-ascii?Q?5CFO29MJyYWGEog23PLqdUUWNre1UdGxBs4rM+HaQ4Odurd5HLv2XNquLzoN?=
 =?us-ascii?Q?9juKxe+qu3kJfdyrHWt1YP+dbIynxqOkqjizsxf6mh0X1j7ZxrF4OITsC4DK?=
 =?us-ascii?Q?wpgAKPBieNRSJF7/gtgQWFIkWjcFYXPon93fkM5HJ/ZrqYPjKN03qYULRndu?=
 =?us-ascii?Q?5jYBg6JGcC/adxmfuaPCJZcFKPDrR3v4MTvyJpWEOyldnb6h3TdYdP3Qq2cR?=
 =?us-ascii?Q?DNGWVkdIPxjmgVs1h4dgAEM8mxHEGmfhwTML4PRHIrCPQwrm0vaF9BVuEewg?=
 =?us-ascii?Q?GxpTl0CM5prYeD2R3fM1/PvhOH8919xqOrwMLK4vVjTgsTwizlqWnvxgtFwT?=
 =?us-ascii?Q?Xn3dntOLpx+2LY1I2+B0lSLbHl+FCI3vPx7sSgkJTggfS/4mCCWP0/KKZ0gx?=
 =?us-ascii?Q?q+bhbnAQaEry4q1obOHr+1LmWcdrUfIb1m2WbNjJdQdUNwSUY7TijyewuYb6?=
 =?us-ascii?Q?GHc1epGpWaKlgeAsB/hsPoFwZWiSMZHywozgoW8AHXbtGxizMQPt81cagqi9?=
 =?us-ascii?Q?kwLOo4u1QdpRjwspS6hSzTYYThb7HXEmYgzAryWYhlgSoztkdnMoYYQ1tldH?=
 =?us-ascii?Q?zglVcl29tZO2afHi0r2nBGL1WdI+fpqfCxRxPUamXBKenK3Z4vUT3ARpXk33?=
 =?us-ascii?Q?RlWDQD7IzHRshE5SG20P7EU3u4rjAs+eHABJMY6SSZ6/d30ZhEtHBH5sFZ/L?=
 =?us-ascii?Q?Zet+gyKu36otJaOdEF3LwRgHIixiWIuLWThYiSfwEeK/7VBakD8q9ywvj4xI?=
 =?us-ascii?Q?CmNjShSM6FKnMm37raFVO7CXDPH8HRqZ9dhr6frm0DBpNxAKLKVvElk1db+8?=
 =?us-ascii?Q?j/zZO/NMkw5yvCwE1EeXRYS+aAa7gUdqQ6JeZXJHQn/52ndrIJcrE7Usp8me?=
 =?us-ascii?Q?PAaPHaCrI1QKUyR0rofznSRWFDivusPMbWfSVBQk++TQvhWORoS3i8wg+aIr?=
 =?us-ascii?Q?/rPlSJG3mYrrB9zYHFHDxrW8k0O1I2ENYfbF/LCXxoyeekSBBrIMTqq2U4H1?=
 =?us-ascii?Q?/q4TKkGxVhs/FrJIImtPHlDAMRqm9ig4kOkKYd3+mIT1ZFol+UltVyUQ+bbJ?=
 =?us-ascii?Q?MsPUZnmMpxiBvFfRjYupgYkerJkTflLyzfKhXV6jyi8Brh4mRZuE5lZHFAxy?=
 =?us-ascii?Q?/+VBzfqlAMFPAAWx7du5PKO47Li26o4BshebISSCqhyJd5jiRyDn3230vOEU?=
 =?us-ascii?Q?rJJpnDRUt7rhCRhZrupSA9g6wUQpMwYeShylyaJeCcImodgwlc1QdE0ULGnQ?=
 =?us-ascii?Q?7Pa+J74TAqo8zquWbN5FhbtN?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b4cf925-daf5-4323-4818-08d978aebfd7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 01:10:19.0853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lFGvRMjuRejP8rPPUct1janUqJk47rf9qx6bHGQg9v3pIHJvMwwR6SSWaa4WprvpWKFgEcmZPwrnMDxWxiZDs7SrihALL6VP7t1wuXuPKA4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1598
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A useless write to ANA_PFC_PFC_CFG was left in while refactoring ocelot to
phylink. Since priority flow control is disabled, writing the speed has no
effect.

Further, it was using ethtool.h SPEED_ instead of OCELOT_SPEED_ macros,
which are incorrectly offset for GENMASK.

Lastly, for priority flow control to properly function, some scenarios
would rely on the rate adaptation from the PCS while the MAC speed would
be fixed. So it isn't used, and even if it was, neither "speed" nor
"mac_speed" are necessarily the correct values to be used.

Fixes: e6e12df625f2 ("net: mscc: ocelot: convert to phylink")
Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index c581b955efb3..08be0440af28 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -569,10 +569,6 @@ void ocelot_phylink_mac_link_up(struct ocelot *ocelot, int port,
 	ocelot_port_writel(ocelot_port, DEV_CLOCK_CFG_LINK_SPEED(speed),
 			   DEV_CLOCK_CFG);
 
-	/* No PFC */
-	ocelot_write_gix(ocelot, ANA_PFC_PFC_CFG_FC_LINK_SPEED(speed),
-			 ANA_PFC_PFC_CFG, port);
-
 	/* Core: Enable port for frame transfer */
 	ocelot_fields_write(ocelot, port,
 			    QSYS_SWITCH_PORT_MODE_PORT_ENA, 1);
-- 
2.25.1

