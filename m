Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523F744807A
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 14:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238673AbhKHNsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 08:48:20 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:30929 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240182AbhKHNsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 08:48:19 -0500
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Hnsgs1RTfzcb6p;
        Mon,  8 Nov 2021 21:40:41 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Mon, 8 Nov 2021 21:45:29 +0800
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Mon, 8 Nov 2021 21:45:28 +0800
Subject: Re: [RFC PATCH bpf-next 1/2] bpf: add bpf_strncmp helper
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20211106132822.1396621-1-houtao1@huawei.com>
 <20211106132822.1396621-2-houtao1@huawei.com>
 <20211106192602.knmfk2x7ogcjuzvw@ast-mbp.dhcp.thefacebook.com>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <67bd8a7e-aef2-7556-e16c-b94e9a2d0ba8@huawei.com>
Date:   Mon, 8 Nov 2021 21:45:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20211106192602.knmfk2x7ogcjuzvw@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 11/7/2021 3:26 AM, Alexei Starovoitov wrote:
> On Sat, Nov 06, 2021 at 09:28:21PM +0800, Hou Tao wrote:
>> The helper compares two strings: one string is a null-terminated
>> read-only string, and another one has const max storage size. And
>> it can be used to compare file name in tracing or LSM program.
>>
>> We don't check whether or not s2 in bpf_strncmp() is null-terminated,
>> because its content may be changed by malicous program, and we only
>> ensure the memory accessed is bounded by s2_sz.
> I think "malicous" adjective is unnecessary and misleading.
> It's also misspelled.
> Just mention that 2nd argument doesn't have to be null terminated.
Will do.
>> + * long bpf_strncmp(const char *s1, const char *s2, u32 s2_sz)
> ...
>> +BPF_CALL_3(bpf_strncmp, const char *, s1, const char *, s2, size_t, s2_sz)
> probably should match u32 instead of size_t.
Yes, will use u32 instead. I forgot to synchronize between these two declarations.
>
>> @@ -1210,6 +1210,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>>  		return &bpf_get_branch_snapshot_proto;
>>  	case BPF_FUNC_trace_vprintk:
>>  		return bpf_get_trace_vprintk_proto();
>> +	case BPF_FUNC_strncmp:
>> +		return &bpf_strncmp_proto;
> why tracing only?
> Should probably be in bpf_base_func_proto.
Because in our use case, bpf_strncmp() is only used by tracing program, but moving
it to bpf_base_func_proto() incurs no harm, so will do it.
>
> I was thinking whether the proto could be:
> long bpf_strncmp(const char *s1, u32 s1_sz, const char *s2)
> but I think your version is better though having const string as 1st arg
> is a bit odd in normal C.
>
> Would it make sense to add bpf_memchr as well while we are at it?
> And
> static inline bpf_strnlen(const char *s, u32 sz)
> {
>   return bpf_memchr(s, sz, 0);
> }
> to bpf_helpers.h ?
> .
It is OK to add it, although I don't have a use case for it.

