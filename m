Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36CDB576BCF
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 06:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiGPE3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 00:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiGPE3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 00:29:44 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2132FFEC;
        Fri, 15 Jul 2022 21:29:43 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 26FKnF4h019353;
        Fri, 15 Jul 2022 21:29:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=mXbVbbukszMR+XaEQo/Wztj9z3fLo8fELT6uUU6RBaM=;
 b=aVsvxHu4yqm255QA/RXmaaD2F+jvGC6gu3RSGX57vVRFchXoKgi9eZbAGkDO9YhCxEO6
 /TfgnPXHb6Q7w3W8tTeum8mFGcejOluVcNDUyiImUk/AN/phFdP3HrbHLSjCN7iAZ/eM
 wG5wRKazdNIQgRrVbnKZSsd2uWAz9ganzl8= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by m0001303.ppops.net (PPS) with ESMTPS id 3hamy3uaae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jul 2022 21:29:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LNYH2nLO0JX/aJHZmu455wtQXcVxVAcQrwPp6tPW9HXK6NXDfXv4qBoPnSJiEa5s6ilV9Gck34MA1j5uwEuSX4oXfwKLdMsVuriMvVGZn/cUKoNddHXkQbggXxwJ557exfCyg68TTwBkMKd+n0P2st0VY5uWKB5VkKMkRzP68uzh8QtRtsHiVXMn2XJZN4ia8l3epAYuwERD9Jg4ouTBxduATeBhb2l3hDK4kd9zONP8j/r4pr4Lj1SZlzp0zyBMsyyb84QkhWkhKKB+xvh/ggzGg8IC0SduANrT5PaiTDxOXa+DMtUEfcKOnr7Nglt3l7zJM28wNX6anHBo8bUxRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mXbVbbukszMR+XaEQo/Wztj9z3fLo8fELT6uUU6RBaM=;
 b=duJl9Q2qJa3uYq7r3zd4HsuqRP0a7GQbjUEK8XRTXuykE6fN4IK7Hcb3u1gWcJHn0dxX0E2DKuZ1ENFc17rgExUD4WnGgZXMdRPueg9cFoxAf3ocBqyVbI+MQmpl81ahrQNy7SmIlYuD/z9DIMKjVatVg2EYisEAvclvLJyIbkx4zsmmDUWntmYxxOPtO2hmFrh6apYkWS2S5U7YMjdU1kNxzgCjZoA2T1qU2U8OFaH9z1w1HlapU8InYMKdJE+sASvIQnLN1sBSkJzHkFyYw/6QFrHnEAm4b8HJxocVQuGimcWbGY+fskMqXHEtLTletmP670tMPh/B+7L1LP4jBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SJ0PR15MB4645.namprd15.prod.outlook.com (2603:10b6:a03:37a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Sat, 16 Jul
 2022 04:29:11 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5438.017; Sat, 16 Jul 2022
 04:29:11 +0000
Message-ID: <7fc49373-55df-c7fd-4a73-c2cf8a62748d@fb.com>
Date:   Fri, 15 Jul 2022 21:29:07 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH bpf-next v6 05/23] bpf/verifier: allow kfunc to return an
 allocated mem
Content-Language: en-US
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
References: <20220712145850.599666-1-benjamin.tissoires@redhat.com>
 <20220712145850.599666-6-benjamin.tissoires@redhat.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220712145850.599666-6-benjamin.tissoires@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0065.namprd08.prod.outlook.com
 (2603:10b6:a03:117::42) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d08889bc-3977-4990-9b1d-08da66e3bafc
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4645:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j3fvr6Yy7wUM2SYihi8rV/FRLfoZ/yPlKivHbCVa+C7xhdGlW/8IPdvmJ9dlTkEiNADqRXNzognYTMLHDHosJehIIWm7Ro569dMAMVkqipaQ2SdVxKdY58diHhuvCZKsThbg9yBTwjKhVYh+IicXQ75LBiCf/RNoJwc0QNIawukHNnw03myDY0wU+55Z0cTuhiOBEn36YzjjGH/HtmTHdQstMaxTQ44rvQeVE5QAu/OVv2etO7WWaxEfQcT+xNxRmxvt9y0g2nVAmTqpy2AaPvsT6JRu8KMp/Ex9YbjWkaB6gGKFFar9nCEwb/Z1y37rxc0Z47QzseMBcRm8uuZc83wH+Cxibn0R58idSDmSs9mSicF5lNB2fkyQc+8c/3lZeRnYwqUm8JeVAfhj0pKulAgywIi6w8XoCH9VAc71KRmHh1OCml4ZxGLkXYVmcTw2vBGhNePc+tNSbvU+wbS8+dv9OSojnKM3z8e5+b3o5iJVV810JcEc+py8aMFATegRbX4V/7TJBi8nai18qyjw7R3xPhP3/ze4qUAYYDtr134za35ce1Rp+IK6or+hTBA1mCxIidrU09CUKKygsB0Cjp8rT1k3j3hG8HzKUHoZuj7+PkzuddnpI56qaP6MmpypBYJWeX8dR0HukfnZ9OSTkSioYAAbK7ShjrqY56n5yRNMNMG/G/O2HgdGB1C1jENVBdvrB7QgdHIm7OjU7Ab5cu6yiRtcv6bi9GgnVpyauFwPlMjJ2jcJk1URKDXuARlSfFEAcJUag/RFD1im+cCXIh6AR09L1u/8f1D7rzeGx2BATexz4cCeqx3138gh71yIMy0LKXcCVu8PTYF0JahZRthY7HFmB9TLc3cjH/et+UI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(136003)(376002)(346002)(39860400002)(8676002)(316002)(8936002)(4326008)(110136005)(83380400001)(36756003)(478600001)(6486002)(7416002)(5660300002)(31686004)(66556008)(66476007)(66946007)(6512007)(41300700001)(2616005)(6506007)(186003)(2906002)(6666004)(921005)(53546011)(38100700002)(31696002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c21OUW41cjlqSHM0NWErQUVIQ0pSMnpnd0hEcUl0aE5YTkkrZ2hIdUE2WUJL?=
 =?utf-8?B?QzVXUTAwWVMwbGd0ZEd3NHVtbWtjMUppOTZ3RGJHU2p0WjZFRWFkWm9POWpx?=
 =?utf-8?B?ZkZ4TGtvRjF3RFpnUENRbVdCMDVPVENxeW1KaWhwUC9QZjAzTGYxTThsTFkz?=
 =?utf-8?B?YVl4VWl3aWFtNTVZOWJuczlNc2oxdkk0ckZ4cmRKNHZ2Q0dsYnFXdU9CSDhi?=
 =?utf-8?B?VmNYL0dYOCtJS3I0OFVSTUZ4a2hib0RkUUppdnJpR0ZRVVRkR2hrTnRMOFNN?=
 =?utf-8?B?ZnB5MDgvSlhnVk1lUHJCMlE2cFNKVk8vTGRua3BHZUFUVVV4WVBvbDVDeWhQ?=
 =?utf-8?B?c3dYblNPQ0NsSUZpRWtxMGU0QmJxczV4WmJONFVEVUpMMVRHeE5zRHJDQU1y?=
 =?utf-8?B?OTFHenBrdXpIb1VwY1ZDclJ0aVZNbFNyclArQiswNGhacTZYUndHdnE4cis5?=
 =?utf-8?B?K2Z0UkM5MUViRit2N1Y2UVB3ZVIwNk42MGhabTlsVVROUi9WTklXVmkvYk5U?=
 =?utf-8?B?YitQczFBbUFuclU1TXB6ajVzTTdyNVJJMmdLdDNZb3hSYi9QT3c5aDZsTm9q?=
 =?utf-8?B?Z1BxRVNleWhIT1FTNFp3VEFXY2Y4Z1BuMjA1WFFZWDNjbXVMN0U3MlFuMFdz?=
 =?utf-8?B?eW9ySGREeHQ0bTdyd3V2WFZUT1E5M1ZwdEltelBVSFg0cHoyUWhoMnRtRjEy?=
 =?utf-8?B?dG9HKzY2OEk2K3pKZ08xaS9WZklscTBBMDRJOHRucEdBbXdtcEJiVmhWZVBJ?=
 =?utf-8?B?WEJrYmdNZjZhK3Mvd0IwMHJNL0ZDY3hIWHl0R3BWVGhlOURqSW5scUVRK0FK?=
 =?utf-8?B?Z2hTa3NteWZkWWxzLzdnZmNxVTJUeEdMTWhRbkRETGEyUXBldHUrVXJ5dzdl?=
 =?utf-8?B?U2pqUGlBN0MrMFBYMGZReWpBSVRwRTRobzZDZ3VlelpTK3Vrb3JFZnJLRmFv?=
 =?utf-8?B?MUZJY1JqV1U1YmZBSkMySGhMVlVYeUU1OVdGOHdKUXpCOHBHakE3UWsveDFu?=
 =?utf-8?B?U0ZlZ05zOWtLZThmZW5HcGU0V01PSEhSY2thZ0lRYXFTSnM0aCtvbGNXSUhV?=
 =?utf-8?B?b0VDdm5TZmk2TW9kVzlwVDA0OGhBd09lWFc0S1dzeFpjTWEyNlpkL0RYN0VJ?=
 =?utf-8?B?S2IrS3ZRNzM0VTIwMEVjekR2WmVOcnVFa01BK3pkdGZWL21EWDNNb0RWNmsr?=
 =?utf-8?B?MHNCQTRWb0FTRU84NjVGN3NxN2ttR3VwdEVoSmMva3V1bWFUbDI2S3BnbUZB?=
 =?utf-8?B?U1R3Qzg2R2o3VWF5NmRyMzhacXlPUnQxcXBvenBJS2FQKzNyc2tSNlRJdHAy?=
 =?utf-8?B?TTRsdXhGb1dXZ1FoVnZZNFJPVGovNVMzaGt0dmp5eUhBZktwRHZRYjIyVE1B?=
 =?utf-8?B?UjdpYkJVOGVIZjhOUEMyV1dUK0F6OUhGZ01kNTVlNjNMcmoyL3c3TlNzK0l0?=
 =?utf-8?B?QVRWYy9UUUZGaDgzNXpYM2ltR21RYWxzb0pPTVBzanoyQ3RoTHB2QzBJSnRz?=
 =?utf-8?B?VUdranVBNHM2MHVLangzSkY4akp5aWdDTVcrcyt2ZVJqRFoveWVtbDBWYXJl?=
 =?utf-8?B?RkVhZHY3bXFFeVgzaThNd2tKMVBEdldCSGxJd0s1eVFvSFV3Vy9GM0xtVk1B?=
 =?utf-8?B?bWhMRVh3Rm0xSXQ3S1k1NHpPYWlyRjFmZU00SVpTTW1IekN1RzhRZ09jbnFy?=
 =?utf-8?B?U1lXYkI5RkhZN3BMU1ArajdVck9xN1VTZnJSVWk4aXZoZitSUmF0SXg4azIz?=
 =?utf-8?B?S3pYUUxwRnF1cHFxZDcwOElkbG9qdUdxM1N5M2lidjQ0VW9zWUtGb3J2YnVn?=
 =?utf-8?B?cVV2ME4zVWZmY1llMjQrTWFIcDV5N3hUZmNmamluams2cysycnpseHJqTkZm?=
 =?utf-8?B?SXpMMEhicmd2T3JRT1lEMHRrcVpXcWJ3RTBzTkpvVDBBZVFaUGVxVjlmeTRH?=
 =?utf-8?B?MWNaL1BkMFZOM0ZRMFIxc1FybVVEVUh1RzBOK2JXUENPU2RCUnFzc0RMWFVo?=
 =?utf-8?B?bkd5dlorK25FTjhRak5jM3lTcDFjMHJGL29MNTFtcHN6UytyM0c2UTl5K3By?=
 =?utf-8?B?L01acUFRMXdMMUhEbG9JaXpjNlMvNUhrVEFENXo4cTNBeVI2SUFnNVd5TG4w?=
 =?utf-8?B?dmlpanQyTHNrZ0ZyTmIwUnpRT0REMFZNUmVVTkJ5Qkk4OEliQ2pTbkRKMEFO?=
 =?utf-8?B?Z2c9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d08889bc-3977-4990-9b1d-08da66e3bafc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2022 04:29:10.8947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IAalovo9qzsnd7i4bmVbmsZia6e44yEcOrGHQktejU1dDkJUuyF+Qn3hJ03O+xwT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4645
X-Proofpoint-GUID: EjuHs4wTBuRPv9eW6-XceY0RS5FKxwvN
X-Proofpoint-ORIG-GUID: EjuHs4wTBuRPv9eW6-XceY0RS5FKxwvN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-16_02,2022-07-15_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/12/22 7:58 AM, Benjamin Tissoires wrote:
> When a kfunc is not returning a pointer to a struct but to a plain type,
> we can consider it is a valid allocated memory assuming that:
> - one of the arguments is either called rdonly_buf_size or
>    rdwr_buf_size
> - and this argument is a const from the caller point of view
> 
> We can then use this parameter as the size of the allocated memory.
> 
> The memory is either read-only or read-write based on the name
> of the size parameter.

If I understand correctly, this permits a kfunc like
    int *kfunc(..., int rdonly_buf_size);
    ...
    int *p = kfunc(..., 20);
so the 'p' points to a memory buffer with size 20.

This looks like a strange interface although probably there
is a valid reason for this as I didn't participated in
earlier discussions.

> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> 
> ---
> 
> changes in v6:
> - code review from Kartikeya:
>    - remove comment change that had no reasons to be
>    - remove handling of PTR_TO_MEM with kfunc releases
>    - introduce struct bpf_kfunc_arg_meta
>    - do rdonly/rdwr_buf_size check in btf_check_kfunc_arg_match
>    - reverted most of the changes in verifier.c
>    - make sure kfunc acquire is using a struct pointer, not just a plain
>      pointer
>    - also forward ref_obj_id to PTR_TO_MEM in kfunc to not use after free
>      the allocated memory
> 
> changes in v5:
> - updated PTR_TO_MEM comment in btf.c to match upstream
> - make it read-only or read-write based on the name of size
> 
> new in v4
> ---
>   include/linux/bpf.h   | 10 ++++++-
>   include/linux/btf.h   | 12 ++++++++
>   kernel/bpf/btf.c      | 67 ++++++++++++++++++++++++++++++++++++++++---
>   kernel/bpf/verifier.c | 49 +++++++++++++++++++++++--------
>   4 files changed, 121 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 2b21f2a3452f..5b8eadb6e7bc 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1916,12 +1916,20 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
>   			   const char *func_name,
>   			   struct btf_func_model *m);
>   
> +struct bpf_kfunc_arg_meta {
> +	u64 r0_size;
> +	bool r0_rdonly;
> +	int ref_obj_id;
> +	bool multiple_ref_obj_id;
> +};
> +
>   struct bpf_reg_state;
>   int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
>   				struct bpf_reg_state *regs);
>   int btf_check_kfunc_arg_match(struct bpf_verifier_env *env,
>   			      const struct btf *btf, u32 func_id,
> -			      struct bpf_reg_state *regs);
> +			      struct bpf_reg_state *regs,
> +			      struct bpf_kfunc_arg_meta *meta);
>   int btf_prepare_func_args(struct bpf_verifier_env *env, int subprog,
>   			  struct bpf_reg_state *reg);
>   int btf_check_type_match(struct bpf_verifier_log *log, const struct bpf_prog *prog,
> diff --git a/include/linux/btf.h b/include/linux/btf.h
> index 1bfed7fa0428..31da4273c2ec 100644
> --- a/include/linux/btf.h
> +++ b/include/linux/btf.h
> @@ -420,4 +420,16 @@ static inline int register_btf_id_dtor_kfuncs(const struct btf_id_dtor_kfunc *dt
>   }
>   #endif
>   
> +static inline bool btf_type_is_struct_ptr(struct btf *btf, const struct btf_type *t)
> +{
> +	/* t comes in already as a pointer */
> +	t = btf_type_by_id(btf, t->type);
> +
> +	/* allow const */
> +	if (BTF_INFO_KIND(t->info) == BTF_KIND_CONST)
> +		t = btf_type_by_id(btf, t->type);
> +
> +	return btf_type_is_struct(t);
> +}
> +
>   #endif
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 4423045b8ff3..552d7bc05a0c 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -6168,10 +6168,36 @@ static bool is_kfunc_arg_mem_size(const struct btf *btf,
>   	return true;
>   }
>   
> +static bool btf_is_kfunc_arg_mem_size(const struct btf *btf,
> +				      const struct btf_param *arg,
> +				      const struct bpf_reg_state *reg,
> +				      const char *name)
> +{
> +	int len, target_len = strlen(name);
> +	const struct btf_type *t;
> +	const char *param_name;
> +
> +	t = btf_type_skip_modifiers(btf, arg->type, NULL);
> +	if (!btf_type_is_scalar(t) || reg->type != SCALAR_VALUE)
> +		return false;
> +
> +	param_name = btf_name_by_offset(btf, arg->name_off);
> +	if (str_is_empty(param_name))
> +		return false;
> +	len = strlen(param_name);
> +	if (len != target_len)
> +		return false;
> +	if (strncmp(param_name, name, target_len))

strcmp(param_name, name) is enough. len == target_len and both len and
target_len is computed from strlen(...).

> +		return false;
> +
> +	return true;
> +}
> +
>   static int btf_check_func_arg_match(struct bpf_verifier_env *env,
>   				    const struct btf *btf, u32 func_id,
>   				    struct bpf_reg_state *regs,
> -				    bool ptr_to_mem_ok)
> +				    bool ptr_to_mem_ok,
> +				    struct bpf_kfunc_arg_meta *kfunc_meta)
>   {
>   	enum bpf_prog_type prog_type = resolve_prog_type(env->prog);
>   	struct bpf_verifier_log *log = &env->log;
> @@ -6225,6 +6251,30 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
>   
>   		t = btf_type_skip_modifiers(btf, args[i].type, NULL);
>   		if (btf_type_is_scalar(t)) {
> +			if (is_kfunc && kfunc_meta) {
> +				bool is_buf_size = false;
> +
> +				/* check for any const scalar parameter of name "rdonly_buf_size"
> +				 * or "rdwr_buf_size"
> +				 */
> +				if (btf_is_kfunc_arg_mem_size(btf, &args[i], reg,
> +							      "rdonly_buf_size")) {
> +					kfunc_meta->r0_rdonly = true;
> +					is_buf_size = true;
> +				} else if (btf_is_kfunc_arg_mem_size(btf, &args[i], reg,
> +								     "rdwr_buf_size"))
> +					is_buf_size = true;
> +
> +				if (is_buf_size) {
> +					if (kfunc_meta->r0_size) {
> +						bpf_log(log, "2 or more rdonly/rdwr_buf_size parameters for kfunc");
> +						return -EINVAL;
> +					}
> +
> +					kfunc_meta->r0_size = reg->var_off.value;

Did we check 'reg' is a constant somewhere?

> +				}
> +			}
> +
>   			if (reg->type == SCALAR_VALUE)
>   				continue;
>   			bpf_log(log, "R%d is not a scalar\n", regno);
> @@ -6246,6 +6296,14 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
>   		if (ret < 0)
>   			return ret;
>   
> +		/* kptr_get is only valid for kfunc */
> +		if (kfunc_meta && reg->ref_obj_id) {
> +			/* check for any one ref_obj_id to keep track of memory */
> +			if (kfunc_meta->ref_obj_id)
> +				kfunc_meta->multiple_ref_obj_id = true;
> +			kfunc_meta->ref_obj_id = reg->ref_obj_id;
> +		}
> +
>   		/* kptr_get is only true for kfunc */
>   		if (i == 0 && kptr_get) {
>   			struct bpf_map_value_off_desc *off_desc;
> @@ -6441,7 +6499,7 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
>   		return -EINVAL;
>   
>   	is_global = prog->aux->func_info_aux[subprog].linkage == BTF_FUNC_GLOBAL;
> -	err = btf_check_func_arg_match(env, btf, btf_id, regs, is_global);
> +	err = btf_check_func_arg_match(env, btf, btf_id, regs, is_global, NULL);
>   
>   	/* Compiler optimizations can remove arguments from static functions
>   	 * or mismatched type can be passed into a global function.
[...]
