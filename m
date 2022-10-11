Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86C265FACC5
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 08:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiJKG1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 02:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiJKG1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 02:27:11 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F0C87F8E;
        Mon, 10 Oct 2022 23:27:10 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Mmm0p3W5mzmV6W;
        Tue, 11 Oct 2022 14:22:34 +0800 (CST)
Received: from [10.67.111.192] (10.67.111.192) by
 kwepemi500013.china.huawei.com (7.221.188.120) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 11 Oct 2022 14:26:46 +0800
Message-ID: <df6ea78f-e980-9bba-d3e0-dc048b4cb9a1@huawei.com>
Date:   Tue, 11 Oct 2022 14:26:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH bpf v3 4/6] selftest/bpf: Fix memory leak in
 kprobe_multi_test
Content-Language: en-US
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Delyan Kratunov <delyank@fb.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
References: <20221010142553.776550-1-xukuohai@huawei.com>
 <20221010142553.776550-5-xukuohai@huawei.com>
 <CAEf4BzbOgHKfe0bq13qnuQ74TiwT6JW_4Rk3-+YvF2kthhdrcA@mail.gmail.com>
From:   Xu Kuohai <xukuohai@huawei.com>
In-Reply-To: <CAEf4BzbOgHKfe0bq13qnuQ74TiwT6JW_4Rk3-+YvF2kthhdrcA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.192]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/2022 9:34 AM, Andrii Nakryiko wrote:
> On Mon, Oct 10, 2022 at 7:08 AM Xu Kuohai <xukuohai@huawei.com> wrote:
>>
>> The get_syms() function in kprobe_multi_test.c does not free the string
>> memory allocated by sscanf correctly. Fix it.
>>
>> Fixes: 5b6c7e5c4434 ("selftests/bpf: Add attach bench test")
>> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
>> Acked-by: Jiri Olsa <jolsa@kernel.org>
>> ---
>>   .../bpf/prog_tests/kprobe_multi_test.c          | 17 ++++++++---------
>>   1 file changed, 8 insertions(+), 9 deletions(-)
>>
>> diff --git a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
>> index d457a55ff408..07dd2c5b7f98 100644
>> --- a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
>> +++ b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
>> @@ -360,15 +360,14 @@ static int get_syms(char ***symsp, size_t *cntp)
>>                   * to them. Filter out the current culprits - arch_cpu_idle
>>                   * and rcu_* functions.
>>                   */
>> -               if (!strcmp(name, "arch_cpu_idle"))
>> -                       continue;
>> -               if (!strncmp(name, "rcu_", 4))
>> -                       continue;
>> -               if (!strcmp(name, "bpf_dispatcher_xdp_func"))
>> -                       continue;
>> -               if (!strncmp(name, "__ftrace_invalid_address__",
>> -                            sizeof("__ftrace_invalid_address__") - 1))
>> +               if (!strcmp(name, "arch_cpu_idle") ||
>> +                       !strncmp(name, "rcu_", 4) ||
>> +                       !strcmp(name, "bpf_dispatcher_xdp_func") ||
>> +                       !strncmp(name, "__ftrace_invalid_address__",
>> +                                sizeof("__ftrace_invalid_address__") - 1)) {
>> +                       free(name);
>>                          continue;
>> +               }
> 
> it seems cleaner if we add if (name) free(name) under error: goto
> label. And in the success case when we assign name to syms[cnt] we can
> reset name to NULL to avoid double-free. WDYT?
> 

Fine, but since free(NULL) works perfectly, will call free(name) unconditionally,
and also initialize name to NULL, and call free(name) before sscanf.

> 
>>                  err = hashmap__add(map, name, NULL);
>>                  if (err) {
>>                          free(name);
>> @@ -394,7 +393,7 @@ static int get_syms(char ***symsp, size_t *cntp)
>>          hashmap__free(map);
>>          if (err) {
>>                  for (i = 0; i < cnt; i++)
>> -                       free(syms[cnt]);
>> +                       free(syms[i]);
>>                  free(syms);
>>          }
>>          return err;
>> --
>> 2.30.2
>>
> .

