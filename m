Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605111BFDE9
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 16:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbgD3OXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 10:23:48 -0400
Received: from www62.your-server.de ([213.133.104.62]:45380 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbgD3OXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 10:23:48 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jUA6I-00086y-K3; Thu, 30 Apr 2020 16:23:42 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jUA6I-000JJ2-3f; Thu, 30 Apr 2020 16:23:42 +0200
Subject: Re: [PATCH bpf-next] bpf, riscv: Fix stack layout of JITed code on
 RV32
To:     Xi Wang <xi.wang@gmail.com>,
        Luke Nelson <lukenels@cs.washington.edu>
Cc:     bpf@vger.kernel.org, Luke Nelson <luke.r.nels@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, netdev@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20200430005127.2205-1-luke.r.nels@gmail.com>
 <CAKU6vybAuF-oziH8oOu1oCv+j8SLOMWq2UdM6_kVCbeggLvxSA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <61bfa5f6-eb21-3767-11c6-d8be46871c0e@iogearbox.net>
Date:   Thu, 30 Apr 2020 16:23:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAKU6vybAuF-oziH8oOu1oCv+j8SLOMWq2UdM6_kVCbeggLvxSA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25798/Thu Apr 30 14:03:33 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/30/20 4:14 AM, Xi Wang wrote:
> On Wed, Apr 29, 2020 at 5:51 PM Luke Nelson <lukenels@cs.washington.edu> wrote:
>>
>> This patch fixes issues with stackframe unwinding and alignment in the
>> current stack layout for BPF programs on RV32.
>>
>> In the current layout, RV32 fp points to the JIT scratch registers, rather
>> than to the callee-saved registers. This breaks stackframe unwinding,
>> which expects fp to point just above the saved ra and fp registers.
>>
>> This patch fixes the issue by moving the callee-saved registers to be
>> stored on the top of the stack, pointed to by fp. This satisfies the
>> assumptions of stackframe unwinding.
>>
>> This patch also fixes an issue with the old layout that the stack was
>> not aligned to 16 bytes.
>>
>> Stacktrace from JITed code using the old stack layout:
>>
>>    [   12.196249 ] [<c0402200>] walk_stackframe+0x0/0x96
>>
>> Stacktrace using the new stack layout:
>>
>>    [   13.062888 ] [<c0402200>] walk_stackframe+0x0/0x96
>>    [   13.063028 ] [<c04023c6>] show_stack+0x28/0x32
>>    [   13.063253 ] [<a403e778>] bpf_prog_82b916b2dfa00464+0x80/0x908
>>    [   13.063417 ] [<c09270b2>] bpf_test_run+0x124/0x39a
>>    [   13.063553 ] [<c09276c0>] bpf_prog_test_run_skb+0x234/0x448
>>    [   13.063704 ] [<c048510e>] __do_sys_bpf+0x766/0x13b4
>>    [   13.063840 ] [<c0485d82>] sys_bpf+0xc/0x14
>>    [   13.063961 ] [<c04010f0>] ret_from_syscall+0x0/0x2
>>
>> The new code is also simpler to understand and includes an ASCII diagram
>> of the stack layout.
>>
>> Tested on riscv32 QEMU virt machine.
>>
>> Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
> 
> Thanks for the fix!
> 
> Acked-by: Xi Wang <xi.wang@gmail.com> 

Applied, thanks everyone!
