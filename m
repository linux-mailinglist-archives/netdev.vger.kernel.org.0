Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB0D4F5EDC
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 15:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbiDFNGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 09:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbiDFNFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 09:05:45 -0400
Received: from 189.cn (ptr.189.cn [183.61.185.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BC4A24096A5;
        Tue,  5 Apr 2022 18:35:52 -0700 (PDT)
HMM_SOURCE_IP: 10.64.8.31:54096.784187684
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-123.150.8.42 (unknown [10.64.8.31])
        by 189.cn (HERMES) with SMTP id 51B6C1002AE;
        Wed,  6 Apr 2022 09:35:48 +0800 (CST)
Received: from  ([172.27.8.53])
        by gateway-151646-dep-b7fbf7d79-bwdqx with ESMTP id a29d35676fba41b29fedbb3bbd7277bc for andrii.nakryiko@gmail.com;
        Wed, 06 Apr 2022 09:35:51 CST
X-Transaction-ID: a29d35676fba41b29fedbb3bbd7277bc
X-Real-From: chensong_2000@189.cn
X-Receive-IP: 172.27.8.53
X-MEDUSA-Status: 0
Sender: chensong_2000@189.cn
Message-ID: <529149bc-d095-8161-11be-b36d7d63b7ed@189.cn>
Date:   Wed, 6 Apr 2022 09:35:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] sample: bpf: syscall_tp_kern: add dfd before filename
Content-Language: en-US
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1648777246-21352-1-git-send-email-chensong_2000@189.cn>
 <CAEf4Bzbo=DU_LqJ=sXgawP9-O4VR84jDdhuf9Xto=T3LSsrySA@mail.gmail.com>
From:   Song Chen <chensong_2000@189.cn>
In-Reply-To: <CAEf4Bzbo=DU_LqJ=sXgawP9-O4VR84jDdhuf9Xto=T3LSsrySA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

在 2022/4/5 06:17, Andrii Nakryiko 写道:
> On Thu, Mar 31, 2022 at 6:34 PM Song Chen <chensong_2000@189.cn> wrote:
>>
>> When i was writing my eBPF program, i copied some pieces of code from
>> syscall_tp, syscall_tp_kern only records how many files are opened, but
>> mine needs to print file name.I reused struct syscalls_enter_open_args,
>> which is defined as:
>>
>> struct syscalls_enter_open_args {
>>          unsigned long long unused;
>>          long syscall_nr;
>>          long filename_ptr;
>>          long flags;
>>          long mode;
>> };
>>
>> I tried to use filename_ptr, but it's not the pointer of filename, flags
>> turns out to be the pointer I'm looking for, there might be something
>> missed in the struct.
>>
>> I read the ftrace log, found the missed one is dfd, which is supposed to be
>> placed in between syscall_nr and filename_ptr.
>>
>> Actually syscall_tp has nothing to do with dfd, it can run anyway without
>> it, but it's better to have it to make it a better eBPF sample, especially
>> to new eBPF programmers, then i fixed it.
>>
>> Signed-off-by: Song Chen <chensong_2000@189.cn>
>> ---
>>   samples/bpf/syscall_tp_kern.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/samples/bpf/syscall_tp_kern.c b/samples/bpf/syscall_tp_kern.c
>> index 50231c2eff9c..e4ac818aee57 100644
>> --- a/samples/bpf/syscall_tp_kern.c
>> +++ b/samples/bpf/syscall_tp_kern.c
>> @@ -7,6 +7,7 @@
>>   struct syscalls_enter_open_args {
>>          unsigned long long unused;
>>          long syscall_nr;
>> +       long dfd_ptr;
>>          long filename_ptr;
>>          long flags;
>>          long mode;
> 
> Here's what I see on latest bpf-next:
> 
> # cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_open/format
> name: sys_enter_open
> ID: 613
> format:
>          field:unsigned short common_type;       offset:0;
> size:2; signed:0;
>          field:unsigned char common_flags;       offset:2;
> size:1; signed:0;
>          field:unsigned char common_preempt_count;       offset:3;
>   size:1; signed:0;
>          field:int common_pid;   offset:4;       size:4; signed:1;
> 
>          field:int __syscall_nr; offset:8;       size:4; signed:1;
>          field:const char * filename;    offset:16;      size:8; signed:0;
>          field:int flags;        offset:24;      size:8; signed:0;
>          field:umode_t mode;     offset:32;      size:8; signed:0;
> 
> This layout doesn't correspond either to before or after state of
> syscalls_enter_open_args. Not sure what's going on, but it doesn't
> seem that struct syscalls_enter_open_args is correct anyways.
> 

sys_enter_open is not enabled in my system somehow and i haven't figured 
out why, then i used sys_enter_openat, whose format is:

name: sys_enter_openat
ID: 647
format:
	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
	field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
	field:int common_pid;	offset:4;	size:4;	signed:1;

	field:int __syscall_nr;	offset:8;	size:4;	signed:1;
	field:int dfd;	offset:16;	size:8;	signed:0;
	field:const char * filename;	offset:24;	size:8;	signed:0;
	field:int flags;	offset:32;	size:8;	signed:0;
	field:umode_t mode;	offset:40;	size:8;	signed:0;

print fmt: "dfd: 0x%08lx, filename: 0x%08lx, flags: 0x%08lx, mode: 
0x%08lx", ((unsigned long)(REC->dfd)), ((unsigned long)(REC->filename)), 
((unsigned long)(REC->flags)), ((unsigned long)(REC->mode))

I think in this case syscalls_enter_open_args is not applicable for 
sys_enter_openat, how about we introduce a new struct specific for 
sys_enter_openat with dfd in it?

/Song

> 
>> --
>> 2.25.1
>>
> 
