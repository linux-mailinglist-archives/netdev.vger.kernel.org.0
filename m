Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984673D43E3
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 02:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbhGWXck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 19:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233425AbhGWXci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 19:32:38 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5FFC061757
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 17:12:35 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id a19so3670205oiw.6
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 17:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/wyLkNvkidaBXNnl6BHcKGKv9sGPdv0n/Uh52dZHFAs=;
        b=ARQVxALlaQ68hdjEtCubn5VankE47YvEbSEpgGW0ASyttJl4Wtlpoz0Jy6+JpuaeNb
         Wm4gmKU2IQkdkqN+cV6uSC9c7/P5K0dGeoTAP3T34hWrai6CkEyKxSDwt/sbqyASb/i7
         4D1+TPeAl/1s5uoK5a66rryRCyJqbDz60O4QwObv32pd+5vbk3HI635ZWfAJMcT7+Pht
         9XQwQmYpNiNTw/Ar5Sb/KuEknizVBJBd5ZKPBUBKm8MgLIsQ6NXrrJS+YyV8me7khawE
         lCpUsq13xRxFGk1/LycJ7b4q7IeTR+/voSwrTHE52ROHNZaERPFZ0W5aOw+0Db0v/C3c
         jHxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/wyLkNvkidaBXNnl6BHcKGKv9sGPdv0n/Uh52dZHFAs=;
        b=VouDV5Kq3jd6UaxAcRRflvwIiCs3ikwGzfZGF+zLAxT3wf4z39I6WxAzmpMi9v+ibV
         C2TezSVsbMdkDUeIuXeZfdoGgXzNksEy5U9Y2Sbx6nCQ8WkClDw4hxZod3yD6OCAvn2Y
         G+Zi7kIQRw5j78iHveSfuT5reIlXEjAWjMLFbah8MxJnUxP6moR3xp3sFhsek2e8Eizb
         NBX3nMrgM2c7P7cMO413Be6lTTFzh6Ed9pm/f7CV+QoWXenSTFy1xYG0w+hNZlVTZqKA
         eah293V2SWKT+sR3nl32qb5BNozt8LQ1mVXh2YdojW1eeNTF0hOsoOaX3SXrRDRnYuHw
         9jJw==
X-Gm-Message-State: AOAM5329kG4i54r7sdJnFOcwLI0NXTrr9Eq+kA5TSY9VbmCG9OBYxQBf
        7mvg+RX+gOV3Ta73FVm++qY=
X-Google-Smtp-Source: ABdhPJzmRu3eBYixB2Tddg33z2b4iZYfnQG864YtV/AuUaoBOuHg4FuEC8k5p/Gv3+a4gnE6hnes7g==
X-Received: by 2002:aca:3904:: with SMTP id g4mr9982384oia.129.1627085554511;
        Fri, 23 Jul 2021 17:12:34 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.27])
        by smtp.googlemail.com with ESMTPSA id k129sm437974oif.21.2021.07.23.17.12.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jul 2021 17:12:33 -0700 (PDT)
Subject: Re: [PATCH iproute2] libbpf: fix attach of prog with multiple
 sections
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Hangbin Liu <haliu@redhat.com>
Cc:     Martynas Pumputis <m@lambda.lt>,
        Networking <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
References: <20210705124307.201303-1-m@lambda.lt>
 <CAEf4Bzb_FAOMK+8J+wyvbR2etYFDU1ae=P3pwW3fzfcWctZ1Xw@mail.gmail.com>
 <df3396c3-9a4a-824d-648f-69f4da5bc78b@lambda.lt> <YPpIeppWpqFCSaqZ@Laptop-X1>
 <CAEf4Bzavevcn=p7iBSH6iXMOCXp5kCu71a1kZ7PSawW=LW5NSQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0cc404df-078a-686e-c5ce-8473c0e220f5@gmail.com>
Date:   Fri, 23 Jul 2021 18:12:32 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CAEf4Bzavevcn=p7iBSH6iXMOCXp5kCu71a1kZ7PSawW=LW5NSQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/22/21 10:51 PM, Andrii Nakryiko wrote:
> On Thu, Jul 22, 2021 at 9:41 PM Hangbin Liu <haliu@redhat.com> wrote:
>>
>> On Wed, Jul 21, 2021 at 04:47:14PM +0200, Martynas Pumputis wrote:
>>>>> diff --git a/lib/bpf_libbpf.c b/lib/bpf_libbpf.c
>>>>> index d05737a4..f76b90d2 100644
>>>>> --- a/lib/bpf_libbpf.c
>>>>> +++ b/lib/bpf_libbpf.c
>>>>> @@ -267,10 +267,12 @@ static int load_bpf_object(struct bpf_cfg_in *cfg)
>>>>>          }
>>>>>
>>>>>          bpf_object__for_each_program(p, obj) {
>>>>> +               bool prog_to_attach = !prog && cfg->section &&
>>>>> +                       !strcmp(get_bpf_program__section_name(p), cfg->section);
>>>>
>>>> This is still problematic, because one section can have multiple BPF
>>>> programs. I.e., it's possible two define two or more XDP BPF programs
>>>> all with SEC("xdp") and libbpf works just fine with that. I suggest
>>>> moving users to specify the program name (i.e., C function name
>>>> representing the BPF program). All the xdp_mycustom_suffix namings are
>>>> a hack and will be rejected by libbpf 1.0, so it would be great to get
>>>> a head start on fixing this early on.
>>>
>>> Thanks for bringing this up. Currently, there is no way to specify a
>>> function name with "tc exec bpf" (only a section name via the "sec" arg). So
>>> probably, we should just add another arg to specify the function name.
>>
>> How about add a "prog" arg to load specified program name and mark
>> "sec" as not recommended? To keep backwards compatibility we just load the
>> first program in the section.
> 
> Why not error out if there is more than one program with the same
> section name? if there is just one (and thus section name is still
> unique) -- then proceed. It seems much less confusing, IMO.
> 

Let' see if I understand this correctly: libbpf 1.0 is not going to
allow SEC("xdp_foo") or SEC("xdp_bar") kind of section names - which is
the hint for libbpf to know program type. Instead only SEC("xdp") is
allowed.

Further, a single object file is not going to be allowed to have
multiple SEC("xdp") instances for each program name.

Correct? If so, it seems like this is limiting each object file to a
single XDP program or a single object file can have 1 XDP program and 1
tc program.
