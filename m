Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 132A668AFF4
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 14:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjBENa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 08:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBENaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 08:30:25 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2130.outbound.protection.outlook.com [40.107.220.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7849214E9F;
        Sun,  5 Feb 2023 05:30:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CpS7wnfF574luzL91NxnBVZEsZT4u3MVa/c2/97KzB2GcQrPd4ntGg4F7u5b/jBx/zCsN6HCekCg7Qx7VNzaEkKfPfvmxrRRB5VfzGAhDEniz34Pc4Vn7Ds0H6IuhQyZ1YkrOmapWddPEetRPqBHFNlBCZFD9pBGBbXBbtIMED905CqMEXN56mO2ZlTr3mJLpvuZh26xxUkRDn1XvCOF0GYwliK1y75fcFRNE576ltuWkjJeNlYal2OxSeWO5kJlIQM7E2zYDkIiGy5M9oKjHR48d9UMxHBexhqcTcWyhpMZ+vctEtsyilEaKL3gxdSTWJR9FSt9qxvL9xJf3VJvsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1rrU8bCQyEyfQHuUXMZKewVMyXfpObYzfRhYV6hT7e8=;
 b=TgiAC9F9GsT//y7WyrGFtoq255QkMvwstQDCYurMsaes84RIlnxkdZ67kPIojo2pzz627X/cLbsEMTK+pSShcBtpkvW3HSrobqO6jx5EoylhMwtPMnGHKwknrJpKpP+OnIRw8Ib4gimy/5McSOthhJiK9CHm42I1ZqvnyaF0S+Oufn5n3uc0srZfDGxKx//czU6TJAEqICe6Jr2ZzboPcVIwQUTG1cEdUzI4RsTNsNZvSs8nGy5zCfD0IKpK64SmJBfEJ+cez7R4ZAv4G86zwQKGasQN8qbmY0+kSsZyvEX5vuZZfknBgK6FVDKoBBSTy350liKuazusHN2nCPX7JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1rrU8bCQyEyfQHuUXMZKewVMyXfpObYzfRhYV6hT7e8=;
 b=n0EbgdzHAN13SmVCh+B7N6UjVcVH4fFggaFpCPwnkTHlXcvsPUi1uMkOmL0bBzKZzWyV9FXznR9e2w8gjLsr4ZCoppNc4cdBmTfqnsuBz2q0KoxN1PgX9sEsh7cOhMci0hX1Pu2fXmiEJUOqSC3drlpsKD+LpZvTbqBVfhHwnzg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4840.namprd13.prod.outlook.com (2603:10b6:303:f6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sun, 5 Feb
 2023 13:30:20 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6064.034; Sun, 5 Feb 2023
 13:30:20 +0000
Date:   Sun, 5 Feb 2023 14:30:11 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Tom Rix <trix@redhat.com>
Cc:     kune@deine-taler.de, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: wireless: zd1211rw: remove redundant decls
Message-ID: <Y9+vY9XZUK1xL12g@corigine.com>
References: <20230204200902.1709343-1-trix@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230204200902.1709343-1-trix@redhat.com>
X-ClientProxiedBy: AM0PR10CA0038.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4840:EE_
X-MS-Office365-Filtering-Correlation-Id: b88c09bb-f040-4079-75f1-08db077d2049
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2zpOvWOk4KBUbRPhXHIbHD5rhZacXgDwYYSWNVlK3djxBTdJPRYpVHC5qzUqhZIVDDlWW/Z5ucbFl9TDCnntS2w63GsVW5mCbBRUAZMkIvwSHmDKC0CcSgIU4CRNYu0sO61M6Tglt4jY/yuMFrNIFCr5I6KRCgrd9cOzYNechg+7Rhv4gpAvJIlrlAgMMMfw2zseNG9GyBzvSPSKpWKAD1Vl0hZmAInk85AyjMIqLmOUY7+alMHUo9q0Fe6Qf/f0/tIhRyKhBbg+NSA1ohm07OJbNuYn7M4JdFCri5uNdoWXFwxVEWRnPCB2JC4RE33VwWeS5rw2HEvU19IlaZWuFigR/9ePbFjjttC8n54c7yX0NNur5pUfHdTUSMyYgyTdSyQ0B+bIwZOT1GcWbLbYGiN3VjTt0s7lf49xtiBztwhOOWFhdvVjPPoUbznfHrzsbZIlYrqcCFLow2RUi3AkCPaQIj0Boc2pKXBAPZvRTDc0CVMRDz7/mzQ9eELFZskZsB76JkD0WFYqOb6eMk7OD3A4JUg5jSZ5r7qTv+AdFs6mJWO2lKc2l6kZfOgGWSfg0M6mnwfj2vHMET2kXz9GVTnGPUHb28jI+h19KEosvHCumT8+lnI9gKDUUlOHJPblM4nXNkYqaPI/SYiq9zgoVDyk5tiy/qp3pZTktae4+BJFh0RkYQ3whlGjlHtN8hdk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39830400003)(136003)(366004)(376002)(346002)(451199018)(66946007)(66556008)(66476007)(6916009)(8936002)(41300700001)(8676002)(4326008)(316002)(86362001)(36756003)(4744005)(2906002)(44832011)(5660300002)(7416002)(2616005)(186003)(6666004)(6512007)(6506007)(38100700002)(478600001)(6486002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?emFxem43eVZxNERLT091U3FJVVJXSFNXazRDSDJYYkZRMHE2YjM2dndYL045?=
 =?utf-8?B?d3Z1Y0F2WG90aThWRnYxN0JGS29uSm9JNzJlRTY0b1FTb243TGljUldGd3pN?=
 =?utf-8?B?WURZKzQzb1FKRFMrbUU2emkxbTBQUnFjdlQ2YUN2cVdTWGg5LzVqZ0FBTHN2?=
 =?utf-8?B?UXpUaDRNcjc0TndKT3kyYlpXa0VhcHUxZFcyNTFRczZvbk5RUis0aEFhOUI0?=
 =?utf-8?B?MkIxRGx2VkhMY1NYZDRwbUxWVXFlNHpKKzhZWmEwNEE3a0plY0w3clRrdVc4?=
 =?utf-8?B?M21PMUFIOWlnUVlPc3NQUk84ZHJXSmFSeHZpcElaY1FLdUtBZytQVSs2Snl1?=
 =?utf-8?B?a0cxM0c1NURqNjNQcjhkRVNYWEZYeHJKbDh3WGFxNzR1RGFRWU5TTzVONGRT?=
 =?utf-8?B?N2pVeHRWdkpyWnYxMFQvbVBWOWFKSDk2b2o2d1FYOXQvQ3JzaldVaTkzUkhy?=
 =?utf-8?B?WC9SclJDYnM3cm1SM0ZPWi9TVnBRU29PRlVyNURtZmxFSFk4Zm5LRmF0Wi9T?=
 =?utf-8?B?cHVuTFF1YUlNQTJUTndrRU91ekFteEJPblI0bUJUM2xvNUUwQ2dBbFBQYUJO?=
 =?utf-8?B?dEIyRnJKVnBNTW5ib1ljQThiMXFiOHl0aWpPSXhZVWx6OVRLSDJ5YUIva3VJ?=
 =?utf-8?B?VHBKRmdZRy9wRDhJdStZR3FRM3RtR3R2QTlvS05RajNWLzJMVjhFVnhnaUJ1?=
 =?utf-8?B?VEh2RC9FcGFVVndRQlZkS1VKdFhTd3RKWWozdVJzL3I2VUVEQTVnOWtxN0lw?=
 =?utf-8?B?K1NEbFNxQjV1U3N3NlYra0ZwbFBRdlJMZkFwVXQwVnpZZEkwNFdIaFBWM044?=
 =?utf-8?B?V245TjM1MEErUlk1QWI5WDE3TVQycGVHM1lkUStuUGwwQ0NhZTl3bkh2ZWhj?=
 =?utf-8?B?UFdCNWdqUjFLelpYZktTcTFUbGtqU3IyUElSZnk2QTdrMjFYaDhpZ2tMemZL?=
 =?utf-8?B?UDN5Y25UczczL2lhSC9yNXkycStpZGpyalRqMWU2NHI2eVNqZmR2SmlxVjY0?=
 =?utf-8?B?YVI4Q1gzN0JnYTZkemVaSGZES0pDMmRDcThKZnVGdTVxRGRNSjR1cHo1eURy?=
 =?utf-8?B?QVZhUGZFSU5kakNNT1B1TjJkWld2OVBaRXFmaGtJam9GQW4ybDFoZ2lpTkZC?=
 =?utf-8?B?M2U2cTBucTRoSUVvckNnNktISnNGbDJjM3RmUWJSUnlpTWVzZVl1RFF2bE5U?=
 =?utf-8?B?V294NFA5bTVnVGJIL2dNUkhSSkxBa3orY0JOaEdGMmJhdXNKa21sRU45WVo5?=
 =?utf-8?B?UFNUVkcvSDNkRlQvOHFwQUV3czFIcklNZlp1NnF4VlNkQVp6NC9pZ3NyMys2?=
 =?utf-8?B?dStZTkxCditrUmRReTRKN05qTFdKcVVKWUFRRTJzVFQydXgrNmQvcWZ1ZndU?=
 =?utf-8?B?Q0ZRNHJ1RW5EUzZCOVpvempRaTR1cVRiMDhmWElYZkFEbTBQbWZ1Mk91NnNj?=
 =?utf-8?B?WFlPRGZUa2RYeVdFdm5Ua0srY1R4RjBVZ0pUS2xLRlRFb3lLcWNYc2tuSUZ0?=
 =?utf-8?B?R3VKdC9DN29ocU95SDQ3QkxvN1BtT0dqeitKdUpVWWg1Q2NvQXlSOG8vNzY2?=
 =?utf-8?B?VzBvTENWOFhndHBKYVh0ZTgvdCsvUXRrRzAxNzV3QXJ0WUYyTFNsdWJuS3JC?=
 =?utf-8?B?NWd1bEhya29zbGNLcUFFSWd6V2NtTldDdmY5eDNsRmhOcldISnJ1VUtOS0RR?=
 =?utf-8?B?SVV0SlowMUZvNFhGZ2xicEtyY3h0NzYyNm5wS0JFUjNOWXpWR0xmKzJKaWFy?=
 =?utf-8?B?NXBiUEk1UkdwWDhreWRxeGZGQ0RKd0s1M2cxdUdDV0xQeTkzRzNDVlQ3U1lK?=
 =?utf-8?B?eTAzTVpWRkx6RTlhVFNSTjJ3d0krS0tqZm1qTFF1bkJza3hZVGYzcDI3Qkdi?=
 =?utf-8?B?VUhDNVRHeDFBeW1TRHhkUnF2T1llb2pjYUxaSzVMemU4OFQvQndwYldNWjlB?=
 =?utf-8?B?S3JCZ0NnYTBDNHZMMEIzQVZnbU4xRStRaGNtRUdBT21uOWNLTE8rU1NlTHZp?=
 =?utf-8?B?STdzQUxTRFhhcDd5TGdrelIyOTloazRXRDN3VUFIcWlnNXdlSmtxZ1hXUy9E?=
 =?utf-8?B?bzFvQWFZUmdrQzVSMkQwNFVXNlVCczZtNGdwYjUxMDlmVDlsUnNYWEUrTEUx?=
 =?utf-8?B?NEg3eHpBRk9JbHJhTnBqTThkUU9vOHVnNkdxdWxod0xmZzJIdE1WRS8zdnd0?=
 =?utf-8?B?ei9SWTZ5MGpaQ3VQMmZzalJpRVgwR1NVUlRwaXhkSHovMDgzdTJqTmlRNlNi?=
 =?utf-8?B?SzlCNUtDUTFTL2FvZE15ajZkcGVBPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b88c09bb-f040-4079-75f1-08db077d2049
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2023 13:30:20.0017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pCIsHk5DT+BwVaroQ8J7PoAnTAR4Pd+7oCPL5G9OxBVkS5+1wuoKznCiDh+TAHbeRuD3KOv/C00ErVFi9kntn6+UEpcort2K+TFucgTy/K4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4840
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 04, 2023 at 12:09:02PM -0800, Tom Rix wrote:
> building with W=2 has these errors
> redundant redeclaration of ‘zd_rf_generic_patch_6m’ [-Werror=redundant-decls]
> redundant redeclaration of ‘zd_rf_patch_6m_band_edge’ [-Werror=redundant-decls]
> 
> Remove the second decls.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

