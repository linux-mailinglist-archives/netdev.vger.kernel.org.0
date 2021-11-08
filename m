Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE0F4480CB
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 15:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237588AbhKHOIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 09:08:25 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:14727 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236375AbhKHOIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 09:08:24 -0500
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HntB2516HzZcxc;
        Mon,  8 Nov 2021 22:03:22 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Mon, 8 Nov 2021 22:05:34 +0800
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Mon, 8 Nov 2021 22:05:33 +0800
Subject: Re: [RFC PATCH bpf-next 2/2] selftests/bpf: add benchmark bpf_strcmp
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20211106132822.1396621-1-houtao1@huawei.com>
 <20211106132822.1396621-3-houtao1@huawei.com>
 <20211106184307.7gbztgkeprktbohz@ast-mbp.dhcp.thefacebook.com>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <c8f473f7-57ec-3161-e634-fc2e6925ec3d@huawei.com>
Date:   Mon, 8 Nov 2021 22:05:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20211106184307.7gbztgkeprktbohz@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HI,

On 11/7/2021 2:43 AM, Alexei Starovoitov wrote:
> On Sat, Nov 06, 2021 at 09:28:22PM +0800, Hou Tao wrote:
>> The benchmark runs a loop 5000 times. In the loop it reads the file name
>> from kprobe argument into stack by using bpf_probe_read_kernel_str(),
>> and compares the file name with a target character or string.
>>
>> Three cases are compared: only compare one character, compare the whole
>> string by a home-made strncmp() and compare the whole string by
>> bpf_strcmp().
>>
>> The following is the result:
>>
>> x86-64 host:
>>
>> one character: 2613499 ns
>> whole str by strncmp: 2920348 ns
>> whole str by helper: 2779332 ns
>>
>> arm64 host:
>>
>> one character: 3898867 ns
>> whole str by strncmp: 4396787 ns
>> whole str by helper: 3968113 ns
>>
>> Compared with home-made strncmp, the performance of bpf_strncmp helper
>> improves 80% under x86-64 and 600% under arm64. The big performance win
>> on arm64 may comes from its arch-optimized strncmp().
> 80% and 600% improvement?!
> I don't understand how this math works.
> Why one char is barely different in total nsec than the whole string?
> The string shouldn't miscompare on the first char as far as I understand the test.
Because the result of "one character" includes the overhead of process filtering and
string read.
My bad, I should explain the tests results in more details.

Three tests are exercised:

(1) one character
Filter unexpected caller by bpf_get_current_pid_tgid()
Use bpf_probe_read_kernel_str() to read the file name into 64-bytes sized-buffer
in stack
Only compare the first character of file name

(2) whole str by strncmp
Filter unexpected caller by bpf_get_current_pid_tgid()
Use bpf_probe_read_kernel_str() to read the file name into 64-bytes sized-buffer
in stack
Compare by using home-made strncmp(): the compared two strings are the same, so
the whole string is compared

(3) whole str by helper
Filter unexpected caller by bpf_get_current_pid_tgid()
Use bpf_probe_read_kernel_str() to read the file name into 64-bytes sized-buffer
in stack
Compare by using bpf_strncmp: the compared two strings are the same, so
the whole string is compared

Now "(1) one character" is used to calculate the overhead of process filtering and
string read. So under x86-64, the overhead of strncmp() is

  total time of whole str by strncmp  test  - total time of no character test =
306849 ns.

The overhead of bpf_strncmp() is:
  total time of whole str by helper test - total time of no character test =
165833 ns

So the performance win is about (306849  / 165833 ) * 100 - 100 = ~85%

And the win under arm64 is about (497920 / 69246) * 100 - 100 = ~600%
