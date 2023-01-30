Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04CD6681714
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 17:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236765AbjA3Q72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 11:59:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236545AbjA3Q70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 11:59:26 -0500
Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4605FF11;
        Mon, 30 Jan 2023 08:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
        s=smtpout1; t=1675097960;
        bh=Qp8uMm5mSox9QONqmnFHcCh3GiajeXXyEhxAnHk1o5M=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=eQDNv1uxDs817kNR9qqvqj6vEa7UZkzKxxO+8v+/W1Nz3hOkiAwxFvMhlRPfRihPj
         OOUQAsfgZF6OBRVtODC1pH5g3mnOsuyD+ckWtiYZJhQUmWYxmosPPPy2Kk1GLOrzN5
         K9wm/WuuNz9ByDC4GC1dxONNfZhqI1Y5oavTN8pHV34h5Q9iSKfl5Ab0nm3+bCq2+x
         duWPBZruAJGDfbLn4M4MBFNpcwnpHv7n+7LTr8gMtTlmGCRlBF0qEyS4+Sk721FuCw
         JC3N4Afz6svdWD1sBA7TidkV8A7k7ysU6eYi1w7Vk9TfgEo29KXlMKN80+/CdaJt8w
         KlOlM1xSuI+aA==
Received: from [172.16.0.188] (192-222-180-24.qc.cable.ebox.net [192.222.180.24])
        by smtpout.efficios.com (Postfix) with ESMTPSA id 4P5DtJ3ncfzhmV;
        Mon, 30 Jan 2023 11:59:20 -0500 (EST)
Message-ID: <7023e3f3-bfd3-5842-5624-b1fd21576591@efficios.com>
Date:   Mon, 30 Jan 2023 12:00:00 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 02/34] selftests: bpf: Fix incorrect kernel headers search
 path
Content-Language: en-US
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Cc:     Shuah Khan <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
References: <20230127135755.79929-1-mathieu.desnoyers@efficios.com>
 <20230127135755.79929-3-mathieu.desnoyers@efficios.com>
 <4defb04e-ddcb-b344-6e9f-35023dee0d2a@linuxfoundation.org>
 <CAADnVQ+1hB-1B_-2LrYC3XvMiEyA2yZv9fz51dDrMABG3dsQ_g@mail.gmail.com>
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <CAADnVQ+1hB-1B_-2LrYC3XvMiEyA2yZv9fz51dDrMABG3dsQ_g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023-01-30 11:26, Alexei Starovoitov wrote:
> On Mon, Jan 30, 2023 at 8:12 AM Shuah Khan <skhan@linuxfoundation.org> wrote:
>>
>> On 1/27/23 06:57, Mathieu Desnoyers wrote:
>>> Use $(KHDR_INCLUDES) as lookup path for kernel headers. This prevents
>>> building against kernel headers from the build environment in scenarios
>>> where kernel headers are installed into a specific output directory
>>> (O=...).
>>>
>>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>>> Cc: Shuah Khan <shuah@kernel.org>
>>> Cc: linux-kselftest@vger.kernel.org
>>> Cc: Ingo Molnar <mingo@redhat.com>
>>> Cc: <stable@vger.kernel.org>    [5.18+]
>>> ---
>>>    tools/testing/selftests/bpf/Makefile | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
>>> index c22c43bbee19..6998c816afef 100644
>>> --- a/tools/testing/selftests/bpf/Makefile
>>> +++ b/tools/testing/selftests/bpf/Makefile
>>> @@ -327,7 +327,7 @@ endif
>>>    CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG),$(CLANG_TARGET_ARCH))
>>>    BPF_CFLAGS = -g -Werror -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN)               \
>>>             -I$(INCLUDE_DIR) -I$(CURDIR) -I$(APIDIR)                   \
>>> -          -I$(abspath $(OUTPUT)/../usr/include)
>>> +          $(KHDR_INCLUDES)
>>>
>>>    CLANG_CFLAGS = $(CLANG_SYS_INCLUDES) \
>>>               -Wno-compare-distinct-pointer-types
>>
>>
>>
>> Adding bpf maintainers - bpf patches usually go through bpf tree.
>>
>> Acked-by: Shuah Khan <skhan@linuxfoundation.org>
> 
> Please resubmit as separate patch with [PATCH bpf-next] subj
> and cc bpf@vger, so that BPF CI can test it on various architectures
> and config combinations.

Hi Shuah,

Do you have means to resubmit it on your end, or should I do it ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

