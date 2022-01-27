Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D917C49EDC3
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 22:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234210AbiA0VvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 16:51:21 -0500
Received: from www62.your-server.de ([213.133.104.62]:34796 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231481AbiA0VvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 16:51:20 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nDCfc-000AAR-Tk; Thu, 27 Jan 2022 22:51:09 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nDCfc-0000SR-Ig; Thu, 27 Jan 2022 22:51:08 +0100
Subject: Re: [PATCH bpf-next] bpf, x86: remove unnecessary handling of BPF_SUB
 atomic op
To:     Brendan Jackman <jackmanb@google.com>, Hou Tao <houtao1@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bpf <bpf@vger.kernel.org>
References: <20220127083240.1425481-1-houtao1@huawei.com>
 <CA+i-1C2HBja-8Am4gHkcrYdkruw0+sOaGDejc9DS-HfYVXVfyQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c0831a45-3d39-891b-b89c-36167421d28b@iogearbox.net>
Date:   Thu, 27 Jan 2022 22:51:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CA+i-1C2HBja-8Am4gHkcrYdkruw0+sOaGDejc9DS-HfYVXVfyQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26435/Thu Jan 27 10:26:27 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/27/22 11:48 AM, Brendan Jackman wrote:
> Yep - BPF_SUB is also excluded in Documentation/networking/filter.rst,
> plus the interpreter and verifier don't support it.
> 
> Thanks,
> 
> Acked-by: Brendan Jackman <jackmanb@google.com>

I was wondering about verifier specifically as well. Added a note to the
commit log that verifier rejects BPF_SUB while applying, thanks!

> On Thu, 27 Jan 2022 at 09:17, Hou Tao <houtao1@huawei.com> wrote:
>>
>> According to the LLVM commit (https://reviews.llvm.org/D72184),
>> sync_fetch_and_sub() is implemented as a negation followed by
>> sync_fetch_and_add(), so there will be no BPF_SUB op and just
>> remove it.
>>
>> Signed-off-by: Hou Tao <houtao1@huawei.com>
>> ---
>>   arch/x86/net/bpf_jit_comp.c | 1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
>> index ce1f86f245c9..5d643ebb1e56 100644
>> --- a/arch/x86/net/bpf_jit_comp.c
>> +++ b/arch/x86/net/bpf_jit_comp.c
>> @@ -787,7 +787,6 @@ static int emit_atomic(u8 **pprog, u8 atomic_op,
>>          /* emit opcode */
>>          switch (atomic_op) {
>>          case BPF_ADD:
>> -       case BPF_SUB:
>>          case BPF_AND:
>>          case BPF_OR:
>>          case BPF_XOR:
>> --
>> 2.29.2
>>

