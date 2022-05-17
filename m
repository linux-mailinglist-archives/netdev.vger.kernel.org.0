Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4EE3529A91
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 09:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239129AbiEQHJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 03:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241438AbiEQHJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 03:09:23 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70FE748E5C;
        Tue, 17 May 2022 00:08:50 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24GIXDTM016182;
        Tue, 17 May 2022 00:08:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=zMofEuPkvIzt9JRbGzhFdxabEkO0mjT/5NIYwzPztU0=;
 b=mFwjEEXOjHkhV1dETndFqCxeafw5GxRiyc4gpdkwL3ON1dDnt3daES0nmNXYpVPlyHbS
 5M3692AmK2ofXgjY7IdAx1682P0l0uNjXHr7HZNbFatMqWZ2kPN34J5OP482ZUYwXnio
 qhbXp6PKAkOTTh8xY+kOaGVOLkyAhBZ8m0c= 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2043.outbound.protection.outlook.com [104.47.51.43])
        by m0001303.ppops.net (PPS) with ESMTPS id 3g283wff86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 00:08:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZGhJWTEuZgk2xFNjNFtNyOliQ0AUgwU+gv6rWEeLjHYfkJNx8Oehr/3GasQasq2hjvJZT2m9OSy7NBFrw2HEOyfQcTwtmdQ/goEzHU1DCKrhm+mXe1GR7XNbkQxnhJm8muS3DGfzqufr/NS6wNnMEm+KdCsAfWEsnY1zU2K/+IbyBt4Xd/A6q2piJqwqw9LOV1P5U9y0PxhUpxpTjwxTw+qaE7bXz+VSLqQqDTfObaZmNuRgzJC1Qd4x6dXYk4/CNPzj7ZWROGT32MA+yDmMY3JdotYAvU78IUC85VN/ryJU1N4tKcLo9t7hOFIw+zdUI/bRyXGmF8z3ERP2lbHfzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zMofEuPkvIzt9JRbGzhFdxabEkO0mjT/5NIYwzPztU0=;
 b=XgJ0Hm6ypVSTZ/zn6j5levNvsYi7XcPtyd3KSRsiiwInE7PKof0RoCYWwlaWLT+Y7NryhvIszZJIXykGr92GsqzLtMY3MPhi+vlqIZ0M+Jz52/6CzhfsZO3cKG91CyWQ15dKzTQuD7TTggx2luyhyP5jZDMjFY+ioFMp85/s6x1wekBQ8PJUA2mdvlRYm1t/CwEjMgeLwOGMkqAgbLKmE3b7Da2vNHyI7nY6iRhQ3gaCYOBjd4vSNxcxJBDE26s3APnWzJ7n2X12/l+cicYyt1fw9irIfM4/YQ0oa37oeGJGjZtVSqcOIvUYNZG+I/MEf76rHv6fPr64Oy4n9GwH7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BL3PR15MB5409.namprd15.prod.outlook.com (2603:10b6:208:3b1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Tue, 17 May
 2022 07:08:32 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5273.013; Tue, 17 May 2022
 07:08:31 +0000
Message-ID: <2a722851-e99f-176e-0f0b-4c32854f762d@fb.com>
Date:   Tue, 17 May 2022 00:08:28 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH bpf v2 2/4] bpf_trace: support 32-bit kernels in
 bpf_kprobe_multi_link_attach
Content-Language: en-US
To:     Eugene Syromiatnikov <esyr@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
References: <20220516230506.GA25374@asgard.redhat.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220516230506.GA25374@asgard.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0129.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::14) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e54c73f-ad2d-4fb9-39c5-08da37d40ca1
X-MS-TrafficTypeDiagnostic: BL3PR15MB5409:EE_
X-Microsoft-Antispam-PRVS: <BL3PR15MB5409700D5C1CEE5FDFBB9ECFD3CE9@BL3PR15MB5409.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JI94gLRb7KKKL1lhLSTtdbdqG6h6hYeIJTRIBRBaLMJPanqCsa7wv8ipmZzoCdJzXWDrP/+47ShiSgzNNc2X4ppCe8XvH63SQglLIP60IgtrSR0LdXbRtHFoqojvO+qZZt9SSHY6UABLHXFn+DeGS6O94m8HSxS5uSSInHrkRn1gVcwjBAkaxF8d6c/TRZZNPmYi6CokJQYkG6awU/0Zc0g1jNCkYaOk9PVr+jn+JiOj+lGeIVXU7LLIDAkZjSVBVH1QAwjeIgrDrIMJH6CSzWzN/Ip5F3FQaovPMjwi+kQ/Xh+UlAuOWJsKV8Q80LPfUlgsY83v7zS5+HwfY9Zyk4oH/vfkfKS2dcs0QUhMG8OSrIcwb2Hd3qoXJxSuBCCBdXo29woc7fM2+e2bxfjN2QaUmCA/TXruzKNEszThHe6+hW7Gg239Hqjo1uUhD4ky4vQwXSRs7GiaAcj5wVJmmUh+v0uqT1SkzHOA1Xjy0WCSi44fIykxuClgKryZvek6vdYXRyD3cWtlCRlFlTeDPo/zxeHfL3WC08qjrIF+yesAzfL1Ry0PxsJ+NMGROo+FV2gfjI6epJ1yU5klSl5aWWSQP9uiSzJVoMeatIWl72mpSSVdseRSyot/jIvNRJMR7ypXZQFDE38+xTkwZ9tDPUBHiK4loI2kgxFG3mdCR4ruCwuMZarUDswGDaXgYwUcx/OkkGZt2twXDl0REHnP+8EvGM3dlzrFMUbCSsFtKYtGzDS8/H8TV9eXQJ0u8FBOWEktt3qucdX/KRYEaQILWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(110136005)(54906003)(31696002)(36756003)(6512007)(4326008)(6486002)(86362001)(31686004)(7416002)(66946007)(66556008)(66476007)(316002)(8936002)(508600001)(186003)(53546011)(8676002)(6506007)(2906002)(52116002)(6666004)(5660300002)(38100700002)(83380400001)(2616005)(43740500002)(45980500001)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZmwvcmZCR28zSCtIcHEvckR1M1ZFQmx3eDZMS05kTk01dmh4NUhQeHBTQUVx?=
 =?utf-8?B?b1N4a0ZoS3NUazdaaHpDOHpqUTFZQjRqeGp1ODdqK3hoK2ZEQ0RTcHlmUU44?=
 =?utf-8?B?UW5qV1lGaWFHelk4MEJYSnRod1Awem5GRGI1SXlnZWlRdlFnaFVxTHF0cDR3?=
 =?utf-8?B?Z3hLZkdUbkFjS2tSSXFBS21BcVk3WTlrTmxiTDBCeTFKak4xY2xyaDBlUUY4?=
 =?utf-8?B?SllHMWkxRjFxazlxcCsrbS9CaGlKc251SnZNbGlXNG1vQ2JyL0x2UmQveG9t?=
 =?utf-8?B?VWM4SmYza0t4TThtZTM1YXVycXkvU3Y2VmFKKzZFb0xqeDBVYm10ZkFaN2RR?=
 =?utf-8?B?YWtzR25MbVd4ZUQ3UmNRMXMza0V1cVlRbHVTN1JhM3IrTW1zbk1STGo3NVJr?=
 =?utf-8?B?RUNCYWdZdFExeTFzamlucE1oQmVqQTBiVGJvUVVPZ3JWVUI4Um1ZbHZiU1k5?=
 =?utf-8?B?UWpUdlpSZTZXd0dPQ0hBRnZCeXhIZ0crTnQxMFlBWnRvYUpoejhQL2M4d3c2?=
 =?utf-8?B?SUorWEhtYkFDUFpQOHVIN254UmVkR1ZQcTd6ME5LbkhCUkErK1dUeThhb2cv?=
 =?utf-8?B?NE8rdkhWaDVSTElNS0orcEdKK3hiZXE1SzdiMnNTQVJ3elg4WXlxVVpESk1W?=
 =?utf-8?B?aUo4enYyMzI1cTYzMFRIbjJpR1hOdWFVRlZtOEU5MkZUVndKaWdFTVQwR2Jw?=
 =?utf-8?B?S3BsT2RlZTRrRHg1ME94VTRpRWpZclBvbTBORVgrL0IvYm9CVVlXUnpiL3FC?=
 =?utf-8?B?aWtnMUQrbDJMWFR6OTZXaXErdTFFOU03WGhkQ3JVTkYySEFUVW1PejBBUGlN?=
 =?utf-8?B?VUdTcmVQaUhpbCs5UnRzS29jR1JPWnd1eWsrUllxcnNqSGprYVVXK1g4dEJ6?=
 =?utf-8?B?UlVjQnRlMlkvTnlEeFErdGRRbzY3YnZNZ3A0bkRURHRpbWNpa1hhSXZvdHYr?=
 =?utf-8?B?NVRnQXpUNk5xRlNUSmlBWmpXQ0pwVzFvM0tMUTJnN0lSTEdUUkZIcmNYRC9X?=
 =?utf-8?B?Tk1TQXE1TDdSY2EveHFkOGg3WkkxU0duMUJZNEk1UFRrRk5mYm04ZHYwZE5B?=
 =?utf-8?B?N2VuYkFxNjJzTVN3bC85VEZJcTlIRWxHS0x0QXpDN041Y0pyTkZWRzJpM0lX?=
 =?utf-8?B?UmwvT1J6ekZJMUFadzF2WEpyVDh2NStpY2lhd3U5ZEtBZ0pSTGxSOThhTlhj?=
 =?utf-8?B?N1FUUWJVVE8ySFJpVm90MlRlTmNXYm85eFdBUDZiL0J0bHVrdmF2MXp6VDVP?=
 =?utf-8?B?V0lKemMyejV5NEhkck14VWVUSkQ3SXRMOGlTeEtWZlp2RTlBZDFHcUY4ejhG?=
 =?utf-8?B?Zm1jN21qR0xKeTVpWWNTVlNzSG9pNDgrSnI5MmRTMmFlL0tlQjl1bnBud0FB?=
 =?utf-8?B?ME01NElidndxOXBSQjdDN3dqQVJVTHd2TzI3aGJlaG9Cd2pCWklnc1h6cXNa?=
 =?utf-8?B?ZGR5bTFFUjdtU1BhZHVCVlZneDJoNGQ2a2lEeVB6NXA2TndwTUdPK1dEcnJI?=
 =?utf-8?B?d2NyUFlqcVNmdFFXUWlmWnlrTmJIZXRMYWJnQ3dOd2oyVUhKeis0ZWJQWWo4?=
 =?utf-8?B?NzVONUdRWVhSWkpBS0IyWDJOWjRtcWxaNG9HVlRlVU94OExxZzk3WHdYa0p1?=
 =?utf-8?B?Y2lmRWNQenM5L0xLM1V4SFJhUGJvellqUERWdjNEZExRTmVsSXR1MWxLWVQr?=
 =?utf-8?B?YXRwYnpscG1TckpBS2FsVENBcVVRQ0VpS3prRzJtUjZuSk5UaHdHaVg4Qnh6?=
 =?utf-8?B?Y1VocEJNZDJUVmJxV0duc0tQa01QQnhWeWlRTXRNWGI1bWk0V2FSTFVZb2RQ?=
 =?utf-8?B?UjdJTGVKT05tM2FMZ2RQdlNLamRBYWtLR0NoT043N2NYMVg1NUhocENIV0N1?=
 =?utf-8?B?bFBJZ3NYZmJuQjFJQzBqVktyRzhlL1p4TnJWL0gyYzhrWFhvbkUraExVRjFp?=
 =?utf-8?B?TzNMK1BhUUg4Vm0rM1VDOWtSUEZ0YmJPZG84c3dvRVRwQnZZUkY5SStCcity?=
 =?utf-8?B?YjBFQzRZQW1uNlRmOGl4SFhCYzJtRmkwcFdMdk0vWS9BTWtpKzdod2FKbjEx?=
 =?utf-8?B?UnJGc0xDMUVQd1hBSk9rL25hY1ZJTkFQOUlnZ0d4YURESmFhc1prTUh1UGtl?=
 =?utf-8?B?U1luWEVFUnc4L3lqTEtmMkk4cDc2cHhxcjRzeitHalBCS1ZsaE9HeGd6T1lQ?=
 =?utf-8?B?dmdTUjRkbmhvMjhpdGJRa0R3b09MeGRiMTBaMVRHMWxOMXlMZndSSUFmLzZY?=
 =?utf-8?B?SWxUN0Q1NWJyUEc2Y2E3cDZyZnpkMUJmOFJob2gxVENKVjliUTFSNFByUU1x?=
 =?utf-8?B?QU9JdFpiRnlOS2ZhZndoNTJuMTFwTUdVeXFlTExhU1ExZWRrekMrcFFBYisv?=
 =?utf-8?Q?7DBcX2ilpsGGnGt0=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e54c73f-ad2d-4fb9-39c5-08da37d40ca1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 07:08:31.2083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 051x/ctxOjPs6DxX6KqFBZOnFIcJipE3rIJ6vBfGRXkfmUPthYDZLOk8uFd3Ah24
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR15MB5409
X-Proofpoint-GUID: KeZfh98U5TKsV-beGOpLlKQ-A7n71dkk
X-Proofpoint-ORIG-GUID: KeZfh98U5TKsV-beGOpLlKQ-A7n71dkk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_01,2022-05-16_02,2022-02-23_01
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/16/22 4:05 PM, Eugene Syromiatnikov wrote:
> It seems that there is no reason not to support 32-bit architectures;
> doing so requires a bit of rework with respect to cookies handling,
> however, as the current code implicitly assumes
> that sizeof(long) == sizeof(u64).
> 
> Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
> ---
>   kernel/trace/bpf_trace.c | 18 +++++++++---------
>   1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index f1d4e68..bf5bcfb 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -2406,16 +2406,12 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
>   	struct bpf_link_primer link_primer;
>   	void __user *ucookies;
>   	unsigned long *addrs;
> -	u32 flags, cnt, size;
> +	u32 flags, cnt, size, cookies_size;
>   	void __user *uaddrs;
>   	u64 *cookies = NULL;
>   	void __user *usyms;
>   	int err;
>   
> -	/* no support for 32bit archs yet */
> -	if (sizeof(u64) != sizeof(void *))
> -		return -EOPNOTSUPP;
> -
>   	if (prog->expected_attach_type != BPF_TRACE_KPROBE_MULTI)
>   		return -EINVAL;
>   
> @@ -2425,6 +2421,7 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
>   
>   	uaddrs = u64_to_user_ptr(attr->link_create.kprobe_multi.addrs);
>   	usyms = u64_to_user_ptr(attr->link_create.kprobe_multi.syms);
> +	ucookies = u64_to_user_ptr(attr->link_create.kprobe_multi.cookies);
>   	if (!!uaddrs == !!usyms)
>   		return -EINVAL;
>   
> @@ -2432,8 +2429,11 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
>   	if (!cnt)
>   		return -EINVAL;
>   
> -	if (check_mul_overflow(cnt, (u32)sizeof(*addrs), &size))
> +	if (check_mul_overflow(cnt, (u32)sizeof(*addrs), &size) ||
> +	    (ucookies &&
> +	     check_mul_overflow(cnt, (u32)sizeof(*cookies), &cookies_size))) {
>   		return -EOVERFLOW;
> +	}
>   	size = cnt * sizeof(*addrs);

size has been calculated, no need to calculate again.

>   	addrs = kvmalloc(size, GFP_KERNEL);
>   	if (!addrs)
> @@ -2450,14 +2450,14 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
>   			goto error;
>   	}
>   
> -	ucookies = u64_to_user_ptr(attr->link_create.kprobe_multi.cookies);
>   	if (ucookies) {
> -		cookies = kvmalloc(size, GFP_KERNEL);
> +		cookies_size = cnt * sizeof(*cookies);

same for cookies_size.

> +		cookies = kvmalloc(cookies_size, GFP_KERNEL);
>   		if (!cookies) {
>   			err = -ENOMEM;
>   			goto error;
>   		}
> -		if (copy_from_user(cookies, ucookies, size)) {
> +		if (copy_from_user(cookies, ucookies, cookies_size)) {
>   			err = -EFAULT;
>   			goto error;
>   		}
