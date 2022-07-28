Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77C9958383E
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 07:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbiG1Ftr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 01:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiG1Ftp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 01:49:45 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5198411C37;
        Wed, 27 Jul 2022 22:49:40 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26S17jsl031283;
        Wed, 27 Jul 2022 22:49:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=3u1B/s1jVJDivwf5I6G9vDD6/mhREUwr65pUQdRlKtQ=;
 b=ZJnjmhrWvgMce4N5pYXKU+/5pWQD5/2MbqF+5Y+lcBcGsuVeS2tXbdOfCudXjk+m1cTa
 B9CbcFvra43XSJoaJURRmmaYWMGE4UfwEywRnMoN0x+f+4pATze/SkUkk7BHcbu98dTr
 e23PoxmRSJRhFYtJmROaigsT330CzAISDh8= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hjjnsw31m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jul 2022 22:49:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JBzST1zQ07LEk5D4ZPpf+CuYxuNaKFMPg/2C9HUiHnVc0W916dskAqXDpjXqOuIGIc+KqxwL+yJktXrnaM49KjSY4ogOcoUcduH3MQUqeyjacmvtiH7aCQdyxiwqmYTq0Fqe3bQWYE0RbVJ7XBsxujHCI+WgcQDp/PVQ//y/bbVdZsjvcS1KS6xvH13RzFxY60249ilfXOYbuA2HIgOGVyUK+bYHsuM+qa/033OW8srWXNoXKarK2mHqY1aCkjTtKaC/TTrBOhQrttOYxCX5wlXqpsFcWyHV1YwUlcZ+F31XxUASOqHKlMIL3BUvhC2qWldfmlxTCLc4zGrrpRq0ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3u1B/s1jVJDivwf5I6G9vDD6/mhREUwr65pUQdRlKtQ=;
 b=hJ9PJFRbfsw0N8JYOAv6MpKoKnfbXdRp32NjsMLG73dA8jpTlnGVbvMdkGr2u0P6E3HORgghigolmii5weFTksvHqGOwnu+i//Yu8zylPisgTJmHxhXs9I9urb2m5tERgcYbnOShj33PCrO4rHXdCRmDkah7K97b8hdWxFGxi/F6CBxCYw9Q+CXTNjGKVORysItoji/1YpFQF5ICnme0xNgYJQkd/BPeW0h7A5KcP/1nFAdYDAkRRTMDKCECGexblVbPiSLo/UbcmTYpT5xWRyH5PyhpWkv/lrJYZ/I62j94ZrFyH/9KzZLeCkTrYDf10O4KMjnRRP/lSF1S61j4iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by CY5PR15MB5416.namprd15.prod.outlook.com (2603:10b6:930:3b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.25; Thu, 28 Jul
 2022 05:49:05 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5458.024; Thu, 28 Jul 2022
 05:49:05 +0000
Message-ID: <c7ebc0c6-b301-de70-b5ae-1f62d360acb6@fb.com>
Date:   Wed, 27 Jul 2022 22:49:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH bpf-next v5 4/8] bpf: Introduce cgroup iter
Content-Language: en-US
To:     Yosry Ahmed <yosryahmed@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Hao Luo <haoluo@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org
References: <20220722174829.3422466-1-yosryahmed@google.com>
 <20220722174829.3422466-5-yosryahmed@google.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220722174829.3422466-5-yosryahmed@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0208.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::33) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d32f5f80-cd90-40b2-cf95-08da705ce1c0
X-MS-TrafficTypeDiagnostic: CY5PR15MB5416:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Df1pJGb84XvhXzifQyhhyABRqgVYilXPNE+Ml9RbOTB2MrmHGJthtCJI2OgSKBjeklkBwUpxGfEnn0SThzIVK3sB+eiztyTBuO+FJNIdRKfdFtzzs7ZoYYK/JahadmrWj8jYy4MdYrnzNl20CwTYmk2VKoe0D4Ch6cQ3KD9Wiypekt4rlvIMZcZp3zbyQGzK91Ia98UkiUsBfloU6l7dyKluoz/zXC9NdUt3sbzqLepx4se/8cWG6glA5oqYV5UxQrAbAZYvKzu0MrFGaWm081WPtKtbhLbM0gcUbHSARrF2UdQf5InfikH9HsZK/FaC3ES107tA6cBWLo1++nVrDIUbEKkQURfwwhmL8z7Z9R/Wg6zuH877ZIoMz2ahrDMcyj0d3/ljYD48d/smJrtr95u8ZGKMHZkTdpcZXpJ0Po1mQUEm3G/2dJ7aP//jTmEgfwXIG2Soa0M79/GSTDThKpXHPrHQABxg3vdifq61t8uVGdBV3lNXOfVQz6oOReWJnI5wIMZyVXZhUTCRniiN1Hz2gr4lGT1G1GRxNDM5eyPPZse8wq/azfKSutM1unSsoy5PFfz2cjWiajiJrNuRKGRO4aJ0+XFnt6EdWpEvjQQ+QrRBd4pPIHHCFRUwjGjsS2cida4rcrBywNBgAcWVQagFpujNycCm5amk0PVuKPRZGuPkV+2c0VSLVFu9Fd80jCAW2XR98dDId1so09zgV8g0YpRhm0wFKwmqBNGUNvRyDf75VgSeJegbqbRpPricN2qnPbCiiU6ygkG5DasInaM2URQJ46UQN8IY/fud8PTDzUI/t+4r+r72FLk0dM/e0A3VVKmsewZBoMJPEdiX4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(136003)(376002)(396003)(346002)(53546011)(2906002)(2616005)(6512007)(31696002)(66476007)(66556008)(41300700001)(86362001)(54906003)(66946007)(8676002)(110136005)(38100700002)(83380400001)(4326008)(7416002)(186003)(8936002)(478600001)(6666004)(316002)(36756003)(5660300002)(6486002)(6506007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N09qMDBnNERyOWs2bHhtSWFyNHMzUmhMa05CNTJZMTB1RUFXYUxYeEJXUm5N?=
 =?utf-8?B?ZCtZL2lVMnpvWGh3bUZYTWNrQmZKekhwR1R2WTU3Rk5qc2EwVHMvY2JNanRa?=
 =?utf-8?B?QjM2VGFQVzdUV3JLMUZtdHQveTF3c3U5QXl2WDl6bW8vREJ2enhGYXBKZ3JP?=
 =?utf-8?B?MkpiTFhBckkwTTZ2OUl2K1J6RmFrWU14UzIxL0ZuenkzMy9iVnFhYlRYVHA2?=
 =?utf-8?B?RVVQRFhpVFg2UDArZEMyL0VxWTREVUI2WVNkeFA3Mkt3ajE3bHNXTHMrbmJK?=
 =?utf-8?B?Z0ZGU2pDRldRVzZrdDJtYmZqTVhsSjZYZ0pTbjRmUzI3LzVzSURoZ2hGeUxt?=
 =?utf-8?B?OXRwa0RxL3V3dm1rNXZIUUNOV3hKT1pkb3gvUWVPdTZqSDYvREN0Mm84d2U3?=
 =?utf-8?B?eVBBamFnS0V4eHRzMVRwbDRsWU4vamVhSnJMak9Ec1FrTUswcG1qWnRRdUZt?=
 =?utf-8?B?blZCcS84cEd4TDI3Zk9vYVdTR2NvcTlaZnlRNnZlRlhwSHovUy9QdG1YaVJZ?=
 =?utf-8?B?cTZRYzRWSHB4WWg0N05mQTN2N2pJTHNIVG1XRDFPVW5UclROZnc5U3hPWnow?=
 =?utf-8?B?TnBjNW51U0hhZ2x6bUdKSkJ5WWhNSytJZXhCQ2lpQy9hcmI3ajgwZnVwNU93?=
 =?utf-8?B?QlVJMG1GZXBoc2FGNmt1ZEkwVjNYdkZkVEIrN3BPd1g2UExPanZyeTlGOTdk?=
 =?utf-8?B?QklCbER1NU9rREhxejFPTHQ5anFTSWxnNmdGZDBOc3E5N2kvbVVnNElGQzNi?=
 =?utf-8?B?YjhpM3ZlUTdxa2hQakNJWWNpQ05TSkFLc09zTDVJZ21LTlJoeE1nK2hvUzJi?=
 =?utf-8?B?T0V6RG8rWWxXU2JiNEpHbEROR3U3QTNmeDJvRzlaR0xmUFJGTTEzSmdKd2VO?=
 =?utf-8?B?a1pMdm5YYVpmWmZ5YXMyNEsrYk9kQitLeis5alN6UW4yeEpKZlE1enNXRENv?=
 =?utf-8?B?SUZDOFJyS1dhd3ZKOTMyeUNlQ21NczQxeGRuWDg4aEtiS1VhRkN6ZWNvMG9R?=
 =?utf-8?B?NnArRWswSmYrc1pVRmZpVkN5OW1RNzBQc0FWdE5aUExIb1JzU0s5UXlYUTM2?=
 =?utf-8?B?ZENIT1ZZcDlnYkx1VkhZRlF4bkFpY25HdWlOUElVYUJySHlGc0wwck1Ma1lF?=
 =?utf-8?B?VW9hM1owOTFJcDZKRVlGclVWTWVWMTdPMm5yaGhEQ2RicGdPL1d1MUxOMk8r?=
 =?utf-8?B?QlJGelR4Q2FvaEZuVVk5ZzA5RzR6bnp0ZUdrUHppckJtQmJSWlJiNXRYeUtE?=
 =?utf-8?B?aUhwT1RVR0d5NGhtdGI5NEJrWnQ0SjVTMGFTRVBENklNRG1oTzNUYVBaeXE3?=
 =?utf-8?B?amp1YWM5SkNaejhSeFA1cER4WVNSN24yRHZwRWpubHRIQTJtNWdMam5uZlZB?=
 =?utf-8?B?RUZUVkhSL3lyR1dMWVlabWNXOS9EVjZMdEl6Tm84NWxWTW5NRUNNWURVY1lr?=
 =?utf-8?B?VmtiY2hXV2JXdHYwRCt4VjFXOGNNOGhiYkRLMkVmV1ZDbDNnRG1ZRlM5SDZt?=
 =?utf-8?B?WmRqTllQQTBTSkRTeFBmc2RRSEZ6YnlySUFDQlF1V2IxNExvQ2tCMGZyYW9u?=
 =?utf-8?B?RU1tc2FkKzgvR2lTSjVUNHVqTVJ0cFpYT1ZYOFpja0d0bkg2enVkUFR5Y1g2?=
 =?utf-8?B?VkYzbEV5QUxMSFBFZTRkVHN2T25BcTd5MldyTmpLeXFBVnJGRnVVNGJML3Nr?=
 =?utf-8?B?V2doR2U5d05VWlg5SHgyMkxpRFhZcTRDN28zeW96Q013REZaalhvVWN3QWJw?=
 =?utf-8?B?RUxTZEVxbk9TQnZOenRwdWtQWHNSN3JPN05NRXpQV2pZbXF1WDJZZzViVm40?=
 =?utf-8?B?SDBDZ0ZGSjk4allJNmVyTDVTS1dqYWF4OC85M0hjdXJ3NWk5dEFDV1pHUVJ6?=
 =?utf-8?B?Z3ZtaXgwZHBsT2w4TUJLN3YxRVRyci9QZUlneFB4UzUxaDQyN0JQZ1dDZUxY?=
 =?utf-8?B?dndURVhsTkZiNndzY21DWEdHZlpvZ0tNRGpVaXBzQi8xTVZiVXIwbWY4aDNC?=
 =?utf-8?B?UlNmZ1VpVGN3YU11L1F1UTN4dFdPeUp3Ti9wSnZ3ZEk3ajBObUlnY09jMFdC?=
 =?utf-8?B?N2lNRHBOU1ZtSUcvNXZabUhXL3ppNVBsSDVTZ3VBWk13WTdCWElzcjdXTFNa?=
 =?utf-8?Q?JmhqHMaxwqy2pbNnMlLAy84XI?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d32f5f80-cd90-40b2-cf95-08da705ce1c0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 05:49:05.4720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fZBwUXNoG6Ry6giYkb8kB5cOckl0OHEiD6NFjE1ZQSfjTWClXf42sDz5ka4j70i9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR15MB5416
X-Proofpoint-ORIG-GUID: sViKdH1nAyR3BwowAp-LmkDxNHSJxQDT
X-Proofpoint-GUID: sViKdH1nAyR3BwowAp-LmkDxNHSJxQDT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-27_08,2022-07-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/22/22 10:48 AM, Yosry Ahmed wrote:
> From: Hao Luo <haoluo@google.com>
> 
> Cgroup_iter is a type of bpf_iter. It walks over cgroups in three modes:
> 
>   - walking a cgroup's descendants in pre-order.
>   - walking a cgroup's descendants in post-order.
>   - walking a cgroup's ancestors.
> 
> When attaching cgroup_iter, one can set a cgroup to the iter_link
> created from attaching. This cgroup is passed as a file descriptor and
> serves as the starting point of the walk. If no cgroup is specified,
> the starting point will be the root cgroup.
> 
> For walking descendants, one can specify the order: either pre-order or
> post-order. For walking ancestors, the walk starts at the specified
> cgroup and ends at the root.
> 
> One can also terminate the walk early by returning 1 from the iter
> program.
> 
> Note that because walking cgroup hierarchy holds cgroup_mutex, the iter
> program is called with cgroup_mutex held.
> 
> Currently only one session is supported, which means, depending on the
> volume of data bpf program intends to send to user space, the number
> of cgroups that can be walked is limited. For example, given the current
> buffer size is 8 * PAGE_SIZE, if the program sends 64B data for each
> cgroup, the total number of cgroups that can be walked is 512. This is

PAGE_SIZE needs to be 4KB in order to conclude that the total number of
walked cgroups is 512.

> a limitation of cgroup_iter. If the output data is larger than the
> buffer size, the second read() will signal EOPNOTSUPP. In order to work
> around, the user may have to update their program to reduce the volume
> of data sent to output. For example, skip some uninteresting cgroups.
> In future, we may extend bpf_iter flags to allow customizing buffer
> size.
> 
> Signed-off-by: Hao Luo <haoluo@google.com>
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> Acked-by: Yonghong Song <yhs@fb.com>
> ---
>   include/linux/bpf.h                           |   8 +
>   include/uapi/linux/bpf.h                      |  30 +++
>   kernel/bpf/Makefile                           |   3 +
>   kernel/bpf/cgroup_iter.c                      | 252 ++++++++++++++++++
>   tools/include/uapi/linux/bpf.h                |  30 +++
>   .../selftests/bpf/prog_tests/btf_dump.c       |   4 +-
>   6 files changed, 325 insertions(+), 2 deletions(-)
>   create mode 100644 kernel/bpf/cgroup_iter.c

This patch cannot apply to bpf-next cleanly, so please rebase
and post again.

> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index a97751d845c9..9061618fe929 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -47,6 +47,7 @@ struct kobject;
>   struct mem_cgroup;
>   struct module;
>   struct bpf_func_state;
> +struct cgroup;
>   
>   extern struct idr btf_idr;
>   extern spinlock_t btf_idr_lock;
> @@ -1717,7 +1718,14 @@ int bpf_obj_get_user(const char __user *pathname, int flags);
>   	int __init bpf_iter_ ## target(args) { return 0; }
>   
>   struct bpf_iter_aux_info {
> +	/* for map_elem iter */
>   	struct bpf_map *map;
> +
> +	/* for cgroup iter */
> +	struct {
> +		struct cgroup *start; /* starting cgroup */
> +		int order;
> +	} cgroup;
>   };
>   
>   typedef int (*bpf_iter_attach_target_t)(struct bpf_prog *prog,
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index ffcbf79a556b..fe50c2489350 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -87,10 +87,30 @@ struct bpf_cgroup_storage_key {
>   	__u32	attach_type;		/* program attach type (enum bpf_attach_type) */
>   };
>   
> +enum bpf_iter_cgroup_traversal_order {
> +	BPF_ITER_CGROUP_PRE = 0,	/* pre-order traversal */
> +	BPF_ITER_CGROUP_POST,		/* post-order traversal */
> +	BPF_ITER_CGROUP_PARENT_UP,	/* traversal of ancestors up to the root */
> +};
> +
>   union bpf_iter_link_info {
>   	struct {
>   		__u32	map_fd;
>   	} map;
> +
> +	/* cgroup_iter walks either the live descendants of a cgroup subtree, or the
> +	 * ancestors of a given cgroup.
> +	 */
> +	struct {
> +		/* Cgroup file descriptor. This is root of the subtree if walking
> +		 * descendants; it's the starting cgroup if walking the ancestors.
> +		 * If it is left 0, the traversal starts from the default cgroup v2
> +		 * root. For walking v1 hierarchy, one should always explicitly
> +		 * specify the cgroup_fd.
> +		 */

I did see how the above cgroup v1/v2 scenarios are enforced.

> +		__u32	cgroup_fd;
> +		__u32	traversal_order;
> +	} cgroup;
>   };
>   
>   /* BPF syscall commands, see bpf(2) man-page for more details. */
> @@ -6136,6 +6156,16 @@ struct bpf_link_info {
>   					__u32 map_id;
>   				} map;
>   			};
> +			union {
> +				struct {
> +					__u64 cgroup_id;
> +					__u32 traversal_order;
> +				} cgroup;
> +			};
> +			/* For new iters, if the first field is larger than __u32,
> +			 * the struct should be added in the second union. Otherwise,
> +			 * it will create holes before map_id, breaking uapi.
> +			 */

Please put the comment above the union. Let us just say, if
the iter specific field is __u32, it can be put in the first or
second union. Otherwise, it is put in second union.

>   		} iter;
>   		struct  {
>   			__u32 netns_ino;
> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> index 057ba8e01e70..00e05b69a4df 100644
> --- a/kernel/bpf/Makefile
> +++ b/kernel/bpf/Makefile
> @@ -24,6 +24,9 @@ endif
>   ifeq ($(CONFIG_PERF_EVENTS),y)
>   obj-$(CONFIG_BPF_SYSCALL) += stackmap.o
>   endif
> +ifeq ($(CONFIG_CGROUPS),y)
> +obj-$(CONFIG_BPF_SYSCALL) += cgroup_iter.o
> +endif
>   obj-$(CONFIG_CGROUP_BPF) += cgroup.o
>   ifeq ($(CONFIG_INET),y)
>   obj-$(CONFIG_BPF_SYSCALL) += reuseport_array.o
> diff --git a/kernel/bpf/cgroup_iter.c b/kernel/bpf/cgroup_iter.c
> new file mode 100644
> index 000000000000..1027faed0b8b
> --- /dev/null
> +++ b/kernel/bpf/cgroup_iter.c
> @@ -0,0 +1,252 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (c) 2022 Google */
> +#include <linux/bpf.h>
> +#include <linux/btf_ids.h>
> +#include <linux/cgroup.h>
> +#include <linux/kernel.h>
> +#include <linux/seq_file.h>
> +
> +#include "../cgroup/cgroup-internal.h"  /* cgroup_mutex and cgroup_is_dead */
> +
> +/* cgroup_iter provides three modes of traversal to the cgroup hierarchy.
> + *
> + *  1. Walk the descendants of a cgroup in pre-order.
> + *  2. Walk the descendants of a cgroup in post-order.
> + *  2. Walk the ancestors of a cgroup.
> + *
> + * For walking descendants, cgroup_iter can walk in either pre-order or
> + * post-order. For walking ancestors, the iter walks up from a cgroup to
> + * the root.
> + *
> + * The iter program can terminate the walk early by returning 1. Walk
> + * continues if prog returns 0.
> + *
> + * The prog can check (seq->num == 0) to determine whether this is
> + * the first element. The prog may also be passed a NULL cgroup,
> + * which means the walk has completed and the prog has a chance to
> + * do post-processing, such as outputing an epilogue.
> + *
> + * Note: the iter_prog is called with cgroup_mutex held.
> + *
> + * Currently only one session is supported, which means, depending on the
> + * volume of data bpf program intends to send to user space, the number
> + * of cgroups that can be walked is limited. For example, given the current
> + * buffer size is 8 * PAGE_SIZE, if the program sends 64B data for each
> + * cgroup, the total number of cgroups that can be walked is 512. This is

Again, let us specify PAGE_SIZE = 4KB here.

> + * a limitation of cgroup_iter. If the output data is larger than the
> + * buffer size, the second read() will signal EOPNOTSUPP. In order to work
> + * around, the user may have to update their program to reduce the volume
> + * of data sent to output. For example, skip some uninteresting cgroups.
> + */
> +
> +struct bpf_iter__cgroup {
> +	__bpf_md_ptr(struct bpf_iter_meta *, meta);
> +	__bpf_md_ptr(struct cgroup *, cgroup);
> +};
> +
> +struct cgroup_iter_priv {
> +	struct cgroup_subsys_state *start_css;
> +	bool terminate;
> +	int order;
> +};
> +
> +static void *cgroup_iter_seq_start(struct seq_file *seq, loff_t *pos)
> +{
> +	struct cgroup_iter_priv *p = seq->private;
> +
> +	mutex_lock(&cgroup_mutex);
> +
> +	/* cgroup_iter doesn't support read across multiple sessions. */
> +	if (*pos > 0)
> +		return ERR_PTR(-EOPNOTSUPP);

This is not quite right. Let us say, the number of cgroups is 1,
after bpf program run, pos = 1, and the control return to user
space. Now the second read() will return -EOPNOTSUPP which is not
right. -EOPNOTSUPP should be returned ONLY if the previous cgroup
iterations do not traverse all cgroups.
So you might need to record additional information in cgroup_iter_priv
to record such information.

> +
> +	++*pos;
> +	p->terminate = false;
> +	if (p->order == BPF_ITER_CGROUP_PRE)
> +		return css_next_descendant_pre(NULL, p->start_css);
> +	else if (p->order == BPF_ITER_CGROUP_POST)
> +		return css_next_descendant_post(NULL, p->start_css);
> +	else /* BPF_ITER_CGROUP_PARENT_UP */
> +		return p->start_css;
> +}
> +
> +static int __cgroup_iter_seq_show(struct seq_file *seq,
> +				  struct cgroup_subsys_state *css, int in_stop);
> +
> +static void cgroup_iter_seq_stop(struct seq_file *seq, void *v)
> +{
> +	/* pass NULL to the prog for post-processing */
> +	if (!v)
> +		__cgroup_iter_seq_show(seq, NULL, true);
> +	mutex_unlock(&cgroup_mutex);
> +}
> +
> +static void *cgroup_iter_seq_next(struct seq_file *seq, void *v, loff_t *pos)
> +{
> +	struct cgroup_subsys_state *curr = (struct cgroup_subsys_state *)v;
> +	struct cgroup_iter_priv *p = seq->private;
> +
> +	++*pos;
> +	if (p->terminate)
> +		return NULL;
> +
> +	if (p->order == BPF_ITER_CGROUP_PRE)
> +		return css_next_descendant_pre(curr, p->start_css);
> +	else if (p->order == BPF_ITER_CGROUP_POST)
> +		return css_next_descendant_post(curr, p->start_css);
> +	else
> +		return curr->parent;
> +}
> +
[...]
