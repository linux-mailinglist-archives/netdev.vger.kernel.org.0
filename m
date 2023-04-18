Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75F26E6012
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 13:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbjDRLkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 07:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbjDRLkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 07:40:14 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2052.outbound.protection.outlook.com [40.107.15.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB664C3B
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 04:40:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nJwxpTvX0MDIRjGR/n80NMOqzOpsCL0c/LHglf6KzpA9KkJatGdP7IrbY/GCE2n5gGROdaHwW3TjtsEZgI/c5IV3/u6FpeEX0lhleRIWuTDxe9HC1Z7v8kLqPv5hXlNcf9VlV+oJvmvR1CNzIYFMTUHNzFcMTOOS7JZZRu77rRiOk1MtWzbVBo8hpxS3frS/wBVVK+v8s8VuAoeiCRFk4fLZHDyCYzorEzdvE6GepYFDRDBGLAQWhHkkdtxvr1YjdixFfFUVaVxL22IA9gFP4HeCeLbnhLpGmD/R8AakIXrFBtHr5VOwgwlssu2y6aewahLpWRGfqAa+XTuh0WQh0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=19SkOQoO0PTZMiZ+iswIRgcZZLkXOz0KPwkBPcg5r+8=;
 b=OQDVqhf4GMaKf3XacETpAlFm5f2UkQJyO05ow+Y0U6k/5x0tg7tJqAlcDsTlHiI3qDkTPu3e0LzKkVoXZBi30jfu21/RPwnRs0CvTTGc6iM8S/j9/tjngnAd3zeNvM7+KZ2mQYphxyBmbYUmUH2diQDLab9lTz+66z5/Ix90KFTC+ygp5TYPaHWumojMYKoZPGu4GFaA3HZZoQePre3JV20LzA9JApIB+nxgnnt8z4A7tT0FsMqBn4xboYHepIRandBBfSid8jKvPbMFL9TpjZjtI/5ac2lyDrhurq7HOcnoZuNL0cVhnC6lTarzPdqK7seEczyvSULGQrf2w1W8yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=19SkOQoO0PTZMiZ+iswIRgcZZLkXOz0KPwkBPcg5r+8=;
 b=Ehe0B7832aWHkn/WNqTei8yvjc+KPmG9I2dLPK9qdzNlNJxCrYYs4kzB3tIsMU5LZM2DeClSr3jkbFH/UIHNpLVrlM/6sZub/xpsxB5jsuRA8vDvf5CXd7kb1ucPsZCAvqOnqL2W9hxH+Ad5odnAPCwbcKGE1OyLaCf4f57goVU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PA4PR04MB7824.eurprd04.prod.outlook.com (2603:10a6:102:cd::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 11:40:08 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 18 Apr 2023
 11:40:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 iproute2-next 04/10] tc/mqprio: use words in man page to express min_rate/max_rate dependency on bw_rlimit
Date:   Tue, 18 Apr 2023 14:39:47 +0300
Message-Id: <20230418113953.818831-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230418113953.818831-1-vladimir.oltean@nxp.com>
References: <20230418113953.818831-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0003.eurprd05.prod.outlook.com
 (2603:10a6:800:92::13) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PA4PR04MB7824:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d8f49cd-9014-49fa-2b73-08db4001a93a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: foWJVZ+8a7Gsm57nJ02t4kgsXjVjX9c8DdrKl9xTCUH0mowLQUUFWJZGSDTvHpJdZLob+dNxvB0kmtvOjWTRAgAWVNI5M/98iEdsYClNGQE/X5rqs8A9LE3SUiVvRF3hKDUvSO6ClwHzUHhuLWWj+vHvV5Y94tao4ExzS4tZs7b+m8avIf3mzjOT6NNZndeCMqQM2yT2qABoqIYStz+iZG9K7xgJydXEl+rCp4tHV1pqZWKwnGQHkmBFC/VZLfE6buC415+SWwttGF2gOe1mtkhgm6ytjRqh2IOqnoD9IJyqY7jBc+n1VojxHU6ixD3Pb9rGHpthRhbkpEdPPhG6oRPsb0U1uoZRsL+wMXNOaNeEP/Ib33528YJHj64pHTi6I786+swZUrTmUpx0CU/H8vMBYr17j5JPDrqP4Yd5yjRR3DcCR6a0K9MaCKj1/hl/jDlaqzOcTre66Y8Txp3yGzLtBL05uniUbAyVh+9Q1Lf62LNcH3ugQX42OYh8Svae1h/yfQV/+riWR/zIezNVk+zhvBl/H0GSk3tujT3VkzzmImN07l3oGv/q84JegejgWc/jyNHkb8wDqgkinCZTfZ9Jr07Qas+zPxuyma1BvPJK5tA3a7w9sa743pCsDICu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(366004)(346002)(396003)(376002)(451199021)(6916009)(4326008)(316002)(54906003)(66946007)(66556008)(66476007)(186003)(6506007)(6512007)(1076003)(26005)(38350700002)(38100700002)(2616005)(83380400001)(5660300002)(41300700001)(8676002)(478600001)(52116002)(6486002)(6666004)(8936002)(36756003)(86362001)(2906002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5NjU2y/Ao7qxbXAp8hJPGypDTX9LKQozd6kX98D2X65oBgHXqpO17BVOZALU?=
 =?us-ascii?Q?16EZCub7JRqc9NWIypSCTIazOyfk40xJoO5f7Ai8R1svx3hPKc3Rp1GO3wrN?=
 =?us-ascii?Q?dNwSey5Q/aSP6h8MxchInWzmf+FH7NMf8eNvoNLlPYQ1GSkT71EHSwbBPt1o?=
 =?us-ascii?Q?TzGAVIIBGGixhZffCiyRs0K5bOcEsslyR9jBgmQWvPWBe7ZdjK0zIKMiP5PA?=
 =?us-ascii?Q?40dbdRAyQdRmokkkfZMqj1F95jomqQx59tBMAN23N/mLrSdSO3dVwpJx/8md?=
 =?us-ascii?Q?Szqhofj7lrfrZlqckWEEf34EY5URWNRTsQAJee9X/rnSgrOBHiofMSuMtzn9?=
 =?us-ascii?Q?t8an/Cdwcn9xJjqfHhjhXO2rkHwD/Qxr5nGeGvgUejMHN5TTfB+ZTZ4p84He?=
 =?us-ascii?Q?tahk4rlOL/MGyHcxsshprmqY0N1DPF9OvyOe8HLsrbbHXM4oeu19JKnIMMzg?=
 =?us-ascii?Q?z041IfAoCdhX2pkbOkIrqWCv6aIrgFbvOpKU1bonH4oUNie7YxBjE56AIo06?=
 =?us-ascii?Q?surv2LNmZgD30R/ZZhCf7aXJ7HSOABYB9RTc0Bf6CmgQ5GwpwzCUMn14CGLd?=
 =?us-ascii?Q?gQ2pIyh7bVyOBVPnokjssdjGDeGFbgGSPbFXddtC99pO8g2E5NT3kHq+n3ig?=
 =?us-ascii?Q?ruy25PQ2X+x9xh1K0i9HJ9XekfryJB2hw+uODi1p0A4dL9NjvsKm1CMUSK2V?=
 =?us-ascii?Q?zlH+c3NF5NjvjMHR59pprHesWQ0k+8HihRDF85GmJV5+ErVCYym1hx8guwXq?=
 =?us-ascii?Q?ADdXDCQgwY/Ezza0VCZeXflCvbBrKPzK8MUGhpH+WiwWtN2hlPyamOFx1ZyX?=
 =?us-ascii?Q?hN+kKSr/tWUo0OyGcFTa+V9wpRTjgcWdaLmMaBX++N7/DeD/O0yNQL1+dt9m?=
 =?us-ascii?Q?V229M1+H58roaS6Ua7rs2fgKD6Q1oZNQ+MZ5WB1VZHXP1qLlhd1AmF3Orl71?=
 =?us-ascii?Q?tY1K1ivQEIKDhY4Uf8pzSk757r8VbZ0x0n0JMD0/eyognv4pqHimDtDnd6p2?=
 =?us-ascii?Q?8Rde3K9eaqwGQadNDCT941lC3y8o8Pt/7uZ7+V83c+Q/vz8/kuRDbfSdJOKU?=
 =?us-ascii?Q?/srC0fI8Sapm6xVSXWIAm/v6up7q+VwgG2WGhDb1ylRzG5jvM3noew3XlLS+?=
 =?us-ascii?Q?Ch1QUBB4qa2PxtLlEfnLmzPrkNQP8FDm9bOZBP4LwTmkfHuuMn16WqptCYnx?=
 =?us-ascii?Q?T757Bml6A8HKvdhy/qz4C+jr4VXitZ/yeqOMZdazKtZxMFt/SJtQkBkhX0H8?=
 =?us-ascii?Q?LPCG627qxBTPM6apoUtSaFrWBHsL9zNalAygWqaRtSpHgkv+1GGWqBpuDy/i?=
 =?us-ascii?Q?Lq+ouhf+gWRC1SPADFbjIBUUqLh5oB04GFRJ8NMQwYHBGmw2UygGbjKkLVAr?=
 =?us-ascii?Q?le+/SdZ/yeb7QcjFjWyU50ExxAjKChPGekqZP6Gh+XMXVEwBHXLjs4qVTzHO?=
 =?us-ascii?Q?1SEGhCdVG6HD2ljPVTCjuwkv8hcvfARsvvIjdNvLwigiRkDGbEiDFIpLanDo?=
 =?us-ascii?Q?PTjrPkCXuvbpSpl1Tq7QGkMUlb7pd5ZRDJg3dc5xdxVOgG6rVYQ0PEc46G8e?=
 =?us-ascii?Q?i4bioccmE6+R7rWAQtBM2NDTeZaI/DwvfbMDOQbysE2KewJBKj/OEyjXXk7p?=
 =?us-ascii?Q?Qw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d8f49cd-9014-49fa-2b73-08db4001a93a
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 11:40:08.2922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fpHy7dMdaq/f9waK7mvfJZMlf6JYpZqDaD4sIH4eEvmvGioLYJXkPhm8ym97TW6eOQtQOSuJGooi98bQWLTjJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7824
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is confusing and easy to get lost in the soup of brackets when trying
to explain that min_rate and max_rate are only accepted as optional
arguments when "shaper" takes the value "bw_rlimit".

Before (synopsis):

[ shaper dcb| [ bw_rlimit min_rate min_rate1 min_rate2 ...  max_rate max_rate1 max_rate2 ...  ]]

After (synopsis):

[ shaper dcb|bw_rlimit ] [ min_rate min_rate1 min_rate2 ... ] [ max_rate max_rate1 max_rate2 ...  ]

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 man/man8/tc-mqprio.8 | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/man/man8/tc-mqprio.8 b/man/man8/tc-mqprio.8
index 51c5644c36bd..e17c50621af0 100644
--- a/man/man8/tc-mqprio.8
+++ b/man/man8/tc-mqprio.8
@@ -19,13 +19,12 @@ count1@offset1 count2@offset2 ...
 .B ] [ mode
 dcb|channel
 .B ] [ shaper
-dcb|
-.B [ bw_rlimit
+dcb|bw_rlimit ] [
 .B min_rate
-min_rate1 min_rate2 ...
+min_rate1 min_rate2 ... ] [
 .B max_rate
 max_rate1 max_rate2 ...
-.B ]]
+.B ]
 
 
 .SH DESCRIPTION
@@ -142,11 +141,19 @@ for hardware QOS defaults. Supported with 'hw' set to 1 only.
 
 .TP
 min_rate
-Minimum value of bandwidth rate limit for a traffic class.
+Minimum value of bandwidth rate limit for a traffic class. Supported only when
+the
+.B 'shaper'
+argument is set to
+.B 'bw_rlimit'.
 
 .TP
 max_rate
-Maximum value of bandwidth rate limit for a traffic class.
+Maximum value of bandwidth rate limit for a traffic class. Supported only when
+the
+.B 'shaper'
+argument is set to
+.B 'bw_rlimit'.
 
 
 .SH EXAMPLE
-- 
2.34.1

