Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF0C66F0066
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 07:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242818AbjD0F2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 01:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242808AbjD0F2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 01:28:17 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C312D53;
        Wed, 26 Apr 2023 22:28:15 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33QLZbdM028268;
        Wed, 26 Apr 2023 22:27:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=+FHprV7SsPWsDcUPH4cYSfzxfVPxebzt+3mjxp0twJY=;
 b=J7ghD2MFUeWyV6a9gzvK5G2sV32NIyTImnYK5S6tOn5PTo/ZYKgl1KnG04m+S/YCsLOB
 7lOYZiK5/zkjWvQYMcNN2rgriIXbmdbyzkKS+/DJsoddEUP83DO/rHjqXFsomaIyHDgV
 NWdWxNbRDt9pON3pATeYq9is6bXe+eani1Iq9X/CMq4pBIlzamfvx4bJ9RGb88CU5ptJ
 tgzokVWRupkzvwwLrNea3X8zFJVEEkVayCEGeb2Riqu8LqDMdv1e0yIkHjGhuOturt0D
 yyR0Er7fHskKB2MD5CXUFMbcQ+lhoqXKwgauQuvZuXOoFDBIV2pjiXNXmlsXJfwSBffU dQ== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3q749m5pxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 22:27:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I6RU42LxwxkhiI0rPeJmUkrnKY8yNHqy6MZy4G7VE3hLxNGZhjJ2WkiJMMOXSvIEdj3MsENhpvLH6ZYSOyMgMFgOEUaFInHZoOZhsM1UZiEdUwLm4CkS2FGYZdOtJMRyJLQcmpjLyEDAzTm/NnJDbDjzh+niE/qKvJwx9BUQRvVhieUcE9XZhYL/w61Nh2rQj8dySq0mBjbrOzOELbItyjil8GHqouDX8LsLOilp6jbcb/YemXukJgxZfmMhzbMDY1kn+wuDEX/pKTr2ZZXGAPbLoF40f3AESSF783xz81dXJQ3TkU7HS7/fua0oAcQ5F3qaqle5zSP1PuOEfSwlkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+FHprV7SsPWsDcUPH4cYSfzxfVPxebzt+3mjxp0twJY=;
 b=BxE7pMBRIkJnu/RCjsuR5I3rOlj+OFrod7Uv0ZU+AynOYctZyu5ExRXWaq+7vc52V+79Xhpsmdv6oDOR4ONjoWVMj4FR6CCiFXJ6h/tPMJl6DOqi7uqMNfpSVhJu+qwG4ucTPWu3/M/z5td5ybDD4phxgtxXb79ojUYJFcipPhFOY8hEGsn25xQInwi6jaL5T28878FCL5Xdlir8tfSpQCTvIP8MF201k7ChYO9Hw1/wY9GeM0oBUAmEaUzV7v4+rLIKu6hYOqgiKy1Uy2dVnMOFWZ8OWv90ZKk0ELXMSJQtqDINNEPjQJDyfquOxfmS6vVtRS5r9zNbmvcCuJXwZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BY3PR15MB4834.namprd15.prod.outlook.com (2603:10b6:a03:3b5::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.22; Thu, 27 Apr
 2023 05:27:38 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::589f:9230:518:7f53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::589f:9230:518:7f53%6]) with mapi id 15.20.6340.022; Thu, 27 Apr 2023
 05:27:38 +0000
Message-ID: <273ef34f-3a67-64eb-e772-c46c390bf2f4@meta.com>
Date:   Wed, 26 Apr 2023 22:27:32 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH bpf-next v3 2/2] selftests/bpf: Add testcase for
 bpf_task_under_cgroup
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
References: <20230427023019.73576-1-zhoufeng.zf@bytedance.com>
 <20230427023019.73576-3-zhoufeng.zf@bytedance.com>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <20230427023019.73576-3-zhoufeng.zf@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0196.namprd05.prod.outlook.com
 (2603:10b6:a03:330::21) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|BY3PR15MB4834:EE_
X-MS-Office365-Filtering-Correlation-Id: ab0aa526-f8e3-4752-4665-08db46e01cd0
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4ZNFIrmWvYtabPR1uqV5SgQqumMGtjLV9mPbUCq4R65RdCjCyiopgltxHtZWe4S6izp94o1pbf0umHBG9GyOjduKgO75WChHnJoFO4q8yZNu1+MRGnVN39arOwgP9kSzl/U5ih/D8XM1QJodSfi7JAgPCbID+ovIm9QG+0JmnTqOW9eECN1/9fzioq0RYkGJ/81QqJoEbNcg3IWHVwKRshop7AG6VYJ36+7vo6nh5oxNGTkJYNXO4C3RF2Y0DcYkyAzuZntO7tVKqaOObT/d1wIsYjLwWlwfU/nRNkWKebkBOQJIfqJJD8Gp9IAENjXwlJvwyOW/J5EVNpQG/8rpBuD8idpioL7+KTikcPmokGrPgzVr7PEMV1fBJ6x/SR3RWJANOF7usEwyn8P6u/cWqAFYZguAx+OquPADKRLDNuajX8lHQTLiG09vjDtuGzdCY1FyPrLs9pFsxSf4LrfQrV9kD3f2N9Tsq2lfymtbVnHBSdje2huqWMyDN6MfSoiK3Qx7fRXnQLbV5TSGGQlYCKyYBtcbelYpJAxLRuIlsHHvhGP7XEFfANg/uXkW8i3ARJzmNBeD+MYtGx9CpdUMXhVxdFVR9eVn2RP+EtzdIhCTYXhlyttrfIa2DV5mz6YK57e/fJU447bjaEUmBwm8HwbAPgahRqGDa9lAuivgGMc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(39860400002)(346002)(366004)(396003)(451199021)(6666004)(6486002)(478600001)(83380400001)(2616005)(186003)(6506007)(53546011)(36756003)(6512007)(38100700002)(31696002)(86362001)(921005)(66476007)(66556008)(66946007)(4326008)(316002)(2906002)(7416002)(8676002)(8936002)(31686004)(41300700001)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RENsSkJrbXgxY0xQZWlJUlVZOGRBOTNIRzFzbXA4dHZsM1VhUmpqS3Q0b3ZW?=
 =?utf-8?B?NU0ybXBDRnp4d3JUT0ZZRVVwc3Q3OGdKU3Vwb3dycnQvcDJCMXZlbHR6USt3?=
 =?utf-8?B?VTlmNWpkMkorSjBjbHlZMGNoMDFiYUZDL1d1ZDFKam8xckZNUHZMVzBYZDQz?=
 =?utf-8?B?VkxuZTN3T3ZlYmxCOVRjbC8wOVg3K09mY0V4eGZydkZieFlzVlA0T1FDQVRn?=
 =?utf-8?B?cm00akFBQnRqWDAxN2hNZ3FTMFNTeUxaQ3JHRTRmTm5pTU9hQTcvUlZNbU9U?=
 =?utf-8?B?TkVkZzN6Rk9FVm53YlRselBadThzQnhpbmM1ZUdBK1k2Y0duUkJxc01kZVpS?=
 =?utf-8?B?VGpTSStuci9rYVJoczRxZDdJUXV1ZlYrZVQrRkJ1Mm11UnpaYmxUYjJub0NB?=
 =?utf-8?B?L2Z0dlNPSndpTWVXMzQ0aG1Tb0hmdFNPd210NmhUdzN2YnNPcGxzdk9BZEt4?=
 =?utf-8?B?b1ZlODRXL0pJaWlCYVFMWE0xMWdpdkt1K1FaRno5RHpPUzRIQk8zUGdCenA2?=
 =?utf-8?B?aGhvSVFMeC9SejRvcFVPdEJuN1IzMUlPMFJ6Z2FnT0pWRHNrMERNSFo0S1pr?=
 =?utf-8?B?c1kvQkR0cUpEb003NGZwdjVndnMzTHFVTHUvSjd1OVJML3hxK3NuYUFQcE9G?=
 =?utf-8?B?Y3VxMWhKUXkrV215ZUFlMWZqTXZNR3FnR1QvWDk3dUt0UkpqVEJKR3ZIYW01?=
 =?utf-8?B?NDJzU1pBR0NITFZuN1d2NlJUSUY2V3VqZit6ZUdFTGFINEsxcEkyMXdWeU82?=
 =?utf-8?B?VE5KQVpaS2hPTW15RU0rckhDVDlEVlloN2ZVVUpacWNaTEszOVgxTENPdDI1?=
 =?utf-8?B?eUdnQlJiaGZvNjFDN2g3bHZqQnZxcG91Y2Y1RTB5SWRjVHFVNnVXR0JsRzVk?=
 =?utf-8?B?eENVNUQxV3IrYTg3dElkY21FVW81NEdWZTcrU2FwSW9WSlVWeUlrRHluOXlD?=
 =?utf-8?B?R1A1QlRjTmFjY3dYRkYzVUdzTTVPdjZlRnE0MCtiNUhIckpKdzc1cHBCRnBo?=
 =?utf-8?B?dExnRkNITW1mZFkzVC96Uzd3aGU2Mjd5QVI2YlVoOUU0L1BHbVE2a1VwZFlp?=
 =?utf-8?B?ZVZVSkJnenF5c0ZhUnpsZkZHZFdvd2xzdUFYMzJ3SUxLenBxZ0JzMndYMTBh?=
 =?utf-8?B?TGdRZ1d4OWJydXNUSExHVzlwUHQwcHlBN2U4Yjc1c09LYzRPMkZzNWVuZ1Er?=
 =?utf-8?B?RDZIWVhYNUdRVjdZWG5tSHgyanJNS0F3SlU4M3FKSWs5T3hhSEdBd2dEcjhD?=
 =?utf-8?B?NEFPb0taazN1QkJHWlpXUUIvTkxxaUl3Yy80R2cra0pwMTJDUHUxY3VFWjEr?=
 =?utf-8?B?M1VQUUNkN0JPS0RtSGRkbkg5aWY2WHZaN1VZSmhxYzRuRk5idW15d0wwSU0y?=
 =?utf-8?B?RjMrZzZ2ZlpaQmpLTkNkT1RKdkRKZE1oRDd0TVVIaTBmaXJpM21jalozYzB6?=
 =?utf-8?B?bFVmRnMyUWwwMjIvWmxVK1ZlaWxPbWdNR25Bb0ZhS1cvMjRyRGRVTTVKcFc0?=
 =?utf-8?B?QUo5RWtlNWpCM3JUcnVkTFNYbThMMHdvQnFHNGNDTCtzNmtZZXpoMTY3MlQz?=
 =?utf-8?B?Z0xDYzVTUHI0UUM1MkNwNGxwd3RGN1ZCWnVadFBDcXFnZE1SNjM3RkVYQkYr?=
 =?utf-8?B?cHdTNmlOR2doSVVGV1NvQmcyMmFiN0dlWXVUMlgrUzNra3hIWWI2bXoycVlN?=
 =?utf-8?B?anlMRUZnakQrSUVpRDRhZGNSamVoQmlaNE8xNkRSKzJCTVdaS3Z5dGJ1eXRm?=
 =?utf-8?B?TmFOdUhFYy9zUlN1b0pXV1dEN0RnNWlKWEV5VzR0R1ZwQ3FpUnhZZFdjNGdh?=
 =?utf-8?B?TFN4dVdzbDAyendrMmo4VlI0cEZYVEhTOU1xeWIwd1VkdE4wTzV1aWRDd0Y0?=
 =?utf-8?B?OU1va2l6U0JmMGd6QmVYWDJ3M1ZMZythTnA3dEhFTG44K1FhYlZjUFRFdHI4?=
 =?utf-8?B?MlRYaWRRUTUzczRyZDhwalZEa3FsVHo3bEZzK0xkcDVvUTVHQ0hWM1hDNlVE?=
 =?utf-8?B?WWtkTUxRMlROSUo2TytGSW1uWndLSU9XRkxJTytHaldSWnhxeGNKUlAvdndH?=
 =?utf-8?B?ZU0vcmFYTDdhWVFTQVoxWjZXMWY2QjR1RmRDd0NHeDUwRE1SWUgyL0pPeHJB?=
 =?utf-8?B?bHp3ZndwNmI3YjhSUys4ZlFBUHJPVC8yenBTSk9sSFZWa2YrNzVEMzdTVm5Z?=
 =?utf-8?B?dkE9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab0aa526-f8e3-4752-4665-08db46e01cd0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2023 05:27:37.5102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j8Hx95RVnYCov9hDk0hwQOmQRMflB/6TV+HsHc70L7XysYrkICmBPl66MwK0YrCG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR15MB4834
X-Proofpoint-ORIG-GUID: To76SNfoERNAkdB3DpMYtFE3lBL3nM06
X-Proofpoint-GUID: To76SNfoERNAkdB3DpMYtFE3lBL3nM06
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-27_03,2023-04-26_03,2023-02-09_01
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/26/23 7:30 PM, Feng zhou wrote:
> From: Feng Zhou <zhoufeng.zf@bytedance.com>
> 
> test_progs:
> Tests new kfunc bpf_task_under_cgroup().
> 
> The bpf program saves the pid which call the getpgid syscall within a
> given cgroup to the remote_pid, which is convenient for the user-mode
> program to verify the test correctness.
> 
> The user-mode program creates its own mount namespace, and mounts the
> cgroupsv2 hierarchy in there, call the getpgid syscall, then check if
> remote_pid and local_pid are equal.
> 
> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
> ---
>   tools/testing/selftests/bpf/DENYLIST.s390x    |  1 +
>   .../bpf/prog_tests/task_under_cgroup.c        | 47 +++++++++++++++++++
>   .../selftests/bpf/progs/cgrp_kfunc_common.h   |  1 +
>   .../bpf/progs/test_task_under_cgroup.c        | 37 +++++++++++++++
>   4 files changed, 86 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/task_under_cgroup.c
>   create mode 100644 tools/testing/selftests/bpf/progs/test_task_under_cgroup.c
> 
> diff --git a/tools/testing/selftests/bpf/DENYLIST.s390x b/tools/testing/selftests/bpf/DENYLIST.s390x
> index c7463f3ec3c0..5061d9e24c16 100644
> --- a/tools/testing/selftests/bpf/DENYLIST.s390x
> +++ b/tools/testing/selftests/bpf/DENYLIST.s390x
> @@ -26,3 +26,4 @@ user_ringbuf                             # failed to find kernel BTF type ID of
>   verif_stats                              # trace_vprintk__open_and_load unexpected error: -9                           (?)
>   xdp_bonding                              # failed to auto-attach program 'trace_on_entry': -524                        (trampoline)
>   xdp_metadata                             # JIT does not support calling kernel function                                (kfunc)
> +test_task_under_cgroup                   # JIT does not support calling kernel function                                (kfunc)
> diff --git a/tools/testing/selftests/bpf/prog_tests/task_under_cgroup.c b/tools/testing/selftests/bpf/prog_tests/task_under_cgroup.c
> new file mode 100644
> index 000000000000..6d5709a8203d
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/task_under_cgroup.c
> @@ -0,0 +1,47 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2023 Bytedance */
> +
> +#include <sys/syscall.h>
> +#include <test_progs.h>
> +#include <cgroup_helpers.h>
> +#include "test_task_under_cgroup.skel.h"
> +
> +#define FOO	"/foo"
> +
> +void test_task_under_cgroup(void)
> +{
> +	struct test_task_under_cgroup *skel;
> +	int ret, foo = -1;
> +
> +	foo = test__join_cgroup(FOO);
> +	if (!ASSERT_OK(foo < 0, "cgroup_join_foo"))
> +		return;
> +
> +	skel = test_task_under_cgroup__open();
> +	if (!ASSERT_OK_PTR(skel, "test_task_under_cgroup__open"))
> +		goto cleanup;
> +
> +	skel->rodata->local_pid = getpid();
> +	skel->rodata->cgid = get_cgroup_id(FOO);
> +
> +	ret = test_task_under_cgroup__load(skel);
> +	if (!ASSERT_OK(ret, "test_task_under_cgroup__load"))
> +		goto cleanup;
> +
> +	ret = test_task_under_cgroup__attach(skel);
> +	if (!ASSERT_OK(ret, "test_task_under_cgroup__attach"))
> +		goto cleanup;
> +
> +	syscall(SYS_getpgid);
> +
> +	test_task_under_cgroup__detach(skel);
> +
> +	ASSERT_EQ(skel->bss->remote_pid, skel->rodata->local_pid,
> +		  "test task_under_cgroup");
> +
> +cleanup:
> +	if (foo >= 0)
> +		close(foo);
> +
> +	test_task_under_cgroup__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/cgrp_kfunc_common.h b/tools/testing/selftests/bpf/progs/cgrp_kfunc_common.h
> index 22914a70db54..001c416b42bc 100644
> --- a/tools/testing/selftests/bpf/progs/cgrp_kfunc_common.h
> +++ b/tools/testing/selftests/bpf/progs/cgrp_kfunc_common.h
> @@ -26,6 +26,7 @@ struct cgroup *bpf_cgroup_ancestor(struct cgroup *cgrp, int level) __ksym;
>   struct cgroup *bpf_cgroup_from_id(u64 cgid) __ksym;
>   void bpf_rcu_read_lock(void) __ksym;
>   void bpf_rcu_read_unlock(void) __ksym;
> +int bpf_task_under_cgroup(struct task_struct *task, struct cgroup *ancestor) __ksym;

return type 'long'?

>   
>   static inline struct __cgrps_kfunc_map_value *cgrps_kfunc_map_value_lookup(struct cgroup *cgrp)
>   {
> diff --git a/tools/testing/selftests/bpf/progs/test_task_under_cgroup.c b/tools/testing/selftests/bpf/progs/test_task_under_cgroup.c
> new file mode 100644
> index 000000000000..8f23a2933fde
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_task_under_cgroup.c
> @@ -0,0 +1,37 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2023 Bytedance */
> +
> +#include <vmlinux.h>
> +#include <bpf/bpf_tracing.h>
> +#include <bpf/bpf_helpers.h>
> +
> +#include "bpf_misc.h"
> +#include "cgrp_kfunc_common.h"
> +
> +const volatile int local_pid;
> +const volatile long cgid;
> +int remote_pid;
> +
> +SEC("fentry/" SYS_PREFIX "sys_getpgid")
> +int sys_getpgid(void *ctx)
> +{
> +	struct cgroup *cgrp;
> +
> +	if (local_pid != (bpf_get_current_pid_tgid() >> 32))
> +		return 0;
> +
> +	cgrp = bpf_cgroup_from_id(cgid);
> +	if (!cgrp)
> +		return 0;
> +
> +	if (!bpf_task_under_cgroup(bpf_get_current_task_btf(), cgrp))
> +		goto out;

The whole point of using bpf_task_under_cgroup() is to test a 
non-current task is under a particular cgroup.

Tracing kernel function enqueue_task_fair() is an option, but it
may be inlined with certain compilers as enqueue_task_fair() is
a static function. Also, the 'task' argument in enqueue_task_fair()
is not trusted, could be null ptr and not rcu safe as well.
We could promote 'task' in enqueue_task_fair() by:
   - checking NULL ptr, if not
   - increase reference count by 1 if current reference count is not 0
     (using bpf_task_acquire kfunc)
   - if reference count can be increased, it becomes trusted, and
     then bpf_task_under_cgroup() can be used.

Could you try this approach or even better if there is another
non-static function also having a task (not the current task)?

> +
> +	remote_pid = local_pid;
> +
> +out:
> +	bpf_cgroup_release(cgrp);
> +	return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";
