Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 725E561739D
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 02:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiKCBNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 21:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiKCBNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 21:13:39 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA79212AA9;
        Wed,  2 Nov 2022 18:13:38 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4N2m0L2krzzJnMp;
        Thu,  3 Nov 2022 09:10:42 +0800 (CST)
Received: from [10.174.179.191] (10.174.179.191) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 09:13:36 +0800
Message-ID: <dbc7e6d3-af51-011a-f61c-7a596a0ae062@huawei.com>
Date:   Thu, 3 Nov 2022 09:13:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH net v2] bpf: Fix memory leaks in __check_func_call
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <john.fastabend@gmail.com>,
        <andrii@kernel.org>, <martin.lau@linux.dev>, <yhs@fb.com>,
        <joe@wand.net.nz>
References: <1666934520-22509-1-git-send-email-wangyufen@huawei.com>
 <CAEf4BzYpsxmmu48YKvWMuAgNp-H+CaEGChAet6DvWCLTcs61Zg@mail.gmail.com>
From:   wangyufen <wangyufen@huawei.com>
In-Reply-To: <CAEf4BzYpsxmmu48YKvWMuAgNp-H+CaEGChAet6DvWCLTcs61Zg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.191]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/11/3 3:05, Andrii Nakryiko 写道:
> On Thu, Oct 27, 2022 at 10:01 PM Wang Yufen <wangyufen@huawei.com> wrote:
>> kmemleak reports this issue:
>>
>> unreferenced object 0xffff88817139d000 (size 2048):
>>    comm "test_progs", pid 33246, jiffies 4307381979 (age 45851.820s)
>>    hex dump (first 32 bytes):
>>      01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>    backtrace:
>>      [<0000000045f075f0>] kmalloc_trace+0x27/0xa0
>>      [<0000000098b7c90a>] __check_func_call+0x316/0x1230
>>      [<00000000b4c3c403>] check_helper_call+0x172e/0x4700
>>      [<00000000aa3875b7>] do_check+0x21d8/0x45e0
>>      [<000000001147357b>] do_check_common+0x767/0xaf0
>>      [<00000000b5a595b4>] bpf_check+0x43e3/0x5bc0
>>      [<0000000011e391b1>] bpf_prog_load+0xf26/0x1940
>>      [<0000000007f765c0>] __sys_bpf+0xd2c/0x3650
>>      [<00000000839815d6>] __x64_sys_bpf+0x75/0xc0
>>      [<00000000946ee250>] do_syscall_64+0x3b/0x90
>>      [<0000000000506b7f>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>
>> The root case here is: In function prepare_func_exit(), the callee is
>> not released in the abnormal scenario after "state->curframe--;". To
>> fix, move "state->curframe--;" to the very bottom of the function,
>> right when we free callee and reset frame[] pointer to NULL, as Andrii
>> suggested.
>>
>> In addition, function __check_func_call() has a similar problem. In
>> the abnormal scenario before "state->curframe++;", the callee is alse
>> not released.
>>
>> Fixes: 69c087ba6225 ("bpf: Add bpf_for_each_map_elem() helper")
>> Fixes: fd978bf7fd31 ("bpf: Add reference tracking to verifier")
>> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
>> ---
> This change seems to be breaking BPF selftests quite badly, please
> check what's going on ([0]):
>
>    [0] https://github.com/kernel-patches/bpf/actions/runs/3379444311/jobs/5611599540
>
>>   kernel/bpf/verifier.c | 11 ++++++++---
>>   1 file changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index 014ee09..d28d460 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -6736,11 +6736,11 @@ static int __check_func_call(struct bpf_verifier_env *env, struct bpf_insn *insn
>>          /* Transfer references to the callee */
>>          err = copy_reference_state(callee, caller);
>>          if (err)
>> -               return err;
>> +               goto err_out;
>>
>>          err = set_callee_state_cb(env, caller, callee, *insn_idx);
>>          if (err)
>> -               return err;
>> +               goto err_out;
>>
>>          clear_caller_saved_regs(env, caller->regs);
>>
>> @@ -6757,6 +6757,11 @@ static int __check_func_call(struct bpf_verifier_env *env, struct bpf_insn *insn
>>                  print_verifier_state(env, callee, true);
>>          }
>>          return 0;
>> +
>> +err_out:
>> +       kfree(callee);
>> +       state->frame[state->curframe + 1] = NULL;
>> +       return err;
>>   }
>>
>>   int map_set_for_each_callback_args(struct bpf_verifier_env *env,
>> @@ -6969,7 +6974,6 @@ static int prepare_func_exit(struct bpf_verifier_env *env, int *insn_idx)
>>                  return -EINVAL;
>>          }
>>
>> -       state->curframe--;
>>          caller = state->frame[state->curframe];
Got the wrong “caller” here,  will change to

state->frame[state->curframe - 1]   in v3

>>          if (callee->in_callback_fn) {
>>                  /* enforce R0 return value range [0, 1]. */
>> @@ -7000,6 +7004,7 @@ static int prepare_func_exit(struct bpf_verifier_env *env, int *insn_idx)
>>                          return err;
>>          }
>>
>> +       state->curframe--;
>>          *insn_idx = callee->callsite + 1;
>>          if (env->log.level & BPF_LOG_LEVEL) {
>>                  verbose(env, "returning from callee:\n");
>> --
>> 1.8.3.1
>>
