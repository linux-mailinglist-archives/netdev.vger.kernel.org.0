Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E842618407
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 17:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbiKCQSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 12:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbiKCQSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 12:18:02 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA2F18363;
        Thu,  3 Nov 2022 09:18:02 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A3DxRcu009985;
        Thu, 3 Nov 2022 09:17:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=logG50yn8EIy+gwID9YStxOqQiMZfE9M2ioY4cqXbGg=;
 b=gk8bmprUSSm7lmBJ5wXAjoPKp9UJpGFQT/V8DWKG4q0NnmKxYHLNZgamkbIBANfJTrsS
 X2UrbhufRSO1iRQ4siovYkmQH+koN45Zvq0YOu2eAfc7Qck9+nvSZnrM7wZv0JjvnayZ
 3t7lH8Rbb3YSGX9YTJtC9GounS4+mu7+FYaVeXA6iS03In/ytDKACrOZkZPzOZWHECKW
 fng5oRe99JJqYRZklKMwhfQAtAhZvpcgLsj3cSND2qDvUys+pSU5fAR9lfbHYgwdfKIi
 d0LIvhbqolAkc8839spbXXvGOu+scNC/pf6xTBR/aIqTR4TE4bz4PCCNMng+xyQe374p ow== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kkvcwjnby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Nov 2022 09:17:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jvfu6U4EIbGlkm56v7N1jTYcF8RTi+OQ9euAxMb2Cb4M4qx9QEwjiDlgLMP7EJbxFJw0Lu2OL9TZ8gdt8CqM8AlaFphoYzW2t3hnARiwLYc5vHnw2WkIBuaH3j9ojwSeHp3J68Y4CtPMtFKM+EGkwfP/EBWgarWSYhu6qmzA5q6OgKe/cS/SsarmfnBfjK41heHVXJvRkTCLCf0cJzc2WL67zT5rbWfV1oXwLXedCrN3cggHoLV33/omVvtle6loCcN1io/rzLp/PjHhGByAAv9oygb59C8zpAKU3lVU8I/T0D2BmdNbZapicNscOoOtwdMDvvaCQ7ZEIHT0fGEHZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=logG50yn8EIy+gwID9YStxOqQiMZfE9M2ioY4cqXbGg=;
 b=jx/lanwKAEb2cvuzfj/xOlXU1CVvKWtzxNis9xMJrBaxFLJYUuC+j9qTHg2YZm28JjuO0jwhDO9MLGztl7LZas6Q+5j9D6GlF7KNZQxvEjAfo4Bi6rHqr2oR7BvQvx8mYHFkTxiu+/OsOhCxHhKYQwEGPDkKR1F3ck9/WP0C1OqHyGXE+rgCRORZ8hDY5fUHL5PbBOWbt9biBLoznBVfTcnI8ON/E0f0hOrTnPj+Gu96kc5zPFx8KfEwBTXL+l1zsqVjPhnK4++mgH2bf8uBva7eH0LpKZtQ/zb2KL49wSGk1dbqlRXcGKcirmBfXVUNVZh97gCh5EV93/wnBNbg5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM6PR15MB4072.namprd15.prod.outlook.com (2603:10b6:5:2bf::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Thu, 3 Nov
 2022 16:17:45 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::1f2:1491:9990:c8e3]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::1f2:1491:9990:c8e3%4]) with mapi id 15.20.5791.022; Thu, 3 Nov 2022
 16:17:44 +0000
Message-ID: <1db13bff-a384-d3c8-33a8-ad0133a1c70e@meta.com>
Date:   Thu, 3 Nov 2022 09:17:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH bpf 1/2] net/ipv4: fix linux/in.h header dependencies
To:     patchwork-bot+netdevbpf@kernel.org,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, kuba@kernel.org, kernel-team@fb.com,
        gustavoars@kernel.org
References: <20221102182517.2675301-1-andrii@kernel.org>
 <166747981590.20434.6205202822354530507.git-patchwork-notify@kernel.org>
Content-Language: en-US
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <166747981590.20434.6205202822354530507.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: SJ0PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::25) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|DM6PR15MB4072:EE_
X-MS-Office365-Filtering-Correlation-Id: 41a1981b-320a-4a17-e7ff-08dabdb6f0c0
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v4aJsGTlbnaX6f/57tdBsGpJ+w9ESU/UqbXuDTx6qrs7WNdQ4AsSWbx5EhTOC2+VYufSqptfce6RpPBIM7wo7Jwen2TexZBwhgT4+9Ard09Bi9odo/P80Rl5CSKr06bJKFlDxXLBbhTih/5beM+n8jdAe/Jia3qALZuHcs/rIrA81c6mUgPBjkjMTSM6tO8sajDZw6ACVH5L+tNoUy7MWHKKU1IyDULpefHNCm3vO6LJskg3CDjKZV5OhWdi/Luapblq5A7qinQPd5iWOcTsQjxcX/dBfEdJL4f5kTuwpDyy3pQAK3QbC0dSC1zQcZiPonJIzSKARMgp7/rnuYAA5ZKt3t/sbwxMfX+vBZtXIFMje4005bGIIuYfk9YHEc3azRjVWiyAy63FJ27d/8ZQy83DhRkRcy6LILnDztnwfpy3+Se1+jnkyE5b4cbT1/aXMkUxIQFowTKVl4ncgaAD8MdeQPpg17s7SyDEMtdQe4wNe82ZRgi+xaei4ak15C5UERc48uMmhUEMey5GXTmb/3pDmBPbaQ+v1+iU1nBOHlNEfDwXNEAMU+/jpBtfFWEMP3naoMbLcBiw6HY47O70GD1vse0eJFbkHDdrMUyM4Fy+VR7uls+b1vBIfETAsUqKz2CsZt2aa7z/4Z6HaXc+Y/pTTa6KUZ0Kfjr8zLMpKTnLRS3b6Bh3guefL8kPrsQ9GBXlu/D/md9+RpE4vkLyx+snW/FsGV45HQ81c4gtVtzkm9Zbzyx2t/nmO80vZLNpN3yLbIkZH0Vd9EaIUtH8myOXbu1DO04IDNLjXpAO27cTB74YXFaaQOD/nMTekrn1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(136003)(366004)(376002)(396003)(451199015)(6506007)(86362001)(41300700001)(6512007)(8936002)(66556008)(8676002)(66476007)(66946007)(4326008)(31696002)(53546011)(2906002)(5660300002)(316002)(36756003)(6666004)(186003)(6916009)(2616005)(31686004)(6486002)(966005)(38100700002)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UVJ0NXMzcnNRWVlRQmZLM0Z2NGNBOWdnTEk2aGFpV2QwMEJGTlFKSERCUENE?=
 =?utf-8?B?bjhPdzE4SFd2S09ycGx6OWJkSDdUbHlyR01RL3RibHlLT00rT0I3eC9qL0hD?=
 =?utf-8?B?Zm0rWDZSblFUUDNYdEFwWk9OcnN6UytwTXFwMGNTa2NobWxJSlFkWk54ZWoy?=
 =?utf-8?B?SEhJdHpmVzVrdmlTNlh6VmlwcG1kZTJSZTdaWWxDektWd2o4Ty9TYnh6VGhu?=
 =?utf-8?B?SlhISFFYVzBoakRCcXFxSmRwcHVqRlcyWnBzUWt1WVIvMmw3djVBZmovS0hJ?=
 =?utf-8?B?b2xnOGNJR1dsaUIrZVdyL3E5ZGZySVdZV2I4U09SZGMzZERwVEt0UGxyeldl?=
 =?utf-8?B?RzYweGRpT2c4RVpDVlVqVll1cVhjVkRCSi9sWDlOMmFXRHhLUlJ1SXd0OXJ0?=
 =?utf-8?B?NEFmbVBoQ3lIeEkwUWpPK0tVZG1pSldTOE5IR0hWTHVjS3Ayd3lsMWNVTks5?=
 =?utf-8?B?L1VKWnZ0TGQyejVScnNVT3FnZ0NmajZyZCtyd29UaW1PZmV3WVA2ci9yOWpS?=
 =?utf-8?B?THE4SlN6TGltTDlCcDdoT0JHRE5rLzBtU1ByUlQrVjdkRWlJV3EzOUUrUmZo?=
 =?utf-8?B?bmxIaDljOXZwOUV3d0dQT1UzVUZ4eWJZTlVOVmZ1OG1UaG44VHk1bklROW1o?=
 =?utf-8?B?OGpsSkV3K0dzZFlZSVR1Nmk0YVoyKy9OOWc2UGxiVEtQQlJKQURnUjk4TUsy?=
 =?utf-8?B?WHZTb3dJRGJYa2xpbld1b1M1ZVVYSkIxYm1NNFNKUko1UkkvK2tNNmkwZXg4?=
 =?utf-8?B?NVFTWUY5S0NuVGtudGpvM0EvOW1zamdMczFLWGlQVFV4WXVLNndWZzFMc3E0?=
 =?utf-8?B?VGpmNjN0TW9DUk0zS3IrdTNhT3lSNGRpOHM1SFAvOXJUN3dzeVVyQk9QNC9R?=
 =?utf-8?B?UERTYVgrNFdyQVZYLzByalhnYng0OGlQaGtRbS9WY2dMbUhzbUM1TFhtNTRY?=
 =?utf-8?B?RmRZODdUZ1pmTGlnUXh2WFIrMm9EYVBoTGVabmUvbW5IMFUvOEJlcU83Q2U5?=
 =?utf-8?B?MEpQTlEyQURCZVlXOVQxd1VMOHRrQ3dxK2FDcFc0dnN3alg4Ukk1WFZMZDdm?=
 =?utf-8?B?cE5keENWTmtpd2xUTXVtcTEzZGJ3MUV2TUtqVGR6MllQQUlhc3pWR1pVQW5z?=
 =?utf-8?B?cjZkYWlTUXZTQWFWVE9hZjBzbml2VHVvL3IwUjgxYzJDc0NTRzU4SHVJdUk5?=
 =?utf-8?B?bG5qelZndG40OWZNaUR0MWYxekN2SlBlaTV6djhZUnFuLzFjMVRzbForWFZr?=
 =?utf-8?B?SjRmclJydk5BV1dselprRGk3NUtxdml0T1R5NFBMajBmR0l1RjNnSkI2Z3Q4?=
 =?utf-8?B?TkxJK0hyK1ZXbkhXSFdyOVhUTVVWMTFKWFRtVXpXZ21mVE9HaVpwdHoyZVhk?=
 =?utf-8?B?YW1YWXlaR1ZlRGhZUnB5ZmtTYTIxSkpjVUlKMTRaZTV6a0ZvSkt2Ry8wUnR1?=
 =?utf-8?B?dmVPakZoWGZDUzI3MkUzeHVlbjBpa1d0cVRVQ2lKVnBOMjAvY0ozSmZJKzc4?=
 =?utf-8?B?RjIxeFBEaUlXVVJ1UkdRdlo0UEN6dGlocVkwdDFKdGh5bnR3U3ozbjhuT0hj?=
 =?utf-8?B?dmViVlFwQmhZVTZKWnhsNmhnQThxdlRlY21SQ3RwdGxrWUFUdzNsT0lQK1lC?=
 =?utf-8?B?UmtUQmxIRElHY0hZdDNJdm1zSkFRTCs2NFI4NWs3ODVOMlNOK285c0pyWm9y?=
 =?utf-8?B?NG5ySXppU0cxaGV1QkFDa25pTnVYNGFQTk8xQlp1TU5yVEEyQzRpU2RYampR?=
 =?utf-8?B?eG1aSWg3RU1nSUxmSjNUUDZPYWY1alViTEVmakMrZWZuYnVKSUhhMUFud3Rl?=
 =?utf-8?B?cHU0ZjRUYzhpWGFlOC9sV04xY1NMcE1nZHZEN1lGS1JKcllLbnpUUXFBOFNU?=
 =?utf-8?B?a0VHS2FrQ0FtaExDVktidS8vRWhyVkxPL2l6Z2VvYll0ODdqdmluZWYvdFV5?=
 =?utf-8?B?bkNVUTBmdnVrREtLU1RhYktzclVGWGdWVmxLa29RdHdqelVielJRdFZqYktu?=
 =?utf-8?B?UFc1VUdXM2Q5UFAzMVRJNnRGZ1lwaU1veitSZGFaU1RJWXBodFZqRlVSZXFG?=
 =?utf-8?B?c3JrNlFyeHRaeExYc2cyYVp0TGpIL2xHb3c4dEE0Z1QwaE4rM05QU1F6dmlB?=
 =?utf-8?Q?PATpquMn4RHuvbd6crYnEfSVK?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41a1981b-320a-4a17-e7ff-08dabdb6f0c0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 16:17:44.8624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ffqBRWrqIbaK7m8beZshwZgkEBpnhDQDRBf1CTTfgcsPXMfIwdlhKfiYIBt8YZnQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB4072
X-Proofpoint-GUID: s1wkHBCgy_MoI1mTbRA3v2CYjWvjGA_k
X-Proofpoint-ORIG-GUID: s1wkHBCgy_MoI1mTbRA3v2CYjWvjGA_k
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-03_04,2022-11-03_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/3/22 5:50 AM, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This series was applied to bpf/bpf.git (master)
> by Daniel Borkmann <daniel@iogearbox.net>:
> 
> On Wed, 2 Nov 2022 11:25:16 -0700 you wrote:
>> __DECLARE_FLEX_ARRAY is defined in include/uapi/linux/stddef.h but
>> doesn't seem to be explicitly included from include/uapi/linux/in.h,
>> which breaks BPF selftests builds (once we sync linux/stddef.h into
>> tools/include directory in the next patch). Fix this by explicitly
>> including linux/stddef.h.
>>
>> Given this affects BPF CI and bpf tree, targeting this for bpf tree.
>>
>> [...]
> 
> Here is the summary with links:
>    - [bpf,1/2] net/ipv4: fix linux/in.h header dependencies
>      https://git.kernel.org/bpf/bpf/c/aec1dc972d27
>    - [bpf,2/2] tools headers uapi: pull in stddef.h to fix BPF selftests build in CI
>      https://git.kernel.org/bpf/bpf/c/a778f5d46b62

Can we put this patch set into bpf-next as well? Apparently we have the 
same issue in bpf-next.

> 
> You are awesome, thank you!
