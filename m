Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D335F525994
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 04:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376435AbiEMCEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 22:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiEMCEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 22:04:37 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CEAFD28B84D;
        Thu, 12 May 2022 19:04:35 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 871701E80C82;
        Fri, 13 May 2022 09:58:54 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Wm2H41FLJxlA; Fri, 13 May 2022 09:58:51 +0800 (CST)
Received: from [172.30.21.106] (unknown [180.167.10.98])
        (Authenticated sender: liqiong@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 007621E80C80;
        Fri, 13 May 2022 09:58:50 +0800 (CST)
Subject: Re: [PATCH 1/2] kernel/bpf: change "char *" string form to "char []"
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        hukun@nfschina.com, qixu@nfschina.com, yuzhe@nfschina.com,
        renyu@nfschina.com
References: <20220512142814.26705-1-liqiong@nfschina.com>
 <bd3d4379-e4aa-79c7-85b8-cc930a04f267@fb.com>
 <223f19c0-70a7-3b1f-6166-22d494b62b6e@nfschina.com>
 <92cc4844-5815-c3b0-63be-2e54dc36e1d9@iogearbox.net>
From:   liqiong <liqiong@nfschina.com>
Message-ID: <6af0b0fe-daf3-5310-2f13-e411a80bdde8@nfschina.com>
Date:   Fri, 13 May 2022 10:04:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <92cc4844-5815-c3b0-63be-2e54dc36e1d9@iogearbox.net>
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



在 2022年05月13日 04:59, Daniel Borkmann 写道:
> On 5/12/22 7:08 PM, liqiong wrote:
>> 在 2022年05月12日 23:16, Yonghong Song 写道:
>>>
>>> On 5/12/22 7:28 AM, liqiong wrote:
>>>> The string form of "char []" declares a single variable. It is better
>>>> than "char *" which creates two variables.
>>>
>>> Could you explain in details about why it is better in generated codes?
>>> It is not clear to me why your patch is better than the original code.
>>
>> The  string form of "char *" creates two variables in the final assembly output,
>> a static string, and a char pointer to the static string.  Use  "objdump -S -D  *.o",
>> can find out the static string  occurring  at "Contents of section .rodata".
>
> There are ~360 instances of this type in the tree from a quick grep, do you
> plan to convert all them ?

Hi daniel,

I have fixed all the string form in kernel tree, summited  two patches. 
Have searched the kernel tree by "grep  -nHre char.*\*.*=.*\"",  and checked all the "char *foo = "bar" "
string form,  only five  instances are needed to fix in bpf direcotry (2 files) and trace directory (2 files).
In most cases, need a char pointer anyway, just like this:

[const] char *foo = "bar";
if (xxx)
    foo = "blash";

In this situation, can't  change  "char *foo"  to  "char foo[]".

This work was published in "KernelJanitors/Todo".  So, I fixed.

Thanks.

>
> Thanks,
> Daniel

