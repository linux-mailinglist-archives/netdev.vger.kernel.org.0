Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFA644BB2CC
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 08:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbiBRHDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 02:03:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbiBRHDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 02:03:03 -0500
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2129.outbound.protection.outlook.com [40.107.215.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98ECD17AB3;
        Thu, 17 Feb 2022 23:02:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SOXKkHAAVray7Nt0qJCCdFj4b1oPpVZR+HS4imuxP8QJj97HltgW4vFJjBe4+CGa8FF/xdnQR8uBZbpkt9cEUtI1qJyIaTE1TYUiAGsSZ4Bwhy//GEDufMrhmJKvlYYVqG8PjS5UU16GBH9Z9Ym2hQGvLlwYSUdf8Grq9n21L0+IvFOwKgzEDfcErIDgRkEvI+Nd/He0uCDvpVtR2nENF4H6qML3sy7BoZcFNQY/POi6WLrK7QnJPcpYphR51IzpKminutZz2XtSRMzvtEHDDH6kr0IQblm1v2GRIpCDT2z4pxN6d6B6Ro4Hv6eNyy5hO2gKsZPgpAlAYAjCL+NlfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ghv73p1V9L+WcDGzE/iZmVuCzDu2pr4vF6QkCbkV2pU=;
 b=f9GDGAhG5RurUPeODabeMPkl2HzeAxaaktd3npHQoxfSavH2CTw86icjTTEj06LdrtvHyMhfYSLZRRWFxrxl+HSdHu/BYwUXzOiN7ymxNY9IhdMxSlKJ5Ta4xRyp1rOKa1kZLCC9lqKQYH6KKyTwoRrFrzkdDq2Et14+ClAzgkxXDvybXlWZNEqcDYKpFo4eJWmyw4p8+RBwPDOJFjefqvXG3GYUaJdn8DuqSJRWXmke2adzLmYARldtWn5sDUodxifWAEC1CLHjrHzrfOUadURVACc9OPBB/N9y68yOI2bH3qCoPo6/VwjsfOqeCv+PdhhGE6MmQ+K5KrSrjIVdxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ghv73p1V9L+WcDGzE/iZmVuCzDu2pr4vF6QkCbkV2pU=;
 b=lyeJcdifa5zVbYavxjt1VjDCKLGE3Jn7yrCEyEskGfLBA/UNddlCzydrgSg9GCb2H5/L0WftIzD4PlFH8iPCo8aS/sk5atI0+6tsxchmI4ndFOrDPyHnri9FptIGxLw62/lqR6ydnRtt/Ex51r/10sSuLc12q28NA3046NeVemY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com (2603:1096:400:26::14)
 by SG2PR06MB3321.apcprd06.prod.outlook.com (2603:1096:4:93::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Fri, 18 Feb
 2022 07:02:41 +0000
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::30ce:609e:c8e8:8a06]) by TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::30ce:609e:c8e8:8a06%4]) with mapi id 15.20.4995.016; Fri, 18 Feb 2022
 07:02:41 +0000
From:   Yihao Han <hanyihao@vivo.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kernel@vivo.com, Yihao Han <hanyihao@vivo.com>
Subject: [PATCH] mac80211: replace DEFINE_SIMPLE_ATTRIBUTE with DEFINE_DEBUGFS_ATTRIBUTE
Date:   Thu, 17 Feb 2022 23:02:28 -0800
Message-Id: <20220218070228.6210-1-hanyihao@vivo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: HK2PR06CA0015.apcprd06.prod.outlook.com
 (2603:1096:202:2e::27) To TYZPR06MB4173.apcprd06.prod.outlook.com
 (2603:1096:400:26::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67a0b150-cec0-49d3-42dd-08d9f2aca7d7
X-MS-TrafficTypeDiagnostic: SG2PR06MB3321:EE_
X-Microsoft-Antispam-PRVS: <SG2PR06MB33217937D26B7D2D16E93BEAA2379@SG2PR06MB3321.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:813;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zXyaDFEIxIms6vm/WBr35fb1r44yV9DrBImVFe73VQCQDz5yW/P5bY4hpOcHSvkSeha0aYz0V6QyLagm+EtvlrE5ZCqGffLE7vpFVEcVYzlG3o0Sk12yM8vSCr77acN9vzvlp6xClYODiDeSDiKRlo60tv6fvpBCEVYEwJQmZGVratvHI8j8xOpRsz+YZD/qMmeU12QeC3/+8/n45z1x60tZdCuJdscFf7jiv8keY+wXgS6JSXCrql/eUYQZJuY5lDqdt28A+vRcmzxaGNyF7ueygHtG8VK88bqINZwGWuLcdUgVUVCOF+BH2YGw/oWk87v3RBRHmrbKDwYpflb5hD2pdXvHfm7F9Gvq+ClylrbMGSVxjQVMqqPYDKgdAmduiQU64aeASFYmge+hXvu8px4fr6UeihVYoUUYCbC0r/TnAwnNdF8U0pDeoZQkXVj1nB3gfP8qFvdBZTSOKkamGtWUp6gfQaWdW6kDN/D01SkFMA/Zph7qdB3amtoIQVn3IWbzxZ8oLxjINFQ03d3RpR+li/t+7HPv+tCIVps9j/iT1tcbnb4WJv2OcdQZnBUxHczRXbPfD8q4UVNA3Yyetsn2UXd672R405bSlV+/JhQvvzZAca0FKrZwx8nXp0dv1sF0JdZPElGM4UadgtY0b9osvjo2gzSBVp/PRkmHDivTPpVZSDxM0ZQ47KOELAzZvPTIOqhB7J/JssrekEbSsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB4173.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52116002)(4744005)(38350700002)(508600001)(6506007)(6666004)(6512007)(316002)(8936002)(110136005)(83380400001)(5660300002)(36756003)(1076003)(26005)(186003)(6486002)(38100700002)(8676002)(86362001)(2616005)(107886003)(2906002)(66946007)(66476007)(4326008)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jmymBMmg/tmLnsrhEiRwhpNhWEa8o17sNYFlQdMnV7/ZG/9CBpBApem8t6Pe?=
 =?us-ascii?Q?KXEp8nbG2pQ2zUkUSxUQSBRonZL0L8sSLMm7Da6zIFdRF+i782KM4XzTyOO5?=
 =?us-ascii?Q?NeiqiaOsFOhsIjgnNjFlfCTn49edsdip1MXK0FQU8hwvtdI74LtLO/vfoY4Q?=
 =?us-ascii?Q?B+ccg26L2zae2c/+bFhWflca8kBflVLNaBCeBPaIm+XdL22/l6DZ6foIkNXd?=
 =?us-ascii?Q?euGXKOtxcSZwjpUCdzb80SBClTV0VIXtXxB914ZbW/ooEuYv4YSFHHeplQPz?=
 =?us-ascii?Q?/JU7w6U0okvUHeyE72Kb/TwS9q472pwlKSesqxOgj2KpNg+13To/vy6fOgKU?=
 =?us-ascii?Q?jXj4Y7Xmp/KQLHu1sDmB8yC0c7BIwP/U+4WBWwFIWDVeGyKtEzy4o1Jhddm7?=
 =?us-ascii?Q?/cyBlfcYxv+7JzapquBvwZmRwp4Olxitvm1akGoTMTOojfhiaeXO0dMKTi3y?=
 =?us-ascii?Q?8fdp3ha0JexzIWk4uAN0DvmBlbn117Lul3rN5nPKvOP74ejQFAoW/vu2qtq7?=
 =?us-ascii?Q?BcknKBjSAjeeHBq++ZpLJ1CDEL88UcAHj8hj3hWBOxr65TnzEd7f1RALlZEg?=
 =?us-ascii?Q?THX3sP2hxMGpkfV4+CxQbIRx0KOObLUUC9eOyGS3PuCQTXbQ79IkeuZRMD0n?=
 =?us-ascii?Q?+QsvmFszl97UEUMtxk0WRfI15eFG2IkpesJK59NZBwji4Xsd8qhJqQr9guRg?=
 =?us-ascii?Q?0sPrrSm/wgshyTA4AXO/anghihfgUdheqVAHQQsFPswbc8C9kQyNG7GsiTeW?=
 =?us-ascii?Q?Wi5PpFGTOeHmxXGh9L/qjUV6mQZx9s8cNY0ZNAdj1cNdWNq8QCUH4g/bxjy/?=
 =?us-ascii?Q?jLp5iD2tNRA/aIhnfvoIHOI8u4PCqIiayMXTKTWxdceqmGykhSNy03s17XrH?=
 =?us-ascii?Q?w9HHMx78P34aRW28qoZ69Tn+xjkLpFijdOVO4SaXDUyb2VGotynafq9muL47?=
 =?us-ascii?Q?OhaDGPojp1bJHeU4W5wkp1gzrITn38TipX6/6duFf4wTcVuqaE5S9grhv/vV?=
 =?us-ascii?Q?X4boDaj1VJF/58ATNxsbbJKmwFEA0P5hpedNa51UQGNnR0pkQG749eVBUbF1?=
 =?us-ascii?Q?mVaDjbrY83e9OD6Jqex2YDzMc7WtpqWIJyCjB+DbbkVVE3nk1hbU0Dl16SeF?=
 =?us-ascii?Q?JMASYJA9amFxpRlwRptCs6r1bPBt0fBQg81dB00y9AJ5ST+5OnhzZztnrHiM?=
 =?us-ascii?Q?P0klzF3eQm6aaTrxT2Mpyxw9FlW64ZBEA1D97xUazQJiNzsPiHDqb/2XaFpv?=
 =?us-ascii?Q?TDaoDK368eCpjy/UW/ejvvcXrSy3QYdNMPdDKb5IBUtERpTc0JsQ98yL16Gx?=
 =?us-ascii?Q?9hXLFEl6yILCGMF+8woCTYm953+/IaRX38mGFsZ1IB6WLvrUjljNInuX8hUR?=
 =?us-ascii?Q?KsenHP8ze7e7ydWi+J3V7WbNufpAE54ip7Lt9WcgVX13FkAHyfQm/KvT4EKZ?=
 =?us-ascii?Q?ewPBXiy+Qnqjn5MWh3O412is9f85+E5jLZVon98XwbV0Ky/VIS9r3Yuy45ua?=
 =?us-ascii?Q?5cctfM6cPR4uYOYwTIzljkf40B8/ybssTXEk/3WJ5PV+RvONkTjww/fcXdaL?=
 =?us-ascii?Q?FHMtZnaa/7zRVxFClsIcm8414nr2T0nvgCP9FQTifnIArGyV9PD2fmubGokE?=
 =?us-ascii?Q?05aE+wbvs6L0QMQd2+iZi3I=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67a0b150-cec0-49d3-42dd-08d9f2aca7d7
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB4173.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 07:02:41.5709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hkE4q96/O8bqQAc7aH9Drppdqq0gJmLepAwie34yBGnHLPVChFrDnBXRkpX5YHWbH1LGpHe2t8vgtZaCvOv7jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR06MB3321
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:
./drivers/net/wireless/mac80211_hwsim.c:1040:0-23: WARNING:
hwsim_fops_rx_rssi should be defined with
DEFINE_DEBUGFS_ATTRIBUTE

Signed-off-by: Yihao Han <hanyihao@vivo.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 18a578495c37..a4ec165d4793 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1037,7 +1037,7 @@ static int hwsim_fops_rx_rssi_write(void *dat, u64 val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(hwsim_fops_rx_rssi,
+DEFINE_DEBUGFS_ATTRIBUTE(hwsim_fops_rx_rssi,
 			hwsim_fops_rx_rssi_read, hwsim_fops_rx_rssi_write,
 			"%lld\n");
 
-- 
2.17.1

