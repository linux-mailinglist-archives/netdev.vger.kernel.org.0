Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 778536F1C8B
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 18:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345870AbjD1QZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 12:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjD1QZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 12:25:28 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746222D61;
        Fri, 28 Apr 2023 09:25:27 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33SA9SPG030222;
        Fri, 28 Apr 2023 09:24:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=X8LKwlibEE5RXHCk6CT5DeJC2EiII0qmO20tdOQ+ZTE=;
 b=EhpI2a6XY0855KkOZq3vcC3szZbyUfI4tGC6vkFhuiIRJM7frcF105JmL2j3Ir/enSIf
 kjweN9s4XuDtaw2Bm+Q/XzwAY9VHfaVPSjZq8eQjsKYc9atyjASfrJNswzj35C2Fw/uv
 sm3zS985O+/dNTy/m71BrERpwqgtwarWM0Var8Q0DmBBnA/QgTsnCWcwMDfz/ryQyoV7
 PrJSPn3/+gCNZkZvDhZUYAQb7nIjenSdj4rZWTSvmX4UADS9nVQnoJzRDFQhXuuV/7gh
 EAKrErJsntVhLY28ZOtw9CMmmqVVnS76PCXh7uqgn37RZvZZeeoMqTGZEdFH4dLPWR42 xA== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3q8a5ck8fu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Apr 2023 09:24:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hb/FdFbQDeCqhlt7Cgr7X1CxvNpirwMRUevk19kAji9es+pI3OAf10uTaCbJB/qoFye8aB0KRREuBetw57M8a32rUSwjoktGSsdnuaAt4R5jve8ej9DQVHv7Te0nt25msaaIS/lHdC0kGqw5ulM9ybmg3MZPJ+n0veEJSGYT/FyckMoy+mMflhcoenrle5RM+lhJSA6qj3dILQPnrmQPYrVKSWEuesh8gW8JaulDQMI0oRZqIlflJ9qpVUCiIq6ofJPDAdzMWrAExnls5iRcxxttfBczWbpG+PQN1NebPR8OybAfrG1A2QkwyqQwp8R8LvtXJrVs5wLc8FUwTXP3JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X8LKwlibEE5RXHCk6CT5DeJC2EiII0qmO20tdOQ+ZTE=;
 b=YRIfHtPWusUPybOJaFBfUd5geNR8dzMxdynjdVANbKnO3HgmTludicuCTnIq0MwozTgRRn51RH9ZBxC1gHh/uTmXJTrv0624IG0xJbMiu5gbnCcIY3538jAZbsXnAM7CbjRzl5xYxek8QrMV56Y6EZPtE2qe9M2SAwR8g9cOjNMiLI4veLbdgsVET3rgbZLPfJAkERedFrQtxCl4TPJHAXj0JZMYDVdcVQDTIG5OICYuwr1kU9fSx0HOHeod/JIKDPHWfxvJFApAMnvoKb451mGUtdcCuY/spvpL1E5DZUMju9SovBL+nfx6R6bQZ/UUuh3CkUa/QZnZcNtB9+yfRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4516.namprd15.prod.outlook.com (2603:10b6:806:19b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.23; Fri, 28 Apr
 2023 16:24:31 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::589f:9230:518:7f53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::589f:9230:518:7f53%6]) with mapi id 15.20.6340.022; Fri, 28 Apr 2023
 16:24:31 +0000
Message-ID: <4325c18b-9470-8b4a-d62c-a4efe0da5b7e@meta.com>
Date:   Fri, 28 Apr 2023 09:24:28 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH bpf-next v4 1/2] bpf: Add bpf_task_under_cgroup() kfunc
Content-Language: en-US
To:     Feng zhou <zhoufeng.zf@bytedance.com>, martin.lau@linux.dev,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mykolal@fb.com,
        shuah@kernel.org
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        yangzhenze@bytedance.com, wangdongdong.6@bytedance.com
References: <20230428071737.43849-1-zhoufeng.zf@bytedance.com>
 <20230428071737.43849-2-zhoufeng.zf@bytedance.com>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <20230428071737.43849-2-zhoufeng.zf@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0006.prod.exchangelabs.com (2603:10b6:a02:80::19)
 To SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|SA1PR15MB4516:EE_
X-MS-Office365-Filtering-Correlation-Id: a3db4edd-f692-49a3-1835-08db48050b8b
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9iRRoQxZLolbKJHX78ZmmrAG1C9tam6ssaIOxhTkiLFSweGde4B5cHCP/d2YSHSvZeqbqBdoUoa4KX1M+p/kdpLuY2A5/z4LBmltJv6w+ZK6V8xIsbXfLQUdpqUvtm1Saej76EhsqH3e3cP0/xzoYvjdxscv5f82KdeNaS7Tl/5QxcuFW4Fc2rPLiSbKn15yWUQnGjQKfu1rtLtIsvc0GZUeY1UIX88gRu16MRNj9yn6rDbiMS9m8yn1cKigkjx7nDuKSxOmCQceLW7vbTE5LE7F72Pu/W+3aGxxO/3Sqyh018ZRgKBlPJYkAec1lweKXjwfa0ll16GaORA5S/PmXK7+vanZR+bZteUzTMXEu47N8OoaTTJHu4DNIZ7iL52uwyiuRgf6WofAg3yiGrGk8r/tJAW6x8ExYNEIU2Tq/klbDhg5cG76g4ABaPWcMpEeh3GzP6vKt7TvrvmbIPGvBGyfqGxQrgNAABu/dc4R1mpJp7j9IqLDRdzmu0AYV0OgyFTi3DgZrNCkw0bVJ8l27XAGyrcGNKE42xyfaWHTfdDXYGyK9lFbWm75VPl3QoiJFLvGuVSJ+zv7RM6HJtJs+bEedXueGxtm94q8i01lEXvW/lFM23zzGhduIEjyYevpiL9q1BzeOk1HGm6kSXhf95r8iWiA1mpUFlMq+gvRZnM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(451199021)(66556008)(66946007)(66476007)(6486002)(6666004)(4744005)(6506007)(2906002)(6512007)(53546011)(921005)(41300700001)(186003)(4326008)(316002)(36756003)(5660300002)(8676002)(38100700002)(8936002)(86362001)(2616005)(7416002)(31686004)(478600001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZUFheWtNQnQ2THhibXhYYmd0TjVmOWlwZW9mOFpGeWFGT0UvdEtRaFdhTzI0?=
 =?utf-8?B?UW9FY2NtU3VLTy84L1BlMDl6dzJLTkwvcm5tTEl2WDAveHVkbnVBbnEzd0Nw?=
 =?utf-8?B?aXVHWkl5eFJkWGJrTzIvU0p4T0oyMTZtUkxXV3hheGRtWTlseTh1N0NVQmVk?=
 =?utf-8?B?cnNybkJXUlM1OVFFRXF4RjE0WURCd3NNNWUzQVVBa0d3QnpnYlZzSk5SWnM3?=
 =?utf-8?B?bmdjM0g3WWEvVGk4a3l4M2E5T05CL2d0UlVBSC9STXBVQW9MbmtjZHQrMTIy?=
 =?utf-8?B?VCtGWkl4b1BLdGtwZEliSjRwSG1Ed215SGs1VDB1UjBGRzFyeTcvelJNd3Vh?=
 =?utf-8?B?UVU3UTFpd0JEVHppQmwzVnJUQnRFbzJDUXk1bUlUc0VkZityYlZXZW8vVGR3?=
 =?utf-8?B?MUgxTmt2b3R3OXJHTTlDU2kxMDlZWVZqeFI0dXloVit2ay9zUjZFWmozQmNp?=
 =?utf-8?B?TVpqUXAvY1V4QnRTWGx3WTh3NlhuejRQdDNzZm9oSm9BZWdra1Q3TzdvdmhH?=
 =?utf-8?B?dWE4bXkwMVRwak9uTGpXVno5QnR0cVQxaHRGL0RsMEU5RUZHODhPM2VzK3hC?=
 =?utf-8?B?Mlo5ZEZrOVZGd09BS0hMV1JoUHFJUzRKVnp2Wkg3Y2loTXh1MDJtenVRZ1BI?=
 =?utf-8?B?UVc1OGlzS3VNT0tMMW1PM1NQQXArS21nS1JKSXBvMFMrcjdlc1VJSzBlMEla?=
 =?utf-8?B?S1UrQnZJQzJoM1gvVHRwbzZDUTNuZ2hJOERLLzd5V2tJUzR0ZW5UWm1paEt1?=
 =?utf-8?B?K0JSaTh5ZkNlTDVaNzlhYU1zY0ZyZmFjcENVTjhCczZrcmVVdk1namNDWGs4?=
 =?utf-8?B?bG9CZjlrTnpmTUt6eDRPSjBscml0V1lKaEhFK0x5MnAyMXJ4dzBkVkpueDdv?=
 =?utf-8?B?M3VaYkcxalJUZlJ0Mm8walFvSmFIRFoyQ3c3cGM0M3poMFcyeVhPM3lDcEx1?=
 =?utf-8?B?SmpLQkk1VHZzdzBxTE0vOVdrb0RJTHFMYXNUVklESlNkRW55V3RXRHNNOFV1?=
 =?utf-8?B?Tkd5c3ZBUW9QY0VMdGZuTGs1a1hXUWJZT2FKT1VTUzhtMitJOTFUNmVGa3dw?=
 =?utf-8?B?N1RhTXNTUkpSc0Z0WXhtWjhIK2J2bGhPZTY0R2tqNE9XZHk5T0lnSFQ0WEJr?=
 =?utf-8?B?R2g3Qlo5enZDZUtNRFNkV3lKdHpuTzR1czBqTkdpZG81N0piUDhaaExPeXdx?=
 =?utf-8?B?MmxnZExJUDIrZm1TUFdDUm5vNm5obUpid01tWEw1WGRWb2dZZXBWV0NzVThw?=
 =?utf-8?B?YmlpekJpWlorNlBxL1VTUmE4M3JiWHhZTlVqczh6cUU1VE1SalYxYysvNERk?=
 =?utf-8?B?NGJjZHR6Y0ZCMnNPRDJDSFNYNmFNSW0zS2xFb2FGSWFJSklIS1hGTWs5UjF3?=
 =?utf-8?B?eTJpVkd3SFo3ekRDZmIzK3c2bEdMVTFzclFWQWxjd3ZMeC85WEdlMmVvWjFU?=
 =?utf-8?B?dVlPQm5oMldQYjE5cFVBSUxzZ3ljRG9pZ0tlRUdmY2lROElXdzNtSmJodUZV?=
 =?utf-8?B?ZnVHYTFtMHBHUXdOQng5MzZtdmFxUGtZeTBOS3MwTG1KMHhmbjBMZHBqTlBX?=
 =?utf-8?B?TFAwTEpTcE9BVVV6d0w4T2lkKytUYlhobjhVSXBDeXpocU43R2k4blU5dW5L?=
 =?utf-8?B?YTFEdEovRUgwNHE2ODZobDUwZHVZdXBJK3JLMmxrRUpQY21tOTl0Y1JWUUtZ?=
 =?utf-8?B?M2VvTWtqMEQvakl4SXlVekZVTkx6T1ZYUUxNQ2lpeGk0UkJZNzNQRFdGK1RG?=
 =?utf-8?B?N2VOa3VKMElSQlhIeVMrSkc2b2ViSVJDLzFHc1NIdVJvUXV2V1V4NFBxYkJW?=
 =?utf-8?B?VUxWZ0ZkVjExTUhXSXdSakQ1ZExNVVBvRk5sdVg3QVVXNW5SbzFxTVRNMWlZ?=
 =?utf-8?B?d0tBamNOT2R1a3VMRE81ODRSWXhQT3FqcllWWjJtSE5kZzZ2TlVqVCtLZkN5?=
 =?utf-8?B?M05MZFZvNG9CRm9tbmEyMTRYQjRibEZUbml1OEllNnpPRGMvZjZaQ3I5cXZk?=
 =?utf-8?B?aHR4RzNOTDZtWFMxazAzdjhVRnQzOTVwRDcyeFcvMjZTRnRMeks2c0dxSUdV?=
 =?utf-8?B?N2p4UHBOZ0MvV29YdSttTDcvT1l1Y2FFTnFFVkhHVEUyMWwwRUtiby9nSEpk?=
 =?utf-8?B?d2tKWEZGVi9RMmIyNkFyb3RhVnlPUUNTUzJPVGdQV2NTalBxTnJmTEY3UEw3?=
 =?utf-8?B?blE9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3db4edd-f692-49a3-1835-08db48050b8b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 16:24:31.0704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: blq1UeQWQpV0fSfSnk/ifHWcXidiF7zTJqpjhF8j0yLzYuHez7rxIVD50MEF75uN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4516
X-Proofpoint-GUID: 0sgBqBUjWPcXkitMhxJb_NCTXyDESGQw
X-Proofpoint-ORIG-GUID: 0sgBqBUjWPcXkitMhxJb_NCTXyDESGQw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-28_04,2023-04-27_01,2023-02-09_01
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/28/23 12:17 AM, Feng zhou wrote:
> From: Feng Zhou <zhoufeng.zf@bytedance.com>
> 
> Add a kfunc that's similar to the bpf_current_task_under_cgroup.
> The difference is that it is a designated task.
> 
> When hook sched related functions, sometimes it is necessary to
> specify a task instead of the current task.
> 
> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
Acked-by: Yonghong Song <yhs@fb.com>
