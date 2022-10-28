Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26DDC610750
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 03:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235279AbiJ1Bgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 21:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233622AbiJ1Bgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 21:36:40 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD70963AF;
        Thu, 27 Oct 2022 18:36:39 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Mz4lL5C8lz15MG1;
        Fri, 28 Oct 2022 09:31:42 +0800 (CST)
Received: from [10.174.179.191] (10.174.179.191) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 28 Oct 2022 09:36:37 +0800
Message-ID: <20f6459e-1fdc-2344-d2a9-8efde5992282@huawei.com>
Date:   Fri, 28 Oct 2022 09:36:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH net] bpf: Fix memory leaks in __check_func_call
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <john.fastabend@gmail.com>,
        <andrii@kernel.org>, <martin.lau@linux.dev>, <yhs@fb.com>,
        <joe@wand.net.nz>
References: <1666866213-4394-1-git-send-email-wangyufen@huawei.com>
 <CAEf4Bza03=MLPJN1fY+93W4=orqt=nHzQuUBw=7cz-qAwFQdvA@mail.gmail.com>
From:   wangyufen <wangyufen@huawei.com>
In-Reply-To: <CAEf4Bza03=MLPJN1fY+93W4=orqt=nHzQuUBw=7cz-qAwFQdvA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.191]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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


在 2022/10/28 4:34, Andrii Nakryiko 写道:
> On Thu, Oct 27, 2022 at 3:03 AM Wang Yufen <wangyufen@huawei.com> wrote:
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
>> not released in the abnormal scenario after "state->curframe--;".
>>
>> In addition, function __check_func_call() has a similar problem. In
>> the abnormal scenario before "state->curframe++;", the callee is alse
>> not released.
> For prepare_func_exit, wouldn't it be correct and cleaner to just move
> state->curframe--; to the very bottom of the function, right when we
> free callee and reset frame[] pointer to NULL?

Yes, that't better. will change and test in v2.

> For __check_func_call, please use err_out label name to disambiguate
> it from the "err" variable.

I got it. will change in v2.

>
>> Fixes: 69c087ba6225 ("bpf: Add bpf_for_each_map_elem() helper")
>> Fixes: fd978bf7fd31 ("bpf: Add reference tracking to verifier")
>> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
>> ---
>>   kernel/bpf/verifier.c | 25 ++++++++++++++++---------
>>   1 file changed, 16 insertions(+), 9 deletions(-)
>>
> [...]
