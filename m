Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6080646D4BB
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 14:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbhLHNvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 08:51:08 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:28288 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbhLHNvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 08:51:07 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J8JPk0h6yzbj62;
        Wed,  8 Dec 2021 21:47:22 +0800 (CST)
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 8 Dec 2021 21:47:34 +0800
Subject: Re: [PATCH bpf-next 4/5] selftests/bpf: add benchmark for
 bpf_strncmp() helper
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20211130142215.1237217-1-houtao1@huawei.com>
 <20211130142215.1237217-5-houtao1@huawei.com>
 <CAEf4BzZLsV_MoUz4VwspzVUbJaXVn0YVsKvf=bL-WPspbw6WGA@mail.gmail.com>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <97a9166f-7eec-49e2-1f94-ae2fc21dcf02@huawei.com>
Date:   Wed, 8 Dec 2021 21:47:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZLsV_MoUz4VwspzVUbJaXVn0YVsKvf=bL-WPspbw6WGA@mail.gmail.com>
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

On 12/7/2021 11:01 AM, Andrii Nakryiko wrote:
> On Tue, Nov 30, 2021 at 6:07 AM Hou Tao <houtao1@huawei.com> wrote:
>> Add benchmark to compare the performance between home-made strncmp()
>> in bpf program and bpf_strncmp() helper. In summary, the performance
>> win of bpf_strncmp() under x86-64 is greater than 18% when the compared
>> string length is greater than 64, and is 179% when the length is 4095.
>> Under arm64 the performance win is even bigger: 33% when the length
>> is greater than 64 and 600% when the length is 4095.
snip
>> +
>> +long hits = 0;
>> +char str[STRNCMP_STR_SZ];
>> +
>> +char _license[] SEC("license") = "GPL";
>> +
>> +static __always_inline int local_strncmp(const char *s1, unsigned int sz,
>> +                                        const char *s2)
>> +{
>> +       int ret = 0;
>> +       unsigned int i;
>> +
>> +       for (i = 0; i < sz; i++) {
>> +               /* E.g. 0xff > 0x31 */
>> +               ret = (unsigned char)s1[i] - (unsigned char)s2[i];
> I'm actually not sure if it will perform subtraction in unsigned form
> (and thus you'll never have a negative result) and then cast to int,
> or not. Why not cast to int instead of unsigned char to be sure?
It is used to handle the character which is greater than or equal with 0x80.
When casting these character into int, the result will be a negative value,
the compare result will always be negative and it is wrong because
0xff should be greater than 0x31.
