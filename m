Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94A6647E2D3
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 13:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348085AbhLWMCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 07:02:33 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:33905 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236028AbhLWMCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 07:02:32 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JKTML1tGGzcbtX;
        Thu, 23 Dec 2021 20:02:06 +0800 (CST)
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 23 Dec 2021 20:02:29 +0800
From:   Hou Tao <houtao1@huawei.com>
Subject: Re: [RFC PATCH bpf-next 0/3] support string key for hash-table
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <yunbo.xufeng@linux.alibaba.com>
References: <20211219052245.791605-1-houtao1@huawei.com>
 <20211220030013.4jsnm367ckl5ksi5@ast-mbp.dhcp.thefacebook.com>
Message-ID: <2b86cdf9-0a7a-8919-b25f-29743f956c1f@huawei.com>
Date:   Thu, 23 Dec 2021 20:02:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20211220030013.4jsnm367ckl5ksi5@ast-mbp.dhcp.thefacebook.com>
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

On 12/20/2021 11:00 AM, Alexei Starovoitov wrote:
> On Sun, Dec 19, 2021 at 01:22:42PM +0800, Hou Tao wrote:
>> Hi,
>>
>> In order to use string as hash-table key, key_size must be the storage
>> size of longest string. If there are large differencies in string
>> length, the hash distribution will be sub-optimal due to the unused
>> zero bytes in shorter strings and the lookup will be inefficient due to
>> unnecessary memcpy().
>>
>> Also it is possible the unused part of string key returned from bpf helper
>> (e.g. bpf_d_path) is not mem-zeroed and if using it directly as lookup key,
>> the lookup will fail with -ENOENT (as reported in [1]).
>>
>> The patchset tries to address the inefficiency by adding support for
>> string key. During the key comparison, the string length is checked
>> first to reduce the uunecessary memcmp. Also update the hash function
>> from jhash() to full_name_hash() to reduce hash collision of string key.
>>
>> There are about 16% and 106% improvment in benchmark under x86-64 and
>> arm64 when key_size is 256. About 45% and %161 when key size is greater
>> than 1024.
>>
>> Also testing the performance improvment by using all files under linux
>> kernel sources as the string key input. There are about 74k files and the
>> maximum string length is 101. When key_size is 104, there are about 9%
>> and 35% win under x86-64 and arm64 in lookup performance, and when key_size
>> is 256, the win increases to 78% and 109% respectively.
>>
>> Beside the optimization of lookup for string key, it seems that the
>> allocated space for BPF_F_NO_PREALLOC-case can also be optimized. More
>> trials and tests will be conducted if the idea of string key is accepted.
> It will work when the key is a string. Sooner or later somebody would need
> the key to be a string and few other integers or pointers.
> This approach will not be usable.
> Much worse, this approach will be impossible to extend.
Although we can format other no-string fields in key into string and still use
one string as the only key, but you are right, the combination of string and
other types as hash key is common, the optimization on string key will not
be applicable to these common cases.
> Have you considered a more generic string support?
> Make null terminated string to be a fist class citizen.
> wdyt?
The generic string support is a good idea. It needs to fulfill the following
two goals:
1) remove the unnecessary memory zeroing when update or lookup
hash-table
2) optimize for hash generation and key comparison

The first solution comes to me is to add a variable-sized: struct bpf_str and
use it as the last field of hash table key:

struct bpf_str {
    /* string hash */
    u32 hash;
    u32 len;
    char raw[0];
};

struct htab_key {
    __u32 cookies;
    struct bpf_str name;
};

For hash generation, the length for jhash() will be sizeof(htab_key). During
key comparison, we need to compare htab_key firstly, if these values are
the same,  then compare htab_key.name.raw. However if there are multiple
strings in htab_key, the definition of bpf_str will change as showed below.
The reference to the content of *name* will depends on the length of
*location*. It is a little wired and hard to use. Maybe we can concatenate
these two strings into one string by zero-byte to make it work.

struct bpf_str {
    /* string hash */
    u32 hash;
    u32 len;
};

struct htab_key {
    __u32 cookies;
    struct bpf_str location;
    struct bpf_str name;
    char raw[0];
};

Another solution is assign a per-map unique id to the string. So the definition
of bpf_str will be:

struct bpf_str {
    __u64 uid;
};

Before using a string, we need to convert it to a unique id by using bpf syscall
or a bpf_helper(). And the mapping of string-to-[unique-id, ref cnt] will be saved
as a string key hash table in the map. So there are twofold hash-table lookup
in this implementation and performance may be bad.

Do you have other suggestions ?

Regards.
Tao
> .

