Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21063EF429
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 22:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234833AbhHQUfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 16:35:32 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:35308
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234248AbhHQUfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 16:35:31 -0400
Received: from [192.168.0.209] (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net [80.193.200.194])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id EEB013F09C;
        Tue, 17 Aug 2021 20:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629232497;
        bh=aH1+suqq1Y7Z2H6cY/RzQZFaxHT3pbfG5PuomAgbVV4=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=FRsYyfbzQZ5aditKm7PPjnQvcbU1Cv60zjE1MiSf99L0Hcse9MW6cJ2HbYBwuAsWc
         ON+nsDipyRwgdMlqVYK1lN3dvSexPWCWdGu/2SDLZl4ebQzDdTA56rOTRdDQv4aoPV
         eEpzncXktcQtsNHSVhQilN9qHzQdFAAO8UJsqiGScXLFGGhkQ2+2NNXcLSVXzvLndf
         Sa43ZCoSH1YEHO+f1XzLT4nenT8mQm3lpbLV8BLnfQRmOcNGdlJZJQZQfgC4NgatxZ
         JBf+rkjM/TIRVMMx/78Ss3T4FxnFo787A8/O43QcAJn0HvgAmrXslS9HctZsJlgeFS
         abeFH8AbFhDHw==
Subject: Re: bpf: Implement minimal BPF perf link
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <342670fc-948a-a76e-5a47-b3d44e3e3926@canonical.com>
 <CAEf4BzYP6OU23D33d6dzgpYyXqSGrQUpenrJStyYFB3L7S93ew@mail.gmail.com>
From:   Colin Ian King <colin.king@canonical.com>
Message-ID: <6609e46f-96f2-8a9d-4422-b9af3e64c024@canonical.com>
Date:   Tue, 17 Aug 2021 21:34:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzYP6OU23D33d6dzgpYyXqSGrQUpenrJStyYFB3L7S93ew@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/08/2021 19:57, Andrii Nakryiko wrote:
> On Tue, Aug 17, 2021 at 10:36 AM Colin Ian King
> <colin.king@canonical.com> wrote:
>>
>> Hi,
>>
>> Static analysis with Coverity on linux-next has detected a potential
>> issue with the following commit:
>>
>> commit b89fbfbb854c9afc3047e8273cc3a694650b802e
>> Author: Andrii Nakryiko <andrii@kernel.org>
>> Date:   Sun Aug 15 00:05:57 2021 -0700
>>
>>     bpf: Implement minimal BPF perf link
>>
>> The analysis is as follows:
>>
>> 2936 static int bpf_perf_link_attach(const union bpf_attr *attr, struct
>> bpf_prog *prog)
>> 2937 {
>>
>>     1. var_decl: Declaring variable link_primer without initializer.
>>
>> 2938        struct bpf_link_primer link_primer;
>> 2939        struct bpf_perf_link *link;
>> 2940        struct perf_event *event;
>> 2941        struct file *perf_file;
>> 2942        int err;
>> 2943
>>
>>     2. Condition attr->link_create.flags, taking false branch.
>>
>> 2944        if (attr->link_create.flags)
>> 2945                return -EINVAL;
>> 2946
>> 2947        perf_file = perf_event_get(attr->link_create.target_fd);
>>
>>     3. Condition IS_ERR(perf_file), taking false branch.
>>
>> 2948        if (IS_ERR(perf_file))
>> 2949                return PTR_ERR(perf_file);
>> 2950
>> 2951        link = kzalloc(sizeof(*link), GFP_USER);
>>
>>     4. Condition !link, taking false branch.
>>
>> 2952        if (!link) {
>> 2953                err = -ENOMEM;
>> 2954                goto out_put_file;
>> 2955        }
>> 2956        bpf_link_init(&link->link, BPF_LINK_TYPE_PERF_EVENT,
>> &bpf_perf_link_lops, prog);
>> 2957        link->perf_file = perf_file;
>> 2958
>> 2959        err = bpf_link_prime(&link->link, &link_primer);
>>
>>     5. Condition err, taking false branch.
>>
>> 2960        if (err) {
>> 2961                kfree(link);
>> 2962                goto out_put_file;
>> 2963        }
>> 2964
>> 2965        event = perf_file->private_data;
>> 2966        err = perf_event_set_bpf_prog(event, prog,
>> attr->link_create.perf_event.bpf_cookie);
>>
>>     6. Condition err, taking true branch.
>> 2967        if (err) {
>>     7. uninit_use_in_call: Using uninitialized value link_primer.fd when
>> calling bpf_link_cleanup.
>>     8. uninit_use_in_call: Using uninitialized value link_primer.file
>> when calling bpf_link_cleanup.
>>     9. uninit_use_in_call: Using uninitialized value link_primer.id when
>> calling bpf_link_cleanup.
>>
>>    Uninitialized pointer read (UNINIT)
>>    10. uninit_use_in_call: Using uninitialized value link_primer.link
>> when calling bpf_link_cleanup.
>>
>> 2968                bpf_link_cleanup(&link_primer);
>> 2969                goto out_put_file;
>> 2970        }
>> 2971        /* perf_event_set_bpf_prog() doesn't take its own refcnt on
>> prog */
>> 2972        bpf_prog_inc(prog);
>>
>> I'm not 100% sure if these are false-positives, but I thought I should
>> report the issues as potentially there is a pointer access on an
>> uninitialized pointer on line 2968.
> 
> Look at bpf_link_prime() implementation. If it succeeds, link_primer
> is fully initialized. We use this pattern in many places, this is the
> first time someone reports any potential issues with it. It's a bit
> strange that Coverity doesn't recognize such a typical output
> parameter initialization pattern, tbh. Maybe the global nature of
> bpf_link_prime() throws it off (it assumes it can be "overridden"
> during linking?) But I double-checked everything twice, all seems to
> be good. Zero-initializing link_primer would be a total waste.

Yes, in pedantic mode it can throw false positives, it's not perfect.
Thanks for double checking, and apologies for wasting your valuable time.

Colin

> 
>>
>> Colin

