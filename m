Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCDC403861
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 12:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349120AbhIHK6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 06:58:13 -0400
Received: from mail.loongson.cn ([114.242.206.163]:53808 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1349050AbhIHK6J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 06:58:09 -0400
Received: from [10.130.0.135] (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dx72vcljhh9KYBAA--.6557S3;
        Wed, 08 Sep 2021 18:56:29 +0800 (CST)
Subject: Re: [RFC PATCH bpf-next] bpf: Make actual max tail call count as
 MAX_TAIL_CALL_CNT
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Shubham Bansal <illusionist.neo@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Paul Burton <paulburton@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        naveen.n.rao@linux.ibm.com, Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, bjorn@kernel.org,
        davem@davemloft.net
References: <1631089206-5931-1-git-send-email-yangtiezhu@loongson.cn>
 <e05e7407-74bb-3ba3-aab7-f62ca16a59ba@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Paul Chaignon <paul@cilium.io>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
Message-ID: <9d0ca1ba-b8e1-dc99-17f4-189571f33c97@loongson.cn>
Date:   Wed, 8 Sep 2021 18:56:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <e05e7407-74bb-3ba3-aab7-f62ca16a59ba@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: AQAAf9Dx72vcljhh9KYBAA--.6557S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWF1UWFWxCryfCFW5KrWxZwb_yoW5Xry8pr
        W7Way8KF4kXF1Sy3ZFgw1xZa40va95Jr98WF1fCrWakFs8AF15K3WSkrW09F909r4rua4j
        qws7uFyUC3WkAF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9mb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I
        8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVW8JVWxJw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l
        c7I2V7IY0VAS07AlzVAYIcxG8wCY02Avz4vE14v_Gw1l42xK82IYc2Ij64vIr41l4I8I3I
        0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWU
        GVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI
        0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0
        rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr
        0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07bOuciUUUUU=
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/08/2021 04:47 PM, Daniel Borkmann wrote:
> [ You have a huge Cc list, but forgot to add Paul and Johan who recently
>   looked into this. Added here. ]
>
> On 9/8/21 10:20 AM, Tiezhu Yang wrote:
>> In the current code, the actual max tail call count is 33 which is 
>> greater
>> than MAX_TAIL_CALL_CNT, this is not consistent with the intended meaning
>> in the commit 04fd61ab36ec ("bpf: allow bpf programs to tail-call other
>> bpf programs"):
>>
>> "The chain of tail calls can form unpredictable dynamic loops therefore
>> tail_call_cnt is used to limit the number of calls and currently is set
>> to 32."
>>
>> Additionally, after commit 874be05f525e ("bpf, tests: Add tail call test
>> suite"), we can see there exists failed testcase.
>>
>> On all archs when CONFIG_BPF_JIT_ALWAYS_ON is not set:
>>   # echo 0 > /proc/sys/net/core/bpf_jit_enable
>>   # modprobe test_bpf
>>   # dmesg | grep -w FAIL
>>   Tail call error path, max count reached jited:0 ret 34 != 33 FAIL
>>
>> On some archs:
>>   # echo 1 > /proc/sys/net/core/bpf_jit_enable
>>   # modprobe test_bpf
>>   # dmesg | grep -w FAIL
>>   Tail call error path, max count reached jited:1 ret 34 != 33 FAIL
>>
>> with this patch, make the actual max tail call count as 
>> MAX_TAIL_CALL_CNT,
>> at the same time, the above failed testcase can be fixed.
>>
>> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
>> ---
>>
>> Hi all,
>>
>> This is a RFC patch, if I am wrong or I missed something,
>> please let me know, thank you!
>
> Yes, the original commit from 04fd61ab36ec ("bpf: allow bpf programs 
> to tail-call
> other bpf programs") got the counting wrong, but please also check 
> f9dabe016b63
> ("bpf: Undo off-by-one in interpreter tail call count limit") where we 
> agreed to
> align everything to 33 in order to avoid changing existing behavior, 
> and if we
> intend to ever change the count, then only in terms of increasing but 
> not decreasing
> since that ship has sailed.

Thank you, understood.

But I still think there is some confusion about the macro MAX_TAIL_CALL_CNT
which is 32 and the actual value 33, I spent some time to understand it
at the first glance.

Is it impossible to keep the actual max tail call count consistent with
the value 32 of MAX_TAIL_CALL_CNT now?

At least, maybe we need to modify the testcase?

> Tiezhu, do you still see any arch that is not on 33
> from your testing?

If the testcase "Tail call error path, max count reached" in test_bpf is 
right,
it seems that the tail call count limit is 32 on x86, because the testcase
passed on x86 jited.

> Last time Paul fixed the remaining ones in 96bc4432f5ad ("bpf,
> riscv: Limit to 33 tail calls") and e49e6f6db04e ("bpf, mips: Limit to 
> 33 tail calls").
>
> Thanks,
> Daniel

