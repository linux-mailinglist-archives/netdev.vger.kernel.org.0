Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5873D89BD
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 10:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235190AbhG1I1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 04:27:42 -0400
Received: from www62.your-server.de ([213.133.104.62]:37546 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234495AbhG1I1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 04:27:41 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1m8eud-0007Me-LW; Wed, 28 Jul 2021 10:27:35 +0200
Received: from [2a01:118f:54a:7f00:89b1:4cb8:1a49:dc0f] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1m8eud-000G9X-Ad; Wed, 28 Jul 2021 10:27:35 +0200
Subject: Re: [RFC PATCH 00/14] bpf/tests: Extend the eBPF test suite
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Tony Ambardar <Tony.Ambardar@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20210726081738.1833704-1-johan.almbladh@anyfinetworks.com>
 <CAEf4BzYdvjz36K7=qYnfL6q=cX=ha27Ro2x6cV1X4hp22VEO=g@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5afe26c6-7ab1-88ab-a3e0-eb007256a856@iogearbox.net>
Date:   Wed, 28 Jul 2021 10:27:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzYdvjz36K7=qYnfL6q=cX=ha27Ro2x6cV1X4hp22VEO=g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26245/Tue Jul 27 10:20:01 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/21 12:53 AM, Andrii Nakryiko wrote:
> On Mon, Jul 26, 2021 at 1:18 AM Johan Almbladh
> <johan.almbladh@anyfinetworks.com> wrote:
>>
>> Greetings,
>>
>> During my work with the 32-bit MIPS JIT implementation I also added a
>> number of new test cases in the test_bpf kernel module. I found it
>> valuable to be able to throughly test the JIT on a low level with
>> minimum dependency on user space tooling. If you think it would be useful,
>> I have prepared a patch set with my additions. I have verified it on
>> x86_64 and i386, with/without JIT and JIT hardening. The interpreter
>> passes all tests. The JITs do too, with one exception, see NOTE below.
>> The result for the x86_64 JIT is summarized below.
>>
>>      test_bpf: Summary: 577 PASSED, 0 FAILED, [565/565 JIT'ed]
>>      test_bpf: test_tail_calls: Summary: 6 PASSED, 1 FAILED, [7/7 JIT'ed]
>>
>> I have inserted the new tests in the location where related tests are run,
>> rather than putting them at the end. I have also tried to use the same
>> description style as the surrounding tests. Below is a summary of the
>> new tests.
>>
>> * Operations not previously covered
>>    JMP32, ALU32 ARSH, remaining ATOMIC operations including
>>    XCHG and CMPXCHG.
>>
>> * ALU operations with edge cases
>>    32-bit JITs implement ALU64 operations with two 32-bit registers per
>>    operand. Even "trivial" operations like bit shifts are non-trivial to
>>    implement. Test different input values that may trigger different JIT
>>    code paths. JITs may also implement BPF_K operations differently
>>    depending on if the immediate fits the corresponding field width of the
>>    native CPU instruction or not, so test that too.
>>
>> * Word order in load/store
>>    The word order should follow endianness. Test that DW load/store
>>    operations result in the expected word order in memory.
>>
>> * 32-bit eBPF argument zero extension
>>    On a 32-bit JIT the eBPF argument is a 32-bit pointer. If passed in
>>    a CPU register only one register in the mapped pair contains valid
>>    data. Verify that value is properly zero-extended.
>>
>> * Long conditional jumps
>>    Test to trigger the relative-to-absolute branch conversion in MIPS JITs,
>>    when the PC-relative offset overflows the field width of the MIPS branch
>>    instruction.
>>
>> * Tail calls
>>    A new test suite to test tail calls. Also test error paths and TCC
>>    limit.
>>
>> NOTE: There is a minor discrepancy between the interpreter and the
>> (x86) JITs. With MAX_TAIL_CALL_CNT = 32, the interpreter seems to allow
>> up to 33 tail calls, whereas the JITs stop at 32. This causes the max TCC
> 
> Given the intended case was to allow 32, let's fix up the interpreter
> to be in line with JITs?

Yes, lets fix up the interpreter.

Could you send a fix for the latter, Johan, along with this series?

Big thanks for adding all the new tests by the way!

>> test to fail for the JITs, since I used the interpreter as reference.
>> Either we change the interpreter behavior, change the JITs, or relax the
>> test to allow both behaviors.
>>
>> Let me know what you think.
>>
>> Cheers,
>> Johan
>>
>> Johan Almbladh (14):
>>    bpf/tests: add BPF_JMP32 test cases
>>    bpf/tests: add BPF_MOV tests for zero and sign extension
>>    bpf/tests: fix typos in test case descriptions
>>    bpf/tests: add more tests of ALU32 and ALU64 bitwise operations
>>    bpf/tests: add more ALU32 tests for BPF_LSH/RSH/ARSH
>>    bpf/tests: add more BPF_LSH/RSH/ARSH tests for ALU64
>>    bpf/tests: add more ALU64 BPF_MUL tests
>>    bpf/tests: add tests for ALU operations implemented with function
>>      calls
>>    bpf/tests: add word-order tests for load/store of double words
>>    bpf/tests: add branch conversion JIT test
>>    bpf/tests: add test for 32-bit context pointer argument passing
>>    bpf/tests: add tests for atomic operations
>>    bpf/tests: add tests for BPF_CMPXCHG
>>    bpf/tests: add tail call test suite
>>
>>   lib/test_bpf.c | 2732 +++++++++++++++++++++++++++++++++++++++++++-----
>>   1 file changed, 2475 insertions(+), 257 deletions(-)
>>
>> --
>> 2.25.1
>>

