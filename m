Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F199228912E
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 20:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731433AbgJISgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 14:36:10 -0400
Received: from www62.your-server.de ([213.133.104.62]:46444 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732766AbgJISfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 14:35:22 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kQxEb-0006Td-LF; Fri, 09 Oct 2020 20:35:17 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kQxEb-000Kp1-Fc; Fri, 09 Oct 2020 20:35:17 +0200
Subject: Re: [PATCH bpf-next v2 3/6] bpf: allow for map-in-map with dynamic
 inner array map entries
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <cover.1602252399.git.daniel@iogearbox.net>
 <48cbc4e24968da275d13bd8797fe32986938f398.1602252399.git.daniel@iogearbox.net>
 <CAEf4BzYVgs0vicVJTeT5yVSrOg=ArJ=BkEoA8KrwdQ8AVQ23Sg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <99c67c05-700e-8f54-7fea-2daa6d19ec9e@iogearbox.net>
Date:   Fri, 9 Oct 2020 20:35:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzYVgs0vicVJTeT5yVSrOg=ArJ=BkEoA8KrwdQ8AVQ23Sg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25952/Fri Oct  9 15:52:40 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/9/20 7:42 PM, Andrii Nakryiko wrote:
> On Fri, Oct 9, 2020 at 7:13 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
[...]
>>   static int percpu_array_map_btf_id;
>>   const struct bpf_map_ops percpu_array_map_ops = {
>>          .map_meta_equal = bpf_map_meta_equal,
>> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
>> index 1110ecd7d1f3..519bf867f065 100644
>> --- a/kernel/bpf/syscall.c
>> +++ b/kernel/bpf/syscall.c
>> @@ -111,7 +111,8 @@ static struct bpf_map *find_and_alloc_map(union bpf_attr *attr)
>>          ops = bpf_map_types[type];
>>          if (!ops)
>>                  return ERR_PTR(-EINVAL);
>> -
>> +       if (ops->map_swap_ops)
>> +               ops = ops->map_swap_ops(attr);
> 
> I'm afraid that this can cause quite a lot of confusion down the road.
> 
> Wouldn't designating -EOPNOTSUPP return code from map_gen_lookup() and
> not inlining in that case as if map_gen_lookup() wasn't even defined
> be a much smaller and more local (semantically) change that achieves
> exactly the same thing? Doesn't seem like switching from u32 to int
> for return value would be a big inconvenience for existing
> implementations of inlining callbacks, right?

I was originally thinking about it, but then decided not to take this path,
for example the ops->map_gen_lookup() patching code has sanity checks for
the u32 return code on whether we patched 0 or too many instructions, so
if there is anything funky going on in one of the map_gen_lookup() that
we'd get a negative code, for example, I don't want to just skip and not
have the verifier bark loudly with "bpf verifier is misconfigured", also
didn't want to make the logic inside fixup_bpf_calls() even more complex,
so the patch here felt simpler & more straight forward to me.

Thanks,
Daniel
