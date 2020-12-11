Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906E52D80DE
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 22:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395162AbgLKVO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 16:14:28 -0500
Received: from www62.your-server.de ([213.133.104.62]:55052 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395275AbgLKVN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 16:13:57 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1knpiz-000CJ8-1h; Fri, 11 Dec 2020 22:13:13 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1knpiy-000Dlh-Sg; Fri, 11 Dec 2020 22:13:12 +0100
Subject: Re: [PATCH] bpf,x64: pad NOPs to make images converge more easily
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Gary Lin <glin@suse.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        andreas.taschner@suse.com
References: <20201211081903.17857-1-glin@suse.com>
 <CAEf4BzbJRf-+_GE4r2+mk0FjT96Qszx3ru9wEfieP_zr6p6dOw@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a9a00c89-3716-2296-d0d9-bba944e2cd82@iogearbox.net>
Date:   Fri, 11 Dec 2020 22:13:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzbJRf-+_GE4r2+mk0FjT96Qszx3ru9wEfieP_zr6p6dOw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26014/Thu Dec 10 15:21:42 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/11/20 9:58 PM, Andrii Nakryiko wrote:
> On Fri, Dec 11, 2020 at 8:51 AM Gary Lin <glin@suse.com> wrote:
>>
[...]
>> +static int emit_nops(u8 **pprog, int len)
>> +{
>> +       u8 *prog = *pprog;
>> +       int i, noplen, cnt = 0;
>> +
>> +       while (len > 0) {
>> +               noplen = len;
>> +
>> +               if (noplen > ASM_NOP_MAX)
>> +                       noplen = ASM_NOP_MAX;
>> +
>> +               for (i = 0; i < noplen; i++)
>> +                       EMIT1(ideal_nops[noplen][i]);
>> +               len -= noplen;
>> +       }
>> +
>> +       *pprog = prog;
>> +
>> +       return cnt;
> 
> Isn't cnt always zero? I guess it was supposed to be `cnt = len` at
> the beginning?

EMIT*() macros from the JIT will bump cnt internally.

> But then it begs the question how this patch was actually tested given
> emit_nops() is returning wrong answers? Changes like this should
> definitely come with tests.

Yeah, applying a change like this without tests for the corner cases it is trying
to fix would be no go, so they are definitely needed, ideally also with disasm dump
of the relevant code and detailed analysis to show why it's bullet-proof.

>> +#define INSN_SZ_DIFF (((addrs[i] - addrs[i - 1]) - (prog - temp)))
>> +
>>   static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
>> -                 int oldproglen, struct jit_context *ctx)
>> +                 int oldproglen, struct jit_context *ctx, bool jmp_padding)
>>   {
>>          bool tail_call_reachable = bpf_prog->aux->tail_call_reachable;
>>          struct bpf_insn *insn = bpf_prog->insnsi;
>> @@ -1409,6 +1432,8 @@ xadd:                     if (is_imm8(insn->off))
>>                          }
>>                          jmp_offset = addrs[i + insn->off] - addrs[i];
>>                          if (is_imm8(jmp_offset)) {
>> +                               if (jmp_padding)
>> +                                       cnt += emit_nops(&prog, INSN_SZ_DIFF - 2);
>>                                  EMIT2(jmp_cond, jmp_offset);
>>                          } else if (is_simm32(jmp_offset)) {
>>                                  EMIT2_off32(0x0F, jmp_cond + 0x10, jmp_offset);
>> @@ -1431,11 +1456,19 @@ xadd:                   if (is_imm8(insn->off))
>>                          else
>>                                  jmp_offset = addrs[i + insn->off] - addrs[i];
>>
>> -                       if (!jmp_offset)
>> -                               /* Optimize out nop jumps */
>> +                       if (!jmp_offset) {
>> +                               /*
>> +                                * If jmp_padding is enabled, the extra nops will
>> +                                * be inserted. Otherwise, optimize out nop jumps.
>> +                                */
>> +                               if (jmp_padding)
>> +                                       cnt += emit_nops(&prog, INSN_SZ_DIFF);
>>                                  break;
>> +                       }
>>   emit_jmp:
>>                          if (is_imm8(jmp_offset)) {
>> +                               if (jmp_padding)
>> +                                       cnt += emit_nops(&prog, INSN_SZ_DIFF - 2);
>>                                  EMIT2(0xEB, jmp_offset);
>>                          } else if (is_simm32(jmp_offset)) {
>>                                  EMIT1_off32(0xE9, jmp_offset);
>> @@ -1578,26 +1611,6 @@ static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
>>          return 0;
>>   }
>>
>> -static void emit_nops(u8 **pprog, unsigned int len)
>> -{
>> -       unsigned int i, noplen;
>> -       u8 *prog = *pprog;
>> -       int cnt = 0;
>> -
>> -       while (len > 0) {
>> -               noplen = len;
>> -
>> -               if (noplen > ASM_NOP_MAX)
>> -                       noplen = ASM_NOP_MAX;
>> -
>> -               for (i = 0; i < noplen; i++)
>> -                       EMIT1(ideal_nops[noplen][i]);
>> -               len -= noplen;
>> -       }
>> -
>> -       *pprog = prog;
>> -}
>> -
>>   static void emit_align(u8 **pprog, u32 align)
>>   {
>>          u8 *target, *prog = *pprog;
>> @@ -1972,6 +1985,9 @@ struct x64_jit_data {
>>          struct jit_context ctx;
>>   };
>>
>> +#define MAX_PASSES 20
>> +#define PADDING_PASSES (MAX_PASSES - 5)
>> +
>>   struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>>   {
>>          struct bpf_binary_header *header = NULL;
>> @@ -1981,6 +1997,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>>          struct jit_context ctx = {};
>>          bool tmp_blinded = false;
>>          bool extra_pass = false;
>> +       bool padding = prog->padded;
> 
> can this ever be true on assignment? I.e., can the program be jitted twice?

Yes, progs can be passed into the JIT twice, see also jit_subprogs(). In one of
the earlier patches it would still potentially change the image size a second
time which would break subprogs aka bpf2bpf calls.

>>          u8 *image = NULL;
>>          int *addrs;
>>          int pass;
>> @@ -2043,7 +2060,9 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>>           * pass to emit the final image.
>>           */
>>          for (pass = 0; pass < 20 || image; pass++) {
>> -               proglen = do_jit(prog, addrs, image, oldproglen, &ctx);
>> +               if (!padding && pass >= PADDING_PASSES)
>> +                       padding = true;
> 
[...]
