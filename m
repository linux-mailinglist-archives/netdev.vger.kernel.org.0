Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69EC74ACACD
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 22:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbiBGVAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 16:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbiBGVAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 16:00:18 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3A0C06173B;
        Mon,  7 Feb 2022 13:00:17 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: usama.anjum)
        with ESMTPSA id B2EE91F449C3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1644267606;
        bh=N5JqssyGW7G70mGE9QlOJwJiSFPcXLNfmk8H/V5Cg2k=;
        h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
        b=i43/GqRMALGePiOvKLLiVm68rl7kuD1jPtECg5+AFtHcce0lAwh1/GGSmHJCn1jLm
         X6EL8T3rmdu1TBQ/ziIiAobHLYePbEtAuBsXOtvThf0rFuOu8ioogWyo6+p0fFYO0U
         ZLVr+k/X26iDjWvfPYqFgwc+hy1U+5WgvQ2zeSKTUHwbHkc7+MItKBgcSIpQIEsWKS
         7W8bg5mwFpiErJuWGEN7K4AK8h2t5qcIQurHllkJpGqXRQfas9/efaLODRJ1EjX+n5
         NBoTD33o5y28NxivwECmAHmWVYfQ12CbFe71ygKzJgFU11I4fj5npRIXDC8Gzhq2U4
         zmjQwNtPnfCgA==
Message-ID: <701fbfac-b548-1f05-7841-e233ef82be15@collabora.com>
Date:   Tue, 8 Feb 2022 01:59:58 +0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Cc:     usama.anjum@collabora.com, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, kernel@collabora.com,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH] selftests: Fix build when $(O) points to a relative path
Content-Language: en-US
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
References: <20220204225817.3918648-1-usama.anjum@collabora.com>
 <CAEf4Bzbf38F39XHJnCKy19m97JZJnhN0+Sr-TAVzZnSKuqzL4w@mail.gmail.com>
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
In-Reply-To: <CAEf4Bzbf38F39XHJnCKy19m97JZJnhN0+Sr-TAVzZnSKuqzL4w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/8/22 12:22 AM, Andrii Nakryiko wrote:
> On Fri, Feb 4, 2022 at 2:59 PM Muhammad Usama Anjum
> <usama.anjum@collabora.com> wrote:
>>
>> Build of bpf and tc-testing selftests fails when the relative path of
>> the build directory is specified.
>>
>> make -C tools/testing/selftests O=build0
>> make[1]: Entering directory '/linux_mainline/tools/testing/selftests/bpf'
>> ../../../scripts/Makefile.include:4: *** O=build0 does not exist.  Stop.
>> make[1]: Entering directory '/linux_mainline/tools/testing/selftests/tc-testing'
>> ../../../scripts/Makefile.include:4: *** O=build0 does not exist.  Stop.
>>
>> The fix is same as mentioned in commit 150a27328b68 ("bpf, preload: Fix
>> build when $(O) points to a relative path").
>>
> 
> I don't think it actually helps building BPF selftest. Even with this
This patch is fixing one type of build error which occurs if output
directory's path is relative.

> patch applied, all the feature detection doesn't work, and I get
> reallocarray redefinition failure when bpftool is being built as part
> of selftest.
There may be more problems in BPF tests. Those needs to be looked at
separately.

>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
>> ---
>>  tools/testing/selftests/Makefile | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
>> index 4eda7c7c15694..aa0faf132c35a 100644
>> --- a/tools/testing/selftests/Makefile
>> +++ b/tools/testing/selftests/Makefile
>> @@ -178,6 +178,7 @@ all: khdr
>>                 BUILD_TARGET=$$BUILD/$$TARGET;                  \
>>                 mkdir $$BUILD_TARGET  -p;                       \
>>                 $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET       \
>> +                               O=$(abs_objtree)                \
>>                                 $(if $(FORCE_TARGETS),|| exit); \
>>                 ret=$$((ret * $$?));                            \
>>         done; exit $$ret;
>> @@ -185,7 +186,8 @@ all: khdr
>>  run_tests: all
>>         @for TARGET in $(TARGETS); do \
>>                 BUILD_TARGET=$$BUILD/$$TARGET;  \
>> -               $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET run_tests;\
>> +               $(MAKE) OUTPUT=$$BUILD_TARGET -C $$TARGET run_tests \
>> +                               O=$(abs_objtree);                   \
>>         done;
>>
>>  hotplug:
>> --
>> 2.30.2
>>
