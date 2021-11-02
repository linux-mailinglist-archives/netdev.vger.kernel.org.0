Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F1C44264B
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 05:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbhKBEDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 00:03:21 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:30893 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhKBEDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 00:03:20 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Hjx0045LXzcb60;
        Tue,  2 Nov 2021 11:56:00 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 2 Nov 2021 12:00:29 +0800
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 2 Nov 2021 12:00:28 +0800
Subject: Re: [PATCH bpf-next v2 2/2] bpf: disallow BPF_LOG_KERNEL log level
 for sys(BPF_BTF_LOAD)
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        "Andrii Nakryiko" <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20211029135321.94065-1-houtao1@huawei.com>
 <20211029135321.94065-3-houtao1@huawei.com>
 <50a07acf-a9e9-13b1-11c8-fae221acf495@iogearbox.net>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <30561c6f-eac4-cf65-3eb9-1cd790765071@huawei.com>
Date:   Tue, 2 Nov 2021 12:00:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <50a07acf-a9e9-13b1-11c8-fae221acf495@iogearbox.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 11/2/2021 5:59 AM, Daniel Borkmann wrote:
> On 10/29/21 3:53 PM, Hou Tao wrote:
>> BPF_LOG_KERNEL is only used internally, so disallow bpf_btf_load()
>> to set log level as BPF_LOG_KERNEL. The same checking has already
>> been done in bpf_check(), so factor out a helper to check the
>> validity of log attributes and use it in both places.
>>
>> Signed-off-by: Hou Tao <houtao1@huawei.com>
>> ---
>>   include/linux/bpf_verifier.h | 6 ++++++
>>   kernel/bpf/btf.c             | 3 +--
>>   kernel/bpf/verifier.c        | 6 +++---
>>   3 files changed, 10 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
>> index c8a78e830fca..b36a0da8d5cf 100644
>> --- a/include/linux/bpf_verifier.h
>> +++ b/include/linux/bpf_verifier.h
>> @@ -396,6 +396,12 @@ static inline bool bpf_verifier_log_needed(const struct
>> bpf_verifier_log *log)
>>            log->level == BPF_LOG_KERNEL);
>>   }
>>   +static inline bool bpf_verifier_log_attr_valid(const struct
>> bpf_verifier_log *log)
>> +{
>> +    return (log->len_total >= 128 && log->len_total <= UINT_MAX >> 2 &&
>> +        log->level && log->ubuf && !(log->level & ~BPF_LOG_MASK));
>
> nit: No surrounding () needed.
Will fix.
>
> This should probably also get a Fixes tag wrt BPF_LOG_KERNEL exposure?
If log->level is set as BPF_LOG_KERNEL, the only harm is the user-space tool
(still need being bpf_capable()) may flood the kernel with BPF error message,
so i didn't add it. Adding the Fixes tags incurs no harm, so will do in v3.
>
> Is there a need to bump log->len_total for BTF so significantly?
>
I had noticed the values of these two max length are different, but doesn't find
any clue about why the different is necessary. So just use the bigger one for
the simplicity of bpf_verifier_log_attr_valid().  Will pass the required max
length to bpf_verifier_log_attr_valid() in v3.
