Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE3C51721F
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 17:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385643AbiEBPFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 11:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239046AbiEBPFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 11:05:19 -0400
Received: from GBR01-CWL-obe.outbound.protection.outlook.com (mail-cwlgbr01on2120.outbound.protection.outlook.com [40.107.11.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B226A101FD;
        Mon,  2 May 2022 08:01:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZqjRcOm+my4Mi9gVTasp201xn2MXoiaBANPz9jhPk+HAJyXiekUffg2PK6WR4XNnlplQHphEg74OXUHIp5IyrwkSCctujexmuqAT7s0xuIqivQJb3pVr8E/K0TjqWHaUhyEHK7/rgLipPQtDBNMSWmXZHhjoQ2busdICPjVxO55H1rD3YCG4jaPTqPKC5uxZsfbU0GQK/y2by/LMStsJIW0RA854Jrokf7Ib8TLyKR5wJWnCIxI6Hmw6lKLLx+c68tltbYBoDONd/iLbpN/gefYvZGnJRFOrPStkQ1rakslM6D8uGNA9/oVKwfSDKT0h+GfYDpsywRTXgOuj+qdUKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8vgqOyajbVpGglP4iu3Z1nVdqlJO2JVzbyD4vf2yKD0=;
 b=UoYGq+Hb+Zn6nEQABX4lncgGMTCJ7xXipeK4P86hFWEaJQ/1Wk7se95dViMiPM1e5TTxcTe/JBe64rYJNrJMMwhqjDh5Y0u0FFPWh2DjB66rMkphNW2dw3crHcA23t2iUhSjG+Cyvm1iwGaUvFr8uChLbg3F0jK3jZdjQItnYKUxbQ+MUb/uXh42hRYAHxGqjaAUCAw10rUUzZVPfyaCqSNjO2OYLGdsAAlLqEktDtjjJGRgCvNJ+mcP1hb909i0U/7Gm6qzl2A/avWJBm+BP9/Ll/mAPfpp/mQrplra4evuyPgm9XtYqq3xv0y3OO1ESuxI6M/7maNYPuBM0NdRgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=purelifi.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8vgqOyajbVpGglP4iu3Z1nVdqlJO2JVzbyD4vf2yKD0=;
 b=be8gImmqWWXCG/4z+uZgOdunLGZn8WmRXoWeGnbShB627y9tGsWepcu4OyO7XyLaD015e5Aiiiu8VXQHvDV0kWtArDnF0lTNQ7DqQcypYrdO96jkA4P7L6h3JJ8Bi8NtNfQ24C5v+U6BXoKlneyOTDhJTUydpdsnqJQX9zq2uA0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=purelifi.com;
Received: from CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:bb::9) by
 LO4P265MB5915.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:29a::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.28; Mon, 2 May 2022 15:01:48 +0000
Received: from CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 ([fe80::9d97:7966:481:5c10]) by CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 ([fe80::9d97:7966:481:5c10%9]) with mapi id 15.20.5206.024; Mon, 2 May 2022
 15:01:48 +0000
From:   Srinivasan Raju <srini.raju@purelifi.com>
Cc:     Srinivasan Raju <srini.raju@purelifi.com>,
        kernel test robot <lkp@intel.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org (open list:PURELIFI PLFXLC DRIVER),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] [v4] plfxlc: fix le16_to_cpu warning for beacon_interval
Date:   Mon,  2 May 2022 16:01:32 +0100
Message-Id: <20220502150133.6052-1-srini.raju@purelifi.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0003.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::15) To CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:400:bb::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef486de9-23bd-459f-9ebb-08da2c4caea0
X-MS-TrafficTypeDiagnostic: LO4P265MB5915:EE_
X-Microsoft-Antispam-PRVS: <LO4P265MB59158E52AD950BB8A6BF06DAE0C19@LO4P265MB5915.GBRP265.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9RrB6sRWijkOUe+NmB+QaHCHvTA3vLWOpp3zfpUUmLGzuq/KDahHKJZXnZHZPAV0AcVj540EHsfoNz++aaTUCyPjP4o9ONWUMq1eonf25KUL/LthylTnmVclQK3hv77aSg7QEO90t3XoyGdtUVD67zHPTM1mKnIChR+Fx+cMuFbMplDHpQ2DXeRyOqE/hs46qZs9bIeD6FFOve2rBvUctm9I7UF0kLRekhkvkR2s1dbXYjS2+CDzFUXyvuMsaC4lgK7IqotRhtEvCBQ3v+T/3LXu4WcGVRleOwN7bGLu0oFAN9YIxuFy3RBtIR/ktVwo0kcIwmLYYD75yJ8pglFBjw1UrpuW9FiqOfLMrCQ2SGohbq3qZwS2vYor0g3Hxtk7I5MimII1X7z8EK/Ro6/4libhRCY9xdHOrlvgwN2E06w0g2u6mBYEtzay1/qvnFjKHvNc6y2nRhiq70NbxJprqfVmPLqNyfgXjGCsTs8vvIKtRHd3DOvwK4nLrdE0CwfeAiasxaBcGby1seIAYozT3L/dGLiBUIf3IQXstFsU/Pdd8AwFMqTWRyn5cQRCItFxkAi8FZyK3CBzMynh7gnzJU1wpD9wtfGXnBPmxYRrLvsMmKdIqpdBb51L17TxvKcB3BEuW/wvwvsSiUwD7TO173BeHEWSvq8fZIlSiWWAwDz+cQBGh5Q5zTT/MLLIaxKhLSK1lyyleDyhOWwbeXGtSqvmSXadN4vhyv/kiEUrrtM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(8676002)(66476007)(66556008)(109986005)(4326008)(66946007)(54906003)(2616005)(316002)(186003)(1076003)(2906002)(26005)(86362001)(6512007)(6506007)(36756003)(6666004)(5660300002)(52116002)(38100700002)(508600001)(6486002)(8936002)(38350700002)(266003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qi1ZhFTisV2YXDPn8nixs1dltxHgavA2oRhASQGzNv+FTMVr7ca/GpdeRDwM?=
 =?us-ascii?Q?xvv3qz1X6G7hbx1nYj79T9seiw6wkiZh6tlHMJbnqUUSlM2IxtLwMPS+VyKj?=
 =?us-ascii?Q?dAv12Xq5hHw5MfmGWbl2TZmK76vo4exEA+Q8G8ny/g4zuN+30KnpI/5iNE7/?=
 =?us-ascii?Q?Ucjy77n55GtJ7HVk3d373Hi3/P6RqsoxWpEmQEZZsQAbIWBSJCpb/eUBeXxu?=
 =?us-ascii?Q?r3LVVex64mmaRdbumBTo21J+Qh8tnLCROE6sbC3/Q3Tu38VP6rvo78kjavVw?=
 =?us-ascii?Q?l9gYTNzo2CBd+g5z4NVssBTyUw9VRvUgyaSRKHQtZKRidSW4P7zk7LNv0VTj?=
 =?us-ascii?Q?8x8WqEiGitzp7awT8Ft5Euks9F/KMucjbWNfAqsAaVxJoAg+4FxT56ucJ+BT?=
 =?us-ascii?Q?MJ6PT4VruPD8mhl8kGhv7l5+2T3ayorxGs/LiB2RP7C/aLi0wCdnHFqVblTo?=
 =?us-ascii?Q?tOlUp3EsiwQC8zVfYKpCTz47xrcSlGOOjAMfiEzanPaYGfpnWxg9y1p+QBlU?=
 =?us-ascii?Q?Aa4041cvVv8xZOY9S5K/6AxzBCElnfqCOlt8LAt66WsKfE7CqeyJaB0AppIJ?=
 =?us-ascii?Q?cIOBVIkZ6Rqw16DHVF7nANoYLT2GPYpfzAspSGpOmDKq8HBidvPrSiv/jXER?=
 =?us-ascii?Q?EBr1DVQAE/TyF2Rm1HlVyzxBCl0zs75Kk5nkwfcEDjmyI1Gozcu9ocUdNQm2?=
 =?us-ascii?Q?abcUr3syCFTWkwasu/JV5lofj3gZA3C5Vo2faWFSY3KQfS0TaG7MfgCddZkS?=
 =?us-ascii?Q?G+QgE97/H7v2WHlHHBv+LMrGTVSa0sdu6WL3VZpbh93upZ/nwnpIPi5pzupM?=
 =?us-ascii?Q?6J4NeF0RsNAOTNSPhfoF4d9csMWOIgrPlc4UoWqCrooPwZlkjhdGQjyIhv+5?=
 =?us-ascii?Q?1y5iFQFz8IhZp3phi+qyCzyoFxnbXfedXf1QEbB9C2VC5WKndWMbyozEs077?=
 =?us-ascii?Q?/n3ROEiBAy3qQIZmiNl5Nr3Dj31fCzSySoJtDNg1YZpt7a/oWcB7uXnDq1rG?=
 =?us-ascii?Q?P55K5/tamS09OFOp0e8zcIryIOLTcsvTVxQzxK3D4zI0xjZocjrSWrh4TZtu?=
 =?us-ascii?Q?5NFJAPmXnRLKrCdezFqbBukIFi9W7hE56nN8LLqqxm1lImnBFn/VpxnublFZ?=
 =?us-ascii?Q?i6mBQY38V8ibeveHnnZGCQB0d+qrbr0XGt0eNWpmh9QbCb7OLPRy4RH5W4fE?=
 =?us-ascii?Q?RZGX9RDTJAz5Hz+nBlC/IQVMc3pLiDZKScBJKLeu9UooQC6UX+uHwczJqewg?=
 =?us-ascii?Q?AgLbPazKqZJPbrFcZcXFk+FM2Jol+5hPCAYc78QrCLC2JLzJWI2/bPyYSBG3?=
 =?us-ascii?Q?Eiyl6AD3ikxT6WfyTDcluK/S19WPY/GHAKVgdIDtvzsUGis7s82O+mYPIkGl?=
 =?us-ascii?Q?27Nj31C3FtgdlsA30WNIXJ56ZXOGU3sTCBXm4cDNDFWkGN1q+Gv7W2aPN4m6?=
 =?us-ascii?Q?JYYExG7psLdp41Q1a6yk4nzPKnAo5YfVQjCPREXzM+sq0pd5ktO/qhp8SNkY?=
 =?us-ascii?Q?Nz7otyiLuKR2/2f802EWiHTrMfxCpNRpk0gQe6FdJG9JJNthKnp+f7jOKeS7?=
 =?us-ascii?Q?+KUAm55LJuBnHhfYPSe11RwHSs58u+8KZx6wEXLaz1EOzjcQK2068TRnIHj2?=
 =?us-ascii?Q?LqNteBhKWvFoRiZTP2kL5s9dCmOZE0bqCew3lRlOiQPM+3YskdfuL50HQCKL?=
 =?us-ascii?Q?2WL3JHl+f69CPf84qUCeWVzfnYSgjQmXqy44i7BRj7gTDuvgBPpYM4QNHCte?=
 =?us-ascii?Q?lKYi8IFPo0g0Jxy8IsOutK/cfKp9vyg=3D?=
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef486de9-23bd-459f-9ebb-08da2c4caea0
X-MS-Exchange-CrossTenant-AuthSource: CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 15:01:48.6339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cWCcYZPeRLOnyx5efI6GrUeJSBvcTCH+2krF0+SVq1mJuD9zQ57SBdG+fcULkn5OFqrAMle1BAsMtJC6MFHhzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO4P265MB5915
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following sparse warnings:
drivers/net/wireless/purelifi/plfxlc/chip.c:36:31: sparse: expected unsigned short [usertype] beacon_interval
drivers/net/wireless/purelifi/plfxlc/chip.c:36:31: sparse: got restricted __le16 [usertype]

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Srinivasan Raju <srini.raju@purelifi.com>
---
 drivers/net/wireless/purelifi/plfxlc/chip.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/purelifi/plfxlc/chip.c b/drivers/net/wireless/purelifi/plfxlc/chip.c
index a5ec10b66ed5..f4ef9ff97146 100644
--- a/drivers/net/wireless/purelifi/plfxlc/chip.c
+++ b/drivers/net/wireless/purelifi/plfxlc/chip.c
@@ -29,11 +29,10 @@ int plfxlc_set_beacon_interval(struct plfxlc_chip *chip, u16 interval,
 			       u8 dtim_period, int type)
 {
 	if (!interval ||
-	    (chip->beacon_set &&
-	     le16_to_cpu(chip->beacon_interval) == interval))
+	    (chip->beacon_set && chip->beacon_interval == interval))
 		return 0;
 
-	chip->beacon_interval = cpu_to_le16(interval);
+	chip->beacon_interval = interval;
 	chip->beacon_set = true;
 	return plfxlc_usb_wreq(chip->usb.ez_usb,
 			       &chip->beacon_interval,
-- 
2.25.1

