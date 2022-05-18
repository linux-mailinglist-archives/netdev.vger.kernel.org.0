Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A464C52C225
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 20:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240441AbiERSZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 14:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234057AbiERSZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 14:25:49 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F843DE82;
        Wed, 18 May 2022 11:25:47 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24IHDZJb031157;
        Wed, 18 May 2022 11:25:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=c86lxq+YOvemo5LLuCqz8DwvAd9XKt2pGgdfgb6B0cs=;
 b=SSi+sBK8eY2sk3PrW9fjBGZBI889Q0WcIEpr5DmVW17saY6aBKbJnugxWcmXCHf26Avm
 eCpH0rNrTLX4fAPdHGOBZt+5zKcI5n3OlPgIoj4PfxWj1l4RtPeCxupshv7B6JwbBT+S
 i4FkcItQO/bRE0sOe+xDM21AEIbyeUc5HiY= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by m0089730.ppops.net (PPS) with ESMTPS id 3g4836uypt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 11:25:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FIEqRmHjSyOdD2c7gBYhIh2E+DpiOz2I1wvQK2CY6UrbUu+UOrk8PqHR39YMAuFRbXzlRiL5ydg3NZ6a5nbOXvd64YQG5/GN1EyJeVMWRwI91d2Dh+kmIlA3fHhu2/At25owgtNKpdpNsATjk0Y99UXkM/4gN273SYBfGHhZzKT8I6hFdMc3UsoKy5ZLxKfsC74BYUHsTlC1X2ZGFKy9f2pUxF1EfleOSL1jQKHq61xKw47AfFjeuPfNtAhhuiaXdZSPbGaQr4280oIrHvc27wxJ+0sQAwzOI+z2BZKfjwZS94He2iDW3V9IeOJ4m8vh+JShPmdg8jr2n8Z7OP//5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c86lxq+YOvemo5LLuCqz8DwvAd9XKt2pGgdfgb6B0cs=;
 b=cpYD7r4BL3ncGR/vG7ItMPqPUBLxu2sT3Aw2V+MpxC7Fy+SlrPJ0JqXgFQ5oTn1SG0oM32AiMmeg7Px2KQatvDpcxHJpTyAtjPq+jarF3guSEygv8vodFluxuVYpKm7qcz4SeGH5jzvOtq+0QJE4q3LlYQLcwCVJ1swSDJofj5xtOSlPzcHbGV7UYG4eQ8QBkk2gBPDwBSlxi9hXDpy0BjrLU1etvvD4Ed5ifikcia6pZa84/lOUGdnwXZu6d7SSnkwlfoZgK00xITYHycy3ucHfDd2hapiagmCTo48k5ZGm6YQxXDH28F/+hwWzUg686/nDdOFnb64QstFi6oVNWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM5PR15MB1467.namprd15.prod.outlook.com (2603:10b6:3:c9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15; Wed, 18 May
 2022 18:25:16 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5273.015; Wed, 18 May 2022
 18:25:16 +0000
Message-ID: <411fe622-a492-9c4e-fae3-9e85372ec4da@fb.com>
Date:   Wed, 18 May 2022 11:25:14 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH v3 bpf-next 2/5] selftests/bpf: Add verifier selftests for
 forced kfunc ref args
Content-Language: en-US
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com
References: <cover.1652870182.git.lorenzo@kernel.org>
 <987c9577695ef9d03c839100289dc432c7e22e4a.1652870182.git.lorenzo@kernel.org>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <987c9577695ef9d03c839100289dc432c7e22e4a.1652870182.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0123.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::8) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56b31b05-2c37-45ec-274f-08da38fbc1b7
X-MS-TrafficTypeDiagnostic: DM5PR15MB1467:EE_
X-Microsoft-Antispam-PRVS: <DM5PR15MB1467B70734D533050ACE4B57D3D19@DM5PR15MB1467.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GSQcOu0mPbVCITDCQyy23Iz/iHkt8mNOOERIYU+5R2MEqT8DcXsP/9m5Ar5tS+Wo5n56avdlqoyB+vAhu1q8rkVdPZCcLH8ifWK8n/o8pG3qC9gFvKPsVVnyGWhd7C/6cGbfKSb8i8EeKpWqhy3nliqF3O6vaLz8PJCFBsb3bj3V1q3TCWkIpSnXyZCQ0IPIJLU+M/r1a29eAwzCKkKAkg0ICJjZ37UnRluwDUfpS6QKPrRnwftTraFY8CBRBBuTTKgTnH5QKulWLPSnQtQ5T3phEPIBGodXDE9RRehIs9Vp4mm9XYo1uKdAdf5mBTs3x36KaVhlwb6Vjvkkb2GUUajadNjLc41EyBR/7+OotZ5IJHrqFzsK61PtGoBYuKbAZMjHk+0JH5B3SKYmYUgLhXVgTCLCdAMtpQtKBhRqzdKKYFmxIgcG7XGsz2Urg+yDDfrCjC7B2lgBxWOirZGKUIwq+oEnjOI0vqWVuWqmjSbsMjFiqvbKN6vAfHv+w7mg5FKz3LayFiiQh8TkXQ6NbIeZQHn18B8XWVwbQTO9g5EpqY4/W/IyqBbzoE+TqsBGfSNszkSSqA2YYEJ1J88dyweMfl/OHA9g64n1oGwFq83WqaAQK1g7o5IGjyizi6tyAK8XB9NLcBDA25FO1ouYlumgSn1Kqb8LmSLGw5mBQNW8HX3o2DFckoBjHEadvXTLlv222gCF4q67Z3aDfyHnOaScOwPsJEbedB+q09KoFTmzmLSMDJSFc1O5tMaIOTP+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(316002)(53546011)(8676002)(66476007)(66556008)(66946007)(4326008)(6486002)(5660300002)(508600001)(31696002)(31686004)(38100700002)(2906002)(6512007)(6506007)(52116002)(4744005)(83380400001)(86362001)(36756003)(186003)(8936002)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?amt2T1ZOOG5saDArQk9RMFBJUEJEOHJxNkUzMVlnT3h6S1ZqOVExd0g4TGVO?=
 =?utf-8?B?RnJsU0toQjQwdG1mdzRnSU5xUmk1UisydmR0NjB5aHl1d2FpQjdwY0tpeDVL?=
 =?utf-8?B?eTIvNGdrV2RkWUpodUtrL1FqaDZ4dy9TUlhDd09oNzJRTTB0TVhEalhveWdQ?=
 =?utf-8?B?OW5hMnZJcTRiQ3lwSlkrdkU1WEUvdWJDR1F0WEJPNzlDSHB4bnRJM2I1NHhR?=
 =?utf-8?B?R2RNWlU4T3RGa3llL2lySzJPY2hFVUNSbmZoRmNsMkd3LzIvTEFPQXJkTno2?=
 =?utf-8?B?Z203R0FuWFliWi9pQzhqSzQrb2MwY1VEN0VjdEVIUFJRczNRcm4vdzZyY0s3?=
 =?utf-8?B?RUlNdGM2NHRKS1VUMzJRdFJ0dEJ2YkVQeDdNZmtBc2wrR3JpSHZxQlVjZjdm?=
 =?utf-8?B?S2grZE1abm5qcFlQSVdEcmFzejVpM1lMSUs3TUQ2citnWHBoMlFFamhkMVQ5?=
 =?utf-8?B?NEV1cEgyRGo0MS91cTBzVkUwY0dJQzhGK1E5Mk5HK1pGSGxXZWNUTWIram4w?=
 =?utf-8?B?ejE4Um13cVoxbWFlUEovY1k3cVpDam1mdzl5NTh6Q0VRa1RJU0tlNDZlbDRW?=
 =?utf-8?B?M2l3OGhkYVN1QnRNL0V2SVdHRFJLdEZQbHFydFovTzdMZlkvUGxxMkc1VEZ3?=
 =?utf-8?B?bTJUc21YSVVFOHBHeTd0bnJNNDhpVWxDTzExVDJ2YTRBblNZR3JqRXRNMjk3?=
 =?utf-8?B?QjlDeS9ndnl6alJrVGxFblcwQWxGZ1lYTDFrMmltbmFMeC9KaWd0SnkwWTRF?=
 =?utf-8?B?VVFmMjFkU2tZdGQxSVo4dmdpYTlVYmQ3QVh6TkNCRkYwdzVEREZkaTl1NCs2?=
 =?utf-8?B?TmhCY0dxaHM0NVR2dWVkc1E0TkVGbWk5QzByZzExMjIvblZLcEIwNmV6aUFr?=
 =?utf-8?B?cUNtN1VScjlwQ2RJVEpJVERXY0MvZ3lVdVRrT1JMMnB4L3Vvc21ld3o2RWxU?=
 =?utf-8?B?R215czhTT2FMQ2VlZ1kwaVJWd1RGcFFuMCttamtsN2lSL29tcVZ3NlBJK2hR?=
 =?utf-8?B?T2Jmb1U4UjdyaG40OW1KalBSSHFIeUVpZEZTNDc5bHUxWkRlb1RoRzdZaXh3?=
 =?utf-8?B?REtaa1dzTnZ2Nk5OZG9QK2cxLzczSDJPS0JOOVREc3k2UEhyVTNLZkdDVlBa?=
 =?utf-8?B?byt2My9mME8yZnNYOGU2UVJhUWVCNGh6VE1lbmZUajFGYVk4UlFvUVRFQzB0?=
 =?utf-8?B?enlZTURVcG15d0R2c0tmcm16SHU2bER4b2l1aEpZeTNpaDFkVUFWTXd1Vkw2?=
 =?utf-8?B?OHRTS3dYLzRkK3RDUUF5L29kTVBNSDZ0UFhqUlg3RDkvQTdmQklWdW8wZGlR?=
 =?utf-8?B?Q3VqR09xeWxHUkpMcUt0VGh5VExMS0hXb05ZYnRtMWR4MEcxWWMxN011aXlx?=
 =?utf-8?B?bEt6eWpnZExVYXRQL0dRV3hrdlNEY2pQZ0R5akdNTTRrSUJQdUloSGJVTlB5?=
 =?utf-8?B?RldOejRhK1dTcmJoTVkvRTNML3hWelRZZHp6SUx6M1p5eTJrblpadStxZ1Np?=
 =?utf-8?B?aEwrVnRrUmtUS1B1VmVqOFpMZVFYc1ZGTExxSXFtY3RxNnpwakdZQ1ZoWFZa?=
 =?utf-8?B?V3k3ZnhhckxWNFNjMk5MWXUraDYwT1k0cE8zeUxZb2kyNStTK25ZaGdGWU9M?=
 =?utf-8?B?VmZvZ2hkaUVWdGxaSndhZ1l5UDRyQUdsYTN1T1JUd3FITTdPVW5DK1owVGhw?=
 =?utf-8?B?YVB4dlFzSzJOVjhhZ25rRDdIRlhuMmh4OHgzOERuMWZXSDNFb1N2b0hZRVY5?=
 =?utf-8?B?aXJCYUFMZWZyWnc5WS9OVzcrWUZVdWlQMDBjaGtwMmNrUnZMM0FxM0Q3VDcy?=
 =?utf-8?B?SVFQcWxUMnhXdmlrRXZZSzRPOEJaWTJ0THI2cEVzbFhkRTdCNDVoOVM1V1U1?=
 =?utf-8?B?eEk4OFFVYU5LaTRuZmcra29zbGZSNkZkNE8wd1RHM1hzUUVRSzRmYm9zY20y?=
 =?utf-8?B?Uys3YS9laDBrT3N1WmxNcjhxT01TNVhvUXJzU1hCYkd4NU56ZlNQL0tWV3Qx?=
 =?utf-8?B?WWZOaTBJbDVoTERGVjM5RnNHdklLdThuczBycnVPMjVLWGkxVEhTemNUS291?=
 =?utf-8?B?QjAxMm43azduUnExbnl2dmFIeWlFa1hybWZtOTNxTkFEQ3ZqMUZUVHdkM1Fv?=
 =?utf-8?B?NjRmTnFYVFdDa2NiZW56SWF1TmRSdm1ZYXB1MzZJbUVydlVjNVBCaFZucUpz?=
 =?utf-8?B?a2o5RkREbXh4cnVjb3dHYUpTVnBQL1BUa01ZVHJkR3FnMVRwS0kxcG5DMEJt?=
 =?utf-8?B?QTBVMk9hdWZ6QmdBSlVwUnFoZGVycHNmaWhJak9PM0ZQZU5oWW94emdmTjdk?=
 =?utf-8?B?bVRGbHlPY3ZJWHR4MzNxZDRoUXg0WmMxNGZKVkxVcUFnSG1QaHdjSFdhdXVz?=
 =?utf-8?Q?H9boCl5gf7wnjUgc=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56b31b05-2c37-45ec-274f-08da38fbc1b7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 18:25:16.5861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ITTnR5fyVc6CTFrmS76QBnCJAmPgN7dKtBYst/Fei/4fj9hgFc238y9qAeJM7Qor
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1467
X-Proofpoint-GUID: WJKiuejtvuJYKdiUwxtiMW-YbZVTUTnY
X-Proofpoint-ORIG-GUID: WJKiuejtvuJYKdiUwxtiMW-YbZVTUTnY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-18_06,2022-05-17_02,2022-02-23_01
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/18/22 3:43 AM, Lorenzo Bianconi wrote:
> From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> 
> Make sure verifier rejects the bad cases and ensure the good case keeps
> working. The selftests make use of the bpf_kfunc_call_test_ref kfunc
> added in the previous patch only for verification.
> 
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
