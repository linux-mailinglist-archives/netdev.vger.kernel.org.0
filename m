Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4B64107DE3
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 10:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfKWJYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 04:24:21 -0500
Received: from www62.your-server.de ([213.133.104.62]:50244 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfKWJYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 04:24:21 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iYReL-0001MN-LN; Sat, 23 Nov 2019 10:24:17 +0100
Received: from [178.197.248.30] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iYReL-0009BW-Bq; Sat, 23 Nov 2019 10:24:17 +0100
Subject: Re: [PATCH bpf-next v2 7/8] bpf, x86: emit patchable direct jump as
 tail call
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <cover.1574452833.git.daniel@iogearbox.net>
 <6ada4c1c9d35eeb5f4ecfab94593dafa6b5c4b09.1574452833.git.daniel@iogearbox.net>
 <CAEf4BzaWhYJAdjs+8-nHHjuKfs6yBB7yx5NH-qNv2tcjiVCVhw@mail.gmail.com>
 <ba52688c-49bf-7897-4ba2-f62f30d501a9@iogearbox.net>
 <CAADnVQJqYE5TAdJ=o8nHSF1mXoXpsVNXcJtWSPQJDn7wUvxR=Q@mail.gmail.com>
 <CAEf4BzZS-yAfYXruzG5+_Wh0Ob4-ChPMPuhcDx4zDoGwUQygcA@mail.gmail.com>
 <20191123061805.grankibnqpae4tnd@ast-mbp.dhcp.thefacebook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1feafabd-7c98-745b-bd9b-2c16d65c24c5@iogearbox.net>
Date:   Sat, 23 Nov 2019 10:24:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191123061805.grankibnqpae4tnd@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25641/Fri Nov 22 11:06:48 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/23/19 7:18 AM, Alexei Starovoitov wrote:
> On Fri, Nov 22, 2019 at 09:00:35PM -0800, Andrii Nakryiko wrote:
>> On Fri, Nov 22, 2019 at 6:28 PM Alexei Starovoitov
>> <alexei.starovoitov@gmail.com> wrote:
>>> On Fri, Nov 22, 2019 at 3:25 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>>>>> +       case BPF_MOD_CALL_TO_NOP:
>>>>>> +       case BPF_MOD_JUMP_TO_NOP:
>>>>>> +               if (old_addr && !new_addr) {
>>>>>> +                       memcpy(new_insn, nop_insn, X86_PATCH_SIZE);
>>>>>> +
>>>>>> +                       prog = old_insn;
>>>>>> +                       ret = emit_patch_fn(&prog, old_addr, ip);
>>>>>> +                       if (ret)
>>>>>> +                               return ret;
>>>>>> +                       break;
>>>>>> +               }
>>>>>> +               return -ENXIO;
>>>>>> +       default:
>>>>>
>>>>> There is this redundancy between BPF_MOD_xxx enums and
>>>>> old_addr+new_addr (both encode what kind of transition it is), which
>>>>> leads to this cumbersome logic. Would it be simpler to have
>>>>> old_addr/new_addr determine whether it's X-to-NOP, NOP-to-Y, or X-to-Y
>>>>> transition, while separate bool or simple BPF_MOD_CALL/BPF_MOD_JUMP
>>>>> enum determining whether it's a call or a jump that we want to update.
>>>>> Seems like that should be a simpler interface overall and cleaner
>>>>> implementation?
>>>>
>>>> Right we can probably simplify it further, I kept preserving the original
>>>> switch from Alexei's code where my assumption was that having the transition
>>>> explicitly spelled out was preferred in here and then based on that doing
>>>> the sanity checks to make sure we don't get bad input from any call-site
>>>> since we're modifying kernel text, e.g. in the bpf_trampoline_update() as
>>>> one example the BPF_MOD_* is a fixed constant input there.
>>>
>>> I guess we can try adding one more argument
>>> bpf_arch_text_poke(ip, BPF_MOD_NOP, old_addr, BPF_MOD_INTO_CALL, new_addr);
>>
>> I was thinking along the lines of:
>>
>> bpf_arch_text_poke(ip, BPF_MOD_CALL (or BPF_MOD_JMP), old_addr, new_addr);
>>
>> old_addr/new_addr being possibly NULL determine NOP/not-a-NOP.
> 
> I see. Something like:
> if (BPF_MOD_CALL) {
>     if (old_addr)
>         memcmp(ip, old_call_insn);
>     else
>         memcmp(ip, nop_insn);
> } else if (BPF_MOD_JMP) {
>     if (old_addr)
>         memcmp(ip, old_jmp_insn);
>     else
>         memcmp(ip, nop_insn);
> }
> I guess that can work.

Ok, will see to come up with a clean simplification in the evening.

Thanks,
Daniel
