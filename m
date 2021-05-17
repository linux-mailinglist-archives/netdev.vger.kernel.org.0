Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 510C13839CC
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 18:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343577AbhEQQ3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 12:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245164AbhEQQ3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 12:29:00 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F43FC08EAE8;
        Mon, 17 May 2021 08:10:11 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id t4so3305728plc.6;
        Mon, 17 May 2021 08:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=chSInzVZxBkEohiqw1SSneAq3KAzecc9iWecdDSIEps=;
        b=VGGER6JsFStjVyWTnshPBgAuAJjHuNWUX/Hz1O7f+PfPU8XV/SouDJW7etR8Uol357
         kmnIeerL2eABoTYqwUcpLymGda6wjOTfL7h/27yKTauBT2onRFlJl79u2nbm80aDgSU2
         0ti5XZrWLNLpW7qvkcjlxjqL1xwU9teHhn0f0QIbk0ZiNxviiIZsW0idt8LqX/Qq6QWa
         ZAGjSXBCmhN55RsXQ7OzkEUdCxsY181ciSge1KaNttuKeTisW4mANDEzmnlCl3Gro5Wf
         fzbx3I5ebVNsasqngkJU4F0AE+As5cGRZJRu6H9jKmGEvSaJBGvoF1Ofb/zvG/GommpR
         Z59Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=chSInzVZxBkEohiqw1SSneAq3KAzecc9iWecdDSIEps=;
        b=hnVuIEbtOfHFhDz3YHTw9Qx7Pc9hU1V+i58McN7qiXXBbYAD0nSyBeWIltdyRewpEO
         nGfdm9VRfboIsV3mWEpSALK7v98pEM14lA5mW/nCrnKjvThydy/nDu7z/aE5SDF70gaQ
         N1Fny/2xoQktGB7tkOj3SPG5e2PHnBMnngGwDn9pRsxkxS5pCyYxJosk3jwyeF82L9/H
         lpwAOz4OY+q2SVrTtFVhfyj9d/cqJM2P2rTBZAfWZFGatFGBVxQTVSP9yCmyUp99q+3u
         prCDFzkCi3g2RgE/dm+O7JRstd6qycr2Ww4Ya7G9oKgVy7+27m5uJQZTZRDrd0961QPo
         HG0w==
X-Gm-Message-State: AOAM531j3XrGKkBb9IXOt7yqVOmbpXT+JRmtOQANFk6q4O8wwsUrc9uI
        fgJc+CONee/Cjs27PDHtR2Zxyao5ZZuWXOe8
X-Google-Smtp-Source: ABdhPJzWj8Pj1VUZhjA/v60Rr8+P7a/bSwobTKIblHiZc9umGQHLN0J3fHj0IXKRF+sMRTGJD3J0LQ==
X-Received: by 2002:a17:90b:1b4f:: with SMTP id nv15mr424297pjb.56.1621264210688;
        Mon, 17 May 2021 08:10:10 -0700 (PDT)
Received: from [192.168.0.111] ([113.172.200.89])
        by smtp.gmail.com with ESMTPSA id j27sm11328508pgb.54.2021.05.17.08.10.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 08:10:10 -0700 (PDT)
Subject: Re: [PATCH] bpf: Fix integer overflow in argument calculation for
 bpf_map_area_alloc
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, hawk@kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        kpsingh@kernel.org, Jakub Sitnicki <jakub@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20210126082606.3183-1-minhquangbui99@gmail.com>
 <CACAyw99bEYWJCSGqfLiJ9Jp5YE1ZsZSiJxb4RFUTwbofipf0dA@mail.gmail.com>
 <20210127042341.GA4948@ubuntu>
 <f4d20d92-2370-a8d3-d56c-408819a5f7f4@iogearbox.net>
From:   Bui Quang Minh <minhquangbui99@gmail.com>
Message-ID: <728b238e-a481-eb50-98e9-b0f430ab01e7@gmail.com>
Date:   Mon, 17 May 2021 22:10:03 +0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <f4d20d92-2370-a8d3-d56c-408819a5f7f4@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/21 7:41 AM, Daniel Borkmann wrote:
> On 1/27/21 5:23 AM, Bui Quang Minh wrote:
>> On Tue, Jan 26, 2021 at 09:36:57AM +0000, Lorenz Bauer wrote:
>>> On Tue, 26 Jan 2021 at 08:26, Bui Quang Minh 
>>> <minhquangbui99@gmail.com> wrote:
>>>>
>>>> In 32-bit architecture, the result of sizeof() is a 32-bit integer so
>>>> the expression becomes the multiplication between 2 32-bit integer 
>>>> which
>>>> can potentially leads to integer overflow. As a result,
>>>> bpf_map_area_alloc() allocates less memory than needed.
>>>>
>>>> Fix this by casting 1 operand to u64.
>>>
>>> Some quick thoughts:
>>> * Should this have a Fixes tag?
>>
>> Ok, I will add Fixes tag in later version patch.
>>
>>> * Seems like there are quite a few similar calls scattered around
>>> (cpumap, etc.). Did you audit these as well?
>>
> [...]
>> In cpumap,
>>
>>     static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
>>     {
>>         cmap->cpu_map = bpf_map_area_alloc(cmap->map.max_entries *
>>                            sizeof(struct bpf_cpu_map_entry *),
>>                            cmap->map.numa_node);
>>     }
>>
>> I think this is safe because max_entries is not permitted to be larger 
>> than NR_CPUS.
> 
> Yes.
> 
>> In stackmap, there is a place that I'm not very sure about
>>
>>     static int prealloc_elems_and_freelist(struct bpf_stack_map *smap)
>>     {
>>         u32 elem_size = sizeof(struct stack_map_bucket) + 
>> smap->map.value_size;
>>         smap->elems = bpf_map_area_alloc(elem_size * 
>> smap->map.max_entries,
>>                          smap->map.numa_node);
>>     }
>>
>> This is called after another bpf_map_area_alloc in stack_map_alloc(). 
>> In the first
>> bpf_map_area_alloc() the argument is calculated in an u64 variable; so 
>> if in the second
>> one, there is an integer overflow then the first one must be called 
>> with size > 4GB. I
>> think the first one will probably fail (I am not sure about the actual 
>> limit of vmalloc()),
>> so the second one might not be called.
> 
> I would sanity check this as well. Looks like k*alloc()/v*alloc() call 
> sites typically
> use array_size() which returns SIZE_MAX on overflow, 610b15c50e86 
> ("overflow.h: Add
> allocation size calculation helpers").

Hi,

I almost forget about this patch, I have checked the bpf_map_area_alloc 
in in stackmap.c and I can see that integer overflow cannot happen in 
this stackmap.c case.

In stack_map_alloc(),

	u64 cost;
	...
	cost = n_buckets * sizeof(struct stack_map_bucket *) + sizeof(*smap);
	cost += n_buckets * (value_size + sizeof(struct stack_map_bucket));
	smap = bpf_map_area_alloc(cost, bpf_map_attr_numa_node(attr)); (1)
	...
	prealloc_elems_and_freelist(smap);

In prealloc_elems_and_freelist(),

	u32 elem_size = sizeof(struct stack_map_bucket) + smap->map.value_size;
	smap->elems = bpf_map_area_alloc(elem_size * smap->map.max_entries, 
smap->map.numa_node); (2)

Argument calculation at (1) is safe. Argument calculation at (2) can 
potentially result in an integer overflow in 32-bit architecture. 
However, if the integer overflow happens, it means argument at (1) must 
be 2**32, which cannot pass the SIZE_MAX check in __bpf_map_area_alloc()

In __bpf_map_area_alloc()

	if (size >= SIZE_MAX)
		return NULL;

So I think the original patch has fixed instances of this bug pattern.

Thank you,
Quang Minh.
