Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09FF2525338
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 19:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356657AbiELRIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 13:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356840AbiELRIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 13:08:43 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9EA1B2609D0;
        Thu, 12 May 2022 10:08:40 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 151A61E80D6B;
        Fri, 13 May 2022 01:03:03 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Rv1vvkAr3Ckd; Fri, 13 May 2022 01:03:00 +0800 (CST)
Received: from [172.30.21.106] (unknown [180.167.10.98])
        (Authenticated sender: liqiong@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 72B091E80D22;
        Fri, 13 May 2022 01:02:59 +0800 (CST)
Subject: Re: [PATCH 1/2] kernel/bpf: change "char *" string form to "char []"
To:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        hukun@nfschina.com, qixu@nfschina.com, yuzhe@nfschina.com,
        renyu@nfschina.com
References: <20220512142814.26705-1-liqiong@nfschina.com>
 <bd3d4379-e4aa-79c7-85b8-cc930a04f267@fb.com>
From:   liqiong <liqiong@nfschina.com>
Message-ID: <223f19c0-70a7-3b1f-6166-22d494b62b6e@nfschina.com>
Date:   Fri, 13 May 2022 01:08:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <bd3d4379-e4aa-79c7-85b8-cc930a04f267@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RDNS_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2022年05月12日 23:16, Yonghong Song 写道:
>
>
> On 5/12/22 7:28 AM, liqiong wrote:
>> The string form of "char []" declares a single variable. It is better
>> than "char *" which creates two variables.
>
> Could you explain in details about why it is better in generated codes?
> It is not clear to me why your patch is better than the original code.

Hi there，

The  string form of "char *" creates two variables in the final assembly output,
a static string, and a char pointer to the static string.  Use  "objdump -S -D  *.o",
can find out the static string  occurring  at "Contents of section .rodata".

>
>>
>> Signed-off-by: liqiong <liqiong@nfschina.com>
>> ---
>>   kernel/bpf/btf.c      | 4 ++--
>>   kernel/bpf/verifier.c | 2 +-
>>   2 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
>> index 0918a39279f6..218a8ac73644 100644
>> --- a/kernel/bpf/btf.c
>> +++ b/kernel/bpf/btf.c
>> @@ -894,10 +894,10 @@ static const struct btf_type *btf_type_skip_qualifiers(const struct btf *btf,
>>   static const char *btf_show_name(struct btf_show *show)
>>   {
>>       /* BTF_MAX_ITER array suffixes "[]" */
>> -    const char *array_suffixes = "[][][][][][][][][][]";
>> +    static const char array_suffixes[] = "[][][][][][][][][][]";
>>       const char *array_suffix = &array_suffixes[strlen(array_suffixes)];
>>       /* BTF_MAX_ITER pointer suffixes "*" */
>> -    const char *ptr_suffixes = "**********";
>> +    static const char ptr_suffixes[] = "**********";
>>       const char *ptr_suffix = &ptr_suffixes[strlen(ptr_suffixes)];
>>       const char *name = NULL, *prefix = "", *parens = "";
>>       const struct btf_member *m = show->state.member;
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index d175b70067b3..78a090fcbc72 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -7346,7 +7346,7 @@ static int sanitize_err(struct bpf_verifier_env *env,
>>               const struct bpf_reg_state *off_reg,
>>               const struct bpf_reg_state *dst_reg)
>>   {
>> -    static const char *err = "pointer arithmetic with it prohibited for !root";
>> +    static const char err[] = "pointer arithmetic with it prohibited for !root";
>>       const char *op = BPF_OP(insn->code) == BPF_ADD ? "add" : "sub";
>>       u32 dst = insn->dst_reg, src = insn->src_reg;
>>   

-- 
李力琼 <13524287433>
上海市浦东新区海科路99号中科院上海高等研究院3号楼3楼

