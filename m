Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3193B2326AD
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 23:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgG2VRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 17:17:12 -0400
Received: from www62.your-server.de ([213.133.104.62]:37296 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbgG2VRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 17:17:12 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k0tRm-0005V4-77; Wed, 29 Jul 2020 23:17:10 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k0tRm-0007WS-0D; Wed, 29 Jul 2020 23:17:10 +0200
Subject: Re: [PATCH v4 bpf 2/2] selftests/bpf: extend map-in-map selftest to
 detect memory leaks
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>,
        linux- stable <stable@vger.kernel.org>
References: <20200729040913.2815687-1-andriin@fb.com>
 <20200729040913.2815687-2-andriin@fb.com> <87k0ymwg2b.fsf@cloudflare.com>
 <CAEf4BzYagTebczsojJJfn0viy07dhRUq3oysezEO_LSYSuwfRQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <e0741aae-64fd-dd2c-d91d-d8eb0b79ba20@iogearbox.net>
Date:   Wed, 29 Jul 2020 23:17:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzYagTebczsojJJfn0viy07dhRUq3oysezEO_LSYSuwfRQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25888/Wed Jul 29 16:57:45 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/29/20 7:48 PM, Andrii Nakryiko wrote:
> On Wed, Jul 29, 2020 at 7:29 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>
>> On Wed, Jul 29, 2020 at 06:09 AM CEST, Andrii Nakryiko wrote:
>>> Add test validating that all inner maps are released properly after skeleton
>>> is destroyed. To ensure determinism, trigger kernel-side synchronize_rcu()
>>> before checking map existence by their IDs.
>>>
>>> Acked-by: Song Liu <songliubraving@fb.com>
>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
[...]
>>> +/*
>>> + * Trigger synchronize_cpu() in kernel.
>>
>> Nit: synchronize_*r*cu().
> 
> welp, yeah
> 
>>
>>> + *
>>> + * ARRAY_OF_MAPS/HASH_OF_MAPS lookup/update operations trigger
>>> + * synchronize_rcu(), if looking up/updating non-NULL element. Use this fact
>>> + * to trigger synchronize_cpu(): create map-in-map, create a trivial ARRAY
>>> + * map, update map-in-map with ARRAY inner map. Then cleanup. At the end, at
>>> + * least one synchronize_rcu() would be called.
>>> + */
>>
>> That's a cool trick. I'm a bit confused by "looking up/updating non-NULL
>> element". It looks like you're updating an element that is NULL/unset in
>> the code below. What am I missing?
> 
> I was basically trying to say that it has to be a successful lookup or
> update. For lookup that means looking up non-NULL (existing) entry.
> For update -- setting valid inner map FD.
> 
> Not sure fixing this and typo above is worth it to post v5.

Nope, I'll fix it up while applying.
