Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1EA375D75
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 01:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbhEFXc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 19:32:58 -0400
Received: from www62.your-server.de ([213.133.104.62]:33950 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbhEFXc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 19:32:57 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lenTG-0002pG-OF; Fri, 07 May 2021 01:31:54 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lenTG-000KXC-G4; Fri, 07 May 2021 01:31:54 +0200
Subject: Re: [PATCH] bpf: Forbid trampoline attach for functions with variable
 arguments
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
References: <20210505132529.401047-1-jolsa@kernel.org>
 <CAEf4BzazQgrPVqKOGP8z=MPZhjZHCZDdcWQB0xBuudXbxXwaXg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c21b54a6-8d6e-f76d-e6c1-95abd8544d9d@iogearbox.net>
Date:   Fri, 7 May 2021 01:31:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzazQgrPVqKOGP8z=MPZhjZHCZDdcWQB0xBuudXbxXwaXg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26162/Thu May  6 13:11:07 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/5/21 8:45 PM, Andrii Nakryiko wrote:
> On Wed, May 5, 2021 at 6:42 AM Jiri Olsa <jolsa@kernel.org> wrote:
>>
>> We can't currently allow to attach functions with variable arguments.
>> The problem is that we should save all the registers for arguments,
>> which is probably doable, but if caller uses more than 6 arguments,
>> we need stack data, which will be wrong, because of the extra stack
>> frame we do in bpf trampoline, so we could crash.
>>
>> Also currently there's malformed trampoline code generated for such
>> functions at the moment as described in:
>>    https://lore.kernel.org/bpf/20210429212834.82621-1-jolsa@kernel.org/
>>
>> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>> ---
> 
> LGTM.
> 
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> 
>>   kernel/bpf/btf.c | 13 +++++++++++++
>>   1 file changed, 13 insertions(+)
>>
>> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
>> index 0600ed325fa0..161511bb3e51 100644
>> --- a/kernel/bpf/btf.c
>> +++ b/kernel/bpf/btf.c
>> @@ -5206,6 +5206,13 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
>>          m->ret_size = ret;
>>
>>          for (i = 0; i < nargs; i++) {
>> +               if (i == nargs - 1 && args[i].type == 0) {
>> +                       bpf_log(log,
>> +                               "The function %s with variable args is unsupported.\n",
>> +                               tname);
>> +                       return -EINVAL;
>> +

(Jiri, fyi, I removed this extra newline while applying. Please scan for such
things before submitting.)

>> +               }
>>                  ret = __get_type_size(btf, args[i].type, &t);
>>                  if (ret < 0) {
>>                          bpf_log(log,
>> @@ -5213,6 +5220,12 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
>>                                  tname, i, btf_kind_str[BTF_INFO_KIND(t->info)]);
>>                          return -EINVAL;
>>                  }
>> +               if (ret == 0) {
>> +                       bpf_log(log,
>> +                               "The function %s has malformed void argument.\n",
>> +                               tname);
>> +                       return -EINVAL;
>> +               }
>>                  m->arg_size[i] = ret;
>>          }
>>          m->nr_args = nargs;
>> --
>> 2.30.2
>>

