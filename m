Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC973D11C3
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 16:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239417AbhGUOSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 10:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239346AbhGUOSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 10:18:44 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8827DC061575
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 07:59:21 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id u15so3163097oiw.3
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 07:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zxNc/baW6zSUqgeLfKWctAOQp+tEgiw50aFNatFeytM=;
        b=qpuE22V/p8lB2ymuozwviDnj5N48FBVbUDGlqWRodnR9FCkfDwzWiC+h2OP3I4JlEZ
         cuZJB33ZXYqQ3Q4T3TTFLHxkE9P2+WegkaPYM0qlBmTw7o0mDkQ7RWy38cFwDlFIbvvM
         K4TKUWEZVFrDsCJZJoZiJfWjY3A+Q/MX4AxoLOJ9fb0S18m4MXCM2KZAu9xEdcHE3aOZ
         zXklf/oITsq6l/NZQ3+VcKZwI5s7GZD4fVOwK1+Esk+8y23PlUIPKHbgBGGhBPCqxa+T
         /O5wQAtekYtAV+W9K8MukwIvyhklHLWNhQA6gW8afnwzcdqQYHC0zSTU/UQeAWSvVxFc
         pKpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zxNc/baW6zSUqgeLfKWctAOQp+tEgiw50aFNatFeytM=;
        b=myOzhgog4wkY1BfA0Cy06tQX5FnD1Q5Qw50UtQpIXW2IVpR5K8zF+mtKc8m6ExRYCc
         phZTGaD+wH5dmyl3zyhL6c63vnXDrbybCX/bzX8DNvdZgJBd1DZkrFn3607EDc2B2VSM
         zRbTkmCJKTqsJt8AWyJ95BGCFS0ddJNLF8I7Ji6Yfjwy2EGltT16XpWW8x1hwA+YSrIE
         letwlQANQ24EhbZSax3HYJOrJmineYuTO11ZBGo3eAb682qj+gvjOv0JFUlsLDEcW1MY
         95efL0FntMeiVTKkuK2m/ATbVks7J/AvhUYbGj20pgbLtn8LaqcQplbwal1MeOVfw6IZ
         h2pg==
X-Gm-Message-State: AOAM532PI9bhE8ztDjb7GKO1rXoJelXzVgYSoncwEojgzzn7L03SgVVX
        1PehFDDrupV9YwP88rsaWV4=
X-Google-Smtp-Source: ABdhPJxOH0gMbpzoCGNU6ClCZHZs3fTlqLCuGz2Zzg3uconbZ3wb+bOtH86oH2ezK1+RepEz+aQjlg==
X-Received: by 2002:a05:6808:1313:: with SMTP id y19mr25070569oiv.37.1626879560950;
        Wed, 21 Jul 2021 07:59:20 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id c16sm1758669otd.18.2021.07.21.07.59.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jul 2021 07:59:20 -0700 (PDT)
Subject: Re: [PATCH iproute2] libbpf: fix attach of prog with multiple
 sections
To:     Martynas Pumputis <m@lambda.lt>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>
References: <20210705124307.201303-1-m@lambda.lt>
 <CAEf4Bzb_FAOMK+8J+wyvbR2etYFDU1ae=P3pwW3fzfcWctZ1Xw@mail.gmail.com>
 <df3396c3-9a4a-824d-648f-69f4da5bc78b@lambda.lt>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4f1b5aaa-80e0-5dcc-277e-c098811cc359@gmail.com>
Date:   Wed, 21 Jul 2021 08:59:19 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <df3396c3-9a4a-824d-648f-69f4da5bc78b@lambda.lt>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/21/21 8:47 AM, Martynas Pumputis wrote:
>>> diff --git a/lib/bpf_libbpf.c b/lib/bpf_libbpf.c
>>> index d05737a4..f76b90d2 100644
>>> --- a/lib/bpf_libbpf.c
>>> +++ b/lib/bpf_libbpf.c
>>> @@ -267,10 +267,12 @@ static int load_bpf_object(struct bpf_cfg_in *cfg)
>>>          }
>>>
>>>          bpf_object__for_each_program(p, obj) {
>>> +               bool prog_to_attach = !prog && cfg->section &&
>>> +                       !strcmp(get_bpf_program__section_name(p),
>>> cfg->section);
>>
>> This is still problematic, because one section can have multiple BPF
>> programs. I.e., it's possible two define two or more XDP BPF programs
>> all with SEC("xdp") and libbpf works just fine with that. I suggest
>> moving users to specify the program name (i.e., C function name
>> representing the BPF program). All the xdp_mycustom_suffix namings are
>> a hack and will be rejected by libbpf 1.0, so it would be great to get
>> a head start on fixing this early on.
> 
> Thanks for bringing this up. Currently, there is no way to specify a
> function name with "tc exec bpf" (only a section name via the "sec"
> arg). So probably, we should just add another arg to specify the
> function name.
> 
> It would be interesting to hear thoughts from iproute2 maintainers
> before fixing this.

maintaining backwards compatibility is a core principle for iproute2. If
we know of a libbpf change is going to cause a breakage then it is best
to fix it before any iproute2 release is affected.
