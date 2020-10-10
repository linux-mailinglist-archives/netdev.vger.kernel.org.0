Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A175628A480
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387557AbgJJXmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 19:42:11 -0400
Received: from www62.your-server.de ([213.133.104.62]:55856 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727138AbgJJXmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 19:42:10 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kROV4-0008NK-Rj; Sun, 11 Oct 2020 01:42:06 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kROV4-000QIh-Bj; Sun, 11 Oct 2020 01:42:06 +0200
Subject: Re: [PATCH bpf-next v5 3/6] bpf: allow for map-in-map with dynamic
 inner array map entries
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20201010205447.5610-1-daniel@iogearbox.net>
 <20201010205447.5610-4-daniel@iogearbox.net>
 <CAEf4BzZjDVqH3feow2Jzp--+akegVp5yrDdMyzB6EiD6U2ddDQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6479a661-6681-94eb-b266-ddced88429cb@iogearbox.net>
Date:   Sun, 11 Oct 2020 01:42:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZjDVqH3feow2Jzp--+akegVp5yrDdMyzB6EiD6U2ddDQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25953/Sat Oct 10 15:55:36 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/20 12:02 AM, Andrii Nakryiko wrote:
> On Sat, Oct 10, 2020 at 1:54 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
[...]
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index f3e36eade3d4..d578875df1ad 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -11049,6 +11049,8 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
>>                          if (insn->imm == BPF_FUNC_map_lookup_elem &&
>>                              ops->map_gen_lookup) {
>>                                  cnt = ops->map_gen_lookup(map_ptr, insn_buf);
>> +                               if (cnt < 0)
>> +                                       goto patch_map_ops_generic;
> 
> but now any reported error will be silently skipped. The logic should be:
> 
> if (cnt == -EOPNOTSUPP)
>      goto patch_map_ops_generic;
> if (cnt <= 0 || cnt >= ARRAY_SIZE(insn_buf))
>      verbose(env, "bpf verifier is misconfigured\n");
> 
> This way only -EOPNOTSUPP is silently skipped, all other cases where
> error is returned, cnt == 0, or cnt is too big would be reported as
> error.

Fair enough, I might have misunderstood earlier mail, but agree, that one is more
robust overall. Fixed.

Thanks,
Daniel
