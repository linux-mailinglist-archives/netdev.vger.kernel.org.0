Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86B646F972
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 04:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236258AbhLJDGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 22:06:18 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:55588 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234051AbhLJDGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 22:06:16 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R901e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=chengshuyi@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V-6w0j._1639105359;
Received: from 30.225.28.43(mailfrom:chengshuyi@linux.alibaba.com fp:SMTPD_---0V-6w0j._1639105359)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 10 Dec 2021 11:02:40 +0800
Message-ID: <d15eb127-3d9b-25e3-9865-d8922f5ff889@linux.alibaba.com>
Date:   Fri, 10 Dec 2021 11:02:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH bpf-next] libbpf: Skip the pinning of global data map for
 old kernels.
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>
References: <9eb3216b-a785-9024-0f1d-e5a14dfb025b@linux.alibaba.com>
 <CAEf4BzbtQGnGZTLbTdy1GHK54f5S7YNFQak7BuEfaqGEwqNNJA@mail.gmail.com>
From:   Shuyi Cheng <chengshuyi@linux.alibaba.com>
In-Reply-To: <CAEf4BzbtQGnGZTLbTdy1GHK54f5S7YNFQak7BuEfaqGEwqNNJA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/10/21 1:26 AM, Andrii Nakryiko wrote:
> On Thu, Dec 9, 2021 at 12:44 AM Shuyi Cheng
> <chengshuyi@linux.alibaba.com> wrote:
>>
>>
>> Fix error: "failed to pin map: Bad file descriptor, path:
>> /sys/fs/bpf/_rodata_str1_1."
>>
>> In the old kernel, the global data map will not be created, see [0]. So
>> we should skip the pinning of the global data map to avoid
>> bpf_object__pin_maps returning error.
>>
>> [0]: https://lore.kernel.org/bpf/20211123200105.387855-1-andrii@kernel.org
>>
>> Signed-off-by: Shuyi Cheng <chengshuyi@linux.alibaba.com>
>> ---
>>    tools/lib/bpf/libbpf.c | 4 ++++
>>    1 file changed, 4 insertions(+)
>>
>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> index 6db0b5e8540e..d96cf49cebab 100644
>> --- a/tools/lib/bpf/libbpf.c
>> +++ b/tools/lib/bpf/libbpf.c
>> @@ -7884,6 +7884,10 @@ int bpf_object__pin_maps(struct bpf_object *obj,
>> const char *path)
>>                  char *pin_path = NULL;
>>                  char buf[PATH_MAX];
>>
>> +               if (bpf_map__is_internal(map) &&
>> +                   !kernel_supports(obj, FEAT_GLOBAL_DATA))
> 
> 
> doing the same check in 3 different places sucks. Let's add "bool
> skipped" to struct bpf_map, which will be set in one place (at the map
> creation time) and then check during relocation and during pinning?
>

Agree, thanks.

regards,
Shuyi



>> +                       continue;
>> +
>>                  if (path) {
>>                          int len;
>>
>> --
>> 2.19.1.6.gb485710b
