Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60C0A660367
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 16:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235445AbjAFPhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 10:37:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231374AbjAFPhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 10:37:45 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBEAB73E3A;
        Fri,  6 Jan 2023 07:37:44 -0800 (PST)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pDomj-0001nf-BJ; Fri, 06 Jan 2023 16:37:33 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1pDomi-000T50-HK; Fri, 06 Jan 2023 16:37:32 +0100
Subject: Re: [bpf-next v2] bpf: drop deprecated bpf_jit_enable == 2
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "tong@infragraf.org" <tong@infragraf.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.or" 
        <linux-arm-kernel@lists.infradead.or>,
        "loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>
Cc:     Hao Luo <haoluo@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <song@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Jiri Olsa <jolsa@kernel.org>, Hou Tao <houtao1@huawei.com>,
        KP Singh <kpsingh@kernel.org>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        naveen.n.rao@linux.ibm.com, mpe@ellerman.id.au
References: <20230105030614.26842-1-tong@infragraf.org>
 <ea7673e1-40ec-18be-af89-5f4fd0f71742@csgroup.eu>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <71c83f39-f85f-d990-95b7-ab6068839e6c@iogearbox.net>
Date:   Fri, 6 Jan 2023 16:37:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <ea7673e1-40ec-18be-af89-5f4fd0f71742@csgroup.eu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26773/Fri Jan  6 09:48:44 2023)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/23 6:53 PM, Christophe Leroy wrote:
> Le 05/01/2023 à 04:06, tong@infragraf.org a écrit :
>> From: Tonghao Zhang <tong@infragraf.org>
>>
>> The x86_64 can't dump the valid insn in this way. A test BPF prog
>> which include subprog:
>>
>> $ llvm-objdump -d subprog.o
>> Disassembly of section .text:
>> 0000000000000000 <subprog>:
>>          0:       18 01 00 00 73 75 62 70 00 00 00 00 72 6f 67 00 r1 = 29114459903653235 ll
>>          2:       7b 1a f8 ff 00 00 00 00 *(u64 *)(r10 - 8) = r1
>>          3:       bf a1 00 00 00 00 00 00 r1 = r10
>>          4:       07 01 00 00 f8 ff ff ff r1 += -8
>>          5:       b7 02 00 00 08 00 00 00 r2 = 8
>>          6:       85 00 00 00 06 00 00 00 call 6
>>          7:       95 00 00 00 00 00 00 00 exit
>> Disassembly of section raw_tp/sys_enter:
>> 0000000000000000 <entry>:
>>          0:       85 10 00 00 ff ff ff ff call -1
>>          1:       b7 00 00 00 00 00 00 00 r0 = 0
>>          2:       95 00 00 00 00 00 00 00 exit
>>
>> kernel print message:
>> [  580.775387] flen=8 proglen=51 pass=3 image=ffffffffa000c20c from=kprobe-load pid=1643
>> [  580.777236] JIT code: 00000000: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
>> [  580.779037] JIT code: 00000010: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
>> [  580.780767] JIT code: 00000020: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
>> [  580.782568] JIT code: 00000030: cc cc cc
>>
>> $ bpf_jit_disasm
>> 51 bytes emitted from JIT compiler (pass:3, flen:8)
>> ffffffffa000c20c + <x>:
>>      0:   int3
>>      1:   int3
>>      2:   int3
>>      3:   int3
>>      4:   int3
>>      5:   int3
>>      ...
>>
>> Until bpf_jit_binary_pack_finalize is invoked, we copy rw_header to header
>> and then image/insn is valid. BTW, we can use the "bpftool prog dump" JITed instructions.
> 
> NACK.
> 
> Because the feature is buggy on x86_64, you remove it for all
> architectures ?
> 
> On powerpc bpf_jit_enable == 2 works and is very usefull.
> 
> Last time I tried to use bpftool on powerpc/32 it didn't work. I don't
> remember the details, I think it was an issue with endianess. Maybe it
> is fixed now, but it needs to be verified.
> 
> So please, before removing a working and usefull feature, make sure
> there is an alternative available to it for all architectures in all
> configurations.
> 
> Also, I don't think bpftool is usable to dump kernel BPF selftests.
> That's vital when a selftest fails if you want to have a chance to
> understand why it fails.

If this is actively used by JIT developers and considered useful, I'd be
ok to leave it for the time being. Overall goal is to reach feature parity
among (at least major arch) JITs and not just have most functionality only
available on x86-64 JIT. Could you however check what is not working with
bpftool on powerpc/32? Perhaps it's not too much effort to just fix it,
but details would be useful otherwise 'it didn't work' is too fuzzy.

Also, with regards to the last statement that bpftool is not usable to
dump kernel BPF selftests. Could you elaborate some more? I haven't used
bpf_jit_enable == 2 in a long time and for debugging always relied on
bpftool to dump xlated insns or JIT. Or do you mean by BPF selftests
the test_bpf.ko module? Given it has a big batch with kernel-only tests,
there I can see it's probably still useful.

Cheers,
Daniel
