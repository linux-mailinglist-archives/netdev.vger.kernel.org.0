Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82DA65F831B
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 07:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiJHFWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 01:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiJHFWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 01:22:40 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C86180F43;
        Fri,  7 Oct 2022 22:22:38 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Mktjq2zsZzlXdR;
        Sat,  8 Oct 2022 13:18:07 +0800 (CST)
Received: from [10.174.179.191] (10.174.179.191) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 8 Oct 2022 13:22:35 +0800
Message-ID: <e2f2b01a-1f0e-a862-c3df-96f61dbdbaf6@huawei.com>
Date:   Sat, 8 Oct 2022 13:22:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [bpf-next v7 1/3] bpftool: Add auto_attach for bpf prog
 load|loadall
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     <quentin@isovalent.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <martin.lau@linux.dev>, <song@kernel.org>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <sdf@google.com>, <haoluo@google.com>, <jolsa@kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <hawk@kernel.org>,
        <nathan@kernel.org>, <ndesaulniers@google.com>, <trix@redhat.com>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <llvm@lists.linux.dev>
References: <1664277676-2228-1-git-send-email-wangyufen@huawei.com>
 <CAEf4BzaBPpZvxD6sDMWWRXVqKYTgwaxsggye0CRbv7q5_4jrPA@mail.gmail.com>
From:   wangyufen <wangyufen@huawei.com>
In-Reply-To: <CAEf4BzaBPpZvxD6sDMWWRXVqKYTgwaxsggye0CRbv7q5_4jrPA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.191]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/10/1 4:55, Andrii Nakryiko 写道:
> On Tue, Sep 27, 2022 at 4:00 AM Wang Yufen <wangyufen@huawei.com> wrote:
>> Add auto_attach optional to support one-step load-attach-pin_link.
>>
>> For example,
>>     $ bpftool prog loadall test.o /sys/fs/bpf/test autoattach
>>
>>     $ bpftool link
>>     26: tracing  name test1  tag f0da7d0058c00236  gpl
>>          loaded_at 2022-09-09T21:39:49+0800  uid 0
>>          xlated 88B  jited 55B  memlock 4096B  map_ids 3
>>          btf_id 55
>>     28: kprobe  name test3  tag 002ef1bef0723833  gpl
>>          loaded_at 2022-09-09T21:39:49+0800  uid 0
>>          xlated 88B  jited 56B  memlock 4096B  map_ids 3
>>          btf_id 55
>>     57: tracepoint  name oncpu  tag 7aa55dfbdcb78941  gpl
>>          loaded_at 2022-09-09T21:41:32+0800  uid 0
>>          xlated 456B  jited 265B  memlock 4096B  map_ids 17,13,14,15
>>          btf_id 82
>>
>>     $ bpftool link
>>     1: tracing  prog 26
>>          prog_type tracing  attach_type trace_fentry
>>     3: perf_event  prog 28
>>     10: perf_event  prog 57
>>
>> The autoattach optional can support tracepoints, k(ret)probes,
>> u(ret)probes.
>>
>> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
>> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
>> ---
> For next revision, please also attach cover letter describing the
> overall goal of the patch set (and that's where the version log
> between revisions is put as well).

Thanks, will add a cover letter in v8.

>
>
>> v6 -> v7: add info msg print and update doc for the skip program
>> v5 -> v6: skip the programs not supporting auto-attach,
>>            and change optional name from "auto_attach" to "autoattach"
>> v4 -> v5: some formatting nits of doc
>> v3 -> v4: rename functions, update doc, bash and do_help()
>> v2 -> v3: switch to extend prog load command instead of extend perf
>> v2: https://patchwork.kernel.org/project/netdevbpf/patch/20220824033837.458197-1-weiyongjun1@huawei.com/
>> v1: https://patchwork.kernel.org/project/netdevbpf/patch/20220816151725.153343-1-weiyongjun1@huawei.com/
>>   tools/bpf/bpftool/prog.c | 81 ++++++++++++++++++++++++++++++++++++++++++++++--
>>   1 file changed, 79 insertions(+), 2 deletions(-)
>>
> [...]
>
