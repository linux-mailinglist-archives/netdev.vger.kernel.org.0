Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B49B64FB66
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 18:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbiLQRtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 12:49:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiLQRtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 12:49:51 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD19111A2C;
        Sat, 17 Dec 2022 09:49:50 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BHDJJeq002665;
        Sat, 17 Dec 2022 09:49:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=iqp3GkZdp9QUcwbM8agmKDSuJqG7CtujiAKC46nVjys=;
 b=dilYv9uXN4/+6z0qkJC/KtDJA7OsZrgWUE0gohMbaqUaC0NdAx/vA2pgghfji2erM3m/
 0VKywlWMnMP11s6oDGh5wKfI1f3km9bsxcpqIZUMUNSTkHzShcCcP7/hxN/HLXZr8ZZ2
 2ZqBS4qr9LV+k/w5NAtu4Zr9aHWfL7wkC8BTQDwKpJaj2P9/MqC+EadHOxS1mHZW+N8S
 jexR77/nASeo+nPLAbTYtxcaqCKOWevZCcojq/I9hiW7AvJn5Y8RPtHXPO8kVLQY6Sz3
 7B3jEbFPNq5G6n61cTuzZAOXZ40YAQIv77h3asHI89g+Kj1wC2FEiPV7szro9gurIi92 Pw== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3mhbrx8x2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 17 Dec 2022 09:49:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hIt3OZ4jzljAkMrKheid7LXFfQlqC+BQSs7gwOFsQhzuBSYK3ecNchv+XZn9uFNYya5V4VYAtfs6xP9Vhw2sv/MIDGYkO1TkoLQisayFsMDWSZfxzMf2qO/Vrg/lymz1PFnK9dPtLteVHWa9JaXPOC5fryZ7aSkZ6nXIE2pOP13mLsjoGu7tnY3ZaBDIRZIJrEj8NnUjHJJl7oTf+L62d4ejIrkYBvJuHIiUIiVgYH2bBbQ+GYJI18861SaVnZVBAF/6oT4pMqhyBD0vX5VzoL2uzVtHPPCHVtLw/eUSHCUn+VHzEwkx07QsDRthdu85YT2/iwvdW3JcCrn+E/QVjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iqp3GkZdp9QUcwbM8agmKDSuJqG7CtujiAKC46nVjys=;
 b=KXih9Nf66UTHbCkwwW/tVTCNo+Kk+dSBr4SQT1NNa4G5eX55gYao9W7wtgeVkoIN34L972PUq7H3EY/QjUCR21TJ+dN5hyXxHjoialpsggMzedQjzRJmYqqZ3fjrQgbhIcAUIXapA/hT+AGol9Ttbii7iNVINnWdN5dTpZl9ty3H7LkCoMX5aU9lXctGQDzUR5YKesep9Z0cBnWRlkrBaXGAAubDqdcr6Xc772+9T5FegReIs06nulmVVgEC0/9Vg7Hu8ZFnzEZdJO1Jvy63JOpqUHe3rG/lxSzqDhE2grcKw5T3PTd2MF83nCWjVIjH2cEKW1ncanzfWNV8MkAfsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4823.namprd15.prod.outlook.com (2603:10b6:806:1e2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sat, 17 Dec
 2022 17:49:33 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::3cc9:4d23:d516:59f0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::3cc9:4d23:d516:59f0%4]) with mapi id 15.20.5924.015; Sat, 17 Dec 2022
 17:49:33 +0000
Message-ID: <c0d20556-cfb2-ed5e-3aa3-af34bb348b5b@meta.com>
Date:   Sat, 17 Dec 2022 09:49:31 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.0
Subject: Re: [bpf-next 3/3] samples/bpf: fix uninitialized warning with
 test_current_task_under_cgroup
Content-Language: en-US
To:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
References: <20221217153821.2285-1-danieltimlee@gmail.com>
 <20221217153821.2285-4-danieltimlee@gmail.com>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <20221217153821.2285-4-danieltimlee@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0223.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::18) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|SA1PR15MB4823:EE_
X-MS-Office365-Filtering-Correlation-Id: 57bd00df-a083-406d-c243-08dae0570e2b
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sayTfosFq1FyzKRlKET3gVS6dGkIZnh9XGc3mkEMW6/iUBEQUAVOlJcisLTiEJhgya7d6tVWp/asDXmhW7kPCXCS25E+Emn/QPPpiuAL/9jlpLiAz8CSm/fvmbOB5Nw9xvEm+tIu0fmO7pGQlolxwnybL6yBU0kGO3wa/aE0IVIqR1WZZ9gJBqW/ahvk8zerhmw8hJ+bIQ11xamZ4JxluMS265SvJAfCnoc0DT0EWC9VwoVbFpWmLIp4X1l6V93x+3rw3sqTzZBTV1LQifj5IdXbyWJs7cBKljajzpo5RgdIBijX3YvwijqBXoiJ4tyjEhzQCbvuPG0794FvLHS8gA1RNTshYmUPE3mpI+3RXCtt1ckfa32rD+aEBpfI/8zQGNSYJCs1tWiJ9bpfPxfEEg6VIZTrouBPRZZWsKyIX0Vq/8vW/oUvcF7eNqWIQ59HiPxlO91Fn8sLMSZ9HSd2wWdjokceQt0lwdhbUPOC5M5pUGqzcj1JS7Hyhksdmaxd29gGsbD6tOGNRsDLUPivW1UP4tGHBAemZ5Sm3YTHbb0zNEyc9ZtpUpNIXNYOX1uq0LpgojBqIhluYUyyeFhX93lI9eJbNbBGOCFZaz1dHX5yKYGji7quCs1tU88Zdo97WE9riF2i75N9y52uyBfbRCUiKHRapsiBbT4k0dQIaMLfWlU+H6VBiJGaP793dfXF3+/Riv9hLEHJ72yt0ZkdoDpEzmDZ69rBUWUIKcrIwCU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(346002)(136003)(39860400002)(366004)(451199015)(41300700001)(4326008)(8676002)(36756003)(38100700002)(5660300002)(8936002)(2906002)(83380400001)(31686004)(53546011)(6506007)(478600001)(6486002)(316002)(110136005)(66476007)(66556008)(66946007)(2616005)(86362001)(31696002)(186003)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cWQ1UHVwVUswMndlTE15L0xGZU4walBIMW9LS0FxNEpzNGQvVFFnak5XRUhn?=
 =?utf-8?B?b0VVWWpFOGoxTDBiWmJxMDl3aU1KSGZXWTEydFRPQllpcU1vTUxjVjc5Q0Vu?=
 =?utf-8?B?QnBwNyszOWZiZHE2SjdqRy93MXl4aWdWLzVCaWxZVjA5TVNyQ1J0Qm5keldR?=
 =?utf-8?B?dWtTMFg5VzQ3VHNac2didnlGR1A3eXhMY1RYaFFQN2doaEl5ZG5JTEZ2eUth?=
 =?utf-8?B?T0REcWd1OXphYVdMRFU1WHNrc0VzM2ZaR1RyZlYvYTJCeTE2b2Y1aTdTenZs?=
 =?utf-8?B?YzlzQ2UxdkN6YnpORjUyU0NZYmJvT0J2NnRDUjBqRElXQVFQYlZsTUVkS2R0?=
 =?utf-8?B?WTlEakFlaHNDR0tVWWdpOGFmYXd2RkRsY2xXMGk3OXZVZUNoSVh6MWpxU2hp?=
 =?utf-8?B?SVk2NHVUaEVTVTNQWWV4clQvVU9tRExqL0VjTlVXVTdZZmFlcE8rYmRBUHVI?=
 =?utf-8?B?Y1hQV0xHVE82aW9uTldZTHBPVm4zY2xwZ0ZQTlhYdkpqT1BqODlWempoN2px?=
 =?utf-8?B?TzdxWFA4M3c4Qjk4cEFoRzhHdzA4WXRkUklGUGRBUjhPVkRGSmJ3aTJtaS9p?=
 =?utf-8?B?cy9PeG4xNUYvS200TVhiRFVsKzQzUXRJN0pGNXJFTENKNVVhekhaZWtabmhH?=
 =?utf-8?B?cHJXcTFBUThmMUxmTEhYcktZQUZpSCtlcDVSa2FVYkJ1M3h5UUVQNmVyLzZi?=
 =?utf-8?B?V1FLWjlIeWtrSHVPV3lBamtYc0QxSEhVbFZXNHJlL3RUc1hhUjBnREJneHM3?=
 =?utf-8?B?Vnp6ME1yWEJNVWJnYmMyOGd6cFlLRGZsV3dXT1I1RWtyN0pLVUN6WTlib2Rs?=
 =?utf-8?B?S0dyTDdmbUVpdHVLbXN3akY0Qms4cG5oWlppZWp0RjBDd2didlBDNHN0VG9w?=
 =?utf-8?B?Q3VkK2lRc3dKL0VXMnByR3Y1MzlYLzlxMmtvZFpXbTQwRlNtMUtRcFF0UzBO?=
 =?utf-8?B?eXYxVFlzQTB1K1MwWTVFQVgxZkxTTTdvSEtiWTJSUjYyMlVpWkpCaC9pV1NT?=
 =?utf-8?B?M1ppTlZLUG0rUmxXckVlT1JaZWh6bXBBbE44R0hpT2VPY0lJUTZPaDB6MUxP?=
 =?utf-8?B?eEpaVCtBc3F4bldZYXhWWW8rSWYwOHYzNVV4cEkwVy81ZFNXNmdkTGRERXND?=
 =?utf-8?B?aWFUVGo1d3lKZ1lUUzNycjVtb3Noa1k4MksrK0JXVEpoZDQ0eFJ0dnFOMVNC?=
 =?utf-8?B?bTlXMDFkdUtUTFZYK09RNE1yaW9CLzhCcEdCd0tBUXIxYkVvVndybkhxQmNX?=
 =?utf-8?B?WnRnUG40L21MZUlCT25XSk52NEJWb1o3VzROV1lPMjM4UndaclFKT2JmMlFa?=
 =?utf-8?B?Um01ZE42dXB3UzFhd0Jna0hsK3VCL2ZTeUZicnpvTENjUGgvalhkdC9Kc0Rv?=
 =?utf-8?B?dTNvdXU4WnZwU2hNRzB3OElySk1RcVkxd1dSVExGNEd6MXRTdHhBNGc1OVNp?=
 =?utf-8?B?OXVPQnhvaUdKMlFaaGkrM2U3eFdjMHczN05IaE9pTzFXSDVLZ2tqVHZMSzdi?=
 =?utf-8?B?cVpZM0pxQkZDS0k3VHROSVFuaXFRQUMwYnZIRDBpQTNKaWF0MSs1YkdFd0dI?=
 =?utf-8?B?RHVJZVp1ekpwYUVFNS9ndm01eDRoTXdDYmVuWXdKVGhSMUpheXkySE1BRG5J?=
 =?utf-8?B?azIwZ3duS3FZZTVmZkZLS0tyY1ZBSVcyaFhZT3A1eGJTY09Ld2ZYNnRVcVd4?=
 =?utf-8?B?MHdzU25DVlJOaXBiYnR6TkJQSkRGUkZaSEtwM0Y3VUVoQUpqeXlhRHRKcmJ4?=
 =?utf-8?B?UG02c0tYVk9kSk1CZHpTVndHa2ZjNnNWMTI1RzlhaUttTlRTS09GVG1Kcytv?=
 =?utf-8?B?RDU1NkRtelF6SnVKcUxJcEF3c2JSdUZjVmx5NW5tQ2NsdFZQckVidS9XbUxI?=
 =?utf-8?B?aDVyZURkRFAzOW5uWWJqeDRHb3NwVEZuSUd1TERvM20xSnFiaHNqSk13akVN?=
 =?utf-8?B?cHNWbDhXRzZ5UmV5MU42VTdCeGM1SEtGTVVWMitYdzFCY3FhTWFyaGNmQVJR?=
 =?utf-8?B?RWQvcGZkNkh2SENwSFhzaHEyMUtKWjhWTVIvWmVsdXUzRW5QVVU2dEtKLzRn?=
 =?utf-8?B?ZmljMHVJNXJXUnc0bGt1QUlkSW5IRldJNU5WZGtzbndUMXZ3L2ROZ3J2dVpy?=
 =?utf-8?B?WW9XdjBJUnY0N3Fkdk1CU2E4OGJLNXJlMy9qT3BjRjVLbjVuT1hxZkVQZUdh?=
 =?utf-8?B?M1E9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57bd00df-a083-406d-c243-08dae0570e2b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2022 17:49:33.1809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tAzmRriXl21Rlu+yUQZZkherGuPVrzqEBW2Kuaqhh4LwNQA64RBiEHHqSDfDJYh0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4823
X-Proofpoint-GUID: 7gHiayh5Apkp5Cgln8Z_SnENjC53wJ0b
X-Proofpoint-ORIG-GUID: 7gHiayh5Apkp5Cgln8Z_SnENjC53wJ0b
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-17_09,2022-12-15_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/17/22 7:38 AM, Daniel T. Lee wrote:
> Currently, compiling samples/bpf with LLVM warns about the uninitialized
> use of variable with test_current_task_under_cgroup.
> 
>      ./samples/bpf/test_current_task_under_cgroup_user.c:57:6:
>      warning: variable 'cg2' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
> 	    if (setup_cgroup_environment())
> 		^~~~~~~~~~~~~~~~~~~~~~~~~~
>      ./samples/bpf/test_current_task_under_cgroup_user.c:106:8:
>      note: uninitialized use occurs here
> 	    close(cg2);
> 		  ^~~
>      ./samples/bpf/test_current_task_under_cgroup_user.c:57:2:
>      note: remove the 'if' if its condition is always false
> 	    if (setup_cgroup_environment())
> 	    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>      ./samples/bpf/test_current_task_under_cgroup_user.c:19:9:
>      note: initialize the variable 'cg2' to silence this warning
> 	    int cg2, idx = 0, rc = 1;
> 		   ^
> 		    = 0
>      1 warning generated.
> 
> This commit resolve this compiler warning by pre-initialize the variable
> with error for safeguard.
> 
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>

Acked-by: Yonghong Song <yhs@fb.com>
