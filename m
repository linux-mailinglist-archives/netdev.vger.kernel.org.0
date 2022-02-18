Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4AC04BB74A
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 11:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbiBRKyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 05:54:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232865AbiBRKyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 05:54:46 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2055.outbound.protection.outlook.com [40.107.236.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E677622530;
        Fri, 18 Feb 2022 02:54:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oRps0eD2OIkS9RYhumcTKgKUSaMjKHxUP3kF93J+rbzExXKAX40qDFTq3xCTbYD8aoggm9+d7okFYqkACw1wtgg0fuZA2G5FF6Ssam+lD8uQxFqKF3UpcrpYlzZakm5gJ+/JSmv1hBOxo7gCI6cuCfKh9X98JHlv92xaJTnxZJL8txme4QITvmhwCd/njLocI2FNnHUY8FgvHx/FRwGL927Vym00hkurWjvs2utG8TvLy5u4RezqYNXzy51TxKKI9AtBUmejbVokd0HnXxojCgpZHYAbl2qGnHTeYKlZPiITGEpk+mX9rmFsQBbNpWbVBul2DxSkHW9bps6UH75C4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C6486Dcz5hnZIsS+NWCT8cQAaujbHa05s8lfs45okOo=;
 b=JQgPxdGwg7t6cR11P4F0jjSNrtl9+kTj6dvj798yftOi1L/0fQfr09Uzc6SkxH+mKX62Lbv4iBeKoGa5wYIWY+kiVCDMNAqU8z3ewvk4MW8UHsK5psL4rQptHmLZh4m7sUZ3AeLm3dJ8CxW6+UXKZU8XI+FfcR0g56qRx2eZlWuGYmbezNO+Mut3QyVObBHgOYRZ0nQtZx4Cp64Gpp0MDIAH0QRiITJdriO1abn7434g9pymThkNVjgEodpJ47kaM1wpQnjUkd9xRmrzuABtm5imMTI3AKa1BDm8JMG0UrC8fro6kO+TQGMho6DTXGVEJebhXAGAtrtZuHDuginyZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C6486Dcz5hnZIsS+NWCT8cQAaujbHa05s8lfs45okOo=;
 b=CrgU9djm6Je9/7ORIL+DsfwqLTHSd9EH2qnGkINUMqd6STvqxUwQAayLT5e1xeNQOdBlQh22s2RgYVCrjQTK70I+hawKn05J6xinSLYD+WsEWvjTXhHGKxGoIhdulL9w/YbVU6t+T6ucv1rmTHSF+RPwc2IFVfrg6VecVe0iOWY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by BN7PR11MB2771.namprd11.prod.outlook.com (2603:10b6:406:a9::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Fri, 18 Feb
 2022 10:54:26 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::1b3:e483:7396:1f98]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::1b3:e483:7396:1f98%3]) with mapi id 15.20.4995.024; Fri, 18 Feb 2022
 10:54:26 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Riccardo Ferrazzo <rferrazzo@came.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH] staging: wfx: fix scan with WFM200 and WW regulation
Date:   Fri, 18 Feb 2022 11:53:58 +0100
Message-Id: <20220218105358.283769-1-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.34.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR3P251CA0027.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:102:b5::13) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c254fe4-b687-444d-02e4-08d9f2cd07bb
X-MS-TrafficTypeDiagnostic: BN7PR11MB2771:EE_
X-Microsoft-Antispam-PRVS: <BN7PR11MB2771265B15AFA32A2876666C93379@BN7PR11MB2771.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6+8jboAO8WiXk2yjpbs+ZO/phECsD4N1BXEW4cPmLWAXTONqFGaorJIIlYJ3+FOAY6lmQ+uRX3NqbqjZYLQE7b4PcpsAF3haCKnNyLEwJhouEsQrq/083/bD1IE+WAoLZE1eCSxQtvED34467rblYwpGmbMrKDE/CcBRrnoT8+jAkz+BhTjQ4XNIemocmxsIh9jCRj+EMQQuRW2YamVDw/DhCgW1ymi8TxLUqKXVJ0waLKqd/hwe6ZVrbW+TaPhtBNx9qx6lmUId+nGu7okys+Q3dhfuwK/+UC30pzwX3rnJToOklWLk8ngf9sGWH8HH/5EAJmlXpeOLihqaVYRrGs01Nwg9xfC+3DELmZxYSam5VKI3w54JNpxQB4zWNwyelL7BwFFgE22KnY/8og4b4AltFdbD50Oh9eSjlzK+SxZKwFiWMNYoW9YT7ruMULaV0xOCkpWtF6ORLz85fdzsDhJ9aFLiQc8RRcHXXXJRA0qv0hWEgyBhE6bkCWUHBd6xTve6A0hShctDhNfbPDEA2dP9DVsoHu/rnT87Hreb7ABFfe9cdf3EX8Vlqq52BZTty4YSqQ7pnypZVA4ob0UQXxI5SIHobVx8PwjTZhUp32fIs7Rg6jUw85eiP6yvRMWdCiflmay4WgWjUBxlCuLUVHIIjWyTKQ/PiAZJkpm1Ii0LFeXVqaCr0ni8f2GF7OAEcH9Y4NXNoNg+47Az/5ZzDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(186003)(52116002)(66556008)(4326008)(26005)(107886003)(83380400001)(1076003)(8676002)(5660300002)(54906003)(38100700002)(38350700002)(8936002)(36756003)(6512007)(6486002)(66946007)(6916009)(2616005)(6506007)(2906002)(66574015)(6666004)(508600001)(66476007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TVl5TzJwZFZwdkg2NVFpN2pjNnErN0FuVGRuM292bkszSGgvNWtiY0NyNVho?=
 =?utf-8?B?L05ocEJHREpPL1lUZDc2WjdiM09sMjZlVzh3VG50YXpXalArWFlydSszc1R0?=
 =?utf-8?B?WktRL2ZxU2padEtOU0dJSFl0TXozODdzQVFTNUFoRDdNOWRDZmpVV0hkTXdt?=
 =?utf-8?B?b0hxTVczLzRxN1NFajBiYzgrdlIvc0E5SWdYeFgxMmlYV0I1UTJ0UFR2OFlO?=
 =?utf-8?B?RThQSFd0Y0lqSWJrMWVTeDlVcmJ5ZFhjVjd2cjhhVDd1dFFNVVJEZzBuM2lS?=
 =?utf-8?B?ZW15QzYwUXBTaTVrNkZBSFRvRUsyaE5iUnpHR25KLzMrM2QwNTJ3Ky94QS8y?=
 =?utf-8?B?aDZGdjl6WGVzaTUzU0VtakJyRFdOMWhuMmpiZ3NtcjJrZkFJY3JUZC84Y21u?=
 =?utf-8?B?WVFGcXlJa3BNOHF6K2h4TC80VE5XRE1BYWdwRkwzamlnbWIwUUJCQ2NpWnAw?=
 =?utf-8?B?YjVSUkk1cklMTlZIVnM3YW1yN0kvNjFDeHh4OEIyRUR4cEsvQjdzZXRwZzB0?=
 =?utf-8?B?OFFWR3gzcG9ZUXVJVlVZY01PM2E2b045a0R4UFd5ZTJXL1l5QXhMbkdsd0ZZ?=
 =?utf-8?B?OElCRjlqWXJFOURzZU9WdTloVjRmRS9xYlRydmFMZExMamFQa0JmRlNYOEU4?=
 =?utf-8?B?VzU3ME1rdUIxc1VQRHhlS2ZWMmlhOUVwazB2V0t5aXNCZjJrVnBYSEhsejlz?=
 =?utf-8?B?d1AvM0pORTN2ZklacXEyblRaWURya2Z1dUhnVWZCYUNpS3BjK0xnczN6WEVZ?=
 =?utf-8?B?eW9MWEJyVldVNS85dUZjVnhJQ3lVZWZ6YlE3YkFPMEt3NzYzQkJ5L3YzOFh0?=
 =?utf-8?B?YUN4L1RUV1RDblRjNUZvL0RPa3p6SVRnM1JKWndUZkhEZk1aMHZpNTVITUs3?=
 =?utf-8?B?cXgyNUVaUHpjSUtvQVZGRDQ5NnFlZDNLRk90RFBLTFhNK2xabmorTjdGNGpl?=
 =?utf-8?B?dnFITVBsbm5WZHdISFJYbFQ5V1FQRDl1MFVkSkVjT3FaNnJNTWZsc2IrQzRK?=
 =?utf-8?B?RWtaYkUyTVRveGIwaXZoQUNKWHBPWmpMUHQ2T0hnOFNITVhId1p1WUtyTWdM?=
 =?utf-8?B?Zzl2dy9PVnJEalVISEhiVG5Vb2MxRUh4ZWIwaWFSekJ4a1B1QzBYUmNsUXRI?=
 =?utf-8?B?MlcvYkg0N2JLeW5tMFc2cGlwT09zZTA2ZjFnNCt2SHdaZGpITjFZTFlaSFpX?=
 =?utf-8?B?VUFBdmlmZ0Q1L3NTajB0cDA2RjRpNzFEakpwWG51clEwTEptaEF0aXZ5elRs?=
 =?utf-8?B?TlpXSW9XUGhueXhhcm5pS1hWcm1qb0o5WlVlbWdmYllUOGExa09wcjhTdUF5?=
 =?utf-8?B?NFppQUNwcVlLSlpuQTlFNWFYd0Jpb0ZhQ3RLNXVhZCtaSk9pTkNDZUduOFZj?=
 =?utf-8?B?NlBJWllhaHZyQ3ZPOEJlakdJMC9FN2JjN1hnU2NOZi81eDZWc1hoRXBDNHNS?=
 =?utf-8?B?UExzKzBTLyt0STdIRC9tYWJXT0xPc3krWHIzdWtkSXhRS2hsYkJjN1ovbTFs?=
 =?utf-8?B?VEJRNmNobTBZWS9ha3hPZDlKVmo3M1ovQ3BJNk9rM0w5SXFEZmxPbzZmRE9E?=
 =?utf-8?B?OXhXR3U3bHc1YjEzMzdvUU5tWHMveTVSQ0haUUloZnN0NWw1QVhnQUR5V0FP?=
 =?utf-8?B?ZStWamdOcjlENFBKdmVwaklkY2ppeHpsQ0xqdkx6MFZnSUNkUnBBb0Nyamhu?=
 =?utf-8?B?WkdxbkUwRjIyUDJPTnRYLzd3eVp0QURtWHI4dHZkaUp4TCszbUNMTyt6Q3d5?=
 =?utf-8?B?eXpQN3p2Vm9tajRVbFRZdmszTzhONEhESjJ0SjVPci9SSmRqVjE5MXFaTXVv?=
 =?utf-8?B?MUxQaSs2K3p1UzR3Um1ndzVVUll0akdHNDdHZ3FOZDd6V25XUVZycTZ3M3ls?=
 =?utf-8?B?cjZ5UWJVMUxGQ1d4NUEyN3lSVTJaL0hrSnBpSXVndzlIRUNtRHd6RFJMSVZa?=
 =?utf-8?B?SXVqZUNTL1BzQkd1VFZoTlNUcG1xVWNhMkhTajN4NndWVE1kRWdMVFhSUVZh?=
 =?utf-8?B?MFBuN0hnMnhxaS9pblFPd1lxWlV2TnFlbXdkMHlCVkVkTFZlaWZPVDYzZVlF?=
 =?utf-8?B?cjE0MTBqMnkyQnRRRkNBblBOcjZhR0ZqeXFaOTU4Wm4yOWV1RStjNlZXYjYr?=
 =?utf-8?B?KzUyNVZ2dHZuZE0wNmR5QzU0bzVBSVU3VU9HZUdOaUJvZFJSNm5LQ2JxTHZU?=
 =?utf-8?Q?qnsXHJ58Y2kQTkpxEQXf0GE=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c254fe4-b687-444d-02e4-08d9f2cd07bb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 10:54:26.4529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: COhDC81AUz/NT2PYTNaTbOSAFF/uK+gebaA+jpCzdi9pQOgV8Z+fuGvdH9piGjfhYA69BUoVmnc1KIIUzj4M1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2771
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUmljY2FyZG8gRmVycmF6em8gPHJmZXJyYXp6b0BjYW1lLmNvbT4KClNvbWUgdmFyaWFu
dHMgb2YgdGhlIFdGMjAwIGRpc2FsbG93IGFjdGl2ZSBzY2FuIG9uIGNoYW5uZWwgMTIgYW5kIDEz
LgpGb3IgdGhlc2UgcGFydHMsIHRoZSBjaGFubmVscyAxMiBhbmQgMTMgYXJlIG1hcmtlZCBJRUVF
ODAyMTFfQ0hBTl9OT19JUi4KCkhvd2V2ZXIsIHRoZSBiZWFjb24gaGludCBwcm9jZWR1cmUgd2Fz
IHJlbW92aW5nIHRoZSBmbGFnCklFRUU4MDIxMV9DSEFOX05PX0lSIGZyb20gY2hhbm5lbHMgd2hl
cmUgYSBCU1MgaXMgZGlzY292ZXJlZC4gVGhpcyB3YXMKbWFraW5nIHN1YnNlcXVlbnQgc2NhbnMg
dG8gZmFpbCBiZWNhdXNlIHRoZSBkcml2ZXIgd2FzIHRyeWluZyBhY3RpdmUKc2NhbnMgb24gcHJv
aGliaXRlZCBjaGFubmVscy4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJv
bWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYyB8
IDEgKwogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspCgpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9zdGFnaW5nL3dmeC9tYWluLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYwppbmRleCBk
ODMyYTIyODUwYzcuLjU5OTllODFkYzQ0ZCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dm
eC9tYWluLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMKQEAgLTM4MSw2ICszODEs
NyBAQCBpbnQgd2Z4X3Byb2JlKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KQogCX0KIAogCWlmICh3ZGV2
LT5od19jYXBzLnJlZ2lvbl9zZWxfbW9kZSkgeworCQl3ZGV2LT5ody0+d2lwaHktPnJlZ3VsYXRv
cnlfZmxhZ3MgfD0gUkVHVUxBVE9SWV9ESVNBQkxFX0JFQUNPTl9ISU5UUzsKIAkJd2Rldi0+aHct
PndpcGh5LT5iYW5kc1tOTDgwMjExX0JBTkRfMkdIWl0tPmNoYW5uZWxzWzExXS5mbGFncyB8PQog
CQkJSUVFRTgwMjExX0NIQU5fTk9fSVI7CiAJCXdkZXYtPmh3LT53aXBoeS0+YmFuZHNbTkw4MDIx
MV9CQU5EXzJHSFpdLT5jaGFubmVsc1sxMl0uZmxhZ3MgfD0KLS0gCjIuMzQuMQoK
