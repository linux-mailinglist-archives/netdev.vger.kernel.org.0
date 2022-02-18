Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E255B4BBA57
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 14:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234905AbiBRNyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 08:54:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbiBRNyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 08:54:20 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DB5297236;
        Fri, 18 Feb 2022 05:54:00 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4K0Y4D4DD0z8wpb;
        Fri, 18 Feb 2022 21:50:36 +0800 (CST)
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 18 Feb 2022 21:53:57 +0800
Subject: Re: [RFC PATCH bpf-next v2 0/3] bpf: support string key in htab
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Joanne Koong <joannekoong@fb.com>
References: <20220214111337.3539-1-houtao1@huawei.com>
 <20220217035041.axk46atz7j4svi2k@ast-mbp.dhcp.thefacebook.com>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <3b968224-c086-a8b6-159a-55db7ec46011@huawei.com>
Date:   Fri, 18 Feb 2022 21:53:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20220217035041.axk46atz7j4svi2k@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2/17/2022 11:50 AM, Alexei Starovoitov wrote:
> On Mon, Feb 14, 2022 at 07:13:34PM +0800, Hou Tao wrote:
>> Hi,
>>
>> In order to use string as hash-table key, key_size must be the storage
>> size of longest string. If there are large differencies in string
>> length, the hash distribution will be sub-optimal due to the unused
>> zero bytes in shorter strings and the lookup will be inefficient due to
>> unnecessary memcmp().
>>
>> Also it is possible the unused part of string key returned from bpf helper
>> (e.g. bpf_d_path) is not mem-zeroed and if using it directly as lookup key,
>> the lookup will fail with -ENOENT (as reported in [1]).
>>
>> The patchset tries to address the inefficiency by adding support for
>> string key. There is extensibility problem in v1 because the string key
>> and its optimization is only available for string-only key. To make it
>> extensible, v2 introduces bpf_str_key_stor and bpf_str_key_desc and enforce
>> the layout of hash key struct through BTF as follows:
>>
>> 	>the start of hash key
>> 	...
>> 	[struct bpf_str_key_desc m;]
>> 	...
>> 	[struct bpf_str_key_desc n;]
>> 	...
>> 	struct bpf_str_key_stor z;
>> 	unsigned char raw[N];
>> 	>the end of hash key
> Sorry, but this is dead end.
> The v2 didn't fundamentally change the design.
> The bpf_str_key_desc has an offset field, but it's unused.
It is used during key comparison to ensure the offset and length of
sub-strings are the same and it also can be used to locate the sub-string
from the raw array.
> The len field is dynamically checked at run-time and all hash maps
> users will be paying that penalty though majority will not be
> using this feature.
> This patch set is incredibly specific solution to one task.
> It's far from being generic. We cannot extend bpf this way.
> All building blocks must be as generic as possible.
Yes, you are right. I worked in the wrong direction. I tried to keep
the change set being small and good performance, but forget that it is
not generic enough.
> If you want strings as a key then the key must be variable size.
> This patch doesn't make them so. It still requires some
> predefined fixed size for largest string. This is no go.
> Variable sized key means truly variable to megabytes long.
> The key would need to contain an object (a pointer wrap) to
> a variable sized object. And this object can be arbitrary
> blob of bytes. Not just null terminated string.
> We've been thinking about "dynamic pointer" concept where
> pointer + length will be represented as an object.
I have seen the proposal from Joanne Koong on "dynamic pointers".
It can solve the storage problem of string, but the lookup of
string is still a problem. Hash is a option but can we support
two dynamic pointers points to the same internal object and use
the id of the internal object to represent the string ?
> The program will be able to allocate it and persist into a map value
> and potentially into a map key.
> For storing a bunch of strings one can use a strong hash and store
> that hash in the key while keeping full string as a variable sized
> object inside the value.
Will using a strong hash function impact the lookup performance because
each lookup will need to calculate the hash ?

> Another approach is to introduce a trie to store strings, or dfa,
> or aho-corasick, etc. There are plenty of data structures that are
> more suitable for storing and searching strings depending on the use case.
> Using hash table for strings has its downsides.
> .
Before add support for string key in hash table, we had implement tries,
ternary search tree and hash table in user-space for string lookup. hash
table shows better performance and memory usage, so we decide to do string
support in hash table. We will revisit our tests and investigate new string
data structures.

Regards,
Tao

