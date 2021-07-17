Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4343CC08A
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 03:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232457AbhGQBm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 21:42:57 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:53472 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231772AbhGQBmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 21:42:55 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R741e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=chengshuyi@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0Ug.Dp-t_1626485996;
Received: from B-39YZML7H-2200.local(mailfrom:chengshuyi@linux.alibaba.com fp:SMTPD_---0Ug.Dp-t_1626485996)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 17 Jul 2021 09:39:57 +0800
Subject: Re: [PATCH bpf-next v4 3/3] selftests/bpf: Switches existing
 selftests to using open_opts for custom BTF
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <1626180159-112996-1-git-send-email-chengshuyi@linux.alibaba.com>
 <1626180159-112996-4-git-send-email-chengshuyi@linux.alibaba.com>
 <CAEf4Bza3X410=1ryu4xZ+5ST2=69CB9BDusBrLMX=VSsXtnuDQ@mail.gmail.com>
From:   Shuyi Cheng <chengshuyi@linux.alibaba.com>
Message-ID: <7400a2b2-1e1e-0981-3966-43492305534c@linux.alibaba.com>
Date:   Sat, 17 Jul 2021 09:39:56 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAEf4Bza3X410=1ryu4xZ+5ST2=69CB9BDusBrLMX=VSsXtnuDQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/17/21 4:27 AM, Andrii Nakryiko wrote:
> On Tue, Jul 13, 2021 at 5:43 AM Shuyi Cheng
> <chengshuyi@linux.alibaba.com> wrote:
>>
>> This patch mainly replaces the bpf_object_load_attr of
>> the core_autosize.c and core_reloc.c files with bpf_object_open_opts.
>>
>> Signed-off-by: Shuyi Cheng <chengshuyi@linux.alibaba.com>
>> ---
>>   .../selftests/bpf/prog_tests/core_autosize.c       | 22 ++++++++---------
>>   .../testing/selftests/bpf/prog_tests/core_reloc.c  | 28 ++++++++++------------
>>   2 files changed, 24 insertions(+), 26 deletions(-)
>>
> 
> So I applied this, but it's obvious you haven't bothered even
> *building* selftests, because it had at least one compilation warning
> and one compilation *error*, not building test_progs at all. I've
> noted stuff I fixed (and still remember) below. I understand it might
> be your first kernel contribution, but it's not acceptable to submit
> patches that don't build. Next time please be more thorough.
> 

I'm very sorry, it was my fault. Although I learned a lot from libbpf, 
there is still a lot to learn and improve. Thank you very much for your 
advice and the very powerful libbpf.

regards,
Shuyi

> [...]
> 
>>
>> -       load_attr.obj = skel->obj;
>> -       load_attr.target_btf_path = btf_file;
>> -       err = bpf_object__load_xattr(&load_attr);
>> +       err = bpf_object__load(skel);
> 
> This didn't compile outright, because it should have been
> test_core_autosize__load(skel).
> 
>>          if (!ASSERT_ERR(err, "bad_prog_load"))
>>                  goto cleanup;
>>
>> diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
>> index d02e064..10eb2407 100644
>> --- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
>> +++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
>> @@ -816,7 +816,7 @@ static size_t roundup_page(size_t sz)
>>   void test_core_reloc(void)
>>   {
>>          const size_t mmap_sz = roundup_page(sizeof(struct data));
>> -       struct bpf_object_load_attr load_attr = {};
>> +       struct bpf_object_open_opts open_opts = {};
>>          struct core_reloc_test_case *test_case;
>>          const char *tp_name, *probe_name;
>>          int err, i, equal;
>> @@ -846,9 +846,17 @@ void test_core_reloc(void)
>>                                  continue;
>>                  }
>>
>> -               obj = bpf_object__open_file(test_case->bpf_obj_file, NULL);
>> +               if (test_case->btf_src_file) {
>> +                       err = access(test_case->btf_src_file, R_OK);
>> +                       if (!ASSERT_OK(err, "btf_src_file"))
>> +                               goto cleanup;
>> +               }
>> +
>> +               open_opts.btf_custom_path = test_case->btf_src_file;
> 
> This was reporting a valid warning about dropping const modifier. For
> good reason, becyase btf_custom_path in open_opts should have been
> `const char *`, I fixed that.
> 
>> +               open_opts.sz = sizeof(struct bpf_object_open_opts);
>> +               obj = bpf_object__open_file(test_case->bpf_obj_file, &open_opts);
>>                  if (!ASSERT_OK_PTR(obj, "obj_open"))
>> -                       continue;
>> +                       goto cleanup;
>>
>>                  probe_name = "raw_tracepoint/sys_enter";
>>                  tp_name = "sys_enter";
> 
> [...]
> 
